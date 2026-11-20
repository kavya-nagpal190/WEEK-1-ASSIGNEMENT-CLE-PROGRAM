-- Payment data
DROP TABLE IF EXISTS fee_payments;

CREATE TABLE fee_payments (
    payment_id    VARCHAR(5)  PRIMARY KEY,
    student_id    INT,
    subject_id    VARCHAR(5),
    payment_date  DATE,
    amount        INT         NULL,
    status        VARCHAR(10)
);

INSERT INTO fee_payments (payment_id, student_id, subject_id, payment_date, amount, status)
VALUES ('P01', 101, 'S01', '2026-01-06', 4000, 'Success'),
       ('P02', 101, 'S02', '2026-01-20', 5000, 'Success'),
       ('P03', 102, 'S01', '2026-01-11', 4000, 'Failed'),
       ('P04', 102, 'S01', '2026-01-12', 4000, 'Success'),
       ('P05', 103, 'S02', '2026-01-19', 2500, 'Success'),
       ('P06', 103, 'S03', '2026-02-01', 3500, 'Success'),
       ('P07', 104, 'S01', '2026-02-04', 4000, 'Success'),
       ('P08', 105, 'S02', '2026-02-15', 5000, 'Success'),
       ('P09', 105, 'S04', '2026-02-16', NULL, 'Pending'),
       ('P10', 103, 'S02', '2026-02-19', 2500, 'Success'),
       ('P11', 107, 'S01', '2026-03-02', 4000, 'Success'),
       ('P12', 107, 'S02', '2026-03-03', 5000, 'Refunded'),
       ('P13', 108, 'S03', '2026-03-06', 3500, 'Success'),
       ('P14', 109, 'S01', '2026-03-12', 4000, 'Success'),
       ('P15', 110, 'S05', '2026-03-21', 4500, 'Success');
GO

-- Subject data
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

-- Q1.6  Calculate Monthly Revenue  (uses fee_payments and subjects)
-- Monthly revenue
SELECT
    CONVERT(CHAR(7), payment_date, 120)                                          AS pay_month,   -- YYYY-MM
    SUM(CASE WHEN status = 'Success' THEN 1 ELSE 0 END)                          AS successful_payments,
    SUM(CASE WHEN status = 'Success' THEN amount ELSE 0 END)                     AS total_revenue,
    CAST(AVG(CASE WHEN status = 'Success' THEN CAST(amount AS DECIMAL(10,2)) END)
         AS DECIMAL(10,2))                                                       AS avg_payment,
    SUM(CASE WHEN status <> 'Success' THEN 1 ELSE 0 END)                         AS other_payments
FROM fee_payments
GROUP BY CONVERT(CHAR(7), payment_date, 120)
HAVING SUM(CASE WHEN status = 'Success' THEN amount ELSE 0 END) >= 15000
ORDER BY pay_month;

-- Revenue by subject
SELECT
    sb.subject_name,
    SUM(fp.amount) AS total_revenue
FROM fee_payments fp
JOIN subjects sb ON sb.subject_id = fp.subject_id
WHERE fp.status = 'Success'
GROUP BY sb.subject_name
HAVING SUM(fp.amount) > 8000
ORDER BY total_revenue DESC;
GO
