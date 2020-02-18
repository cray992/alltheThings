BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

USE [Superbill_Shared];
GO

BEGIN TRANSACTION;

DECLARE @edi_hack_id AS INT ,
    @customer_id AS INT;
SET @customer_id = 8345;

SELECT TOP 1
        @edi_hack_id = EH.EdiHackID
FROM    [Superbill_Shared].dbo.EdiHack AS EH
WHERE   EH.NAME = 'ForcePatientAddressIn2310C';

IF EXISTS ( SELECT  *
            FROM    dbo.EdiHackPayer AS EHP
            WHERE   EHP.CustomerID = @customer_id
                    AND EHP.EdiHackID = @edi_hack_id
                    AND EHP.PayerNumber = '12202' ) 
    BEGIN
        DELETE  FROM EHP
        FROM    dbo.EdiHackPayer AS EHP
        WHERE   EHP.CustomerID = @customer_id
                AND EHP.EdiHackID = @edi_hack_id
                AND EHP.PayerNumber = '12202';
    END
        
IF NOT EXISTS ( SELECT  *
                FROM    dbo.EdiHackCustomer AS EHC
                WHERE   EHC.CustomerID = @customer_id
                        AND EHC.EdiHackID = @edi_hack_id ) 
    BEGIN
        INSERT  INTO dbo.EdiHackCustomer
                ( EdiHackID ,
                  CustomerID ,
                  LastModifiedDate ,
                  LastModifiedUser				        
                )
        VALUES  ( @edi_hack_id , -- EdiHackID - int
                  @customer_id , -- CustomerID - int
                  CURRENT_TIMESTAMP , -- LastModifiedDate - datetime
                  'joe.somoza'  -- LastModifiedUser - varchar(100)				        
                );
    END

COMMIT;

