UPDATE ClaimTransaction SET PostingDate=CAST(CONVERT(CHAR(10),PostingDate,110) AS DATETIME)
WHERE CreatedDate>='12-21-05' AND ClaimTransactionTypeCode='CST'