use godking;
select student_id, sum(value) as total from score group by student_id order by total desc;

select concat(s.forename,' ', s.surname) as name, score.total from student s inner join (
    select student_id, sum(value) as total from score group by student_id order by total desc
) as score where s.id = score.student_id;

select * from mysql.user;
revoke all privileges on godking.* from 'report'@'%';
grant select on godking.* to 'report'@'%';
flush privileges ;

alter user 'report'@'%' account unlock ;



create user if not exists report identified by 'report';

select id from student where age < 30;
select id from course where name = 'physics';

select avg(value) as 'avg_score' from score where course_id = (select id from course where name = 'physics');

select student_id, sum(value) from score where exists (select id from student where age < 30 and student_id = student.id) group by student_id;

select student_id, sum(value) as total, avg(value) as avg from score where student_id in (select id from student where age < 30) group by student_id having avg >= 60;

select length(uuid());

select count(*) from  huge_table_person;

show indexes from huge_table_person;
drop index idx_birthday on huge_table_person;

select count( distinct id_card_num) from huge_table_person;
select count(distinct id) from huge_table_person;

create index idx_birthday on huge_table_person(birthday);

select count( distinct birthday) from huge_table_person;

show variables like '%slow_query%';
set global slow_query_log = 1;
set global long_query_time = 2;

show variables like '%log_output%';

select @@transaction_isolation;
show variables like '%isolation%';


set transaction isolation level serializable ;
start transaction ;
insert into classroom(name) values ('l');

commit;

rollback ;

select * from information_schema.INNODB_TRX;


