/* =====================================================================
   Q1.8  Order Summary Report Across Five Tables
   (creates customers, products, orders, order_items, payments
    - reused in Q1.9)
   ===================================================================== */
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id    VARCHAR(5)  PRIMARY KEY,
    customer_name  VARCHAR(40),
    city           VARCHAR(30),
    signup_date    DATE
);

CREATE TABLE products (
    product_id    VARCHAR(5)  PRIMARY KEY,
    product_name  VARCHAR(40),
    category      VARCHAR(30),
    unit_price    INT
);

CREATE TABLE orders (
    order_id     INT         PRIMARY KEY,
    customer_id  VARCHAR(5)  REFERENCES customers(customer_id),
    order_date   DATE,
    status       VARCHAR(15)
);

CREATE TABLE order_items (
    order_id    INT         REFERENCES orders(order_id),
    product_id  VARCHAR(5)  REFERENCES products(product_id),
    qty         INT,
    unit_price  INT,
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE payments (                -- gateway does not check the order, so NO foreign key
    payment_id    VARCHAR(5)  PRIMARY KEY,
    order_id      INT,
    payment_date  DATE,
    amount        INT,
    method        VARCHAR(20)
);

INSERT INTO customers (customer_id, customer_name, city, signup_date)
VALUES ('C01', 'Rahul Mehta',     'Jaipur',   '2025-11-02'),
       ('C02', 'Priya Nair',      'Kochi',    '2025-12-15'),
       ('C03', 'Arjun Das',       'Kolkata',  '2026-01-08'),
       ('C04', 'Fatima Sheikh',   'Mumbai',   '2026-01-20'),
       ('C05', 'Karan Malhotra',  'Delhi',    '2026-02-11'),
       ('C06', 'Sneha Kulkarni',  'Pune',     '2026-02-25');

INSERT INTO products (product_id, product_name, category, unit_price)
VALUES ('P1', 'Wireless Mouse', 'Electronics',  799),
       ('P2', 'USB-C Hub',      'Electronics', 1999),
       ('P3', 'Notebook A5',    'Stationery',   120),
       ('P4', 'Gel Pen Pack',   'Stationery',   250),
       ('P5', 'Desk Lamp',      'Home',        1499),
       ('P6', 'Water Bottle',   'Home',         499);

INSERT INTO orders (order_id, customer_id, order_date, status)
VALUES (1001, 'C01', '2026-03-02', 'Delivered'),
       (1002, 'C02', '2026-03-03', 'Delivered'),
       (1003, 'C01', '2026-03-10', 'Delivered'),
       (1004, 'C03', '2026-03-12', 'Cancelled'),
       (1005, 'C04', '2026-03-15', 'Shipped'),
       (1006, 'C05', '2026-03-18', 'Delivered'),
       (1007, 'C01', '2026-04-01', 'Shipped'),
       (1008, 'C06', '2026-04-03', 'Pending');

INSERT INTO order_items (order_id, product_id, qty, unit_price)
VALUES (1001, 'P1',  2,  799),
       (1001, 'P3',  5,  120),
       (1002, 'P2',  1, 1999),
       (1003, 'P4',  2,  250),
       (1003, 'P6',  1,  499),
       (1004, 'P5',  1, 1499),
       (1005, 'P1',  1,  799),
       (1005, 'P2',  1, 1999),
       (1005, 'P3', 10,  120),
       (1006, 'P6',  3,  499),
       (1007, 'P5',  1, 1499),
       (1008, 'P4',  4,  250);

INSERT INTO payments (payment_id, order_id, payment_date, amount, method)
VALUES ('PM01', 1001, '2026-03-02', 2198, 'UPI'),
       ('PM02', 1002, '2026-03-03', 1000, 'Card'),
       ('PM03', 1002, '2026-03-05',  999, 'Card'),
       ('PM04', 1003, '2026-03-10',  500, 'UPI'),
       ('PM05', 1005, '2026-03-15', 3998, 'NetBanking'),
       ('PM06', 1006, '2026-03-18', 1497, 'UPI'),
       ('PM07', 1009, '2026-04-02',  750, 'UPI'),
       ('PM08', 1004, '2026-03-12', 1499, 'Card');

-- Order summary
-- order_items and payments are summed SEPARATELY (in sub-queries) and then joined
-- to orders, so a payment is never repeated once per item.
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    o.status,
    ISNULL(i.item_count, 0)                                   AS item_count,
    ISNULL(i.order_value, 0)                                  AS order_value,
    ISNULL(p.paid_amount, 0)                                  AS paid_amount,
    ISNULL(i.order_value, 0) - ISNULL(p.paid_amount, 0)       AS balance,
    CASE
        WHEN ISNULL(p.paid_amount, 0) >= ISNULL(i.order_value, 0) THEN 'Paid'
        WHEN ISNULL(p.paid_amount, 0) > 0                         THEN 'Partially Paid'
        ELSE 'Unpaid'
    END                                                       AS payment_status
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
LEFT JOIN (SELECT order_id,
                  SUM(qty)              AS item_count,
                  SUM(qty * unit_price) AS order_value
           FROM   order_items
           GROUP BY order_id) i ON i.order_id = o.order_id
LEFT JOIN (SELECT order_id,
                  SUM(amount) AS paid_amount
           FROM   payments
           GROUP BY order_id) p ON p.order_id = o.order_id
ORDER BY o.order_id;
GO
