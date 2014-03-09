select * from Study_Participants where user_id in (67,144);


select * from Study_Participants;
select * from Mood_Log;
select user_id,fullname,q_social_index from Study_Participants;
select * from User;

# '139','91','Lisa Vanoni','24','1989-08-21 00:00:00',NULL,NULL,NULL,NULL,'0','0',NULL,NULL,'listener',NULL,'1','1','1','F'

	select count(rs.session_id) as scount,rs.narrator_user_id as uid, sp.fullname
	from Study_Participants sp, Reminiscence_Sessions rs
	where 
		sp.user_id = rs.narrator_user_id 
		and rs.done = 'SI'
	group by sp.user_id, sp.fullname;

    select count(rs.session_id) as scount,rs.narrator2_user_id as uid, sp.fullname
	from Study_Participants sp, Reminiscence_Sessions rs
	where 
		sp.user_id = rs.narrator2_user_id 
		and rs.done = 'SI'
	group by sp.user_id, sp.fullname;


	select count(rs.session_id) as scount,rs.listener_user_id as uid, sp.fullname
	from Study_Participants sp, Reminiscence_Sessions rs
	where 
		sp.user_id = rs.listener_user_id 
		and rs.done = 'SI'
	group by sp.user_id, sp.fullname;

