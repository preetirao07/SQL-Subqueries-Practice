-- Sub-queries function

-- find out the amounts which are above average
-- solution: first calculate the average amount
select avg(amount) from payment

select * from payment
where amount > 4.2006673312979002

-- subquery within a query
select * from payment
where amount > (select avg(amount) from payment)

-- Find all of the payments by customer adam

select * from payment
where customer_id = (select customer_id from customer where first_name = 'ADAM')

-- Challenge: Select all the films where the length is longer than the average of all  films
select film_id, title from film
where length > (select avg(length) from film)

-- Challenge: Return all the films that are avilable in the inventory in store 2 more than 3 times.
select film_id, title from film 
where film_id in (select i.film_id
					from inventory i
					where store_id = 2
					group by i.film_id
					having count(*) > 3)

-- Challenge: Return all customers' first names & last names that have made a payment on '2020-01-25'
select first_name, last_name from customer
where customer_id in (select customer_id from payment where date(payment_date) = '2020-01-25')

-- Challenge: Return all customers' first names & email address that have spent a more than $30
select first_name, email from customer
where customer_id in (select customer_id from payment 
						group by customer_id
						having sum(amount) > 30)

-- Challenge: Return all customers' first names & last names that are from califormia and have spent more than 100 in total
select first_name, last_name from customer
where customer_id in (select customer_id from payment 
						group by customer_id
						having sum(amount) > 100)
and customer_id in (select customer_id from customer
					inner join address a
					on a.address_id = customer.address_id
					where district = 'California')
					

--


-- Find average life time spending of a customer
select round(avg(total_amount), 2) as avg_lifetime_spent 
from (select customer_id, sum(amount) as total_amount from payment
group by customer_id)

-- What is the average total amount spent per day (average daily revenue)?
select round(avg(daily_revenue), 2) as average_daily_revenue from
(select sum(amount) as daily_revenue, date(payment_date) from payment
group by date(payment_date))

--  Add column with 1 single value
select *, 'hello', 3 from payment

-- Add average of daily revenue in a column
select *, (select round(avg(amount), 2) from payment) from payment

-- Show all the payments together with how much the payment amount is below the maximum payment amount.
select *, (select max(amount) from payment) - amount as difference
from payment

-- CORREALTED SUB-QUERIES
-- correlated subquery gets evaluated for EVERY SINGLE ROW
-- correlated ṣubquery does NOT work independently

-- CORREALTED SUB-QUERIES in WHERE
-- show only those payments that have the highest amount per customer among all payments done by the customer

select * from payment p1
where amount = (select max(amount) from payment p2
where p1.customer_id = p2.customer_id)
order by customer_id 


-- show only those movie titles, their associated film_id & replacement_cost with the lowest replacement_costs for in each rating category - also show the rating.
select title, film_id, replacement_cost, rating  from film f1
where replacement_cost = (select min(replacement_cost) from film f2
where f1.rating = f1.rating)

-- show only those movie titles, their associated film_id & length that have the highest in each rating category - also show the rating.
select title, film_id, length, rating  from film f1
where length = (select max(length) from film f2
where f1.rating = f1.rating)

-- CORREALTED SUB-QUERIES in SELECT
-- show only those payments that have the maximum amount for every customer among all payments done by the customer
select *, (select max(amount) from payment p2
where p1.customer_id = p2.customer_id )
from payment p1
order by customer_id


-- show all the payments plus the total amount for every customer as well as the number of payments of each customer
select payment_id, customer_id, staff_id, amount,
(select sum(amount) as sum_amount from payment p2
where p1.customer_id =  p2.customer_id),
(select count(amount) as count_payments from payment p2
where p1.customer_id =  p2.customer_id) from payment p1
order by customer_id, amount desc

-- Correlated subquery in WHERE and SELECT
-- show only those films with the highest replacement_cost in their rating category 
-- show the average replacement cost in their rating category
(select avg(replacement_cost) from film f1 group by rating)

select title, replacement_cost, rating,
(select avg(replacement_cost) from film f2 
where f1.rating = f2.rating)
from film f1
where replacement_cost = (select max(replacement_cost) from film f3 where f1.rating = f3.rating)


-- Show only those payments with the highest payment for each customer's first name - including the payment_id of that payment.
-- how would you solve it if you would not need the payment_id?
select first_name, amount, payment_id from payment p1
inner join customer c
on p1.customer_id = c.customer_id
where amount = (select max(amount) from payment p2 where p1.customer_id = p1.customer_id)


select first_name, max(amount) from payment p1
inner join customer c
on p1.customer_id = c.customer_id
where amount = (select max(amount) from payment p2 where p1.customer_id = p1.customer_id)
group by first_name
-- 
