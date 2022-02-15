USE [master]
RESTORE DATABASE [vault]
FROM DISK = N'/var/opt/mssql-log-shipping/vault_LogShipping_FullBackup.bak'
WITH FILE = 1,
     MOVE N'vault' TO N'/var/opt/mssql/data/vault-db.mdb',
	 MOVE N'vault_log' TO N'/var/opt/mssql/data/vault-db.ldb',
	 STANDBY = N'/var/opt/mssql/data/vault_RollbackUndo_2022-02-14_03-08-24.bak',
	 NOUNLOAD,
	 REPLACE,
	 STATS = 5
GO

RESTORE LOG [vault]
FROM DISK = N'/var/opt/mssql-log-shipping/vault_LogShipping_TransactionLogBackup.bak'
WITH FILE = 1,
     STANDBY = N'/var/opt/mssql/data\ROLLBACK_UNDO_vault.BAK',
	 NOUNLOAD,
	 STATS = 5
GO
