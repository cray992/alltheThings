/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='InsuranceCompanyPlanGuid' AND COLUMNS.TABLE_NAME='InsuranceCompanyPlan')
ALTER TABLE dbo.InsuranceCompanyPlan ADD
	InsuranceCompanyPlanGuid uniqueidentifier NOT NULL CONSTRAINT DF_InsuranceCompanyPlan_InsuranceCompanyPlanGuid DEFAULT NEWID()
GO
COMMIT


IF NOT EXISTS(SELECT * FROM sys.indexes AS i WHERE i.name='UX_InsuranceCompanyPlan_InsuranceCompanyPlanGuid')
ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD  CONSTRAINT [UX_InsuranceCompanyPlan_InsuranceCompanyPlanGuid] UNIQUE NONCLUSTERED 
(
	[InsuranceCompanyPlanGuid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
