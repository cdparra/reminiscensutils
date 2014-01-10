select * from File where filename = "U_97_D2013-11-07T04:54:08.843-05:00_DSC01312.JPG";
select * from File where hashcode = "8ff180f8-8a8d-3490-abb0-b04080f15c71";

select replace(filename,".JPG",".jpg") from File where filename = "U_97_D2013-11-07T04:54:08.843-05:00_DSC01312.JPG";


select * from File where filename like "%.JPG" COLLATE utf8_bin;


select * from File f, User u where f.user_id = u.user_id and u.person_id = 79;


update File set 
	filename = replace(filename,".JPG",".jpg"),
	URI = replace(URI,".JPG",".jpg"),
	thumbnail_uri = replace(thumbnail_uri,".JPG",".jpg"),
	small_uri = replace(small_uri,".JPG",".jpg"),
	medium_uri = replace(medium_uri,".JPG",".jpg"),
	large_uri = replace(large_uri,".JPG",".jpg")
where filename like "%.JPG" COLLATE utf8_bin;


