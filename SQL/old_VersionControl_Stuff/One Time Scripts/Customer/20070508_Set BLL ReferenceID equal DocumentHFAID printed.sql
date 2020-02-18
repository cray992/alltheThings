

-- case 21752, fixes the BLL transaction by resetting the referenceID = Document_HCFAID

select ct.PracticeID, ct.ClaimID, ct.ClaimTransactionID, db.DocumentBatchID, dh.Document_HCFAID
INTO #HCFA
	FROM DocumentBatch DB INNER JOIN Document D
	ON DB.DocumentBatchID=D.DocumentBatchID
	INNER JOIN  document_hcfa dh ON D.DocumentID=DH.DocumentID
	INNER JOIN  Document_HCFAClaim dhc ON DH.Document_HCFAID=DHC.Document_HCFAID
	INNER JOIN  ClaimTransaction ct ON ct.PracticeID = db.PracticeID AND ct.ReferenceID = db.DocumentBatchID AND ct.ClaimTransactionTypeCode = 'BLL'
		AND dhc.ClaimID = ct.ClaimID
		AND cast( ct.ReferenceID as varchar) = right( cast( notes as varchar), len( ct.ReferenceID ))
where Code = 'P' 


alter table claimTransaction disable trigger all
update ct
SET ReferenceID = Document_HCFAID
FROM claimTransaction ct
	INNER JOIN #HCFA h ON h.ClaimTransactionID = ct.ClaimTransactionID
WHERE
	ClaimTransactionTypeCode = 'BLL' AND Code = 'P' 
alter table claimTransaction enable trigger all

