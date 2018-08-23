
SELECT a.id as member_id,a.reg_time as '注册时间'
,b.sid
,CASE WHEN b.sid IN ('mtimount', 'wtimount') THEN '天芒云' 
WHEN b.sid IN ('mmojifen', 'wmojifen') THEN '魔积分' 
WHEN b.sid IN ('mthomson', 'wthomson') THEN '汤姆逊' 
WHEN b.sid IN ('mqishuo', 'wqishuo') THEN '祺硕'
WHEN b.sid IN ('mairuix', 'wairuix') THEN '艾瑞星'
WHEN b.sid IN ('myingdie', 'wyingdie') THEN '映蝶'
when b.sid like '%p2peye%' THEN '网贷天眼'
else b.sid END AS '渠道来源'
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
where ( b.sid IN ('mtimount', 'wtimount')
or b.sid in ('mmojifen','wmojifen')
or b.sid in ('mthomson','wthomson')
or b.sid in ('mqishuo','wqishuo')
or b.sid in ('mairuix','wairuix')
or b.sid in ('myingdie','wyingdie')
or b.sid like '%p2peye%'
)


