data _null_;
set [dateset];
   call execute('%[macro]('||[var1]||','||[var2]||','||[var3]||');');
run;
