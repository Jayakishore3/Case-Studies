. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . .
FILE NAME                                                          : CS008
PROGRAM DEVELOPER                                   : Gunji Jaya Kishore
PROJECTTITLE                                                    :   Summary of Medication 
PROJECT/TRIAL CODE                                      : CCS008
DESCRIPTION                                                     : : Generate summary reports of concomitant medication reports by using procedure Report 
APPLICATION VERSION                                   : SAS 9.4
INPUT                                                                    : trt.sas,mockshell
OUTPUT                                                                :  med.sas7bdat,med.log,med.rtf 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .;






libname rawdata "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS008\RAW DATA";
libname output "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS008\OUTPUT";

data output.Med;
set rawdata.trtmentr;
run;
proc printto log="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS008\OUTPUT\med.log" new;
ods listing close;
ods rtf file="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS008\OUTPUT\med.rtf";


proc report data=rawdata.trtmentr nowd;
title "summary medication table";
   column lab drug sub;
   define lab / group;
   define drug /group;
   define sub / across analysis sum;
   break after  lab/ summarize;
   rbreak after /summarize;
run;



proc report data=rawdata.trtmentr;
column lab drug,sub sub=total;
define lab / group;
define drug / across ;
define sub / across analysis sum;
compute after;
line '  ';
line ' ';
line "this datat belongs to phase4";
endcomp;
run;



proc report data=rawdata.trtmentr;
column lab drug,sub sub=total;
define lab / group;
define drug / across ;
define sub / across analysis sum;
compute before;
line " ";
line " ";
line "this data belongs to oncology";
line " ";
line "phase 4 trails";
line " ";
line " ";
endcomp;
compute after;
line '  ';
line ' ';
line "this datat belongs to phase4";
line " ";
line " ";
endcomp;
run;


ods rtf close;
ods listing ;
proc printto ;run;
