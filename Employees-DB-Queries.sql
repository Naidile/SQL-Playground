-- Copyright 2022 Naidile Murali

-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at

    -- http://www.apache.org/licenses/LICENSE-2.0

-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


SELECT 
    first_name, last_name
FROM
    employees;
    
SELECT * FROM employees;

SELECT * FROM employees WHERE gender = 'F' AND first_name = 'Elvis';

SELECT * FROM employees WHERE first_name = 'Kellie' OR first_name = 'Aruna';

SELECT * FROM employees WHERE (first_name = 'Kellie' OR first_name = 'Aruna') AND gender = 'F';

Select * FROM employees WHERE first_name IN ('Denis', 'Elvis');

Select * FROM employees WHERE first_name NOT IN ('John', 'Mark', 'Jacob');

SELECT * FROM employees WHERE first_name LIKE ('Mar%');

SELECT * FROM employees WHERE hire_date LIKE ('2000%');

SELECT * FROM employees WHERE emp_no LIKE ('1000_');

SELECT * FROM employees
WHERE first_name LIKE ('%JACK%');

SELECT * FROM employees
WHERE first_name NOT LIKE ('%Jack%'); 

SELECT * FROM salaries;

SELECT * FROM salaries WHERE salary BETWEEN '66000' AND '70000';

SELECT * FROM employees WHERE emp_no NOT BETWEEN '10004' AND '10012';

SELECT dept_name FROM departments WHERE dept_no BETWEEN 'd003' AND 'd006';

SELECT * FROM departments WHERE dept_no BETWEEN 'd003' AND 'd006';

SELECT dept_name FROM departments WHERE dept_no IS NOT NULL;
SELECT dept_name FROM departments WHERE dept_no IS NULL;

SELECT * FROM employees WHERE gender = 'F' AND hire_date >= '2000-01-01';

SELECT * FROM salaries WHERE salary > '150000';
SELECT DISTINCT hire_date FROM employees;

SELECT count(emp_no) FROM salaries WHERE salary >= '100000';

SELECT count(*) FROM dept_manager;

SELECT count(DISTINCT gender) FROM employees;

SELECT * FROM employees
ORDER BY hire_date DESC;

SELECT first_name, COUNT(first_name)
FROM employees
GROUP BY first_name
ORDER BY first_name DESC;

SELECT salary, COUNT(salary) AS emps_with_same_salary
FROM salaries 
WHERE salary > '80000'
GROUP BY salary;

SELECT emp_no, AVG(salary) AS avg_salary 
FROM salaries
GROUP BY emp_no
HAVING AVG(salary) > '120000'
ORDER BY emp_no;

SELECT * FROM salaries;

SELECT first_name, COUNT(first_name) AS name_count
FROM employees
WHERE hire_date > '1999-01-01'
GROUP BY first_name
HAVING COUNT(first_name) < '200'
ORDER BY first_name DESC
LIMIT 100;

SELECT * FROM dept_emp
LIMIT 100;

SELECT emp_no
FROM dept_emp
WHERE from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(dept_no) > '1'
ORDER BY emp_no DESC;

SELECT COUNT(DISTINCT dept_no) FROM dept_emp;

SELECT SUM(salary) FROM salaries
WHERE from_date > '1997-01-01';

SELECT MIN(emp_no) FROM salaries;
SELECT MAX(emp_no) FROM salaries;

SELECT ROUND(AVG(salary),2) FROM salaries
WHERE from_date > '1997-01-01';

DROP TABLE IF EXISTS departments_dup;
CREATE TABLE departments_dup
(

    dept_no CHAR(4) NULL,

    dept_name VARCHAR(40) NULL

);

INSERT INTO departments_dup
(

    dept_no,

    dept_name

)

SELECT * FROM departments;

INSERT INTO departments_dup (dept_name) VALUES ('Public Relations');

DELETE FROM departments_dup
WHERE dept_no = 'd002'; 

INSERT INTO departments_dup(dept_no) VALUES ('d010'), ('d011');
SELECT * FROM departments_dup;

DROP TABLE IF EXISTS dept_manager_dup;

CREATE TABLE dept_manager_dup (

  emp_no int(11) NOT NULL,

  dept_no char(4) NULL,

  from_date date NOT NULL,

  to_date date NULL

  );

INSERT INTO dept_manager_dup
select * from dept_manager;

INSERT INTO dept_manager_dup (emp_no, from_date)

VALUES                (999904, '2017-01-01'),

                                (999905, '2017-01-01'),

                               (999906, '2017-01-01'),

                               (999907, '2017-01-01');

 

DELETE FROM dept_manager_dup
WHERE dept_no = 'd001';

SELECT * FROM dept_manager_dup;

SELECT m.emp_no, m.from_date
FROM departments_dup d
INNER JOIN dept_manager_dup m ON d.dept_no = m.dept_no;

SELECT e.emp_no, e.first_name, e.last_name, e.hire_date, m.dept_no
FROM employees e
INNER JOIN dept_manager_dup m ON e.emp_no = m.emp_no;

SELECT e.emp_no, e.first_name, e.last_name, m.dept_no, m.from_date
FROM employees e
LEFT JOIN dept_manager m ON e.emp_no = m.emp_no
WHERE e.last_name = 'Markovitch'
ORDER BY m.dept_no DESC, e.emp_no;

SELECT e.emp_no, e.first_name, e.last_name, m.dept_no, e.hire_date 
FROM employees e, dept_manager m
WHERE e.emp_no = m.emp_no;

set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');

SELECT e.emp_no, e.first_name, e.last_name, e.hire_date, j.title
FROM employees e
JOIN titles j ON e.emp_no = j.emp_no
WHERE e.first_name = 'Margareta' AND e.last_name = 'Markovitch'
ORDER BY e.emp_no DESC;

SELECT d.*, dm.*
FROM departments d
CROSS JOIN dept_manager dm
WHERE d.dept_no = 'd009'
ORDER BY d.dept_name;

SELECT e.*, d.*
FROM employees e
CROSS JOIN departments d
WHERE e.emp_no < '10011'
ORDER BY e.emp_no, d.dept_no;

SELECT e.emp_no, e.first_name, e.last_name, e.hire_date, t.title, t.from_date, de.dept_name
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
JOIN dept_manager d ON d.emp_no = e.emp_no
JOIN departments de ON de.dept_no = d.dept_no
WHERE t.title = 'Manager';


SELECT gender, count(d.emp_no) as no_of_managers
FROM employees e
JOIN dept_manager d ON e.emp_no = d.emp_no
GROUP BY gender;

Select * from dept_manager;

SELECT *
FROM
(SELECT
        e.emp_no,
		e.first_name,
		e.last_name,
		NULL AS dept_no,
		NULL AS from_date
    FROM employees e
    WHERE last_name = 'Denis' UNION SELECT
        NULL AS emp_no,
        NULL AS first_name,
        NULL AS last_name,
        dm.dept_no,
		dm.from_date
FROM dept_manager dm) as a
ORDER BY -a.emp_no DESC;

SELECT *
FROM dept_manager dm
WHERE dm.emp_no IN (SELECT e.emp_no
					FROM employees e
                    WHERE (e.hire_date BETWEEN '1990-01-01' AND '1995-01-01'));
                    
SELECT * FROM employees e
WHERE EXISTS (SELECT t.emp_no
			FROM titles t
			WHERE e.emp_no AND t.title = "Assistant Engineer");
            
SELECT *
FROM Employees 
WHERE emp_no = 110022;

SELECT * FROM dept_manager;
SELECT * FROM employees;

DROP TABLE IF EXISTS emp_manager;

CREATE TABLE emp_manager (

   emp_no INT(11) NOT NULL,

   dept_no CHAR(4) NULL,

   manager_no INT(11) NOT NULL

);

SELECT * FROM emp_manager;




SELECT * FROM
(SELECT e.emp_no, 
MIN(em.dept_no) as dept_code,
(SELECT emp_no
FROM dept_manager
WHERE emp_no = '110022') as manager_id
FROM employees e 
JOIN dept_emp em ON e.emp_no = em.emp_no
WHERE e.emp_no <= '10020'
GROUP BY e.emp_no
ORDER BY e.emp_no) as A

UNION

SELECT * FROM
(SELECT e.emp_no, 
MIN(em.dept_no) as dept_code,
(SELECT emp_no
FROM dept_manager
WHERE emp_no = '110039') as manager_id
FROM employees e 
JOIN dept_emp em ON e.emp_no = em.emp_no
WHERE e.emp_no BETWEEN '10021' AND '10040'
GROUP BY e.emp_no
ORDER BY e.emp_no) as B

UNION

SELECT * FROM
(SELECT e.emp_no, 
MIN(em.dept_no) as dept_code,
(SELECT emp_no
FROM dept_manager
WHERE emp_no = '110039') as manager_id
FROM employees e 
JOIN dept_emp em ON e.emp_no = em.emp_no
WHERE e.emp_no = '110022'
GROUP BY e.emp_no
ORDER BY e.emp_no) as C

UNION

SELECT * FROM
(SELECT e.emp_no, 
MIN(em.dept_no) as dept_code,
(SELECT emp_no
FROM dept_manager
WHERE emp_no = '110022') as manager_id
FROM employees e 
JOIN dept_emp em ON e.emp_no = em.emp_no
WHERE e.emp_no = '110039'
GROUP BY e.emp_no
ORDER BY e.emp_no) as D;


SELECT e.emp_no, e.first_name, e.last_name,
CASE 
WHEN e.emp_no = m.emp_no THEN 'Manager'
ELSE 'Employee' END AS title
FROM employees e LEFT JOIN dept_manager m
ON e.emp_no = m.emp_no
WHERE e.emp_no > 109990;


SELECT m.emp_no, e.first_name, e.last_name,
(MAX(salary)-MIN(salary)) as salary_dif,
CASE
WHEN (MAX(salary)-MIN(salary)) > 30000 THEN "GREATER THAN 30"
ELSE "LESSER THAN 30" END AS salary_raise
FROM dept_manager m JOIN employees e 
ON m.emp_no = e.emp_no
JOIN salaries s ON s.emp_no = m.emp_no
GROUP BY m.emp_no
ORDER BY m.emp_no;

SELECT * FROM dept_emp;

SELECT d.emp_no, e.first_name, e.last_name,
IF (d.to_date IS NULL, 'Is still employed', 'Not an employee anymore') AS current_employee
FROM employees e JOIN dept_emp d ON
e.emp_no = d.emp_no
ORDER BY e.emp_no
LIMIT 100;


SELECT e.emp_no, e.first_name, e.last_name,
    CASE
        WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
        ELSE 'Not an employee anymore'
    END AS current_employee
FROM employees e JOIN
dept_emp de ON de.emp_no = e.emp_no
GROUP BY de.emp_no
LIMIT 100;
