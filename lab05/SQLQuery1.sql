--1----------------------------------------
select *
from Student s
where s.St_Age is not null

--2----------------------------------------
select distinct i.Ins_Name
from Instructor i

--3----------------------------------------
select s.St_Id, isnull(s.St_Fname,'') + ' ' + isnull(s.St_Lname,'') fullName, isnull(d.Dept_Name,'')
from Student s, Department d
where s.Dept_Id = d.Dept_Id 

--4----------------------------------------
select i.Ins_Name, d.Dept_Name
from Instructor i left join Department d
on i.Dept_Id = d.Dept_Id

--5----------------------------------------
select isnull(s.St_Fname,'') + ' ' + isnull(s.St_Lname,'') fullName, c.Crs_Name
from Student s inner join Stud_Course sc
on sc.St_Id = s.St_Id inner join Course c
on sc.Crs_Id = c.Crs_Id
where sc.Grade is not null

--6----------------------------------------
select t.Top_Name, count(c.Crs_Id) as numOfCour
from Topic t inner join Course c
on c.Top_Id = t.Top_Id
group by t.Top_Name

--7----------------------------------------
select max(i.Salary) as maxSal, min(i.Salary) as minSal
from Instructor i

--8----------------------------------------
select *
from Instructor i
where i.Salary < ( select avg(Salary) from Instructor)

--9----------------------------------------
select d.Dept_Name
from Department d inner join Instructor i
on i.Dept_Id = d.Dept_Id
where i.Salary = (select min(Salary) from Instructor)

--10----------------------------------------
select top 2 i.Salary
from Instructor i
where i.Salary is not null
order by salary desc

--11----------------------------------------
select i.Ins_Name, coalesce(cast(i.Salary as varchar(50)), 'instructor bonus') as bonusSalary
from Instructor i

--12----------------------------------------
select avg(i.Salary) avgSal
from Instructor i

--13----------------------------------------
select isnull(s.St_Fname,'') + ' ' + isnull(s.St_Lname,'') fullName, sp.*
from Student s left join Student sp
on s.St_super = sp.St_Id

--14----------------------------------------
select *
from (select i.Ins_Name, d.Dept_Id ,i.Salary, ROW_NUMBER()over(partition by d.Dept_Id order by i.Salary desc) as RN
	from Instructor i inner join Department d
	on i.Dept_Id = d.Dept_Id
) as newTable

where RN <= 2

--15----------------------------------------
select *
from (
    select 
        s.*,
        d.Dept_Name,
        row_number() OVER (Partition by s.Dept_Id order by newid()) as RandomRank
    from Student s
    inner join Department d ON s.Dept_Id = d.Dept_Id
) sub
where RandomRank = 1