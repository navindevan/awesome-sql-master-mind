USE MyWork
GO

CREATE TABLE dbo.AccountTransactions (
    AccountID INT,
    TransactionDate DATE,
    Amount DECIMAL(10, 2));

INSERT INTO dbo.AccountTransactions (AccountID, TransactionDate, Amount)
VALUES 
    (1, '2023-01-01', 100.00),
    (1, '2023-01-02', 150.00),
    (1, '2023-01-03', 200.00),
    (1, '2023-01-04', NULL),
    (1, '2023-01-05', 300.00),
    (2, '2023-01-01', 500.00),
    (2, '2023-01-02', 700.00),
    (2, '2023-01-03', NULL),
    (2, '2023-01-04', 800.00),
    (2, '2023-01-05', 900.00);



--Using OVER with ORDER BY for Aggregate Functions - Running Total of Transactions by Account

--The SUM function is paired with OVER (PARTITION BY AccountID ORDER BY TransactionDate). 
--For each row, it calculates a running total of the Amount column by partitioning the data by AccountID and ordering it by TransactionDate.
SELECT
    AccountID,
    TransactionDate,
    Amount,
    SUM(Amount) OVER (PARTITION BY AccountID ORDER BY TransactionDate) AS RunningTotal
FROM dbo.AccountTransactions
ORDER BY AccountID, TransactionDate;
--------------------------------------------------------------------------------------------------------------------------------------------------

--Sliding Aggregations with a Limit on Rows per Window -Three-Row Sliding Sum

--The ROWS 2 PRECEDING clause limits the window to the current row and the previous two rows. 
--This is a rolling three-row sum, which helps in understanding recent trends in transaction amounts.

SELECT
    AccountID,
    TransactionDate,
    Amount,
    SUM(Amount) OVER (PARTITION BY AccountID ORDER BY TransactionDate ROWS 2 PRECEDING) AS SlidingSum
FROM dbo.AccountTransactions
ORDER BY AccountID, TransactionDate;
--------------------------------------------------------------------------------------------------------------------------------------------------

--Using the WINDOW Clause to Eliminate Code Duplication -  Defining and Using a Window

--The WINDOW clause defines a reusable window called w, which can then be applied to different aggregates, reducing code repetition and making modifications easier.

SELECT
    AccountID,
    TransactionDate,
    Amount,
    SUM(Amount) OVER w AS RunningTotal,
    AVG(Amount) OVER w AS RollingAverage
FROM dbo.AccountTransactions
WINDOW w AS (PARTITION BY AccountID ORDER BY TransactionDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
ORDER BY AccountID, TransactionDate;
--------------------------------------------------------------------------------------------------------------------------------------------------

--Using IGNORE NULLS in FIRST_VALUE and LAST_VALUE Functions - Getting the Last Non-NULL Value per Account

--Without IGNORE NULLS, the LAST_VALUE function would return a NULL value if the last row in the partition contained NULL.
--With IGNORE NULLS, SQL Server skips over the NULL values and returns the most recent non-null value instead.

SELECT
    AccountID,
    TransactionDate,
    Amount,
    LAST_VALUE(Amount) IGNORE NULLS OVER (PARTITION BY AccountID ORDER BY TransactionDate) AS LastNonNullAmount
FROM dbo.AccountTransactions
ORDER BY AccountID, TransactionDate;

--------------------------------------------------------------------------------------------------------------------------------------------------
--Handling NULLs with the IGNORE NULLS Option for Aggregations - Average Transaction Amount Ignoring NULLs

--With IGNORE NULLS, the calculation ignores rows where Amount is NULL, providing a more accurate average.

SELECT
    AccountID,
    TransactionDate,
    Amount,
    SUM(Amount) OVER (PARTITION BY AccountID ORDER BY TransactionDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) /
    NULLIF(COUNT(Amount) OVER (PARTITION BY AccountID ORDER BY TransactionDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0)
    AS AverageAmount
FROM dbo.AccountTransactions
ORDER BY AccountID, TransactionDate;