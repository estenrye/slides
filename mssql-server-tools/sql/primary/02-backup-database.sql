USE master;
GO

EXECUTE dbo.DatabaseBackup
@Databases = 'SYSTEM_DATABASES',
@Directory = '/var/opt/mssql/logship',
@DirectoryStructure = '{ServerName}${InstanceName}{DirectorySeparator}SYSTEM_DATABASES{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}',
@Init = 'Y',
@BackupType = 'FULL',
@Verify = 'N',
@Compress = 'N',
@CheckSum = 'Y',
@CleanupTime = 168,
@LogToTable = 'Y'

EXECUTE dbo.DatabaseBackup
@Databases = 'SYSTEM_DATABASES',
@Directory = '/var/opt/mssql/logship',
@DirectoryStructure = '{ServerName}${InstanceName}{DirectorySeparator}SYSTEM_DATABASES{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}',
@BackupType = 'LOG',
@Verify = 'N',
@Compress = 'N',
@CheckSum = 'Y',
@CleanupTime = 168,
@LogToTable = 'Y'

EXECUTE dbo.DatabaseBackup
@Databases = 'USER_DATABASES',
@Directory = '/var/opt/mssql/logship',
@DirectoryStructure = '{ServerName}${InstanceName}{DirectorySeparator}USER_DATABASES{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}',
@Init = 'Y',
@BackupType = 'FULL',
@Verify = 'N',
@Compress = 'N',
@CheckSum = 'Y',
@CleanupTime = 168,
@LogToTable = 'Y'

EXECUTE dbo.DatabaseBackup
@Databases = 'USER_DATABASES',
@Directory = '/var/opt/mssql/logship',
@DirectoryStructure = '{ServerName}${InstanceName}{DirectorySeparator}USER_DATABASES{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}',
@BackupType = 'LOG',
@Verify = 'N',
@Compress = 'N',
@CheckSum = 'Y',
@CleanupTime = 168,
@LogToTable = 'Y'
