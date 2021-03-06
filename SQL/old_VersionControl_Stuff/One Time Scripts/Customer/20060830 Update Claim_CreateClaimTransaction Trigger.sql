IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'tr_Claim_CreateClaimTransaction'
	AND	TYPE = 'TR'
)
	DROP TRIGGER dbo.tr_Claim_CreateClaimTransaction
GO

CREATE TRIGGER dbo.tr_Claim_CreateClaimTransaction
ON	dbo.Claim
FOR	INSERT

AS
BEGIN
	INSERT INTO ClaimTransaction (
		ClaimID, 
		ClaimTransactionTypeCode, 
		PatientID,
		PracticeID, 
		PostingDate, 
		Amount,
		Notes, 
		Claim_ProviderID,
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID )
	SELECT 	I.ClaimID, 
		'CST', 
		E.PatientID, 
		E.PracticeID, 
		CAST(CONVERT(CHAR(10),E.PostingDate,110) AS DATETIME),
		ISNULL(EP.ServiceUnitCount,0)*ISNULL(EP.ServiceChargeAmount,0) Amount,
		'Claim created for '+ CAST(ISNULL(EP.ServiceUnitCount,0)*ISNULL(EP.ServiceChargeAmount,0) AS VARCHAR(20)),
		E.DoctorID,
		GETDATE(),
		I.CreatedUserID,
		GETDATE(),
		I.CreatedUserID		
	FROM 	inserted I 
		INNER JOIN EncounterProcedure EP ON I.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN Encounter E ON EP.EncounterID=E.EncounterID
END
