%macro append(in_dataset);
   proc append base= CME_data data= &in_dataset. force; quit;
%mend append;