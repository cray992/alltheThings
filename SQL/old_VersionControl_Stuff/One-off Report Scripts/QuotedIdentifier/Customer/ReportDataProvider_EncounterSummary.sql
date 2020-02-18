SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_EncounterSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[ReportDataProvider_EncounterSummary]
GO


CREATE PROCEDURE dbo.ReportDataProvider_EncounterSummary
	@PayerScenarioID INT, 
	@PracticeID INT,
	@BeginDate datetime = null,
	@EndDate datetime = null,
	@DateType char(1) = 'P',		-- P = Posting Date, S=Service Date
	@ProviderNumberID int = -1, 
	@ServiceLocationID int = -1, 
	@DepartmentID int = -1, 
	@BatchNumberID varchar(50) = null, --???
	@EncounterStatusID int = -1


AS
/*
declare
	@PayerScenarioID INT, 
	@PracticeID INT,
	@BeginDate datetime,
	@EndDate datetime,
	@DateType char(1),		-- P = Posting Date, S=Service Date
	@ProviderNumberID int, 
	@ServiceLocationID int, 
	@DepartmentID int, 
	@BatchNumberID VARCHAR(50), 
	@EncounterStatusID int

select 
	@PayerScenarioID = -1, 
	@PracticeID = 65,
	@BeginDate = '5/1/06',
	@EndDate = '7/18/06',
	@DateType = 'P',		-- P = Posting Date, S=Service Date
	@ProviderNumberID = -1, 
	@ServiceLocationID = -1, 
	@DepartmentID = -1, 
	@BatchNumberID = NULL, 
	@EncounterStatusID = -1
*/

	SET @BeginDate = dbo.fn_DateOnly( @BeginDate )
	SET @EndDate = DATEADD( S, -1, DBO.fn_DateOnly( DATEADD(D, 1, @EndDate)))

	select	ec.EncounterID,
			ec.PracticeID,
			ec.PatientCaseID,
			ec.PatientID,
			LocationID,
			DateOfService,
			es.EncounterStatusDescription,
			RTRIM(ISNULL(doc.FirstName + ' ','') + ISNULL(doc.MiddleName + ' ', '')) + ISNULL(' ' + doc.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(doc.Degree), '') AS ProviderFullname,
			doc.DepartmentID,
			pc.PayerScenarioID,
			ec.EncounterStatusID
	into #EC
	from encounter ec 
		inner join PatientCase pc on ec.PracticeID=pc.PracticeID AND ec.PatientCaseID=pc.PatientCaseID
		inner join Doctor doc on doc.DoctorID = ec.DoctorID and doc.[External]=0 
		INNER JOIN EncounterStatus es on es.EncounterStatusID = ec.EncounterStatusID
	where 	(@PracticeID = ec.PracticeID) and		
			( (@DateType = 'P' and ec.PostingDate between @BeginDate and @EndDate) or (@DateType = 'S' and ec.DateOfService between @BeginDate and @EndDate) ) and
			(@ProviderNumberID = -1 or @ProviderNumberID = ec.DoctorID) and
			(@ServiceLocationID = -1 or @ServiceLocationID = ec.LocationID) and
			(@PayerScenarioID = -1 or @PayerScenarioID = pc.PayerScenarioID ) and
			(@DepartmentID = -1 or @DepartmentID = doc.DepartmentID) and
			(@EncounterStatusID = -1 or @EncounterStatusID = es.EncounterStatusID ) and
			((RTRIM(EC.BatchID)=RTRIM(@BatchNumberID)) OR (@BatchNumberID IS NULL))


/*
	SELECT		e.PracticeID,
				e.EncounterID,
 				ep.EncounterProcedureID, 
				ep.ServiceUnitCount, 
				DCD1.DiagnosisCode as DiagnosisCode1, 
				DCD2.DiagnosisCode as DiagnosisCode2, 
				ep.ProcedureModifier1,
				dic.ProcedureCode,
				ISNULL(dic.LocalName,dic.OfficialName) as ProcedureCodeOfficialName,
				EstCharges = ISNULL(ep.ServiceUnitCount, 0) * ISNULL(ep.ServiceChargeAmount, 0)
	into #EP
	FROM        #EC AS e INNER JOIN
				EncounterProcedure AS ep ON e.PracticeID = ep.PracticeID and e.EncounterID = ep.EncounterID INNER JOIN
				ProcedureCodeDictionary as dic on dic.ProcedureCodeDictionaryID = ep.ProcedureCodeDictionaryID LEFT OUTER JOIN
				EncounterDiagnosis ED1 ON ED1.EncounterDiagnosisID = EP.EncounterDiagnosisID1 LEFT OUTER JOIN 
				DiagnosisCodeDictionary as DCD1 on DCD1.DiagnosisCodeDictionaryID = ED1.DiagnosisCodeDictionaryID LEFT OUTER JOIN
				EncounterDiagnosis ED2 ON ED2.EncounterDiagnosisID = EP.EncounterDiagnosisID2 LEFT OUTER JOIN 
				DiagnosisCodeDictionary as DCD2 on DCD2.DiagnosisCodeDictionaryID = ED2.DiagnosisCodeDictionaryID	
*/

select 
		E.EncounterID,
		cntEncounterID = count(distinct ep.EncounterID), 
		cntEncounterProcedureID = count(distinct ep.EncounterProcedureID) ,
		Charges =SUM( CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END) ,
		Adjustments = SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN Amount*-1 ELSE 0 END) ,
		InsPay = SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='I' THEN Amount*-1 ELSE 0 END) ,
		PatPay = SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' THEN Amount*-1 ELSE 0 END) ,
		TotalBalance = SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE Amount*-1 END),
		PendingIns = SUM(CASE WHEN ICP.InsuranceCompanyPlanID is not null AND CAA.ClaimID is not null THEN CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE Amount*-1 END ELSE 0 END),
		PendingPat = SUM(CASE WHEN ICP.InsuranceCompanyPlanID is null AND CAA.ClaimID is not null THEN CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE Amount*-1 END ELSE 0 END),
		EstCharges = SUM( ISNULL(ep.ServiceUnitCount, 0) * ISNULL(ep.ServiceChargeAmount, 0) ),
		E.EncounterStatusID,
		PayerScenarioID
INTO #ClaimAccounting
from 
	#EC AS e 
	INNER JOIN EncounterProcedure AS ep ON e.PracticeID = ep.PracticeID and e.EncounterID = ep.EncounterID
	left outer join Claim C on c.PracticeID = @PracticeID AND c.EncounterProcedureID = ep.EncounterProcedureID
	left outer join ClaimAccounting CA on ca.PracticeID = @PracticeID AND c.ClaimID = ca.ClaimID
	left outer join ClaimAccounting_Assignments CAA on caa.practiceID = @PracticeID and c.ClaimID = caa.ClaimID and isnull(caa.LastAssignment, 1) = 1
	LEFT OUTER JOIN PaymentClaimTransaction PCT ON pct.PracticeID = @PracticeID AND CA.ClaimTransactionID=PCT.ClaimTransactionID
	LEFT OUTER JOIN Payment P ON P.PracticeID = @PracticeID AND PCT.PaymentID=P.PaymentID
	Left Outer Join InsuranceCompanyPlan ICP ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
GROUP BY E.EncounterID, 		
	E.EncounterStatusID,
	PayerScenarioID

UPDATE ca
SET Charges = EstCharges,
	TotalBalance = EstCharges,
	PendingIns = CASE WHEN ps.Name <> 'Self Pay' AND ps.Name IS NOT NULL THEN EstCharges ELSE 0 END,
	PendingPat =  CASE WHEN ps.Name = 'Self Pay' OR ps.Name IS NULL THEN EstCharges ELSE 0 END
from #ClaimAccounting ca
	LEFT OUTER JOIN PayerScenario ps on ps.PayerScenarioID = ca.PayerScenarioID
where EncounterStatusID <> 3



select	ec.EncounterStatusDescription, 
		ec.ProviderFullname,
		sl.Name as ServiceLocationName,
		dept.Name as DepartmentName,
		cntEncounterID = SUM( cntEncounterID), 
		cntEncounterProcedureID = SUM(cntEncounterProcedureID ),
		Charges = SUM(Charges ),
		Adjustments = SUM(Adjustments ),
		InsPay = SUM(InsPay ),
		PatPay = SUM( PatPay),
		TotalBalance = SUM(TotalBalance ),
		PendingIns = SUM(PendingIns ),
		PendingPat = SUM(PendingPat )

from #ec ec
	LEFT OUTER JOIN #ClaimAccounting CA ON EC.EncounterID = CA.EncounterID
	left outer JOIN ServiceLocation sl on sl.ServiceLocationID = ec.LocationID
	Left outer Join Department dept on dept.DepartmentID = ec.DepartmentID
group by ec.EncounterStatusDescription, 
		ec.ProviderFullname,
		sl.Name ,
		dept.Name

	Drop table #EC, #ClaimAccounting

go




GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

