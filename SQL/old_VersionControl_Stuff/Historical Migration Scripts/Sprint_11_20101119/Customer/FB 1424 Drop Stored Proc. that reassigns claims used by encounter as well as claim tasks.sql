/**********************************************************************************************
** Name		: EncounterDataProvider_ReassignExistingClaimsBasedOnCase
**
** Desc         : Reassigns any existing claims for an encounter based on the first insurance for
**		  the case. If no insurance exists assigns claims to patient.
**
** Test		: EncounterDataProvider_ReassignExistingClaimsBasedOnCase 153
**
***********************************************************************************************/

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'EncounterDataProvider_ReassignExistingClaimsBasedOnCase'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.EncounterDataProvider_ReassignExistingClaimsBasedOnCase
