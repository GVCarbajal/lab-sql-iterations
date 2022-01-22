-- Write a query to find what is the total business done by each store.

select s.store_id, sum(amount) income from rental r
join payment p on r.rental_id = p.rental_id
join staff s on p.staff_id = s.staff_id
group by s.store_id;


-- Convert the previous query into a stored procedure.

delimiter //
create procedure store_income()
begin
	select s.store_id, sum(amount) income from rental r
	join payment p on r.rental_id = p.rental_id
	join staff s on p.staff_id = s.staff_id
	group by s.store_id;
end
// delimiter ;


-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

delimiter //
create procedure store_income(in store smallint)
begin
	select s.store_id, sum(amount) income from rental r
	join payment p on r.rental_id = p.rental_id
	join staff s on p.staff_id = s.staff_id
    where s.store_id = store
	group by s.store_id;
end
// delimiter ;

call store_income(2);


/* Update the previous query. Declare a variable total_sales_value of float type, 
that will store the returned result (of the total sales amount for the store). 
Call the stored procedure and print the results. */

drop procedure if exists store_income;

delimiter //
create procedure store_income(in store smallint, out total_sales_value float)
begin
	select income into total_sales_value from (
		select s.store_id, sum(amount) income from rental r
		join payment p on r.rental_id = p.rental_id
		join staff s on p.staff_id = s.staff_id
		where s.store_id = store
		group by s.store_id
        ) sub1;
end
// delimiter ;

call store_income(1, @total_sales_value);
select @total_sales_value;


/* In the previous query, add another variable flag. 
If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value. */

drop procedure if exists store_income;

delimiter //
create procedure store_income(in store smallint, out total_sales_value float, out flag varchar(10))
begin

	declare flag_color varchar(10) default "";
    
	select income into total_sales_value from (
		select s.store_id, sum(amount) income from rental r
		join payment p on r.rental_id = p.rental_id
		join staff s on p.staff_id = s.staff_id
		where s.store_id = store
		group by s.store_id
        ) sub1;
        
	if total_sales_value > 30000 then
		set flag_color = "green_flag";
	else
		set flag_color = "red_flag";
	end if;
    
	select flag_color into flag;
        
end
// delimiter ;

call store_income(1, @total_sales_value, @flag);
select @total_sales_value, @flag;