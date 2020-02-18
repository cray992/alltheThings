IF EXISTS(SELECT * FROM sys.objects WHERE name='PK_DMSDocumentToRecordAssociation')
	ALTER TABLE DMSDocumentToRecordAssociation DROP CONSTRAINT PK_DMSDocumentToRecordAssociation
GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='CI_DMSDocumentToRecordAssociation')
	DROP INDEX DMSDocumentToRecordAssociation.CI_DMSDocumentToRecordAssociation
GO

CREATE CLUSTERED INDEX CI_DMSDocumentToRecordAssociation ON dbo.DMSDocumentToRecordAssociation
	(
	RecordTypeID,
	RecordID DESC,
	DMSDocumentID DESC
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 80, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO