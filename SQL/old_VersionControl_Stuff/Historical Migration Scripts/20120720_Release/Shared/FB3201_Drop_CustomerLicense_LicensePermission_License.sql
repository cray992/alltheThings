BEGIN TRANSACTION;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET NOCOUNT ON;
COMMIT;
USE Superbill_Shared;
GO
CREATE FUNCTION dbo.VerifyTableExists ( @TableName SYSNAME )
RETURNS BIT
AS 
    BEGIN
        DECLARE @result BIT;
        SELECT  @result = CASE WHEN EXISTS ( SELECT *
                                             FROM   [sys].[tables]
                                             WHERE  [object_id] = OBJECT_ID(@TableName)
                                                    AND OBJECTPROPERTY([object_id],
                                                              N'IsUserTable') = 1 )
                               THEN 1
                               ELSE 0
                          END;
        RETURN
	(
		@result		
	)
    END
GO
DECLARE @table_name AS SYSNAME;
SET @table_name = N'dbo.CustomerLicense';
IF dbo.VerifyTableExists(@table_name) = 0 
    PRINT @table_name + N' doesn''t exist';
ELSE 
    BEGIN
        DROP TABLE dbo.CustomerLicense;
        PRINT @table_name + N' dropped';
    END
SET @table_name = N'dbo.LicensePermission';
IF dbo.VerifyTableExists(@table_name) = 0 
    PRINT @table_name + N' doesn''t exist';
ELSE 
    BEGIN
        DROP TABLE dbo.LicensePermission;
        PRINT @table_name + N' dropped';
    END
SET @table_name = N'dbo.License';
IF dbo.VerifyTableExists(@table_name) = 0 
    PRINT @table_name + N' doesn''t exist';
ELSE 
    BEGIN
        DROP TABLE dbo.License;
        PRINT @table_name + N' dropped';
    END
GO
DROP FUNCTION dbo.VerifyTableExists;
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   type = 'P'
                    AND name = 'Shared_AuthenticationDataProvider_CreateLicense' ) 
    BEGIN
        DROP PROCEDURE dbo.Shared_AuthenticationDataProvider_CreateLicense;
    END
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   type = 'P'
                    AND name = 'Shared_AuthenticationDataProvider_DeleteLicense' ) 
    BEGIN
        DROP PROCEDURE dbo.Shared_AuthenticationDataProvider_DeleteLicense;
    END
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   type = 'P'
                    AND name = 'Shared_AuthenticationDataProvider_GetCustomerLicenses' ) 
    BEGIN
        DROP PROCEDURE dbo.Shared_AuthenticationDataProvider_GetCustomerLicenses;
    END
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   type = 'P'
                    AND name = 'Shared_AuthenticationDataProvider_GetLicense' ) 
    BEGIN
        DROP PROCEDURE dbo.Shared_AuthenticationDataProvider_GetLicense;
    END
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   type = 'P'
                    AND name = 'Shared_AuthenticationDataProvider_GetLicenses' ) 
    BEGIN
        DROP PROCEDURE dbo.Shared_AuthenticationDataProvider_GetLicenses;
    END
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   type = 'P'
                    AND name = 'Shared_AuthenticationDataProvider_GetLicensePermissions' ) 
    BEGIN
        DROP PROCEDURE dbo.Shared_AuthenticationDataProvider_GetLicensePermissions;
    END
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   type = 'P'
                    AND name = 'Shared_AuthenticationDataProvider_UpdateLicensePermission' ) 
    BEGIN
        DROP PROCEDURE dbo.Shared_AuthenticationDataProvider_UpdateLicensePermission;
    END
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   type = 'P'
                    AND name = 'Shared_AuthenticationDataProvider_SetCustomerLicense;' ) 
    BEGIN
        DROP PROCEDURE dbo.Shared_AuthenticationDataProvider_SetCustomerLicense;
    END
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   type = 'P'
                    AND name = 'Shared_AuthenticationDataProvider_UnsetCustomerLicense' ) 
    BEGIN
        DROP PROCEDURE dbo.Shared_AuthenticationDataProvider_UnsetCustomerLicense;
    END
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   type = 'P'
                    AND name = 'Shared_AuthenticationDataProvider_UpdateLicense' ) 
    BEGIN
        DROP PROCEDURE dbo.Shared_AuthenticationDataProvider_UpdateLicense;
    END
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   type = 'P'
                    AND name = 'Shared_CustomerDataProvider_GetLicensesByCustomer' ) 
    BEGIN
        DROP PROCEDURE dbo.Shared_CustomerDataProvider_GetLicensesByCustomer;
    END
GO
