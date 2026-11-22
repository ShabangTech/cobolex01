//USER25R  JOB MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*--------------------------------------------------
//* STEP 1: DELETE OUTPUT FROM ANY EARLIER RUN
//*--------------------------------------------------
//DELOUT   EXEC PGM=IEFBR14
//DD1      DD DSN=USER25.COBEX06.OUT,
//            DISP=(MOD,DELETE,DELETE),
//            SPACE=(TRK,(1,1))
//*--------------------------------------------------
//* STEP 2: RUN COBEX06 - ADD 5% TO EACH SALARY
//*--------------------------------------------------
//RUN      EXEC PGM=COBEX06
//STEPLIB  DD DSN=USER25.DEV.LOAD,DISP=SHR
//EMPIN    DD DSN=USER25.COBEX06.IN,DISP=SHR
//EMPOUT   DD DSN=USER25.COBEX06.OUT,
//            DISP=(NEW,CATLG,DELETE),
//            LIKE=USER25.COBEX06.IN
//SYSOUT   DD SYSOUT=*
