-- TODO;
--   1) Add some WAITFOR 1 second delays to allow other processes to get a hold of any locks, etc

SET DEADLOCK_PRIORITY -10

-- UPDATE dbo.Active SET Active = 0

-- Run each item by hand plz kthx
RETURN;

-- HandyStorage

PRINT 'Deleting from [HandyStorage]'

DECLARE @maxHandyStorageIdToDelete INT

SELECT  @maxHandyStorageIdToDelete = MAX(HandyStorageId)
FROM    dbo.HandyStorage
WHERE   CreatedDate < DATEADD(m, -2, GETDATE())

WHILE 1 = 1 
    BEGIN

        DELETE TOP (5000)
        FROM    dbo.HandyStorage
        WHERE   HandyStorageId <= @maxHandyStorageIdToDelete

        IF @@rowcount = 0 
            BREAK ;

    END

PRINT 'Deleted from [HandyStorage]'


-- PrefetcherFile
-- NOTE: We cannot delete ERAs (ResponeType == 33) since these are used by the app to pull the original 835.
-- See 'BillDataProvider_GetPrefetchedFileCmd.sql'

PRINT 'Deleting from [PrefetcherFile]'

DECLARE @maxPrefetcherFileIdToDelete INT

SELECT  @maxPrefetcherFileIdToDelete = MAX(PrefetcherFileId)
FROM    dbo.PrefetcherFile
WHERE   FileReceiveDate < DATEADD(m, -3, GETDATE())

-- SELECT COUNT(*) FROM dbo.PrefetcherFile WHERE   FileReceiveDate < DATEADD(m, -3, GETDATE())

WHILE 1 = 1 
    BEGIN

        DELETE TOP (2000)
        FROM    dbo.PrefetcherFile
        WHERE   PrefetcherFileId <= @maxPrefetcherFileIdToDelete AND ResponseType <> 33

        IF @@rowcount = 0 
            BREAK ;

    END

PRINT 'Deleted from [PrefetcherFile]'


-- Batch & BatchTransaction

-- Is this necessary (i.e. how much space is used).  Nice to see when we sent a file -> perhaps just blow away the 'data' columns
	--PRINT 'Deleting from [Batch] and [BatchTransaction]'

	--DECLARE @maxBatchIdToDelete INT

	--SELECT  @maxBatchIdToDelete = MAX(batchid)
	--FROM    dbo.Batch
	--WHERE   CreatedDate < DATEADD(m, -3, GETDATE())

	--ALTER TABLE dbo.BatchTransaction NOCHECK CONSTRAINT FK_BatchTransaction_Batch

	--WHILE 1 = 1 
	--	BEGIN

	--		BEGIN TRAN

	--		DECLARE @deletedBatchIds TABLE (BatchId INT)

	--		DELETE TOP (5000)
	--				dbo.Batch
	--		OUTPUT  DELETED.BatchId
	--				INTO @deletedBatchIds
	--		FROM    dbo.Batch
	--		WHERE   BatchId <= @maxBatchIdToDelete


	--		DELETE  FROM dbo.BatchTransaction
	--		WHERE   BatchId IN (SELECT  BatchId
	--							FROM    @deletedBatchIds)

	--		IF (SELECT  COUNT(*)
	--			FROM    @deletedBatchIds) = 0 
	--			BEGIN
	--				COMMIT TRAN
	--				BREAK ;
	--			END

	--		DELETE  FROM @deletedBatchIds

	--		COMMIT TRAN

	--	END

	--ALTER TABLE dbo.BatchTransaction CHECK  CONSTRAINT FK_BatchTransaction_Batch ;
	--ALTER TABLE dbo.BatchTransaction WITH CHECK CHECK CONSTRAINT ALL ;

	--PRINT 'Deleted from [Batch] and [BatchTransaction]'

-- SELECT COUNT(*) FROM dbo.BatchTransaction bt
-- WHERE NOT EXISTS (SELECT batchid FROM batch b where bt.batchid = b.batchid)

-- GatewayEDIResponse

PRINT 'Deleting from [GatewayEDIResponse]'

DECLARE @maxGatewayEDIResponseIdToDelete INT
SELECT  @maxGatewayEDIResponseIdToDelete = MAX(GatewayEDIREsponseID)
FROM    dbo.GatewayEDIResponse
WHERE   FileReceiveDate < DATEADD(m, -3, GETDATE())

-- SELECT COUNT(*) FROM    dbo.GatewayEDIResponse WHERE   FileReceiveDate < DATEADD(m, -3, GETDATE())

WHILE 1 = 1 
    BEGIN

        DELETE TOP (5000)
        FROM    dbo.GatewayEDIResponse
        WHERE   GatewayEDIResponseId <= @maxGatewayEDIResponseIdToDelete

        IF @@ROWCOUNT = 0 
            BREAK ;
		
    END

PRINT 'Deleted from [GatewayEDIResponse]'


-- ProxymedResponse

PRINT 'Deleting from [ProxymedResponse]'

DECLARE @maxProxymedResponseIdToDelete INT
SELECT  @maxProxymedResponseIdToDelete = MAX(ProxymedResponseId)
FROM    dbo.ProxymedResponse
WHERE   FileReceiveDate < DATEADD(m, -3, GETDATE())

-- SELECT COUNT(*) FROM    dbo.ProxymedResponse WHERE   FileReceiveDate < DATEADD(m, -3, GETDATE())

WHILE 1 = 1 
    BEGIN

        DELETE TOP (5000)
        FROM    dbo.ProxymedResponse
        WHERE   ProxymedResponseId <= @maxProxymedResponseIdToDelete

        IF @@ROWCOUNT = 0 
            BREAK ;
		
    END

PRINT 'Deleted from [ProxymedResponse]'


-- OfficeAllyResponse

PRINT 'Deleting from [OfficeAllyResponse]'

DECLARE @maxOfficeAllyResponseIdToDelete INT
SELECT  @maxOfficeAllyResponseIdToDelete = MAX(OfficeAllyResponseId)
FROM    dbo.OfficeAllyResponse
WHERE   FileReceiveDate < DATEADD(m, -3, GETDATE())

WHILE 1 = 1 
    BEGIN

        DELETE TOP (5000)
        FROM    dbo.OfficeAllyResponse
        WHERE   OfficeAllyResponseId <= @maxOfficeAllyResponseIdToDelete

        IF @@ROWCOUNT = 0 
            BREAK ;
		
    END

PRINT 'Deleted from [OfficeAllyResponse]'


-- BizClaimsResponse

PRINT 'Deleting from [BizClaimsResponse]'

DECLARE @maxBizClaimsResponseIdToDelete INT
SELECT  @maxBizClaimsResponseIdToDelete = MAX(BizClaimsResponseId)
FROM    dbo.BizClaimsResponse
WHERE   FileReceiveDate < DATEADD(m, -3, GETDATE())

WHILE 1 = 1 
    BEGIN

        DELETE TOP (5000)
        FROM    dbo.BizClaimsResponse
        WHERE   BizClaimsResponseId <= @maxBizClaimsResponseIdToDelete

        IF @@ROWCOUNT = 0 
            BREAK ;
		
    END

PRINT 'Deleted from [BizClaimsResponse]'


-- PayerGatewayResponse

PRINT 'Deleting from [PayerGatewayResponse]'

DECLARE @maxPayerGatewayResponseIdToDelete INT
SELECT  @maxPayerGatewayResponseIdToDelete = MAX(PayerGatewayResponseId)
FROM    dbo.PayerGatewayResponse
WHERE   CreatedDate < DATEADD(m, -3, GETDATE())

WHILE 1 = 1 
    BEGIN

        DELETE TOP (5000)
        FROM    dbo.PayerGatewayResponse
        WHERE   PayerGatewayResponseId <= @maxPayerGatewayResponseIdToDelete

        IF @@ROWCOUNT = 0 
            BREAK ;
		
    END

PRINT 'Deleted from [PayerGatewayResponse]'


-- ClaimMessage	& ClaimMessageTransaction, part 1

PRINT 'Deleting from [ClaimMessage] and [ClaimMessageTransaction]'

DECLARE @maxClaimMessageIdToDelete INT
SELECT  @maxClaimMessageIdToDelete = MAX(ClaimMessageId)
FROM    dbo.ClaimMessage
WHERE   CreatedDate < DATEADD(m,-6,DATEADD(year, -1, GETDATE()))	-- uh, this is weird.  just set it back 18 months?
																	-- for some reason of another, we still get responses for very old claim messages
																	-- ex: Response received for claim created '2010-02-24 15:38:16.000' on '2012-01-29'
																	-- (perhaps we don't insert duplicate ClaimMessage_K9Nums
																	
--SELECT  COUNT(*) FROM    dbo.ClaimMessage WHERE   CreatedDate < DATEADD(m,-3,DATEADD(year, -1, GETDATE()))

ALTER TABLE dbo.ClaimMessageTransaction NOCHECK CONSTRAINT FK_ClaimMessageTransaction_ClaimMessage

WHILE 1 = 1 
    BEGIN


-- Change this so we don't actually delete the ClaimMessage row (to deal with super old claims getting responses)
-- Instead delete all ClaimMessageTransaction rows except those that would cause the message to be batched again
-- See BCDataProvider_GetReadyForBatchingClaimMessages
-- Note, we might still be able to delete all the ClaimMessageTransaction rows, since the BCDataProvider_GetReadyForBatchingClaimMessages sproc
-- looks requires VLD rows (at what point do we add the VLDs?  I think this is part of the RTSendAdapter orchestration)    
BREAK:

        BEGIN TRAN

        DECLARE @deletedClaimMessageIds TABLE (ClaimMessageID INT)

        DELETE TOP (5000)
                dbo.ClaimMessage
        OUTPUT  DELETED.ClaimMessageId
                INTO @deletedClaimMessageIds
        FROM    dbo.ClaimMessage
        WHERE   ClaimMessageId <= @maxClaimMessageIdToDelete


        DELETE  FROM dbo.ClaimMessageTransaction
        WHERE   ClaimMessageId IN (SELECT   ClaimMessageId
                                   FROM     @deletedClaimMessageIds)

        IF (SELECT  COUNT(*)
            FROM    @deletedClaimMessageIds) = 0 
            BEGIN
                COMMIT TRAN
                BREAK ;
            END
            
        DELETE  FROM @deletedClaimMessageIds

        COMMIT TRAN

    END

ALTER TABLE ClaimMessageTransaction CHECK  CONSTRAINT FK_ClaimMessageTransaction_ClaimMessage ;
ALTER TABLE ClaimMessageTransaction WITH CHECK CHECK CONSTRAINT ALL ;

PRINT 'Deleted from [ClaimMessage] and [ClaimMessageTransaction]'

-- Clean up broken references (e.g. when delete process is stopped in a partially complete state
-- SELECT COUNT(*) FROM dbo.ClaimMessageTransaction cmt
-- WHERE NOT EXISTS (SELECT * FROM dbo.ClaimMessage cm WHERE cm.ClaimMessageId = cmt.ClaimMessageId)

-- DELETE dbo.ClaimMessageTransaction
-- FROM dbo.ClaimMessageTransaction CMT
-- WHERE NOT EXISTS (SELECT * FROM dbo.ClaimMessage CM WHERE CM.ClaimMessageId = CMT.ClaimMessageId)

-- ClaimMessage, part 2 - Delete the 'data' column

PRINT 'Deleting "data" column from [ClaimMessage]'

DECLARE @maxClaimMessageIdToPurge INT
DECLARE @startRangeDateTime DATETIME
DECLARE @endRangeDateTime DATETIME

SELECT  @maxClaimMessageIdToPurge = MAX(ClaimMessageId), @startRangeDateTime = MIN(CreatedDate)
FROM    dbo.ClaimMessage
WHERE   CreatedDate < DATEADD(m, -3, GETDATE()) AND CreatedDate > '10/28/2011'


WHILE 1 = 1 
    BEGIN

		SET @endRangeDateTime = DATEADD(hour, 4, @startRangeDateTime)

		PRINT 'Deleteing "data" column between ' + CAST(@startRangeDateTime AS VARCHAR(MAX)) + ' and ' + CAST(@endRangeDateTime AS VARCHAR(MAX))
		
		-- Set in 'data' = NULL for the @currenDayToPurge
        UPDATE  dbo.ClaimMessage
        SET     data = NULL
        WHERE   CreatedDate BETWEEN @startRangeDateTime
                            AND     @endRangeDateTime
                            AND data IS NOT NULL
              
        SET @startRangeDateTime = @endRangeDateTime
       
        IF @startRangeDateTime > DATEADD(m, -3, GETDATE()) 
            BREAK
		
    END

PRINT 'Deleted "data" column from [ClaimMessage]'



/* 
	ClaimMessageTransaction, part 2 - Delete ClaimMessageTransactions, but not its parent ClaimMessage.
	-------------------------------------------------------------------------------------------------------
	This is safe so long as all E_V, VLD, and BTC messages are deleted.
	There should only be one of these per parent ClaimMessageId... except when there isn't...
	Multiple 'BTC' items happened on 2009-06-09 (1000+) and 2010-08-17 (2).
*/ 

PRINT 'Deleting from [ClaimMessageTransaction]'

DECLARE @maxClaimMessageTransactionIdToDelete INT
SELECT  @maxClaimMessageTransactionIdToDelete = MAX(ClaimMessageTransactionId)
FROM    dbo.ClaimMessageTransaction WITH (INDEX(IX_ClaimMessageTransaction_Forwarded_CreatedDate_ClaimMessageTransactionTypeCode))
WHERE   CreatedDate < DATEADD(m, -3, GETDATE())

--SELECT @maxClaimMessageTransactionIdToDelete

WHILE 1 = 1 
    BEGIN

		BEGIN TRAN

        DELETE  dbo.ClaimMessageTransaction
        FROM    dbo.ClaimMessageTransaction CMT
        WHERE   ClaimMessageId IN (SELECT TOP 2000
                                            ClaimMessageId
                                   FROM     dbo.ClaimMessageTransaction
                                   WHERE    ClaimMessageTransactionId <= @maxClaimMessageTransactionIdToDelete)
		
		IF @@ROWCOUNT = 0
		BEGIN
			COMMIT TRAN
			BREAK;
		END
		
		COMMIT TRAN
			
    END

PRINT 'Deleted from [ClaimMessageTransaction]'


-- UPDATE STATISTICS BRO

UPDATE STATISTICS dbo.Batch WITH FULLSCAN
UPDATE STATISTICS dbo.BatchTransaction WITH FULLSCAN

UPDATE STATISTICS dbo.ClaimMessage WITH FULLSCAN
UPDATE STATISTICS dbo.ClaimMessageTransaction WITH FULLSCAN
UPDATE STATISTICS dbo.ClaimMessage_K9Number WITH FULLSCAN
UPDATE STATISTICS dbo.ClaimMessage_K9Numbers WITH FULLSCAN

UPDATE STATISTICS dbo.BizclaimsResponse WITH FULLSCAN
UPDATE STATISTICS dbo.GatewayEDIResponse WITH FULLSCAN
UPDATE STATISTICS dbo.OfficeAllyResponse WITH FULLSCAN
UPDATE STATISTICS dbo.PayerGatewayResponse WITH FULLSCAN
UPDATE STATISTICS dbo.ProxymedResponse WITH FULLSCAN

UPDATE STATISTICS dbo.TaxId WITH FULLSCAN


-- ROLLBACK

-- The indented blocks below are too small to worry about at this point

	-- ClaimMessage_K9Number

	--PRINT 'Deleting from [ClaimMessage_K9Number]'

	--WHILE 1 = 1 
	--    BEGIN
	--        DELETE TOP (1000)
	--                dbo.ClaimMessage_K9Number
	--        FROM    dbo.ClaimMessage_K9Number
	--        WHERE   ClaimMessageID NOT IN (SELECT   ClaimMessageID
	--                                       FROM     dbo.ClaimMessage)

	--        IF @@ROWCOUNT = 0 
	--            BREAK ;
	--    END

	--PRINT 'Deleted from [ClaimMessage_K9Number]'


	------ClaimMessage_K9Numbers

	--PRINT 'Deleting from [ClaimMessage_K9Numbers]'

	--WHILE 1 = 1 
	--    BEGIN

	--        DELETE TOP (1000)
	--                dbo.ClaimMessage_K9Numbers
	--        FROM    dbo.ClaimMessage_K9Numbers
	--        WHERE   ClaimMessageID NOT IN (SELECT   ClaimMessageID
	--                                       FROM     dbo.ClaimMessage)

	--        IF @@ROWCOUNT = 0 
	--            BREAK ;

	--    END

	--PRINT 'Deleted from [ClaimMessage_K9Numbers]'


	---- BizclaimsResponseClaimMessageTransaction.

	--PRINT 'Deleting from [BizclaimsResponseClaimMessageTransaction]'

	--WHILE 1 = 1 
	--    BEGIN

	--		-- Delete BizclaimsResponse items (rejection notifications) that have had their triggering ClaimMessageTransaction deleted (ClaimMessageTransactionTypeCode = 'E_V')
	--        DELETE TOP (1000)
	--                BizclaimsResponseClaimMessageTransaction
	--        FROM    dbo.BizclaimsResponseClaimMessageTransaction BRCMT
	--                LEFT OUTER JOIN ClaimMessageTransaction CMT ON CMT.ClaimMessageTransactionId = BRCMT.ClaimMessageTransactionId
	--        WHERE   CMT.ClaimMessageTransactionId IS NULL
		
	--        IF @@ROWCOUNT = 0 
	--            BREAK ;

	--    END

	--PRINT 'Deleted from [BizclaimsResponseClaimMessageTransaction]'


--SELECT DATEDIFF(d, cmt1.CreatedDate, cmt2.CreatedDate)
--FROM dbo.ClaimMessageTransaction cmt1
--INNER JOIN dbo.ClaimMessageTransaction cmt2 ON cmt1.ClaimMessageId = cmt2.ClaimMessageId AND cmt1.ClaimMessageTransactionId <> cmt2.ClaimMessageTransactionId
--WHERE DATEDIFF(d, cmt1.CreatedDate, cmt2.CreatedDate) > 365 AND cmt1.ClaimMessageTransactionTypeCode = 'NEW'
--ORDER BY DATEDIFF(d, cmt1.CreatedDate, cmt2.CreatedDate) desc
