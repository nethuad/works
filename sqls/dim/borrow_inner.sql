create table borrow_inner as 
select 
unnest(ARRAY[
13477,
13478,
13479,
13480,
13481,
13482,
13483,
13484,
13485,
13486,
13487,
13488,
13489,
13490,
13491,
13492,
13493,
13494,
13495,
13496,
13497
]) as borrow_id
,'batch_invest'::varchar(50) as borrow_type
;