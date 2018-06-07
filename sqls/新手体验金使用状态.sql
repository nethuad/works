select case when does_use_status in (0,3) then '未使用' 
    when does_use_status=1 then '使用' 
    when does_use_status=2 then '使用并领取' 
    end as 新手体验金使用状态
,count(1) as members 
from xueshandai.dbo.new_comer_borrow_invest
where date_created>='2018-03-01'
group by case when does_use_status in (0,3) then '未使用' when does_use_status=1 then '使用' when does_use_status=2 then '使用并领取' end


-- does_use_status:  NOT_USE("未使用"), 1-USE("已使用"), 2-DONE("奖励已发放"), 3-OVERDUE("已过期")