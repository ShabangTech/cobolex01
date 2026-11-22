//USER25R  JOB MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*--------------------------------------------------
//*  RUN COBEX05 - PERFORM UNTIL, MULTIPLICATION TABLE
//*--------------------------------------------------
//RUN      EXEC PGM=COBEX05
//STEPLIB  DD DSN=USER25.DEV.LOAD,DISP=SHR
//SYSOUT   DD SYSOUT=*
