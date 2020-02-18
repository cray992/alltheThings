IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DashboardBusinessManagerDisplay]') AND type in (N'U'))
DROP TABLE [dbo].[DashboardBusinessManagerDisplay]
GO

create table dbo.DashboardBusinessManagerDisplay(
		PracticeId int constraint pk_DashboardBusinessManagerDisplay primary key clustered,
		CreatedDate datetime constraint df_DashboardBusinessManagerDisplay_CreatedDate default(getdate()),
		ModifiedDate datetime constraint df_DashboardBusinessManagerDisplay_ModifiedDate default(getdate()),
		CountPatientStatementsToSend int not null,
		)
