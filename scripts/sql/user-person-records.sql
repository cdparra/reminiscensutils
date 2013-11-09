select * from User ;
select * from Person where person_id = 6;
select * from Context;
select * from Person where person_id = 84;
select * from City where city_id = 3876;
select * from Life_Event l, Participant p 
where p.person_id = 84 and l.life_event_id = p.life_event_id;
select * from Fuzzy_Date where fuzzy_date_id=15602;
select * from Location where location_id = 2739;
select * from Context where person_for_id=71;
select * from Context_Public_Memento c, Public_Memento p
where c.public_memento_id = p.public_memento_id 
and c.context_id = 21;


select * from Public_Memento where public_memento_id in  
(select c.public_memento_id from Context_Public_Memento c
where c.context_id = 27);


select * from Context_Public_Memento where context_id = 27;

select * from Location where location_id =2710;

select * from Fuzzy_Date where fuzzy_date_id = 15632;


select * from Public_Memento order by creation_date desc;


update Public_Memento set resource_url = "http://upload.wikimedia.org/wikipedia/commons/3/3d/Tony_Renis_Primo_Piano.jpg" where resource_url = "http://it.wikipedia.org/wiki/File:Tony_Renis_Primo_Piano.jpg";