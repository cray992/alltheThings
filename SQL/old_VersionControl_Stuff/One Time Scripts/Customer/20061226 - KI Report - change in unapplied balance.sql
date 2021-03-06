IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReportDataProvider_KeyIndicatorsSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ReportDataProvider_KeyIndicatorsSummary]
GO



-- dbo.ReportDataProvider_KeyIndicatorsSummary @PracticeID = 65, @SummarizeAllProviders=0, 	@BeginDate = '5/1/06', @EndDate = '5/31/06', @GroupBy = 'P'

CREATE PROCEDURE [dbo].[ReportDataProvider_KeyIndicatorsSummary]
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@SummarizeAllProviders bit = 0,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@ReportType INT = 1,	-- 1 = "Payment Receivied".  Use Posting Date of "PAY" from Payment Table, All other will come from Claims
						-- 3 = "Payments Applied". Using Posting Date for all from Service Line, 
						-- 2=  "Payments Applied w/ Fix". Same as 3, but fix error condition where Payment.PostingDate > ClaimTransaction.PostingDate

	@GroupBy Char(1) = 'P',	-- P=Provider, S=ServiceLocation, D=Department	
	@DepartmentID INT = 0,	
	@ServiceLocationID INT = 0


AS



--DECLARE
--	@PracticeID int,
--	@ProviderID int,
--	@SummarizeAllProviders bit,
--	@BeginDate datetime,
--	@EndDate datetime,
--	@ReportType INT,
--	@GroupBy Char(1),	-- P=Provider, S=ServiceLocation, D=Department	
--	@DepartmentID INT,	
--	@ServiceLocationID INT
--	
--
--SELECT
--	@PracticeID =65,
--	@ProviderID= 0,
--	@SummarizeAllProviders = 0,
--	@BeginDate = '11/1/06',
--	@EndDate = '11/30/06',
--	@ReportType = 1,
--	@GroupBy = 'P',	-- P=Provider, S=ServiceLocation, D=Department	
--	@DepartmentID = 0,	
--	@ServiceLocationID = 0



BEGIN

	DECLARE
		@ShowUnbilledAR BIT,
		@FixPaymentPostingDate BIT


		IF @ReportType = 1	OR @ReportType IS NULL		-- Use Posting Date of pament from Payment Table, Posting Date of CST, ADJ from ClaimAccounting. See Case 11167 
			BEGIN
				SET @ShowUnbilledAR = 1
				SET @FixPaymentPostingDate = 0
			END
		ELSE IF @ReportType = 2		-- Use Posting Date of Service Line. Fix Error condition where Payment.PostingDate > ClaimAccounting.PostingDate. See case 12036 
			BEGIN
				SET @ShowUnbilledAR = 0
				SET @FixPaymentPostingDate = 1
			END
		ELSE						-- Use Posting Date of Service Line as is. Orginal calculation
			BEGIN
				SET @ShowUnbilledAR = 0
				SET @FixPaymentPostingDate = 0
			END


	DECLARE @EndOfDayEndDate DATETIME
	SET @EndOfDayEndDate=DATEADD(S,-1,DATEADD(D,1,dbo.fn_DateOnly( @EndDate )))

	DECLARE @ReportResults TABLE(GroupID INT, GroupDescription VARCHAR(256), Charges MONEY, Adjustments MONEY,
				     Receipts MONEY, Refunds MONEY, ARBalance MONEY, DaysInAR DECIMAL(10,2), DaysRevenueOutstanding DECIMAL(18,2),
				     DaysToSubmission DECIMAL(10,2), DaysToBill DECIMAL(10,2),  TotalRefundsPrior MONEY,
					 UnappliedBeginBalance MONEY, UnappliedEndBalance MONEY)

	DECLARE @ClaimAmounts TABLE(GroupID INT, Charges MONEY, Adjustments MONEY)
	DECLARE @Receipts TABLE(GroupID INT, ClaimTransactionID INT, ClaimID INT, PaymentID INT, PostingDate DATETIME, Amount MONEY, PayerTypeCode varchar(50), CA_PostingDate DATETIME )
	DECLARE @AR TABLE (GroupID INT, EndARAmount MONEY)
	create table #ReceiptSum (GroupID INT, Rec_PaymentBeginBal MONEY, Rec_PaymentEndBal MONEY, App_PaymentBeginBal MONEY, App_PaymentEndBal MONEY, pApp_PaymentBeginBal MONEY, pApp_PaymentEndBal MONEY, Unapplied MONEY )
	CREATE TABLE #rSum ( PaymentID INT, AppliedPrior MONEY, AppliedCurrent MONEY, AppliedAll MONEY, pAppliedPrior MONEY, pAppliedCurrent MONEY)


	Create TABLE #ClaimAccounting  (
		GroupID [int] NULL,
		ServiceLocationID [int] NULL,
		DepartmentID [int] NULL,
		ProviderID [int] NOT NULL,
		[ClaimID] [int] NOT NULL,
		[ClaimTransactionID] [int] NOT NULL,
		[ClaimTransactionTypeCode] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ProcedureCount] [int] NULL,
		[Amount] [money] NULL,
		[Status] [bit] NOT NULL,
		[PostingDate] [datetime] NOT NULL,
		[Pay_PostingDate] [datetime] NULL,
		[PaymentID] [int] NULL,
		[PayerTypeCode] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	)




	
	IF  @GroupBy = 'S'
		BEGIN
			-- Place holder for those not associated to Service Location
			INSERT @ReportResults(GroupID, GroupDescription)
			SELECT -1, 'Other'

			INSERT @ReportResults(GroupID, GroupDescription)
			SELECT ServiceLocationID, Name
			FROM ServiceLocation
			WHERE PracticeID = @PracticeID
				AND ( @ServiceLocationID = 0 or @ServiceLocationID = ServiceLocationID )
		END
	ELSE IF  @GroupBy = 'D'
		BEGIN
			-- Place holder for those not associated to Department
			INSERT @ReportResults(GroupID, GroupDescription)
			SELECT -1, 'Other'

			INSERT @ReportResults(GroupID, GroupDescription)
			SELECT dept.DepartmentID, Name
			FROM Department dept
				LEFT JOIN Doctor d on d.PracticeID = dept.PracticeID AND d.DepartmentID = dept.DepartmentID
			WHERE dept.PracticeID = @PracticeID
				AND ( @DepartmentID = 0 or @DepartmentID = dept.DepartmentID )
				AND ( @ProviderID = 0 OR @ProviderID = d.DoctorID )
		END
	ELSE 
		BEGIN
			INSERT @ReportResults(GroupID, GroupDescription)
			SELECT d.DoctorID ProviderID, RTRIM(ISNULL(FirstName + ' ','') + ISNULL(MiddleName + ' ', '')) + ISNULL(' ' + LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(Degree), '') AS ProviderFullname
			FROM Doctor d
				LEFT JOIN Department dept on d.PracticeID = dept.PracticeID AND d.DepartmentID = dept.DepartmentID
			WHERE d.PracticeID=@PracticeID
				AND [External] = 0
				AND ( @ProviderID = 0 or @ProviderID = DoctorID )
				AND ( @DepartmentID = 0 or @DepartmentID = dept.DepartmentID )
		END

	INSERT INTO #ClaimAccounting( ProviderID, ClaimID, ClaimTransactionID, ClaimTransactionTypeCode, ProcedureCount, 
			Amount, 
			Status, PostingDate, Pay_PostingDate, 
			PaymentID, PayerTypeCode)
	SELECT	CA.ProviderID, CA.ClaimID, CA.ClaimTransactionID, ClaimTransactionTypeCode, ProcedureCount, 
			Amount,
			Status, CA.PostingDate, P.PostingDate AS Pay_PostingDate, 
			P.PaymentID, PayerTypeCode
	FROM ClaimAccounting ca
			LEFT JOIN PaymentClaimTransaction PCT ON pct.PracticeID = @PracticeID AND CA.ClaimTransactionID=PCT.ClaimTransactionID
			LEFT JOIN Payment P ON P.PracticeID = @PracticeID AND PCT.PaymentID=P.PaymentID
	WHERE ca.PracticeID = @PracticeID
		AND ClaimTransactionTypeCode IN ('ADJ', 'CST', 'PAY', 'BLL')
		AND ( ca.PostingDate <= @EndOfDayEndDate OR p.PostingDate <= @EndOfDayEndDate)

	UPDATE ca
	SET GroupID = ISNULL( CASE @GroupBy 
						WHEN  'S' THEN E.LocationID
						WHEN  'D' THEN D.DepartmentID
						ELSE CA.ProviderID END,
					-1),
		ServiceLocationID = E.LocationID,
		DepartmentID = D.DepartmentID
	FROM #ClaimAccounting ca
			INNER JOIN Doctor D on D.PracticeID = @PracticeID AND d.DoctorID = CA.ProviderID
			INNER JOIN Claim c on c.PracticeID = @PracticeID AND c.ClaimID = ca.ClaimID
			INNER JOIN EncounterProcedure ep on ep.EncounterProcedureID = c.EncounterProcedureID
			INNER JOIN Encounter e on e.PracticeID = @PracticeID AND e.EncounterID = ep.EncounterID


	-- Filters based on Paramter
	DELETE #ClaimAccounting
	WHERE
		( @DepartmentID <> 0 AND  @DepartmentID <> ISNULL(DepartmentID, 0) ) OR
		( @ProviderID <> 0 AND @ProviderID <> ISNULL(ProviderID, 0) )  OR 
		( @ServiceLocationID <> 0 AND @ServiceLocationID <> ISNULL(ServiceLocationID, 0) )

	 
	

	IF ISNULL(@ShowUnbilledAR, 0) = 1
		BEGIN

			INSERT @ClaimAmounts(GroupID, Charges, Adjustments)
			SELECT GroupID, 
				SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN AMOUNT ELSE 0 END ) Charges,
				SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN AMOUNT ELSE 0 END ) Adjustments
			FROM #ClaimAccounting ca 
			WHERE CA.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
					AND ClaimTransactionTypeCode IN ('ADJ','CST')
			GROUP BY GroupID


			INSERT @Receipts(GroupID, ClaimTransactionID, ClaimID, PaymentID, 
					PostingDate, Amount, PayerTypeCode, CA_PostingDate)
			SELECT GroupID, ClaimTransactionID, ClaimID, PaymentID, 
					PostingDate, -- Pay_PostingDate, 
					Amount, PayerTypeCode, 
					PAY_PostingDate --CA.PostingDate
			FROM #ClaimAccounting CA 
			WHERE (PAY_PostingDate <= @EndOfDayEndDate OR PostingDate <= @EndOfDayEndDate)
				AND ClaimTransactionTypeCode='PAY'


			INSERT @AR(GroupID, EndARAmount)
			SELECT	GroupID, 			
					EndARAmount = SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END )			
			FROM #ClaimAccounting CA 
			WHERE (	(ClaimTransactionTypeCode = 'PAY' AND PAY_PostingDate  <= @EndOfDayEndDate)
							OR  
					(ClaimTransactionTypeCode <> 'PAY' AND PostingDate  <= @EndOfDayEndDate)
				  )
			GROUP BY GroupID
			HAVING 0 <> SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END )


		END ELSE 
		BEGIN

			IF ISNULL( @FixPaymentPostingDate, 0) = 1
				BEGIN
					-- Error condition of PaymentPostingDate Fixes 
					UPDATE #ClaimAccounting
					SET PostingDate = Pay_PostingDate
					WHERE Pay_PostingDate > PostingDate
				END

			INSERT @ClaimAmounts(GroupID, Charges, Adjustments)
			SELECT GroupID, 
				SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN AMOUNT ELSE 0 END ) Charges,
				SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN AMOUNT ELSE 0 END ) Adjustments
			FROM #ClaimAccounting CA 
			WHERE  
					PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
					AND ClaimTransactionTypeCode IN ('ADJ','CST')
			GROUP BY GroupID


			INSERT @Receipts(GroupID, ClaimTransactionID, ClaimID, PaymentID, 
					PostingDate, Amount, PayerTypeCode, CA_PostingDate)
			SELECT GroupID, CA.ClaimTransactionID, CA.ClaimID, ca.PaymentID, 
					Pay_PostingDate, 
					Amount, 
					PayerTypeCode, 
					PostingDate
			FROM #ClaimAccounting CA
			WHERE ClaimTransactionTypeCode='PAY'
					AND PostingDate <= @EndOfDayEndDate

			INSERT @AR(GroupID, EndARAmount)
			SELECT GroupID,
					EndARAmount = SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END )			
			FROM #ClaimAccounting ca 
			WHERE	PostingDate <= @EndOfDayEndDate
			GROUP BY GroupID

		END


	UPDATE RR SET Charges=CA.Charges, Adjustments=CA.Adjustments
	FROM @ReportResults RR INNER JOIN @ClaimAmounts CA ON RR.GroupID=CA.GroupID



	--Set AR Value
	UPDATE RR SET ARBalance=ISNULL(EndARAmount,0)
	FROM @ReportResults RR INNER JOIN @AR AR ON RR.GroupID=AR.GroupID

	DECLARE @ReceiptsSummarized TABLE(GroupID INT, Receipts MONEY)
	INSERT @ReceiptsSummarized(GroupID, Receipts)
	SELECT GroupID, SUM(R.Amount) Receipts
	FROM @Receipts R
	WHERE ( ISNULL(@ShowUnbilledAR, 0) = 1
			AND ( (ISNULL(@SummarizeAllProviders, 0) = 1  AND (PostingDate <= @EndOfDayEndDate OR CA_PostingDate <= @EndOfDayEndDate) ) -- All Provider
					OR (ISNULL(@SummarizeAllProviders, 0) = 0 AND  PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate )
				)
			) OR 
		( ISNULL(@ShowUnbilledAR, 0) = 0 
			AND (
					(ISNULL(@SummarizeAllProviders, 0) = 1 AND (CA_PostingDate <= @EndOfDayEndDate ))
					 OR (ISNULL(@SummarizeAllProviders, 0) = 0 AND  CA_PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate )						
				)
		)
	GROUP BY GroupID


	UPDATE RR SET Receipts=RS.Receipts
	FROM @ReportResults RR INNER JOIN @ReceiptsSummarized RS ON RR.GroupID=RS.GroupID

	-- When Filtering by ServiceLocationID, we delete groups that have no activities. 
	DELETE @ReportResults
	WHERE Charges IS NULL 
			AND Adjustments IS NULL
			AND Receipts IS NULL
			AND @ServiceLocationID <> 0


	--Prep the Days in AR Calc
	DECLARE @DaysInARI TABLE(GroupID INT, ClaimID INT, Amount MONEY, Weighted MONEY)
	INSERT @DaysInARI(GroupID, ClaimID, Amount, Weighted)
	SELECT R.GroupID, R.ClaimID, SUM(R.Amount) Amount, SUM(R.Amount)*AVG(DATEDIFF(D,CA.PostingDate, R.CA_PostingDate)) Weighted
	FROM #ClaimAccounting CA INNER JOIN @Receipts R ON CA.ClaimID=R.ClaimID
	WHERE ClaimTransactionTypeCode='BLL'
		AND R.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
	GROUP BY R.GroupID, R.ClaimID
	
	--Prep the DaysRevenueOutstanding Calc
	DECLARE @DaysRevenueOutstandingI TABLE(GroupID INT, ClaimID INT, Amount MONEY, Weighted MONEY)
	INSERT @DaysRevenueOutstandingI(GroupID, ClaimID, Amount, Weighted)
	SELECT R.GroupID, R.ClaimID, SUM(Amount) Amount, SUM(Amount)*AVG(DATEDIFF(D,ProcedureDateOfService, R.CA_PostingDate)) Weighted
	FROM Claim C 
			INNER JOIN @Receipts R ON C.ClaimID=R.ClaimID
			INNER JOIN EncounterProcedure EP ON C.PracticeID = EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
	WHERE C.PracticeID = @PracticeID
			AND R.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
	GROUP BY R.GroupID, R.ClaimID
	
	
	DECLARE @OtherDays TABLE(GroupID INT, ClaimID INT, ProcedureDateOfService DATETIME, SubmittedDate DATETIME)
	INSERT @OtherDays(GroupID, ClaimID, ProcedureDateOfService, SubmittedDate)
	SELECT GroupID, C.ClaimID, CAST(CONVERT(CHAR(10), ProcedureDateOfService,110) AS DATETIME) ProcedureDateOfService, 
	CAST(CONVERT(CHAR(10), E.SubmittedDate, 110) AS DATETIME) SubmittedDate
	FROM Encounter E 
		INNER JOIN EncounterProcedure EP ON E.PracticeID=EP.PracticeID AND E.EncounterID=EP.EncounterID
		INNER JOIN Claim C ON EP.PracticeID=C.PracticeID AND EP.EncounterProcedureID=C.EncounterProcedureID
		INNER JOIN #ClaimAccounting CA ON C.ClaimID=CA.ClaimID
	WHERE C.PracticeID=@PracticeID 
			AND CA.PostingDate<=@EndDate 
			AND Status=0 
			AND ClaimTransactionTypeCode='CST'
	
-------------------  Calculates the "All Grouping section. Adds Unapplied amounts, Refunds, etc.... ----------

		INSERT @ReportResults(GroupID, GroupDescription, Charges, Adjustments, Receipts, ARBalance)
		SELECT 0 GroupID, NULL ProviderFullName, SUM(Charges) Charges, SUM(Adjustments) Adjustments, SUM(Receipts) Receipts, SUM(ARBalance)
		FROM @ReportResults
		

		--Get Refund Totals For use in report sum, or do check to see if 1 provider only which does not require summary
		DECLARE @Refunds TABLE(Refunds MONEY, TotalRefundsPrior MONEY)
		INSERT @Refunds(Refunds, TotalRefundsPrior)
		SELECT
			SUM( CASE WHEN PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate THEN RefundAmount ELSE 0 END ) ThisPeriod,
			SUM( CASE WHEN PostingDate < @BeginDate THEN RefundAmount ELSE 0 END ) PriorRefunds
		FROM Refund
		WHERE PracticeID=@PracticeID AND PostingDate <= @EndOfDayEndDate

		UPDATE RR SET Refunds=ISNULL(R.Refunds,0),
			TotalRefundsPrior=ISNULL(r.TotalRefundsPrior, 0)
		FROM @ReportResults RR, @Refunds R
		WHERE GroupID = 0
		
		DECLARE @DaysInARSum TABLE(GroupID INT, DaysInAR DECIMAL(10,2))
		INSERT @DaysInARSum(GroupID, DaysInAR)
		SELECT 0 ProviderID, CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END DaysInAR
		FROM @DaysInARI
	
		UPDATE RR SET DaysInAR=D.DaysInAR
		FROM @ReportResults RR INNER JOIN @DaysInARSum D ON RR.GroupID=D.GroupID
		WHERE rr.GroupID = 0
		
		DECLARE @DaysRevenueOutstandingSum TABLE(GroupID INT, DaysRevenueOutstanding DECIMAL(10,2))
		INSERT @DaysRevenueOutstandingSum(GroupID, DaysRevenueOutstanding)
		SELECT 0 GroupID, CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END DaysRevenueOutstanding
		FROM @DaysRevenueOutstandingI
		
		UPDATE RR SET DaysRevenueOutstanding=D.DaysRevenueOutstanding
		FROM @ReportResults RR INNER JOIN @DaysRevenueOutstandingSum D ON RR.GroupID=D.GroupID
		WHERE rr.GroupID = 0
		
		DECLARE @DaysToSubmissionSum TABLE(GroupID INT, DaysToSubmission DECIMAL(10,2))
		INSERT @DaysToSubmissionSum(GroupID, DaysToSubmission)
		SELECT 0 ProviderID, AVG(DATEDIFF(D, ProcedureDateOfService, SubmittedDate)) DaysToSubmission
		FROM @OtherDays
		
		UPDATE RR SET DaysToSubmission=DS.DaysToSubmission
		FROM @ReportResults RR INNER JOIN @DaysToSubmissionSum DS ON RR.GroupID=DS.GroupID
		WHERE rr.GroupID = 0
		
		DECLARE @DaysToBillSum TABLE(GroupID INT, DaysToBill DECIMAL(10,2))
		INSERT @DaysToBillSum(GroupID, DaysToBill)
		SELECT 0 ProviderID, AVG(DATEDIFF(D, SubmittedDate, PostingDate))
		FROM #ClaimAccounting CA INNER JOIN @OtherDays OD ON CA.ClaimID=OD.ClaimID
		WHERE ClaimTransactionTypeCode='BLL'
		
		UPDATE RR SET DaysToBill=DB.DaysToBill
		FROM @ReportResults RR INNER JOIN @DaysToBillSum DB ON RR.GroupID=DB.GroupID
		WHERE rr.GroupID = 0
		if @ReportType <> 3 --Sum of Receipts is the same as applied receipts
		BEGIN

				INSERT INTO #rSum ( PaymentID, AppliedPrior, AppliedCurrent, pAppliedPrior, pAppliedCurrent, AppliedAll )
				select PaymentID,
						AppliedPrior =	SUM( CASE WHEN CA_PostingDate < @BeginDate then Amount else 0 end ),
						AppliedCurrent = sum( CASE WHEN CA_PostingDate  <= @EndOfDayEndDate THEN Amount else 0 END),
						pAppliedPrior =	SUM( CASE WHEN PostingDate < @BeginDate then Amount else 0 end ),
						pAppliedCurrent = sum( CASE WHEN PostingDate  <= @EndOfDayEndDate THEN Amount else 0 END),
						AppliedAll =	SUM( Amount )
				from @Receipts r
				GROUP BY PaymentID


				INSERT INTO #ReceiptSum (GroupID , Rec_PaymentBeginBal , Rec_PaymentEndBal , App_PaymentBeginBal , App_PaymentEndBal , pApp_PaymentBeginBal , pApp_PaymentEndBal , Unapplied  )
				SELECT
					GroupID = 0,
					Rec_PaymentBeginBal = sum( case when p.postingDate < @BeginDate then paymentAmount else 0 end ),
					Rec_PaymentEndBal = sum(case when p.postingDate <= @EndOfDayEndDate then paymentAmount else 0 end ),
					App_PaymentBeginBal = sum( AppliedPrior),
					App_PaymentEndBal = sum(AppliedCurrent),
					pApp_PaymentBeginBal = sum( pAppliedPrior),
					pApp_PaymentEndBal = sum(pAppliedCurrent),
					Unapplied = sum( case when p.postingDate  between @BeginDate AND @EndOfDayEndDate THEN PaymentAmount - ISNULL(AppliedAll, 0) else 0 end  )
				from Payment P
					LEFT JOIN #rSum r  ON r.PaymentID=P.PaymentID
				WHERE  p.PracticeID = @PracticeID
					AND p.PostingDate <= @EndOfDayEndDate





				IF @ReportType = 1
				BEGIN
							UPDATE rr
							SET	ARBalance = isnull(ARBalance, 0) - ( (isnull( Rec_PaymentEndBal, 0) - ISNULL(App_PaymentEndBal, 0) )),
								Receipts = isnull( Rec_PaymentEndBal, 0) - ISNULL(Rec_PaymentBeginBal, 0),
								UnappliedBeginBalance = ISNULL( Rec_PaymentBeginBal, 0) - ISNULL( pApp_PaymentBeginBal, 0),
								UnappliedEndBalance = ISNULL(Rec_PaymentEndBal, 0) - ISNULL( pApp_PaymentEndBal, 0)
							FROM @ReportResults rr INNER JOIN #ReceiptSum R ON r.GroupID = rr.GroupID
							WHERE rr.GroupID = 0

							Update RR
							SET UnappliedEndBalance = UnappliedEndBalance - isnull(
																					( select sum(amount) FROM @Receipts where postingDate between @BeginDate AND @EndOfDayEndDate AND ca_PostingDate > @EndOfDayEndDate )
																					, 0)
							FROM @ReportResults rr
							WHERE rr.GroupID = 0		

				END
				ELSE 
				BEGIN
							UPDATE rr
							SET	ARBalance = isnull(ARBalance, 0) - ( (isnull( Rec_PaymentEndBal, 0) - ISNULL(App_PaymentEndBal, 0) )),
								Receipts = isnull( Rec_PaymentEndBal, 0) - ISNULL(Rec_PaymentBeginBal, 0),
								UnappliedBeginBalance = ISNULL( Rec_PaymentBeginBal, 0) - ISNULL( App_PaymentBeginBal, 0),
								UnappliedEndBalance = ISNULL(Rec_PaymentEndBal, 0) - ISNULL( App_PaymentEndBal, 0)
							FROM @ReportResults rr INNER JOIN #ReceiptSum R ON r.GroupID = rr.GroupID
							WHERE rr.GroupID = 0

				END




		
		END

		ELSE BEGIN
			UPDATE rr
			SET	Receipts = AppliedAmount					
			FROM @ReportResults rr, (SELECT sum(amount) as AppliedAmount from @Receipts where Ca_postingDate between @BeginDate and @EndOfDayEndDate ) as R		
			WHERE rr.GroupID = 0

		END


		-- Gets Capitated
		DECLARE @TotalCapitated MONEY, @PriorCapititated MONEY
/*
		select  @TotalCapitated = sum(-1*c.Amount),
				@PriorCapititated = SUM( CASE when p.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate THEN -1*c.Amount ELSE 0 END)
		from capitatedAccountToPayment c 
			INNER JOIN Payment p on c.PaymentID = p.PaymentID
		WHERE p.PracticeID = @PracticeID AND 
			P.PostingDate <= @EndOfDayEndDate
*/


		UPDATE rr
		SET	ARBalance = ISNULL(TotalRefundsPrior, 0) + ISNULL(Refunds,0)+ISNULL(ARBalance,0) - ISNULL(@TotalCapitated, 0)
		FROM @ReportResults rr
		WHERE GroupID = 0


	IF @SummarizeAllProviders=1
	BEGIN
		DELETE @ReportResults WHERE GroupID<>0

		SELECT GroupID, GroupDescription, ISNULL(Charges,0) Charges, ISNULL(Adjustments,0) Adjustments, 
		ISNULL(Receipts,0) Receipts, ISNULL(Refunds,0) Refunds, 
		ISNULL(ARBalance,0) ARBalance,
		ISNULL(DaysInAR,0) DaysInAR, ISNULL(DaysRevenueOutstanding,0) DaysRevenueOutstanding, 
		ISNULL(DaysToSubmission,0) DaysToSubmission, ISNULL(DaysToBill,0) DaysToBill,
		ISNULL(UnappliedBeginBalance, 0) UnappliedBeginBalance, ISNULL(UnappliedEndBalance, 0) UnappliedEndBalance
		FROM @ReportResults

	END ELSE
	BEGIN
---------- For the detailed --------------



		DECLARE @DaysInARII TABLE(GroupID INT, DaysInAR DECIMAL(10,2))
		INSERT @DaysInARII(GroupID, DaysInAR)
		SELECT GroupID, CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END DaysInAR
		FROM @DaysInARI
		GROUP BY GroupID
		
		UPDATE RR SET DaysInAR=D.DaysInAR
		FROM @ReportResults RR INNER JOIN @DaysInARII D ON RR.GroupID=D.GroupID


		DECLARE @DaysRevenueOutstandingII TABLE(GroupID INT, DaysRevenueOutstanding DECIMAL(10,2))
		INSERT @DaysRevenueOutstandingII(GroupID, DaysRevenueOutstanding)
		SELECT GroupID, CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END DaysRevenueOutstanding
		FROM @DaysRevenueOutstandingI
		GROUP BY GroupID
		
		UPDATE RR SET DaysRevenueOutstanding=D.DaysRevenueOutstanding
		FROM @ReportResults RR INNER JOIN @DaysRevenueOutstandingII D ON RR.GroupID=D.GroupID
		WHERE RR.GroupID <> 0
		
		DECLARE @DaysToSubmission TABLE(GroupID INT, DaysToSubmission DECIMAL(10,2))
		INSERT @DaysToSubmission(GroupID, DaysToSubmission)
		SELECT GroupID, AVG(DATEDIFF(D, ProcedureDateOfService, SubmittedDate)) DaysToSubmission
		FROM @OtherDays
		GROUP BY GroupID
		
		UPDATE RR SET DaysToSubmission=DS.DaysToSubmission
		FROM @ReportResults RR INNER JOIN @DaysToSubmission DS ON RR.GroupID=DS.GroupID
		WHERE RR.GroupID <> 0
	
		DECLARE @DaysToBill TABLE(GroupID INT, DaysToBill DECIMAL(10,2))
		INSERT @DaysToBill(GroupID, DaysToBill)
		SELECT OD.GroupID, AVG(DATEDIFF(D, SubmittedDate, PostingDate))
		FROM #ClaimAccounting CA INNER JOIN @OtherDays OD ON CA.ClaimID=OD.ClaimID
		WHERE ClaimTransactionTypeCode='BLL'
		GROUP BY OD.GroupID
		
		UPDATE RR SET DaysToBill=DB.DaysToBill
		FROM @ReportResults RR INNER JOIN @DaysToBill DB ON RR.GroupID=DB.GroupID
		WHERE RR.GroupID <> 0


		DELETE @ReportResults
		WHERE	GroupID = -1 AND
				Charges IS NULL AND 
				Adjustments IS NULL AND 
				Receipts  IS NULL AND 
				Refunds  IS NULL AND 
				ARBalance IS NULL

		SELECT GroupID, GroupDescription, 
			ISNULL(Charges,0) Charges, ISNULL(Adjustments,0) Adjustments, 
			ISNULL(Receipts,0) Receipts, ISNULL(Refunds,0) Refunds, ISNULL(ARBalance,0) ARBalance,
			ISNULL(DaysInAR,0) DaysInAR, ISNULL(DaysRevenueOutstanding,0) DaysRevenueOutstanding, 
			ISNULL(DaysToSubmission,0) DaysToSubmission, ISNULL(DaysToBill,0) DaysToBill,
			ISNULL(UnappliedBeginBalance, 0) UnappliedBeginBalance, ISNULL(UnappliedEndBalance, 0) UnappliedEndBalance
		FROM @ReportResults


	END
END	


drop table #claimAccounting
drop table #ReceiptSum
drop table #rSum
GO





--------------------------------- ====================== ------------------------
-- KI Indicator Detail
--------------------------------- ====================== ------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReportDataProvider_KeyIndicatorsDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ReportDataProvider_KeyIndicatorsDetail]

GO


-- ReportDataProvider_KeyIndicatorsDetail 65 ,0,false,'5/1/2006', '5/31/2006'
CREATE PROCEDURE [dbo].[ReportDataProvider_KeyIndicatorsDetail]
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@SummarizeAllProviders bit = 0,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@ReportType INT = 1,			-- 1 = Use Posting Date of "PAY" from Payment Table, All other will come from Claims
									-- 2 = Using Posting Date for all from Service Line, 
									-- 3= Same as 2, but fix error condition where Payment.PostingDate > ClaimTransaction.PostingDate

	@GroupBy Char(1) = 'P',	-- P=Provider, S=ServiceLocation, D=Department	
	@DepartmentID INT = 0,	
	@ServiceLocationID INT = 0
AS


--DECLARE
--	@PracticeID int,
--	@ProviderID int,
--	@SummarizeAllProviders bit,
--	@BeginDate datetime,
--	@EndDate datetime,
--	@ReportType INT,
--	@GroupBy Char(1),	-- P=Provider, S=ServiceLocation, D=Department	
--	@DepartmentID INT,	
--	@ServiceLocationID INT
--
--
--SELECT
--	@PracticeID = 65,
--	@ProviderID =0,
--	@SummarizeAllProviders = 1,
--	@BeginDate ='11/1/06',
--	@EndDate ='11/30/06',
--	@ReportType = 1,
--	@GroupBy = 'P',	-- P=Provider, S=ServiceLocation, D=Department	
--	@DepartmentID = 0,	
--	@ServiceLocationID = 0


SET NOCOUNT ON


DECLARE
	@ShowUnbilledAR BIT,
	@FixPaymentPostingDate BIT


	IF @ReportType = 1	OR @ReportType IS NULL		-- Use Posting Date of pament from Payment Table, Posting Date of CST, ADJ from ClaimAccounting. See Case 11167 
		BEGIN
			SET @ShowUnbilledAR = 1
			SET @FixPaymentPostingDate = 0
		END
	ELSE IF @ReportType = 2		-- Use Posting Date of Service Line. Fix Error condition where Payment.PostingDate > ClaimAccounting.PostingDate. See case 12036 
		BEGIN
			SET @ShowUnbilledAR = 0
			SET @FixPaymentPostingDate = 1
		END
	ELSE						-- Use Posting Date of Service Line as is. Orginal calculation
		BEGIN
			SET @ShowUnbilledAR = 0
			SET @FixPaymentPostingDate = 0
		END
	


	DECLARE @EndOfDayEndDate DATETIME
	SET @EndOfDayEndDate=DATEADD(S,-1,DATEADD(D,1, dbo.fn_dateOnly(@EndDate)))

	SET @SummarizeAllProviders = ISNULL(@SummarizeAllProviders, 0)
	SET @ShowUnbilledAR = ISNULL(@ShowUnbilledAR, 1) -- Always use the TOTAL AR Calculation

	DECLARE @ReportResults TABLE(GroupID INT, GroupDescription VARCHAR(256), ChargesProcedureCount INT, 
				     ChargesAvgCharge MONEY, TotalCharges MONEY, TotalAdjustments MONEY,
				     ReceiptsInsurance MONEY, ReceiptsPatient MONEY, ReceiptsOther MONEY, 
				     TotalReceipts MONEY, RefundsInsurance MONEY, RefundsPatient MONEY, 
				     RefundsOther MONEY, TotalRefunds MONEY, ARBalanceBeginning MONEY, ARBalanceEnd MONEY,
				     ARBalanceChangePercent DECIMAL(14,2), DaysInAR DECIMAL(10,2), DaysRevenueOutstanding DECIMAL(18,2),
				     DaysToSubmission DECIMAL(10,2), DaysToBill DECIMAL(10,2), TotalRefundsPrior MONEY,
					 UnappliedBeginBalance MONEY, UnappliedEndBalance MONEY)

	DECLARE @FinalResults TABLE(GroupID INT, GroupDescription VARCHAR(256), Description VARCHAR(250), Computation DECIMAL(18, 2), Specifier VARCHAR(10))
	DECLARE @FinalResults2 TABLE(GroupID INT, Code VARCHAR(50), Description VARCHAR(250), Computation DECIMAL(18, 2), Specifier VARCHAR(10))
	create table #rSum( PaymentID INT, AppliedPrior MONEY, AppliedCurrent MONEY, uAppliedPrior MONEY, uAppliedCurrent MONEY, AppliedAll MONEY )
	create table #ReceiptSum( Rec_PaymentBeginBal MONEY, Rec_PaymentEndBal MONEY, 
							App_PaymentBeginBal MONEY, App_PaymentEndBal MONEY, uApp_PaymentBeginBal MONEY, uApp_PaymentEndBal MONEY, 
							Unapplied MONEY, App_Insurance MONEY, App_Patient MONEY, App_Others MONEY )

	IF  @GroupBy = 'S'
		BEGIN
			-- Place holder for those not associated to Service Location
			INSERT @ReportResults(GroupID, GroupDescription)
			SELECT -1, 'Other'

			INSERT @ReportResults(GroupID, GroupDescription)
			SELECT ServiceLocationID, Name
			FROM ServiceLocation
			WHERE PracticeID = @PracticeID
				AND ( @ServiceLocationID = 0 or @ServiceLocationID = ServiceLocationID )
		END
	ELSE IF  @GroupBy = 'D'
		BEGIN
			-- Place holder for those not associated to Department
			INSERT @ReportResults(GroupID, GroupDescription)
			SELECT -1, 'Other'

			INSERT @ReportResults(GroupID, GroupDescription)
			SELECT dept.DepartmentID, Name
			FROM Department dept
				LEFT JOIN Doctor d on d.PracticeID = dept.PracticeID AND d.DepartmentID = dept.DepartmentID
			WHERE dept.PracticeID = @PracticeID
				AND ( @DepartmentID = 0 or @DepartmentID = dept.DepartmentID )
				AND ( @ProviderID = 0 OR @ProviderID = d.DoctorID )

		END
	ELSE 
		BEGIN
			INSERT @ReportResults(GroupID, GroupDescription)
			SELECT d.DoctorID ProviderID, RTRIM(ISNULL(FirstName + ' ','') + ISNULL(MiddleName + ' ', '')) + ISNULL(' ' + LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(Degree), '') AS GroupDescription
			FROM Doctor d
				LEFT JOIN Department dept on d.PracticeID = dept.PracticeID AND d.DepartmentID = dept.DepartmentID
			WHERE d.PracticeID=@PracticeID
				AND [External] = 0
				AND ( @ProviderID = 0 or @ProviderID = d.DoctorID )
				AND ( @DepartmentID = 0 or @DepartmentID = dept.DepartmentID )
		END
	
	DECLARE @ClaimAmounts TABLE(GroupID INT, ProcedureCount INT, Charges MONEY, Adjustments MONEY)
	DECLARE @Receipts TABLE(GroupID INT, ClaimTransactionID INT, ClaimID INT, PaymentID INT, PostingDate DATETIME, Amount MONEY, PayerTypeCode varchar(50), CA_PostingDate DATETIME )
	DECLARE @AR TABLE (GroupID INT, BeginARAmount MONEY, EndARAmount MONEY)


	Create TABLE #ClaimAccounting  (
		GroupID [int] NULL,
		ServiceLocationID [int] NULL,
		DepartmentID [int] NULL,
		[ProviderID] [int] NOT NULL,
		[ClaimID] [int] NOT NULL,
		[ClaimTransactionID] [int] NOT NULL,
		[ClaimTransactionTypeCode] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ProcedureCount] [int] NULL,
		[Amount] [money] NULL,
		[Status] [bit] NOT NULL,
		[PostingDate] [datetime] NOT NULL,
		[Pay_PostingDate] [datetime] NULL,
		[PaymentID] [int] NULL,
		[PayerTypeCode] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	)


	INSERT INTO #ClaimAccounting( ProviderID, ClaimID, ClaimTransactionID, ClaimTransactionTypeCode, ProcedureCount, 
			Amount, 
			Status, PostingDate, Pay_PostingDate, 
			PaymentID, PayerTypeCode)
	SELECT CA.ProviderID, CA.ClaimID, CA.ClaimTransactionID, ClaimTransactionTypeCode, ProcedureCount, 
			Amount, --CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN (CASE WHEN CA.PostingDate <= @EndOfDayEndDate THEN Amount ELSE 0 END) ELSE Amount END,
			Status, CA.PostingDate, P.PostingDate AS Pay_PostingDate, 
			P.PaymentID, PayerTypeCode
	FROM ClaimAccounting ca
			LEFT JOIN PaymentClaimTransaction PCT ON pct.PracticeID = @PracticeID AND CA.ClaimTransactionID=PCT.ClaimTransactionID
			LEFT JOIN Payment P ON P.PracticeID = @PracticeID AND PCT.PaymentID=P.PaymentID
	WHERE ca.PracticeID = @PracticeID
		AND ClaimTransactionTypeCode IN ('ADJ', 'CST', 'PAY', 'BLL')
		AND ( ca.PostingDate <= @EndOfDayEndDate OR p.PostingDate <= @EndOfDayEndDate)


	UPDATE ca
	SET GroupID = ISNULL( CASE @GroupBy 
						WHEN  'S' THEN E.LocationID
						WHEN  'D' THEN D.DepartmentID
						ELSE CA.ProviderID END,
					-1),
		ServiceLocationID = E.LocationID,
		DepartmentID = D.DepartmentID
	FROM #ClaimAccounting ca
			INNER JOIN Doctor D on D.PracticeID = @PracticeID AND d.DoctorID = CA.ProviderID
			INNER JOIN Claim c on c.PracticeID = @PracticeID AND c.ClaimID = ca.ClaimID
			INNER JOIN EncounterProcedure ep on ep.PracticeID = @PracticeID AND ep.EncounterProcedureID = c.EncounterProcedureID
			INNER JOIN Encounter e on e.PracticeID = @PracticeID AND e.EncounterID = ep.EncounterID



	-- Filters based on Paramter
	DELETE #ClaimAccounting
	WHERE
		( @DepartmentID <> 0 AND  @DepartmentID <> ISNULL(DepartmentID, 0) ) OR
		( @ServiceLocationID <> 0 AND @ServiceLocationID <> ISNULL(ServiceLocationID, 0) ) OR
		( @ProviderID <> 0 AND @ProviderID <> ISNULL(ProviderID, 0) )


	IF ISNULL(@ShowUnbilledAR, 0) = 1
		BEGIN

			INSERT @ClaimAmounts(GroupID, ProcedureCount, Charges, Adjustments)
			SELECT GroupID, 
				SUM(ProcedureCount) ProcedureCount, 
				SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN AMOUNT ELSE 0 END ) Charges,
				SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN AMOUNT ELSE 0 END ) Adjustments
			FROM #ClaimAccounting ca 
			WHERE CA.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
					AND ClaimTransactionTypeCode IN ('ADJ','CST')
			GROUP BY GroupID


			INSERT @Receipts(GroupID, ClaimTransactionID, ClaimID, PaymentID, PostingDate, Amount, PayerTypeCode, CA_PostingDate)
			SELECT GroupID, ClaimTransactionID, ClaimID, PaymentID, 
					PostingDate, -- Pay_PostingDate, 
					Amount, PayerTypeCode, 
					Pay_PostingDate --CA.PostingDate
			FROM #ClaimAccounting CA 
			WHERE (PAY_PostingDate <= @EndOfDayEndDate OR PostingDate <= @EndOfDayEndDate)
				AND ClaimTransactionTypeCode='PAY'


			INSERT @AR(GroupID, BeginARAmount, EndARAmount)
			SELECT GroupID, 			
					BeginARAmount = SUM( CASE WHEN CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN PAY_PostingDate ELSE PostingDate END < @BeginDate 
											THEN CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END 
											ELSE 0 END ),
					EndARAmount = SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END )			
			FROM #ClaimAccounting CA 
			WHERE (	(ClaimTransactionTypeCode = 'PAY' AND PAY_PostingDate  <= @EndOfDayEndDate)
							OR  
					(ClaimTransactionTypeCode <> 'PAY' AND PostingDate  <= @EndOfDayEndDate)
				  )
			GROUP BY GroupID
			HAVING 0 <> SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END )


		END ELSE 
		BEGIN

			IF ISNULL( @FixPaymentPostingDate, 0) = 1
				BEGIN
					-- Error condition of PaymentPostingDate Fixes 
					UPDATE #ClaimAccounting
					SET PostingDate = Pay_PostingDate
					WHERE Pay_PostingDate > PostingDate
				END

			INSERT @ClaimAmounts(GroupID, ProcedureCount, Charges, Adjustments)
			SELECT GroupID, 
				SUM(ProcedureCount) ProcedureCount, 
				SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN AMOUNT ELSE 0 END ) Charges,
				SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN AMOUNT ELSE 0 END ) Adjustments
			FROM #ClaimAccounting CA 
			WHERE  PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
					AND ClaimTransactionTypeCode IN ('ADJ','CST')
			GROUP BY GroupID


			INSERT @Receipts(GroupID, ClaimTransactionID, ClaimID, PaymentID, PostingDate, Amount, PayerTypeCode, CA_PostingDate)
			SELECT GroupID, CA.ClaimTransactionID, CA.ClaimID, ca.PaymentID, 
					Pay_PostingDate, 
					Amount, 
					PayerTypeCode, 
					PostingDate
			FROM #ClaimAccounting CA
			WHERE ClaimTransactionTypeCode='PAY'
					AND PostingDate <= @EndOfDayEndDate

			INSERT @AR(GroupID, BeginARAmount, EndARAmount)
			SELECT GroupID, 			
					BeginARAmount = SUM( CASE WHEN PostingDate < @BeginDate THEN CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END ELSE 0 END ),
					EndARAmount = SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END )			
			FROM #ClaimAccounting ca 
			WHERE	PostingDate <= @EndOfDayEndDate
			GROUP BY GroupID

		END

	UPDATE RR SET ChargesProcedureCount=ProcedureCount, ChargesAvgCharge=CASE WHEN ProcedureCount=0 THEN 0 ELSE Charges/ProcedureCount END,
	TotalCharges=Charges, TotalAdjustments=Adjustments
	FROM @ReportResults RR INNER JOIN @ClaimAmounts CA ON RR.GroupID=CA.GroupID

	DECLARE @ReceiptsSummarized TABLE(GroupID INT, ReceiptsI MONEY, ReceiptsP MONEY, ReceiptsO MONEY, ReceiptsTotal MONEY)
	INSERT @ReceiptsSummarized(GroupID, ReceiptsI, ReceiptsP, ReceiptsO, ReceiptsTotal)
	SELECT GroupID, 
	SUM(CASE WHEN PayerTypeCode='I' THEN R.Amount ELSE 0 END) ReceiptsI,
	SUM(CASE WHEN PayerTypeCode='P' THEN R.Amount ELSE 0 END) ReceiptsP,
	SUM(CASE WHEN PayerTypeCode='O' THEN R.Amount ELSE 0 END) ReceiptsO,
	SUM(R.Amount) ReceiptsTotal
	FROM @Receipts R
	WHERE ( ISNULL(@ShowUnbilledAR, 0) = 1
			AND ( (ISNULL(@SummarizeAllProviders, 0) = 1  AND (PostingDate <= @EndOfDayEndDate OR CA_PostingDate <= @EndOfDayEndDate) ) -- All Provider
					OR (ISNULL(@SummarizeAllProviders, 0) = 0 AND  PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate )
				)
			) OR 
		( ISNULL(@ShowUnbilledAR, 0) = 0 
			AND (
					(ISNULL(@SummarizeAllProviders, 0) = 1 AND (CA_PostingDate <= @EndOfDayEndDate ))
					 OR (ISNULL(@SummarizeAllProviders, 0) = 0 AND  CA_PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate )						
				)
		)
	GROUP BY GroupID


	UPDATE RR SET ReceiptsInsurance=ReceiptsI, ReceiptsPatient=ReceiptsP, ReceiptsOther=ReceiptsO,
	TotalReceipts=ReceiptsTotal
	FROM @ReportResults RR INNER JOIN @ReceiptsSummarized RS ON RR.GroupID=RS.GroupID
	

	UPDATE RR 
	SET ARBalanceBeginning=ISNULL(BeginARAmount,0),
		ARBalanceEnd=ISNULL(EndARAmount,0),
		ARBalanceChangePercent=CASE WHEN ISNULL(BeginARAmount,0) =0 THEN 0 ELSE (ISNULL(EndARAmount,0)-ISNULL(BeginARAmount,0) )/ISNULL(BeginARAmount,0) END
	FROM @ReportResults RR INNER JOIN @AR BAR ON RR.GroupID=BAR.GroupID



	-- When Filtering by ServiceLocationID, we delete groups that have no activities. 
	DELETE @ReportResults
	WHERE TotalCharges IS NULL 
			AND TotalAdjustments IS NULL
			AND TotalReceipts IS NULL
			AND @ServiceLocationID <> 0

	
	--Prep the Days in AR Calc
	DECLARE @DaysInARI TABLE(GroupID INT, ClaimID INT, Amount MONEY, Weighted MONEY)
	INSERT @DaysInARI(GroupID, ClaimID, Amount, Weighted)
	SELECT R.GroupID, R.ClaimID, SUM(R.Amount) Amount, SUM(R.Amount)*AVG(DATEDIFF(D,CA.PostingDate, R.CA_PostingDate)) Weighted
	FROM #ClaimAccounting CA INNER JOIN @Receipts R ON CA.ClaimID=R.ClaimID
	WHERE ClaimTransactionTypeCode='BLL'
		AND R.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
	GROUP BY R.GroupID, R.ClaimID
	
	DECLARE @DaysInARII TABLE(GroupID INT, DaysInAR DECIMAL(10,2))
	INSERT @DaysInARII(GroupID, DaysInAR)
	SELECT GroupID, CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END DaysInAR
	FROM @DaysInARI
	GROUP BY GroupID
	
	UPDATE RR SET DaysInAR=D.DaysInAR
	FROM @ReportResults RR INNER JOIN @DaysInARII D ON RR.GroupID=D.GroupID
	
	--Prep the DaysRevenueOutstanding Calc
	DECLARE @DaysRevenueOutstandingI TABLE(GroupID INT, ClaimID INT, Amount MONEY, Weighted MONEY)
	INSERT @DaysRevenueOutstandingI(GroupID, ClaimID, Amount, Weighted)
	SELECT R.GroupID, R.ClaimID, SUM(Amount) Amount, SUM(Amount)*AVG(DATEDIFF(D,ProcedureDateOfService, R.CA_PostingDate)) Weighted
	FROM Claim C INNER JOIN @Receipts R ON C.ClaimID=R.ClaimID
	INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
	WHERE C.PracticeID = @PracticeID
			AND R.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
	GROUP BY R.GroupID, R.ClaimID
	
	DECLARE @DaysRevenueOutstandingII TABLE(GroupID INT, DaysRevenueOutstanding DECIMAL(10,2))
	INSERT @DaysRevenueOutstandingII(GroupID, DaysRevenueOutstanding)
	SELECT GroupID, CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END DaysRevenueOutstanding
	FROM @DaysRevenueOutstandingI
	GROUP BY GroupID
	
	UPDATE RR SET DaysRevenueOutstanding=D.DaysRevenueOutstanding
	FROM @ReportResults RR INNER JOIN @DaysRevenueOutstandingII D ON RR.GroupID=D.GroupID
	
	DECLARE @OtherDays TABLE(GroupID INT, ClaimID INT, ProcedureDateOfService DATETIME, SubmittedDate DATETIME)
	INSERT @OtherDays(GroupID, ClaimID, ProcedureDateOfService, SubmittedDate)
	SELECT DoctorID GroupID, C.ClaimID, CAST(CONVERT(CHAR(10), ProcedureDateOfService,110) AS DATETIME) ProcedureDateOfService, 
	CAST(CONVERT(CHAR(10), E.SubmittedDate, 110) AS DATETIME) SubmittedDate
	FROM Encounter E 
		INNER JOIN EncounterProcedure EP ON E.PracticeID=EP.PracticeID AND E.EncounterID=EP.EncounterID
		INNER JOIN Claim C ON EP.PracticeID=C.PracticeID AND EP.EncounterProcedureID=C.EncounterProcedureID
		INNER JOIN #ClaimAccounting CA ON C.ClaimID=CA.ClaimID
	WHERE E.PracticeID = @PracticeID 
		AND CA.PostingDate<=@EndOfDayEndDate 
		AND Status=0 
		AND ClaimTransactionTypeCode='CST'
	
	DECLARE @DaysToSubmission TABLE(GroupID INT, DaysToSubmission DECIMAL(10,2))
	INSERT @DaysToSubmission(GroupID, DaysToSubmission)
	SELECT GroupID, AVG(DATEDIFF(D, ProcedureDateOfService, SubmittedDate)) DaysToSubmission
	FROM @OtherDays
	GROUP BY GroupID
	
	UPDATE RR SET DaysToSubmission=DS.DaysToSubmission
	FROM @ReportResults RR INNER JOIN @DaysToSubmission DS ON RR.GroupID=DS.GroupID
	
	DECLARE @DaysToBill TABLE(GroupID INT, DaysToBill DECIMAL(10,2))
	INSERT @DaysToBill(GroupID, DaysToBill)
	SELECT OD.GroupID, AVG(DATEDIFF(D, SubmittedDate, PostingDate))
	FROM ClaimAccounting CA INNER JOIN @OtherDays OD ON CA.ClaimID=OD.ClaimID
	WHERE ClaimTransactionTypeCode='BLL'
	GROUP BY OD.GroupID
	
	UPDATE RR SET DaysToBill=DB.DaysToBill
	FROM @ReportResults RR INNER JOIN @DaysToBill DB ON RR.GroupID=DB.GroupID
	


-------------------  Calculates the "All Grouping section. Adds Unapplied amounts, Refunds, etc.... ----------

		--Get Refund Totals For use in report sum, or do check to see if 1 provider only which does not require summary
		DECLARE @Refunds TABLE(PracticeID INT, RefundsInsurance MONEY, RefundsPatient MONEY, RefundsOther MONEY, TotalRefunds MONEY, TotalRefundsPrior MONEY)
		INSERT @Refunds(PracticeID, RefundsInsurance, RefundsPatient, RefundsOther, TotalRefunds, TotalRefundsPrior)
		SELECT PracticeID, 
		SUM(CASE WHEN RecipientTypeCode='I' AND PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate THEN RefundAmount ELSE 0 END) RefundsInsurance,
		SUM(CASE WHEN RecipientTypeCode='P' AND PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate THEN RefundAmount ELSE 0 END) RefundsPatient,
		SUM(CASE WHEN RecipientTypeCode='O' AND PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate THEN RefundAmount ELSE 0 END) RefundsOther,
		SUM( CASE WHEN PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate THEN RefundAmount ELSE 0 END ) ThisPeriod,
		SUM( CASE WHEN PostingDate < @BeginDate THEN RefundAmount ELSE 0 END ) PriorRefunds
		FROM Refund
		WHERE PracticeID=@PracticeID AND PostingDate <= @EndOfDayEndDate
		GROUP BY PracticeID

		INSERT @ReportResults(GroupID, GroupDescription, ChargesProcedureCount, ChargesAvgCharge, TotalCharges,
				      TotalAdjustments, ReceiptsInsurance, ReceiptsPatient,
				      ReceiptsOther, TotalReceipts, ARBalanceBeginning, ARBalanceEnd, ARBalanceChangePercent)
		SELECT 0 GroupID, 
		NULL GroupDescription, 
		SUM(ChargesProcedureCount) ChargesProcedureCount, 
		ChargesAvgCharge = CASE WHEN SUM(ChargesProcedureCount)=0 THEN 0 ELSE SUM(TotalCharges)/SUM(ChargesProcedureCount)  END,
		SUM(TotalCharges) TotalCharges,
		SUM(TotalAdjustments) TotalAdjustments, 
		SUM(ReceiptsInsurance) ReceiptsInsurance, 
		SUM(ReceiptsPatient) ReceiptsPatient, 
		SUM(ReceiptsOther) ReceiptsOther, 
		SUM(TotalReceipts) TotalReceipts, 
		SUM(ARBalanceBeginning) ARBalanceBeginning,
		SUM(ARBalanceEnd) ARBalanceEnd, 
		ARBalanceChangePercent = CASE WHEN SUM(ARBalanceBeginning)=0 THEN 0 ELSE (SUM(ARBalanceEnd)-SUM(ARBalanceBeginning)) / SUM(ARBalanceBeginning) END
		FROM @ReportResults
		
		
		UPDATE RR SET RefundsInsurance=ISNULL(R.RefundsInsurance,0), RefundsPatient=ISNULL(R.RefundsPatient,0), RefundsOther=ISNULL(R.RefundsOther,0),
		TotalRefunds=ISNULL(R.TotalRefunds,0),
		TotalRefundsPrior = ISNULL(R.TotalRefundsPrior, 0)
		FROM @ReportResults RR INNER JOIN @Refunds R ON @PracticeID=R.PracticeID
		WHERE GroupID = 0
		
		DECLARE @DaysInARSum TABLE(GroupID INT, DaysInAR DECIMAL(10,2))
		INSERT @DaysInARSum(GroupID, DaysInAR)
		SELECT 0 GroupID, CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END DaysInAR
		FROM @DaysInARI
		
		UPDATE RR SET DaysInAR=D.DaysInAR
		FROM @ReportResults RR INNER JOIN @DaysInARSum D ON RR.GroupID=D.GroupID
		WHERE rr.GroupID = 0
		
		DECLARE @DaysRevenueOutstandingSum TABLE(GroupID INT, DaysRevenueOutstanding DECIMAL(10,2))
		INSERT @DaysRevenueOutstandingSum(GroupID, DaysRevenueOutstanding)
		SELECT 0 GroupID, CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END DaysRevenueOutstanding
		FROM @DaysRevenueOutstandingI
		
		UPDATE RR SET DaysRevenueOutstanding=D.DaysRevenueOutstanding
		FROM @ReportResults RR INNER JOIN @DaysRevenueOutstandingSum D ON RR.GroupID=D.GroupID
		WHERE rr.GroupID = 0
		
		DECLARE @DaysToSubmissionSum TABLE(GroupID INT, DaysToSubmission DECIMAL(10,2))
		INSERT @DaysToSubmissionSum(GroupID, DaysToSubmission)
		SELECT 0 GroupID, AVG(DATEDIFF(D, ProcedureDateOfService, SubmittedDate)) DaysToSubmission
		FROM @OtherDays
		
		UPDATE RR SET DaysToSubmission=DS.DaysToSubmission
		FROM @ReportResults RR INNER JOIN @DaysToSubmissionSum DS ON RR.GroupID=DS.GroupID
		WHERE rr.GroupID = 0
		
		DECLARE @DaysToBillSum TABLE(GroupID INT, DaysToBill DECIMAL(10,2))
		INSERT @DaysToBillSum(GroupID, DaysToBill)
		SELECT 0 GroupID, AVG(DATEDIFF(D, SubmittedDate, PostingDate))
		FROM ClaimAccounting CA INNER JOIN @OtherDays OD ON CA.ClaimID=OD.ClaimID
		WHERE ClaimTransactionTypeCode='BLL'
		
		UPDATE RR SET DaysToBill=DB.DaysToBill
		FROM @ReportResults RR INNER JOIN @DaysToBillSum DB ON RR.GroupID=DB.GroupID
		WHERE rr.GroupID = 0



		INSERT #rSum( PaymentID, AppliedPrior, AppliedCurrent, uAppliedPrior, uAppliedCurrent, AppliedAll )
		select PaymentID,
				AppliedPrior =	SUM( CASE WHEN CA_PostingDate < @BeginDate then Amount else 0 end ),
				AppliedCurrent = sum( CASE WHEN CA_PostingDate  <= @EndOfDayEndDate THEN Amount else 0 END),
				uAppliedPrior =	SUM( CASE WHEN PostingDate < @BeginDate then Amount else 0 end ),
				uAppliedCurrent = sum( CASE WHEN PostingDate  <= @EndOfDayEndDate THEN Amount else 0 END),
				AppliedAll =	SUM( Amount )
		from @Receipts r
		GROUP BY PaymentID



		INSERT #ReceiptSum( Rec_PaymentBeginBal, Rec_PaymentEndBal, 
			App_PaymentBeginBal, App_PaymentEndBal, uApp_PaymentBeginBal, uApp_PaymentEndBal, 
			Unapplied, App_Insurance, App_Patient, App_Others )
		SELECT
			Rec_PaymentBeginBal = sum( case when p.postingDate < @BeginDate then paymentAmount else 0 end ),
			Rec_PaymentEndBal = sum(case when p.postingDate <= @EndOfDayEndDate then paymentAmount else 0 end ),
			App_PaymentBeginBal = sum( AppliedPrior),
			App_PaymentEndBal = sum(AppliedCurrent),
			uApp_PaymentBeginBal = sum( uAppliedPrior),
			uApp_PaymentEndBal = sum(uAppliedCurrent),
			Unapplied = sum( case when p.postingDate  between @BeginDate AND @EndOfDayEndDate THEN PaymentAmount - ISNULL(AppliedAll, 0) else 0 end  ),
			App_Insurance =	SUM( CASE WHEN PayerTypeCode='I' AND P.PostingDate between @BeginDate AND @EndOfDayEndDate then PaymentAmount else 0 end ),
			App_Patient =	SUM( CASE WHEN PayerTypeCode='P' AND P.PostingDate between @BeginDate AND @EndOfDayEndDate then PaymentAmount else 0 end ),
			App_Others =	SUM( CASE WHEN PayerTypeCode='O' AND P.PostingDate between @BeginDate AND @EndOfDayEndDate then PaymentAmount else 0 end )
		from Payment P
			LEFT JOIN #rSum r  ON r.PaymentID=P.PaymentID
		WHERE  p.PracticeID = @PracticeID
			AND p.PostingDate <= @EndOfDayEndDate



		-- Applying Payment

		if @ReportType = 1 --Sum of Receipts is the same as applied receipts
		BEGIN

			UPDATE rr
			SET	ARBalanceEnd = isnull(ARBalanceEnd, 0) - ( (isnull( Rec_PaymentEndBal, 0) - ISNULL(App_PaymentEndBal, 0) )),
				ARBalanceBeginning = isnull(ARBalanceBeginning, 0) - ( isnull( Rec_PaymentBeginBal , 0) - ISNULL(App_PaymentBeginBal, 0) ),
				ReceiptsInsurance = isnull(App_Insurance, 0),
				ReceiptsPatient = isnull(App_Patient, 0),
				ReceiptsOther = isnull(App_Others, 0),
				TotalReceipts = isnull( Rec_PaymentEndBal, 0) - ISNULL(Rec_PaymentBeginBal, 0),
				UnappliedBeginBalance = ISNULL( Rec_PaymentBeginBal, 0) - ISNULL( uApp_PaymentBeginBal, 0),
				UnappliedEndBalance = ISNULL(Rec_PaymentEndBal, 0) - ISNULL( uApp_PaymentEndBal, 0)
			FROM @ReportResults rr, #ReceiptSum R
			WHERE RR.GroupID = 0

			Update RR
			SET UnappliedEndBalance = UnappliedEndBalance - isnull(
																	( select sum(amount) FROM @Receipts where postingDate between @BeginDate AND @EndOfDayEndDate AND ca_PostingDate > @EndOfDayEndDate )
																	, 0)
			FROM @ReportResults rr
			WHERE rr.GroupID = 0	

		END
		ELSE if @ReportType = 2 --Sum of Receipts is the same as applied receipts
		BEGIN

			UPDATE rr
			SET	ARBalanceEnd = isnull(ARBalanceEnd, 0) - ( (isnull( Rec_PaymentEndBal, 0) - ISNULL(App_PaymentEndBal, 0) )),
				ARBalanceBeginning = isnull(ARBalanceBeginning, 0) - ( isnull( Rec_PaymentBeginBal , 0) - ISNULL(App_PaymentBeginBal, 0) ),
				ReceiptsInsurance = isnull(App_Insurance, 0),
				ReceiptsPatient = isnull(App_Patient, 0),
				ReceiptsOther = isnull(App_Others, 0),
				TotalReceipts = isnull( Rec_PaymentEndBal, 0) - ISNULL(Rec_PaymentBeginBal, 0),
				UnappliedBeginBalance = ISNULL( Rec_PaymentBeginBal, 0) - ISNULL( App_PaymentBeginBal, 0),
				UnappliedEndBalance = ISNULL(Rec_PaymentEndBal, 0) - ISNULL( App_PaymentEndBal, 0)
			FROM @ReportResults rr, #ReceiptSum R
			WHERE RR.GroupID = 0
		END
		ELSE if @ReportType = 3 --Sum of Receipts is the same as applied receipts
		BEGIN

			UPDATE rr
			SET	
				ReceiptsInsurance = isnull(App_Insurance, 0),
				ReceiptsPatient = isnull(App_Patient, 0),
				ReceiptsOther = isnull(App_Others, 0),
				TotalReceipts = isnull( App_PaymentEndBal, 0) - ISNULL(App_PaymentBeginBal, 0)
			FROM @ReportResults rr, #ReceiptSum R
			WHERE rr.GroupID = 0

		END


--------------------------- End of applying payment


		-- Gets Capitated
		DECLARE @TotalCapitated MONEY, @PriorCapititated MONEY


		UPDATE rr
		SET	ARBalanceBeginning = ISNULL(ARBalanceBeginning,0) + ISNULL(TotalRefundsPrior, 0) - ISNULL(@PriorCapititated, 0),
			ARBalanceEnd = ISNULL(ARBalanceEnd,0)+ ISNULL(TotalRefundsPrior, 0) + ISNULL(TotalRefunds,0) - ISNULL(@TotalCapitated, 0)
		FROM @ReportResults rr
		WHERE GroupID = 0

		IF @SummarizeAllProviders=1
			DELETE @ReportResults WHERE GroupID<>0


--					SELECT GroupID, GroupDescription, ISNULL(ChargesProcedureCount,0) ChargesProcedureCount, ISNULL(ChargesAvgCharge,0) ChargesAvgCharge, ISNULL(TotalCharges,0) TotalCharges,
--					ISNULL(TotalAdjustments,0) TotalAdjustments, ISNULL(ReceiptsInsurance,0) ReceiptsInsurance, ISNULL(ReceiptsPatient,0) ReceiptsPatient, ISNULL(ReceiptsOther,0) ReceiptsOther, 
--					ISNULL(TotalReceipts,0) TotalReceipts, ISNULL(RefundsInsurance,0) RefundsInsurance,
--					ISNULL(RefundsPatient,0) RefundsPatient, ISNULL(RefundsOther,0) RefundsOther, ISNULL(TotalRefunds,0) TotalRefunds,
--					ISNULL(ARBalanceBeginning,0) ARBalanceBeginning, ISNULL(ARBalanceEnd,0) ARBalanceEnd, ISNULL(ARBalanceChangePercent,0) ARBalanceChangePercent,
--					ISNULL(DaysInAR,0) DaysInAR, ISNULL(DaysRevenueOutstanding,0) DaysRevenueOutstanding, ISNULL(DaysToSubmission,0) DaysToSubmission, ISNULL(DaysToBill,0) DaysToBill,
--					ISNULL(UnappliedBeginBalance, 0) UnappliedBeginBalance, ISNULL(UnappliedEndBalance, 0) UnappliedEndBalance
--					FROM @ReportResults


-------------- The rest of the section is to pivot the data. This is so that we don't have to use a subreprot ---------


		DELETE @ReportResults
		WHERE	GroupID = -1 AND
				TotalCharges IS NULL AND 
				TotalAdjustments IS NULL AND 
				TotalReceipts  IS NULL AND 
				TotalRefunds  IS NULL AND 
				ARBalanceEnd IS NULL


	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(ChargesProcedureCount,0), 'CPC'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(ChargesAvgCharge,0), 'CAC'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(TotalCharges,0), 'TC'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(TotalAdjustments,0), 'TA'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(ReceiptsInsurance,0), 'RCI'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(ReceiptsPatient,0), 'RCP'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(ReceiptsOther,0), 'RCO'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(TotalReceipts,0), 'TRC'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(RefundsInsurance,0), 'RFI'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(RefundsPatient,0), 'RFP'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(RefundsOther,0), 'RFO'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(TotalRefunds,0), 'TRF'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(ARBalanceChangePercent,0), 'ARBCP'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(DaysInAR,0), 'DIAR'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(DaysRevenueOutstanding,0), 'DRO'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(DaysToSubmission,0), 'DTS'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(DaysToBill,0), 'DTB'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(UnappliedBeginBalance,0), 'UnApBegin'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(UnappliedEndBalance,0), 'UnApEnd'
	FROM @ReportResults


	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(ARBalanceBeginning,0), 'ARBB'
	FROM @ReportResults

	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT GroupID, GroupDescription, '', ISNULL(ARBalanceEnd,0), 'ARBE'
	FROM @ReportResults




	SET @BeginDate =  dbo.fn_DateOnly(@BeginDate)
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))

		-- Adds the Adjustment Reason codes.
		INSERT @FinalResults2(GroupID, Code, Description, Computation, Specifier)
		SELECT Claim_ProviderID GroupID, CT.Code,
			ISNULL(AC.Description, 'Not Specified'),
			SUM(ISNULL(CT.Amount,0)), 'ADJ'
		FROM ClaimTransaction CT 
			LEFT JOIN VoidedClaims VC ON CT.ClaimID=VC.ClaimID
			LEFT JOIN Adjustment AC ON CT.Code=AC.AdjustmentCode
			LEFT OUTER JOIN PaymentClaimTransaction pct ON pct.PracticeID = @PracticeID AND pct.ClaimID = ct.ClaimID AND pct.ClaimTransactionID = ct.ClaimTransactionID
			LEFT OUTER JOIN Payment p on p.PracticeID=@PracticeID AND pct.PaymentID = p.PaymentID
			INNER JOIN #ClaimAccounting ca on ct.ClaimID = ca.ClaimID AND ca.ClaimTransactionID = ct.ClaimTransactionID
		WHERE CT.PracticeID=@PracticeID
		AND ca.PostingDate BETWEEN @BeginDate AND @EndDate
		AND CT.ClaimTransactionTypeCode = 'ADJ'
		AND VC.ClaimID IS NULL
		AND ((Claim_ProviderID = @ProviderID) OR (ISNULL(@ProviderID,0)=0))
		GROUP BY Claim_ProviderID, CT.Code, ISNULL(AC.Description, 'Not Specified')


		INSERT @FinalResults2(GroupID, Code, Description, Computation, Specifier)
		SELECT 0 GroupID,  Code, Description, SUM(Computation), Specifier
		FROM @FinalResults2
		GROUP BY Code, Description, Specifier


	INSERT @FinalResults(GroupID, GroupDescription, Description, Computation, Specifier)
	SELECT RR.GroupID, RR.GroupDescription, FR2.Description, SUM(FR2.Computation), FR2.Specifier
	FROM @FinalResults2 FR2
		INNER JOIN @ReportResults RR ON FR2.GroupID = RR.GroupID
	GROUP BY RR.GroupID, RR.GroupDescription, FR2.Description, FR2.Specifier


	SELECT GroupID, GroupDescription, Description, Computation, Specifier
	FROM @FinalResults



	drop table #ClaimAccounting
	Drop table #rSum, #ReceiptSum
