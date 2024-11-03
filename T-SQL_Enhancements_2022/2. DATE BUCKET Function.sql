USE AdventureWorks2022
GO

--Syntax: DATE_BUCKET (datepart, number, date [, origin ] )
--datepart: The part of the date you want to group by, such as a day, week, month, etc. This can be
--number: The size of the time bucket, which must be an integer. year, month, week, day, hour, minute, second, millisecond, etc.
--date: The date to be truncated and grouped by the interval and datepart.


--Month Interval Example
--This example groups dates into 2-month intervals, starting from January 1, 2024.
DECLARE @DateOrigin date = '2024-01-01'
SELECT
    '1/2m' = DATE_BUCKET(MONTH, 2, CONVERT(date, '2024-01-01'), @DateOrigin),
    '1/2m' = DATE_BUCKET(MONTH, 2, CONVERT(date, '2024-02-01'), @DateOrigin),
    '2/2m' = DATE_BUCKET(MONTH, 2, CONVERT(date, '2024-03-01'), @DateOrigin),
    '2/2m' = DATE_BUCKET(MONTH, 2, CONVERT(date, '2024-04-01'), @DateOrigin),
    '1/2m' = DATE_BUCKET(MONTH, 2, CONVERT(date, '2024-05-01'), @DateOrigin),
    '1/2m' = DATE_BUCKET(MONTH, 2, CONVERT(date, '2024-06-01'), @DateOrigin),
    '2/2m' = DATE_BUCKET(MONTH, 2, CONVERT(date, '2024-07-01'), @DateOrigin),
    '2/2m' = DATE_BUCKET(MONTH, 2, CONVERT(date, '2024-08-01'), @DateOrigin)
GO

--Week Interval Example
--This example groups dates into 2-week intervals, starting from January 1, 2024.
DECLARE @DateOrigin date = '2024-01-01'
SELECT
    '1/2w' = DATE_BUCKET(WEEK, 2, CONVERT(date, '2024-01-01'), @DateOrigin),
    '1/2w' = DATE_BUCKET(WEEK, 2, CONVERT(date, '2024-01-08'), @DateOrigin),
    '2/2w' = DATE_BUCKET(WEEK, 2, CONVERT(date, '2024-01-15'), @DateOrigin),
    '2/2w' = DATE_BUCKET(WEEK, 2, CONVERT(date, '2024-01-22'), @DateOrigin),
    '1/2w' = DATE_BUCKET(WEEK, 2, CONVERT(date, '2024-01-29'), @DateOrigin),
    '1/2w' = DATE_BUCKET(WEEK, 2, CONVERT(date, '2024-02-05'), @DateOrigin),
    '2/2w' = DATE_BUCKET(WEEK, 2, CONVERT(date, '2024-02-12'), @DateOrigin),
    '2/2w' = DATE_BUCKET(WEEK, 2, CONVERT(date, '2024-02-19'), @DateOrigin)
GO

--Day Interval Example
--This example groups dates into 2-day intervals, starting from January 1, 2022.
DECLARE @DateOrigin date = '2024-01-01'
SELECT
    '1/2d' = DATE_BUCKET(DAY, 2, CONVERT(date, '2024-01-01'), @DateOrigin),
    '2/2d' = DATE_BUCKET(DAY, 2, CONVERT(date, '2024-01-02'), @DateOrigin),
    '1/2d' = DATE_BUCKET(DAY, 2, CONVERT(date, '2024-01-03'), @DateOrigin),
    '2/2d' = DATE_BUCKET(DAY, 2, CONVERT(date, '2024-01-04'), @DateOrigin),
    '1/2d' = DATE_BUCKET(DAY, 2, CONVERT(date, '2024-01-05'), @DateOrigin),
    '2/2d' = DATE_BUCKET(DAY, 2, CONVERT(date, '2024-01-06'), @DateOrigin),
    '1/2d' = DATE_BUCKET(DAY, 2, CONVERT(date, '2024-01-07'), @DateOrigin),
    '2/2d' = DATE_BUCKET(DAY, 2, CONVERT(date, '2024-01-08'), @DateOrigin)
GO

--Grouping Sales Data by Weekly Buckets
SELECT
    DATE_BUCKET(WEEK, 1, OrderDate) AS OrderWeek,
    COUNT(SalesOrderID) AS TotalOrders,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY DATE_BUCKET(WEEK, 1, OrderDate)
ORDER BY OrderWeek

--Monthly Sales Data Analysis
SELECT
    DATE_BUCKET(MONTH, 1, OrderDate) AS OrderMonth,
    COUNT(SalesOrderID) AS TotalOrders,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY DATE_BUCKET(MONTH, 1, OrderDate)
ORDER BY OrderMonth

--Grouping Data in Custom Intervals (e.g., 10-Day Buckets)
SELECT
    DATE_BUCKET(DAY, 10, OrderDate) AS OrderPeriod,
    COUNT(SalesOrderID) AS TotalOrders,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY DATE_BUCKET(DAY, 10, OrderDate)
ORDER BY OrderPeriod

--DATEADD and DATEDIFF
SELECT
    DATEADD(YEAR, DATEDIFF(YEAR, 0, OrderDate), 0) AS OrderYear,
    COUNT(SalesOrderID) AS TotalOrders,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY DATEADD(YEAR, DATEDIFF(YEAR, 0, OrderDate), 0)

--FLOOR or CEILING on Date Calculations
SELECT
    FLOOR(DATEDIFF(DAY, '1900-01-01', OrderDate) / 7) AS WeekNumber,
    COUNT(SalesOrderID) AS TotalOrders
FROM Sales.SalesOrderHeader
GROUP BY FLOOR(DATEDIFF(DAY, '1900-01-01', OrderDate) / 7)