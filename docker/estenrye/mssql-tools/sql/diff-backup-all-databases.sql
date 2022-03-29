EXECUTE dbo.DatabaseBackup
@Databases = 'ALL_DATABASES',
@Directory = '/var/opt/mssql/logship',
@BackupType = 'DIFF',
@Verify = 'N',
@Compress = 'N',
@CheckSum = 'Y',
@CleanupTime = 168,
@LogToTable = 'Y'