CREATE TABLE #member_recommend
(
    member_id bigint
)

insert into #member_recommend(member_id) values
(169633),
(185380),
(111807),
(282052),
(111804),
(188037),
(119196),
(263653),
(978644),
(542519),
(103788),
(979726),
(344605),
(218941),
(230140),
(475155),
(367405),
(521226),
(329597),
(344473),
(346819),
(399390),
(981287),
(919833),
(371),
(89545),
(40476),
(89556),
(40409),
(40412)

select * from recommend where status =2



select a.borrow_id
,a.investor_id 投资人id
,a.capital 投资金额
,a.date_created 投资时间
,a.activate_time 生效时间
,a.status
,c.cycle_type
,c.cycle as 期数
from borrow_invest a 
inner join #member_recommend b on a.investor_id=b.member_id
inner join borrow c on a.borrow_id=c.id
where a.date_created>='2018-04-01'





