INSERT INTO `reminiscensdb`.`Public_Memento`
(
`migration_id`,
`headline`,
`text`,
`type`,
`resource_type`,
`category`,
`source`,
`source_url`,
`resource_url`,
`resource_thumbnail_url`,
`author`,
`collection`,
`collection_type`,
`is_collection`,
`nationality`,
`locale`,
`haschcode`,
`file_hashcode`,
`file_name`,
`contributor_type`,
`contributor`,
`creation_date`,
`last_update`,
`fuzzy_startdate`,
`location_start_id`,
`fuzzy_enddate`,
`location_end_id`,
`indexed`,
`tags`)

SELECT
`Works`.`work_id`,
`Works`.`title`,
`Works`.`description`,
`Works`.`type`,
`Works`.`resource_type`,
`Works`.`category`,
`Works`.`source`,
`Works`.`source_url`,
`Works`.`resource_url`,
NULL,
`Works`.`author`,
`Works`.`collection`,
NULL,
0,
(select 
 (case locale 
	when 'it_IT' then italian_name
	when 'en_US' then short_name
	when 'fr_FR' then french_name
    else short_name
	end
 ) as name
 from Country where `Country`.`country_id` = `Works`.`author_country_id`
) as nationality,
`Works`.`locale`,
NULL,
NULL,
NULL,
'SYSTEM',
NULL,
`Works`.`last_update`,
`Works`.`last_update`,
`Works`.`fuzzy_releasedate`,
NULL,
NULL,
NULL,
`Works`.`indexed`,
`Works`.`tags`
FROM `reminiscensdb`.`Works`;
