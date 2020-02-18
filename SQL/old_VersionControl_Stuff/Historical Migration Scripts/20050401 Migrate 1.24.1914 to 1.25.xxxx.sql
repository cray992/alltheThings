/*

DATABASE UPDATE SCRIPT

v1.24.1914 to v1.25.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 3644:  Add tables to limit reports by software application

-- Add the SoftwareApplication table

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SoftwareApplication]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SoftwareApplication]
GO

CREATE TABLE [dbo].[SoftwareApplication] (
	[SoftwareApplicationID] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SoftwareApplication] ADD 
	CONSTRAINT [PK_SoftwareApplication] PRIMARY KEY  CLUSTERED 
	(
		[SoftwareApplicationID]
	)  ON [PRIMARY] 
GO

INSERT [dbo].[SoftwareApplication]
VALUES ('A', 'Kareo Administrator')

INSERT [dbo].[SoftwareApplication]
VALUES ('B', 'Kareo Business Manager')

INSERT [dbo].[SoftwareApplication]
VALUES ('M', 'Kareo Medical Office')

INSERT [dbo].[SoftwareApplication]
VALUES ('P', 'Kareo Practitioner')

INSERT [dbo].[SoftwareApplication]
VALUES ('S', 'Kareo Service Manager')


-- Add the ReportToSoftwareApplication

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportToSoftwareApplication]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ReportToSoftwareApplication]
GO

CREATE TABLE [dbo].[ReportToSoftwareApplication] (
	[ReportID] [int] NOT NULL ,
	[SoftwareApplicationID] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ReportToSoftwareApplication] WITH NOCHECK ADD 
	CONSTRAINT [PK_ReportToSoftwareApplication] PRIMARY KEY  CLUSTERED 
	(
		[ReportID],
		[SoftwareApplicationID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ReportToSoftwareApplication] ADD 
	CONSTRAINT [FK_ReportToSoftwareApplication_Report] FOREIGN KEY 
	(
		[ReportID]
	) REFERENCES [dbo].[Report] (
		[ReportID]
	),
	CONSTRAINT [FK_ReportToSoftwareApplication_SoftwareApplication] FOREIGN KEY 
	(
		[SoftwareApplicationID]
	) REFERENCES [dbo].[SoftwareApplication] (
		[SoftwareApplicationID]
	)
GO

-- Associate the existing reports to Business Manager and Medical Office
INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (1, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (2, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (3, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (4, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (5, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (6, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (7, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (8, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (9, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (10, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (11, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (12, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (13, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (14, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (15, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (16, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (17, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (18, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (19, 'B')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (1, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (2, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (3, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (4, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (5, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (6, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (7, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (8, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (9, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (10, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (11, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (12, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (13, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (14, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (15, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (16, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (17, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (18, 'M')

INSERT INTO [dbo].[ReportToSoftwareApplication]
VALUES (19, 'M')

--Add the ReportCategoryToSoftwareApplication

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportCategoryToSoftwareApplication]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ReportCategoryToSoftwareApplication]
GO

CREATE TABLE [dbo].[ReportCategoryToSoftwareApplication] (
	[ReportCategoryID] [int] NOT NULL ,
	[SoftwareApplicationID] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ReportCategoryToSoftwareApplication] WITH NOCHECK ADD 
	CONSTRAINT [PK_ReportCategoryToSoftwareApplication] PRIMARY KEY  CLUSTERED 
	(
		[ReportCategoryID],
		[SoftwareApplicationID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ReportCategoryToSoftwareApplication] ADD 
	CONSTRAINT [FK_ReportCategoryToSoftwareApplication_ReportCategory] FOREIGN KEY 
	(
		[ReportCategoryID]
	) REFERENCES [dbo].[ReportCategory] (
		[ReportCategoryID]
	),
	CONSTRAINT [FK_ReportCategoryToSoftwareApplication_SoftwareApplication] FOREIGN KEY 
	(
		[SoftwareApplicationID]
	) REFERENCES [dbo].[SoftwareApplication] (
		[SoftwareApplicationID]
	)
GO

-- Associate existing report categories to Business Manager and Medical Office
INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (1, 'B')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (2, 'B')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (3, 'B')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (4, 'B')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (5, 'B')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (6, 'B')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (7, 'B')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (1, 'M')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (2, 'M')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (3, 'M')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (4, 'M')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (5, 'M')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (6, 'M')

INSERT INTO [dbo].[ReportCategoryToSoftwareApplication]
VALUES (7, 'M')

GO

---------------------------------------------------------------------------------------
--case 3599 - Payment ID must be part of Clearinghouse Report (for ERA purposes)
---------------------------------------------------------------------------------------

ALTER TABLE
	ClearinghouseResponse
ADD
	PaymentID INT NULL
GO

ALTER TABLE ClearinghouseResponse
	ADD CONSTRAINT [FK_ClearinghouseResponse_Payment] FOREIGN KEY 
	(
		[PaymentID]
	) REFERENCES [Payment] (
		[PaymentID]
	)
GO

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
