IF NOT EXISTS(select 1
		  from sys.schemas
		  where name='invoicing')
BEGIN
	EXEC ('CREATE SCHEMA invoicing AUTHORIZATION dbo')
END

GO

IF EXISTS(SELECT 1 
		  FROM sys.objects so inner join sys.schemas sc
		  ON so.schema_id=sc.schema_id
		  WHERE so.name='PaymentTerms' AND sc.name='invoicing' and so.type='U')
	DROP TABLE invoicing.PaymentTerms
GO

CREATE TABLE invoicing.PaymentTerms(PaymentTermsID INT IDENTITY(1,1) NOT NULL
CONSTRAINT PK_invoicing_PaymentTerms PRIMARY KEY CLUSTERED,
PaymentTermsName VARCHAR(512) NOT NULL CONSTRAINT UX_PaymentTermsName UNIQUE,
DefaultMessage VARCHAR(MAX) NOT NULL,
Active TINYINT NOT NULL,
CreatedDate DATETIME NOT NULL CONSTRAINT DF_CreatedDate DEFAULT GETDATE(),
ModifiedDate DATETIME NULL)

GO

INSERT INTO invoicing.PaymentTerms(PaymentTermsName, Active, DefaultMessage)
VALUES('Pay By Check', 1, 'Your payment by check is due no later than the 25th of the month.')
INSERT INTO invoicing.PaymentTerms(PaymentTermsName, Active, DefaultMessage)
VALUES('E-Payment', 1, 'Your electronic payment will be processed by the 15th of the month.  You do not need to mail a check.')

GO

IF EXISTS(SELECT 1 
		  FROM sys.objects so inner join sys.schemas sc
		  ON so.schema_id=sc.schema_id
		  WHERE so.name='CustomerSettings' AND sc.name='invoicing' and so.type='U')
	DROP TABLE invoicing.CustomerSettings
GO

CREATE TABLE invoicing.CustomerSettings(CustomerID INT NOT NULL
CONSTRAINT PK_invoicing_CustomerSettings PRIMARY KEY CLUSTERED,
CustomerPriceModelID INT NULL,
CustomerLeadTypeID INT NULL,
PaymentTermsID INT NULL,
EmailInvoice TINYINT NULL,
InvoiceMessage VARCHAR(MAX) NULL,
CreatedDate DATETIME NOT NULL CONSTRAINT DF_invoicing_CustomerSettings_CreatedDate DEFAULT GETDATE(),
ModifiedDate DATETIME NULL)

GO

INSERT INTO invoicing.CustomerSettings(CustomerID, CustomerPriceModelID, CustomerLeadTypeID)
SELECT CustomerID, CustomerPriceModelID, CustomerLeadTypeID
FROM Customer

GO

--ALTER TABLE BillingInvoicing_Customer ADD PaymentTermsID INT NULL, EmailInvoice TINYINT NULL,
--InvoiceMessage VARCHAR(MAX) NULL

GO

IF EXISTS(SELECT 1 
		  FROM sys.objects so inner join sys.schemas sc
		  ON so.schema_id=sc.schema_id
		  WHERE so.name='CustomerPriceModel' AND sc.name='invoicing' and so.type='U')
	DROP TABLE invoicing.CustomerPriceModel
GO

CREATE TABLE invoicing.CustomerPriceModel(
CustomerPriceModelID INT IDENTITY(1,1) NOT NULL
CONSTRAINT PK_invoicing_CustomerPriceModel PRIMARY KEY CLUSTERED,
CustomerPriceModelDescription VARCHAR(50) NOT NULL CONSTRAINT UX_invoicing_CustomerPriceModel UNIQUE,
Active TINYINT NOT NULL)

GO

INSERT INTO invoicing.CustomerPriceModel(CustomerPriceModelDescription, Active)
SELECT CustomerPriceModelDescription, Active
FROM CustomerPriceModel
ORDER BY CustomerPriceModelID

GO

IF EXISTS(SELECT 1 
		  FROM sys.objects so inner join sys.schemas sc
		  ON so.schema_id=sc.schema_id
		  WHERE so.name='CustomerLeadType' AND sc.name='invoicing' and so.type='U')
	DROP TABLE invoicing.CustomerLeadType
GO

CREATE TABLE invoicing.CustomerLeadType(CustomerLeadTypeID INT IDENTITY(1,1) NOT NULL
CONSTRAINT PK_invoicing_CustomerLeadType PRIMARY KEY CLUSTERED,
CustomerLeadDescription VARCHAR(50) NOT NULL CONSTRAINT UX_invoicing_CustomerLeadType UNIQUE,
Active TINYINT NOT NULL)

GO

INSERT INTO invoicing.CustomerLeadType(CustomerLeadDescription, Active)
SELECT CustomerLeadDescription, Active
FROM CustomerLeadType
ORDER BY CustomerLeadTypeID

GO

IF EXISTS(SELECT 1 
		  FROM sys.objects so inner join sys.schemas sc
		  ON so.schema_id=sc.schema_id
		  WHERE so.name='CustomerEmailRecipient' AND sc.name='invoicing' and so.type='U')
	DROP TABLE invoicing.CustomerEmailRecipient
GO

CREATE TABLE invoicing.CustomerEmailRecipient(
CustomerEmailRecipientID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_invoicing_CustomerEmailRecipient PRIMARY KEY NONCLUSTERED,
CustomerID INT NOT NULL,
Email VARCHAR(256) NOT NULL,
CONSTRAINT UX_invoicing_CustomerEmailRecipient UNIQUE (CustomerID, Email))

GO

IF EXISTS(SELECT 1 
		  FROM sys.objects so inner join sys.schemas sc
		  ON so.schema_id=sc.schema_id
		  WHERE so.name='SentEmailLog' AND sc.name='invoicing' and so.type='U')
	DROP TABLE invoicing.SentEmailLog
GO

CREATE TABLE invoicing.SentEmailLog(
CustomerID INT NOT NULL, InvoiceID INT NOT NULL,
EmailRecipients VARCHAR(MAX) NULL, 
SendDate DATETIME NOT NULL CONSTRAINT DF_invoicing_SentEmailLog DEFAULT GETDATE())

GO

CREATE CLUSTERED INDEX CI_invoicing_SentEmailLog ON invoicing.SentEmailLog 
(CustomerID, InvoiceID)