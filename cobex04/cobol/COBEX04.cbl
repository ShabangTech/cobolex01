       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBEX04.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-AGE           PIC 999.
          88 IS-ADULT      VALUE 18 THRU 999.

       PROCEDURE DIVISION.
           MOVE 25 TO WS-AGE.

           IF IS-ADULT
              DISPLAY "ACCESS AUTHORIZED"
           END-IF.

           EVALUATE WS-AGE
              WHEN 0 THRU 12
                 DISPLAY "CHILD"
              WHEN 13 THRU 17
                 DISPLAY "TEEN"
              WHEN OTHER
                 DISPLAY "ADULT"
           END-EVALUATE.

           STOP RUN.
