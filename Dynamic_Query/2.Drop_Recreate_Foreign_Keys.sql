USE [Databasename]
GO

DECLARE @tablename     AS NVARCHAR(255) = 'tablename'
DECLARE @keyColumnname AS NVARCHAR(255) = 'Keycolumnname'

SELECT
     'ALTER TABLE [dbo].[' + OBJECT_NAME(f.parent_object_id) + '] Drop Constraint [' + F.Name + ']'
	-- ,*
	-- ,OBJECT_NAME(f.parent_object_id) TableName,
	-- COL_NAME(fc.parent_object_id,fc.parent_column_id) ColName
FROM sys.foreign_keys AS f
INNER JOIN sys.foreign_key_columns AS fc
    ON f.OBJECT_ID = fc.constraint_object_id
INNER JOIN sys.tables t
    ON t.OBJECT_ID = fc.referenced_object_id
INNER JOIN sys.columns S 
	ON S.Column_ID = fc.Parent_column_ID 
	AND S.object_ID = f.parent_object_id
WHERE  OBJECT_NAME (f.referenced_object_id) = @tablename

SELECT
     'ALTER TABLE [dbo].[' + OBJECT_NAME(f.parent_object_id) + '] WITH NOCHECK ADD  CONSTRAINT [' + F.Name + '] FOREIGN KEY (' + S.Name + ') REFERENCES '+ @tablename +'('+@keyColumnname+')'
	-- ,*
	-- ,OBJECT_NAME(f.parent_object_id) TableName,
	-- COL_NAME(fc.parent_object_id,fc.parent_column_id) ColName
FROM sys.foreign_keys AS f
INNER JOIN sys.foreign_key_columns AS fc
    ON f.OBJECT_ID = fc.constraint_object_id
INNER JOIN sys.tables t
    ON t.OBJECT_ID = fc.referenced_object_id
INNER JOIN sys.columns S 
	ON S.Column_ID = fc.Parent_column_ID 
	AND S.object_ID =f.parent_object_id
WHERE  OBJECT_NAME (f.referenced_object_id) = @tablename

SELECT
     'ALTER TABLE [dbo].[' + OBJECT_NAME(f.parent_object_id) + '] CHECK Constraint [' + F.Name + ']'
	-- ,*
	-- , OBJECT_NAME(f.parent_object_id) TableName,
	-- COL_NAME(fc.parent_object_id,fc.parent_column_id) ColName
FROM sys.foreign_keys AS f
INNER JOIN sys.foreign_key_columns AS fc
    ON f.OBJECT_ID = fc.constraint_object_id
INNER JOIN sys.tables t
    ON t.OBJECT_ID = fc.referenced_object_id
INNER JOIN sys.columns S 
	ON S.Column_ID = fc.Parent_column_ID 
	AND S.object_ID =f.parent_object_id
WHERE  OBJECT_NAME (f.referenced_object_id) = @tablename