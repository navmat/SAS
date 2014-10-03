/*
Updates to make:
   Update with default values.
   use sysfunc exist to see if dataset exists first (see example in infile macro). 
*/

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

***********************************END*************************************************;