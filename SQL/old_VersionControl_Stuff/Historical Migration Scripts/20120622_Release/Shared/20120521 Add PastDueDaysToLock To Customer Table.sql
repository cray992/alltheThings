USE Superbill_Shared

GO

IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='Customer' AND column_name='PastDueDaysToLock' )
    ALTER TABLE Customer ADD PastDueDaysToLock INT NOT NULL CONSTRAINT DF_Customer_PastDueDaysToLock DEFAULT 7
    
GO
