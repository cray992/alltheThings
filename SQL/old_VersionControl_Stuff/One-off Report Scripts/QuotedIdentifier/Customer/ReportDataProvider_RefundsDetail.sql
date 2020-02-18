SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
IF EXISTS(	SELECT *
			FROM INFORMATION_SCHEMA.ROUTINES R
			WHERE R.ROUTINE_NAME = 'ReportDataProvider_RefundsDetail'
		)
	DROP PROCEDURE dbo.ReportDataProvider_RefundsDetail
GO
--===========================================================================
-- SRS Refunds Detail
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_RefundsDetail
	@PracticeID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@PaymentMethodCode varchar(1) = ''
AS
BEGIN
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))

	SELECT PMC.Description AS PaymentMethodType, 
		R.ReferenceNumber,
		R.PostingDate RefundDate,
		CASE WHEN R.RecipientTypeCode = 'P' THEN CAST('Patient' AS varchar(9))
		     WHEN R.RecipientTypeCode = 'I' THEN CAST('Insurance' AS varchar(9))
		     ELSE CAST('Other' AS varchar(9))
		     END AS RecipientType,
		CASE WHEN R.RecipientTypeCode = 'P' THEN RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) 
		     WHEN R.RecipientTypeCode = 'I' THEN ICP.PlanName 
		     ELSE O.OtherName
		     END AS RecipientName,
		R.RecipientID,
		RSC.Description AS Status,
		ISNULL(R.RefundAmount,0) AS RefundAmount
	FROM dbo.Refund R
		INNER JOIN dbo.PaymentMethodCode PMC
		ON R.PaymentMethodCode = PMC.PaymentMethodCode
			AND @PracticeID = R.PracticeID
			AND R.PostingDate BETWEEN @BeginDate AND @EndDate
		INNER JOIN dbo.RefundStatusCode RSC
		ON R.RefundStatusCode = RSC.RefundStatusCode
		LEFT OUTER JOIN dbo.Patient P
		ON R.RecipientID = P.PatientID
			AND R.RecipientTypeCode = 'P'
		LEFT OUTER JOIN dbo.InsuranceCompanyPlan ICP
		ON R.RecipientID = ICP.InsuranceCompanyPlanID
			AND R.RecipientTypeCode = 'I'
		LEFT OUTER JOIN dbo.Other O
		ON R.RecipientID = O.OtherID
			AND R.RecipientTypeCode = 'O'
	WHERE ((PMC.PaymentMethodCode = @PaymentMethodCode) OR (ISNULL(RTRIM(@PaymentMethodCode),'')=''))
		
	RETURN
END
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

