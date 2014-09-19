***************************************************************************************;

*Proc sql code to create a table;
proc sql;
   create table [out_dataset] as
      select [* or distinct]     
         [var1],
         [var2],
         [var3]
      from [in_dataset]
      /*Only sort if necessary!*/
      order by [by_var1], [by_var2]
   ;
quit;

***************************************************************************************;

*Proc sql code for a join;
proc sql;
   create table [out_dataset] as
      select      
         a.[a_var1],
         a.[a_var2],
         b.[b_var1],
         b.[b_var2]
      from [merge_dataset_1] a [left/right/inner/full] join [merge_dataset_2] b
      /*Warning! Duplicate key values will result in Cartesian product and may break SAS*/
      on (a.[key_1a] = b.[key_1b]) and (a.[key_2a] = b.[key_2b])
      /*Only sort if necessary!*/
      order by [by_var1], [by_var2], [by_var3]
   ;
quit;

***************************************************************************************;

*Proc sql code to create a macro list variabl;
proc sql noprint;
   select [select_var]
      into :[macrolist] separated by ' '
      from [dataset]
   ;
quit;

%put &[macrolist].;

***************************************************************************************;

*example proc sql code received from Max Clarke;



proc sql;
	create table PA_type_Summary as 
	Select BILLING_TYPE_DESC, CONDITION_CLASS_DESC, REDACTED
			, count(*) as records 
			, count(distinct a.invoice_ln_id) as Invoice_ln_IDs
			, sum(case when CONDITION_VALUE < 0 then 1 else 0 end) as Negative_Value
			, sum(case when CONDITION_VALUE > 0 then 1 else 0 end) as Positive_Value
			, sum(case when b.record_type_desc = "Purchase" then 1 else 0 end) as Purchase_invoices
			, sum(case when b.record_type_desc = "Chargeback" then 1 else 0 end) as Chargeback_invoices
			, sum(case when b.record_type_desc = "Price_Adjustment" then 1 else 0 end) as PriceAdj_invoices
			, sum(case when b.record_type_desc = "Return" then 1 else 0 end) as Return_invoices
	from in.price_adjustments a
		join in.direct_sales b
			on a.invoice_ln_id = b.invoice_ln_id 
	group by BILLING_TYPE_DESC, CONDITION_CLASS_DESC, REDACTED 
	having Negative_Value > 0 or Positive_Value > 0;
quit;


proc sql;
	create table REDACTED_indirect2 as 
	Select ACTUAL_CUSTOMER_NAME , payer_name , REDACTED, CUSTOMER_ADDR_LN1, CUSTOMER_CITY, CUSTOMER_STATE
		, count(*) as records
		, sum(ACTUAL_QTY) as REDACTED
		, sum(case when prxmatch('/REDACTED/i',PRODUCT_DESC) then ACTUAL_QTY end) as REDACTED
	from REDACTED_indirect
	group by ACTUAL_CUSTOMER_NAME , payer_name , REDACTED, CUSTOMER_ADDR_LN1, CUSTOMER_CITY, CUSTOMER_STATE;
quit;

*Indexes!!!!, make joins and where clauses orders of magnitude faster;
proc sql; create index payer_num on san.direct_sales_intermediate(payer_num); quit;







proc sql;
	create table REDACTED_custs_direct as 
	select customer_num, customer_name, CUSTOMER_ADDR_LN1, CUSTOMER_CITY, CUSTOMER_STATE_CD, CUSTOMER_ZIP_BASE
		, sum(case when product_family_desc = "REDACTED" and year(order_dt) = 2010 then Doses_shipped end) as REDACTED_10
		, sum(case when product_family_desc = "REDACTED" and year(order_dt) = 2011 then Doses_shipped end) as REDACTED_11
		, sum(case when product_family_desc = "REDACTED" and year(order_dt) = 2012 then Doses_shipped end) as REDACTED_12
		, sum(case when product_family_desc = "REDACTED" and year(order_dt) = 2013 then Doses_shipped end) as REDACTED_13
		, CUSTOMER_DEA_NUM
	from san.direct_sales_intermediate
	where CONTRACT_NUM in (417518,419879,420593,422549) and record_type_desc = 'Purchase' and year(order_dt) >= 2010
	group by customer_num, customer_name, CUSTOMER_ADDR_LN1, CUSTOMER_CITY, CUSTOMER_STATE_CD, CUSTOMER_ZIP_BASE, 
	having sum(case when record_type_desc = 'Purchase' and period="During" then 1 else 0 end) > 0 ;
quit;










