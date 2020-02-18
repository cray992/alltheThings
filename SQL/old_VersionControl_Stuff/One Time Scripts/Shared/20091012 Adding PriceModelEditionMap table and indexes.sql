IF EXISTS(SELECT 1 FROM sys.objects WHERE name='BillingInvoicing_EditionMap' AND type='U')
	DROP TABLE BillingInvoicing_EditionMap
GO

CREATE TABLE BillingInvoicing_EditionMap(CustomerPriceModelID INT NOT NULL, EditionTypeID INT NOT NULL,
CONSTRAINT PK_BillingInvoicing_EditionMap PRIMARY KEY CLUSTERED (CustomerPriceModelID, EditionTypeID),
EditionTypeName VARCHAR(128), EditionTypeDescription VARCHAR(256), BillingSort TINYINT, Active BIT)

INSERT INTO BillingInvoicing_EditionMap(CustomerPriceModelID, EditionTypeID, EditionTypeName, EditionTypeDescription, BillingSort, Active)
VALUES(1,3,'Basic I', 'Basic I Edition',1,1)
INSERT INTO BillingInvoicing_EditionMap(CustomerPriceModelID, EditionTypeID, EditionTypeName, EditionTypeDescription, BillingSort, Active)
VALUES(1,2,'Team', 'Team Edition',2,1)
INSERT INTO BillingInvoicing_EditionMap(CustomerPriceModelID, EditionTypeID, EditionTypeName, EditionTypeDescription, BillingSort, Active)
VALUES(1,1,'Enterprise', 'Enterprise Edition',3,1)
INSERT INTO BillingInvoicing_EditionMap(CustomerPriceModelID, EditionTypeID, EditionTypeName, EditionTypeDescription, BillingSort, Active)
VALUES(2,3,'Basic', 'Basic Edition',4,1)
INSERT INTO BillingInvoicing_EditionMap(CustomerPriceModelID, EditionTypeID, EditionTypeName, EditionTypeDescription, BillingSort, Active)
VALUES(2,2,'Plus', 'Plus Edition',5,1)
INSERT INTO BillingInvoicing_EditionMap(CustomerPriceModelID, EditionTypeID, EditionTypeName, EditionTypeDescription, BillingSort, Active)
VALUES(2,1,'Complete', 'Complete Edition',6,1)
INSERT INTO BillingInvoicing_EditionMap(CustomerPriceModelID, EditionTypeID, EditionTypeName, EditionTypeDescription, BillingSort, Active)
VALUES(2,7,'Max', 'Max Edition',7,1)
INSERT INTO BillingInvoicing_EditionMap(CustomerPriceModelID, EditionTypeID, EditionTypeName, EditionTypeDescription, BillingSort, Active)
VALUES(3,3,'Complete', 'Complete Edition',0,1)
INSERT INTO BillingInvoicing_EditionMap(CustomerPriceModelID, EditionTypeID, EditionTypeName, EditionTypeDescription, BillingSort, Active)
VALUES(3,2,'Complete', 'Complete Edition',0,1)
INSERT INTO BillingInvoicing_EditionMap(CustomerPriceModelID, EditionTypeID, EditionTypeName, EditionTypeDescription, BillingSort, Active)
VALUES(3,1,'Complete', 'Complete Edition',0,1)
INSERT INTO BillingInvoicing_EditionMap(CustomerPriceModelID, EditionTypeID, EditionTypeName, EditionTypeDescription, BillingSort, Active)
VALUES(3,7,'Complete', 'Complete Edition',0,1)

GO

CREATE CLUSTERED INDEX [ci_InvoiceRunID_CustomerID_DoctorID] ON [dbo].[BillingInvoicing_InvoicingInputs] 
(
	[InvoiceRunID] DESC,
	[CustomerID] ASC,
	[DoctorID] ASC
)

GO

CREATE INDEX nci_InvoicingInputItemID ON dbo.BillingInvoicing_InvoicingInputs (InvoiceRunID, InvoicingInputItemID)
