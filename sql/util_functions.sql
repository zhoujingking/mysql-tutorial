use godking;

drop function if exists get_random_name;
delimiter $$
create function get_random_name() returns varchar(20) deterministic
begin
	declare name varchar(20) default '';
    select concat(surname.name, ' ', forename.name) into name from surname cross join forename order by rand() limit 1;
    return name;
end $$
delimiter ;


drop function if exists get_random_integer;
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

drop function if exists get_random_date;
delimiter $$
create function get_random_date()
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

show function status where db = 'godking';

