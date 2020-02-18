
-- to populate CustomerId, PracticeId fields in ProxymedResponse table:

	DECLARE @ProxymedResponseId int
	DECLARE	@CustomerIdCorrelated int
	DECLARE	@PracticeIdCorrelated int
	DECLARE	@PracticeEin varchar(30)

	DECLARE pr_cursor CURSOR
	READ_ONLY
	FOR 	SELECT PR.ProxymedResponseId, PR.PracticeEin
			FROM dbo.ProxymedResponse PR
		WHERE PR.PracticeEin IS NOT NULL AND LEN(PR.PracticeEin) = 9 AND PR.ProxymedResponseId < 12534
	
	OPEN pr_cursor


	FETCH NEXT FROM pr_cursor INTO @ProxymedResponseId, @PracticeEin
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN

--			PRINT 'Processing ProxymedResponseId=' + CAST(@ProxymedResponseId AS VARCHAR(32))

			SET @CustomerIdCorrelated = NULL
			SET @PracticeIdCorrelated = NULL

			exec dbo.BCDataProvider_GetCustomerPracticeByTaxId @PracticeEin, @CustomerIdCorrelated output, @PracticeIdCorrelated output

			IF (@CustomerIdCorrelated IS NOT NULL AND @PracticeIdCorrelated IS NOT NULL)
			BEGIN
				UPDATE ProxymedResponse
				SET CustomerIdCorrelated = @CustomerIdCorrelated, PracticeIdCorrelated = @PracticeIdCorrelated
				WHERE ProxymedResponseId = @ProxymedResponseId
			END

		END
	FETCH NEXT FROM pr_cursor INTO @ProxymedResponseId, @PracticeEin
	END
	CLOSE pr_cursor
	DEALLOCATE pr_cursor
