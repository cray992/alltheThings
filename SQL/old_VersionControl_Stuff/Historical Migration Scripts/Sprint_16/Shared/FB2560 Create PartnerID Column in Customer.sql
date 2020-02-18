USE Superbill_Shared
go

IF NOT EXISTS ( SELECT  *
                FROM    information_schema.columns
                WHERE   table_name = 'Customer'
                        AND column_name = 'PartnerID' ) 
    BEGIN
        ALTER TABLE [dbo].[Customer]
        ADD [PartnerID] INT NOT NULL
        CONSTRAINT [DF_Customers_PartnerID] DEFAULT (1) WITH VALUES
        CONSTRAINT [FK_Customer_PartnerID]
        FOREIGN KEY ([PartnerID])
        REFERENCES [dbo].[Partner]([PartnerID])
    END
go