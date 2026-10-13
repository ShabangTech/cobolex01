//USER25C  JOB (ACCT),'COBEX01',CLASS=A,MSGCLASS=X,
//             NOTIFY=&SYSUID
//*--------------------------------------------------------------*
//* MEMBER  : USER25.DEV.JCL(COBEX01)                            *
//* PURPOSE : COMPILE, LINK AND RUN COBEX01 (IGYWCLG PROCEDURE)  *
//* NOTE    : JCLLIB POINTS TO THE IBM COBOL PROC LIBRARY.       *
//*           V6R4M0 ENDS IN ZERO (0), NOT THE LETTER O.         *
//*--------------------------------------------------------------*
//         JCLLIB ORDER=(IGY.V6R4M0.SIGYPROC)
//STEP1    EXEC IGYWCLG
//COBOL.SYSIN DD DSN=USER25.DEV.COBOL(COBEX01),DISP=SHR
//GO.SYSOUT   DD SYSOUT=*
