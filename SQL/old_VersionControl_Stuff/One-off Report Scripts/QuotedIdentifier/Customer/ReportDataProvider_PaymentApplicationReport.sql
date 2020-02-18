SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_PaymentApplicationReport]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_PaymentApplicationReport]
GO

--ReportDataProvider_PaymentApplicationReport 40, 106008
CREATE PROCEDURE dbo.ReportDataProvider_PaymentApplicationReport
	@PracticeID int = NULL,
	@PaymentID int = 0
AS
BEGIN
	CREATE TABLE #PCT(PracticeID INT, PostingDate DATETIME, ClaimID INT, ClaimTransactionID INT, IsOtherAdjustment BIT)
	INSERT INTO #PCT(PracticeID, PostingDate, ClaimID, ClaimTransactionID, IsOtherAdjustment)
	SELECT P.PracticeID, P.PostingDate, ClaimID, ClaimTransactionID, IsOtherAdjustment
	FROM Payment P INNER JOIN PaymentClaimTransaction PCT
	ON P.PracticeID=PCT.PracticeID AND P.PaymentID=PCT.PaymentID
	WHERE P.PracticeID=@PracticeID AND P.PaymentID=@PaymentID

	CREATE TABLE #Claims(PracticeID INT, PostingDate DATETIME, ClaimID INT)
	INSERT INTO #Claims(PracticeID, PostingDate, ClaimID)
	SELECT DISTINCT PracticeID, PostingDate, ClaimID
	FROM #PCT

	CREATE TABLE #Trans(PostingDate DATETIME, PracticeID INT, PatientID INT, ClaimID INT, ClaimTransactionID INT, ClaimTransactionTypeCode VARCHAR(6), Code VARCHAR(6), Amount MONEY)
	INSERT INTO #Trans(PostingDate, PracticeID, PatientID, ClaimID, ClaimTransactionID, ClaimTransactionTypeCode, Amount)
	SELECT C.PostingDate, CA.PracticeID, CA.PatientID, CA.ClaimID, CA.ClaimTransactionID, CA.CLaimTransactionTypeCode, Amount
	FROM #Claims C INNER JOIN ClaimAccounting CA
	ON C.PracticeID=CA.PracticeID AND C.ClaimID=CA.ClaimID 
	WHERE CA.ClaimTransactionTypeCode NOT IN ('BLL','END')

	UPDATE T SET Code=CT.Code
	FROM #PCT PCT INNER JOIN #Trans T
	ON PCT.ClaimTransactionID=T.ClaimTransactionID
	INNER JOIN ClaimTransaction CT
	ON T.ClaimTransactionID=CT.ClaimTransactionID
	WHERE PCT.IsOtherAdjustment=0 AND T.ClaimTransactionTypeCode='ADJ'

	UPDATE T SET Code=DT.Code
	FROM #Trans T INNER JOIN (SELECT DISTINCT ClaimID, Code FROM #Trans WHERE Code IS NOT NULL) DT
	ON T.ClaimID=DT.ClaimID

	CREATE TABLE #ReturnSummary(PostingDate DATETIME, PracticeID INT, PatientID INT, ClaimID INT, Code VARCHAR(6),
	OriginalCharge MONEY, BalanceForward MONEY, Adjustment MONEY, Payment MONEY, Balance MONEY)
	INSERT INTO #ReturnSummary(PostingDate, PracticeID, PatientID, ClaimID, Code, OriginalCharge,
	BalanceForward, Adjustment, Payment, Balance)
	SELECT T.PostingDate, T.PracticeID, T.PatientID, T.ClaimID, T.Code, 
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END) OriginalCharge,
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END) - 
	SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' AND PCT.ClaimTransactionID IS NULL THEN Amount ELSE 0 END) BalanceForward,
	SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' AND PCT.ClaimTransactionID IS NOT NULL THEN Amount ELSE 0 END) Adjustment,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PCT.ClaimTransactionID IS NOT NULL THEN Amount ELSE 0 END) Payment,
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END) - 
	SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN Amount ELSE 0 END) Balance
	FROM #Trans T LEFT JOIN #PCT PCT
	ON T.ClaimTransactionID=PCT.ClaimTransactionID
	GROUP BY T.PostingDate, T.PracticeID, T.PatientID, T.ClaimID, T.Code
	HAVING SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' AND PCT.ClaimTransactionID IS NOT NULL THEN Amount ELSE 0 END)<>0 OR
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PCT.ClaimTransactionID IS NOT NULL THEN Amount ELSE 0 END)<>0

	CREATE TABLE #ReportResults(PatientFullName VARCHAR(256), PatientID INT, Num INT, ServiceDate DATETIME, ProcedureCode VARCHAR(16), 
				    PostDate DATETIME, OriginalCharge MONEY, BalanceForward MONEY, AdjustmentCode VARCHAR(250),
				    Adjustment MONEY, Payment MONEY, Balance MONEY, Capitated MONEY)
	INSERT INTO #ReportResults(PatientFullName, PatientID, Num, ServiceDate, ProcedureCode, PostDate,
	OriginalCharge, BalanceForward, AdjustmentCode, Adjustment, Payment, Balance)
	SELECT COALESCE(P.LastName + ',', '')
					+ COALESCE(' ' + P.FirstName, '')
					+ COALESCE(' ' + P.MiddleName, '') PatientFullName, RS.PatientID, RS.ClaimID Num,
	EP.ProcedureDateOfService ServiceDate, PCD.ProcedureCode, PostingDate PostDate, 
	OriginalCharge, BalanceForward, ISNULL(A.AdjustmentCode+' - '+A.Description,'') AdjustmentCode,
	Adjustment, Payment, Balance
	FROM #ReturnSummary RS 
	INNER JOIN Claim C
		ON RS.PracticeID=C.PracticeID 
		AND RS.ClaimID=C.ClaimID
	INNER JOIN EncounterProcedure EP
		ON C.PracticeID=EP.PracticeID 
		AND C.EncounterProcedureID=EP.EncounterProcedureID
	INNER JOIN ProcedureCodeDictionary PCD
		ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
	INNER JOIN Patient P
		ON P.PracticeID = @PracticeID
		AND RS.PatientID = P.PatientID
	LEFT JOIN Adjustment A
	ON RS.Code=A.AdjustmentCode
	WHERE C.PracticeID=@PracticeID

	DECLARE @Capitated MONEY
	SELECT 	@Capitated=  SUM( Amount )
	FROM       CapitatedAccountToPayment
	WHERE PaymentID = @PaymentID


---------------------------------------------------
	IF @Capitated IS NOT NULL AND @Capitated > 0
	BEGIN 

	INSERT INTO #ReportResults ( Capitated )
	VALUES( @Capitated )
	
	END
---------------------------------------------------

	SELECT * FROM #ReportResults
	ORDER BY PatientFullName, ServiceDate
	
	DROP TABLE #PCT
	DROP TABLE #Claims
	DROP TABLE #Trans
	DROP TABLE #ReturnSummary
	DROP TABLE #ReportResults
END


GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

