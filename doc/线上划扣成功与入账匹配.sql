select v.CONTRACT_NUM||v.LOAN_BELONG as LOAN_ID from (select trunc(o1.rsp_receive_time) res_date, o1.loan_id, o1.actual_amount
  from offer_transaction o1
 where o1.rsp_receive_time > trunc(sysdate) -1 
   and o1.create_time < trunc(sysdate)
   and o1.rtn_code in ('000000', '444444')
union all   
select trunc(o2.res_time) res_date, o2.loan_id, o2.actual_amount
  from debit_transaction o2
 where o2.res_time > trunc(sysdate) -1 
   and o2.res_time < trunc(sysdate)
   and o2.rtn_code in ('000000', '444444')) t join v_loan_info v on v.id = t.loan_id
where not exists
   (
select 1
  from offer_repay_info o
 where o.trade_date >= trunc(sysdate) -1 
   and o.trade_date < trunc(sysdate)
   and o.trade_code in ('1001', '3001')
   and o.trade_type not in ('转账', '挂账', '现金')
   and o.loan_id = t.loan_id and o.amount = t.actual_amount and o.trade_date = t.res_date
   )
   
   
  select  v.CONTRACT_NUM||v.LOAN_BELONG as loan_id
  from offer_repay_info o join v_loan_info v on v.id = o.loan_id
 where o.trade_date >= trunc(sysdate) -1 
   and o.trade_date < trunc(sysdate)
   and o.trade_code in ('1001', '3001')
   and o.trade_type not in ('转账', '挂账', '现金')
   and not exists (
   select 1 from (select trunc(o1.rsp_receive_time) res_date, o1.loan_id, o1.actual_amount
  from offer_transaction o1
 where o1.rsp_receive_time > trunc(sysdate) -1 
   and o1.create_time < trunc(sysdate)
   and o1.rtn_code in ('000000', '444444')
union all   
select trunc(o2.res_time) res_date, o2.loan_id, o2.actual_amount
  from debit_transaction o2
 where o2.res_time > trunc(sysdate) -1 
   and o2.res_time < trunc(sysdate)
   and o2.rtn_code in ('000000', '444444')) t 
   where o.loan_id = t.loan_id and o.amount = t.actual_amount and o.trade_date = t.res_date
   )