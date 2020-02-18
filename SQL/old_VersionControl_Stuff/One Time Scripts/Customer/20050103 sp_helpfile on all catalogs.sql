DECLARE catalog_name_cursor CURSOR
READ_ONLY
FOR 
	SELECT CATALOG_NAME
	FROM INFORMATION_SCHEMA.SCHEMATA
	ORDER BY CATALOG_NAME

DECLARE @sql varchar(8000)

DECLARE @name varchar(128)
OPEN catalog_name_cursor

FETCH NEXT FROM catalog_name_cursor INTO @name
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		SET @sql = 'EXEC [' + @name + ']..sp_helpfile'
		EXEC(@sql)
	END
	FETCH NEXT FROM catalog_name_cursor INTO @name
END

CLOSE catalog_name_cursor
DEALLOCATE catalog_name_cursor
GO
