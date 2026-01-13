/*
Consider the following schema:
Employee (EmpNo, EmpName, Gender, Salary, Address, DNo)
Department (DeptNo, DeptName, Location)
 */
/*
1. Create Employee table with following constraints:
- Make EmpNo as Primary key.
- Do not allow EmpName, Gender, Salary and Address to have null values.
- Allow Gender to have one of the two values: ‘M’, ‘F’.
 */
CREATE TABLE
  Employee (
    EmpNo NUMBER PRIMARY KEY,
    EmpName VARCHAR2 (50) NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    Salary NUMBER (10, 2) NOT NULL,
    Address VARCHAR2 (100) NOT NULL,
    DNo NUMBER
  );

/*
2. Create Department table with following:
- Make DeptNo as Primary key
- Make DeptName as candidate key
 */
CREATE TABLE
  Department (
    DeptNo NUMBER PRIMARY KEY,
    DeptName VARCHAR2 (50) NOT NULL UNIQUE,
    Location VARCHAR2 (50)
  );

-- 3. Make DNo of Employee as foreign key which refers to DeptNo of Department.
ALTER TABLE Employee ADD CONSTRAINT fk_emp_dept FOREIGN KEY (DNo) REFERENCES Department (DeptNo);

-- 4. Insert few tuples into Employee and Department which satisfies the above constraints.
-- Department
INSERT INTO
  Department
VALUES
  (10, 'HR', 'Bangalore');

INSERT INTO
  Department
VALUES
  (20, 'IT', 'Hyderabad');

INSERT INTO
  Department
VALUES
  (30, 'Finance', 'Mumbai');

-- Employee
INSERT INTO
  Employee
VALUES
  (101, 'Rahul', 'M', 50000, 'Bangalore', 10);

INSERT INTO
  Employee
VALUES
  (102, 'Anita', 'F', 60000, 'Hyderabad', 20);

INSERT INTO
  Employee
VALUES
  (103, 'Kiran', 'M', 55000, 'Mumbai', 30);

-- 5. Try to insert few tuples into Employee and Department which violates some of the above constraints.
-- Primary key violation
INSERT INTO
  Department
VALUES
  (10, 'Admin', 'Delhi');

-- NULL EmpName
INSERT INTO
  Employee
VALUES
  (104, NULL, 'M', 40000, 'Chennai', 20);

-- 6. Try to modify/delete a tuple which violates a constraint.
-- Update GENDER to invalid
UPDATE Employee
SET
  Gender = 'X'
WHERE
  EmpNo = 101;

-- Duplicate DeptName
UPDATE Department
SET
  DeptName = 'IT'
WHERE
  DeptNo = 30;

-- 7. Modify the foreign key constraint of Employee table such that whenever a department tuple is deleted, the employees belonging to that department will also be deleted.
ALTER TABLE Employee
DROP CONSTRAINT fk_emp_dept;

ALTER TABLE Employee ADD CONSTRAINT fk_emp_dept FOREIGN KEY (DNo) REFERENCES Department (DeptNo) ON DELETE CASCADE;

-- 8. Create a named constraint to set the default salary to 10000 and test the constraint by inserting a new record.
ALTER TABLE Employee MODIFY Salary DEFAULT 10000;

INSERT INTO
  Employee (EmpNo, EmpName, Gender, Address, DNo)
VALUES
  (108, 'Amit', 'M', 'Delhi', 20);

/*
University Database Schema:
Student (ID, name,dept-name, tot-cred)
Instructor (ID, name, dept-name, salary)
Course (Course-id, title,dept-name, credits)
Takes (ID, course-id, sec-id, semester, year, grade)
Classroom (building, room-number, capacity)
Department (dept-name, building, budget)
Section (course-id, section-id, semester, year, building, room-number, time-slot-id)
Teaches (id, course-id, section-id, semester, year)
Advisor (s-id, i-id)
Time-slot (time-slot-id, day, start-time, end-time)
Prereq (course-id, prereq-id)
 */

@university.sql;

-- 9. List all Students with names and their department names.
SELECT
  name,
  dept_name
FROM
  Student;

-- 10. List all instructors in CSE department.
SELECT
  name
FROM
  Instructor
WHERE
  dept_name = 'Comp. Sci.';

-- 11. Find the names of courses in CSE department which have 3 credits.
SELECT
  title
FROM
  Course
WHERE
  dept_name = 'Comp. Sci.'
  AND credits = 3;

-- 12. For the student with ID 12345 (or any other value), show all course-id and title of all courses registered for by the student.
SELECT
  c.course_id,
  c.title
FROM
  Takes t
  JOIN Course c ON t.course_id = c.course_id
WHERE
  t.ID = 12345;

-- 13. List all the instructors whose salary is in between 40000 and 90000.
SELECT
  name
FROM
  Instructor
WHERE
  salary BETWEEN 40000 AND 90000;

-- 14. Display the IDs of all instructors who have never taught a course.
SELECT
  i.ID
FROM
  Instructor i
WHERE
  NOT EXISTS (
    SELECT
      1
    FROM
      Teaches t
    WHERE
      t.ID = i.ID
  );

-- 15. Find the student names, course names, and the year, for all students those who have attended classes in room-number 303.
SELECT
  s.name AS student_name,
  c.title AS course_name,
  t.year
FROM
  Student s
  JOIN Takes t ON s.ID = t.ID
  JOIN Section sec ON t.course_id = sec.course_id
  AND t.sec_id = sec.sec_id
  AND t.semester = sec.semester
  AND t.year = sec.year
  JOIN Course c ON sec.course_id = c.course_id
WHERE
  sec.room_number = 303;

-- 16. For all students who have opted courses in 2015, find their names and course id’s with the attribute course title replaced by c-name.
SELECT
  s.name,
  t.course_id,
  c.title AS c_name
FROM
  Student s
  JOIN Takes t ON s.ID = t.ID
  JOIN Course c ON t.course_id = c.course_id
WHERE
  t.year = 2015;

-- 17. Find the names of all instructors whose salary is greater than the salary of at least one instructor of CSE department and salary replaced by inst-salary.
SELECT
  name,
  salary AS inst_salary
FROM
  Instructor
WHERE
  salary > ANY (
    SELECT
      salary
    FROM
      Instructor
    WHERE
      dept_name = 'Comp. Sci.'
  );

-- 18. Find the names of all instructors whose department name includes the substring ‘ch’.
SELECT
  name
FROM
  Instructor
WHERE
  dept_name LIKE '%ch%';

-- 19. List the student names along with the length of the student names.
SELECT
  name,
  LENGTH (name) AS name_length
FROM
  Student;

-- 20. List the department names and 3 characters from 3rd position of each department name.
SELECT
  dept_name,
  SUBSTR (dept_name, 3, 3) AS sub_string
FROM
  Department;

-- 21. List the instructor names in upper case.
SELECT
  UPPER(name) AS instructor_name
FROM
  Instructor;

-- 22. Replace NULL with value1 (say 0) for a column in any of the table.
SELECT
  name,
  NVL (tot_cred, 0) AS tot_cred
FROM
  Student;

-- 23. Display the salary and salary/3 rounded to nearest hundred from Instructor.
SELECT
  salary,
  ROUND(salary / 3, -2) AS salary_div_3
FROM
  Instructor;

-- Add date of birth column (DOB) to Employee Table. Insert appropriate DOB values for different employees.
ALTER TABLE Employee ADD DOB DATE;

INSERT INTO
  Employee
VALUES
  (
    301,
    'Rohit',
    'M',
    45000,
    'Bangalore',
    10,
    DATE '1998-06-15'
  );

INSERT INTO
  Employee
VALUES
  (
    302,
    'Neha',
    'F',
    52000,
    'Hyderabad',
    20,
    DATE '1997-11-23'
  );

UPDATE Employee
SET
  DOB = DATE '1996-03-10'
WHERE
  EmpNo = 101;

UPDATE Employee
SET
  DOB = DATE '1999-08-05'
WHERE
  EmpNo = 102;

COMMIT;

/*
24. Display the birth date of all the employees in the following format:
- ‘DD-MON-YYYY’
- ‘DD-MON-YY’
- ‘DD-MM-YY’
 */
SELECT
  EmpName,
  TO_CHAR (DOB, 'DD-MON-YYYY') AS dob_dd_mon_yyyy,
  TO_CHAR (DOB, 'DD-MON-YY') AS dob_dd_mon_yy,
  TO_CHAR (DOB, 'DD-MM-YY') AS dob_dd_mm_yy
FROM
  Employee;

/*
25. List the employee names and the year (fully spelled out) in which they are born
- ‘YEAR’
- ‘Year’
- ‘year’
 */
SELECT
  EmpName,
  TO_CHAR (DOB, 'YEAR') AS year_upper,
  INITCAP (TO_CHAR (DOB, 'YEAR')) AS year_initcap,
  LOWER(TO_CHAR (DOB, 'YEAR')) AS year_lower
FROM
  Employee;