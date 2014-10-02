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
   YYYY.MM.DD  III     Please use this format and insert new entries above
   
*******************************END MACRO HEADER********************************/

/*******************************************************************************
 Defining macro to export sas datasets to .xlsx files.
*******************************************************************************/
%macro export_xlsx(exportdir=  exportdir, dataset= , outfile= sas_output, sheet= sheet1);

   proc export 
      data= &dataset
      outfile= "&&&exportdir.\&outfile..xlsx" replace;
      sheet= "&sheet";
   run;

%mend;

***********************************END*************************************************;