BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
IF NOT EXISTS ( SELECT  *
                FROM    dbo.PlaceOfService
                WHERE   PlaceOfServiceCode = 17 ) 
    BEGIN
        INSERT  INTO dbo.PlaceOfService
                ( [PlaceOfServiceCode] ,
                  [Description]
                )
        VALUES  ( '17' ,
                  'Walk-in Retail Health Clinic'
                );
    END