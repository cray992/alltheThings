Declare @name NVARCHAR(250);
Declare @SQL VARCHAR(max);
Declare @Views as CURSOR;
Declare @cnt int;

SET @Views = CURSOR FAST_FORWARD FOR
Select o.name 
From sys.objects as o
Where o.type = 'V' and OBJECT_SCHEMA_NAME(o.object_id) = 'dbo'

OPEN @Views
FETCH NEXT FROM @Views INTO @name;
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @cnt = 1;
		SET @SQL = 'CREATE VIEW [dbo].['+@name+'] AS'
		While @cnt <= 48
			Begin
				If @cnt <> 47
					begin
						SET @SQL =@SQL + CHAR(13) + (Select 'Select * From [LAS-PDW-D0' + CASE 
																						  WHEN @cnt <= 9 THEN '0' + CAST(@cnt as varchar(20)) 
																						  ELSE CAST(@cnt as varchar(20))
																						  END 
																						+ '].KareoDBA.' 
																						+ OBJECT_SCHEMA_NAME(o.object_id) 
																						+ '.' 
																						+ o.name 
																						+ CASE 
																						  WHEN @cnt = 48 THEN ' WITH (NOLOCK)'
																						  ELSE ' WITH (NOLOCK) UNION ALL'
																						  END
																						  
																						  
													From
														sys.objects as o
													Where
														o.type = 'V' and OBJECT_SCHEMA_NAME(o.object_id) = 'dbo' and o.name = @name)
					end
				Set @cnt = @cnt + 1;
			End;
		SET @SQL = @SQL + CHAR(13)+char(10) + 'GO' + CHAR(13)+char(10)
		Print @SQL
		FETCH NEXT FROM @Views INTO @name;	
	END
CLOSE @Views;
DEALLOCATE @Views;
