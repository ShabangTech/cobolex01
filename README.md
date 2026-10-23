# COBOL on z/OS — Exercises

My COBOL exercises on an IBM z/OS mainframe: written in ISPF, compiled and run with JCL, and checked in SDSF. Each exercise keeps its program in `cobol/`, its job in `jcl/`, and a write-up with the output and a troubleshooting log.

| # | Exercise | Skills | Output |
|---|---|---|---|
| 01 | [COBEX01 – DISPLAY & MOVE](#cobex01--display--move-cobol-on-zos) | Group variable, `MOVE`, `DISPLAY`, compile-link-go JCL | `DUPONT DAVID` |
| 02 | [COBEX02 – Group variable (formatted date)](cobex02/README.md) | `FILLER` with `VALUE`, `ACCEPT` from SYSIN, one `DISPLAY` of a group | `23/10/2026` |

**Stack:** COBOL · JCL · ISPF · SDSF · JES2 · IBM Enterprise COBOL 6.4

---

## COBEX01 – DISPLAY & MOVE (COBOL on z/OS)

A first COBOL exercise on an IBM mainframe: declare a group variable, fill it with `MOVE`, print it with `DISPLAY`, then compile and run it with JCL.

**Output in SYSOUT:**

```
DUPONT DAVID
```

### Repository layout

| File | Mainframe location | What it is |
|---|---|---|
| [`cobol/COBEX01.cbl`](cobol/COBEX01.cbl) | `USER25.DEV.COBOL(COBEX01)` | The COBOL program |
| [`jcl/COBEX01.jcl`](jcl/COBEX01.jcl) | `USER25.DEV.JCL(COBEX01)` | Job that compiles, links and runs it |

### The exercise

1. In the `WORKING-STORAGE SECTION`, declare a group variable `FULL-NAME` made of two alphanumeric fields, `LAST-NAME` (6 characters) and `FIRST-NAME` (5 characters).
2. In the `PROCEDURE DIVISION`, move `"DUPONT"` to `LAST-NAME` and `"DAVID"` to `FIRST-NAME`.
3. Display `FULL-NAME`.
4. End the program with `STOP RUN`.
5. Compile and run it, and find the full name in SYSOUT.

### The program – `USER25.DEV.COBOL(COBEX01)`

```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBEX01.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 FULL-NAME.
          05 LAST-NAME   PIC X(6).
          05 FILLER      PIC X     VALUE SPACE.
          05 FIRST-NAME  PIC X(5).

       PROCEDURE DIVISION.
           MOVE 'DUPONT' TO LAST-NAME.
           MOVE 'DAVID'  TO FIRST-NAME.
           DISPLAY FULL-NAME.
           STOP RUN.
```

| Line | Meaning |
|---|---|
| `01 FULL-NAME.` | Group item. No `PIC`: its size is the sum of its children (6 + 1 + 5 = 12). |
| `05 LAST-NAME PIC X(6).` | Alphanumeric (`X`), 6 characters – fits `DUPONT` exactly. |
| `05 FILLER PIC X VALUE SPACE.` | Unnamed 1-character field holding a blank, so the names are separated. |
| `05 FIRST-NAME PIC X(5).` | Alphanumeric, 5 characters – fits `DAVID` exactly. |
| `MOVE 'DUPONT' TO LAST-NAME.` | Copies a literal into a field. |
| `DISPLAY FULL-NAME.` | Prints the whole group (all 12 characters) to SYSOUT. |
| `STOP RUN.` | Ends the program. |

> **Without the `FILLER` line** the group is only 11 characters and the output is `DUPONTDAVID`, because the two fields sit side by side in memory. That is the strict answer to the exercise (exactly two elementary fields); the `FILLER` is an optional improvement for readability.

#### Column rules (fixed format)

| Columns | Use |
|---|---|
| 1–6 | Sequence numbers (ISPF fills these) |
| 7 | Indicator: `*` = comment line |
| 8–11 | **Area A** – divisions, sections, `01` levels, paragraph names |
| 12–72 | **Area B** – `05` levels and statements (`MOVE`, `DISPLAY`, …) |
| 73–80 | Ignored |

### The JCL – `USER25.DEV.JCL(COBEX01)`

```jcl
//USER25C  JOB (ACCT),'COBEX01',CLASS=A,MSGCLASS=X,
//             NOTIFY=&SYSUID
//         JCLLIB ORDER=(IGY.V6R4M0.SIGYPROC)
//STEP1    EXEC IGYWCLG
//COBOL.SYSIN DD DSN=USER25.DEV.COBOL(COBEX01),DISP=SHR
//GO.SYSOUT   DD SYSOUT=*
```

| Line | Meaning |
|---|---|
| `JOB … ,` | Job card. The trailing comma means "continued on the next line". |
| `NOTIFY=&SYSUID` | Sends you a message when the job ends. Must start in column 16 or earlier. |
| `JCLLIB ORDER=(…)` | Tells JES where to find the `IGYWCLG` procedure on this system. |
| `EXEC IGYWCLG` | IBM procedure: **C**ompile, **L**ink, **G**o (run) in one job. |
| `COBOL.SYSIN DD` | The source code fed to the compile step. |
| `GO.SYSOUT DD` | Where `DISPLAY` output goes when the program runs. |

### Step by step in ISPF

#### 1. Write the program

1. `=2` (Edit), open `USER25.DEV.COBOL(COBEX01)` (Project `USER25`, Group `DEV`, Type `COBOL`, Member `COBEX01`).
2. Type the program above, respecting Area A / Area B.
3. Type `SAVE` on the Command line.

#### 2. Write the JCL

1. `=2`, open `USER25.DEV.JCL(COBEX01)`.
2. Type the JCL above.
3. `SAVE`.

#### 3. Submit

1. With the JCL open, type `SUB` on the Command line and press Enter.
2. You get `JOB USER25C(JOBnnnnn) SUBMITTED`.
3. Press Enter until the NOTIFY message appears. You want `MAXCC=0000`.

#### 4. Check the output

1. `=SD`, then `ST`.
2. Put `?` next to your job and press Enter.
3. Put `S` next to the **SYSOUT** line (ProcStep `GO`) and press Enter.
4. You see `DUPONT DAVID` (or `DUPONTDAVID` without the `FILLER`).

#### Useful ISPF line commands

Typed over the line number on the left, then Enter:

| Command | Action |
|---|---|
| `I` / `I3` | Insert 1 / 3 blank lines below |
| `D` | Delete the line |
| `R` | Repeat (duplicate) the line |

Command-line commands: `SAVE`, `SUB`, `CAN` (leave without saving), `RESET` (clear messages), `RECOVERY ON` (enable UNDO).

### Troubleshooting log

Errors hit while doing this exercise, and the fixes:

| Symptom | Cause | Fix |
|---|---|---|
| `01 FULL NAME.` would not compile | Missing hyphen | `01 FULL-NAME.` |
| `PICX X(6)` | Typo | `PIC X(6)` |
| Line shows `''''''` instead of a number | Inserted line not processed yet | Press Enter |
| `ENTER JOBNAME CHARACTER(S)` prompt on `SUB` | Job name equals the user ID (`USER25`) | Add a character: `//USER25C` |
| JCL typos: `DNS=`, `DISO=SHR`, `NOTIFY==` | Typing errors | `DSN=`, `DISP=SHR`, `NOTIFY=` |
| `IEFC612I PROCEDURE IGYWCLG WAS NOT FOUND` | Proc not in the default proc library | Find it with `=3.4` → `IGY*`, add `JCLLIB ORDER=(IGY.V6R4M0.SIGYPROC)` |
| `IKJ56228I DATA SET IGY.V6R4MO.SIGYPROC NOT IN CATALOG` | Letter **O** typed instead of zero | `V6R4M0` ends in the digit **0** |
| Edited the wrong member (`RUNEX01`) | Old copy with old typos | `CAN`, then open the correct member |

### Result

- Job `USER25C` ended **`MAXCC=0000`** (compile, link and run all succeeded).
- SYSOUT of step `GO`: **`DUPONT DAVID`**.
