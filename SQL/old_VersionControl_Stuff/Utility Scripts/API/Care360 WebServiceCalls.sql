USE FlowMessages

SET TRAN ISOLATION LEVEL READ UNCOMMITTED

DECLARE @login VARCHAR(100)
DECLARE @customerId VARCHAR(10)
DECLARE @messageName VARCHAR(100)

SET @login = 'kareointegration@medplus.com'
SET @customerId = NULL --'2862'
SET @messageName = NULL --'Create Encounter'

DECLARE @startdate DATETIME,
    @enddate DATETIME
SET @startdate = DATEADD(d, -1, GETDATE())
SET @enddate = NULL


IF OBJECT_ID('tempdb..#WebServiceMsg') IS NOT NULL 
    DROP TABLE #WebServiceMsg


SELECT  WebServiceMsgId, Received, Completed, DATEDIFF(ms, Received, Completed) / 1000 AS ElapsedTimeSeconds,
        CAST(Request AS XML) AS Request,
        Error
INTO    #webservicemsg
FROM    WebServiceMsg WITH (INDEX (nci_WebServiceMsg_Received))
WHERE   --WebServiceMsgId >= @minwebservicemsgid AND 
        Received >= @startdate
        AND (Received <= @enddate
             OR @enddate IS NULL)
        --AND (Error IS NULL
        --     OR @ignoreErrors = 0)

SELECT  t.WebServiceMsgId, t.Received, t.Completed, t.Error, t.Request, CAST(W.Response AS XML),
        CAST(t.Request.query('(/Request/Name/text())') AS VARCHAR(128)) AS Name,
        CAST(t.Request.query('(/Request/ClientVersion/text())') AS VARCHAR(128)) AS ClientVersion,
        CAST(t.Request.query('(/Request/CustomerKey/text())') AS VARCHAR(128)) AS CustomerKey,
        CAST(t.Request.query('(/Request/User/text())') AS VARCHAR(128)) AS Login
FROM    #webservicemsg t
	INNER JOIN dbo.WebServiceMsg W ON t.WebServiceMsgId = W.WebServiceMsgId
WHERE   LEN(CAST(w.Request AS VARCHAR(MAX))) < 7000	-- filter Responses that were truncated (make this optional!?)
		AND CAST(t.Request.query('(/Request/User/text())') AS VARCHAR(128)) = @login
        AND (@customerID IS NULL
             OR CAST(t.Request.query('(/Request/CustomerKey/text())') AS VARCHAR(128)) LIKE '%:'
             + @customerId + '%')
        AND (@messageName IS NULL
             OR CAST(t.Request.query('(/Request/Name/text())') AS VARCHAR(128)) = @messageName)
ORDER BY WebServiceMsgID DESC




/*
select	WebServiceMsgId, 
		Received, 
		Completed,  
		DateDiff(ms, Received, Completed) / 1000 as ElaspedTimeSeconds,
		cast(Request as xml) Request,
		--cast(Response as xml) Response, 
		Response,
		Error,
		CorrelationID
from webservicemsg
where webservicemsgid in (7603774)
order by webservicemsgid
*/