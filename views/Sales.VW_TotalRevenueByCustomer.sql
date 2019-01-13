USE DreamBox
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