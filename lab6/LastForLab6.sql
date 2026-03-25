use SD
--1
sp_addtype loc, 'nchar(2)'                                                                             
create rule r1 as @x in ('NY', 'DS', 'KW')
create default def1 as 'NY'
sp_bindrule r1, loc
sp_bindefault def1, loc
create table department (
    deptno varchar(50) primary key,
    deptname varchar(50),
    location loc
)
insert into department (deptno, deptname) values ('d1', 'Research')
insert into department (deptno, deptname, location) values ('d2', 'Accounting', 'DS')
insert into department (deptno, deptname, location) values ('d3', 'Marketing', 'KW')

--2
create rule r2 as @x < 6000

create table employee (
    empno int,                      
    empfname varchar(50) not null,
    emplname varchar(50) not null, 
    deptno varchar(50),       
    salary int,
    constraint c1 primary key (empno),
    constraint c2 foreign key (deptno) references department(deptno), 
    constraint c3 unique (salary),      
)
sp_bindrule r2, 'employee.salary'
insert into employee (empno, empfname, emplname, deptno, salary) values (25348, 'Mathew', 'Smith', 'd3', 2500)
insert into employee (empno, empfname, emplname, deptno, salary) values (10102, 'Ann', 'Jones', 'd3', 3000)
insert into employee (empno, empfname, emplname, deptno, salary) values (18316, 'John', 'Barrimore', 'd1', 2400)
insert into employee (empno, empfname, emplname, deptno, salary) values (29346, 'James', 'James', 'd2', 2800)
insert into employee (empno, empfname, emplname, deptno, salary) values (9031, 'Lisa', 'Bertoni', 'd2', 4000)
insert into employee (empno, empfname, emplname, deptno, salary) values (2581, 'Elisa', 'Hansel', 'd2', 3600)
insert into employee (empno, empfname, emplname, deptno, salary) values (28559, 'Sybl', 'Moser', 'd1', 2900)

--3&4 by wizard
insert into works_on (empno, projectno, job, enter_date) values (10102, 'p1', 'analyst', '2006-10-01')
insert into works_on (empno, projectno, job, enter_date) values (10102, 'p3', 'manager', '2012-01-01')
insert into works_on (empno, projectno, job, enter_date) values (25348, 'p2', 'clerk', '2007-02-15')
insert into works_on (empno, projectno, job, enter_date) values (18316, 'p2', null, '2007-06-01')
insert into works_on (empno, projectno, job, enter_date) values (29346, 'p2', null, '2006-12-15')
insert into works_on (empno, projectno, job, enter_date) values (2581, 'p3', 'analyst', '2007-10-15')
insert into works_on (empno, projectno, job, enter_date) values (9031, 'p1', 'manager', '2007-04-15')
insert into works_on (empno, projectno, job, enter_date) values (28559, 'p1', null, '2007-08-01')
insert into works_on (empno, projectno, job, enter_date) values (28559, 'p2', 'clerk', '2012-02-01')
insert into works_on (empno, projectno, job, enter_date) values (9031, 'p3', 'clerk', '2006-11-15')
insert into works_on (empno, projectno, job, enter_date) values (29346, 'p1', 'clerk', '2007-01-04')

--5
insert into works_on (empno, projectno, job, enter_date) 
values (11111, 'p1', 'analyst', '2022-05-01') --error

update works_on 
set empno = 11111 
where empno = 10102 --error

update employee 
set empno = 22222 
where empno = 10102 --error

delete from employee 
where empno = 10102 --error

--
create schema Company
alter schema Company transfer department
alter schema Company transfer project

create schema HR
alter schema HR transfer employee

--
exec sp_helpconstraint 'HR.employee'
--

create synonym emp for hr.employee

Select * from employee  --error
Select * from HR.employee --7 rows
Select * from emp --7 rows
Select * from HT.emp --error

--

update company.project
set budget = budget * 1.10
from company.project p
join dbo.works_on w
    on p.projectno = w.projectno
where w.empno = 10102

--
update company.department
set deptname = 'sales'
from company.department d
join hr.employee e
    on d.deptno = e.deptno
where e.empfname = 'james' and e.emplname = 'james'

--

update w
set w.enter_date = '2007-12-12'
from works_on w
join hr.employee e
    on w.empno = e.empno
join company.department d
    on e.deptno = d.deptno
where w.projectno = 'p1'
and d.deptname = 'sales'

--

delete w
from works_on w
join hr.employee e
    on w.empno = e.empno
join company.department d
    on e.deptno = d.deptno
where d.location = 'kw'


-- Forgot to do this
alter table hr.employee
add telephonenumber varchar(20);

alter table hr.employee
drop column telephonenumber;

alter table dbo.works_on
drop constraint FK_works_on_employee;

alter table dbo.works_on
add constraint FK_works_on_employee foreign key (empno) references hr.employee(empno);
