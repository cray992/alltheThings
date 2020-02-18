SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ReportDoctorIncomeReviewXML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_ReportDoctorIncomeReviewXML]
GO

/*
--===========================================================================
-- REPORT DOCTOR INCOME REVIEW XML
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ReportDoctorIncomeReviewXML
	@doctor_id INT
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--Create a temp table of transactions.
	SELECT	C.RenderingProviderID AS DoctorID,
		CT.ClaimID,
		'PAY' AS TypeCode,
		COALESCE(CT.ReferenceDate,CT.TransactionDate) AS TransactionDate,
		COALESCE(CT.Amount,0) AS Amount
	INTO	#ReportTransactions
	FROM	Claim C
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode = 'PAY'
	WHERE	C.RenderingProviderID = @doctor_id
	AND	YEAR(COALESCE(CT.ReferenceDate,CT.TransactionDate)) >= YEAR(GETDATE()) - 1


	--Create a temp table of monthly income data.
	CREATE TABLE #DoctorIncomeData (
		DatumDate DATETIME,
		ReceiptAmount MONEY,
		RefundAmount MONEY
	)

	DECLARE @start_date DATETIME
	DECLARE @end_date DATETIME
	SET @start_date = CAST(CAST(YEAR(GETDATE()) - 1 AS VARCHAR) AS DATETIME)
	SET @end_date = DATEADD(month, 1, @start_date)

	DECLARE @count INT
	SET @count = 0
	WHILE (@count < 24)
	BEGIN
		INSERT	#DoctorIncomeData
		SELECT	@start_date,
			COALESCE(
				SUM(
					CASE
					WHEN RT.TypeCode = 'PAY' THEN RT.Amount
					ELSE 0
					END),
				0),
			0
		FROM	#ReportTransactions RT
		WHERE	RT.TransactionDate BETWEEN @start_date AND @end_date

		SET @start_date = @end_date
		SET @end_date = DATEADD(month, 1, @start_date)

		SET @count = @count + 1
	END

	SELECT	1 AS Tag, NULL AS Parent,
		1 AS [report!1!report-ind],
		GETDATE() AS [report!1!report-date],
		YEAR(GETDATE()) AS [report!1!current-year],
		YEAR(GETDATE()) - 1 AS [report!1!previous-year],
		D.FirstName AS [report!1!doctor-first-name],
		D.MiddleName AS [report!1!doctor-middle-name],
		D.LastName AS [report!1!doctor-last-name],
		D.Suffix AS [report!1!doctor-suffix],
		D.Degree AS [report!1!doctor-degree],
		NULL AS [datum!2!datum-ind],
		NULL AS [datum!2!date],
		NULL AS [datum!2!receipt-amount],
		NULL AS [datum!2!refund-amount]
	FROM	Doctor D
	WHERE	D.DoctorID = @doctor_id
	UNION ALL
	SELECT	2 AS Tag, 1 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!current-year],
		NULL AS [report!1!previous-year],
		NULL AS [report!1!doctor-first-name],
		NULL AS [report!1!doctor-middle-name],
		NULL AS [report!1!doctor-last-name],
		NULL AS [report!1!doctor-suffix],
		NULL AS [report!1!doctor-degree],
		1 AS [datum!2!datum-ind],
		DatumDate AS [datum!2!date],
		ReceiptAmount AS [datum!2!receipt-amount],
		RefundAmount AS [datum!2!refund-amount]
	FROM	#DoctorIncomeData
	ORDER BY [report!1!report-ind],
		[datum!2!datum-ind],
		[datum!2!date]
	FOR XML EXPLICIT

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
*/

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

