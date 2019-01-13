USE DreamBox
-------------------------------------------------------------
-------View for gender analisis of Customers-------------------

--DROP VIEW Sales.VW_GenderOfCustomers

CREATE VIEW Sales.VW_GenderOfCustomers
AS
SELECT ISNULL(Gender, 'Total sum') AS Gender, COUNT(*) AS Number
FROM Sales.Customers
GROUP BY Gender WITH ROLLUP;

--SELECT * from Sales.VW_GenderOfCustomers
----------------------------------------------------------------