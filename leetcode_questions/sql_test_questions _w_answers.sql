/* 
SQL practice questions 
Everything that we do in SQL we will also do in python
*/

/*
Question 1

Write a solution to find the ids of products that are both low fat and recyclable.

Return the result table in any order.
*/


-- Create and populate the tables needed to work on the question

CREATE TABLE products (
product_id INT,
low_fats CHAR(1),
recyclable CHAR(1)
);

INSERT INTO products (product_id, low_fats, recyclable)
VALUES
    (0, 'Y', 'N'),
    (1, 'Y', 'Y'),
    (2, 'N', 'Y'),
    (3, 'Y', 'Y'),
    (4, 'N', 'N');

/*
Expected outcome

+-------------+
| product_id  |
+-------------+
| 1           |
| 3           |
+-------------+

*/

/* Question 2

Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| referee_id  | int     |
+-------------+---------+
In SQL, id is the primary key column for this table.
Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.
 

Find the names of the customer that are not referred by the customer with id = 2.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Customer table:
+----+------+------------+
| id | name | referee_id |
+----+------+------------+
| 1  | Will | null       |
| 2  | Jane | null       |
| 3  | Alex | 2          |
| 4  | Bill | null       |
| 5  | Zack | 1          |
| 6  | Mark | 2          |
+----+------+------------+
Output: 
+------+
| name |
+------+
| Will |
| Jane |
| Bill |
| Zack |
+------+

*/

-- Let's create the table we will need for the exercise

CREATE TABLE customer (
	id INT, 
	name VARCHAR(4),
	referee_id INT
	);

-- Let's insert the data into the newly created table

INSERT INTO customer (id, name, referee_id)
VALUES
	(1,'Will',null),
	(2,'Jane',null),
	(3,'Alex',2),
	(4,'Bill',null),
	(5,'Zack',1),
	(6,'Mark',2);

-- Find the names of the customer that are not referred by the customer with id = 2

SELECT name
FROM customer
WHERE COALESCE(referee_id,0) <> 2

-- OR

SELECT name
FROM customer
WHERE referee_id <> 2 OR referee_id IS NULL

/* Question 3

Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | null      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+
Output: 
+------+
| name |
+------+
| John |
+------+
*/

CREATE TABLE employee (
	id INT,
	name VARCHAR(5),
	department VARCHAR(1),
	managerid INT
);

INSERT INTO employee (id, name, department, managerid)
VALUES
(101, 'John', 'A', null),
(102, 'Dan', 'A', 101),
(103, 'James', 'A', 101),
(104, 'Amy', 'A', 101),
(105, 'Anne', 'A', 101),
(106, 'Ron', 'B' , 101);

-- there are several ways to construct the query

-- subquery

SELECT 
    e.name
FROM
(
SELECT
    managerid,
    COUNT(id) AS direct_reports
FROM employee
GROUP BY 1) f
JOIN employee e ON f.managerid = e.id
WHERE f.direct_reports >= 5;

-- it is nice to show knowledge of HAVING (used with aggregates)

SELECT name 
FROM employee 
WHERE id IN (
    SELECT managerId 
    FROM employee 
    GROUP BY managerId 
    HAVING COUNT(*) >= 5)

-- there are a lot of ways to answer this question, this one is my favorite

SELECT b.name
FROM Employee as a
INNER JOIN Employee as b ON a.managerId = b.id
GROUP BY a.managerId HAVING COUNT(a.id)>=5


/* Question 4

Table: Activity

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| machine_id     | int     |
| process_id     | int     |
| activity_type  | enum    |
| timestamp      | float   |
+----------------+---------+
The table shows the user activities for a factory website.
(machine_id, process_id, activity_type) is the primary key (combination of columns with unique values) of this table.
machine_id is the ID of a machine.
process_id is the ID of a process running on the machine with ID machine_id.
activity_type is an ENUM (category) of type ('start', 'end').
timestamp is a float representing the current time in seconds.
'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.
 

There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.

The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Activity table:
+------------+------------+---------------+-----------+
| machine_id | process_id | activity_type | timestamp |
+------------+------------+---------------+-----------+
| 0          | 0          | start         | 0.712     |
| 0          | 0          | end           | 1.520     |
| 0          | 1          | start         | 3.140     |
| 0          | 1          | end           | 4.120     |
| 1          | 0          | start         | 0.550     |
| 1          | 0          | end           | 1.550     |
| 1          | 1          | start         | 0.430     |
| 1          | 1          | end           | 1.420     |
| 2          | 0          | start         | 4.100     |
| 2          | 0          | end           | 4.512     |
| 2          | 1          | start         | 2.500     |
| 2          | 1          | end           | 5.000     |
+------------+------------+---------------+-----------+
Output: 
+------------+-----------------+
| machine_id | processing_time |
+------------+-----------------+
| 0          | 0.894           |
| 1          | 0.995           |
| 2          | 1.456           |
+------------+-----------------+

*/

DROP TABLE IF EXISTS activity;
CREATE TABLE IF NOT EXISTS activity (
	machine_id INT,
	process_id INT,
	activity_type ENUM,
	timestamp FLOAT(10)
);

INSERT INTO activity (machine_id, process_id, activity_type, timestamp)
VALUES
    (0, 0, 'start', 0.712),
    (0, 0, 'end', 1.520),
    (0, 1, 'start', 3.140),
    (0, 1, 'end', 4.120),
    (1, 0, 'start', 0.550),
    (1, 0, 'end', 1.550),
    (1, 1, 'start', 0.430),
    (1, 1, 'end', 1.420),
    (2, 0, 'start', 4.100),
    (2, 0, 'end', 4.512),
    (2, 1, 'start', 2.500),
    (2, 1, 'end', 5.000);

-- I like working with CTEs (just a personal preference)
WITH s AS (
SELECT
    machine_id,
    process_id,
    activity_type,
    timestamp
FROM activity
WHERE activity_type = 'start'
)

, e AS (
SELECT
    machine_id,
    process_id,
    activity_type,
    timestamp
FROM activity
WHERE activity_type = 'end'
)

, combine AS (
SELECT
    s.machine_id,
    s.process_id,
    s.activity_type,
    e.timestamp - s.timestamp AS time
FROM s
LEFT JOIN e ON s.machine_id = e.machine_id
AND s.process_id = e.process_id)

SELECT
    machine_id,
    ROUND(AVG(time),3) AS processing_time
FROM combine
GROUP BY machine_id

-- There is a more elegant query
-- The key is in the fact that the machines each run same number of processes

WITH t AS (
SELECT 
    machine_id,
    process_id,
    CASE WHEN activity_type = 'start' THEN timestamp*-1 ELSE timestamp END AS processing_time
FROM activity)

SELECT
    machine_id,
    ROUND(SUM(processing_time)*1.0/COUNT(DISTINCT process_id),3) AS processing_time
FROM t
GROUP BY machine_id

/* Question 5

Table: Sessions

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| user_id       | int      |
| session_start | datetime |
| session_end   | datetime |
| session_id    | int      |
| session_type  | enum     |
+---------------+----------+
session_id is column of unique values for this table.
session_type is an ENUM (category) type of (Viewer, Streamer).
This table contains user id, session start, session end, session id and session type.
Write a solution to find the number of streaming sessions for users whose first session was as a viewer.

Return the result table ordered by count of streaming sessions, user_id in descending order.

The result format is in the following example.

Example 1:

Input: 
Sessions table:
+---------+---------------------+---------------------+------------+--------------+
| user_id | session_start       | session_end         | session_id | session_type | 
+---------+---------------------+---------------------+------------+--------------+
| 101     | 2023-11-06 13:53:42 | 2023-11-06 14:05:42 | 375        | Viewer       |  
| 101     | 2023-11-22 16:45:21 | 2023-11-22 20:39:21 | 594        | Streamer     |   
| 102     | 2023-11-16 13:23:09 | 2023-11-16 16:10:09 | 777        | Streamer     | 
| 102     | 2023-11-17 13:23:09 | 2023-11-17 16:10:09 | 778        | Streamer     | 
| 101     | 2023-11-20 07:16:06 | 2023-11-20 08:33:06 | 315        | Streamer     | 
| 104     | 2023-11-27 03:10:49 | 2023-11-27 03:30:49 | 797        | Viewer       | 
| 103     | 2023-11-27 03:10:49 | 2023-11-27 03:30:49 | 798        | Streamer     |  
+---------+---------------------+---------------------+------------+--------------+
Output: 
+---------+----------------+
| user_id | sessions_count | 
+---------+----------------+
| 101     | 2              | 
+---------+----------------+
Explanation
- user_id 101, initiated their initial session as a viewer on 2023-11-06 at 13:53:42, followed by two subsequent sessions as a Streamer, the count will be 2.
- user_id 102, although there are two sessions, the initial session was as a Streamer, so this user will be excluded.
- user_id 103 participated in only one session, which was as a Streamer, hence, it won't be considered.
- User_id 104 commenced their first session as a viewer but didn't have any subsequent sessions, therefore, they won't be included in the final count. 
Output table is ordered by sessions count and user_id in descending order.

*/

-- I like this one as we get to show knowledge of several SQL functions

-- Create the Sessions table if it doesn't exist
CREATE TABLE IF NOT EXISTS Sessions (
    user_id INTEGER,
    session_start DATETIME,
    session_end DATETIME,
    session_id INTEGER,
    session_type TEXT
);

-- Insert data into the Sessions table
INSERT INTO Sessions (user_id, session_start, session_end, session_id, session_type)
VALUES
    ('101', '2023-11-06 13:53:42', '2023-11-06 14:05:42', '375', 'Viewer'),
    ('101', '2023-11-22 16:45:21', '2023-11-22 20:39:21', '594', 'Streamer'),
    ('102', '2023-11-16 13:23:09', '2023-11-16 16:10:09', '777', 'Streamer'),
    ('102', '2023-11-17 13:23:09', '2023-11-17 16:10:09', '778', 'Streamer'),
    ('101', '2023-11-20 07:16:06', '2023-11-20 08:33:06', '315', 'Streamer'),
    ('104', '2023-11-27 03:10:49', '2023-11-27 03:30:49', '797', 'Viewer'),
    ('103', '2023-11-27 03:10:49', '2023-11-27 03:30:49', '798', 'Streamer');

-- the SQL I came up with on the challenge is as follows:
-- find users that had their first session as a viewer
-- count the number of streaming sessions after the initial viewer session
WITH r AS (
SELECT
    user_id,
    session_start,
    session_id,
    session_type,
    DENSE_RANK() OVER (PARTITION BY user_id ORDER BY session_start ASC) drnk
FROM sessions
)

, vf AS (
SELECT user_id
FROM r
WHERE session_type = 'Viewer' AND drnk = 1
)

SELECT 
    r.user_id,
    COUNT(DISTINCT r.session_id) AS sessions_count
FROM r
JOIN vf ON r.user_id = vf.user_id -- fetch users with first session as Viewer
WHERE drnk > 1 AND session_type = 'Streamer'
GROUP BY 1
ORDER BY sessions_count DESC, r.user_id DESC;

-- this is the most efficient query on leetcode

WITH rank_info AS (
SELECT user_id, session_type, RANK() OVER (PARTITION BY user_id ORDER BY session_start) AS r FROM Sessions),

count_total AS (
SELECT user_id, COUNT(*) AS c FROM Sessions GROUP BY user_id
),

count_streamer AS (
SELECT user_id, count(*) AS c FROM Sessions WHERE session_type = 'Streamer' GROUP BY user_id)


SELECT a.user_id,  COALESCE(b.c, 0) AS sessions_count FROM count_total a
LEFT JOIN count_streamer b
ON a.user_id = b.user_id 
WHERE a.c > 1 AND a.user_id IN (SELECT user_id FROM rank_info WHERE r = 1 AND session_type = 'Viewer') ORDER BY sessions_count DESC, user_id DESC

/* for a bigger challenge you can use this dataset. The expected output is as follows:

| user_id | sessions_count |
| ------- | -------------- |
| 105     | 11             |
| 104     | 10             |
| 103     | 8              |
| 102     | 8              |
| 107     | 5              |
| 101     | 5              |

*/

-- Insert data into the Sessions table

CREATE TABLE IF NOT EXISTS sessions (
    user_id INTEGER,
    session_start DATETIME,
    session_end DATETIME,
    session_id INTEGER,
    session_type TEXT
);

INSERT INTO sessions (user_id, session_start, session_end, session_id, session_type)
VALUES
('105','45236.5789583333','45236.5872916667','375','Streamer'),
('104','45252.6981597222','45252.8606597222','594','Viewer'),
('102','45246.5577430556','45246.6737152778','777','Streamer'),
('100','45250.3028472222','45250.3563194444','315','Streamer'),
('106','45257.1325115741','45257.146400463','797','Viewer'),
('103','45234.6429282407','45234.958900463','939','Viewer'),
('106','45236.8184259259','45237.0413425926','776','Viewer'),
('100','45249.2597337963','45249.6208449074','813','Viewer'),
('106','45253.9041087963','45254.2381365741','510','Streamer'),
('106','45249.04625','45249.1052777778','723','Viewer'),
('104','45243.5508680556','45243.8251736111','906','Streamer'),
('104','45239.5085532407','45239.7675810185','216','Streamer'),
('102','45232.5778587963','45232.8841087963','623','Viewer'),
('100','45239.6481365741','45239.6793865741','631','Streamer'),
('101','45256.8343171296','45256.9912615741','309','Viewer'),
('104','45233.6576041667','45233.8548263889','179','Streamer'),
('100','45248.696712963','45248.959212963','452','Viewer'),
('104','45246.7225','45247.0648611111','447','Viewer'),
('107','45249.5524884259','45249.682349537','271','Viewer'),
('103','45251.0101157407','45251.201087963','884','Streamer'),
('103','45257.0130902778','45257.3700347222','283','Viewer'),
('101','45243.8291550926','45244.1874884259','353','Viewer'),
('105','45260.423912037','45260.5079398148','124','Viewer'),
('107','45247.9511805556','45248.2032638889','902','Streamer'),
('107','45260.2459837963','45260.5654282407','800','Streamer'),
('100','45240.5006134259','45240.8672800926','731','Streamer'),
('103','45255.4323842593','45255.8032175926','821','Streamer'),
('100','45254.0413425926','45254.1350925926','129','Streamer'),
('102','45239.3038078704','45239.6135300926','530','Streamer'),
('104','45256.0594675926','45256.3566898148','160','Streamer'),
('101','45260.6139814815','45260.7556481482','702','Streamer'),
('106','45250.2441203704','45250.2566203704','477','Viewer'),
('100','45260.1107291667','45260.4065625','131','Viewer'),
('106','45257.1491087963','45257.4004976852','908','Viewer'),
('104','45257.8216435185','45258.1716435185','419','Viewer'),
('106','45250.3728240741','45250.424212963','317','Streamer'),
('105','45234.5043634259','45234.6057523148','464','Viewer'),
('104','45241.2726273148','45241.5830439815','838','Streamer'),
('100','45238.7400347222','45239.0560069445','280','Streamer'),
('105','45235.3403125','45235.3458680556','344','Streamer'),
('104','45259.3054282407','45259.6130671296','475','Streamer'),
('102','45248.5044328704','45248.6204050926','325','Streamer'),
('103','45246.6972685185','45246.7326851852','498','Viewer'),
('106','45248.6673611111','45248.7048611111','517','Viewer'),
('104','45243.0257986111','45243.2549652778','667','Streamer'),
('104','45237.2061805556','45237.5457638889','469','Viewer'),
('102','45240.7503356481','45240.7836689815','920','Streamer'),
('105','45241.6197337963','45241.8211226852','922','Streamer'),
('105','45236.1909027778','45236.375625','932','Viewer'),
('106','45245.642962963','45245.830462963','962','Streamer'),
('106','45247.5835185185','45247.8682407407','516','Viewer'),
('103','45258.3863425926','45258.4648148148','273','Streamer'),
('100','45259.990625','45260.2461805556','635','Streamer'),
('102','45259.4718518519','45259.6225462963','889','Viewer'),
('104','45233.0196527778','45233.141875','668','Viewer'),
('103','45254.4499305556','45254.5853472222','267','Viewer'),
('104','45249.0329513889','45249.1058680556','892','Streamer'),
('107','45249.3037847222','45249.6232291667','801','Viewer'),
('100','45252.1920833333','45252.4719444444','640','Streamer'),
('104','45246.5399074074','45246.8162962963','750','Streamer'),
('100','45254.4225','45254.4377777778','629','Viewer'),
('105','45254.1562962963','45254.460462963','603','Streamer'),
('105','45256.108912037','45256.2012731481','722','Streamer'),
('103','45235.6417939815','45235.7022106481','163','Viewer'),
('100','45239.0470023148','45239.1275578704','956','Viewer'),
('103','45250.7212731482','45250.8684953704','707','Streamer'),
('105','45245.9858912037','45246.3726967593','874','Streamer'),
('103','45244.1322453704','45244.3725231482','919','Viewer'),
('105','45236.452337963','45236.539837963','915','Streamer'),
('102','45253.4214699074','45253.4304976852','714','Viewer'),
('101','45247.6613078704','45247.9036689815','334','Streamer'),
('105','45242.9011689815','45243.1726967593','875','Streamer'),
('103','45260.9472916667','45261.3285416667','450','Streamer'),
('103','45242.5845833333','45242.7741666667','165','Viewer'),
('107','45255.4233217593','45255.6031828704','958','Streamer'),
('101','45235.8903356481','45236.2410300926','528','Viewer'),
('102','45251.9421527778','45252.3532638889','471','Streamer'),
('105','45241.5678703704','45241.8206481481','487','Streamer'),
('107','45234.2624537037','45234.5471759259','614','Viewer'),
('105','45251.5307986111','45251.6321875','430','Streamer'),
('105','45253.9744097222','45254.2570486111','444','Viewer'),
('105','45252.8152430556','45252.8680208333','628','Viewer'),
('104','45237.7365046296','45237.801087963','986','Streamer'),
('107','45239.4287731481','45239.4766898148','275','Viewer'),
('103','45240.9679861111','45241.0547916667','292','Viewer'),
('102','45247.4704513889','45247.7968402778','703','Viewer'),
('106','45246.7059606482','45246.9830439815','595','Streamer'),
('103','45239.8954050926','45240.2697106482','379','Streamer'),
('105','45243.6052777778','45243.8233333333','613','Viewer'),
('101','45260.4430324074','45260.7208101852','125','Streamer'),
('102','45254.7893402778','45255.0886458333','592','Streamer'),
('107','45235.805775463','45236.024525463','151','Viewer'),
('103','45235.8369560185','45236.1070949074','262','Streamer'),
('101','45238.2216435185','45238.3841435185','414','Streamer'),
('104','45248.5568171296','45248.6915393519','981','Viewer'),
('101','45257.362650463','45257.5480671296','312','Viewer'),
('107','45235.7425694444','45236.1127083333','646','Viewer'),
('100','45245.4569560185','45245.4729282407','957','Streamer'),
('105','45258.607025463','45258.6681365741','493','Viewer'),
('107','45249.8338773148','45250.118599537','659','Viewer'),
('105','45245.2143865741','45245.2317476852','967','Streamer'),
('101','45256.0681712963','45256.272337963','636','Streamer'),
('104','45243.1244791667','45243.2126736111','809','Viewer'),
('102','45234.9145023148','45235.0214467593','217','Viewer'),
('102','45237.8317592593','45238.0831481482','905','Viewer'),
('106','45232.2193055556','45232.4206944444','952','Streamer'),
('107','45254.4948148148','45254.6142592593','682','Streamer'),
('100','45241.6559606481','45241.9649884259','868','Viewer'),
('107','45243.6293981482','45243.8828703704','196','Streamer'),
('104','45249.8037152778','45250.1988541667','141','Viewer'),
('105','45236.0873611111','45236.31375','405','Viewer'),
('103','45260.1845717593','45260.2470717593','658','Viewer'),
('102','45255.6535648148','45255.8959259259','724','Streamer'),
('100','45245.3322106482','45245.5981828704','897','Streamer'),
('100','45252.4781365741','45252.8198032407','445','Viewer'),
('103','45251.1023263889','45251.1696875','980','Streamer'),
('102','45248.3070486111','45248.6403819444','605','Streamer');

/*
Question 6

Table: World

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
| area        | int     |
| population  | int     |
| gdp         | bigint  |
+-------------+---------+
name is the primary key (column with unique values) for this table.
Each row of this table gives information about the name of a country, 
the continent to which it belongs, its area, the population, and its GDP value.

A country is big if:

it has an area of at least three million (i.e., 3000000 km2), or
it has a population of at least twenty-five million (i.e., 25000000).
Write a solution to find the name, population, and area of the big countries.

Return the result table in any order.

The result format is in the following example.

Example 1:

Input: 
World table:
+-------------+-----------+---------+------------+--------------+
| name        | continent | area    | population | gdp          |
+-------------+-----------+---------+------------+--------------+
| Afghanistan | Asia      | 652230  | 25500100   | 20343000000  |
| Albania     | Europe    | 28748   | 2831741    | 12960000000  |
| Algeria     | Africa    | 2381741 | 37100000   | 188681000000 |
| Andorra     | Europe    | 468     | 78115      | 3712000000   |
| Angola      | Africa    | 1246700 | 20609294   | 100990000000 |
+-------------+-----------+---------+------------+--------------+
Output: 
+-------------+------------+---------+
| name        | population | area    |
+-------------+------------+---------+
| Afghanistan | 25500100   | 652230  |
| Algeria     | 37100000   | 2381741 |
+-------------+------------+---------+

*/

SELECT
    name,
    population,
    area
FROM world
WHERE area >= 3000000
OR population >= 25000000;

/*

Question 7

Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the column with unique values for this table.
This table contains information about the temperature on a certain day.
 

Write a solution to find all dates' Id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.

The result format is in the following example.

*/

-- I like this one as it is a one table problem, but the table needs to be joined to itself
-- We need to use a condition in the JOIN -> we want the join to return a view of the temp for
-- current date and the previous date

SELECT id
FROM weather w1
JOIN weather w2 ON DATEDIFF(w1.recorddate, w2.recorddate) = 1
WHERE w1.tempurature > w2.tempurature

