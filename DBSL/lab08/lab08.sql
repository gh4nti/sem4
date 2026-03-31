-- Note: Use University DB schema for the following, unless a different DB schema is explicitly specified.
-- Cursors
-- CursorName %ISOPEN / FOUND / NOT FOUND
-- 1. The HRD manager has decided to raise the salary of all the Instructors in a given department number by 5%. Whenever, any such raise is given to the instructor, a record for the same is maintained in the salary_raise table. It includes the Instuctor Id, the date when the raise was given and the actual raise amount. Write a PL/SQL block to update the salary of each Instructor and insert a record in the salary_raise table.
-- salary_raise(Instructor_Id, Raise_date, Raise_amt)
DECLARE v_dept_name instructor.dept_name % TYPE := '&Enter_Dept_Name';

v_id instructor.id % TYPE;

v_salary instructor.salary % TYPE;

v_raise_amt instructor.salary % TYPE;

CURSOR c_instructor IS
SELECT
    id,
    salary
FROM
    instructor
WHERE
    dept_name = v_dept_name FOR
UPDATE
;

BEGIN OPEN c_instructor;

IF c_instructor % ISOPEN THEN LOOP FETCH c_instructor INTO v_id,
v_salary;

EXIT
WHEN c_instructor % NOTFOUND;

-- Calculate 5% raise
v_raise_amt := v_salary * 0.05;

-- Update salary
UPDATE
    instructor
SET
    salary = salary + v_raise_amt
WHERE
    CURRENT OF c_instructor;

-- Insert raise record
INSERT INTO
    salary_raise
VALUES
    (v_id, SYSDATE, v_raise_amt);

END LOOP;

CLOSE c_instructor;

END IF;

COMMIT;

END;

SET
    SERVEROUTPUT ON;

/ -- CursorName%ROWCOUNT
-- 2. Write a PL/SQL block that will display the ID, name, dept_name and tot_cred of the first 10 students with lowest total credit.
DECLARE v_id student.ID % TYPE;

v_name student.name % TYPE;

v_dept student.dept_name % TYPE;

v_tot_cred student.tot_cred % TYPE;

CURSOR c_student IS
SELECT
    ID,
    name,
    dept_name,
    tot_cred
FROM
    student
ORDER BY
    tot_cred ASC;

BEGIN OPEN c_student;

LOOP FETCH c_student INTO v_id,
v_name,
v_dept,
v_tot_cred;

EXIT
WHEN c_student % NOTFOUND
OR c_student % ROWCOUNT > 10;

DBMS_OUTPUT.PUT_LINE(
    'ID: ' || v_id || ' | Name: ' || v_name || ' | Dept: ' || v_dept || ' | Total Credits: ' || v_tot_cred
);

END LOOP;

CLOSE c_student;

END;

/ -- Cursor FOR loop 
-- 3. Print the Course details and the total number of students registered for each course along with the course details - (Course-id, title, dept-name, credits, instructor_name, building, room-number, time-slot-id, tot_student_no.
DECLARE BEGIN FOR rec IN (
    SELECT
        c.course_id,
        c.title,
        c.dept_name,
        c.credits,
        i.name AS instructor_name,
        s.building,
        s.room_number,
        s.time_slot_id,
        (
            SELECT
                COUNT(*)
            FROM
                takes t
            WHERE
                t.course_id = s.course_id
                AND t.sec_id = s.sec_id
                AND t.semester = s.semester
                AND t.year = s.year
        ) AS tot_student_no
    FROM
        course c
        JOIN section s ON c.course_id = s.course_id
        JOIN teaches t ON s.course_id = t.course_id
        AND s.sec_id = t.sec_id
        AND s.semester = t.semester
        AND s.year = t.year
        JOIN instructor i ON t.ID = i.ID
) LOOP DBMS_OUTPUT.PUT_LINE(
    'Course ID: ' || rec.course_id || ' | Title: ' || rec.title || ' | Dept: ' || rec.dept_name || ' | Credits: ' || rec.credits || ' | Instructor: ' || rec.instructor_name || ' | Building: ' || rec.building || ' | Room: ' || rec.room_number || ' | Time Slot: ' || rec.time_slot_id || ' | Total Students: ' || rec.tot_student_no
);

END LOOP;

END;

/ -- 4. Find all students who take the course with Course-id: CS101 and if he/she has less than 30 total credit (tot-cred), deregister the student from that course. (Delete the entry in Takes table).
DECLARE BEGIN FOR rec IN (
    SELECT
        s.ID,
        s.name
    FROM
        student s
        JOIN takes t ON s.ID = t.ID
    WHERE
        t.course_id = 'CS101'
        AND s.tot_cred < 30
) LOOP
DELETE FROM
    takes
WHERE
    ID = rec.ID
    AND course_id = 'CS101';

DBMS_OUTPUT.PUT_LINE(
    'Student Deregistered: ' || rec.ID || ' - ' || rec.name
);

END LOOP;

COMMIT;

END;

/ -- WHERE CURRENT OF
-- 5. Alter StudentTable (refer Lab No. 8 Exercise) by resetting column LetterGrade to F. Then write a PL/SQL block to update the table by mapping GPA to the corresponding letter grade for each student.
UPDATE
    StudentTable
SET
    LetterGrade = 'F';

COMMIT;

DECLARE v_grade StudentTable.LetterGrade % TYPE;

CURSOR c_student IS
SELECT
    GPA
FROM
    StudentTable FOR
UPDATE
;

BEGIN FOR rec IN c_student LOOP -- GPA to Grade Mapping
IF rec.GPA >= 9 THEN v_grade := 'A+';

ELSIF rec.GPA >= 8 THEN v_grade := 'A';

ELSIF rec.GPA >= 7 THEN v_grade := 'B';

ELSIF rec.GPA >= 6 THEN v_grade := 'C';

ELSIF rec.GPA >= 5 THEN v_grade := 'D';

ELSE v_grade := 'F';

END IF;

-- Update using WHERE CURRENT OF
UPDATE
    StudentTable
SET
    LetterGrade = v_grade
WHERE
    CURRENT OF c_student;

END LOOP;

COMMIT;

END;

/ -- Parameterized Cursors
-- 6. Write a PL/SQL block to print the list of Instructors teaching a specified course.  
SET
    SERVEROUTPUT ON;

DECLARE v_course_id course.course_id % TYPE := '&Enter_Course_ID';

CURSOR c_instructor (p_course_id course.course_id % TYPE) IS
SELECT
    DISTINCT i.ID,
    i.name,
    i.dept_name
FROM
    instructor i
    JOIN teaches t ON i.ID = t.ID
WHERE
    t.course_id = p_course_id;

BEGIN FOR rec IN c_instructor(v_course_id) LOOP DBMS_OUTPUT.PUT_LINE(
    'Instructor ID: ' || rec.ID || ' | Name: ' || rec.name || ' | Dept: ' || rec.dept_name
);

END LOOP;

END;

/ -- 7. Write a PL/SQL block to list the students who have registered for a course taught by his/her advisor.
SET
    SERVEROUTPUT ON;

DECLARE CURSOR c_students (p_course_id course.course_id % TYPE) IS
SELECT
    DISTINCT s.ID,
    s.name
FROM
    student s
    JOIN takes t ON s.ID = t.ID
    JOIN teaches te ON te.course_id = t.course_id
    AND te.sec_id = t.sec_id
    AND te.semester = t.semester
    AND te.year = t.year
WHERE
    s.advisor_ID = te.ID
    AND t.course_id = p_course_id;

v_course_id course.course_id % TYPE := '&Enter_Course_ID';

BEGIN FOR rec IN c_students(v_course_id) LOOP DBMS_OUTPUT.PUT_LINE(
    'Student ID: ' || rec.ID || ' | Name: ' || rec.name
);

END LOOP;

END;

/