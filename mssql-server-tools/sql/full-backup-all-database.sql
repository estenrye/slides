EXECUTE dbo.DatabaseBackup
@Databases = 'ALL_DATABASES',
@Directory = '/var/opt/mssql/logship',
@BackupType = 'FULL',
@Verify = 'N',
@Compress = 'N',
@CheckSum = 'Y',
@CleanupTime = 168,
@LogToTable = 'Y'
