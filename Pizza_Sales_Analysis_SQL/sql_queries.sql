/*
CREATE TABLE orders(
order_id INT NOT NULL,
order_date DATE NOT NULL,
order_time TIME NOT NULL);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE order_details(
order_details_id INT NOT NULL,
order_id INT NOT NULL,
pizza_id VARCHAR(100),
quantity INT NOT NULL);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_details.csv'
INTO TABLE order_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
*/

SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;

-- Basic:
-- Retrieve the total number of orders placed.

SELECT COUNT(*) total_number FROM orders;

-- Calculate the total revenue generated from pizza sales.

SELECT ROUND(SUM(price*quantity), 2) total_revenue FROM order_details OD
JOIN pizzas P
ON P.pizza_id = OD.pizza_id;

-- Identify the highest-priced pizza.

SELECT pizza_id FROM pizzas
WHERE price = (SELECT MAX(price) FROM pizzas);

-- Identify the most common pizza size ordered.

SELECT P.size most_ordered_pizza_size FROM pizzas P
JOIN order_details OD
USING(pizza_id)
GROUP BY P.size
ORDER BY COUNT(*) DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.

SELECT P.pizza_id most_ordered_pizza FROM pizzas P
JOIN order_details OD
USING(pizza_id)
GROUP BY P.pizza_id
ORDER BY SUM(quantity) DESC
LIMIT 5;

-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT PT.category, SUM(OD.quantity) tot_quant_ordered FROM pizza_types PT
JOIN pizzas P
USING(pizza_type_id)
JOIN order_details OD
USING(pizza_id)
GROUP BY PT.category;

-- Determine the distribution of orders by hour of the day.

SELECT HOUR(order_time) hour_, COUNT(*) dist FROM orders 
GROUP BY hour_
ORDER BY dist DESC;

-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT PT.category, COUNT(*) dist FROM pizza_types PT
JOIN pizzas P
USING(pizza_type_id)
JOIN order_details OD
USING(pizza_id)
GROUP BY PT.category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT ROUND(AVG(pizza_count)) pizza_ord_per_day FROM
(SELECT order_date, COUNT(*)  pizza_count FROM orders O
JOIN order_details OD
USING(order_id)
GROUP BY order_date) subquery;

-- Determine the top 3 most ordered pizza types based on revenue.

SELECT name, SUM(P.price*OD.quantity) revenue FROM pizza_types PT
JOIN pizzas P
USING(pizza_type_id)
JOIN order_details OD
USING(pizza_ID)
GROUP BY name
ORDER BY revenue DESC
LIMIT 3;


-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.

WITH CTE AS
(SELECT SUM(P.price*OD.quantity) tot_revenue FROM order_details OD
JOIN pizzas P
USING(pizza_id))

SELECT name, 
ROUND((100.0*SUM(P.price*OD.quantity))/ (SELECT tot_revenue FROM CTE), 2)  pct_contr_pizza_type
FROM pizza_types PT
JOIN pizzas P
USING(pizza_type_id)
JOIN order_details OD
USING(pizza_ID)
GROUP BY name;

-- Analyze the cumulative revenue generated over time.

WITH CTE AS(
SELECT O.order_date, SUM(OD.quantity*P.price) revenue FROM orders O
JOIN order_details OD
USING(order_id)
JOIN pizzas P
USING(pizza_id)
GROUP BY O.order_date)

SELECT order_date, revenue, SUM(revenue) OVER(ORDER BY order_date) cumulative_revenue FROM CTE;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

WITH CTE AS(
SELECT PT.category, PT.name, SUM(OD.quantity*P.price) revenue,  
DENSE_RANK() OVER(PARTITION BY PT.category ORDER BY SUM(OD.quantity*P.price) DESC) rank_
FROM pizza_types PT
JOIN pizzas P
USING(pizza_type_id)
JOIN order_details OD
USING(pizza_id)
GROUP BY category, name)

SELECT category, name, revenue FROM CTE
WHERE rank_ < 4;
