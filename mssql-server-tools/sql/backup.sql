DECLARE @database_name as NVARCHAR(50) = N'vault'
DECLARE @backup_directory as NVARCHAR(50) = N'/var/opt/mssql-log-shipping'

DECLARE @datetime as DATETIME = GETDATE()
DECLARE @datestamp_file as NVARCHAR(14) = (SELECT FORMAT(@datetime, 'yyyyMMddHHmmss'))
DECLARE @datestamp_title as NVARCHAR(25) = (SELECT FORMAT(@datetime, 'yyyy-MM-dd hh:mm:ss tt'))

DECLARE @backup_filename as NVARCHAR(125) = @backup_directory + N'/' + @database_name + N'_' + @datestamp_file + N'_Full.bak'
DECLARE @backup_title as NVARCHAR(125) = @database_name + N' - Full Database Backup - ' + @datestamp_title
SELECT @backup_filename AS [Filename], @backup_title AS [Title]

BACKUP DATABASE [vault] TO  DISK = @backup_filename
WITH NOFORMAT,
     NOINIT,
	 NAME = @backup_title,
     SKIP, NOREWIND, NOUNLOAD,
	 STATS = 5,
	 CHECKSUM

DECLARE @backupSetId AS INT
SELECT @backupSetId = position
FROM msdb..backupset
WHERE database_name=@database_name
  AND backup_set_id=(SELECT max(backup_set_id)
                     FROM msdb..backupset
					 WHERE database_name=@database_name )

DECLARE @backupSetNotFoundError AS NVARCHAR(125) = N'Verify failed. Backup information for database ''' + @database_name +  N''' not found.'
IF @backupSetId IS NULL BEGIN raiserror(@backupSetNotFoundError, 16, 1) END

RESTORE VERIFYONLY
FROM
  DISK = @backup_filename
  WITH FILE = @backupSetId,
       NOUNLOAD,
	   NOREWIND
GO