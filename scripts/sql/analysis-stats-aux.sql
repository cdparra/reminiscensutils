# Stats for reminiscence sessions
# 1 - Duration of sessions
select starttime,endtime,round(time_to_sec(timediff(endtime,starttime))/60/60,2) as duration 
from Reminiscence_Sessions;

#'CLOSE','51'
#'CONTEXT_READ','185'
#'CONTEXT_REFRESH','415'
#'DETAILVIEWS','84'
#'FILE_NEW','433'
#'LOGIN','109'
#'MEMENTO_DELETE','7'
#'OPEN','102'
#'PUBLIC_MEMENTO_NEW','10'
#'QUESTION_ANSWER','36'
#'QUESTION_READ','890'
#'SIGNUP','1'
#'STORY_DELETE','2'
#'STORY_MODIFY','238'
#'STORY_NEW','283'
#'TIMELINE_READ','215'
#'VIEWS','3030'


# File counts per date
select count(*),date(creation_date) from File 
group by date(creation_date);

# 2 - Log Items
select * from Reminiscence_Sessions rs
left join (
	select l.session_id as sid,count(*) as log_items 
	from Log l
	group by l.session_id
) as ljoin
on rs.session_id = ljoin.sid;

# User stats 
select * from User;

# Participants of the study
#'Alessandro Ercolani'
#'Alicia Recalde'
#'Alma Meggio'
#'Amanda Liriti'
#'Annalisa Zanfranceschi'
#'Antonietta Bevilacqua'
#'Antonio La Barba'
#'Antonio Zambella'
#'Maria Greca'
#'Beatrice Valeri'
#'Bruna Giovanini'
#'Carla Bevilacqua'
#'Carlos Rodriguez'
#'Damiano Flessati'
#'Delsi Ayala'
#'Elena Baldo'
#'Fiorenza Flessati'
#'Germana Franceschini'
#'Giulio Flessati'
#'Iole Gregori'
#'Isotta Biasi'
#'Laura Folgheraiter'
#'Lisa Vanoni'
#'Luis Flessati'
#'María Antonia Ravanelli'
#'Maria Grazia'
#'Maria Zanon'
#'Paolina Santini'
#'Pia Perdegnana'
#'Raffaella Keller'
#'Roberto Casagranda'
#'Sara Vescovi'
#'Teresa Gottardi'
#'Sergio Torri'
#'Valentina Zanata'

select * from User where user_id > 68 order by fullname;
select * from User where user_id in (69,70,73,75,77,78,79,83,96,98,100,103,104,105,106);


# 3 - Created stories
# --> All Stories created in each reminiscence session
(select rs.session_id, rs.narrator_name, rs.week,le.headline, le.life_event_id, 
	date(le.creation_date) as creation, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join User u on rs.narrator_user_id = u.user_id
	join Participant p on u.person_id = p.person_id
	join Life_Event_Log le on p.life_event_id = le.life_event_id
where 
	rs.done = 'SI'
	and le.action = 'create'
	and hour(ADDTIME(le.creation_date, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(le.creation_date, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(le.creation_date, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
order by rs.narrator_name, rs.week) 

union 
 
(select rs.session_id, rs.narrator_name, rs.week,le.headline, le.life_event_id, 
	date(le.creation_date) as creation, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join User u on rs.narrator_user_id = u.user_id
	join Participant p on u.person_id = p.person_id
	join Life_Event_Log le on p.life_event_id = le.life_event_id
where 
	rs.done = 'SI'
	and le.action = 'create'
	and hour(ADDTIME(le.creation_date, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(le.creation_date, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(le.creation_date, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
order by rs.narrator_name, rs.week);

# --> Stories counts created in each reminiscence session
(
select rs.session_id, rs.narrator_name, rs.week, 
	date(le.creation_date) as creation, count(le.life_event_id)#,  rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join User u on rs.narrator_user_id = u.user_id
	join Participant p on u.person_id = p.person_id
	join Life_Event_Log le on p.life_event_id = le.life_event_id
where 
	rs.done = 'SI'
	and le.action = 'create'
	and hour(ADDTIME(le.creation_date, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(le.creation_date, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(le.creation_date, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
group by rs.session_id, rs.narrator_name, rs.week, date(le.creation_date)
order by rs.narrator_name, rs.week
) 

union 
 
(select rs.session_id, rs.narrator_name, rs.week, 
	date(le.creation_date) as creation, count(le.life_event_id)#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join User u on rs.narrator_user_id = u.user_id
	join Participant p on u.person_id = p.person_id
	join Life_Event_Log le on p.life_event_id = le.life_event_id
where 
	rs.done = 'SI'
	and le.action = 'create'
	and hour(ADDTIME(le.creation_date, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(le.creation_date, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(le.creation_date, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
group by rs.session_id, rs.narrator_name, rs.week, date(le.creation_date)
order by rs.narrator_name, rs.week)
order by narrator_name, week;


# editions, update of stories

(
select rs.session_id, rs.narrator_name, rs.week, 
	date(le.creation_date) as creation, count(le.life_event_id)#,  rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join User u on rs.narrator_user_id = u.user_id
	join Participant p on u.person_id = p.person_id
	join Life_Event_Log le on p.life_event_id = le.life_event_id
where 
	rs.done = 'SI'
	and le.action = 'update'
	and hour(ADDTIME(le.creation_date, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(le.creation_date, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(le.creation_date, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
group by rs.session_id, rs.narrator_name, rs.week, date(le.creation_date)
order by rs.narrator_name, rs.week
) 

union 
 
(select rs.session_id, rs.narrator_name, rs.week, 
	date(le.creation_date) as creation, count(le.life_event_id)#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join User u on rs.narrator_user_id = u.user_id
	join Participant p on u.person_id = p.person_id
	join Life_Event_Log le on p.life_event_id = le.life_event_id
where 
	rs.done = 'SI'
	and le.action = 'update'
	and hour(ADDTIME(le.creation_date, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(le.creation_date, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(le.creation_date, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
group by rs.session_id, rs.narrator_name, rs.week, date(le.creation_date)
order by rs.narrator_name, rs.week)
order by narrator_name, week;



# delections
(
select rs.session_id, rs.narrator_name, rs.week, 
	date(le.creation_date) as creation, count(le.life_event_id)#,  rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join User u on rs.narrator_user_id = u.user_id
	join Participant p on u.person_id = p.person_id
	join Life_Event_Log le on p.life_event_id = le.life_event_id
where 
	rs.done = 'SI'
	and le.action = 'delete'
	and hour(ADDTIME(le.creation_date, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(le.creation_date, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(le.creation_date, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
group by rs.session_id, rs.narrator_name, rs.week, date(le.creation_date)
order by rs.narrator_name, rs.week
) 

union 
 
(select rs.session_id, rs.narrator_name, rs.week, 
	date(le.creation_date) as creation, count(le.life_event_id)#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join User u on rs.narrator_user_id = u.user_id
	join Participant p on u.person_id = p.person_id
	join Life_Event_Log le on p.life_event_id = le.life_event_id
where 
	rs.done = 'SI'
	and le.action = 'delete'
	and hour(ADDTIME(le.creation_date, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(le.creation_date, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(le.creation_date, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
group by rs.session_id, rs.narrator_name, rs.week, date(le.creation_date)
order by rs.narrator_name, rs.week)
order by narrator_name, week;

select distinct(action) from Life_Event_Log;

# --> Stories counts created in each reminiscence session
(
select rs.session_id, rs.narrator_name, rs.week, 
	date(le.creation_date) as creation, count(le.life_event_id)#,  rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join User u on rs.narrator_user_id = u.user_id
	join Participant p on u.person_id = p.person_id
	join Life_Event_Log le on p.life_event_id = le.life_event_id
where 
	rs.done = 'SI'
	and le.action = 'create'
	and hour(ADDTIME(le.creation_date, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(le.creation_date, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(le.creation_date, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
group by rs.session_id, rs.narrator_name, rs.week, date(le.creation_date)
order by rs.narrator_name, rs.week
) 

union 
 
(select rs.session_id, rs.narrator_name, rs.week, 
	date(le.creation_date) as creation, count(le.life_event_id)#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join User u on rs.narrator_user_id = u.user_id
	join Participant p on u.person_id = p.person_id
	join Life_Event_Log le on p.life_event_id = le.life_event_id
where 
	rs.done = 'SI'
	and le.action = 'create'
	and hour(ADDTIME(le.creation_date, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(le.creation_date, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(le.creation_date, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
group by rs.session_id, rs.narrator_name, rs.week, date(le.creation_date)
order by rs.narrator_name, rs.week)
order by narrator_name, week;


select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as deleted_stories#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'STORY_DELETE'
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
	group by rs.session_id, rs.narrator_name, rs.week, date(l.time);



# ---> deleted stories

(select rs.session_id, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id)#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'STORY_DELETE'
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
order by rs.narrator_name, rs.week)
union
(select rs.session_id, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id)#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'STORY_DELETE'
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
order by rs.narrator_name, rs.week);


# ---> question_views

(select rs.session_id, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id)#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'STORY_DELETE'
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
order by rs.narrator_name, rs.week)
union
(select rs.session_id, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id)#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'STORY_DELETE'
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
order by rs.narrator_name, rs.week);


# ----> pictures posted!

# --> All Stories created in each reminiscence session
(select rs.session_id, rs.narrator_name, rs.week, f.filename, 
	date(f.creation_date) as creation, rs.date, rs.starttime, rs.endtime, time(f.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join File f on rs.narrator_user_id = f.user_id
where 
	rs.done = 'SI'
	and hour(ADDTIME(f.creation_date, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(f.creation_date, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(f.creation_date, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
order by rs.narrator_name, rs.week) 

union 
 
(select rs.session_id, rs.narrator_name, rs.week, f.filename, 
	date(f.creation_date) as creation, rs.date, rs.starttime, rs.endtime, time(f.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join File f on rs.narrator_user_id = f.user_id
where 
	rs.done = 'SI'
	and hour(ADDTIME(f.creation_date, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(f.creation_date, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(f.creation_date, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
order by rs.narrator_name, rs.week);



select rs.narrator_name,ml.total from Reminiscence_Sessions rs
join Mood_Log ml 
  on rs.session_id = ml.session_id
  and rs.narrator_name=ml.person_name
where 
  rs.done='SI'
  and moment='Dopo Incontro';

select distinct person_name from Mood_Log;
select distinct moment from Mood_Log;
select * from Mood_Log where moment = 'Durante Settimana';


select rs.narrator_name,rs.week,avg(ml.total) from Reminiscence_Sessions rs
join Mood_Log ml 
  on rs.week = ml.week
  and rs.narrator_name=ml.person_name
where 
  rs.done='SI'
  and moment='Durante Settimana'
group by rs.narrator_name,rs.week;


select * from Context;
select * from User where user_id > 65;
select 
	user_id, person_id, group_id, context_id, fullname, role, type, birthdate, age
from Study_Participants;

select 
*
from Study_Participants;

select min(firstrs.date) as firts_session,max(lastrs.date) as last_session, sp.user_id, sp.fullname
from Study_Participants sp, Reminiscence_Sessions firstrs, Reminiscence_Sessions lastrs
where 
	(
		sp.user_id = firstrs.narrator_user_id 
		or sp.user_id = firstrs.narrator2_user_id 
		or sp.user_id = firstrs.listener_user_id
	) and (
		sp.user_id = lastrs.narrator_user_id 
		or sp.user_id = lastrs.narrator2_user_id 
		or sp.user_id = lastrs.listener_user_id
	) 
	and lastrs.done = 'SI'
	and firstrs.done = 'SI'
group by sp.user_id, sp.fullname;

	

select count(l.life_event_id) as number_stories,l.contributor_id
from Life_Event_Log l
where l.action='create'
group by l.contributor_id;