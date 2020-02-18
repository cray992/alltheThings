DECLARE @Indexes TABLE(Name VARCHAR(256), TableName VARCHAR(256), IType BIT, frag REAL)
INSERT @Indexes(Name, TableName, IType, frag)
SELECT si.Name, so.Name, CASE WHEN index_type_desc='CLUSTERED INDEX' THEN 1 ELSE 0 END IType, avg_fragmentation_in_percent frag
FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,NULL) sis INNER JOIN sys.indexes si
ON sis.object_id=si.object_id AND sis.index_id=si.index_id
INNER JOIN sys.objects so
ON si.object_id=so.object_id
WHERE avg_fragmentation_in_percent>0 AND si.Name IS NOT NULL
ORDER BY avg_fragmentation_in_percent DESC

DECLARE @LOOP INT
DECLARE @COUNT INT
DECLARE @Table VARCHAR(256)
DECLARE @Index VARCHAR(256)
DECLARE @US_SQL VARCHAR(8000)
DECLARE @RI_SQL VARCHAR(8000)
DECLARE @EXEC_SQL VARCHAR(8000)

SET @US_SQL='UPDATE STATISTICS {0} WITH FULLSCAN'
SET @RI_SQL='ALTER INDEX {1} ON {0} REBUILD'

DECLARE @CI TABLE(CID INT IDENTITY(1,1), Name VARCHAR(256), TableName VARCHAR(256), frag REAL)
INSERT @CI(Name, TableName, frag)
SELECT Name, TableName, frag
FROM @Indexes
WHERE IType=1

DECLARE @TablesToUpdate TABLE(TID INT IDENTITY(1,1), TableName VARCHAR(256))
INSERT @TablesToUpdate(TableName)
SELECT DISTINCT Tablename
FROM @CI

SET @LOOP=@@ROWCOUNT
SET @COUNT=0

WHILE @COUNT<@LOOP
BEGIN
	SET @COUNT=@COUNT+1

	SELECT @Table=TableName
	FROM @TablesToUpdate
	WHERE TID=@COUNT

	SET @EXEC_SQL=REPLACE(@US_SQL,'{0}',@Table)

	EXEC(@EXEC_SQL)
END

SELECT @LOOP=COUNT(*), @COUNT=0 FROM @CI

WHILE @COUNT<@LOOP
BEGIN
	SET @COUNT=@COUNT+1

	SELECT @Table=TableName, @Index=Name
	FROM @CI
	WHERE CID=@COUNT
	
	SET @EXEC_SQL=REPLACE(REPLACE(@RI_SQL,'{0}',@Table),'{1}',@Index)

	EXEC(@EXEC_SQL)
END

DECLARE @IndexesII TABLE(Name VARCHAR(256), TableName VARCHAR(256), IType BIT, frag REAL)
INSERT @IndexesII(Name, TableName, IType, frag)
SELECT si.Name, so.Name, CASE WHEN index_type_desc='CLUSTERED INDEX' THEN 1 ELSE 0 END IType, avg_fragmentation_in_percent frag
FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,NULL) sis INNER JOIN sys.indexes si
ON sis.object_id=si.object_id AND sis.index_id=si.index_id
INNER JOIN sys.objects so
ON si.object_id=so.object_id
WHERE avg_fragmentation_in_percent>0 AND si.Name IS NOT NULL
ORDER BY avg_fragmentation_in_percent DESC

DECLARE @NCI TABLE(NCID INT IDENTITY(1,1), Name VARCHAR(256), TableName VARCHAR(256), frag REAL)
INSERT @NCI(Name, TableName, frag)
SELECT Name, TableName, frag
FROM @IndexesII
WHERE IType=0

DECLARE @TablesToUpdateII TABLE(TID INT IDENTITY(1,1), TableName VARCHAR(256))
INSERT @TablesToUpdateII(TableName)
SELECT DISTINCT N.Tablename
FROM @NCI N LEFT JOIN @TablesToUpdate TTU
ON N.TableName=TTU.TableName
WHERE TTU.TableName IS NULL

SET @LOOP=@@ROWCOUNT
SET @COUNT=0

WHILE @COUNT<@LOOP
BEGIN
	SET @COUNT=@COUNT+1

	SELECT @Table=TableName
	FROM @TablesToUpdateII
	WHERE TID=@COUNT

	SET @EXEC_SQL=REPLACE(@US_SQL,'{0}',@Table)

	EXEC(@EXEC_SQL)
END

SELECT @LOOP=COUNT(*), @COUNT=0 FROM @NCI

WHILE @COUNT<@LOOP
BEGIN
	SET @COUNT=@COUNT+1

	SELECT @Table=TableName, @Index=Name
	FROM @NCI
	WHERE NCID=@COUNT
	
	SET @EXEC_SQL=REPLACE(REPLACE(@RI_SQL,'{0}',@Table),'{1}',@Index)

	EXEC(@EXEC_SQL)
END