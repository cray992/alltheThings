/* Case 19200 - Practice Details: Add Subscription Edition, Support Plan dropdowns  */

/* Create Subscription Edition types table ... */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EditionType]') AND type in (N'U'))
DROP TABLE [dbo].[EditionType]
GO

CREATE TABLE [dbo].[EditionType](
	[EditionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[EditionTypeName] [varchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SortOrder] [smallint],
	[Active] [bit],
 CONSTRAINT [PK_SubscriptionType] PRIMARY KEY CLUSTERED 
(
	[EditionTypeID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

/*
Insert the following known editions:
	Enterprise
	Team
	Basic
*/

INSERT INTO dbo.[EditionType] (
	EditionTypeName, 
	SortOrder, 
	Active ) 
VALUES (
	'Enterprise',
	10,
	1 )
GO

INSERT INTO dbo.[EditionType] (
	EditionTypeName, 
	SortOrder, 
	Active ) 
VALUES (
	'Team',
	20,
	1 )
GO

INSERT INTO dbo.[EditionType] (
	EditionTypeName, 
	SortOrder, 
	Active ) 
VALUES (
	'Basic',
	30,
	1 )
GO

/* Create Support Plan types table ... */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SupportType]') AND type in (N'U'))
DROP TABLE [dbo].[SupportType]
GO

CREATE TABLE [dbo].[SupportType](
	[SupportTypeID] [int] IDENTITY(1,1) NOT NULL,
	[SupportTypeName] [varchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SortOrder] [smallint],
	[Active] [bit],
 CONSTRAINT [PK_SupportType] PRIMARY KEY CLUSTERED 
(
	[SupportTypeID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

/*
Insert the following known support plans:
	Platinum
	Gold
	Standard
*/

INSERT INTO dbo.[SupportType] (
	SupportTypeName, 
	SortOrder, 
	Active ) 
VALUES (
	'Platinum',
	10,
	1 )
GO

INSERT INTO dbo.[SupportType] (
	SupportTypeName, 
	SortOrder, 
	Active ) 
VALUES (
	'Gold',
	20,
	1 )
GO

INSERT INTO dbo.[SupportType] (
	SupportTypeName, 
	SortOrder, 
	Active ) 
VALUES (
	'Standard',
	30,
	1 )
GO

/* Add columns EditionTypeID, SupportTypeID to practice ... */
ALTER TABLE dbo.Practice ADD
	EditionTypeID INT NULL,
	SupportTypeID INT NULL
GO

/* Change edit practice permission name ... */
UPDATE [Superbill_Shared]..[Permissions]
SET [Name] = 'Edit Practice Information'
WHERE [Name] = 'Edit Contact Information'
GO