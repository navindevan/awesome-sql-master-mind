USE AdventureWorks2022
GO


--Syntax: GENERATE_SERIES(start_value, stop_value [, step_value])
-- start_value: The beginning value of the series (required).
-- stop_value: The ending value of the series (required).
-- step_value: The increment between each successive value (optional).
-- If not specified, the default is 1.

--Generating a Series of Numbers

SELECT value AS NumberSeries
FROM GENERATE_SERIES(1, 10);
-- In this example, the function generates a series of numbers from 1 to 10.

SELECT value AS EvenNumbers
FROM GENERATE_SERIES(2, 20, 2);
-- You can customize the step value to generate a sequence that increments by a specific value.
-- For instance, to generate a series of even numbers.

--Generating Test Data
SELECT value AS EmployeeID,
       'Employee' + CAST(value AS VARCHAR(10)) AS EmployeeName
FROM GENERATE_SERIES(1, 10);

--Generating Date Ranges for Sales Reporting
WITH DateSeries AS (
    SELECT CAST(DATEADD(DAY, value, '2014-01-01') AS DATE) AS SaleDate
    FROM GENERATE_SERIES(0, 9)  -- Generates dates from '2014-01-01' to '2014-01-10'
)
SELECT ds.SaleDate,
       COALESCE(SUM(d.UnitPrice * d.OrderQty), 0) AS SalesAmount
FROM DateSeries ds
LEFT JOIN Sales.SalesOrderHeader s
    ON CAST(s.OrderDate AS DATE) = ds.SaleDate
LEFT JOIN Sales.SalesOrderDetail d
    ON s.SalesOrderID = d.SalesOrderID
GROUP BY ds.SaleDate
ORDER BY ds.SaleDate;