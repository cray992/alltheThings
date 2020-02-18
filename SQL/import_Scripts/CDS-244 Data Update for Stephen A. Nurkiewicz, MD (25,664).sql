USE superbill_25664_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

PRINT ''
PRINT 'Updating Patient ZipCodes'
UPDATE dbo.Patient
 SET ZipCode = CASE WHEN LEN(imp.zip) IN (4,8) THEN '0' + imp.zip 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.zip) ELSE '' END ,
	 ModifiedDate = GETDATE()
 FROM dbo.Patient pat INNER JOIN dbo.[_import_4_1_PatientDemo] imp ON pat.VendorID = imp.patientid AND pat.VendorImportID = 4
 WHERE pat.ModifiedUserID = 0 AND pat.VendorImportID = 4 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Updating Referring Doctor ZipCodes'
UPDATE dbo.Doctor
 SET ZipCode = CASE WHEN LEN(imp.zip) IN (4,8) THEN '0' + imp.zip 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.zip) ELSE '' END ,
	 ModifiedDate = GETDATE()
 FROM dbo.Doctor doc INNER JOIN dbo.[_import_4_1_ReferringDoctor] imp ON doc.VendorID = imp.refcode AND doc.VendorImportID = 4
 WHERE doc.ModifiedUserID = 0 AND doc.VendorImportID = 4
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Updating Employer ZipCodes'
UPDATE dbo.Employers
 SET ZipCode = CASE WHEN LEN(imp.zip) IN (4,8) THEN '0' + imp.zip 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.zip) ELSE '' END ,
	 ModifiedDate = GETDATE()
 FROM dbo.Employers emp INNER JOIN dbo.[_import_4_1_Employer] imp ON emp.EmployerID = imp.employerid AND emp.CreatedUserID = 0
 WHERE emp.ModifiedUserID = 0 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Updating Insurance Company ZipCodes'
UPDATE dbo.InsuranceCompany
 SET ZipCode = CASE WHEN LEN(imp.zip) IN (4,8) THEN '0' + imp.zip 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.zip) ELSE '' END ,
	 ModifiedDate = GETDATE()
 FROM dbo.InsuranceCompany ins INNER JOIN dbo.[_import_4_1_InsuranceList] imp ON ins.VendorID = imp.inscode AND ins.CreatedUserID = 0
 WHERE ins.ModifiedUserID = 0 AND ins.VendorImportID = 4
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '
;

PRINT ''
PRINT 'Updating Insurance Company Plan ZipCodes'
UPDATE dbo.InsuranceCompanyPlan
 SET ZipCode = imp.ZipCode ,
     ModifiedDate = GETDATE()
 FROM dbo.InsuranceCompanyPlan insp INNER JOIN dbo.InsuranceCompany imp ON insp.VendorID = imp.VendorID AND insp.CreatedUserID = 0
 WHERE insp.ModifiedUserID = 0 AND insp.VendorImportID = 4
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Updating Insurance Policies - Guarantors - Precedence 1'
UPDATE dbo.InsurancePolicy
 SET HolderZipCode = CASE WHEN LEN(gua.zip) IN (4,8) THEN '0' + gua.zip 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(gua.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(gua.zip) ELSE '' END,
	 ModifiedDate = GETDATE()
 FROM dbo.InsurancePolicy inspo
	INNER JOIN dbo.[_import_4_1_PatientPolicy] imp ON
		imp.pripolicy = inspo.PolicyNumber AND imp.patientid = inspo.VendorID 
	LEFT JOIN dbo.[_import_4_1_Guarantor] gua ON 
		gua.guarantorid = imp.priguarantorid
WHERE inspo.PatientRelationshipToInsured <> 'S' AND inspo.ModifiedUserID = 0 AND inspo.Precedence = 1
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Updating Insurance Policies - Guarantors - Precedence 2'
UPDATE dbo.InsurancePolicy
 SET HolderZipCode = CASE WHEN LEN(gua.zip) IN (4,8) THEN '0' + gua.zip 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(gua.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(gua.zip) ELSE '' END,
	 ModifiedDate = GETDATE()
 FROM dbo.InsurancePolicy inspo
	INNER JOIN dbo.[_import_4_1_PatientPolicy] imp ON
		imp.secpolicy = inspo.PolicyNumber AND imp.patientid = inspo.VendorID 
	LEFT JOIN dbo.[_import_4_1_Guarantor] gua ON 
		gua.guarantorid = imp.secguarantorid
WHERE inspo.PatientRelationshipToInsured <> 'S' AND inspo.ModifiedUserID = 0 AND inspo.Precedence = 2
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Updating Insurance Policies - Guarantors - Precedence 3'
UPDATE dbo.InsurancePolicy
 SET HolderZipCode = CASE WHEN LEN(gua.zip) IN (4,8) THEN '0' + gua.zip 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(gua.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(gua.zip) ELSE '' END,
	 ModifiedDate = GETDATE()
 FROM dbo.InsurancePolicy inspo
	INNER JOIN dbo.[_import_4_1_PatientPolicy] imp ON
		imp.terpolicy = inspo.PolicyNumber AND imp.patientid = inspo.VendorID 
	LEFT JOIN dbo.[_import_4_1_Guarantor] gua ON 
		gua.guarantorid = imp.terguarantorid
WHERE inspo.PatientRelationshipToInsured <> 'S' AND inspo.ModifiedUserID = 0 AND inspo.Precedence = 3
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


--COMMIT
--ROLLBACK
