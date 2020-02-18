USE [superbill_5596_dev]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--CREATE PROCEDURE [dbo].[ReportDataProvider_EssentialBilling_ARType] 


--@EndDate DATETIME,
--@PracticeID INT,
--@DateType VARCHAR (1)='F',--First Bill Date is Default =F, Last Bill Date=L, Encounter PostingDate=E
--@ProviderID INT =NULL

--AS 

	/*Debug*/
	DECLARE
	@EndDate DATETIME,
	@PracticeID INT,
	@DateType VARCHAR (1)='F',--First Bill Date is Default =F, Last Bill Date=L, Encounter PostingDate=E, ServiceDate=S
	@ProviderID INT =NULL,
	@BeginDate DATETIME='1/1/1900',
	@IncludePriorPM Tinyint=0
	
	Select  @EndDate='7/1/2015', 
			@PracticeID=3, 
			@DateType='F',
			@IncludePriorPM=0

	SET @EndDate = DATEADD(S,-1,DATEADD(D,1,dbo.fn_DateOnly( @EndDate )))	
	
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL	READ UNCOMMITTED

IF @IncludePriorPM=0
	BEGIN
	SELECT @BeginDate=activationDate FROM SHAREDSERVER.superbill_shared.dbo.ProductDomain_ProductSubscription WHERE CustomerId=(SELECT value FROM dbo.CustomerProperties WHERE [Key]='CustomerID') AND DeactivationDate IS NULL
	END
	
	IF @BeginDate IS NULL 
	BEGIN
	SET @BeginDate='1/1/1900'
	END

SELECT @BeginDate	
	
CREATE TABLE #BLLMax (PracticeID INT, ClaimID INT, ClaimTransactionID INT, TypeGroup varchar(20) )
	
CREATE TABLE #BLL(PracticeID INT,ClaimID INT, PostingDate DATETIME, TypeGroup varchar(20) )

CREATE TABLE #AR_ASN (PracticeID INT,PatientID INT, ClaimID INT, InsAmount MONEY, PatAmount MONEY , 
	UnasgnAmount MONEY, ServiceDate Datetime, ServicePostingDate Datetime, TypeCode char(1),
	InsurancePolicyID INT, InsuranceCompanyPlanID INT, InsuranceCompanyID INT)

		
CREATE TABLE #Final
	( InsCoID INT, InsName VARCHAR(100), Bucket VARCHAR(20), Result MONEY , [Group] VARCHAR(2))

CREATE TABLE #FinalResults(InsCoId INT, Name Varchar(max), 
		TotalBalance MONEY)	
CREATE TABLE #AR (PracticeID INT,PaymentID INT, RespID INT, ClaimID INT, ARAmount MONEY,
		ServiceDate Datetime, ServicePostingDate Datetime, TypeGroup varchar(20), TypeSort INT)
CREATE TABLE #ReportResults(
		PracticeID INT,RespID INT, TypeGroup VARCHAR(128), TypeSort INT, TotalBalance MONEY)
CREATE TABLE #PatientResults(InsCoId INT, Name Varchar(max), TotalBalance MONEY)	
CREATE TABLE #AppliedReceipts(PaymentID INT, AppliedAmount MONEY)

CREATE TABLE #ASN(ClaimID INT, InsurancePolicyID INT, InsuranceCompanyPlanID INT, InsurancecompanyID INT)
	
CREATE TABLE #ASNMax
	(ClaimID INT, ClaimTransactionID INT)

INSERT INTO #ASNMax(ClaimID, ClaimTransactionID)
	SELECT CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Assignments CAA 
	WHERE PracticeID=@PracticeID AND caa.PostingDate<=@EndDate AND caa.postingdate>=@BeginDate
	GROUP BY CAA.ClaimID
	
	
	
INSERT INTO #ASN(ClaimID, InsurancePolicyID, InsuranceCompanyPlanID, InsuranceCompanyID)
	SELECT CAA.ClaimID, 
	ip.InsurancePolicyID,
	ip.InsuranceCompanyPlanID,
	icp.InsuranceCompanyID
	FROM ClaimAccounting_Assignments CAA 
		INNER JOIN #ASNMax AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
		LEFT JOIN InsurancePolicy ip ON caa.PracticeID = ip.PracticeID AND CAA.InsurancePolicyID=IP.InsurancePolicyID
		LEFT JOIN InsuranceCompanyPlan icp ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	WHERE CAA.PracticeID=@PracticeID AND CAA.PostingDate<=@EndDate AND caa.postingdate>=@BeginDate
	-----------------------------------------------------------------------
--If there are no filters this will run
	IF @ProviderID IS NULL

	Begin 
			--Patient and Insurance
			INSERT INTO #AR_ASN(
				PracticeID,
				patientID
				, ClaimID
				, ServiceDate
				, ServicePostingDate
				, UnasgnAmount
				, InsAmount
				, PatAmount
				, TypeCode
				,InsurancePolicyID, InsuranceCompanyPlanID, InsuranceCompanyID
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






ELSE -- filters

BEGIN
			INSERT INTO #AR_ASN(
				PracticeID,
				patientID
				, ClaimID
				, ServiceDate
				, ServicePostingDate
				, UnasgnAmount
				, InsAmount
				, PatAmount
				, TypeCode
				,InsurancePolicyID, InsuranceCompanyPlanID, InsuranceCompanyID
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
			INNER  JOIN #ASN asn ON asn.ClaimID = ca.ClaimID 
			LEFT JOIN Payment PMT  ON PMT.PracticeID = ca.PracticeID AND  PMT.PaymentID = ca.PaymentID
			WHERE 
			ca.PracticeID=@PracticeID
				AND ca.ca_PostingDate <=@Enddate
				AND ClaimTransactionTypeCode IN ('PAY', 'ADJ', 'CST')
				AND (@ProviderID IS NULL OR EDP.DoctorID=@ProviderID )
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
 	
INSERT INTO #AppliedReceipts
	SELECT	ca.PaymentID, 
			SUM(  case when ca.ca_postingDate <= @endDate then -1 * Amount else 0 end ) AppliedAmount
	
	FROM vReportDataProvider_Claim_Payments AS ca
	INNER JOIN Payment AS p ON ca.PaymentId = p.PaymentID
	
	
	WHERE ca.PracticeID = @PracticeID 
		AND (ca.PAY_PostingDate <= @endDate OR ca.ca_PostingDate <= @endDate )
		AND ClaimTransactionTypeCode = 'PAY' AND ca.PayerTypeCode='I'
	GROUP BY ca.PaymentID


----------------------------------------			
	INSERT INTO #ReportResults(PracticeID,RespID, TypeGroup, TypeSort, TotalBalance)
	SELECT
		AR.PracticeID ,
		RespID ,
		ISNULL(ar.TypeGroup, 'Unassigned') ,
		ISNULL(TypeSort, 4) ,
		SUM(ARAmount) TotalBalance 
	FROM (  SELECT PracticeID, RespID, ClaimID, TypeGroup, TypeSort, sum(ARAmount)AS ARAmount
			FROM #AR
			GROUP BY PracticeID,RespID, ClaimID, TypeGroup, TypeSort
		  ) as AR 
	LEFT JOIN #BLL BLL ON AR.ClaimID=BLL.ClaimID 
			AND ( 
				(@DateType IN ('F', 'L') AND bll.TypeGroup = ar.TypeGroup) 
				OR ( @DateType NOT IN ('F', 'L') ))	 
											
	WHERE ar.claimID IN (SELECT claimID from #AR aa group by claimID having sum(ARAmount)<>0)
	GROUP BY AR.PracticeID, RespID, ar.TypeGroup, TypeSort



--Gets the Insurance Company part 
INSERT INTO #FinalResults
(InsCoId, Name,  TotalBalance )	
SELECT  ID,NAME,TotalBalance
FROM 	   
	   (SELECT
		IC.InsuranceCompanyID AS ID ,
		IC.InsuranceCompanyName AS NAME ,
		ISNULL(SUM(TotalBalance), 0) AS TotalBalance
		FROM #ReportResults r
		INNER JOIN InsuranceCompanyPlan AS icp  ON r.respId=icp.InsuranceCompanyPlanId
		INNER JOIN dbo.InsuranceCompany AS IC ON icp.InsuranceCompanyID = IC.InsuranceCompanyID
		Group by IC.InsuranceCompanyID, IC.InsuranceCompanyName, TypeGroup
			)sub
WHERE TotalBalance <> 0 
ORDER BY ID, Name		
--Gets only the Patients part 
INSERT INTO #PatientResults
(InsCoId, Name, TotalBalance )	
SELECT  0 AS InsCoId,'Patient' AS NAME, TotalBalance
FROM 	   
	   (SELECT 
		TotalBalance
		FROM #ReportResults r
		WHERE TypeGroup='Patient' 
		)sub
WHERE 		TotalBalance <> 0 
ORDER BY InsCoId, Name	

--Inserts all the insurance based on buckets and results and then ranks them based on the results
INSERT INTO #Final
	( InsCoID, InsName, Bucket, Result,  [Group] )
SELECT InsCoID, Name, Bucket, Result, 'I' 
FROM
	(SELECT InsCoID, Name, TotalBalance
	FROM #FinalResults) AS Source
UNPIVOT
(Result FOR Bucket IN
	(TotalBalance)
) AS unpvt;

--This is to insert patient responsibility seperate so it doesn't mess with the ranking of insurance
INSERT INTO #Final
	( InsCoID, InsName, Bucket, Result,  [Group] )
SELECT InsCoID, Name, 'TotalBalance', SUM(TotalBalance), 'P'
FROM #PatientResults
GROUP BY InsCoID, Name


SELECT 'Insurance',  'Total AR', SUM(Result)
FROM #Final WHERE [Group] = 'I'
UNION
SELECT 'Patient', 'Total AR', Result
FROM #Final WHERE [Group] = 'P'


DROP TABLE #AR, #AR_ASN, #ASNMax, #ASN
DROP TABLE #BLL, #Final, #FinalResults
DROP TABLE #ReportResults, #PatientResults
DROP TABLE #BLLMax, #AppliedReceipts
