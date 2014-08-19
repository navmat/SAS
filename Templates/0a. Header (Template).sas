***********************************ROOT************************************************;
%let sasroot= ["SAS root file path"];

***********************************OPTIONS*********************************************;
options noquotelenmax mprint center compress=yes mlogic symbolgen notes source
sortequals source2 nonumber nodate yearcutoff=1920 linesize=155 pagesize=65 msglevel=i
reuse=yes obs=max pageno=1 nobyline nolabel merror ovp mautosource mrecall nofmterr;

***********************************LIBRARIES*******************************************;
*SAS datasets;
libname sasdata "&sasroot.\Datasets";

***********************************MACRO VARIABLES*************************************;
**Folders**;
*Import directory;
%let importdir= &sasroot.\Input;
*Export directory;
%let exportdir= &sasroot.\Output;

**Files**;
%let file_name= &sasroot.["File path"];

**SAS Code**;
%let import_code= &sasroot.["Import code file path"];
%let export_code= &sasroot.["Export code file path"];

***********************************MACROS**********************************************;
%include "&sasroot.[Macro code file path]";

***********************************END*************************************************;
*dm 'log' clear;

