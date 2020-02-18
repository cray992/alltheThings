use FlowMessages -- kprod-db09
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @WeekEnd DATETIME
DECLARE @WeekStart DATETIME
DECLARE @Count INT
DECLARE @Average DECIMAL

SET @WeekEnd = CONVERT(VARCHAR(10), GETDATE(), 101)
SET @WeekStart = DATEADD(d, -7, @WeekEnd)

PRINT 'Executing for ' + CONVERT(VARCHAR(32), @WeekStart, 101) + ' to ' + CONVERT(VARCHAR(32), @WeekEnd, 101)

DECLARE @Table TABLE ( Metric VARCHAR(MAX), [Value] int )

/****************************** Get all Web Service calls ******************************/
declare @minwebservicemsgid int
set		@minwebservicemsgid = 1

select	WebServiceMsgId,
		Received,
		Completed, 
		DateDiff(ms, Received, Completed) / 1000 as ElapsedTimeSeconds,
		CASE WHEN Error IS NULL THEN 0 ELSE 1 END AS Error
into	#webservicemsg
from	WebServiceMsg
where	WebServiceMsgId >= @minwebservicemsgid
and		Received >= @WeekStart
and		(Received <= @WeekEnd or @WeekEnd is null)

/****************************** All ******************************/
SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 0

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '1.0 0 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 2
AND ElapsedTimeSeconds >= 1

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '1.0 1-2 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 10
AND ElapsedTimeSeconds >= 3

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '1.0 3-10 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 60
AND ElapsedTimeSeconds >= 11

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '1.0 11-60 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds >= 61

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '1.0 60+ seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT	*
FROM	@Table

DROP TABLE #webservicemsg
--DROP TABLE #webservicemsg2