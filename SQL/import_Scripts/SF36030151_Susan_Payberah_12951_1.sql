--USE superbill_12951_dev
USE superbill_12951_prod
go
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT


SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM DBO.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM DBO.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Plan records deleted'
DELETE FROM DBO.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM DBO.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM DBO.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM DBO.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND 
			VendorImportID = @VendorImportID)
	PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM DBO.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'



-- Insurance Company
PRINT ''
PRINT ' Inserting into Insurance Company ...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
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
SELECT   ic.name , -- InsuranceCompanyName - varchar(128)
          ic.address1 , -- AddressLine1 - varchar(256)
          ic.address2 , -- AddressLine2 - varchar(256)
          ic.city , -- City - varchar(128)
          ic.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
		  LEFT(REPLACE(ic.zipcode, '-', ''), 9) , -- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ic.phone, '(', ''), ')', ''), '-', ''), ' ', ''), 10) , -- Phone - varchar(10)
          @PracticeID ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ic.carrcode , --Customer provided unique id
          @VendorImportID , 
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
FROM dbo.[_import_1_1_InsuranceCarriers] ic 
PRINT '   ' + CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'




-- Insurance Company Plan
PRINT ''
PRINT ' Inserting into Insurance Company Plan ...'
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
          Copay ,
          VendorID ,
          VendorImportID
        )
SELECT   DISTINCT
		  CASE WHEN icp.coveragename = '' THEN ic.InsuranceCompanyName 
				ELSE icp.coveragename
				END , -- PlanName - varchar(128)
          ic.AddressLine1 , -- AddressLine1 - varchar(256)
          ic.AddressLine2 , -- AddressLine2 - varchar(256)
          ic.City , -- City - varchar(128)
          ic.[STATE] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ic.ZipCode , -- ZipCode - varchar(9)
          ic.Phone , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.fixedcopay, -- Copay - money
          icp.carrcode + coveragename,
          --icp.policyuniqueid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientInsurance] icp
LEFT JOIN dbo.InsuranceCompany ic ON 
	icp.carrcode = ic.VendorID AND 
	ic.VendorImportID = @VendorImportID

PRINT '   ' + CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'




-- Doctor
PRINT ''
PRINT ' Inserting into Doctor ...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          WorkPhone ,
          PagerPhone ,
          EmailAddress ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          NPI ,
          TaxonomyCode ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] 
        )
select    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          doc.firstname , -- FirstName - varchar(64)
          doc.middlename , 
          doc.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          doc.address1 , -- AddressLine1 - varchar(256)
          doc.address2 , -- AddressLine2 - varchar(256)
          doc.city , -- City - varchar(128)
          doc.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(doc.zipcode, '-', ''), 9) , -- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(doc.phone, ')', ''), '(',''), '-', ''), 10) , -- WorkPhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(doc.pager, ')', ''), '(',''), '-', ''), 10) , -- PagerPhone - varchar(10)
          LEFT(doc.email, 256) , -- EmailAddress - varchar(256)
          CASE WHEN doc.license <> '' 
			THEN  'License: ' + doc.license 
			ELSE '' 
			END ,
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          LEFT(doc.designation, 8) , -- Degree - varchar(8)
          doc.npi ,
          TaxonomyCode , -- TaxonomyCode - char(10)
          doc.referprovcode , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(REPLACE(REPLACE(REPLACE(doc.fax, ')', ''), '(',''), '-', ''), 10) , -- FaxNumber - varchar(10)
          1  -- External - bit
 
FROM dbo.[_import_1_1_ReferingProviders] doc
LEFT JOIN DBO.TaxonomyCode ON DOC.taxonomy = TaxonomyCode

PRINT '   ' + CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'




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
	WorkPhone ,
	DOB ,
	SSN ,
	EmailAddress,
	ResponsibleRelationshipToPatient,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	DefaultServiceLocationID,
	VendorID,
	VendorImportID,
	CollectionCategoryID ,
	Active ,
	PhonecallRemindersEnabled ,
	SendEmailCorrespondence 
	)
SELECT DISTINCT
	@PracticeID
	,''
	,LEFT(impP.[lastName], 64)
	,LEFT(impP.[FirstName], 64)
	,LEFT(impP.[MiddleName], 64)
	,''
	,LEFT(impP.[address1], 256)
	,LEFT(impP.[address2], 256)
	,impP.[City]
	,LEFT(impP.[State], 2)
	,''
	,LEFT(REPLACE(impP.[ZipCode], '-', ''), 9)
	,CASE impP.[sex] WHEN 'F' THEN 'F' WHEN 'M' THEN 'M' ELSE 'U' END
	,CASE impP.[maritalstatus] WHEN  2 THEN 'M' WHEN 1 THEN 'S' ELSE '' end
	,CASE WHEN LEN(LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[homephone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)) < 9 THEN NULL 
		ELSE  LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[homephone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		end
	,CASE WHEN LEN(LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[workphone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)) < 9 THEN NULL 
		ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[workphone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		END
	,CASE ISDATE(impP.[dateofbirth]) WHEN 1 THEN impP.[dateofbirth] ELSE NULL END 
	,LEFT(REPLACE(impP.[ssno], '-', ''), 9)
	,LEFT(impP.email, 256)
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,1 -- default service location
	,impP.patuniqueid -- Unique Import Assigned ID (or the export tool's patient id?)
	,@VendorImportID
	,1
	,1
	,1
	,1
FROM dbo.[_import_1_1_PatientsDemographics] impP
LEFT JOIN dbo.Patient ON
	impP.firstname = dbo.Patient.FirstName AND
	impP.lastname = dbo.Patient.LastName
WHERE PatientID IS NULL 

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Case
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
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import, please review.'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impCase.PatUniqueID
	,@VendorImportID
FROM dbo.[_import_1_1_PatientsDemographics] impCase
LEFT JOIN dbo.Patient realP ON
	impCase.PatUniqueID = realP.VendorID AND 
	realP.VendorImportID = @VendorImportID
WHERE realP.PatientID IS NOT NULL 
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Journal Notes
PRINT ''
PRINT 'Inserting records into PatientJournalNote ...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          NoteMessage,
          UserName ,
          SoftwareApplicationID
        )
SELECT  GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          realP.PatientID , -- PatientID - int
          impPJN.patnotes , -- NoteMessage - varchar(max)
          0 ,
          'K'
FROM dbo.[_import_1_1_PatientNotes] impPJN
JOIN dbo.Patient realP ON 
	impPJN.patuniqueid = realP.VendorID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy 
PRINT ''
PRINT 'Inserting records into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	GroupName,
	Copay,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation
	)
SELECT distinct
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,impINS.plannumber
	,impINS.subscriberno
	,impINS.groupno
	,LEFT(impINS.groupname, 14)
	,impINS.fixedcopay
	,'U'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impINS.policyuniqueid
	,@VendorImportID
	,'Y'
FROM dbo.[_import_1_1_PatientInsurance] impINS
LEFT JOIN dbo.PatientCase pc ON 
	impINS.patuniqueid = pc.VendorID
	AND pc.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = impINS.CarrCode + impINS.Coveragename
	AND icp.VendorImportID = @VendorImportID
	AND impins.fixedcopay = icp.Copay
WHERE pc.PatientCaseID IS NOT null
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT


