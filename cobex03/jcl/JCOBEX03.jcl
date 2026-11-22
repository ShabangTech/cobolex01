//USER25R  JOB MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*--------------------------------------------------
//* RUN COBEX03 - ARITHMETIC OPERATIONS
//*--------------------------------------------------
//RUN      EXEC PGM=COBEX03
//STEPLIB  DD DSN=USER25.DEV.LOAD,DISP=SHR
//SYSOUT   DD SYSOUT=*
