IF EXISTS(SELECT 1 FROM sys.objects WHERE name='BillingInvoicing_Customer' AND type='U')
	DROP TABLE BillingInvoicing_Customer
GO

CREATE TABLE BillingInvoicing_Customer(InvoiceRunID INT NOT NULL, CustomerID INT NOT NULL,
CONSTRAINT PK_BillingInvoicing_Customer PRIMARY KEY CLUSTERED (InvoiceRunID, CustomerID),
PricingModel CHAR(1))

