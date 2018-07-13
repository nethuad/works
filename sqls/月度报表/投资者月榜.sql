use xueshandai

DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @begin_date = '2018-06-01'
SET @end_date = '2018-07-01'

select a.investor_id as 用户id
,b.uname as 用户名
,a.capital as 投资金额
,a.rown as 排名
,@begin_date as begindate,@end_date as enddate
from (
  select investor_id,capital,ROW_NUMBER() OVER(ORDER BY capital desc)  as rown
  from (
    select investor_id,sum(a.capital) as capital
    from borrow_invest a 
	inner join borrow b on a.borrow_id=b.id
	where a.status in (1, 3) and a.activate_time>=@begin_date and a.activate_time<@end_date
	and b.status in (1,4,5,6)
    group by investor_id
  ) a
) a
left outer join member b on a.investor_id=b.id 
where rown<=6
order by rown