*Suppressing log for call execute;
proc printto
   log = "&exportdir.\junk.txt";
run;

or 

filename junk dummy;
proc printto log = junk; run;

**********************************************************************************;

*Re-enabling log;
proc printto; run;