
/* Add the CurrentClearinghouseProcessingStatus column... */
ALTER TABLE dbo.Claim ADD
	CurrentClearinghouseProcessingStatus varchar(1) NULL
GO

/* Populate the CurrentClearinghouseProcessingStatus column with the current value in the ClearinghouseProcessingStatus column... */
UPDATE	Claim
SET		CurrentClearinghouseProcessingStatus = ClearinghouseProcessingStatus
WHERE	ClearinghouseProcessingStatus IS NOT NULL
GO

/* Reset CurrentClearinghouseProcessingStatus to 'NULL' for those claims that have been re-billed... */
UPDATE	Claim
SET		CurrentClearinghouseProcessingStatus = NULL,
		CurrentPayerProcessingStatusTypeCode = NULL
WHERE	ClaimID IN (
		SELECT 
			CORR_TRX.ClaimID
		FROM 
			(	SELECT 
					CT.ClaimID,
					MAX(CT.ClaimTransactionID) AS 'ClaimTransactionID'
				FROM	ClaimTransaction CT
				WHERE	CT.ClaimTransactionTypeCode = 'EDI' AND Notes LIKE '%Error:%'
				GROUP BY ClaimID ) AS EDI_TRX
			JOIN ClaimTransaction CORR_TRX
				ON CORR_TRX.ClaimID = EDI_TRX.ClaimID
				AND CORR_TRX.ClaimTransactionID > EDI_TRX.ClaimTransactionID
				AND CORR_TRX.ClaimTransactionTypeCode IN ( 'ASN', 'BLL', 'END', 'RAS', 'XXX' )
		GROUP BY
			CORR_TRX.ClaimID )
		AND ClearinghouseProcessingStatus = 'R'
GO
