drop table if exists member_info_map;
create table member_info_map as 
select member_id,birthday,age,gender,current_address
from (
select id,member_id
,substring(birthday from 1 for 10) as birthday
,EXTRACT(EPOCH FROM ( now()-birthday::TIMESTAMP )) /60/60/24/365 as age
,substring(gender from '[男女]') as gender
,current_address
,ROW_NUMBER() OVER(PARTITION BY member_id ORDER BY id desc) as  rown
from member_info
) a 
inner join member b on a.member_id=b.id
where rown=1 and b.is_valid_idcard
;

