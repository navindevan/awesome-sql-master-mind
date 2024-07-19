DECLARE @SqlStart NVARCHAR(max) = ''
DECLARE @sql NVARCHAR(max) = ''
DECLARE @sqlEnd NVARCHAR(max) = ''
DECLARE @table VARCHAR(max) = 'DatabaseLog'

 
SET @SqlStart = 'CREATE TABLE [' + @table + '] (' + CHAR(13) 
                 
SELECT @sql = @sql + a.Column_Name + ' '
	+ Data_Type 
	+ CASE WHEN CHARACTER_MAXIMUM_LENGTH  IS NULL or DATA_TYPE = 'xml' THEN '' ELSE '(' + CASE WHEN CHARACTER_MAXIMUM_LENGTH>0 THEN CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) ELSE 'max' END +')' END
	+ CASE WHEN NUMERIC_PRECISION IS NULL OR DATA_TYPE in ('Int', 'tinyint', 'bigint', 'smallint') THEN '' ELSE '(' + CAST(NUMERIC_PRECISION AS VARCHAR(10)) +','+CAST(NUMERIC_SCALE AS VARCHAR(10)) +')' END
	+ CASE WHEN EXISTS (  SELECT id from sys.syscolumns WHERE OBJECT_NAME(id)=@table AND name=a.column_name AND COLUMNPROPERTY(id,name,'IsIdentity') = 1  ) THEN ' IDENTITY(' +  CAST(IDENT_SEED(@table) AS VARCHAR) + ',' +  CAST(IDENT_INCR(@table) AS VARCHAR) + ')' ELSE '' END
	+ CASE WHEN b.default_value is not null THEN ' DEFAULT ' + SUBSTRING(b.default_value, 2, LEN(b.default_value)-2) + ' ' ELSE '' END
	+ CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL ' END + CHAR(13) + ','
FROM INFORMATION_SCHEMA.COLUMNS a
JOIN (
	SELECT so.name AS table_name, 
		sc.name AS column_name, 
		sm.text AS default_value
    FROM sys.sysobjects so
    JOIN sys.syscolumns sc ON sc.id = so.id
	LEFT JOIN sys.syscomments SM ON sm.id = sc.cdefault
    WHERE so.xtype = 'U'
	AND SO.name = @table) b 
ON b.column_name = a.COLUMN_NAME 
	AND b.table_name = a.TABLE_NAME
WHERE a.Table_Name = @table

IF((SELECT COUNT(1) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = @table) >0)
BEGIN
    SELECT @sqlEnd = CHAR(13) + 'CONSTRAINT [PK_' + @table + '_1] PRIMARY KEY NONCLUSTERED' +
		CHAR(13) +'(' + CHAR(13) + Column_Name + ' ASC ' + CHAR(13) + ') WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]) ON [PRIMARY]'
	FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE  WHERE TABLE_NAME = @table                
	 
	SET @Sql = @SqlStart + SUBSTRING(@sql, 0, LEN(@sql)-1) + @sqlEnd
END
ELSE
BEGIN
     SET @Sql = @SqlStart + SUBSTRING(@sql, 0, LEN(@sql)-1) + ')'
END
 
PRINT @sql  