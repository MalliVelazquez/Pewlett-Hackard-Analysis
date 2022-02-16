-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
CREATE TABLE employees (
	emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);
CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (title, emp_no, from_date)
);
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM dept_manager;
SELECT * FROM dep_emp;
SELECT * FROM titles;

--Retrieve employees and titles between 1952 & 1955
SELECT emp.emp_no,
       emp.first_name,
       emp.last_name,
       tt.title,
       tt.from_date,
       tt.to_date
INTO retirement_titles
FROM employees as emp
INNER JOIN titles as tt
ON emp.emp_no = tt.emp_no
WHERE birth_date between '1952-01-01' and '1955-12-31'
ORDER BY emp.emp_no ASC;

SELECT * FROM retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no)emp_no,
   first_name,
   last_name,
   title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

SELECT * FROM unique_titles;

--Retrieve the number of titles
SELECT COUNT(*),
	title
INTO retiring_title
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_title; 

--Export the Mentorship Eligibility table
SELECT 
DISTINCT ON (em.emp_no)
     em.emp_no,
	   em.first_name,
	   em.last_name,
	   em.birth_date,
	   dept.from_date,
	   dept.to_date,
	   tt.title
INTO mentorship_eligibilty
FROM employees as em
JOIN dept_emp as dept ON em.emp_no = dept.emp_no
JOIN titles as tt ON em.emp_no = tt.emp_no
WHERE dept.to_date = '9999-01-01'
AND birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY em.emp_no ASC;

SELECT * FROM mentorship_eligibilty;



