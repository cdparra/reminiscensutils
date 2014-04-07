select * from User;

select * from Person;

select 
        u1.email,
        u1.fullname,u1.person_id,u1.user_id,
        u2.fullname,u2.person_id,u2.user_id,
    la.provider_user_id
from User u1 right outer join User u2 
        on u1.person_id=u2.person_id and u1.user_id <> u2.user_id
        left outer join Linked_Account la 
        on u1.user_id = la.user_id

where u1.fullname like "%Admin%";


select 
        u1.email,
        u1.fullname,u1.person_id,u1.user_id,
    la.provider_user_id
from User u1 join Linked_Account la 
        on u1.user_id = la.user_id
where u1.fullname like "%Admin%";


select u1.email, u1.fullname from User u1


where u1.fullname like "%Admin%";



select * from Linked_Account;







select * from Security_Role s, User_Security_Roles us, User u 
where u.fullname like "%Admin%" 
and u.user_id = us.user_id
and us.role_id = s.role_id;


select * from Security_Role;
select * from User_Security_Roles;


select * from Fuzzy_Date where fuzzy_date_id = 16588;


#<p>Mia madre</p><p>Si chiama Brunetta Agnoletto ed è l'ottava di nove figli.</p><p>E' nata in un piccolo paesino del Veneto: Coriano veronese, comune di Albaredo d' Adige, provincia di Verona.</p><p>Il suo nome è stato" ripreso" da una sorella Bruna che all'età di 9 anni è morta in un incidente,sotto il treno,e lei per meglio identificarla è stata chiamata Brunetta .</p><p>Ha frequentato le scuole elementari</p><p>Essendo l'ultima femmina la sua mamma Elisabetta voleva che svolgesse tutti i lavori di casa, ma lei non li amava e preferiva andarsene dalle suore dove imparava altre cose come il ricamo.</p><p>La famiglia viveva con i proventi di un negozio-tabaccheria dove trovavi non solo cose alimentari,ma anche ogni genere di altri articoli.Il padre &nbsp;finchè i figli erano piccoli era lui che con il carro andava nei centri più grossi a comperare la merce per rifornire il negozio,ma poi più avanti questo lavoro passò al figlio maggiore Silvio&nbsp;<span style="line-height:1.5;">e lui ,come dice mia madre, si dedicò alla politica.</span></p><p><span style="line-height:1.5;"></span></p>


