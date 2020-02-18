if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_KeyIndicatorsSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[ReportDataProvider_KeyIndicatorsSummary]

GO


-- dbo.ReportDataProvider_KeyIndicatorsSummary @PracticeID = 65, @SummarizeAllProviders=0, 	@BeginDate = '5/1/06', @EndDate = '5/31/06', @GroupBy = 'P'

CREATE PROCEDURE dbo.ReportDataProvider_KeyIndicatorsSummary
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
/*


DECLARE
	@PracticeID int,
	@ProviderID int,
	@SummarizeAllProviders bit,
	@BeginDate datetime,
	@EndDate datetime,
	@ReportType INT,
	@GroupBy Char(1),	-- P=Provider, S=ServiceLocation, D=Department	
	@DepartmentID INT,	
	@ServiceLocationID INT
	

SELECT
	@PracticeID =65,
	@ProviderID= 0,
	@SummarizeAllProviders = 0,
	@BeginDate = '5/1/06',
	@EndDate = '5/31/06',
	@ReportType = 1,
	@GroupBy = 'P',	-- P=Provider, S=ServiceLocation, D=Department	
	@DepartmentID = 0,	
	@ServiceLocationID = 0
*/


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
	create table #ReceiptSum (GroupID INT, Rec_PaymentBeginBal MONEY, Rec_PaymentEndBal MONEY, App_PaymentBeginBal MONEY, App_PaymentEndBal MONEY, Unapplied MONEY )
	CREATE TABLE #rSum ( PaymentID INT, AppliedPrior MONEY, AppliedCurrent MONEY, AppliedAll MONEY )


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

				INSERT INTO #rSum ( PaymentID, AppliedPrior, AppliedCurrent, AppliedAll )
				select PaymentID,
						AppliedPrior =	SUM( CASE WHEN CA_PostingDate < @BeginDate then Amount else 0 end ),
						AppliedCurrent = sum( CASE WHEN CA_PostingDate  <= @EndOfDayEndDate THEN Amount else 0 END),
						AppliedAll =	SUM( Amount )
				from @Receipts r
				GROUP BY PaymentID


				INSERT INTO #ReceiptSum (GroupID , Rec_PaymentBeginBal , Rec_PaymentEndBal , App_PaymentBeginBal , App_PaymentEndBal , Unapplied  )
				SELECT
					GroupID = 0,
					Rec_PaymentBeginBal = sum( case when p.postingDate < @BeginDate then paymentAmount else 0 end ),
					Rec_PaymentEndBal = sum(case when p.postingDate <= @EndOfDayEndDate then paymentAmount else 0 end ),
					App_PaymentBeginBal = sum( AppliedPrior),
					App_PaymentEndBal = sum(AppliedCurrent),
					Unapplied = sum( case when p.postingDate  between @BeginDate AND @EndOfDayEndDate THEN PaymentAmount - ISNULL(AppliedAll, 0) else 0 end  )
				from Payment P
					LEFT JOIN #rSum r  ON r.PaymentID=P.PaymentID
				WHERE  p.PracticeID = @PracticeID
					AND p.PostingDate <= @EndOfDayEndDate


				UPDATE rr
				SET	ARBalance = isnull(ARBalance, 0) - ( (isnull( Rec_PaymentEndBal, 0) - ISNULL(App_PaymentEndBal, 0) )),
					Receipts = isnull( Rec_PaymentEndBal, 0) - ISNULL(Rec_PaymentBeginBal, 0),
					UnappliedBeginBalance = ISNULL( Rec_PaymentBeginBal, 0) - ISNULL( App_PaymentBeginBal, 0),
					UnappliedEndBalance = ISNULL(Rec_PaymentEndBal, 0) - ISNULL( App_PaymentEndBal, 0)
				FROM @ReportResults rr INNER JOIN #ReceiptSum R ON r.GroupID = rr.GroupID
				WHERE rr.GroupID = 0


		
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

