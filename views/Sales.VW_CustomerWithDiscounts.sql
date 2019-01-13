USE DreamBox
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