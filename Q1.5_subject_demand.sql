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

-- Q1.5  Calculate Subject Demand
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

-- Subject demand
-- LEFT JOIN keeps subjects with no enrollments; the second LEFT JOIN to students
-- makes sure only enrollments of existing students are counted.
SELECT
    sb.subject_id,
    sb.subject_name,
    COUNT(st.student_id)                         AS enrolled_students,
    sb.max_seats - COUNT(st.student_id)          AS seats_left,
    CASE
        WHEN COUNT(st.student_id) >= 4 THEN 'High'
        WHEN COUNT(st.student_id) >= 2 THEN 'Medium'
        WHEN COUNT(st.student_id) = 1  THEN 'Low'
        ELSE 'No Demand'
    END                                          AS demand_level
FROM subjects sb
LEFT JOIN enrollments e ON e.subject_id = sb.subject_id
LEFT JOIN students   st ON st.student_id = e.student_id
GROUP BY sb.subject_id, sb.subject_name, sb.max_seats
ORDER BY enrolled_students DESC, sb.subject_id;
GO
