-- for 张海峰

select convert(varchar(7),date_created,120) as ym,card_num
,count(1) as nums
,count(distinct member_id) as member_num
FROM [xueshandai].[dbo].[mobile_pay_record]
group by convert(varchar(7),date_created,120),card_num
FROM [xueshandai].[dbo].[mobile_pay_record]