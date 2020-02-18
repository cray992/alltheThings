--USE superbill_13760_dev
USE superbill_13760_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.patient WHERE PracticeID = @PracticeID AND 
		VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientJournalNote records deleted'	
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'

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
	PhoneExt,
	Fax,
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
	ic.[carriername]
	,ic.[address1]
	,ic.[address2]
	,ic.city
	,ic.[state]
	,''
	,LEFT(REPLACE(ic.zipcode, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ic.[eligibilityphonenumber], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,[eligibilityphoneextension]
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ic.[faxnumber], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ic.[carrieruid] -- Hope it's unique!
	,@VendorImportID
	,0  -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13  -- BillingFormID - int
	,CASE WHEN ic.typeofinsurance = 'MB' THEN 'MB' 
		  WHEN ic.typeofinsurance = 'MC' THEN 'MC' 
		  ELSE 'CI' end   -- InsuranceProgramCode - char(2)
	,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D'  -- HCFASameAsInsuredFormatCode - char(1)
	,NULL -- DefaultAdjustmentCode - varchar(10)
	,NULL  -- ReferringProviderNumberTypeID - int
	,1  -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U'  -- AnesthesiaType - varchar(1)
	,18  -- InstitutionalBillingFormID - int,
	,13
FROM dbo.[_import_4_1_Carriers] ic
WHERE ic.carriername <> '' AND ic.carriername <> '(***DO NOT USE***)'
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
	PhoneExt,
	Fax,
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
	icp.[carriername]
	,icp.[address1]
	,icp.[address2]
	,icp.city
	,icp.[state]
	,''
	,LEFT(REPLACE(icp.zipcode, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(icp.[eligibilityphonenumber], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,[eligibilityphoneextension]
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(icp.[faxnumber], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,icp.[carrieruid] -- Hope it's unique!
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_import_4_1_Carriers] icp
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	icp.[carrieruid] = ic.VendorID
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'





-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	Prefix ,
	LastName ,
	FirstName ,
	MiddleName ,
	Suffix ,
	AddressLine1 ,
	AddressLine2 ,
	City ,
	[State] ,
	Country ,
	ZipCode ,
	HomePhone ,
	MobilePhone,
	DOB ,
	SSN ,
	Gender ,
	PrimaryCarePhysicianID ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	MedicalRecordNumber,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,''
	,pat.[lastname]
	,pat.[firstname]
	,pat.[middlename]
	,''
	,pat.[address2]
	,pat.[address1]
	,pat.[city]
	,LEFT(pat.[state], 2)
	,''
	,LEFT(REPLACE(pat.[zipcode], '-', ''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[homephone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[other], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,pat.[dob]
	,LEFT(REPLACE(pat.[ssn], '-', ''), 9)
	,pat.[gender]
	,2
	,GETDATE()
	,0
	,GETDATE()
	,0
	,pat.chartnumber -- MedicalRecordNumber
	,pat.[patientuid] -- VendorID unique hooray!
	,@VendorImportID
	,1
	,1
	,1
FROM dbo.[_import_4_1_PatientInfo] pat
WHERE pat.firstname <> '' AND pat.lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Case - All records
PRINT ''
PRINT 'Inserting records into PatientCase ...'
INSERT INTO dbo.PatientCase (
	PatientID,
	[Name],
	PayerScenarioID,
	Notes,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	PracticeID,
	VendorID,
	VendorImportID
)
SELECT DISTINCT
	realP.PatientID
	,'Default Case '  
	,5
	,'Record created via data import, please review.'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,realP.VendorID 
	,@VendorImportID
FROM dbo.Patient realP
WHERE realp.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy 
PRINT ''
PRINT 'Inserting records into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupName,
	GroupNumber,
	PatientRelationshipToInsured,
	DependentPolicyNumber,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	Copay,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation,
	HolderFirstName,
	HolderLastName,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderGender,
	HolderDOB,
	HolderPhone,
	HolderSSN
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,impPC.sequencenumber
	,impPC.subscriberidnumber
	,LEFT(impPC.groupname, 14)
	,impPC.groupnumber
	,CASE WHEN pat.firstname <> res.firstname THEN 'O' ELSE 'S' END 
	,CASE WHEN pat.firstname <> res.firstname THEN impPC.subscriberidnumber ELSE '' END 
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impPC.copaydollaramount
	,@PracticeID
	,impPC.patientfid
	,@VendorImportID
	,'Y'
	,CASE WHEN pat.firstname <> res.firstname THEN res.firstname ELSE '' END
	,CASE WHEN pat.firstname <> res.firstname THEN res.lastname ELSE '' END
	,CASE WHEN pat.firstname <> res.firstname THEN res.address1 ELSE '' END
	,CASE WHEN pat.firstname <> res.firstname THEN res.address2 ELSE '' END
	,CASE WHEN pat.firstname <> res.firstname THEN res.city ELSE '' END
	,CASE WHEN pat.firstname <> res.firstname THEN res.state ELSE '' END
	,CASE WHEN pat.firstname <> res.firstname THEN res.gender ELSE '' END
	,CASE WHEN pat.firstname <> res.firstname THEN res.dob ELSE '' END 
	,CASE WHEN pat.firstname <> res.firstname THEN res.homephone ELSE '' END
	,CASE WHEN pat.firstname <> res.firstname THEN res.ssn ELSE '' END
FROM dbo.[_import_4_1_Coverages] impPC
INNER JOIN dbo.PatientCase pc ON 
	impPC.patientfid = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	impPC.carrierfid = icp.VendorId AND
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.Patient pat ON 
	impPC.patientfid = pat.VendorID
INNER JOIN dbo.[_import_4_1_ResponsibleParties] res ON
	impPC.responsiblepartysubscriberfid = res.responsiblepartyuid
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Journal Notes
PRINT ''
PRINT 'Inserting records into PatientJournalNotes ...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          NoteMessage 
        )
SELECT    note.createdate , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
		  GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          note.note  -- NoteMessage - varchar(max)
        
FROM dbo.[_import_4_1_Note] note
INNER JOIN dbo.Patient pat ON
	note.patientfid = pat.VendorID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Journal Notes
PRINT ''
PRINT 'Inserting records into PatientJournalNotes ...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          NoteMessage 
        )
SELECT    memo.created , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
		  GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          memo.memotext  -- NoteMessage - varchar(max)
FROM dbo.[_import_4_1_Memos] memo
INNER JOIN dbo.Patient pat ON
	memo.[patientfid] = pat.VendorID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN
