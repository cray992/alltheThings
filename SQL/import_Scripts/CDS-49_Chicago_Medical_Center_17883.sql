--USE superbill_17883_dev
USE superbill_17883_prod
GO

BEGIN TRANSACTION


UPDATE dbo.[_import_4_1_PatientDemographics] SET dateofbirth = '11/02/2006' WHERE dateofbirth = '11/0212006'
UPDATE dbo._import_4_1_PatientDemoLytec SET chart = '24136' WHERE chart = '241.36'
UPDATE dbo.[_import_4_1_PatientDemoLytec] SET birthdate = '19810102' WHERE birthdate = '1981102'
UPDATE dbo._import_4_1_PatientDemoLytec SET chart = '2888' WHERE chart = '288.8'

SET NOCOUNT ON 

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 4


PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' + CAST(@@Rowcount AS VARCHAR) + ' Insurance Policies deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' +  CAST(@@rowcount AS VARCHAR) + ' Patient Cases deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' Patients deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' InsuranceCompanyPlans deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' InsuranceCompanys deleted'


PRINT ''
PRINT 'Inserting into Insurance Company ...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT    ins.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
          '' , -- Notes - text
          ins.insurancestreet1 , -- AddressLine1 - varchar(256)
          ins.insurancestreet2 , -- AddressLine2 - varchar(256)
          ins.insurancecity , -- City - varchar(128)
          ins.insurancestate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ins.insurancezip , -- ZipCode - varchar(9)
          0, -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          ins.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_4_1_InsuranceCOMPANYPLANList] ins
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Insurance Company Plan ....'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
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
	      icp.insuranceplanname , -- PlanName - varchar(128)
          icp.insurancestreet1 , -- AddressLine1 - varchar(256)
          icp.insurancestreet2 , -- AddressLine2 - varchar(256)
          icp.insurancecity , -- City - varchar(128)
          icp.insurancestate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          insurancezip , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.insuranceid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_1_InsuranceCOMPANYPLANList] icp
INNER JOIN dbo.InsuranceCompany ic ON
	icp.insurancecompanyname = ic.InsuranceCompanyName AND
	icp.AutoTempID = ic.VendorID AND
	ic.VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PrimaryProviderID ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.firstname , -- FirstName - varchar(64)
          pat.middleinitial , -- MiddleName - varchar(64)
          pat.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.street1 , -- AddressLine1 - varchar(256)
          pat.street2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          LEFT(pat.state, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(pat.zipcode, '-', ''), 9) , -- ZipCode - varchar(9)
          CASE WHEN pat.gender = 'M' THEN 'M'
			   WHEN pat.gender = 'F' THEN 'F' END , -- Gender - varchar(1)
          LEFT(REPLACE(REPLACE(replace(pat.homephone, '(', ''), ')', ''), '-', ''), 10) , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(replace( pat.workphone, '(', ''), ')', ''), '-', ''), 10) , -- WorkPhone - varchar(10)
          LEFT(REPLACE(REPLACE(replace(pat.workextension, '(', ''), ')', ''), '-', ''), 10) , -- WorkPhoneExt - varchar(10)
          CAST(pat.dateofbirth AS DATETIME) , -- DOB - datetime
          pat.socialsecuritynumber , -- SSN - char(9)
          pat.email , -- EmailAddress - varchar(256)
          NULL , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          doc.DoctorID , -- PrimaryProviderID - int
          LEFT(REPLACE(REPLACE(replace(pat.cellphone, '(', ''), ')', ''), '-', ''), 10) , -- MobilePhone - varchar(10)
          d.DoctorID , -- PrimaryCarePhysicianID - int
          pat.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_4_1_PatientDemographics] pat
LEFT JOIN dbo.Doctor doc ON
	pat.defaultrenderingproviderfirstname = doc.FirstName AND
	pat.defaultrenderingproviderlastname = doc.FirstName AND 
	doc.[EXTERNAL] = 0
LEFT JOIN dbo.Doctor d ON 
	pat.primarycarephysicianfirstname = doc.FirstName AND
	pat.primarycarephysicianlastname = doc.LastName AND
	doc.[EXTERNAL] = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
          DOB ,
          SSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.firstname , -- FirstName - varchar(64)
          pat.mi , -- MiddleName - varchar(64)
          pat.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.addressline1 , -- AddressLine1 - varchar(256)
          pat.addressline2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          pat.st , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(pat.zip, '-', ''), 9) , -- ZipCode - varchar(9)
          pat.s ,
          pat.m ,
          CASE WHEN pat.birthdate = 0 THEN NULL ELSE pat.birthdate END , -- DOB - datetime
          REPLACE(pat.ssn, '-', '') , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int   
          pat.chart , -- MedicalRecordNumber 
          pat.chart , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_1_PatientDemoLytec] pat
WHERE NOT EXISTS (SELECT * FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND FirstName = pat.firstname
	  AND lastname = pat.lastname )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
SELECT    pc.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import, please review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pc
WHERE pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          ip.policynumber1 , -- PolicyNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ip.copay , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.policynumber1 , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_1_PatientDemographics] ip
INNER JOIN dbo.PatientCase pc ON 
	ip.AutoTempID  = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.insuranceplanname1 = icp.PlanName AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into StandardFeeSchedule ...'
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
VALUES  ( @PracticeID , -- PracticeID - int
          'Default Fee Schedule' , -- Name - varchar(128)
		  'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          GETDATE() , -- EffectiveStartDate - datetime
          'F' , -- SourceType - char(1)
          'Import File' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into StandardFee'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT    c.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          0 , -- ModifierID - int
          sfs.standardfee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_4_1_StandardFeeSchedule] sfs
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule c ON
	CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
	c.practiceID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	sfs.cpt = pcd.ProcedureCode AND
	ISNUMERIC(sfs.standardfee) = 1	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into StandardFeeLink ...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT    doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs
WHERE doc.PracticeID = @PracticeID AND	
	doc.[External] = 0 AND 
	sl.PracticeID = @PracticeID AND
	CAST(sfs.notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	sfs.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



UPDATE dbo.PatientCase
	SET PayerScenarioID = 11
	WHERE 
		VendorImportID = @VendorIMportID AND
		PracticeID = @PracticeID AND
		PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy) AND
		PayerScenarioID <> 11			

COMMIT
