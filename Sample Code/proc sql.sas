***************************************************************************************;

*Proc sql code to create a table;
proc sql;
   create table [out_dataset] as
      select [* or distinct]     
         [var1],
         [var2],
         [var3]
      from [in_dataset]
      /*Only sort if necessary!*/
      order by [by_var1], [by_var2]
   ;
quit;

***************************************************************************************;

*Proc sql code for a join;
proc sql;
   create table [out_dataset] as
      select      
         a.[a_var1],
         a.[a_var2],
         b.[b_var1],
         b.[b_var2]
      from [merge_dataset_1] a [left/right/inner/full] join [merge_dataset_2] b
      /*Warning! Duplicate key values will result in Cartesian product and may break SAS*/
      on (a.[key_1a] = b.[key_1b]) and (a.[key_2a] = b.[key_2b])
      /*Only sort if necessary!*/
      order by [by_var1], [by_var2], [by_var3]
   ;
quit;

***************************************************************************************;

*Proc sql code to create a macro list variabl;
proc sql noprint;
   select [select_var]
      into :[macrolist] separated by ' '
      from [dataset]
   ;
quit;

%put &[macrolist].;

***************************************************************************************;
