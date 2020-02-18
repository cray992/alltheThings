SELECT *
FROM dbo.Claim C
WHERE 
claimid = 18605


SELECT *
FROM dbo.Patient
WHERE patientid = 165349

 ROUND(C.ServiceChargeAmount * C.ServiceUnitCount, 2, 1) <> (C.ServiceChargeAmount* C.ServiceUnitCount)
 
 
 SELECT *
 FROM dbo.ClaimTransaction CT
 WHERE 
 ROUND(CT.Amount, 2, 1) <> (CT.Amount)
 
 
 	SELECT P.PaymentID, 
		(P.PaymentAmount - ISNULL(T.AppliedAmount,0)) as PaymentUnappliedAmount, 
		ISNULL(T.AppliedAmount,0) as AppliedAmount,
		CAST(NULL as bit) as IsDeletable
	FROM dbo.Payment P LEFT OUTER JOIN
		(SELECT CT.ReferenceID as PaymentID, SUM(CT.Amount) as AppliedAmount
		FROM dbo.ClaimTransaction CT
		WHERE CT.ClaimTransactionTypeCode ='PAY'
		GROUP BY CT.ReferenceID) as T ON
			P.PaymentID = T.PaymentID
	WHERE P.PracticeID = 42
		AND ROUND((P.PaymentAmount - ISNULL(T.AppliedAmount,0)), 2, 1) <> (P.PaymentAmount - ISNULL(T.AppliedAmount,0))
		
		SELECT *
		FROM [dbo].[PaymentClaimTransaction] PCT
		INNER JOIN dbo.ClaimTransaction CT 
		ON PCT.ClaimTransactionID = CT.ClaimTransactionID
		WHERE paymentid = 3262
			AND  ROUND(CT.Amount, 2, 1) <> (CT.Amount)
