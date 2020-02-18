USE ClearinghousePayers
GO

ALTER TABLE dbo.Payer ADD
	Active bit NULL
GO

ALTER TABLE dbo.Payer ADD CONSTRAINT
	DF_Payer_Active DEFAULT 1 FOR Active
GO

UPDATE	[dbo].[Payer]
SET		[Active] = 1
GO

/* Deactivate OfficeAlly payers ... */
UPDATE	[dbo].[Payer]
SET		[Active] = 0
WHERE	[PayerSourceID] = 2 
GO

/* Add EIN/SSN type ... */
ALTER TABLE dbo.EnrollmentOrder ADD
	ProviderEINType char(3) NULL
GO