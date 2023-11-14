use godking;

drop procedure if exists batch_insert_users;

delimiter $$
create procedure batch_insert_users(in count int)
begin
	declare inserted_count int default 0;
    declare gender bool default 0;
    repeat
		if rand() > 0.5 then
			set gender = 1;
		else
			set gender = 0;
		end if;
		insert into users(name, gender, id_card_number)
			values (get_random_name(), gender, uuid());
		set inserted_count = inserted_count + 1;
	until inserted_count > count
    end repeat;
end $$
delimiter ;