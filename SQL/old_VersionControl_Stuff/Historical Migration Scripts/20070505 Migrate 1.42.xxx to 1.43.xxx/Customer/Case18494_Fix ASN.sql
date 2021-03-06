	SELECT PracticeID, ClaimID, min(ClaimTransactionID) as minClaimTransactionID
	INTO #minASN
	FROM ClaimTransaction
	WHERE ClaimTransactionTypeCode = 'ASN'
	GROUP BY PracticeID, ClaimID


create TABLE #Claims(ClaimID INT, minClaimTransactionID INT)
INSERT #Claims(ClaimID, minClaimTransactionID)
SELECT ct.ClaimID, minClaimTransactionID
FROM ClaimTransaction ct
	LEFT JOIN VoidedClaims vc ON vc.ClaimID = ct.ClaimID
	INNER JOIN #minASN as minASN ON minASN.PracticeID = ct.PracticeID AND minASN.ClaimID = CT.ClaimID AND ct.ClaimTransactionID > minClaimTransactionID
WHERE dbo.fn_DateOnly(PostingDate) <> dbo.fn_DateOnly( CreatedDate )
	AND ClaimTransactionTypeCode = 'ASN'
	AND vc.ClaimID IS NULL
GROUP BY ct.ClaimID, minClaimTransactionID

-- Reset PostingDate, create date, 
update caa
SET PostingDate = convert(varchar, CreatedDate, 1)
FROM ClaimAccounting_Assignments caa
	INNER JOIN ClaimTransaction ct ON ct.PracticeID = caa.PracticeID AND ct.ClaimID = caa.ClaimID AND ct.ClaimTransactionID = caa.ClaimTransactionID
	INNER JOIN #Claims c on c.CLaimID = caa.ClaimID AND caa.ClaimTransactionID > c.minClaimTransactionID
WHERE dbo.fn_DateOnly(caa.PostingDate) <> dbo.fn_DateOnly( CreatedDate )
	
-- Reset PostingDate, create date, 
alter table ClaimTransaction disable trigger all
update ct
SET PostingDate = convert(varchar, ct.CreatedDate, 1)
FROM ClaimAccounting_Assignments caa
	INNER JOIN ClaimTransaction ct ON ct.PracticeID = caa.PracticeID AND ct.ClaimID = caa.ClaimID AND ct.ClaimTransactionID = caa.ClaimTransactionID
	INNER JOIN #Claims c on c.CLaimID = caa.ClaimID and caa.ClaimTransactionID > c.minClaimTransactionID
WHERE dbo.fn_DateOnly(ct.PostingDate) <> dbo.fn_DateOnly( CreatedDate )
alter table ClaimTransaction enable trigger all	



-- Rest EndClaimTransactionID, EndPostingDateID, LastAssignment, LastAssignmentOfEndPostingDate
SELECT CT.ClaimID, 
	ct.ClaimTransactionID, 
	EndClaimTransactionID = (select min(caa.ClaimTransactionID) from ClaimAccounting_Assignments caa 
								WHERE caa.practiceID = ct.PracticeID AND caa.ClaimID = ct.ClaimID 
								AND caa.ClaimTransactionID > ct.ClaimTransactionID )
INTO #EndASN
FROM #Claims C INNER JOIN ClaimAccounting_Assignments CT
ON C.ClaimID=CT.ClaimID 
order by ct.ClaimTransactionID


update caa
SET EndClaimTransactionID = endCaa.ClaimTransactionID,
	EndPostingDate = endCaa.PostingDate,
	LastAssignment = CASE WHEN C.EndClaimTransactionID IS NULL THEN 1 ELSE 0 END,
	DKPostingDateID = dbo.fn_GetDateKeySelectivityID(caa.PracticeID,caa.PostingDate,0,0),
	DKEndPostingDateID = dbo.fn_GetDateKeySelectivityID(endCaa.PracticeID,endCaa.PostingDate,0,0)
FROM 
	#EndASN c  
	INNER JOIN claimAccounting_Assignments caa ON caa.ClaimTransactionID = c.ClaimTransactionID
	LEFT JOIN claimAccounting_Assignments endCaa ON endCaa.ClaimTransactionID = c.EndClaimTransactionID

drop table #EndASN, #Claims, #minASN
GO
