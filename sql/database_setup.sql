
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE,
    customer_segment VARCHAR(30),
    acquisition_channel VARCHAR(50)
);

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price_aed NUMERIC(10,2),
    unit_cost_aed NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) REFERENCES customers(customer_id),
    order_date DATE,
    order_status VARCHAR(30),
    payment_method VARCHAR(50),
    delivery_city VARCHAR(50),
    shipping_fee_aed NUMERIC(10,2)
);

CREATE TABLE order_items (
    order_item_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) REFERENCES orders(order_id),
    product_id VARCHAR(20) REFERENCES products(product_id),
    quantity INTEGER,
    unit_price_aed NUMERIC(10,2),
    discount_aed NUMERIC(10,2)
);

CREATE TABLE returns (
    return_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) REFERENCES orders(order_id),
    order_item_id VARCHAR(20) REFERENCES order_items(order_item_id),
    return_date DATE,
    return_reason VARCHAR(100),
    return_status VARCHAR(30)
);

CREATE TABLE payments (
    payment_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) REFERENCES orders(order_id),
    payment_date DATE,
    payment_method VARCHAR(50),
    payment_status VARCHAR(30)
);