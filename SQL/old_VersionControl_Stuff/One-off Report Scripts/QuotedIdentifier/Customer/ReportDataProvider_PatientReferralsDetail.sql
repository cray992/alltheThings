SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_PatientReferralsDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_PatientReferralsDetail]
GO


--===========================================================================
--SRS Patient Referrals Detail
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_PatientReferralsDetail
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@ServiceLocationID int = NULL,
	@ReferringProviderID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	SET NOCOUNT ON
	
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))

	--No voided claims
	IF @ProviderID >= 0
	BEGIN
		SELECT	RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '') AS ProviderFullname,
				RTRIM(ISNULL(RP.LastName + ', ', '') + ISNULL(RP.FirstName,'') + ISNULL(' ' + RP.MiddleName, '')) AS ReferringProviderFullname,
				RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS PatientFullname,
				SL.Name AS LocationName,
				ICP.PlanName,
				T.*
		FROM 
			(
			SELECT E.DoctorID,
				PC.ReferringPhysicianID, 
				E.PatientID,
				E.PatientCaseID,
				E.LocationID, 
				SUM(ISNULL(EP.ServiceUnitCount,0) * EP.ServiceChargeAmount) AS TotalCharges
			FROM PatientCase PC 
			INNER JOIN Encounter E ON PC.PatientCaseID=E.PatientCaseID
			INNER JOIN EncounterProcedure EP ON E.EncounterID=EP.EncounterID
			INNER JOIN Claim C ON EP.EncounterProcedureID=C.EncounterProcedureID
			LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
			WHERE PC.PracticeID = @PracticeID
				AND C.PracticeID = @PracticeID
				AND VC.ClaimID IS NULL 
				AND E.PracticeID = @PracticeID
				AND E.DateOfService BETWEEN @BeginDate and @EndDate
				AND EP.PracticeID = @PracticeID
				AND PC.ReferringPhysicianID IS NOT NULL
				AND (PC.ReferringPhysicianID = @ReferringProviderID OR ISNULL(@ReferringProviderID,0) = 0)
				AND ((E.DoctorID = @ProviderID) OR (ISNULL(@ProviderID,0) = 0))
				AND (E.LocationID = @ServiceLocationID OR ISNULL(@ServiceLocationID,0) = 0)
				
			GROUP BY E.DoctorID, PC.ReferringPhysicianID, E.PatientID, E.PatientCaseID, E.LocationID
			) T
			INNER JOIN Doctor RP
			ON T.ReferringPhysicianID = RP.DoctorID
			INNER JOIN ServiceLocation SL
			ON T.LocationID = SL.ServiceLocationID
			INNER JOIN Doctor D
			ON T.DoctorID = D.DoctorID
			INNER JOIN Patient P
			ON T.PatientID = P.PatientID
			LEFT JOIN InsurancePolicy IP ON T.PatientCaseID=IP.PatientCaseID
			AND 1=IP.Precedence
			LEFT JOIN InsuranceCompanyPlan ICP
			ON IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
	END
	ELSE
	BEGIN
		--ProviderID should be -1 to NOT GROUP BY provider
		--All Providers
		SELECT	
				RTRIM(ISNULL(RP.LastName + ', ', '') + ISNULL(RP.FirstName,'') + ISNULL(' ' + RP.MiddleName, '')) AS ReferringProviderFullname,
				RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS PatientFullname,
				SL.Name AS LocationName,
				ICP.PlanName,
				T.*
		FROM 
			(
			SELECT 
				PC.ReferringPhysicianID, 
				E.PatientID,
				E.PatientCaseID, 
				E.LocationID, 
				SUM(ISNULL(EP.ServiceUnitCount,0) * EP.ServiceChargeAmount) AS TotalCharges
			FROM PatientCase PC 
				INNER JOIN Encounter E ON PC.PatientCaseID = E.PatientCaseID
				INNER JOIN EncounterProcedure EP ON E.EncounterID=EP.EncounterID
				INNER JOIN Claim C ON EP.EncounterProcedureID=C.EncounterProcedureID
				LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
			WHERE PC.PracticeID = @PracticeID
				AND C.PracticeID = @PracticeID
				AND VC.ClaimID IS NULL 
				AND E.PracticeID = @PracticeID
				AND E.DateOfService BETWEEN @BeginDate and @EndDate
				AND EP.PracticeID = @PracticeID
				AND PC.ReferringPhysicianID IS NOT NULL
				AND (PC.ReferringPhysicianID = @ReferringProviderID OR ISNULL(@ReferringProviderID,0) = 0)
				AND (E.LocationID = @ServiceLocationID OR ISNULL(@ServiceLocationID,0) = 0)
			GROUP BY PC.ReferringPhysicianID, E.PatientID, E.PatientCaseID, E.LocationID
			) T
			INNER JOIN dbo.Doctor RP
			ON T.ReferringPhysicianID = RP.DoctorID
			INNER JOIN dbo.ServiceLocation SL
			ON T.LocationID = SL.ServiceLocationID
			INNER JOIN dbo.Patient P
			ON T.PatientID = P.PatientID
			LEFT JOIN InsurancePolicy IP ON T.PatientCaseID=IP.PatientCaseID
			AND 1=IP.Precedence
			LEFT JOIN InsuranceCompanyPlan ICP
			ON IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
	END
	
	SET NOCOUNT OFF
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

