# Class that contains queries for getting the stories of a person in reminiscens
#
# Author: Cristhian Parra
import urllib.request, urllib.parse, urllib.error
import csv
import os
import os.path
import sys, argparse, csv
import re
import subprocess
import time

class Queries: 

	# Life stories of a person for his BOOK
	# Titles and date/location information for checking, 
	# no mementos (i.e pictures, audios)
	@staticmethod
	def storiesOfPerson(person_id): 
		query =  " SELECT "  
		query += "     l.life_event_id, "
		query += "     if ((fd.year is null),fd.decade,fd.year) as 'anno', "
		query += "     if ((fd.month is null),0,fd.month) as 'mese', "
		query += "     if ((fd.day is null),0,fd.day) as 'giorno', "
		query += "     if ((loc.country is null),'',loc.country) as 'nazione', "
		query += "     if ((loc.region is null),'',loc.region) as 'regione', "
		query += "     if ((loc.city is null),'',loc.city) as 'citta', "
		query += "     if (loc.location_textual is null, "
		query += "         if (loc.name is null,'',loc.name), "
		query += "         if (loc.name is null,loc.location_textual, "
		query += "                concat(loc.location_textual,loc.name) "
		query += "            ) "
		query += "        ) as 'posto', "
		query += "     l.headline as 'titolo', "
		query += "     l.text as 'testo' "
		query += "from Life_Event l "
		query += " join Participant p on p.life_event_id = l.life_event_id "
		query += " join Fuzzy_Date fd on l.fuzzy_startdate = fd.fuzzy_date_id "
		query += " join Location loc on l.location_id = loc.location_id "
		query += " where "
		query += " person_id = " + person_id
		query += " order by fd.decade asc, fd.year asc, fd.month asc, fd.day asc;"
		return query

	# Life stories of a person for his BOOK
	# Titles and date/location information for checking, 
	# Including mementos (i.e pictures, audios)
	@staticmethod
	def storiesOfPersonWithMementos(person_id): 
		query = " SELECT "
		query += "     l.life_event_id as 'nro_storia',  "
		query += "     l.headline as 'titolo',  "
		query += "     l.text as 'testo', "
		query += "     m.memento_id as 'nro_foto',  "
		query += "     f.large_uri as 'foto_url', "
		query += "     m.file_name as 'foto_nome', "
		query += "     m.url as 'foto_full_url',  "
		query += "     if ((fd.year is null),fd.decade,fd.year) as 'anno', "
		query += "     if ((fd.month is null),0,fd.month) as 'mese', "
		query += "     if ((fd.day is null),0,fd.day) as 'giorno', "
		query += "     if ((loc.country is null),'',loc.country) as 'nazione',  "
		query += "     if ((loc.region is null),'',loc.region) as 'regione',  "
		query += "     if ((loc.city is null),'',loc.city) as 'citta', "
		query += "     if (loc.location_textual is null, "
		query += "     if (loc.name is null,'',loc.name),  "
		query += "     if (loc.name is null,loc.location_textual, "
		query += " 		concat(loc.location_textual,loc.name) "
		query += " 		) "
		query += " 	) as 'posto', "
		query += " f.hashcode as 'fotohash', "
		query += "     l.question_id as 'question_id', "
		query += " qt.question_text as 'question_text', "
		query += "     l.public_memento_id as 'public_memento_id', "
		query += " pm.headline as 'public_memento_title', "
		query += " pm.resource_url as 'public_memento_url' "
		query += "from Life_Event l "
		query += " left outer join Memento m on m.life_event_id=l.life_event_id  "
		query += " left outer join File f on f.hashcode = m.file_hashcode "
		query += " join Participant p on p.life_event_id = l.life_event_id "
		query += " join Fuzzy_Date fd on l.fuzzy_startdate = fd.fuzzy_date_id "
		query += " join Location loc on l.location_id = loc.location_id "
		query += " left outer join Question q on q.question_id = l.question_id "
		query += " left outer join Question_Trans qt on q.question_id = qt.question_id and qt.locale='it_IT' "
		query += " left outer join Public_Memento pm on pm.public_memento_id = l.public_memento_id "
		query += "where  "
		query += "person_id = " + person_id
		query += " order by fd.decade asc, fd.year asc, fd.month asc, fd.day asc;"
		return query