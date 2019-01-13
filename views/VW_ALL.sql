USE DreamBox
-------------------------------------------------------------
-------View for gender analisis of Customers-------------------

--drop view V_GenderOfCustomers

CREATE VIEW Sales.VW_GenderOfCustomers
AS
SELECT ISNULL(Gender, 'Total sum') AS Gender, COUNT(*) AS Number
FROM Sales.Customers
GROUP BY Gender WITH ROLLUP;

--SELECT * from Sales.VW_GenderOfCustomers
----------------------------------------------------------------
GO 


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
GO

----------------------------------------------------------------
--------View for age group of Customer----------------------------

--DROP VIEW Sales.VW_CustomerAgeGroup

CREATE VIEW Sales.VW_CustomerAgeGroup
AS
SELECT AgeGroup, COUNT(*) AS NumberOfCustomers
FROM (SELECT CASE
			WHEN Age < 20 THEN '< 20 years'
			WHEN Age BETWEEN 20 AND 25 THEN '20 - 25 years'
			WHEN Age BETWEEN 26 AND 35 THEN '26 - 35 years'
			WHEN Age BETWEEN 36 AND 50 THEN '36 - 50 years'
			WHEN Age BETWEEN 51 AND 60 THEN '51 - 60 years'
			WHEN Age > 60 THEN '> 60 years'
			END AS AgeGroup
		FROM Sales.VW_CustomerAge) AS a
GROUP BY AgeGroup
ORDER BY AgeGroup
OFFSET 0 ROW
 
--SELECT * FROM Sales.VW_CustomerAgeGroup
-----------------------------------------------------------------
GO

-----------------View for Customer Discount----------------------
CREATE VIEW Sales.VW_CustomerWithDiscounts
AS 
SELECT c.FirstName + ' ' + c.LastName AS 'Name', d.Amount
FROM Sales.Customers c
inner join Sales.Discounts d ON d.DiscountID = c.DiscountID
ORDER BY [Name]
OFFSET 0 ROW


--SELECT * FROM Sales.VW_CustomerWithDiscounts
-----------------------------------------------------------------
GO


-----------------View Number of Customers With Discounts----------------------
CREATE VIEW Sales.VW_NumberCustomerWithDiscounts
AS
SELECT COUNT([Name]) AS 'Number of Customers with discounts', 
					(CONCAT(Amount*100,'%')) AS 'Discount' from Sales.VW_CustomerWithDiscounts
		GROUP BY Amount


--SELECT * FROM Sales.VW_NumberCustomerWithDiscounts
-----------------------------------------------------------------
GO


-----------------View Number of Customers From City----------------------
CREATE VIEW Sales.VW_NumberCustomersFromCity
AS
SELECT c.CityID,  ci.Name, COUNT(*) AS People from Sales.Customers c
INNER JOIN Basics.Cities ci ON ci.CityID=c.CityID
GROUP BY c.CityID, ci.Name 
ORDER BY People DESC
offset 0 row

--SELECT * FROM Sales.VW_NumberCustomersFromCity
-----------------------------------------------------------------
GO


-----------------View Total Revenue By Customers and Number of Orders----------------------
CREATE VIEW Sales.VW_TotalRevenueByCustomer
AS
SELECT i.CustomerID, c.FirstName+''+ c.LastName AS 'Name', COUNT(InvoiceID) AS 'NumberOfOrders', 
SUM(TotalPrice) AS 'Sum' from Sales.Invoices i
INNER JOIN Sales.Customers c ON c.CustomerID= i.CustomerID
WHERE StatusID = 4
GROUP BY i.CustomerID, c.FirstName, c.LastName
ORDER BY [Sum]
OFFSET 0 ROW

--SELECT * FROM Sales.VW_TotalRevenueByCustomer

GO

USE DreamBox
-----------------View all about Customers----------------------
CREATE VIEW Sales.VW_AllAboutCustomers
AS
SELECT c.CustomerID, c.FirstName, c.LastName, c.BirthDate AS 'Date of birth',
		 c.Email, c.Phone, c.BirthDate, c.Gender, 
		 d.DiscountID ,  
		 Discount = CASE 
			WHEN d.Name IS NULL OR d.Amount IS NULL THEN '-' ELSE concat(d.Name,' ',d.Amount*100,' %') END,
		 City = CASE
			WHEN ci.Name IS NULL THEN '-' ELSE ci.Name END
		  FROM Sales.Customers c
LEFT JOIN Sales.Discounts d ON d.DiscountID = c.DiscountID
LEFT JOIN Basics.Cities ci ON ci.CityID = c.CityID
--SELECT * FROM Sales.VW_AllAboutCustomers

---------------------------------------------------------------



--update Sales.Customers
--set CityID = '0'+CityID
--where CityID like '____'


