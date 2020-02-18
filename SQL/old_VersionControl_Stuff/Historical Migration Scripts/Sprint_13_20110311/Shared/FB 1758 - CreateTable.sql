IF EXISTS (SELECT * FROM sys.tables WHERE name = 'CustomerPracticesAggregationDoctor')
	DROP TABLE dbo.CustomerPracticesAggregationDoctor
GO

CREATE TABLE dbo.CustomerPracticesAggregationDoctor (
	CustomerPracticesAggregationDoctorID UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	CustomerID INT NOT NULL,
	PracticeID INT NOT NULL,
	DoctorID INT NOT NULL,
	Prefix  VARCHAR(16),
	FirstName  VARCHAR(64),
	MiddleName  VARCHAR(64),
	LastName  VARCHAR(64),
	Suffix  VARCHAR(16),	
	Degree VARCHAR(8),
	NPI VARCHAR(10),
	Specialty CHAR(10),
	ProviderType VARCHAR(50),
	CreatedDT DATETIME,
	CreatedUserID INT
)
GO


IF EXISTS (SELECT * FROM sys.tables WHERE name = 'CustomerPracticesAggregationDoctorHistory')
	DROP TABLE dbo.CustomerPracticesAggregationDoctorHistory
GO

CREATE TABLE [dbo].[CustomerPracticesAggregationDoctorHistory]
(
	[ID] [uniqueidentifier] NULL,
	[DoctorID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ActivationEventID] [int] NULL,
	[ActivationUserID] [int] NULL,
	ActivationUserName VARCHAR(60) NULL,
	[ActivationDT] [datetime] NULL,
	[DeactivationEventID] [int] NULL,
	[DeactivationUserID] [int] NULL,
	DeactivationUserName VARCHAR(60) NULL,
	[DeactivationDT] [datetime] NULL,
	Question VARCHAR(256),
	[Reason] [varchar] (256) NULL
) 
GO



IF EXISTS (SELECT * FROM sys.tables WHERE name = 'CustomerPracticesAggregationLastEvent')
	DROP TABLE dbo.CustomerPracticesAggregationLastEvent
GO

CREATE TABLE [dbo].[CustomerPracticesAggregationLastEvent]
(
	CustomerPracticesAggregationLastEventID INT NOT NULL IDENTITY(1,1),
	[Description] VARCHAR(32),
	LastValue INT NOT NULL DEFAULT 0
)
GO


INSERT INTO dbo.CustomerPracticesAggregationLastEvent
        ( DESCRIPTION)
VALUES  ( 'RETENTION_OFFER')


IF EXISTS (SELECT * FROM sys.tables WHERE name = 'CustomerPracticesAggregationPracticeHistory')
	DROP TABLE dbo.CustomerPracticesAggregationPracticeHistory
GO

CREATE TABLE [dbo].[CustomerPracticesAggregationPracticeHistory]
(
	[ID] [uniqueidentifier] NULL,
	[PracticeID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ActivationEventID] [int] NULL,
	[ActivationUserID] [int] NULL,
	ActivationUserName VARCHAR(60) NULL,
	[ActivationDT] [datetime] NULL,
	[DeactivationEventID] [int] NULL,
	[DeactivationUserID] [int] NULL,
	DeactivationUserName VARCHAR(60) NULL,
	[DeactivationDT] [datetime] NULL,
	Question VARCHAR(256),
	[Reason] [varchar] (256) NULL
) 
GO
