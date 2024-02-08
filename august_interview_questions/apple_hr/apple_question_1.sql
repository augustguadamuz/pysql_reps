-- Question 1

-- Create and populate table to test queries

CREATE TABLE IF NOT EXISTS employee (
    employee_id INT PRIMARY KEY,
    department VARCHAR(20),
    job_level VARCHAR(10),
    employee_status VARCHAR(6),
    hire_date DATE,
    term_date DATE
);

INSERT INTO employee (employee_id, department, job_level, employee_status, hire_date, term_date)
VALUES
    (1, 'People', 'Senior', 'Active', '2020-01-01', NULL),
    (2, 'People', 'Senior', 'Active', '2021-10-15', NULL),
    (3, 'Product', 'Junior', 'Termed', '2018-06-08', '2023-01-17'),
    (4, 'Product', 'Mid-Level', 'Active', '1997-04-10', NULL),
    (5, 'Product', 'Senior', 'Active', '1985-02-03', NULL),
    (6, 'Marketing', 'Senior', 'Active', '2022-05-01', NULL),
    (7, 'Marketing', 'Junior', 'Active', '2021-10-02', NULL),
    (8, 'Marketing', 'Junior', 'Termed', '2023-01-01', '2023-12-25'),
    (9, 'People', 'Senior', 'Termed', '2020-03-01', '2023-12-22'),
    (10, 'People', 'Mid-Level', 'Active', '2019-08-20', NULL),
    (11, 'People', 'Mid-Level', 'Active', '2021-07-12', NULL),
    (12, 'Product', 'Senior', 'Active', '2017-12-05', NULL),
    (13, 'Product', 'Junior', 'Active', '2022-02-28', NULL),
    (14, 'Product', 'Mid-Level', 'Active', '2020-11-15', NULL),
    (15, 'Product', 'Senior', 'Active', '2018-04-10', NULL),
    (16, 'Marketing', 'Senior', 'Active', '2021-04-22', NULL),
    (17, 'Marketing', 'Junior', 'Active', '2022-09-30', NULL),
    (18, 'People', 'Senior', 'Active', '2023-03-15', NULL),
    (19, 'People', 'Mid-Level', 'Active', '2022-08-25', NULL),
    (20, 'People', 'Junior', 'Active', '2023-01-10', NULL),
    (21, 'People', 'Junior', 'Active', '1931-12-18', NULL), -- intentional to test stdev
    (22, 'People', 'Junior', 'Active', '2020-07-01', NULL),
    (23, 'People', 'Junior', 'Active', '2022-06-05', NULL),
    (24, 'Product', 'Junior', 'Active', '2023-02-15', NULL),
    (25, 'Product', 'Mid-Level', 'Active', '2023-03-20', NULL),
    (26, 'Marketing', 'Senior', 'Active', '2022-05-01', NULL),
    (27, 'Marketing', 'Junior', 'Active', '2023-04-10', NULL),
    (28, 'Marketing', 'Junior', 'Active', '2022-12-22', NULL),
    (29, 'Marketing', 'Junior', 'Active', '2021-11-28', NULL),
    (30, 'Marketing', 'Junior', 'Active', '2020-09-15', NULL),
    (31, 'Marketing', 'Junior', 'Active', '2023-02-28', NULL),
    (32, 'Marketing', 'Junior', 'Active', '2021-05-12', NULL),
    (33, 'Marketing', 'Junior', 'Active', '2022-04-01', NULL),
    (34, 'Marketing', 'Junior', 'Active', '2023-03-05', NULL),
    (35, 'Marketing', 'Junior', 'Active', '2020-08-20', NULL),
    (36, 'People', 'Junior', 'Active', '2023-01-17', NULL),
    (37, 'People', 'Junior', 'Active', '2023-01-17', NULL),
    (38, 'People', 'Junior', 'Active', '2023-01-17', NULL),
    (39, 'People', 'Junior', 'Active', '2023-01-17', NULL),
    (40, 'People', 'Junior', 'Active', '2023-01-17', NULL),
    (41, 'People', 'Junior', 'Active', '2023-01-17', NULL),
    (42, 'People', 'Junior', 'Active', '2023-01-17', NULL),
    (43, 'People', 'Junior', 'Active', '2023-01-17', NULL),
    (44, 'People', 'Junior', 'Active', '2023-01-17', NULL),
    (45, 'People', 'Junior', 'Active', '2023-01-17', NULL)
;

/*
Task 1
Write a SQL query to calculate the average tenure of active employees in each job level within each department. Assume today's date as the end date you need to calculate tenure for active employees.
*/

SELECT
    department,
    job_level,
    AVG(CURRENT_DATE - hire_date) AS tenure
FROM employee
WHERE employee_status = 'Active'
GROUP BY 1,2;


-- I would have used a datediff function but that is not supported by PostgreSQL (which is what I am using to test my queries)

/*
Task 2
Due to data error, there may be issues with term date and hire date. Write the issues that might occur in the date fields and how will you modify Task 1 to account for those conditions.

String instead of Date: Sometimes dates in a database are stored as a string instead of a DATE or TIMESTAMP field. In these caeses I would likely CAST the STRING to DATE:
CAST(hire_date AS DATE) AS hire_date

NULL hire_date: There could be a case where the hire date is NULL. In these cases I would likely inform someone of the issue and likely use a COALESCE function:
COALESCE(hire_date, CURRENT_DATE) AS hire_date

Incorrect date format: There could be a case where the date is stored incorrectly, such as MM-DD-YYYY (e.g. 12-25-2023). In these cases I would use a LIKE, CASE WHEN and SUBSTR function to reformat the dates. This is something that I would also recommend be done upstream in the data pipeline.

CASE 
    WHEN hire_date LIKE '____--__--__' THEN hire_date
    WHEN '__-__-____' THEN SUBSTR(hire_date, 7, 4) || '-' || SUBSTR(hire_date, 1, 2) || '-' || SUBSTR(4, 2)

*/

/*
Task 3
Write a SQL query to find the employee(s) in each department with the longest tenure, along with their tenure. Also, identify any employees whose tenure is more than two standard deviations above the average tenure for their department and job level.
*/

WITH employee_tenure AS (
    SELECT
        department,
        job_level,
        employee_id,
        CURRENT_DATE - hire_date AS tenure
    FROM
        employee
    WHERE
        employee_status = 'Active'
)
, department_max_tenure AS (
    SELECT
        department,
        MAX(tenure) AS max_tenure
    FROM
        employee_tenure
    GROUP BY
        1
)
, employees_with_longest_tenure AS (
    SELECT
        e.department,
        e.job_level,
        e.employee_id,
        e.tenure
    FROM
        employee_tenure e
    JOIN
        department_max_tenure dmt ON e.department = dmt.department AND e.tenure = dmt.max_tenure
)
, department_avgstdev AS (
    SELECT
        department,
        job_level,
        AVG(tenure) AS avg_tenure,
        STDDEV(tenure) AS stddev_tenure
    FROM
        employee_tenure
    GROUP BY
        1,2
)
, lt AS (
SELECT
    ewt.department,
    ewt.job_level,
    ewt.employee_id,
    ewt.tenure
FROM
    employees_with_longest_tenure ewt
ORDER BY
    1,2
)
, stdv AS (
SELECT
    e.department,
    e.job_level,
    e.employee_id,
    e.tenure
    -- DAS.avg_tenure,
    -- DAS.stddev_tenure,
    -- (DAS.avg_tenure + 2 * DAS.stddev_tenure)
FROM
    employee_tenure e
JOIN
    department_avgstdev das ON e.department = das.department AND e.job_level = das.job_level
WHERE
    e.tenure > (das.avg_tenure + 2 * das.stddev_tenure))

SELECT *
FROM lt 
UNION ALL
SELECT *
FROM stdv;