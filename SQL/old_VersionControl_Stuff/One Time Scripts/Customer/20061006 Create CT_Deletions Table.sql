
IF EXISTS(SELECT * FROM sys.objects WHERE name='CT_Deletions' AND type='U')
	DROP TABLE CT_Deletions
GO


CREATE TABLE CT_Deletions(
	[ClaimTransactionID] [int] ,
	[ClaimTransactionTypeCode] [char](3),
	[ClaimID] [int] NOT NULL,
	[Amount] [money] NULL,
	[Quantity] [int] NULL,
	[Code] [varchar](50) ,
	[ReferenceID] [int] NULL,
	[ReferenceData] [varchar](250) ,
	[CreatedDate] [datetime] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[PatientID] [int] NULL,
	[PracticeID] [int] NULL,
	[BatchKey] [uniqueidentifier] NULL,
	[Original_ClaimTransactionID] [int] NULL,
	[Claim_ProviderID] [int] NULL,
	[PostingDate] [datetime] NOT NULL,
	[CreatedUserID] [int] NULL,
	[ModifiedUserID] [int] NULL,
	DeletionDate DATETIME CONSTRAINT DF_CT_Deletions DEFAULT GETDATE()
)

GO

CREATE INDEX IX_CT_Deletions
ON CT_Deletions(ClaimID)
GO