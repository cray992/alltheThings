/*

DATABASE UPDATE SCRIPT

v1.23.1878 to v1.24.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 3495 - Create a table to store the trial security group for each customer

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TrialSecurityGroup]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TrialSecurityGroup]
GO

CREATE TABLE [dbo].[TrialSecurityGroup] (
	[CustomerID] [int] NOT NULL ,
	[TrialSecurityGroupID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL,
	[Timestamp] [timestamp] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TrialSecurityGroup] WITH NOCHECK ADD 
	CONSTRAINT [PK_TrialSecurityGroup] PRIMARY KEY  CLUSTERED 
	(
		[CustomerID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TrialSecurityGroup] ADD 
	CONSTRAINT [DF_TrialSecurityGroup_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_TrialSecurityGroup_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

ALTER TABLE [dbo].[TrialSecurityGroup] ADD 
	CONSTRAINT [FK_TrialSecurityGroup_Customer] FOREIGN KEY 
	(
		[CustomerID]
	) REFERENCES [dbo].[Customer] (
		[CustomerID]
	),
	CONSTRAINT [FK_TrialSecurityGroup_SecurityGroup] FOREIGN KEY 
	(
		[TrialSecurityGroupID]
	) REFERENCES [dbo].[SecurityGroup] (
		[SecurityGroupID]
	)
GO

-- Create the Trial User group for Customer 1

SET identity_insert SecurityGroup ON
INSERT INTO [dbo].[SecurityGroup] (
	[SecurityGroupID] /* Identity Field */ ,
	[CustomerID],
	[SecurityGroupName],
	[SecurityGroupDescription],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID],
	[ViewInMedicalOffice],
	[ViewInBusinessManager],
	[ViewInAdministrator],
	[ViewInServiceManager])
VALUES (
	7 /* Identity Field */ ,
	1,
	'Trial User',
	'Denies trial user access to certain features',
	getdate(),
	1,
	getdate(),
	1,
	0,
	0,
	0,
	0)
SET identity_insert SecurityGroup off

INSERT INTO dbo.TrialSecurityGroup (
	CustomerID,
	TrialSecurityGroupID)
VALUES (
	1,
	7)


INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	215,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)

INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	216,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)

INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	217,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)

INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	218,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)

INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	224,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)


INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	226,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)


INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	238,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)


INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	239,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)

INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	240,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)

INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	241,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)

INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	306,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)

INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	307,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)

INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	308,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)

INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	309,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)

INSERT INTO dbo.SecurityGroupPermissions (
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID)
VALUES (
	7,
	310,
	0,
	1,
	getdate(),
	1,
	getdate(),
	1)

---------------------------------------------------------------------------------------
--case 3550:  

ALTER TABLE
	Customer
ADD
	SubscriptionExpirationLastWarningOffset int NOT NULL DEFAULT 30
GO

---------------------------------------------------------------------------------------
--case 3448:  Add Blue Cross (California) to ProviderNumberType

INSERT INTO ProviderNumberType(
		ProviderNumberTypeID,
		TypeName,
		SortOrder)
VALUES (
		9,
		'Blue Cross (California)',
		22)
GO

---------------------------------------------------------------------------------------
--case 3201:  


CREATE TABLE [KareoProduct] (
	[KareoProductID] [int] IDENTITY (1, 1) NOT NULL ,
	[ProductName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Price] [money] NOT NULL CONSTRAINT [DF_KareoProduct_Price] DEFAULT(0),
	[CurrentlyOffered] [bit] NOT NULL CONSTRAINT [DF_KareoProduct_CurrentlyOffered] DEFAULT(1),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_KareoProduct_CreatedDate] DEFAULT (getdate()),

	CONSTRAINT [PK_KareoProduct] PRIMARY KEY  CLUSTERED 
	(
		[KareoProductID]
	)  ON [PRIMARY]

)
GO

INSERT INTO [KareoProduct] (ProductName, Price)
VALUES ('Kareo Basic Edition',149)
INSERT INTO [KareoProduct] (ProductName, Price)
VALUES ('Kareo Enterprise Edition',299)

INSERT INTO [KareoProduct] (ProductName, Price)
VALUES ('Standard Support',0)
INSERT INTO [KareoProduct] (ProductName, Price)
VALUES ('Gold Support',79)
INSERT INTO [KareoProduct] (ProductName, Price)
VALUES ('Platinum Support',99)

GO

CREATE TABLE [CustomerKareoProduct] (
	[CustomerID] int NOT NULL,
	[KareoProductID] int NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_CustomerKareoProduct_CreatedDate] DEFAULT (getdate()),
	CONSTRAINT [PK_CustomerKareoProduct] PRIMARY KEY  CLUSTERED 
	(
		[CustomerID],
		[KareoProductID]
	)  ON [PRIMARY],
	CONSTRAINT [FK_CustomerKareoProduct_CustomerID] FOREIGN KEY 
	(
		[CustomerID]
	) REFERENCES [Customer] (
		[CustomerID]
	),
	CONSTRAINT [FK_CustomerKareoProduct_KareoProductID] FOREIGN KEY 
	(
		[KareoProductID]
	) REFERENCES [KareoProduct] (
		[KareoProductID]
	)
)

GO

ALTER TABLE [Customer]
ADD
	LicenseCount int CONSTRAINT [DF_Customer_LicenseCount] DEFAULT(1)

ALTER TABLE [Customer]
ADD
	CustomerTypeTransitionPending bit CONSTRAINT [DF_Customer_CustomerTypeTransitionPending] DEFAULT(1)

GO

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
