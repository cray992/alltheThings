IF EXISTS(SELECT 1 FROM sys.objects WHERE name='BillingInvoicing_PostedInvoices' AND type='U')
	DROP TABLE BillingInvoicing_PostedInvoices
GO

CREATE TABLE BillingInvoicing_PostedInvoices(InvoiceRunID INT NOT NULL,
CustomerID INT NOT NULL, 
CONSTRAINT PK_BillinInvoicing_PostedInvoices PRIMARY KEY CLUSTERED (InvoiceRunID, CustomerID),
Amount MONEY, QBOEListID INT, QBOERefNumber VARCHAR(50), PDFPosted BIT, PostedDate DATETIME)

GO

CREATE INDEX nci_BillingInvoicing_PostedInvoices ON BillingInvoicing_PostedInvoices (CustomerID)

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='BillingInvoicing_PostedInvoiceDetails' AND type='U')
	DROP TABLE BillingInvoicing_PostedInvoiceDetails
GO

CREATE TABLE BillingInvoicing_PostedInvoiceDetails(InvoiceRunID INT NOT NULL,
CustomerID INT NOT NULL, 
CompanyName VARCHAR(128), PracticeName VARCHAR(256), 
ProviderName VARCHAR(256), ProviderType VARCHAR(50), StartDate SMALLDATETIME, 
EndDate SMALLDATETIME, KareoProductLineItemID INT, ProRate DECIMAL(18,2), 
Qty DECIMAL(18,2), Allowance DECIMAL(18,2), Price MONEY, BilledQty DECIMAL(18,2), Total MONEY, 
Comment VARCHAR(500), PublicComment VARCHAR(MAX), BillToAddress VARCHAR(2048), PaymentTermsID INT)

GO

CREATE CLUSTERED INDEX CI_BillingInvoicing_PostedInvoiceDetails ON BillingInvoicing_PostedInvoiceDetails (InvoiceRunID, CustomerID)

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='BillingInvoicing_InvoicePostingLog' AND type='U')
	DROP TABLE BillingInvoicing_InvoicePostingLog
GO

CREATE TABLE BillingInvoicing_InvoicePostingLog(InvoiceRunID INT NOT NULL, ChangeXML XML NOT NULL, 
DateLogged DATETIME NOT NULL CONSTRAINT DF_BillingInvoicing_InvoicePostingLog_DateLogged DEFAULT GETDATE())

GO

CREATE INDEX nci_BillingInvoicing_InvoicePostingLog ON BillingInvoicing_InvoicePostingLog(InvoiceRunID)
