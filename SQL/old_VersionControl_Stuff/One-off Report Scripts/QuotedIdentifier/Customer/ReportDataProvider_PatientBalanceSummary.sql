SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_PatientBalanceSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[ReportDataProvider_PatientBalanceSummary]
GO

CREATE PROCEDURE dbo.ReportDataProvider_PatientBalanceSummary
	@PracticeID int = NULL,
	@EndDate datetime = NULL,
	@Assigned Char(1) = 'P' -- 'Show only patients with a balance assigned to (a)ll, (p)atient, or (i)nsurance
AS
/*
Declare
	@PracticeID int ,
	@EndDate datetime,
	@Assigned Char(1)
Select
	@PracticeID  = 1,
	@EndDate  = '7/20/06',
	@Assigned = 'P'
*/

BEGIN


	SET NOCOUNT ON
	
	CREATE TABLE #AR (ClaimID INT, Amount MONEY)
	INSERT INTO #AR(ClaimID, Amount)
	SELECT ClaimID, SUM(Amount)
	FROM ClaimAccounting
	WHERE PracticeID=@PracticeID AND PostingDate<=@EndDate
	GROUP BY ClaimID
	HAVING SUM(Amount)<>0
	
	--Get Last Assignments
	CREATE TABLE #ASNMax (ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #ASNMax(ClaimID, ClaimTransactionID)
	SELECT CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Assignments CAA INNER JOIN #AR AR ON CAA.ClaimID=AR.ClaimID
	WHERE PracticeID=@PracticeID AND PostingDate<=@EndDate
	GROUP BY CAA.ClaimID
	
	CREATE TABLE #ASN (ClaimID INT, PatientID INT, TypeGroup INT)
	INSERT INTO #ASN(ClaimID, PatientID, TypeGroup)
	SELECT CAA.ClaimID, CAA.PatientID,
	CASE WHEN ICP.InsuranceCompanyPlanID IS NULL THEN 2 ELSE 1 END TypeGroup
	FROM ClaimAccounting_Assignments CAA INNER JOIN #ASNMax AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
	LEFT JOIN InsuranceCompanyPlan ICP ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	WHERE CAA.PracticeID=@PracticeID AND CAA.PostingDate<=@EndDate
	

	--Remove Records that will not be used in calculating final report
	CREATE TABLE #PatientsInReport(PatientID INT)
	INSERT INTO #PatientsInReport(PatientID)
	SELECT A.PatientID
	FROM #ASN A INNER JOIN ClaimAccounting CAA
	ON A.ClaimID=CAA.ClaimID
	GROUP BY A.PatientID
	HAVING SUM(ARAmount) <> 0
--		AND SUM(DISTINCT TypeGroup)>= 2

		AND (
			(@Assigned = 'P' AND SUM(DISTINCT TypeGroup)>= 2)
			OR (@Assigned = 'I' AND SUM(DISTINCT TypeGroup) = 1)
			OR (@Assigned = 'A')
			)


	DELETE A
	FROM #ASN A LEFT JOIN #PatientsInReport PIR
	ON A.PatientID=PIR.PatientID
	WHERE PIR.PatientID IS NULL


	SELECT A.PatientID, RTRIM(ISNULL(Pat.LastName + ', ', '') + ISNULL(Pat.FirstName,'') + ISNULL(' ' + Pat.MiddleName, '')) PatientName,
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END) Charges,
	SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN Amount*-1 ELSE 0 END) Adjustments,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='I' THEN Amount*-1 ELSE 0 END) InsPay,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' THEN Amount*-1 ELSE 0 END) PatPay,
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)+
	SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END) TotalBalance,
	SUM(CASE WHEN TypeGroup=1 AND ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)+
	SUM(CASE WHEN TypeGroup=1 AND ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END) PendingIns,
	SUM(CASE WHEN TypeGroup=2 AND ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)+
	SUM(CASE WHEN TypeGroup=2 AND ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END) PendingPat
	FROM #ASN A INNER JOIN ClaimAccounting CAA
	ON A.PatientID=CAA.PatientID AND A.ClaimID=CAA.ClaimID
	LEFT JOIN PaymentClaimTransaction PCT
	ON CAA.ClaimTransactionID=PCT.ClaimTransactionID
	LEFT JOIN Payment P
	ON PCT.PaymentID=P.PaymentID
	INNER JOIN Patient Pat
	ON A.PatientID=Pat.PatientID
	WHERE CAA.PracticeID=@PracticeID AND CAA.PostingDate<=@EndDate
	GROUP BY A.PatientID, RTRIM(ISNULL(Pat.LastName + ', ', '') + ISNULL(Pat.FirstName,'') + ISNULL(' ' + Pat.MiddleName, ''))
	ORDER BY RTRIM(ISNULL(Pat.LastName + ', ', '') + ISNULL(Pat.FirstName,'') + ISNULL(' ' + Pat.MiddleName, ''))

	DROP TABLE #AR
	DROP TABLE #ASN
	DROP TABLE #ASNMax
	DROP TABLE #PatientsInReport

	RETURN
END


GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

