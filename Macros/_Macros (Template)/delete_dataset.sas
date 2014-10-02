/*
Updates to make:
   Update with default values.
   use sysfunc exist to see if dataset exists first (see example in infile macro). 
*/

***************************************************************************************;

*Delete SAS dataset;
%macro delete_dataset(lib,dataset);
   proc datasets lib= &lib. nolist nowarn;
      delete &dataset.;
   quit; run;
%mend;

***********************************END*************************************************;