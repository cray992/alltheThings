USE Superbill_10721_dev
GO

BEGIN TRAN

-- Fix the primary policy relationship field
UPDATE 
	dbo.InsurancePolicy 
SET 
	PatientRelationshipToInsured = 'S'
WHERE 
	VendorImportID = 4 AND
	Precedence = 1 AND
	VendorID IN
	(
		SELECT ID FROM 
			dbo.[_import_4_1_Patientdemos] 
		WHERE 
			primary_ins_id <> '' AND 
			(
				policyholder_1st_name = '' OR 
				(
					policyholder_1st_name <> '' AND policyholder_1st_name = first_name AND policyholder_last_name = last_name
				)
			)	
	)


-- Fix the secondary policy relationship field
UPDATE 
	dbo.InsurancePolicy 
SET 
	PatientRelationshipToInsured = 'S'
WHERE 
	VendorImportID = 4 AND
	Precedence = 2 AND
	VendorID IN
	(
		SELECT ID FROM 
			dbo.[_import_4_1_Patientdemos] 
		WHERE 
			sec_ins_id <> '' AND 
			(
				sec_ins_ph_1st_name = '' OR 
				(
					sec_ins_ph_1st_name <> '' AND sec_ins_ph_1st_name = first_name AND sec_ins_ph_last_name = last_name
				)
			)	
	)
	
-- COMMIT TRAN

-- ROLLBACK TRAN