SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT  *
                FROM    information_schema.columns
                WHERE   table_name = 'Customer'
                        AND column_name = 'GrantPricingID' ) 
BEGIN

		ALTER TABLE Customer
		DROP CONSTRAINT FK_Customer_GrantPricingID
                        
		ALTER TABLE Customer
		DROP COLUMN GrantPricingID
                        
END

IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   xtype = 'u'
                    AND name = 'GrantPricing' ) 
    BEGIN 
     
		DROP TABLE [dbo].[GrantPricing]
    END
    
GO


CREATE TABLE [dbo].[GrantPricing]
(
[GrantPricingID] [int] NOT NULL IDENTITY(1, 1),
[GrantCode] [varchar] (50) NOT NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[DurationInMonths] [int] NOT NULL,
[DiscountPercentage] [numeric] (4,2) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GrantPricing] ADD CONSTRAINT [PK_GrantPricing] PRIMARY KEY CLUSTERED  ([GrantPricingID]) ON [PRIMARY]
GO


IF NOT EXISTS ( SELECT  *
                FROM    information_schema.columns
                WHERE   table_name = 'Customer'
                        AND column_name = 'GrantPricingID' ) 
    BEGIN
        ALTER TABLE [dbo].[Customer]
        ADD [GrantPricingID] INT NULL
        CONSTRAINT [FK_Customer_GrantPricingID]
        FOREIGN KEY ([GrantPricingID])
        REFERENCES [dbo].[GrantPricing]([GrantPricingID])
    END
go

IF NOT EXISTS ( SELECT  *
                FROM    information_schema.columns
                WHERE   table_name = 'BillingInvoicing_Customer'
                        AND column_name = 'GrantPricingID' ) 
BEGIN

		ALTER TABLE dbo.BillingInvoicing_Customer
		ADD [GrantPricingID] INT NULL
		
END



INSERT dbo.GrantPricing
        ( GrantCode,
          StartDate,
          EndDate,
          DurationInMonths,
          DiscountPercentage
        )
SELECT 'QG20120509', -- GrantCode - varchar(50)
          '5/1/2012', -- StartDate - datetime
          '8/31/2012', -- EndDate - datetime
          15, -- DurationInMonths - int
          37.5  -- DiscountPercentage - numeric(4,2)
UNION ALL
SELECT 'QG20120509', -- GrantCode - varchar(50)
          '9/1/2012', -- StartDate - datetime
          '12/31/2012', -- EndDate - datetime
          10, -- DurationInMonths - int
          37.5  -- DiscountPercentage - numeric(4,2)