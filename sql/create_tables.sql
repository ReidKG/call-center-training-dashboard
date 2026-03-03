
-- Call Center Dataset CREATE TABLE statements
CREATE DATABASE IF NOT EXISTS call_center_portfolio;
USE call_center_portfolio;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE agents (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR(100),
    dept_id INT,
    hire_date DATE
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    region VARCHAR(50),
    signup_date DATE
);

CREATE TABLE calls (
    call_id INT PRIMARY KEY,
    agent_id INT,
    customer_id INT,
    start_time DATETIME,
    duration_sec INT,
    wait_time_sec INT,
    status VARCHAR(50),
    call_type VARCHAR(50)
);

CREATE TABLE call_quality (
    quality_id INT PRIMARY KEY,
    call_id INT,
    quality_score DECIMAL(3,1),
    comment VARCHAR(255)
);

CREATE TABLE agent_schedule (
    schedule_id INT PRIMARY KEY,
    agent_id INT,
    shift_date DATE,
    start_time TIME,
    end_time TIME
);

CREATE TABLE escalations (
    escalation_id INT PRIMARY KEY,
    call_id INT,
    reason VARCHAR(255),
    escalation_date DATE
);

CREATE TABLE training_sessions (
    training_id INT PRIMARY KEY,
    title VARCHAR(255),
    training_date DATE,
    duration_minutes INT,
    trainer_agent_id INT
);
