/* filename junk dummy; proc printto log = junk; run; */

data _null_;
   set in_dataset /*(obs=10)*/;
   call execute('%macro('||arg1||', arg2, '||arg3||');');
run;

/* proc printto; run; */