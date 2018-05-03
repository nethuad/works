-- psql  -v pt="'20180424'" -f proc-member_info.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_member_info_last;
--create table dbo_member_info_last as 
--select * 
--from dbo_member_info
--where pt=:pt
--;


drop table IF EXISTS dbo_member_info_merge;
create table dbo_member_info_merge as 
select id,member_id,birthday,gender,age,hight_degree,school,edu_start_date,marriage,has_children,has_house,has_mortgage
,has_car,has_car_loan,birth_place_id,current_address,resident_city_id,resident_telephone,person_image,date_created,last_updated
,created_by,updated_by,version,qq_num,occupation,hobby,postcode,modified_address,label_type,describe,has_contact,loan_type
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_member_info_last
union all 
select * 
from dbo_member_info_dadd
) a 
) a where rown = 1
;

--备份 dbo_member_info_last
drop table IF EXISTS dbo_member_info_last_bak;
alter table dbo_member_info_last rename to dbo_member_info_last_bak;

alter table dbo_member_info_merge rename to dbo_member_info_last;

-- 清空增量数据
DELETE FROM dbo_member_info_dadd;

--member_info
drop table IF EXISTS member_info_tmp;
create table member_info_tmp as 
select * from (
select id,member_id,birthday,gender,age,hight_degree,school,edu_start_date,marriage,has_children,has_house,has_mortgage
,has_car,has_car_loan,birth_place_id,current_address,resident_city_id,resident_telephone,person_image,date_created,last_updated
,created_by,updated_by,version,qq_num,occupation,hobby,postcode,modified_address,label_type,describe,has_contact,loan_type
,pt
,row_number() over(partition by member_id order by pt desc,last_updated desc) as rown
from dbo_member_info_last
) a where rown = 1
;

drop table IF EXISTS member_info_bak;
alter table member_info rename to member_info_bak;
alter table member_info_tmp rename to member_info;


