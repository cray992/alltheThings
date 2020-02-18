IF EXISTS(SELECT 1 FROM sys.objects WHERE name='BillingInvoicing_ClosingDate' AND type='U')
	DROP TABLE BillingInvoicing_ClosingDate

GO

CREATE TABLE dbo.BillingInvoicing_ClosingDate(ClosingDateID INT IDENTITY(1,1) 
CONSTRAINT PK_BillingInvoicing_ClosingDate PRIMARY KEY CLUSTERED, ClosingDate DATETIME NOT NULL,
EntryDate DATETIME NOT NULL CONSTRAINT DF_EntryDate_BillingInvoicing_ClosingDate DEFAULT GETDATE())

GO

INSERT INTO dbo.BillingInvoicing_ClosingDate(ClosingDate)
VALUES('3-1-10')

INSERT INTO dbo.BillingInvoicing_ClosingDate(ClosingDate)
VALUES('4-30-10')

