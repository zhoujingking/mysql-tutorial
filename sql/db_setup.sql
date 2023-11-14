drop database godking;
create database if not exists godking;

use godking;

delimiter $$
create function get_random_integer(
	min int,
    max int
)
returns int
deterministic
begin
	return floor(rand() * (max - min))+ min;
end $$

delimiter ;


create table if not exists classroom (
    id int primary key auto_increment,
    name char(10) not null unique
);


insert into classroom(name) values ('01-01'),
                                   ('01-02'),
                                   ('01-03'),
                                   ('02-01'),
                                   ('02-02'),
                                   ('02-03'),
                                   ('03-01'),
                                   ('03-02'),
                                   ('03-03');

create table if not exists course (
    id int primary key auto_increment,
    name varchar(50) not null unique,
    code varchar(10) not null unique
);

insert into course(name, code) values ('math', '000001'),
                                      ('english', '000002'),
                                      ('chemistry', '000003'),
                                      ('physics', '000004'),
                                      ('sports', '000005'),
                                      ('experiment', '000006');


create table if not exists student(
    id int primary key auto_increment,
    forename varchar(20) not null ,
    surname varchar(20) not null,
    age tinyint not null check ( age > 0 && age < 150 ),
    classroom_id int,
    constraint fk_classroom_id foreign key (classroom_id) references classroom(id)
);

create index student_age on student(age);

insert into student(forename, surname, age, classroom_id) values ('Shepperd', 'Jack', get_random_integer(10, 100), 1),
                                                                 ('John', 'Lock', get_random_integer(10, 100), 2),
                                                                 ('Kate', 'Anderson', get_random_integer(10, 100), 3),
                                                                 ('Sawyer', 'Watt', get_random_integer(10, 100), 4),
                                                                 ('Hugo', 'Jones', get_random_integer(10, 100), 5),
                                                                 ('Jasmine', 'Williams', get_random_integer(10, 100), 6),
                                                                 ('Jacky', 'Garcia', get_random_integer(10, 100), 1),
                                                                 ('Oliver', 'Katherine', get_random_integer(10, 100), 2),
                                                                 ('Harry', 'Porter', get_random_integer(10, 100), 3),
                                                                 ('Jacob', 'Unknown', get_random_integer(10, 100), 4),
                                                                 ('Charlie', 'Jack', get_random_integer(10, 100), 5),
                                                                 ('George', 'Brown', get_random_integer(10, 100), 6),
                                                                 ('Oscar', 'Williams', get_random_integer(10, 100), 1),
                                                                 ('Higgins', 'Thomas', get_random_integer(10, 100), 2),
                                                                 ('Ronnie', 'Lopez', get_random_integer(10, 100), 3),
                                                                 ('Emily', 'Davis', get_random_integer(10, 100), 4),
                                                                 ('Eva', 'Miller', get_random_integer(10, 100), 5),
                                                                 ('King', 'God', get_random_integer(10, 100), 6);

create table if not exists score(
    id int primary key auto_increment,
    course_id int,
    student_id int,
    value int not null check ( value >= 0 && value <= 100 ),
    constraint fk_course_id foreign key (course_id) references course(id),
    constraint fk_student_id foreign key (student_id) references student(id)
);

delimiter $$;
create procedure add_scores_of_student(in student_id int)
begin
    declare finished boolean default false;
    declare course_id int;
    declare course_cursor cursor for select id from course;
    declare continue handler for not found set finished = 1;
    open course_cursor;
    course_loop: loop
        fetch course_cursor into course_id;
        if finished = 1 then
            leave course_loop;
        else
            insert into score(course_id, student_id, value) VALUE(course_id,student_id, get_random_integer(0, 100));
        end if;
    end loop;
    close course_cursor;
end $$;
delimiter ;



delimiter $$;
create procedure add_scores()
begin
    declare finished boolean default false;
    declare student_id int;
    declare student_cursor cursor for select id from student;
    declare continue handler for not found set finished = 1;
    open student_cursor;
    student_loop: loop
        fetch student_cursor into student_id;
        if finished = 1 then
            leave student_loop;
        else
            call add_scores_of_student(student_id);
        end if;
    end loop;
end $$;

delimiter ;

call add_scores();

