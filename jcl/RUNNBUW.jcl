//RUNNB   JOB (ACCT),'RUN NB DRIVER',CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//*-------------------------------------------------------------------*
//* Execute integrated-test driver DRIVENBUW (GnuCOBOL build:
//*   build/bin/driver-nbuw001). On z/OS substitute your load module.
//*-------------------------------------------------------------------*
// SET LOAD=YOUR.HLQ.COBSAMP.LOAD
//GO     EXEC PGM=DRVNBUW,REGION=8M
//STEPLIB  DD DISP=SHR,DSN=&LOAD
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=133,BLKSIZE=1330)
//CEEDUMP  DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
/*
