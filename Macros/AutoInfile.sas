/******************************BEGIN MACRO HEADER*******************************

   Name:       TempInfile & AutoInfile
   Author:     Kevin Fong
   Created:    2014.07.05

   Purpose:    Automate infile statements and facilitate data management.

   Arguments:  
               TempInfile
                  ref - one or more filerefs to add to the option
               AutoInfile
                  ref - one or more filerefs to add to the option

   Revisions
   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
   Date        Author  Comments
   ¯¯¯¯¯¯¯¯¯¯  ¯¯¯¯¯¯  ¯¯¯¯¯¯¯¯
   2014.09.30  KF      1. Added default values for parameters.
                       2. Add argument for import directory.
                       3. Comment out condition in second macro to see if file exists.
                       4. Updated to work with SAS 9.4 / .xlsx files.
                       5. Added infile options that are useful for dealing with
                          special characters and carriage returns.
                           a. IgnoreDOSeof
                           b. TERMSTR = CRLF 

   YYYY-MM-DD  III     Please use this format and insert new entries above
   
*******************************END MACRO HEADER********************************/

/*******************************************************************************
 Defining macro to get import headers from .csv files.
*******************************************************************************/
%macro TempInfile(dir, filename, out_sheetname);

   proc import out= temp replace
      datafile= "&&&dir.\&filename..csv";
   run;

   proc contents noprint out= temp data= temp;
   run;

   proc sort data= temp; by VARNUM;
   run;

   data temp
      (keep= Var_Order Var_Name Var_Type Var_Informat Var_Format Notes);
      retain VARNUM NAME type2 Var_Informat Var_Format;
      set temp;
      var_format= compress(format||formatl)||'.';
      var_informat= compress(informat||INFORML)||'.';

      %*Determining variable type;
      if informat= '$' then type2= 'Character';
      else if informat= 'BEST' then type2= 'Number';
      else type2= 'Date';

      rename varnum= Var_Order; rename name= Var_Name; rename type2= Var_Type;

      %*Generating warning message if format length equals zero;
      if FORMATL= 0 then Notes= 'Warning: Format length is 0';
      else Notes= ' ';
   run;

   proc export data= temp
      outfile= "&exportdir.\Import Headers (Temp).xls" replace;
      sheet= &out_sheetname.;
   run;

   %*Deleting temp dataset created by macro;
   %delete_dataset(work,temp);
   
%mend TempInfile;

%for_infile(dir, filename, out_sheetname);

/*******************************************************************************
 Defining macro to get import headers from .xls and infile data.
*******************************************************************************/
%macro AutoInfile(dir, filename, in_sheetname, out_dataset);

   %* Condition to see if header has already been imported;
   %if ^%sysfunc(exist(temp_&in_sheetname.)) %then
   %do;
      %*Importing import header file;
      proc import out= temp_&in_sheetname. replace
         datafile= "&importdir.\Import Headers.xls" ;   
         sheet= &in_sheetname.; scantext= yes; usedate= yes; scantime= yes ;
      run;
      %*Defining inputFMT for input portion of infile;
      data temp_&in_sheetname.;
         format inputFMT $1.;
         set temp_&in_sheetname.;
         if var_type= :'Ch' then inputFMT='$';
         else inputFMT=' ';
      run;
   %end;

   %*Defining macrovariables to host variable attributes and formats;
   proc sql noprint;
      select compress(var_name)||' '||compress(inputFMT)
         into :varName separated by ' '
         from temp_&in_sheetname.
      ;
      select compress(var_name)||' '||compress(var_Informat)
         into :varInformat separated by ' '
         from temp_&in_sheetname.
      ;
      select compress(var_name)||' '||compress(var_Format)
         into :varFormat separated by ' '
         from temp_&in_sheetname.
      ;
   quit;

   %*Infile statement;
   data &out_dataset.;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile "&&&dir.\&filename..csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2;

      informat &varInformat;
      format   &varFormat;
      input    &varName;

      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
   run;
   %* Deleting temp datasets created by macro;
   %delete_dataset(work,temp:); /* Comment this line out if importing multiple files with the same header */

%mend AutoInfile;

%get_Infile(dir, filename, in_sheetname, out_dataset) ;

/*********************************END******************************************/