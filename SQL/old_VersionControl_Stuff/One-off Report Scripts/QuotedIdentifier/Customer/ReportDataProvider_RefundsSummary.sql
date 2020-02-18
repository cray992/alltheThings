SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
IF EXISTS(	SELECT *
			FROM INFORMATION_SCHEMA.ROUTINES R
			WHERE R.ROUTINE_NAME = 'ReportDataProvider_RefundsSummary'
		)
	DROP PROCEDURE dbo.ReportDataProvider_RefundsSummary
GO
--===========================================================================
-- SRS Refunds Summary
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_RefundsSummary
	@PracticeID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@PaymentMethodCode varchar(1) = ''
AS
BEGIN
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))

	SELECT PMC.Description AS PaymentMethodType, 
		PMC.PaymentMethodCode, 
		SUM(ISNULL(R.RefundAmount,0)) AS RefundAmount
	FROM dbo.PaymentMethodCode PMC
		LEFT OUTER JOIN dbo.Refund R
		ON PMC.PaymentMethodCode = R.PaymentMethodCode
			AND @PracticeID = R.PracticeID
			AND R.PostingDate BETWEEN @BeginDate AND @EndDate
	WHERE ((PMC.PaymentMethodCode = @PaymentMethodCode) OR (ISNULL(RTRIM(@PaymentMethodCode),'')=''))
	GROUP BY PMC.Description, PMC.PaymentMethodCode
	
	RETURN
END
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

