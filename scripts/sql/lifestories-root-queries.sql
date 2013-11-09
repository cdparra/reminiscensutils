# Number of mementos and types by story of a person
select l.life_event_id, l.headline, l.text, count(m.memento_id), concat(m.type) 
from Life_Event l
	left outer join Memento m on m.life_event_id=l.life_event_id 
	join Participant p on p.life_event_id = l.life_event_id
where 
	p.person_id = 66
group by l.life_event_id, l.headline;

# Files by User
select * from File where user_id = 65 order by creation_date desc;

# Life Events of a Person
select *
from Life_Event l
where life_event_id in 
(select life_event_id from Participant
where 
person_id = 66);

# Select an specific Fuzzy-Date to fix
select * from Fuzzy_Date where fuzzy_date_id=15655;








# FIXING QUERIES

# Select an specific Memento to fix
update Memento set type = "audio" WHERE memento_id = 486;

# Life stories of a person for his BOOK
select l.life_event_id,l.headline, l.text, m.memento_id, m.file_name, m.url, 
	m.file_hashcode, f.uri
from Life_Event l
	left outer join Memento m on m.life_event_id=l.life_event_id 
	join Participant p on p.life_event_id = l.life_event_id
	join File f on f.hashcode = m.file_hashcode
where 
#	m.url =""
#	m.file_hashcode is not null;
person_id=66
;





# query to fix mementos without url that cause an error in tablet app
update Life_Event l
	left outer join Memento m on m.life_event_id=l.life_event_id 
	join Participant p on p.life_event_id = l.life_event_id
	join File f on f.hashcode = m.file_hashcode
set m.url = f.uri,m.thumbnail_url=f.thumbnail_uri,m.file_name=f.filename
where 
#	m.url=""
	m.file_name is null
	and m.file_hashcode is not null;

select * from File where user_id=75;



# life stories of a person
select l.life_event_id,l.headline, l.text, m.memento_id, m.file_name, m.url, 
	m.file_hashcode, f.uri
from Life_Event l
	left outer join Memento m on m.life_event_id=l.life_event_id 
	join Participant p on p.life_event_id = l.life_event_id
	join File f on f.hashcode = m.file_hashcode
where 
#	m.url =""
	m.file_hashcode is not null
and p.person_id=76;


select * from Memento where file_name like 'http%';

select * from Memento where url like '%localhost%';

update Memento set url = replace(url,"http://localhost/","http://test.reminiscens.me/") where url like '%localhost%';
update File set large_uri = replace(large_uri,"http://localhost/","http://test.reminiscens.me/") where large_uri like '%localhost%';

select * from Memento where file_name is null and file_hashcode is not null;


# query to fix mementos without url that cause an error in tablet app
update Life_Event l
	left outer join Memento m on m.life_event_id=l.life_event_id 
	join Participant p on p.life_event_id = l.life_event_id
	join File f on f.hashcode = m.file_hashcode
set l.contributor_id = 75 
where 
#	m.url=""
	p.person_id = 76;

select * from File where user_id=75;