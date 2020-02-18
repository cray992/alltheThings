SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_PaymentsDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_PaymentsDetail]
GO



--===========================================================================
-- SRS Payment Detail
--===========================================================================
--ReportDataProvider_PaymentsDetail 13,NULL,'5/1/2006','5/31/2006'
CREATE PROCEDURE dbo.ReportDataProvider_PaymentsDetail
	@PracticeID int = NULL,
	@ProviderID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@PaymentMethodCode varchar(1) = '',
	@PaymentTypeID INT = -1,
	@BatchID varchar(50) = NULL,
	@ReportType char(1) = 'A' -- A=All, U=Unapplied
AS
BEGIN
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))

	CREATE TABLE #Receipts(PaymentID INT, TotalApplied MONEY)
	INSERT INTO #Receipts(PaymentID, TotalApplied)
	SELECT P.PaymentID, SUM(CA.Amount) TotalApplied
	FROM Payment P INNER JOIN PaymentClaimTransaction PCT
	ON P.PracticeID=PCT.PracticeID AND P.PaymentID=PCT.PaymentID
	INNER JOIN ClaimAccounting CA
	ON PCT.PracticeID=CA.PracticeID AND PCT.ClaimID=CA.ClaimID 
	AND PCT.ClaimTransactionID=CA.ClaimTransactionID
	WHERE P.PracticeID=@PracticeID AND P.PostingDate BETWEEN @BeginDate AND @EndDate
	AND CA.ClaimTransactionTypeCode='PAY'
	AND ((ProviderID = @ProviderID) Or (@ProviderID IS NULL))
	GROUP BY P.PaymentID


	CREATE TABLE #Refunds(PaymentID INT, Refund MONEY)
	INSERT INTO #Refunds(PaymentID, Refund)
	SELECT RTP.PaymentID, SUM(RTP.Amount) Refund
	FROM Refund R INNER JOIN RefundToPayments RTP
	ON R.RefundID=RTP.RefundID
	WHERE R.PracticeID=@PracticeID AND R.PostingDate BETWEEN @BeginDate AND @EndDate
	GROUP BY RTP.PaymentID

-------------------------------------------------------------------
	CREATE TABLE #Capitated(PaymentID INT, CapitatedAmount MONEY)
	INSERT INTO #Capitated(PaymentID, CapitatedAmount)
	SELECT CAP.PaymentID, SUM(CAP.Amount) CapitatedAmount
	FROM CapitatedAccount CA INNER JOIN CapitatedAccountToPayment CAP
	ON CA.CapitatedAccountID=CAP.CapitatedAccountID
	WHERE CA.PracticeID=@PracticeID AND CAP.PostingDate BETWEEN @BeginDate AND @EndDate 
	GROUP BY CAP.PaymentID
--------------------------------------------------------------------

	SELECT PT.PaymentID, 
		PMC.Description AS PaymentMethodType,
		PT.PaymentNumber, 
		PT.BatchID,
		PT.PostingDate, 
		CASE WHEN PT.PayerTypeCode = 'P' THEN CAST('Patient' AS varchar(9))
		     WHEN PT.PayerTypeCode = 'I' THEN CAST('Insurance' AS varchar(9))
		     ELSE CAST('Other' AS varchar(9))
		     END AS PayerType,
		CASE WHEN PT.PayerTypeCode = 'P' THEN RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, ''))  + ' (' + CAST(P.PatientID AS varchar(30)) + ')'
		     WHEN PT.PayerTypeCode = 'I' THEN ICP.PlanName + ' (' + CAST(ICP.InsuranceCompanyPlanID AS varchar(30)) + ')'
		     ELSE O.OtherName
		     END AS PayerName,
		PT.PaymentAmount,
		(PT.PaymentAmount - COALESCE(Rec.TotalApplied,0) - COALESCE(R.Refund,0) - COALESCE(C.CapitatedAmount,0)) AS UnAppliedAmount, 
		COALESCE(R.Refund, 0) as RefundAmount,
		pyt.Name as PayementType,
		pyt.SortOrder,		
		PTC.Description PayerTypeCode
	FROM dbo.Payment PT
		LEFT JOIN dbo.Patient P ON PT.PayerID = P.PatientID
		LEFT JOIN dbo.InsuranceCompanyPlan ICP ON PT.PayerID = ICP.InsuranceCompanyPlanID
		LEFT JOIN dbo.Other O ON PT.PayerID = O.OtherID
		INNER JOIN dbo.PaymentMethodCode PMC ON PT.PaymentMethodCode = PMC.PaymentMethodCode 
		LEFT JOIN #Receipts Rec ON PT.PaymentID = Rec.PaymentID
		LEFT JOIN #Refunds R ON PT.PaymentID = R.PaymentID	
		LEFT JOIN #Capitated C ON C.PaymentID = PT.PaymentID
		LEFT JOIN PaymentType pyt on pt.PaymentTypeID = pyt.PaymentTypeID
		LEFT JOIN PayerTypeCode PTC on PTC.PayerTypeCode = pyt.PayerTypeCode
	WHERE PT.PracticeID = @PracticeID 
		AND PT.PostingDate BETWEEN @BeginDate and @EndDate
		AND (@PaymentTypeID = -1 OR @PaymentTypeID = PT.PaymentTypeID )
		AND ((PT.PaymentMethodCode = @PaymentMethodCode) OR (ISNULL(RTRIM(@PaymentMethodCode),'')=''))
		AND((BatchID = @BatchID) OR (@BatchID IS NULL OR LTRIM(RTRIM(@BatchID))=''))
		AND (@ReportType = 'A' OR 0 <> (PT.PaymentAmount - COALESCE(Rec.TotalApplied,0) - COALESCE(R.Refund,0) - COALESCE(C.CapitatedAmount,0)) )



	DROP TABLE #Receipts
	DROP TABLE #Refunds

	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
