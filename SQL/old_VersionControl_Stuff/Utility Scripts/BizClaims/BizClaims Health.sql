USE FlowMessages
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select QueueMsgId, MsgStatus, CreatedDate, error, cast(msg.query('(/Request/Name/text())') AS varchar(50))
from queuemsg 
where createddate > dateadd(day, -4, getdate())
--and MsgStatus = 'Error'
and cast(msg.query('(/Request/Name/text())') as varchar(50)) in( 'SendAllPhysiciansReportCard', 'SendAllAppointmentReminders')
ORDER BY CreatedDate

use KareoBizClaims


---- Look for records from Axis Medical
--SELECT ProxymedResponseId 
--FROM dbo.ProxymedResponse 
--WHERE FileReceiveDate > '7/11/2012' 
--AND CustomerIdCorrelated=613 AND PracticeIdCorrelated=7 
--AND ReviewedFlag=1 


--SELECT GatewayEDIResponseId
--FROM dbo.GatewayEDIResponse
--WHERE FileReceiveDate > '7/11/2012'
--AND PracticeEin='1598734238'
--AND CustomerIdCorrelated IS NULL
--AND PracticeIdCorrelated IS null

---- SF 00245180
--SELECT GatewayEDIResponseId
--FROM dbo.GatewayEDIResponse 
--WHERE PracticeEin='1447318696' 
--AND FileReceiveDate > '7/11/2012' AND CustomerIdCorrelated=3571
/*
update proxymedresponse 
set reviewedflag=0, 
customeridcorrelated=3413, 
practiceidcorrelated=1, 
practiceein='870794948' 
where proxymedresponseid in ( 
SELECT ProxymedResponseId 
FROM dbo.ProxymedResponse 
WHERE FileReceiveDate > '12/19/2011' 
AND CustomerIdCorrelated=613 AND PracticeIdCorrelated=7 
AND ReviewedFlag=1 )

UPDATE dbo.GatewayEDIResponse
SET CustomerIdCorrelated=856, PracticeIdCorrelated=15
WHERE GatewayEDIResponseId IN (
SELECT GatewayEDIResponseId
FROM dbo.GatewayEDIResponse
WHERE FileReceiveDate > '12/19/2011'
AND PracticeEin='1598734238'
AND CustomerIdCorrelated IS NULL
AND PracticeIdCorrelated IS null)

update GatewayEDIResponse
SET CustomerIdCorrelated=1117, PracticeIdCorrelated=2, reviewedflag=0
Where GatewayEDIResponseId IN (
SELECT GatewayEDIResponseId
FROM dbo.GatewayEDIResponse 
WHERE PracticeEin='1447318696' 
AND FileReceiveDate > '12/19/2011' AND CustomerIdCorrelated=3571)
*/

-- Forwarding claim transactions to Kareo
select * from vwClaimMessageTransactionAgeByHour order by hourofday

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

-- Missing files from external vendors
select PrefetcherFileId, FileReceiveDate, errors, result, count, startedutc, durationms, PayerGatewayId, ResponseType, SourceAddress, FileName, FileStorageLocation, TIMESTAMP
from prefetcherfile
where errors is not NULL AND result = 1
and filereceivedate > dateadd(d, -30, getdate())
AND FileReceiveDate > '2012-05-08'
AND FileName NOT LIKE '%.enc' AND errors NOT LIKE '%directorynotfoundex%' --AND SourceAddress NOT LIKE '%proxymed%' AND SourceAddress NOT LIKE '%ally%'
order by filereceivedate desc

/*
-- Biggest files since a certain day from clearnghouse
SELECT TOP 100 FileName, Count, FileReceiveDate, FileStorageLocation,DATALENGTH(data)
FROM dbo.PrefetcherFile
WHERE FileReceiveDate > '2/21/11'
ORDER BY DATALENGTH(data) desc

select *
from prefetcherfile	
where filename like '%GD004250_MR060_20101215_003451%'
and filereceivedate > '12/15/2010'

select *
from gatewayediresponse
where filename like '%E5946691%'
and filereceivedate > '8/1/2011'

Change name so file will get downloaded again if posted (P09102D270660287U0_6371.rmt.pgp)
BEGIN TRAN
UPDATE PrefetcherFile SET FileName = FileName + '.not.processed' WHERE PrefetcherFileId in (1783575,1783590,1783599,1783602,1783607,1783615,1783617,1783621,1783624,1783627,1783629,1783635,1783637,1783640,1783646,1783648,1783650,1783653,1783655,1783673,1783674,1783677,1783681,1783685,1783692,1783695,1783699,1783702,1783705,1783710)
COMMIT TRAN

-- See if remit got downloaded again
select PrefetcherFileId, FileReceiveDate, errors, result, count, startedutc, durationms, PayerGatewayId, ResponseType, SourceAddress, FileName, FileStorageLocation, TIMESTAMP
from prefetcherfile
where filereceivedate > '8/20/2010 9:00am'
and filename like '%881288089%'
order by filereceivedate desc

-- Check to see which claim transactions were posted from the original ProxymedResponseID (source ID)
SELECT * 
FROM dbo.PayerGatewayResponse
WHERE SourceResponseId  in (1961787, 1961785, 1920845)
and payergatewayresponsetypecode='era'

select *
from proxymedresponse
where filereceivedate > '4/1/2011 9:20am'
and filename like '%GD006538_MR042_20110419_002222%'
order by filereceivedate desc

select *
from gatewayediresponse
where filereceivedate > '7/1/2011'
and filename like '%880058737%'
order by filereceivedate desc
*/

-- Recent files received
declare @FilesReceived table (
			GatewayLatestFileReceived		datetime,
			GatewayLatestFileProcessed		datetime,
			ProxymedLatestFileReceived		datetime,
			ProxymedLatestFileProcessed		datetime,
			OfficeAllyLatestFileReceived	datetime,
			OfficeAllyLatestFileProcessed	datetime
			)

insert into @FilesReceived
select		(select max(filereceivedate)
			from gatewayediresponse) as GatewayLatestFileReceived,	-- prefetcher (gateway-gatewayedi log)
			(select max(filereceivedate)
			from gatewayediresponse
			where reviewedflag=1) as GatewayLatestFileProcessed,	-- (forwardergatewayediresponse log)
			(select max(filereceivedate)
			from proxymedresponse) as ProxymedLatestFileReceived,	-- prefetcher (gateway-proxymed log)
			(select max(filereceivedate)
			from proxymedresponse
			where reviewedflag=1) as ProxymedLatestFileProcessed,	-- (forwarderproxymedresponse log)
			(select max(filereceivedate)
			from officeallyresponse) as OfficeAllyLatestFileReceived,	-- prefetcher (gateway-officeally log)
			(select max(filereceivedate)
			from officeallyresponse
			where reviewedflag=1) as OfficeAllyLatestFileProcessed	-- (forwarderofficeallyresponse log)

select	GatewayLatestFileReceived,
		case when GatewayLatestFileReceived < dateadd(hh, -2, getdate()) then 1 else 0 end as GatewayFileReceivedBeyondThreshold,
		GatewayLatestFileProcessed,	   
		case when GatewayLatestFileProcessed < dateadd(hh, -2, getdate()) then 1 else 0 end as GatewayLatestFileProcessedBeyondThreshold		
from	@FilesReceived

select	ProxymedLatestFileReceived,
		case when ProxymedLatestFileReceived < dateadd(hh, -2, getdate()) then 1 else 0 end as ProxymedFileReceivedBeyondThreshold,
		ProxymedLatestFileProcessed,	   
		case when ProxymedLatestFileProcessed < dateadd(hh, -2, getdate()) then 1 else 0 end as ProxymedLatestFileProcessedBeyondThreshold		
from	@FilesReceived

select	OfficeAllyLatestFileReceived,
		case when OfficeAllyLatestFileReceived < dateadd(hh, -2, getdate()) then 1 else 0 end as OfficeAllyFileReceivedBeyondThreshold,
		OfficeAllyLatestFileProcessed,	   
		case when OfficeAllyLatestFileProcessed < dateadd(hh, -2, getdate()) then 1 else 0 end as OfficeAllyLatestFileProcessedBeyondThreshold		
from	@FilesReceived

-- Next file to send to GatewayEDI
SELECT MIN(BTVLD.CreatedDate) as GatewayNextFileToSend,	-- BatchSender
	   COUNT(*) as GatewayTotalToSend, 
	   case when MIN(BTVLD.CreatedDate) < dateadd(hh, -2, getdate()) then 1 else 0 end as GatewayNextFileToSendBeyondThreshold
FROM BatchTransaction BTVLD
JOIN Batch B ON B.BatchId = BTVLD.BatchID
LEFT OUTER JOIN PayerGateway PG ON PG.PayerGatewayId = B.PayerGatewayId
WHERE
  B.RoutingType = 'SEND' AND B.result = 0 AND B.count > 0
  AND PG.PayerGatewayId IS NOT NULL AND PG.Active = 1
  AND BTVLD.BatchTransactionTypeCode in ('NEW')				-- ('VLD')
  AND BTVLD.BatchProcessed = 0
  --AND NOT EXISTS (SELECT BatchTransactionID FROM BatchTransaction
		--	 WHERE BatchId = BTVLD.BatchId
		--	 AND (BatchTransactionTypeCode LIKE 'E\_%' ESCAPE('\')
		--		OR BatchTransactionTypeCode IN ('SNT','SNF','SNR','KIL'))
		--)
  AND B.GatewayClass = 'GatewayEDI'

-- Next file to send to Capario
SELECT MIN(BTVLD.CreatedDate) as ProxymedNextFileToSend,	-- BatchSender
	   COUNT(*) as ProxymedTotalToSend, 
	   case when MIN(BTVLD.CreatedDate) < dateadd(hh, -2, getdate()) then 1 else 0 end as ProxymedNextFileToSendBeyondThreshold
FROM BatchTransaction BTVLD
JOIN Batch B ON B.BatchId = BTVLD.BatchID
LEFT OUTER JOIN PayerGateway PG ON PG.PayerGatewayId = B.PayerGatewayId
WHERE
  B.RoutingType = 'SEND' AND B.result = 0 AND B.count > 0
  AND PG.PayerGatewayId IS NOT NULL AND PG.Active = 1
  AND BTVLD.BatchTransactionTypeCode in ('NEW')				-- ('VLD')
  AND BTVLD.BatchProcessed = 0
  --AND NOT EXISTS (SELECT BatchTransactionID FROM BatchTransaction
		--	 WHERE BatchId = BTVLD.BatchId
		--	 AND (BatchTransactionTypeCode LIKE 'E\_%' ESCAPE('\')
		--		OR BatchTransactionTypeCode IN ('SNT','SNF','SNR','KIL'))
		--)
  AND B.GatewayClass = 'Proxymed'
  


-- Next file to send to Office Ally
SELECT MIN(BTVLD.CreatedDate) as OfficeAllyNextFileToSend,	-- BatchSender
	   COUNT(*) as OfficeAllyTotalToSend,
	   case when MIN(BTVLD.CreatedDate) < dateadd(hh, -2, getdate()) then 1 else 0 end as OfficeAllyNextFileToSendBeyondThreshold
FROM BatchTransaction BTVLD
JOIN Batch B ON B.BatchId = BTVLD.BatchID
LEFT OUTER JOIN PayerGateway PG ON PG.PayerGatewayId = B.PayerGatewayId
WHERE
  B.RoutingType = 'SEND' AND B.result = 0 AND B.count > 0
  AND PG.PayerGatewayId IS NOT NULL AND PG.Active = 1
  AND BTVLD.BatchTransactionTypeCode in ('NEW')				-- ('VLD')
  AND BTVLD.BatchProcessed = 0
  --AND NOT EXISTS (SELECT BatchTransactionID FROM BatchTransaction
		--	 WHERE BatchId = BTVLD.BatchId
		--	 AND (BatchTransactionTypeCode LIKE 'E\_%' ESCAPE('\')
		--		OR BatchTransactionTypeCode IN ('SNT','SNF','SNR','KIL'))
		--)
  AND B.GatewayClass = 'OfficeAlly'

-- Last file scheduled to go out
SELECT MAX(BTVLD.CreatedDate) as MostRecentFileToSend,
	   case when MAX(BTVLD.CreatedDate) < dateadd(hh, -2, getdate()) then 1 else 0 end as MostRecentFileToSendBeyondThreshold
FROM BatchTransaction BTVLD
JOIN Batch B ON B.BatchId = BTVLD.BatchID
LEFT OUTER JOIN PayerGateway PG ON PG.PayerGatewayId = B.PayerGatewayId
WHERE
  B.RoutingType = 'SEND' AND B.result = 0 AND B.count > 0
  AND PG.PayerGatewayId IS NOT NULL AND PG.Active = 1
  AND BTVLD.BatchTransactionTypeCode in ('NEW')				-- ('VLD')

-- Claim transactions scheduled to post - ClaimMessageCorrelator
SELECT MIN(PGR.CreatedDate) AS OldestTransactionToPost,
		MAX(PGR.CreatedDate) AS NewestTransactionToPost,
	   COUNT(*) AS TotalTransactionsToPost,
	   case when MIN(PGR.CreatedDate) < dateadd(hh, -2, getdate()) then 'Yes' else 'No' end as OldestTransactionToPostBeyondThreshold
FROM	PayerGatewayResponse PGR 
WHERE PGR.ProcessedFlag = 0


-- ClaimMessage rows validated but not yet batched
--SELECT COUNT(DISTINCT(CMTVLD.ClaimMessageId)) AS ClaimsToBatch, MIN(CMTVLD.CreatedDate) AS OldestClaimToBatch
--	FROM         ClaimMessageTransaction CMTVLD
--	INNER JOIN dbo.ClaimMessage cm ON CMTVLD.ClaimMessageId = cm.ClaimMessageId
--	WHERE CMTVLD.ClaimMessageId > 800000		-- ignore really old ones
--	 AND CMTVLD.ClaimMessageTransactionTypeCode in ('VLD')
--	 AND NOT EXISTS (SELECT ClaimMessageTransactionID FROM ClaimMessageTransaction CMT
--				 WHERE CMT.ClaimMessageId = CMTVLD.ClaimMessageId
--				 AND (CMT.ClaimMessageTransactionTypeCode LIKE 'E\_%' ESCAPE('\')
--					OR CMT.ClaimMessageTransactionTypeCode IN ('BTC'))
--			)
--	 AND (DATEADD(minute,15,(SELECT TOP 1 CMT1.TransactionTimeStamp FROM ClaimMessageTransaction CMT1
--		 WHERE CMT1.ClaimMessageId = CMTVLD.ClaimMessageId 
--		 AND CMTVLD.ClaimMessageTransactionTypeCode  = 'VLD'
--		 ORDER BY CMT1.TransactionTimeStamp DESC)) < GETDATE())
	
	
-- 'Ready' EDI Bills awaiting pickup from Shared.BizClaimsEDIBill
SELECT MIN(CreatedDate) AS OldestReadyEDIBill, COUNT(*) AS ReadyEDIBills
FROM SHAREDSERVER.superbill_shared.dbo.BizClaimsEDIBill BE
INNER JOIN SHAREDSERVER.superbill_shared.dbo.CustomerUsers CU	-- We only want customers that bizclaims@kareo.com has access to
	ON CU.CustomerID = BE.CustomerID
WHERE BillStateCode = 'R' AND ConfirmedDate IS NOT NULL AND CreatedDate > DATEADD(d,-5,GETDATE()) AND CU.UserID = 519

--UPDATE dbo.Active SET Active = 1

-- Unforwarded Responses --

SELECT  MIN(FileReceiveDate) AS OldestUnforwardedGatewayEDIResponse, COUNT(*) AS GatewayEDIResponsesToSend
FROM    GatewayEDIResponse GER
        LEFT JOIN TaxId TI ON GER.PracticeEin = TI.TaxId
WHERE   GER.ReviewedFlag = 0
        AND GER.PracticeId = -3
        AND GER.PracticeEin IS NOT NULL
        AND ((GER.CustomerIdCorrelated IS NOT NULL
              AND GER.PracticeIdCorrelated IS NOT NULL)
             OR (TI.TaxIdType IS NOT NULL
                 AND TI.CustomerId IS NOT NULL
                 AND TI.PracticeId IS NOT NULL
                 AND ISNULL(TI.Approved, 0) = 0
                 AND GER.ResponseType = 33))
                 
	
SELECT  MIN(FileReceiveDate) AS OldestUnforwardedProxymedResponse, COUNT(*) AS ProxymedResponsesToSend
FROM    ProxymedResponse PR
        LEFT JOIN TaxId TI ON PR.PracticeEin = TI.TaxId
WHERE   PR.ReviewedFlag = 0
        AND PR.PracticeId = -3     -- AND PR.PracticeEin IS NOT NULL
        AND ((PR.CustomerIdCorrelated IS NOT NULL
              AND PR.PracticeIdCorrelated IS NOT NULL)
             OR (TI.TaxIdType IS NOT NULL
                 AND TI.CustomerId IS NOT NULL
                 AND TI.PracticeId IS NOT NULL
                 AND ISNULL(TI.Approved, 0) = 0))

SELECT  MIN(FileReceiveDate) AS OldestUnforwardedOfficeAllyResponse, COUNT(*) AS OfficeAllyResponsesToSend
FROM    OfficeAllyResponse PR
        LEFT JOIN TaxId TI ON PR.PracticeEin = TI.TaxId
WHERE   PR.ReviewedFlag = 0
        AND PR.PracticeId = -3
        AND PR.PracticeEin IS NOT NULL
        AND ((PR.CustomerIdCorrelated IS NOT NULL
              AND PR.PracticeIdCorrelated IS NOT NULL)
             OR (TI.TaxIdType IS NOT NULL
                 AND TI.CustomerId IS NOT NULL
                 AND TI.PracticeId IS NOT NULL
                 AND ISNULL(TI.Approved, 0) = 0))
		
SELECT  MIN(FileReceiveDate) AS OldestUnforwardedBizclaimsResponse, COUNT(*) AS BizclaimsResponseToSend
FROM    BizclaimsResponse BCR
        LEFT JOIN TaxId TI ON BCR.PracticeEin = TI.TaxId
WHERE   BCR.ReviewedFlag = 0
        AND BCR.PracticeEin IS NOT NULL
        AND ((BCR.CustomerIdCorrelated IS NOT NULL
              AND BCR.PracticeIdCorrelated IS NOT NULL)
             OR (TI.TaxIdType IS NOT NULL
                 AND TI.CustomerId IS NOT NULL
                 AND TI.PracticeId IS NOT NULL
                 AND ISNULL(TI.Approved, 0) = 0))

-- Find 'NEW' batchtransactions that are processed, but do not have a corresponding result row
--SELECT *
--FROM dbo.BatchTransaction
--WHERE batchid IN (
--SELECT batchid FROM dbo.BatchTransaction
--WHERE BatchProcessed = 1 AND CreatedDate > '7/30/12' AND BatchTransactionTypeCode = 'new'
--AND batchid IN (SELECT batchid FROM dbo.BatchTransaction
--GROUP BY BatchId
--HAVING count(*) = 1))

-- Requeue failed items
--BEGIN TRAN
--UPDATE dbo.BatchTransaction
--SET BatchProcessed = 0
--WHERE batchid IN (
--SELECT batchid FROM dbo.BatchTransaction
--WHERE BatchProcessed = 1 AND CreatedDate < DATEADD(HOUR,-12,GETDATE()) AND BatchTransactionTypeCode = 'new' and createddate > '7/30/12'
--AND batchid IN (SELECT batchid FROM dbo.BatchTransaction
--GROUP BY BatchId
--HAVING count(*) = 1))
--COMMIT TRAN

          
--SELECT PrefetcherFileId, PF.FileName, PF.FileReceiveDate, PF.FileStorageLocation, pf.errors
--FROM    dbo.PrefetcherFile PF
--        LEFT JOIN dbo.GatewayEDIResponse GResp ON PF.FileName = GResp.FileName
--        LEFT JOIN dbo.ProxymedResponse PResp ON PF.FileName = PResp.FileName
--        LEFT JOIN dbo.OfficeAllyResponse OResp ON PF.FileName = OResp.FileName
--WHERE   (GResp.FileName IS NULL
--         AND OResp.FileName IS NULL
--         AND PResp.FileName IS NULL)
--         AND PF.FileReceiveDate < DATEADD(HOUR,-4, GETDATE())
--         AND PF.FileReceiveDate > DATEADD(MONTH,-3, GETDATE())
--         AND ((PF.errors NOT LIKE '%decrypt_message failed%' AND PF.errors NOT LIKE '%gpg: encrypted with 1024-bit%') OR PF.errors IS NULL)
--ORDER BY PF.FileReceiveDate DESC     

--UPDATE dbo.Active SET Active = 1
