--total record in each table--
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_order_items FROM order_items;
SELECT COUNT(*) AS total_returns FROM returns;

--checking for duplicates
SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


--checking duplicates--
SELECT *
FROM customers
WHERE customer_id IS NULL;

SELECT *
FROM products
WHERE product_id IS NULL;

SELECT *
FROM orders
WHERE order_id IS NULL;

SELECT *
FROM order_items
WHERE  order_item_id IS NULL;

SELECT *
FROM returns
WHERE  return_id IS NULL;

select * from payments
where payment_id isnull;

--checking foreign key relation--
SELECT o.*
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

--checking invalid business values---
SELECT *
FROM order_items
WHERE quantity <= 0;

--checkin order_status_distributions--
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;