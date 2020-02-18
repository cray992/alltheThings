/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
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
IF NOT EXISTS ( SELECT  *
                FROM    sys.columns
                WHERE   Name = N'Field31Value'
                        AND Object_ID = OBJECT_ID(N'dbo.ClaimSettings') ) 
    BEGIN
        ALTER TABLE dbo.ClaimSettings ADD
        Field31Value VARCHAR(50) NULL
    END
GO
COMMIT
