

------------------------------------------------------------
------------------------------------------------------------
--- BLL
------------------------------------------------------------
------------------------------------------------------------

create TABLE #Claims(ClaimID INT, MaxID INT)
INSERT #Claims(ClaimID, MaxID)
SELECT ClaimID, MAX(ClaimTransactionID) MaxID--, MAX(CASE WHEN LastAssignment=1 THEN ClaimTransactionID ELSE NULL END) LastASN
FROM ClaimAccounting_Billings
GROUP BY ClaimID
HAVING MAX(CASE WHEN LastBilled=1 THEN ClaimTransactionID ELSE NULL END)<>MAX(ClaimTransactionID)



-- Reset PostingDate, create date, 
update caa
SET PostingDate = convert(varchar, CreatedDate, 1)
FROM ClaimAccounting_Billings caa
	INNER JOIN ClaimTransaction ct ON ct.PracticeID = caa.PracticeID AND ct.ClaimID = caa.ClaimID AND ct.ClaimTransactionID = caa.ClaimTransactionID
	INNER JOIN #Claims c on c.CLaimID = caa.ClaimID
	
-- Reset PostingDate, create date, 
alter table ClaimTransaction disable trigger all
update ct
SET PostingDate = convert(varchar, ct.CreatedDate, 1)
FROM ClaimAccounting_Billings caa
	INNER JOIN ClaimTransaction ct ON ct.PracticeID = caa.PracticeID AND ct.ClaimID = caa.ClaimID AND ct.ClaimTransactionID = caa.ClaimTransactionID
	INNER JOIN #Claims c on c.CLaimID = caa.ClaimID
alter table ClaimTransaction enable trigger all	



-- Rest EndClaimTransactionID, EndPostingDateID, LastAssignment, LastAssignmentOfEndPostingDate
SELECT CT.ClaimID, 
	ct.ClaimTransactionID, 
	EndClaimTransactionID = (select min(caa.ClaimTransactionID) from ClaimAccounting_Billings caa 
								WHERE caa.practiceID = ct.PracticeID AND caa.ClaimID = ct.ClaimID 
								AND caa.ClaimTransactionID > ct.ClaimTransactionID )
INTO #EndASN
FROM #Claims C INNER JOIN ClaimAccounting_Billings CT
ON C.ClaimID=CT.ClaimID
order by ct.ClaimTransactionID


update caa
SET EndClaimTransactionID = endCaa.ClaimTransactionID,
	EndPostingDate = endCaa.PostingDate,
	LastBilled = CASE WHEN C.EndClaimTransactionID IS NULL THEN 1 ELSE 0 END,
	DKPostingDateID = dbo.fn_GetDateKeySelectivityID(caa.PracticeID,caa.PostingDate,0,0),
	DKEndPostingDateID = dbo.fn_GetDateKeySelectivityID(endCaa.PracticeID,endCaa.PostingDate,0,0)
FROM 
	#EndASN c  
	INNER JOIN ClaimAccounting_Billings caa ON caa.ClaimTransactionID = c.ClaimTransactionID
	LEFT JOIN ClaimAccounting_Billings endCaa ON endCaa.ClaimTransactionID = c.EndClaimTransactionID

drop table #EndASN, #Claims

GO




