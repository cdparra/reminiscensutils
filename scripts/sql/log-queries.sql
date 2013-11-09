select r.date,r.starttime,r.endtime,
	time(ADDTIME(l.time, '0 6:0:0.000000')) as logtime, 
	date(ADDTIME(l.time, '0 6:0:0.000000'))as logdate,
	l.user_id, r.user_id,
	l.* 
from Log l, Reminiscence_Sessions r
where 
#l.user_id = r.user_id
#and 
time(ADDTIME(l.time, '0 6:0:0.000000'))>=r.starttime
and time(ADDTIME(l.time, '0 6:0:0.000000'))<=r.endtime
and date(ADDTIME(l.time, '0 6:0:0.000000'))<=r.date
and session = 0
and date(ADDTIME(l.time, '0 6:0:0.000000'))>'2013-10-15'
;


update Log l, Reminiscence_Sessions r
	set l.session=1
#r.date,r.starttime,r.endtime,
#	time(ADDTIME(l.time, '0 6:0:0.000000')) as logtime, 
#	date(ADDTIME(l.time, '0 6:0:0.000000'))as logdate,
#l.* 
#from 
where l.user_id = r.user_id
and time(ADDTIME(l.time, '0 6:0:0.000000'))>=r.starttime
and time(ADDTIME(l.time, '0 6:0:0.000000'))<=r.endtime
and date(ADDTIME(l.time, '0 6:0:0.000000'))<=r.date
#and date(ADDTIME(l.time, '0 6:0:0.000000'))<'2013-10-27'
;


select count(*),session from Log group by session;