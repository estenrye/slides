USE master;
GO

BACKUP DATABASE vault TO DISK = '/var/opt/mssql-log-shipping/vault_LogShipping_FullBackup.bak'
WITH INIT
	,FORMAT
	,COMPRESSION
	,STATS = 5;
GO

BACKUP LOG vault TO DISK = '/var/opt/mssql-log-shipping/vault_LogShipping_TransactionLogBackup.bak'
WITH INIT
	,FORMAT
	,COMPRESSION
	,STATS = 5;
GO