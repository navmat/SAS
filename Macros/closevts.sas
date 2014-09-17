***************************************************************************************;

*Defining macro that closes open datasets and can be called by pressing "F12";
%macro closevts / cmd; 
  %local i; 
  %do i=1 %to 20;
    next "viewtable:"; end; 
  %end; 
%mend;
dm "keydef F12 '%NRSTR(%closevts);";

***********************************END*************************************************;
