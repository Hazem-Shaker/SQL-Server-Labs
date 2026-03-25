--1
create view vstud_pass
as
	select 
		concat(st_fname,' ',st_lname) as sname,
		crs_name
	from student s inner join stud_course sc
	on s.st_id=sc.st_id
	inner join course c
	on sc.crs_id=c.crs_id
	where grade>50

select * from vstud_pass

sp_helptext 'vstud_pass'



--2

alter view vman_topics
with encryption
as
	select distinct i.ins_name,t.top_name
	from instructor i inner join department d
	on i.ins_id=d.dept_manager
	inner join ins_course ic
	on i.ins_id=ic.ins_id
	inner join course c
	on ic.crs_id=c.crs_id
	inner join topic t
	on c.top_id=t.top_id


select * from vman_topics

sp_helptext 'vman_topics'


--3

create view vins_sd_java
as
	select ins_name,dept_name
	from instructor i inner join department d
	on i.dept_id=d.dept_id
	where dept_name in ('sd','java')


select * from vins_sd_java

--4

create view v1
as
	select *
	from student
	where st_address in ('alex','cairo')
with check option

update v1                   --error
set st_address='mansoura'
where st_address='alex'

select * from v1


--5

create view vproj_count
as
	select p.ProjectName, count(e.empno) as empcount
	from sd.hr.employee e inner join sd.dbo.Works_on w
	on e.empno = w.EmpNo inner join sd.Company.Project p
	on w.ProjectNo = p.ProjectNo
	group by p.ProjectName

select * from vproj_count

--6

create clustered index i_hire      --error as there is a pk that got the only one clustered index for the table
on department(Manager_hiredate)


--7

create unique index i_age  --error as the table has duplicate ages and the constraint works on old and new data
on student(st_age)


--8

create table lastt(xid int,xname varchar(20),xval int)
create table Dailyt(yid int,yname varchar(20),yval int)

insert into lastt values
(1,'ahmed',100),
(2,'eman',200),
(3,'omar',300)

insert into dailyt values
(2,'eman',250),
(3,'omar',350),
(4,'nada',400)

select * from lastt
select * from dailyt

Merge into lastt as T
using dailyt as S
on T.xid = S.yid

when Matched then
	update 
		set T.xval = S.yval
when not matched then
	insert
    values(S.yid,S.yname,S.yval)                 
	
output $action;


select * from lastt
select * from dailyt


-- part 2

--1

create view v_clerk 
as
	select w.empno, w.projectno, w.enter_date
	from sd.dbo.works_on w
	where w.job = 'clerk'

select * from v_clerk 


--2


create view v_without_budget 
as
	select *
	from sd.company.project p
	where p.Budget is null


select * from v_without_budget 


--3


create view v_count
as
	select p.ProjectName, count(w.job) numberofjobs
	from sd.company.project p left join sd.dbo.Works_on w
	on w.ProjectNo = p.ProjectNo
	group by p.ProjectName

select * from v_count


--4


create view v_project_p2
as
	select empno
	from v_clerk 
	where projectno = 'p2'

select * from v_project_p2


--5

alter view v_without_budget 
as
	select *
	from sd.company.project p
	where p.ProjectNo in('p1','p2')

select * from v_without_budget 


--6


drop view v_clerk
drop view v_count


--7

--7) Create view that will display the emp# and emp lastname who works on dept# is ‘d2’ 

create view c_lname_d2
as
	select e.empno, e.emplname
	from SD.HR.employee e
	where e.deptno = 'd2'

select * from c_lname_d2


--8


select emplname
from c_lname_d2
where emplname like '%j%'


--9


create view v_dept
as
	select d.deptname, d.deptno
	from SD.Company.department d

select * from v_dept


--10


insert into v_dept (deptno, deptname)  --insertion in the main table
values ('d4', 'development')


--11


create view v_2006_check 
as
	select w.empno, w.projectno, w.enter_date
	from sd.dbo.works_on w
	where w.enter_date between '2006-01-01' and '2006-12-31'

select * from v_2006_check 

