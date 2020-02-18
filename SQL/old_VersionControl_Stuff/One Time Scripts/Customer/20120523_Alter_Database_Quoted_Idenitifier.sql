

GO
	
SET NOCOUNT ON


DECLARE @DBName VARCHAR(32)

		Select @DBName=(SELECT db_name()); 
		
IF 
EXISTS(select *
FROM sys.databases AS d
WHERE d.is_quoted_identifier_on=0 AND d.name=@DBName)

Begin	
		
PRINT @DBName

	
EXEC('Alter Database '+@DBName+ ' Set QUOTED_IDENTIFIER ON' );

END


GO

