USE superbill_8023_dev
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 24
SET @VendorImportID = 3 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating InsurancePolicy 1 of 2 ...'
UPDATE dbo.InsurancePolicy 
SET Notes = i.notes ,
	phone = i.phone ,
	fax = i.fax , 
	copay = i.copay ,
	Deductible = i.deductible , 
	Active = i.active ,
	ReleaseofInformation = 'Y' ,
	HolderDOB = CASE WHEN ISDATE(i.holderdob) = 1 THEN i.holderdob ELSE NULL END
FROM dbo.[_import_3_24_Sheet1] i
INNER JOIN dbo.InsurancePolicy ip ON
	i.insurancepolicyid = ip.VendorID AND
	ip.VendorImportID = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating InsurancePolicy 2 of 2 ...'
UPDATE dbo.InsurancePolicy
SET PolicyNumber = i.policynumber , 
	GroupNumber = i.groupnumber ,
	DependentPolicyNumber = i.dependentpolicynumber
FROM dbo.[_import_3_24_Sheet2] i
INNER JOIN dbo.InsurancePolicy ip ON
	i.insurancepolicyid = ip.VendorID AND
	ip.VendorImportID = 2
WHERE ModifiedUserID = -50
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--COMMIT
--ROLLBACK  

