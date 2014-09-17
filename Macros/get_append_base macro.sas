
***************************************************************************************;

*Print to log the SAS code to define the base dataset for a proc appened;
%macro get_append_base(base_dataset);
   proc contents data= &base_dataset. out= local_temp; run;
   
   proc sort data= local_temp; by varnum; run;

   data _null_;
      set local_temp end= last;
      by varnum;
      obs = _N_;
      ;
      if obs = 1 then do;
         put "***************************************************************************************;";
         put;
         put "   data stuff;";
         put "      set _null_;";
         put "      format";
      end;

      formatted = compress(name) || ' ' || compress(cat(format,FORMATL,"."));
      put "         " formatted;

      if last then do;
         put "      ;";
         put "   run;";
         put;
         put "***************************************************************************************;";
      end;   
   run;
   %delete_dataset(work,local_temp);
%mend get_append_base;

***********************************END*************************************************;
