*Created by:   Kevin Fong
*Date Created: 2/4/14
*Purpose:      SAS email notification;

dm 'output;clear';
dm 'log;clear';

***********************************************************************
*     Header                                                          *
***********************************************************************;

%macro startT;
data _null_;
   tempdate=put(date(),weekdate32.);
   temptime=put(time(),hhmm5.);
   call symput("startdate",tempdate);
   call symput("starttime",temptime);
run;
%mend;
%macro endT;
data _null_;
   tempdate=put(date(),weekdate32.);
   temptime=put(time(),hhmm5.);
   call symput("enddate",tempdate);
   call symput("endtime",temptime);
run;
%mend;
%macro email(dt);
   /* Set up the options for the email. */
   OPTIONS EMAILSYS=smtp EMAILID="kfong@cornerstone.com"
   EMAILHOST=CRDCEXCH10.cornerstone.com;
   FILENAME mymail
   EMAIL
   TO = ("kfong@cornerstone.com")
   SUBJECT="&dt. finished"
   ;
   /* Send the email and define the message to send. */
   DATA _NULL_;
   FILE mymail;
   PUT "Hello,";
   PUT " ";
   PUT "The code for &dt. has finished running.";
   PUT "Start: &StartTime. &StartDate. ";
   PUT "End:   &EndTime. &EndDate. ";
   RUN;
%mend;

%StartT;
%EndT;

*Code goes here!;
data _null_;
   put "Hello world!";
run;

%Email(test);