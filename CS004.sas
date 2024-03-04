
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . .
FILE NAME                                                          : CS004
PROGRAM DEVELOPER                                   : Gunji Jaya Kishore
PROJECTTITLE                                                    :  Summary of demographic tables
PROJECT/TRIAL CODE                                      : CCS004
DESCRIPTION                                                     : Generate a demographic table 
APPLICATION VERSION                                   : SAS 9.4
INPUT                                                                    : Dm.sas7bdat,Mockshell
OUTPUT                                                                : demog.sas7bdat,aesumm.sas,demog.log,demog.rtf 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .;









libname rawdata "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS004\RAW DATA";
libname newdata "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS004\OUTPUT";

proc sort data=rawdata.dm out=newdata.dm;
by arm;
run;
proc summary data=newdata.dm print;
class arm;
var age;
output out=one (drop=_type_ _freq_ where=(arm~=.))n= mean= std= median= q1= q3= min= max= /autoname;
run;
data two;
set one;
N=put(age_n,3.);
Mean=put(age_mean,4.1);
SD=put(age_stddev,4.1);
Median=put(age_median,4.1);
Q1=put(age_q1,4.1);
Q3=put(age_q3,4.1);
Min=put(age_min,4.1);
Max=put(age_max,4.1);
Q1_Q3=Q1||"-"||Q3;
Min_Max=Min||"-"||Max;
run;

proc transpose data=two out=result prefix=arm ;
id arm;
var n mean sd median q1 q3 min max;
run;

data age1;
input agerow$25.;
cards;
Age
;
run;
data result1;
length agerow $25. arm0 $25. arm1 $25.;
set age1 result;
if agerow ne "Age" then agerow=_name_;
drop _name_;
run;
proc freq data=newdata.dm;
table arm*gender/out=aaa;
run;

data bbb;
set aaa;
length value $25.;
value=strip((put(count,4.))||"("||strip(put(percent,5.))||"%)");
run;
proc sort data=bbb ;
by gender arm;
run;

proc transpose data=bbb out=resultg prefix=arm;
id arm;
var value;
by gender;
run;
data gender;
input genrow$25.;
cards;
Gender
;
run;
data resultg1;
set gender resultg;
if Gender=1 then genrow="Male";
if Gender=2 then genrow="Female";
drop Gender _name_;
run;

proc printto log="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS004\OUTPUT\demog.log" new;

data newdata.demog;
retain frstcol;
set result1 resultg1;
frstcol=trim(genrow)||trim(agerow);
drop genrow agerow;
run;

options nodate nonumber;
ods listing close;
ods rtf file="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS004\OUTPUT\demog.rtf";

proc report data=newdata.demog nowd headskip
style (header)=data {background=white fontsize=7.5 font_face="SAS Monospace"}
style (column)={cellwidth=4cm fontsize=7 font_face="SAS Monospace"}
style={rules=none frame=void};
columns frstcol arm1 arm0;
define frstcol/"  " width=20;
define arm1/display "Active/N=15 (53.57%)"  center width=30;
define arm0/display "Placebo/N=13 (46.43%)" center width=30;
rbreak before /summarize dol;
compute after ;
line" ";
line" ";
line"______________________________________________________";
line" ";
endcomp;
compute before;
line"________________________________________________________";
line" ";
line" ";
endcomp;
title1 height =10 font="SAS Monospace" "Table 4: Demographic Characteristics";
title2 " ";
run;
ods rtf close;
ods listing;
proc printto;
run;
