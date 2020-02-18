/*********************************************************************************
List of changes to add databasestatusid to customer table

Also cleans up default names

This was already run ON Production
*********************************************************************************/

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
GO
BEGIN TRANSACTION
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_NumOfEmployeesID]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_NumOfUsersID]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_NumOfPhysiciansID]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_AnnualCompanyRevenueID]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_MarketingSourceID]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_CustomerType]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_Prepopulated]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_AccountLocked]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_DBActive]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_CreatedDate]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_ModifiedDate]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF__Customer__SendNe__297722B6]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF__Customer__Subscr__546180BB]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF__Customer__Subscr__592635D8]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF__Customer__Subscr__7226EDCC]
GO
	
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_LicenseCount]
GO

ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_CustomerTypeTransitionPending]
GO

ALTER TABLE [dbo].[Customer] ADD
	[DatabaseStatusID] int NOT NULL CONSTRAINT [DF_Customer_DatabaseStatusID] DEFAULT (0)
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_NumOfEmployeesID] DEFAULT (0) FOR [NumOfEmployeesID]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_NumOfUsersID] DEFAULT (0) FOR [NumOfUsersID]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_NumOfPhysiciansID] DEFAULT (0) FOR [NumOfPhysiciansID]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_AnnualCompanyRevenueID] DEFAULT (0) FOR [AnnualCompanyRevenueID]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_MarketingSourceID] DEFAULT (0) FOR [MarketingSourceID]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_CustomerType] DEFAULT ('T') FOR [CustomerType]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_Prepopulated] DEFAULT (0) FOR [Prepopulated]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_AccountLocked] DEFAULT (0) FOR [AccountLocked]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_DBActive] DEFAULT (0) FOR [DBActive]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_SendNewsletter] DEFAULT (0) FOR [SendNewsletter]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_SubscriptionExpirationDate] DEFAULT (dateadd(day,30,getdate())) FOR [SubscriptionExpirationDate]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_SubscriptionNextCheckDate] DEFAULT (getdate()) FOR [SubscriptionNextCheckDate]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_SubscriptionExpirationLastWarningOffset] DEFAULT (30) FOR [SubscriptionExpirationLastWarningOffset]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_LicenseCount] DEFAULT (1) FOR [LicenseCount]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_CustomerTypeTransitionPending] DEFAULT (1) FOR [CustomerTypeTransitionPending]
GO
CREATE TABLE [dbo].[DatabaseStatus] (
	[DatabaseStatusID] [int] NOT NULL ,
	[StatusText] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DatabaseStatus] ADD
	CONSTRAINT [PK_DatabaseStatus] PRIMARY KEY CLUSTERED
	(
		[DatabaseStatusID]
	) ON [PRIMARY]
GO

PRINT 'Inserting rows into table: [dbo].[DatabaseStatus]'

INSERT INTO [dbo].[DatabaseStatus] ([DatabaseStatusID], [StatusText]) VALUES (0, 'Database Not Created')
GO
INSERT INTO [dbo].[DatabaseStatus] ([DatabaseStatusID], [StatusText]) VALUES (1, 'Database Created')
GO
INSERT INTO [dbo].[DatabaseStatus] ([DatabaseStatusID], [StatusText]) VALUES (2, 'Logshipping Primary Setup')
GO
INSERT INTO [dbo].[DatabaseStatus] ([DatabaseStatusID], [StatusText]) VALUES (3, 'Logshipping Secondard Setup')
GO

--
ALTER TABLE [dbo].[Customer] WITH NOCHECK ADD
	CONSTRAINT [FK_Customer_DatabaseStatus] FOREIGN KEY
	(
		[DatabaseStatusID]
	) REFERENCES [dbo].[DatabaseStatus] (
		[DatabaseStatusID]
	) 


UPDATE Customer
	SET DatabaseStatusID = 1
	
--COMMIT
SELECT @@TRANCOUNT

