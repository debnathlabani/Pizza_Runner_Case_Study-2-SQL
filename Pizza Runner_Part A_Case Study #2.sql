-- A. Pizza Metrics
-- 1.How many pizzas were ordered?

select count(*) as no_of_pizaa
from customer_orders;

-- 2. How many unique customer orders were made?

select count(distinct order_id) as total_orders
from customer_orders;

   -- 3. How many successful orders were delivered by each runner?
   
select runner_id, count(*) as order_cnt
from runner_orders
where distance is not null
group by runner_id;
   
   -- 4. How many of each type of pizza was delivered?
   
   select pizza_name, count(co.pizza_id) as total_pizza
   from customer_orders co join pizza_names pn
   on co.pizza_id=pn.pizza_id join runner_orders ro 
   on co.order_id=ro.order_id
   where ro.distance is not null
   group by co.pizza_id, pizza_name;
   
   -- 5.How many Vegetarian and Meatlovers were ordered by each customer?
   
   select customer_id, pizza_name, count(*) as total_orders
   from customer_orders co join pizza_names pn 
   on co.pizza_id=pn.pizza_id
   group by customer_id, pizza_name
   order by customer_id;
   
   -- 6.What was the maximum number of pizzas delivered in a single order?
   
   with cte as(
   select co.order_id, count(pizza_id) as total_pizza, 
   dense_rank() over(order by count(pizza_id) desc) as rnk
   from customer_orders co join runner_orders ro 
   on co.order_id=ro.order_id
   where distance is not null
   group by order_id)
   select order_id, total_pizza as total_delivered
   from cte
   where rnk=1;
   
   -- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
   
   select co.customer_id, SUM(CASE WHEN (NULLIF(exclusions, '') IS NOT NULL OR NULLIF(extras, '') IS NOT NULL) THEN 1 ELSE 0 END) AS changed,
	SUM(CASE WHEN (NULLIF(exclusions, '') IS NULL AND NULLIF(extras, '') IS NULL) THEN 1 ELSE 0 END) AS unchanged
   from customer_orders co
   inner join runner_orders ro
   on co.order_id = ro.order_id
   where ro.distance != 0
   group by co.customer_id;
    
   -- 8.How many pizzas were delivered that had both exclusions and extras?
   
select COUNT(*) as pizzas_with_exclusions_extra
from customer_orders co
join runner_orders ro on co.order_id = ro.order_id
where ro.distance != 0
and (coalesce(co.exclusions, '') != '' and coalesce(co.extras, '') != '');

-- 9.What was the total volume of pizzas ordered for each hour of the day?

select hour(order_time) as hourly_order, count(*) as total_pizza
from customer_orders
group by hourly_order
order by hourly_order;

-- 10.What was the volume of orders for each day of the week? 
   
select dayname(order_time) as week_day, count(*) as total_order
from customer_orders
group by week_day
order by total_order desc;