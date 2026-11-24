-- =====================================================
-- PROJECT: E-COMMERCE SALES ANALYSIS
-- TOOL: PostgreSQL
-- PURPOSE: Analyze sales, products and customers
-- =====================================================


-- =====================================================
-- 01. SALES PERFORMANCE ANALYSIS
-- =====================================================
-- 1. Order status distribution

SELECT
    order_status,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- calculating total orders, cancelled_orders and cancelation rate--
select 
count(*) as total_orders,
sum
(case 
       when order_status='Cancelled' then 1 else 0 end
	   ) as total_cancelled_orders,
round
      ( 
	    100* sum(case when order_status='Cancelled' then 1 else 0 end)/count(*)
		,2)as cancelation_rate
from orders;

-- 2. Total revenue and quantity sold


SELECT 
 sum((oi.quantity * oi.unit_price_aed)-oi.discount_aed )as total_revenue,
 sum(oi.quantity) as total_quantity_sold,
 count(distinct oi.order_id)as total_uniq_order
 from order_items oi
 inner join orders o
 on oi.order_id=o.order_id
 where o.order_status='Delivered';
 
-- 3. Gross profit and gross profit margin
---profit calculation---

select 
sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed) as total_revenue,
sum(oi.quantity * p.unit_cost_aed)as total_product_cost,
sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed)-sum(oi.quantity * p.unit_cost_aed) as profit
from order_items oi
inner join orders o
 on oi.order_id=o.order_id
inner join products p
on oi.product_id = p.product_id
where o.order_status='Delivered';


--profit margin--

select 
sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed) as total_revenue,
sum(oi.quantity * p.unit_cost_aed)as total_product_cost,
sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed)-sum(oi.quantity * p.unit_cost_aed) as profit,
round(100*((sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed)-sum(oi.quantity * p.unit_cost_aed))/sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed)),2)as profit_margin
from order_items oi
inner join orders o
 on oi.order_id=o.order_id
inner join products p
on oi.product_id = p.product_id
where o.order_status='Delivered';

-- 4. Category-wise sales and profitability

--which product catagory generate highest revenue and profit--
select p.category,
sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed) as total_revenue,
sum(oi.quantity * p.unit_cost_aed)as total_product_cost,
sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed)-sum(oi.quantity * p.unit_cost_aed) as profit,
round(100*((sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed)-sum(oi.quantity * p.unit_cost_aed))/sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed)),2)as profit_margin
from order_items oi
inner join orders o
 on oi.order_id=o.order_id
inner join products p
on oi.product_id = p.product_id
where o.order_status='Delivered'
group by p.category
order by profit desc;


-- =====================================================
-- 02. PRODUCT ANALYSIS
-- =====================================================
--5. Top 10 products by revenue--

select p.product_id,
p.product_name,
sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed) as total_revenue
from order_items oi
inner join products p
on oi.product_id= p.product_id
inner join  orders o
on oi.order_id= o.order_id
where order_status='Delivered'
group by p.product_id,p.product_name
order by total_revenue desc
limit 10;

---top 10 product by profit---
select p.product_id,
p.product_name,
sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed) as total_revenue,
sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed)-sum(oi.quantity * p.unit_cost_aed) as profit,
round(100*((sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed)-sum(oi.quantity * p.unit_cost_aed))/sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed)),2)as profit_margin
from order_items oi
inner join products p
on oi.product_id= p.product_id
inner join  orders o
on oi.order_id= o.order_id
where order_status='Delivered'
group by p.product_id,p.product_name
order by profit desc
limit 10;

-- =====================================================
-- 03. CUSTOMER ANALYSIS
-- =====================================================

--customer hving more than 1 deliverde order--

select c.customer_id,
count(DISTINCT o.order_id) as total_orders,
sum ((oi.quantity * oi.unit_price_aed)-oi.discount_aed) as total_revenue
from  orders o
inner join customers c
on o.customer_id= c.customer_id
inner join order_items oi
on o.order_id= oi.order_id
where o.order_status='Delivered'
group by c.customer_id
having count(DISTINCT o.order_id) >1
order by total_revenue desc;


--top 10 customers having highest revenue--
select c.customer_id,
 sum((oi.quantity * oi.unit_price_aed)-oi.discount_aed )as total_revenue
 from orders o
 inner join customers c
 on o.customer_id=c.customer_id
 inner join order_items oi
 on oi.order_id=o.order_id
 where o.order_status= 'Delivered'
 and o.order_date >= '2025-01-01'
 and o.order_date < '2026-01-01'
 group by c.customer_id
 order by total_revenue desc
 limit 10;

-- 9. Customer retention analysis

--december customers--
SELECT DISTINCT customer_id
FROM orders
WHERE order_status = 'Delivered'
AND order_date >= '2025-11-01'
AND order_date < '2025-12-01';

--customer retention rate--

WITH november_customers AS (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE order_status = 'Delivered'
    AND order_date >= '2025-11-01'
    AND order_date < '2025-12-01'
),

december_customers AS (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE order_status = 'Delivered'
    AND order_date >= '2025-12-01'
    AND order_date < '2026-01-01'
)
SELECT
    COUNT(n.customer_id) AS november_customers,

    COUNT(d.customer_id) AS returning_customers,

    ROUND(
        100.0 * COUNT(d.customer_id)
        / NULLIF(COUNT(n.customer_id), 0),
        2
    ) AS retention_rate

FROM november_customers n

LEFT JOIN december_customers d
    ON n.customer_id = d.customer_id;

-- 10. Repeat purchase rate--
with repeat_customer as(
select 
customer_id,
count(distinct order_id) as total_orders
from orders 
where order_status='Delivered'
group by customer_id
having count(distinct order_id)>1),
total_customer as
(
select count(distinct customer_id) as total_customer
from orders
where order_status='Delivered'
),
total_repeat as(select count(*) as repeat_customers
from repeat_customer
)
select r.repeat_customers,
       t.total_customer,
	   round(100* r.repeat_customers/nullif(t.total_customer,0),2)as repeat_purchase_rate
	   from total_customer t
	   cross join total_repeat r;

-- 11. Customer segmentation--
WITH customer_orders AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(
            (oi.quantity * oi.unit_price_aed) - oi.discount_aed
        ) AS total_revenue
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.customer_id
),
customer_segments AS (
    SELECT
        customer_id,
        total_orders,
        total_revenue,
        CASE
            WHEN total_orders = 1 THEN 'One-time Customer'
            WHEN total_orders > 1 THEN 'Repeat Customer'
        END AS customer_type,
        CASE
            WHEN total_revenue > 10000 THEN 'High-value Customer'
            ELSE 'Regular-value Customer'
        END AS value_segment
    FROM customer_orders
)
SELECT
    customer_type,
    value_segment,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_customer_revenue
FROM customer_segments
GROUP BY customer_type, value_segment
ORDER BY customer_type, value_segment;


-- =====================================================
-- 04. TIME-BASED ANALYSIS
-- =====================================================
-- 13. Monthly sales trend

select 
 Date_trunc('month',o.order_date) as order_month,
 count(distinct o.order_id) as total_orders,
 sum(oi.quantity) as total_quanity_sold,
 sum((oi.quantity * oi.unit_price_aed)-oi.discount_aed )as total_revenue
 from orders o
 inner join order_items oi 
 on o.order_id=oi.order_id
 where o.order_status ='Delivered'
 and  extract (year from o.order_date)=2025
 GROUP BY DATE_TRUNC('month', o.order_date)
 ORDER BY  order_month;

-- 14. Month-over-month revenue growth

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS order_month,
        SUM((oi.quantity * oi.unit_price_aed) - oi.discount_aed)
            AS total_revenue
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
      AND o.order_date >= '2025-01-01'
      AND o.order_date < '2026-01-01'
    GROUP BY DATE_TRUNC('month', o.order_date)
),

revenue_comparison AS (
    SELECT
        order_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    order_month,
    total_revenue,
    previous_month_revenue,
    ROUND(
        100.0 * (total_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS growth_percentage
FROM revenue_comparison
ORDER BY order_month;

-- =====================================================
-- SECTION 05: ORDER ANALYSIS
-- =====================================================


-- 15. Order cancellation rate
select * from orders;
with total_orders as
(select
count(distinct order_id) as total_orderss
from orders
),
canceled_orders as(
select
count(distinct order_id)as total_canceled_orders
from orders
where order_status='Cancelled'
)
select o.total_orderss,
       c.total_canceled_orders,
	   round(
       100.0 *c.total_canceled_orders/nullif (o.total_orderss,0),
	   2)as cancelation_rate
from total_orders o
cross join canceled_orders c;

-- 16. Average order value (AOV)
select
count (distinct o.order_id) as total_orders,
sum((oi.quantity * oi.unit_price_aed)-oi.discount_aed )as total_revenue,
round(
100.0 *sum((oi.quantity * oi.unit_price_aed)-oi.discount_aed )/nullif (count (distinct o.order_id),0),2
) as aov
from orders o
inner join order_items oi
on o.order_id=oi.order_id
where o.order_status='Delivered';

-- =====================================================
-- SECTION 06: RETURN ANALYSIS
-- =====================================================

-- 17. Approved order return rate
with delivered_order as
(select
   count(distinct order_id)as total_delivered_orders
   from orders
   where order_status='Delivered'
   ),
approved_returns as
(select 
 count(distinct order_id)as total_returned_orders
 from returns
 where return_status='Approved'
 )
select
d.total_delivered_orders,
r.total_returned_orders,
ROUND(
        100.0 * r.total_returned_orders /
        NULLIF(d.total_delivered_orders, 0), 2
    ) AS order_return_rate
FROM delivered_order d
cross join approved_returns r;
