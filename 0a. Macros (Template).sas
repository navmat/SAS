*Copy SAS dataset from one lib to another;
%macro copy_dataset(inlib,outlib,dataset);
   proc copy in= &inlib.  out= &outlib.;
      select &dataset.;
   run;
%mend;

************************************************************************************;

*Delete SAS dataset;
%macro delete_dataset(lib,dataset);
   proc datasets lib= &lib. nolist nowarn;
      delete &dataset.;
   quit; run;
%mend;