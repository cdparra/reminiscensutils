select count(*) from Public_Memento; # 3261, 29/08/2013
select count(*) from Public_Memento where fuzzy_startdate is null; # 260, 29/08/2013
select count(*) from Public_Memento where fuzzy_startdate is not null; # 3001, 29/08/2013
select count(*) from Public_Memento where fuzzy_startdate is null and location_start_id is not null; # 0, 29/08/2013
select count(*) from Public_Memento where fuzzy_startdate is not null and location_start_id is null; # 1948, 29/08/2013

select count(*) from Public_Memento where category = 'SONG'; # 1595, 29/08/2013
select count(*) from Public_Memento where category = 'PEOPLE'; # 485, 29/08/2013
select count(*) from Public_Memento where category = 'STORY'; # 632, 29/08/2013
select count(*) from Public_Memento where category = 'PICTURE'; # 549, 29/08/2013
select count(*) from Public_Memento where category IS NULL; # 0, 29/08/2013
