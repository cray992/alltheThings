use FlowMessages -- kprod-db15
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
		CAST(cast(Request as xml).query('(/Request/User/text())') as varchar(128)) as UserLogin,
		CASE WHEN Error IS NULL THEN 0 ELSE 1 END AS Error
into	#webservicemsg
from	WebServiceMsg
where	WebServiceMsgId >= @minwebservicemsgid
and		Received >= @WeekStart
and		(Received <= @WeekEnd or @WeekEnd is null)

/****************************** Quest Only ******************************/
SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 0
AND UserLogin = 'kareointegration@medplus.com'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 Quest Only 0 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 2
AND ElapsedTimeSeconds >= 1
AND UserLogin = 'kareointegration@medplus.com'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 Quest Only 1-2 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 10
AND ElapsedTimeSeconds >= 3
AND UserLogin = 'kareointegration@medplus.com'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 Quest Only 3-10 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 60
AND ElapsedTimeSeconds >= 11
AND UserLogin = 'kareointegration@medplus.com'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 Quest Only 11-60 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds >= 61
AND UserLogin = 'kareointegration@medplus.com'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 Quest Only 60+ seconds', -- Metric - varchar(max)
		( @Count )
          )

/****************************** Practice Fusion Only ******************************/
SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 0
AND UserLogin = 'kareointegration@practicefusion.com'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 PF Only 0 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 2
AND ElapsedTimeSeconds >= 1
AND UserLogin = 'kareointegration@practicefusion.com'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 PF Only 1-2 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 10
AND ElapsedTimeSeconds >= 3
AND UserLogin = 'kareointegration@practicefusion.com'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 PF Only 3-10 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 60
AND ElapsedTimeSeconds >= 11
AND UserLogin = 'kareointegration@practicefusion.com'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 PF Only 11-60 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds >= 61
AND UserLogin = 'kareointegration@practicefusion.com'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 PF Only 60+ seconds', -- Metric - varchar(max)
		( @Count )
          )

/****************************** All ******************************/
SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 0
AND UserLogin NOT IN ('kareointegration@practicefusion.com', 'kareointegration@medplus.com')

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 Excl PF 0 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 2
AND ElapsedTimeSeconds >= 1
AND UserLogin NOT IN ('kareointegration@practicefusion.com', 'kareointegration@medplus.com')

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 Excl PF 1-2 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 10
AND ElapsedTimeSeconds >= 3
AND UserLogin NOT IN ('kareointegration@practicefusion.com', 'kareointegration@medplus.com')

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 Excl PF 3-10 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds <= 60
AND ElapsedTimeSeconds >= 11
AND UserLogin NOT IN ('kareointegration@practicefusion.com', 'kareointegration@medplus.com')

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 Excl PF 11-60 seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*)
FROM #webservicemsg
WHERE ElapsedTimeSeconds >= 61
AND UserLogin NOT IN ('kareointegration@practicefusion.com', 'kareointegration@medplus.com')

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( '2.1 Excl PF 60+ seconds', -- Metric - varchar(max)
		( @Count )
          )

SELECT	*
FROM	@Table

--SELECT TOP 100 * FROM #webservicemsg

DROP TABLE #webservicemsg
--DROP TABLE #webservicemsg2