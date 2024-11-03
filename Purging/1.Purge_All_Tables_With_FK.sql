USE AdventureWorks2022
GO

--Retrieve all tables with foreign keys, excluding those that are self-referencing
;WITH CTE_Get_Tables_With_FK
AS (
	SELECT
		FK.[parent_object_id] AS [parent_object_id]
		,SCM.[name] AS [Parent_SchemaName]
		,TBL.[name] AS [Parent_TableName]
		,FK.[referenced_object_id] AS [Ref_object_id]
		,RSCM.[name] AS	[Ref_SchemaName]
		,RTBL.[name] AS	[Ref_TableName]
	FROM sys.foreign_keys FK
	INNER JOIN sys.tables TBL ON TBL.[object_id] = FK.[parent_object_id]
	INNER JOIN sys.schemas SCM ON SCM.[schema_id] = TBL.[schema_id]
	INNER JOIN sys.tables RTBL ON RTBL.[object_id] = FK.[referenced_object_id]
	INNER JOIN sys.schemas RSCM ON RSCM.[schema_id] = RTBL.[schema_id]
	WHERE FK.[type] = 'F'
		AND FK.[parent_object_id] <> [referenced_object_id]
		AND TBL.type = 'U'
		AND RTBL.type = 'U'
)

/*
Recursive CTE: Identify the sequence of each referenced table. 
For example, if Table1 references Table2, and Table2 references Table3, then assign the sequence as follows: Table3 should be assigned a sequence of 1, Table2 a sequence of 2, and Table1 a sequence of 3.
*/
,CTE_Get_All_Ref_Table_In_Sequence
AS (
	SELECT FK1.[parent_object_id]
		,FK1.[Parent_SchemaName]
		,FK1.[Parent_TableName]
		,FK1.[Ref_object_id]
		,FK1.[Ref_SchemaName]
		,FK1.[Ref_TableName]
		,1 AS [Iteration_Sequence_No]
	FROM CTE_Get_Tables_With_FK FK1
	LEFT JOIN CTE_Get_Tables_With_FK FK2 ON FK1.[parent_object_id] = FK2.[Ref_object_id]
	WHERE FK2.[parent_object_id] IS NULL
	
	UNION ALL
	
	SELECT FK.[parent_object_id]
		,FK.[Parent_SchemaName]
		, FK.[Parent_TableName]
		, FK.[Ref_object_id]
		, FK.[Ref_SchemaName]
		, FK.[Ref_TableName]
		, CTE.[Iteration_Sequence_No] + 1 AS [Iteration_Sequence_No]
	FROM CTE_Get_Tables_With_FK FK
	INNER JOIN CTE_Get_All_Ref_Table_In_Sequence CTE ON FK.[parent_object_id] = CTE.[Ref_object_id]
	WHERE FK.[Ref_object_id] <> CTE.[parent_object_id]
)

--Retrieve the distinct parent tables along with their iteration sequence numbers
,CTE_Get_Unique_Parent_Table_With_Ref
AS (
	SELECT DISTINCT [Parent_SchemaName]
		,[Parent_TableName]
		,[parent_object_id]
		,[Iteration_Sequence_No]
	FROM CTE_Get_All_Ref_Table_In_Sequence
)

--Combine all tables, including those with foreign keys and those without foreign keys.
, CTE_Get_All_Tables
AS (
	SELECT SCM.[name] AS [SchemaName]
		,TBL.[name] AS	[TableName]
		,ISNULL(Prnt_Tbl_Ref.[Iteration_Sequence_No], (ISNULL(MITRN.[Max_Iteration_Sequence_No], 0) + 1)) AS [Iteration_Sequence_No]
		,CASE WHEN EXISTS (SELECT 1 FROM CTE_Get_Tables_With_FK WHERE [Ref_object_id] = TBL.[object_id]) THEN 1	ELSE 0 END	AS	[Table_Has_Ref]
	FROM sys.tables TBL
	INNER JOIN sys.schemas SCM ON SCM.[schema_id] = TBL.[schema_id]
	LEFT JOIN CTE_Get_Unique_Parent_Table_With_Ref Prnt_Tbl_Ref ON Prnt_Tbl_Ref.[parent_object_id] = TBL.[object_id]
	OUTER APPLY	( SELECT MAX([Iteration_Sequence_No]) AS [Max_Iteration_Sequence_No] FROM CTE_Get_Unique_Parent_Table_With_Ref ) MITRN
	WHERE TBL.[type] = 'U'
		AND TBL.[name] NOT LIKE 'sys%'
)
/*
Output: SchemaName, TableName, and T-SQL script to purge the table data. TRUNCATE is used where there are no foreign key references, otherwise, DELETE is used.
*/
SELECT TBL_SEQ.[SchemaName]	
	,TBL_SEQ.[TableName]
	,TBL_SEQ.[Iteration_Sequence_No]
	,(CASE WHEN ROW_NUMBER() OVER (ORDER BY TBL_SEQ.[Iteration_Sequence_No] ASC) = 1 THEN 'SET NOCOUNT ON;'	ELSE ''	END) + CHAR(13) + CHAR(10) + 
	 (CASE WHEN TBL_SEQ.[Table_Has_Ref] = 0 THEN 'TRUNCATE TABLE ' + QUOTENAME(TBL_SEQ.[SchemaName]) + '.' + QUOTENAME(TBL_SEQ.[TableName]) + ';'
			ELSE 'DELETE FROM ' + QUOTENAME(TBL_SEQ.[SchemaName]) + '.' + QUOTENAME(TBL_SEQ.[TableName]) + ';' + CHAR(13) + CHAR(10) + 'GO' + CHAR(13) + CHAR(10) + 
			'DBCC CHECKIDENT (''' + QUOTENAME(TBL_SEQ.[SchemaName]) + '.' + QUOTENAME(TBL_SEQ.[TableName]) + ''', RESEED, 1);'
		END + CHAR(13) + CHAR(10) + 'GO') AS	[TSQL_Query]
FROM CTE_Get_All_Tables TBL_SEQ
ORDER BY TBL_SEQ.[Iteration_Sequence_No] ASC, TBL_SEQ.[SchemaName] ASC, TBL_SEQ.[TableName] ASC
OPTION (MAXRECURSION 0)