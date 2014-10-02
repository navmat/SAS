***************************************************************************************;

*Defining macro that closes open datasets and can be called by pressing "F12";
%macro closevts / cmd; 
  %local i; 
  %do i=1 %to 20;
    next "viewtable:"; end; 
  %end; 
%mend;

* Assigns macro to F12. Move to header file and comment out if compiling from autocall file.
/* dm "keydef F12 '%NRSTR(%closevts);"; */ 

***********************************END*************************************************;
