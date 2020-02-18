IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='Customer' AND column_name='UseUpdatedSecondaryERALogic' )
	ALTER TABLE dbo.Customer
	ADD UseUpdatedSecondaryERALogic BIT NOT NULL
	CONSTRAINT DF_Customer_UseUpdatedSecondaryERALogic DEFAULT CAST(0 AS BIT)

GO

UPDATE dbo.Customer
SET UseUpdatedSecondaryERALogic = 1
WHERE CustomerID IN (6683,7143,6369)