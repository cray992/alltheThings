SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
IF EXISTS(	SELECT * FROM INFORMATION_SCHEMA.ROUTINES R WHERE R.ROUTINE_NAME = 'ReportDataProvider_ARAgingDetail' ) DROP PROCEDURE dbo.ReportDataProvider_ARAgingDetail
GO

--===========================================================================
-- SRS AR Aging Detail
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ARAgingDetail
	@PracticeID int = NULL,
	@AgeRange VARCHAR(20) = 'Current+', --Can be Current+, Age31_60, Age61_90, Age91_120, AgeOver120
	@BalanceRange VARCHAR(20) = 'All', --Can be All, $10+,$50+,$100+,$1000+,$5000+,$10000+,$100000
	@VelocitySort BIT = 0, --0 no sort on @AgeRange Balance otherwise sort desc on @AgeRange Balance
	@EndDate datetime = NULL,
	@RespType char(1) = 'I',
	@Responsibility BIT =0, --Can be currently assigned=0 or ultimate responsibility=1
	@RespID int = 0,
	@BatchID VARCHAR(50) = NULL

AS
/*
DECLARE
	@PracticeID int,
	@AgeRange VARCHAR(20), --Can be Current+, Age31_60, Age61_90, Age91_120, AgeOver120
	@BalanceRange VARCHAR(20), --Can be All, $10+,$50+,$100+,$1000+,$5000+,$10000+,$100000
	@VelocitySort BIT, --0 no sort on @AgeRange Balance otherwise sort desc on @AgeRange Balance
	@EndDate datetime,
	@RespType char(1),
	@Responsibility BIT, --Can be currently assigned=0 or ultimate responsibility=1
	@RespID int,
	@BatchID VARCHAR(50)
SELECT
	@PracticeID  = 65,
	@AgeRange = 'Current+', --Can be Current+, Age31_60, Age61_90, Age91_120, AgeOver120
	@BalanceRange = 'All', --Can be All, $10+,$50+,$100+,$1000+,$5000+,$10000+,$100000
	@VelocitySort = 0, --0 no sort on @AgeRange Balance otherwise sort desc on @AgeRange Balance
	@EndDate = '5/31/06',
	@RespType = 'I',
	@Responsibility =0, --Can be currently assigned=0 or ultimate responsibility=1
	@RespID = 13377,
	@BatchID = NULL
*/

BEGIN
	SET @EndDate = DATEADD(S,-1,DATEADD(D,1,dbo.fn_DateOnly( @EndDate )))


	-- Create a table of claim ids for a batch
	CREATE TABLE #BatchClaims (ClaimID INT)
	IF @BatchID IS NOT NULL
	BEGIN
		INSERT INTO #BatchClaims (ClaimID)	
		SELECT	C.ClaimID
		FROM	Encounter E
		INNER JOIN
				EncounterProcedure EP
		ON		   EP.PracticeID = @PracticeID
		AND		   EP.EncounterID = E.EncounterID
		INNER JOIN
				Claim C
		ON		   C.PracticeID = @PracticeID
		AND		   C.EncounterProcedureID = EP.EncounterProcedureID
		WHERE	E.PracticeID = @PracticeID
		AND		E.BatchID = @BatchID
	END

	--Get Last Assignments
	CREATE TABLE #ASNMax (ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #ASNMax(ClaimID, ClaimTransactionID)
	SELECT CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Assignments CAA
	WHERE PracticeID=@PracticeID AND CAA.PostingDate <=@EndDate
	AND ((@BatchID IS NULL) OR (ClaimID IN (SELECT ClaimID FROM #BatchClaims)))
	GROUP BY CAA.ClaimID
	
	CREATE TABLE #ASN (ClaimID INT, PatientID INT, InsurancePolicyID INT, PostingDate DATETIME, InsuranceCompanyPlanID INT, PlanName VARCHAR(128),
			   TypeCode CHAR(1), Type VARCHAR(128))
	
	IF @RespType='I'
	BEGIN

		INSERT INTO #ASN(ClaimID, PatientID, InsurancePolicyID, PostingDate, InsuranceCompanyPlanID, PlanName,
				 TypeCode, Type)
		SELECT CAA.ClaimID, CAA.PatientID, CAA.InsurancePolicyID, CAA.PostingDate, ICP.InsuranceCompanyPlanID, PlanName, 'I' TypeCode, 'Insurance' Type 
		FROM ClaimAccounting_Assignments CAA INNER JOIN #ASNMax AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
		INNER JOIN InsuranceCompanyPlan ICP ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
		WHERE CAA.PracticeID=@PracticeID AND CAA.PostingDate<=@EndDate AND ICP.InsuranceCompanyPlanID=@RespID
	END
	ELSE
	BEGIN
		INSERT INTO #ASN(ClaimID, PatientID, InsurancePolicyID, PostingDate, InsuranceCompanyPlanID, PlanName,
				 TypeCode, Type)
		SELECT CAA.ClaimID, CAA.PatientID, CAA.InsurancePolicyID, CAA.PostingDate, NULL, NULL, 'P' TypeCode, 'Patient' Type 
		FROM ClaimAccounting_Assignments CAA INNER JOIN #ASNMax AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
		WHERE CAA.PracticeID=@PracticeID AND CAA.PostingDate<=@EndDate AND CAA.PatientID=@RespID AND (InsurancePolicyID IS NULL OR @Responsibility=1)
	END
/*
	CREATE TABLE #AR_Trans (ClaimID INT, ARAmount MONEY)
	INSERT INTO #AR_Trans(ClaimID, ARAmount)
	SELECT CA.ClaimID, SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END )
	FROM ClaimAccounting CA INNER JOIN #ASN ASN ON CA.ClaimID=ASN.ClaimID
	WHERE PracticeID=@PracticeID AND CA.PostingDate<=@EndDate AND ClaimTransactionTypeCode<>'PAY'
	GROUP BY CA.ClaimID

	CREATE TABLE #Receipts(ClaimID INT, ARAmount MONEY)
	INSERT INTO #Receipts(ClaimID, ARAmount)
	SELECT CA.ClaimID, SUM(-1 * Amount)
	FROM ClaimAccounting CA 
		INNER JOIN #ASN ASN ON CA.ClaimID=ASN.ClaimID
		LEFT JOIN PaymentClaimTransaction PCT ON PCT.PracticeID = @PracticeID AND PCT.ClaimTransactionID = CA.ClaimTransactionID		
		LEFT JOIN Payment PMT  ON PMT.PracticeID = @PracticeID AND  PMT.PaymentID = PCT.PaymentID
	WHERE CA.PracticeID=@PracticeID AND ISNULL(PMT.PostingDate, CA.PostingDate ) <=@EndDate AND ClaimTransactionTypeCode='PAY'
	GROUP BY CA.ClaimID

	INSERT INTO #AR_Trans(ClaimID, ARAmount)
	SELECT ClaimID, ARAmount
	FROM #Receipts

	CREATE TABLE #AR(ClaimID INT, ARAmount MONEY)
	INSERT INTO #AR(ClaimID, ARAmount)
	SELECT ClaimID, SUM(ARAmount)
	FROM #AR_Trans
	GROUP BY ClaimID
	HAVING SUM(ARAmount)<>0

	CREATE TABLE #Receipts(ClaimID INT, ARAmount MONEY)
	INSERT INTO #Receipts(ClaimID, ARAmount)
	SELECT CA.ClaimID, SUM(-1 * Amount)
	FROM ClaimAccounting CA 
		INNER JOIN #ASN ASN ON CA.ClaimID=ASN.ClaimID
		LEFT JOIN PaymentClaimTransaction PCT ON PCT.PracticeID = @PracticeID AND PCT.ClaimTransactionID = CA.ClaimTransactionID		
		LEFT JOIN Payment PMT  ON PMT.PracticeID = @PracticeID AND  PMT.PaymentID = PCT.PaymentID
	WHERE CA.PracticeID=@PracticeID AND ISNULL(PMT.PostingDate, CA.PostingDate ) <=@EndDate AND ClaimTransactionTypeCode='PAY'
	GROUP BY CA.ClaimID


	CREATE TABLE #ClaimCST(ClaimID INT, Amount MONEY)
	INSERT INTO #ClaimCST(ClaimID, Amount)
	SELECT CA.ClaimID, Amount
	FROM ClaimAccounting CA INNER JOIN #AR AR ON CA.ClaimID=AR.ClaimID
	WHERE PracticeID=@PracticeID AND CA.PostingDate<=@EndDate AND ClaimTransactionTypeCode='CST'
	
	CREATE TABLE #Adjustments(ClaimID INT, Adjustments MONEY)
	INSERT INTO #Adjustments(ClaimID, Adjustments)
	SELECT CA.ClaimID, SUM(Amount)
	FROM ClaimAccounting CA INNER JOIN #AR AR ON CA.ClaimID=AR.ClaimID
	WHERE PracticeID=@PracticeID AND CA.PostingDate<=@EndDate AND ClaimTransactionTypeCode='ADJ'
	GROUP BY CA.ClaimID
 */


	CREATE TABLE #AR(ClaimID INT, ARAmount MONEY, CSTAmount MONEY, ADJAmount MONEY, PAYAmount MONEY)
	INSERT INTO #AR(ClaimID, ARAmount, CSTAmount, ADJAmount, PAYAmount)
	SELECT ca.ClaimID, 
			SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END ),
			SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE 0 END),
			SUM( CASE WHEN ClaimTransactionTypeCode = 'ADJ' THEN AMOUNT ELSE 0 END),
			SUM( CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN AMOUNT ELSE 0 END)
	FROM ClaimAccounting CA 
		INNER JOIN #ASN ASN ON CA.ClaimID=ASN.ClaimID
		LEFT JOIN PaymentClaimTransaction PCT ON PCT.PracticeID = @PracticeID AND PCT.ClaimTransactionID = CA.ClaimTransactionID		
		LEFT JOIN Payment PMT  ON PMT.PracticeID = @PracticeID AND  PMT.PaymentID = PCT.PaymentID
	WHERE CA.PracticeID=@PracticeID AND CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN PMT.PostingDate ELSE  CA.PostingDate END <=@EndDate 
	GROUP BY ca.ClaimID

		
	--Get Last Billed Info
	CREATE TABLE #BLLMax (ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #BLLMax(ClaimID, ClaimTransactionID)
	SELECT CAB.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Billings CAB INNER JOIN #ASN ASN ON CAB.ClaimID=ASN.ClaimID
	WHERE PracticeID=@PracticeID AND CAB.PostingDate<=@EndDate 
	GROUP BY CAB.ClaimID
	
	CREATE TABLE #BLL(ClaimID INT, PostingDate DATETIME)
	INSERT #BLL(ClaimID, PostingDate)
	SELECT CAB.ClaimID, CAB.PostingDate
	FROM ClaimAccounting_Billings CAB INNER JOIN #BLLMax BM ON CAB.ClaimTransactionID=BM.ClaimTransactionID
	WHERE PracticeID=@PracticeID AND CAB.PostingDate<=@EndDate




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
		AND @RespType = PMT.PayerTypeCode
		AND @RespID = PMT.PayerID
	GROUP BY PMT.PaymentID


	SELECT	PayerID, 
			PayerTypeCode,
			MAX(PostingDate) as PostingDate,
			SUM(PaymentAmount) as PaymentAmount
	INTO #SummarizedUnapplied
	FROM (
		-- figures out unapplied
		SELECT	PayerID, 
				PayerTypeCode, 
				MAX(P.PostingDate) AS PostingDate, 
				SUM(ISNULL(PaymentAmount, 0) - ISNULL(a.AppliedAmount, 0) ) PaymentAmount
		FROM  Payment P
				LEFT OUTER JOIN #AppliedReceipts AS a ON a.PaymentID = p.PaymentID
		WHERE P.PracticeID=@PracticeID
			AND  p.PostingDate <= @EndDate
			AND @RespType = p.PayerTypeCode
			AND @RespID = p.PayerID
		GROUP BY p.PayerID,  
				p.PayerTypeCode
		HAVING 0 <> SUM(ISNULL(PaymentAmount, 0) - ISNULL(a.AppliedAmount, 0) )

		UNION ALL

		-- gets refund
		select p.PayerID, p.PayerTypeCode, MAX(r.PostingDate), sum(-1 * rtp.amount)
		from refund r 
			INNER jOIn refundToPayments rtp on r.RefundID = rtp.RefundID
			INNER JOIN Payment p on  p.practiceID = r.practiceID AND p.PaymentID = rtp.PaymentID
		WHERE r.PracticeID = @PracticeID AND r.PostingDate <= @EndDate 
		group by p.PayerID, payerTypeCode
/*
		UNION ALL

		-- Gets Capitated
		select p.PayerID, PayerTypeCode, Max( p.PostingDate), sum(-1*c.Amount)
		from capitatedAccountToPayment c 
			INNER JOIN Payment p on c.PaymentID = p.PaymentID
		WHERE p.PracticeID = @PracticeID AND 
			c.PostingDate <= @EndDate
			AND (@BatchID is Null or RTRIM(p.BatchID) = RTRIM(@BatchID))
		group by p.PayerID, payerTypeCode
*/

	) as V
		WHERE @RespType = PayerTypeCode
			AND @RespID = PayerID
	GROUP BY PayerID, PayerTypeCode

	
	CREATE TABLE #ReportResults(RespID INT, TypeCode CHAR(1), RespType VARCHAR(9), RespName VARCHAR(128), 
				    ClaimID INT, ServiceDate DATETIME, ProcedureCode VARCHAR(48), PatientID INT, PatientFullName VARCHAR(128), 
				    AdjustedCharges MONEY, Receipts MONEY, BilledDate DATETIME, Aging INT, AgeGroup INT, OpenBalance MONEY)
	INSERT INTO #ReportResults(RespID, TypeCode, RespType, RespName, ClaimID, ServiceDate, ProcedureCode, AdjustedCharges, Receipts,
				   PatientID, PatientFullName, BilledDate, Aging, AgeGroup, OpenBalance)
	SELECT CASE WHEN @Responsibility=1 THEN ASN.PatientID ELSE ISNULL(ASN.InsuranceCompanyPlanID,ASN.PatientID) END RespID, TypeCode, Type RespType, 
	ISNULL(PlanName,RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, ''))) RespName, 
	AR.ClaimID, ISNULL(EP.ProcedureDateOfService, E.DateOfService) ServiceDate, ProcedureCode, 0 AdjustedCharges, 0 Receipts,
	ASN.PatientID, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) PatientFullName,
	BLL.PostingDate BilledDate, ISNULL( DATEDIFF(D, BLL.PostingDate, @EndDate), 0) Aging, 
	CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 0 AND 30  OR BLL.PostingDate IS NULL THEN 1
	     WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 31 AND 60 THEN 2
	     WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 61 AND 90 THEN 3
	     WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 91 AND 120 THEN 4
	     WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) > 120 THEN 5 END AgeGroup,
	ARAmount OpenBalance
	FROM #AR AR 
	LEFT JOIN #ASN ASN ON AR.ClaimID=ASN.ClaimID
	LEFT JOIN #BLL BLL ON AR.ClaimID=BLL.ClaimID
	LEFT JOIN Patient P ON P.PracticeID = @PracticeID AND ASN.PatientID=P.PatientID
	LEFT JOIN Claim C ON c.PracticeID = @PracticeID AND AR.ClaimID=C.ClaimID
	LEFT JOIN EncounterProcedure EP ON ep.PracticeID = @PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
	LEFT JOIN Encounter E ON E.PracticeID = @PracticeID AND EP.EncounterID=E.EncounterID
	LEFT JOIN ProcedureCodeDictionary PCD ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID

	
	UPDATE RR SET AdjustedCharges=CSTAmount
	FROM #ReportResults RR INNER JOIN #AR CC ON RR.ClaimID=CC.ClaimID
	
	UPDATE RR SET AdjustedCharges=AdjustedCharges-ISNULL(ADJAmount,0)
	FROM #ReportResults RR INNER JOIN #AR CA ON RR.ClaimID=CA.ClaimID

	UPDATE RR SET Receipts=ISNULL(PAYAmount,0)
	FROM #ReportResults RR INNER JOIN #AR R ON RR.ClaimID=R.ClaimID

	INSERT INTO #ReportResults (RespID, TypeCode, RespType,RespName,PatientID,PatientFullName,Receipts,BilledDate,Aging,AgeGroup,OpenBalance)
	select 
		RespID = PayerID, 
		TypeCode = su.PayerTypeCode, 
		RespType = ptc.Description,
		RespName= ISNULL(icp.PlanName,RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, ''))),
		PatientID,
		PatientFullName = RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')),
		Receipts = su.PaymentAmount,
		BilledDate = su.PostingDate,
		Aging = 0,
		AgeGroup = 10,
		OpenBalance = -1*su.PaymentAmount
	from #SummarizedUnapplied su 
		LEFT JOIN Patient P ON su.PayerID =P.PatientID AND su.PayerTypeCode = 'P'
		LEFT JOIN InsuranceCompanyPlan icp on su.PayerID = icp.InsuranceCompanyPlanID AND su.PayerTypeCode = 'I'
		LEFT JOIN PayerTypeCode ptc on ptc.PayerTypeCode = su.PayerTypeCode
	WHERE su.PaymentAmount <> 0

	CREATE TABLE #FilteredResults(RowID INT IDENTITY(1,1), RespID INT, TypeCode CHAR(1), RespType VARCHAR(9), RespName VARCHAR(128), 
				    ClaimID INT, ServiceDate DATETIME, ProcedureCode VARCHAR(48), PatientID INT, PatientFullName VARCHAR(128), 
				    AdjustedCharges MONEY, Receipts MONEY, BilledDate DATETIME, Aging INT, AgeGroup INT, OpenBalance MONEY)

	IF @VelocitySort=1
	BEGIN
			INSERT INTO #FilteredResults(RespID, TypeCode, RespType, RespName, ClaimID, ServiceDate, ProcedureCode, AdjustedCharges, Receipts,
				                     PatientID, PatientFullName, BilledDate, Aging, AgeGroup, OpenBalance)
			SELECT RespID, TypeCode, RespType, RespName, ClaimID, ServiceDate, ProcedureCode, AdjustedCharges, Receipts,
		        PatientID, PatientFullName, BilledDate, Aging, AgeGroup, OpenBalance
			FROM #ReportResults
			WHERE TypeCode=@RespType AND RespID=@RespID 
					AND (@AgeRange='Current+' 
					AND AgeGroup>=1 
					AND ( (@BalanceRange='All' AND OpenBalance <> 0)
								OR @BalanceRange='$10+' AND OpenBalance>=10
								OR @BalanceRange='$50+' AND OpenBalance>=50
								OR @BalanceRange='$100+' AND OpenBalance>=100
								OR @BalanceRange='$200+' AND OpenBalance>=200
								OR @BalanceRange='$300+' AND OpenBalance>=300
								OR @BalanceRange='$400+' AND OpenBalance>=400
								OR @BalanceRange='$500+' AND OpenBalance>=500
								OR @BalanceRange='$600+' AND OpenBalance>=600
								OR @BalanceRange='$700+' AND OpenBalance>=700
								OR @BalanceRange='$800+' AND OpenBalance>=800
								OR @BalanceRange='$900+' AND OpenBalance>=900
								OR @BalanceRange='$1000+' AND OpenBalance>=1000
								OR @BalanceRange='$5000+' AND OpenBalance>=5000
								OR @BalanceRange='$10000+' AND OpenBalance>=10000	
								OR @BalanceRange='$100000+' AND OpenBalance>=100000)
					 OR @AgeRange='Age31_60' AND AgeGroup>=2  AND ( (@BalanceRange='All' AND OpenBalance <> 0)
								OR @BalanceRange='$10+' AND OpenBalance>=10
								OR @BalanceRange='$50+' AND OpenBalance>=50
								OR @BalanceRange='$100+' AND OpenBalance>=100
								OR @BalanceRange='$200+' AND OpenBalance>=200
								OR @BalanceRange='$300+' AND OpenBalance>=300
								OR @BalanceRange='$400+' AND OpenBalance>=400
								OR @BalanceRange='$500+' AND OpenBalance>=500
								OR @BalanceRange='$600+' AND OpenBalance>=600
								OR @BalanceRange='$700+' AND OpenBalance>=700
								OR @BalanceRange='$800+' AND OpenBalance>=800
								OR @BalanceRange='$900+' AND OpenBalance>=900
								OR @BalanceRange='$1000+' AND OpenBalance>=1000
								OR @BalanceRange='$5000+' AND OpenBalance>=5000
								OR @BalanceRange='$10000+' AND OpenBalance>=10000	
								OR @BalanceRange='$100000+' AND OpenBalance>=100000)
					 OR @AgeRange='Age61_90' AND AgeGroup>=3  AND ((@BalanceRange='All' AND OpenBalance <> 0)
								OR @BalanceRange='$10+' AND OpenBalance>=10
								OR @BalanceRange='$50+' AND OpenBalance>=50
								OR @BalanceRange='$100+' AND OpenBalance>=100
								OR @BalanceRange='$200+' AND OpenBalance>=200
								OR @BalanceRange='$300+' AND OpenBalance>=300
								OR @BalanceRange='$400+' AND OpenBalance>=400
								OR @BalanceRange='$500+' AND OpenBalance>=500
								OR @BalanceRange='$600+' AND OpenBalance>=600
								OR @BalanceRange='$700+' AND OpenBalance>=700
								OR @BalanceRange='$800+' AND OpenBalance>=800
								OR @BalanceRange='$900+' AND OpenBalance>=900
								OR @BalanceRange='$1000+' AND OpenBalance>=1000
								OR @BalanceRange='$5000+' AND OpenBalance>=5000
								OR @BalanceRange='$10000+' AND OpenBalance>=10000	
								OR @BalanceRange='$100000+' AND OpenBalance>=100000)
					 OR @AgeRange='Age91_120' AND AgeGroup>=4  AND ((@BalanceRange='All' AND OpenBalance <> 0)
								OR @BalanceRange='$10+' AND OpenBalance>=10
								OR @BalanceRange='$50+' AND OpenBalance>=50
								OR @BalanceRange='$100+' AND OpenBalance>=100
								OR @BalanceRange='$200+' AND OpenBalance>=200
								OR @BalanceRange='$300+' AND OpenBalance>=300
								OR @BalanceRange='$400+' AND OpenBalance>=400
								OR @BalanceRange='$500+' AND OpenBalance>=500
								OR @BalanceRange='$600+' AND OpenBalance>=600
								OR @BalanceRange='$700+' AND OpenBalance>=700
								OR @BalanceRange='$800+' AND OpenBalance>=800
								OR @BalanceRange='$900+' AND OpenBalance>=900
								OR @BalanceRange='$1000+' AND OpenBalance>=1000
								OR @BalanceRange='$5000+' AND OpenBalance>=5000
								OR @BalanceRange='$10000+' AND OpenBalance>=10000	
								OR @BalanceRange='$100000+' AND OpenBalance>=100000)
					 OR @AgeRange='AgeOver120' AND AgeGroup=5  AND ((@BalanceRange='All' AND OpenBalance <> 0)
								OR @BalanceRange='$10+' AND OpenBalance>=10
								OR @BalanceRange='$50+' AND OpenBalance>=50
								OR @BalanceRange='$100+' AND OpenBalance>=100
								OR @BalanceRange='$200+' AND OpenBalance>=200
								OR @BalanceRange='$300+' AND OpenBalance>=300
								OR @BalanceRange='$400+' AND OpenBalance>=400
								OR @BalanceRange='$500+' AND OpenBalance>=500
								OR @BalanceRange='$600+' AND OpenBalance>=600
								OR @BalanceRange='$700+' AND OpenBalance>=700
								OR @BalanceRange='$800+' AND OpenBalance>=800
								OR @BalanceRange='$900+' AND OpenBalance>=900
								OR @BalanceRange='$1000+' AND OpenBalance>=1000
								OR @BalanceRange='$5000+' AND OpenBalance>=5000
								OR @BalanceRange='$10000+' AND OpenBalance>=10000	
								OR @BalanceRange='$100000+' AND OpenBalance>=100000))
			ORDER BY AgeGroup, OpenBalance DESC
	END
	ELSE
	BEGIN
			INSERT INTO #FilteredResults(RespID, TypeCode, RespType, RespName, ClaimID, ServiceDate, ProcedureCode, AdjustedCharges, Receipts,
				                     PatientID, PatientFullName, BilledDate, Aging, AgeGroup, OpenBalance)
			SELECT RespID, TypeCode, RespType, RespName, ClaimID, ServiceDate, ProcedureCode, AdjustedCharges, Receipts,
		        PatientID, PatientFullName, BilledDate, Aging, AgeGroup, OpenBalance
			FROM #ReportResults
			WHERE TypeCode=@RespType AND RespID=@RespID AND
					(@AgeRange='Current+' AND AgeGroup>=1 AND ((@BalanceRange='All' AND OpenBalance <> 0)
								OR @BalanceRange='$10+' AND OpenBalance>=10
								OR @BalanceRange='$50+' AND OpenBalance>=50
								OR @BalanceRange='$100+' AND OpenBalance>=100
								OR @BalanceRange='$200+' AND OpenBalance>=200
								OR @BalanceRange='$300+' AND OpenBalance>=300
								OR @BalanceRange='$400+' AND OpenBalance>=400
								OR @BalanceRange='$500+' AND OpenBalance>=500
								OR @BalanceRange='$600+' AND OpenBalance>=600
								OR @BalanceRange='$700+' AND OpenBalance>=700
								OR @BalanceRange='$800+' AND OpenBalance>=800
								OR @BalanceRange='$900+' AND OpenBalance>=900
								OR @BalanceRange='$1000+' AND OpenBalance>=1000
								OR @BalanceRange='$5000+' AND OpenBalance>=5000
								OR @BalanceRange='$10000+' AND OpenBalance>=10000	
								OR @BalanceRange='$100000+' AND OpenBalance>=100000)
					 OR @AgeRange='Age31_60' AND AgeGroup>=2  AND ((@BalanceRange='All' AND OpenBalance <> 0)
								OR @BalanceRange='$10+' AND OpenBalance>=10
								OR @BalanceRange='$50+' AND OpenBalance>=50
								OR @BalanceRange='$100+' AND OpenBalance>=100
								OR @BalanceRange='$200+' AND OpenBalance>=200
								OR @BalanceRange='$300+' AND OpenBalance>=300
								OR @BalanceRange='$400+' AND OpenBalance>=400
								OR @BalanceRange='$500+' AND OpenBalance>=500
								OR @BalanceRange='$600+' AND OpenBalance>=600
								OR @BalanceRange='$700+' AND OpenBalance>=700
								OR @BalanceRange='$800+' AND OpenBalance>=800
								OR @BalanceRange='$900+' AND OpenBalance>=900
								OR @BalanceRange='$1000+' AND OpenBalance>=1000
								OR @BalanceRange='$5000+' AND OpenBalance>=5000
								OR @BalanceRange='$10000+' AND OpenBalance>=10000	
								OR @BalanceRange='$100000+' AND OpenBalance>=100000)
					 OR @AgeRange='Age61_90' AND AgeGroup>=3  AND ((@BalanceRange='All' AND OpenBalance <> 0)
								OR @BalanceRange='$10+' AND OpenBalance>=10
								OR @BalanceRange='$50+' AND OpenBalance>=50
								OR @BalanceRange='$100+' AND OpenBalance>=100
								OR @BalanceRange='$200+' AND OpenBalance>=200
								OR @BalanceRange='$300+' AND OpenBalance>=300
								OR @BalanceRange='$400+' AND OpenBalance>=400
								OR @BalanceRange='$500+' AND OpenBalance>=500
								OR @BalanceRange='$600+' AND OpenBalance>=600
								OR @BalanceRange='$700+' AND OpenBalance>=700
								OR @BalanceRange='$800+' AND OpenBalance>=800
								OR @BalanceRange='$900+' AND OpenBalance>=900
								OR @BalanceRange='$1000+' AND OpenBalance>=1000
								OR @BalanceRange='$5000+' AND OpenBalance>=5000
								OR @BalanceRange='$10000+' AND OpenBalance>=10000	
								OR @BalanceRange='$100000+' AND OpenBalance>=100000)
					 OR @AgeRange='Age91_120' AND AgeGroup>=4  AND ((@BalanceRange='All' AND OpenBalance <> 0)
								OR @BalanceRange='$10+' AND OpenBalance>=10
								OR @BalanceRange='$50+' AND OpenBalance>=50
								OR @BalanceRange='$100+' AND OpenBalance>=100
								OR @BalanceRange='$200+' AND OpenBalance>=200
								OR @BalanceRange='$300+' AND OpenBalance>=300
								OR @BalanceRange='$400+' AND OpenBalance>=400
								OR @BalanceRange='$500+' AND OpenBalance>=500
								OR @BalanceRange='$600+' AND OpenBalance>=600
								OR @BalanceRange='$700+' AND OpenBalance>=700
								OR @BalanceRange='$800+' AND OpenBalance>=800
								OR @BalanceRange='$900+' AND OpenBalance>=900
								OR @BalanceRange='$1000+' AND OpenBalance>=1000
								OR @BalanceRange='$5000+' AND OpenBalance>=5000
								OR @BalanceRange='$10000+' AND OpenBalance>=10000	
								OR @BalanceRange='$100000+' AND OpenBalance>=100000)
					 OR @AgeRange='AgeOver120' AND AgeGroup=5  AND ((@BalanceRange='All' AND OpenBalance <> 0)
								OR @BalanceRange='$10+' AND OpenBalance>=10
								OR @BalanceRange='$50+' AND OpenBalance>=50
								OR @BalanceRange='$100+' AND OpenBalance>=100
								OR @BalanceRange='$200+' AND OpenBalance>=200
								OR @BalanceRange='$300+' AND OpenBalance>=300
								OR @BalanceRange='$400+' AND OpenBalance>=400
								OR @BalanceRange='$500+' AND OpenBalance>=500
								OR @BalanceRange='$600+' AND OpenBalance>=600
								OR @BalanceRange='$700+' AND OpenBalance>=700
								OR @BalanceRange='$800+' AND OpenBalance>=800
								OR @BalanceRange='$900+' AND OpenBalance>=900
								OR @BalanceRange='$1000+' AND OpenBalance>=1000
								OR @BalanceRange='$5000+' AND OpenBalance>=5000
								OR @BalanceRange='$10000+' AND OpenBalance>=10000	
								OR @BalanceRange='$100000+' AND OpenBalance>=100000))

			ORDER BY AgeGroup Desc, PatientFullName, ServiceDate Desc
	END

	SELECT * 
	FROM #FilteredResults

	DROP TABLE #AR
	DROP TABLE #ASN
	DROP TABLE #ASNMax
	DROP TABLE #BLL
	DROP TABLE #BLLMax
	DROP TABLE #ReportResults
	DROP TABLE #FilteredResults
	DROP TABLE #BatchClaims
	DROP TABLE #AppliedReceipts
	DROP TABLE #SummarizedUnapplied

END
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

