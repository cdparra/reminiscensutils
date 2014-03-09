select 
	user_id,
	person_id,
	fullname,
	email,
	conf_type, 
	birthdate, 
	age, 
	participations, 
	week, 
	gender

from User
where user_id > 66
#and conf_type ='narrator'
;

update User u, Person p
set u.birthdate = p.birthdate 
where u.person_id = p.person_id;

update User u
set u.age = DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(u.birthdate)), '%Y')+0;



SELECT DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(u.birthdate)), '%Y')+0 AS age_calc,
 u.birthdate, u.age, u.*
FROM User u
where user_id>66 
and conf_type is not null;

