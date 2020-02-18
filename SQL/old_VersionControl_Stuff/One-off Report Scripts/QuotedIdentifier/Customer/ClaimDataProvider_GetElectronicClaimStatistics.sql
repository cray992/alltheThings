SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClaimDataProvider_GetElectronicClaimStatistics]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ClaimDataProvider_GetElectronicClaimStatistics]
GO


CREATE PROCEDURE dbo.ClaimDataProvider_GetElectronicClaimStatistics
	@practice_id INT
AS
BEGIN

	SELECT	COUNT(*) as AssignedToElectronicCount
	FROM	Claim C
		LEFT OUTER JOIN ClaimAccounting_Assignments CA
			ON CA.PracticeID = @practice_id AND CA.ClaimID = C.ClaimID AND CA.LastAssignment = 1
		INNER JOIN dbo.Patient P
			ON P.PatientID = C.PatientID
		INNER JOIN dbo.EncounterProcedure EP
			ON EP.EncounterProcedureID = C.EncounterProcedureID
		INNER JOIN dbo.Encounter E
			ON E.EncounterID = EP.EncounterID
		INNER JOIN dbo.ProcedureCodeDictionary PCD
			ON PCD.ProcedureCodeDictionaryID = EP.ProcedureCodeDictionaryID
		INNER JOIN PatientCase PC
			ON PC.PatientCaseID = E.PatientCaseID
		LEFT OUTER JOIN InsurancePolicy PI
			ON PI.InsurancePolicyID = CA.InsurancePolicyID
		INNER JOIN InsuranceCompanyPlan ICP					
			ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
		INNER JOIN InsuranceCompany IC
			ON ICP.InsuranceCompanyID=IC.InsuranceCompanyID
		LEFT OUTER JOIN ClearinghousePayersList CPL
			ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID
		INNER JOIN Practice PR
			ON C.PracticeID = PR.PracticeID
		LEFT OUTER JOIN PracticeToInsuranceCompany PTIC
			ON PTIC.PracticeID = PR.PracticeID AND PTIC.InsuranceCompanyID = ICP.InsuranceCompanyID
		LEFT OUTER JOIN PatientCaseDate PCDT 
			ON PCDT.PatientCaseID = PC.PatientCaseID
			AND PCDT.PatientCaseDateTypeID = (
				SELECT PatientCaseDateTypeID 
				FROM PatientCaseDateType 
				WHERE [Name] = 'Hospitalization Related to Condition' )
			
	WHERE	C.PracticeID = @practice_id
		AND C.ClaimStatusCode = 'R'
		AND PR.EClaimsEnrollmentStatusID > 1
		AND IC.EClaimsAccepts = 1 AND (PTIC.EClaimsDisable IS NULL OR PTIC.EClaimsDisable = 0)
		AND CPL.PayerNumber IS NOT NULL
		AND (CPL.IsEnrollmentRequired = 0 OR PTIC.EClaimsEnrollmentStatusID > 1) 
	
	--		AND C.AssignmentIndicator IS NOT NULL
	--		AND C.AssignmentIndicator <> ''P''
		AND PC.AutoAccidentRelatedFlag = 0
		AND PC.EmploymentRelatedFlag = 0
	
		AND NOT (C.NonElectronicOverrideFlag = 1 OR E.DoNotSendElectronic = 1) 
		AND NOT EXISTS (SELECT	CT.ClaimTransactionID
				FROM	ClaimTransaction CT
				WHERE	CT.ClaimID = C.ClaimID AND CT.ClaimTransactionTypeCode = 'ADJ')
		AND NOT (PCDT.StartDate IS NULL AND E.PlaceOfServiceCode IN (21,51))
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

