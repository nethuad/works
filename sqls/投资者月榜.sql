use xueshandai

DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @begin_date = '2018-04-01'
SET @end_date = '2018-05-01'

select a.investor_id,b.uname,a.capital,a.rown
from (
  select investor_id,capital,ROW_NUMBER() OVER(ORDER BY capital desc)  as rown
  from (
    select investor_id,sum(capital) as capital
    from borrow_invest 
    where status in (1, 3) and activate_time>=@begin_date and activate_time<@end_date
    group by investor_id
  ) a
) a
left outer join member b on a.investor_id=b.id 
where rown<=10
order by rown