1 MVP


--Question 1.
--Find all the employees who work in the ‘Human Resources’ department.

SELECT *
FROM employees
WHERE department = 'Human Rescources';

--Question 2.
--Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department.

SELECT first_name, last_name, country, department
FROM employees
WHERE department = 'Legal';

--Question 3.
--Count the number of employees based in Portugal.

SELECT count(*)
FROM employees
WHERE country = 'Portugal';


-- 29

--Question 4.
--Count the number of employees based in either Portugal or Spain.


SELECT count(*)
FROM employees
WHERE country = 'Portugal' OR country = 'Spain';


-- 35


--Question 5.
--Count the number of pay_details records lacking a local_account_no.

SELECT count(*) 
FROM pay_details
WHERE local_account_no IS NULL;

- 25

-- Question 6.
-- Are there any pay_details records lacking both a local_account_no and iban number?

SELECT count(id) 
FROM pay_details
WHERE local_account_no IS NULL AND iban IS NULL 

-- 0 

-- Question 7.
-- Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last).

SELECT first_name, last_name
FROM employees
ORDER BY last_name NULLS LAST;

-- Question 8.
-- Get a table of employees first_name, last_name and country, ordered alphabetically first by country and then by last_name (put any NULLs last).

SELECT first_name, last_name, country
FROM employees
ORDER BY country NULLS LAST, last_name NULLS LAST;

-- Question 9.
-- Find the details of the top ten highest paid employees in the corporation.

SELECT *
FROM employees
ORDER BY salary DESC NULLS LAST
LIMIT 10;

-- Question 10.
-- Find the first_name, last_name and salary of the lowest paid employee in Hungary.

SELECT first_name, last_name, salary
FROM employees
WHERE country = 'Hungary'
ORDER BY salary NULLS LAST;


-- Question 11.
-- How many employees have a first_name beginning with ‘F’?

SELECT count(first_name)
FROM employees
WHERE first_name ILIKE 'f%' ;

-- 30 

-- Question 12.
-- Find all the details of any employees with a ‘yahoo’ email address?

SELECT *
FROM employees
WHERE email ILIKE '_%yahoo%' ;

-- Question 13. Count the number of pension enrolled employees not based in either France or Germany.

SELECT count(id)
FROM employees
WHERE country NOT IN ('France' , 'Germany') 
AND pension_enrol IS TRUE;

-- Question 14.
-- What is the maximum salary among those employees in the ‘Engineering’ department who work 1.0 full-time equivalent hours (fte_hours)?

SELECT max(salary)
FROM employees 
WHERE department = 'Engineering' AND fte_hours = 1;

-- Question 15.
-- Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), salary, and a new column effective_yearly_salary 
-- which should contain fte_hours multiplied by salary.

SELECT first_name, last_name, fte_hours, salary, fte_hours * salary AS effective_yearly_salary
FROM employees 

-- Question 16.
--The corporation wants to make name badges for a forthcoming conference. Return a column badge_label showing employees’ first_name and last_name joined together with 
 -- their department in the following style: ‘Bob Smith - Legal’. Restrict output to only those employees with stored first_name, last_name and department.

SELECT concat(first_name, ' ', last_name, ' - ', department) AS bagge_label 
FROM employees
WHERE 
first_name NOTNULL
AND 
last_name NOTNULL 
AND 
department NOTNULL;

--Question 17.
-- One of the conference organisers thinks it would be nice to add the year of the employees’ start_date to the badge_label to celebrate long-standing colleagues,
--  in the following style ‘Bob Smith - Legal (joined 1998)’. Further restrict output to only those employees with a stored start_date.

--[If you’re really keen - try adding the month as a string: ‘Bob Smith - Legal (joined July 1998)’]

SELECT 
concat(first_name, ' ', last_name, ' - ', department, ' (joined ', 
(SELECT TO_CHAR(start_date, 'FMMonth ')), 
EXTRACT(YEAR FROM start_date), ')') AS bagge_label 
FROM employees
WHERE 
first_name NOTNULL
AND 
last_name NOTNULL 
AND 
department NOTNULL;


-- Question 18.
--Return the first_name, last_name and salary of all employees together with a new column called salary_class with a value 'low' 
-- where salary is less than 40,000 and value 'high' where salary is greater than or equal to 40,000.

SELECT concat(first_name, ' ' , last_name, ' ' , 
(SELECT CASE
WHEN salary < 40000 THEN 'low' 
WHEN salary >= 40000 THEN 'Hgh'
END	
salary)) AS salary_class
FROM employees







