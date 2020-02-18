--USE [superbill_customer_id_dev] 
--GO
-- Description = We are adding a DescriptionCode field to 
-- dbo.PaymentMethodCode. This field is needed for the API and it matches 
-- internally to enumerator KareoServicesWCF.PaymentMethodCode.
-- Author = Joe Somoza
-- Date = 2011-12-01
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
-- Add DescriptionCode field to dbo.PaymentMethodCode
IF NOT EXISTS ( SELECT  *
                FROM    sys.columns AS SC
                WHERE   SC.name = 'DescriptionCode'
                        AND SC.object_id = OBJECT_ID(N'dbo.PaymentMethodCode',
                                                     N'U') ) 
    BEGIN
        ALTER TABLE dbo.PaymentMethodCode 
        ADD DescriptionCode VARCHAR(50) NULL
    END
    GO
        -- The DescriptionCodes come from the API documentation.
        UPDATE  dbo.PaymentMethodCode
        SET     DescriptionCode = CASE PaymentMethodCode
                                    WHEN 'K' THEN 'Check'
                                    WHEN 'R' THEN 'CreditCard'
                                    WHEN 'E' THEN 'ElectronicFundsTransfer'
                                    WHEN 'C' THEN 'Cash'
                                    WHEN 'O' THEN 'Other'
                                    WHEN 'U' THEN 'Unknown'
                                  END 
                                  WHERE DescriptionCode IS NULL
		-- Add indexing and avoid duplicate DescriptionCodes
        ALTER TABLE dbo.PaymentMethodCode 
        ALTER COLUMN Description VARCHAR(50) NOT NULL
GO
COMMIT                       