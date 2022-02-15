-- Execute the following statements at the Primary to configure Log Shipping 
-- for the database [mssql-primary.mssql.svc.cluster.local].[vault],
-- The script needs to be run at the Primary in the context of the [msdb] database.  
------------------------------------------------------------------------------------- 
-- Adding the Log Shipping configuration 

-- ****** Begin: Script to be run at Primary: [mssql-primary.mssql.svc.cluster.local] ******


DECLARE @LS_BackupJobId	AS uniqueidentifier 
DECLARE @LS_PrimaryId	AS uniqueidentifier 
DECLARE @SP_Add_RetCode	As int 


EXEC @SP_Add_RetCode = master.dbo.sp_add_log_shipping_primary_database 
		@database = N'vault' 
		,@backup_directory = N'/var/opt/mssql-log-shipping' 
		,@backup_share = N'/var/opt/mssql-log-shipping' 
		,@backup_job_name = N'LSBackup_vault' 
		,@backup_retention_period = 4320
		,@backup_compression = 2
		,@monitor_server = N'MSSQL-MONITOR.MSSQL.SVC.CLUSTER.LOCAL' 
		,@monitor_server_security_mode = 0 
		,@monitor_server_login = N'**********'
		,@monitor_server_password = N'**********'
		,@backup_threshold = 60 
		,@threshold_alert_enabled = 1
		,@history_retention_period = 5760 
		,@backup_job_id = @LS_BackupJobId OUTPUT 
		,@primary_id = @LS_PrimaryId OUTPUT 
		,@overwrite = 1 


IF (@@ERROR = 0 AND @SP_Add_RetCode = 0) 
BEGIN 

DECLARE @LS_BackUpScheduleUID	As uniqueidentifier 
DECLARE @LS_BackUpScheduleID	AS int 


EXEC msdb.dbo.sp_add_schedule 
		@schedule_name =N'LSBackupSchedule_mssql-primary.mssql.svc.cluster.local1' 
		,@enabled = 1 
		,@freq_type = 4 
		,@freq_interval = 1 
		,@freq_subday_type = 4 
		,@freq_subday_interval = 15 
		,@freq_recurrence_factor = 0 
		,@active_start_date = 20220213 
		,@active_end_date = 99991231 
		,@active_start_time = 0 
		,@active_end_time = 235900 
		,@schedule_uid = @LS_BackUpScheduleUID OUTPUT 
		,@schedule_id = @LS_BackUpScheduleID OUTPUT 

EXEC msdb.dbo.sp_attach_schedule 
		@job_id = @LS_BackupJobId 
		,@schedule_id = @LS_BackUpScheduleID  

EXEC msdb.dbo.sp_update_job 
		@job_id = @LS_BackupJobId 
		,@enabled = 1 


END 


EXEC master.dbo.sp_add_log_shipping_primary_secondary 
		@primary_database = N'vault' 
		,@secondary_server = N'MSSQL-SECONDARY.MSSQL.SVC.CLUSTER.LOCAL' 
		,@secondary_database = N'vault' 
		,@overwrite = 1 

-- ****** End: Script to be run at Primary: [mssql-primary.mssql.svc.cluster.local]  ******