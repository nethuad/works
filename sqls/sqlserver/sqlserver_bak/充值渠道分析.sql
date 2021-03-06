drop table #1
select charge_way
,count(1) as c
,count(distinct member_id) as members
,sum(cash) as cash
,min(date_created) as date_s,max(date_created) as date_e
into #1
from account_recharge
where cash>0 and charge_status='3'
and date_created>='2018-01-01'
group by charge_way
order by c 

select top 10 * from account_recharge where charge_status=3 and member_id=980723

select top 10 * from account_recharge where charge_status=3 and date_created>='2018-01-01' and bank_name is null 
and charge_way in ('wgYinGuanTong')
and charge_way not in ('xxYinGuanTong','wgYinGuanTong')


select bank_name,sum(cash) as cash,count(1) as c
,sum(cash)/count(1) as mc
from account_recharge 
where charge_status=3 
and date_created>='2018-01-01'
and charge_way<>'xxYinGuanTong'
group by bank_name
order by cash desc

select * from #1 a 
inner join #rechargeway b on a.charge_way=b.waycode 

create table #rechargeway(
way varchar(100),
waycode varchar(100)
)

select * from #rechargeway

insert into #rechargeway 
values 
('存管线下还款','xxYinGuanTong'),
('新浪支付','sina'),
('宝付','baofoo'),
('融宝','reapal'),
('国付宝','gopay'),
('环讯支付','ips'),
('盛付通','shengpay'),
('网银在线','chinabank'),
('汇潮','ecpss'),
('快钱充值','kuaiqian'),
('贝付','ebatong'),
('网银在线快捷支付','chinabankquick'),
('安卓网银在线快捷支付','appchinabankquick'),
('web先锋代扣','pcxianfeng'),
('mobile先锋代扣','mxianfeng'),
('安卓先锋代扣','appxianfeng'),
('ios先锋代扣','iosappxianfeng'),
('后台先锋代扣','adminappxianfeng'),
('富友网关','fuiouwg'),
('web拉卡拉代扣','pclakala'),
('mobile拉卡拉代扣','mlakala'),
('安卓拉卡拉代扣','applakala'),
('ios拉卡拉代扣','iosapplakala'),
('后台拉卡拉代扣','adminlakala'),
('web银生宝代扣','pcyinshengbao'),
('mobile银生宝代扣','myinshengbao'),
('安卓银生宝代扣','appyinshengbao'),
('ios银生宝代扣','iosappyinshengbao'),
('后台银生宝代扣','adminyinshengbao'),
('存管快捷充值','kjYinGuanTong'),
('存管网关充值','wgYinGuanTong')

