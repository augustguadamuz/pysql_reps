-- Question 2

-- Create and populate tables to test queries

-- Create Employees Table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    department_id INTEGER,
    job_level VARCHAR(20),
    tenure_in_level INTEGER,
    tenure INTEGER
);

-- Create Performance Table
CREATE TABLE performance (
    employee_id INTEGER,
    year INTEGER,
    performance_rating INTEGER
);

-- Create Engagement Survey Table
CREATE TABLE engagement_survey (
    employee_id INTEGER,
    year INTEGER,
    engagement_score INTEGER
);

INSERT INTO employees (employee_id, department_id, job_level, tenure_in_level, tenure)
VALUES
    (1, 1, 'Junior', 2, 3),
    (2, 1, 'Mid-level', 5, 7),
    (3, 1, 'Senior', 6, 8),
    (4, 2, 'Junior', 10, 12),
    (5, 2, 'Mid-level', 9, 10),
    (6, 2, 'Senior', 3, 13),
    (7, 3, 'Junior', 2, 2),
    (8, 3, 'Mid-level', 1, 3),
    (9, 3, 'Senior', 10, 12) ,
    (10, 4, 'Junior', 9, 12),
    (11, 4, 'Senior', 8, 10),
    (12, 4, 'Mid-level', 7, 8),
    (13, 5, 'Junior', 6, 7),
    (14, 5, 'Senior', 5, 6),
    (15, 5, 'Mid-level', 4, 5),
    (16, 6, 'Junior', 3, 4),
    (17, 7, 'Mid-level', 2, 3)
;

INSERT INTO performance (employee_id, year, performance_rating)
VALUES
    (1, 2023, 2),
    (2, 2023, 5),
    (3, 2023, 2),
    (4, 2023, 3),
    (5, 2023, 1),
    (6, 2023, 1),
    (7, 2023, 3),
    (8, 2023, 5),
    (9, 2023, 5),
    (10, 2023, 2),
    (11, 2023, 5),
    (12, 2023, 2),
    (13, 2023, 1),
    (14, 2023, 1),
    (15, 2023, 5),
    (16, 2023, 5),
    (17, 2023, 4),
    (1, 2022, 3),
    (2, 2022, 5),
    (3, 2022, 7),
    (4, 2022, 2),
    (5, 2022, 2),
    (6, 2022, 2),
    (7, 2022, 2),
    (8, 2022, 4),
    (9, 2022, 4),
    (10, 2022, 3),
    (11, 2022, 5),
    (12, 2022, 3),
    (13, 2022, 2),
    (14, 2022, 3),
    (15, 2022, 4),
    (16, 2022, 5),
    (17, 2022, 5)
;

INSERT INTO engagement_survey (employee_id, year, engagement_score)
VALUES
    (1, 2023, 10),
    (2, 2023, NULL),
    (3, 2023, 8),
    (4, 2023, 7),
    (5, 2023, 6),
    (6, 2023, 5),
    (7, 2023, 4),
    (8, 2023, 3),
    (9, 2023, 2),
    (10, 2023, 1),
    (11, 2023, 5),
    (12, 2023, 6),
    (13, 2023, 7),
    (14, 2023, 7),
    (15, 2023, 8),
    (16, 2023, 10),
    (17, 2023, 1),
    (1, 2022, 1),
    (2, 2022, NULL),
    (3, 2022, 8),
    (4, 2022, 10),
    (5, 2022, 6),
    (6, 2022, 6),
    (7, 2022, 7),
    (8, 2022, 8),
    (9, 2022, 9),
    (10, 2022, 10),
    (11, 2022, 10),
    (12, 2022, 3),
    (13, 2022, 3),
    (14, 2022, 3),
    (15, 2022, 3),
    (16, 2022, NULL),
    (17, 2022, 3)
;


/* Write a SQL query to show average score across the company */

-- This shows the average for all years
SELECT 
    AVG(engagement_score) AS average_engagement_score
FROM engagement_survey;

-- This shows the average across all years
SELECT 
    year,
    AVG(engagement_score) AS average_engagement_score
FROM engagement_survey
GROUP BY 1;

/* Construct a SQL query to identify the top 5 departments with the highest 
average engagement score among employees with a performance rating of 4 or above in 2023 */

SELECT
    e.department_id,
    AVG(es.engagement_score) AS average_engagement_score
FROM employees e
JOIN performance p ON e.employee_id = p.employee_id
JOIN engagement_survey es ON e.employee_id = es.employee_id
WHERE p.year = 2023 AND p.performance_rating >= 4
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5;

/* Only employees who responded to the survey will have a score.
Write a SQL query to show the top 5 departments with least participation rates in year 2022 and year 2023 */

WITH rate AS (
SELECT 
    e.department_id,
    es.year,
    COUNT(DISTINCT e.employee_id) AS employee_count,
    COUNT(DISTINCT CASE WHEN es.engagement_score IS NOT NULL THEN es.employee_id END) AS participating_employees,
    ROUND(COUNT(DISTINCT CASE WHEN es.engagement_score IS NOT NULL THEN es.employee_id END)*1.0 / COUNT(DISTINCT e.employee_id),2) AS participation_rate
FROM employees e
LEFT JOIN engagement_survey es ON e.employee_id = es.employee_id
WHERE es.year IN (2022, 2023)
GROUP BY 1, 2
ORDER BY 2 ASC, 5 ASC)

SELECT
    department_id,
    year,
    participation_rate
FROM (
SELECT 
*,
ROW_NUMBER() OVER (PARTITION BY year ORDER BY participation_rate ASC) AS drnk
FROM rate) z
WHERE drnk <= 5;

/* Create a SQL query to rank each department based on how much above or below 
    they score compared to the average company score 
    (Hint: Rank based on Company Avg Score – Department Avg Score) */

-- overall (all years)
WITH department_scores AS (
    SELECT
        e.department_id,
        AVG(es.engagement_score) AS department_avg_score
    FROM
        employees e
    JOIN
        engagement_survey es ON e.employee_id = es.employee_id
    WHERE
        es.year IN (2022, 2023)
    GROUP BY
        e.department_id
)
, avg_score AS (
    SELECT
        AVG(es.engagement_score) AS company_avg_score
    FROM
        engagement_survey es
    WHERE
        es.year IN (2022, 2023)
)
SELECT
    d.department_id,
    d.department_avg_score,
    (a.company_avg_score - d.department_avg_score) AS score_difference,
    DENSE_RANK() OVER (ORDER BY a.company_avg_score - d.department_avg_score DESC) AS drnk
FROM
    department_scores d
CROSS JOIN
    avg_score a
ORDER BY
    4;


-- split by year
WITH department_scores AS (
    SELECT
        e.department_id,
        es.year,
        AVG(es.engagement_score) AS department_avg_score
    FROM
        employees e
    JOIN
        engagement_survey es ON e.employee_id = es.employee_id
    WHERE
        es.year IN (2022, 2023)
    GROUP BY
        e.department_id, es.year
)
, avg_scores AS (
    SELECT
        year,
        AVG(es.engagement_score) AS company_avg_score
    FROM
        engagement_survey es
    WHERE
        es.year IN (2022, 2023)
    GROUP BY
        es.year
)
SELECT
    d.department_id,
    d.year,
    d.department_avg_score,
    a.company_avg_score,
    a.company_avg_score - d.department_avg_score AS score_difference,
    RANK() OVER (PARTITION BY d.year ORDER BY a.company_avg_score - d.department_avg_score) AS department_rank
FROM
    department_scores d
JOIN
    avg_scores a ON d.year = a.year
ORDER BY 2 ASC, 6 DESC;
