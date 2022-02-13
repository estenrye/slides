USE [master]
RESTORE DATABASE [vault]
  FROM  DISK = N'/var/opt/mssql-log-shipping/vault_LogShipping_FullBackup.bak'
  WITH  FILE = 1,  
        MOVE N'vault' TO N'/var/opt/mssql/data/vault-db.mdb',
        MOVE N'vault_log' TO N'/var/opt/mssql/data/vault-db.ldb',
        STANDBY = N'/var/opt/mssql-log-shipping/vault_LogShipping_StandbyFile.bak',
        NOUNLOAD,
        REPLACE,
        STATS = 5
GO
