IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_ClaimsAreReadyForPrinting'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_ClaimsAreReadyForPrinting
GO

--===========================================================================
-- CLAIMS ARE READY FOR PRINTING
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_ClaimsAreReadyForPrinting (@practice_id INT)
RETURNS BIT
AS
BEGIN
	--Look for clams that are 'Ready' and assigned to insurance.
	IF EXISTS (
		SELECT	*
		FROM	Claim C
		INNER JOIN
			ClaimAccounting_Assignments CA
		ON	   CA.PracticeID = @practice_id
		AND	   CA.ClaimID = C.ClaimID
		AND	   CA.LastAssignment = 1
		AND	   CA.InsurancePolicyID IS NOT NULL
		WHERE	C.PracticeID = @practice_id
		AND	C.ClaimStatusCode IN ('R','P')
	)
		RETURN 1
	
	RETURN 0
END
GO