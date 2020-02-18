USE superbill_9632_dev
--USE superbill_9632_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 4
SET @VendorImportID = 1 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT)
INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID) 
(
	SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE Notes = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
)
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'
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



PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany(
    InsuranceCompanyName,
    AddressLine1,
    AddressLine2,
    City,
    State,
    ZipCode,
    Phone,
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
	ic.[name]
	,ic.[address1]
	,ic.[address2]
	,ic.[city]
	,LEFT(ic.[state], 2)
	,ic.[zipcode] + ic.zipplus4
	,ic.phone
	,ic.fax
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ic.[code]  -- Hope it's unique!
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
FROM [dbo].[_import_1_4_Insurance] ic
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--InsuranceCompanyPlan
PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
		  AddressLine1 ,
		  AddressLine2 ,
		  city ,
		  State ,
		  ZipCode ,
		  Phone ,
		  Fax ,
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
		  icp.InsuranceCompanyName , -- PlanName - varchar(128)
		  icp.addressline1 ,
		  icp.addressline2 ,
		  icp.city ,
		  icp.[State] ,
		  icp.zipcode ,
		  icp.phone ,
		  icp.fax ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          icp.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany icp 
WHERE icp.CreatedPracticeID = @PracticeID AND 
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--Patient
PRINT ''
PRINT 'Inserting into Patient ...'
INSERT INTO dbo.Patient
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Gender , 
          MaritalStatus , 
          HomePhone ,
          WorkPhone ,
          MobilePhone ,
          DOB ,
          SSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT DISTINCT 
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.[firstname] , -- FirstName - varchar(64)
          pat.[middleinitial] , -- MiddleName - varchar(64)
          pat.[lastname] , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.[address1] , -- AddressLine1 - varchar(256)
          pat.[address2] , -- AddressLine2 - varchar(256)
          pat.[city] , -- City - varchar(128)
          pat.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          pat.[zipcode] + pat.[zipplus4] , -- ZipCode - varchar(9)
          pat.[sex] ,
          CASE WHEN pat.[maritalstatus] = 'M' THEN 'M'
				WHEN pat.[maritalstatus] = 'W' THEN 'W'
				WHEN pat.[maritalstatus] = 'D' THEN 'D'
				WHEN pat.[maritalstatus] = 'X' THEN ''
				WHEN pat.[maritalstatus] = 'S' THEN 'S'
				ELSE NULL 
			END ,
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[homephone], '(', ''), ')', ''), '-', ''), ' ', ''), 10) , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[workphone], '(', ''), ')', ''), '-', ''), ' ', ''), 10) , -- WorkPhone - varchar(10)
		  LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[mobilephone], '(', ''), ')', ''), '-', ''), ' ', ''), 10) , -- MobilePhone - varchar(10)
          CASE WHEN ISDATE(pat.[birthdate]) = 1 THEN pat.[birthdate] ELSE NULL END , -- DOB - datetime
          LEFT(REPLACE(pat.[socialsecurity], '-', ''), 9) , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.chartnumber ,
          pat.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_1_4_Patient] pat
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--PatientCase
PRINT ''
PRINT 'Inserting into PatientCase ...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import, please review.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pat
WHERE pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--InsurancePolicy #1
PRINT ''
PRINT 'Inserting into InsurancePolicy 1 ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderFirstName ,
          HolderLastName ,
          HolderMiddleName ,
          HolderDOB ,
          HolderSSN ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
		  HolderZipCode ,
		  HolderPhone ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName
        )
SELECT    
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pol.primaryid , -- PolicyNumber - varchar(32)
          pol.primarypolicy , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          DATEADD(yy, 1, GETDATE()), -- PolicyEndDate - datetime
          CASE WHEN pol.primaryinsuredpatient <> pol.chartnumber THEN 'O'
				ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pol.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.primaryinsuredguarantor = g.code) THEN gi.firstname END , -- HolderFirstName - varchar(64)
		  CASE WHEN pol.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.primaryinsuredguarantor = g.code) THEN gi.lastname END , -- HolderLastName - varchar(64)				
          CASE WHEN pol.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.primaryinsuredguarantor = g.code) THEN gi.middleinitial END , -- HolderMiddleName - varchar(64)
		  CASE WHEN pol.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.primaryinsuredguarantor = g.code) THEN gi.birthdate END , -- HolderDOB - varchar(64)
		  CASE WHEN pol.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.primaryinsuredguarantor = g.code) THEN gi.socialsecurity END , -- HolderSSN - varchar(64)
		  CASE WHEN pol.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.primaryinsuredguarantor = g.code) THEN gi.Sex END , -- HolderGender - varchar(64)
		  CASE WHEN pol.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.primaryinsuredguarantor = g.code) THEN gi.address1 END , -- HolderAddressLine1 - varchar(64)
		  CASE WHEN pol.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.primaryinsuredguarantor = g.code) THEN gi.Address2 END , -- HolderAddressLine2 - varchar(64)
		  CASE WHEN pol.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.primaryinsuredguarantor = g.code) THEN gi.city END , -- HolderCity - varchar(64)
		  CASE WHEN pol.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.primaryinsuredguarantor = g.code) THEN gi.[state] END , -- HolderState - varchar(64)
	      CASE WHEN pol.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.primaryinsuredguarantor = g.code) THEN gi.zipcode END , -- HolderZipcode - varchar(64)
		  CASE WHEN pol.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.primaryinsuredguarantor = g.code) THEN gi.homephone END , -- HolderHomePhone - varchar(64)
          'Created via Data Import, please review' , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          icp.InsuranceCompanyPlanID+1 , -- VendorID - varchar(50)
          @VendorImportId , -- VendorImportID - int
          LEFT(pol.primarygroupname, 14)
FROM dbo.[_import_1_4_Patient] pol 
INNER JOIN dbo.PatientCase pc ON
	pol.chartnumber = pc.VendorID AND
	pc.VendorImportID = @VendorImportId
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	pol.primarycode = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_4_Guarantor] gi ON
	pol.primaryinsuredguarantor = gi.code

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--InsurancePolicy #2
PRINT ''
PRINT 'Inserting into InsurancePolicy 2 ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderFirstName ,
          HolderLastName ,
          HolderMiddleName ,
          HolderDOB ,
          HolderSSN ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
		  HolderZipCode ,
		  HolderPhone ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          pol.secondaryid , -- PolicyNumber - varchar(32)
          pol.secondarypolicy , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          DATEADD(yy, 1, GETDATE()), -- PolicyEndDate - datetime
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pol.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.secondaryinsuredguarantor = g.code) THEN gi.firstname END , -- HolderFirstName - varchar(64)
		  CASE WHEN pol.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.secondaryinsuredguarantor = g.code) THEN gi.lastname END , -- HolderLastName - varchar(64)				
          CASE WHEN pol.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.secondaryinsuredguarantor = g.code) THEN gi.middleinitial END , -- HolderMiddleName - varchar(64)
		  CASE WHEN pol.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.secondaryinsuredguarantor = g.code) THEN gi.birthdate END , -- HolderDOB - varchar(64)
		  CASE WHEN pol.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.secondaryinsuredguarantor = g.code) THEN gi.socialsecurity END , -- HolderSSN - varchar(64)
		  CASE WHEN pol.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.secondaryinsuredguarantor = g.code) THEN gi.Sex END , -- HolderGender - varchar(64)
		  CASE WHEN pol.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.secondaryinsuredguarantor = g.code) THEN gi.address1 END , -- HolderAddressLine1 - varchar(64)
		  CASE WHEN pol.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.secondaryinsuredguarantor = g.code) THEN gi.Address2 END , -- HolderAddressLine2 - varchar(64)
		  CASE WHEN pol.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.secondaryinsuredguarantor = g.code) THEN gi.city END , -- HolderCity - varchar(64)
		  CASE WHEN pol.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.secondaryinsuredguarantor = g.code) THEN gi.[state] END , -- HolderState - varchar(64)
	      CASE WHEN pol.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.secondaryinsuredguarantor = g.code) THEN gi.zipcode END , -- HolderZipcode - varchar(64)
		  CASE WHEN pol.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.secondaryinsuredguarantor = g.code) THEN gi.homephone END , -- HolderHomePhone - varchar(64)
          'Created via Data Import, please review' , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          icp.InsuranceCompanyPlanID+2 , -- VendorID - varchar(50)
          @VendorImportId  -- VendorImportID - int
FROM dbo.[_import_1_4_Patient] pol 
INNER JOIN dbo.PatientCase pc ON
	pol.chartnumber = pc.VendorID AND
	pc.VendorImportID = @VendorImportId
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	pol.secondarycode = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_4_Guarantor] gi ON
	pol.secondaryinsuredguarantor = gi.code
WHERE secondarycode <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--InsurancePolicy #3
PRINT ''
PRINT 'Inserting into InsurancePolicy 3 ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderFirstName ,
          HolderLastName ,
          HolderMiddleName ,
          HolderDOB ,
          HolderSSN ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
		  HolderZipCode ,
		  HolderPhone ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          pol.tertiaryid , -- PolicyNumber - varchar(32)
          pol.tertiarypolicy , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          DATEADD(yy, 1, GETDATE()), -- PolicyEndDate - datetime
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pol.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.tertiaryinsuredguarantor = g.code) THEN gi.firstname END , -- HolderFirstName - varchar(64)
		  CASE WHEN pol.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.tertiaryinsuredguarantor = g.code) THEN gi.lastname END , -- HolderLastName - varchar(64)				
          CASE WHEN pol.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.tertiaryinsuredguarantor = g.code) THEN gi.middleinitial END , -- HolderMiddleName - varchar(64)
		  CASE WHEN pol.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.tertiaryinsuredguarantor = g.code) THEN gi.birthdate END , -- HolderDOB - varchar(64)
		  CASE WHEN pol.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.tertiaryinsuredguarantor = g.code) THEN gi.socialsecurity END , -- HolderSSN - varchar(64)
		  CASE WHEN pol.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.tertiaryinsuredguarantor = g.code) THEN gi.Sex END , -- HolderGender - varchar(64)
		  CASE WHEN pol.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.tertiaryinsuredguarantor = g.code) THEN gi.address1 END , -- HolderAddressLine1 - varchar(64)
		  CASE WHEN pol.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.tertiaryinsuredguarantor = g.code) THEN gi.Address2 END , -- HolderAddressLine2 - varchar(64)
		  CASE WHEN pol.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.tertiaryinsuredguarantor = g.code) THEN gi.city END , -- HolderCity - varchar(64)
		  CASE WHEN pol.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.tertiaryinsuredguarantor = g.code) THEN gi.[state] END , -- HolderState - varchar(64)
	      CASE WHEN pol.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.tertiaryinsuredguarantor = g.code) THEN gi.zipcode END , -- HolderZipcode - varchar(64)
		  CASE WHEN pol.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_4_Guarantor] g 
						WHERE pol.tertiaryinsuredguarantor = g.code) THEN gi.homephone END , -- HolderHomePhone - varchar(64)
          'Created via Data Import, please review' , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          icp.InsuranceCompanyPlanID+3 , -- VendorID - varchar(50)
          @VendorImportId  -- VendorImportID - int
FROM dbo.[_import_1_4_Patient] pol 
INNER JOIN dbo.PatientCase pc ON
	pol.chartnumber = pc.VendorID AND
	pc.VendorImportID = @VendorImportId
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	pol.tertiarycode = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_4_Guarantor] gi ON
	pol.tertiaryinsuredguarantor = gi.code
WHERE tertiarycode  <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--StandardFeeSchedule
PRINT ''
PRINT 'Inserting in a new StandardFeeSchedule ...'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
        ( PracticeID ,
          Name ,
          Notes ,
          EffectiveStartDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          MedicareFeeScheduleGPCICarrier ,
          MedicareFeeScheduleGPCILocality ,
          MedicareFeeScheduleGPCIBatchID ,
          MedicareFeeScheduleRVUBatchID ,
          AddPercent ,
          AnesthesiaTimeIncrement
        )
VALUES  ( 
		  @PracticeID , -- PracticeID - int
          'Default contract' , -- Name - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          GETDATE() , -- EffectiveStartDate - datetime
          'f' , -- SourceType - char(1)
          'Import file' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--StandardFee
PRINT ''
PRINT 'Inserting in Standard Fees ...'
INSERT INTO dbo.ContractsAndFees_StandardFee
    ( StandardFeeScheduleID ,
      ProcedureCodeID ,
      ModifierID ,
      SetFee ,
      AnesthesiaBaseUnits
    )
SELECT
      c.StandardFeeScheduleID , -- StandardFeeScheduleID - int
      pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
      0 , -- ModifierID - int
      impSFS.standardcost , -- SetFee - money
      0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_1_4_TransactionCode] impSFS
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule c ON
	CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
	c.practiceID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	impSFS.code = pcd.ProcedureCode
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--StandardFeeScheduleLink
PRINT ''
PRINT 'Inserting in Standard Fee Schedule Link ...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
    ( ProviderID ,
      LocationID ,
      StandardFeeScheduleID
    )
SELECT
      doc.DoctorID , -- ProviderID - int
      sl.ServiceLocationID , -- LocationID - int
      sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs 
WHERE doc.PracticeID = @PracticeID AND
	doc.[External] = 0 AND 
	sl.PracticeID = @PracticeID AND
	CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	sfs.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'






COMMIT