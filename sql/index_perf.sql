use godking;

create table if not exists huge_table_person(
    id int primary key auto_increment,
    name varchar(20) not null,
    id_card_num char(36), -- uuid
    age tinyint,
    gender tinyint(1),
    birthday DATE not null
);

alter table huge_table_person add constraint uk_id_card_num unique (id_card_num);

delimiter $$
create function if not exists get_random_date()
returns varchar(10)
deterministic
begin
	declare min_timestamp, max_timestamp int;
    declare result timestamp;
    set min_timestamp = unix_timestamp('1980-01-01');
    set max_timestamp = unix_timestamp(); -- now
	set result = from_unixtime(rand() * (max_timestamp - min_timestamp) + min_timestamp);
    return date_format(result, '%Y-%m-%d');
end $$

delimiter ;

delimiter $$
create function if not exists get_random_name() returns varchar(20) deterministic
begin
	declare name varchar(20) default '';
    select concat(surname.name, ' ', forename.name) into name from surname cross join forename order by rand() limit 1;
    return name;
end $$
delimiter ;

-- drop procedure batch_insert_person;
delimiter $$;
create procedure if not exists batch_insert_person(
    in count int
)
begin
    declare inserted_count int default 0;
    declare gender bool default 0;
    set autocommit = 0;
    repeat
		if rand() > 0.5 then
			set gender = 1;
		else
			set gender = 0;
		end if;
		insert into huge_table_person(name, id_card_num, age, gender, birthday)
			values (get_random_name(), uuid(), get_random_integer(10, 100), gender, get_random_date());
		set inserted_count = inserted_count + 1;
	until inserted_count > count
    end repeat;
    commit;
    set autocommit = 1;
end $$;
delimiter ;

-- set sql_log_bin = on;
call batch_insert_person(20000000);

select * from huge_table_person where name like 'Rod%';

select distinct age,  count(*) from huge_table_person group by age order by age desc ;

select * from huge_table_person order by id desc limit 1;

explain select * from huge_table_person where id in (
    select id from huge_table_person h where h.id_card_num = 'f28bed47-7ee8-11ee-bd42-0242ac110002'
    );