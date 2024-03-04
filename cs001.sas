. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . .
FILE NAME                                                          : CS001
PROGRAM DEVELOPER                                   : Gunji Jaya kishore
PROJECTTITLE                                                    :  Dataset creation and Listing generation 
PROJECT/TRIAL CODE                                      : CCS001
DESCRIPTION                                                     : Listing of demographicdata 
APPLICATION VERSION                                   : SAS 9.4
INPUT                                                                    : demography.csv, visit.xls
OUTPUT                                                                :  demo.sas7bdat, Demo.lst,adhoc,demo2.xls, Demographics.rtf 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .

/*Task1*/;


proc import datafile="C:\Users\kisho\Downloads\Raw Data\CASE STUDIES\CS001\RAW DATA\demography.csv" out=graphics dbms=csv replace ;
proc import datafile="C:\Users\kisho\Downloads\Raw Data\CASE STUDIES\CS001\RAW DATA\visit.xls" out=bmid dbms=xls replace;

proc sort data=graphics (rename=(patid=pat)) nodup;
by pat;
run;
proc sort data=bmid nodup ;
by pat;
run;
data demographics;
merge graphics bmid;
run;

proc format;
value gender
1='Male'
2='Female';
run;
libname result "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS001\OUTPUT";

data result.demo (keep= Subject gender bmi label=demograpgy);;
set demographics;
format sexcd gender. bmi 5.2;
rename sexcd=Gender pat=Subject;
label bmi='Body Mass Index' pat='subject';
bmi=(weight/(height*height)*703);
run;

proc printto print="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS001\OUTPUT\demo.lst";
proc print data=result.demo  noobs  ;
run;
proc printto ;
run;




/*Adhoc report*/
data bmi_report(keep=category bmi);
set result.demo;
length category $17.;
if bmi <= 15 then category='very underweight';
else if 16>bmi<18.4 then category='underweight';
else if 18.5>bmi<24.9 then category='normal';
else if 25>bmi<29.9 then category='overweight';
else if 30>bmi<34.9 then category='obese';
else if bmi<=35 then category='very obese';
run;
proc printto print="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS001\ADHOC\adhocreport.lst";

proc report data=bmi_report colwidth=60;
columns category  bmi ;
define category/display ;
define bmi/display 'BMI-range[BMI(lb/in^2)*703.1]' format=6.2;
run;
proc printto;
run;

/* Task2*/

data result.demo2;
set demographics;
age=intck('year',birthdt,today());
rename site=location sexcd=sex;
run;

ods listing close;
ods excel file="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS001\OUTPUT\demo2.xls";
proc print data=result.demo2 noobs;
format sex gender.;
var age sex location;
run;
ods excel close;
ods listing;


/*Task3*/
proc format;
value races
1='Asian' 2='White' 3='Black' 4='African' 5='Multi' 6='Caucasian'
7='BI-RA';
run;
proc format;
value ethnic
1='latino' 2='Not Hispanic';
run;
ods listing close;
ods rtf body="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS001\OUTPUT\demographics.rtf";
proc report data=demographics split='*';
columns site pat racecd ethnicity sexcd new1 birthdt age new2 start_date end_date usubjid;
define site/display noprint;
define pat/display noprint;
define racecd/display noprint;
define ethnicity/display noprint;
define sexcd/display noprint;
define new1/computed  'site\subjid\race\ethnicity\sex' width=35;
compute new1/character length=35;
new1=catx('\',site,pat,put(racecd,races.),put(ethnicity,ethnic.),put(sexcd,gender.));
endcomp;
define birthdt/display noprint ;
define age/computed noprint;
compute age;
age=intck('year',birthdt,today());
endcomp;
define new2/computed 'Brthdt\*Age*(DD\MMM\YY)' width=15;
compute new2/character length=25;
new2=catx('\',put(birthdt,date9.),age);
endcomp;
define start_date/display 'Start date*(DD\MMM\YY)' width=13;
define end_date/display 'End date*(DD\MMM\YY)' width=13;
define usubjid/computed 'Usubjid*(site+subjid)' width=13;
compute usubjid;
usubjid=site+pat;
endcomp;
run;
ods rtf close;
ods listing;




