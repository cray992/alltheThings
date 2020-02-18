USE Superbill_Shared

GO

IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='Customer' AND column_name='ClientIpAddress' )
    ALTER TABLE Customer ADD ClientIpAddress varchar(512) NULL CONSTRAINT DF_Customer_ClientIpAddress DEFAULT '0.0.0.0'
    
GO
