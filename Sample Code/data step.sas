* Vanilla data step;
data [out_dataset];
   set [in_dataset] <(dset-options)>;
   [Code goes here];
run;

* merge;
data [out_dataset];
   merge [a_dataset] (in= a) [b_dataset] (in= b);
   by [var1] [var2];
   if a / b / a eq b / a ne b;
   [Code goes here];
run;

* Common options;
rename= (old-name = new-name <...old-name-n = new-name-n>)
where= (var in("value_1" "value_2"))
where= (date >= "01jan2007"d & date <= "30sep2009"d)
keep=
drop=
obs= 