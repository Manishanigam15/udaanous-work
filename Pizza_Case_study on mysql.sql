use pizza;

-- 1. Retrieve the total number of orders placed. 
 select count(distinct order_id) as 'Total Orders' from order_details; 
 
 -- 2. Calculate the total revenue generated from pizza sales. 
 select cast(sum(order_details.quantity * pizzas.price) as decimal(10,2)) as 'Total Revenue' from order_details
 join pizzas on pizzas.pizza_id = order_details.pizza_id;
 
 -- 3. Identify the highest-priced pizza. 
 select pizza_types.name as 'Pizza Name',cast(pizzas.price as decimal(10,2)) as 'Price'
 from pizzas join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id 
 order by price desc limit 1;
 
 -- 4. Identify the most common pizza size ordered.
 select pizzas.size, count(distinct order_id) as 'No of Orders', sum(quantity) as 'Total Quantity Ordered'
 from order_details join pizzas on pizzas.pizza_id = order_details.pizza_id
 group by pizzas.size
 order by count(distinct order_id) desc;

-- only most common size 
 SELECT size, COUNT(*) AS count
FROM pizzas
GROUP BY size
ORDER BY count DESC
LIMIT 1;

 
 -- 5. List the top 5 most ordered pizza types along with their quantities.
 select p.pizza_type_id as 'Pizza' , sum(od.quantity) as Total_Ordered 
 from  pizzas p
 inner join order_details od on p.pizza_id = od.pizza_id 
 GROUP BY pizza_type_id
 order by Total_Ordered desc limit 5;
 
 
 -- 6. Join the necessary tables to find the total quantity of each pizza category ordered. 
 SELECT 
    pt.category, 
    SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt on p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

-- 7. Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(time) AS order_hour, 
    COUNT(order_id) AS order_count
FROM orders
GROUP BY order_hour
ORDER BY order_hour;


-- 8. Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    pt.category, 
    COUNT(p.pizza_id) AS total_pizzas
FROM pizzas p
JOIN order_details od ON p.pizza_id = od.pizza_id
JOIN pizza_types pt on p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_pizzas DESC;


-- 9. Group the orders by date and calculate the average number of pizzas ordered per day. 
SELECT 
    date, 
    SUM(od.quantity) AS total_pizzas_ordered,
    AVG(SUM(od.quantity)) OVER () AS avg_pizzas_per_day
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY date
ORDER BY date;


-- alternate method of calculate the average number of pizzas ordered per day
SELECT o.date, ROUND(AVG(od.quantity),2) AS avg_pizzas_per_day
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.date  
order by o.date;

-- 10. Determine the top 3 most ordered pizza types based on revenue. 
select pt.name as pizza_type, sum(od.quantity * p.price) as Revenue
from order_details od
join pizzas as p on od.pizza_id = p.pizza_id
join pizza_types as pt on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by Revenue desc limit 3;


-- 11. Calculate the percentage contribution of each pizza type to total revenue. 
SELECT 
    pt.name AS pizza_type, 
    SUM(od.quantity * p.price) AS pizza_revenue,
    (SUM(od.quantity * p.price)  * 100 / 
    (SELECT SUM(od.quantity * p.price) FROM order_details od
      JOIN pizzas p ON od.pizza_id = p.pizza_id)) AS percentage_contribution
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY pizza_revenue DESC;


-- 12. Analyze the cumulative revenue generated over time. 
SELECT 
    o.date, 
    SUM(od.quantity * p.price) AS daily_revenue,
    SUM(SUM(od.quantity * p.price)) OVER (ORDER BY o.date) AS cumulative_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.date
ORDER BY o.date;


-- 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category. 
SELECT 
   p.pizza_type_id, pt.category, sum(p.price * od.quantity) as total_revenue from pizzas p join pizza_types pt
   on pt.pizza_type_id = p.pizza_type_id join order_details od on od.pizza_id = p.pizza_id
   group by pizza_type_id, category order by total_revenue desc limit 3;
    