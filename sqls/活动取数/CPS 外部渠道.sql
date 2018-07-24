SELECT a.id as member_id,a.reg_time as '注册时间'
,CASE WHEN b.sid IN ('mtimount', 'wtimount') THEN '天芒云' else '其他' END AS '渠道来源'
,c.date_created as '首次投资时间',c.capital AS '首次投资金额', c.cycle AS '首次投资期限'
from member a 
inner join register_attach_info b on a.id=b.register_user_id
left outer join (
    select * from (
    select a.*,b.cycle
    ,ROW_NUMBER() OVER (PARTITION BY investor_id ORDER BY a.date_created asc) as rown
    from borrow_invest a 
    inner join borrow b on a.borrow_id=b.id
    where b.status in (4,5,6)
    ) a where rown=1
) c on a.id=c.investor_id
where b.sid IN ('mtimount', 'wtimount')




