/*

SHARED DATABASE UPDATE SCRIPT

v1.22.xxxx to v1.23.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------
--case 2870 -  Change how provider and group numbers are configured for e-claims
--This IS portion of the case WHERE the identity property IS removed FROM the
--GroupNumberType and ProviderNumberType tables

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

ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP CONSTRAINT [FK_InsuranceCompanyPlan_GroupNumberType]
GO

ALTER TABLE [dbo].[GroupNumberType] DROP CONSTRAINT [DF__GroupNumb__SortO__3118447E]
GO

CREATE TABLE [dbo].[Tmp_GroupNumberType] (
	[GroupNumberTypeID] int NOT NULL,
	[TypeName]	varchar(50) NOT NULL,
	[ANSIReferenceIdentificationQualifier]	char(2) NULL,
	[SortOrder] int NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Tmp_GroupNumberType] ADD CONSTRAINT [DF_GroupNumberType_SortOrder] DEFAULT (0) FOR [SortOrder]
GO

INSERT INTO [dbo].[Tmp_GroupNumberType] ([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier], [SortOrder])
SELECT [GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier], [SortOrder] FROM [dbo].[GroupNumberType] TABLOCKX
GO

DROP TABLE [dbo].[GroupNumberType]
GO

EXECUTE sp_rename N'[dbo].[Tmp_GroupNumberType]', N'GroupNumberType', 'OBJECT'
GO

ALTER TABLE [dbo].[GroupNumberType]
	ADD CONSTRAINT [PK_GroupNumberType] PRIMARY KEY CLUSTERED
(	[GroupNumberTypeID]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] WITH NOCHECK ADD CONSTRAINT [FK_InsuranceCompanyPlan_GroupNumberType] FOREIGN KEY
(	[GroupNumberTypeID])
REFERENCES [dbo].[GroupNumberType]
(	[GroupNumberTypeID])
GO

COMMIT

GO
BEGIN TRANSACTION
GO
ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumberType_LocalUse]
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumberType]
GO

ALTER TABLE [dbo].[ProviderNumberType] DROP CONSTRAINT [DF__ProviderN__SortO__33008CF0]
GO

CREATE TABLE [dbo].[Tmp_ProviderNumberType] (
	[ProviderNumberTypeID] int NOT NULL,
	[TypeName]	varchar(50) NOT NULL,
	[ANSIReferenceIdentificationQualifier]	char(2) NULL,
	[SortOrder] int NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Tmp_ProviderNumberType] ADD CONSTRAINT [DF_ProviderNumberType_SortOrder] DEFAULT (0) FOR [SortOrder]
GO

INSERT INTO [dbo].[Tmp_ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier])
SELECT [ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier] FROM [dbo].[ProviderNumberType] TABLOCKX
GO

DROP TABLE [dbo].[ProviderNumberType]
GO

EXECUTE sp_rename N'[dbo].[Tmp_ProviderNumberType]', N'ProviderNumberType', 'OBJECT'
GO

ALTER TABLE [dbo].[ProviderNumberType]
	ADD CONSTRAINT [PK_BillingIdentifier] PRIMARY KEY CLUSTERED
(	[ProviderNumberTypeID]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] WITH NOCHECK ADD CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumberType] FOREIGN KEY
(	[ProviderNumberTypeID])
REFERENCES [dbo].[ProviderNumberType]
(	[ProviderNumberTypeID])
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] WITH NOCHECK ADD CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumberType_LocalUse] FOREIGN KEY
(	[LocalUseProviderNumberTypeID])
REFERENCES [dbo].[ProviderNumberType]
(	[ProviderNumberTypeID])
GO

COMMIT
GO

---------------------------------------------------------------------------------------
--case 2870 -  Change how provider and group numbers are configured for e-claims

CREATE TABLE [dbo].[AttachConditionsType] (
	[PK_ID] [int] IDENTITY (1, 1)  NOT NULL PRIMARY KEY ,
	[AttachConditionsTypeID] [int] UNIQUE NOT NULL ,
	[AttachConditionsTypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

INSERT INTO AttachConditionsType (AttachConditionsTypeID, AttachConditionsTypeName) VALUES(1, 'Paper And Electronic Claims')
INSERT INTO AttachConditionsType (AttachConditionsTypeID, AttachConditionsTypeName) VALUES(2, 'Paper Claims Only')
INSERT INTO AttachConditionsType (AttachConditionsTypeID, AttachConditionsTypeName) VALUES(3, 'Electronic Claims Only')

  ------------------------------------------------
  -- Migrate GroupNumberType to new notation
  -- (same change is going to happen in shared):
ALTER TABLE
	GroupNumberType
ADD
	SortOrder INT NOT NULL DEFAULT 0
GO

INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(21, 'State License Number', '0B', 10)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(22, 'Blue Cross Provider Number', '1A', 20)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(23, 'Blue Shield Provider Number', '1B', 30)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(24, 'Medicare Provider Number', '1C', 40)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(25, 'Medicaid Provider Number', '1D', 50)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(26, 'Provider UPIN Number', '1G', 60)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(27, 'CHAMPUS Identification Number', '1H', 70)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(28, 'Facility ID Number', '1J', 80)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(29, 'Preferred Provider Organization Number', 'B3', 90)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(30, 'Health Maintenance Organization Code Number', 'BQ', 100)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(31, 'Employer’s Identification Number', 'EI', 110)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(32, 'Clinic Number', 'FH', 120)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(33, 'Provider Commercial Number', 'G2', 130)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(34, 'Provider Site Number', 'G5', 140)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(35, 'Location Number', 'LU', 150)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(36, 'Social Security Number', 'SY', 160)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(37, 'Unique Supplier Identification Number (USIN)', 'U3', 170)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(38, 'State Industrial Accident Provider Number', 'X5', 180)
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE Name = 'temp_migrate_GroupNumberType' AND TYPE = 'P') DROP PROCEDURE dbo.temp_migrate_GroupNumberType
GO
CREATE PROCEDURE dbo.temp_migrate_GroupNumberType
	@from_id INT, @to_id INT, @attach_to INT
AS
BEGIN
	--SELECT * FROM InsuranceCompanyPlan ICP WHERE ICP.GroupNumberTypeID = @from_id
	UPDATE InsuranceCompanyPlan
	SET GroupNumberTypeID = @to_id WHERE GroupNumberTypeID = @from_id
	--SELECT * FROM InsuranceCompanyPlan ICP WHERE ICP.GroupNumberTypeID = @to_id
END
GO
BEGIN TRAN 
EXEC dbo.temp_migrate_GroupNumberType 1, 33, 2
GO
EXEC dbo.temp_migrate_GroupNumberType 2, 23, 2
GO
EXEC dbo.temp_migrate_GroupNumberType 3, 24, 2
GO
EXEC dbo.temp_migrate_GroupNumberType 4, 21, 3
GO
EXEC dbo.temp_migrate_GroupNumberType 5, 22, 3
GO
EXEC dbo.temp_migrate_GroupNumberType 6, 23, 3
GO
EXEC dbo.temp_migrate_GroupNumberType 7, 24, 3
GO
EXEC dbo.temp_migrate_GroupNumberType 8, 25, 3
GO
EXEC dbo.temp_migrate_GroupNumberType 9, 27, 3
GO
EXEC dbo.temp_migrate_GroupNumberType 10, 33, 3
GO
EXEC dbo.temp_migrate_GroupNumberType 11, 38, 3
GO
---No records were affected BY the above calls

-- clean-up:
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE Name = 'temp_migrate_GroupNumberType' AND TYPE = 'P') DROP PROCEDURE dbo.temp_migrate_GroupNumberType
GO
DELETE FROM GroupNumberType WHERE GroupNumberTypeID < 20
GO
--No Records were affected BY the above call
--SELECT @@TRANCOUNT
--COMMIT
  ------------------------------------------------
  -- Migrate ProviderNumberType to new notation
  -- (same change is going to happen in shared):
--ALTER TABLE
--	ProviderNumberType
--ADD
--	SortOrder INT NOT NULL DEFAULT 0
--GO

INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(21, 'State License Number', '0B', 10)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(22, 'Blue Shield Provider Number', '1B', 20)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(23, 'Medicare Provider Number', '1C', 30)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(24, 'Medicaid Provider Number', '1D', 40)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(25, 'Provider UPIN Number', '1G', 50)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(26, 'CHAMPUS Identification Number', '1H', 60)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(27, 'Employer’s Identification Number', 'EI', 70)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(28, 'Provider Commercial Number', 'G2', 80)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(29, 'Location Number', 'LU', 90)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(30, 'Provider Plan Network Identification Number', 'N5', 100)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(31, 'Social Security Number', 'SY', 120)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(32, 'State Industrial Accident Provider Number', 'X5', 130)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE Name = 'temp_migrate_ProviderNumberType' AND TYPE = 'P') DROP PROCEDURE dbo.temp_migrate_ProviderNumberType
GO
CREATE PROCEDURE dbo.temp_migrate_ProviderNumberType
	@from_id INT, @to_id INT, @attach_to INT
AS
BEGIN
	--SELECT * FROM InsuranceCompanyPlan ICP WHERE ICP.ProviderNumberTypeID = @from_id
	UPDATE InsuranceCompanyPlan
	SET ProviderNumberTypeID = @to_id WHERE ProviderNumberTypeID = @from_id
	--SELECT * FROM InsuranceCompanyPlan ICP WHERE ICP.ProviderNumberTypeID = @to_id

	--SELECT * FROM InsuranceCompanyPlan ICP WHERE ICP.LocalUseProviderNumberTypeID = @from_id
	UPDATE InsuranceCompanyPlan
	SET LocalUseProviderNumberTypeID = @to_id WHERE LocalUseProviderNumberTypeID = @from_id
	--SELECT * FROM InsuranceCompanyPlan ICP WHERE ICP.LocalUseProviderNumberTypeID = @to_id
END
GO
BEGIN TRAN 
EXEC dbo.temp_migrate_ProviderNumberType 1, 28, 2
GO
EXEC dbo.temp_migrate_ProviderNumberType 2, 25, 2
GO
EXEC dbo.temp_migrate_ProviderNumberType 3, 22, 2
GO
EXEC dbo.temp_migrate_ProviderNumberType 4, 24, 2
GO
EXEC dbo.temp_migrate_ProviderNumberType 5, 23, 2
GO
--dbo.temp_migrate_ProviderNumberType 6
--dbo.temp_migrate_ProviderNumberType 7
--dbo.temp_migrate_ProviderNumberType 8
EXEC dbo.temp_migrate_ProviderNumberType 9, 21, 3
GO
EXEC dbo.temp_migrate_ProviderNumberType 11, 22, 3
GO
EXEC dbo.temp_migrate_ProviderNumberType 10, 22, 3
GO
EXEC dbo.temp_migrate_ProviderNumberType 12, 23, 3
GO
EXEC dbo.temp_migrate_ProviderNumberType 13, 24, 3
GO
EXEC dbo.temp_migrate_ProviderNumberType 14, 26, 3
GO
EXEC dbo.temp_migrate_ProviderNumberType 15, 28, 3
GO
EXEC dbo.temp_migrate_ProviderNumberType 16, 32, 3
GO

--COMMIT
--No rows were affected BY the above sp's calls

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE Name = 'temp_migrate_ProviderNumberType' AND TYPE = 'P') DROP PROCEDURE dbo.temp_migrate_ProviderNumberType
GO
DELETE FROM ProviderNumberType WHERE ProviderNumberTypeID IN (1, 2, 3, 4, 5, 9, 10, 11, 12, 13, 14, 15, 16)
GO

UPDATE ProviderNumberType SET SortOrder = 201 WHERE ProviderNumberTypeID = 6
GO
UPDATE ProviderNumberType SET SortOrder = 202 WHERE ProviderNumberTypeID = 7
GO
UPDATE ProviderNumberType SET SortOrder = 203 WHERE ProviderNumberTypeID = 8
GO

SET XACT_ABORT ON
SET ARITHABORT ON
GO

INSERT INTO [dbo].[SharedSystemPropertiesAndValues] ([PropertyName], [Value], [PropertyDescription], [ValueType]) VALUES ('DefaultNewCustomer_DatabasePath', 'C:\Database\', NULL, NULL)
INSERT INTO [dbo].[SharedSystemPropertiesAndValues] ([PropertyName], [Value], [PropertyDescription], [ValueType]) VALUES ('DefaultNewCustomer_DBPassword', 'Never!', NULL, NULL)
INSERT INTO [dbo].[SharedSystemPropertiesAndValues] ([PropertyName], [Value], [PropertyDescription], [ValueType]) VALUES ('DefaultNewCustomer_DBServerName', '', NULL, NULL)
INSERT INTO [dbo].[SharedSystemPropertiesAndValues] ([PropertyName], [Value], [PropertyDescription], [ValueType]) VALUES ('DefaultNewCustomer_DBSuffix', '_prod', NULL, NULL)
INSERT INTO [dbo].[SharedSystemPropertiesAndValues] ([PropertyName], [Value], [PropertyDescription], [ValueType]) VALUES ('DefaultNewCustomer_DBUserName', 'dev', NULL, NULL)
INSERT INTO [dbo].[SharedSystemPropertiesAndValues] ([PropertyName], [Value], [PropertyDescription], [ValueType]) VALUES ('DefaultNewCustomer_EmptyDBName', '[CustomerModel]', NULL, NULL)
INSERT INTO [dbo].[SharedSystemPropertiesAndValues] ([PropertyName], [Value], [PropertyDescription], [ValueType]) VALUES ('DefaultNewCustomer_LogicalFileData', 'Customer_Data', NULL, NULL)
INSERT INTO [dbo].[SharedSystemPropertiesAndValues] ([PropertyName], [Value], [PropertyDescription], [ValueType]) VALUES ('DefaultNewCustomer_LogicalFileLog', 'Customer_Log', NULL, NULL)
INSERT INTO [dbo].[SharedSystemPropertiesAndValues] ([PropertyName], [Value], [PropertyDescription], [ValueType]) VALUES ('DefaultNewCustomer_NewDBNameFormat', 'superbill_{0}{1}', NULL, NULL)
INSERT INTO [dbo].[SharedSystemPropertiesAndValues] ([PropertyName], [Value], [PropertyDescription], [ValueType]) VALUES ('DefaultNewCustomer_PrepopulatedDBName', '[CustomerModelPrepopulated]', NULL, NULL)
INSERT INTO [dbo].[SharedSystemPropertiesAndValues] ([PropertyName], [Value], [PropertyDescription], [ValueType]) VALUES ('TEMP_PATH', 'C:\TEMP\', 'General temporary area on the DB''s file system', NULL)

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
