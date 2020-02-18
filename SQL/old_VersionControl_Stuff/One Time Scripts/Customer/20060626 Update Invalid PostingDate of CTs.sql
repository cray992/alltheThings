UPDATE CT SET PostingDate=P.PostingDate
FROM Payment P INNER JOIN PaymentClaimTransaction PCT
ON P.PaymentID=PCT.PaymentID
INNER JOIN ClaimTransaction CT
ON PCT.ClaimTransactionID=CT.ClaimTransactionID
WHERE CAST(CONVERT(CHAR(10),P.PostingDate,110) AS DATETIME)>CAST(CONVERT(CHAR(10),CT.PostingDate,110) AS DATETIME)
