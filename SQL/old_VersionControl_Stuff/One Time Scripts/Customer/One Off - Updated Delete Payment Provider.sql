IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'PaymentDataProvider_DeletePayment'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.PaymentDataProvider_DeletePayment
GO

--===========================================================================
-- DELETE PAYMENT
--===========================================================================
CREATE    PROCEDURE dbo.PaymentDataProvider_DeletePayment
	@payment_id INT
AS
BEGIN

	DELETE FROM
		PaymentPatient
	WHERE
		PaymentID = @payment_id
	
	CREATE TABLE #CTsToDelete(PracticeID INT, ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #CTsToDelete(PracticeID, ClaimID, ClaimTransactionID)
	SELECT PracticeID, ClaimID, ClaimTransactionID
	FROM PaymentClaimTransaction
	WHERE PaymentID= @payment_id

	DELETE FROM
		PaymentClaimTransaction
	WHERE
		PaymentID = @payment_id

	--
	UPDATE CR SET PaymentID=NULL
	FROM ClearinghouseResponse CR
	WHERE PaymentID=@payment_id

	DELETE	PAYMENT
	WHERE	PaymentID = @payment_id

	DELETE UnappliedPayments
	WHERE PaymentID=@payment_id

	DELETE CT
	FROM #CTsToDelete CTTD INNER JOIN ClaimTransaction CT
	ON CTTD.ClaimTransactionID=CT.ClaimTransactionID

	--Get END Transactions To Delete
	CREATE TABLE #CTENDToDelete(PracticeID INT, ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #CTENDToDelete(PracticeID, ClaimID, ClaimTransactionID)
	SELECT CT.PracticeID, CT.ClaimID, CT.ClaimTransactionID
	FROM ClaimTransaction CT INNER JOIN 
	(SELECT DISTINCT PracticeID, ClaimID FROM #CTsToDelete) Claims
	ON CT.PracticeID=Claims.PracticeID AND CT.ClaimID=Claims.ClaimID
	WHERE CT.ClaimTransactionTypeCode='END'

	DELETE CT
	FROM ClaimTransaction CT INNER JOIN #CTENDToDelete CTE
	ON CT.PracticeID=CTE.PracticeID AND CT.ClaimID=CTE.ClaimID
	AND CT.ClaimTransactionID=CTE.ClaimTransactionID

	--Use List of END Transactions that were deleted to Reset ClaimStatusCode
	UPDATE C SET ClaimStatusCode=
			 CASE WHEN CTTC IN ('ASN','CST','RAS') THEN 'R'
			      WHEN CTTC='END' THEN 'C'
			      WHEN CTTC='BLL' THEN 'P' END
	FROM (SELECT CTO.ClaimID, ClaimTransactionTypeCode CTTC
	      FROM ClaimTransaction CTO INNER JOIN (
		SELECT CT.ClaimID, MAX(CT.ClaimTransactionID) ClaimTransactionID
		FROM ClaimTransaction CT INNER JOIN 
		(SELECT DISTINCT PracticeID, ClaimID FROM #CTsToDelete) CTD
		ON CT.PracticeID=CTD.PracticeID AND CT.ClaimID=CTD.ClaimID
		AND ClaimTransactionTypeCode NOT IN ('ADJ','PAY','MEM','XXX','EDI')
		GROUP BY CT.ClaimID) LastTran
		ON CTO.ClaimID=LastTran.ClaimID AND CTO.ClaimTransactionID=LastTran.ClaimTransactionID) T
	INNER JOIN Claim C ON T.ClaimID=C.ClaimID

	DROP TABLE #CTsToDelete
	DROP TABLE #CTENDToDelete

END