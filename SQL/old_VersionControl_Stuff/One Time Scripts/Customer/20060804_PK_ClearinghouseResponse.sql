/*
   Date: Friday, August 04, 200611:18:53 PM
   Scripted From: kdb04, superbill_0001_prod
   Purpose: To replace the existing clustered index.
*/

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
ALTER TABLE dbo.ClearinghouseResponse
	DROP CONSTRAINT FK_ClearinghouseResponse_Payment
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ClearinghouseResponse
	DROP CONSTRAINT DF__Clearingh__Revie__1DF06171
GO
ALTER TABLE dbo.ClearinghouseResponse
	DROP CONSTRAINT DF__Clearingh__Proce__5BA37B27
GO
CREATE TABLE dbo.Tmp_ClearinghouseResponse
	(
	ClearinghouseResponseID int NOT NULL IDENTITY (1, 1),
	ResponseType int NOT NULL,
	PracticeID int NOT NULL,
	SourceAddress varchar(100) NULL,
	FileName varchar(100) NULL,
	FileReceiveDate datetime NULL,
	FileContents ntext NULL,
	ReviewedFlag bit NULL,
	TIMESTAMP timestamp NULL,
	ProcessedFlag bit NOT NULL,
	Title varchar(256) NULL,
	PaymentID int NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ClearinghouseResponse ADD CONSTRAINT
	DF__Clearingh__Revie__1DF06171 DEFAULT (0) FOR ReviewedFlag
GO
ALTER TABLE dbo.Tmp_ClearinghouseResponse ADD CONSTRAINT
	DF__Clearingh__Proce__5BA37B27 DEFAULT (0) FOR ProcessedFlag
GO
SET IDENTITY_INSERT dbo.Tmp_ClearinghouseResponse ON
GO
IF EXISTS(SELECT * FROM dbo.ClearinghouseResponse)
	 EXEC('INSERT INTO dbo.Tmp_ClearinghouseResponse (ClearinghouseResponseID, ResponseType, PracticeID, SourceAddress, FileName, FileReceiveDate, FileContents, ReviewedFlag, ProcessedFlag, Title, PaymentID)
		SELECT ClearinghouseResponseID, ResponseType, PracticeID, SourceAddress, FileName, FileReceiveDate, FileContents, ReviewedFlag, ProcessedFlag, Title, PaymentID FROM dbo.ClearinghouseResponse WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_ClearinghouseResponse OFF
GO
DROP TABLE dbo.ClearinghouseResponse
GO
EXECUTE sp_rename N'dbo.Tmp_ClearinghouseResponse', N'ClearinghouseResponse', 'OBJECT' 
GO
ALTER TABLE dbo.ClearinghouseResponse ADD CONSTRAINT
	PK_ClearinghouseResponse PRIMARY KEY CLUSTERED 
	(
	PracticeID,
	ResponseType,
	ClearinghouseResponseID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.ClearinghouseResponse ADD CONSTRAINT
	FK_ClearinghouseResponse_Payment FOREIGN KEY
	(
	PaymentID
	) REFERENCES dbo.Payment
	(
	PaymentID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
