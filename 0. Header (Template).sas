***************************************************************************************;
* Created by:   Kevin Fong                                                             ;
***********************************ROOT************************************************;
%let sasroot= [SAS root file path];

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
%let file= &sasroot.[File path];

**SAS Code**;
%let import_code= &sasroot.[Import code file path];
%let export_code= &sasroot.[Export code file path];

***********************************MACROS**********************************************; data word word;
set stuff;


%include "&sasroot.[Macro code file path]";

***********************************END*************************************************;
*dm 'log' clear;
/*
%macro test(args,);
   Code goes here!
%mend test;
#
%%include "filespec";
#comments
*/

blah
eq 
+ / 
%macro blah(%macro (args);
   Code goes here!
%mend ;
args);
   Code goes here!
%mend blah;%macro (args);
   Code goes here!
%mend ;

proc sort sort 
   out= out_dataset
   data= in_dataset
      (keep=
          var1
          var2
      )
   ;
   by var1 var2;
run;
   
            

proc means;
proc proc sort nodupkey 
   out= 
   data= in_dataset
      (keep=
          var1
          var2
      )
   ;
   by var1 var2;
run;
