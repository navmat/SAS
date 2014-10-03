/***************************BEGIN MACRO HEADER**********************************

   Name:       AutoInfile
   Author:     Kevin Fong
   Created:    2014.10.02

   Purpose:    Automate infile statements and facilitate data management.  This
               macro writes an infile statement based on headers in a xlsx.
               Can be used in conjunction with the AutoInfileTemp macro.

   Arguments:  importdir   - Directory where .xlsx with headers lives. 
                             Default is importdir.
               datadir     - Directory where raw data lives.
               filename    - Name of input file.  Include file extension.
               in_sheet    - Sheet in xlsx. file to use as infile header.
               out_dataset - Name of output dataset.

   Note:       All arguments are required.  Datadir and importdir must be macro
               variables.  If the same header can be applied to multiple input
               files, comment out the last line in the macro, which deletes the
               temp datasets created by the macro.

               TERMSTR= CRLF and IgnoreDOSeof are useufl options for dealing
               with unwanted carriage returns and sepcial characters.

   Revisions
   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
   Date        Author  Comments
   ¯¯¯¯¯¯¯¯¯¯  ¯¯¯¯¯¯  ¯¯¯¯¯¯¯¯
   YYYY.MM.DD  III     Please use this format and insert new entries above

******************************END MACRO HEADER*********************************/

/*********************************MACRO****************************************/

%macro AutoInfile(importdir= importdir, datadir=, filename=, in_sheet=, out_dataset=);
   
   %* Check that header file exists.;  
   %if ^%sysfunc(fileexist(&&&importdir.\Import Headers.xlsx)) %then %do ;
        %put %str(E)RROR: The external file &&&importdir.\Import Headers.xlsx does not exist. ;
        %return;
   %end;

   %* Check that input file exists.;  
   %if ^%sysfunc(fileexist(&&&datadir.\&filename.)) %then %do ;
        %put %str(E)RROR: The external file &&&datadir.\&filename. does not exist. ;
        %return;
   %end;

   %* Condition to see if header has already been imported;
   %if ^%sysfunc(exist(temp_&in_sheet.)) %then %do;
      %*Importing import header file;
      proc import out= temp_&in_sheet. replace
         datafile= "&&&importdir.\Import Headers.xlsx" ;   
         sheet= &in_sheet.; scantext= yes; usedate= yes; scantime= yes ;
      run;
      %*Defining inputFMT for input portion of infile;
      data temp_&in_sheet.;
         format inputFMT $1.;
         set temp_&in_sheet.;
         if var_type= :'Ch' then inputFMT='$';
         else inputFMT=' ';
      run;
   %end;

   %*Defining macrovariables to host variable attributes and formats;
   proc sql noprint;
      select compress(var_name)||' '||compress(inputFMT)
         into :varName separated by ' '
         from temp_&in_sheet.
      ;
      select compress(var_name)||' '||compress(var_Informat)
         into :varInformat separated by ' '
         from temp_&in_sheet.
      ;
      select compress(var_name)||' '||compress(var_Format)
         into :varFormat separated by ' '
         from temp_&in_sheet.
      ;
   quit;

   %*Infile statement;
   data &out_dataset.;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile "&&&datadir.\&filename." delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2;

      informat &varInformat;
      format   &varFormat;
      input    &varName;

      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
   run;

   %* Deleting temp datasets created by macro;
   %delete_dataset(work,temp:); /* Comment this line out if importing multiple files with the same header */

%mend AutoInfile;

/*********************************END******************************************/