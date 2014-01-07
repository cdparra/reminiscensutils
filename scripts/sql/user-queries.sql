select * from User;

select 
	u1.email,
	u1.fullname,u1.person_id,u1.user_id,
	u2.fullname,u2.person_id,u2.user_id,
    la.provider_user_id
from User u1 right outer join User u2 
	on u1.person_id=u2.person_id and u1.user_id <> u2.user_id
	left outer join Linked_Account la 
	on u1.user_id = la.user_id

where u1.fullname like "%Admin%";


select 
	u1.email,
	u1.fullname,u1.person_id,u1.user_id,
    la.provider_user_id
from User u1 join Linked_Account la 
	on u1.user_id = la.user_id
where u1.fullname like "%Admin%";


select u1.email, u1.fullname from User u1


where u1.fullname like "%Admin%";



select * from Linked_Account;



select * from Security_Role s, User_Security_Roles us, User u 
where u.fullname like "%Admin%" 
and u.user_id = us.user_id
and us.role_id = s.role_id;


select * from Security_Role;
select * from User_Security_Roles;