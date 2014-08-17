*proc import for xlsx;
%macro import_xlsx(dataset,folder,filename,sheet);
   proc import
      out= &dataset.
      datafile = '&importdir.\&folder.\&filename..xlsx'
      dbms = excelcs replace;   
      sheet = &sheet.; /*Can also use, range = "&range.$";*/
      scantext = yes;
      usedate = yes;
      scantime = yes;
   run;
%mend;

*proc import for csv;
%macro import_csv(dataset,folder,filename);
   proc import
      out= &dataset.
      datafile = "&importdir.\&folder.\&filename..csv";
   run;
%mend;

************************************************************************************;

*Infile sample;

%macro get_muni_trade_leg_swap(dataset,folder,filename);
   data &dataset.;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile "&importdir.\&folder.\&filename..csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2;

         informat var1 $10. ;
         informat var2 best12. ;
         informat var3 best32. ;
         informat var4 date11. ;
         informat var5 hhmmss. ;

         format var1 $10. ;
         format var2 best12. ;
         format var3 best32. ;
         format var4 date11. ;
         format var5 time8. ;

         input
            var1 $.
            var2
            var3
            var4
            var5
         ;
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
   run;
%mend;