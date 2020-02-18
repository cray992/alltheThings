SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ARAging]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[ReportDataProvider_ARAging]
GO


-- [dbo].[ReportDataProvider_ARAging] @PracticeID = 65, @VelocitySort = 1, @EndDate = N'5/31/06', @BatchID = NULL, @PayerTypeCode = I
CREATE PROCEDURE dbo.ReportDataProvider_ARAging
	@PracticeID int = NULL,
	@PayerTypeCode char(1) = 'A', --Can be I, P, O or A for all
	@Responsibility BIT =0, --Can be currently assigned=0 or ultimate responsibility=1
	@AgeRange VARCHAR(20) = 'Current+', --Can be Current+, Age31_60, Age61_90, Age91_120, AgeOver120
	@BalanceRange VARCHAR(20) = 'All', --Can be All, $10+,$50+,$100+,$1000+,$5000+,$10000+,$100000
	@VelocitySort BIT = 0, --0 no sort on @AgeRange Balance otherwise sort desc on @AgeRange Balance
	@EndDate datetime = NULL, 
	@DateType Char(1) = 'B', -- B = Last Billed Date, P = Posting Date, S = Service Date
	@ProviderID INT = -1,
	@BatchID VARCHAR(50) = NULL,
	@ServiceLocationID INT = -1,
	@DepartmentID INT = -1,
	@PayerScenarioID INT = -1,
	@InsuranceCompanyPlanID INT = -1,
	@PatientID INT = -1,
	@ContractID INT = -1
AS
/*
DECLARE
	@PracticeID int,
	@PayerTypeCode char(1), --Can be I, P, or A for all
	@Responsibility BIT, --Can be currently assigned=0 or ultimate responsibility=1
	@AgeRange VARCHAR(20), --Can be Current+, Age31_60, Age61_90, Age91_120, AgeOver120
	@BalanceRange VARCHAR(20), --Can be All, $10+,$50+,$100+,$1000+,$5000+,$10000+,$100000
	@VelocitySort BIT, --0 no sort on @AgeRange Balance otherwise sort desc on @AgeRange Balance
	@EndDate datetime, 
	@BatchID VARCHAR(50),
	@ServiceLocationID INT,
	@DepartmentID INT,
	@PayerScenarioID INT,
	@ProviderID INT,
	@InsuranceCompanyPlanID INT,
	@PatientID INT,
	@ContractID INT,
	@DateType Char(1)
SELECT
	@PracticeID = 13,
	@PayerTypeCode = 'P', --Can be I, P, or A for all
	@Responsibility = 0, --Can be currently assigned=0 or ultimate responsibility=1
	@AgeRange = 'Current+', --Can be Current+, Age31_60, Age61_90, Age91_120, AgeOver120
	@BalanceRange = 'All', --Can be All, $10+,$50+,$100+,$1000+,$5000+,$10000+,$100000
	@VelocitySort = 0, --0 no sort on @AgeRange Balance otherwise sort desc on @AgeRange Balance
	@EndDate =  '7/30/06', 
	@BatchID = NULL,
	@ServiceLocationID = -1,
	@DepartmentID = -1,
	@PayerScenarioID = -1,
	@ProviderID = -1,
	@InsuranceCompanyPlanID = -1,
	@PatientID = -1,
	@ContractID = -1,
	@DateType = 'S'
*/


BEGIN
	SET NOCOUNT OFF
	SET @EndDate = DATEADD(S,-1,DATEADD(D,1,dbo.fn_DateOnly( @EndDate )))
	

	CREATE TABLE #AR (ClaimID INT, ARAmount MONEY, ServiceDate Datetime, PostingDate Datetime)
	INSERT INTO #AR(ClaimID, ARAmount, ServiceDate, PostingDate)
	SELECT	ca.ClaimID, 
			SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END ),
			ep.ProcedureDateOfService, e.PostingDate
	FROM ClaimAccounting  ca
		LEFT JOIN PaymentClaimTransaction PCT ON PCT.PracticeID = @PracticeID AND PCT.ClaimTransactionID = CA.ClaimTransactionID		
		LEFT JOIN Payment PMT  ON PMT.PracticeID = @PracticeID AND  PMT.PaymentID = PCT.PaymentID
		INNER JOIN Claim c ON c.PracticeID = @PracticeID AND c.ClaimID = ca.ClaimID
		INNER JOIN EncounterProcedure ep ON ep.PracticeID = @PracticeID AND c.EncounterProcedureID = ep.EncounterProcedureID
		INNER JOIN Encounter e ON e.PracticeID = @PracticeID AND e.EncounterID = ep.EncounterID
		INNER JOIN PatientCase pc ON pc.PracticeID = @PracticeID AND pc.PatientCaseID = e.PatientCaseID
		INNER JOIN Doctor d ON d.PracticeID = @PracticeID AND d.DoctorID = e.DoctorID
	WHERE ca.PracticeID=@PracticeID 
		AND CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN PMT.PostingDate else ca.PostingDate END <=@EndDate
		AND (@BatchID IS NULL OR RTRIM(@BatchID) = RTRIM(e.BatchID) )
		AND (@BatchID IS NULL OR RTRIM(@BatchID) = RTRIM(pmt.BatchID) )
		AND (@PayerScenarioID = -1 OR PC.PayerScenarioID = @PayerScenarioID)
		AND (@ServiceLocationID = -1 OR e.LocationID = @ServiceLocationID )
		AND (@DepartmentID = -1 OR d.DepartmentID = @DepartmentID )
		AND (@ProviderID = -1 OR @ProviderID = e.DoctorID )
		AND (@PatientID = -1 OR @PatientID = ca.PatientID )
	GROUP BY ca.ClaimID, ep.ProcedureDateOfService, e.PostingDate
	HAVING 0 <> SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END )




	--Get Last Assignments
	CREATE TABLE #ASNMax (ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #ASNMax(ClaimID, ClaimTransactionID )
	SELECT CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Assignments CAA INNER JOIN #AR AR ON CAA.ClaimID=AR.ClaimID
	WHERE PracticeID=@PracticeID AND caa.PostingDate<=@EndDate
	GROUP BY CAA.ClaimID
	
	CREATE TABLE #ASN (ClaimID INT, PatientID INT, InsurancePolicyID INT, PostingDate DATETIME, InsuranceCompanyPlanID INT, PlanName VARCHAR(128),
			   Phone VARCHAR(10), TypeGroup VARCHAR(128), TypeSort INT, TypeCode CHAR(1), Type VARCHAR(128))
	INSERT INTO #ASN(ClaimID, PatientID, InsurancePolicyID, PostingDate, InsuranceCompanyPlanID, PlanName,
			 Phone, TypeGroup, TypeSort, TypeCode, Type)
	SELECT CAA.ClaimID, CAA.PatientID, CAA.InsurancePolicyID, CAA.PostingDate, caa.InsuranceCompanyPlanID, PlanName, ICP.Phone,
	CASE WHEN InsurancePolicyID IS NULL THEN 'Patient' ELSE 'Insurance' END TypeGroup, 
	CASE WHEN InsurancePolicyID IS NULL THEN 2 ELSE 1 END TypeSort, 
	CASE WHEN InsurancePolicyID IS NULL THEN 'P' ELSE 'I' END TypeCode, 
	CASE WHEN InsurancePolicyID IS NULL THEN 'Patient' ELSE 'Insurance' END Type 
	FROM ClaimAccounting_Assignments CAA 
		INNER JOIN #ASNMax AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
		LEFT JOIN InsuranceCompanyPlan ICP ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
		LEFT JOIN ContractToInsurancePlan cp ON cp.PlanID = caa.InsuranceCompanyPlanID
		LEFT JOIN contract c ON  c.PracticeID = @PracticeID AND c.ContractID = cp.ContractID
	WHERE CAA.PracticeID=@PracticeID AND CAA.PostingDate<=@EndDate
		AND (@ContractID = -1 OR C.ContractID = @ContractID)
	GROUP BY CAA.ClaimID, CAA.PatientID, CAA.InsurancePolicyID, CAA.PostingDate, caa.InsuranceCompanyPlanID, PlanName, ICP.Phone,
		CASE WHEN InsurancePolicyID IS NULL THEN 'Patient' ELSE 'Insurance' END , 
		CASE WHEN InsurancePolicyID IS NULL THEN 2 ELSE 1 END , 
		CASE WHEN InsurancePolicyID IS NULL THEN 'P' ELSE 'I' END , 
		CASE WHEN InsurancePolicyID IS NULL THEN 'Patient' ELSE 'Insurance' END  


	-- Get Date of AR based on DateType Selection
	CREATE TABLE #BLL(ClaimID INT, PostingDate DATETIME)
	IF 	@DateType = 'S' -- Use service Date
		BEGIN
			INSERT #BLL(ClaimID, PostingDate)
			SELECT ClaimID, Max(ServiceDate)
			FROM #AR
			GROUP BY ClaimID
		END
	ELSE IF @DateType = 'P' -- Use Posting Date
		BEGIN
			INSERT #BLL(ClaimID, PostingDate)
			SELECT ClaimID, Max(PostingDate)
			FROM #AR
			GROUP BY ClaimID
		END
	ELSE
		BEGIN

			--Get Last Billed Info
			CREATE TABLE #BLLMax (ClaimID INT, ClaimTransactionID INT)
			INSERT INTO #BLLMax(ClaimID, ClaimTransactionID)
			SELECT CAB.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
			FROM ClaimAccounting_Billings CAB INNER JOIN #AR AR ON CAB.ClaimID=AR.ClaimID
			WHERE PracticeID=@PracticeID AND cab.PostingDate<=@EndDate 
			GROUP BY CAB.ClaimID
			
			INSERT #BLL(ClaimID, PostingDate)
			SELECT CAB.ClaimID, CAB.PostingDate
			FROM ClaimAccounting_Billings CAB INNER JOIN #BLLMax BM ON CAB.ClaimTransactionID=BM.ClaimTransactionID
			WHERE PracticeID=@PracticeID AND CAB.PostingDate<=@EndDate

			DROP TABLE #BLLMax
		END
	
	
	--Get Last Paid Info
	CREATE TABLE #PAYMax (ClaimID INT, PostingDate DATETIME)
	INSERT INTO #PAYMax(ClaimID, ca.PostingDate)
	SELECT CA.ClaimID, MAX(ca.PostingDate) PostingDate
	FROM ClaimAccounting CA INNER JOIN #AR AR ON CA.ClaimID=AR.ClaimID
	WHERE PracticeID=@PracticeID AND CA.PostingDate<=@EndDate AND ClaimTransactionTypeCode='PAY'
	GROUP BY CA.ClaimID
	
	CREATE TABLE #PAY(Num INT, TypeCode CHAR(1), PostingDate DATETIME)
	INSERT #PAY(Num, TypeCode, PostingDate)
	SELECT ISNULL(InsuranceCompanyPlanID, ASN.PatientID) Num, TypeCode, MAX(PM.PostingDate) PostingDate
	FROM #PAYMax PM INNER JOIN #ASN ASN ON PM.ClaimID=ASN.ClaimID
	GROUP BY ISNULL(InsuranceCompanyPlanID, ASN.PatientID), TypeCode

--------------------- Calc Unapplied Payments ----------------------------
	SELECT	PMT.PaymentID, 
			SUM( AMOUNT ) AppliedAmount
	INTO #AppliedReceipts
	FROM ClaimAccounting  ca
		INNER JOIN PaymentClaimTransaction PCT ON PCT.PracticeID = @PracticeID AND PCT.ClaimTransactionID = CA.ClaimTransactionID		
		INNER JOIN Payment PMT  ON PMT.PracticeID = @PracticeID AND  PMT.PaymentID = PCT.PaymentID
	WHERE  ca.PracticeID = @PracticeID
		AND PMT.PostingDate <= @EndDate
		AND ClaimTransactionTypeCode = 'PAY'
	GROUP BY PMT.PaymentID


	SELECT	PayerID, 
			PayerTypeCode,
			MAX(PostingDate) as PostingDate,
			SUM(PaymentAmount) as PaymentAmount
	INTO #SummarizedUnapplied
	FROM (
				SELECT	PayerID, 
						PayerTypeCode, 
						MAX(P.PostingDate) AS PostingDate, 
						SUM(ISNULL(PaymentAmount, 0) - ISNULL(a.AppliedAmount, 0) ) PaymentAmount
				FROM  Payment P
						LEFT OUTER JOIN #AppliedReceipts AS a ON a.PaymentID = p.PaymentID
				WHERE P.PracticeID=@PracticeID
					AND  p.PostingDate <= @EndDate
					AND (@BatchID is Null or RTRIM(p.BatchID) = RTRIM(@BatchID))
				GROUP BY p.PayerID,  p.PayerTypeCode
				HAVING 0 <> SUM(ISNULL(PaymentAmount, 0) - ISNULL(a.AppliedAmount, 0) )

				UNION ALL

				select p.PayerID, p.PayerTypeCode, MAX(r.PostingDate), sum(-1 * rtp.amount)
				from refund r 
					INNER jOIn refundToPayments rtp on r.RefundID = rtp.RefundID
					INNER JOIN Payment p on  p.practiceID = r.practiceID AND p.PaymentID = rtp.PaymentID
				WHERE r.PracticeID = @PracticeID AND r.PostingDate <= @EndDate 
					AND (@BatchID is Null or RTRIM(p.BatchID) = RTRIM(@BatchID))
				group by p.PayerID, payerTypeCode

			) as V
	WHERE 	(@PayerTypeCode='A' OR PayerTypeCode=@PayerTypeCode)  AND
			( @InsuranceCompanyPlanID = -1 OR (@InsuranceCompanyPlanID = PayerID AND PayerTypeCode = 'I')) AND
			( @PatientID = -1 OR (@PatientID = PayerID AND PayerTypeCode = 'P')) AND 
			@ServiceLocationID = -1 AND
			@DepartmentID = -1 AND
			@PayerScenarioID = -1 AND
			@ProviderID = -1 AND
			(@ContractID = -1 OR PayerID IN (SELECT cp.PlanID FROM ContractToInsurancePlan cp INNER JOIN contract c ON  c.PracticeID = @PracticeID AND c.ContractID = cp.ContractID ))
	GROUP BY PayerID, PayerTypeCode


		
	
	CREATE TABLE #ReportResults(TypeGroup VARCHAR(128), TypeSort INT, Num INT, TypeCode CHAR(1), Type VARCHAR(128), Name VARCHAR(128), Phone VARCHAR(10), LastBilled DATETIME, LastPaid DATETIME, Unapplied MONEY,
	CurrentBalance MONEY, Age31_60 MONEY, Age61_90 MONEY, Age91_120 MONEY, AgeOver120 MONEY, TotalBalance MONEY, AppliedReceipt MONEY)
	INSERT INTO #ReportResults(TypeGroup, TypeSort, Num, TypeCode, Type, Name, Phone, LastBilled, Unapplied, CurrentBalance, Age31_60, Age61_90, Age91_120, 
	AgeOver120, TotalBalance)
	SELECT CASE WHEN @Responsibility=1 THEN 'Patient' ELSE ISNULL(TypeGroup, 'Unassigned') END TypeGroup, CASE WHEN @Responsibility=1 THEN 2 ELSE ISNULL(TypeSort, 4) END TypeSort, 
		CASE WHEN @Responsibility=1 THEN ASN.PatientID ELSE ISNULL(ASN.InsuranceCompanyPlanID,ASN.PatientID) END Num, 
		CASE WHEN @Responsibility=1 THEN 'P' ELSE TypeCode END TypeCode, CASE WHEN @Responsibility=1 THEN 'Patient' ELSE Type END Type, 
		CASE WHEN @Responsibility=1 THEN '' ELSE PlanName END PlanName, 
		CASE WHEN @Responsibility=1 THEN '' ELSE Phone END Phone, MAX(BLL.PostingDate) LastBilled, 0 Unapplied,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 0 AND 30 OR BLL.PostingDate IS NULL THEN ARAmount ELSE 0 END) CurrentBalance,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 31 AND 60 THEN ARAmount ELSE 0 END) Age31_60,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 61 AND 90 THEN ARAmount ELSE 0 END) Age61_90,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 91 AND 120 THEN ARAmount ELSE 0 END) Age91_120,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) > 120 THEN ARAmount ELSE 0 END) AgeOver120,
		SUM(ARAmount) TotalBalance
	FROM #AR AR 
		LEFT JOIN #ASN ASN ON AR.ClaimID=ASN.ClaimID
		LEFT JOIN #BLL BLL ON AR.ClaimID=BLL.ClaimID
	WHERE (@InsuranceCompanyPlanID = -1 OR @InsuranceCompanyPlanID = InsuranceCompanyPlanID)
			AND (@ContractID = -1 OR AR.ClaimID=ASN.ClaimID)
	GROUP BY CASE WHEN @Responsibility=1 THEN 'Patient' ELSE ISNULL(TypeGroup, 'Unassigned') END, 
			 CASE WHEN @Responsibility=1 THEN 2 ELSE ISNULL(TypeSort, 4) END, 
			 CASE WHEN @Responsibility=1 THEN ASN.PatientID ELSE ISNULL(ASN.InsuranceCompanyPlanID,ASN.PatientID) END, 
			 CASE WHEN @Responsibility=1 THEN 'P' ELSE TypeCode END, 
			 CASE WHEN @Responsibility=1 THEN 'Patient' ELSE Type END, 
			 CASE WHEN @Responsibility=1 THEN '' ELSE PlanName END, 
			 CASE WHEN @Responsibility=1 THEN '' ELSE Phone END


	-- Set Unapplied Payments
	UPDATE RR
	SET Unapplied = ISNULL(PaymentAmount,0)
		, Totalbalance = ISNULL(RR.Totalbalance, 0) - ISNULL(R.PaymentAmount, 0)
		, LastPaid = r.PostingDate
	from #SummarizedUnapplied R
		INNER JOIN #ReportResults RR ON R.PayerID = RR.Num AND RR.TypeCode = r.PayerTypeCode


	-- Inserts Unapplied Payment that do not have Claims
	INSERT INTO #ReportResults( TypeGroup,TypeSort,Num,TypeCode,[Type],LastPaid,Unapplied,TotalBalance, Name, Phone)
	select TypeGroup = ptc.Description,
			TypeSort = CASE r.PayerTypeCode 
							WHEN  'I' THEN 1
							WHEN 'P' THEN 2
							ELSE 3 END,
			Num = PayerID,
			r.PayerTypeCode,
			[Type] = ptc.Description,
			LastPaid = PostingDate,
			Unapplied = PaymentAmount,
			TotalBalance = -1 * PaymentAmount, 
			PlanName = CASE WHEN @Responsibility=1 THEN '' ELSE PlanName END, 
			icp.Phone
	from #SummarizedUnapplied R
		INNER JOIN PayerTypeCode ptc on r.PayerTypeCode = ptc.PayerTypeCode
		LEFT OUTER JOIN #ReportResults RR ON R.PayerID = RR.Num AND RR.TypeCode = r.PayerTypeCode
		LEFT OUTER JOIN InsuranceCompanyPlan icp on icp.InsuranceCompanyPlanID = PayerID AND r.PayerTypeCode = 'I'
		LEFT OUTER JOIN Patient p ON p.PatientID = r.PayerID and r.PayerTypeCode = 'P'
	WHERE rr.TypeGroup IS NULL


	UPDATE RR SET LastPaid=PostingDate
	FROM #ReportResults RR INNER JOIN #PAY PAY
	ON RR.Num=PAY.Num AND RR.TypeCode=PAY.TypeCode

	
	UPDATE RR SET Name=RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')),
	Phone=P.HomePhone
	FROM #ReportResults RR INNER JOIN Patient P ON RR.Num=P.PatientID 
	AND RR.TypeCode='P'
	WHERE PracticeID=@PracticeID
	
	CREATE TABLE #FilteredResults(TypeGroup VARCHAR(128), TypeSort INT, Num INT, TypeCode CHAR(1), Type VARCHAR(128), Name VARCHAR(128), Phone VARCHAR(10), LastBilled DATETIME, LastPaid DATETIME, Unapplied MONEY,
	CurrentBalance MONEY, Age31_60 MONEY, Age61_90 MONEY, Age91_120 MONEY, AgeOver120 MONEY, TotalBalance MONEY)
	INSERT INTO #FilteredResults(	TypeGroup, TypeSort, Num, TypeCode, Type, Name, Phone, LastBilled, LastPaid,	CurrentBalance, Age31_60, Age61_90, Age91_120, AgeOver120, TotalBalance, Unapplied)
	SELECT TypeGroup,				TypeSort, Num, TypeCode, Type, Name, Phone, LastBilled, LastPaid,				CurrentBalance, Age31_60, Age61_90, Age91_120, AgeOver120, TotalBalance, Unapplied
	FROM #ReportResults
	WHERE	(@PayerTypeCode='A' OR TypeCode=@PayerTypeCode)  AND
			(@AgeRange='Current+' AND (@BalanceRange='All' AND (TotalBalance <>0 OR Unapplied <> 0)
									   OR @BalanceRange='$10+' AND TotalBalance>=10
									   OR @BalanceRange='$50+' AND TotalBalance>=50
									   OR @BalanceRange='$100+' AND TotalBalance>=100
									   OR @BalanceRange='$1000+' AND TotalBalance>=1000
									   OR @BalanceRange='$5000+' AND TotalBalance>=5000
									   OR @BalanceRange='$10000+' AND TotalBalance>=10000	
									   OR @BalanceRange='$100000+' AND TotalBalance>=100000)
			 OR @AgeRange='Age31_60' AND (@BalanceRange='All' AND (TotalBalance-CurrentBalance)<>0
								      OR @BalanceRange='$10+' AND (TotalBalance-CurrentBalance)>=10
								      OR @BalanceRange='$50+' AND (TotalBalance-CurrentBalance)>=50
								      OR @BalanceRange='$100+' AND (TotalBalance-CurrentBalance)>=100
								      OR @BalanceRange='$1000+' AND (TotalBalance-CurrentBalance)>=1000
								      OR @BalanceRange='$5000+' AND (TotalBalance-CurrentBalance)>=5000
								      OR @BalanceRange='$10000+' AND (TotalBalance-CurrentBalance)>=10000	
								      OR @BalanceRange='$100000+' AND (TotalBalance-CurrentBalance)>=100000)
			 OR @AgeRange='Age61_90' AND (@BalanceRange='All' AND (CurrentBalance+Age31_60)<>0
							              OR @BalanceRange='$10+' AND (CurrentBalance+Age31_60)>=10
								      OR @BalanceRange='$50+' AND (CurrentBalance+Age31_60)>=50
								      OR @BalanceRange='$100+' AND (CurrentBalance+Age31_60)>=100
								      OR @BalanceRange='$1000+' AND (CurrentBalance+Age31_60)>=1000
								      OR @BalanceRange='$5000+' AND (CurrentBalance+Age31_60)>=5000
								      OR @BalanceRange='$10000+' AND (CurrentBalance+Age31_60)>=10000	
								      OR @BalanceRange='$100000+' AND (CurrentBalance+Age31_60)>=100000)
			 OR @AgeRange='Age91_120' AND (@BalanceRange='All' AND (Age91_120+AgeOver120)<>0
									OR @BalanceRange='$10+' AND (Age91_120+AgeOver120)>=10
									OR @BalanceRange='$50+' AND (Age91_120+AgeOver120)>=50
									OR @BalanceRange='$100+' AND (Age91_120+AgeOver120)>=100
									OR @BalanceRange='$1000+' AND (Age91_120+AgeOver120)>=1000
									OR @BalanceRange='$5000+' AND (Age91_120+AgeOver120)>=5000
									OR @BalanceRange='$10000+' AND (Age91_120+AgeOver120)>=10000	
									OR @BalanceRange='$100000+' AND (Age91_120+AgeOver120)>=100000)
			 OR @AgeRange='AgeOver120' AND (@BalanceRange='All' AND  AgeOver120<>0
									  OR @BalanceRange='$10+' AND AgeOver120>=10
									  OR @BalanceRange='$50+' AND AgeOver120>=50
									  OR @BalanceRange='$100+' AND AgeOver120>=100
									  OR @BalanceRange='$1000+' AND AgeOver120>=1000
									  OR @BalanceRange='$5000+' AND AgeOver120>=5000
									  OR @BalanceRange='$10000+' AND AgeOver120>=10000	
									  OR @BalanceRange='$100000+' AND AgeOver120>=100000))




	IF @VelocitySort=1
	BEGIN
		SELECT * 
		FROM #FilteredResults
		ORDER BY TotalBalance DESC
	END
	ELSE
	BEGIN
		SELECT * 
		FROM #FilteredResults
		ORDER BY Name, Num
	END

	DROP TABLE #AR
	DROP TABLE #ASN
	DROP TABLE #ASNMax
	DROP TABLE #BLL
	DROP TABLE #PAYMax
	DROP TABLE #PAY
	DROP TABLE #ReportResults
	DROP TABLE #FilteredResults
	DROP TABLE #AppliedReceipts
	DROP TABLE #SummarizedUnapplied

END


GO
