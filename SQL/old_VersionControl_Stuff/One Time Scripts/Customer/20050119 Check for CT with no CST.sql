SELECT CT.ClaimID, SUM(CT.Amount), MAX(CT.Claim_Amount), MAX(CT.Claim_TotalAdjustments)
FROM dbo.Payment P
	INNER JOIN dbo.PaymentClaimTransaction PCT
	ON P.PaymentID = PCT.PaymentID
	INNER JOIN dbo.ClaimTransaction CT
	ON PCT.ClaimTransactionID = CT.ClaimTransactionID
WHERE P.PayerID = 16170
 and P.PayerTypeCode = 'I'
GROUP BY CT.ClaimID



SELECT CT.ClaimID, SUM(CT.Amount), MAX(CT.Claim_Amount), MAX(CT.Claim_TotalAdjustments)
FROM dbo.Payment P
	INNER JOIN dbo.PaymentClaimTransaction PCT
	ON P.PaymentID = PCT.PaymentID
	INNER JOIN dbo.ClaimTransaction CT
	ON PCT.ClaimTransactionID = CT.ClaimTransactionID
WHERE P.PayerID = 16170
 and P.PayerTypeCode = 'I'
GROUP BY CT.ClaimID


SELECT *
FROM dbo.ClaimTransaction CT WITH (NOLOCK)
WHERE CT.Claim_TotalBalance < 0
ORDER BY claimTransactionid

	--AND 
	--ClaimID = 35489
ORDER BY ClaimTransactionID

SELECT PaymentID, ClaimID, COUNT(*)
FROM dbo.PaymentClaimTransaction PCT
GROUP BY PaymentID, ClaimID
HAVING COUNT(*) > 1

SELECT *
FROM dbo.Claim C
WHERE C.ClaimID IN
(
SELECT DISTINCT CT.ClaimID
FROM dbo.ClaimTransaction CT
WHERE CT.Claim_TotalBalance < 0
	AND CT.ClaimID NOT IN (
		SELECT ClaimID
		FROM dbo.ClaimTransaction CTT
		WHERE CTT.ClaimTransactionTypeCode = 'CST'
	)
	)
	
SELECT *
FROM dbo.Claim C
WHERE C.ClaimID IN
(
SELECT DISTINCT CT.ClaimID
FROM dbo.ClaimTransaction CT
WHERE CT.ClaimID NOT IN (
		SELECT ClaimID
		FROM dbo.ClaimTransaction CTT
		WHERE CTT.ClaimTransactionTypeCode = 'CST'
	)
)

SELECT *
INTO _20050119_ClaimTransaction
FROM dbo.ClaimTransaction CT
	
SELECT *
INTO _20050119_ClaimTransaction_MissingCST
FROM dbo.ClaimTransaction CT
WHERE CT.ClaimID NOT IN (
		SELECT ClaimID
		FROM dbo.ClaimTransaction CTT
		WHERE CTT.ClaimTransactionTypeCode = 'CST'
	)
ORDER BY ClaimID, ClaimTransactionID


SELECT *
FROM dbo.ClaimTransaction CT
WHERE CT.ClaimID NOT IN (
		SELECT ClaimID
		FROM dbo.ClaimTransaction CTT
		WHERE CTT.ClaimTransactionTypeCode = 'CST'
	)
ORDER BY ClaimID, ClaimTransactionID



-----------------------------------
SELECT min(CT.ClaimTransactionID)
FROM dbo.ClaimTransaction CT

304322

SELECT *
FROM dbo.Claim C
WHERE C.ClaimID = 35489

BEGIN TRAN 

DECLARE claim_fix_cursor CURSOR
READ_ONLY
FOR SELECT 
		ISNULL(C.ServiceChargeAmount,0) * ISNULL(C.ServiceUnitCount,0) AS Amount,
		C.ClaimID,
		C.PatientID,
		C.PracticeID,
		C.CreatedDate
	FROM dbo.Claim C
	WHERE C.ClaimID IN
					(
						SELECT Distinct ClaimID
						FROM dbo.ClaimTransaction CT
						WHERE CT.ClaimID NOT IN (
								SELECT ClaimID
								FROM dbo.ClaimTransaction CTT
								WHERE CTT.ClaimTransactionTypeCode = 'CST'
							)
					)

DECLARE @NextCTID int
SET @NextCTID = 300000
DECLARE @Amount money
--SET @Amount = 155
DECLARE @ClaimID int
--SET @ClaimID = 35489
DECLARE @PatientID int
--SET @PatientID = 167877
DECLARE @PracticeID int
--SET @PracticeID = 38
DECLARE @ClaimCreatedDate datetime
--SET @ClaimCreatedDate = '2004-06-16 07:39:57.547'

DECLARE @name varchar(40)
OPEN claim_fix_cursor

FETCH NEXT FROM claim_fix_cursor INTO @Amount, @ClaimID, @PatientID, @PracticeID, @ClaimCreatedDate
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		SET identity_insert  ClaimTransaction ON
		INSERT INTO [dbo].[ClaimTransaction] (
			ClaimTransactionID,
			[Amount],
			[ClaimID],
			[ClaimTransactionTypeCode],
			[Notes],
			[PatientID],
			[PracticeID],
			[TransactionDate],
			CreatedDate)
		VALUES (
			@nextCTID,
			@Amount,
			@ClaimID,
			'CST',
			'Claim created for ' + STR(@Amount,15,2) + '  ',
			@PatientID,
			@PracticeID,
			GETDATE(),
			@ClaimCreatedDate)
				
		SET identity_insert  ClaimTransaction OFF
		SET @NextCTID = @NextCTID + 1
	END
	FETCH NEXT FROM claim_fix_cursor INTO @Amount, @ClaimID, @PatientID, @PracticeID, @ClaimCreatedDate
END

CLOSE claim_fix_cursor
DEALLOCATE claim_fix_cursor

COMMIT		
		
--SELECT *
--FROM dbo.ClaimTransaction CT
--WHERE --CT.Claim_TotalBalance < 0
	--AND 
--	ClaimID = 52216 --35489
--ORDER BY ClaimTransactionID

--ROLLBACK
--COMMIT


SET NOCOUNT ON
DECLARE test_cursor CURSOR
READ_ONLY
FOR SELECT MIN(CT.ClaimTransactionID) AS CTIC
	FROM dbo.ClaimTransaction CT
	GROUP BY CT.ClaimID

DECLARE @ClaimTransactionID int
DECLARE @newid uniqueidentifier
SET @newid = NEWID()

OPEN test_cursor

FETCH NEXT FROM test_cursor INTO @ClaimTransactionID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		PRINT @ClaimTransactionID		
		UPDATE dbo.ClaimTransaction
			SET Amount = Amount
		WHERE ClaimTransactionID=@ClaimTransactionID
	END
	FETCH NEXT FROM test_cursor INTO @ClaimTransactionID
END

CLOSE test_cursor
DEALLOCATE test_cursor
