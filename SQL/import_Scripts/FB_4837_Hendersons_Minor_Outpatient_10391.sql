USE superbill_10391_dev
--USE superbill_10391_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(100)
DECLARE @ImportNote VARCHAR(100)

SET @PracticeID = 1
SET @VendorName = 'Henderson''s Minor Outpatient Medicine, LLC'
SET @ImportNote = 'Initial import for customer 10391. FBID: 4837.'

-- If the VendorImport record doesn't exist create it
IF NOT EXISTS (SELECT * FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)
BEGIN
	INSERT INTO dbo.VendorImport (VendorName, VendorFormat, DateCreated, Notes) 
	VALUES (@VendorName, 'XLXS', GETDATE(), @ImportNote)
END

SET @VendorImportID = (SELECT VendorImportID FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'



-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
	AddressLine1,
	AddressLine2,
	City,
	[State],
	Country,
	ZipCode,
	Phone,
	CreatedPracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	BillSecondaryInsurance ,
	EClaimsAccepts ,
	BillingFormID ,
	InsuranceProgramCode ,
	HCFADiagnosisReferenceFormatCode ,
	HCFASameAsInsuredFormatCode ,
	DefaultAdjustmentCode ,
	ReferringProviderNumberTypeID ,
	NDCFormat ,
	UseFacilityID ,
	AnesthesiaType ,
	InstitutionalBillingFormID,
	SecondaryPrecedenceBillingFormID 
)
SELECT DISTINCT
	ins_plan_name
	,street1 -- yeah these are in the wrong fields in the source data
	,street2
	,city
	,state
	,'USA'
	,LEFT(REPLACE(zip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ins_code
	,@VendorImportID,
	0 , -- BillSecondaryInsurance - bit
	0, -- EClaimsAccepts - bit
	13 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	NULL , -- DefaultAdjustmentCode - varchar(10)
	NULL , -- ReferringProviderNumberTypeID - int
	1 , -- NDCFormat - int
	1, -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 , -- InstitutionalBillingFormID - int,
	13
FROM dbo.[_import_20120613_Insurance]
WHERE ins_plan_name <> ''


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Company Plan
PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan (
	PlanName,
	AddressLine1,
	AddressLine2,
	City,
	[State],
	Country,
	ZipCode,
	Phone,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	CreatedPracticeID,
	VendorID,
	VendorImportID,
	InsuranceCompanyID
)
SELECT DISTINCT
	impIns.ins_plan_name
	,impIns.street1
	,impIns.street2
	,impIns.city
	,impIns.state
	,'USA'
	,LEFT(REPLACE(impIns.zip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,ins_code
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_import_20120613_Insurance] impIns
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.VendorImportID = @VendorImportID AND
	impIns.ins_code = ic.VendorID
WHERE impIns.ins_plan_name <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Doctor Referring
PRINT ''
PRINT 'Inserting records into Doctor (Referring) ...'
INSERT INTO dbo.Doctor (
	PracticeID,
	Prefix,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	ActiveDoctor,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	VendorID,
	VendorImportID,
	[External],
	NPI,
	ProviderTypeID
)
SELECT DISTINCT
	@PracticeID
	,''
	,ref_provider_first_name
	,ref_provider_mi
	,ref_provider_last_name
	,''
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ref_provider_credential
	,ID
	,@VendorImportID
	,1
	,ref_provider_npi
	,1
FROM dbo.[_import_20120613_ReferringDoctor]
WHERE ref_provider_first_name <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT TRAN