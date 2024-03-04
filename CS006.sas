
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . .
FILE NAME                                                          : CS006
PROGRAM DEVELOPER                                   : Gunji Jaya Kishore
PROJECTTITLE                                                    :   Analysis subject level Dataset 
PROJECT/TRIAL CODE                                      : CCS006
DESCRIPTION                                                     :  Analysis dataset creation of SL (Subject Level) 
APPLICATION VERSION                                   : SAS 9.4
INPUT                                                                    : sl.xls,base.csv
OUTPUT                                                                : sl.sas7bdat,sl_dup.sas7bdat,sl.sas,sl.log 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .;








proc import datafile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS006\RAW DATA\Base.csv" out=rawbase dbms=csv replace;
proc import datafile="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS006\RAW DATA\SL.xls" out=subject dbms=xls replace; getnames=yes;namerow=4;datarow=5;run;
libname output "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS006\OUTPUT" ;

proc printto log="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS006\OUTPUT\SL.log" new;

/*Task1*/
proc sort data=rawbase (rename=(subject=subjectid)) ;
by subjectid site;
run;
proc sort data=subject ;
by subjectid site;
run;
data base;
set rawbase;
by subjectid site ;
if first.site then output;
run;
data output.SL (label=Subject level) output.SL_DUP(label=Subject level);
set subject;
by subjectid site;
if first.site then output output.SL;
else output output.SL_DUP;
run;

data SL_new;
merge base(in=a) output.sl(in=b);
by subjectid;
if a;
run;

/*Task2*/
data Sl_new1;
set Sl_new;
if length(birthdate)>5 then do;
a= scan(birthdate,1,'/');
b= scan (birthdate,2,'/');
c= input(scan(birthdate,3,'/'),best.);
end;
if a='unk' then do;
if b in(1:6) then a='01';
else if b in(7:12) then a='30';
end;
if b='unk' then do;
if a in(01:15) then b='01';
else if a in(16:31) then b='12';
end;
if a='unk' and b='unk' then do;
a='01';b='01';
end;
a1=input(a,best.);
b1=input(b,best.);
birthdate1=mdy(b1,a1,c);
if length(startdate)>5 then do;
x= scan(startdate, 1, ":");
y= scan(startdate, 2, ":");
z= scan(startdate, 3, ":");
k= scan(startdate, 4, ":");
l= scan(startdate, 5, ":");
m= scan(startdate, 6, ":");
end;
if x='unk' then do;
if y in(1:6) then x='01';
else if y in(7:12) then x='30';
end;
if y='unk' then do;
if x in(01:15) then y='01';
else if x in(16:31) then y='12';
end;
if x='unk' and y='unk' then do;
x='01';y='01';
end;
if k='null' or l='null' or m='null' then do;
k='00';l='00';m='00';
end;
x1=input(x,best.);
y1=input(y,best.);
z1=input(z,best.);
k1=input(k,best.);
l1=input(l,best.);
m1=input(m,best.);
startdate1=mdy(y1,x1,z1);
if birthdate1=. and birthdate ne " " then birthdate1=input(birthdate,best.);
if enddate ne " " then enddate1=input(substr(enddate,1,10),ddmmyy10.);
if startdate1=. and startdate ne " " then startdate1=input(startdate,best.);
format birthdate1 startdate1 enddate1 date9.;
keep name height subjectid site sex startdate1 enddate1 birthdate1 wt initial;
rename startdate1=startdate enddate1=enddate birthdate1=birthdate;
run;


/*Task3*/

data SL_1;
set SL_new1;
age=intck('years',startdate,birthdate);
days=intck('days',startdate,enddate);
months=intck('months',startdate,enddate);
years=intck('years',startdate,enddate);
label months='No of Months' years='No of Years';
wt1=input(wt,best4.);
weight=round(wt1,4.1);
label weight='Weight(In Kgs)';
drop wt1 wt;
run;

/*Task4*/

data SL;
set SL_1;
gen=upcase(sex);
length gender $8;
if gen='M'  then gender='Male';
else if gen='F' then gender='Female';
else if gen='MALE' then gender='Male';
else if gen='FEMALE' then gender='Female';
drop sex gen;
run;

proc printto;run;
