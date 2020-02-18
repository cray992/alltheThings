SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_PatientReferralsSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_PatientReferralsSummary]
GO


--===========================================================================
-- SRS Patient Referrals Detail
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_PatientReferralsSummary
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@ServiceLocationID int = NULL,
	@GroupByLocation bit = 1,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	SET @BeginDate =  dbo.fn_DateOnly(@BeginDate)
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))

	--No voided claims
	IF @ProviderID >= 0
	BEGIN
		IF @GroupByLocation = 1
		BEGIN
			SELECT	RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '') AS ProviderFullname,
					RTRIM(ISNULL(RP.LastName + ', ', '') + ISNULL(RP.FirstName,'') + ISNULL(' ' + RP.MiddleName, '')) AS ReferringProviderFullname,
					SL.Name AS LocationName,
					T.*
			FROM 
				(
				SELECT E.DoctorID,
					PC.ReferringPhysicianID, 
					E.LocationID, 
					COUNT(DISTINCT E.PatientID) AS ReferralCount,
					SUM(ISNULL(EP.ServiceUnitCount,0) * EP.ServiceChargeAmount) AS TotalCharges
				FROM Claim C 
				INNER JOIN EncounterProcedure EP 
					ON C.PracticeID = EP.PracticeID
					AND C.EncounterProcedureID = EP.EncounterProcedureID
				INNER JOIN Encounter E 
					ON EP.PracticeID = E.PracticeID
					AND EP.EncounterID = E.EncounterID
				INNER JOIN PatientCase PC 
					ON PC.PracticeID = E.PracticeID
					AND E.PatientCaseID = PC.PatientCaseID
				WHERE C.PracticeID = @PracticeID 
					AND C.ClaimID NOT IN
					(	SELECT CT.ClaimID
						FROM dbo.ClaimTransaction CT
						WHERE CT.ClaimTransactionTypeCode = 'XXX'
					)
					AND E.DateOfService BETWEEN @BeginDate and @EndDate 
					AND ((E.DoctorID = @ProviderID) OR (ISNULL(@ProviderID,0) = 0))
					AND (E.LocationID = @ServiceLocationID OR ISNULL(@ServiceLocationID,0) = 0)
					AND PC.ReferringPhysicianID IS NOT NULL
				GROUP BY E.DoctorID, PC.ReferringPhysicianID, E.LocationID
				) T
				INNER JOIN Doctor RP
				ON T.ReferringPhysicianID = RP.DoctorID
				INNER JOIN ServiceLocation SL
				ON T.LocationID = SL.ServiceLocationID
				INNER JOIN Doctor D
				ON T.DoctorID = D.DoctorID
		END
		ELSE
		BEGIN
			SELECT	RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '') AS ProviderFullname,
					RTRIM(ISNULL(RP.LastName + ', ', '') + ISNULL(RP.FirstName,'') + ISNULL(' ' + RP.MiddleName, '')) AS ReferringProviderFullname,
					T.*
			FROM 
				(
				SELECT E.DoctorID,
					PC.ReferringPhysicianID, 
					COUNT(DISTINCT E.PatientID) AS ReferralCount,
					SUM(ISNULL(EP.ServiceUnitCount,0) * EP.ServiceChargeAmount) AS TotalCharges
				FROM Claim C 
				INNER JOIN EncounterProcedure EP 
					ON C.PracticeID = EP.PracticeID
					AND C.EncounterProcedureID = EP.EncounterProcedureID
				INNER JOIN Encounter E 
					ON EP.PracticeID = E.PracticeID
					AND EP.EncounterID = E.EncounterID
				INNER JOIN PatientCase PC 
					ON E.PracticeID = PC.PracticeID
					AND E.PatientCaseID = PC.PatientCaseID
				WHERE C.PracticeID = @PracticeID 
					AND C.ClaimID NOT IN
					(	SELECT CT.ClaimID
						FROM dbo.ClaimTransaction CT
						WHERE CT.ClaimTransactionTypeCode = 'XXX'
					)
					AND E.DateOfService BETWEEN @BeginDate and @EndDate 
					AND ((E.DoctorID = @ProviderID) OR (ISNULL(@ProviderID,0) = 0))
					AND (E.LocationID = @ServiceLocationID OR ISNULL(@ServiceLocationID,0) = 0)
					AND PC.ReferringPhysicianID IS NOT NULL
				GROUP BY E.DoctorID, PC.ReferringPhysicianID
				) T
				INNER JOIN Doctor RP
				ON T.ReferringPhysicianID = RP.DoctorID
				INNER JOIN Doctor D
				ON T.DoctorID = D.DoctorID
		END
	END
	ELSE
	BEGIN
		--All Providers
		IF @GroupByLocation = 1
		BEGIN
			SELECT	RTRIM(ISNULL(RP.LastName + ', ', '') + ISNULL(RP.FirstName,'') + ISNULL(' ' + RP.MiddleName, '')) AS ReferringProviderFullname,
					SL.Name AS LocationName,
					T.*
			FROM 
				(
				SELECT 	PC.ReferringPhysicianID, 
					E.LocationID, 
					COUNT(DISTINCT E.PatientID) AS ReferralCount,
					SUM(ISNULL(EP.ServiceUnitCount,0) * EP.ServiceChargeAmount) AS TotalCharges
				FROM Claim C 
				INNER JOIN EncounterProcedure EP 
					ON C.PracticeID = EP.PracticeID
					AND C.EncounterProcedureID = EP.EncounterProcedureID
				INNER JOIN Encounter E 
					ON EP.PracticeID = E.PracticeID
					AND EP.EncounterID = E.EncounterID
				INNER JOIN PatientCase PC 
					ON E.PracticeID = PC.PracticeID
					AND E.PatientCaseID = PC.PatientCaseID
				WHERE C.PracticeID = @PracticeID 
					AND C.ClaimID NOT IN
					(	SELECT CT.ClaimID
						FROM dbo.ClaimTransaction CT
						WHERE CT.ClaimTransactionTypeCode = 'XXX'
					)
					AND E.DateOfService BETWEEN @BeginDate and @EndDate 
					AND (E.LocationID = @ServiceLocationID OR ISNULL(@ServiceLocationID,0) = 0)
					AND PC.ReferringPhysicianID IS NOT NULL
				GROUP BY PC.ReferringPhysicianID, E.LocationID
				) T
				INNER JOIN Doctor RP
				ON T.ReferringPhysicianID = RP.DoctorID
				INNER JOIN ServiceLocation SL
				ON T.LocationID = SL.ServiceLocationID
		END 
		ELSE
		BEGIN
			SELECT	RTRIM(ISNULL(RP.LastName + ', ', '') + ISNULL(RP.FirstName,'') + ISNULL(' ' + RP.MiddleName, '')) AS ReferringProviderFullname,
					T.*
			FROM 
				(
				SELECT 	PC.ReferringPhysicianID, 
					COUNT(DISTINCT E.PatientID) AS ReferralCount,
					SUM(ISNULL(EP.ServiceUnitCount,0) * EP.ServiceChargeAmount) AS TotalCharges
				FROM Claim C 
				INNER JOIN EncounterProcedure EP 
					ON EP.PracticeID = C.PracticeID
					AND C.EncounterProcedureID = EP.EncounterProcedureID
				INNER JOIN Encounter E 
					ON E.PracticeID = EP.PracticeID
					AND EP.EncounterID = E.EncounterID
				INNER JOIN PatientCase PC 
					ON PC.PracticeID = E.PracticeID
					AND E.PatientCaseID = PC.PatientCaseID
				WHERE C.PracticeID = @PracticeID 
					AND C.ClaimID NOT IN
					(	SELECT CT.ClaimID
						FROM dbo.ClaimTransaction CT
						WHERE CT.ClaimTransactionTypeCode = 'XXX'
					)
					AND E.DateOfService BETWEEN @BeginDate and @EndDate 
					AND (E.LocationID = @ServiceLocationID OR ISNULL(@ServiceLocationID,0) = 0)
					AND PC.ReferringPhysicianID IS NOT NULL
				GROUP BY PC.ReferringPhysicianID
				) T
				INNER JOIN Doctor RP
				ON T.ReferringPhysicianID = RP.DoctorID
		END
	END
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

