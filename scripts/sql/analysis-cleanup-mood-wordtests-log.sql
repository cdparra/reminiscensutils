select * from Mood_Log;
select * from Word_Tests;


select m.* from Mood_Log m
where m.session_id is null
and moment = 'Dopo Incontro';


update Mood_Log m, Reminiscence_Sessions rs 
set m.session_id = rs.session_id
where ((m.person_name = rs.narrator_name) 
	or (m.person_name = rs.narrator2_name)
	or (m.person_name = rs.listener_name))
and m.week = rs.week
and day(m.datetime)=day(rs.date)
and month(m.datetime)=month(rs.date)
and year(m.datetime)=year(rs.date)
and m.session_id is null;




update Word_Tests wt, Reminiscence_Sessions rs 
set wt.session_id = rs.session_id
where ((wt.person_name = rs.narrator_name) 
	or (wt.person_name = rs.narrator2_name)
	or (wt.person_name = rs.listener_name))
and wt.week = rs.week
and day(wt.datetime)=day(rs.date)
and month(wt.datetime)=month(rs.date)
and year(wt.datetime)=year(rs.date)
and wt.session_id is null;

select m.* from Word_Tests m
where m.session_id is null;


