CREATE TABLE #PayClaims(PaymentID INT, PracticeID INT, PatientID INT, EncounterID INT, ClaimID INT, Charge MONEY, InsurancePolicyID INT, Precedence INT)
INSERT INTO #PayClaims(PaymentID, PracticeID, PatientID, EncounterID, ClaimID, Charge)
SELECT PC.PaymentID, PC.PracticeID, PC.PatientID, PC.EncounterID, PC.ClaimID, 
CEILING(CA.Amount*100)/100 Charge
FROM PaymentClaim PC INNER JOIN ClaimAccounting CA
ON PC.PracticeID=CA.PracticeID AND PC.ClaimID=CA.ClaimID
AND CA.ClaimTransactionTypeCode='CST'
INNER JOIN Payment P
ON PC.PaymentID=P.PaymentID
WHERE PC.EOBXml IS NULL AND P.PayerTypeCode='I'

CREATE TABLE #PayClaims_FirstPAYTran(PaymentID INT, ClaimID INT, ClaimTransactionID INT)
INSERT INTO #PayClaims_FirstPAYTran(PaymentID, ClaimID, ClaimTransactionID)
SELECT PC.PaymentID, PC.ClaimID, MIN(CT.ClaimTransactionID) ClaimTransactionID
FROM #PayClaims PC INNER JOIN ClaimTransaction CT
ON PC.PracticeID=CT.PracticeID AND PC.ClaimiD=CT.ClaimID AND PC.PaymentID=CT.PaymentID 
AND CT.ClaimTransactionTypeCode IN ('ADJ','PAY')
GROUP BY PC.PaymentID, PC.ClaimID

UPDATE PC SET InsurancePolicyID=CAA.InsurancePolicyID
FROM #PayClaims PC INNER JOIN #PayClaims_FirstPAYTran PCFT
ON PC.PaymentID=PCFT.PaymentID AND PC.ClaimID=PCFT.ClaimID
INNER JOIN ClaimAccounting_Assignments CAA
ON PC.PracticeID=CAA.PracticeID AND PCFT.ClaimID=CAA.ClaimID
AND ((PCFT.ClaimTransactionID BETWEEN CAA.ClaimTransactionID AND CAA.EndClaimTransactionID)
	 OR (PCFT.ClaimTransactionID>CAA.ClaimTransactionID AND CAA.EndClaimTransactionID IS NULL))

UPDATE PC SET Precedence=IP.Precedence
FROM #PayClaims PC INNER JOIN InsurancePolicy IP
ON PC.PracticeID=IP.PracticeID AND PC.InsurancePolicyID=IP.InsurancePolicyID

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PaymentClaim]') AND name = N'IX_PaymentClaim_eobXML')
DROP INDEX [IX_PaymentClaim_eobXML] ON [dbo].[PaymentClaim]

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PaymentClaim]') AND name = N'IX_PaymentClaim_eobXML_Path')
DROP INDEX [IX_PaymentClaim_eobXML_Path] ON [dbo].[PaymentClaim]

UPDATE PC SET EOBXml='<eob xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<stage>'+CAST(CASE WHEN TPC.Precedence IS NULL THEN 0 ELSE TPC.Precedence END AS VARCHAR)+'</stage>
<insurancePolicyID>'+CAST(CASE WHEN TPC.InsurancePolicyID IS NULL THEN 0 ELSE TPC.InsurancePolicyID END AS VARCHAR)+'</insurancePolicyID>
</eob>'
FROM PaymentClaim PC INNER JOIN #PayClaims TPC
ON PC.PracticeID=TPC.PracticeID AND PC.PaymentID=TPC.PaymentID AND PC.ClaimID=TPC.ClaimID

UPDATE PC SET EOBXml=CONVERT(XML,'<eob xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><stage>'
+CAST(EOBXml.value('(eob/items/stage)[1]','INT') AS VARCHAR)+'</stage><insurancePolicyID>'
+CAST(EOBXml.value('(eob/items/insurancePolicyID)[1]','INT') AS VARCHAR)+'</insurancePolicyID>'+CAST(EOBXml.query('eob/*[local-name()!="items"]') AS VARCHAR(MAX))
+CASE WHEN CAST(EOBXml.query('eob/items/*[local-name()!="stage" and local-name()!="insurancePolicyID"]') AS VARCHAR(MAX))<>'' THEN
'<items>'+
CAST(EOBXml.query('eob/items/*[local-name()!="stage" and local-name()!="insurancePolicyID"]') AS VARCHAR(MAX))+'</items>' ELSE '' END+'</eob>')
FROM PaymentClaim PC
WHERE EOBXml.value('(eob/items/stage)[1]','INT') IS NOT NULL

DROP TABLE #PayClaims
DROP TABLE #PayClaims_FirstPAYTran

CREATE PRIMARY XML INDEX [IX_PaymentClaim_eobXML] ON [dbo].[PaymentClaim] 
(
	[EOBXml]
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF)

GO

CREATE XML INDEX [IX_PaymentClaim_eobXML_Path] ON [dbo].[PaymentClaim] 
(
	[EOBXml]
)
USING XML INDEX [IX_PaymentClaim_eobXML] FOR PATH WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF)