USE DreamBox
----------------------------------------------------------------
--------View for age of Customer--------------------------------

--DROP VIEW Sales.VW_CustomerAge

CREATE VIEW Sales.VW_CustomerAge
AS
select FirstName + ' ' + LastName AS 'Name' , (YEAR(GETDATE()) * 10000 + MONTH(GETDATE()) * 100 + DAY(GETDATE())
- YEAR(BirthDate) * 10000 - MONTH(BirthDate) * 100 - DAY(BirthDate)
) / 10000 AS Age
FROM Sales.Customers 

-- select * from Sales.VW_CustomerAge
-----------------------------------------------------------------