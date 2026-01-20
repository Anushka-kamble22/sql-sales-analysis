CREATE DATABASE Pizzahut;

CREATE TABLE orders (
order_id INT NOT NULL,
order_date DATE NOT NULL,
order_time TIME NOT NULL,
PRIMARY KEY(order_id) );


CREATE TABLE order_details (
order_details_id INT NOT NULL,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY(order_details_id) );


-- Retrieve the total number of orders placed 
SELECT COUNT(order_id) AS total_orders
FROM orders;


-- Calculate the total revenue generated from pizza sales 
SELECT 
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;




-- Identify the highest-priced pizza
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY price DESC
LIMIT 1;

-- Identify the most common pizza size ordered
SELECT 
    pizzas.size, COUNT(order_details.order_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1; 


-- List the top 5 most ordered pizza types along with their quantities
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

-- Intermediate
-- Join the necessary tables to find the total quantity of each pizza category ordered
SELECT SUM(order_details.quantity) AS quantity , pizza_types.category
FROM order_details
JOIN pizzas
	ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types
	ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category;


-- Determaine the distribution of orders by hour of the day
SELECT 
    HOUR(order_time) AS Hour, COUNT(order_id) AS total_orders
FROM
    orders
GROUP BY HOUR(order_time);


-- Join relevant tables to find the category wise distribution of pizzas 
SELECT 
    COUNT(name), category
FROM
    pizza_types
GROUP BY category;


-- Group the orders by date and calculate the average number of pizzas ordered per day
SELECT AVG(quantity) AS avg_pizza_ordered_per_day
 FROM
(SELECT  orders.order_date , SUM(order_details.quantity) AS quantity
FROM orders 
JOIN order_details
	ON order_details.order_id = orders.order_id
GROUP BY orders.order_date) AS sum_data;



-- Determine the top 3 most ordered pizza types  based on revenue
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_revenue DESC
LIMIT 3;

-- Calculate the percentage contribution of each pizza type to tota revenue
SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;


-- Analyze the cumulative revenue generated over time
SELECT 
	order_date , 
    ROUND(SUM(revenue) OVER (ORDER BY order_date),2)  AS cummulative_revenue
FROM
	(SELECT orders.order_date , SUM(order_details.quantity * pizzas.price) AS revenue
FROM 
	order_details
		JOIN 
	pizzas
		ON order_details.pizza_id = pizzas.pizza_id
	JOIN orders
		ON orders.order_id = order_details.order_id
GROUP BY orders.order_date) AS sales;









 













