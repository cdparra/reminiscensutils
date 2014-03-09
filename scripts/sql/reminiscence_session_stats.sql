# Stat calculation script for reminiscens based on the autmatic log

## Stat Fields to UPDAT
# stat_stories


select count(l.resource_uri),rs.session_id,rs.week from Reminiscence_Sessions rs, Log l 
where rs.narrator_user_id = l.user_id
	and time(ADDTIME(l.time, '0 6:0:0.000000'))>=ADDTIME(rs.starttime, '-0 0:15:0.000000')
	and time(ADDTIME(l.time, '0 6:0:0.000000'))<=ADDTIME(rs.endtime, '0 0:15:0.000000') 
	and date(ADDTIME(l.time, '0 6:0:0.000000'))<=rs.date
	and l.action = 'STORY_NEW'
    and rs.done = 'SI'
group by rs.session_id, rs.week asc
order by rs.week asc
;

select l.log_id, rs.narrator_user_id, rs.main_participant_fullname,rs.session_id,rs.week from Reminiscence_Sessions rs, Log l 
where rs.narrator_user_id = l.user_id
	and time(ADDTIME(l.time, '0 6:0:0.000000'))>=ADDTIME(rs.starttime, '-0 0:15:0.000000')
	and time(ADDTIME(l.time, '0 6:0:0.000000'))<=ADDTIME(rs.endtime, '0 0:15:0.000000') 
	and date(ADDTIME(l.time, '0 6:0:0.000000'))<=rs.date
	and l.action = 'STORY_NEW'
    and rs.done = 'SI'
#group by rs.session_id, rs.week asc
order by rs.week asc
;




# stat_editions
# stat_deletions
# stat_pictures
# stat_stories_qual
# stat_questions_views
# stat_questions_answered
# stat_public_memento_views
# stat_public_memento_detail_views

## Actions Logged
# QUESTION_READ  		= 6 question_views
# TIMELINE_READ 
# CONTEXT_READ  
# FILE_NEW 				= Picture uploaded 
# STORY_NEW				= 1 new story
# CONTEXT_REFRESH	
# LOGIN					= 1 session
# SIGNUP
# CONTEXT_INIT
# STORY_MODIFY			= 1 edition story
# PUBLIC_MEMENTO_NEW	
# QUESTION_ANSWER		= 1 question answer
# VIEWS					= 1 public memento view
# OPEN					= 1 session started
# CLOSE					= 1 session finished
# DETAILVIEWS			= 1 public memento detail view
# MEMENTO_DELETE		= 1 picture deletion
# STORY_DELETE			= 1 story deletion


update Reminiscence_Sessions rs, Log l 
	set rs.stat_stories = count(*)
where rs.narrator_id = l.user_id
	and time(ADDTIME(l.time, '0 6:0:0.000000'))>=ADDTIME(rs.starttime, '-0 0:15:0.000000')
	and time(ADDTIME(l.time, '0 6:0:0.000000'))<=ADDTIME(rs.endtime, '0 0:15:0.000000') 
	and date(ADDTIME(l.time, '0 6:0:0.000000'))<=rs.date
	and l.action = 'STORY_NEW';



# AUX
select * from Reminiscence_Sessions 
#where narrator_user_id = 78
order by date asc;



select narrator_user_id from Reminiscence_Sessions group by narrator_user_id;

update Reminiscence_Sessions set listener_user_id = 0 where narrator_user_id = 65;
update Reminiscence_Sessions set listener_user_id = 0 where narrator_user_id = 67;
update Reminiscence_Sessions set listener_user_id = 71 where narrator_user_id = 69;
update Reminiscence_Sessions set listener_user_id = 72 where narrator_user_id = 70;
update Reminiscence_Sessions set listener_user_id = 74 where narrator_user_id = 73;
update Reminiscence_Sessions set listener_user_id = 76 where narrator_user_id = 75;
update Reminiscence_Sessions set listener_user_id = 80 where narrator_user_id = 77;
update Reminiscence_Sessions set listener_user_id = 81 where narrator_user_id = 78;
update Reminiscence_Sessions set listener_user_id = 82 where narrator_user_id = 79;
update Reminiscence_Sessions set listener_user_id = 84 where narrator_user_id = 83;
update Reminiscence_Sessions set listener_user_id = 0 where narrator_user_id = 96;
update Reminiscence_Sessions set listener_user_id = 99 where narrator_user_id = 98;
update Reminiscence_Sessions set listener_user_id = 0 where narrator_user_id = 100;
update Reminiscence_Sessions set listener_user_id = 0 where narrator_user_id = 103;
update Reminiscence_Sessions set listener_user_id = 0 where narrator_user_id = 104;
update Reminiscence_Sessions set listener_user_id = 0 where narrator_user_id = 105;
update Reminiscence_Sessions set listener_user_id = 0 where narrator_user_id = 106;

#'65','66','Sergio Torri'
#'67','66','Sergio Torri'
#'69','70','Raffaella Keller'
#'70','71','Paolina Santini'
#'71','70','Amanda Liriti'
#'72','71','Alessandro Ercolani'
#'73','74','Antonio Zambella'
#'74','74','Sara Vescovi'
#'75','76','Maria Greca'
#'76','76','Laura Folgheraiter'
#'77','78','Maria Grazia'
#'78','79','Alma Meggio'
#'79','80','Pia Perdegnana'
#'80','78','Annalisa Zanfranceschi'
#'81','79','Antonio La Barba'
#'82','80','Beatrice Valeri'
#'83','84','Giulio Flessati & Maria Zanon'
#'84','84','Damiano Flessati'
#'96','88','Rita Lunelli'
#'98','90','Carla e Antonia '
#'99','90','Isotta Biasi'
#'100','91','Iole Gregori'
#'103','94','Teresa Gottarde'
#'104','95','Bruna Giovanini'
#'105','96','Germana Franceschini'
#'106','97','Maria Antonia Ravanelli'