*Excel export macro;
%macro export_xlsx(dataset, outfile, sheet);
   proc export 
      data= &dataset
      outfile= "&exportdir.\&outfile..xls" replace
      dbms= excelcs;
      sheet= "&sheet";
   run;
%mend;