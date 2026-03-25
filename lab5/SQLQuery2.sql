--1----------------------------------------
select s.SalesOrderID, s.ShipDate
from Sales.SalesOrderHeader s
where s.OrderDate between '7/28/2002' and '7/29/2014' 

--2----------------------------------------
select *
from Production.Product p
where p.StandardCost < 110.00

--3----------------------------------------
select p.Name
from Production.Product p
where p.Weight is null

--4----------------------------------------
select *
from Production.Product p
where p.Color in ('Silver', 'Black', 'Red')

--5----------------------------------------
select *
from Production.Product p
where p.Name like 'B%'

--6----------------------------------------
--UPDATE Production.ProductDescription 
--SET Description = 'Chromoly steel_High of defects' 
--WHERE ProductDescriptionID = 3 

select *
from Production.ProductDescription p
where p.Description like '%[_]%'

--7----------------------------------------
select sum(TotalDue) as sum, OrderDate
from Sales.SalesOrderHeader 
where OrderDate between '7/1/2001' and '7/31/2014' 
group by OrderDate
order by OrderDate

--8----------------------------------------
select distinct e.HireDate
from HumanResources.Employee e

--9----------------------------------------
select avg(ListPrice)
from (
	select distinct ListPrice
	from Production.Product
) as x

--10----------------------------------------
select 'The ' + p.Name + ' is only! ' + cast(p.ListPrice as varchar(50))
from Production.Product p
where ListPrice between 100 and 120

--11--------------------------------------
--DROP TABLE IF EXISTS store_Archive
select rowguid, Name, SalesPersonID, Demographics
into store_Archive
from Sales.Store

select count(*) as count
from store_Archive

select *
from store_Archive
--
DROP TABLE IF EXISTS store_Archive
select rowguid, Name, SalesPersonID, Demographics
into store_Archive
from Sales.Store
where 1=0

select count(*) as count
from store_Archive

select *
from store_Archive

--12--------------------------------------
SELECT CONVERT(VARCHAR(10), GETDATE(), 101) AS DateStyle
UNION
SELECT CONVERT(VARCHAR(10), GETDATE(), 103)
UNION
SELECT CONVERT(VARCHAR(10), GETDATE(), 120)