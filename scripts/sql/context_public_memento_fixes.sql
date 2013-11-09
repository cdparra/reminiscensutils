select 
	(
		select max(ccpm.ranking) 
		from Context_Public_Memento ccpm 
		where ccpm.context_id = cpm.context_id 
	) as max_ranking , cpm.* 
from 
	Context_Public_Memento cpm 
where ranking is null;

UPDATE Context_Public_Memento AS t 
	INNER JOIN 
	(
		SELECT context_id, max(ranking) mranking 
		FROM Context_Public_Memento 
		GROUP BY context_id) as t1 
ON t.context_id= t1.context_id 
SET t.ranking=t1.mranking
where t.ranking is null;



SELECT context_id, max(ranking) mranking 
		FROM Context_Public_Memento 
		GROUP BY context_id;