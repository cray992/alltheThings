--USE superbill_13836_dev
USE superbill_13836_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
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


--Inserting Primary Insurance Companies
PRINT ''
PRINT 'Inserting into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  ic.ins1 , -- InsuranceCompanyName - varchar(128)
          ic.ins1address1 , -- AddressLine1 - varchar(256)
          ic.ins1address2 , -- AddressLine2 - varchar(256)
          ic.ins1city , -- City - varchar(128)
          ic.ins1state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(ic.ins1zip,'-',''),9),-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(ic.ins1phone1,'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13, -- SecondaryPrecedenceBillingFormID - int
          ic.ins1address1 , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_5_1_Table1] ic
WHERE ic.ins1 <> '' AND ic.ins1 NOT IN (SELECT InsuranceCompanyName FROM insuranceCompany)
PRINT  CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records inserted'


PRINT ''
PRINT 'Inserting into Insurance Company Plan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
		  icp.ins1 , -- PlanName - varchar(128)
          icp.ins1address1 , -- AddressLine1 - varchar(256)
          icp.ins1address2 , -- AddressLine2 - varchar(256)
          icp.ins1city , -- City - varchar(128)
          icp.ins1state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(icp.ins1zip,'-',''),9),-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(icp.ins1phone1,'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID, --@PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.ins1address1 , -- VendorID - varchar(50)
          @VendorImportID --@VendorImportID  -- VendorImportID - int
FROM [dbo].[_import_5_1_Table1] icp
LEFT JOIN dbo.InsuranceCompany ic
ON icp.ins1address1 = ic.VendorID
WHERE icp.ins1 <> '' AND  icp.ins1 NOT IN (SELECT PlanName FROM dbo.InsuranceCompanyPlan)
PRINT  CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records inserted'



--Inserting Secondary Insurance Companies
PRINT ''
PRINT 'Inserting into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  ic.ins2 , -- InsuranceCompanyName - varchar(128)
          ic.ins2address1 , -- AddressLine1 - varchar(256)
          ic.ins2address2 , -- AddressLine2 - varchar(256)
          ic.ins2city , -- City - varchar(128)
          ic.ins2state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(ic.ins2zip,'-',''),9),-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(ic.ins2phone1,'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13, -- SecondaryPrecedenceBillingFormID - int
          ic.ins2address1 , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_5_1_Table1] ic
WHERE ic.ins2 <> '' AND ic.ins2 NOT IN (SELECT InsuranceCompanyName FROM dbo.InsuranceCompany)
PRINT  CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records inserted'


PRINT ''
PRINT 'Inserting into Insurance Company Plan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
		  icp.ins2 , -- PlanName - varchar(128)
          icp.ins2address1 , -- AddressLine1 - varchar(256)
          icp.ins2address2 , -- AddressLine2 - varchar(256)
          icp.ins2city , -- City - varchar(128)
          icp.ins2state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(icp.ins2zip,'-',''),9),-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(icp.ins2phone1,'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID, --@PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.ins2address1 , -- VendorID - varchar(50)
          @VendorImportID --@VendorImportID  -- VendorImportID - int
FROM [dbo].[_import_5_1_Table1] icp
LEFT JOIN dbo.InsuranceCompany ic
ON icp.ins2address1 = ic.VendorID
WHERE icp.ins2 <> '' AND icp.ins2 NOT IN (SELECT PlanName FROM dbo.InsuranceCompanyPlan)
PRINT  CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records inserted'



--Inserting Tertiary Insurance Companies
PRINT ''
PRINT 'Inserting into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  ic.ins3 , -- InsuranceCompanyName - varchar(128)
          ic.ins3address1 , -- AddressLine1 - varchar(256)
          ic.ins3address2 , -- AddressLine2 - varchar(256)
          ic.ins3city , -- City - varchar(128)
          ic.ins3state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(ic.ins3zip,'-',''),9),-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(ic.ins3phone1,'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13, -- SecondaryPrecedenceBillingFormID - int
          ic.ins3address1 , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_5_1_Table1] ic
WHERE ic.ins3 <> '' AND ic.ins3 NOT IN (SELECT InsuranceCompanyName FROM dbo.InsuranceCompany)
PRINT  CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records inserted'



PRINT ''
PRINT 'Inserting into Insurance Company Plan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
		  icp.ins3 , -- PlanName - varchar(128)
          icp.ins3address1 , -- AddressLine1 - varchar(256)
          icp.ins3address2 , -- AddressLine2 - varchar(256)
          icp.ins3city , -- City - varchar(128)
          icp.ins3state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(icp.ins3zip,'-',''),9),-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(icp.ins3phone1,'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID, --@PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.ins3address1 , -- VendorID - varchar(50)
          @VendorImportID --@VendorImportID  -- VendorImportID - int
FROM [dbo].[_import_5_1_Table1] icp
LEFT JOIN dbo.InsuranceCompany ic
ON icp.ins3address1 = ic.VendorID
WHERE icp.ins3 <> '' AND icp.ins3 NOT IN (SELECT PlanName FROM dbo.InsuranceCompanyPlan)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records inserted'





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
	Gender ,
	MaritalStatus ,
	HomePhone ,
	DOB ,
	SSN ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	MedicalRecordNumber ,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,pat.ptitle
	,pat.plname
	,pat.pfname
	,pat.pmname
	,pat.psuffix
	,pat.paddress1
	,pat.paddress2
	,pat.pcity
	,pat.pstate
	,''
	,LEFT(REPLACE(pat.pzip, '-', ''), 9)
	,pat.pgender
	,CASE WHEN pat.pmstatus = 'single' THEN 'S'
		WHEN pat.pmstatus = 'married' THEN 'M'
		ELSE ' ' END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.phphone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(pat.pdob) WHEN 1 THEN pat.pdob ELSE NULL END 
	,''
	,GETDATE()
	,0
	,GETDATE()
	,0
	,pat.patientid
	,pat.patientid -- VendorID unique hooray!
	,@VendorImportID
	,1
	,1
	,1
FROM dbo.[_import_5_1_Table1] pat
WHERE pat.pfname <> '' AND pat.plname <> '' AND NOT EXISTS (SELECT * FROM dbo.Patient p WHERE pat.patientid = p.medicalrecordnumber)

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
	,'Default Case'
	, 5   -- Commercial 
	,'Record created via data import, please review.'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,realP.VendorID
	,@VendorImportID
FROM dbo.Patient realP
WHERE realP.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #1
PRINT ''
PRINT 'Inserting records into InsurancePolicy #1...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PatientRelationshipToInsured,
	HolderFirstName ,
    HolderMiddleName ,
    HolderLastName ,
    HolderDOB ,
    HolderSSN ,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	HolderGender ,
    HolderAddressLine1 ,
    HolderAddressLine2 ,
    HolderCity ,
    HolderState ,
	HolderCountry ,
	HolderPhone ,
	Notes,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,ip.ins1policy
	,ip.ins1group
	,CASE WHEN ip.ins1phrelationship = 'Mother' THEN 'C'
		WHEN ip.ins1phrelationship = 'Father' THEN 'C'
		WHEN ip.ins1phrelationship = 'Spouse' THEN 'U'
		WHEN ip.ph1policyholderid = 'self' THEN 'S'
		ELSE 'O'  
	 END
	,CASE WHEN ip.ph1policyholderid <> 'self' AND ip.ph1policyholderid <> ''
		THEN ip.ph1fname
	 END
	,CASE WHEN ip.ph1policyholderid <> 'self' AND ip.ph1policyholderid <> ''
		THEN ip.ph1mname
	 END
	,CASE WHEN ip.ph1policyholderid <> 'self' AND ip.ph1policyholderid <> ''
		THEN ip.ph1lname
	 END
	,CASE WHEN ip.ph1policyholderid <> 'self' AND ip.ph1policyholderid <> ''
		THEN CASE ISDATE(ip.ph1birthday) WHEN 1  -- DOB - datetime
					THEN
						CASE WHEN ip.ph1birthday > GETDATE() 
							THEN DATEADD(yy, -100, ip.ph1birthday) 
							ELSE ip.ph1birthday
						END
			 END 
	 END
	,CASE WHEN ip.ph1policyholderid <> 'self' AND ip.ph1policyholderid <> ''
		THEN LEFT(REPLACE(ip.ph1ssn,'-',''),9)
	 END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE WHEN ip.ph1policyholderid <> 'self' AND ip.ph1policyholderid <> ''
		THEN ip.ph1sex
	 END
	,CASE WHEN ip.ph1policyholderid <> 'self' AND ip.ph1policyholderid <> ''
		THEN ip.ph1address1
	 END
	,CASE WHEN ip.ph1policyholderid <> 'self' AND ip.ph1policyholderid <> ''
		THEN ip.ph1address2
	 END
	,CASE WHEN ip.ph1policyholderid <> 'self' AND ip.ph1policyholderid <> ''
		THEN ip.ph1city
	 END
	,CASE WHEN ip.ph1policyholderid <> 'self' AND ip.ph1policyholderid <> ''
		THEN ip.ph1state
	 END
	,''
	,CASE WHEN ip.ph1policyholderid <> 'self' AND ip.ph1policyholderid <> ''
		THEN LEFT(REPLACE(REPLACE(REPLACE(ip.ph1phone1,'(',''),')',''),'-',''),10)
	 END
	,'Record created via data import, please review.     ' + ip.ins1comments + '     Deductible: ' + ip.ins1deductible
	,@PracticeID
	,ip.patientid + '1'
	,@VendorImportID
	,'Y'
FROM dbo.[_import_5_1_Table1] ip
INNER JOIN dbo.PatientCase pc ON 
	ip.patientid = pc.VendorID  AND
	pc.VendorImportID = @VendorImportId
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.AddressLine1 = ip.ins1address1 AND 
	ip.ins1address1 <> '' AND
	ip.ins1 = icp.PlanName
WHERE ip.ins1address1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #2
PRINT ''
PRINT 'Inserting records into InsurancePolicy #2...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PatientRelationshipToInsured,
	HolderFirstName ,
    HolderMiddleName ,
    HolderLastName ,
    HolderDOB ,
    HolderSSN ,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	HolderGender ,
    HolderAddressLine1 ,
    HolderAddressLine2 ,
    HolderCity ,
    HolderState ,
	HolderCountry ,
	HolderPhone ,
	Notes,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,ip.ins2policy
	,ip.ins2group
	,CASE WHEN ip.ins2phrelationship = 'Mother' THEN 'C'
		WHEN ip.ins2phrelationship = 'Father' THEN 'C'
		WHEN ip.ins2phrelationship = 'Spouse' THEN 'U'
		WHEN ip.ph2policyholderid = 'self' THEN 'S'
		ELSE 'O'  
	 END
	,CASE WHEN ip.ph2policyholderid <> 'self' AND ip.ph2policyholderid <> ''
		THEN ip.ph2fname
	 END
	,CASE WHEN ip.ph2policyholderid <> 'self' AND ip.ph2policyholderid <> ''
		THEN ip.ph2mname
	 END
	,CASE WHEN ip.ph2policyholderid <> 'self' AND ip.ph2policyholderid <> ''
		THEN ip.ph2lname
	 END
	,CASE WHEN ip.ph2policyholderid <> 'self' AND ip.ph2policyholderid <> ''
		THEN CASE ISDATE(ip.ph2birthday) WHEN 1  -- DOB - datetime
					THEN
						CASE WHEN ip.ph2birthday > GETDATE() 
							THEN DATEADD(yy, -100, ip.ph2birthday) 
							ELSE ip.ph2birthday
						END
			 END 
	 END
	,CASE WHEN ip.ph2policyholderid <> 'self' AND ip.ph2policyholderid <> ''
		THEN LEFT(REPLACE(ip.ph2ssn,'-',''),9)
	 END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE WHEN ip.ph2policyholderid <> 'self' AND ip.ph2policyholderid <> ''
		THEN ip.ph2sex
	 END
	,CASE WHEN ip.ph2policyholderid <> 'self' AND ip.ph2policyholderid <> ''
		THEN ip.ph2address1
	 END
	,CASE WHEN ip.ph2policyholderid <> 'self' AND ip.ph2policyholderid <> ''
		THEN ip.ph2address2
	 END
	,CASE WHEN ip.ph2policyholderid <> 'self' AND ip.ph2policyholderid <> ''
		THEN ip.ph2city
	 END
	,CASE WHEN ip.ph2policyholderid <> 'self' AND ip.ph2policyholderid <> ''
		THEN ip.ph2state
	 END
	,''
	,CASE WHEN ip.ph2policyholderid <> 'self' AND ip.ph2policyholderid <> ''
		THEN LEFT(REPLACE(REPLACE(REPLACE(ip.ph2phone1,'(',''),')',''),'-',''),10)
	 END
	,'Record created via data import, please review.     ' + ip.ins2comments + '     Deductible: ' + ip.ins2deductible
	,@PracticeID
	,ip.patientid + '2'
	,@VendorImportID
	,'Y'
FROM dbo.[_import_5_1_Table1] ip
INNER JOIN dbo.PatientCase pc ON 
	ip.patientid = pc.VendorID  AND
	pc.VendorImportID = @VendorImportId
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.AddressLine1 = ip.ins2address1 AND 
	ip.ins2address1 <> '' AND
	icp.PlanName = ip.ins2 
WHERE ip.ins2address1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #3
PRINT ''
PRINT 'Inserting records into InsurancePolicy #3...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PatientRelationshipToInsured,
	HolderFirstName ,
    HolderMiddleName ,
    HolderLastName ,
    HolderDOB ,
    HolderSSN ,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	HolderGender ,
    HolderAddressLine1 ,
    HolderAddressLine2 ,
    HolderCity ,
    HolderState ,
	HolderCountry ,
	HolderPhone ,
	Notes,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,3
	,ip.ins3policy
	,ip.ins3group
	,CASE WHEN ip.ins3phrelationship = 'Mother' THEN 'C'
		WHEN ip.ins3phrelationship = 'Father' THEN 'C'
		WHEN ip.ins3phrelationship = 'Spouse' THEN 'U'
		WHEN ip.ph3policyholderid = 'self' THEN 'S'
		ELSE 'O'  
	 END
	,CASE WHEN ip.ph3policyholderid <> 'self' AND ip.ph3policyholderid <> ''
		THEN ip.ph3fname
	 END
	,CASE WHEN ip.ph3policyholderid <> 'self' AND ip.ph3policyholderid <> ''
		THEN ip.ph3mname
	 END
	,CASE WHEN ip.ph3policyholderid <> 'self' AND ip.ph3policyholderid <> ''
		THEN ip.ph3lname
	 END
	,CASE WHEN ip.ph3policyholderid <> 'self' AND ip.ph3policyholderid <> ''
		THEN CASE ISDATE(ip.ph3birthday) WHEN 1  -- DOB - datetime
					THEN
						CASE WHEN ip.ph3birthday > GETDATE() 
							THEN DATEADD(yy, -100, ip.ph3birthday) 
							ELSE ip.ph3birthday
						END
			 END 
	 END
	,CASE WHEN ip.ph3policyholderid <> 'self' AND ip.ph3policyholderid <> ''
		THEN LEFT(REPLACE(ip.ph3ssn,'-',''),9)
	 END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE WHEN ip.ph3policyholderid <> 'self' AND ip.ph3policyholderid <> ''
		THEN ip.ph3sex
	 END
	,CASE WHEN ip.ph3policyholderid <> 'self' AND ip.ph3policyholderid <> ''
		THEN ip.ph3address1
	 END
	,CASE WHEN ip.ph3policyholderid <> 'self' AND ip.ph3policyholderid <> ''
		THEN ip.ph3address2
	 END
	,CASE WHEN ip.ph3policyholderid <> 'self' AND ip.ph3policyholderid <> ''
		THEN ip.ph3city
	 END
	,CASE WHEN ip.ph3policyholderid <> 'self' AND ip.ph3policyholderid <> ''
		THEN ip.ph3state
	 END
	,''
	,CASE WHEN ip.ph3policyholderid <> 'self' AND ip.ph3policyholderid <> ''
		THEN LEFT(REPLACE(REPLACE(REPLACE(ip.ph3phone1,'(',''),')',''),'-',''),10)
	 END
	,'Record created via data import, please review.    ' + ip.ins3comments + '     Deductible: ' + ip.ins3deductible
	,@PracticeID
	,ip.patientid + '3'
	,@VendorImportID
	,'Y'
FROM dbo.[_import_5_1_Table1] ip
INNER JOIN dbo.PatientCase pc ON 
	ip.patientid = pc.VendorID  AND
	pc.VendorImportID = @VendorImportId
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.AddressLine1 = ip.ins3address1 AND 
	ip.ins3address1 <> '' AND
	icp.PlanName = ip.ins3 
WHERE ip.ins3address1 <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT