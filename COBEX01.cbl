      *================================================================*
      * PROGRAM   : COBEX01                                            *
      * MEMBER    : USER25.DEV.COBOL(COBEX01)                          *
      * PURPOSE   : DISPLAY & MOVE EXERCISE                            *
      *             BUILD A FULL NAME FROM TWO FIELDS AND DISPLAY IT.  *
      * OUTPUT    : DUPONT DAVID  (IN SYSOUT OF STEP GO)               *
      *================================================================*
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
