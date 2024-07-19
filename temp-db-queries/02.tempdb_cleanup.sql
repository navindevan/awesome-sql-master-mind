--Find oldest transaction
DBCC OPENTRAN

-- Get input buffer for a SPID
DBCC INPUTBUFFER(115) -- Replace the SPID number from above

--Get tempdb files and available space in MB
USE [Tempdb]
GO
SELECT 
	name AS 'File Name',
	physical_name AS 'Physical Name', 
	size/128 AS 'Total Size in MB', 
	size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS 'Available Space In MB', 
	* 
FROM sys.database_files;

--Shrink file by TRUNCATEONLY
USE [tempdb]
GO
DBCC SHRINKFILE (N'temp2' , 0, TRUNCATEONLY)
GO

USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev' , 1024)
GO

USE [tempdb]
GO
CHECKPOINT

USE tempdb
GO

SELECT name, size
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb');
GO

DBCC FREEPROCCACHE -- clean cache
DBCC DROPCLEANBUFFERS -- clean buffers
DBCC FREESYSTEMCACHE ('ALL') -- clean system cache
DBCC FREESESSIONCACHE -- clean session cache
DBCC SHRINKDATABASE(tempdb, 10); -- shrink tempdb

--Update the tempdb filles
DBCC SHRINKFILE ('tempdev') -- shrink default db file
DBCC SHRINKFILE ('templog') -- shrink db file tempdev
DBCC SHRINKFILE ('temp1') -- shrink db file tempdev1
DBCC SHRINKFILE ('temp2') -- shrink db file tempdev2
DBCC SHRINKFILE ('templog1') -- shrink log file
DBCC SHRINKFILE ('tempdev2') -- shrink log file

GO