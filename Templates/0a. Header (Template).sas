/*********************************ROOT*****************************************/
%let sasroot= ['SAS ROOT FILE PATH'];

/*********************************OPTIONS**************************************/
options noquotelenmax mprint center compress=yes mlogic symbolgen notes source
sortequals source2 nonumber nodate yearcutoff=1920 linesize=155 pagesize=65 msglevel=i
reuse=yes obs=max pageno=1 nobyline nolabel merror ovp mautosource mrecall nofmterr;

/*********************************LIBRARIES************************************/
*SAS datasets;
libname sasdata "&sasroot.\Datasets";

/*********************************MACRO VARIABLES******************************/
**Folders**;
*Import directory;
%let importdir= &sasroot.\Input;
*Export directory;
%let exportdir= &sasroot.\Output;

**Files**;
%let file_name= &sasroot.['FILE PATH'];

/*********************************MACROS***************************************/
%include "&sasroot.['MACRO CODE FILE PATH']";

/*********************************END******************************************/
*dm 'log' clear;

