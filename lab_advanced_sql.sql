/*6.04 Activity 1



/*Lab | Advanced SQL and Pivot tables

In this lab, you will be using the Sakila database of movie rentals. You have been using this database for a couple labs already, but if you need to get the data again, refer to the official installation link.

Instructions

Write the SQL queries to answer the following questions:

1. Select the first name, last name, and email address of all the customers who have rented a movie.

2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

3. Select the name and email address of all the customers who have rented the "Action" movies.

- Write the query using multiple join statements
- Write the query using sub queries with multiple WHERE clause and IN condition
- Verify if the above two queries produce the same results or not

4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.*/


-- 1. Select the first name, last name, and email address of all the customers who have rented a movie.

use sakila;

select c.first_name, c.last_name, c.email, count(r.rental_id) from customer c
join rental r on r.customer_id = c.customer_id
group by c.first_name, c.last_name, c.email
having count(r.rental_id)>0 ;


-- 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

select c.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, avg (p.amount) as average_pay from customer c
join payment p on p.customer_id = c.customer_id
group by c.customer_id, customer_name;

-- 3. Select the name and email address of all the customers who have rented the "Action" movies.

-- -- Write the query using multiple join statements

select c.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, c.email from customer c
join rental r on r.customer_id = c.customer_id
join inventory i on i.inventory_id = r.inventory_id
join film_category fc on i.film_id = fc.film_id
join category ct on ct.category_id = fc.category_id
where ct.name = 'Action';

-- Write the query using sub queries with multiple WHERE clause and IN condition

# subqueries
select category_id from category where name = "Action";

select film_id from film_category where category_id in 
	(select category_id from category where name = "Action");

select inventory_id from inventory where film_id in (
	select film_id from film_category where category_id in  
	(select category_id from category where name = "Action")
	);
	
select customer_id from rental where inventory_id in (
	select inventory_id from inventory where film_id in (
	select film_id from film_category where category_id in  
	(select category_id from category where name = "Action")
	)
	);

-- Final:
select customer_id, concat(first_name, ' ', last_name) as customer_name, email from customer where customer_id in (
	select customer_id from rental where inventory_id in (
	select inventory_id from inventory where film_id in (
	select film_id from film_category where category_id in  
	(select category_id from category where name = "Action")
	)
	)
);

-- Verify if the above two queries produce the same results or not*/ YES


-- 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
-- PAYMENT TABLE

select *, 
case 
	when (2 > amount > 0) then 'low' 
	when (amount >= 2) and (amount < 4) then 'medium'
	when (amount >= 4) then 'high' 
end as classification 
from payment;


