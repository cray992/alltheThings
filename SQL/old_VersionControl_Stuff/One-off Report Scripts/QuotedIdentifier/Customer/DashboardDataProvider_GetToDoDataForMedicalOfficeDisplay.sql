SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardDataProvider_GetToDoDataForMedicalOfficeDisplay]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DashboardDataProvider_GetToDoDataForMedicalOfficeDisplay]
GO


CREATE PROCEDURE dbo.DashboardDataProvider_GetToDoDataForMedicalOfficeDisplay
	@PracticeID int = 34
AS
BEGIN
	DECLARE @flat TABLE (
		[PracticeID] [int] NULL ,
		NeedContactInfo bit default(0),
		NeedProviders bit default(0),
		NeedProviderNumbers bit default(0),
		NeedGroupNumber bit default(0),
		CountPatientScheduledForAppointments int default(0),
		CountDraftEncounters int default(0),
		CountRejectedEncounters int default(0),
		CountMobileEncounters int default(0),
		NeedReviewReports bit default(1),
		KFaxDnis char(10) default('')
	)
	
	--
	INSERT @flat (PracticeID)
	VALUES(@PracticeID)

	--Contact Info
	IF EXISTS(
				SELECT *
				FROM dbo.Practice P
				WHERE P.PracticeID = @PracticeID
					AND (
						isnull(LEN(P.AddressLine1), 0) = 0
						OR isnull(LEN(P.City), 0) = 0
						OR isnull(LEN(P.State), 0) = 0
						OR isnull(LEN(P.ZipCode), 0) = 0
						OR isnull(LEN(P.Phone), 0) < 10
						OR isnull(LEN(P.Fax), 0) < 10
						OR isnull(LEN(P.EIN), 0) < 9
					)
				)
	BEGIN
		UPDATE @flat
			SET NeedContactInfo = 1
	END
	
	--Providers
	IF NOT EXISTS(
				SELECT *
				FROM dbo.Doctor D
				WHERE D.PracticeID = @PracticeID
					AND D.[External] = 0
				)
	BEGIN
		UPDATE @flat
			SET NeedProviders = 1
	END	
	
	--NeedProviderNumbers
	IF EXISTS(
				SELECT *
				FROM dbo.Doctor D
				WHERE D.PracticeID = @PracticeID
					AND D.[External] = 0
					AND NOT EXISTS (SELECT *
									FROM dbo.ProviderNumber PN
									WHERE PN.DoctorID = D.DoctorID)
				)
	BEGIN
		UPDATE @flat
			SET NeedProviderNumbers = 1
	END	

	--NeedGroupNumber
	IF NOT EXISTS(
				SELECT *
				FROM dbo.PracticeInsuranceGroupNumber PIGN
				WHERE PIGN.PracticeID = @PracticeID
				)
	BEGIN
		UPDATE @flat
			SET NeedGroupNumber = 1
	END	

	UPDATE @flat
		SET CountPatientScheduledForAppointments = (SELECT COUNT(*)
													FROM dbo.Appointment A
													WHERE A.PracticeID = @PracticeID
														AND A.AppointmentType = 'P'
														AND A.StartDate BETWEEN dbo.fn_DateOnly(GETDATE()) AND DATEADD(ms,-10,dbo.fn_DateOnly(GETDATE()) + 1)
													)
									
	UPDATE @flat
		SET CountDraftEncounters = (SELECT COUNT(*)
									FROM dbo.Encounter E
									WHERE E.PracticeID = @PracticeID
										AND E.EncounterStatusID = 1
									)

	UPDATE @flat
		SET CountRejectedEncounters = (SELECT COUNT(*)
										FROM dbo.Encounter E
										WHERE E.PracticeID = @PracticeID
											AND E.EncounterStatusID = 4
									   )

	UPDATE @flat
		SET CountMobileEncounters = (SELECT COUNT(*)
									FROM dbo.HandheldEncounter HE
									WHERE HE.PracticeID = @PracticeID
										AND HE.ReviewStatus = 'N'
									)

	
	UPDATE @flat
		SET KFaxDnis = (SELECT DNIS 
						FROM Practice PT
						WHERE PT.PracticeID = @PracticeID AND PT.DNIS IS NOT NULL)
	--Get the data			
	SELECT *
	FROM @flat
	
	RETURN
END
