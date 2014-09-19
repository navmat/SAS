*'; *"; run; quit; */;
dm 'output' clear;
dm 'log' clear;

proc datasets lib=work nolist nowarn kill; run; quit; libname _all_ clear;

***********************************HEADER**********************************************;
%include "[Complete header file path]";

***********************************EXPORT**********************************************;
*** Exporting from sasdata lib.                                                     ***;
***************************************************************************************;

[Code goes here]

***********************************END*************************************************;
dm 'log';