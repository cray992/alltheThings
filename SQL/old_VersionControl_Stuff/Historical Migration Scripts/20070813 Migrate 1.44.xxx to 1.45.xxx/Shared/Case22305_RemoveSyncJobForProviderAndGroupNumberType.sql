--/* Case 22305 - Hide unused provider & group number types from users */
--
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Shared_SyncJob_GroupNumberType]') AND type in (N'P', N'PC'))
--DROP PROCEDURE [dbo].[Shared_SyncJob_GroupNumberType]
--GO
--
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Shared_SyncJob_ProviderNumberType]') AND type in (N'P', N'PC'))
--DROP PROCEDURE [dbo].[Shared_SyncJob_ProviderNumberType]
--GO



USE [msdb]


GO

ExEC dbo.sp_update_jobstep
    @job_name = N'Sync Subscribed Data',
	@step_id=3, 
	@command=N'/*Shared_SyncJob_GroupNumberType*/'
GO



ExEC dbo.sp_update_jobstep
    @job_name = N'Sync Subscribed Data',
	@step_id=4, 
	@command=N'/*Shared_SyncJob_ProviderNumberType*/'
GO
