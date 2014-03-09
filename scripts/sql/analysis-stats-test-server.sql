# Stats for reminiscence sessions

# 1 - Duration of sessions
update Reminiscence_Sessions set duration = round(time_to_sec(timediff(endtime,starttime))/60/60,2) where duration = 0;

# 2 - Log Items
update Reminiscence_Sessions rs
left join (
	select l.session_id as sid,count(*) as log_items 
	from Log l
	group by l.session_id
) as ljoin
on rs.session_id = ljoin.sid
set rs.log_traffic = ljoin.log_items
where ljoin.log_items is not null;

# 3 - Created stories
# --> count stories before time zone change in server
update Reminiscence_Sessions r
left join
(
  select rs.session_id as sid, date(le.creation_date) as creation, count(le.life_event_id) as created_stories
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
  group by rs.session_id, date(le.creation_date)
) as session_stories on r.session_id = session_stories.sid
set r.stat_stories = session_stories.created_stories
where session_stories.created_stories is not null;


# --> count stories after time zone change in server
update Reminiscence_Sessions r
left join
(
  select rs.session_id as sid, date(le.creation_date) as creation, count(le.life_event_id) as created_stories
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
) as session_stories on r.session_id = session_stories.sid
set r.stat_stories = session_stories.created_stories
where session_stories.created_stories is not null;

# 4 - Updated stories
# --> count stories before time zone change in server
update Reminiscence_Sessions r
left join
(
  select rs.session_id as sid, date(le.creation_date) as creation, count(*) as created_stories
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
  group by rs.session_id, date(le.creation_date)
) as session_stories on r.session_id = session_stories.sid
set r.stat_editions = session_stories.created_stories
where session_stories.created_stories is not null;


# --> count stories after time zone change in server
update Reminiscence_Sessions r
left join
(
  select rs.session_id as sid, date(le.creation_date) as creation, count(*) as created_stories
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
) as session_stories on r.session_id = session_stories.sid
set r.stat_editions = session_stories.created_stories
where session_stories.created_stories is not null;



# 5 - Deleted stories
# --> count stories before time zone change in server
update Reminiscence_Sessions r
left join
(
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
	group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
) as session_stories on r.session_id = session_stories.sid
set r.stat_deletions= session_stories.deleted_stories
where session_stories.deleted_stories is not null;


# --> count stories after time zone change in server
update Reminiscence_Sessions r
left join
(
select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as deleted_stories#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
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
)as session_stories on r.session_id = session_stories.sid
set r.stat_deletions= session_stories.deleted_stories
where session_stories.deleted_stories is not null;



# 2 - Created stories (from log)
# --> count stories before time zone change in server
update Reminiscence_Sessions r
left join
(
  select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as scount#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'STORY_NEW'
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
	group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
) as session_stories on r.session_id = session_stories.sid
set r.stat_stories_from_log= session_stories.scount
where session_stories.scount is not null;


# --> count stories after time zone change in server
update Reminiscence_Sessions r
left join
(
select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as scount#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'STORY_NEW'
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
)as session_stories on r.session_id = session_stories.sid
set r.stat_stories_from_log= session_stories.scount
where session_stories.scount is not null;


# 6 - Question Views
# --> count before time zone change in server
update Reminiscence_Sessions r
left join
(
  select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as scount#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'QUESTION_READ'
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
	group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
) as session_stories on r.session_id = session_stories.sid
set r.stat_questions_views= session_stories.scount
where session_stories.scount is not null;


# --> count  after time zone change in server
update Reminiscence_Sessions r
left join
(
select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as scount#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'QUESTION_READ'
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
)as session_stories on r.session_id = session_stories.sid
set r.stat_questions_views= session_stories.scount
where session_stories.scount is not null;


# 7 - Question Answer
# --> count before time zone change in server
update Reminiscence_Sessions r
left join
(
  select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as scount#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'QUESTION_ANSWER'
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
	group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
) as session_stories on r.session_id = session_stories.sid
set r.stat_questions_answered= session_stories.scount
where session_stories.scount is not null;


# --> count  after time zone change in server
update Reminiscence_Sessions r
left join
(
select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as scount#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'QUESTION_ANSWER'
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
)as session_stories on r.session_id = session_stories.sid
set r.stat_questions_answered= session_stories.scount
where session_stories.scount is not null;

# 8 - Memento Views
# --> count before time zone change in server
update Reminiscence_Sessions r
left join
(
  select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as scount#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'VIEWS'
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
	group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
) as session_stories on r.session_id = session_stories.sid
set r.stat_public_memento_views= session_stories.scount
where session_stories.scount is not null;


# --> count  after time zone change in server
update Reminiscence_Sessions r
left join
(
select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as scount#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'VIEWS'
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
)as session_stories on r.session_id = session_stories.sid
set r.stat_public_memento_views= session_stories.scount
where session_stories.scount is not null;


# 9 - Memento Detail Views
# --> count before time zone change in server
update Reminiscence_Sessions r
left join
(
  select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as scount#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'DETAILVIEWS'
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
	group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
) as session_stories on r.session_id = session_stories.sid
set r.stat_public_memento_detail_views= session_stories.scount
where session_stories.scount is not null;


# --> count  after time zone change in server
update Reminiscence_Sessions r
left join
(
select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as scount#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'DETAILVIEWS'
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
)as session_stories on r.session_id = session_stories.sid
set r.stat_public_memento_detail_views= session_stories.scount
where session_stories.scount is not null;

# 4 - Updated stories from log
# --> count before time zone change in server
update Reminiscence_Sessions r
left join
(
  select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as scount#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'STORY_MODIFY'
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
	group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
) as session_stories on r.session_id = session_stories.sid
set r.stat_editions_from_log= session_stories.scount
where session_stories.scount is not null;


# --> count  after time zone change in server
update Reminiscence_Sessions r
left join
(
select rs.session_id as sid, rs.narrator_name, rs.week, 
	date(l.time) as creation, count(l.log_id) as scount#, rs.date, rs.starttime, rs.endtime, time(le.creation_date) as creation_time
from Reminiscence_Sessions rs 
	join Log l on rs.narrator_user_id = l.user_id
where 
	rs.done = 'SI'
	and l.action = 'STORY_MODIFY'
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(l.time, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(l.time, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
group by rs.session_id, rs.narrator_name, rs.week, date(l.time)
)as session_stories on r.session_id = session_stories.sid
set r.stat_editions_from_log= session_stories.scount
where session_stories.scount is not null;







# 10 - Pictures
# --> count before time zone change in server
update Reminiscence_Sessions r
left join
(
  select rs.session_id as sid, date(f.creation_date) as creation, count(f.filename) as scount
from Reminiscence_Sessions rs 
	join File f on rs.narrator_user_id = f.user_id
where 
	rs.done = 'SI'
	and hour(ADDTIME(f.creation_date, '0 6:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(f.creation_date, '0 6:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(f.creation_date, '0 6:0:0.000000'))=rs.date
	and date(rs.date)<=date('2013-10-26')
  group by rs.session_id, date(f.creation_date)
) as session_stories on r.session_id = session_stories.sid
set r.stat_pictures = session_stories.scount
where session_stories.scount is not null;


update Reminiscence_Sessions r
left join 
(  select rs.session_id as sid, date(f.creation_date) as creation, count(f.filename) as scount
from Reminiscence_Sessions rs 
	join File f on rs.narrator_user_id = f.user_id
where 
	rs.done = 'SI'
	and hour(ADDTIME(f.creation_date, '0 5:0:0.000000'))>=hour(rs.starttime)-2
	and hour(ADDTIME(f.creation_date, '0 5:0:0.000000'))<=hour(rs.endtime)+2
	and date(ADDTIME(f.creation_date, '0 5:0:0.000000'))=rs.date
	and date(rs.date)>=date('2013-10-27')
  group by rs.session_id, date(f.creation_date)
) as session_stories on r.session_id = session_stories.sid
set r.stat_pictures = session_stories.scount
where session_stories.scount is not null;




# 11 - Narrator mood after session
Update Reminiscence_Sessions rs
join Mood_Log ml 
  on rs.session_id = ml.session_id
  and rs.narrator_name=ml.person_name
set mood_after_narrator = ml.total
where 
  rs.done='SI'
  and moment='Dopo Incontro'
  and ml.total is not null;


# 12 - Narrator2 mood after session
Update Reminiscence_Sessions rs
join Mood_Log ml 
  on rs.session_id = ml.session_id
  and rs.narrator2_name=ml.person_name
set mood_after_narrator2 = ml.total
where 
  rs.done='SI'
  and moment='Dopo Incontro'
  and ml.total is not null;


# 13 - Listener mood after session
Update Reminiscence_Sessions rs
join Mood_Log ml 
  on rs.session_id = ml.session_id
  and rs.listener_name=ml.person_name
set mood_after_listener = ml.total
where 
  rs.done='SI'
  and moment='Dopo Incontro'
  and ml.total is not null;

# 11 - Narrator mood before session
Update Reminiscence_Sessions rs
join Mood_Log ml 
  on rs.session_id = ml.session_id
  and rs.narrator_name=ml.person_name
set mood_before_narrator = ml.total
where 
  rs.done='SI'
  and moment='Prima Incontro'
  and ml.total is not null;


# 12 - Narrator2 mood after session
Update Reminiscence_Sessions rs
join Mood_Log ml 
  on rs.session_id = ml.session_id
  and rs.narrator2_name=ml.person_name
set mood_before_narrator2 = ml.total
where 
  rs.done='SI'
  and moment='Prima Incontro'
  and ml.total is not null;


# 13 - Listener mood after session
Update Reminiscence_Sessions rs
join Mood_Log ml 
  on rs.session_id = ml.session_id
  and rs.listener_name=ml.person_name
set mood_before_listener = ml.total
where 
  rs.done='SI'
  and moment='Prima Incontro'
  and ml.total is not null;


# 11 - Narrator mood during week before session
Update Reminiscence_Sessions rss
left join (
select rs.narrator_name,rs.week,round(avg(ml.total),2) as mood_avg from Reminiscence_Sessions rs
join Mood_Log ml 
  on rs.week = ml.week
  and rs.narrator_name=ml.person_name
where 
  rs.done='SI'
  and moment='Durante Settimana'
group by rs.narrator_name,rs.week) as jointable on rss.narrator_name = jointable.narrator_name and rss.week=jointable.week
set mood_week_narrator = jointable.mood_avg
where 
  rss.done='SI'
  and jointable.mood_avg is not null;

# 12 - Narrator2 mood during week before session
Update Reminiscence_Sessions rss
left join (
select rs.narrator2_name,rs.week,round(avg(ml.total),2) as mood_avg from Reminiscence_Sessions rs
join Mood_Log ml 
  on rs.week = ml.week
  and rs.narrator2_name=ml.person_name
where 
  rs.done='SI'
  and moment='Durante Settimana'
group by rs.narrator2_name,rs.week) as jointable on rss.narrator2_name = jointable.narrator2_name and rss.week=jointable.week
set mood_week_narrator2 = jointable.mood_avg
where 
  rss.done='SI'
  and jointable.mood_avg is not null;


# 13 - Listener mood during week before session
Update Reminiscence_Sessions rss
left join (
select rs.listener_name,rs.week,round(avg(ml.total),2) as mood_avg from Reminiscence_Sessions rs
join Mood_Log ml 
  on rs.week = ml.week
  and rs.listener_name=ml.person_name
where 
  rs.done='SI'
  and moment='Durante Settimana'
group by rs.listener_name,rs.week) as jointable on rss.listener_name = jointable.listener_name and rss.week=jointable.week
set mood_week_listener = jointable.mood_avg
where 
  rss.done='SI'
  and jointable.mood_avg is not null;



# cleanup


update Reminiscence_Sessions 
set stat_stories = 0 
where stat_stories is null;

update Reminiscence_Sessions 
set stat_stories_from_log = 0 
where stat_stories_from_log is null;

update Reminiscence_Sessions 
set stat_editions = 0 
where stat_editions is null;

update Reminiscence_Sessions 
set stat_editions_from_log = 0 
where stat_editions_from_log is null;

update Reminiscence_Sessions 
set stat_deletions = 0 
where stat_deletions is null;

update Reminiscence_Sessions 
set stat_pictures = 0 
where stat_pictures is null;

update Reminiscence_Sessions 
set stat_questions_views = 0 
where stat_questions_views is null;

update Reminiscence_Sessions 
set stat_questions_answered= 0 
where stat_questions_answered is null;

update Reminiscence_Sessions 
set stat_public_memento_views = 0 
where stat_public_memento_views is null;

update Reminiscence_Sessions 
set stat_public_memento_detail_views = 0 
where stat_public_memento_detail_views is null;

######
update Reminiscence_Sessions 
set mood_week_narrator = 0 
where mood_week_narrator is null;
update Reminiscence_Sessions 
set mood_week_narrator2 = 0 
where mood_week_narrator2 is null;
update Reminiscence_Sessions 
set mood_week_listener = 0 
where mood_week_listener is null;


update Reminiscence_Sessions 
set mood_before_narrator = 0 
where mood_before_narrator is null;
update Reminiscence_Sessions 
set mood_before_narrator2 = 0 
where mood_before_narrator2 is null;
update Reminiscence_Sessions 
set mood_before_listener = 0 
where mood_before_listener is null;


update Reminiscence_Sessions 
set mood_after_narrator = 0 
where mood_after_narrator is null;
update Reminiscence_Sessions 
set mood_after_narrator2 = 0 
where mood_after_narrator2 is null;
update Reminiscence_Sessions 
set mood_after_listener = 0 
where mood_after_listener is null;


# ######################## PARTICIPANTS STATS

# update gender in study participants
update Study_Participants sp, User u set sp.gender = u.gender 
where sp.user_id = u.user_id;

# update first and last sessions of participants
update Study_Participants p 
left join (
	select min(firstrs.date) as first_session,max(lastrs.date) as last_session, sp.user_id, sp.fullname
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
	group by sp.user_id, sp.fullname
) as sessions
on p.user_id = sessions.user_id
set p.first_session = sessions.first_session, p.last_session = sessions.last_session
where sessions.last_session is not null and sessions.first_session is not null;

# update session count of participants
update Study_Participants p 
left join (
	select count(rs.session_id) as scount,rs.narrator_user_id as uid, sp.fullname
	from Study_Participants sp, Reminiscence_Sessions rs
	where 
		sp.user_id = rs.narrator_user_id 
		and rs.done = 'SI'
	group by sp.user_id, sp.fullname
) as sessions
on p.user_id = sessions.uid
set p.stat_sessions = sessions.scount
where sessions.scount is not null;


update Study_Participants p 
left join (
	select count(rs.session_id) as scount,rs.narrator2_user_id as uid, sp.fullname
	from Study_Participants sp, Reminiscence_Sessions rs
	where 
		sp.user_id = rs.narrator2_user_id 
		and rs.done = 'SI'
	group by sp.user_id, sp.fullname
) as sessions
on p.user_id = sessions.uid
set p.stat_sessions = sessions.scount
where sessions.scount is not null;


update Study_Participants p 
left join (
	select count(rs.session_id) as scount,rs.listener_user_id as uid, sp.fullname
	from Study_Participants sp, Reminiscence_Sessions rs
	where 
		sp.user_id = rs.listener_user_id 
		and rs.done = 'SI'
	group by sp.user_id, sp.fullname
) as sessions
on p.user_id = sessions.uid
set p.stat_sessions = sessions.scount
where sessions.scount is not null;

# update missed session count of participants
update Study_Participants p 
set p.stat_missed_sessions = 8 - p.stat_sessions
where p.type = 'Stabile';

# update missed session count of participants
update Study_Participants p 
set p.stat_missed_sessions = 4 - p.stat_sessions
where p.type = 'Pilot';

# update missed session count of participants
update Study_Participants p 
set p.stat_missed_sessions = 1 - p.stat_sessions
where p.type = '1-Volta';

# update total stories count of participants
update Study_Participants p 
left join (
select count(*) as number_stories,u.user_id
from Life_Event l, Participant p, User u
where l.life_event_id = p.life_event_id and p.person_id = u.person_id
group by u.user_id
) as life_stories
on p.user_id = life_stories.user_id
set p.stat_stories = life_stories.number_stories
where life_stories.number_stories is not null;

# update total editions count of participants
update Study_Participants p 
left join (
select count(*) as number_stories,l.contributor_id
from Life_Event_Log l
where l.action='update'
group by l.contributor_id
) as life_stories
on p.user_id = life_stories.contributor_id
set p.stat_editions = life_stories.number_stories
where life_stories.number_stories is not null;


# update total editions count of participants
update Study_Participants p 
left join (
select count(*) as number_stories,l.user_id
from Log l
where l.action='STORY_MODIFY'
group by l.user_id
) as life_stories
on p.user_id = life_stories.user_id
set p.stat_editions = life_stories.number_stories
where life_stories.number_stories is not null;


# update total editions count of participants
update Study_Participants p 
left join (
select count(*) as number_stories,l.user_id
from Log l
where l.action='STORY_DELETE'
group by l.user_id
) as life_stories
on p.user_id = life_stories.user_id
set p.stat_deletions = life_stories.number_stories
where life_stories.number_stories is not null;


# update total stories count of participants in session
update Study_Participants p 
left join (
select sum(rs.stat_stories) as number_stories,rs.narrator_user_id
from Reminiscence_Sessions rs
group by rs.narrator_user_id
) as life_stories
on p.user_id = life_stories.narrator_user_id
set p.stat_stories_session = life_stories.number_stories
where life_stories.number_stories is not null;

update Study_Participants p 
left join (
select sum(rs.stat_stories) as number_stories,rs.narrator2_user_id
from Reminiscence_Sessions rs
group by rs.narrator2_user_id
) as life_stories
on p.user_id = life_stories.narrator2_user_id
set p.stat_stories_session = life_stories.number_stories
where life_stories.number_stories is not null;

update Study_Participants p 
left join (
select sum(rs.stat_stories) as number_stories,rs.listener_user_id
from Reminiscence_Sessions rs
group by rs.listener_user_id
) as life_stories
on p.user_id = life_stories.listener_user_id
set p.stat_stories_session = life_stories.number_stories
where life_stories.number_stories is not null;

# update total stories modifications count of participants in session
update Study_Participants p 
left join (
select sum(rs.stat_editions) as number_stories,rs.narrator_user_id
from Reminiscence_Sessions rs
group by rs.narrator_user_id
) as life_stories
on p.user_id = life_stories.narrator_user_id
set p.stat_editions_session = life_stories.number_stories
where life_stories.number_stories is not null;

update Study_Participants p 
left join (
select sum(rs.stat_editions) as number_stories,rs.narrator2_user_id
from Reminiscence_Sessions rs
group by rs.narrator2_user_id
) as life_stories
on p.user_id = life_stories.narrator2_user_id
set p.stat_editions_session = life_stories.number_stories
where life_stories.number_stories is not null;

update Study_Participants p 
left join (
select sum(rs.stat_editions) as number_stories,rs.listener_user_id
from Reminiscence_Sessions rs
group by rs.listener_user_id
) as life_stories
on p.user_id = life_stories.listener_user_id
set p.stat_editions_session = life_stories.number_stories
where life_stories.number_stories is not null;

# update total stories deletions count of participants in session
update Study_Participants p 
left join (
select sum(rs.stat_deletions) as number_stories,rs.narrator_user_id
from Reminiscence_Sessions rs
group by rs.narrator_user_id
) as life_stories
on p.user_id = life_stories.narrator_user_id
set p.stat_deletions_session = life_stories.number_stories
where life_stories.number_stories is not null;

update Study_Participants p 
left join (
select sum(rs.stat_deletions) as number_stories,rs.narrator2_user_id
from Reminiscence_Sessions rs
group by rs.narrator2_user_id
) as life_stories
on p.user_id = life_stories.narrator2_user_id
set p.stat_deletions_session = life_stories.number_stories
where life_stories.number_stories is not null;

update Study_Participants p 
left join (
select sum(rs.stat_deletions) as number_stories,rs.listener_user_id
from Reminiscence_Sessions rs
group by rs.listener_user_id
) as life_stories
on p.user_id = life_stories.listener_user_id
set p.stat_deletions_session = life_stories.number_stories
where life_stories.number_stories is not null;


# update total number of pictures for user
update Study_Participants p 
left join (
select count(*) as number_pictures, f.user_id
from File f
group by f.user_id
) as pictures
on p.user_id = pictures.user_id
set p.stat_pictures = pictures.number_pictures
where pictures.number_pictures is not null;

# update total pictures count of participants in session
update Study_Participants p 
left join (
select sum(rs.stat_pictures) as number_stories,rs.narrator_user_id
from Reminiscence_Sessions rs
group by rs.narrator_user_id
) as life_stories
on p.user_id = life_stories.narrator_user_id
set p.stat_pictures_session = life_stories.number_stories
where life_stories.number_stories is not null;

update Study_Participants p 
left join (
select sum(rs.stat_pictures) as number_stories,rs.narrator2_user_id
from Reminiscence_Sessions rs
group by rs.narrator2_user_id
) as life_stories
on p.user_id = life_stories.narrator2_user_id
set p.stat_pictures_session = life_stories.number_stories
where life_stories.number_stories is not null;

update Study_Participants p 
left join (
select sum(rs.stat_pictures) as number_stories,rs.listener_user_id
from Reminiscence_Sessions rs
group by rs.listener_user_id
) as life_stories
on p.user_id = life_stories.listener_user_id
set p.stat_pictures_session = life_stories.number_stories
where life_stories.number_stories is not null;

# cleanup number of stories stats

update Study_Participants p
set p.stat_pictures_session = 0 
where p.stat_pictures_session is null;

update Study_Participants p
set p.stat_stories_session = 0
where p.stat_stories_session is null;

update Study_Participants p
set p.stat_editions_session = 0
where p.stat_editions_session is null;

update Study_Participants p
set p.stat_deletions_session = 0
where p.stat_deletions_session is null;


update Study_Participants p
set p.stat_pictures = p.stat_pictures_session 
where p.stat_pictures is null;

update Study_Participants p
set p.stat_stories = p.stat_stories_session 
where p.stat_stories is null;

update Study_Participants p
set p.stat_editions = p.stat_editions_session 
where p.stat_editions is null;

update Study_Participants p
set p.stat_deletions = p.stat_deletions_session 
where p.stat_deletions is null;


update Study_Participants p
set p.stat_pictures = p.stat_pictures + p.stat_pictures_session 
where p.stat_pictures < p.stat_pictures_session;


update Study_Participants p
set p.stat_stories = p.stat_stories + p.stat_stories_session 
where p.stat_stories < p.stat_stories_session;

update Study_Participants p
set p.stat_editions =p.stat_editions + p.stat_editions_session 
where p.stat_editions < p.stat_editions_session;

update Study_Participants p
set p.stat_deletions =p.stat_deletions + p.stat_deletions_session 
where p.stat_deletions < p.stat_deletions_session;

# Questions answered in session
update Study_Participants p 
left join (
select sum(rs.stat_questions_answered) as scount,rs.narrator_user_id
from Reminiscence_Sessions rs
group by rs.narrator_user_id
) as sessions
on p.user_id = sessions.narrator_user_id
set p.stat_questions_answered_session = sessions.scount
where sessions.scount is not null;

update Study_Participants p 
left join (
select sum(rs.stat_questions_answered) as scount,rs.narrator2_user_id
from Reminiscence_Sessions rs
group by rs.narrator2_user_id
) as sessions
on p.user_id = sessions.narrator2_user_id
set p.stat_questions_answered_session = sessions.scount
where sessions.scount is not null;

update Study_Participants p 
left join (
select sum(rs.stat_questions_answered) as scount,rs.listener_user_id
from Reminiscence_Sessions rs
group by rs.listener_user_id
) as sessions
on p.user_id = sessions.listener_user_id
set p.stat_questions_answered_session = sessions.scount
where sessions.scount is not null;

update Study_Participants p set stat_questions_answered_session = 0
where stat_questions_answered_session is null;


# Questions answered total
update Study_Participants p 
left join (
select count(*) as scount,l.user_id
from Log l
where l.action='QUESTION_ANSWER'
group by l.user_id
) as log_items
on p.user_id = log_items.user_id
set p.stat_questions_answered = log_items.scount
where log_items.scount is not null;

update Study_Participants p 
set p.stat_questions_answered = 0
where p.stat_questions_answered is null;

update Study_Participants p 
set p.stat_questions_answered = p.stat_questions_answered_session
where p.stat_questions_answered < p.stat_questions_answered_session;


# Public Memento views in sessions
update Study_Participants p 
left join (
select sum(rs.stat_public_memento_views) as scount,rs.narrator_user_id
from Reminiscence_Sessions rs
group by rs.narrator_user_id
) as sessions
on p.user_id = sessions.narrator_user_id
set p.stat_public_memento_views_session = sessions.scount
where sessions.scount is not null;

update Study_Participants p 
left join (
select sum(rs.stat_public_memento_views) as scount,rs.narrator2_user_id
from Reminiscence_Sessions rs
group by rs.narrator2_user_id
) as sessions
on p.user_id = sessions.narrator2_user_id
set p.stat_public_memento_views_session = sessions.scount
where sessions.scount is not null;

update Study_Participants p 
left join (
select sum(rs.stat_public_memento_views) as scount,rs.listener_user_id
from Reminiscence_Sessions rs
group by rs.listener_user_id
) as sessions
on p.user_id = sessions.listener_user_id
set p.stat_public_memento_views_session = sessions.scount
where sessions.scount is not null;

update Study_Participants p set stat_public_memento_views_session = 0
where stat_public_memento_views_session is null;


# Public memento views totals
update Study_Participants p 
left join (
select count(*) as scount,l.user_id
from Log l
where l.action='VIEWS'
group by l.user_id
) as log_items
on p.user_id = log_items.user_id
set p.stat_public_memento_views = log_items.scount
where log_items.scount is not null;

update Study_Participants p 
set p.stat_public_memento_views = 0
where p.stat_public_memento_views is null;

update Study_Participants p 
set p.stat_public_memento_views = p.stat_public_memento_views_session
where p.stat_public_memento_views < p.stat_public_memento_views_session;



# Public Memento Detail views in sessions
update Study_Participants p 
left join (
select sum(rs.stat_public_memento_detail_views) as scount,rs.narrator_user_id
from Reminiscence_Sessions rs
group by rs.narrator_user_id
) as sessions
on p.user_id = sessions.narrator_user_id
set p.stat_public_memento_detail_views_session = sessions.scount
where sessions.scount is not null;

update Study_Participants p 
left join (
select sum(rs.stat_public_memento_detail_views) as scount,rs.narrator2_user_id
from Reminiscence_Sessions rs
group by rs.narrator2_user_id
) as sessions
on p.user_id = sessions.narrator2_user_id
set p.stat_public_memento_detail_views_session = sessions.scount
where sessions.scount is not null;

update Study_Participants p 
left join (
select sum(rs.stat_public_memento_detail_views) as scount,rs.listener_user_id
from Reminiscence_Sessions rs
group by rs.listener_user_id
) as sessions
on p.user_id = sessions.listener_user_id
set p.stat_public_memento_detail_views_session = sessions.scount
where sessions.scount is not null;

update Study_Participants p set stat_public_memento_detail_views_session = 0
where stat_public_memento_detail_views_session is null;


# Public memento views totals
update Study_Participants p 
left join (
select count(*) as scount,l.user_id
from Log l
where l.action='DETAILVIEWS'
group by l.user_id
) as log_items
on p.user_id = log_items.user_id
set p.stat_public_memento_detail_views = log_items.scount
where log_items.scount is not null;

update Study_Participants p 
set p.stat_public_memento_detail_views = 0
where p.stat_public_memento_detail_views is null;

update Study_Participants p 
set p.stat_public_memento_detail_views = p.stat_public_memento_detail_views_session
where p.stat_public_memento_detail_views < p.stat_public_memento_detail_views_session;



# Log items in sessions
update Study_Participants p 
left join (
select sum(rs.log_traffic) as scount,rs.narrator_user_id
from Reminiscence_Sessions rs
group by rs.narrator_user_id
) as sessions
on p.user_id = sessions.narrator_user_id
set p.stat_log_items_session = sessions.scount
where sessions.scount is not null;

update Study_Participants p 
left join (
select sum(rs.log_traffic) as scount,rs.narrator2_user_id
from Reminiscence_Sessions rs
group by rs.narrator2_user_id
) as sessions
on p.user_id = sessions.narrator2_user_id
set p.stat_log_items_session = sessions.scount
where sessions.scount is not null;

update Study_Participants p 
left join (
select sum(rs.log_traffic) as scount,rs.listener_user_id
from Reminiscence_Sessions rs
group by rs.listener_user_id
) as sessions
on p.user_id = sessions.listener_user_id
set p.stat_log_items_session = sessions.scount
where sessions.scount is not null;

update Study_Participants p set stat_log_items_session = 0
where stat_log_items_session is null;


# Public memento views totals
update Study_Participants p 
left join (
select count(*) as scount,l.user_id
from Log l
group by l.user_id
) as logfull
on p.user_id = logfull.user_id
set p.stat_log_items = logfull.scount
where logfull.scount is not null;

update Study_Participants p 
set p.stat_log_items = 0
where p.stat_log_items is null;

update Study_Participants p 
set p.stat_log_items = p.stat_log_items_session
where p.stat_log_items < p.stat_log_items_session;
