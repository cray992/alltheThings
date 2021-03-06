/*----------------------------------------------------------------------------- 
Case 20706 - Claim Error Filter: Rejected Claims
-----------------------------------------------------------------------------*/


if NOT exists( select * from [ClaimTransactionType] where [ClaimTransactionTypeCode] = 'RJT' )
BEGIN
	INSERT INTO [ClaimTransactionType]
			   ([ClaimTransactionTypeCode]
			   ,[TypeName])
		 VALUES (
			   'RJT'
			   ,'Rejected')
END
GO

	alter table CLAIMTRANSACTION disable trigger all
GO
	-- migrate old data.
	INSERT	CLAIMTRANSACTION (
		ClaimTransactionTypeCode,
		ClaimID,
		PostingDate,
		Notes,
		PracticeID,
		PatientID,
		Claim_ProviderID)
	SELECT	
		'RJT',
		ClaimID,
		CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(c.ModifiedDate) AS DATETIME),110) AS DATETIME),
		'Auto-generated by migration',
		c.practiceID,
		c.patientID,
		doctorID
	FROM Claim c
		INNER JOIN EncounterProcedure ep ON ep.PracticeID = c.PracticeID AND ep.EncounterProcedureID = c.EncounterProcedureID
		INNER JOIN Encounter e ON e.PracticeID = ep.PracticeID AND e.EncounterID = ep.EncounterID
	WHERE C.CurrentPayerProcessingStatusTypeCode = 'R00' OR C.CurrentClearinghouseProcessingStatus = 'R'
		AND C.ClaimStatusCode <> 'C'
GO
	alter table CLAIMTRANSACTION enable trigger all
GO

