-- 1 First, create a view that summarizes rental information for each customer. The view should 
-- include the customer's ID, name, email address, and total number of rentals (rental_count).

select * from customer;
select count(*) as rental_count, customer_id from rental group by customer_id;

CREATE VIEW rental_information AS
select c.customer_id, c.first_name, c.email, count(r.rental_id) rental_count from customer c
inner join rental r on c.customer_id = r.customer_id
group by first_name;


-- 2 Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should 
-- use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE temporary table amount_paid_customer AS

select ri.first_name, SUM(p.amount) as total_amount
from payment p
inner join rental_information ri on ri.customer_id = p.customer_id
group by ri.first_name;

-- 3- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH rental_cust_paymentCTE AS (
select ri.first_name, ri.email, ri.rental_count, a.total_amount from rental_information ri
left join amount_paid_customer a on a.first_name = ri.first_name
)

select * from rental_cust_paymentCTE;
