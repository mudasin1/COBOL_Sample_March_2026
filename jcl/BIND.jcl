//COBLINK JOB (ACCT),'COBOL BIND',CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//*-------------------------------------------------------------------*
//* Binder skeleton: adjust PGM (IEWL / HEWLH096), libraries, ENTRY,
//* and INCLUDE members to match your cataloged names.
//*-------------------------------------------------------------------*
// SET HLQ=YOUR.HLQ.COBSAMP
// SET LOAD=&HLQ..LOAD
//*
//BIND   EXEC PGM=IEWL,PARM='MAP,XREF,LET,LIST'
//OBJLIB   DD DISP=SHR,DSN=&HLQ..OBJ
//SYSLMOD  DD DISP=SHR,DSN=&LOAD(DRVNBUW)
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//CEELKED  DD DISP=SHR,DSN=CEE.SCEELKED
//SYSUT1   DD UNIT=VIO,SPACE=(CYL,(5,5))
//SYSLIN   DD *
     INCLUDE OBJLIB(DRVNBUW)
     INCLUDE OBJLIB(NBUW001)
     SETCODE AC(1)
     ENTRY DRIVENBUW
     NAME DRVNBUW(R)
/*
