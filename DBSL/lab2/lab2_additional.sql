-- ADDITIONAL QUESTIONS
-- 1. Modify the employee table to check the salary of every employee to be greater than 5000.
ALTER TABLE Employee ADD CONSTRAINT chk_employee_salary CHECK (Salary > 5000);

-- 2. Find the quarter of year from the given date.
SELECT
	TO_CHAR (DATE '2024-08-15', 'Q') AS quarter
FROM
	dual;

-- 3. Convert seconds to hours, minutes and seconds format.
SELECT
	FLOOR(3665 / 3600) AS hours,
	FLOOR(MOD(3665, 3600) / 60) AS minutes,
	MOD(3665, 60) AS seconds
FROM
	dual;

-- 4. Find the week of the year from the given date.
SELECT
	TO_CHAR (DATE '2024-08-15', 'WW') AS week_of_year
FROM
	dual;

-- 5. Find the names of all departments with instructor, and remove duplicates.
SELECT DISTINCT
	dept_name
FROM
	Instructor;

-- 6. For all instructors who have taught some course, find their names and the course ID of the courses they taught.
SELECT
	i.name,
	t.course_id
FROM
	Instructor i
	JOIN Teaches t ON i.ID = t.ID;

-- 7. Find all the instructors with the courses they taught.
SELECT
	i.name,
	t.course_id
FROM
	Instructor i
	JOIN Teaches t ON i.ID = t.ID;

-- 8. List all the students with student name, department name, advisor name and the number of courses registered.
SELECT
	s.name AS student_name,
	s.dept_name AS department_name,
	i.name AS advisor_name,
	COUNT(t.course_id) AS no_of_courses
FROM
	Student s
	LEFT JOIN Advisor a ON s.ID = a.s_id
	LEFT JOIN Instructor i ON a.i_id = i.ID
	LEFT JOIN Takes t ON s.ID = t.ID
GROUP BY
	s.name,
	s.dept_name,
	i.name;