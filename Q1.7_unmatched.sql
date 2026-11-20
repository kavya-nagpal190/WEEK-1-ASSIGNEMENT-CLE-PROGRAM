-- Student data
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id    INT          PRIMARY KEY,
    student_name  VARCHAR(50),
    gender        CHAR(1),
    city          VARCHAR(30),
    email         VARCHAR(60),
    phone         VARCHAR(10),
    dob           DATE,
    join_date     DATE
);

INSERT INTO students (student_id, student_name, gender, city, email, phone, dob, join_date)
VALUES (101, ' aarav sharma ', 'M', 'Jaipur',    'aarav.sharma@gmail.com', '9876543210', '2004-05-12', '2026-01-05'),
       (102, 'Diya Patel',     'F', 'Ahmedabad', 'diya.patel@yahoo.com',   NULL,         '2003-11-23', '2026-01-10'),
       (103, 'Kabir Singh',    'M', 'Delhi',     NULL,                     '9812345678', '2004-02-02', '2026-01-18'),
       (104, 'Meera Iyer',     'F', 'Chennai',   'meera.iyer@outlook.com', '9900112233', NULL,         '2026-02-03'),
       (105, 'rohan VERMA',    'M', 'Jaipur',    'rohan.verma@gmail.com',  '9811122233', '2005-07-30', '2026-02-14'),
       (106, 'Sana Khan',      'F', 'Delhi',     NULL,                     NULL,         NULL,         '2026-02-20'),
       (107, 'Ishaan Gupta',   'M', 'Pune',      'ishaan.gupta@gmail.com', '9822001100', '2004-09-09', '2026-03-01'),
       (108, 'Ananya Rao',     'F', NULL,        NULL,                     NULL,         '2003-12-19', '2026-03-05'),
       (109, 'Vikram Joshi',   'M', 'Jaipur',    'vikram.joshi@yahoo.com', '9876501234', '2004-01-25', '2026-03-11'),
       (110, 'Neha Kapoor',    'F', 'Mumbai',    'neha.kapoor@gmail.com',  '9800098000', '2005-03-14', '2026-03-20');
GO

-- Subject and enrollment data
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS subjects;

CREATE TABLE subjects (
    subject_id    VARCHAR(5)  PRIMARY KEY,
    subject_name  VARCHAR(40),
    fee           INT,
    max_seats     INT
);

CREATE TABLE enrollments (            -- migrated table: deliberately NO foreign keys
    enrollment_id  VARCHAR(5),
    student_id     INT,
    subject_id     VARCHAR(5),
    enroll_date    DATE
);

INSERT INTO subjects (subject_id, subject_name, fee, max_seats)
VALUES ('S01', 'SQL Fundamentals',    4000, 30),
       ('S02', 'Python Programming',  5000, 30),
       ('S03', 'Data Visualization',  3500, 20),
       ('S04', 'Statistics',          3000, 25),
       ('S05', 'Cloud Basics',        4500, 20),
       ('S06', 'Machine Learning',    6000, 15);

INSERT INTO enrollments (enrollment_id, student_id, subject_id, enroll_date)
VALUES ('E01', 101, 'S01', '2026-01-06'),
       ('E02', 101, 'S02', '2026-01-06'),
       ('E03', 102, 'S01', '2026-01-11'),
       ('E04', 103, 'S02', '2026-01-19'),
       ('E05', 103, 'S03', '2026-02-01'),
       ('E06', 104, 'S01', '2026-02-04'),
       ('E07', 105, 'S02', '2026-02-15'),
       ('E08', 105, 'S04', '2026-02-15'),
       ('E09', 107, 'S01', '2026-03-02'),
       ('E10', 107, 'S02', '2026-03-02'),
       ('E11', 108, 'S03', '2026-03-06'),
       ('E12', 109, 'S01', '2026-03-12'),
       ('E13', 110, 'S05', '2026-03-21'),
       ('E14', 112, 'S02', '2026-03-25');     -- student 112 does not exist -> not counted
GO

-- Q1.7  Find Unmatched Students, Customers and Orders
DROP TABLE IF EXISTS store_orders;
DROP TABLE IF EXISTS store_customers;

CREATE TABLE store_customers (
    customer_id    VARCHAR(5)  PRIMARY KEY,
    customer_name  VARCHAR(40),
    city           VARCHAR(30)
);

CREATE TABLE store_orders (            -- no foreign key; guest orders have NULL customer_id
    order_id     VARCHAR(6),
    customer_id  VARCHAR(5) NULL,
    order_date   DATE,
    amount       INT
);

INSERT INTO store_customers (customer_id, customer_name, city)
VALUES ('C01', 'Rahul Mehta',     'Jaipur'),
       ('C02', 'Priya Nair',      'Kochi'),
       ('C03', 'Arjun Das',       'Kolkata'),
       ('C04', 'Fatima Sheikh',   'Mumbai'),
       ('C05', 'Karan Malhotra',  'Delhi');

INSERT INTO store_orders (order_id, customer_id, order_date, amount)
VALUES ('O1001', 'C01', '2026-03-01', 1200),
       ('O1002', 'C02', '2026-03-02',  850),
       ('O1003', 'C01', '2026-03-05',  430),
       ('O1004', 'C07', '2026-03-06',  999),
       ('O1005', 'C04', '2026-03-08', 2100),
       ('O1006', NULL,  '2026-03-09',  300);

-- Students without enrollments
SELECT s.student_id, s.student_name, s.city
FROM   students s
WHERE  NOT EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id = s.student_id)
ORDER BY s.student_id;

-- Customers without orders
SELECT c.customer_id, c.customer_name, c.city
FROM   store_customers c
LEFT JOIN store_orders o ON o.customer_id = c.customer_id
WHERE  o.order_id IS NULL
ORDER BY c.customer_id;

-- Orders without a matching customer
SELECT
    o.order_id,
    o.customer_id,
    o.amount,
    CASE WHEN o.customer_id IS NULL THEN 'Guest order - no customer'
         ELSE 'Customer not found' END AS issue
FROM store_orders o
LEFT JOIN store_customers c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL
ORDER BY o.order_id;
GO
