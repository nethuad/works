/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [id]
      ,[account_id]
      ,[event_type_id]
      ,[change]
      ,[available_after]
      ,[freeze_after]
      ,[date_created]
      ,[last_updated]
      ,[created_by]
      ,[updated_by]
      ,[version]
      ,[data_digest]
      ,[available_before]
      ,[freeze_before]
      ,[event_source]
      ,[description]
      ,[expand1]
      ,[expand2]
      ,[is_voucher]
      ,[way]

  select b.member_id
  ,a.*
  into #1
  FROM [xueshandai].[dbo].[cash_flow] a 
  inner join (select * from account where member_id=16993 and type='cash') b on a.account_id=b.id

  select a.id
  ,member_id,m.name as moldname
  ,case when way=1 then '冻结' when way=2 then '解冻' when way=3 then '转入' when way=4 then '转出' end as way
  ,change
  ,available_after
  ,a.freeze_before
  ,a.freeze_after
  ,a.date_created
  ,a.description
  from #1 a 
  left outer join mold m on a.event_type_id=m.id
  where description like '%推荐奖励%'

  
