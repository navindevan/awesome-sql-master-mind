USE AdventureWorks2022
GO

--Syntax: DATETRUNC ( datepart, expression )
--datepart: The part of the date to truncate. This can be year, quarter, month, day, hour, minute, second, etc.
--expression: The datetime, smalldatetime, date, or datetime2 expression to truncate.

DECLARE @date datetime2 = '2024-10-08 13:45:30.123'

-- Truncate to year
SELECT DATETRUNC(year, @date) AS TruncatedToYear

-- Truncate to month
SELECT DATETRUNC(month, @date) AS TruncatedToMonth

-- Truncate to day
SELECT DATETRUNC(day, @date) AS TruncatedToDay

-- Truncate to hour
SELECT DATETRUNC(hour, @date) AS TruncatedToHour

-- Truncate to minute
SELECT DATETRUNC(minute, @date) AS TruncatedToMinute

-- Truncate to second
SELECT DATETRUNC(second, @date) AS TruncatedToSecond


--Truncating to Day
-------------------
DECLARE @date datetime2 = '2024-10-08 13:45:30.123';

-- Traditional method
SELECT CAST(CONVERT(date, @date) AS datetime) AS TruncatedToDay;

-- Using DATETRUNC
SELECT DATETRUNC(day, @date) AS TruncatedToDay;


--Truncating to Month and Year
------------------------------
DECLARE @date datetime2 = '2024-10-08 13:45:30.123';

-- Truncating to Month
-- Traditional method
SELECT DATEADD(month, DATEDIFF(month, 0, @date), 0) AS TruncatedToMonth;

-- Using DATETRUNC
SELECT DATETRUNC(month, @date) AS TruncatedToMonth;

-- Truncating to Year
-- Traditional method
SELECT DATEADD(year, DATEDIFF(year, 0, @date), 0) AS TruncatedToYear;

-- Using DATETRUNC
SELECT DATETRUNC(year, @date) AS TruncatedToYear;