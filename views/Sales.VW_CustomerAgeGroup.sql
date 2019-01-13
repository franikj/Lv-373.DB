USE DreamBox
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