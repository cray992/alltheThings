BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRANSACTION;

IF NOT EXISTS ( SELECT  *
                FROM    syscolumns
                WHERE   id = OBJECT_ID('InsurancePolicyAuthorization')
                        AND name = 'VendorID' ) 
    BEGIN
        ALTER TABLE dbo.InsurancePolicyAuthorization ADD VendorID VARCHAR(50) NULL;
    END

IF NOT EXISTS ( SELECT  *
                FROM    syscolumns
                WHERE   id = OBJECT_ID('InsurancePolicyAuthorization')
                        AND name = 'VendorImportID' ) 
    BEGIN
        ALTER TABLE dbo.InsurancePolicyAuthorization ADD VendorImportID INT NULL;
    END

COMMIT;
