SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
-- Test: ReportDataProvider_ARAgingSummary @PracticeID=65, @EndDate = '7/31/06'
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ARAgingSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[ReportDataProvider_ARAgingSummary]
GO

CREATE PROCEDURE dbo.ReportDataProvider_ARAgingSummary
	@PracticeID int = NULL,
	@DateType Char(1) = 'B',	-- B="Last Billed Date", P="Post Date", S="Service Date", 
	@EndDate datetime = NULL,
	@ProviderID int = -1,
	@BatchID VARCHAR(50) = NULL,
	@ServiceLocationID INT = -1,
	@DepartmentID INT = -1,
	@PayerScenarioID INT = -1,
	@ReportType INT = 1,			-- Report Type that ties to the KI Report Case 11541 
	@ContractID INT = -1
AS
/*
DECLARE
	@PracticeID int,
	@EndDate datetime,
	@ProviderID int,
	@BatchID VARCHAR(50),
	@ServiceLocationID INT,
	@DepartmentID INT,
	@PayerScenarioID INT,
	@DateType Char(1),
	@ReportType INT,
	@ContractID INT
SELECT
	@PracticeID  = 65,
	@EndDate  = '7/1/06',
	@ProviderID  = -1,
	@BatchID  = NULL,
	@ServiceLocationID = -1,
	@DepartmentID = -1,
	@PayerScenarioID = -1,
	@DateType = 'P',
	@ReportType = 1,
	@ContractID = -1
*/

	SET NOCOUNT ON
	DECLARE @ReportCutOff Datetime

	SELECT @ReportCutOff = dateadd( d, 1+(-1 * datepart(day, EndPostingDate)),  EndPostingDate )
	FROM ReportDailyActivitiesDate rda
	WHERE rda.ViewName = 'ReportClaimAccounting'


	-- Since the Indexed Views are summarized for the whole month, 
	-- if the EndDate falls within the middle of the summarized month, 
	-- then have to move the ReportCutOff t the closest full month
	IF @ReportCutOff > @EndDate			
		IF month( dateAdd(day, 1, @EndDate) ) <> month( dateAdd(day, 1, @EndDate) ) -- Figures out if the EndDate is the last day of the month
			SET @ReportCutOff = month( dateAdd(day, 1, dbo.fn_DateOnly( @EndDate ) ) )
		ELSE
			SET @ReportCutOff = dateadd( d, 1+(-1 * datepart(day, @EndDate)),  @EndDate )

	SET @EndDate = DATEADD(S,-1,DATEADD(D,1,dbo.fn_DateOnly( @EndDate )))





	CREATE TABLE #AR (PaymentID INT, ClaimID INT, ARAmount MONEY, PostingDate Datetime, ServiceDate Datetime, ServicePostingDate Datetime)


	-- 1 = Use Posting Date of "PAY" from Payment Table, All other will come from Claims
	-- 2 = Same as 2, but fix error condition where Payment.PostingDate > ClaimTransaction.PostingDate
	-- 3 = Using Posting Date for all from Service Line
	IF @ReportType = 1 OR @ReportType IS NULL
		BEGIN


			INSERT INTO #AR(ClaimID, ARAmount, PostingDate, ServiceDate, ServicePostingDate)
			SELECT	ca.ClaimID, 
					SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END ),
					ca.PostingDate,
					ep.ProcedureDateOfService,
					e.PostingDate
			FROM ClaimAccounting  ca
				INNER JOIN Claim c ON c.PracticeID = @PracticeID AND c.ClaimID = ca.ClaimID
				INNER JOIN EncounterProcedure ep ON ep.PracticeID = @PracticeID AND c.EncounterProcedureID = ep.EncounterProcedureID
				INNER JOIN Encounter e ON e.PracticeID = @PracticeID AND e.EncounterID = ep.EncounterID				
				INNER JOIN Doctor d ON d.PracticeID = @PracticeID AND d.DoctorID = e.DoctorID
				LEFT JOIN PatientCase pc ON pc.PracticeID = @PracticeID AND pc.PatientCaseID = e.PatientCaseID
			WHERE ca.PracticeID=@PracticeID 
				AND ca.PostingDate between @ReportCutOff AND @EndDate
				AND CA.ClaimTransactionTypeCode <> 'PAY'
				AND (@ProviderID = -1 OR ProviderID = @ProviderID)
				AND (@BatchID IS NULL OR RTRIM(e.BatchID) = RTRIM(@BatchID))
				AND (@PayerScenarioID = -1 OR PC.PayerScenarioID = @PayerScenarioID)
				AND (@ServiceLocationID = -1 OR e.LocationID = @ServiceLocationID )
				AND (@DepartmentID = -1 OR d.DepartmentID = @DepartmentID )
			GROUP BY 
					ca.ClaimID, 
					ca.PostingDate, 
					ep.ProcedureDateOfService,
					e.PostingDate
			HAVING 0 <> SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END )


			union ALL

			SELECT ca.ClaimID, 
					SUM(Charges - Adjustments),
					PostingDate,
					ProcedureDateOfService,
					EncounterPostingDate
			FROM ReportClaimAccounting  ca  with( noexpand )
				LEFT JOIN PatientCase pc ON pc.PracticeID = @PracticeID AND pc.PatientCaseID = ca.PatientCaseID
			WHERE ca.PracticeID = @PracticeID AND ca.PostingDate < @ReportCutOff
				AND (@ProviderID = -1 OR ProviderID = @ProviderID)
				AND (@BatchID IS NULL OR RTRIM(BatchID) = RTRIM(@BatchID))
				AND (@PayerScenarioID = -1 OR PC.PayerScenarioID = @PayerScenarioID)
				AND (@ServiceLocationID = -1 OR LocationID = @ServiceLocationID )
				AND (@DepartmentID = -1 OR  DepartmentID = @DepartmentID )
			GROUP BY 
					ca.ClaimID, 
					PostingDate,
					ProcedureDateOfService,
					EncounterPostingDate
			HAVING 0 <> SUM(Charges - Adjustments)

		END
	ELSE IF @ReportType = 2
			BEGIN
				INSERT INTO #AR(PaymentID, ClaimID, ARAmount, PostingDate, ServiceDate, ServicePostingDate)
				SELECT	
						CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN PMT.PaymentID ELSE NULL END,
						ca.ClaimID, 
						SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END ),
						CASE WHEN pmt.PostingDate > ca.PostingDate THEN pmt.PostingDate ELSE ca.PostingDate END,
						ep.ProcedureDateOfService,
						e.PostingDate
				FROM ClaimAccounting  ca
					LEFT JOIN PaymentClaimTransaction PCT ON PCT.PracticeID = @PracticeID AND PCT.ClaimID = ca.ClaimID AND PCT.ClaimTransactionID = CA.ClaimTransactionID
					LEFT JOIN Payment PMT  ON PMT.PracticeID = @PracticeID AND  PMT.PaymentID = PCT.PaymentID
					LEFT JOIN Claim c ON c.PracticeID = @PracticeID AND c.ClaimID = ca.ClaimID
					LEFT JOIN EncounterProcedure ep ON ep.PracticeID = @PracticeID AND c.EncounterProcedureID = ep.EncounterProcedureID
					LEFT JOIN Encounter e ON e.PracticeID = @PracticeID AND e.EncounterID = ep.EncounterID
					LEFT JOIN PatientCase pc ON pc.PracticeID = @PracticeID AND pc.PatientCaseID = e.PatientCaseID
					LEFT JOIN Doctor d ON d.PracticeID = @PracticeID AND d.DoctorID = e.DoctorID
				WHERE ca.PracticeID=@PracticeID 
					AND CASE WHEN pmt.PostingDate > ca.PostingDate THEN pmt.PostingDate ELSE ca.PostingDate END <=@EndDate
					AND (@ProviderID = -1 OR ProviderID = @ProviderID)
					AND (@BatchID IS NULL OR RTRIM(e.BatchID) = RTRIM(@BatchID))
					AND (@PayerScenarioID = -1 OR PC.PayerScenarioID = @PayerScenarioID)
					AND (@ServiceLocationID = -1 OR e.LocationID = @ServiceLocationID )
					AND (@DepartmentID = -1 OR d.DepartmentID = @DepartmentID )
				GROUP BY CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN PMT.PaymentID ELSE NULL END, 
					ca.ClaimID, 
					CASE WHEN pmt.PostingDate > ca.PostingDate THEN pmt.PostingDate ELSE ca.PostingDate END, 
					ep.ProcedureDateOfService,
					e.PostingDate
				HAVING 0 <> SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END )


			END
		ELSE 
		BEGIN
print '3'
			INSERT INTO #AR(PaymentID, ClaimID, ARAmount, PostingDate, ServiceDate, ServicePostingDate)
			SELECT	
					CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN PMT.PaymentID ELSE NULL END,
					ca.ClaimID, 
					SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END ),
					ca.PostingDate,
					ep.ProcedureDateOfService,
					e.PostingDate
			FROM ClaimAccounting  ca
				LEFT JOIN PaymentClaimTransaction PCT ON PCT.PracticeID = @PracticeID AND PCT.ClaimID = ca.ClaimID AND PCT.ClaimTransactionID = CA.ClaimTransactionID
				LEFT JOIN Payment PMT  ON PMT.PracticeID = @PracticeID AND  PMT.PaymentID = PCT.PaymentID
				LEFT JOIN Claim c ON c.PracticeID = @PracticeID AND c.ClaimID = ca.ClaimID
				LEFT JOIN EncounterProcedure ep ON ep.PracticeID = @PracticeID AND c.EncounterProcedureID = ep.EncounterProcedureID
				LEFT JOIN Encounter e ON e.PracticeID = @PracticeID AND e.EncounterID = ep.EncounterID
				LEFT JOIN PatientCase pc ON pc.PracticeID = @PracticeID AND pc.PatientCaseID = e.PatientCaseID
				LEFT JOIN Doctor d ON d.PracticeID = @PracticeID AND d.DoctorID = e.DoctorID
			WHERE ca.PracticeID=@PracticeID 
				AND ca.PostingDate <= @EndDate
				AND (@ProviderID = -1 OR ProviderID = @ProviderID)
				AND (@BatchID IS NULL OR RTRIM(e.BatchID) = RTRIM(@BatchID))
				AND (@PayerScenarioID = -1 OR PC.PayerScenarioID = @PayerScenarioID)
				AND (@ServiceLocationID = -1 OR e.LocationID = @ServiceLocationID )
				AND (@DepartmentID = -1 OR d.DepartmentID = @DepartmentID )
			GROUP BY CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN PMT.PaymentID ELSE NULL END, 
				ca.ClaimID, 
				ca.PostingDate, 
				ep.ProcedureDateOfService,
				e.PostingDate
			HAVING 0 <> SUM( CASE WHEN ClaimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END )

		END


		-----------------  Calc Receipt amounts -----------
		SELECT	p.PaymentID, 
				ca.ClaimID,
				SUM( -1 * Amount ) AppliedAmount,
				P.PostingDate,
			e.PostingDate as EncounterPostingDate,
			ProcedureDateOfService
		INTO #AppliedReceiptsDetail
		FROM Payment p
				INNER JOIN PaymentClaimTransaction pct on pct.PracticeID = p.PracticeID AND pct.PaymentID = p.PaymentID
				INNER JOIN ClaimAccounting ca on ca.PracticeID = pct.PracticeID AND pct.ClaimTransactionID = ca.ClaimTransactionID
						INNER JOIN Claim c ON c.PracticeID = @PracticeID AND c.ClaimID = ca.ClaimID
						INNER JOIN EncounterProcedure ep ON ep.PracticeID = @PracticeID AND c.EncounterProcedureID = ep.EncounterProcedureID
						INNER JOIN Encounter e ON e.PracticeID = @PracticeID AND e.EncounterID = ep.EncounterID
						INNER JOIN Doctor d ON d.PracticeID = @PracticeID AND d.DoctorID = e.DoctorID
						LEFT JOIN PatientCase pc ON pc.PracticeID = @PracticeID AND pc.PatientCaseID = e.PatientCaseID
		WHERE p.PracticeID = @PracticeID 
				AND ca.ClaimTransactionTypeCode = 'PAY'
				AND P.PostingDate between @ReportCutOff AND @EndDate
				AND (@ProviderID = -1 OR ProviderID = @ProviderID)
				AND (@BatchID IS NULL OR RTRIM(p.BatchID) = RTRIM(@BatchID))
				AND (@PayerScenarioID = -1 OR PC.PayerScenarioID = @PayerScenarioID)
				AND (@ServiceLocationID = -1 OR LocationID = @ServiceLocationID )
				AND (@DepartmentID = -1 OR  DepartmentID = @DepartmentID )
				AND Amount <> 0
		GROUP BY p.PaymentID,
				ca.ClaimID,
				P.PostingDate, 
				e.PostingDate,
				ProcedureDateOfService
	

		UNION ALL 

		select p.PaymentID, rap.ClaimID, 
				sum(Receipts), rap.AppliedPostingDate,
				EcounterPostingDate,
				ProcedureDateOfService
				
		from  Payment p 
			INNER JOIN ReportAppliedPayment rap with( noexpand ) on p.PracticeID = rap.PracticeID AND rap.PaymentID = p.PaymentID
			LEFT JOIN PatientCase pc ON pc.PracticeID = @PracticeID AND pc.PatientCaseID = rap.PatientCaseID
		WHERE p.PracticeID = @PracticeID AND p.PostingDate < @ReportCutOff
				AND (@ProviderID = -1 OR ProviderID = @ProviderID)
				AND (@BatchID IS NULL OR RTRIM(PaymentBatchID) = RTRIM(@BatchID))
				AND (@PayerScenarioID = -1 OR PC.PayerScenarioID = @PayerScenarioID)
				AND (@ServiceLocationID = -1 OR LocationID = @ServiceLocationID )
				AND (@DepartmentID = -1 OR  DepartmentID = @DepartmentID )
		GROUP BY  p.PaymentID, rap.ClaimID, rap.AppliedPostingDate,
			EcounterPostingDate,
			ProcedureDateOfService
		HAVING 0 <> sum(Receipts)





		insert INTO #AR( ClaimID, ARAmount, PostingDate, ServiceDate, ServicePostingDate)
		SELECT ClaimID, AppliedAmount, PostingDate, ProcedureDateOfService, EncounterPostingDate
		FROM #AppliedReceiptsDetail


	select PaymentID, sum(AppliedAmount) as AppliedAmount
	INTO #AppliedReceipts
	FROM #AppliedReceiptsDetail
	GROUP BY PaymentID


	SELECT PayerTypeCode, SUM(PaymentAmount) AS PaymentAmount
	INTO #SummarizedUnapplied
	FROM	(
					SELECT PayerTypeCode, 
							PayerID,
							PaymentAmount = SUM(  ISNULL(PaymentAmount, 0) + ISNULL(a.AppliedAmount, 0) )
					FROM  Payment P
							LEFT OUTER JOIN #AppliedReceipts AS a ON a.PaymentID = p.PaymentID
					WHERE P.PracticeID=@PracticeID 
						AND p.PostingDate <= @EndDate
						AND (@BatchID is Null or RTRIM(p.BatchID) = RTRIM(@BatchID))
					GROUP BY  p.PayerTypeCode, p.PayerID
	--				HAVING 0 <> SUM(ISNULL(PaymentAmount, 0) + ISNULL(a.AppliedAmount, 0) )

					UNION ALL

					select p.PayerTypeCode, p.PayerID, sum(-1 * rtp.amount)
					from refund r 
						INNER jOIn refundToPayments rtp on r.RefundID = rtp.RefundID
						INNER JOIN Payment p on  p.practiceID = r.practiceID AND p.PaymentID = rtp.PaymentID
					WHERE r.PracticeID = @PracticeID AND 
						r.PostingDate <= @EndDate
						AND (@BatchID is Null or RTRIM(p.BatchID) = RTRIM(@BatchID))
					group by payerTypeCode, p.PayerID	
				) AS V
	WHERE 		@ProviderID  = -1 AND
				@ServiceLocationID = -1 AND
				@DepartmentID = -1 AND
				@PayerScenarioID = -1 AND
				(@ContractID = -1 OR PayerID IN (SELECT cp.PlanID FROM ContractToInsurancePlan cp INNER JOIN contract c ON  c.PracticeID = @PracticeID AND c.ContractID = cp.ContractID ))
	GROUP BY PayerTypeCode


	--Get Last Assignments
	CREATE TABLE #ASNMax (ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #ASNMax(ClaimID, ClaimTransactionID)
	SELECT CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Assignments CAA INNER JOIN #AR AR ON CAA.ClaimID=AR.ClaimID
	WHERE PracticeID=@PracticeID AND caa.PostingDate<=@EndDate
	GROUP BY CAA.ClaimID
	
	CREATE TABLE #ASN (ClaimID INT, PostingDate DATETIME, TypeGroup VARCHAR(128), TypeSort INT)
	INSERT INTO #ASN(ClaimID, TypeGroup, TypeSort)
	SELECT CAA.ClaimID, 
	CASE WHEN InsurancePolicyID IS NULL THEN 'Patient' ELSE 'Insurance' END TypeGroup, 
	CASE WHEN InsurancePolicyID IS NULL THEN 2 ELSE 1 END TypeSort
	FROM ClaimAccounting_Assignments CAA 
		INNER JOIN #ASNMax AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
		LEFT JOIN InsuranceCompanyPlan ICP ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
		LEFT JOIN ContractToInsurancePlan cp ON cp.PlanID = caa.InsuranceCompanyPlanID
		LEFT JOIN contract c ON  c.PracticeID = @PracticeID AND c.ContractID = cp.ContractID
	WHERE CAA.PracticeID=@PracticeID AND CAA.PostingDate<=@EndDate
		AND (@ContractID = -1 OR C.ContractID = @ContractID)
	GROUP BY CAA.ClaimID, 
		CASE WHEN InsurancePolicyID IS NULL THEN 'Patient' ELSE 'Insurance' END, 
		CASE WHEN InsurancePolicyID IS NULL THEN 2 ELSE 1 END

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
			SELECT ClaimID, Max(ServicePostingDate)
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
	


	CREATE TABLE #ReportResults(TypeGroup VARCHAR(128), TypeSort INT, Unapplied MONEY,
	CurrentBalance MONEY, Age31_60 MONEY, Age61_90 MONEY, Age91_120 MONEY, AgeOver120 MONEY, TotalBalance MONEY)
	INSERT INTO #ReportResults(TypeGroup, TypeSort, Unapplied, CurrentBalance, Age31_60, Age61_90, Age91_120, 
	AgeOver120, TotalBalance)
	SELECT ISNULL(TypeGroup, 'Unassigned'), ISNULL(TypeSort, 4), 0 Unapplied,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 0 AND 30 OR BLL.PostingDate IS NULL THEN ARAmount ELSE 0 END) CurrentBalance,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 31 AND 60 THEN ARAmount ELSE 0 END) Age31_60,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 61 AND 90 THEN ARAmount ELSE 0 END) Age61_90,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 91 AND 120 THEN ARAmount ELSE 0 END) Age91_120,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) > 120 THEN ARAmount ELSE 0 END) AgeOver120,
	SUM(ARAmount) TotalBalance
	FROM #AR AR 
		LEFT JOIN #ASN ASN ON AR.ClaimID=ASN.ClaimID
		LEFT JOIN #BLL BLL ON AR.ClaimID=BLL.ClaimID
	WHERE (@ContractID = -1 OR AR.ClaimID=ASN.ClaimID)
	GROUP BY TypeGroup, TypeSort

---------- Adds Unapplied Payment
	UPDATE RR
	SET Unapplied = SU.PaymentAmount, 
		TotalBalance = ISNULL(TotalBalance, 0) - ISNULL( SU.PaymentAmount, 0)
	FROM #SummarizedUnapplied SU
		INNER JOIN PayerTypeCode PTC ON PTC.PayerTypeCode = SU.PayerTypeCode
		INNER JOIN #ReportResults RR ON RR.TypeGroup = PTC.Description
																						
	INSERT INTO #ReportResults( TypeGroup, TypeSort, Unapplied, TotalBalance)
	SELECT  TypeGroup = PTC.Description,
			(CASE SU.PayerTypeCode WHEN  'I' THEN 1 WHEN 'P' THEN 2 ELSE 3 END),
			SU.PaymentAmount, -1* PaymentAmount
	FROM #SummarizedUnapplied SU
		INNER JOIN PayerTypeCode PTC ON PTC.PayerTypeCode = SU.PayerTypeCode
		LEFT OUTER JOIN #ReportResults RR ON RR.TypeGroup = PTC.Description		
	WHERE RR.TypeGroup IS NULL
----------- End Adds Unapplied Payment


	SELECT TypeGroup, TypeSort, Unapplied, CurrentBalance, Age31_60, Age61_90, Age91_120, 
	AgeOver120, TotalBalance
	FROM #ReportResults
	ORDER BY TypeSort


	DROP TABLE #AR
	DROP TABLE #ASN
	DROP TABLE #ASNMax
	DROP TABLE #BLL
	DROP TABLE #ReportResults
	DROP TABLE #SummarizedUnapplied
	DROP TABLE #AppliedReceipts, #AppliedReceiptsDetail





GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



