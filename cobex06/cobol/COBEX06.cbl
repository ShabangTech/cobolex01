       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBEX06.
      *------------------------------------------------
      *COBEX06 - READ EMPLOYEES, ADD 5% TO SALARY
      *------------------------------------------------
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EMP-IN  ASSIGN TO EMPIN
                  FILE STATUS IS WS-FS-IN.
           SELECT EMP-OUT ASSIGN TO EMPOUT
                  FILE STATUS IS WS-FS-OUT.
       DATA DIVISION.
       FILE SECTION.
       FD  EMP-IN
           RECORDING MODE F
           RECORD CONTAINS 70 CHARACTERS.
       01  IN-REC.
           05  IN-DEPT        PIC X(02).
           05  IN-ID          PIC X(05).
           05  IN-NAME        PIC X(20).
           05  IN-SALARY      PIC 9(05).
           05  IN-FILLER      PIC X(38).
       FD  EMP-OUT
           RECORDING MODE F
           RECORD CONTAINS 70 CHARACTERS.
       01  OUT-REC.
           05  OUT-DEPT       PIC X(02).
           05  OUT-ID         PIC X(05).
           05  OUT-NAME       PIC X(20).
           05  OUT-SALARY     PIC 9(05).
           05  OUT-FILLER     PIC X(38).
       WORKING-STORAGE SECTION.
       01  WS-FS-IN           PIC XX.
       01  WS-FS-OUT          PIC XX.
       01  WS-EOF             PIC X VALUE 'N'.
           88  END-OF-FILE          VALUE 'Y'.
       01  WS-COUNT           PIC 9(05) VALUE ZERO.
       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM 1000-INIT
           PERFORM 2000-PROCESS UNTIL END-OF-FILE
           PERFORM 3000-FINISH
           STOP RUN.
       1000-INIT.
           OPEN INPUT EMP-IN
           IF WS-FS-IN NOT = '00'
              DISPLAY 'OPEN ERROR EMPIN, STATUS: ' WS-FS-IN
              STOP RUN
           END-IF
           OPEN OUTPUT EMP-OUT
           IF WS-FS-OUT NOT = '00'
              DISPLAY 'OPEN ERROR EMPOUT, STATUS: ' WS-FS-OUT
              STOP RUN
           END-IF
           PERFORM 2100-READ.
       2000-PROCESS.
           MOVE IN-REC TO OUT-REC
           COMPUTE OUT-SALARY ROUNDED = IN-SALARY * 1.05
              ON SIZE ERROR
                 DISPLAY 'SALARY TOO LARGE, EMP ID: ' IN-ID
           END-COMPUTE
           WRITE OUT-REC
           ADD 1 TO WS-COUNT
           PERFORM 2100-READ.
       2100-READ.
           READ EMP-IN
              AT END SET END-OF-FILE TO TRUE
           END-READ.
       3000-FINISH.
           CLOSE EMP-IN EMP-OUT
           DISPLAY 'COBEX06 RECORDS PROCESSED: ' WS-COUNT.
