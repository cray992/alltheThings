
-- to populate CustomerId, PracticeId fields in PayerGatewayResponse table:

	DECLARE @PayerGatewayResponseId int
	DECLARE	@CustomerId int
	DECLARE	@PracticeId int
	DECLARE	@PracticeEin varchar(30)

	DECLARE pr_cursor CURSOR
	READ_ONLY
	FOR 	SELECT PGR.PayerGatewayResponseId, PGR.PracticeEin
			FROM dbo.PayerGatewayResponse PGR
		WHERE PGR.PracticeEin IS NOT NULL AND LEN(PGR.PracticeEin) = 9 AND PGR.PayerGatewayResponseId < 109012
	
	OPEN pr_cursor


	FETCH NEXT FROM pr_cursor INTO @PayerGatewayResponseId, @PracticeEin
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN

--			PRINT 'Processing PayerGatewayResponseId=' + CAST(@PayerGatewayResponseId AS VARCHAR(32))

			SET @CustomerId = NULL
			SET @PracticeId = NULL

			exec dbo.BCDataProvider_GetCustomerPracticeByTaxId @PracticeEin, @CustomerId output, @PracticeId output

			IF (@CustomerId IS NOT NULL AND @PracticeId IS NOT NULL)
			BEGIN
				UPDATE PayerGatewayResponse
				SET CustomerId = @CustomerId, PracticeId = @PracticeId
				WHERE PayerGatewayResponseId = @PayerGatewayResponseId
			END

		END
	FETCH NEXT FROM pr_cursor INTO @PayerGatewayResponseId, @PracticeEin
	END
	CLOSE pr_cursor
	DEALLOCATE pr_cursor
