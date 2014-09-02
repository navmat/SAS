proc means data=nojs  noprint nway;
   class day_bucket  amt_bucket;
   output out=summ_nojs (drop=_:)
      mean(hold_days) = days_mean
      median(hold_days) = days_med
      mean(amt_wa)=amt_wa_mean
      median(amt_wa)=amt_wa_med
      sum(acct_cnt)=
      sum(interest_wa)=
   ;
run;
