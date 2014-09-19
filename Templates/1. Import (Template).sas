*'; *"; run; quit; */;
dm 'output' clear;
dm 'log' clear;

proc datasets lib=work nolist nowarn kill; run; quit; libname _all_ clear;

***********************************HEADER**********************************************;
%include "[Complete header file path]";

***********************************IMPORT**********************************************;
*** Importing to sasdata lib.                                                       ***;
***************************************************************************************;

[Code goes here]

***********************************END*************************************************;
dm 'log';