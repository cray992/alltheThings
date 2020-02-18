UPDATE CT SET PostingDate=CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(CT.PostingDate) AS DATETIME),110) AS DATETIME)
FROM ClaimTransaction CT INNER JOIN ClaimAccounting CA
ON CT.ClaimTransactionID=CA.ClaimTransactionID
WHERE CT.ClaimTransactionTypeCode IN ('ADJ','PAY','END') AND
CT.PostingDate<>CA.PostingDate
