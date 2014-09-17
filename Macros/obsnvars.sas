/*
Updates to make:
   Update with default values.
   use sysfunc exist to see if dataset exists first (see example in infile macro). 
*/

***************************************************************************************;

*Defining macro to print number of observations and variables in a dataset;
%macro obsnvars(ds);
   
   %global dset nvars nobs;
   %let dset=&ds;
   %let dsid = %sysfunc(open(&ds.));
   %if &dsid %then
      %do;
         options NOMLOGIC NOSYMBOLGEN NOMPRINT;
         %let nobs =%sysfunc(attrn(&dsid,NOBS));
         %let nvars=%sysfunc(attrn(&dsid,NVARS));
         %let rc = %sysfunc(close(&dsid));
         %put ***************************************************************************************;
         %put;
         %put &dset has &nvars  variable(s) and &nobs observation(s).;
         %put;
         %put ***************************************************************************************;
      %end;
   %else
      %put Open for data set &dset failed - %sysfunc(sysmsg());
   options MLOGIC SYMBOLGEN MPRINT;
   
%mend obsnvars;

***********************************END*************************************************;