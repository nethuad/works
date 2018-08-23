use xueshandai

-- 替换　2018-06-　　为　2018-07-

--------【F4整改初始机构存管规模】：截至2017年6月30日的待收总额，包括本金+利息。---

select (ac+bc)/100000000 from (

select '1' as aid,SUM(should_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') 
) a left join (
select '1' as aid,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end bc 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') and receipt_time>='2017-7-1 00:00:00' 
) b on a.aid = b.aid

-- 5.855959 

------------F5整改初始机构存量不合规业务规模】：截至2017年6月30日的待收中，所有借款超过100w元的借款人待收总额。（按之前第一种方式统计）-----

select sum(fr.cp)/100000000 from (
select loaner_id,SUM(ac) cp,sum(scpl) s_capital from (
select loaner_id,sum(capital) scpl,sum(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') group by loaner_id
union all
select loaner_id,sum(capital) scpl,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end ac 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') and receipt_time>='2017-7-1 00:00:00' group by loaner_id
) r group by loaner_id having SUM(scpl) >1000000

) fr

-- 0.722483


--------------G1月末机构存量规模】：截至2018年7月25日的待收总额--------


select (ac+bc)/100000000 from (

select '1' as aid,SUM(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') 
) a left join (
select '1' as aid,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end bc 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') and receipt_time>='2018-07-26 00:00:00' 
) b on a.aid = b.aid

--6.284147 

-------------------【G2当月存量规模变化】：=G1-截至2018年7月1日的待收总额。--------


select (g1.ct-r.ct)/100000000 from (


select '1' rid,ac,bc,(ac+bc) ct from (

select '1' as aid,SUM(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') 
) a left join (
select '1' as aid,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end bc 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') and receipt_time>='2018-07-26 00:00:00' 
) b on a.aid = b.aid

) g1,(
select '1' rid,ac,bc,(ac+bc) ct from (

select '1' as aid,SUM(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-01 00:00:00') 
) a left join (
select '1' as aid,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end bc 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-01 00:00:00') and receipt_time>='2018-07-01 00:00:00' 
) b on a.aid = b.aid
) r where g1.rid = r.rid

-- 0.020408 

 

-----------------【G3整改以来存量规模变化】：=G1-F4---------------


select (g1.ct-r.ct)/100000000 from (


select '1' rid,ac,bc,(ac+bc) ct from (

select '1' as aid,SUM(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') 
) a left join (
select '1' as aid,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end bc 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') and receipt_time>='2018-07-26 00:00:00' 
) b on a.aid = b.aid


) g1,(
select '1' rid,ac,bc,(ac+bc) ct from (

select '1' as aid,SUM(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') 
) a left join (
select '1' as aid,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end bc 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') and receipt_time>='2017-7-1 00:00:00' 
) b on a.aid = b.aid
) r where g1.rid = r.rid

-- 0.428188

-------------------【H1月末机构存量不合规业务规模】：截至2018年7月25日的待收中，所有借款超过100w元的借款人待收总额。（按之前第一种方式统计）-------


select sum(fr.cp)/100000000 from (
select loaner_id,SUM(ac) cp,sum(scpl) s_capital from (
select loaner_id,sum(capital) scpl,sum(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') group by loaner_id
union all
select loaner_id,sum(capital) scpl,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end ac 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') and receipt_time>='2018-07-26 00:00:00' group by loaner_id
) r group by loaner_id having SUM(scpl) >1000000

) fr

-- 0.047250
 

-----------------【H2当月存量不合规业务变化】：H1-截至2018年7月26日的待收中，所有借款超过100元的借款人待收总额


select(h1.ds-r.ds)/100000000 from (

select '1' rid,sum(fr.s_capital) bj,sum(fr.cp) ds from (
select loaner_id,SUM(ac) cp,sum(scpl) s_capital from (
select loaner_id,sum(capital) scpl,sum(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') group by loaner_id
union all
select loaner_id,sum(capital) scpl,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end ac 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') and receipt_time>='2018-07-26 00:00:00' group by loaner_id
) r group by loaner_id having SUM(scpl) >1000000

) fr

) h1,(

select '1' rid,sum(fr.s_capital) bj,sum(fr.cp) ds from (
select loaner_id,SUM(ac) cp,sum(scpl) s_capital from (
select loaner_id,sum(capital) scpl,sum(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail
 where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-01 00:00:00') group by loaner_id
union all
select loaner_id,sum(capital) scpl,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end ac 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-01 00:00:00') and receipt_time>='2018-07-01 00:00:00' group by loaner_id
) r group by loaner_id having SUM(scpl) >1000000

) fr

) r where h1.rid = r.rid

--- 0

 

----------------H3整改以来存量不合规业务规模变化】：H1-F5-----------

 

select (h1.ds-r.ds)/100000000 from (

select '1' rid,sum(fr.s_capital) bj,sum(fr.cp) ds from (
select loaner_id,SUM(ac) cp,sum(scpl) s_capital from (
select loaner_id,sum(capital) scpl,sum(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') group by loaner_id
union all
select loaner_id,sum(capital) scpl,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end ac 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2018-07-26 00:00:00') and receipt_time>='2018-07-26 00:00:00' group by loaner_id
) r group by loaner_id having SUM(scpl) >1000000

) fr

) h1,(

select '1' rid,sum(fr.s_capital) bj,sum(fr.cp) ds from (
select loaner_id,SUM(ac) cp,sum(scpl) s_capital from (
select loaner_id,sum(capital) scpl,sum(should_receipt_balance-fact_receipt_balance) ac 
from receipt_detail 
where status in (1,2,3) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') group by loaner_id
union all
select loaner_id,sum(capital) scpl,case when SUM(should_receipt_balance) is null then 0 else SUM(should_receipt_balance) end ac 
from receipt_detail 
where status in (4) and borrow_id in (select id from borrow where full_time<'2017-7-1 00:00:00') and receipt_time>='2017-7-1 00:00:00' group by loaner_id
) r group by loaner_id having SUM(scpl) >1000000

) fr

) r where h1.rid = r.rid

-- -0.675233




