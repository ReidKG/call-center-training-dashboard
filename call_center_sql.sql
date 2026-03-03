select *
from agent_schedule;
select *
from agents;
select*
from call_quality;
select *
from calls;
select *
from customers;
select *
from departments;
select *
from escalations;
select *
from training_sessions;

-- Cleaning

-- PK_cleaning

select schedule_id, count(*)  -- selects column, count counts how many times a schedule_id appears in the table
from agent_schedule -- tells sql where to look for info
group by schedule_id -- groups all the rows that have the same schedule_id
having count(*) > 1; -- having is a filter for groups, count means only show groups where the same schedule_id appears more then once 
					 -- ie duplicate
select agent_id, count(*)
from agents
group by agent_id
having count(*) > 1;

select quality_id, count(*)
from call_quality
group by quality_id
having count(*) > 1;

select call_id, count(*)
from calls
group by call_id
having count(*) > 1;

select customer_id, count(*)
from customers
group by customer_id
having count(*) > 1;

select dept_id, count(*)
from departments
group by dept_id
having count(*) > 1;

select escalation_id, count(*)
from escalations
group by escalation_id
having count(*) > 1;

select training_id, count(*)
from training_sessions
group by training_id
having count(*) > 1;

-- Check for Nulls
describe agent_schedule; -- describe (table name) will show if the columns allow nulls or not
select -- checks for nulls in each column and displays the new values with a 0 if no nulls, a number for the total nulls in column if found
sum(case when agent_id is null then 1 else 0 end) as null_agent_id,
sum(case when shift_date is null then 1 else 0 end) as null_shift_date,
sum(case when start_time is null then 1 else 0 end) as null_start_time,
sum(case when end_time is null then 1 else 0 end) as null_end_time
from agent_schedule;

describe agents;
select
sum(case when agent_name is null then 1 else 0 end) as null_agent_name,
sum(case when dept_id is null then 1 else 0 end) as null_dept_id,
sum(case when hire_date is null then 1 else 0 end) as null_hire_date
from agents;

describe call_quality;
select 
sum(case when call_id is null then 1 else 0 end) as null_call_id,
sum(case when quality_score is null then 1 else 0 end) as null_quality_score,
sum(case when comment is null then 1 else 0 end) as null_comment -- comment could be Null but checked anyways
from call_quality;

describe calls;
select 
sum(case when agent_id is null then 1 else 0 end) as null_agent_id,
sum(case when customer_id is null then 1 else 0 end) as null_customer_id,
sum(case when start_time is null then 1 else 0 end) as null_start_time,
sum(case when duration_sec is null then 1 else 0 end) as null_duration_sec,
sum(case when wait_time_sec is null then 1 else 0 end) as null_wait_time_sec,
sum(case when status is null then 1 else 0 end) as null_status,
sum(case when call_type is null then 1 else 0 end) as null_call_type
from calls;

describe customers;
select
sum(case when customer_name is null then 1 else 0 end) as null_customer_name,
sum(case when region is null then 1 else 0 end) as null_region,
sum(case when signup_date is null then 1 else 0 end) as null_signup_date
from customers;

describe departments;
select
sum(case when dept_name is null then 1 else 0 end) as null_dept_name
from departments;

describe escalations;
select
sum(case when call_id is null then 1 else 0 end) as null_call_id,
sum(case when reason is null then 1 else 0 end) as null_reason,
sum(case when escalation_date is null then 1 else 0 end) as null_escalation_date
from escalations;

describe training_sessions;
select
sum(case when title is null then 1 else 0 end) as null_title,
sum(case when training_date is null then 1 else 0 end) as null_training_date,
sum(case when duration_minutes is null then 1 else 0 end) as null_duration_minutes,
sum(case when trainer_agent_id is null then 1 else 0 end) as null_trainer_agent_id
from training_sessions;

-- CLEAN DEPARTMENTS TABLE

-- Checks dept_id and dept_name for null or in the case of dept_name nulls and empty cells 
select 'departments' as table_name, -- creats a lable for results, with one table technically not needed. With multiple tabels required to know which results relate to which table
count(*) as total_rows, -- counts the total number of rows in table
sum(case when trim(dept_name) = '' then 1 else 0 end) as empty_dept_name, -- trim empty spaces, then indicates if column has an rows with empty space
sum(case when upper(trim(dept_name)) in ('NULL', 'NONE', 'N/A', 'NA') then 1 else 0 end) as placeholder_dept_name -- trim empty space and capitalizes, then checks for nulls
from departments; -- selects what table to pull from

select * -- selects all 
from departments -- where pulling from
where dept_name is NULL; -- only displays rows where there is a null value

delete from departments
where dept_id is null or NULL
and dept_name is null or NULL
or dept_name = '';

SELECT *
FROM departments
WHERE dept_id IS NULL
   OR dept_name IS NULL
   OR TRIM(dept_name) = ''
   OR UPPER(TRIM(dept_name)) IN ('NULL','NONE','N/A','NA');

-- CLEAN AGENTS TABLE

SELECT *
FROM agents
WHERE agent_name IS NULL;  -- check for nulls in agent_name column

select 'agents' as table_name, 
count(*) as total_rows,
sum(case when trim(agent_name) = '' then 1 else 0 end) as empty_dept_name,
sum(case when upper(trim(agent_name)) in ('NULL', 'NONE', 'N/A', 'NA') then 1 else 0 end) as placeholder_agent_name
from agents; -- selects what table to pull from

select * 
from agents
where dept_id is null; -- check for nulls in dept_id column

SELECT a.*  -- tells what columns to select
FROM agents a  -- sets a as an alias for agent also is the left table in the join since mentioned first
LEFT JOIN departments d -- sets d as alias for departments an sets departments as the right table in the , keeps all the rows from agents
  ON a.dept_id = d.dept_id -- sets how the tables connect
WHERE d.dept_id IS NULL;  -- returns results where dept_id is null, so those results do not link to a existing department

delete from agents  -- deletes rows from agent table
where dept_id = '9' -- deletes rows where dept_id is 9 or 999 which are both invalid departments
or dept_id = '999';

select *
from agents
where hire_date = null;

select *
from agents
where hire_date > current_date;

-- CLEANING TRAINING_SESSIONS TABLE

select *
from training_sessions
where title is null;

select 'training_id' as table_name, 
count(*) as total_rows,
sum(case when trim(title) = '' then 1 else 0 end) as empty_title,
sum(case when upper(trim(title)) in ('NULL', 'NONE', 'N/A', 'NA') then 1 else 0 end) as placeholder_title
from training_sessions; -- selects what table to pull from

select *
from training_sessions
where training_date is null;

select *
from training_sessions
where training_date > current_date;

select *
from training_sessions
where duration_minutes is null;

select *
from training_sessions
where duration_minutes < 0;

select *
from training_sessions
where duration_minutes > 480;

delete from training_sessions
where duration_minutes = 9999; -- delete trainig time that must be invalid

SELECT ts.*, agent_id
FROM training_sessions ts
LEFT JOIN agents a
  ON ts.trainer_agent_id = a.agent_id
WHERE ts.trainer_agent_id IS NOT NULL
  AND a.agent_id IS NULL;
  
  UPDATE training_sessions
SET trainer_agent_id = NULL
WHERE trainer_agent_id NOT IN (SELECT agent_id FROM agents);

-- A. Overall Training Activity

-- 1. How many training sessions have been conducted in total?
select count(training_id) as total_training_sessions -- counts the total number of trainings
from training_sessions;

-- 2. What is the total number of training hours delivered?
select round(sum(duration_minutes)/ 60, 2) as total_training_hours -- sums all training hours,divided by 60 for hours
from training_sessions;                                            -- then set to 2 decimal places

-- 3. What is the average training duration?
select round(sum(duration_minutes) / count(training_id), 0) as average_training_duration_minutes
from training_sessions;
-- OR
SELECT ROUND(AVG(duration_minutes), 0)  -- gets same result but a cleaner code
       AS average_training_duration_minutes
FROM training_sessions;

-- B. Training Over Time

-- 1. How many training sessions occurred per month?
SELECT
    YEAR(training_date) AS year,
    MONTH(training_date) AS month_number,
    COUNT(training_id) AS total_sessions
FROM training_sessions
GROUP BY year, month_number
ORDER BY year DESC, month_number DESC;

-- 2. How has total training time changed over time?
SELECT
    YEAR(training_date) AS year,
    MONTH(training_date) AS month_number,
    round(sum(duration_minutes) / 60, 1) AS total_training_hours
FROM training_sessions
GROUP BY year, month_number
ORDER BY year DESC, month_number DESC;

-- 3. Are there seasonal patterns in training activity?
-- Seasonal patterns are present in the training data.
-- Training hours are lower during the second and fourth quarters, 
-- which may reflect reduced training availability during busier operational periods 
-- such as spring initiatives and year-end activit

-- C. Trainer Contribution

-- 1. How many training sessions has each trainer conducted?
SELECT
    a.agent_id,
    a.agent_name,
    COUNT(ts.training_id) AS total_sessions_conducted
FROM agents a
LEFT JOIN training_sessions ts
  ON a.agent_id = ts.trainer_agent_id
GROUP BY
    a.agent_id,
    a.agent_name
ORDER BY total_sessions_conducted DESC;

-- 2. Which trainer has delivered the most total training hours?
SELECT
    a.agent_id,
    a.agent_name,
    ROUND(SUM(ts.duration_minutes) / 60, 1) AS total_training_hours
FROM training_sessions ts
JOIN agents a
  ON ts.trainer_agent_id = a.agent_id
GROUP BY
    a.agent_id,
    a.agent_name
ORDER BY total_training_hours DESC;

-- 3. Which department’s agents conduct the most training hours?
SELECT
    d.dept_id,
    d.dept_name,
    ROUND(SUM(ts.duration_minutes) / 60, 1) AS total_training_hours
FROM training_sessions ts
JOIN agents a
  ON ts.trainer_agent_id = a.agent_id
JOIN departments d
  ON a.dept_id = d.dept_id
GROUP BY
    d.dept_id,
    d.dept_name
ORDER BY total_training_hours DESC;

-- 4. What is the average session length by trainer?
select
	a.agent_name,
	ts.trainer_agent_id,
    round(avg(ts.duration_minutes) / 60, 1) AS average_session_length
from training_sessions ts
Join agents a 
	on ts.trainer_agent_id = a.agent_id
group by 
	a.agent_name,
    ts.trainer_agent_id
order by average_session_length desc;
    
-- D. Department Level Training

-- 1. How many training sessions were conducted by each department?
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(ts.training_id) AS total_sessions_conducted
FROM training_sessions ts
JOIN agents a
  ON ts.trainer_agent_id = a.agent_id
JOIN departments d
  ON a.dept_id = d.dept_id
WHERE ts.trainer_agent_id IS NOT NULL
GROUP BY
    d.dept_id,
    d.dept_name
ORDER BY total_sessions_conducted DESC;

-- 2. Which departments contribute the most training hours?
SELECT
    d.dept_id,
    d.dept_name,
    ROUND(SUM(ts.duration_minutes) / 60, 1) AS total_training_hours
FROM training_sessions ts
JOIN agents a
  ON ts.trainer_agent_id = a.agent_id
JOIN departments d
  ON a.dept_id = d.dept_id
GROUP BY
    d.dept_id,
    d.dept_name
ORDER BY total_training_hours DESC;

-- 3. Are some departments under- or over-represented in training delivery?
-- Based on total training hours by department, Sales appears under-represented in training delivery,
-- contributing roughly one-third the training hours of the next lowest department.
-- In contrast, Training, Billing, and HR are over-represented, each contributing significantly more training hours than 
-- other departments, exceeding them by approximately 38 hours or more.
-- This indicates an uneven distribution of training delivery across departments,
-- with a small number of departments accounting for a disproportionate share of total training hours.

-- E. Data Quality / Coverage

-- 1. How many training sessions have no assigned trainer?
select count(training_id) as self_directed_training
from training_sessions
where trainer_agent_id is null;

-- 2. What percentage of total training hours lack a trainer assignment?
select round(
		sum(case
			when trainer_agent_id is null
			then duration_minutes 
			else 0
				end)
/ sum(duration_minutes)
* 100, 1) as percent_hours_no_trainer
from training_sessions;
