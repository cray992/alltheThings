-- OneTime = True
-- Customer = True
-- Description = 
-- 1. Add FK from dbo.Encounter and dbo.Payment to dbo.PaymentMethodCode. 
-- 2. Add FK from dbo.Appointment and dbo.HandheldEncounter to dbo.ServiceLocation.
-- 3. Check if referring table has correct values.
-- 4. Check if foreign key already exists.
-- Date = 2011-12-08
-- Use IS NULL and IS NOT NULL.
SET ANSI_NULLS ON
GO
-- Identifiers double quote. Strings single quote.
SET QUOTED_IDENTIFIER ON
GO
-- Prevent DONE_IN_PROC messages for each statement 
SET NOCOUNT ON
GO

DECLARE @is_debug AS BIT ;
SET @is_debug = 0 ;

-- Make sure the tables exist for dynamic sql
IF @is_debug = 1 
    BEGIN
        SELECT TOP 0
                *
        FROM    dbo.Encounter ;    
        SELECT TOP 0
                *
        FROM    dbo.Payment ;
        SELECT TOP 0
                *
        FROM    dbo.PaymentMethodCode ;
        SELECT TOP 0
                *
        FROM    dbo.Appointment ;
        SELECT TOP 0
                *
        FROM    dbo.HandheldEncounter ;
        SELECT TOP 0
                *
        FROM    dbo.ServiceLocation ;
    END

-- Create data for dynamic sql
DECLARE @new_foreign_keys AS TABLE
    (
      schemaname SYSNAME NOT NULL ,
      referencing_table SYSNAME NOT NULL ,
      referenced_table SYSNAME NOT NULL ,
      referencing_column SYSNAME NOT NULL ,
      referenced_column SYSNAME NOT NULL ,
      column_type VARCHAR(30) NOT NULL
    ) ;

INSERT  INTO @new_foreign_keys
        ( schemaname ,
          referencing_table ,
          referenced_table ,
          referencing_column ,
          referenced_column ,
          column_type
        )
VALUES  ( 'dbo' , -- schemaname - sysname
          'Encounter' , -- referencing_table - sysname
          'PaymentMethodCode' , -- referenced_table - sysname
          'PaymentMethod' , -- referencing_column - sysname
          'PaymentMethodCode' , -- referenced_column - sysname
          'CHAR(1)'  -- column_type - varchar(30)
        ) ;
INSERT  INTO @new_foreign_keys
        ( schemaname ,
          referencing_table ,
          referenced_table ,
          referencing_column ,
          referenced_column ,
          column_type
        )
VALUES  ( 'dbo' , -- schemaname - sysname
          'Payment' , -- referencing_table - sysname
          'PaymentMethodCode' , -- referenced_table - sysname
          'PaymentMethodCode' , -- referencing_column - sysname
          'PaymentMethodCode' , -- referenced_column - sysname
          'CHAR(1)'  -- column_type - varchar(30)
        ) ;
INSERT  INTO @new_foreign_keys
        ( schemaname ,
          referencing_table ,
          referenced_table ,
          referencing_column ,
          referenced_column ,
          column_type
        )
VALUES  ( 'dbo' , -- schemaname - sysname
          'Appointment' , -- referencing_table - sysname
          'ServiceLocation' , -- referenced_table - sysname
          'ServiceLocationID' , -- referencing_column - sysname
          'ServiceLocationID' , -- referenced_column - sysname
          'INT'  -- column_type - varchar(30)
        ) ;
INSERT  INTO @new_foreign_keys
        ( schemaname ,
          referencing_table ,
          referenced_table ,
          referencing_column ,
          referenced_column ,
          column_type
        )
VALUES  ( 'dbo' , -- schemaname - sysname
          'HandheldEncounter' , -- referencing_table - sysname
          'ServiceLocation' , -- referenced_table - sysname
          'ServiceLocationID' , -- referencing_column - sysname
          'ServiceLocationID' , -- referenced_column - sysname
          'INT'  -- column_type - varchar(30)
        ) ;
                                
DECLARE @sql AS NVARCHAR(MAX) ,
    @schemaname AS SYSNAME ,
    @referencing_table SYSNAME ,
    @referenced_table SYSNAME ,
    @referencing_column SYSNAME ,
    @referenced_column SYSNAME ,
    @column_type VARCHAR(30) ;
    
DECLARE C CURSOR FAST_FORWARD /* read only, forward only */
FOR
    SELECT  schemaname ,
            referencing_table ,
            referenced_table ,
            referencing_column ,
            referenced_column ,
            column_type
    FROM    @new_foreign_keys

OPEN C

FETCH NEXT FROM C INTO @schemaname, @referencing_table, @referenced_table,
    @referencing_column, @referenced_column, @column_type ;    

WHILE @@FETCH_STATUS = 0 
    BEGIN

        SET @sql = N'-- Add foreign key from ' + @schemaname + '.'
            + @referencing_table + '.' + @referencing_column + ' to '
            + @schemaname + '.' + @referenced_table + '.' + @referenced_column
            + '
DECLARE @referred_values_' + @referencing_table + ' AS TABLE
    (
      referred_value ' + @column_type + ' NOT NULL
    ) ;
INSERT  INTO @referred_values_' + @referencing_table + '
        ( referred_value 
        )
        SELECT  TBL.' + @referenced_column + '
        FROM    ' + @schemaname + '.' + @referenced_table + ' AS TBL ;
IF NOT EXISTS ( SELECT  *
                FROM    sys.foreign_keys
                WHERE   object_id = OBJECT_ID(N''' + @schemaname + '.FK_'
            + @referencing_table + '_' + @referencing_column + ''')
                        AND parent_object_id = OBJECT_ID(N''' + @schemaname
            + '.' + @referencing_table + ''') ) 
    BEGIN
        IF EXISTS ( SELECT  *
                    FROM    ' + @schemaname + '.' + @referencing_table
            + ' AS E
                    WHERE   E.' + @referencing_column + ' IS NOT NULL
                            AND E.' + @referencing_column + ' NOT IN (
                            SELECT  referred_value
                            FROM    @referred_values_' + @referencing_table
            + ' ) ) 
            BEGIN
                RAISERROR (N''Cannot create the foreign key "%s" because referring table has incorrect values.'', 
				   16, -- Severity,
				   1, -- State,
				   N''FK_' + @referencing_table + '_' + @referencing_column
            + ''') ; -- First argument supplies the string.
            END
        ELSE 
            BEGIN
                ALTER TABLE ' + @schemaname + '.' + @referencing_table + '
                ADD CONSTRAINT FK_' + @referencing_table + '_'
            + @referencing_column + '
                FOREIGN KEY(' + @referencing_column + ')
                REFERENCES ' + @schemaname + '.' + @referenced_table + '('
            + @referenced_column + ') ;
                PRINT ''Added foreign key FK_' + @referencing_table + '_'
            + @referencing_column + ''' ;
            END
    END
' ;
        IF @is_debug = 1 
            PRINT @sql ;
        ELSE 
            EXEC(@sql) ;
        FETCH NEXT FROM C INTO @schemaname, @referencing_table,
            @referenced_table, @referencing_column, @referenced_column,
            @column_type ; 
    END ;

CLOSE C ;

DEALLOCATE C ;     