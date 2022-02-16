EXECUTE dbo.DatabaseBackup
@Databases = 'USER_DATABASES',
@Directory = '/var/opt/mssql/logship',
@BackupType = 'LOG',
@Verify = 'N',
@Compress = 'N',
@CheckSum = 'Y',
@CleanupTime = 168,
@LogToTable = 'Y'