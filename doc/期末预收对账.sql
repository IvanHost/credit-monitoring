select CONTRACT_NUM||LOAN_BELONG as CONTRACT_NUM from (select 
nvl(t1.qimoyushou,0) qimoyushou,nvl(t2.huankuang,0) huankuang ,nvl(t3.fenzhang,0) fenzhang,nvl(t4.quxian,0) quxian,nvl(t5.qimoyushou2,0) qimoyushou2,
nvl(t1.qimoyushou,0)+nvl(t2.huankuang,0)-nvl(t3.fenzhang,0)-nvl(t4.quxian,0)-nvl(t5.qimoyushou2,0) duizhang,v.id,v.CONTRACT_NUM,v.LOAN_BELONG
from v_loan_info v left join (SELECT fw.loan_id,
nvl((case when fw.appo_dorc = 'C' then nvl(fw.end_amount,0) else fw.trade_amount end ),0) AS qimoyushou
FROM offer_flow fw
where Acct_Title = '111'
and fw.id in (select max(id) id
from offer_flow
where trade_date <add_months(trunc(sysdate),-1)
GROUP BY account)) t1 on v.id = t1.loan_id
left join 
(select sum(t.amount) huankuang,t.loan_id from offer_repay_info t where t.trade_date between add_months(trunc(sysdate),-1) and trunc(sysdate)-1
and t.trade_code in ('1001','3001') group by t.loan_id) t2 on v.id = t2.loan_id
left join 
(select sum(case when a.acct_title = '452' and a.account = 'ZD0000001090000002' then -a.trade_amount
when a.acct_title = '452' and a.account <> 'ZD0000001090000002' then a.trade_amount
when a.acct_title in ('211','451','494') then a.trade_amount
when a.acct_title in ('491','492','493','481','497','483') then -a.trade_amount else 0 end) fenzhang,loan_id
from offer_flow a where a.trade_date between add_months(trunc(sysdate),-1) and trunc(sysdate)-1 and a.trade_code in ('1001','3001')
and a.acct_title in ('452','211','451','494','491','492','493','481','497','483') group by loan_id) t3 on v.id = t3.loan_id 
left join (
select sum(b.trade_amount) quxian,b.loan_id from offer_flow b where b.trade_date between add_months(trunc(sysdate),-1) and trunc(sysdate)-1
and b.trade_code = '1003' group by loan_id) t4 on v.id = t4.loan_id 
left join (
SELECT fw.loan_id,
nvl((case when fw.appo_dorc = 'C' then nvl(fw.end_amount,0) else fw.trade_amount end ),0) AS qimoyushou2
FROM offer_flow fw
where Acct_Title = '111'
and fw.id in (select max(id) id
from offer_flow
where trade_date <trunc(sysdate)
GROUP BY account)) t5 on v.id =t5.loan_id where v.LOAN_FLOW_STATE = 'Õý³£' ) where duizhang<>0