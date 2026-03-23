-- Procedures
-- 1. Write a procedure to display a message “Good Day to You”.
CREATE
OR REPLACE PROCEDURE greet_message IS BEGIN DBMS_OUTPUT.PUT_LINE ('Good Day to You');

END;

/
-- 2. Based on the University Database Schema in Lab 2, write a procedure which takes the dept_name as input parameter and lists all the instructors  associated with the department as well as list all the courses offered by the department. Also, write an anonymous block with the procedure call.
CREATE
OR REPLACE PROCEDURE dept_details (p_dept_name IN VARCHAR2) IS
-- Cursor for instructors
CURSOR c_instructor IS
SELECT
	name
FROM
	instructor
WHERE
	dept_name = p_dept_name;

-- Cursor for courses
CURSOR c_course IS
SELECT
	title
FROM
	course
WHERE
	dept_name = p_dept_name;

BEGIN DBMS_OUTPUT.PUT_LINE (
	'--- Instructors in Department: ' || p_dept_name || ' ---'
);

FOR inst IN c_instructor LOOP DBMS_OUTPUT.PUT_LINE ('Instructor: ' || inst.name);

END LOOP;

DBMS_OUTPUT.PUT_LINE (
	'--- Courses Offered by Department: ' || p_dept_name || ' ---'
);

FOR crs IN c_course LOOP DBMS_OUTPUT.PUT_LINE ('Course: ' || crs.title);

END LOOP;

END;

/
SET
	SERVEROUTPUT ON;

BEGIN dept_details ('CSE');

-- You can change department name
END;

/
-- 3. Based on the University Database Schema in Lab 2, write a PL/SQL block of code that lists the most popular course (highest number of students take it) for each of the departments. It should make use of a procedure course_popular which finds the most popular course in the given department.
CREATE
OR REPLACE PROCEDURE course_popular (p_dept_name IN VARCHAR2) IS v_course_id course.course_id;

v_title course.title;

v_count NUMBER;

BEGIN
-- Find most popular course in the given department
SELECT
	c.course_id,
	c.title,
	COUNT(t.ID) INTO v_course_id,
	v_title,
	v_count
FROM
	course c
	LEFT JOIN takes t ON c.course_id = t.course_id
WHERE
	c.dept_name = p_dept_name
GROUP BY
	c.course_id,
	c.title
HAVING
	COUNT(t.ID) = (
		SELECT
			MAX(cnt)
		FROM
			(
				SELECT
					COUNT(t2.ID) AS cnt
				FROM
					course c2
					LEFT JOIN takes t2 ON c2.course_id = t2.course_id
				WHERE
					c2.dept_name = p_dept_name
				GROUP BY
					c2.course_id
			)
	);

DBMS_OUTPUT.PUT_LINE ('Department: ' || p_dept_name);

DBMS_OUTPUT.PUT_LINE (
	'Most Popular Course: ' || v_title || ' (ID: ' || v_course_id || ', Students: ' || v_count || ')'
);

DBMS_OUTPUT.PUT_LINE ('----------------------------------');

EXCEPTION WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE (
	'No courses found for department: ' || p_dept_name
);

WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE (
	'Multiple popular courses found for department: ' || p_dept_name
);

END;

/
SET
	SERVEROUTPUT ON;

DECLARE CURSOR dept_cursor IS
SELECT
	dept_name
FROM
	department;

BEGIN FOR d IN dept_cursor LOOP course_popular (d.dept_name);

END LOOP;

END;

/
-- 4. Based on the University Database Schema in Lab 2, write a procedure which takes the dept-name as input parameter and lists all the students  associated with the department as well as list all the courses offered by the department. Also, write an anonymous block with the procedure call.
CREATE
OR REPLACE PROCEDURE dept_student_course (p_dept_name IN VARCHAR2) IS
-- Cursor for students
CURSOR c_student IS
SELECT
	name
FROM
	student
WHERE
	dept_name = p_dept_name;

-- Cursor for courses
CURSOR c_course IS
SELECT
	title
FROM
	course
WHERE
	dept_name = p_dept_name;

BEGIN DBMS_OUTPUT.PUT_LINE (
	'--- Students in Department: ' || p_dept_name || ' ---'
);

FOR stu IN c_student LOOP DBMS_OUTPUT.PUT_LINE ('Student: ' || stu.name);

END LOOP;

DBMS_OUTPUT.PUT_LINE (
	'--- Courses Offered by Department: ' || p_dept_name || ' ---'
);

FOR crs IN c_course LOOP DBMS_OUTPUT.PUT_LINE ('Course: ' || crs.title);

END LOOP;

END;

/
SET
	SERVEROUTPUT ON;

BEGIN dept_student_course ('CSE');

-- change dept name if needed
END;

/
-- Functions
-- 5. Write a function to return the square of a given number and call it from an anonymous block.
CREATE
OR REPLACE FUNCTION square_num (n IN NUMBER) RETURN NUMBER IS BEGIN RETURN n * n;

END;

/
SET
	SERVEROUTPUT ON;

DECLARE num NUMBER = 5;

-- input value
result NUMBER;

BEGIN result = square_num (num);

DBMS_OUTPUT.PUT_LINE ('Square of ' || num || ' is ' || result);

END;

/
-- 6. Based on the University Database Schema in Lab 2, write a PL/SQL block of code that lists the highest paid Instructor in each of the Department. It should make use of a function department_highest which returns the highest paid Instructor for the given branch.
CREATE
OR REPLACE FUNCTION department_highest (p_dept_name IN VARCHAR2) RETURN VARCHAR2 IS v_name instructor.name;

BEGIN
SELECT
	name INTO v_name
FROM
	instructor
WHERE
	dept_name = p_dept_name
	AND salary = (
		SELECT
			MAX(salary)
		FROM
			instructor
		WHERE
			dept_name = p_dept_name
	);

RETURN v_name;

EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'No Instructor Found';

WHEN TOO_MANY_ROWS THEN RETURN 'Multiple Top Instructors';

END;

/
SET
	SERVEROUTPUT ON;

DECLARE CURSOR dept_cursor IS
SELECT
	dept_name
FROM
	department;

v_result VARCHAR2 (100);

BEGIN FOR d IN dept_cursor LOOP v_result = department_highest (d.dept_name);

DBMS_OUTPUT.PUT_LINE ('Department: ' || d.dept_name);

DBMS_OUTPUT.PUT_LINE ('Highest Paid Instructor: ' || v_result);

DBMS_OUTPUT.PUT_LINE ('----------------------------------');

END LOOP;

END;

/
-- Packages
/*
7. Based on the University Database Schema in Lab 2, create a package to include the following: 
a) A named procedure to list the instructor_names of given department
b) A function which returns the max salary for the given department
c) Write a PL/SQL block to demonstrate the usage of above package components
 */
CREATE
OR REPLACE PACKAGE dept_pkg IS
-- (a) Procedure to list instructor names
PROCEDURE list_instructors (p_dept_name IN VARCHAR2);

-- (b) Function to return max salary
FUNCTION max_salary (p_dept_name IN VARCHAR2) RETURN NUMBER;

END dept_pkg;

/ CREATE
OR REPLACE PACKAGE BODY dept_pkg IS
-- Procedure implementation
PROCEDURE list_instructors (p_dept_name IN VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE ('Instructors in Department: ' || p_dept_name);

FOR inst IN (
	SELECT
		name
	FROM
		instructor
	WHERE
		dept_name = p_dept_name
) LOOP DBMS_OUTPUT.PUT_LINE (inst.name);

END LOOP;

END list_instructors;

-- Function implementation
FUNCTION max_salary (p_dept_name IN VARCHAR2) RETURN NUMBER IS v_max NUMBER;

BEGIN
SELECT
	MAX(salary) INTO v_max
FROM
	instructor
WHERE
	dept_name = p_dept_name;

RETURN v_max;

EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 0;

END max_salary;

END dept_pkg;

/
SET
	SERVEROUTPUT ON;

DECLARE v_salary NUMBER;

BEGIN
-- Call procedure
dept_pkg.list_instructors ('CSE');

-- Call function
v_salary = dept_pkg.max_salary ('CSE');

DBMS_OUTPUT.PUT_LINE ('Max Salary in CSE: ' || v_salary);

END;

/
-- Parameter modes: IN, OUT, IN OUT
-- 8. Write a PL/SQL procedure to return simple and compound interest (OUT parameters) along with the Total Sum (IN OUT) i.e. Sum of Principle and Interest taking as input the principle, rate of interest and number of years (IN parameters). Call this procedure from an anonymous block.
CREATE
OR REPLACE PROCEDURE interest_calc (
	p_principal IN NUMBER,
	p_rate IN NUMBER,
	p_time IN NUMBER,
	si OUT NUMBER,
	ci OUT NUMBER,
	total_amt IN OUT NUMBER
) IS BEGIN
-- Simple Interest
si = (p_principal * p_rate * p_time) / 100;

-- Compound Interest
ci = p_principal * POWER((1 + p_rate / 100), p_time) - p_principal;

-- Total Amount (Principal + SI)
total_amt = p_principal + si;

END;

/
SET
	SERVEROUTPUT ON;

DECLARE p NUMBER = 10000;

-- principal
r NUMBER = 10;

-- rate %
t NUMBER = 2;

-- years
si NUMBER;

ci NUMBER;

tot NUMBER = 0;

-- IN OUT variable
BEGIN interest_calc (p, r, t, si, ci, tot);

DBMS_OUTPUT.PUT_LINE ('Simple Interest: ' || si);

DBMS_OUTPUT.PUT_LINE ('Compound Interest: ' || ci);

DBMS_OUTPUT.PUT_LINE ('Total Amount (P + SI): ' || tot);

END;

/