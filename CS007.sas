
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . .
FILE NAME                                                          : CS007
PROGRAM DEVELOPER                                   : Gunji Jaya Kishore
PROJECTTITLE                                                    :  Summary of Treatment 
PROJECT/TRIAL CODE                                      : CCS007
DESCRIPTION                                                     : : Generate summary reports of treatment reports by using procedure Tabulate 
APPLICATION VERSION                                   : SAS 9.4
INPUT                                                                    : trt.sas, Mockshell
OUTPUT                                                                :  trt.sas7bdat,trt.log,trt.rtf 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .;









libname rawdata "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS007\RAW DATA";
libname output "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS007\OUTPUT";
proc import datafile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS007\RAW DATA\trt2.csv" out=rawdata.trt2 dbms=csv replace;
proc printto log="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS007\OUTPUT\trt.log" new;
ods listing close;
ods rtf file="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS007\OUTPUT\trt.rtf";
data output.trt;
set rawdata.trt;
run;
title1 "Summary of treatment";
title2 "CCS007";
title3 "Generate summary reports of treatment reports by using procedure Tabulate ";
proc tabulate data=rawdata.Trt;
class Lab;
var sub;
table Lab,sub*(N mean);
label lab=Lab_Group;
run;
proc format;
value visit_fmt
1 = 'Visit1'
2 = 'Visit2'
3 = 'Visit3'
4 = 'Visit4'
5 = 'Visit5'
6 = 'Visit6'
7 = 'visit7'
;
run;


proc tabulate data=rawdata.trt;
class visit drug/style=[background=white];
var sub;
table visit*drug,sub*(n sum mean max min std);
format visit visit_fmt.;
label drug=drug1;
run;

proc tabulate data=rawdata.trt2 ;
class trt sex;
table trt all, sex='Gender(count)'*n all sex='Gender(%)'*pctn all*pctn/box="Example of using PCTN"  ;
run;


proc tabulate data=rawdata.trt2 ;
class trt sex;
var aval;
table trt all, sex='Gender(count)'*aval  all*aval sex='Gender(%)'*aval*pctsum all*aval*pctsum/box="Example of using PCTSUM"  ;
label aval='Lab_Group Result';
run;

proc tabulate data=rawdata.trt2;
class trt sex;
table trt all,sex='Gender(Count)'*n all*n sex='Gender(%)'*rowpctn all*rowpctn/box="Example of using ROWPCTN"  ;
run;

proc tabulate data=rawdata.trt2;
class trt sex;
var aval;
table trt all,sex='Gender (Count)' *aval  all*aval sex='Gender (%)'*aval*rowpctsum all*aval*rowpctsum/box="Example of using ROWPCTSUM";
label aval='Lab_Group Result';
run;

proc tabulate data=rawdata.trt2;
class trt sex site avisit;
table site*(trt all), avisit*(sex*rowpctn all*rowpctn) ;
keylabel rowpctn=" ";
run;


ods rtf close;
ods listing;
proc printto;run;





libname adhoc "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS007\ADHOC";
proc printto log="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS007\ADHOC\trt2.log" new;
ods listing close;
ods rtf file="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS007\ADHOC\trt2.rtf";
data adhoc.trt2;
set rawdata.trt2;
run;
title1 "Summary of treatment";
title2 "CCS007";
title3 "Generate summary reports of treatment reports by using procedure Tabulate ";
proc tabulate data=adhoc.trt2 ;
class trt sex;
table trt all, sex='Gender(count)'*n all sex='Gender(%)'*pctn all*pctn/box="Example of using PCTN" ;
run;


proc tabulate data=adhoc.trt2 ;
class trt sex;
var aval;
table trt all, sex='Gender(count)'*aval  all*aval sex='Gender(%)'*aval*pctsum all*aval*pctsum/box="Example of using PCTSUM"  ;
label aval='Lab_Group Result';
run;

proc tabulate data=adhoc.trt2;
class trt sex;
table trt all,sex='Gender(Count)'*n all*n sex='Gender(%)'*rowpctn all*rowpctn/box="Example of using ROWPCTN"  ;
run;

proc tabulate data=adhoc.trt2;
class trt sex;
var aval;
table trt all,sex='Gender (Count)' *aval  all*aval sex='Gender (%)'*aval*rowpctsum all*aval*rowpctsum/box="Example of using ROWPCTSUM";
label aval='Lab_Group Result';
run;

proc tabulate data=adhoc.trt2;
class trt sex site avisit;
table site*(trt all), avisit*(sex*rowpctn all*rowpctn) ;
keylabel rowpctn=" ";
run;

ods rtf close;
ods listing;
proc printto; run;
