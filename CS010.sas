
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . .
FILE NAME                                                          : CS010
PROGRAM DEVELOPER                                   : Gunji Jaya Kishore
PROJECTTITLE                                                    :  Graph 
PROJECT/TRIAL CODE                                      : CCS0010
DESCRIPTION                                                     : Generate vertical Graph 
APPLICATION VERSION                                   : SAS 9.4
INPUT                                                                    : profit.sas7bdat,toal.sas7bdat
OUTPUT                                                                :  Graph.rtf,Graph.log,Graphs 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .;







libname graphy "C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS010\RAW DATA";
proc printto log="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS010\OUTPUT\Graph.log" new;

ods rtf file="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS010\OUTPUT\Graph.rtf";
ods pdf file="C:\Users\kisho\OneDrive\Documents\Raw Data\CASE STUDIES\CS010\OUTPUT\Graph.pdf";
ods listing close;
goptions hsize=9in vsize=18in;
proc gchart data=graphy.profit;
vbar month/sumvar=sales space=1 discrete width=6 ;
pattern1 v=s c=blue;
run;
quit;
proc format;
value monthfmt
1='Jan'
2='Feb'
3='Mar'
4='Apr'
5='May';
run;

legend1 across=5 down=1
position=(bottom center outside )shape=bar(3,1)
value=(tick=1 "Jan" tick=2 "Feb" tick=3 "Mar" tick=4 "Apr" tick=5 "May");

proc gchart data=graphy.profit;
vbar month/sumvar=sales 
subgroup=month space=1 discrete
width=6 legend=legend1;
format month monthfmt.;
pattern1 v=s c=blue;
pattern2 v=e c=blue;
pattern3 v=l1 c=blue;
pattern4 v=r2 c=blue;
pattern5 v=x2 c=blue;
run;
quit;


proc gchart data=graphy.totals;
vbar site /sumvar=sales space=1 width=6 discrete ;
format sales dollar6.;
pattern1 v=s c=blue;
run;
quit;

ods _all_ close;
ods listing;
 proc printto ;
 run;
