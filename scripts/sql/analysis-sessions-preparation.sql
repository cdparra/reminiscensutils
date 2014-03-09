# Get sessions ordered by week
select * from Reminiscence_Sessions rs order by rs.narrator_user_id,rs.week;

# Get sessions of families
select * from Reminiscence_Sessions 
where narrator_name in ('Pia Pedergnana','Giulio Flessati','Carla Bevilacqua')
order by narrator_name;

select session_id,narrator_name, narrator2_user_id, narrator2_name,listener_user_id, listener_age,listener_name, week, total_weeks, cumulative_weeks
from Reminiscence_Sessions
order by narrator_name, week;

# GET number of weeks of the trio
select narrator_user_id, narrator2_user_id, listener_user_id, count(*) 
from Reminiscence_Sessions
where done='SI'
group by narrator_user_id, narrator2_user_id, listener_user_id;

# UPDATES 

# Families in the study
update Reminiscence_Sessions set family = 0;
update Reminiscence_Sessions set family = 1
where narrator_name in 
('Pia Pedergnana','Giulio Flessati','Carla Bevilacqua');


# Add narrator2 to reminiscence sessions
# 1. cleanup narrator2 
update Reminiscence_Sessions rs
set rs.narrator2_user_id = null,
rs.narrator2_name = null,
rs.narrator2_age = null,
rs.narrator2_gender = null,
rs.narrator2_birthdate = null;

# Link sessions and second narrators (narrator2)
update Reminiscence_Sessions rs, User u, User narrator
set rs.narrator2_user_id = u.user_id, 
rs.narrator2_name = u.fullname,
rs.narrator2_age = u.age,
rs.narrator2_gender = u.gender,
rs.narrator2_birthdate = u.birthdate
where narrator.user_id = rs.narrator_user_id 
and u.person_id = narrator.person_id
and u.user_id <> narrator.user_id
and u.conf_type = 'narrator2';

# Link listener to reminiscence sessions (when no info about the listener is available in the session)
update Reminiscence_Sessions rs, User u, User narrator
set rs.listener_user_id = u.user_id, 
rs.listener_name = u.fullname,
rs.listener_age = u.age,
rs.listener_gender = u.gender,
rs.listener_birthdate = u.birthdate
where narrator.user_id = rs.narrator_user_id 
and u.person_id = narrator.person_id
and u.user_id <> narrator.user_id
and u.conf_type = 'listener';

# Add listener to reminiscence sessions (when the listener user id is available in session)
update Reminiscence_Sessions rs, User u
set 
	rs.listener_name = u.fullname,
	rs.listener_age = u.age,
	rs.listener_gender = u.gender,
	rs.listener_birthdate = u.birthdate
where u.user_id = rs.listener_user_id
and u.conf_type = 'listener'
and rs.listener_age is null;


# Add age, gender, birthdate to narrator in reminiscence sessions
update Reminiscence_Sessions rs, User narrator
set rs.narrator_name = narrator.fullname,
rs.narrator_age = narrator.age,
rs.narrator_gender = narrator.gender,
rs.narrator_birthdate = narrator.birthdate
where narrator.user_id = rs.narrator_user_id 
and narrator.conf_type = 'narrator';


# Update number of weeks of the trio

update Reminiscence_Sessions set narrator2_user_id = 0 where narrator2_user_id is null;

update Reminiscence_Sessions as rs
	left join (
		select count(t.narrator_user_id) as tot_weeks, t.narrator_user_id as a, t.narrator2_user_id as b, t.listener_user_id as c
		from  Reminiscence_Sessions t
		where t.done='SI' 
		group by t.narrator_user_id, t.narrator2_user_id, t.listener_user_id
	) as rs1
		on rs.narrator_user_id = rs1.a 
		and rs.narrator2_user_id = rs1.b
		and rs.listener_user_id = rs1.c
set rs.total_weeks = rs1.tot_weeks;

select appversion,count(*) from Reminiscence_Sessions where done = 'SI' group by appversion;


# Update 
update Reminiscence_Sessions set appversion = 'Tutto 2' where appversion = 'Tutto v2';

update Reminiscence_Sessions 
set appversion_number = 1, appversion_number2 = 1 
where appversion = 'Personale';

update Reminiscence_Sessions 
set appversion_number = 2, appversion_number2 = 2
where appversion = 'Senza Contesto';

update Reminiscence_Sessions 
set appversion_number = 3, appversion_number2 = 3
where appversion = 'Senza Domande';

update Reminiscence_Sessions 
set appversion_number = 3, appversion_number2 = 5
where appversion = 'Senza Domande 2';

update Reminiscence_Sessions 
set appversion_number = 4, appversion_number2 = 4
where appversion = 'Tutto';

update Reminiscence_Sessions 
set appversion_number = 4, appversion_number2 = 6
where appversion = 'Tutto 2';




# Get sessions ordered by week
select rs.session_id, rs.listener_user_id,rs.week,rs.date,rs.listener_name from Reminiscence_Sessions rs order by rs.session_id,rs.narrator_user_id, rs.week;

select count(*),creation_date from Life_Event group by creation_date;




select * from Reminiscence_Sessions;

select * from Life_Event where creation_date is null;



