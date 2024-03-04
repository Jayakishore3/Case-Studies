. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . .
FILE NAME                                                          : CS009
PROGRAM DEVELOPER                                   : Gunji Jaya Kishore
PROJECTTITLE                                                    :  AE Summary
PROJECT/TRIAL CODE                                      : CCS009
DESCRIPTION                                                     : Incidence of Treatment Emergent Adverse Events by System Organ Class (SOC) and Preferred Term (PT) 
APPLICATION VERSION                                   : SAS 9.4
INPUT                                                                    : adae.xls,Mockshell
OUTPUT                                                                :  ae.sas7bdat,ae.sas,ae.log 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .








libname raw "C:\Users\kisho\OneDrive\Documents\Raw Data\BASE SAS";
proc printto log="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS009\OUTPUT\ae.log" new;

proc import file="C:\Users\kisho\OneDrive\Documents\ADAE_AA.xls"
out=raw.new  DBMS=XLS REPLACE;GETNAMES=YES;
run;

data raw.new1;
set raw.new;
where TEAE  AND AEBODSYS NE '';
RUN;

proc sort data=raw.new1  nodupkey out= raw.unique dupout=raw.dup;
by USUBJID TRT01A  AEDECOD AEBODSYS;
run;

/*First line*/

proc sort data=raw.new1  NODUPKEY OUT=raw.FIRST01 ;
BY USUBJID ;
RUN;

proc freq data=raw.FIRST01 NOPRINT ;
table TRT01A /out=raw.FREQ;
run;

DATA raw.FREQ1(DROP=COUNT PERCENT);
SET raw.FREQ;
CP=put(COUNT,1.)||'('||COMPBL(put(PERCENT,5.1))||')' ;
AEBODSYS='Number of subjects with at least one adverse event';
run;

PROC TRANSPOSE DATA=raw.FREQ1 OUT=raw.FREQ2 PREFIX=TRT ;
VAR CP;
id TRT01A;
BY AEBODSYS ;
RUN;

/*Second line*/

PROC SORT DATA=raw.new1   NODUPKEY OUT=raw.SECOND01 ;
BY USUBJID TRT01A AEBODSYS AEDECOD;
RUN;
proc freq data=raw.SECOND01 NOPRINT ;
table TRT01A*AEBODSYS /out=raw.FREQ_BODSYS ;
RUN;
DATA raw.FREQ_BODSYS1 (DROP=COUNT PERCENT);
SET raw.FREQ_BODSYS;
CP=put(COUNT,3.)||'('||COMPBL(put(PERCENT,5.1))||')' ;
RUN;
PROC SORT DATA=raw.FREQ_BODSYS1 ;
BY  AEBODSYS TRT01A ;
RUN;
PROC TRANSPOSE DATA=raw.FREQ_BODSYS1  OUT=raw.FREQ_BODSYS2 PREFIX=TRT ;
VAR CP;
id TRT01A;
BY AEBODSYS;
RUN;

DATA raw.final1;
SET raw.FREQ_BODSYS1;
BY  AEBODSYS TRT01A;
IF FIRST.AEBODSYS THEN DO;
CNT=1;
END;
RUN;


/*Third line*/


proc sort data=raw.new1  NODUPKEY OUT=raw.THIRD01;
by USUBJID TRT01A AEBODSYS AEDECOD ;
run;

proc freq data=raw.THIRD01 NOPRINT ;
table TRT01A*AEBODSYS*AEDECOD /out=raw.FREQ_DECOD;
RUN;

DATA raw.FREQ_DECOD1 (DROP=COUNT PERCENT);
SET raw.FREQ_DECOD;
CP=put(COUNT,3.)||'('||COMPBL(put(PERCENT,5.1))||')' ;
RUN;
PROC SORT DATA=raw.FREQ_DECOD1 ;
BY  AEBODSYS AEDECOD;
RUN;
PROC TRANSPOSE DATA=raw.FREQ_DECOD1 OUT=raw.FREQ_DECOD2  PREFIX=TRT ;
VAR CP;
id TRT01A;
BY  AEBODSYS AEDECOD;
RUN;

/*MERGING*/


PROC SORT DATA=raw.FREQ_BODSYS1 ;
BY  AEBODSYS TRT01A;
RUN;
PROC SORT DATA=raw.FREQ_DECOD1 ;
BY  AEBODSYS TRT01A;
RUN;

data raw.merg (drop= AEBODSYS  AEDECOD);
set raw.FREQ_BODSYS1 raw.FREQ_DECOD1 ;
by  AEBODSYS TRT01A ;
if AEBODSYS ne ' '  AND AEDECOD= ' '  then aebodsys1=Aebodsys;
else AEBODSYS1="  "||AEDECOD;
RUN;


data raw.f1;
set raw.merg;
by aebodsys1;
if first.aebodsys1 then count=1;
else count+1;
run;



proc sort data=raw.F1  OUT=raw.F2 ;
by COUNT AEBODSYS1 ;
run;

PROC TRANSPOSE DATA=raw.F2 OUT=raw.F3   PREFIX=TRT ;
VAR CP;
id TRT01A;
BY COUNT AEBODSYS1 ;
RUN;

Data raw.F4 (DROP=COUNT rename=(AEBODSYS1=AEBODSYS));
set  raw.F3;
Array TRT(3) TRTA TRTB TRTC;
do i=1 to 3;
if TRT(i)=' ' then TRT(i)='0(00.0)';
end;
drop i;
run;

libname output "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS009\OUTPUT";

proc sort data=raw.freq2;
by aebodsys;
run;
proc sort data=raw.f4 out=output.ae;
by aebodsys;
run;
DATA output.ae (DROP=_NAME_);
LENGTH AEBODSYS $100. TRTA TRTB TRTC $10.;
SET raw.Freq2 raw.F4;
run;



PROC PRINT DATA=output.ae;
RUN;

proc printto;run;
