USE superbill_16360_dev
--use superbill_16360_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Purging existing records in detination tables for VendorImport ' + CAST(@@ROWCOUNT AS VARCHAR(10)) 

DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT)
INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID)
(
	SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule
	WHERE Notes = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
)
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Standard Fee Schedule Link records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Standard Fee records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Standard Fee Schedule records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


PRINT ''
PRINT 'Inserting into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Phone ,
          PhoneExt ,
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
          VendorID ,
          VendorImportID 
        )
SELECT
		  insurancename , -- InsuranceCompanyName - varchar(128)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          zipcode , -- ZipCode - varchar(9)
          LEFT(phone, 10) , -- Phone - varchar(10)
          phoneext , -- PhoneExt - varchar(10)
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
          idnum , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_InsuranceList]
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Phone ,
          PhoneExt ,
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
		  InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          ZipCode , -- ZipCode - varchar(9)
          LEFT(Phone , 10) , -- Phone - varchar(10)
          PhoneExt , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany 
WHERE VendorImportID = @VendorImportID  
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient...'
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
          Gender ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.firstname , -- FirstName - varchar(64)
          pat.middlename , -- MiddleName - varchar(64)
          pat.lastname , -- LastName - varchar(64)
          pat.suffix , -- Suffix - varchar(16)
          pat.address1 , -- AddressLine1 - varchar(256)
          pat.address2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          LEFT(pat.state , 2) ,-- State - varchar(2)
          LEFT(pat.zipcode , 9) , -- ZipCode - varchar(9)
          CASE pat.gender WHEN 'F' THEN 'F'
						  WHEN 'M' THEN 'M'
						  ELSE 'U' END , -- Gender - varchar(1)
          
		  CASE pat.homephone WHEN '956' THEN '' ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.homephone , '-' , '' ), ' ' , '') , '(' , '') , ')' , '' ) , 10) END , -- HomePhone - varchar(10)
		  CASE pat.workphone WHEN '956' THEN '' ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.workphone , '-' , '' ), ' ' , '') , '(' , '') , ')' , '' ) , 10) END , -- WorkPhone - varchar(10)
          pat.dob , -- DOB - datetime
          LEFT(REPLACE(REPLACE(pat.ssn , '-' , '' ) , ' ' , '') ,9), -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.medicalrecordnumber , -- MedicalRecordNumber - varchar(128)
          CASE pat.mobilephone WHEN '956' THEN '' ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.mobilephone , '-' , '' ), ' ' , '') , '(' , '') , ')' , '' ) , 10) END , -- MobilePhone - varchar(10)
          pat.medicalrecordnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_2_1_Patient] pat
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Case...'
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
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import. Please review before using' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Policy 1...'
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
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
	      pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          imp.primarysubpolicy , -- PolicyNumber - varchar(32)
          imp.primarysubgroup , -- GroupNumber - varchar(32)
          CASE imp.primarysubrelation WHEN 'U' THEN 'U'
									  WHEN 'C' THEN 'C'
									  WHEN 'O' THEN 'O'
									  ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          imp.primarysubfirstname , -- HolderFirstName - varchar(64)
          imp.primarysubmiddlename , -- HolderMiddleName - varchar(64)
          imp.prisublastname , -- HolderLastName - varchar(64)
          imp.primarysubsuffix , -- HolderSuffix - varchar(16)
          LEFT(REPLACE(REPLACE(imp.primarysubssn, '-' , '') , ' ' , '') , 9) , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE imp.primarysubgender WHEN 'F' THEN 'F'
									WHEN 'M' THEN 'M'
									ELSE 'U' END , -- HolderGender - char(1)
          imp.primarysubpolicy , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.medicalrecordnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_Patient] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.medicalrecordnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorID = imp.primaryinsid AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Policy 2...'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
	      pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          imp.secondarysubpolicy , -- PolicyNumber - varchar(32)
          imp.secondarysubgroup , -- GroupNumber - varchar(32)
          CASE imp.secondarysubrelation WHEN 'U' THEN 'U'
									    WHEN 'C' THEN 'C'
									    WHEN 'O' THEN 'O'
									    ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          imp.secondarysubfirstname , -- HolderFirstName - varchar(64)
          imp.secondarysubmiddlename, -- HolderMiddleName - varchar(64)
          imp.secondarysublastname , -- HolderLastName - varchar(64)
          imp.secondarysubsuffix , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE imp.seccondarysubgender WHEN 'F' THEN 'F'
									   WHEN 'M' THEN 'M'
									   ELSE 'U' END , -- HolderGender - char(1)
          imp.secondarysubpolicy , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.medicalrecordnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_Patient] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.medicalrecordnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorID = imp.secondaryinsid AND
	icp.VendorImportID = @VendorImportID
WHERE imp.secondaryinsid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting in a new Standard Fee Schedule...'
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
          'Default Contract' , -- Name - varchar(128)
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
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Inserting into Standard Fee Schedule Fees'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT
		  fs.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          pm.ProcedureModifierID , -- ModifierID - int
          CAST(impsfs.amount AS MONEY) , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_2_1_FeeSchedule] impsfs
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule fs ON
	CAST(fs.notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	fs.PracticeID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	pcd.ProcedureCode = impsfs.cptcode
INNER JOIN dbo.ProcedureModifier pm ON
	pm.Proceduremodifiercode = impsfs.modifier
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Standard Fee Schedule Link...'
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
	  CAST(sfs.notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	  sfs.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Alert...'
INSERT INTO dbo.PatientAlert
        ( PatientID ,
          AlertMessage ,
          ShowInPatientFlag ,
          ShowInAppointmentFlag ,
          ShowInEncounterFlag ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT DISTINCT
		  pat.PatientID , -- PatientID - int
          imp.alert , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0   -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_2_1_Patient] imp
INNER JOIN dbo.Patient pat ON
	pat.VendorID = imp.MedicalRecordNumber AND
	pat.VendorImportID = @VendorImportID
WHERE imp.alert <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11
	WHERE VendorImportID = @VendorImportID AND
		  PayerScenarioID = 5 AND 
		  PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


COMMIT