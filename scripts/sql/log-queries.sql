select r.date,r.starttime,r.endtime,
	time(ADDTIME(l.time, '0 6:0:0.000000')) as logtime, 
	date(ADDTIME(l.time, '0 6:0:0.000000'))as logdate,
	l.user_id, r.user_id,
	l.* 
from Log l, Reminiscence_Sessions r
where 
#l.user_id = r.user_id
#and 
time(ADDTIME(l.time, '0 6:0:0.000000'))>=r.starttime
and time(ADDTIME(l.time, '0 6:0:0.000000'))<=r.endtime
and date(ADDTIME(l.time, '0 6:0:0.000000'))<=r.date
and session = 0
and date(ADDTIME(l.time, '0 6:0:0.000000'))>'2013-10-15'
;


update Log l, Reminiscence_Sessions r
	set l.session=1
#r.date,r.starttime,r.endtime,
#	time(ADDTIME(l.time, '0 6:0:0.000000')) as logtime, 
#	date(ADDTIME(l.time, '0 6:0:0.000000'))as logdate,
#l.* 
#from 
where l.user_id = r.narrator_user_id
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))>=hour(r.starttime)-2
    and hour(ADDTIME(l.time, '0 6:0:0.000000'))<=hour(r.endtime)+2
    and date(ADDTIME(l.time, '0 6:0:0.000000'))=r.date
    and date(r.date)<=date('2013-10-26');


update Log l, Reminiscence_Sessions r
	set l.session=1
#r.date,r.starttime,r.endtime,
#	time(ADDTIME(l.time, '0 6:0:0.000000')) as logtime, 
#	date(ADDTIME(l.time, '0 6:0:0.000000'))as logdate,
#l.* 
#from 
where l.user_id = r.narrator_user_id
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))>=hour(r.starttime)-2
    and hour(ADDTIME(l.time, '0 5:0:0.000000'))<=hour(r.endtime)+2
    and date(ADDTIME(l.time, '0 5:0:0.000000'))=r.date
    and date(r.date)>=date('2013-10-27');


select count(*),month(time), year(time), session from Log 
where user_id in (65, 67, 69, 70, 73, 75, 77, 78, 79, 83, 98, 100, 103, 104, 105, 106, 96)
group by month(time),  year(time), session;


select count(*),user_id, action from Log group by user_id, action having user_id is null;



select user_id, action, time, session, resource_uri from Log 
where month(time) in (1, 10, 11, 12) 
	and (user_id in (65, 67, 69, 70, 73, 75, 77, 78, 79, 83, 98, 100, 103, 104, 105, 106, 96) or user_id is null);


select l.user_id, l.action, l.time, l.session, l.resource_uri, count(distinct l2.user_id) 
from Log l, Log l2
where month(l.time) in (1, 10, 11, 12) 
	and l.user_id is null
	and day(l.time) = day(l2.time)
	and year(l.time) = year(l2.time)
	and month(l.time) = month(l2.time)
	and hour(l.time) = hour(l2.time)
	and minute(l.time) = minute(l2.time)
	and l2.user_id in (65, 67, 69, 70, 73, 75, 77, 78, 79, 83, 98, 100, 103, 104, 105, 106, 96)
	and l2.log_id <> l.log_id
group by 
	l.user_id, l.action, l.time, l.session, l.resource_uri
having 
	count(distinct l2.user_id) = 1
limit 100;



# Fix question logs where user_id was not stored
update Log l, Log l2 set l.user_id = l2.user_id 
where month(l.time) in (1, 10, 11, 12) 
	and l.user_id is null
	and day(l.time) = day(l2.time)
	and year(l.time) = year(l2.time)
	and month(l.time) = month(l2.time)
	and hour(l.time) = hour(l2.time)
	and minute(l.time) = minute(l2.time)
	and l2.log_id <> l.log_id
#	and l2.user_id in (65, 67, 69, 70, 73, 75, 77, 78, 79, 83, 98, 100, 103, 104, 105, 106, 96)
	and l2.user_id in (69, 70, 73, 75, 77, 78, 79, 83, 98, 100, 103, 104, 105, 106);
#	and count(distinct l2.user_id) = 1;


# Reminiscence User and Person Ids
#SET @personid := 70; # DONE: Raffaella Keller
#SET @personid := 71; # Paolina Santini
#SET @personid := 74; # Antonio Zambella
#SET @personid := 76; # Maria Greca
#SET @personid := 90; # Carla Bevilacqua
#SET @personid := 90; # Antonietta Bevilacqua
#SET @personid := 78; # Maria Grazia Frainer 
#SET @personid := 79; # DONE: Alma Meggio 
#SET @personid := 80; # Pia Pedergnana
#SET @personid := 84; # Giulio Flessati
#SET @personid := 84; # Maria Zanon
#SET @personid := 88; # Rita Lunelli
#SET @personid := 91; # Iole Gregori
#SET @personid := 94; # Teresa Gottardi
#SET @personid := 95; # Bruna Giovanini
#SET @personid := 96; # Germana Franceschini
#SET @personid := 97; # María Antonia Ravanelli


# Link session logs to session registry (with time before DST change)
update Log l, Reminiscence_Sessions rs
	set 
		l.session=1,
		l.session_id = rs.session_id
where 
	l.user_id = rs.narrator_user_id
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and day(ADDTIME(l.time, '0 6:0:0.000000'))=day(rs.date)
	and month(ADDTIME(l.time, '0 6:0:0.000000'))=month(rs.date)
	and year(ADDTIME(l.time, '0 6:0:0.000000'))=year(rs.date)
	and date(rs.date)<=date('2013-10-26')
	and rs.done = 'SI';


# Link session logs to session registry (with time after DST change)
update Log l, Reminiscence_Sessions rs
	set 
		l.session=1,
		l.session_id = rs.session_id
where 
	l.user_id = rs.narrator_user_id
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and day(ADDTIME(l.time, '0 5:0:0.000000'))=day(rs.date)
	and month(ADDTIME(l.time, '0 5:0:0.000000'))=month(rs.date)
	and year(ADDTIME(l.time, '0 5:0:0.000000'))=year(rs.date)
	and date(rs.date)>=date('2013-10-27')
	and rs.done = 'SI';