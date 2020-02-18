/*

DATABASE UPDATE SCRIPT

v1.18.1664 to v.1.19.xxxx
*/
----------------------------------
--EXEC sp_change_users_login @Action = 'Update_One', @UserNamePattern = 'dev', @LoginName = 'dev'

--BEGIN TRAN 
----------------------------------

--case 2128

ALTER TABLE dbo.Payment
	ADD SourceEncounterID INT NULL 
GO

ALTER TABLE dbo.Payment
	ADD CONSTRAINT [FK_Payment_Encounter] FOREIGN KEY 
	(
		[SourceEncounterID]
	) REFERENCES [Encounter] (
		[EncounterID]
	)
GO


INSERT INTO PaymentPatient (PaymentID, PatientID)
(
SELECT 
	PaymentID, PayerID
FROM 
	Payment P 
WHERE 
	P.[Description] = 'PATIENT PAYMENT MADE AT TIME OF ENCOUNTER' 
	AND NOT EXISTS 
		(SELECT PatientID FROM PaymentPatient PP WHERE PP.PaymentID = P.PaymentID)
)

GO


----------------------------------
--ROLLBACK
--COMMIT

-- case 2132

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Report'
)
DROP TABLE dbo.Report

GO
--===========================================================================

CREATE TABLE dbo.Report (
	ReportID INT IDENTITY(1,1) NOT NULL,
	ReportCategoryID INT NOT NULL,

	DisplayOrder INT NOT NULL,
	Image VARCHAR(128) NOT NULL,
	Name VARCHAR(128) NOT NULL,
	Description VARCHAR(256),
	TaskName VARCHAR(128) NOT NULL,
	ReportServer VARCHAR(128) NOT NULL,
	ReportPath VARCHAR(256) NOT NULL,
	ReportParameters TEXT,

	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	TIMESTAMP
)
GO
ALTER TABLE dbo.Report
ADD CONSTRAINT PK_Report
PRIMARY KEY (ReportID)
go
----------------------------------

-- case 2132

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'ReportCategory'
)
DROP TABLE dbo.ReportCategory
go
--===========================================================================

CREATE TABLE dbo.ReportCategory (
	ReportCategoryID INT IDENTITY(1,1) NOT NULL,

	DisplayOrder INT NOT NULL,
	Image VARCHAR(128) NOT NULL,
	Name VARCHAR(128) NOT NULL,
	Description VARCHAR(256),
	TaskName VARCHAR(128) NOT NULL,
	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	TIMESTAMP
)
go
ALTER TABLE dbo.ReportCategory
ADD CONSTRAINT PK_ReportCategory
PRIMARY KEY (ReportCategoryID)
go
ALTER TABLE dbo.Report
ADD CONSTRAINT FK_Report_ReportCategory
FOREIGN KEY (ReportCategoryID)
REFERENCES ReportCategory(ReportCategoryID)
go
INSERT INTO ReportCategory (DisplayOrder, Image, Name, Description, TaskName) values (
	1, '[[image[Practice.Reports.Images.reports.gif]]]', 'Key Indicators', 'Key Indicators', 'Report List'
)
INSERT INTO ReportCategory (DisplayOrder, Image, Name, Description, TaskName) values (
	2, '[[image[Practice.Reports.Images.reports.gif]]]', 'Payments', 'Payments', 'Report List'
)
INSERT INTO ReportCategory (DisplayOrder, Image, Name, Description, TaskName) values (
	3, '[[image[Practice.Reports.Images.reports.gif]]]', 'Accounts Receivable', 'Accounts Receivable', 'Report List'
)
INSERT INTO ReportCategory (DisplayOrder, Image, Name, Description, TaskName) values (
	4, '[[image[Practice.Reports.Images.reports.gif]]]', 'Productivity & Analysis', 'Productivity & Analysis', 'Report List'
)
INSERT INTO ReportCategory (DisplayOrder, Image, Name, Description, TaskName) values (
	5, '[[image[Practice.Reports.Images.reports.gif]]]', 'Patients', 'Patients', 'Report List'
)

----------------------------------

-- case 2231

ALTER TABLE [dbo].[ClearinghouseResponse] ADD [ProcessedFlag] [bit] NOT NULL DEFAULT 0 WITH VALUES
ALTER TABLE [dbo].[ClearinghouseResponse] ADD [Title] [varchar](256)
DROP TABLE PaymentAdvice
DROP TABLE PaymentAdviceFileType
GO

------------------------------------
-- case 2298:
-- note: keep the name "IX_UsersEmailAddress" as it is hardcoded in C# (Admin, validating Save of User detail).
UPDATE Users SET EmailAddress = CAST(UserID AS VARCHAR(20)) WHERE EmailAddress IS NULL OR EmailAddress = 'n/a'
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [UX_UsersEmailAddress] UNIQUE NONCLUSTERED ([EmailAddress])
GO

------------------------------------
-- case 2303:
--ALTER TABLE [dbo].[Claim] ADD [ClearinghouseTrackingNumber] [varchar](64) NULL
--ALTER TABLE [dbo].[Claim] ADD [PayerTrackingNumber] [varchar](64) NULL
--ALTER TABLE [dbo].[Claim] ADD [ClearinghouseProcessingStatus] [varchar](1) NULL
--ALTER TABLE [dbo].[Claim] ADD [PayerProcessingStatus] [varchar](256) NULL
--ALTER TABLE [dbo].[Claim] ADD [ClearinghousePayer] [varchar](64) NULL
--INSERT ClaimTransactionType (ClaimTransactionTypeCode, TypeName) VALUES ('EDI', 'PROXYMED Response')
GO

--------------------------------------
-- case 2296:
DROP TABLE PracticeToCodingTemplate
ALTER TABLE [dbo].[CodingTemplate] ADD [PracticeID] int NULL
GO
UPDATE [dbo].[CodingTemplate] SET PracticeID = 27
UPDATE [dbo].[CodingTemplate] SET PracticeID = 13 WHERE CodingTemplateID = 5

----------------------------------
-- case 1858

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'RefundStatusCode'
)
DROP TABLE dbo.RefundStatusCode
GO
--===========================================================================

CREATE TABLE dbo.RefundStatusCode (
	RefundStatusCode CHAR(1) NOT NULL,
	[Description] VARCHAR(50) NOT NULL,
	TIMESTAMP
)
GO

ALTER TABLE dbo.RefundStatusCode
ADD CONSTRAINT PK_RefundStatusCode
PRIMARY KEY (RefundStatusCode)
GO
INSERT INTO RefundStatusCode (RefundStatusCode, [Description]) VALUES ('D', 'Draft')
INSERT INTO RefundStatusCode (RefundStatusCode, [Description]) VALUES ('I', 'Issued')

      -----------------------------------------------------------------------

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Refund'
)
DROP TABLE dbo.Refund
GO
--===========================================================================

CREATE TABLE dbo.Refund (
	RefundID INT IDENTITY(1,1) NOT NULL,

	PracticeID INT NOT NULL,
	RefundDate DATETIME NOT NULL DEFAULT (GETDATE()),
	RefundAmount MONEY NOT NULL DEFAULT (0),
	RefundStatusCode CHAR(1) NOT NULL,			-- points to RefundStatusCode table
	PaymentMethodCode CHAR(1) NOT NULL,			-- points to PaymentMethodCode table
	RecipientTypeCode CHAR(1) NOT NULL,			-- points to PayerTypeCode, P I O
	RecipientID INT,
	ReferenceNumber VARCHAR(64),				-- tracking #, or check #, or...
	[Description] VARCHAR(250),

	CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	TIMESTAMP
)

ALTER TABLE dbo.Refund
ADD CONSTRAINT PK_Refund
PRIMARY KEY (RefundID)

ALTER TABLE dbo.Refund
ADD CONSTRAINT FK_Refund_Practice
FOREIGN KEY (PracticeID)
REFERENCES Practice(PracticeID)

ALTER TABLE dbo.Refund
ADD CONSTRAINT FK_Refund_RefundStatusCode
FOREIGN KEY (RefundStatusCode)
REFERENCES RefundStatusCode(RefundStatusCode)

ALTER TABLE dbo.Refund
ADD CONSTRAINT FK_Refund_RecipientTypeCode
FOREIGN KEY (RecipientTypeCode)
REFERENCES PayerTypeCode(PayerTypeCode)

ALTER TABLE dbo.Refund
ADD CONSTRAINT FK_Refund_PaymentMethodCode
FOREIGN KEY (PaymentMethodCode)
REFERENCES PaymentMethodCode(PaymentMethodCode)

GO

      -----------------------------------------------------------------------

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'RefundToPayments'
)
DROP TABLE dbo.RefundToPayments

--===========================================================================
go
CREATE TABLE dbo.RefundToPayments (
	RefundToPaymentsID INT IDENTITY(1,1) NOT NULL,

	RefundID INT NOT NULL,
	PaymentID INT NOT NULL,
	Amount MONEY NOT NULL DEFAULT (0),

	CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	TIMESTAMP
)

ALTER TABLE dbo.RefundToPayments
ADD CONSTRAINT PK_RefundToPayments
PRIMARY KEY (RefundToPaymentsID)

ALTER TABLE dbo.RefundToPayments
ADD CONSTRAINT FK_RefundToPayments_RefundID
FOREIGN KEY (RefundID)
REFERENCES Refund(RefundID)

ALTER TABLE dbo.RefundToPayments
ADD CONSTRAINT FK_RefundToPayments_PaymentID
FOREIGN KEY (PaymentID)
REFERENCES Payment(PaymentID)

----------------------------------

--Add speciality
IF NOT EXISTS(SELECT * FROM ProviderSpecialty WHERE ProviderSpecialtyCode = '0000000001')
BEGIN
	INSERT INTO [dbo].[ProviderSpecialty] ([ProviderSpecialtyCode], [SpecialtyName], [Description]) 
	VALUES ('0000000001', 'Clinical Psychologist', NULL)
END
GO

----------------------------------
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
PRINT N'Altering [dbo].[ReportEdition]'
GO
ALTER TABLE [dbo].[ReportEdition] ADD
[ReportContentsEMF] [image] NULL
GO
