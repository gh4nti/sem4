/*
Relational Schema:
EMPLOYEE(Ssn, Fname, Minit, Lname, Bdate, Address, Sex, Salary, Super_ssn, Dno),
DEPARTMENT(Dnumber, Dname, Mgr_ssn, Mgr_start_date),
DEPT_LOCATIONS(Dnumber, Dlocation),
PROJECT(Pnumber, Pname, Plocation, Dnum),
WORKS_ON(Essn, Pno, Hours),
DEPENDENT(Essn, Dependent_name, Sex, Bdate, Relationship)

Key Constraints:
PK:
EMPLOYEE(Ssn)
DEPARTMENT(Dnumber)
DEPT_LOCATIONS(Dnumber, Dlocation)
PROJECT(Pnumber)
WORKS_ON(Essn, Pno)
DEPENDENT(Essn, Dependent_name)

FK:
EMPLOYEE.Super_ssn → EMPLOYEE.Ssn
EMPLOYEE.Dno → DEPARTMENT.Dnumber
DEPARTMENT.Mgr_ssn → EMPLOYEE.Ssn
DEPT_LOCATIONS.Dnumber → DEPARTMENT.Dnumber
PROJECT.Dnum → DEPARTMENT.Dnumber
WORKS_ON.Essn → EMPLOYEE.Ssn
WORKS_ON.Pno → PROJECT.Pnumber
DEPENDENT.Essn → EMPLOYEE.Ssn
 */
-- 1. Retrieve the birth date and address of the employee(s) whose name is 'John B.  Smith'. Retrieve the name and address of all employees who work for the 'Research' department.
SELECT
    Bdate,
    Address
FROM
    EMPLOYEE
WHERE
    Fname = 'John'
    AND Minit = 'B'
    AND Lname = 'Smith';

SELECT
    Fname,
    Minit,
    Lname,
    Address
FROM
    EMPLOYEE
WHERE
    Dno = (
        SELECT
            Dnumber
        FROM
            DEPARTMENT
        WHERE
            Dname = 'Research'
    );

-- 2. For every project located in 'Stanford', list the project number, the controlling department number, and the department manager's last name, address, and birth date.
SELECT
    P.Pnumber,
    P.Dnum,
    E.Lname,
    E.Address,
    E.Bdate
FROM
    PROJECT P
    JOIN DEPARTMENT D ON P.Dnum = D.Dnumber
    JOIN EMPLOYEE E ON D.Mgr_ssn = E.Ssn
WHERE
    P.Plocation = 'Stanford';

-- 3. For each employee, retrieve the employee's first and last name and the first and last name of his or her immediate supervisor.
SELECT
    E.Fname AS Employee_Fname,
    E.Lname AS Employee_Lname,
    S.Fname AS Supervisor_Fname,
    S.Lname AS Supervisor_Lname
FROM
    EMPLOYEE E
    LEFT JOIN EMPLOYEE S ON E.Super_ssn = S.Ssn;

-- 4. Make a list of all project numbers for projects that involve an employee whose last  name is 'Smith', either as a worker or as a manager of the department that controls the project.
SELECT DISTINCT
    P.Pnumber
FROM
    PROJECT P
WHERE
    P.Pnumber IN (
        SELECT
            W.Pno
        FROM
            WORKS_ON W
            JOIN EMPLOYEE E ON W.Essn = E.Ssn
        WHERE
            E.Lname = 'Smith'
    )
    OR P.Dnum IN (
        SELECT
            D.Dnumber
        FROM
            DEPARTMENT D
            JOIN EMPLOYEE E ON D.Mgr_ssn = E.Ssn
        WHERE
            E.Lname = 'Smith'
    );

-- 5. Show the resulting salaries if every employee working on the ‘ProductX’ project is given a 10 percent raise.
SELECT
    E.Ssn,
    E.Fname,
    E.Lname,
    E.Salary * 1.10 AS New_Salary
FROM
    EMPLOYEE E
    JOIN WORKS_ON W ON E.Ssn = W.Essn
    JOIN PROJECT P ON W.Pno = P.Pnumber
WHERE
    P.Pname = 'ProductX';

-- 6. Retrieve a list of employees and the projects they are working on, ordered by department and, within each department, ordered alphabetically by last name, then first name.
SELECT
    D.Dname,
    E.Fname,
    E.Lname,
    P.Pname
FROM
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.Dno = D.Dnumber
    JOIN WORKS_ON W ON E.Ssn = W.Essn
    JOIN PROJECT P ON W.Pno = P.Pnumber
ORDER BY
    D.Dname,
    E.Lname,
    E.Fname;

-- 7. Retrieve the name of each employee who has a dependent with the same first name and is the same sex as the employee.
SELECT DISTINCT
    E.Fname,
    E.Lname
FROM
    EMPLOYEE E
    JOIN DEPENDENT D ON E.Ssn = D.Essn
WHERE
    E.Fname = D.Dependent_name
    AND E.Sex = D.Sex;

-- 8. Retrieve the names of employees who have no dependents.
SELECT
    E.Fname,
    E.Lname
FROM
    EMPLOYEE E
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            DEPENDENT D
        WHERE
            D.Essn = E.Ssn
    );

-- 9. List the names of managers who have at least one dependent.
SELECT DISTINCT
    E.Fname,
    E.Lname
FROM
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.Ssn = D.Mgr_ssn
WHERE
    EXISTS (
        SELECT
            *
        FROM
            DEPENDENT DP
        WHERE
            DP.Essn = E.Ssn
    );

-- 10. Find the sum of the salaries of all employees, the maximum salary, the minimum salary, and the average salary.
SELECT
    SUM(Salary) AS Total_Salary,
    MAX(Salary) AS Max_Salary,
    MIN(Salary) AS Min_Salary,
    AVG(Salary) AS Avg_Salary
FROM
    EMPLOYEE;

-- 11. For each project, retrieve the project number, the project name, and the number of employees who work on that project.
SELECT
    P.Pnumber,
    P.Pname,
    COUNT(W.Essn) AS Num_Employees
FROM
    PROJECT P
    LEFT JOIN WORKS_ON W ON P.Pnumber = W.Pno
GROUP BY
    P.Pnumber,
    P.Pname;

-- 12. For each project on which more than two employees work, retrieve the project number, the project name, and the number of employees who work on the project.
SELECT
    P.Pnumber,
    P.Pname,
    COUNT(W.Essn) AS Num_Employees
FROM
    PROJECT P
    JOIN WORKS_ON W ON P.Pnumber = W.Pno
GROUP BY
    P.Pnumber,
    P.Pname
HAVING
    COUNT(W.Essn) > 2;

-- 13. For each department that has more than five employees, retrieve the department number and the number of its employees who are making more than 40,000.
SELECT
    D.Dnumber,
    COUNT(E.Ssn) AS Num_Employees_Over_40000
FROM
    DEPARTMENT D
    JOIN EMPLOYEE E ON D.Dnumber = E.Dno
WHERE
    E.Salary > 40000
GROUP BY
    D.Dnumber
HAVING
    COUNT(E.Ssn) > 5;