--1
create proc getstcountbydept
as
	select d.dept_name , count(s.st_id) as st_count
	from department d inner join student s
	on d.dept_id = s.dept_id
	group by d.dept_name

getstcountbydept

--2
alter proc empinprojectp1
as
	declare @cnt int

	select @cnt = count(*)
	from company_sd.dbo.Works_for
	where pno = '1'

	if @cnt >= 3
		select 'the number of employees in the project p1 is 3 or more'
	else
		begin
			select 'the following employees work for the project p1'
			select e.fname , e.lname
			from company_sd.dbo.employee e inner join company_sd.dbo.Works_for w
			on e.ssn = w.essn
			where w.pno = '1'
		end

empinprojectp1


--3

alter proc replaceemp @oldid int, @newid int, @pno int
as
	begin try
		update Company_SD.dbo.Works_for
		set essn = @newid
		where essn = @oldid and pno = @pno
		
		select 'update successful'
	end try
	begin catch
		select 'an error occurred during the update'
		select error_number(), error_message()
	end catch


replaceemp 102672, 102660, 100

--4

alter table company_sd.dbo.project
add budget int

update company_sd.dbo.project set budget = 95000 where Pnumber = '100'
update company_sd.dbo.project set budget = 120000 where Pnumber = '200'

create table company_sd.dbo.audit_table
(
	projectno int,
	username varchar(20),
	modifieddate date,
	budget_old int,
	budget_new int
)

create trigger tr_auditbudget
on company_sd.dbo.project
after update
as
	if update(budget)
		begin
			insert into audit_table
			select 
				i.pnumber,
				suser_name(),
				getdate(),
				d.budget,
				i.budget
			from inserted i inner join deleted d
			on i.Pnumber = d.Pnumber
		end

update company_sd.dbo.project
set budget = 200000
where Pnumber = '200'

select * from audit_table

--5

alter trigger tr_no_dept_insert
on department
instead of insert
as
	select 'you can’t insert a new record in department table'

insert into department values (100,'sdd','system development','cairo',2,'2002-02-05')

--6

alter trigger tr_preventmarchinsert
on employee
instead of insert
as
	if month(getdate()) = 3
		select 'you cannot insert employees in march'
	else
		begin
			insert into employee
			select * from inserted
		end


insert into employee values ('ahmed','ahmed',102667,'3/3/2002','mansoura','m',null,102672,30) --faails if curr month is 3


--7

create table student_audit
(
	username varchar(20),
	_date date,
	note varchar(200)
)

create trigger tr_student_insert_audit
on student
after insert
as
	insert into student_audit
	select 
		suser_name(),
		getdate(),
		suser_name() + ' insert new row with key=' + cast(st_id as varchar) + ' in table student'
	from inserted

insert into Student values(800,'Hazem', 'Shaker', 'Mansoura', 23, 10, 1)
select * from student_audit

--8

create trigger tr_student_delete_audit
on student
instead of delete
as
	insert into student_audit
	select 
		suser_name(),
		getdate(),
		'try to delete row with key=' + cast(st_id as varchar)
	from deleted

delete from student where st_id = 5
select * from student_audit
