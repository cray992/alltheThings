/*

	Case 3396

*/

UPDATE
	Permissions
SET
	PermissionGroupID = 15
WHERE 
	PermissionValue IN (
				'NewSharedProcedure',
				'ReadSharedProcedure',
				'NewSharedProcedureModifier',
				'ReadSharedProcedureModifier',
				'NewSharedDiagnosis',
				'ReadSharedDiagnosis',
				'FindSharedInsurancePlan',
				'FindSharedProcedure',
				'FindSharedProcedureModifier',
				'FindSharedDiagnosis'
			)
GO
