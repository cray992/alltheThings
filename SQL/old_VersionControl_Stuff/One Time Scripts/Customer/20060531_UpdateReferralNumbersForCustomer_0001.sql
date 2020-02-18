/*=============================================================================
Case 8038 - Change eclaims billing procedures to support Medipass numbers 
=============================================================================*/

/* Insert new provider number type of "Referral Number". */

INSERT INTO [ProviderNumberType]
	([ProviderNumberTypeID]
	,[TypeName]
	,[ANSIReferenceIdentificationQualifier]
	,[SortOrder])
VALUES
	(40
	,'Referral Number (MediPass)'
	,'9F'
	,300)

--GO
--
--/* Update current Medicaid numbers to become referral numbers if they match the original other IDs. */
--
--UPDATE	ProviderNumber
--SET		ProviderNumberTypeID = 40
--WHERE	ProviderNumberID IN
--	( SELECT
--		PN.ProviderNumberID
--	FROM 
--		ProviderNumber PN 
--		JOIN ReferringPhysicianToDoctorMigrationLog L ON PN.DoctorID = L.TrgtDoctorID
--		JOIN Doctor D ON D.DoctorID = L.TrgtDoctorID
--	WHERE
--		PN.ProviderNumberTypeID = 24 
--		AND PN.ProviderNumber = L.SrcOtherID
--		AND D.PracticeID = 24 )
--
--GO
--
--/* Create the new referral numbers from the original Other ID values of referring physicians. */
--
--INSERT INTO [ProviderNumber]
--	([DoctorID]
--	,[ProviderNumberTypeID]
--	,[ProviderNumber]
--	,[AttachConditionsTypeID])
--SELECT
--	D.DoctorID
--	,40
--	,SrcOtherID
--	,1
--FROM
--	ReferringPhysicianToDoctorMigrationLog L
--	JOIN Doctor D ON D.DoctorID = L.TrgtDoctorID
--	LEFT JOIN ProviderNumber PN ON PN.DoctorID = D.DoctorID
--		AND PN.ProviderNumberTypeID = 40
--WHERE 
--	(L.SrcOtherID IS NOT NULL) 
--	AND (L.SrcOtherID <> '')
--	AND PN.ProviderNumberTypeID IS NULL
--	AND D.PracticeID = 24
--
--GO