select id as member_id 
into #1
from member
where id in (
131,11282,15600,22345,22346,22347,22348,22367,22369,22372,22444,22457,22462,22538,22539,22571,22804,
24523,25053,25054,25055,25936,26249,26260,26812,29187,29490,29495,29597,29600,29696,29761,30265,30357,
30514,30515,30517,31033,31073,31094,84593,84595,84596,84598,84599,84602,84603,84608,84610,85199,85200,
85201,85203,85204,85207,85209,85218,85219,85220,85356,85357,85358,85360,89600,89601,279385
)


ancl326	    未实名
suchasyou	未实名
ceshi123	未实名
kqqbb112	密码错误
babynan	    密码错误


select 
a.member_id,a.uname,a.real_name
,case when b.investor_id is null then 0 else b.should_receipt_balance end should_receipt_balance
,c.available,c.freeze
from (
  select a.id as member_id,a.real_name,a.uname,a.is_valid_idcard
  from member a 
  inner join #1 b on a.id=b.member_id
) a 
left outer join (
  select investor_id,sum(should_receipt_balance) as  should_receipt_balance
  from receipt_detail a 
  inner join #1 b on a.investor_id = b.member_id
  where a.status in (1,2)
  group by investor_id
) b on a.member_id=b.investor_id
left outer join (
  select a.member_id,a.available,a.freeze
  from account a 
  inner join #1 b on a.member_id=b.member_id
  where a.type='cash'
) c on a.member_id=c.member_id







