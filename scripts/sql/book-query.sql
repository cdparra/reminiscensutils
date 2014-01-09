BEGIN;

#SET @personid := 70; # DONE: Raffaella Keller
#SET @personid := 71; # Paolina Santini
#SET @personid := 74; # Antonio Zambella
#SET @personid := 76; # Maria Greca
#SET @personid := 90; # Carla Bevilacqua
#SET @personid := 90; # Antonietta Bevilacqua
#SET @personid := 78; # Maria Grazia Frainer
#SET @personid := 79; # DONE: Alma Meggio 
#SET @personid := 80; # Pia Pedergnana
#SET @personid := 84; # Giulio Flessati
#SET @personid := 84; # Maria Zanon
#SET @personid := 88; # Rita Lunelli
#SET @personid := 91; # Iole Gregori
#SET @personid := 94; # Teresa Gottardi
#SET @personid := 95; # Bruna Giovanini
#SET @personid := 96; # Germana Franceschini
SET @personid := 97; # María Antonia Ravanelli

SET @csvoutput1 := concat("/tmp/",@personid,"_storie-senzafotourl.csv");
SET @csvoutput2 := concat("/tmp/",@personid,"_storie.csv");


# Life stories of a person for his BOOK - Titles and date/location information for checking
select 
#	l.life_event_id,
#	,m.memento_id as 'photo_id', m.url as 'photo_url' 
	if ((fd.year is null),fd.decade,fd.year) as 'anno', 
	if ((fd.month is null),0,fd.month) as 'mese', 
	if ((fd.day is null),0,fd.day) as 'giorno',
	if ((loc.country is null),"",loc.country) as 'nazione', 
	if ((loc.region is null),"",loc.region) as 'regione', 
	if ((loc.city is null),"",loc.city) as 'citta',
	if (loc.location_textual is null,
		if (loc.name is null,"",loc.name), 
		if (loc.name is null,loc.location_textual,
			concat(loc.location_textual,loc.name)
			)
		) as 'posto',
	l.headline as 'titolo',
	l.text as 'testo'
from Life_Event l
#	left outer join Memento m on m.life_event_id=l.life_event_id 
	join Participant p on p.life_event_id = l.life_event_id
	join Fuzzy_Date fd on l.fuzzy_startdate = fd.fuzzy_date_id
	join Location loc on l.location_id = loc.location_id
where 
person_id=@personid 
order by if ((fd.year is null),fd.decade,fd.year)
INTO OUTFILE '/tmp/storie-senzaurl.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

#select * from File where filename="U_65_D2013-10-28T09:30:50.159-04:00_concerto col %22New Quartet%22 dicembre 1997.jpeg";


# Life stories of a person for his BOOK
select 
	l.life_event_id as 'nro_storia', 
	l.headline as 'titolo', 
	l.text as 'testo',	
	m.memento_id as 'nro_foto', 
	f.large_uri as 'foto_url', 
	m.file_name as 'foto_nome',
	m.url as 'foto_full_url', 
	if ((fd.year is null),fd.decade,fd.year) as 'anno', 
	if ((fd.month is null),0,fd.month) as 'mese', 
	if ((fd.day is null),0,fd.day) as 'giorno',
	if ((loc.country is null),"",loc.country) as 'nazione', 
	if ((loc.region is null),"",loc.region) as 'regione', 
	if ((loc.city is null),"",loc.city) as 'citta',
	if (loc.location_textual is null,
		if (loc.name is null,"",loc.name), 
		if (loc.name is null,loc.location_textual,
			concat(loc.location_textual,loc.name)
			)
		) as 'posto',
	f.hashcode as 'fotohash'
from Life_Event l
	left outer join Memento m on m.life_event_id=l.life_event_id 
	left outer join File f on f.hashcode = m.file_hashcode
	join Participant p on p.life_event_id = l.life_event_id
	join Fuzzy_Date fd on l.fuzzy_startdate = fd.fuzzy_date_id
	join Location loc on l.location_id = loc.location_id
where 
person_id=@personid
INTO OUTFILE '/tmp/storie.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

COMMIT;