DECLARE @PayerNumber VARCHAR(32)
SET @PayerNumber='MC018'

DECLARE @PracticeID INT
SET @PracticeID=2

DECLARE @ChangeStatus_ReasonCode VARCHAR(5)
SET @ChangeStatus_ReasonCode='0'

DECLARE @ChangeStatus_Note VARCHAR(500)
SET @ChangeStatus_Note='Rebilled per customer request'

DECLARE @Claims TABLE(PracticeID INT, PatientID INT, ProviderID INT, ClaimID INT, Charges MONEY)
INSERT @Claims(PracticeID, PatientID, ProviderID, ClaimID, Charges)
SELECT CAA.PracticeID, CAA.PatientID, E.DoctorID, CAA.ClaimID, ISNULL(ServiceChargeAmount,0)*ISNULL(ServiceUnitCount,0) Charges
FROM SHAREDSERVER.Superbill_Shared.dbo.ClearinghousePayersList CPL 
INNER JOIN InsuranceCompany IC
ON CPL.ClearinghousePayerID=IC.ClearinghousePayerID
INNER JOIN InsuranceCompanyPlan ICP
ON IC.InsuranceCompanyID=ICP.InsuranceCompanyID
INNER JOIN ClaimAccounting_Assignments CAA
ON --CAA.PracticeID=@PracticeID AND
   ICP.InsuranceCompanyPlanID=CAA.InsuranceCompanyPlanID
AND CAA.LastAssignment=1 AND Status=0
INNER JOIN Claim C
ON CAA.PracticeID=C.PracticeID AND CAA.ClaimID=C.ClaimID
INNER JOIN EncounterProcedure EP
ON C.EncounterProcedureID=EP.EncounterProcedureID
INNER JOIN Encounter E
ON EP.EncounterID=E.EncounterID
WHERE CPL.PayerNumber=@PayerNumber AND C.ClaimStatusCode='P'

SELECT PracticeID, COUNT(*) Items, SUM(Charges) Charges
FROM @Claims
GROUP BY PracticeID


--INSERT	CLAIMTRANSACTION (ClaimTransactionTypeCode,	ClaimID, PostingDate, Amount,
--						  Quantity, Code, ReferenceID, ReferenceData, Notes, PracticeID,
--						  PatientID, Claim_ProviderID)
--SELECT 'RAS', ClaimID,
--CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(GETDATE()) AS DATETIME),110) AS DATETIME),
--NULL, NULL, @ChangeStatus_ReasonCode, NULL, NULL, @ChangeStatus_Note, PracticeID, PatientID, ProviderID
--FROM @Claims
--
--UPDATE C SET ClaimStatusCode = 'R',
--			 CurrentClearinghouseProcessingStatus = NULL,
--			 CurrentPayerProcessingStatusTypeCode = NULL,
--			 ModifiedDate = GETDATE(), ModifiedUserID=295
--FROM @Claims Cs INNER JOIN Claim C
--ON Cs.ClaimID=C.ClaimID
