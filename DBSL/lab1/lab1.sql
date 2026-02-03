-- 1. Create a table employee with (emp_no, emp_name, emp_address)
CREATE TABLE employee (
    emp_no NUMBER(5),
    emp_name VARCHAR(20),
    emp_address VARCHAR(20)
);

-- 2. Insert five employees information.
INSERT INTO
    employee
VALUES
    (101, 'ABC', 'MANIPAL');

INSERT INTO
    employee
VALUES
    (102, 'DEF', 'MANGALORE');

INSERT INTO
    employee
VALUES
    (103, 'GHI', 'MANIPAL');

INSERT INTO
    employee
VALUES
    (104, 'JKL', 'BANGALORE');

INSERT INTO
    employee
VALUES
    (105, 'MNO', 'MANGALORE');

COMMIT;

-- 3. Display names of all employees.
SELECT
    emp_name
FROM
    employee;

-- 4. Display all the employees from ‘MANIPAL’.
SELECT
    *
FROM
    employee
WHERE
    emp_address = 'MANIPAL';

-- 5. Add a column named salary to employee table.
ALTER TABLE
    employee
ADD
    salary NUMBER(8, 2);

-- 6. Assign the salary for all employees.
UPDATE
    employee
SET
    salary = 30000
WHERE
    emp_no = 101;

UPDATE
    employee
SET
    salary = 28000
WHERE
    emp_no = 102;

UPDATE
    employee
SET
    salary = 32000
WHERE
    emp_no = 103;

UPDATE
    employee
SET
    salary = 35000
WHERE
    emp_no = 104;

UPDATE
    employee
SET
    salary = 29000
WHERE
    emp_no = 105;

COMMIT;

-- 7. View the structure of the table employee using describe.
DESC employee;

-- 8. Delete all the employees from ‘MANGALORE’.
DELETE FROM
    employee
WHERE
    emp_address = 'MANGALORE';

COMMIT;

-- 9. Rename employee as employee1.
RENAME employee TO employee1;

-- 10. Drop the table employee1.
DROP TABLE employee1;