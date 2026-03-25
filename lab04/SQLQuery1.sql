--1---------------------------------------------
select d.Dependent_name, d.Sex
from Dependent d inner join Employee e
on d.ESSN = e.SSN
where e.Sex = 'F' and d.Sex = 'F'
union
select d.Dependent_name, d.Sex
from Dependent d inner join Employee e
on d.ESSN = e.SSN
where e.Sex = 'M' and d.Sex = 'M'

--2---------------------------------------------
select p.Pname, sum(w.Hours) totalHouts
from Project p inner join Works_for w
on p.Pnumber = w.Pno
group by p.Pname

--3---------------------------------------------
select d.*
from Departments d
where d.Dnum = (select DNO
				from Employee
				where SSN = (select min(SSN)
							from Employee
							)
				)

--4---------------------------------------------
select d.Dname, min(e.Salary) as minSal, max(e.Salary) as maxSal, avg(e.Salary) as avgSal
from Departments d inner join Employee e 
on d.Dnum = e.Dno
group by d.Dname

--5---------------------------------------------
select e.Fname + ' ' + e.Lname as fullName
From Employee e inner join Departments d
on e.SSN = d.MGRSSN
except 
select e.Fname + ' ' + e.Lname as fullName
From Employee e inner join Dependent dp
on dp.ESSN = e.SSN
--or
select e.Fname + ' ' + e.Lname as fullName
From Employee e inner join Departments d
on e.SSN = d.MGRSSN
where e.SSN not in( select ESSN from Dependent)

--6---------------------------------------------
select d.Dnum, d.Dname, count(e.SSN) as empCount
from Departments d inner join Employee e
on d.Dnum = e.Dno
group by d.Dname, d.Dnum
having avg(e.Salary) < (select avg(Salary) from Employee)


--7---------------------------------------------
select e.Lname + ' ' + e.Lname as fullName, p.Pname
from Employee e inner join Departments d
on e.Dno = d.Dnum inner join Project p
on p.Dnum = d.Dnum
order by d.Dnum, e.Lname, e.Fname

--8---------------------------------------------
select e.Fname + ' ' + e.Lname as fullName, e.Salary
from Employee e
where e.Salary in (
					(select max(salary) from Employee),
					(select max(salary) from Employee 
					where salary < (select max(salary) from Employee)
					)
				)

--9---------------------------------------------
select e.Fname + ' ' + e.Lname
from Employee e
intersect
select d.Dependent_name
from Dependent d
--or
select e.Fname + ' ' + e.Lname as fullName
from Employee e
where e.Fname + ' ' + e.Lname in (select Dependent_name from Dependent)

--10---------------------------------------------
select e.SSN, e.Fname + ' ' + e.Lname as fullName
from Employee e
where exists (
	select 1
	from Dependent d
	where e.SSN = d.ESSN
	)

--11---------------------------------------------
insert into Departments
values ('DEPT IT', 100, 112233, '2006-11-01')

--12---------------------------------------------
update Departments
set MGRSSN = 968574, [MGRStart Date] = GETDATE()
WHERE Dnum = 100

update Departments
set MGRSSN = 102672, [MGRStart Date] = GETDATE()
where Dnum = 20

update Employee
set Superssn = 102672
where SSN = 102660

--13---------------------------------------------
delete from Dependent where ESSN = 223344

delete from Works_for where ESSn = 223344

update Departments
set MGRSSN = NULL
where MGRSSN = 223344

update Employee
set Superssn = NULL
where Superssn = 223344

delete from Employee where SSN = 223344

--14---------------------------------------------
update Employee
set Salary = Salary * 1.3
where SSN in (
    select w.ESSn
    from Works_for w
    join Project p on w.Pno = p.Pnumber
    where p.Pname = 'Al Rabwah'
)