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

-- ADDITIONAL QUESTIONS
-- 1. Find the names of all departments with instructor and remove duplicates.
SELECT DISTINCT
       dept_name
FROM
       Instructor;

-- 2. For all instructors who have taught some course, find their names and the course ID of the courses they taught.
SELECT
       i.name,
       t.course_id
FROM
       Instructor i
       JOIN Teaches t ON i.ID = t.ID;

-- 3. Find all the instructors with the courses they taught.
SELECT
       i.name,
       t.course_id
FROM
       Instructor i
       LEFT JOIN Teaches t ON i.ID = t.ID;

-- 4. List all the students with student name, department name, advisor name and the number of courses registered.
SELECT
       s.name AS student_name,
       s.dept_name AS department_name,
       i.name AS advisor_name,
       COUNT(t.course_id) AS number_of_courses
FROM
       Student s
       LEFT JOIN Advisor a ON s.ID = a.s_id
       LEFT JOIN Instructor i ON a.i_id = i.ID
       LEFT JOIN Takes t ON s.ID = t.ID
GROUP BY
       s.ID,
       s.name,
       s.dept_name,

       i.name;
