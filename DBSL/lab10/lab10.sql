-- Row Triggers
-- 1. Based on the University database Schema in Lab 2, write a row trigger that records along with the time any change made in the Takes (ID, course-id, sec-id, semester, year, grade) table in log_change_Takes (Time_Of_Change, ID, courseid,sec-id, semester, year, grade).
CREATE
OR REPLACE TRIGGER trg_log_takes_changes
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON Takes FOR EACH ROW BEGIN -- INSERT operation
    IF INSERTING THEN
INSERT INTO
    log_change_Takes
VALUES
    (
        SYSTIMESTAMP,
        :NEW.ID,
        :NEW.course_id,
        :NEW.sec_id,
        :NEW.semester,
        :NEW.year,
        :NEW.grade
    );

-- UPDATE operation
ELSIF UPDATING THEN
INSERT INTO
    log_change_Takes
VALUES
    (
        SYSTIMESTAMP,
        :NEW.ID,
        :NEW.course_id,
        :NEW.sec_id,
        :NEW.semester,
        :NEW.year,
        :NEW.grade
    );

-- DELETE operation
ELSIF DELETING THEN
INSERT INTO
    log_change_Takes
VALUES
    (
        SYSTIMESTAMP,
        :OLD.ID,
        :OLD.course_id,
        :OLD.sec_id,
        :OLD.semester,
        :OLD.year,
        :OLD.grade
    );

END IF;

END;

/ -- 2. Based on the University database schema in Lab 2, write a row trigger to insert the existing values of the Instructor (ID, name, dept-name, salary) table into a new table Old_Data_Instructor (ID, name, dept-name, salary) when the salary table is updated.
CREATE
OR REPLACE TRIGGER trg_old_instructor_data BEFORE
UPDATE
    OF salary ON Instructor FOR EACH ROW BEGIN
INSERT INTO
    Old_Data_Instructor
VALUES
    (
        :OLD.ID,
        :OLD.name,
        :OLD.dept_name,
        :OLD.salary
    );

END;

/ -- Database Triggers
/*
 3. Based on the University Schema, write a database trigger on Instructor that checks the following: 
 - The name of the instructor is a valid name containing only alphabets.
 - The salary of an instructor is not zero and is positive.
 - The salary does not exceed the budget of the department to which the instructor belongs.
 */
CREATE
OR REPLACE TRIGGER trg_check_instructor BEFORE
INSERT
    OR
UPDATE
    ON Instructor FOR EACH ROW DECLARE dept_budget NUMBER;

BEGIN -- 1. Name should contain only alphabets
IF NOT REGEXP_LIKE(:NEW.name, '^[A-Za-z ]+$') THEN RAISE_APPLICATION_ERROR(-20001, 'Invalid name: Only alphabets allowed');

END IF;

-- 2. Salary must be positive and not zero
IF :NEW.salary <= 0 THEN RAISE_APPLICATION_ERROR(-20002, 'Salary must be greater than zero');

END IF;

-- 3. Salary should not exceed department budget
SELECT
    budget INTO dept_budget
FROM
    Department
WHERE
    dept_name = :NEW.dept_name;

IF :NEW.salary > dept_budget THEN RAISE_APPLICATION_ERROR(-20003, 'Salary exceeds department budget');

END IF;

EXCEPTION
WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20004, 'Department does not exist');

END;

/ -- 4. Create a transparent audit system for a table Client_master (client_no, name, address, Bal_due). The system must keep track of the records that are being deleted or updated. The functionality being when a record is deleted or modified the original record details and the date of operation are stored in the auditclient (client_no, name, bal_due, operation, userid, opdate) table, then the delete or update is allowed to go through.
CREATE TABLE auditclient (
    client_no VARCHAR2(10),
    name VARCHAR2(50),
    bal_due NUMBER,
    operation VARCHAR2(10),
    userid VARCHAR2(30),
    opdate DATE
);

CREATE
OR REPLACE TRIGGER trg_audit_client BEFORE
UPDATE
    OR DELETE ON Client_master FOR EACH ROW BEGIN -- For UPDATE operation
    IF UPDATING THEN
INSERT INTO
    auditclient
VALUES
    (
        :OLD.client_no,
        :OLD.name,
        :OLD.bal_due,
        'UPDATE',
        USER,
        SYSDATE
    );

END IF;

-- For DELETE operation
IF DELETING THEN
INSERT INTO
    auditclient
VALUES
    (
        :OLD.client_no,
        :OLD.name,
        :OLD.bal_due,
        'DELETE',
        USER,
        SYSDATE
    );

END IF;

END;

/ -- Instead of Triggers
-- 5. Based on the University database Schema in Lab 2, create a view Advisor_Student which is a natural join on Advisor, Student and Instructor tables. Create an INSTEAD OF trigger on Advisor_Student to enable the user to delete the corresponding entries in Advisor table.
CREATE
OR REPLACE VIEW Advisor_Student AS
SELECT
    *
FROM
    Advisor NATURAL
    JOIN Student NATURAL
    JOIN Instructor;

CREATE
OR REPLACE TRIGGER trg_delete_advisor_student INSTEAD OF DELETE ON Advisor_Student FOR EACH ROW BEGIN
DELETE FROM
    Advisor
WHERE
    s_id = :OLD.s_id
    AND i_id = :OLD.i_id;

END;

/