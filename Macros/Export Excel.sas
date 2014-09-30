*Excel export macro;
%macro export_xlsx(dataset, outfile, sheet);
   proc export 
      data= &dataset
      outfile= "&exportdir.\&outfile..xlsx" replace;
      sheet= "&sheet";
   run;
%mend;

***********************************END*************************************************;