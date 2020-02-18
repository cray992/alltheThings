
-- to populate Payer table from whatever claims we have already processed:

	DECLARE @ClaimMessageId int
	DECLARE @RoutingPayerType varchar(30)
	DECLARE @RoutingPayerName varchar(128) 
	DECLARE @RoutingPayerNumber varchar(30)
	DECLARE @RoutingRoutingPreference varchar(512) 

	DECLARE payer_sync_cursor CURSOR
	READ_ONLY
	FOR 	SELECT CM.ClaimMessageId, CM.RoutingPayerType, CM.RoutingPayerName, CM.RoutingPayerNumber, CM.RoutingRoutingPreference
			FROM dbo.ClaimMessage CM
	
	OPEN payer_sync_cursor


	FETCH NEXT FROM payer_sync_cursor INTO @ClaimMessageId, @RoutingPayerType, @RoutingPayerName, @RoutingPayerNumber, @RoutingRoutingPreference
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN

			PRINT 'Processing ClaimMessageId=' + CAST(@ClaimMessageId AS VARCHAR(32))

			DECLARE @PayerNotes varchar(128)
			SET @PayerNotes = 'populate - by ClaimMessageId ' + CAST(@ClaimMessageId AS VARCHAR(64))
		
			exec BCDataProvider_CreatePayerIfMissing @RoutingPayerType, @RoutingPayerName, @RoutingPayerNumber, @RoutingRoutingPreference, @PayerNotes

		END
		FETCH NEXT FROM payer_sync_cursor INTO @ClaimMessageId, @RoutingPayerType, @RoutingPayerName, @RoutingPayerNumber, @RoutingRoutingPreference
	END
	CLOSE payer_sync_cursor
	DEALLOCATE payer_sync_cursor
