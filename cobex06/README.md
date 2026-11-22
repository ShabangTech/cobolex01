# COBEX06 — Sequential (PS) File: 5% Salary Increase

Exercise from *Chapter 1 – Files and Libraries, Lesson 13*, run on IBM z/OS with IBM Enterprise COBOL 6.4.

**Skills shown:** allocating a PS dataset in ISPF 3.2, entering fixed-length records in the editor, `SELECT … ASSIGN` / `FD` / `FILE STATUS`, a priming-read loop with an 88-level end-of-file flag, `COMPUTE … ROUNDED … ON SIZE ERROR`, and an execution JCL that is safe to rerun (IEFBR14 delete step + `LIKE=`).

## The exercise

1. Allocate `USER25.COBEX06.IN` with ISPF 3.2: sequential (PS), `FB`, LRECL 70, 1 track primary and secondary.
2. Write employee records: department (2), employee ID (5), name (20), monthly salary (5 digits), filler for the rest.
3. Write `COBEX06`, which gives every employee a 5% raise and writes `USER25.COBEX06.OUT` with the same characteristics as the input.
4. Write the execution JCL `JCOBEX06`.

## Workflow

```mermaid
flowchart LR
    A["ISPF 3.2<br/>allocate COBEX06.IN"] --> B["ISPF Edit<br/>type 3 records"]
    B --> C["COBEX06<br/>READ → ×1.05 → WRITE"]
    C --> D["COBCOMP<br/>compile + link"]
    D -->|MAXCC 0004| E["JCOBEX06"]
    E --> F["IEFBR14<br/>delete old .OUT"]
    F --> G["RUN COBEX06<br/>EMPIN → EMPOUT"]
    G --> H["COBEX06.OUT<br/>+ SYSOUT count"]
```

## Files

| File | Mainframe dataset | Purpose |
|---|---|---|
| [`cobol/COBEX06.cbl`](cobol/COBEX06.cbl) | `USER25.DEV.COBOL(COBEX06)` | COBOL source |
| [`jcl/COBCOMP.jcl`](jcl/COBCOMP.jcl) | `USER25.DEV.JCL(COBCOMP)` | Compile and link into `USER25.DEV.LOAD` |
| [`jcl/JCOBEX06.jcl`](jcl/JCOBEX06.jcl) | `USER25.DEV.JCL(JCOBEX06)` | Delete old output, run the program |
| [`data/COBEX06.IN.txt`](data/COBEX06.IN.txt) | `USER25.COBEX06.IN` | Input records |
| [`data/COBEX06.OUT.expected.txt`](data/COBEX06.OUT.expected.txt) | `USER25.COBEX06.OUT` | Expected output |

## Record layout (70 bytes)

| Field | Columns | PIC |
|---|---|---|
| Department | 1–2 | `X(02)` |
| Employee ID | 3–7 | `X(05)` |
| Name | 8–27 | `X(20)` |
| Monthly salary | 28–32 | `9(05)` (numeric, so it can be used in `COMPUTE`) |
| Filler | 33–70 | `X(38)` |

`RECORD CONTAINS 70 CHARACTERS` on both FDs makes the compiler check that the fields add up to 70.

## How the program works

| Paragraph | Job |
|---|---|
| `0000-MAIN` | `PERFORM` init, then process `UNTIL END-OF-FILE`, then finish |
| `1000-INIT` | Opens both files, stops with a clear message if a `FILE STATUS` isn't `00`, then does the **priming read** |
| `2000-PROCESS` | `MOVE IN-REC TO OUT-REC`, then overwrites the salary with `COMPUTE … ROUNDED = IN-SALARY * 1.05`; `ON SIZE ERROR` catches results over 5 digits; `WRITE`; count; read next |
| `2100-READ` | The only place a record is read; `AT END` sets the 88-level flag |
| `3000-FINISH` | Closes the files, displays the record count |

The link between program and JCL is the DD name: `SELECT EMP-IN ASSIGN TO EMPIN` ↔ `//EMPIN DD …`.

## The JCL

- **`DELOUT` (IEFBR14)** with `DISP=(MOD,DELETE,DELETE)` removes `COBEX06.OUT` if it exists, so the job can be rerun without a "duplicate data set" error.
- **`EMPOUT`** uses `DISP=(NEW,CATLG,DELETE)`: create it, catalog it if the step ends normally, delete it if the step abends.
- **`LIKE=USER25.COBEX06.IN`** copies the input's attributes (PS, FB, 70), which is exactly "same characteristics as the input file".

## Result

- Compile (`COBCOMP`): `MAXCC=0004`, warnings only.
- Run (`JCOBEX06`, job `JOB00920`): `MAXCC=0000`, with one SYSOUT line, the record count.

Expected output file (5% raise):

```
1012345SAMUEL DENIS        02100
1012346ETIENNE PATRICK     01575
2012347TEDDY SMITH         03360
```

## Troubleshooting log

| Symptom | Cause | Fix |
|---|---|---|
| Dataset created as `USER25.USER25.COBEX06.IN` | Name typed without quotes, so TSO added the user ID prefix | Renamed with 3.2 `R`, using `'USER25.COBEX06.IN'` with quotes |
| `Invalid value` on the 3.2 option line | Data set information is the **blank** option, not `I` | Leave the option blank |
| Comment lines highlighted as code | `*` in column 8–10 instead of column 7 | Moved `*` to column 7 (Delete key; Backspace only moves the cursor in a 3270 screen) |
| `Invalid on this line` | Shift line command not accepted | Used the Delete key instead |
| `ENVIORNMENT`, `EM-IN`, `PICX(02)`, `END-OF-FILR` | Typos | `ENVIRONMENT`, `EMP-IN`, `PIC X(02)`, `END-OF-FILE` |
| `STOP-RUN`, `OPEN-INPUT` | Hyphens in verb phrases | `STOP RUN`, `OPEN INPUT`; only names and `END-xxx` scope terminators take hyphens |
| `END COMPUTE`, `END READ` | Missing hyphen in scope terminators | `END-COMPUTE`, `END-READ` |
| `STOP RUN.` inside an `IF` | A period ends the IF early, leaving an orphan `END-IF` | No periods inside `IF` blocks |
| `Member in use` | Same member open in another stacked ISPF screen | F3 back to the open session |
| JCL: `DNS=`, `TRL`, `CALG` | Typos | `DSN=`, `TRK`, `CATLG` |
| Lines holding only `//` | The null statement, which means end of job | Deleted them (use `//*` for a visual gap) |
| `JCL ERROR`, JESJCL shows only the job card | `(ACCT),CLASS=A` job card not accepted on this system | Switched to the `MSGLEVEL=(1,1),NOTIFY=&SYSUID` card used by `COBCOMP` |
| `MSGCLASS=(1,1)` | Wrong parameter: MSGCLASS takes one letter | `MSGLEVEL=(1,1)` |
| DD statement ends early | Missing comma at the end of a continued DSN line | Trailing comma on every continued line |

## Screenshots

| | |
|---|---|
| ![3.2 invalid option](docs/images/01-3-2-invalid-option.png) | ![Double user ID](docs/images/02-dataset-info-double-userid.png) |
| ![Rename](docs/images/03-rename-panel.png) | ![Rename with quotes](docs/images/04-rename-with-quotes.png) |
| ![Edit entry](docs/images/05-edit-entry-panel.png) | ![Empty file](docs/images/06-empty-input-file.png) |
| ![Input records](docs/images/07-input-records-cols.png) | ![First line](docs/images/08-program-first-line.png) |
| ![Comments wrong column](docs/images/09-comments-in-wrong-column.png) | ![ENVIRONMENT typo fixed](docs/images/10-environment-typo-fixed.png) |
| ![Invalid on this line](docs/images/11-shift-invalid-on-line.png) | ![Comments in column 7](docs/images/12-comments-fixed-col7.png) |
| ![PICX](docs/images/13-data-division-picx.png) | ![Member in use](docs/images/14-member-in-use.png) |
| ![Data division](docs/images/15-data-division-progress.png) | ![Working-storage](docs/images/16-working-storage.png) |
| ![Hyphen typos](docs/images/17-procedure-hyphen-typos.png) | ![Program 1](docs/images/18-full-program-1.png) |
| ![Program 2](docs/images/19-full-program-2.png) | ![Program 3](docs/images/20-full-program-3.png) |
| ![Program 4](docs/images/21-full-program-4.png) | ![COBCOMP](docs/images/22-cobcomp-member-cobex06.png) |
| ![Edit entry JCOBEX06](docs/images/23-edit-entry-jcobex06.png) | ![JCL started](docs/images/24-jcl-started.png) |
| ![JCL typos](docs/images/25-jcl-with-typos.png) | ![JCL fixed](docs/images/26-jcl-typos-fixed.png) |
| ![JCL error](docs/images/27-jcl-error.png) | ![JESJCL](docs/images/28-jesjcl-stops-at-job-card.png) |
| ![MSGCLASS typo](docs/images/29-job-card-msgclass-typo.png) | ![MAXCC 0000](docs/images/30-maxcc-0000.png) |
| ![SYSOUT](docs/images/31-sdsf-sysout-1-record.png) | |
