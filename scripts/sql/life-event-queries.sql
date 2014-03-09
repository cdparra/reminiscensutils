# Life Event Queries

#SET @personid := 70; # Raffaella Keller
#SET @personid := 71; # Paolina Santini
#SET @personid := 74; # Antonio Zambella
#SET @personid := 76; # Maria Greca
#SET @personid := 90; # Carla Bevilacqua
#SET @personid := 90; # Antonietta Bevilacqua
#SET @personid := 78; # Maria Grazia Frainer 
SET @personid := 79; # Alma Meggio 
#SET @personid := 80; # Pia Pedergnana
#SET @personid := 84; # Giulio Flessati
#SET @personid := 84; # Maria Zanon
#SET @personid := 88; # Rita Lunelli
#SET @personid := 91; # Iole Gregori
#SET @personid := 94; # Teresa Gottardi
#SET @personid := 95; # Bruna Giovanini
#SET @personid := 96; # Germana Franceschini
#SET @personid := 97; # María Antonia Ravanelli


select #* 
	#l.life_event_id, 
	#l.headline , 
	#l.question_id,
	#qt.question_text as 'question_text',	
    #l.text, 
	l.*
from Life_Event l, Participant p
	#left join Question q on q.question_id = l.question_id
	#left join Question_Trans qt on q.question_id = qt.question_id and qt.locale='it_IT'
where 
	p.person_id=80
	and p.life_event_id = l.life_event_id;

select * from Life_Event where life_event_id = 591;

select * from Fuzzy_Date where fuzzy_date_id = 17104;



delete from Memento where memento_id = 653;

delete from Life_Event where life_event_id = 499;
delete from Life_Event where life_event_id = 366;

update Memento set life_event_id = 361 where memento_id = 655;
update Memento set life_event_id = 596 where memento_id = 447;




delete from Memento where url = "http://base.reminiscens.me/files/story-book.jpg";

select #* 
	l.life_event_id, 
	l.headline , 
	l.question_id,
	#qt.question_text as 'question_text',	
    l.text 	
from Life_Event l#, Participant p
	#left join Question q on q.question_id = l.question_id
	#left join Question_Trans qt on q.question_id = qt.question_id and qt.locale='it_IT'
where 
	#p.person_id=79
	#and p.life_event_id = l.life_event_id
	l.life_event_id in (
						735
					   );


# life events with wrong questions
# 385, 389, 456, 346, 353, 377, 722, 277, 433, 376, 458, 392, 393, 391, 379, 383, 386, 385, 455, 536, 805, 436, 354, 448, 763, 402, 769 
# 719, 720, 574, 764,  646, 537, 378, 538, 403, 454, 495, 673, 619, 434, 618, 675, 674, 677, 721, 387, 450, 806, 765, 



# Life Event Queries

select #* 
	l.life_event_id, 
	l.headline , 
	l.question_id,
	qt.question_text as 'question_text'	
    #l.text, 
	#l.*
from Life_Event l
	left join Participant p on p.life_event_id = l.life_event_id
	left join Question q on q.question_id = l.question_id
	left join Question_Trans qt on q.question_id = qt.question_id and qt.locale='it_IT'
where 
	p.person_id=79
	and l.question_id is not null
;
