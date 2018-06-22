drop table if exists account_cash;
create table account_cash as 
select * 
from account 
where type= 'cash'
;