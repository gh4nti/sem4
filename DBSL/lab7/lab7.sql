-- Use a table StudentTable(RollNo, GPA) and populate the table with {(1, 5.8); (2, 6.5); (3, 3.4); (4,7.8); (5, 9.5)} unless a different DB schema is explicitly specified.
CREATE TABLE StudentTable (
    RollNo NUMBER PRIMARY KEY,
    GPA NUMBER(3, 1)
);

BEGIN FOR rec IN 1..5 LOOP
INSERT INTO
    StudentTable
VALUES
    (
        rec,
        CASE
            rec
            WHEN 1 THEN 5.8
            WHEN 2 THEN 6.5
            WHEN 3 THEN 3.4
            WHEN 4 THEN 7.8
            WHEN 5 THEN 9.5
        END
    );

END LOOP;

COMMIT;

END;

SET
    SERVEROUTPUT ON;

/ -- 1. Write a PL/SQL block to display the GPA of given student.
DECLARE v_rollno StudentTable.RollNo % TYPE := & rollno;

v_gpa StudentTable.GPA % TYPE;

BEGIN
SELECT
    GPA INTO v_gpa
FROM
    StudentTable
WHERE
    RollNo = v_rollno;

DBMS_OUTPUT.PUT_LINE(
    'GPA of student ' || v_rollno || ' is: ' || v_gpa
);

EXCEPTION
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Student not found.');

END;

/ -- Usage of IF–THEN
-- 2. Write a PL/SQL block to display the letter grade (0-4: F; 4-5: E; 5-6: D; 6-7: C; 7-8: B; 8-9: A; 9-10: A+) of given student.
DECLARE v_rollno StudentTable.RollNo % TYPE := & rollno;

v_gpa StudentTable.GPA % TYPE;

v_grade VARCHAR2(2);

BEGIN
SELECT
    GPA INTO v_gpa
FROM
    StudentTable
WHERE
    RollNo = v_rollno;

IF v_gpa >= 0
AND v_gpa < 4 THEN v_grade := 'F';

ELSIF v_gpa >= 4
AND v_gpa < 5 THEN v_grade := 'E';

ELSIF v_gpa >= 5
AND v_gpa < 6 THEN v_grade := 'D';

ELSIF v_gpa >= 6
AND v_gpa < 7 THEN v_grade := 'C';

ELSIF v_gpa >= 7
AND v_gpa < 8 THEN v_grade := 'B';

ELSIF v_gpa >= 8
AND v_gpa < 9 THEN v_grade := 'A';

ELSIF v_gpa >= 9
AND v_gpa <= 10 THEN v_grade := 'A+';

ELSE v_grade := 'Invalid GPA';

END IF;

DBMS_OUTPUT.PUT_LINE('RollNo: ' || v_rollno);

DBMS_OUTPUT.PUT_LINE('GPA: ' || v_gpa);

DBMS_OUTPUT.PUT_LINE('Grade: ' || v_grade);

EXCEPTION
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Student not found.');

END;

/ -- 3. Input the date of issue and date of return for a book. Calculate and display the fine with the appropriate message using a PL/SQL block.
DECLARE v_issue_date DATE := TO_DATE('&issue_date', 'DD-MM-YYYY');

v_return_date DATE := TO_DATE('&return_date', 'DD-MM-YYYY');

v_late_days NUMBER;

v_fine NUMBER := 0;

BEGIN v_late_days := v_return_date - v_issue_date;

IF v_late_days <= 7 THEN v_fine := 0;

ELSIF v_late_days BETWEEN 8
AND 15 THEN v_fine := v_late_days * 1;

ELSIF v_late_days BETWEEN 16
AND 30 THEN v_fine := v_late_days * 2;

ELSE v_fine := v_late_days * 5;

END IF;

DBMS_OUTPUT.PUT_LINE('Late Days: ' || v_late_days);

DBMS_OUTPUT.PUT_LINE('Fine Amount: Rs. ' || v_fine);

EXCEPTION
WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Invalid date entered.');

END;

/ -- Simple LOOP
-- 4. Write a PL/SQL block to print the letter grade of all the students (RollNo: 1-5).
DECLARE v_grade VARCHAR2(2);

BEGIN FOR rec IN (
    SELECT
        RollNo,
        GPA
    FROM
        StudentTable
    ORDER BY
        RollNo
) LOOP IF rec.GPA >= 0
AND rec.GPA < 4 THEN v_grade := 'F';

ELSIF rec.GPA >= 4
AND rec.GPA < 5 THEN v_grade := 'E';

ELSIF rec.GPA >= 5
AND rec.GPA < 6 THEN v_grade := 'D';

ELSIF rec.GPA >= 6
AND rec.GPA < 7 THEN v_grade := 'C';

ELSIF rec.GPA >= 7
AND rec.GPA < 8 THEN v_grade := 'B';

ELSIF rec.GPA >= 8
AND rec.GPA < 9 THEN v_grade := 'A';

ELSE v_grade := 'A+';

END IF;

DBMS_OUTPUT.PUT_LINE(
    'RollNo: ' || rec.RollNo || '  GPA: ' || rec.GPA || '  Grade: ' || v_grade
);

END LOOP;

END;

/ -- Usage of WHILE
-- 5. Alter StudentTable by appending an additional column LetterGrade Varchar2(2). Then write a PL/SQL block  to update the table with letter grade of each student.
ALTER TABLE
    StudentTable
ADD
    LetterGrade VARCHAR2(2);

DECLARE v_rollno NUMBER := 1;

v_gpa StudentTable.GPA % TYPE;

v_grade VARCHAR2(2);

BEGIN WHILE v_rollno <= 5 LOOP
SELECT
    GPA INTO v_gpa
FROM
    StudentTable
WHERE
    RollNo = v_rollno;

IF v_gpa >= 0
AND v_gpa < 4 THEN v_grade := 'F';

ELSIF v_gpa >= 4
AND v_gpa < 5 THEN v_grade := 'E';

ELSIF v_gpa >= 5
AND v_gpa < 6 THEN v_grade := 'D';

ELSIF v_gpa >= 6
AND v_gpa < 7 THEN v_grade := 'C';

ELSIF v_gpa >= 7
AND v_gpa < 8 THEN v_grade := 'B';

ELSIF v_gpa >= 8
AND v_gpa < 9 THEN v_grade := 'A';

ELSE v_grade := 'A+';

END IF;

UPDATE
    StudentTable
SET
    LetterGrade = v_grade
WHERE
    RollNo = v_rollno;

v_rollno := v_rollno + 1;

END LOOP;

COMMIT;

DBMS_OUTPUT.PUT_LINE('Letter grades updated successfully.');

END;

/ -- Usage of FOR
-- 6. Write a PL/SQL block to find the student with max. GPA without using aggregate function.
DECLARE v_max_gpa StudentTable.GPA % TYPE := 0;

v_max_roll StudentTable.RollNo % TYPE;

BEGIN FOR rec IN (
    SELECT
        RollNo,
        GPA
    FROM
        StudentTable
) LOOP IF rec.GPA > v_max_gpa THEN v_max_gpa := rec.GPA;

v_max_roll := rec.RollNo;

END IF;

END LOOP;

DBMS_OUTPUT.PUT_LINE('Student with Maximum GPA:');

DBMS_OUTPUT.PUT_LINE('RollNo: ' || v_max_roll);

DBMS_OUTPUT.PUT_LINE('GPA: ' || v_max_gpa);

END;

/ -- Usage of GOTO
-- 7. Implement lab exercise 4 using GOTO.
DECLARE v_rollno NUMBER := 1;

v_gpa StudentTable.GPA % TYPE;

v_grade VARCHAR2(2);

BEGIN < < start_loop > > IF v_rollno > 5 THEN GOTO end_loop;

END IF;

SELECT
    GPA INTO v_gpa
FROM
    StudentTable
WHERE
    RollNo = v_rollno;

IF v_gpa >= 0
AND v_gpa < 4 THEN v_grade := 'F';

ELSIF v_gpa >= 4
AND v_gpa < 5 THEN v_grade := 'E';

ELSIF v_gpa >= 5
AND v_gpa < 6 THEN v_grade := 'D';

ELSIF v_gpa >= 6
AND v_gpa < 7 THEN v_grade := 'C';

ELSIF v_gpa >= 7
AND v_gpa < 8 THEN v_grade := 'B';

ELSIF v_gpa >= 8
AND v_gpa < 9 THEN v_grade := 'A';

ELSE v_grade := 'A+';

END IF;

DBMS_OUTPUT.PUT_LINE(
    'RollNo: ' || v_rollno || '  GPA: ' || v_gpa || '  Grade: ' || v_grade
);

v_rollno := v_rollno + 1;

GOTO start_loop;

< < end_loop > > NULL;

END;

/ -- Exception Handling
/*
 8. Based on the University database schema, write a PL/SQL block to display the details of the Instructor whose name is supplied by the user. Use exceptions to show appropriate error message for the following cases: 
 a. Multiple instructors with the same name
 b. No instructor for the given name
 */
DECLARE v_name Instructor.name % TYPE := '&instructor_name';

v_id Instructor.ID % TYPE;

v_dept Instructor.dept_name % TYPE;

v_salary Instructor.salary % TYPE;

BEGIN
SELECT
    ID,
    dept_name,
    salary INTO v_id,
    v_dept,
    v_salary
FROM
    Instructor
WHERE
    name = v_name;

DBMS_OUTPUT.PUT_LINE('Instructor Details:');

DBMS_OUTPUT.PUT_LINE('ID: ' || v_id);

DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept);

DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);

EXCEPTION
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE(
    'Error: No instructor found with name ' || v_name
);

WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE(
    'Error: Multiple instructors found with name ' || v_name
);

END;

/