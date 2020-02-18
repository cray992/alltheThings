USE superbill_27261_dev
--USE superbill_27261_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 6
SET @PracticeID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Updating Patient DOB...'
UPDATE dbo.Patient
SET DOB = i.dateofbirth
FROM dbo.[_import_7_1_Patient] i
	INNER JOIN dbo.Patient p ON
		i.firstname + i.lastname + i.dateofbirthbad = p.VendorID AND
		p.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Updating Policy Holder DOB...'
UPDATE dbo.InsurancePolicy
SET HolderDOB = i.subscriberdob
FROM dbo.[_import_7_1_Policy] i
	INNER JOIN dbo.InsurancePolicy ip ON
		i.firstname + i.lastname + i.patientdob = ip.VendorID AND
		ip.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

--ROLLBACK
--COMMIT
