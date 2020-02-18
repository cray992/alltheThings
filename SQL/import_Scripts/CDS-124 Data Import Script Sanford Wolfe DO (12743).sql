USE superbill_12743_dev
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

DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT )
INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID)
(
	SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule 
	WHERE Notes = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) 
)
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'

PRINT ''
PRINT 'Inserting Into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          AddressLine1 ,
          City ,
          State ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  imp.name , -- EmployerName - varchar(128)
          imp.[address] , -- AddressLine1 - varchar(256)
          imp.city , -- City - varchar(128)
          LEFT(imp.[state], 2) , -- State - varchar(2)
          LEFT(imp.zip, 9) , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_2_1_EmployerList] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into ReferringDoctor...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          WorkPhone ,
          WorkPhoneExt ,
		  Notes , 
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
	      @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          imp.firstname , -- FirstName - varchar(64)
          imp.middlename , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          imp.suffix , -- Suffix - varchar(16)
          imp.address1 , -- AddressLine1 - varchar(256)
          LEFT(imp.workphone, 10) , -- WorkPhone - varchar(10)
		  LEFT(imp.ext, 10) , -- WorkPhoneExt - 
		  imp.notes , --Notes
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          LEFT(imp.degree, 8), -- Degree - varchar(8)
          imp.id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(imp.fax, 10) , -- FaxNumber - varchar(10)
          1 , -- External - bit
          LEFT(imp.npinumber, 10)  -- NPI - varchar(10)
FROM dbo.[_import_3_1_ReferringPhysicianList] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          Phone ,
          PhoneExt ,
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
          AnesthesiaType 
        )
SELECT DISTINCT
		  imp.payorname , -- InsuranceCompanyName - varchar(128)
          'Contact Name ' + imp.contactname , -- Notes - text
          imp.phone , -- Phone - varchar(10)
          imp.ext , -- PhoneExt - varchar(10)
          imp.fax , -- Fax - varchar(10)
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
          imp.companyid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U'  -- AnesthesiaType - varchar(1)
FROM dbo.[_import_2_1_InsuranceCompanyList] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
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
		  imp.planname , -- PlanName - varchar(128)
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE(), -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          imp.planid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_InsuranceCompanyPlan] imp
INNER JOIN dbo.InsuranceCompany ic ON
		ic.VendorID = imp.companyid AND
		ic.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Patient...'
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
          HomePhone ,
		  WorkPhone ,
          ResponsibleDifferentThanPatient ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,
          ResponsibleSuffix ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleCountry ,
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          imp.firstname , -- FirstName - varchar(64)
          imp.middlename , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          imp.suffix , -- Suffix - varchar(16)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          imp.zip , -- ZipCode - varchar(9)
          imp.homephone , -- HomePhone - varchar(10)
          imp.workphone , -- WorkPhone - varchar(10)
          CASE WHEN imp.guarantorid <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN imp.guarantorfirstname <> '' THEN imp.guarantorfirstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN imp.guarantormiddlename <> '' THEN imp.guarantormiddlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN imp.guarantorlastname <> '' THEN imp.guarantorlastname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN imp.guarantorsuffix <> '' THEN imp.guarantorsuffix END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN imp.guarantoraddress1 <> '' THEN imp.guarantoraddress1 END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN imp.guarantoraddress2 <> '' THEN imp.guarantoraddress2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN imp.guarantorcity <> '' THEN imp.guarantorcity END , -- ResponsibleCity - varchar(128)
          CASE WHEN imp.guarantorstate <> '' THEN imp.guarantorstate END , -- ResponsibleState - varchar(2)
          '' , -- ResponsibleCountry - varchar(32)
          CASE WHEN imp.guaratorzip <> '' THEN LEFT(imp.guaratorzip,9) END , -- ResponsibleZipCode - varchar(9)
          '2013-12-26 20:01:58' , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          '2013-12-26 20:01:58' , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
		  1, --DefaultServiceLocationID
          imp.patientid , -- MedicalRecordNumber - varchar(128)
          imp.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_2_1_PatientDemo] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into PatientCase...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          PregnancyRelatedFlag ,
          StatementActive ,
          EPSDT ,
          FamilyPlanning ,
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag
        )
SELECT DISTINCT
	      PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          'Created via Data Import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Policy1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
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
          imp.insidnumber , -- PolicyNumber - varchar(32)
          CASE imp.relation WHEN 'S' THEN 'S'
							WHEN 'O' THEN 'O'
							ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorfirstname FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END , -- HolderFirstName - varchar(64)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.middlename FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorlastname FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderLastName - varchar(64)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorsuffix FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantoraddress1 FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantoraddress2 FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorcity FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderCity - varchar(128)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorstate FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guaratorzip FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderZipCode - varchar(9)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorhomephone FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderPhone - varchar(10)
          CASE WHEN imp.relation = 'O' THEN imp.insidnumber END, -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.patientid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_InsurancePolicy] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.patientid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.planid AND
	icp.VendorImportId = @VendorImportID
WHERE imp.precedence = 1 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Policy2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
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
          imp.insidnumber , -- PolicyNumber - varchar(32)
          CASE imp.relation WHEN 'S' THEN 'S'
							WHEN 'O' THEN 'O'
							ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorfirstname FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END , -- HolderFirstName - varchar(64)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.middlename FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorlastname FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderLastName - varchar(64)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorsuffix FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantoraddress1 FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantoraddress2 FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorcity FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderCity - varchar(128)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorstate FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guaratorzip FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderZipCode - varchar(9)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorhomephone FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderPhone - varchar(10)
          CASE WHEN imp.relation = 'O' THEN imp.insidnumber END, -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.patientid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_InsurancePolicy] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.patientid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.planid AND
	icp.VendorImportId = @VendorImportID
WHERE imp.precedence = 2 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Policy3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          imp.insidnumber , -- PolicyNumber - varchar(32)
          CASE imp.relation WHEN 'S' THEN 'S'
							WHEN 'O' THEN 'O'
							ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorfirstname FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END , -- HolderFirstName - varchar(64)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.middlename FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorlastname FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderLastName - varchar(64)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorsuffix FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantoraddress1 FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantoraddress2 FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorcity FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderCity - varchar(128)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorstate FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guaratorzip FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderZipCode - varchar(9)
          CASE WHEN imp.relation = 'O' THEN (SELECT pd.guarantorhomephone FROM dbo.[_import_1_1_PatientDemo] pd WHERE pc.VendorID = pd.patientid) END, -- HolderPhone - varchar(10)
          CASE WHEN imp.relation = 'O' THEN imp.insidnumber END, -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.patientid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_InsurancePolicy] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.patientid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.planid AND
	icp.VendorImportId = @VendorImportID
WHERE imp.precedence = 3 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Standard Fee Schedule...'
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
          'Standard Fees' , -- Name - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          '2013-01-01 07:00:00' , -- EffectiveStartDate - datetime
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
PRINT 'Inserting into Standard Fee...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT DISTINCT
		  sfs.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          imp.fee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_2_1_StandardFeeSchedule] imp
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON	
		CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
		sfs.PracticeID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
		pcd.ProcedureCode = imp.code
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into Standard Fee Link...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT DISTINCT
		  doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs
WHERE doc.[External] = 0 AND	
	  doc.PracticeID = @PracticeID AND
	  sl.PracticeID = @PracticeID AND
	  CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	  sfs.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




PRINT ''
PRINT 'Inserting Into Appointment...'
INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
	      pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          imp.startdate , -- StartDate - datetime
          imp.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          imp.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'C' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          imp.starttm , -- StartTm - smallint
          imp.endtm  -- EndTm - smallint
FROM dbo.[_import_2_1_Appointment] imp
INNER JOIN dbo.Patient pat ON
	pat.VendorID = imp.patientid AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON
	pc.PatientID = pat.PatientID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND 
	dk.Dt = (SELECT Dt FROM dbo.DateKeyToPractice WHERE Dt = DATEADD(d , 0, DATEDIFF(d , 0 , imp.startdate)))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT  
		  appt.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          0 , -- ResourceID - int
          GETDATE(), -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_Appointment] imp
INNER JOIN dbo.Patient pat ON	
	pat.VendorID = imp.patientid AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment appt ON 
	appt.PatientID = pat.PatientID and
	appt.StartDate = imp.startdate
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Appointment Reason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode 
        )
SELECT DISTINCT 
	        1 , -- PracticeID - int
          imp.reason , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0  -- DefaultColorCode - int
FROM dbo.[_import_2_1_AppointmentReasons] imp
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Appointment to Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT  
		  apt.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_Appointment] imp
INNER JOIN dbo.Patient pat ON
	pat.VendorID = imp.patientid AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment apt ON
	apt.PatientID = pat.PatientID AND
	apt.StartDate = imp.startdate
INNER JOIN dbo.AppointmentReason ar ON
	ar.Name = imp.reason
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	
	
PRINT ''
PRINT 'Updating Patient Cases that have no policies...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11
	WHERE VendorImportID = @VendorImportID AND
		  PayerScenarioID = 5 AND 
		  PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Updating Appointments to EST...'
UPDATE dbo.Appointment
	SET StartDate = DATEADD(hh,- 3, StartDate) ,
		EndDate = DATEADD(hh,- 3, EndDate) ,
		StartTm = - 300 ,
		EndTm = - 300
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'
		


COMMIT