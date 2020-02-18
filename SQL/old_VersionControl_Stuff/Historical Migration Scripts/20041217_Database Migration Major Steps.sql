exec sp_detach_db N'superbill_shared', N'true'
GO
exec sp_detach_db N'superbill_stage', N'true'
GO
exec sp_detach_db N'superbill_build', N'true'
GO
exec sp_detach_db N'superbill_build_test', N'true'
GO

exec sp_detach_db N'superbill_0001_dev', N'true'

select spid from master..sysprocesses where dbid=db_id('superbill_0001_dev')

kill 51
GO
kill 59
go
kill 62
go
kill 63
go
kill 64

--Hookup the old dev database
exec sp_attach_db N'superbill_0001_dev_Old_1217', 
		N'C:\database\aged_out_dev_1217\superbill_0001_dev.mdf', 
		N'C:\database\aged_out_dev_1217\superbill_0001_dev_log.ldf'
GO
exec superbill_0001_dev_Old_1217..sp_changedbowner 'sa', false
GO

--Hookup the old shared
exec sp_attach_db N'superbill_shared_Old_1217', 
		N'C:\database\aged_out_dev_1217\superbill_shared_data.mdf', 
		N'C:\database\aged_out_dev_1217\superbill_shared_log.ldf'
GO
exec superbill_0001_dev_Old_1217..sp_changedbowner 'sa', false
GO

--Restore the production backup AS superbill_0001_dev
RESTORE DATABASE [superbill_0001_dev] 
	FROM DISK = N'C:\temp\migrate_superbill_prod_backup_daily.bak' 
	WITH 
		FILE = 1, 
		STATS = 10, 
		RECOVERY, 
		NOUNLOAD, 
		MOVE N'superbill_prod_Data' TO N'C:\database\superbill_0001_dev\superbill_0001_dev.mdf', 
		MOVE N'superbill_prod_Log' TO N'C:\database\superbill_0001_dev\superbill_0001_dev_log.ldf'

GO
exec superbill_0001_dev..sp_changedbowner 'sa', false
GO
sp_change_users_login @Action = 'Report'
GO
