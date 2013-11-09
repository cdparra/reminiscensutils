select * from (
(	(select distinct ci.decade, ci.category, ci.type, ci.level, i.event_id as "item_id", i.headline, i.text, i.resource_url
	from Context_Event ci, Event i 
	where ci.event_id = i.event_id
	and ci.context_id=26) 
union
	(select distinct ci.decade, ci.category, ci.type, ci.level, i.media_id as "item_id", i.headline, i.text, i.media_url
	from Context_Media ci, Media i 
	where ci.media_id = i.media_id
	and ci.context_id=26) 
union
	(select distinct ci.decade, ci.category, ci.type, ci.level, i.famous_id as "item_id", i.fullname, i.famous_for, i.picture_url as "resource_url"
	from Context_Famous ci, Famous_Person i 
	where ci.famous_id = i.famous_id
	and ci.context_id=26) 
union
	(select distinct ci.decade, ci.category, ci.type, ci.level, i.work_id as "item_id", i.title as "headline", i.description as "text", i.resource_url
	from Context_Works  ci, Works i 
	where ci.work_id = i.work_id
	and ci.context_id=26) 
union
	(select distinct ci.decade, ci.category, ci.type, ci.level, i.contributed_memento_id as "item_id", i.headline, i.text, i.resource_url
	from Context_Contributed_Memento  ci, Contributed_Memento i 
	where ci.contributed_memento_id = i.contributed_memento_id
	and ci.context_id=26)
) as context

) ;