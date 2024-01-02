# B. Runner and Customer Experience
-- 1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

select week(registration_date+3) as registration_week, count(runner_id) as total_runner
from runners
group by registration_week;

-- 2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

select runner_id, round(avg(timestampdiff(minute,order_time,pickup_time)),1) as avg_time
from customer_orders co inner join runner_orders ro 
on co.order_id=ro.order_id
where distance != 0
group by runner_id
order by avg_time;

-- 3.Is there any relationship between the number of pizzas and how long the order takes to prepare?

with cte as(
select co.order_id, count(*) as total_pizza, round(avg(timestampdiff(minute,order_time,pickup_time)),1) as avg_time
from customer_orders co inner join runner_orders ro 
on co.order_id=ro.order_id
where distance != 0
group by co.order_id)
select total_pizza, avg_time
from cte 
group by total_pizza
order by avg_time;

-- 4.What was the average distance travelled for each customer?

select customer_id, round(avg(distance),1) as avg_distance
from customer_orders co inner join runner_orders ro 
on co.order_id=ro.order_id
group by customer_id;

-- 5.What was the difference between the longest and shortest delivery times for all orders?

select (max(duration)-min(duration)) as difference_del_time
from runner_orders
where duration is not null; 

-- 6.What was the average speed for each runner for each delivery and do you notice any trend for these values?

select runner_id,order_id, round(avg(distance*60/duration),1) as avg_time
from runner_orders
where duration is not null
group by runner_id,order_id
;

-- 7.What is the successful delivery percentage for each runner?

select runner_id, round(sum(case when distance!=0 then 1 else 0 end)/count(order_id)*100,1) as succesful_delivery_percentage
from runner_orders
group by runner_id;