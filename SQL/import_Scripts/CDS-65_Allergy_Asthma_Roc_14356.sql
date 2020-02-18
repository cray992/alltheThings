--USE superbill_14356_dev
USE superbill_14356_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeId AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
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
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
		  ic.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
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
          13 , -- SecondaryPrecedenceBillingFormID - int
          ic.insurancecompanyname , -- VendorID - varchar(50)
          @Vendorimportid , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18 -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_InsuranceCompanies] ic
PRINT CAST(@@rowcount AS VARCHAR) + ' records inserted' 


PRINT''
PRINT'Inserting into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
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
SELECT Distinct 
		  impIP.insuranceplanname , -- PlanName - varchar(128)
          impIP.insurancestreet1 , -- AddressLine1 - varchar(256)
          impIP.insurancestreet2 , -- AddressLine2 - varchar(256)
          impIP.insurancecity , -- City - varchar(128)
          impIP.insurancestate , -- State - varchar(2)
          impIP.insurancezip , -- ZipCode - varchar(9)
          RIGHT(REPLACE(impIP.insurancephone,' ',''),10) , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          IC.insurancecompanyid , -- InsuranceCompanyID - int
          impIP.insuranceplanid , -- VendorID - varchar(50)
          @VendorimportID  -- VendorImportID - int
 FROM dbo.[_import_3_1_InsurancePlans] impIP
 INNER JOIN dbo.[_import_3_1_InsuranceCompanies] impIC ON 
	impIP.insuranceplanid = impIC.insuranceplanid 
 INNER JOIN dbo.InsuranceCompany IC ON
	IC.VendorID = impIC.insurancecompanyname AND
	IC.VendorImportID = @VendorImportID
PRINT CAST (@@Rowcount AS VARCHAR) + ' records inserted'


PRINT''
PRINT'Inserting into Patient ...'
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
          DOB ,
          SSN ,
          ResponsibleDifferentThanPatient ,
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
          impPat.firstname , -- FirstName - varchar(64)
          impPat.middleinitial , -- MiddleName - varchar(64)
          impPat.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          impPat.street1 , -- AddressLine1 - varchar(256)
          impPat.street2 , -- AddressLine2 - varchar(256)
          impPat.city , -- City - varchar(128)
          impPat.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(replace(impPat.zipcode, ' ', ''), '-', ''), 9) , -- ZipCode - varchar(9)
          impPat.gender , -- Gender - varchar(1)
          impPat.homephone , -- HomePhone - varchar(10)
          impPat.dateofbirth , -- DOB - datetime
          impPat.ssn , -- SSN - char(9)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          impPat.chartnumber , -- MedicalRecordNumber - varchar(128)
          impPat.autotempid , -- VendorID - varchar(50)
          @VendorImportiD , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_3_1_PatientDemo] impPat
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT'Inserting into PatientCase ...'
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
          'Created via Data Import, please review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pat
WHERE pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT''
PRINT'Inserting into InsurancePolicy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
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
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          impIP.policynumber1 , -- PolicyNumber - varchar(32)
          impIP.groupnumber1 , -- GroupNumber - varchar(32)
		  impIP.policy1startdate , -- PolicyStartDate 
          CASE WHEN impIP.guarantor1firstname <> '' THEN 'O' ELSE 'S' end , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          impIP.guarantor1firstname , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          impIP.guarantor1lastname , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          impIP.guarantor1policynumber , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          impIP.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemo] impIP
INNER JOIN dbo.Patient pat ON 
	impIP.chartnumber = pat.MedicalRecordNumber AND
	impIP.firstname = pat.FirstName AND
	impIP.AutoTempID = pat.VendorID 
INNER JOIN dbo.PatientCase pc ON
	impIP.AutoTempID = pc.VendorID AND 
	pat.PatientID = pc.PatientID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	impIP.insuranceplanid = icp.VendorID AND
	icp.VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT''
PRINT'Inserting into StandardFeeSchedule...'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
        ( PracticeID ,
          Name ,
          Notes ,
          EffectiveStartDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          AddPercent ,
          AnesthesiaTimeIncrement
        )
VALUES  ( @PracticeiD , -- PracticeID - int
          'Default Fee Schedule' , -- Name - varchar(128)
          'Created via Data Import, please review' , -- Notes - varchar(1024)
          '2012-01-19 01:01:24' , -- EffectiveStartDate - datetime
          'F' , -- SourceType - char(1)
          'Import file' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into StandardFees....'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT    sfs.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          0 , -- ModifierID - int
          imp.standardfee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_3_1_StandardFeeSchedule] imp
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON
	sfs.notes = 'Created via Data Import, please review' AND
	sfs.PracticeID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON 
	imp.cpt = pcd.ProcedureCode 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into StandardFeeScheduleLink...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT    doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs
WHERE doc.ActiveDoctor = 1 AND
	  doc.[External] = 0 AND
	  doc.PracticeID = @PracticeID and
	  sl.PracticeID = @PracticeID AND
	  sfs.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

 
PRINT''
PRINT'Updating PatientCases....'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11
	WHERE PayerScenarioID = 5 AND
		  VendorImportID = @VendorImportID AND
		  PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	  

COMMIT

