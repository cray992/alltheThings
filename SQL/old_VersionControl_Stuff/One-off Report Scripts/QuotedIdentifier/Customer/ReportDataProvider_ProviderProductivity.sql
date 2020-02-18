SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ProviderProductivity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_ProviderProductivity]
GO


--===========================================================================
-- SRS 
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ProviderProductivity
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@ServiceLocationID int = 0,
	@GroupByLocation bit = 1,
	@GroupByProvider bit = 1,
	@DateType CHAR(1),
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@BatchID varchar(50) = NULL
AS
BEGIN
	SET @EndDate=DATEADD(S,-1,DATEADD(D,1,@EndDate))

	IF @GroupByLocation = 1 AND @GroupByProvider = 1
	BEGIN 
		SELECT RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '') AS ProviderFullname,
			T.*
		FROM dbo.Doctor D
			INNER JOIN 
				(SELECT PCD.ProcedureCode, 
					PCD.OfficialName ProcedureName, 
					E.DoctorID,	
					SL.Name AS Location,
					CAST(SUM(ISNULL(EP.ServiceUnitCount,0)) AS int) AS UnitCount, 
					CAST(SUM(ISNULL(EP.ServiceUnitCount,0) * ISNULL(EP.ServiceChargeAmount,0)) AS money) AS ServiceCharge,
				0 AS Sort
				FROM Encounter E 
				INNER JOIN EncounterProcedure EP 
					ON E.PracticeID = EP.PracticeID 
					AND E.EncounterID = EP.EncounterID
				INNER JOIN Claim C
					ON EP.PracticeID = C.PracticeID
					AND EP.EncounterProcedureID = C.EncounterProcedureID					
				INNER JOIN ProcedureCodeDictionary PCD ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
				INNER JOIN ServiceLocation SL ON E.LocationID = SL.ServiceLocationID
				LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
				WHERE E.PracticeID = @PracticeID AND VC.ClaimID IS NULL 
					AND ((EP.ProcedureDateOfService BETWEEN @BeginDate AND @EndDate AND @DateType='D')
					 OR (E.PostingDate BETWEEN @BeginDate AND @EndDate AND @DateType='P'))
					AND ((E.DoctorID = @ProviderID) OR (ISNULL(@ProviderID,0) = 0))
					AND ((E.LocationID = @ServiceLocationID OR ISNULL(@ServiceLocationID,0) = 0))
					AND ((E.BatchID = @BatchID) OR (@BatchID IS NULL))
				GROUP BY 	
					PCD.ProcedureCode, 
					PCD.OfficialName, 
					E.DoctorID,	
					SL.Name) T
			ON D.DoctorID = T.DoctorID

		UNION

		SELECT RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '') AS ProviderFullname,
			T.*
		FROM dbo.Doctor D
			INNER JOIN 
				(SELECT PCD.ProcedureCode, 
					PCD.OfficialName ProcedureName, 
					E.DoctorID,	
					'All Locations' AS Location,
					CAST(SUM(ISNULL(EP.ServiceUnitCount,0)) AS int) AS UnitCount, 
					CAST(SUM(ISNULL(EP.ServiceUnitCount,0) * ISNULL(EP.ServiceChargeAmount,0)) AS money) AS ServiceCharge,
				1 AS Sort
				FROM Encounter E 
				INNER JOIN EncounterProcedure EP 
					ON E.PracticeID=EP.PracticeID 
					AND E.EncounterID=EP.EncounterID
				INNER JOIN Claim C
					ON C.PracticeID = EP.PracticeID
					AND EP.EncounterProcedureID=C.EncounterProcedureID					
				INNER JOIN ProcedureCodeDictionary PCD ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
				INNER JOIN ServiceLocation SL ON E.LocationID = SL.ServiceLocationID
				LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
				WHERE E.PracticeID = @PracticeID AND VC.ClaimID IS NULL 
					AND ((EP.ProcedureDateOfService BETWEEN @BeginDate AND @EndDate AND @DateType='D')
					 OR (E.PostingDate BETWEEN @BeginDate AND @EndDate AND @DateType='P'))
					AND ((E.DoctorID = @ProviderID) OR (ISNULL(@ProviderID,0) = 0))
					AND ISNULL(@ServiceLocationID,0) = 0
					AND ((E.BatchID = @BatchID) OR (@BatchID IS NULL))
				GROUP BY 	
					PCD.ProcedureCode, 
					PCD.OfficialName, 
					E.DoctorID) T
			ON D.DoctorID = T.DoctorID
		ORDER BY
			T.Sort,
			T.Location
	END 
	ELSE IF @GroupByLocation = 1
	BEGIN
		SELECT PCD.ProcedureCode, 
					PCD.OfficialName ProcedureName, 
					SL.Name AS Location,
					CAST(SUM(ISNULL(EP.ServiceUnitCount,0)) AS int) AS UnitCount, 
					CAST(SUM(ISNULL(EP.ServiceUnitCount,0) * ISNULL(EP.ServiceChargeAmount,0)) AS money) AS ServiceCharge,
				0 AS Sort
				FROM Encounter E 
				INNER JOIN EncounterProcedure EP 
					ON E.PracticeID = EP.PracticeID 
					AND E.EncounterID = EP.EncounterID
				INNER JOIN Claim C
					ON EP.PracticeID = C.PracticeID
					AND EP.EncounterProcedureID=C.EncounterProcedureID					
				INNER JOIN ProcedureCodeDictionary PCD ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
				INNER JOIN ServiceLocation SL ON E.LocationID = SL.ServiceLocationID
				LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
				WHERE E.PracticeID = @PracticeID AND VC.ClaimID IS NULL 
					AND ((EP.ProcedureDateOfService BETWEEN @BeginDate AND @EndDate AND @DateType='D')
					 OR (E.PostingDate BETWEEN @BeginDate AND @EndDate AND @DateType='P'))
					AND ((E.DoctorID = @ProviderID) OR (ISNULL(@ProviderID,0) = 0))
					AND ((E.LocationID = @ServiceLocationID OR ISNULL(@ServiceLocationID,0) = 0))
					AND ((E.BatchID = @BatchID) OR (@BatchID IS NULL))
				GROUP BY 	
					PCD.ProcedureCode, 
					PCD.OfficialName, 
					SL.Name
		UNION

		SELECT PCD.ProcedureCode, 
					PCD.OfficialName ProcedureName, 
					'All Locations' AS Location,
					CAST(SUM(ISNULL(EP.ServiceUnitCount,0)) AS int) AS UnitCount, 
					CAST(SUM(ISNULL(EP.ServiceUnitCount,0) * ISNULL(EP.ServiceChargeAmount,0)) AS money) AS ServiceCharge,
				1 AS Sort
				FROM Encounter E 
				INNER JOIN EncounterProcedure EP 
					ON E.PracticeID=EP.PracticeID 
					AND E.EncounterID=EP.EncounterID
				INNER JOIN Claim C
					ON EP.PracticeID = C.PracticeID
					AND EP.EncounterProcedureID=C.EncounterProcedureID					
				INNER JOIN ProcedureCodeDictionary PCD ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
				INNER JOIN ServiceLocation SL ON E.LocationID = SL.ServiceLocationID
				LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
				WHERE E.PracticeID = @PracticeID AND VC.ClaimID IS NULL 
					AND ((EP.ProcedureDateOfService BETWEEN @BeginDate AND @EndDate AND @DateType='D')
					 OR (E.PostingDate BETWEEN @BeginDate AND @EndDate AND @DateType='P'))
					AND ((E.DoctorID = @ProviderID) OR (ISNULL(@ProviderID,0) = 0))
					AND ISNULL(@ServiceLocationID,0) = 0
					AND ((E.BatchID = @BatchID) OR (@BatchID IS NULL))
				GROUP BY 	
					PCD.ProcedureCode, 
					PCD.OfficialName
		ORDER BY
			Sort,
			Location
	END
	ELSE IF @GroupByProvider = 1
	BEGIN

		SELECT RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '') AS ProviderFullname,
			T.*
		FROM dbo.Doctor D
			INNER JOIN 
				(SELECT PCD.ProcedureCode, 
					PCD.OfficialName ProcedureName, 
					E.DoctorID,
					CAST(SUM(ISNULL(EP.ServiceUnitCount,0)) AS int) AS UnitCount, 
					CAST(SUM(ISNULL(EP.ServiceUnitCount,0) * ISNULL(EP.ServiceChargeAmount,0)) AS money) AS ServiceCharge
				FROM Encounter E 
				INNER JOIN EncounterProcedure EP 
					ON E.PracticeID = EP.PracticeID 
					AND E.EncounterID = EP.EncounterID
				INNER JOIN Claim C
					ON EP.PracticeID = C.PracticeID
					AND EP.EncounterProcedureID = C.EncounterProcedureID					
				INNER JOIN ProcedureCodeDictionary PCD ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
				INNER JOIN ServiceLocation SL ON E.LocationID = SL.ServiceLocationID
				LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
				WHERE E.PracticeID = @PracticeID AND VC.ClaimID IS NULL 
					AND ((EP.ProcedureDateOfService BETWEEN @BeginDate AND @EndDate AND @DateType='D')
					 OR (E.PostingDate BETWEEN @BeginDate AND @EndDate AND @DateType='P'))
					AND ((E.DoctorID = @ProviderID) OR (ISNULL(@ProviderID,0) = 0))
					AND ((E.LocationID = @ServiceLocationID OR ISNULL(@ServiceLocationID,0) = 0))
					AND ((E.BatchID = @BatchID) OR (@BatchID IS NULL))
				GROUP BY 	
					PCD.ProcedureCode, 
					PCD.OfficialName, 
					E.DoctorID) T
			ON D.DoctorID = T.DoctorID
	END
	ELSE
	BEGIN

		SELECT PCD.ProcedureCode, 
					PCD.OfficialName ProcedureName,
					CAST(SUM(ISNULL(EP.ServiceUnitCount,0)) AS int) AS UnitCount, 
					CAST(SUM(ISNULL(EP.ServiceUnitCount,0) * ISNULL(EP.ServiceChargeAmount,0)) AS money) AS ServiceCharge
				FROM Encounter E 
				INNER JOIN EncounterProcedure EP 
					ON E.PracticeID = EP.PracticeID 
					AND E.EncounterID = EP.EncounterID
				INNER JOIN Claim C
					ON EP.PracticeID = C.PracticeID
					AND EP.EncounterProcedureID = C.EncounterProcedureID					
				INNER JOIN ProcedureCodeDictionary PCD ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
				LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
				WHERE E.PracticeID = @PracticeID AND VC.ClaimID IS NULL 
					AND ((EP.ProcedureDateOfService BETWEEN @BeginDate AND @EndDate AND @DateType='D')
					 OR (E.PostingDate BETWEEN @BeginDate AND @EndDate AND @DateType='P'))
					AND ((E.DoctorID = @ProviderID) OR (ISNULL(@ProviderID,0) = 0))
					AND ((E.LocationID = @ServiceLocationID OR ISNULL(@ServiceLocationID,0) = 0))
					AND ((E.BatchID = @BatchID) OR (@BatchID IS NULL))
				GROUP BY 	
					PCD.ProcedureCode, 
					PCD.OfficialName
	END	
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

