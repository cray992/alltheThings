IF db_name() = 'superbill_0001_prod'
BEGIN
	-- Batch ID, Patient, and Date Range we are processing
	DECLARE @BatchID INT
	DECLARE @PracticeID INT
	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME

	SET @BatchID = 11885
	SET @PracticeID = 65
	SET @StartDate = '3/7/2006'
	SET @EndDate = '3/8/2006'

	-- Create a temp table to store the results of the bills and claims
	CREATE TABLE #t_billsandclaims(
		ClaimID int,
		BillID int,
		RID int IDENTITY(0,1)
	)

	-- Insert into temp table
	INSERT INTO #t_billsandclaims
	EXEC BillDataProvider_GetPatientStatementBillsAndClaims @BatchID

	-- Delete any claims that were already processed
	DELETE FROM #t_billsandclaims
	WHERE ClaimID IN
			(SELECT ClaimID 
			 FROM ClaimTransaction 
			 WHERE PracticeID = @PracticeID 
			 AND Code = 's'
			 AND CreatedDate > @StartDate
			 AND CreatedDate <= @EndDate)

	-- Loop through unprocessed claims and process them
	DECLARE @max INT
	DECLARE @current INT
	DECLARE @claim INT
	DECLARE @bill INT
	
	SELECT @current=MIN(RID), @max=MAX(RID) FROM #t_billsandclaims
	
	WHILE @current <= @max
	BEGIN
		SELECT	@claim = ClaimID,
				@bill = BillID
		FROM	#t_billsandclaims
		WHERE	RID = @current		

		EXEC BillDataProvider_CreatePatientStatementTransaction @BatchID, @claim, @bill

		SELECT @current=MIN(RID) FROM #t_billsandclaims WHERE RID > @current
	END

	-- Confirm the bill batch
	EXEC BillDataProvider_ConfirmBillBatch @BatchID

--	SELECT * FROM #t_billsandclaims
	DROP TABLE #t_billsandclaims
END