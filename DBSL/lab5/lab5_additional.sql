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
-- 1. Find the names of employees who work on all the projects controlled by department number 5.
SELECT
    E.Fname,
    E.Lname
FROM
    EMPLOYEE E
WHERE
    NOT EXISTS (
        SELECT
            P.Pnumber
        FROM
            PROJECT P
        WHERE
            P.Dnum = 5
            AND NOT EXISTS (
                SELECT
                    *
                FROM
                    WORKS_ON W
                WHERE
                    W.Essn = E.Ssn
                    AND W.Pno = P.Pnumber
            )
    );

-- 2. Find the names of all employees who have a higher salary than some instructor in 'Research' department.
SELECT
    E.Fname,
    E.Lname
FROM
    EMPLOYEE E
WHERE
    E.Salary > SOME (
        SELECT
            E2.Salary
        FROM
            EMPLOYEE E2
            JOIN DEPARTMENT D ON E2.Dno = D.Dnumber
        WHERE
            D.Dname = 'Research'
    );

-- 3. Find the total number of (distinct) employees who have worked on project 'ProductX'.
SELECT
    COUNT(DISTINCT W.Essn) AS Total_Employees
FROM
    WORKS_ON W
    JOIN PROJECT P ON W.Pno = P.Pnumber
WHERE
    P.Pname = 'ProductX';