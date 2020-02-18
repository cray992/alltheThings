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
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@@ROWCOUNT AS VARCHAR(10)) 


DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


PRINT ''
PRINT 'Inserting Into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          Country ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  imp.companyname , -- EmployerName - varchar(128)
          '' , -- Country - varchar(32)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_2_1_Update] imp
WHERE imp.companyname <> ''
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
		  ZipCode , 
          Country ,
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
		  Gender ,
          EmailAddress ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence 
        )
SELECT DISTINCT 
		  @PracticeID , -- PracticeID - int
		  '' , -- Prefix
          imp.firstname , -- FirstName - varchar(64)
		  '' , --MiddleName
          imp.lastname , -- LastName - varchar(64)
		  '' , --Suffix
		  imp.streetaddress1 , --Address1
		  '' , --Address2
		  imp.city , --City
		  imp.state , --State
		  LEFT(imp.postalcode, 9) , --ZipCode
          '' , -- Country - varchar(32)
          imp.homephone , -- HomePhone - varchar(10)
          imp.workphone , -- WorkPhone - varchar(10)
          imp.workphoneext , -- WorkPhoneExt - varchar(10)
          imp.birthday , -- DOB - datetime
		  'U', --Gender
          imp.email , -- EmailAddress - varchar(256)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          2 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          emp.EmployerID , -- EmployerID - int
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.cellphone), 10) , -- MobilePhone - varchar(10)
          imp.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          1  -- SendEmailCorrespondence - bit
FROM dbo.[_import_2_1_Update] imp
	LEFT JOIN dbo.Employers emp ON
	emp.EmployerName = imp.companyname
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pat WHERE pat.FirstName = imp.firstname AND pat.LastName = imp.lastname) AND imp.firstname <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Contact List Into Patient...'

INSERT INTO dbo.Patient
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          Country ,
		  EmailAddress , 
          Gender ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          imp.firstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          '' , -- Country - varchar(32)
          imp.email , -- EmailAddress - varchar(256)
		  'U' , --Gender
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          imp.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          1  -- SendEmailCorrespondence - bit
FROM dbo.[_import_2_1_Import] imp
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
          'Self Pay' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
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
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Update Existing Patient Records with Email Address'

UPDATE dbo.Patient
SET EmailAddress = imp.email
From dbo.[_import_2_1_Update] imp
INNER JOIN dbo.Patient pat ON
	imp.firstname = pat.FirstName AND
	imp.lastname = pat.LastName
WHERE imp.email <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated'



COMMIT