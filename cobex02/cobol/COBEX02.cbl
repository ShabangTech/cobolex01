       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBEX02.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-FORMATTED-DATE.
           05 WS-DAY              PIC 99.
           05 FILLER              PIC X VALUE "/".
           05 WS-MONTH            PIC 99.
           05 FILLER              PIC X VALUE "/".
           05 WS-YEAR             PIC 9(4).
       PROCEDURE DIVISION.
       0000-MAIN.
           DISPLAY "ENTER DAY (DD): ".
           ACCEPT WS-DAY.

           DISPLAY "ENTER MONTH (MM): ".
           ACCEPT WS-MONTH.

           DISPLAY "ENTER YEAR (YYYY): ".
           ACCEPT WS-YEAR.

           DISPLAY "FORMATTED DATE " WS-FORMATTED-DATE.
           STOP RUN.
