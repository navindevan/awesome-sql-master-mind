USE [AdventureWorks2022]
GO

CREATE TABLE [dbo].[Employees](
	[EmployeeID] [int] NULL,
	[Salary] [decimal](10, 2) NULL,
	[Bonus] [decimal](10, 2) NULL
) ON [PRIMARY]
GO

INSERT [dbo].[Employees] ([EmployeeID], [Salary], [Bonus]) VALUES (1, CAST(50000.00 AS Decimal(10, 2)), CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[Employees] ([EmployeeID], [Salary], [Bonus]) VALUES (2, CAST(60000.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[Employees] ([EmployeeID], [Salary], [Bonus]) VALUES (3, NULL, NULL)
INSERT [dbo].[Employees] ([EmployeeID], [Salary], [Bonus]) VALUES (4, CAST(55000.00 AS Decimal(10, 2)), CAST(5500.00 AS Decimal(10, 2)))
INSERT [dbo].[Employees] ([EmployeeID], [Salary], [Bonus]) VALUES (5, NULL, CAST(3000.00 AS Decimal(10, 2)))
GO

--Syntax: value1 IS DISTINCT FROM value2
--TRUE if the two values are different, including cases where one value is NULL and the other is not.
--FALSE if the two values are the same, including cases where both values are NULL.

--Syntax: value1 IS NOT DISTINCT FROM value2
--TRUE if the two values are the same, including cases where both values are NULL.
--FALSE if the two values are different, including cases where one value is NULL and the other is not.

--Traditional Approach
SELECT
    EmployeeID,
    CASE
        WHEN Salary IS NULL AND Bonus IS NULL THEN 'Equal'
        WHEN Salary = Bonus THEN 'Equal'
        ELSE 'Distinct'
    END AS ComparisonResult
FROM dbo.Employees

--Using IS DISTINCT FROM
SELECT
    EmployeeID,
    CASE
        WHEN Salary IS DISTINCT FROM Bonus THEN 'Distinct'
        ELSE 'Equal'
    END AS ComparisonResult
FROM dbo.Employees

--Using IS NOT DISTINCT FROM
--Data Deduplication: For example, to identify duplicate rows in a table with nullable columns.
;WITH DuplicateRows AS (
    SELECT
        EmployeeID,
        ROW_NUMBER() OVER (PARTITION BY Salary, Bonus ORDER BY EmployeeID) AS RowNum
    FROM dbo.Employees
    WHERE Salary IS NOT DISTINCT FROM Bonus
)
DELETE FROM DuplicateRows WHERE RowNum > 1

--Conditional Updates and Inserts - For example, to update the Bonus column only if it is distinct from the Salary column.
UPDATE dbo.Employees
SET Bonus = Salary * 0.1
WHERE Salary IS DISTINCT FROM Bonus;

--Data Comparison and Synchronization
SELECT
    a.EmployeeID,
    a.Salary AS SalaryInTableA,
    b.Salary AS SalaryInTableB
FROM dbo.Employees a
JOIN dbo.Employees1 b
    ON a.EmployeeID = b.EmployeeID
WHERE a.Salary IS DISTINCT FROM b.Salary;