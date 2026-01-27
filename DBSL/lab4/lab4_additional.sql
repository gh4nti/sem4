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

@university.sql

-- ADDITIONAL EXERCISE
-- 1. Display lowest paid instructor details under each department.
SELECT *
FROM Instructor i
WHERE salary = (
    SELECT MIN(salary)
    FROM Instructor
    WHERE dept_name = i.dept_name
);


-- 2. Find the sum of the salaries of all instructors of the ‘CSE’ department, as well as maximum salary, the minimum salary, and the average salary in this department.
SELECT 
    SUM(salary) AS total_salary,
    MAX(salary) AS max_salary,
    MIN(salary) AS min_salary,
    AVG(salary) AS avg_salary
FROM Instructor
WHERE dept_name = 'Comp. Sci.';


-- 3. Retrieve the name of each student who registered for all the subjects offered by ‘CSE’ department.
SELECT s.name
FROM Student s
WHERE NOT EXISTS (
    SELECT c.course_id
    FROM Course c
    WHERE c.dept_name = 'CSE'
      AND NOT EXISTS (
          SELECT *
          FROM Takes t
          WHERE t.ID = s.ID
            AND t.course_id = c.course_id
      )
);