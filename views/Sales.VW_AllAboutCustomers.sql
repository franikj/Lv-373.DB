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