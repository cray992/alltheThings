GO
-----------------------------------------------------------
-- Case 21000
-- Billing/Invoicing - Add a picklist field to the provider record with label “Type:” 
-----------------------------------------------------------
IF EXISTS(SELECT * FROM sys.objects WHERE name='ProviderType' AND type='U')
	DROP TABLE ProviderType
GO

CREATE TABLE ProviderType(ProviderTypeID INT IDENTITY(1,1), ProviderTypeName VARCHAR(50) NOT NULL, SortOrder SMALLINT NOT NULL, Active BIT CONSTRAINT DF_ProviderType_Active DEFAULT 1)

GO

INSERT INTO ProviderType(ProviderTypeName, SortOrder, Active)
VALUES('Normal Provider',0,1)

INSERT INTO ProviderType(ProviderTypeName, SortOrder, Active)
VALUES('Mid-Level Provider',1,1)

INSERT INTO ProviderType(ProviderTypeName, SortOrder, Active)
VALUES('Part-Time Provider',2,1)

INSERT INTO ProviderType(ProviderTypeName, SortOrder, Active)
VALUES('Free Promotion',3,1)

GO

ALTER TABLE Doctor ADD ProviderTypeID INT NULL

GO