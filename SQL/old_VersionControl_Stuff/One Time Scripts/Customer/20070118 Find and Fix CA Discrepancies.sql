CREATE TABLE #CTCounts(ClaimID INT, Items INT)
INSERT INTO #CTCounts(ClaimID, Items)
SELECT CT.ClaimID, COUNT(ClaimTransactionID) Items
FROM ClaimTransaction CT LEFT JOIN VoidedClaims VC
ON CT.ClaimID=VC.ClaimID
WHERE ClaimTransactionTypeCode IN ('CST','ADJ','PAY','END','PRC') AND VC.ClaimID IS NULL
GROUP BY CT.ClaimID
ORDER BY CT.ClaimID

CREATE TABLE #CACounts(ClaimID INT, Items INT)
INSERT INTO #CACounts(ClaimID, Items)
SELECT ClaimID, COUNT(ClaimTransactionID) Items
FROM ClaimAccounting
WHERE ClaimTransactionTypeCode<>'BLL'
GROUP BY ClaimID
ORDER BY ClaimID

CREATE TABLE #InvalidClaimAccounting(ClaimID INT)
INSERT INTO #InvalidClaimAccounting(ClaimID)
SELECT CT.ClaimID
FROM #CTCounts CT LEFT JOIN #CACounts CA
ON CT.ClaimID=CA.ClaimID AND CT.Items<>ISNULL(CA.Items,0) 

CREATE TABLE #ClaimTransactions(ClaimID INT, ClaimTransactionID INT, ClaimTransactionTypeCode CHAR(3))
INSERT INTO #ClaimTransactions(ClaimID, ClaimTransactionID, ClaimTransactionTypeCode)
SELECT CT.ClaimID, ClaimTransactionID, ClaimTransactionTypeCode
FROM #InvalidClaimAccounting ICT INNER JOIN ClaimTransaction CT
ON ICT.ClaimID=CT.ClaimID
WHERE ClaimTransactionTypeCode IN ('CST','ADJ','PAY','END','PRC','BLL')

CREATE TABLE #FirstBLL(ClaimID INT, ClaimTransactionID INT)
INSERT INTO #FirstBLL(ClaimID, ClaimTransactionID)
SELECT ClaimID, MIN(ClaimTransactionID) ClaimTransactionID
FROM #ClaimTransactions
WHERE ClaimTransactionTypeCode='BLL'
GROUP BY ClaimID

DELETE CT
FROM #ClaimTransactions CT INNER JOIN #FirstBLL FB
ON CT.ClaimID=FB.ClaimID AND CT.ClaimTransactionID<>FB.ClaimTransactionID
WHERE CT.ClaimTransactionTypeCode='BLL'

CREATE TABLE #ExistingClaimAccounting(ClaimID INT, ClaimtransactionID INT)
INSERT INTO #ExistingClaimAccounting(ClaimID, ClaimTransactionID)
SELECT CA.ClaimID, CA.ClaimTransactionID
FROM #InvalidClaimAccounting ICA INNER JOIN ClaimAccounting CA
ON ICA.ClaimID=CA.ClaimID

CREATE TABLE #OrderedList(PracticeID INT, PostingDate SMALLDATETIME, ClaimID INT, ProviderID INT, PatientID INT,
			  ClaimTransactionID INT, ClaimTransactionTypeCode CHAR(3), Status BIT, ProcedureCount DECIMAL(19,4),
			  Amount MONEY, ARAmount MONEY, Code CHAR(1), CreatedUserID INT, PaymentID INT, FirstBilled BIT, ReferenceID INT)
INSERT INTO #OrderedList(PracticeID, PostingDate, ClaimID, ProviderID, PatientID,  ClaimTransactionID,
			 ClaimTransactionTypeCode, Status, ProcedureCount, Amount, ARAmount, Code, CreatedUserID, PaymentID, ReferenceID)
SELECT CT.PracticeID, CAST(CONVERT(CHAR(10),CT.PostingDate,110) AS SMALLDATETIME) PostingDate, CT.ClaimID, CT.Claim_ProviderID,
       CT.PatientID, CT.ClaimTransactionID, CT.ClaimTransactionTypeCode,
       CASE WHEN CT.ClaimTransactionTypeCode='END' THEN 1 ELSE 0 END Status, 0 ProcedureCount,
       CASE WHEN CT.ClaimTransactionTypeCode='BLL' THEN 0 ELSE CT.Amount END Amount,
       0 ARAmount, CASE WHEN CT.ClaimTransactionTypeCode='BLL' THEN CT.Code ELSE NULL END Code, CT.CreatedUserID,
	   CT.PaymentID, CT.ReferenceID
FROM #ClaimTransactions TCT LEFT JOIN #ExistingClaimAccounting ECA
ON TCT.ClaimID=ECA.ClaimID AND TCT.ClaimTransactionID=ECA.ClaimTransactionID
INNER JOIN ClaimTransaction CT
ON TCT.ClaimID=CT.ClaimID AND TCT.ClaimTransactionID=CT.ClaimTransactionID
WHERE ECA.ClaimTransactionID IS NULL
ORDER BY CT.PracticeID, CAST(CONVERT(CHAR(10),CT.PostingDate,110) AS SMALLDATETIME), CT.Claim_ProviderID, CT.PatientID,
	 CT.ClaimID, CASE WHEN CT.ClaimTransactionTypeCode='CST' THEN 0
		       WHEN CT.ClaimTransactionTypeCode='PRC' THEN 1
		       WHEN CT.ClaimTransactionTypeCode='BLL' THEN 2
		       WHEN CT.ClaimTransactionTypeCode='PAY' THEN 3
		       WHEN CT.ClaimTransactionTypeCode='ADJ' THEN 4
		       WHEN CT.ClaimTransactionTypeCode='END' THEN 5 END


CREATE TABLE #OLClaims(PracticeID INT, ClaimID INT)
INSERT INTO #OLClaims(PracticeID, ClaimID)
SELECT DISTINCT PracticeID, ClaimID
FROM #OrderedList

IF EXISTS(SELECT DISTINCT C.PracticeID, C.ClaimID
	FROM #OLClaims C INNER JOIN ClaimTransaction CT
	ON C.PracticeID=CT.PracticeID AND C.ClaimID=CT.ClaimID
	LEFT JOIN ClaimAccounting_Assignments CAA
	ON CT.PracticeID=CAA.PracticeID AND CT.ClaimTransactionID=CAA.ClaimTransactionID
	WHERE ClaimTransactionTypeCode='ASN' AND CAA.ClaimTransactionID IS NULL)
BEGIN
	DECLARE @ASNClaims TABLE(PracticeID INT, ClaimID INT)
	INSERT @ASNClaims(PracticeID, ClaimID)
	SELECT DISTINCT C.PracticeID, C.ClaimID
	FROM #OLClaims C INNER JOIN ClaimTransaction CT
	ON C.PracticeID=CT.PracticeID AND C.ClaimID=CT.ClaimID
	LEFT JOIN ClaimAccounting_Assignments CAA
	ON CT.PracticeID=CAA.PracticeID AND CT.ClaimTransactionID=CAA.ClaimTransactionID
	WHERE ClaimTransactionTypeCode='ASN' AND CAA.ClaimTransactionID IS NULL

	DECLARE @ASNTrans TABLE(TID INT IDENTITY(1,1), PracticeID INT, NewFlag BIT, ClaimID INT, ClaimTransactionID INT, PostingDate DATETIME, EndPostingDate DATETIME, LastAssignmentOfEndPostingDate BIT, LastAssignment BIT, EndClaimTransactionID INT)
	INSERT @ASNTrans(PracticeID, NewFlag, ClaimID, ClaimTransactionID, PostingDate, LastAssignmentOfEndPostingDate, LastAssignment)
	SELECT C.PracticeID, 0, C.ClaimID, CAA.ClaimTransactionID, CAST(CONVERT(CHAR(10),CAA.PostingDate,110) AS SMALLDATETIME), 0, 0
	FROM @ASNClaims C INNER JOIN ClaimAccounting_Assignments CAA
	ON C.PracticeID=CAA.PracticeID AND C.ClaimID=CAA.ClaimID
	UNION
	SELECT CT.PracticeID, 1, CT.ClaimID, CT.ClaimTransactionID, CAST(CONVERT(CHAR(10),CT.PostingDate,110) AS SMALLDATETIME), 0, 0
	FROM #OLClaims C INNER JOIN ClaimTransaction CT
	ON C.PracticeID=CT.PracticeID AND C.ClaimID=CT.ClaimID
	LEFT JOIN ClaimAccounting_Assignments CAA
	ON CT.PracticeID=CAA.PracticeID AND CT.ClaimTransactionID=CAA.ClaimTransactionID
	WHERE ClaimTransactionTypeCode='ASN' AND CAA.ClaimTransactionID IS NULL
	ORDER BY ClaimID, CAST(CONVERT(CHAR(10),PostingDate,110) AS SMALLDATETIME) DESC, ClaimTransactionID DESC

	UPDATE AT1 SET EndPostingDate=AT2.PostingDate, EndClaimTransactionID=AT2.ClaimTransactionID
	FROM @ASNTrans AT1 INNER JOIN  @ASNTrans AT2
	ON AT1.ClaimID=AT2.ClaimID AND AT1.TID=AT2.TID+1

	DECLARE @ASN_FlagsToUpdate TABLE(ClaimID INT, EndPostingDate DATETIME, CTIDToUpdate INT)
	INSERT @ASN_FlagsToUpdate(ClaimID, EndPostingDate, CTIDToUpdate)
	SELECT ClaimID, EndPostingDate, MAX(ClaimTransactionID) CTIDToUpdate
	FROM @ASNTrans
	GROUP BY ClaimID, EndPostingDate

	UPDATE AT SET LastAssignmentOfEndPostingDate=1
	FROM @ASNTrans AT INNER JOIN @ASN_FlagsToUpdate ATU
	ON AT.ClaimID=ATU.ClaimID AND AT.ClaimTransactionID=ATU.CTIDToUpdate

	UPDATE @ASNTrans SET LastAssignment=1
	WHERE EndPostingDate IS NULL

	UPDATE CAA SET LastAssignment=AT.LastAssignment, EndPostingDate=AT.EndPostingDate, EndClaimTransactionID=AT.EndClaimTransactionID,
	DKEndPostingDateID=dbo.fn_GetDateKeySelectivityID(AT.PracticeID,AT.EndPostingDate,0,0),
	LastAssignmentOfEndPostingDate=AT.LastAssignmentOfEndPostingDate
	FROM @ASNTrans AT INNER JOIN ClaimAccounting_Assignments CAA
	ON AT.ClaimID=CAA.ClaimID AND AT.ClaimTransactionID=CAA.ClaimTransactionID
	WHERE NewFlag=0

	--Insert Assignments
	INSERT INTO ClaimAccounting_Assignments(PracticeID, PostingDate, ClaimID, ClaimTransactionID, 
											InsurancePolicyID, InsuranceCompanyPlanID, PatientID,
											LastAssignment, EndPostingDate, DKPostingDateID, 
										    DKEndPostingDateID, LastAssignmentOfEndPostingDate, Status, EndClaimTransactionID)
	SELECT I.PracticeID, CAST(CONVERT(CHAR(10),I.PostingDate,110) AS SMALLDATETIME), I.ClaimID, I.ClaimTransactionID, I.ReferenceID, IP.InsuranceCompanyPlanID, I.PatientID, AT.LastAssignment, AT.EndPostingDate, 
	dbo.fn_GetDateKeySelectivityID(I.PracticeID,I.PostingDate,0,0), dbo.fn_GetDateKeySelectivityID(AT.PracticeID,AT.EndPostingDate,0,0), AT.LastAssignmentOfEndPostingDate, 0,
	AT.EndClaimTransactionID
	FROM ClaimTransaction I INNER JOIN @ASNTrans AT
	ON I.ClaimID=AT.ClaimID AND I.ClaimTransactionID=AT.ClaimTransactionID
	LEFT JOIN InsurancePolicy IP
	ON I.PracticeID=IP.PracticeID AND I.ReferenceID=IP.InsurancePolicyID
	WHERE AT.NewFlag=1
END

CREATE TABLE #OLClaims_BLL(PracticeID INT, ClaimID INT, ClaimTransactionID INT, PostingDate DATETIME)
INSERT INTO #OLClaims_BLL(PracticeID, ClaimID, ClaimTransactionID, PostingDate)
SELECT CT.PracticeID, CT.ClaimID, CT.ClaimTransactionID, CT.PostingDate
FROM #OLClaims C INNER JOIN ClaimTransaction CT
ON C.PracticeID=CT.PracticeID AND C.ClaimID=CT.ClaimID
LEFT JOIN ClaimAccounting_Billings CAB
ON CT.PracticeID=CAB.PracticeID AND CT.ClaimTransactionID=CAB.ClaimTransactionID
WHERE ClaimTransactionTypeCode='BLL' AND CAB.ClaimTransactionID IS NULL

CREATE TABLE #OLDenormalizedData(ClaimID INT, EncounterProcedureID INT, ProcedureCount INT)
INSERT INTO #OLDenormalizedData(ClaimID, EncounterProcedureID, ProcedureCount)
SELECT OL.ClaimID, EP.EncounterProcedureID, ISNULL(EP.ServiceUnitCount,0) ProcedureCount 
FROM #OLClaims OL INNER JOIN Claim C
ON OL.PracticeID=C.PracticeID AND OL.ClaimID=C.ClaimID
INNER JOIN EncounterProcedure EP
ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID

--Update all records with a Status of 1 if claim has been closed
DECLARE @ClosedItems TABLE(PracticeID INT, ClaimID INT, PostingDate DATETIME)
INSERT @ClosedItems(PracticeID, ClaimID, PostingDate)
SELECT PracticeID, ClaimID, PostingDate
FROM #OrderedList 
WHERE ClaimTransactionTypeCode='END'

--Flag those items closed in the insert list
UPDATE OL SET Status=1
FROM #OrderedList OL INNER JOIN @ClosedItems CI ON OL.ClaimID=CI.ClaimID

DECLARE @BLLTrans TABLE(TID INT IDENTITY(1,1), PracticeID INT, NewFlag BIT, ClaimID INT, ClaimTransactionID INT, PostingDate DATETIME, EndPostingDate DATETIME, 
						LastBilledOfEndPostingDate BIT, LastBilled BIT, FirstBilled BIT, EndClaimTransactionID INT)

IF EXISTS(SELECT * FROM #OLClaims_BLL)
BEGIN
	INSERT @BLLTrans(PracticeID, NewFlag, ClaimID, ClaimTransactionID, PostingDate, LastBilledOfEndPostingDate, LastBilled, FirstBilled)
	SELECT C.PracticeID, 0,C.ClaimID, ClaimTransactionID, PostingDate, 0, 0, 0 
	FROM #OLClaims C INNER JOIN ClaimAccounting_Billings CAB
	ON C.PracticeID=CAB.PracticeID AND C.ClaimID=CAB.ClaimID
	UNION
	SELECT OCB.PracticeID, 1, OCB.ClaimID, OCB.ClaimTransactionID, OCB.PostingDate, 0, 0, 0
	FROM #OLClaims_BLL OCB
	ORDER BY ClaimID, PostingDate DESC, ClaimTransactionID DESC

	UPDATE BT1 SET EndPostingDate=BT2.PostingDate, EndClaimTransactionID=BT2.ClaimTransactionID
	FROM @BLLTrans BT1 INNER JOIN  @BLLTrans BT2
	ON BT1.ClaimID=BT2.ClaimID AND BT1.TID=BT2.TID+1

	DECLARE @BLL_FlagsToUpdate TABLE(ClaimID INT, EndPostingDate DATETIME, CTIDToUpdate INT)
	INSERT @BLL_FlagsToUpdate(ClaimID, EndPostingDate, CTIDToUpdate)
	SELECT ClaimID, EndPostingDate, MAX(ClaimTransactionID) CTIDToUpdate
	FROM @BLLTrans
	GROUP BY ClaimID, EndPostingDate

	UPDATE BT SET LastBilledOfEndPostingDate=1
	FROM @BLLTrans BT INNER JOIN @BLL_FlagsToUpdate BTU
	ON BT.ClaimID=BTU.ClaimID AND BT.ClaimTransactionID=BTU.CTIDToUpdate

	UPDATE @BLLTrans SET LastBilled=1
	WHERE EndPostingDate IS NULL

	UPDATE BT SET FirstBilled=1
	FROM @BLLTrans BT INNER JOIN (SELECT ClaimID, MIN(ClaimTransactionID) FBID FROM @BLLTrans GROUP BY ClaimID) FBT
	ON BT.ClaimID=FBT.ClaimID AND BT.ClaimTransactionID=FBT.FBID

	UPDATE OL SET FirstBilled=1
	FROM #OrderedList OL INNER JOIN @BLLTrans BT
	ON OL.ClaimTransactionID=BT.ClaimTransactionID

	UPDATE CAB SET LastBilled=BT.LastBilled, EndPostingDate=BT.EndPostingDate, EndClaimTransactionID=BT.EndClaimTransactionID,
	DKEndPostingDateID=dbo.fn_GetDateKeySelectivityID(BT.PracticeID,BT.EndPostingDate,0,0),
	LastBilledOfEndPostingDate=BT.LastBilledOfEndPostingDate
	FROM @BLLTrans BT INNER JOIN ClaimAccounting_Billings CAB
	ON BT.ClaimID=CAB.ClaimID AND BT.ClaimTransactionID=CAB.ClaimTransactionID
	WHERE NewFlag=0

	INSERT INTO ClaimAccounting_Billings(PracticeID, PostingDate, ClaimID, ClaimTransactionID, Batchtype, LastBilled, EndPostingDate, DKPostingDateID, 
										 DKEndPostingDateID, LastBilledOfEndPostingDate, Status, EndClaimTransactionID)
	SELECT OL.PracticeID, OL.PostingDate, OL.ClaimID, OL.ClaimTransactionID, OL.Code, BT.LastBilled, BT.EndPostingDate, 
	dbo.fn_GetDateKeySelectivityID(OL.PracticeID,OL.PostingDate,0,0), dbo.fn_GetDateKeySelectivityID(BT.PracticeID,BT.EndPostingDate,0,0), BT.LastBilledOfEndPostingDate,
	OL.Status, BT.EndClaimTransactionID
	FROM #OrderedList OL INNER JOIN @BLLTrans BT
	ON OL.ClaimID=BT.ClaimID AND OL.ClaimTransactionID=BT.ClaimTransactionID
	WHERE BT.NewFlag=1
END

--Delete Voided Claims
DELETE OL
FROM #OrderedList OL INNER JOIN VoidedClaims VC 
ON OL.ClaimID=VC.ClaimID

--After determining the first bills, check if other claims are in the billing cycle
--for proper updating of ADJ, PAY, and END transaction amount into ClaimAccounting
DECLARE @PrevBLLs TABLE (ClaimID INT)
INSERT @PrevBLLs(ClaimID)
SELECT DISTINCT ClaimID
FROM @BLLTrans
WHERE NewFlag=0 AND FirstBilled=1

--Delete all BLL except those flagged as First Billing for Claim
DELETE OL
FROM #OrderedList OL INNER JOIN @BLLTrans BT
ON OL.ClaimID=BT.ClaimID AND OL.ClaimTransactionID=BT.ClaimTransactionID
WHERE NewFlag<>1 AND BT.FirstBilled<>1	

--Get Previous Claim transactions pre first bill that lower the AR Amount upon
--first bill
DECLARE @AdjToAR TABLE (ClaimID INT, Amount MONEY)
INSERT @AdjToAR(ClaimID, Amount)
SELECT CT.ClaimID, SUM(CT.Amount) Amount
FROM ClaimTransaction CT INNER JOIN #OrderedList FB ON CT.ClaimID=FB.ClaimID AND FB.FirstBilled=1
AND CT.ClaimTransactionTypeCode IN ('PAY','ADJ') 
      AND CT.ClaimTransactionID<FB.ClaimTransactionID
GROUP BY CT.ClaimID

--Use @FirstBLLs result to set ARAmounts
DECLARE @ClaimAmounts TABLE(ClaimID INT, Amount MONEY)
INSERT @ClaimAmounts(ClaimID, Amount)
SELECT CT.ClaimID, CT.Amount
FROM ClaimTransaction CT INNER JOIN #OrderedList FB ON CT.ClaimID=FB.ClaimID AND FirstBilled=1
AND CT.ClaimTransactionTypeCode='CST'

UPDATE OL SET ARAmount=ClmA.Amount
FROM #OrderedList OL INNER JOIN #OrderedList FB ON OL.ClaimTransactionID=FB.ClaimTransactionID  AND FB.FirstBilled=1
INNER JOIN @ClaimAmounts ClmA ON FB.ClaimID=ClmA.ClaimID

--Adjust ARAmounts by any ADJ or Payments which occured pre first billing
UPDATE OL SET ARAmount=OL.ARAmount-ISNULL(ATA.Amount,0)
FROM #OrderedList OL INNER JOIN #OrderedList FB ON OL.ClaimTransactionID=FB.ClaimTransactionID  AND FB.FirstBilled=1
INNER JOIN @AdjToAR ATA ON FB.ClaimID=ATA.ClaimID

--SET PAY, ADJ, END ARAmounts
--Take into Consideration only trans after first bill
UPDATE OL SET ARAmount=-1*OL.Amount
FROM #OrderedList OL INNER JOIN #OrderedList FB ON OL.ClaimID=FB.ClaimID AND FB.FirstBilled=1
WHERE OL.ClaimTransactionTypeCode NOT IN ('CST','BLL','PRC')
      AND OL.ClaimTransactionID>FB.ClaimTransactionID

--set those trans previously billed
UPDATE OL SET ARAmount=-1*Amount
FROM #OrderedList OL INNER JOIN @PrevBLLs PB ON OL.ClaimID=PB.ClaimID
WHERE ClaimTransactionTypeCode NOT IN ('CST','BLL','PRC')  

--Insert ClaimAccounting Records
INSERT INTO ClaimAccounting(PracticeID, ClaimID, ProviderID, PatientID,  ClaimTransactionID,
			    ClaimTransactionTypeCode, Status, ProcedureCount, Amount, ARAmount, PostingDate,
				CreatedUserID, PaymentID, EncounterProcedureID) 
SELECT OL.PracticeID, OL.ClaimID, OL.ProviderID, OL.PatientID,  OL.ClaimTransactionID,
       OL.ClaimTransactionTypeCode, OL.Status, DD.ProcedureCount, OL.Amount, OL.ARAmount, OL.PostingDate,
	   OL.CreatedUserID, OL.PaymentID, DD.EncounterProcedureID
FROM #OrderedList OL INNER JOIN #OLDenormalizedData DD
ON OL.ClaimID=DD.ClaimID

INSERT INTO ClaimAccounting_ClaimPeriod(ProviderID, PatientID, ClaimID, DKInitialPostingDateID)
SELECT OL.ProviderID, OL.PatientID, OL.ClaimID, dbo.fn_GetDateKeySelectivityID(OL.PracticeID,OL.PostingDate,0,0)
FROM #OrderedList OL
WHERE ClaimTransactionTypeCode='CST'

--Update/Insert ClaimAccounting_ClaimPeriod Records
UPDATE CP SET DKEndPostingDateID=dbo.fn_GetDateKeySelectivityID(CI.PracticeID,CI.PostingDate,0,0)
FROM @ClosedItems CI INNER JOIN ClaimAccounting_ClaimPeriod CP
ON CI.ClaimID=CP.ClaimID

--Flag those items closed in the table that also need updating
UPDATE CA SET Status=1
FROM ClaimAccounting CA INNER JOIN @ClosedItems CI ON CA.ClaimID=CI.ClaimID

UPDATE CAA SET Status=1
FROM ClaimAccounting_Assignments CAA INNER JOIN @ClosedItems CI ON CAA.ClaimID=CI.ClaimID

UPDATE CAB SET Status=1
FROM ClaimAccounting_Billings CAB INNER JOIN @ClosedItems CI ON CAB.ClaimID=CI.ClaimID

DROP TABLE #CACounts
DROP TABLE #CTCounts
DROP TABLE #InvalidClaimAccounting
DROP TABLE #ClaimTransactions
DROP TABLE #FirstBLL
DROP TABLE #ExistingClaimAccounting
DROP TABLE #OrderedList
DROP TABLE #OLClaims
DROP TABLE #OLClaims_BLL
DROP TABLE #OLDenormalizedData
