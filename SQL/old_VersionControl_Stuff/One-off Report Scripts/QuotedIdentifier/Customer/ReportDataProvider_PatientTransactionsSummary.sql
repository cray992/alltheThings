SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_PatientTransactionsSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[ReportDataProvider_PatientTransactionsSummary]
GO

--===========================================================================
-- SRS Patient Referrals Summary
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_PatientTransactionsSummary
	@PracticeID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@BatchID varchar(50) = NULL
AS

/*
DECLARE
	@PracticeID int ,
	@BeginDate datetime,
	@EndDate datetime,
	@BatchID varchar(50)
SELECT
	@PracticeID  = 65,
	@BeginDate  = '1/1/06',
	@EndDate  = '5/8/06',
	@BatchID  = NULL
*/
BEGIN

	SET @EndDate=DATEADD(S,-1,DATEADD(D,1,@EndDate))
	
	SELECT DISTINCT BatchID, PayerID
	INTO #Batch
	FROM Payment
	WHERE	PracticeID = @PracticeID AND 
			@BatchID IS NOT NULL AND 
			rtrim(BatchID) = rtrim(@BatchID)

	CREATE TABLE #Balances(PatientID INT, ClaimID INT, Balance MONEY, Charges MONEY, Adjustments MONEY, Receipts MONEY)
	INSERT INTO #Balances(PatientID, ClaimID, Balance, Charges, Adjustments, Receipts)
	SELECT CA.PatientID, ClaimID, SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END) Balance,
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' AND CA.PostingDate>=@BeginDate THEN Amount ELSE 0 END) Charges,
	SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' AND CA.PostingDate>=@BeginDate THEN Amount ELSE 0 END) Adjustments,
	0 Receipts
	FROM ClaimAccounting CA
	LEFT OUTER JOIN #Batch P ON P.PayerID = CA.PatientID
	WHERE CA.PracticeID=@PracticeID AND CA.PostingDate<=@EndDate
	AND ((RTRIM(P.BatchID) = RTRIM(@BatchID)) OR(@BatchID IS NULL))
--	AND P.PayerTypeCode='P'
	GROUP BY PatientID, ClaimID

	CREATE TABLE #Receipts(PatientID INT, Receipts MONEY)
	INSERT INTO #Receipts(PatientID, Receipts)
	SELECT CA.PatientID, SUM(Amount) Receipts
	FROM Payment P INNER JOIN PaymentClaimTransaction PCT
	ON P.PracticeID=PCT.PracticeID AND P.PaymentID=PCT.PaymentID
	INNER JOIN ClaimAccounting CA
	ON PCT.PracticeID=CA.PracticeID AND PCT.ClaimID=CA.ClaimID AND PCT.ClaimTransactionID=CA.ClaimTransactionID
	WHERE P.PracticeID=@PracticeID AND p.PostingDate BETWEEN @BeginDate AND @EndDate AND CA.ClaimTransactionTypeCode='PAY'
	AND ((RTRIM(P.BatchID) = RTRIM(@BatchID)) OR(@BatchID IS NULL)) 
	-- AND P.PayerTypeCode = 'P'
	GROUP BY CA.PatientID


	CREATE TABLE #Assignments(ClaimID INT, ClaimTransactionID INT, Type CHAR(1))
	INSERT INTO #Assignments(ClaimID, ClaimTransactionID)
	SELECT CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Assignments CAA INNER JOIN #Balances B ON CAA.ClaimID=B.ClaimID
	WHERE CAA.PracticeID=@PracticeID AND CAA.PostingDate<=@EndDate
	GROUP BY CAA.ClaimID
	
	UPDATE A SET Type=CASE WHEN InsurancePolicyID IS NULL THEN 'P' ELSE 'I' END
	FROM #Assignments A INNER JOIN ClaimAccounting_Assignments CAA
	ON A.ClaimTransactionID=CAA.ClaimTransactionID
	
	CREATE TABLE #Unapplied(PatientID INT, PaymentID INT, Unapplied MONEY)
	INSERT INTO #Unapplied(PatientID, PaymentID, Unapplied)
	SELECT PayerID PatientID, P.PaymentID, PaymentAmount
	FROM Payment P INNER JOIN UnappliedPayments UP ON P.PracticeID=UP.PracticeID
	AND P.PaymentID=UP.PaymentID
	AND ((RTRIM(P.BatchID) = RTRIM(@BatchID)) OR(@BatchID IS NULL))
	WHERE P.PracticeID=@PracticeID AND PayerTypeCode='P' AND PostingDate<=@EndDate
	
	UPDATE U SET Unapplied=Unapplied-CT.Amount
	FROM #Unapplied U INNER JOIN PaymentClaimTransaction PCT ON U.PaymentID=PCT.PaymentID
	INNER JOIN ClaimTransaction CT ON PCT.ClaimTransactionID=CT.ClaimTransactionID
	WHERE CT.PracticeID=@PracticeID AND CT.ClaimTransactionTypeCode='PAY'
	
	CREATE TABLE #Refunds(PatientID INT, Refunds MONEY)
	INSERT INTO #Refunds(PatientID, Refunds)
	SELECT P.PayerID PatientID, SUM(RTP.Amount) Refunds
	FROM Refund R INNER JOIN RefundToPayments RTP
	ON R.RefundID=RTP.RefundID
	INNER JOIN Payment P 
	ON RTP.PaymentID=P.PaymentID
	WHERE R.PracticeID=@PracticeID AND R.RecipientTypeCode='P' AND R.PostingDate BETWEEN @BeginDate AND @EndDate
	AND ((RTRIM(P.BatchID) = RTRIM(@BatchID)) OR(@BatchID IS NULL)) 
	AND P.PayerTypeCode='P'
	GROUP BY P.PayerID

-------------------------------------------------------------------------------------------------------------------
	CREATE TABLE #Capitated(PatientID INT, Capitated MONEY)
	INSERT INTO #Capitated(PatientID, Capitated)
	SELECT P.PayerID PatientID, SUM(CAP.Amount) Capitated
	FROM CapitatedAccount C INNER JOIN CapitatedAccountToPayment CAP
	ON C.CapitatedAccountID=CAP.CapitatedAccountID
	INNER JOIN Payment P 
	ON CAP.PaymentID=P.PaymentID
	WHERE C.PracticeID=@PracticeID AND P.PayerTypeCode='P' AND CAP.PostingDate BETWEEN @BeginDate AND @EndDate
	AND ((RTRIM(P.BatchID) = RTRIM(@BatchID)) OR(@BatchID IS NULL))
	AND P.PayerTypeCode='P'
	GROUP BY P.PayerID
-------------------------------------------------------------------------------------------------------------------
	
	CREATE TABLE #ReportResults(PatientID INT, PatientFullName VARCHAR(192), HomePhone VARCHAR(10), Charges MONEY, Adjustments MONEY, Receipts MONEY, 
				    Refunds MONEY, Capitated MONEY, Unapplied MONEY, InsuranceBalance MONEY, PatientBalance MONEY)
	INSERT INTO #ReportResults(PatientID, PatientFullName, HomePhone, Charges, Adjustments, Receipts, Refunds, Capitated, Unapplied, InsuranceBalance, PatientBalance)
	SELECT B.PatientID, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) PatientFullname,	
	P.HomePhone, SUM(Charges) Charges, SUM(Adjustments) Adjustments, SUM(Receipts) Receipts, 0 Refunds, 0 Capitated, 0 Unapplied,
	SUM(CASE WHEN Type='I' THEN Balance ELSE 0 END) InsuranceBalance,
	SUM(CASE WHEN Type='P' THEN Balance ELSE 0 END) PatientBalance
	FROM #Balances B INNER JOIN #Assignments A ON B.ClaimID=A.ClaimID
	INNER JOIN Patient P ON B.PatientID=P.PatientID
	GROUP BY B.PatientID, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')), P.HomePhone
	
	UPDATE RR SET Refunds=R.Refunds
	FROM #ReportResults RR INNER JOIN #Refunds R ON RR.PatientID=R.PatientID

------------------------------------------------------------------------------------------
	UPDATE RR SET Capitated=C.Capitated
	FROM #ReportResults RR INNER JOIN #Capitated C ON RR.PatientID=C.PatientID
------------------------------------------------------------------------------------------
	
	UPDATE RR SET Unapplied=SU.Unapplied
	FROM #ReportResults RR INNER JOIN 
	(SELECT PatientID, SUM(Unapplied) Unapplied
	 FROM #Unapplied
	 GROUP BY PatientID) SU ON RR.PatientID=SU.PatientID

-----------------------------------------------------------------------------------------------------
	UPDATE #ReportResults SET Unapplied=Unapplied - Refunds - Capitated

-----------------------------------------------------------------------------------------------------

	UPDATE RR SET Receipts=R.Receipts
	FROM #ReportResults RR INNER JOIN #Receipts R
	ON RR.PatientID=R.PatientID
	
	DELETE #ReportResults
	WHERE Charges=0 AND Adjustments=0 AND Receipts=0 AND Refunds=0 --AND PatientBalance=0 AND Capitated=0
	
	SELECT * FROM #ReportResults 
	ORDER BY PatientFullName

	DROP TABLE #Balances
	DROP TABLE #Assignments
	DROP TABLE #Unapplied
	DROP TABLE #Refunds
	DROP TABLE 
		#ReportResults, 
		#Batch, 
		#Receipts,
		#Capitated
	

	
END	


GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

