-- Q1.12  Compare CRM and Billing Customer Lists (set operations)
DROP TABLE IF EXISTS crm_customers;
DROP TABLE IF EXISTS billing_customers;

CREATE TABLE crm_customers     (customer_id VARCHAR(5), email VARCHAR(50));   -- no PK: export has a duplicate
CREATE TABLE billing_customers (customer_id VARCHAR(5), email VARCHAR(50));

INSERT INTO crm_customers (customer_id, email)
VALUES ('C01', 'rahul.mehta@mail.com'),
       ('C02', 'priya.nair@mail.com'),
       ('C02', 'priya.nair@mail.com'),      -- duplicate row
       ('C03', 'arjun.das@mail.com'),
       ('C04', 'fatima.s@mail.com');

INSERT INTO billing_customers (customer_id, email)
VALUES ('C02', 'priya.nair@mail.com'),
       ('C04', 'fatima.s@mail.com'),
       ('C05', 'karan.m@mail.com'),
       ('C06', 'sneha.k@mail.com');

-- Customers in both systems
SELECT customer_id, email FROM crm_customers
INTERSECT
SELECT customer_id, email FROM billing_customers
ORDER BY customer_id;

-- Customers only in CRM
SELECT customer_id, email FROM crm_customers
EXCEPT
SELECT customer_id, email FROM billing_customers
ORDER BY customer_id;

-- Customers only in billing
SELECT customer_id, email FROM billing_customers
EXCEPT
SELECT customer_id, email FROM crm_customers
ORDER BY customer_id;

-- Compare UNION and UNION ALL
SELECT
    (SELECT COUNT(*) FROM (SELECT customer_id, email FROM crm_customers
                           UNION
                           SELECT customer_id, email FROM billing_customers) u)   AS union_rows,
    (SELECT COUNT(*) FROM (SELECT customer_id, email FROM crm_customers
                           UNION ALL
                           SELECT customer_id, email FROM billing_customers) ua)  AS union_all_rows;
GO
