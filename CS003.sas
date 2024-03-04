

. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . .
FILE NAME                                                          : CS003
PROGRAM DEVELOPER                                   : Gunji Jaya Kishore
PROJECTTITLE                                                    :  Dataset creation and Listing generation 
PROJECT/TRIAL CODE                                      : CCS003
DESCRIPTION                                                     : Eligibility criteria and create inclusive criteria,exclusive criteria and diposition patients profile
APPLICATION VERSION                                   : SAS 9.4
INPUT                                                                    : Screen_pat.txt,Medication.txt,Dispose.txt
OUTPUT                                                                :  incl.sas7bdat,incl.log,excl.sas7bdat,excl.log,ds.sas7bdat,ds.log 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .








proc import datafile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS003\RAW DATA\dispose.txt" out=dispose;
delimiter=",";
run;
proc import datafile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS003\RAW DATA\medication.txt" out=medication ;
delimiter=",";
run;
proc import datafile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS003\RAW DATA\screen_pat.txt" out=scr_pat;
delimiter=",";
run;
proc sort data=dispose;
by pat;
run;
proc sort data=medication;
by pat;
run;
proc sort data=scr_pat;
by pat;
run;
data new;
length visit $10 age 3  location $3 status $10 arm $10 criteria $15 dscat $24; 
label pat='SUBJECT' visit='VISIT' age='AGE' sex='SEX' location='LOCATION' status='STATUS' height='HEIGHT' weight='WEIGHT' arm='ARM' criteria='CRITERIA' dscat='DISPOSITION CRITERIA';
merge scr_pat medication dispose;
by pat;
if age>30;
if status='h';
run;
proc format;
value $gender
'male'='M'
'female'='F';
run;
proc format;
value $locate
'us'='USA';
value $status
'h'='Healthy'
'p'='Patient';
value $arm
'p'='Placebo'
'a'='Active'
's'='Standard';
run;

libname result "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS003";

proc printto log="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS003\incl.log" new;
data result.incl;
set new;
if criteria='inc';
format sex $gender. location $locate. status $status. arm $arm. height 3.1 weight 3.1;
run;
proc printto; 
run;

proc printto log="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS003\excl.log" new ;
data result.excl;
set new;
if criteria='exl';
format sex $gender. location $locate. status $status. arm $arm. height 3.1 weight 3.1;
run;
proc printto ;
run;

proc printto log="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS003\ds.log" new;
data result.ds;
set new;
if dscat ne ' ';
format sex $gender. location $locate. status $status. arm $arm. height 3.1 weight 3.1;
run;
proc printto ;
run;
