/*
SELECT UPPER(C.COLUMN_NAME) AS ToFind, C.COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS C
WHERE C.TABLE_NAME NOT like 'sys%'
	AND C.TABLE_NAME <> 'dtproperties'
GROUP BY C.COLUMN_NAME
ORDER BY LEN(C.COLUMN_NAME) DESC

SELECT 'Replace("' + UPPER(C.COLUMN_NAME) + '", "' +C.COLUMN_NAME + '") ' + char(13) + char(10)
FROM INFORMATION_SCHEMA.COLUMNS C
WHERE C.TABLE_NAME NOT like 'sys%'
	AND C.TABLE_NAME <> 'dtproperties'
GROUP BY C.COLUMN_NAME
ORDER BY LEN(C.COLUMN_NAME) DESC
*/
-- =============================================
-- Declare and using a READ_ONLY cursor
-- =============================================
DECLARE column_cursor CURSOR
READ_ONLY
FOR 	SELECT UPPER(C.COLUMN_NAME) AS ToFind, C.COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS C
		WHERE C.TABLE_NAME NOT like 'sys%'
			AND C.TABLE_NAME <> 'dtproperties'
		GROUP BY C.COLUMN_NAME
		ORDER BY LEN(C.COLUMN_NAME) DESC

DECLARE @ToFind sysname
DECLARE @NewValue sysname
OPEN column_cursor

FETCH NEXT FROM column_cursor INTO @ToFind, @NewValue
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
--		PRINT 'add user defined code here'
--		eg.
		--PRINT 'currentLine = currentLine.Replace("' + @ToFind + '", "' + @NewValue + '");' 
		--PRINT '.Add("' + @ToFind + '", "' + @NewValue + '");' 
		PRINT @NewValue
	END
	FETCH NEXT FROM column_cursor INTO @ToFind, @NewValue
END

CLOSE column_cursor
DEALLOCATE column_cursor
GO


