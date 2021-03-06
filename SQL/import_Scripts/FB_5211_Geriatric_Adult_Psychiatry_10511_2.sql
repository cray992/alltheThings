USE superbill_10511_dev 
--USE superbill_10511_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 1 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientJournalNote records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
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
	ReviewCode,
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
	carrier_name
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0  -- No unique id for insurance company going to have to join based on name
	,@VendorImportID
	,0  -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13  -- BillingFormID - int
	,'' -- ReviewCode - Empty string means just this practice
	,'CI' -- InsuranceProgramCode - char(2)
	,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D'  -- HCFASameAsInsuredFormatCode - char(1)
	,NULL  -- DefaultAdjustmentCode - varchar(10)
	,NULL  -- ReferringProviderNumberTypeID - int
	,1  -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U'  -- AnesthesiaType - varchar(1)
	,18  -- InstitutionalBillingFormID - int,
	,13
FROM dbo._import_1_1_rad5797C
WHERE
	carrier_name <> '' 
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Company Plan
PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan (
	PlanName,
	CreatedPracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	InsuranceCompanyID
)
SELECT DISTINCT 
	impIns.carrier_name
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo._import_1_1_rad5797C impIns
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	impIns.carrier_name = ic.InsuranceCompanyName AND
	ic.CreatedPracticeID = @PracticeID
WHERE
	impIns.carrier_name <> '' 
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID 
	,Prefix 
	,LastName 
	,FirstName
	,MiddleName 
	,Suffix 
	,[AddressLine1] 
    ,[AddressLine2] 
    ,[City] 
    ,[State] 
    ,[Country] 
    ,[ZipCode] 
	,Gender 
	,MaritalStatus 
	,HomePhone 
	,DOB
	,SSN 
	,MedicalRecordNumber
	,CreatedDate 
	,CreatedUserID 
	,ModifiedDate 
	,ModifiedUserID 
	,VendorID 
	,VendorImportID 
	,CollectionCategoryID 
	,Active 
	,SendEmailCorrespondence 
	,PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,''
	,impP.[pat_last_name]
	,impP.[pat_first_name]
	,''
	,''
	,LEFT(impP.[guar_addr_1], 256)
	,LEFT(impP.[guar_addr_2], 256)
	,LEFT(impP.[guar_city], 128)
	,LEFT(impP.[guar_state], 2)
	,'USA' 
	,LEFT(REPLACE(impP.[guar_zip_full], '-', ''), 9)
	,Case impP.[guar_sex] WHEN 'F' THEN 'F' WHEN 'M' THEN 'M' ELSE 'U' END
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[guar_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.[pat_date_of_birth]) WHEN 1 THEN impP.[pat_date_of_birth] ELSE NULL END 
	,LEFT(REPLACE(impP.[guar_ssn], '-', ''), 9)
	,impP.[acct_#]
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impP.acct_# -- Unique ID created during import, since customer didn't have a unique ID of their own
	,@VendorImportID
	,1
	,1
	,0
	,1
FROM dbo._import_1_1_rad5797C impP
INNER JOIN InsuranceCompanyPlan icp ON  impP.carrier_name = icp.PlanName
WHERE patient_note <> 'NON-PATIENT ACCOUNTS (MR)' AND
			patient_note <> 'Status 9 Message'
			

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- PatientJornal Note
PRINT ''
PRINT 'Inserting records into PatientJournalNote ...'
INSERT INTO [dbo].[PatientJournalNote] (
	[CreatedDate]
	,[CreatedUserID]
	,[ModifiedDate]
	,[ModifiedUserID]
	,[PatientID]
	,[UserName]
	,[SoftwareApplicationID]
	,[NoteMessage]
)
SELECT DISTINCT
	GETDATE(),
	0,
	GETDATE(),
	0,
	realP.PatientID,
	'',
	'K',
	patient_note
FROM _import_1_1_rad5797C impP
INNER JOIN Patient realP ON 
	impP.acct_# = realP.vendorID AND 
	realP.VendorImportID = @VendorImportID AND 
	realP.PracticeID = @PracticeID
WHERE impP.patient_note <> '' AND
	impP.patient_note <> 'NON-PATIENT ACCOUNTS (MR)' AND
	impP.patient_note <> 'Status 9 Message'

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




COMMIT TRAN