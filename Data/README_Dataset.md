# E-commerce Customer & Sales Analysis Dataset

Synthetic UAE e-commerce dataset created for portfolio learning and demonstration. It is not real customer or company data.

## Files
- customers.csv: 3,000 customers
- products.csv: 100 products across 5 categories
- orders.csv: 10,000 orders from 2023–2025
- order_items.csv: line-item details for each order
- returns.csv: return records linked to orders and order items
- payments.csv: payment records linked to orders

## Suggested relationships
- customers.customer_id -> orders.customer_id (one-to-many)
- orders.order_id -> order_items.order_id (one-to-many)
- products.product_id -> order_items.product_id (one-to-many)
- orders.order_id -> returns.order_id (one-to-many)
- order_items.order_item_id -> returns.order_item_id (one-to-many)
- orders.order_id -> payments.order_id (one-to-one)

## Important fields
- All monetary values are in AED.
- order_items.discount_aed is the total discount amount for that line.
- Gross line value = quantity * unit_price_aed.
- Net line value = quantity * unit_price_aed - discount_aed.
- Estimated line profit = net line value - quantity * unit_cost_aed (join products).
- Orders include Delivered, Cancelled, Returned and Processing statuses.
- Returns include return reason and return approval status.

## Practice questions
1. What are monthly revenue and order trends?
2. Which categories and products generate the most revenue and profit?
3. What is the average order value (AOV)?
4. What percentage of orders are cancelled or returned?
5. Which cities and acquisition channels bring the most valuable customers?
6. What is the repeat-customer rate?
7. What are the most common return reasons?
8. Which customer segments contribute most to revenue?
9. How does discounting affect estimated profit?
10. What recommendations could improve retention and reduce returns?

## Notes
This dataset is intentionally designed to be relational and suitable for PostgreSQL, Python (Pandas), and Power BI practice. Validate definitions carefully before calculating revenue: for example, decide whether cancelled, processing, and returned orders should be included in a given KPI.
