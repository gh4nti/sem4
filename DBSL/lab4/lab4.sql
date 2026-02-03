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

-- Group By
-- 1. Find the number of students in each course.
SELECT
    course_id,
    COUNT(ID) AS student_count
FROM
    Takes
GROUP BY
    course_id;

-- 2. Find those departments where the average number of students are greater than 10.
SELECT
    c.dept_name
FROM
    Course c
    JOIN Takes t ON c.course_id = t.course_id
GROUP BY
    c.dept_name,
    c.course_id
HAVING
    COUNT(t.ID) > 10;

-- 3. Find the total number of courses in each department.
SELECT
    dept_name,
    COUNT(course_id) AS total_courses
FROM
    Course
GROUP BY
    dept_name;

-- 4. Find the names and average salaries of all departments whose average salary is greater than 42000.
SELECT
    dept_name,
    AVG(salary) AS avg_salary
FROM
    Instructor
GROUP BY
    dept_name
HAVING
    AVG(salary) > 42000;

-- 5. Find the enrolment of each section that was offered in Spring 2009.
SELECT
    course_id,
    sec_id,
    COUNT(ID) AS enrolment
FROM
    Takes
WHERE
    semester = 'Spring'
    AND year = 2009
GROUP BY
    course_id,
    sec_id;

-- Ordering the display of Tuples (Use ORDER BY ASC/DESC)
-- 6. List all the courses with prerequisite courses, then display course id in increasing order.
SELECT
    course_id,
    prereq_id
FROM
    Prereq
ORDER BY
    course_id ASC;

-- 7. Display the details of instructors sorting the salary in decreasing order.
SELECT
    *
FROM
    Instructor
ORDER BY
    salary DESC;

-- Derived Relations
-- 8. Find the maximum total salary across the departments.
SELECT
    MAX(total_salary) AS max_total_salary
FROM
    (
        SELECT
            dept_name,
            SUM(salary) AS total_salary
        FROM
            Instructor
        GROUP BY
            dept_name
    ) dept_totals;

-- 9. Find the average instructors’ salaries of those departments where the average salary is greater than 42000.
SELECT
    dept_name,
    avg_salary
FROM
    (
        SELECT
            dept_name,
            AVG(salary) AS avg_salary
        FROM
            Instructor
        GROUP BY
            dept_name
    )
WHERE
    avg_salary > 42000;

-- 10. Find the sections that had the maximum enrolment in Spring 2010.
SELECT
    course_id,
    sec_id,
    enrolment
FROM
    (
        SELECT
            course_id,
            sec_id,
            COUNT(ID) AS enrolment
        FROM
            Takes
        WHERE
            semester = 'Spring'
            AND year = 2010
        GROUP BY
            course_id,
            sec_id
    )
WHERE
    enrolment = (
        SELECT
            MAX(enrolment)
        FROM
            (
                SELECT
                    COUNT(ID) AS enrolment
                FROM
                    Takes
                WHERE
                    semester = 'Spring'
                    AND year = 2010
                GROUP BY
                    course_id,
                    sec_id
            )
    );

-- 11. Find the names of all instructors who teach all students that belong to ‘CSE’ department.
SELECT
    i.name
FROM
    Instructor i
WHERE
    NOT EXISTS (
        SELECT
            s.ID
        FROM
            Student s
        WHERE
            s.dept_name = 'Comp. Sci.'
            AND NOT EXISTS (
                SELECT
                    *
                FROM
                    Teaches t
                    JOIN Takes tk ON t.course_id = tk.course_id
                    AND t.sec_id = tk.sec_id
                    AND t.semester = tk.semester
                    AND t.year = tk.year
                WHERE
                    t.ID = i.ID
                    AND tk.ID = s.ID
            )
    );

-- 12. Find the average salary of those department where the average salary is greater than 50000 and total number of instructors in the department are more than 5.
SELECT
    dept_name,
    avg_salary
FROM
    (
        SELECT
            dept_name,
            AVG(salary) AS avg_salary,
            COUNT(ID) AS instructor_count
        FROM
            Instructor
        GROUP BY
            dept_name
    )
WHERE
    avg_salary > 50000
    AND instructor_count > 5;

-- With Clause
-- 13. Find all departments with the maximum budget.
WITH
    max_budget AS (
        SELECT
            MAX(budget) AS max_budget
        FROM
            Department
    )
SELECT
    dept_name
FROM
    Department,
    max_budget
WHERE
    Department.budget = max_budget.max_budget;

-- 14. Find all departments where the total salary is greater than the average of the total salary at all departments.
WITH
    dept_total_salary AS (
        SELECT
            dept_name,
            SUM(salary) AS total_salary
        FROM
            Instructor
        GROUP BY
            dept_name
    ),
    avg_total_salary AS (
        SELECT
            AVG(total_salary) AS avg_salary
        FROM
            dept_total_salary
    )
SELECT
    dept_name
FROM
    dept_total_salary,
    avg_total_salary
WHERE
    dept_total_salary.total_salary > avg_total_salary.avg_salary;

-- Use ROLLBACK (and SAVEPOINT) to undo the effect of any modification on database before COMMIT
-- 15. Transfer all the students from CSE department to IT department.
SAVEPOINT before_transfer;

UPDATE Student
SET
    dept_name = 'IT'
WHERE
    dept_name = 'Comp. Sci.';

-- ROLLBACK
ROLLBACK TO before_transfer;

-- COMMIT;
-- 16. Increase salaries of instructors whose salary is over $100,000 by 3%, and all others receive a 5% raise.
SAVEPOINT before_salary_update;

UPDATE Instructor
SET
    salary = CASE
        WHEN salary > 100000 THEN salary * 1.03
        ELSE salary * 1.05
    END;

-- ROLLBACK
ROLLBACK TO before_salary_update;


-- COMMIT;
