SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardDataProvider_UpdateKeyIndicatorsVolatileJobForPractice]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DashboardDataProvider_UpdateKeyIndicatorsVolatileJobForPractice]
GO


CREATE PROCEDURE dbo.DashboardDataProvider_UpdateKeyIndicatorsVolatileJobForPractice
	@PracticeID int = NULL
AS
BEGIN

	SET NOCOUNT ON

DECLARE 
	@EndDate datetime,
	@Current_BeginDate datetime,
	@Prior_BeginDate datetime,
	@Prior_EndDate datetime,
	@CurrentMonth int,
	@QuarterBeginMonth int

	DECLARE @PercentThreshold int
	DECLARE @PercentThresholdErrorValue float
	SET @PercentThreshold = 9999
	SET @PercentThresholdErrorValue = 9999.99


SELECT
	@EndDate = getdate()

	DECLARE @EndOfDayEndDate DATETIME
	SET @EndOfDayEndDate=DATEADD(S,-1,DATEADD(D,1,dbo.fn_DateOnly( @EndDate )))

	DECLARE @Calendar TABLE( PeriodType Char(1), Period char(1), BeginDate DATETIME, EndDate DATETIME )


-------------------- Sets the MTD --------------------------		
		SET @Current_BeginDate = CAST(MONTH(@EndOfDayEndDate) AS varchar(2)) + '/1/' + CAST(YEAR(@EndOfDayEndDate) AS varchar(4))
		SET @Prior_BeginDate = DATEADD(m,-1,@Current_BeginDate)
		SET @Prior_EndDate = DATEADD(m,-1,@EndOfDayEndDate)


		INSERT INTO @Calendar( PeriodType , Period , BeginDate , EndDate  )
		VALUES( 'M', 'C', @Current_BeginDate, @EndOfDayEndDate)

		INSERT INTO @Calendar( PeriodType , Period , BeginDate , EndDate  )
		VALUES( 'M', 'P', @Prior_BeginDate, @Prior_EndDate )

-------------------- Sets the Quater to Date ----------------
		SET @CurrentMonth = MONTH(@EndOfDayEndDate)
		IF @CurrentMonth IN (1,2,3)
			SET @QuarterBeginMonth = 1
		ELSE IF @CurrentMonth IN (4,5,6)
			SET @QuarterBeginMonth = 4
		ELSE IF @CurrentMonth IN (7,8,9)
			SET @QuarterBeginMonth = 7
		ELSE
			SET @QuarterBeginMonth = 10	
	
		SET @Current_BeginDate = CAST(@QuarterBeginMonth AS varchar(2)) + '/1/' + CAST(YEAR(@EndOfDayEndDate) AS varchar(4))
		SET @Prior_EndDate = DATEADD(q,-1,@EndOfDayEndDate)
		SET @Prior_BeginDate = DATEADD(q,-1,@Current_BeginDate)


		INSERT INTO @Calendar( PeriodType , Period , BeginDate , EndDate  )
		VALUES( 'Q', 'C', @Current_BeginDate, @EndOfDayEndDate)

		INSERT INTO @Calendar( PeriodType , Period , BeginDate , EndDate  )
		VALUES( 'Q', 'P', @Prior_BeginDate, @Prior_EndDate )
	

------------------ Sets Year to Date -----------------------
		SET @Current_BeginDate = '1/1/' + CAST(YEAR(@EndOfDayEndDate) AS varchar(4))
		SET @Prior_BeginDate = DATEADD(yyyy,-1,@Current_BeginDate)
		SET @Prior_EndDate = DATEADD(yyyy,-1,@EndOfDayEndDate)

		INSERT INTO @Calendar( PeriodType , Period , BeginDate , EndDate  )
		VALUES( 'Y', 'C', @Current_BeginDate, @EndOfDayEndDate)

		INSERT INTO @Calendar( PeriodType , Period , BeginDate , EndDate  )
		VALUES( 'Y', 'P', @Prior_BeginDate, @Prior_EndDate )


---------------- Sets Claims amount for Charges, Adj, Applied Receipts -----------------
	DECLARE @ReportResults TABLE(PracticeID INT, PeriodType Char(1), Period Char(1), ProviderID INT, ProviderFullName VARCHAR(256), Procedures INT, Charges MONEY, Adjustments MONEY,
				     Receipts MONEY, Refunds MONEY, ARBalance MONEY, DaysInAR DECIMAL(10,2), DaysRevenueOutstanding DECIMAL(18,2),
				     DaysToSubmission DECIMAL(10,2), DaysToBill DECIMAL(10,2),  TotalRefundsPrior MONEY, ALLAppliedReceipts MONEY )
	
	DECLARE @ClaimAmounts TABLE(PracticeID INT, ProviderID INT, ClaimID INT, PostingDate DATETIME, InPeriod BIT, Procedures INT, Charges MONEY, Adjustments MONEY, Receipts MONEY, ALLAppliedReceipts MONEY, ARBalance MONEY, 
				PeriodType Char(1), Period Char(1) )
	INSERT @ClaimAmounts(PracticeID, ProviderID, ClaimID, PostingDate, InPeriod, Procedures, Charges, Adjustments, Receipts, ALLAppliedReceipts, ARBalance, PeriodType, Period)
	SELECT ca.PracticeID, ProviderID, ca.ClaimID, P.PostingDate, 
	(CASE WHEN ISNULL(p.PostingDate, CA.PostingDate) >= BeginDate then 1 ELSE 0 END) as InPeriod,
	COUNT(CASE WHEN ClaimTransactionTypeCode='CST' AND ISNULL(p.PostingDate, CA.PostingDate) >= BeginDate THEN 1 ELSE NULL END) Procedures,
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' AND ISNULL(p.PostingDate, CA.PostingDate) >= BeginDate THEN Amount ELSE 0 END) Charges,
	SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' AND ISNULL(p.PostingDate, CA.PostingDate) >= BeginDate THEN Amount ELSE 0 END) Adjustments,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND ISNULL(p.PostingDate, CA.PostingDate) >= BeginDate THEN Amount ELSE 0 END) Receipts,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY'  THEN Amount ELSE 0 END) ALLAppliedReceipts,
	SUM( CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END ) ARBalance,
	c.PeriodType, c.Period
	FROM ClaimAccounting ca (NOLOCK) 
		LEFT OUTER JOIN PaymentClaimTransaction PCT (NOLOCK) 
			ON ca.PracticeID = pct.PracticeID 
			AND CA.ClaimTransactionID = PCT.ClaimTransactionID -- AND CA.ClaimTransactionTypeCode = 'PAY'
		LEFT JOIN Payment P  (NOLOCK) 
			ON  p.PracticeID = pct.PracticeID 
			AND PCT.PaymentID=P.PaymentID 
		CROSS JOIN @Calendar c
	WHERE CA.PracticeID = @PracticeID
		AND ISNULL(p.PostingDate, CA.PostingDate) <= c.EndDate
		AND ClaimTransactionTypeCode IN ('ADJ','CST', 'PAY')
	GROUP BY ca.PracticeID, ProviderID, ca.ClaimID, P.PostingDate, (CASE WHEN ISNULL(p.PostingDate, CA.PostingDate) >= BeginDate then 1 ELSE 0 END), c.PeriodType, c.Period


	Insert @ReportResults (PracticeID, PeriodType, Period, ProviderID, Procedures, Charges, Adjustments, Receipts, ARBalance, ALLAppliedReceipts )
	SELECT PracticeID, PeriodType, Period, 0,  SUM(Procedures) Procedures, SUM(Charges) Charges, SUM(Adjustments) Adjustments, SUM(Receipts) Receipts, SUM(ARBalance) ARBalance, SUM(ALLAppliedReceipts) ALLAppliedReceipts
	FROM @ClaimAmounts ca
	GROUP BY PracticeID, PeriodType, Period


	
------------- Sets Refund Totals --------------------------------
	DECLARE @Refunds TABLE(PracticeID INT, PeriodType Char(1) , Period Char(1), Refunds MONEY, TotalRefundsPrior MONEY)
	INSERT @Refunds(PracticeID, PeriodType, Period, Refunds, TotalRefundsPrior)
	SELECT PracticeID, PeriodType, Period,
	SUM( CASE WHEN PostingDate BETWEEN BeginDate AND EndDate THEN RefundAmount ELSE 0 END ) ThisPeriod,
	SUM( CASE WHEN PostingDate < BeginDate THEN RefundAmount ELSE 0 END ) PriorRefunds
	FROM Refund r  (NOLOCK) 
		CROSS JOIN @Calendar c
	WHERE R.PracticeID = @PracticeID
		AND PostingDate <= c.EndDate
	GROUP BY PracticeID, PeriodType, Period


	UPDATE RR SET Refunds=ISNULL(R.Refunds,0),
		TotalRefundsPrior=ISNULL(r.TotalRefundsPrior, 0)
	FROM @ReportResults RR INNER JOIN @Refunds R ON RR.PracticeID =R.PracticeID And r.PeriodType = RR.PeriodType AND r.Period = RR.Period
	


------------------ Sets Receipts --------------------	
	DECLARE @Receipts TABLE( PracticeID INT, PeriodType CHAR(1), Period CHAR(1), Receipts MONEY, ALLReceipts MONEY )
	INSERT INTO @Receipts( PracticeID, PeriodType, Period, Receipts, ALLReceipts )
	SELECT 	PracticeID, PeriodType, Period,
			Receipts = SUM(CASE WHEN PostingDate BETWEEN BeginDate AND EndDate THEN PaymentAmount END),
			ALLReceipts  = SUM(PaymentAmount)
	FROM Payment P (NOLOCK) 
		CROSS JOIN @Calendar c
	WHERE P.PracticeID = @PracticeID
		AND PostingDate <= EndDate 
	GROUP BY PracticeID, PeriodType, Period


----------------- AR Balance -------------------------
	UPDATE rr
	SET Receipts = r.Receipts, 
		ARBalance = ISNULL(ARBalance,0) - ( ISNULL(ALLReceipts, 0) - ISNULL(ALLAppliedReceipts, 0) ) + (ISNULL(TotalRefundsPrior, 0) + ISNULL(Refunds,0))
	FROM @ReportResults RR INNER JOIN @Receipts r on r.PracticeID = RR.PracticeID AND r.PeriodType = RR.PeriodType AND r.Period = RR.Period



------------------ Days in AR ---------------------------------
	DECLARE @DaysInARI TABLE( PracticeID INT, PeriodType CHAR(1), Period CHAR(1), ProviderID INT, ClaimID INT, Amount MONEY, Weighted MONEY)
	INSERT @DaysInARI(PracticeID, PeriodType, Period, ProviderID, ClaimID, Amount, Weighted)
	SELECT R.PracticeID, PeriodType, Period, R.ProviderID, R.ClaimID, SUM(R.Receipts) Amount, SUM(R.Receipts)*AVG(DATEDIFF(D,CA.PostingDate, R.PostingDate)) Weighted
	FROM ClaimAccounting CA  (NOLOCK) 
		INNER JOIN @ClaimAmounts R 
			ON CA.PracticeID = R.PracticeID 
			AND CA.ClaimID=R.ClaimID 
			AND R.InPeriod = 1 
			AND R.PostingDate IS NOT NULL 
			AND R.Receipts <> 0
	WHERE ClaimTransactionTypeCode='BLL'
	GROUP BY PeriodType, Period, R.PracticeID, R.ProviderID, R.ClaimID
		
	DECLARE @DaysInARSum TABLE(PeriodType CHAR(1), Period CHAR(1), PracticeID INT, ProviderID INT, DaysInAR DECIMAL(10,2))
	INSERT @DaysInARSum(PeriodType, Period, PracticeID, ProviderID, DaysInAR)
	SELECT PeriodType, Period, PracticeID, 0 ProviderID, CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END DaysInAR
	FROM @DaysInARI
	GROUP BY PeriodType, Period, PracticeID

	UPDATE RR SET DaysInAR=D.DaysInAR
	FROM @ReportResults RR INNER JOIN @DaysInARSum D ON rr.PracticeID = d.PracticeID AND RR.ProviderID=D.ProviderID AND D.PeriodType = RR.PeriodType AND D.Period = RR.Period
	

------------------- Days Out Standing ---------------------------
	DECLARE @DaysRevenueOutstandingI TABLE(PracticeID INT, PeriodType CHAR(1), Period CHAR(1), ProviderID INT, ClaimID INT, Amount MONEY, Weighted MONEY)
	INSERT @DaysRevenueOutstandingI(PracticeID, PeriodType, Period, ProviderID, ClaimID, Amount, Weighted)
	SELECT R.PracticeID, PeriodType, Period, R.ProviderID, R.ClaimID, SUM(Receipts) Amount, SUM(Receipts)*AVG(DATEDIFF(D,ProcedureDateOfService, R.PostingDate)) Weighted
	FROM Claim C  (NOLOCK) 
		INNER JOIN @ClaimAmounts R ON c.PracticeID = R.PracticeID AND C.ClaimID=R.ClaimID AND R.InPeriod = 1 AND R.PostingDate IS NOT NULL AND R.Receipts <> 0
		INNER JOIN EncounterProcedure EP  (NOLOCK) ON ep.PracticeID = R.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
	GROUP BY R.PracticeID,  PeriodType, Period, R.ProviderID, R.ClaimID
	

	DECLARE @DaysRevenueOutstandingSum TABLE(PracticeID INT, PeriodType CHAR(1), Period CHAR(1), ProviderID INT, DaysRevenueOutstanding DECIMAL(10,2))
	INSERT @DaysRevenueOutstandingSum(PracticeID, PeriodType, Period, ProviderID, DaysRevenueOutstanding)
	SELECT PracticeID,  PeriodType, Period, 0 ProviderID, CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END DaysRevenueOutstanding
	FROM @DaysRevenueOutstandingI
	GROUP BY PracticeID,  PeriodType, Period
	
	UPDATE RR SET DaysRevenueOutstanding=D.DaysRevenueOutstanding
	FROM @ReportResults RR INNER JOIN @DaysRevenueOutstandingSum D ON RR.PracticeID = D.PracticeID AND RR.ProviderID=D.ProviderID AND RR.PeriodType = D.PeriodType AND RR.Period = D.Period
	

------------------ Preperation for Other Days -------
	DECLARE @OtherDays TABLE(PracticeID INT, EndDate DATETIME, ProviderID INT, ClaimID INT, ProcedureDateOfService DATETIME, SubmittedDate DATETIME)
	INSERT @OtherDays(PracticeID, EndDate, ProviderID, ClaimID, ProcedureDateOfService, SubmittedDate)
	SELECT CA.PracticeID, EndDate, DoctorID ProviderID, C.ClaimID, 
		CAST(CONVERT(CHAR(10), ProcedureDateOfService,110) AS DATETIME) ProcedureDateOfService, 
		CAST(CONVERT(CHAR(10), E.SubmittedDate, 110) AS DATETIME) SubmittedDate
	FROM Encounter E  (NOLOCK) INNER JOIN EncounterProcedure EP ON E.PracticeID=EP.PracticeID AND E.EncounterID=EP.EncounterID
		INNER JOIN Claim C  (NOLOCK) ON EP.PracticeID=C.PracticeID AND EP.EncounterProcedureID=C.EncounterProcedureID
		INNER JOIN ClaimAccounting CA  (NOLOCK) ON C.PracticeID=CA.PracticeID AND C.ClaimID=CA.ClaimID
		CROSS JOIN (Select Distinct EndDate FROM @Calendar ) cal
	WHERE 
		E.PracticeID = @PracticeID
		AND CA.PostingDate <= EndDate 
		AND Status = 0 
		AND ClaimTransactionTypeCode IN ('CST')
	GROUP BY CA.PracticeID, EndDate, DoctorID, C.ClaimID, 
		CAST(CONVERT(CHAR(10), ProcedureDateOfService,110) AS DATETIME), 
		CAST(CONVERT(CHAR(10), E.SubmittedDate, 110) AS DATETIME)



-------------- Days to Submission -------------------		
		DECLARE @DaysToSubmissionSum TABLE(PracticeID INT,  EndDate DATETIME, ProviderID INT, DaysToSubmission DECIMAL(10,2))
		INSERT @DaysToSubmissionSum(PracticeID, EndDate, ProviderID, DaysToSubmission)
		SELECT PracticeID, EndDate, 0 ProviderID, AVG(DATEDIFF(D, ProcedureDateOfService, SubmittedDate)) DaysToSubmission
		FROM @OtherDays
		GROUP BY PracticeID, EndDate
		
		UPDATE RR SET DaysToSubmission=DS.DaysToSubmission
		FROM @ReportResults RR 
			INNER JOIN @Calendar Cal on RR.PeriodType = cal.PeriodType AND RR.Period = Cal.Period
			INNER JOIN @DaysToSubmissionSum DS ON RR.PracticeID = DS.PracticeID AND RR.ProviderID=DS.ProviderID AND cal.EndDate = ds.EndDate


------------------ Days to Bill ----------------------	
		DECLARE @DaysToBillSum TABLE(PracticeID INT, EndDate DATETIME, ProviderID INT, DaysToBill DECIMAL(10,2))
		INSERT @DaysToBillSum(PracticeID, EndDate, ProviderID, DaysToBill)
		SELECT OD.PracticeID, EndDate, 0 ProviderID, AVG(DATEDIFF(D, SubmittedDate, PostingDate))
		FROM ClaimAccounting CA  (NOLOCK) 
			INNER JOIN @OtherDays OD ON OD.PracticeID = CA.PracticeID AND CA.ClaimID=OD.ClaimID
		WHERE ClaimTransactionTypeCode='BLL'
		GROUP BY OD.PracticeID, EndDate
		
		
		UPDATE RR SET DaysToBill=DB.DaysToBill
		FROM @ReportResults RR 			
			INNER JOIN @Calendar Cal on RR.PeriodType = cal.PeriodType AND RR.Period = Cal.Period
			INNER JOIN @DaysToBillSum DB ON RR.PracticeID = DB.PracticeID AND RR.ProviderID=DB.ProviderID AND cal.EndDate = DB.EndDate
		

	delete DashboardKeyIndicatorVolatile

	INSERT INTO DashboardKeyIndicatorVolatile(
			PracticeID, 
			ComparePeriodType,
			Procedures,
			Charges,
			Adjustments,
			Receipts,
			Refunds,
			ARBalance,
			DaysInAR,
			DaysRevenueOutstanding,
			DaysToSubmission,
			DaysToBill,
			PercentOfProcedures,
			PercentOfCharges,
			PercentOfAdjustments,
			PercentOfReceipts,
			PercentOfRefunds,
			PercentOfARBalance,
			PercentOfDaysInAR,
			PercentOfDaysRevenueOutstanding,
			PercentOfDaysToSubmission,
			PercentOfDaysToBill
		)

	SELECT	PracticeID, 
			PeriodType,
			ISNULL(Procedures, 0) Procedures,
			ISNULL(Charges,0) Charges, 
			ISNULL(Adjustments,0) Adjustments, 
			ISNULL(Receipts,0) Receipts, 
			ISNULL(Refunds,0) Refunds, 
			ISNULL(ARBalance,0) ARBalance,
			ISNULL(DaysInAR,0) DaysInAR, 
			ISNULL(DaysRevenueOutstanding,0) DaysRevenueOutstanding, 
			ISNULL(DaysToSubmission,0) DaysToSubmission, 
			ISNULL(DaysToBill,0) DaysToBill,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0
	FROM @ReportResults
	WHERE Period = 'C'

	UNION ALL

	SELECT	p.PracticeID, 
			cal.PeriodType,
			0,
			0, 
			0, 
			0, 
			0, 
			0,
			0, 
			0, 
			0, 
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0
	FROM Practice p 
			LEFT OUTER JOIN @ReportResults rr on rr.PracticeID = p.PracticeID
			CROSS JOIN (SELECT DISTINCT PeriodType FROM @Calendar ) as cal
	WHERE rr.PracticeID IS NULL 



	UPDATE V
		SET PercentOfProcedures = 	CASE WHEN U.Procedures > 0 THEN
										CASE WHEN (cast(V.Procedures as decimal) - cast(U.Procedures as decimal)) / cast(U.Procedures as decimal) > @PercentThreshold THEN @PercentThresholdErrorValue
										ELSE (cast(V.Procedures as decimal) - cast(U.Procedures as decimal)) / cast(U.Procedures as decimal)
										END
									ELSE
										0
									END,
			PercentOfCharges = 		CASE WHEN U.Charges > 0.0 THEN
										CASE WHEN (V.Charges - U.Charges) / U.Charges > @PercentThreshold THEN @PercentThresholdErrorValue
										ELSE (V.Charges - U.Charges) / U.Charges
										END
									ELSE
										0
									END,
			PercentOfAdjustments = CASE WHEN U.Adjustments > 0.0001 THEN
										CASE WHEN (V.Adjustments - U.Adjustments) / U.Adjustments > @PercentThreshold THEN @PercentThresholdErrorValue
										ELSE (V.Adjustments - U.Adjustments) / U.Adjustments
										END
									ELSE
										0
									END,
			PercentOfReceipts = 	CASE WHEN U.Receipts > 0.0001 THEN
										CASE WHEN (V.Receipts - U.Receipts) / U.Receipts > @PercentThreshold THEN @PercentThresholdErrorValue
										ELSE (V.Receipts - U.Receipts) / U.Receipts
										END
									ELSE
										0
									END,
			PercentOfRefunds = 		CASE WHEN U.Refunds > 0.0001 THEN
										CASE WHEN (V.Refunds - U.Refunds) / U.Refunds > @PercentThreshold THEN @PercentThresholdErrorValue
										ELSE (V.Refunds - U.Refunds) / U.Refunds
										END
									ELSE
										0
									END,
			PercentOfARBalance = 	CASE WHEN U.ARBalance > 0.0001 THEN
										CASE WHEN (V.ARBalance - U.ARBalance) / U.ARBalance > @PercentThreshold THEN @PercentThresholdErrorValue
										ELSE (V.ARBalance - U.ARBalance) / U.ARBalance
										END
									ELSE
										0
									END,
			PercentOfDaysInAR = 	CASE WHEN U.DaysInAR > 0 THEN
										CASE WHEN (V.DaysInAR - U.DaysInAR) / U.DaysInAR > @PercentThreshold THEN @PercentThresholdErrorValue
										ELSE (V.DaysInAR - U.DaysInAR) / U.DaysInAR
										END
									ELSE
										0
									END,
			PercentOfDaysRevenueOutstanding = CASE WHEN U.DaysRevenueOutstanding > 0 THEN
										CASE WHEN (V.DaysRevenueOutstanding - U.DaysRevenueOutstanding) / U.DaysRevenueOutstanding > @PercentThreshold THEN @PercentThresholdErrorValue
										ELSE (V.DaysRevenueOutstanding - U.DaysRevenueOutstanding) / U.DaysRevenueOutstanding
										END
									ELSE
										0
									END,
			PercentOfDaysToSubmission = CASE WHEN U.DaysToSubmission > 0 THEN
										CASE WHEN (V.DaysToSubmission - U.DaysToSubmission) / U.DaysToSubmission > @PercentThreshold THEN @PercentThresholdErrorValue
										ELSE (V.DaysToSubmission - U.DaysToSubmission) / U.DaysToSubmission
										END
									ELSE
										0
									END,
			PercentOfDaysToBill = 	CASE WHEN U.DaysToBill > 0 THEN
										CASE WHEN (V.DaysToBill - U.DaysToBill)/ U.DaysToBill > @PercentThreshold THEN @PercentThresholdErrorValue
										ELSE (V.DaysToBill - U.DaysToBill)/ U.DaysToBill
										END
									ELSE
										0
									END
		FROM @ReportResults U 
				INNER JOIN DashboardKeyIndicatorVolatile v on v.PracticeID = u.PracticeID AND ComparePeriodType = u.PeriodType
		WHERE u.Period = 'P'



	--Now replace the data in one operation
	BEGIN TRAN 
		DELETE dbo.DashboardKeyIndicatorDisplay
		WHERE PracticeID = @PracticeID
	
		INSERT dbo.DashboardKeyIndicatorDisplay WITH (TABLOCK)
			(PracticeID, 
			ComparePeriodType, 
			Procedures, 
			PercentOfProcedures, 
			Charges, 
			PercentOfCharges, 
			Adjustments, 
			PercentOfAdjustments, 
			Receipts, 
			PercentOfReceipts, 
			Refunds, 
			PercentOfRefunds, 
			ARBalance, 
			PercentOfARBalance, 
			DaysInAR, 
			PercentOfDaysInAR, 
			DaysRevenueOutstanding, 
			PercentOfDaysRevenueOutstanding, 
			DaysToSubmission, 
			PercentOfDaysToSubmission, 
			DaysToBill, 
			PercentOfDaysToBill
		)
		SELECT PracticeID, 
			ComparePeriodType, 
			Procedures, 
			PercentOfProcedures, 
			Charges, 
			PercentOfCharges, 
			Adjustments, 
			PercentOfAdjustments, 
			Receipts, 
			PercentOfReceipts, 
			Refunds, 
			PercentOfRefunds, 
			ARBalance, 
			PercentOfARBalance, 
			DaysInAR, 
			PercentOfDaysInAR, 
			DaysRevenueOutstanding, 
			PercentOfDaysRevenueOutstanding, 
			DaysToSubmission, 
			PercentOfDaysToSubmission, 
			DaysToBill, 
			PercentOfDaysToBill
		FROM dbo.DashboardKeyIndicatorVolatile
		WHERE PracticeID = @PracticeID
	COMMIT
	
	SET NOCOUNT OFF
END

