IF NOT EXISTS(SELECT * FROM sys.columns WHERE NAME = N'ConversionDate' and Object_ID = Object_ID(N'invoicing.CustomerSettings'))    
BEGIN
    
    ALTER TABLE invoicing.CustomerSettings
	ADD [ConversionDate] [DATETIME] NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE NAME = N'ConversionDate' and Object_ID = Object_ID(N'BillingInvoicing_Customer'))    
BEGIN
    
    ALTER TABLE dbo.BillingInvoicing_Customer
	ADD [ConversionDate] [DATETIME] NULL
END