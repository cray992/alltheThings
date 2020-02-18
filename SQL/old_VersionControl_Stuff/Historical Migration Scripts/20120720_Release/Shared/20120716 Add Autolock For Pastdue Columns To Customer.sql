USE Superbill_Shared

GO

IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='Customer' AND column_name='LockedForPastDuePayment' )
    ALTER TABLE Customer ADD LockedForPastDuePayment BIT NOT NULL CONSTRAINT DF_Customer_LockedForPastDuePayment DEFAULT 0
    
GO

IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='Customer' AND column_name='AutoLocksWhenPastDue' )
    ALTER TABLE Customer ADD AutoLocksWhenPastDue BIT NOT NULL CONSTRAINT DF_Customer_AutoLocksWhenPastDue DEFAULT 1
    
GO
