select * from Public_Memento where category in ("STORY") 
and resource_url is null;

select distinct category from Public_Memento;

select count(*) from Public_Memento where resource_url is null;

select category,sum(views),sum(detail_views),sum(stories) 
from Context_Public_Memento where views > 0
group by category;

select count(l.life_event_id),l.question_id, q.category, q.chapter
from Life_Event l, Question q
where l.question_id = q.question_id
group by q.question_id, q.category, q.chapter
order by count(life_event_id) desc;


select count(l.life_event_id), count(distinct l.question_id), q.category
from Life_Event l, Question q
where l.question_id = q.question_id
group by q.category
order by count(life_event_id) desc;


select count(l.life_event_id),count(distinct l.question_id), q.chapter
from Life_Event l, Question q
where l.question_id = q.question_id
group by q.chapter
order by count(life_event_id) desc;







select count(l.life_event_id),count(distinct l.public_memento_id), p.category
from Life_Event l, Public_Memento p
where l.public_memento_id = p.public_memento_id
group by p.category
order by count(life_event_id) desc;


select l.public_memento_id, p.category, p.headline, p.text, p.resource_url, l.headline, l.text
from Life_Event l, Public_Memento p
where l.public_memento_id = p.public_memento_id;



select category,count(*) from Public_Memento
group by category;


select source,count(*) from Public_Memento
group by source;


select f.decade,count(*) from Public_Memento p, Fuzzy_Date f
where p.fuzzy_startdate = f.fuzzy_date_id
group by f.decade;



select count(*) from Public_Memento p, Fuzzy_Date f
where p.fuzzy_startdate = f.fuzzy_date_id
and f.decade<1900;
