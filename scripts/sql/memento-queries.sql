
update Memento m, File f 
	set m.thumbnail_url = f.filename, m.file_name=f.filename 
where 
	m.thumbnail_url = 0 
	and m.file_hashcode=f.hashcode;


select life_event_id,headline from Life_Event where headline like "%Mamma e papa%";
select * from Memento where url like "%U_65_D2013-09-27T09:16:10.670-04:00_%";

update Memento m set life_event_id=272 where m.memento_id = 152;

delete from Life_Event where life_event_id = 270;






select l.life_event_id, l.headline, count(m.memento_id) 
from Life_Event l
	left outer join Memento m on m.life_event_id=l.life_event_id 
	join Participant p on p.life_event_id = l.life_event_id
where 
	p.person_id = 66
group by l.life_event_id, l.headline;



select * from Memento ;
