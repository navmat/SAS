*** Call-asaurus Rexecute ***;
by Clark Bristol;
	* PURPOSE: to replace a 'call execute' in order to:
		- allow the use of call symput() in your macro
		- make some other issues easier to deal with;
	* CAPABILITIES: this version works for a macro with up to 10 positional parameters;
	* INSTRUCTIONS:
		- macro_name = the name of the macro that you want to invoke
		- macro_inputs_dataset = the name of the file containing the inputs to your macro
		- var1 = the name of the column in the inputs dataset that contains
		  the values that will be assigned to the 1st positional parameter of the macro
		- var2-10 are optional
		- from = the first row of the inputs dataset to be used in the macro
		- to = the last row of the inputs dataset to be used in the macro;
%macro call_rexecute(macro_name=,
					 macro_inputs_dataset=,
					 var1=,var2=,var3=,var4=,var5=,var6=,var7=,var8=,var9=,var10=,
					 from=,to=);

	data _null_;
		set &macro_inputs_dataset. (obs = &to.);
		obs = _n_;
	    call symput(compress("&var1."||obs," "),&var1.);
		%do b = 2 %to 10;
			%if &&var&b. ne %then %do;
				call symput(compress("&&var&b."||obs," "),&&var&b.);
			%end;
		%end;
		run;

	%do a = &from. %to &to.;
		%&macro_name.(&&&var1.&a.
		%do b = 2 %to 10;
			%if &&var&b. ne %then %do;
				,&&&&&&var&b&&a
			%end;
		%end;
		);
	%end;
%mend;
