%macro compare_things(base, compare, results);

   proc compare 
      base= &base.
      compare= &compare.
      out= &results.
      /* criterion= .000001 */
      outnoequal /* noprint */;
      /*
      VAR   var_1_base    var_2_base    var_3_base;
      WITH  var_1_compare var_2_compare var_3_compare;
      */
   run;

%mend compare_things;