DECLARE @StartDate DATETIME
DECLARE @FileName VARCHAR(MAX)

SET @StartDate = '4/2/2011'
SET @FileName = 'CLM-201104060809-188'

SELECT *
FROM dbo.BatchTransaction
WHERE CreatedDate > @StartDate
AND BatchTransactionTypeCode='SNT'
AND data LIKE 'ftp.gatewayedi.com/claims/' + @FileName + '%'