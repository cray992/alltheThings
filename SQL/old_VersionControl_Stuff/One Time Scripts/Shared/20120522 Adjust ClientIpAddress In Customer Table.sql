USE Superbill_Shared

GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME ='DF_Customer_ClientIpAddress')
    ALTER TABLE dbo.Customer DROP CONSTRAINT DF_Customer_ClientIpAddress

GO

UPDATE dbo.Customer SET ClientIpAddress=NULL WHERE ClientIpAddress='0.0.0.0'

GO

