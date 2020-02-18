IF EXISTS(SELECT 1 FROM sys.objects WHERE name='CustomerLeadType' AND type='U')
	DROP TABLE CustomerLeadType

GO

CREATE TABLE CustomerLeadType(CustomerLeadTypeID INT NOT NULL IDENTITY(1,1)
CONSTRAINT PK_CustomerLeadType PRIMARY KEY CLUSTERED, CustomerLeadDescription VARCHAR(50) NOT NULL, Active TINYINT NOT NULL)

GO

INSERT INTO CustomerLeadType(CustomerLeadDescription, Active)
VALUES('Billing Service',1)

GO

INSERT INTO CustomerLeadType(CustomerLeadDescription, Active)
VALUES('Physician Practice',1)

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='CustomerPriceModel' AND type='U')
	DROP TABLE CustomerPriceModel

GO

CREATE TABLE CustomerPriceModel(CustomerPriceModelID INT NOT NULL IDENTITY(1,1)
CONSTRAINT PK_CustomerPriceModel PRIMARY KEY CLUSTERED, CustomerPriceModelDescription VARCHAR(50) NOT NULL, Active TINYINT NOT NULL)

GO

INSERT INTO CustomerPriceModel(CustomerPriceModelDescription, Active)
VALUES('Old',1)
INSERT INTO CustomerPriceModel(CustomerPriceModelDescription, Active)
VALUES('New',1)
INSERT INTO CustomerPriceModel(CustomerPriceModelDescription, Active)
VALUES('Transactional',1)

GO

ALTER TABLE Customer ADD CustomerPriceModelID INT NULL, CustomerLeadTypeID INT NULL

GO

ALTER TABLE BillingInvoicing_Customer ADD CustomerPriceModelID INT NULL, CustomerLeadTypeID INT NULL


