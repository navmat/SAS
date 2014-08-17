dm 'log' clear;
***********************************HEADER*******************************************;
%include '[Header file path]';

************************************************************************************;
*** Defining macro to get import headers and infile data                         ***;
************************************************************************************;
%macro getInfile(sheetname,folder,filename);
   %*Importing import header file;
   proc import
      out= temp
      datafile = "&importHeader."
      dbms = excelcs replace;   
      sheet = &sheetname.;
      scantext = yes;
      usedate = yes;
      scantime = yes;
   run;

   %*Defining inputFMT for input portion of infile;
   data temp;
      format inputFMT $1.;
      set temp;
      if var_type= :'Ch' then inputFMT='$';
         else inputFMT=' '
      ;
   run;

   %*Defining macrovariables to host variable attributes and formats;
   proc sql;
      select var_name||' '||inputFMT
         into :varName separated by ' '
         from temp
      ;
      select var_name||' '||var_Informat
         into :varInformat separated by ' '
         from temp
      ;
      select var_name||' '||var_Format
         into :varFormat separated by ' '
         from temp
      ;
   quit;

   %*Infile statement;
   data &sheetname.;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile "&rawdata.\&folder.\&filename..csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2;

      informat &varInformat;
      format   &varFormat;
      input    &varName;

      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
   run;

   %*Deleting temp dataset created by macro;
   proc datasets lib=work nolist nowarn;
      delete temp;
   quit; run;
%mend;

**********************************************************************************;
*** Defining macro to get and write inputs for infile statement.               ***;
**********************************************************************************;
%macro for_infile(dataset,folder,filename);
   proc import
      out= temp replace
      datafile = "&rawdata.\&folder\&filename..csv";
   run;

   proc contents 
      out= temp2
      data= temp;
   run;

   proc sort 
      data= temp2;
      by VARNUM;
   run;

   data temp2
      (keep=
         Var_Order Var_Name Var_Type Var_Informat Var_Format Notes
      );
      retain VARNUM NAME type2 Var_Informat Var_Format;
      set temp2;
      var_format= compress(format||formatl)||'.';
      var_informat= compress(informat||INFORML)||'.';

      *Determining variable type;
      if informat= '$' then type2= 'Character';
      else if informat= 'BEST' then type2= 'Number';
      else type2= 'Date';

      rename varnum= Var_Order;
      rename name= Var_Name; 
      rename type2= Var_Type;

      *Generating warning message if format length equals zero;
      if FORMATL= 0 then Notes= 'Warning: Format length is 0';
      else Notes= ' ';
   run;

   proc export
      data= temp2
      outfile= "&exportdir.\Import Headers (Temp).xls" replace
      dbms= excelcs;
      sheet= &dataset.;
   run;

   %*Deleting temp dataset created by macro;
   proc datasets lib=work nolist nowarn;
      delete temp;
      delete temp2;
   quit; run;
%mend;