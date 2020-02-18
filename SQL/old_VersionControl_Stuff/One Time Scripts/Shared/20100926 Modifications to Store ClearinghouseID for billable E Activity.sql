IF EXISTS(SELECT * FROM sys.indexes WHERE name='IX_BillingInvoicing_InvoicingInputs_ClearinghouseDetails_InvoiceRunID')
	DROP INDEX BillingInvoicing_InvoicingInputs_ClearinghouseDetails.IX_BillingInvoicing_InvoicingInputs_ClearinghouseDetails_InvoiceRunID

GO

IF EXISTS(SELECT 1 FROM sys.objects so WHERE name='BillingInvoicing_InvoicingInputs_ClearinghouseDetails' AND type='U')
	DROP TABLE BillingInvoicing_InvoicingInputs_ClearinghouseDetails

GO

CREATE TABLE BillingInvoicing_InvoicingInputs_ClearinghouseDetails(InvoiceRunID INT, CustomerID INT, PracticeID INT, DoctorID INT, InvoicingInputItemID INT,
																   ClearinghouseID INT, Qty INT)
GO

CREATE INDEX IX_BillingInvoicing_InvoicingInputs_ClearinghouseDetails_InvoiceRunID ON BillingInvoicing_InvoicingInputs_ClearinghouseDetails (InvoiceRunID)
