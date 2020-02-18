--IF EXISTS(SELECT * FROM sys.objects WHERE name='' AND type='U')
--	DROP TABLE 
--
--GO
--
--CREATE TABLE ()

IF EXISTS(SELECT * FROM sys.objects WHERE name='BillingInvoicing_InvoiceRun' AND type='U')
	DROP TABLE BillingInvoicing_InvoiceRun

GO

CREATE TABLE BillingInvoicing_InvoiceRun(InvoiceRunID INT IDENTITY(1,1) CONSTRAINT PK_BillingInvoice PRIMARY KEY, 
										 InvoiceDate DATETIME, ProcessDate DATETIME, Comments VARCHAR(2000))

GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='BillingInvoicing_Invoices' AND type='U')
	DROP TABLE BillingInvoicing_Invoices

GO

CREATE TABLE BillingInvoicing_Invoices(InvoiceID INT IDENTITY(1,1) CONSTRAINT PK_BillingInvoicing_Invoices PRIMARY KEY, 
									   InvoiceRunID INT NOT NULL, CustomerID INT NOT NULL, Comment VARCHAR(MAX), 
									   Billed BIT CONSTRAINT DF_BillingInvoicing_Invoices_Billed DEFAULT 0)

GO


IF EXISTS(SELECT * FROM sys.objects WHERE name='BillingInvoicing_KareoProductRule' AND type='U')
	DROP TABLE BillingInvoicing_KareoProductRule

GO

CREATE TABLE BillingInvoicing_KareoProductRule(BI_KareoProductRuleID INT IDENTITY(1,1) CONSTRAINT PK_BillingInvoicing_KareoProductRule PRIMARY KEY, 
											   InvoiceRunID INT NOT NULL, KareoProductRuleID INT NOT NULL, KareoProductRuleName VARCHAR(128), KareoProductRuleTypeCode CHAR(1), KareoProductRuleDef XML,
											   EffectiveStartDate DATETIME, EffectiveEndDate DATETIME,  CustomerID INT NULL, EditionTypeID INT NOT NULL,
											   ProviderTypeID INT NULL
											   CONSTRAINT U_BillingInvoicing_KareoProductRule UNIQUE (InvoiceRunID, KareoProductRuleID))

GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='InvoicingInputItem' AND type='U')
	DROP TABLE InvoicingInputItem

GO

CREATE TABLE InvoicingInputItem(InvoicingInputItemID INT IDENTITY(1,1), InvoicingInputItemName VARCHAR(50))

GO

INSERT INTO InvoicingInputItem(InvoicingInputItemName)
VALUES('dms')
INSERT INTO InvoicingInputItem(InvoicingInputItemName)
VALUES('eclaims')
INSERT INTO InvoicingInputItem(InvoicingInputItemName)
VALUES('encounters')
INSERT INTO InvoicingInputItem(InvoicingInputItemName)
VALUES('era')
INSERT INTO InvoicingInputItem(InvoicingInputItemName)
VALUES('ps firstpage')
INSERT INTO InvoicingInputItem(InvoicingInputItemName)
VALUES('ps additionalpage')
INSERT INTO InvoicingInputItem(InvoicingInputItemName)
VALUES('eligibility')
INSERT INTO InvoicingInputItem(InvoicingInputItemName)
VALUES('codecheck')

IF EXISTS(SELECT * FROM sys.objects WHERE name='BillingInvoicing_KareoProductRuleLineItem' AND type='U')
	DROP TABLE BillingInvoicing_KareoProductRuleLineItem

GO

CREATE TABLE BillingInvoicing_KareoProductRuleLineItem(InvoiceRunID INT NOT NULL, KareoProductLineItemID INT NOT NULL, KareoProductLineItemName VARCHAR(128), Price MONEY,
													   InvoicingInputItemID INT, 
													   CONSTRAINT PK_BillingInvoicing_KareoProductRuleLineItem PRIMARY KEY (InvoiceRunID, KareoProductLineItemID))													   

GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='BillingInvoicing_Practices' AND type='U')
	DROP TABLE BillingInvoicing_Practices

GO

CREATE TABLE BillingInvoicing_Practices(InvoiceRunID INT NOT NULL, CustomerID INT NOT NULL, PracticeID INT NOT NULL,
										PracticeName VARCHAR(256), EditionTypeID INT, SupportTypeID INT,
										CONSTRAINT PK_BillingInvoicing_Practices PRIMARY KEY (InvoiceRunID, CustomerID, PracticeID))

GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='BillingInvoicing_KareoProviders' AND type='U')
	DROP TABLE BillingInvoicing_KareoProviders

GO

CREATE TABLE BillingInvoicing_KareoProviders(InvoiceRunID INT NOT NULL, KareoProviderID INT NOT NULL, CustomerID INT, RepresentativeDoctorID INT,
											 ProviderTypeID INT, PromoExpiration DATETIME, CreatedDate DATETIME, ProRate DECIMAL(5,2), KareoProductRuleID INT,
											 CONSTRAINT PK_BillingInvoicing_KareoProviders PRIMARY KEY (InvoiceRunID, KareoProviderID))

GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='BillingInvoicing_CustomerProviders' AND type='U')
	DROP TABLE BillingInvoicing_CustomerProviders

GO

CREATE TABLE BillingInvoicing_CustomerProviders(InvoiceRunID INT NOT NULL, KareoProviderID INT NOT NULL, CustomerID INT NOT NULL, PracticeID INT NOT NULL, DoctorID INT NOT NULL,
												ProviderName VARCHAR(256), Degree VARCHAR(8), CreatedDate DATETIME, ProviderTypeID INT)

GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='BillingInvoicing_InvoicingInputs' AND type='U')
	DROP TABLE BillingInvoicing_InvoicingInputs

GO

CREATE TABLE BillingInvoicing_InvoicingInputs(InvoiceRunID INT NOT NULL, CustomerID INT, PracticeID INT, DoctorID INT, InvoicingInputItemID INT, QTY DECIMAL(18,4))

GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='BillingInvoicing_InvoiceDetail' AND type='U')
	DROP TABLE BillingInvoicing_InvoiceDetail

GO

CREATE TABLE BillingInvoicing_InvoiceDetail(InvoiceDetailID INT IDENTITY(1,1), InvoiceRunID INT NOT NULL, CustomerID INT, PracticeID INT, KareoProviderID INT,
											KareoProductLineItemID INT, StartDate DATETIME, EndDate DATETIME, ProRate DECIMAL(5,2), Qty DECIMAL(18,4), Allowance DECIMAL(18,4), Price MONEY, 
											Deleted BIT CONSTRAINT DF_BillingInvoicing_InvoiceDetail_Deleted DEFAULT 0,
											Posted BIT CONSTRAINT DF_BillingInvoicing_InvoiceDetail_Posted DEFAULT 0, Comment VARCHAR(500), 
											InternalComment BIT CONSTRAINT DF_BillingInvoicing_InvoiceDetail_InternalComment DEFAULT 0,
											Inserted BIT CONSTRAINT DF_BillingInvoicing_Inserted DEFAULT 0)

GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='BillingInvoicing_InvoiceEdits' AND type='U')
	DROP TABLE BillingInvoicing_InvoiceEdits

GO

CREATE TABLE BillingInvoicing_InvoiceEdits(InvoiceDetailID INT CONSTRAINT PK_BillingInvoicing_InvoiceEdits PRIMARY KEY, 
										   InvoiceRunID INT, KareoProductLineItemID INT, StartDate DATETIME, EndDate DATETIME, 
										   ProRate DECIMAL(5,2), Qty DECIMAL(18,4), Allowance DECIMAL(18,4), Price MONEY)

GO
