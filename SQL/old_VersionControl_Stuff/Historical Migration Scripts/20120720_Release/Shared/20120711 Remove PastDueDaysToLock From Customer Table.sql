USE Superbill_Shared

GO

IF EXISTS ( SELECT * FROM sys.objects WHERE name = 'DF_Customer_PastDueDaysToLock' )
    ALTER TABLE Customer DROP CONSTRAINT DF_Customer_PastDueDaysToLock
    
GO

IF EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='Customer' AND column_name='PastDueDaysToLock' )
    ALTER TABLE Customer DROP COLUMN PastDueDaysToLock
    
GO

