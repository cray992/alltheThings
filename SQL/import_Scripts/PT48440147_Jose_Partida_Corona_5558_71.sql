--USE superbill_5558_dev
USE superbill_5558_prod
GO


 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 71
SET @VendorImportID = 5 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

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
DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID AND [External] = 1
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
		
-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany Primary...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
	AddressLine1,
	City,
	[State],
	Country,
	ZipCode,
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
	ic.[primaryins]
	,ic.[primaryinsaddress1]
	,ic.[primaryinscity]
	,ic.[primaryinsstate]
	,''
	,LEFT(REPLACE(ic.[primaryinszip], '-',''), 9)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ic.[primaryins] -- Hope it's unique!
	,@VendorImportID
	,0  -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13  -- BillingFormID - int
	,'CI'  -- InsuranceProgramCode - char(2)
	,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D'  -- HCFASameAsInsuredFormatCode - char(1)
	,NULL -- DefaultAdjustmentCode - varchar(10)
	,NULL  -- ReferringProviderNumberTypeID - int
	,1  -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U'  -- AnesthesiaType - varchar(1)
	,18  -- InstitutionalBillingFormID - int,
	,13
FROM dbo.[_import_5_71_Sheet1] ic
WHERE ic.primaryins <> '' AND ic.primaryins <> 'SELF PAY' AND ic.primaryins <> 'No Insurance'
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany Secondary...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
	AddressLine1,
	City,
	[State],
	Country,
	ZipCode,
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
	ic.[secondaryins]
	,ic.[secondaryinsaddress1]
	,ic.[secondaryinscity]
	,ic.[secondaryinsstate]
	,''
	,LEFT(REPLACE(ic.[secondaryinszip], '-',''), 9)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ic.[secondaryins] -- Hope it's unique!
	,@VendorImportID
	,0  -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13  -- BillingFormID - int
	,'CI'  -- InsuranceProgramCode - char(2)
	,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D'  -- HCFASameAsInsuredFormatCode - char(1)
	,NULL -- DefaultAdjustmentCode - varchar(10)
	,NULL  -- ReferringProviderNumberTypeID - int
	,1  -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U'  -- AnesthesiaType - varchar(1)
	,18  -- InstitutionalBillingFormID - int,
	,13
FROM dbo.[_import_5_71_Sheet1] ic
WHERE ic.secondaryins NOT IN (SELECT InsuranceCompanyName FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID)
	AND ic.secondaryins <> '' AND ic.secondaryins <> 'SELF PAY' AND ic.secondaryins <> 'No Insurance'
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany Tertiary...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
	AddressLine1,
	City,
	[State],
	Country,
	ZipCode,
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
	ic.[tertiaryins]
	,ic.[tertiaryinsaddress1]
	,ic.[tertiaryinscity]
	,ic.[tertiaryinsstate]
	,''
	,LEFT(REPLACE(ic.[tertiaryinszip], '-',''), 9)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ic.[tertiaryins] -- Hope it's unique!
	,@VendorImportID
	,0  -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13  -- BillingFormID - int
	,'CI'  -- InsuranceProgramCode - char(2)
	,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D'  -- HCFASameAsInsuredFormatCode - char(1)
	,NULL -- DefaultAdjustmentCode - varchar(10)
	,NULL  -- ReferringProviderNumberTypeID - int
	,1  -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U'  -- AnesthesiaType - varchar(1)
	,18  -- InstitutionalBillingFormID - int,
	,13
FROM dbo.[_import_5_71_Sheet1] ic
WHERE ic.tertiaryins NOT IN (SELECT InsuranceCompanyName FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID)
	AND ic.tertiaryins <> '' AND ic.tertiaryins <> 'SELF PAY' AND ic.tertiaryins <> 'No Insurance'
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
	icp.[InsuranceCompanyName]
	,icp.[AddressLine1]
	,icp.[AddressLine2]
	,icp.[City]
	,icp.[State]
	,''
	,LEFT(REPLACE(icp.[ZipCode], '-',''), 9)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,icp.InsuranceCompanyID -- Hope it's unique!
	,@VendorImportID
	,icp.InsuranceCompanyID
FROM dbo.InsuranceCompany icp
--LEFT JOIN dbo.[_import_5_71_Sheet1] impicp ON
--	icp.InsuranceCompanyName = impicp.primaryins AND 
--	icp.AddressLine1 = impicp.primaryinsaddress1
WHERE icp.CreatedPracticeID = @PracticeID AND
	  icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Doctor ...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          [External] 
        )
SELECT DISTINCT   
		  @PracticeID ,
		  '' ,
		  doc.ref6tmfirst ,
		  '' ,
		  doc.referringlast ,
		  '' ,
		  1 ,
		  GETDATE() ,
		  0 , 
		  GETDATE() ,
		  0 ,
		  doc.ref6tmfirst ,
		  @VendorImportID ,
		  1 
FROM dbo.[_import_5_71_Sheet1] doc
WHERE ref6tmfirst <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	ReferringPhysicianID ,
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
	MaritalStatus , 
	HomePhone ,
	MobilePhone ,
	WorkPhone ,
	DOB ,
	SSN ,
	Gender ,
	EmailAddress ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	PrimaryProviderID ,
	MedicalRecordNumber ,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,ref.DoctorID
	,''
	,pat.[last]
	,pat.[first]
	,pat.[middeinitial]
	,''
	,pat.[address1]
	,pat.[address2]
	,pat.[city]
	,LEFT(pat.[state], 2)
	,''
	,LEFT(REPLACE(pat.[zipcode], '-', ''), 9)
	,CASE pat.maritalstatus WHEN 'married' THEN 'M'
							WHEN 'divorced' THEN 'D'
							WHEN 'widowed' THEN 'W'
							ELSE ''
	 END -- Maritalstatus 
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[homephone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[celphone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[workphone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,pat.bathdate
	--,CASE ISDATE(pat.[bathdate]) WHEN 1 
	--	THEN CASE WHEN pat.[bathdate] > GETDATE() THEN DATEADD(year, -100, pat.[bathdate])
	--			ELSE pat.[bathdate] END
	--	ELSE NULL END 
	,LEFT(REPLACE(pat.[ssn], '-', ''), 9)
	,pat.[sex]
	,pat.[email]
	,GETDATE()
	,0
	,GETDATE()
	,0
	,doc.DoctorID
	,pat.[MedicalRecordNumber]
	,pat.[MedicalRecordNumber] -- VendorID unique hooray!
	,@VendorImportID
	,1
	,1
	,1
FROM dbo.[_import_5_71_Sheet1] pat
LEFT JOIN dbo.Doctor doc ON
	doc.FirstName = pat.providerfirst AND
	doc.LastName = REPLACE(REPLACE(pat.providerlast, 'MD', ''), 'PAC', '') AND
	doc.PracticeID = @PracticeID AND
	doc.[External] = 0
LEFT JOIN dbo.Doctor ref ON
	ref.FirstName = pat.ref6tmfirst AND
	ref.LastName = pat.referringlast AND
	ref.PracticeID = @PracticeID AND
	ref.[External] = 1
WHERE pat.first <> '' AND pat.last <> ''
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



-- Insurance Policy #1
PRINT ''
PRINT 'Inserting records into InsurancePolicy Primary...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PatientRelationshipToInsured,
	HolderFirstName,
	HolderLastName,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderZipCode,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,impPC.primaryinsid
	,LEFT(impPC.primarygroup, 14)
	,'S'
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[reternigrist]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subsatberlast]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subscriberandress1]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subscriberaddress2]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subsabercity]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subscriberstate]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subsvberzip]
			ELSE '' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,@VendorImportID
	,'Y'
FROM dbo.[_import_5_71_Sheet1] impPC
INNER JOIN dbo.PatientCase pc ON 
	impPC.[MedicalRecordNumber] = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsuranceCompany ic ON
	ic.VendorID = impPC.primaryins AND
	ic.AddressLine1 = impPC.primaryinsaddress1 AND 
	ic.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	ic.InsuranceCompanyID = icp.InsuranceCompanyID AND
	icp.VendorImportID = @VendorImportID
WHERE impPC.primaryins <> '''' AND 
	  impPC.primaryins <> 'SELF PAY' AND 
	  impPC.primaryins <> 'No Insurance'
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Policy #2
PRINT ''
PRINT 'Inserting records into InsurancePolicy Secondary...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PatientRelationshipToInsured,
	HolderFirstName,
	HolderLastName,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderZipCode,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,impPC.secondaryinsid
	,LEFT(impPC.secondarygroup, 14)
	,'S'
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[reternigrist]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subsatberlast]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subscriberandress1]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subscriberaddress2]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subsabercity]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subscriberstate]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subsvberzip]
			ELSE '' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,@VendorImportID
	,'Y'
FROM dbo.[_import_5_71_Sheet1] impPC
INNER JOIN dbo.PatientCase pc ON 
	impPC.[MedicalRecordNumber] = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsuranceCompany ic ON
	ic.VendorID = impPC.secondaryins AND
	ic.AddressLine1 = impPC.secondaryinsaddress1 AND 
	ic.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	ic.InsuranceCompanyID = icp.InsuranceCompanyID AND
	icp.VendorImportID = @VendorImportID
WHERE impPC.secondaryins <> '' AND 
	  impPC.secondaryins <> 'SELF PAY' AND 
	  impPC.secondaryins <> 'No Insurance'
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #3
PRINT ''
PRINT 'Inserting records into InsurancePolicy Tertiary...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PatientRelationshipToInsured,
	HolderFirstName,
	HolderLastName,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderZipCode,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,3
	,impPC.tertiaryinsid
	,LEFT(impPC.tertiarygroup, 14)
	,'S'
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[reternigrist]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subsatberlast]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subscriberandress1]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subscriberaddress2]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subsabercity]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subscriberstate]
			ELSE '' END
	,CASE WHEN impPC.[subsatberlast] <> impPC.[last] AND impPC.[reternigrist] <> impPC.[first] THEN impPC.[subsvberzip]
			ELSE '' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,@VendorImportID
	,'Y'
FROM dbo.[_import_5_71_Sheet1] impPC
INNER JOIN dbo.PatientCase pc ON 
	impPC.[MedicalRecordNumber] = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsuranceCompany ic ON
	ic.VendorID = impPC.tertiaryins AND
	ic.AddressLine1 = impPC.tertiaryinsaddress1 AND 
	ic.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	ic.InsuranceCompanyID = icp.InsuranceCompanyID AND
	icp.VendorImportID = @VendorImportID
WHERE impPC.tertiaryins <> '' AND 
	  impPC.tertiaryins <> 'SELF PAY' AND 
	  impPC.tertiaryins <> 'No Insurance'
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Updated PatientCase ...'
UPDATE dbo.PatientCase
	SET PayerScenarioID = 11
	WHERE PatientCaseID NOT IN (SELECT  PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	AND PracticeID = @PracticeID AND dbo.PatientCase.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records updated'


COMMIT TRAN