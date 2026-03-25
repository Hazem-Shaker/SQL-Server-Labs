SELECT d.Dnum, d.Dname, concat(e.Fname, ' ', e.Lname) FullName
FROM Departments d inner join Employee e
On d.MGRSSN = e.SSN
-------------------------------

SELECT d.Dname, p.Pname
FROM Departments d, Project p
WHERE p.Dnum = d.Dnum
-------------------------------

SELECT *
FROM Dependent d, Employee e
WHERE d.ESSN = e.SSN
-------------------------------

SELECT p.Pnumber, p.Pname, p.Plocation
FROM Project p
WHERE p.City in ('Cairo','Alex')
-------------------------------

SELECT *
FROM Project p
WHERE p.Pname like 'a%'
-------------------------------

SELECT *
FROM Employee e
WHERE e.Dno = 30 and e.Salary >= 1000 and e.Salary <= 2000
-------------------------------

SELECT concat(e.Fname, ' ', e.Lname) FullName
FROM Employee e, Project p, Works_for w
WHERE e.SSN = w.ESSn and w.Hours >= 10 and w.Pno = p.Pnumber and p.Pname = 'AL Rabwah'
-------------------------------

SELECT concat(e.Fname, ' ', e.Lname) FullName
FROM Employee e, Employee s
WHERE e.Superssn = s.SSN and s.Fname = 'Kamel' and s.Lname = 'Mohamed'
-------------------------------

SELECT concat(e.Fname, ' ', e.Lname) FullName, p.Pname
FROM Employee e, Works_for w, Project p
WHERE w.ESSn = e.SSN and w.Pno = p.Pnumber
ORDER BY p.Pname
-------------------------------

SELECT p.Pnumber, d.Dname, e.Lname, e.Address, e.Bdate
FROM Employee e inner join Departments d on d.MGRSSN = e.SSN
	inner join Project p on  p.Dnum = d.Dnum
WHERE p.City = 'Cairo'
-------------------------------

SELECT e.*
FROM Employee e inner join Departments d on e.SSN = d.MGRSSN
-------------------------------

SELECT *
FROM Employee e left outer join Dependent d
ON d.ESSN = e.SSN
-------------------------------

--INSERT INTO Employee values('Hazem', 'Shaker', 102672, '2/5/2002', 'Mansoura', 'M', 3000, 112233, 30)
-------------------------------

--INSERT INTO Employee(Fname,Lname, SSN, Bdate, Address, Sex, Dno) values ('Mohamed', 'Nagy', 102660, '11/11/2001', 'Mansoura', 'M', 30)
-------------------------------

--UPDATE Employee
	--set Salary *= 1.2
--WHERE SSN = 102672