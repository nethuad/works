
1、18活动总表 (activity18)

字段：ID、活动名称、开始日期、结束日期、抽奖次数、分享次数、状态（0-待生效，1-生效；2-已停止）

参数	类型	是否为空	说明
id	bigint	N	ID，自动增长，步长为1
activity_name	nvarchar(200)	N	活动名称
start_date	datetime2(7)	N	开始日期（先最小，后期待定）
end_date	datetime2(7)	N	结束日期（先最大，后期待定）
lottery_num	int	N	抽奖次数（正常次数），默认为0，最小0
share_num	int	Y	分享次数（额外次数），默认为0，最小0
status	int	Y	状态（0-待生效，1-生效；2-已停止）
date_created	datetime2(7)	Y	创建时间
last_updated	datetime2(7)	Y	修改时间
created_by	bigint	Y	创建人
updated_by	bigint	Y	修改人
version	bigint	Y	版本


2、18活动限时增值比例表(activity18rate)

字段：ID、总表ID、周期类型(cycle_type)、周期（cycle）、限时增值比例、限时增值天数、允许使用红包、允许使用增值券、备注

参数	类型	是否为空	说明
id	bigint	N	ID，自动增长，步长为1
activity18_id	bigint	N	总表ID
cycle	int	N	周期（cycle）
cycle_type	int		周期单位（1：天；2：月）
rate	numeric(19, 4)	N	限时增值比例
rate_day	int	N	限时增值天数
allow_red	bit	N	默认允许（0:不，1：可以）
allow_rate	bit	N	默认允许（0:不，1：可以）
remark	nvarchar(300)	Y	备注
date_created	datetime2(7)	Y	创建时间
last_updated	datetime2(7)	Y	修改时间
created_by	bigint	Y	创建人
updated_by	bigint	Y	修改人
version	bigint	Y	版本



3、18活动限时增值收益明细 (activity18interest)

字段：ID、标ID、投资记录ID、投资人ID、限时增值比例ID、限时增值比例、限时增值收益，计划发放日期、实际发放日期、状态（0-待满标、1-已流标、2-待发放、3-已发放）

参数	类型	是否为空	说明
id	bigint	N	ID，自动增长，步长为1
borrow_id	bigint	N	标id
invest_id	bigint	N	投资记录ID
member_id	bigint	N	投资人id
activity18rate_id	bigint	N	限时增值比例ID
rate	numeric(19, 4)	N	限时增值比例
interest	numeric(19, 2)	N	限时增值收益
need_give_time	datetime2(7)	Y	计划发放日期
give_time	datetime2(7)	Y	实际发放日期
status	int	N	状态（0-待满标、1-已流标、2-待发放、3-已发放）
date_created	datetime2(7)	Y	创建时间
last_updated	datetime2(7)	Y	修改时间
created_by	bigint	Y	创建人
updated_by	bigint	Y	修改人
version	bigint	Y	版本


4、18活动奖品设置表(activity18prize)

字段：ID、总表ID、奖品类别（1-红包、2-实物奖励）、奖品ID、奖品说明、比例、备注

参数	类型	是否为空	说明
id	bigint	N	ID，自动增长，步长为1
activity18_id	bigint	N	总表ID
prize_type	int	N	奖品类别（1-红包、2-实物奖励）
batch_id	bigint	Y	红包批次ID(当1的时候不能为空，2的时候可以)
prize_name	nvarchar(100)	N	奖品名称
prize_num	int	N	比例（整数）
remark	nvarchar(300)	Y	备注
date_created	datetime2(7)	Y	创建时间
last_updated	datetime2(7)	Y	修改时间
created_by	bigint	Y	创建人
updated_by	bigint	Y	修改人
version	bigint	Y	版本



5、red_envelopes 拓展表字段

奖品类别（1-红包、2-实物奖励）、奖品说明

参数	类型	是否为空	说明
award_type	int	Y	奖品类型默认为0，（0：红包，1：实物）
award_name	nvarchar(200)	Y	放实物奖品的名称
batch_id	bigint	Y	优惠劵批次id


-- 
select count(distinct open_id) as 活动人数
,count(distinct user_open_id) as 助力人数
,count(distinct case when user_open_id is not null then open_id else null end) as 被助力人数
from weixin_activity where active_type=2

=====
查询：

-------------查询总的配置------

select * from activity18


------------查询抽奖配置---------

select * from activity18prize

-----------查询利息配置---

select * from activity18rate

---------查询获取的利息----

select * from activity18interest

--------查询-红包组---

select * from red_envelopes where type='3'


-----查询抽奖--

select * from red_envelopes where type='3' and member_id is not null

select member_id,COUNT(*) from red_envelopes where type='3' and member_id is not null group by member_id

--查看实物---

select member_id,COUNT(*) from red_envelopes where type='3' and award_type='1' and member_id is not null group by member_id
select face_value,COUNT(*) from red_envelopes where type='3' and member_id is not null group by face_value

----查询-红包-
select * from card_coupons_batch order by id desc

select * from card_coupons_detail where batch_id between 392 and 397 and member_id is not null

select amount,count(*) from card_coupons_detail where batch_id between 392 and 397 and member_id is not null group by amount


------------核查对应的红包下发情况------(不包括实物)--------------

select * from card_coupons_detail where batch_id between 392 and 397 and member_id is not null

select all_memberId,red_member_id,c_member_id,rct,crct from (
select member_id as all_memberId from card_coupons_detail where batch_id between 392 and 397 and member_id is not null

union 
select member_id as all_memberId from red_envelopes where type='3' and award_type !='1' and member_id is not null

) al left join (
select member_id as red_member_id,count(*) rct from red_envelopes where type='3' and award_type !='1' and member_id is not null group by member_id
) r on al.all_memberId = r.red_member_id left join (

select member_id as c_member_id,count(*) crct from card_coupons_detail where batch_id between 392 and 397 and member_id is not null group by member_id

) cr on al.all_memberId = cr.c_member_id



