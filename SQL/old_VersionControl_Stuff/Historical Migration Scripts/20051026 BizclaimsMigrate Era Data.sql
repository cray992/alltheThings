
-- to populate HandyStorage table from ERAs we have already processed:

	DECLARE @PayerGatewayResponseId int
	DECLARE @ProxymedResponseId int
	DECLARE @ProxymedResponseIdLast int
	DECLARE @title varchar(2048)
	DECLARE @data varchar(1024)
	DECLARE @dataLast varchar(1024)
	DECLARE @HandyStorageId int

	SET @ProxymedResponseIdLast = -1
	SET @dataLast = ''
	SET @HandyStorageId = 0

	DECLARE pgr_cursor CURSOR
	READ_ONLY
	FOR 	SELECT PGR.PayerGatewayResponseId, PR.ProxymedResponseId, PR.Title, CAST(PGR.data AS varchar(1024))
			FROM dbo.PayerGatewayResponse PGR
			JOIN ProxymedResponse PR ON PR.ProxymedResponseId = PGR.SourceResponseId
		WHERE (PayerGatewayResponseTypeCode = 'era') ORDER BY PGR.PayerGatewayResponseId
	
	OPEN pgr_cursor


	FETCH NEXT FROM pgr_cursor INTO @PayerGatewayResponseId, @ProxymedResponseId, @title, @data
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN

			PRINT 'Processing PayerGatewayResponseId=' + CAST(@PayerGatewayResponseId AS VARCHAR(32))

			IF (@ProxymedResponseId <> @ProxymedResponseIdLast OR @data <> @dataLast)
			BEGIN

				DECLARE @MetaData varchar(2048)
				SET @MetaData = '<EraSt><ProxymedResponseId>' + CAST(@ProxymedResponseId AS VARCHAR(32)) + '</ProxymedResponseId><Title>' + @title + '</Title></EraSt>'
		
				INSERT HandyStorage
				SELECT 'era-st' AS DataType, @MetaData AS MetaData, data, GETDATE() AS CreatedDate, NULL FROM dbo.PayerGatewayResponse PGR WHERE PGR.PayerGatewayResponseId = @PayerGatewayResponseId

				SET @HandyStorageId = SCOPE_IDENTITY()

				PRINT 'Created HandyStorageId=' + CAST(@HandyStorageId AS VARCHAR(32))

				SET @ProxymedResponseIdLast = @ProxymedResponseId
				SET @dataLast = @data
			END

			DECLARE @NewData varchar(128)
			SET @NewData = '<HandyStorageId>' + CAST(@HandyStorageId AS VARCHAR(32)) + '</HandyStorageId>'
		
			PRINT @NewData

			UPDATE PayerGatewayResponse SET data = @NewData WHERE PayerGatewayResponseId = @PayerGatewayResponseId

		END
	FETCH NEXT FROM pgr_cursor INTO @PayerGatewayResponseId, @ProxymedResponseId, @title, @data
	END
	CLOSE pgr_cursor
	DEALLOCATE pgr_cursor
