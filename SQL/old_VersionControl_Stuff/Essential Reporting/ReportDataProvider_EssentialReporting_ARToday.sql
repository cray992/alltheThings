USE [superbill_22109_dev]
GO
/****** Object:  StoredProcedure [dbo].[ReportDataProvider_ArAgingSummary_Insurance_V1]    Script Date: 7/23/2015 2:44:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--CREATE PROCEDURE [dbo].[ReportDataProvider_EssentialBilling_ARToday] 


--@EndDate DATETIME,
--@PracticeID INT,
--@DateType VARCHAR (1)='F',--First Bill Date is Default =F, Last Bill Date=L, Encounter PostingDate=E
--@ProviderID INT =NULL,
--@ServiceLocationID INT =NULL,
--@BatchID VARCHAR(50) =NULL ,
--@PayerScenarioID INT =NULL,
--@InsuranceCompanyPlanIDs VARCHAR(8000) =NULL--Varchar because you can pass through an array of InsuranceCompanyPlans or just one

--AS 

	/*Debug*/
	DECLARE
	@EndDate DATETIME,
	@PracticeID INT,
	@NumberOfIns INT

	----ReportDataProvider_ArAgingSummary_Insurance_V1 @EndDate='10/25/2012', @PracticeID=2, @DateType='F', @ProviderID=5, @ServiceLocationID=NULL, @BatchID=NULL, @PayerScenarioID=Null, @InsuranceCompanyPlanIDs='218,230,79'
	Select @EndDate='7/1/2015', 
			@PracticeID=3, 
			@DateType='F', 
			@NumberOfIns = 10

	SET @EndDate = DATEADD(S,-1,DATEADD(D,1,dbo.fn_DateOnly( @EndDate )))	
	
	SELECT 
	@BatchID = CASE WHEN (@BatchID = '' ) THEN NULL ELSE @BatchID END

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL	READ UNCOMMITTED


	
	CREATE TABLE #BLLMax (PracticeID INT, ClaimID INT, ClaimTransactionID INT, TypeGroup varchar(20) )
	
	CREATE TABLE #BLL(PracticeID INT,ClaimID INT, PostingDate DATETIME, TypeGroup varchar(20) )

	CREATE TABLE #AR_ASN (PracticeID INT,
		PatientID INT
		, ClaimID INT
		, InsAmount MONEY
		, PatAmount MONEY 
		,UnasgnAmount MONEY
		, ServiceDate Datetime
		,ServicePostingDate Datetime
		, TypeCode char(1)
		,InsurancePolicyID INT, InsuranceCompanyPlanID INT, InsuranceCompanyID INT
		)



CREATE TABLE #Final
	( Name VARCHAR(100),  Result MONEY )

CREATE TABLE #FinalResults(InsCoId INT, Name Varchar(max), TotalBalance MONEY)	
CREATE TABLE #AR (PracticeID INT,PaymentID INT, RespID INT, ClaimID INT, ARAmount MONEY
		, ServiceDate Datetime, ServicePostingDate Datetime, TypeGroup varchar(20), TypeSort INT)
CREATE TABLE #ReportResults(
		PracticeID INT,RespID INT, TypeGroup VARCHAR(128), TypeSort INT, TotalUnapplied MONEY,
		CurrentBalance MONEY, TotalBalance MONEY, Credit MONEY, Unapplied MONEY, Capitated MONEY, Refund MONEY, UnbilledCharges MONEY)
CREATE TABLE #PatientResults(InsCoId INT, Name Varchar(max), TotalBalance MONEY)	
CREATE TABLE #AppliedReceipts(PaymentID INT, AppliedAmount MONEY)
CREATE TABLE #SummarizedUnapplied(PayerID INT, PayerTypeCode VARCHAR(2), PaymentAmount MONEY) 	

	
	CREATE TABLE #ASNMax
	(ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #ASNMax(ClaimID, ClaimTransactionID)
	SELECT CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Assignments CAA 
	WHERE PracticeID=@PracticeID AND caa.PostingDate<=@EndDate
	GROUP BY CAA.ClaimID
	
	
	CREATE TABLE #ASN(ClaimID INT, InsurancePolicyID INT, InsuranceCompanyPlanID INT, InsurancecompanyID INT)
	INSERT INTO #ASN(ClaimID, InsurancePolicyID, InsuranceCompanyPlanID, InsuranceCompanyID)
	SELECT CAA.ClaimID, 
	ip.InsurancePolicyID,
	ip.InsuranceCompanyPlanID,
	icp.InsuranceCompanyID
	FROM ClaimAccounting_Assignments CAA 
		INNER JOIN #ASNMax AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
		LEFT JOIN InsurancePolicy ip ON caa.PracticeID = ip.PracticeID AND CAA.InsurancePolicyID=IP.InsurancePolicyID
		LEFT JOIN InsuranceCompanyPlan icp ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	WHERE CAA.PracticeID=@PracticeID AND CAA.PostingDate<=@EndDate
	-----------------------------------------------------------------------

	Begin 
			--Patient and Insurance
			INSERT INTO #AR_ASN(
				PracticeID, PatientID, ClaimID, ServiceDate, ServicePostingDate, UnasgnAmount
				, InsAmount, PatAmount, TypeCode,InsurancePolicyID, InsuranceCompanyPlanID, InsuranceCompanyID
				)
			SELECT	
				CA.PracticeID,
				EDP.patientID,
				ca.ClaimID, 
				EDP.ProcedureDateOfService,
				eDP.EncounterDate PostingDate,
				UnasgnAmount = SUM( 
								case when asn.CLaimID IS NULL THEN
									case 
										when ClaimTransactionTypeCode = 'PAY' and ca.ca_PostingDate>@EndDate then 0	-- we can not take future payments
										when ClaimTransactionTypeCode = 'CST' THEN amount else -1*Amount 
										END 
								ELSE 0 
								END 
							),
				InsAmount = SUM(	
								CASE 
								WHEN asn.CLaimID IS NULL THEN 0 -- 'Unassigned'
								WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' -- Exclude patient payment against total
									THEN 0
								WHEN InsurancePolicyID IS NOT NULL
									THEN CASE WHEN ClaimTransactionTypeCode='CST' THEN AMOUNT ELSE -1*AMOUNT END
								ELSE 0
								END
							),
				PatAmount = SUM(
								CASE 
								WHEN asn.CLaimID IS NULL THEN 0 -- 'Unassigned'		
								WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' -- Include patient payment against total
									THEN Amount*-1
								WHEN InsurancePolicyID IS NULL -- Assinged to patient
									THEN  CASE WHEN ClaimTransactionTypeCode = 'CST' THEN Amount ELSE Amount*-1 END 
								ELSE 0 
								END
							),
		case when InsurancePolicyID IS NULL then 'P' else 'I' END,
	
	asn.InsurancePolicyID,
	asn.InsuranceCompanyPlanID,
	asn.InsuranceCompanyID
			FROM vReportDataProvider_Claim_ClaimAccounting CA WITH(NOEXPAND)
			Inner JOIN vReportDataProvider_Encounter_Doctor_Patient as EDP  with (NOEXPAND) ON CA.PracticeID=EDP.PRacticeID 
					AND edp.EncounterProcedureID=CA.EncounterPRocedureID
			INNER JOIN #ASN asn ON asn.ClaimID = ca.ClaimID 
			LEFT JOIN Payment PMT  ON PMT.PracticeID = ca.PracticeID AND  PMT.PaymentID = ca.PaymentID
			WHERE 
			ca.PracticeID=@PracticeID
				AND 
				ca.ca_PostingDate <=@Enddate
				AND ClaimTransactionTypeCode IN ('PAY', 'ADJ', 'CST')
				
			GROUP BY 
				Ca.PracticeID,
				ca.ClaimID, 
				edp.ProcedureDateOfService,
				edp.EncounterDate,				
				edp.patientID,
				case when InsurancePolicyID IS NULL then 'P' else 'I' END,
	asn.InsurancePolicyID,
	asn.InsuranceCompanyPlanID,
	asn.InsuranceCompanyID
	
	
END
			--------------- Figures out co-pay ----------------

		
			update asn
			set insAmount = ISNULL(insAmount, 0) - ISNULL(ca.amount,0),
				patAmount = ISNULL(PatAmount, 0) + ISNULL(ca.amount, 0)
			from #AR_ASN asn 
			INNER JOIN (SELECT PracticeID, ClaimID, sum(Amount) Amount 
								FROM ClaimAccounting ca  
								WHERE ClaimTransactionTypeCode = 'PRC' AND ca.PostingDate <=@Enddate
								GROUP BY ClaimID, PracticeID
							) as ca on ca.ClaimID = asn.ClaimID AND ca.PracticeID=asn.PracticeID
			
			Where TypeCode = 'I' AND ASN.PracticeID=@PracticeID


			-- Insurance's responsibility
			INSERT INTO #AR(PracticeID,RespID, ClaimID
				, ServiceDate, ServicePostingDate, ARAmount, TypeGroup, TypeSort
				)
			SELECT	c.PracticeID,
				
					c.InsuranceCompanyPlanID as RespID,
					c.ClaimID, 
					c.ServiceDate, c.ServicePostingDate,
					c.insAmount,
					TypeGroup = 'Insurance', 
					TypeSort = 1
			FROM #AR_ASN c
		
			where c.insAmount <> 0

	
			-- Patient's responsibility
			INSERT INTO #AR(PracticeID,RespID, ClaimID
				, ServiceDate, ServicePostingDate, ARAmount, TypeGroup, TypeSort
				)
			SELECT	c.PracticeID,
					patientID as RespID,
					c.ClaimID,  
					c.ServiceDate, c.ServicePostingDate,
					c.patAmount,
					TypeGroup = 'Patient', 
					TypeSort = 2
			FROM #AR_ASN c
			where patAmount <> 0

	

		
		
			--Get First Billed Info
			INSERT INTO #BLLMax(PracticeID,ClaimID, ClaimTransactionID, TypeGroup)
			SELECT 
				CAB.PracticeID,
				CAB.ClaimID
				, MIN(ClaimTransactionID) ClaimTransactionID
				, case when BatchType = 'S' THEN 'Patient' ELSE 'Insurance' END
			FROM ClaimAccounting_Billings CAB 
			INNER JOIN #AR ar ON CAB.ClaimID=AR.ClaimID AND cab.PracticeID=AR.PracticeID
			WHERE		cab.PostingDate<=@EndDate 			
				--AND EXISTS(SELECT * FROM #AR ar WHERE CAB.ClaimID=AR.ClaimID AND CAB.PracticeID=AR.PracticeID)
			GROUP BY 
				CAB.PracticeID,
				CAB.ClaimID, 
				case when BatchType = 'S' THEN 'Patient' ELSE 'Insurance' END
				
			
		
		
		INSERT #BLL(PracticeID,ClaimID, PostingDate, TypeGroup)
			SELECT CAB.PracticeID,CAB.ClaimID, CAB.PostingDate, bm.TypeGroup
			FROM #BLLMax BM 
				INNER JOIN ClaimAccounting_Billings CAB  ON CAB.ClaimTransactionID=BM.ClaimTransactionID
								AND CAB.ClaimId=BM.ClaimID AND BM.PracticeID=CAB.PracticeID



-----------------  Calc Unapplied amounts -----------
		


--IF there is no Insurance filter this will run
 Begin	
INSERT INTO #AppliedReceipts
	SELECT	ca.PaymentID, 
			SUM(  case when ca.ca_postingDate <= @endDate then -1 * Amount else 0 end ) AppliedAmount
	
	FROM vReportDataProvider_Claim_Payments AS ca
	INNER JOIN Payment AS p ON ca.PaymentId = p.PaymentID
	
	
	WHERE ca.PracticeID = @PracticeID 
		AND (ca.PAY_PostingDate <= @endDate OR ca.ca_PostingDate <= @endDate )
		AND ClaimTransactionTypeCode = 'PAY' AND ca.PayerTypeCode='I'
	GROUP BY ca.PaymentID

INSERT INTO #SummarizedUnapplied
	SELECT PayerID, PayerTypeCode, SUM(PaymentAmount) AS PaymentAmount
	FROM	(
					SELECT PayerTypeCode, 
							PayerID,
							PaymentAmount = SUM(  ISNULL(PaymentAmount, 0) + ISNULL(a.AppliedAmount, 0) )
					FROM  Payment P
					
							LEFT OUTER JOIN #AppliedReceipts AS a ON a.PaymentID = p.PaymentID
					WHERE P.PracticeID=@PracticeID 
						AND p.PostingDate <= @EndDate
						AND (@BatchID is Null or RTRIM(p.BatchID) = RTRIM(@BatchID))
						AND PayerTypeCode='I' 
					GROUP BY  p.PayerTypeCode, p.PayerID

					UNION ALL


					select PayerTypeCode, p.PayerID, sum(-1 * rtp.amount)
					from refund r 
						INNER jOIn refundToPayments rtp on r.RefundID = rtp.RefundID
						INNER JOIN Payment p on  p.practiceID = r.practiceID AND p.PaymentID = rtp.PaymentID
						
					WHERE r.PracticeID = @PracticeID 
						AND rtp.PostingDate <= @EndDate 
						AND r.RefundStatusCode = 'I'
						AND (@BatchID is Null or RTRIM(p.BatchID) = RTRIM(@BatchID))
						AND PayerTypeCode='I'
					group by p.PayerID, payerTypeCode

					UNION ALL

					select PayerTypeCode, PayerID, sum(-1 * rtp.amount)
					from CapitatedAccountToPayment rtp
						INNER JOIN Payment p on  p.PaymentID = rtp.PaymentID
					WHERE rtp.PostingDate <= @EndDate 
						AND p.PracticeID = @PracticeID
						AND (@BatchID is Null or RTRIM(p.BatchID) = RTRIM(@BatchID))
						AND PayerTypeCode='I'
					group by p.PayerID, payerTypeCode


				) AS V
			--LEFT JOIN InsuranceCompanyPlan icp ON icp.InsuranceCompanyPlanID = v.PayerID AND v.PayerTypeCode = 'I'
	WHERE 
	PayerTypeCode='I'	
	AND	@ProviderID IS NULL AND
		@ServiceLocationID IS Null AND
		@PayerScenarioID IS NULL 
   -- AND (@InsuranceCompanyPlanIDs IS NULL OR V.PayerID IN (SELECT InsuranceCompanyPlanId FROM #InsuranceCompanyPlanIDs))

	GROUP BY PayerID, PayerTypeCode
END 

----------------------------------------			
	INSERT INTO #ReportResults(PracticeID,RespID, TypeGroup, TypeSort, 
		 TotalBalance, Credit, UnbilledCharges)
	SELECT
		AR.PracticeID ,RespID, ISNULL(ar.TypeGroup, 'Unassigned'), ISNULL(TypeSort, 4),
		SUM(ARAmount) AS  TotalBalance, SUM(CASE WHEN ARAMount < 0 THEN ARAmount ELSE 0 END) Credit,
		SUM(CASE WHEN BLL.PostingDate IS NULL AND ARAmount>0 THEN ARAmount ELSE 0 END) UnbilledCharges
		
	FROM (
			SELECT PracticeID, RespID, ClaimID, TypeGroup, TypeSort, sum(ARAmount) ARAmount
			FROM #AR
			GROUP BY PracticeID,RespID, ClaimID, TypeGroup, TypeSort
			
		) as AR 

		LEFT JOIN #BLL BLL ON AR.ClaimID=BLL.ClaimID 
			AND ( 
				(@DateType IN ('F', 'L') AND bll.TypeGroup = ar.TypeGroup) 
				OR ( @DateType NOT IN ('F', 'L') ))	 
											
	WHERE
		ar.claimID IN (SELECT claimID from #AR aa group by claimID having sum(ARAmount)<>0)
	GROUP BY AR.PracticeID, RespID, ar.TypeGroup, TypeSort
	
------------ Adds Unapplied Payment
	UPDATE RR
	SET Unapplied = SU.PaymentAmount
	FROM #SummarizedUnapplied SU
		INNER JOIN PayerTypeCode PTC ON PTC.PayerTypeCode = SU.PayerTypeCode
		INNER JOIN #ReportResults RR ON RR.TypeGroup = PTC.Description AND rr.RespID = su.PayerID
	--WHERE UnappliedType='U'	
	
	
--Insert any unapplied $ not associated with previous AR Claims																						
	INSERT INTO #ReportResults(RespID, TypeGroup, TypeSort, Unapplied)
	SELECT  
			PayerID,
			TypeGroup = PTC.Description,
			(CASE SU.PayerTypeCode WHEN  'I' THEN 1 WHEN 'P' THEN 2 ELSE 3 END),
			Unapplied =  ISNULL(SUM(SU.PaymentAmount),0)
	FROM #SummarizedUnapplied SU
		INNER JOIN PayerTypeCode PTC ON PTC.PayerTypeCode = SU.PayerTypeCode
		LEFT OUTER JOIN #ReportResults RR ON RR.TypeGroup = PTC.Description	AND rr.RespID = su.PayerID	
	WHERE RR.TypeGroup IS NULL 
	
	GROUP BY PayerID,
			PTC.Description,
			(CASE SU.PayerTypeCode WHEN  'I' THEN 1 WHEN 'P' THEN 2 ELSE 3 END)
	HAVING SUM(SU.PaymentAmount) <> 0
----------- End Adds Unapplied Payment


--Gets the Insurance Company part 
INSERT INTO #FinalResults
(InsCoId, Name, TotalBalance )	
SELECT  ID,NAME,
		TotalBalance
FROM 	   
	   (SELECT IC.InsuranceCompanyID AS ID, IC.InsuranceCompanyName AS NAME ,TotalBalance
		FROM #ReportResults r
		INNER JOIN InsuranceCompanyPlan AS icp  ON r.respId=icp.InsuranceCompanyPlanId
		INNER JOIN dbo.InsuranceCompany AS IC ON icp.InsuranceCompanyID = IC.InsuranceCompanyID
		Group by IC.InsuranceCompanyID, IC.InsuranceCompanyName)sub
WHERE 		TotalBalance <> 0 
ORDER BY ID, Name		
--Gets only the Patients part 
INSERT INTO #PatientResults
(InsCoId, Name, TotalBalance )	
SELECT  0 AS InsCoId,'Patient' AS NAME, TotalBalance
FROM 	   
	   (SELECT TotalBalance
		FROM #ReportResults r
		WHERE TypeGroup='Patient' 
		)sub
WHERE 		TotalBalance <> 0 
ORDER BY InsCoId, Name	

--Inserts all the insurance based on buckets and results and then ranks them based on the results
INSERT INTO #Final
	( Name, Result )
SELECT 'Insurance', SUM(Result)


--This is to insert patient responsibility seperate so it doesn't mess with the ranking of insurance
INSERT INTO #Final
	( InsCoID, InsName, Bucket, Result, [Rank], [Group] )
SELECT InsCoID, Name, Bucket, Result, 0 , 'P'
FROM
(SELECT InsCoID, Name, TotalBalance
	FROM #PatientResults
	) AS Source
UNPIVOT
(Result FOR Bucket IN
	(Age0_10, Age11_20, Age21_30, Age31_40, Age41_50, 
	   Age51_60, Age61_70, Age71_80, Age81_90,Age91_100, 
	   Age101_110, Age111_120,Age121_150, Age151_180, Age181_plus,
	   TotalBalance)
) AS unpvt;


--Returns results either as one of the insurances or patients
SELECT InsCoID, InsName, Result
FROM #Final WHERE [Group] = 'I'
UNION
SELECT 0, 'Patient',  Result
FROM #Final WHERE [Group] = 'P'
UNION 
SELECT 0, 'Other', CASE WHEN SUBSTRING(bucket, (CHARINDEX('_', bucket, 0) + 1), LEN(bucket)) = 'plus' THEN 999
			WHEN SUBSTRING(bucket, (CHARINDEX('_', bucket, 0) + 1), LEN(bucket)) = 'TotalBalance' THEN 9999
			ELSE SUBSTRING(bucket, (CHARINDEX('_', bucket, 0) + 1), LEN(bucket)) END AS Bucket, SUM(Result), (@NumberOfIns + 2)
FROM #Final WHERE [Group] = 'G'
GROUP BY Bucket 
ORDER BY Bucket, Rank 


	DROP TABLE #AR, #AR_ASN, #ASNMax, #ASN
	DROP TABLE #BLL, #Final, #FinalResults
	DROP TABLE #ReportResults, #PatientResults
	DROP TABLE #BLLMax,#SummarizedUnapplied, #AppliedReceipts


