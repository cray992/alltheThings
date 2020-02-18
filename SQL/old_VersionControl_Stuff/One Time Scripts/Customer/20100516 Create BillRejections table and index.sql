IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='nci_BillRejections_Dt')
	DROP INDEX BillRejections.nci_BillRejections_Dt

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='BillRejections' AND type='U')
	DROP TABLE BillRejections
GO

CREATE TABLE dbo.BillRejections(PracticeID INT NOT NULL, BillBatchID INT NOT NULL, ReferenceID INT NOT NULL,
CONSTRAINT PK_BillRejections PRIMARY KEY CLUSTERED (PracticeID, BillBatchID, ReferenceID),
FirstRejectedDate DATETIME NOT NULL)

GO

CREATE INDEX nci_BillRejections_Dt ON dbo.BillRejections(FirstRejectedDate)

GO

IF NOT EXISTS(SELECT 1 FROM sys.objects so inner join sys.columns sc
					   ON so.object_id=sc.object_id 
					   WHERE so.name='BillTransmission' AND so.type='U' and sc.name='ParsedPayerNumber')
	ALTER TABLE BillTransmission ADD ParsedPayerNumber VARCHAR(32) NULL


