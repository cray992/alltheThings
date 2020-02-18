

DECLARE @PracticeId INT,
		@BeginDate DATETIME,
		@EndDate DATETIME,
		@NoOfProc INT=10,
		@ProviderID INT=NULL
;	
WITH PROC_CTE(ProcedureCode, ProcedureName, PaymentAmount)
AS (
SELECT pcd.ProcedureCode,pcd.OfficialName AS ProcedureName, SUM(PaymentAmount) AS PaymentAmount
FROM dbo.vReportDataProvider_Claim_ClaimAccounting ca	 WITH (NOEXPAND)
--INNER JOIN dbo.ClaimAccounting ca WITH (NOLOCK) ON ca.ClaimID = Claim.ClaimID AND 
INNER JOIN dbo.EncounterProcedure ep WITH (NOLOCK) ON ep.EncounterProcedureID = Ca.EncounterProcedureID
INNER JOIN dbo.ProcedureCodeDictionary pcd WITH (NOLOCK) ON pcd.ProcedureCodeDictionaryID = ep.ProcedureCodeDictionaryID
INNER JOIN dbo.Payment P WITH (NOLOCK) ON ca.PaymentID=p.paymentid AND p.PayerTypeCode='I'
WHERE ClaimTransactionTypeCode='Pay' AND p.PostingDate BETWEEN @BeginDate AND @EndDate AND ca.ProviderID=ISNULL(@Providerid, ca.ProviderID)
GROUP BY ProcedureCode, OfficialName)

SELECT ProcedureCode, ProcedureName,PaymentAmount
FROM 
(
SELECT ProcedureCode, ProcedureName,PaymentAmount, ROW_NUMBER()OVER(ORDER BY PaymentAmount DESC) AS Rank

FROM PROC_CTE) sub
WHERE rank BETWEEN 1 AND @NoOfProc
UNION ALL 

SELECT 'Other', 'Other',SUM(PaymentAmount) AS AMount
FROM 
(
SELECT ProcedureCode, PaymentAmount, ROW_NUMBER()OVER(ORDER BY PaymentAmount DESC) AS Rank

FROM PROC_CTE) Other
WHERE rank>@NoOfProc



