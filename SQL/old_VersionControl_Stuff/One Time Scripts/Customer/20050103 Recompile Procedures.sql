DECLARE obj_recomp_cursor CURSOR
READ_ONLY
FOR 
	SELECT R.ROUTINE_NAME
	FROM INFORMATION_SCHEMA.ROUTINES R

DECLARE @name varchar(128)
OPEN obj_recomp_cursor

FETCH NEXT FROM obj_recomp_cursor INTO @name
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		--PRINT 'Setting recompile flag for ' + ISNULL(@name,'NULL was passed')
		EXEC sp_recompile @name
	END
	FETCH NEXT FROM obj_recomp_cursor INTO @name
END

CLOSE obj_recomp_cursor
DEALLOCATE obj_recomp_cursor
GO
