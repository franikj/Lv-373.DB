USE DreamBox
-----------------View Number of Customers With Discounts----------------------
CREATE VIEW Sales.VW_NumberCustomerWithDiscounts
AS
SELECT COUNT([Name]) AS 'Number of Customers with discounts', 
					(CONCAT(Amount*100,'%')) AS 'Discount' from Sales.VW_CustomerWithDiscounts
		GROUP BY Amount


--SELECT * FROM Sales.VW_NumberCustomerWithDiscounts
-----------------------------------------------------------------