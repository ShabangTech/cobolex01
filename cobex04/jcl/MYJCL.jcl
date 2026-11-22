//USER25R  JOB MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*--------------------------------------------------
//*  RUN COBEX04 - IF,EVALUATE AND LEVEL 88
//*--------------------------------------------------
//RUN      EXEC PGM=COBEX04
//STEPLIB  DD DSN=USER25.DEV.LOAD,DISP=SHR
//SYSOUT   DD SYSOUT=*
