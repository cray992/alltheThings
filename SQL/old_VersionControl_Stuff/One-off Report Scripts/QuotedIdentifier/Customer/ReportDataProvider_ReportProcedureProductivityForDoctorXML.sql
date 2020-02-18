SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ReportProcedureProductivityForDoctorXML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_ReportProcedureProductivityForDoctorXML]
GO

/*
--===========================================================================
-- REPORT PROCEDURE PRODUCTIVITY FOR DOCTOR
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ReportProcedureProductivityForDoctorXML
	@doctor_id INT,
	@start_date DATETIME,
	@end_date DATETIME
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--Create a temp table of transactions.
	SELECT	C.RenderingProviderID AS DoctorID,
		C.ProcedureCode,
		C.ClaimID,
		COALESCE(C.ServiceUnitCount,1) AS UnitCount,
		COALESCE(C.ServiceChargeAmount,0) AS ChargeAmount
	INTO	#ReportTransactions
	FROM	Claim C
	WHERE	C.RenderingProviderID = @doctor_id
	AND	C.ServiceBeginDate BETWEEN @start_date AND @end_date

	--Create a temp table of procedure totals.
	SELECT	RT.ProcedureCode,
		SUM(RT.UnitCount) AS PeriodUnitCount,
		SUM(RT.ChargeAmount * RT.UnitCount) AS PeriodChargeAmount
	INTO	#ProcedureTotals
	FROM	#ReportTransactions RT
	GROUP BY RT.ProcedureCode

	--Create a temp table of doctor totals.
	SELECT	RT.DoctorID,
		SUM(RT.UnitCount) AS PeriodUnitCount,
		SUM(RT.ChargeAmount * RT.UnitCount) AS PeriodChargeAmount
	INTO 	#DoctorTotals
	FROM	#ReportTransactions RT
	GROUP BY RT.DoctorID

	SELECT	1 AS Tag, NULL AS Parent,
		1 AS [report!1!report-ind],
		GETDATE() AS [report!1!report-date],
		@start_date AS [report!1!period-start-date],
		@end_date AS [report!1!period-end-date],
		D.DoctorID AS [report!1!doctor-id],
		D.FirstName AS [report!1!doctor-first-name],
		D.MiddleName AS [report!1!doctor-middle-name],
		D.LastName AS [report!1!doctor-last-name],
		D.Suffix AS [report!1!doctor-suffix],
		D.Degree AS [report!1!doctor-degree],
		COALESCE(DT.PeriodUnitCount,0)
			AS [report!1!total-unit-count],
		COALESCE(DT.PeriodChargeAmount,0)
			AS [report!1!total-charge-amount],
		COALESCE(
			CASE
			WHEN DT.PeriodUnitCount = 0 THEN 0
			ELSE DT.PeriodChargeAmount / DT.PeriodUnitCount
			END,
			0
			) AS [report!1!average-charge-amount],
		NULL AS [procedure!2!procedure-ind],
		NULL AS [procedure!2!procedure-code],
		NULL AS [procedure!2!description],
		NULL AS [procedure!2!total-unit-count],
		NULL AS [procedure!2!total-charge-amount],
		NULL AS [procedure!2!unit-percentage],
		NULL AS [procedure!2!charge-percentage],
		NULL AS [procedure!2!average-charge-amount],
		NULL AS [procedure!2!standard-charge-amount]
	FROM	Doctor D
		LEFT OUTER JOIN #DoctorTotals DT
		ON	DT.DoctorID = D.DoctorID
	WHERE	D.DoctorID = @doctor_id
	UNION ALL
	SELECT	2 AS Tag, 1 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!period-end-date],
		NULL AS [report!1!doctor-id],
		NULL AS [report!1!doctor-first-name],
		NULL AS [report!1!doctor-middle-name],
		NULL AS [report!1!doctor-last-name],
		NULL AS [report!1!doctor-suffix],
		NULL AS [report!1!doctor-degree],
		NULL AS [report!1!total-unit-count],
		NULL AS [report!1!total-charge-amount],
		NULL AS [report!1!average-charge-amount],
		1 AS [procedure!2!procedure-ind],
		PT.ProcedureCode 
			AS [procedure!2!procedure-code],
		PCD.ProcedureName 
			AS [procedure!2!description],
		COALESCE(PT.PeriodUnitCount,0)
			AS [procedure!2!total-unit-count],
		COALESCE(PT.PeriodChargeAmount,0)
			AS [procedure!2!total-charge-amount],
		COALESCE(
			CASE
			WHEN DT.PeriodUnitCount = 0 THEN 0
			ELSE 100 * PT.PeriodUnitCount / DT.PeriodUnitCount
			END,
			0
			) AS [procedure!2!unit-percentage],
		COALESCE(
			CASE
			WHEN DT.PeriodChargeAmount = 0 THEN 0
			ELSE 100 * PT.PeriodChargeAmount / DT.PeriodChargeAmount
			END,
			0
			) AS [procedure!2!charge-percentage],
		COALESCE(
			CASE
			WHEN PT.PeriodUnitCount = 0 THEN 0
			ELSE PT.PeriodChargeAmount / PT.PeriodUnitCount
			END,
			0
			) AS [procedure!2!average-charge-amount],
		'N/A' AS [procedure!2!standard-charge-amount]
	FROM 	#ProcedureTotals PT
		INNER JOIN #DoctorTotals DT
		ON	1 = 1
		LEFT OUTER JOIN ProcedureCodeDictionary PCD
		ON	PCD.ProcedureCode = PT.ProcedureCode
	ORDER BY [report!1!report-ind],
		[procedure!2!procedure-ind],
		[procedure!2!procedure-code]
	FOR XML EXPLICIT

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
*/
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

