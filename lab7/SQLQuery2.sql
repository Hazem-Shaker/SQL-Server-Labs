--1
create function getmonthname(@d date)
returns varchar(20)
begin
	return format(@d,'MMMM')
end

select dbo.getmonthname(getdate())

--2
create function getrange(@x int,@y int)
returns @t table(num int)
as
begin
	while @x<=@y
	begin
		insert into @t values(@x)
		set @x+=1
	end
	return
end

select * from getrange(3,10)

--3
create function getstuddept(@sid int)
returns table
as
	return
	(
		select 
			concat(st_fname,' ',st_lname) as fullname,
			dept_name
		from student s inner join department d
		on s.dept_id=d.dept_id
		where s.st_id=@sid
	)

select * from getstuddept(4)

--4
create function checkstudentname(@sid int)
returns varchar(50)
begin
	declare @fn varchar(50),@ln varchar(50),@msg varchar(50)

	select @fn=st_fname,@ln=st_lname
	from student
	where st_id=@sid

	if @fn is null and @ln is null
		set @msg='first name & last name are null'
	else if @fn is null
		set @msg='first name is null'
	else if @ln is null
		set @msg='last name is null'
	else
		set @msg='first name & last name are not null'

	return @msg
end

select dbo.checkstudentname(3)

--5

create function getmanagerinfo(@mid int)
returns table
as
	return
	(
		select 
			dept_name,
			ins_name,
			manager_hiredate
		from department d inner join instructor i
		on d.dept_manager=i.ins_id
		where d.dept_manager=@mid
	)

select * from getmanagerinfo(1) --no data if non-manager id

--6

create function getstudnames(@format varchar(20))
returns @t table(id int,name varchar(50))
as
begin
	if @format='first name'
		insert into @t
		select st_id,isnull(st_fname,'')
		from student

	else if @format='last name'
		insert into @t
		select st_id,isnull(st_lname,'')
		from student

	else if @format='full name'
		insert into @t
		select st_id,
		isnull(st_fname,'')+' '+isnull(st_lname,'')
		from student

	return
end

select * from getstudnames('full name')

--7

select st_id,
substring(st_fname,1,len(st_fname)-1)
from student

--8

delete from stud_course
where st_id in
(
	select s.st_id
	from student s inner join department d
	on s.dept_id=d.dept_id
	where d.dept_name='sd'
)

-- Bonus 1

create table region
(
	region_id int,
	region_name varchar(30),
	region_node hierarchyid
)

insert into region
values
(1,'egypt','/')

insert into region
values
(2,'cairo','/1/'),
(3,'giza','/2/'),
(4,'alexandria','/3/')

insert into region
values
(5,'nasr city','/1/1/'),
(6,'heliopolis','/1/2/'),
(7,'dokki','/2/1/'),
(8,'smouha','/3/1/')

--direct children
declare @caironode hierarchyid
select @caironode = region_node from region where region_name='cairo'

select *
from region
where region_node.IsDescendantOf(@caironode) = 1 
and region_node.GetLevel() = @caironode.GetLevel() + 1

--names and levels
select region_name, region_node.GetLevel() as level
from region

--order by heiraricy
select region_name
from region
order by region_node


--Bonus 2
declare @x int=3000
while @x<=6000
begin
	insert into student(st_id,st_fname,st_lname)
	values(@x,'jane','smith')
	set @x+=1
end

select count(s.St_Id) from Student s


