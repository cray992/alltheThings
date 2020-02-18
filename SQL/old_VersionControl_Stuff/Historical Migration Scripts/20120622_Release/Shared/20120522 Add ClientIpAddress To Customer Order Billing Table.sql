USE Superbill_Shared

GO

IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='CustomerOrderBilling' AND column_name='ModifiedByIpAddress' )
    ALTER TABLE CustomerOrderBilling ADD ModifiedByIpAddress varchar(512) NULL

GO
