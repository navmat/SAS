*'; *"; run; quit; */;
dm 'output' clear;
dm 'log' clear;

proc datasets lib=work nolist nowarn kill; run; quit; libname _all_ clear;

/*********************************HEADER***************************************/
%include "['HEADER FILE PATH']";

/*********************************EXPORT****************************************
 Exporting from sasdata lib.                                                  
********************************************************************************/

['CODE GOES HERE']

/*********************************END******************************************/
dm 'log';