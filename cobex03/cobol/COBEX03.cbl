       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBEX03.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 A                PIC 99 VALUE 25.
       01 B                PIC 99 VALUE 5.
       01 C                PIC 99 VALUE 10.
       01 WS-ADD           PIC ZZ9.
       01 WS-SUB           PIC -ZZ9.
       01 WS-MUL           PIC ZZZ9.
       01 WS-DIV           PIC Z9.99.
       01 WS-MOY           PIC ZZ9.99.

       PROCEDURE DIVISION.
           PERFORM CALCULATED-OPERATIONS.
           STOP RUN.

       CALCULATED-OPERATIONS.
           ADD A B GIVING WS-ADD.
           DISPLAY "SUM OF A AND B: " WS-ADD.

           SUBTRACT B FROM A GIVING WS-SUB.
           DISPLAY "DIFFERENCE (A - B): " WS-SUB.

           MULTIPLY A BY B GIVING WS-MUL.
           DISPLAY "PRODUCT OF A BY B: " WS-MUL.

           DIVIDE A BY B GIVING WS-DIV ROUNDED
              ON SIZE ERROR DISPLAY "DIVISION BY ZERO"
           END-DIVIDE.
           DISPLAY "QUOTIENT OF A BY B: " WS-DIV.

           COMPUTE WS-MOY ROUNDED = (A + B + C) / 3.
           DISPLAY "AVERAGE OF A, B, AND C: " WS-MOY.
