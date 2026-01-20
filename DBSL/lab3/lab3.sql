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

-- Set Operations
-- UNION
-- 1. Find courses that ran in Fall 2009 or in Spring 2010.
SELECT course_id
FROM Section
WHERE semester = 'Fall' AND year = 2009
UNION ALL
SELECT course_id
FROM Section
WHERE semester = 'Spring' AND year = 2010;


-- INTERSECT
-- 2. Find courses that ran in Fall 2009 and in Spring 2010.
SELECT course_id
FROM Section
WHERE semester = 'Fall' AND year = 2009
INTERSECT
SELECT course_id
FROM Section
WHERE semester = 'Spring' AND year = 2010;


-- MINUS
-- 3. Find courses that ran in Fall 2009 but not in Spring 2010.
SELECT course_id
FROM Section
WHERE semester = 'Fall' AND year = 2009
MINUS
SELECT course_id
FROM Section
WHERE semester = 'Spring' AND year = 2010;


-- Null values
-- 4. Find the name of the course for which none of the students registered.
SELECT c.title
FROM Course c
LEFT OUTER JOIN Takes t
ON c.course_id = t.course_id
WHERE t.ID IS NULL;


-- Nested Subqueries
-- Set Membership (in / not in)
-- 5. Find courses offered in Fall 2009 and in Spring 2010.
SELECT DISTINCT course_id
FROM Section
WHERE course_id IN (
        SELECT course_id
        FROM Section
        WHERE semester = 'Fall' AND year = 2009
)
AND course_id IN (
        SELECT course_id
        FROM Section
        WHERE semester = 'Spring' AND year = 2010
);


-- 6. Find the total number of students who have taken course taught by the instructor with ID 10101.
SELECT COUNT(DISTINCT ID)
FROM Takes
WHERE (course_id, sec_id, semester, year) IN (
        SELECT course_id, sec_id, semester, year
        FROM Teaches
        WHERE ID = 10101
);


-- 7. Find courses offered in Fall 2009 but not in Spring 2010.
SELECT DISTINCT course_id
FROM Section
WHERE course_id IN (
        SELECT course_id
        FROM Section
        WHERE semester = 'Fall' AND year = 2009
)
AND course_id NOT IN (
        SELECT course_id
        FROM Section
        WHERE semester = 'Spring' AND year = 2010
);


-- 8. Find the names of all students whose name is same as the instructor’s name.
SELECT name
FROM Student
WHERE name IN (
        SELECT name
        FROM Instructor
);


-- Set Comparison (>= some / all)
-- 9. Find names of instructors with salary greater than that of some (at least one) instructor in the Biology department.
SELECT name
FROM Instructor
WHERE salary > SOME (
        SELECT salary
        FROM Instructor
        WHERE dept_name = 'Biology'
);


-- 10. Find the names of all instructors whose salary is greater than the salary of all instructors in the Biology department.
SELECT name
FROM Instructor
WHERE salary > ALL (
        SELECT salary
        FROM Instructor
        WHERE dept_name = 'Biology'
);


-- 11. Find the departments that have the highest average salary.
SELECT dept_name
FROM Instructor
GROUP BY dept_name
HAVING AVG(salary) >= ALL (
        SELECT AVG(salary)
        FROM Instructor
        GROUP BY dept_name
);


-- 12. Find the names of those departments whose budget is lesser than the average salary of all instructors.
SELECT dept_name
FROM Department
WHERE budget < (
        SELECT AVG(salary)
        FROM Instructor
);


-- Test for Empty Relations (exists/ not exists)
-- 13. Find all courses taught in both the Fall 2009 semester and in the Spring 2010 semester.
SELECT DISTINCT s1.course_id
FROM Section s1
WHERE s1.semester = 'Fall'
  AND s1.year = 2009
  AND EXISTS (
        SELECT *
        FROM Section s2
        WHERE s2.course_id = s1.course_id
          AND s2.semester = 'Spring'
          AND s2.year = 2010
);


-- 14. Find all students who have taken all courses offered in the Biology department.
SELECT s.ID, s.name
FROM Student s
WHERE NOT EXISTS (
        SELECT c.course_id
        FROM Course c
        WHERE c.dept_name = 'Biology'
          AND NOT EXISTS (
                SELECT *
                FROM Takes t
                WHERE t.ID = s.ID
                  AND t.course_id = c.course_id
          )
);


-- Test for Absence of Duplicate Tuples
-- 15. Find all courses that were offered at most once in 2009.
SELECT DISTINCT s1.course_id
FROM Section s1
WHERE s1.year = 2009
  AND NOT EXISTS (
        SELECT *
        FROM Section s2
        WHERE s2.course_id = s1.course_id
          AND s2.year = 2009
          AND (
                s2.semester <> s1.semester
                OR s2.sec_id <> s1.sec_id
          )
);


-- 16. Find all the students who have opted at least two courses offered by CSE department.
SELECT DISTINCT s.ID, s.name
FROM Student s
WHERE EXISTS (
        SELECT *
        FROM Takes t1, Takes t2, Course c1, Course c2
        WHERE t1.ID = s.ID
          AND t2.ID = s.ID
          AND t1.course_id = c1.course_id
          AND t2.course_id = c2.course_id
          AND c1.dept_name = 'Comp. Sci.'
          AND c2.dept_name = 'Comp. Sci.'
          AND t1.course_id <> t2.course_id
);


-- Subqueries in the From Clause
-- 17. Find the average instructors salary of those departments where the average salary is greater than 42000.
SELECT dept_name, avg_salary
FROM (
        SELECT dept_name, AVG(salary) AS avg_salary
        FROM Instructor
        GROUP BY dept_name
     ) dept_avg
WHERE avg_salary > 42000;


-- Views
-- 18. Create a view all_courses consisting of course sections offered by Physics department in the Fall 2009, with the building and room number of each section.
CREATE VIEW all_courses AS
SELECT s.course_id,
       s.sec_id,
       s.semester,
       s.year,
       s.building,
       s.room_number
FROM Section s
JOIN Course c
  ON s.course_id = c.course_id
WHERE c.dept_name = 'Physics'
  AND s.semester = 'Fall'
  AND s.year = 2009;


-- 19. Select all the courses from all_courses view.
SELECT *
FROM all_courses;


-- 20. Create a view department_total_salary consisting of department name and total salary of that department.
CREATE VIEW department_total_salary AS
SELECT dept_name,
       SUM(salary) AS total_salary
FROM Instructor
GROUP BY dept_name;