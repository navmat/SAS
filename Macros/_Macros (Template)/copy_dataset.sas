/***************************BEGIN MACRO HEADER**********************************

   Name:       copy_dataset
   Author:     Kevin Fong
   Created:    2014.10.02

   Purpose:    Copy SAS dataset from one lib to another.

   Arguments:  in_lib      - Input dataset library.  Default is sasdata lib.
               out_lib     - Output dataset library.  Default is work lib.
               in_dataset  - Input dataset.
               out_dataset - Output dataset.

   Note:       All arguments are required.

   Revisions
   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
   Date        Author  Comments
   ¯¯¯¯¯¯¯¯¯¯  ¯¯¯¯¯¯  ¯¯¯¯¯¯¯¯
   YYYY.MM.DD  III     Please use this format and insert new entries above

******************************END MACRO HEADER*********************************/

/*********************************MACRO****************************************/

%macro copy_dataset(in_lib= sasdata, out_lib= work, in_dataset, out_dataset);
   
   %* Check that in_dataset exists.;  
   %if ^%sysfunc(exist(&in_lib.&in_dataset.)) %then %do ;
        %put %str(E)RROR: Dataset does not exist. ;
        %return;
   %end;

   %if %sysfunc(exist(&out_lib.&out_dataset.)) %then %do ;
      %delete_dataset(&out_lib.,&out_dataset.) ;
   %end;

   %if &in_dataset. = &out_dataset. %then %do;
      proc copy in= &in_lib.  out= &out_lib.;
         select &in_dataset.;
      run
   %end;
   %else %do;
      proc copy in= &in_lib.  out= &out_lib.;
         select &in_dataset.;
      run;

      proc datasets lib= &out_lib. nolist;
         change &in_dataset. = &out_dataset.;
      quit; run;
   %end;

%mend;

/*********************************END******************************************/