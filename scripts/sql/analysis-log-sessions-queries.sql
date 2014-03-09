select * from Log limit 10000;

select action,count(*) from Log where session_id is not null group by action;


select session_id,count(*) from Log 
group by session_id
order by count(*) asc;


select * from Log where session_id = 1;

select * from Reminiscence_Sessions where session_id in (7,23,58,73,6,41);
# 15 - 15.45, 2013-10-27
# 16 - 17, 2013-11-02
select hour(time),l.* from Log l
where user_id = 96
	and day(time) <=26
	and day(time) >=20
	and month(time) = 10
union 
select hour(time),l.* from Log l
where user_id = 75
	and day(time) <=25
	and day(time) >=15
	and month(time) = 10;
;



select * from Reminiscence_Sessions where narrator_user_id = 96;
select * from Reminiscence_Sessions where log_traffic is null and done='SI';
select * from Reminiscence_Sessions order by session_id;
# 25/10/2013, desde las 11 hasta las 12

# session 2 --> 30/10
# session 3 --> 15/11
select hour(time),l.* from Log l
where user_id = 96
	and day(time) <=26
	and day(time) >=20
	and month(time) = 10;

select date(time),hour(time),l.user_id,count(l.user_id) from Log l
where l.user_id = 96
group by date(time),hour(time),l.user_id;

