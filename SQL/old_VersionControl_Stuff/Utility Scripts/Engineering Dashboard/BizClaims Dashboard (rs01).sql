USE KareoBizclaims -- kprod-rs01
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @WeekEnd DATETIME
DECLARE @WeekStart DATETIME
DECLARE @Count INT

SET @WeekEnd = CONVERT(VARCHAR(10), GETDATE(), 101)
SET @WeekStart = DATEADD(d, -7, @WeekEnd)

PRINT 'Executing for ' + CONVERT(VARCHAR(32), @WeekStart, 101) + ' to ' + CONVERT(VARCHAR(32), @WeekEnd, 101)

DECLARE @Table TABLE ( Metric VARCHAR(MAX), [Value] int )

/****************************** Files received by Clearinghouse ******************************/
SELECT @Count = COUNT(*) 
FROM dbo.PrefetcherFile 
WHERE FileReceiveDate BETWEEN @WeekStart AND @WeekEnd
AND SourceAddress LIKE '%proxymed%'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Files received by Clearinghouse - Capario', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*) 
FROM dbo.PrefetcherFile 
WHERE FileReceiveDate BETWEEN @WeekStart AND @WeekEnd
AND SourceAddress LIKE '%gatewayedi%'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Files received by Clearinghouse - Gateway EDI', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*) 
FROM dbo.PrefetcherFile 
WHERE FileReceiveDate BETWEEN @WeekStart AND @WeekEnd
AND SourceAddress LIKE '%officeally%'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Files received by Clearinghouse - Office Ally', -- Metric - varchar(max)
		( @Count )
          )

/****************************** Files sent to Clearinghouse ******************************/
SELECT @Count = COUNT(*) 
FROM dbo.BatchTransaction
WHERE CreatedDate BETWEEN @WeekStart AND @WeekEnd
AND BatchTransactionTypeCode = 'SNT'
AND data LIKE '%proxymed%'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Files sent to Clearinghouse - Capario', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*) 
FROM dbo.BatchTransaction
WHERE CreatedDate BETWEEN @WeekStart AND @WeekEnd
AND BatchTransactionTypeCode = 'SNT'
AND data LIKE '%gatewayedi%'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Files sent to Clearinghouse - Gateway EDI', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*) 
FROM dbo.BatchTransaction
WHERE CreatedDate BETWEEN @WeekStart AND @WeekEnd
AND BatchTransactionTypeCode = 'SNT'
AND data LIKE '%officeally%'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Files sent to Clearinghouse - Office Ally', -- Metric - varchar(max)
		( @Count )
          )

/****************************** Transactions Posted to Kareo Customers ******************************/
SELECT @Count = COUNT(*) 
FROM dbo.PayerGatewayResponse
WHERE CreatedDate BETWEEN @WeekStart AND @WeekEnd
AND ProcessedFlag = 1
AND PayerGatewayId IN (SELECT PayerGatewayId FROM dbo.PayerGateway WHERE Active = 1 AND GatewayClass = 'PROXYMED')

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Transactions posted to Kareo - Capario', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*) 
FROM dbo.PayerGatewayResponse
WHERE CreatedDate BETWEEN @WeekStart AND @WeekEnd
AND ProcessedFlag = 1
AND PayerGatewayId IN (SELECT PayerGatewayId FROM dbo.PayerGateway WHERE Active = 1 AND GatewayClass = 'GATEWAYEDI')

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Transactions posted to Kareo - Gateway EDI', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*) 
FROM dbo.PayerGatewayResponse
WHERE CreatedDate BETWEEN @WeekStart AND @WeekEnd
AND ProcessedFlag = 1
AND PayerGatewayId IN (SELECT PayerGatewayId FROM dbo.PayerGateway WHERE Active = 1 AND GatewayClass = 'OFFICEALLY')

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Transactions posted to Kareo - Office Ally', -- Metric - varchar(max)
		( @Count )
          )

/****************************** Clearinghouse Reports Posted to Kareo Customers ******************************/
SELECT @Count = COUNT(*) 
FROM dbo.ProxymedResponse
WHERE FileReceiveDate BETWEEN @WeekStart AND @WeekEnd
AND ReviewedFlag = 1

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Clearinghouse Reports posted to Kareo - Capario', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*) 
FROM dbo.GatewayEDIResponse
WHERE FileReceiveDate BETWEEN @WeekStart AND @WeekEnd
AND ReviewedFlag = 1

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Clearinghouse Reports posted to Kareo - Gateway EDI', -- Metric - varchar(max)
		( @Count )
          )
          
SELECT @Count = COUNT(*) 
FROM dbo.OfficeAllyResponse
WHERE FileReceiveDate BETWEEN @WeekStart AND @WeekEnd
AND ReviewedFlag = 1

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Clearinghouse Reports posted to Kareo - Office Ally', -- Metric - varchar(max)
		( @Count )
          )

/****************************** Rejection Rate ******************************/
SELECT @Count = COUNT(*) 
FROM dbo.PayerGatewayResponse
WHERE CreatedDate BETWEEN @WeekStart AND @WeekEnd
AND ProcessedFlag = 1
AND PayerGatewayId IN (SELECT PayerGatewayId FROM dbo.PayerGateway WHERE Active = 1 AND GatewayClass = 'PROXYMED')
AND PayerProcessingStatusTypeCode = 'A00'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Rejection Rate - Capario Acknowledgements', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*) 
FROM dbo.PayerGatewayResponse
WHERE CreatedDate BETWEEN @WeekStart AND @WeekEnd
AND ProcessedFlag = 1
AND PayerGatewayId IN (SELECT PayerGatewayId FROM dbo.PayerGateway WHERE Active = 1 AND GatewayClass = 'PROXYMED')
AND PayerProcessingStatusTypeCode = 'R00'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Rejection Rate - Capario Rejections', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*) 
FROM dbo.PayerGatewayResponse
WHERE CreatedDate BETWEEN @WeekStart AND @WeekEnd
AND ProcessedFlag = 1
AND PayerGatewayId IN (SELECT PayerGatewayId FROM dbo.PayerGateway WHERE Active = 1 AND GatewayClass = 'GATEWAYEDI')
AND PayerProcessingStatusTypeCode = 'A00'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Rejection Rate - Gateway EDI Acknowledgements', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*) 
FROM dbo.PayerGatewayResponse
WHERE CreatedDate BETWEEN @WeekStart AND @WeekEnd
AND ProcessedFlag = 1
AND PayerGatewayId IN (SELECT PayerGatewayId FROM dbo.PayerGateway WHERE Active = 1 AND GatewayClass = 'GATEWAYEDI')
AND PayerProcessingStatusTypeCode = 'R00'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Rejection Rate - Gateway EDI Rejections', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*) 
FROM dbo.PayerGatewayResponse
WHERE CreatedDate BETWEEN @WeekStart AND @WeekEnd
AND ProcessedFlag = 1
AND PayerGatewayId IN (SELECT PayerGatewayId FROM dbo.PayerGateway WHERE Active = 1 AND GatewayClass = 'OFFICEALLY')
AND PayerProcessingStatusTypeCode = 'A00'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Rejection Rate - Office Ally Acknowledgements', -- Metric - varchar(max)
		( @Count )
          )

SELECT @Count = COUNT(*) 
FROM dbo.PayerGatewayResponse
WHERE CreatedDate BETWEEN @WeekStart AND @WeekEnd
AND ProcessedFlag = 1
AND PayerGatewayId IN (SELECT PayerGatewayId FROM dbo.PayerGateway WHERE Active = 1 AND GatewayClass = 'OFFICEALLY')
AND PayerProcessingStatusTypeCode = 'R00'

INSERT INTO @Table
        ( Metric, Value )
VALUES  ( 'Rejection Rate - Office Ally Rejections', -- Metric - varchar(max)
		( @Count )
          )

/************************************ Return data ************************************/
SELECT * FROM @Table
/*
SELECT  PrefetcherFileId ,
        FileReceiveDate ,
        errors ,
        result ,
        count ,
        startedutc ,
        durationms ,
        PayerGatewayId ,
        ResponseType ,
        SourceAddress ,
        FileName ,
        FileStorageLocation ,
        TIMESTAMP
FROM dbo.PrefetcherFile WHERE FileReceiveDate > '3/24/2011 9:31am'
ORDER BY FileReceiveDate desc

SELECT COUNT(*) 
FROM dbo.PrefetcherFile WHERE FileReceiveDate > '3/24/2011 9:31am'

*/