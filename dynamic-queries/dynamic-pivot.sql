DROP TABLE IF EXISTS #Tmp_Dynamci_Pivot
CREATE TABLE #Tmp_Dynamci_Pivot ([Id] int, [ColumnName] NVARCHAR(20), [Value] NVARCHAR(20))
   
INSERT INTO #Tmp_Dynamci_Pivot ([Id], [ColumnName], [Value])
SELECT 1,'Id','1001'
UNION
SELECT 2,'Name','Dynamic Pivot'
UNION 
SELECT 3,'Type','Blog'
UNION
SELECT 4,'Status','Active'
UNION 
SELECT 5,'CreatedMonth','July'

DECLARE @PivotColumns NVARCHAR(100)
DECLARE @PivotQuery   NVARCHAR(500)

SELECT  @PivotColumns = STRING_AGG(QUOTENAME([ColumnName]),', ') 
FROM( SELECT 1 AS Id, [ColumnName] FROM #Tmp_Dynamci_Pivot ) P
GROUP BY ID

SET @PivotQuery = N'SELECT ' + @PivotColumns + 
				  N' from ( SELECT [ColumnName],[Value] FROM  #Tmp_Dynamci_Pivot ) A
				  PIVOT 
				  (
				    MAX([value])
				    FOR [ColumnName] IN (' + @PivotColumns + N')
				  ) AA '

EXEC sp_executesql @PivotQuery

