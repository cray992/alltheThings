--IF EXISTS(SELECT 1 FROM sys.objects WHERE name='BillingInvoicing_CustomerDoc' AND type='U')
--	DROP TABLE BillingInvoicing_CustomerDoc
--
--GO
--
--CREATE TABLE BillingInvoicing_CustomerDoc(InvoiceRunID INT NOT NULL, CustomerID INT NOT NULL,
--CONSTRAINT PK_BillingInvoicing_CustomerDoc PRIMARY KEY CLUSTERED (InvoiceRunID, CustomerID),
--CustomerDoc XML NOT NULL)

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='BillingInvoicing_KareoCustomerContract' AND type='U')
	DROP TABLE BillingInvoicing_KareoCustomerContract

GO

CREATE TABLE BillingInvoicing_KareoCustomerContract(InvoiceRunID INT NOT NULL, KareoCustomerContractID INT NOT NULL,
CONSTRAINT PK_BillingInvoicing_KareoCustomerContract PRIMARY KEY CLUSTERED (InvoiceRunID, KareoCustomerContractID),
KareoCustomerContract XML NOT NULL, isDefault BIT NOT NULL)

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='KareoCustomerContract' AND type='U')
	DROP TABLE KareoCustomerContract

GO

CREATE TABLE KareoCustomerContract(KareoCustomerContractID INT IDENTITY(1,1) NOT NULL 
CONSTRAINT PK_KareoCustomerContract PRIMARY KEY CLUSTERED,
ContractName VARCHAR(256) NOT NULL, ContractDescription VARCHAR(MAX) NULL,
KareoCustomerContract XML NOT NULL,
Active TINYINT NOT NULL CONSTRAINT DF_KareoCustomerContract_Active DEFAULT 1,
EffectiveStartDate DATETIME NULL,
EffectiveEndDate DATETIME NULL,
CreatedDate DATETIME NOT NULL CONSTRAINT DF_KareoCustomerContract_CreatedDate DEFAULT GETDATE(),
ModifiedDate DATETIME NOT NULL CONSTRAINT DF_KareoCustomerContradct_ModifiedDate DEFAULT GETDATE(),
CreatedByUserID INT NULL,
ModifiedByUserID INT NULL, isDefault BIT NOT NULL CONSTRAINT DF_KareoCustomerContract_isDefault DEFAULT 0)

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='KareoCustomerContract_CustomerMap' AND type='U')
	DROP TABLE KareoCustomerContract_CustomerMap

GO

CREATE TABLE KareoCustomerContract_CustomerMap(KareoCustomerContractID INT NOT NULL, CustomerID INT NOT NULL,
CONSTRAINT PK_KareoCustomerContract_CustomerMap PRIMARY KEY CLUSTERED (KareoCustomerContractID, CustomerID))

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='BillingInvoicing_CustomerContract_CustomerMap' AND type='U')
	DROP TABLE BillingInvoicing_CustomerContract_CustomerMap

GO

CREATE TABLE BillingInvoicing_CustomerContract_CustomerMap(InvoiceRunID INT NOT NULL, 
KareoCustomerContractID INT NOT NULL, CustomerID INT NOT NULL,
CONSTRAINT PK_BillingInvoicing_CustomerContract_CustomerMap 
PRIMARY KEY CLUSTERED (InvoiceRunID, KareoCustomerContractID, CustomerID))

GO

ALTER TABLE BillingInvoicing_InvoiceDetail ADD Sort INT NULL

GO

ALTER TABLE BillingInvoicing_Invoices ADD DoNotPrint BIT NULL