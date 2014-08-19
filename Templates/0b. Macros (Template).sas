***************************************************************************************;

*Delete SAS dataset;
%macro delete_dataset(lib,dataset);
   proc datasets lib= &lib. nolist nowarn;
      delete &dataset.;
   quit; run;
%mend;

***************************************************************************************;

*Copy SAS dataset from one lib to another;
%macro copy_dataset(in_lib,out_lib,in_dataset,out_dataset);
   %if &in_dataset. = &out_dataset. %then %do;
      proc copy in= &in_lib.  out= &out_lib.;
         select &in_dataset.;
      run
   %end;
   %else %do;
      proc copy in= &in_lib.  out= &out_lib.;
         select &in_dataset.;
      run;

      %delete_dataset(&out_lib.,&out_dataset.);

      proc datasets lib= &out_lib. nolist;
         change &in_dataset. = &out_dataset.;
      quit; run;
   %end;
%mend;

***************************************************************************************;

*Defining macro to print number of observations and variables in a dataset;
%macro obsnvars(ds);
   
   %global dset nvars nobs;
   %let dset=&ds;
   %let dsid = %sysfunc(open(&ds.));
   %if &dsid %then
      %do;
         options NOMLOGIC NOSYMBOLGEN NOMLOGIC NOMPRINT;
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
   options MLOGIC SYMBOLGEN NOMLOGIC NOMPRINT;
   
%mend obsnvars;

***************************************************************************************;

*Defining macro that closes open datasets and can be called by pressing "F12";
%macro closevts / cmd; 
  %local i; 
  %do i=1 %to 20;
    next "viewtable:"; end; 
  %end; 
%mend;
dm "keydef F12 '%NRSTR(%closevts);";

***************************************************************************************;
