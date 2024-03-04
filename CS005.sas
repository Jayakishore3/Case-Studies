
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . .
FILE NAME                                                          : CS005
PROGRAM DEVELOPER                                   : Gunji Jaya Kishore
PROJECTTITLE                                                    :   Listing of Screening Volunteers for Clinical Trials 
PROJECT/TRIAL CODE                                      : CCS005
DESCRIPTION                                                     : To screen healthy volunteers for clinical trials 
APPLICATION VERSION                                   : SAS 9.4
INPUT                                                                    : Screen.sas7bdat,lab.sas7bdat,pat_inf.sas7bdat,Mockshell 
OUTPUT                                                                : sc.sas7bdat,sc.lst,sc.log,sc.rtf
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .;










libname rawdata "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS005\RAW DATA";
libname output "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS005\OUTPUT";

proc printto log="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS005\OUTPUT\cs.log" new;
ods listing file="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS005\OUTPUT\cs.lst";
ods rtf file="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS005\OUTPUT\cs.rtf";

data scone ;
set rawdata.sc;
pat=input(patid,comma1.);
drop patid;
rename pat=patid;
run;


proc sort data=rawdata.pat_inf out=pat;
by patid;
run;
proc sort data=scone out=sc_sort;
by patid;
run;

proc format;
value gender
1='male' 2='female';
run;
data pat_;
set pat;
format sex gender.;
run;
data scr waste;
merge pat (in=frst) sc_sort (in=scnd);
by patid;
if frst=1 and scnd=1 then output scr;
else output waste;
run;
data scrone;
set scr;
format birdt date9.;
birdt=input(dob,anydtdte10.);
drop dob;
age=intck('years',birdt,today());
run;

proc sql;
create table output.sc as select * from scrone,rawdata.lab order by site,patid,lb_test;
quit;



title1 "Listing 5";
title2 "Screening Patient";
footnote1 "*1=male & 2=female";
footnote2 "**Created by Jayakishore 15jun2023 thursday 15:50";
proc report data=output.sc ;
columns site patid age sex birdt height weight racespec lb_test;
define site/order ;
define patid/order ;
define sex/order ;
define birdt/order ;
define racespec/order  ;
define height/order;
define weight/order;
define lb_test/order;
define age/order;
run;



ods _all_ close;
proc printto ;
run;
