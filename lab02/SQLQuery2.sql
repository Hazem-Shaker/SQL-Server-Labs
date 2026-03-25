SELECT DB_NAME() AS CurrentDatabase
---
SELECT * FROM Employee
---
SELECT Fname, Lname, salary, Dno
FROM Employee
--
SELECT Pname, Plocation, Dnum FROM Project
-----
SELECT Fname + ' ' + Lname AS [full_name],
       salary * 12 * 0.10 AS [ANNUAL COMM]
FROM Employee
----
SELECT Fname + ' ' + Lname AS [full_name], SSN
FROM Employee
WHERE salary > 1000
---
SELECT Fname + ' ' + Lname AS [full_name], SSN
FROM Employee
WHERE salary * 12 > 10000
---
SELECT Fname + ' ' + Lname AS [full_name], Salary
FROM Employee
WHERE Sex = 'F'
---
SELECT Dname, Dnum
FROM Departments
WHERE MGRSSN = 968574
---
Select Pnumber, Pname, Plocation
FROM Project
WHERE Dnum = 10
---
