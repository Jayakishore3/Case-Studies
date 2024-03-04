
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . .
FILE NAME                                                          : CS002
PROGRAM DEVELOPER                                   : Gunji Jaya Kishore
PROJECTTITLE                                                    :  Check outliers 
PROJECT/TRIAL CODE                                      : CCS002
DESCRIPTION                                                     : Outliers creation from rawdata 
APPLICATION VERSION                                   : SAS 9.4
INPUT                                                                    : Ae.xls,Dm2.xls,Mh.xls
OUTPUT                                                                : Safety report.xls
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .




proc import datafile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\RAW DATA\AE.xls" out=adv_evnt replace;
proc import datafile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\RAW DATA\demography.csv" out=demography replace;
proc import datafile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\RAW DATA\dm2.xls" out=demo2 replace;
proc import datafile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\RAW DATA\MH.xls" out=med_his replace;

proc sort data=adv_evnt (rename=(subject=patid));
by patid;
run;
proc sort data=demo2;
by patid;
run;
proc sort data=demography;
by patid;
run;
proc sort data=med_his;
by patid;
run;
data information;
merge adv_evnt demo2 demography med_his;
by patid;
run;
data informatics(drop=height1);
retain height1;;
set information;
if HEIGHT~=. then height1=HEIGHT;
else HEIGHT=height1;
run;

data demo_org demo_dup ;
set informatics;
by patid;
if first.patid=1 then output demo_org;
else output demo_dup;
run;

data bmi bmi_below;
set informatics;
bmi=(weight/(height*height))*703;
if 19<bmi<26 then output bmi_below;
else output bmi;
run;
data age age_range;
set informatics;
age=intck('years',birthdt,visit_date);
if 40<age<60 then output age_range;
else output age;
run;

data dob_lt dob_grt;
set informatics;
if birthdt > visit_date then status='yes';
if status='yes' then output dob_grt;
else status='no';
if status='no'  then output dob_lt;
run;
data gender_valid gender_invalid;
set informatics;
if sex='M' or sex='F' then output gender_valid;
else output gender_invalid;
run;
data decimal;
set informatics;
format weight 5.1 temp 4.1;
run;

/*adverse event*/
data stop_before_start;
set adv_evnt;
where end_date < start_date;
run;

data overlap;
set adv_evnt;
by patid;
if first.patid=0 then output overlap;
run;

/*vitals*/
data vitals;
set demography;
where DIABP > SYSBP ;
run;

/*medical history*/

data medicalhstry;
set informatics;
if visit_date<screen_date then physicalexam='normal';
else physicalexam='abnormal';
if physicalexam='normal' then output medicalhstry;
run;

proc export data=demo_dup
outfile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\OUTPUT\safety report.xls"
dbms=xls replace;
sheet='dup_patients';
run;
proc export data=bmi_below
outfile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\OUTPUT\safety report.xls"
dbms=xls replace;
sheet='bmi';
run;
proc export data=age_range
outfile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\OUTPUT\safety report.xls"
dbms=xls replace;
sheet='age_range';
run;
proc export data=dob_grt
outfile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\OUTPUT\safety report.xls"
dbms=xls replace;
sheet='dob gt visitdate';
run;
proc export data=gender_invalid
outfile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\OUTPUT\safety report.xls"
dbms=xls replace;
sheet='invalid gender';
run;
proc export data=decimal
outfile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\OUTPUT\safety report.xls"
dbms=xls replace;
sheet='decimal values';
run;
proc export data=stop_before_start
outfile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\OUTPUT\safety report.xls"
dbms=xls replace;
sheet='start is before start';
run;
proc export data=overlap
outfile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\OUTPUT\safety report.xls"
dbms=xls replace;
sheet='overlap data';
run;
proc export data=vitals
outfile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\OUTPUT\safety report.xls"
dbms=xls replace;
sheet='vitals';
run;
proc export data=medicalhstry
outfile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS002\OUTPUT\safety report.xls"
dbms=xls replace;
sheet='medical history';
run;
