--USE superbill_17972_dev
USE superbill_17972_prod
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


-- NUKE Standard fee schedules for this import
DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT)
INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID) 
(
	SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE Notes = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
)
DECLARE @ContractRatesToNuke TABLE (ContractRateScheduleID INT)
INSERT INTO @ContractRatesToNuke ( ContractRateScheduleID )
(
	SELECT DISTINCT ContractRateScheduleID FROM dbo.ContractsAndFees_ContractRateSchedule WHERE InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID)
)
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'
DELETE FROM dbo.ContractsAndFees_ContractRateScheduleLink WHERE ContractRateScheduleID IN (SELECT ContractRateScheduleID FROM @ContractRatesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractRateScheduleLink records deleted'
DELETE FROM dbo.ContractsAndFees_ContractRate WHERE ContractRateScheduleID IN (SELECT ContractRateScheduleID FROM @ContractRatesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractRate records deleted'
DELETE FROM dbo.ContractsAndFees_ContractRateSchedule WHERE ContractRateScheduleID IN (SELECT ContractRateScheduleID FROM @ContractRatesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractRateSchedule records deleted'
DELETE FROM dbo.InsurancePolicy WHERE (PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Policy records deleted '
DELETE FROM dbo.PatientCase WHERE PatientID IN (SELECT patientid FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient Case records deleted '
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient records deleted '
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR) + ' Doctor records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Company Plans records deleted '
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Companies records deleted '

PRINT ''
PRINT 'Inserting into Insurance Company ....'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Phone , 
          Fax ,
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
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT  
		ins.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
		ins.insuranceaddress1 ,
		ins.insuranceaddress2 ,
		ins.insurancecity ,
		ins.insurancestate ,
		LEFT(REPLACE(ins.insurancezip, '-', ''), 9) ,
		LEFT(ins.insurancephone, 9) ,
		LEFT(ins.insurancefax, 9) ,
		0 , -- BillSecondaryInsurance - bit
		0 , -- EClaimsAccepts - bit
		13 , -- BillingFormID - int
		'CI' , -- InsuranceProgramCode - char(2)
		'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
		'D' , -- HCFASameAsInsuredFormatCode - char(1)
		@PracticeID , -- CreatedPracticeID - int
		GETDATE() , -- CreatedDate - datetime
		0 , -- CreatedUserID - int
		GETDATE() , -- ModifiedDate - datetime
		0 , -- ModifiedUserID - int
		13 , -- SecondaryPrecedenceBillingFormID - int
		ins.insurancecompanyid , -- VendorID - varchar(50)
		@VendorImportID , -- VendorImportID - int
		1 , -- NDCFormat - int
		1 , -- UseFacilityID - bit
		'U' , -- AnesthesiaType - varchar(1)
		18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceCompany] AS ins
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT''
PRINT'Inserting into Insurance Company Plan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
		  AddressLine1,
		  AddressLine2,
		  City,
		  State,
		  ZipCode,
		  Phone,
		  Fax,
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
		icp.insurancecompanyplanname , -- PlanName - varchar(128)
		ic.AddressLine1 ,
		ic.AddressLine2 ,
		ic.City ,
		ic.state,
		ic.ZipCode ,
		ic.Phone ,
		ic.Fax ,		
		GETDATE() , -- CreatedDate - datetime
		0 , -- CreatedUserID - int
		GETDATE() , -- ModifiedDate - datetime
		0 , -- ModifiedUserID - int
		@PracticeID , -- CreatedPracticeID - int
		ic.InsuranceCompanyID , -- InsuranceCompanyID - int
		VendorID , -- VendorID - varchar(50)
		@VendorImportID  -- VendorImportID - int       
FROM dbo.[_import_1_1_InsuranceCompany] icp
INNER JOIN dbo.InsuranceCompany ic ON
	icp.insurancecompanyid = ic.VendorID AND
	ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Doctor ....'
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
          State ,
          Country ,
          ZipCode ,
          WorkPhone ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          ref.refphyfirstname , -- FirstName - varchar(64)
          ref.refphymiddleinitial , -- MiddleName - varchar(64)
          ref.refphylastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          ref.refphyaddress1 , -- AddressLine1 - varchar(256)
          ref.refphyaddress2 , -- AddressLine2 - varchar(256)
          ref.refphycity , -- City - varchar(128)
          ref.refphystate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(ref.refphyzip, '-', ''), 9) , -- ZipCode - varchar(9)
          ref.refphyphone , -- WorkPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'TaxonomyCode: ' + refphytaxonomy , -- TaxonomyCode - char(10)
          ref.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          ref.refphyfax , -- FaxNumber - varchar(10)
          1 , -- External - bit
          refphynpi  -- NPI - varchar(10)
FROM dbo.[_import_1_1_ReferringPhysicians] ref 
PRINT CAST(@@rowcount AS VARCHAR) + ' records inserted'


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
          ZipCode ,
          Country,
          Gender ,
          HomePhone ,
          SSN , 
          PrimaryProviderID,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )  
SELECT DISTINCT   
		@PracticeID , -- PracticeID - int
		'' , -- Prefix - varchar(16)
		pat.firstname , -- FirstName - varchar(64)
		pat.middlename , -- MiddleName - varchar(64)
		pat.lastname , -- LastName - varchar(64)
		'' , -- Suffix - varchar(16)
		pat.address1 , -- AddressLine1 - varchar(256)
		pat.address2 , -- AddressLine2 - varchar(256)
		pat.city , -- City - varchar(128)
		pat.state , -- State - varchar(2)
		LEFT(REPLACE(pat.zip, '-', ''), 9) , -- ZipCode - varchar(9)
		'', -- Country
		pat.gender , -- Gender - varchar(1)
		LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.homephone, ' ', ''), '(', ''), ')', ''), '-', ''), 10), -- HomePhone - varchar(10)
		REPLACE(pat.ssn, '-', '') , -- SSN - char(9)
		doc.DoctorID ,
		GETDATE() , -- CreatedDate - datetime
		0 , -- CreatedUserID - int
		GETDATE() , -- ModifiedDate - datetime
		0 , -- ModifiedUserID - int
		pat.patientid ,
		pat.patientid , -- VendorID - varchar(50)
		@VendorImportID , -- VendorImportID - int
		1 , -- Active - bit
		0 , -- SendEmailCorrespondence - bit
		1  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_1_1_PatientDemographics] pat
left JOIN dbo.Doctor doc ON
	doc.FirstName = defaultrenderingproviderfirstname AND
	doc.LastName = defaultrenderingproviderlastname AND
	doc.[External] = 0 AND
	doc.PracticeID = @PracticeID AND
	doc.ActiveDoctor = 1
WHERE pat.firstname <> '' AND
	  pat.lastname <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Case ...'
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
SELECT DISTINCT
		pat.PatientID , -- PatientID - int
		'Default Case' , -- Name - varchar(128)
		1 , -- Active - bit
		5 , -- PayerScenarioID - int (5 is 'Commercial')
		'Created via data import, please review.' , -- Notes - text
		GETDATE() , -- CreatedDate - datetime
		0 , -- CreatedUserID - int
		GETDATE() , -- ModifiedDate - datetime
		0 , -- ModifiedUserID - int
		@PracticeID , -- PracticeID - int
		pat.VendorID, -- VendorID - varchar(50)
		@VendorImportID -- VendorImportID - int
FROM  dbo.Patient pat 
WHERE pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Insurance Policy ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          ip.policynumber1 , -- PolicyNumber - varchar(32)
          ip.groupnumber1 , -- GroupNumber - varchar(32)
          CASE WHEN ip.patientrelationship1 = '' THEN 'S' 
			   WHEN ip.patientrelationship1 = 'Spouse' THEN 'U'
			   WHEN ip.patientrelationship1 = 'Child' THEN 'C'
			   WHEN ip.patientrelationship1 = 'Other Relationship' THEN 'O'
			   WHEN ip.patientrelationship1 = 'Self' THEN 'S'   END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.patientrelationship1 = '' THEN '' 
			   WHEN ip.patientrelationship1 = 'Self' THEN  '' 
			   ELSE ip.guarantorfirstname END , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.patientrelationship1 = '' THEN '' 
			   WHEN ip.patientrelationship1 = 'Self' THEN  '' 
			   ELSE ip.guarantorlastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN ip.patientrelationship1 = '' THEN '' 
			   WHEN ip.patientrelationship1 = 'Self' THEN  '' 
			   ELSE ip.guarantordateofbirth END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN ip.patientrelationship1 = '' THEN '' 
			   WHEN ip.patientrelationship1 = 'Self' THEN  '' 
			   ELSE ip.guarantoraddress1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.patientrelationship1 = '' THEN '' 
			   WHEN ip.patientrelationship1 = 'Self' THEN  '' 
			   ELSE ip.guarantorcity END , -- HolderCity - varchar(128)
          CASE WHEN ip.patientrelationship1 = '' THEN '' 
			   WHEN ip.patientrelationship1 = 'Self' THEN  '' 
			   ELSE ip.guarantorstate END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN ip.patientrelationship1 = '' THEN '' 
			   WHEN ip.patientrelationship1 = 'Self' THEN  '' 
			   ELSE ip.guarantorzip END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.patientrelationship1 = '' THEN ''
			  WHEN ip.patientrelationship1 = 'Self' THEN ''
			  ELSE ip.policynumber1 END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.patientid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemographics] ip
INNER JOIN dbo.PatientCase pc ON 
	ip.patientid = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompany ic ON 
	ip.insurancecompany1 = ic.InsuranceCompanyName AND
	ip.insurancecompanyid = ic.VendorID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	ic.InsuranceCompanyID = icp.InsuranceCompanyID AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Policy ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          ip.policynumber2 , -- PolicyNumber - varchar(32)
          ip.groupnumber2 , -- GroupNumber - varchar(32)
          CASE WHEN ip.patientrelationship2 = '' THEN 'S' 
			   WHEN ip.patientrelationship2 = 'Spouse' THEN 'U'
			   WHEN ip.patientrelationship2 = 'Child' THEN 'C'
			   WHEN ip.patientrelationship2 = 'Other Relationship' THEN 'O'
			   WHEN ip.patientrelationship2 = 'Self' THEN 'S'   END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.patientrelationship2 = '' THEN '' 
			   WHEN ip.patientrelationship2 = 'Self' THEN  '' 
			   ELSE ip.guarantorfirstname END , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.patientrelationship2 = '' THEN '' 
			   WHEN ip.patientrelationship2 = 'Self' THEN  '' 
			   ELSE ip.guarantorlastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN ip.patientrelationship2 = '' THEN '' 
			   WHEN ip.patientrelationship2 = 'Self' THEN  '' 
			   ELSE ip.guarantordateofbirth END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN ip.patientrelationship2 = '' THEN '' 
			   WHEN ip.patientrelationship2 = 'Self' THEN  '' 
			   ELSE ip.guarantor2address END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.patientrelationship2 = '' THEN '' 
			   WHEN ip.patientrelationship2 = 'Self' THEN  '' 
			   ELSE ip.guarantorcity END , -- HolderCity - varchar(128)
          CASE WHEN ip.patientrelationship2 = '' THEN '' 
			   WHEN ip.patientrelationship2 = 'Self' THEN  '' 
			   ELSE ip.guarantorstate2 END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN ip.patientrelationship2 = '' THEN '' 
			   WHEN ip.patientrelationship2 = 'Self' THEN  '' 
			   ELSE ip.guarantorzip2 END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.patientrelationship2 = '' THEN '' 
			   WHEN ip.patientrelationship2 = 'Self' THEN  '' 
			   ELSE ip.policynumber2 END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.patientid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemographics] ip
INNER JOIN dbo.PatientCase pc ON 
	ip.patientid = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompany ic ON 
	ip.insurancecompany2 = ic.InsuranceCompanyName AND
	ip.secondaryinsurancecompanyid = ic.VendorID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	ic.InsuranceCompanyID = icp.InsuranceCompanyID AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Standard Fee Schedule'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
	( 
		PracticeID ,
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
        
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Insert into Standard Fee ...'
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
          CAST(impSFS.fee AS MONEY), -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_1_1_StandardFeeSchedule] impSFS
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule c ON
	CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
	c.practiceID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	impSFS.cptcode = pcd.ProcedureCode AND
	ISNUMERIC(fee) = 1	
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Insert into Standard Fee Link ...'

INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT    doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc , dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule	 sfs 
WHERE doc.PracticeID = @PracticeID AND	
	doc.[External] = 0 AND 
	sl.PracticeID = @PracticeID AND
	CAST(sfs.notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	sfs.PracticeID = @PracticeID
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Contract Rate Schedule'
INSERT INTO dbo.ContractsAndFees_ContractRateSchedule
        ( PracticeID ,
          InsuranceCompanyID ,
          EffectiveStartDate ,
          EffectiveEndDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          MedicareFeeScheduleGPCICarrier ,
          MedicareFeeScheduleGPCILocality ,
          MedicareFeeScheduleGPCIBatchID ,
          MedicareFeeScheduleRVUBatchID ,
          AddPercent ,
          AnesthesiaTimeIncrement ,
          Capitated
        )
SELECT    @PracticeID , -- PracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          GETDATE() , -- EffectiveStartDate - datetime
          DATEADD(yy, 1, GETDATE()) , -- EffectiveEndDate
          'F' , -- SourceType - char(1)
          'Import File' , -- SourceFileName - varchar(256)
          0 , -- EClaimsNoResponseTrigger - int
          0 , -- PaperClaimsNoResponseTrigger - int
          0 , -- MedicareFeeScheduleGPCICarrier - int
          0 , -- MedicareFeeScheduleGPCILocality - int
          0 , -- MedicareFeeScheduleGPCIBatchID - int
          0 , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          0 , -- AnesthesiaTimeIncrement - int
          15  -- Capitated - bit
FROM dbo.InsuranceCompany ic
WHERE ic.InsuranceCompanyName = 'LA Medicaid Unisys'
PRINT CAST(@@ROWCOUNT AS VARCHAR)  + ' records inserted'


PRINT ''
PRINT 'Inserting  into Contract Rate'
INSERT INTO dbo.ContractsAndFees_ContractRate
        ( ContractRateScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT    crs.ContractRateScheduleID , -- ContractRateScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          0 , -- ModifierID - int
          fee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_1_1_MedicaidFeeSchedule] fs
INNER JOIN dbo.InsuranceCompany ic ON
	fs.insurancecompanyname = ic.InsuranceCompanyName AND
	ic.VendorImportID = @VendorImportID
INNER JOIN dbo.ContractsAndFees_ContractRateSchedule crs ON
	crs.InsuranceCompanyID = ic.InsuranceCompanyID 
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	fs.cptcode = pcd.ProcedureCode AND
	ISNUMERIC(fs.fee) = 1
PRINT CAST(@@rowcount AS VARCHAR) + ' records inserted'




PRINT ''
PRINT 'Inserting into Contract Rate Schedule'
INSERT INTO dbo.ContractsAndFees_ContractRateSchedule
        ( PracticeID ,
          InsuranceCompanyID ,
          EffectiveStartDate ,
          EffectiveEndDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          MedicareFeeScheduleGPCICarrier ,
          MedicareFeeScheduleGPCILocality ,
          MedicareFeeScheduleGPCIBatchID ,
          MedicareFeeScheduleRVUBatchID ,
          AddPercent ,
          AnesthesiaTimeIncrement ,
          Capitated
        )
SELECT    @PracticeID , -- PracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          GETDATE() , -- EffectiveStartDate - datetime
          DATEADD(yy, 1, GETDATE()) , -- EffectiveEndDate
          'F' , -- SourceType - char(1)
          'Import File' , -- SourceFileName - varchar(256)
          0 , -- EClaimsNoResponseTrigger - int
          0 , -- PaperClaimsNoResponseTrigger - int
          0 , -- MedicareFeeScheduleGPCICarrier - int
          0 , -- MedicareFeeScheduleGPCILocality - int
          0 , -- MedicareFeeScheduleGPCIBatchID - int
          0 , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          0 , -- AnesthesiaTimeIncrement - int
          15  -- Capitated - bit
FROM dbo.InsuranceCompany ic
WHERE ic.InsuranceCompanyName = 'Medicaid of MS'
PRINT CAST(@@ROWCOUNT AS VARCHAR)  + ' records inserted'


PRINT ''
PRINT 'Inserting  into Contract Rate'
INSERT INTO dbo.ContractsAndFees_ContractRate
        ( ContractRateScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT    crs.ContractRateScheduleID , -- ContractRateScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          0 , -- ModifierID - int
          fee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_1_1_MedicaidMSFeeSchedule] fs
INNER JOIN dbo.InsuranceCompany ic ON
	fs.insurancecompanyname = ic.InsuranceCompanyName AND
	ic.VendorImportID = @VendorImportID
INNER JOIN dbo.ContractsAndFees_ContractRateSchedule crs ON
	crs.InsuranceCompanyID = ic.InsuranceCompanyID 
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	fs.cptcode = pcd.ProcedureCode AND
	ISNUMERIC(fs.fee) = 1
PRINT CAST(@@rowcount AS VARCHAR) + ' records inserted'




PRINT ''
PRINT 'Inserting into Contract Rate Link'
INSERT INTO dbo.ContractsAndFees_ContractRateScheduleLink
        ( ProviderID ,
          LocationID ,
          ContractRateScheduleID
        )
SELECT    doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          crs.ContractRateScheduleID  -- ContractRateScheduleID - int
FROM dbo.doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_ContractRateSchedule crs
WHERE doc.PracticeID = @PracticeID AND
	doc.[External] = 0 AND
	crs.PracticeID = @PracticeID AND
	sl.PracticeID = @PracticeID   
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'     


-- CLEAN UP TASKS --

PRINT ''
PRINT 'Updating PatientCase'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11 
WHERE 
	@VendorImportID = VendorImportID AND 
	@PracticeID = PracticeID AND
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy) AND
	PayerScenarioID <> 11
	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records update'



COMMIT TRAN