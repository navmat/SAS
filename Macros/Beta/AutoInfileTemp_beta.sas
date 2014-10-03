/***************************BEGIN MACRO HEADER**********************************

   Name:       AutoInfileTemp
   Author:     Kevin Fong
   Created:    2014.10.02

   Purpose:    Automate infile statements and facilitate data management.  This
               macro generates headers in a xlsx. file and should be used in 
               conjunction with the AutoInfile macro.

   Arguments:  datadir     - Directory where raw data lives.
               filename    - Name of input file.  Include file extension.
               out_sheet   - Name of sheet created in xlsx. file. 

   Note:       All arguments are required.  Datadir must be a macro variable.

   Revisions
   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
   Date        Author  Comments
   ¯¯¯¯¯¯¯¯¯¯  ¯¯¯¯¯¯  ¯¯¯¯¯¯¯¯
   YYYY.MM.DD  III     Please use this format and insert new entries above

******************************END MACRO HEADER*********************************/

/*********************************MACRO****************************************/

%macro AutoInfileTemp(datadir=, filename=, out_sheet=);

   %* Check that input file exists.;  
   %if ^%sysfunc(fileexist(&&&datadir.\&filename.)) %then %do ;
        %put %str(E)RROR: The external file &&&datadir.\&filename. does not exist. ;
        %return;
   %end;

   proc import out= temp replace
      datafile= "&&&datadir.\&filename." ;
   run;

   proc contents noprint out= temp data= temp ;
   run;

   proc sort data= temp; by VARNUM ;
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
      outfile= "&exportdir.\Import Headers (Temp).xlsx" replace;
      sheet= &out_sheet.;
   run;

   %*Deleting temp dataset created by macro;
   %delete_dataset(work,temp);
   
%mend AutoInfileTemp;

/*********************************END******************************************/








