--1
use company_sd

declare c1 cursor
for select salary from employee
for update

declare @sal int
open c1
fetch c1 into @sal
while @@fetch_status=0
	begin
		if @sal < 3000
			update employee
				set salary = salary * 1.10
			where current of c1
		else
			update employee
				set salary = salary * 1.20
			where current of c1

		fetch c1 into @sal
	end
close c1
deallocate c1

--2
use iti

declare c2 cursor
for
	select d.dept_name, i.ins_name
	from department d
	left join instructor i
		on d.dept_manager = i.ins_id
for read only

declare @dname varchar(30),@mname varchar(30)
open c2
fetch c2 into @dname,@mname
while @@fetch_status=0
	begin
		select @dname,@mname
		fetch c2 into @dname,@mname
	end
close c2
deallocate c2

--3
use iti

declare c3 cursor
for select distinct st_fname from student where st_fname is not null
for read only

declare @name varchar(20),@all_names varchar(300)=''
open c3
fetch c3 into @name
while @@fetch_status=0
	begin
		set @all_names = concat(@all_names,',',@name)
		fetch c3 into @name
	end
select @all_names
close c3
deallocate c3

--4
create sequence seq_test
start with 1
increment by 1
minvalue 1
maxvalue 10
no cycle

create table sqe_table(id int, name varchar(100))

insert into sqe_table values (next value for seq_test, 'ahmed')
insert into sqe_table values (next value for seq_test, 'ahmed2')
insert into sqe_table values (next value for seq_test, 'ahmed3')
insert into sqe_table values (next value for seq_test, 'ahmed4')
insert into sqe_table values (next value for seq_test, 'ahmed5')
insert into sqe_table values (next value for seq_test, 'ahmed6')
insert into sqe_table values (next value for seq_test, 'ahmed7')
insert into sqe_table values (next value for seq_test, 'ahmed8')
insert into sqe_table values (next value for seq_test, 'ahmed9')
insert into sqe_table values (next value for seq_test, 'ahmed10')
insert into sqe_table values (next value for seq_test, 'ahmed11') --error says 'seq_test' has reached its minimum or maximum value
insert into sqe_table values (next value for seq_test, 'ahmed12') --same error for the rest of insertions
insert into sqe_table values (next value for seq_test, 'ahmed13')
insert into sqe_table values (next value for seq_test, 'ahmed14')
insert into sqe_table values (next value for seq_test, 'ahmed15')

select * from sqe_table

--5
create database mysnap
on
(
	name='AdventureWorks2012_Data',
	filename='c:\Backup\AdventureWorks2012_snap.ss'
)
as snapshot of AdventureWorks2012

select name, source_database_id  --returned mysnap and 6
from sys.databases
where name = 'mysnap'

use mysnap
select * from HumanResources.Department

use mysnap
insert into dbo.ErrorLog values ('test') --error

use AdventureWorks2012
insert into HumanResources.Department values('Test', 'Testing', 2/5/2002)

select count(*) from AdventureWorks2012.HumanResources.Department --17
select count(*) from mysnap.HumanResources.Department  --16


--6
--6.1
drop procedure if exists getmonthname

create procedure getmonthname
    @d date
as
begin
    select format(@d, 'MMMM') as month_name
end

exec getmonthname '2023-10-01'

--6.2
create procedure getrange
    @x int,
    @y int
as
begin
    declare @t table(num int)
    
    while @x <= @y
    begin
        insert into @t values(@x)
        set @x += 1
    end
    
    select * from @t
end

exec getrange 3, 10

--6.3
drop procedure if exists getstuddeptt

create procedure getstuddeptt
    @sid int
as
begin
    select 
        concat(st_fname, ' ', st_lname) as fullname,
        dept_name
    from student s inner join department d
    on s.dept_id = d.dept_id
    where s.st_id = @sid
end

exec getstuddeptt 4

--6.4
create procedure checkstudentnamee
    @sid int
as
begin
    declare @fn varchar(50), @ln varchar(50), @msg varchar(50)

    select @fn = st_fname, @ln = st_lname
    from student
    where st_id = @sid

    if @fn is null and @ln is null
        set @msg = 'first name & last name are null'
    else if @fn is null
        set @msg = 'first name is null'
    else if @ln is null
        set @msg = 'last name is null'
    else
        set @msg = 'first name & last name are not null'

    select @msg as status_message
end

exec checkstudentnamee 3

--6.5
create procedure getmanagerinfoo
    @mid int
as
begin
    select 
        dept_name,
        ins_name,
        manager_hiredate
    from department d inner join instructor i
    on d.dept_manager = i.ins_id
    where d.dept_manager = @mid
end

exec getmanagerinfoo 1

--6.6
create procedure getstudnamess
    @format varchar(20)
as
begin
    if @format = 'first name'
        select st_id, isnull(st_fname, '') as name
        from student

    else if @format = 'last name'
        select st_id, isnull(st_lname, '') as name
        from student

    else if @format = 'full name'
        select st_id, 
        isnull(st_fname, '') + ' ' + isnull(st_lname, '') as name
        from student
end

exec getstudnamess 'full name'

--6.7
create procedure getcleanednamess
as
begin
    select st_id,
    substring(st_fname, 1, len(st_fname) - 1) as clean_name
    from student
end

exec getcleanednamess

--6.8
create procedure deletesdstudentss
as
begin
    delete from stud_course
    where st_id in
    (
        select s.st_id
        from student s inner join department d
        on s.dept_id = d.dept_id
        where d.dept_name = 'sd'
    )
end

exec deletesdstudentss

--7

backup database SD
to disk='c:\Backup\SD_Full_Backup.bak'

backup database SD
to disk='c:\Backup\SD_Diff_Backup.bak'
with differential

--8

create view studentdata
as
select 
    st_id as 'student id',
    concat(st_fname, ' ', st_lname) as 'full name',
    st_address as 'address',
    st_age as 'age',
    dept_id as 'department id'
from student

select * from studentdata