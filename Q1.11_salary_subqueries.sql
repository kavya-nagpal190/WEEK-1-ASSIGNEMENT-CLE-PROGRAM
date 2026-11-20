-- Employee and department data
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    dept_id    INT         PRIMARY KEY,
    dept_name  VARCHAR(30),
    location   VARCHAR(30)
);

CREATE TABLE employees (
    emp_id      VARCHAR(5)  PRIMARY KEY,
    emp_name    VARCHAR(40),
    dept_id     INT         NULL,
    manager_id  VARCHAR(5)  NULL,
    salary      INT,
    hire_date   DATE
);

INSERT INTO departments (dept_id, dept_name, location)
VALUES (10, 'Leadership', 'Jaipur'),
       (20, 'Engineering', 'Bengaluru'),
       (30, 'Analytics',   'Pune'),
       (40, 'Finance',     'Mumbai'),
       (50, 'Legal',       'Delhi');

INSERT INTO employees (emp_id, emp_name, dept_id, manager_id, salary, hire_date)
VALUES ('E01', 'Asha Verma',    10,   NULL,  150000, '2018-04-01'),
       ('E02', 'Ravi Kumar',    20,   'E01',  95000, '2019-06-15'),
       ('E03', 'Meena Pillai',  20,   'E02',  72000, '2021-01-10'),
       ('E04', 'John Mathew',   20,   'E02',  72000, '2022-03-01'),
       ('E05', 'Sara Ali',      30,   'E01',  98000, '2019-09-20'),
       ('E06', 'Vivek Rao',     30,   'E05',  64000, '2023-02-14'),
       ('E07', 'Pooja Shah',    30,   'E05',  58000, '2024-07-01'),
       ('E08', 'Nikhil Jain',   20,   'E03',  55000, '2025-01-06'),
       ('E09', 'Tara Menon',    40,   'E01',  88000, '2020-11-11'),
       ('E10', 'Imran Qureshi', NULL, 'E01',  61000, '2025-08-18');
GO

-- Q1.11  Salary Benchmarks Using Subqueries  (uses employees)
-- 4th highest distinct salary
-- (a salary is 4th highest when exactly 3 distinct salaries are higher than it)
SELECT DISTINCT e1.salary AS fourth_highest_salary
FROM   employees e1
WHERE  3 = (SELECT COUNT(DISTINCT e2.salary)
            FROM   employees e2
            WHERE  e2.salary > e1.salary);

-- Employees above their department average
SELECT
    e.emp_name,
    e.dept_id,
    e.salary,
    (SELECT CAST(ROUND(AVG(CAST(x.salary AS DECIMAL(12,2))), 2) AS DECIMAL(12,2))
     FROM   employees x
     WHERE  x.dept_id = e.dept_id)                     AS dept_avg_salary
FROM employees e
WHERE e.dept_id IS NOT NULL
  AND e.salary > (SELECT AVG(CAST(x.salary AS DECIMAL(12,2)))
                  FROM   employees x
                  WHERE  x.dept_id = e.dept_id)
ORDER BY e.dept_id, e.salary DESC;

-- Managers and their direct reports
SELECT
    e.emp_id,
    e.emp_name,
    (SELECT COUNT(*) FROM employees r WHERE r.manager_id = e.emp_id) AS direct_reports
FROM employees e
WHERE EXISTS (SELECT 1 FROM employees r WHERE r.manager_id = e.emp_id)
ORDER BY e.emp_id;
GO
