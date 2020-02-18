
IF NOT EXISTS ( SELECT  column_name
                FROM    INFORMATION_SCHEMA.COLUMNS AS IST
                WHERE   table_name = 'ProcedureModifier'
                        AND column_name = 'ProcedureModifierID' ) 
    BEGIN
        ALTER TABLE [dbo].[ProcedureModifier]
        ADD ProcedureModifierID INT IDENTITY(1,1)
    END
    
IF NOT EXISTS ( SELECT  column_name
                FROM    INFORMATION_SCHEMA.COLUMNS AS IST
                WHERE   table_name = 'TypeOfService'
                        AND column_name = 'TypeOfServiceID' ) 
    BEGIN
        ALTER TABLE [dbo].[TypeOfService]
        ADD TypeOfServiceID INT IDENTITY(1,1)
    END