USE Superbill_Shared

GO

IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='Customer' AND column_name='AllowMultiGroupMembership' )
    ALTER TABLE Customer ADD AllowMultiGroupMembership BIT NOT NULL CONSTRAINT DF_Customer_AllowMultiGroupMembership DEFAULT 0
    
GO