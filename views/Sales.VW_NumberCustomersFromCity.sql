USE DreamBox
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