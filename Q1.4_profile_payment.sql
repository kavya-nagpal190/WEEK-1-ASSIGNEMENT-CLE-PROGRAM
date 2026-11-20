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

/* =====================================================================
   Q1.4  Classify Incomplete Records Without Treating NULL as Zero
   (creates fee_payments - reused in Q1.5 and Q1.6)
   ===================================================================== */
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

-- Student profile status
SELECT
    student_id,
    student_name,
    x.missing_fields,
    CASE
        WHEN x.missing_fields = 0                    THEN 'Complete'
        WHEN email IS NULL AND phone IS NULL         THEN 'Contact Missing'
        ELSE 'Partially Complete'
    END AS profile_status
FROM students
CROSS APPLY (SELECT (CASE WHEN email IS NULL THEN 1 ELSE 0 END)
                  + (CASE WHEN phone IS NULL THEN 1 ELSE 0 END)
                  + (CASE WHEN city  IS NULL THEN 1 ELSE 0 END)
                  + (CASE WHEN dob   IS NULL THEN 1 ELSE 0 END) AS missing_fields) x
ORDER BY student_id;

-- Payment classification
SELECT
    payment_id,
    student_id,
    amount,
    status,
    CASE
        WHEN amount IS NULL     THEN 'Amount Missing'
        WHEN status <> 'Success' THEN 'Not Collected'
        ELSE 'Collected'
    END AS payment_class
FROM fee_payments
ORDER BY payment_id;

-- Average payment check
SELECT
    ROUND(AVG(CAST(amount AS DECIMAL(10,2))), 2)               AS avg_amount_correct,
    ROUND(AVG(CAST(ISNULL(amount, 0) AS DECIMAL(10,2))), 2)    AS avg_amount_wrong
FROM fee_payments;
GO
