IF NOT EXISTS(SELECT * FROM sys.columns WHERE NAME = N'ServiceLocationGuid' and Object_ID = Object_ID(N'ServiceLocation'))    
BEGIN
    
    ALTER TABLE dbo.ServiceLocation
	ADD [ServiceLocationGuid] [uniqueidentifier] NOT NULL 
	CONSTRAINT [DF_ServiceLocation_ServiceLocationGuid]  
	DEFAULT (newid())

END
