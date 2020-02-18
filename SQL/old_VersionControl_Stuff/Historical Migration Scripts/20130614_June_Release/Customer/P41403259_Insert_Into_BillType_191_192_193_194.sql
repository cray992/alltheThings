BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRANSACTION;

IF NOT EXISTS ( SELECT  *
                FROM    dbo.BillType AS BT
                WHERE   BT.Code = '191' ) 
    BEGIN
        INSERT  INTO dbo.BillType
                ( Code, Name )
        VALUES  ( '191', 'Admission through discharge bill' );
    END

IF NOT EXISTS ( SELECT  *
                FROM    dbo.BillType AS BT
                WHERE   BT.Code = '192' ) 
    BEGIN
        INSERT  INTO dbo.BillType
                ( Code, Name )
        VALUES  ( '192', 'First interim bill' );
    END

IF NOT EXISTS ( SELECT  *
                FROM    dbo.BillType AS BT
                WHERE   BT.Code = '193' ) 
    BEGIN
        INSERT  INTO dbo.BillType
                ( Code, Name )
        VALUES  ( '193', 'Second interim bill' );
    END
	  
IF NOT EXISTS ( SELECT  *
                FROM    dbo.BillType AS BT
                WHERE   BT.Code = '194' ) 
    BEGIN
        INSERT  INTO dbo.BillType
                ( Code, Name )
        VALUES  ( '194', 'Final bill for interim' );
    END

COMMIT;
	  
GO
