USE superbill_3182_dev
--USE superbill_3182_prod
GO

/*
UPDATE 
	dbo.Patient
SET
	Patient.ReferringPhysicianID = dbo.[_import_Ref_Docs].ReferringPhysicianID
FROM 
	dbo.[_import_Ref_Docs]
WHERE
	Patient.ReferringPhysicianID IS NULL AND
	Patient.PracticeID = dbo.[_import_Ref_Docs].PracticeID
*/