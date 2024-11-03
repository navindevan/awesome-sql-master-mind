USE AdventureWorks2022
GO


--Syntax 
/*
LEAST: Returns the smallest value from a list of expressions.

LEAST (
    expression1,
    expression2,
    ...,
    expressionN
)

GREATEST: Returns the largest value from a list of expressions.

GREATEST (
    expression1,
    expression2,
    ...,
    expressionN
)
*/

--Tradtitional Methods
SELECT
    CASE
        WHEN Column1 <= Column2 AND Column1 <= Column3 THEN Column1
        WHEN Column2 <= Column1 AND Column2 <= Column3 THEN Column2
        ELSE Column3
    END AS SmallestValue,

    CASE
        WHEN Column1 >= Column2 AND Column1 >= Column3 THEN Column1
        WHEN Column2 >= Column1 AND Column2 >= Column3 THEN Column2
        ELSE Column3
    END AS LargestValue
FROM MyTable;

--Using LEAST and GREATEST
SELECT
    LEAST(Column1, Column2, Column3) AS SmallestValue,
    GREATEST(Column1, Column2, Column3) AS LargestValue
FROM
    MyTable;

-- Using LEAST to Compare Different Tax Rates
SELECT
    SalesOrderID,
    LEAST(TaxAmt, Freight, SubTotal) AS SmallestAmount
FROM Sales.SalesOrderHeader WITH (NOLOCK)
WHERE SalesOrderID IN (43659, 43660, 43661);


--Use GREATEST to Find the Maximum Bonus, Sick Leave, and Vacation Hours

SELECT
    BusinessEntityID,
    GREATEST(VacationHours, SickLeaveHours, 10) AS MaxBenefit
FROM
    HumanResources.Employee
WHERE
    BusinessEntityID BETWEEN 1 AND 10;