USE superbill_25839_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Purging existing records in detination tables for VendorImport 1'


DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
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
	      imp.name , -- InsuranceCompanyName - varchar(128)
          imp.street1 , -- AddressLine1 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.zip)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.zip) 
			   ELSE '' END, -- ZipCode - varchar(9)
          imp.phone , -- Phone - varchar(10)
          13 , -- BillingFormID - int
          'CI', -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          imp.code , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsList] imp
WHERE imp.code <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
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
		  InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          [State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportId  -- VendorImportID - int
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          Gender ,
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          middlename , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          street1 , -- AddressLine1 - varchar(256)
          street2 , -- AddressLine2 - varchar(256)
          homecity , -- City - varchar(128)
          CASE homestate WHEN 'Kentucky' THEN 'KY'
						 WHEN 'Texas' THEN 'TX'
						 WHEN 'Arkansas' THEN 'AR'
						 WHEN 'Iowa' THEN 'IA'
						 WHEN 'Tennessee' THEN 'TN'
						 WHEN 'Oklahoma' THEN 'OK'
						 WHEN 'Arizona' THEN 'AZ'
						 WHEN 'Ohio' THEN 'OH'
						 WHEN 'Kansas' THEN 'KS'
						 WHEN 'Missouri' THEN 'MO'
						 WHEN 'California' THEN 'CA'
						 WHEN 'Washington' THEN 'WA'
						 WHEN 'Virginia' THEN 'VA'
						 WHEN 'Pennsylvania' THEN 'PA'
						 WHEN 'Vermont' THEN 'VT'
						 WHEN 'North Carolina' THEN 'NC'
						 WHEN 'Colorado' THEN 'CO'
						 WHEN 'Connecticut' THEN 'CN'
						 WHEN 'District of Columbia' THEN 'DC'
						 WHEN 'New Jersey' THEN 'NJ'
						 WHEN 'Indiana' THEN 'IN'
						 WHEN 'New York' THEN 'NY'
						 WHEN 'Illinois' THEN 'IL'
						 WHEN 'Mississippi' THEN 'MS'
						 WHEN 'Georgia' THEN 'GA'
						 WHEN 'Minnesota' THEN 'MN'
						 WHEN 'Maryland' THEN 'MA'
						 WHEN 'Florida' THEN 'FL'
						 WHEN 'Louisiana' THEN 'LA'
						 WHEN 'Michigan' THEN 'MI'
						 WHEN 'Nevada' THEN 'NV'
						 WHEN 'South Carolina' THEN 'SC'
						 ELSE LEFT(homestate, 2) END , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(homepostalcode,9) , -- ZipCode - varchar(9)
          sex , -- Gender - varchar(1)
          homephone , -- HomePhone - varchar(10)
          workphone , -- WorkPhone - varchar(10)
          workphoneext , -- WorkPhoneExt - varchar(10)
          birthday , -- DOB - datetime
          CASE WHEN LEN(ssn) >= 6 THEN RIGHT('000'+ ssn, 9) ELSE '' END, -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          chartno , -- MedicalRecordNumber - varchar(128)
          mobilephone , -- MobilePhone - varchar(10)
          chartno , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          active  -- Active - bit
FROM dbo.[_import_1_1_PatDemo]
WHERE chartno <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
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
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Policy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          imp.priinspolicy , -- PolicyNumber - varchar(32)
          imp.priinsurancegroup , -- GroupNumber - varchar(32)
		  'S' , --PatientRelationshipToInsured 
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatPolicies] imp
INNER JOIN dbo.InsuranceCompanyPlan icp ON
icp.VendorID = imp.priinspayercode AND
icp.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase pc ON
pc.VendorID = imp.chartno AND
pc.VendorImportID = @VendorImportID
WHERE imp.priinspayercode <> '' AND imp.priinspolicy <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          imp.secinspolicy , -- PolicyNumber - varchar(32)
          imp.secinsurancegroup , -- GroupNumber - varchar(32)
		  'S' , --PatientRelationshipToInsured 
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatPolicies] imp
INNER JOIN dbo.InsuranceCompanyPlan icp ON
icp.VendorID = imp.secinspayercode AND
icp.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase pc ON
pc.VendorID = imp.chartno AND
pc.VendorImportID = @VendorImportID
WHERE imp.secinspayercode <> '' AND imp.secinspolicy <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Policy 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          imp.terinspolicy , -- PolicyNumber - varchar(32)
          imp.terinsurancegroup , -- GroupNumber - varchar(32)
		  'S' , --PatientRelationshipToInsured 
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatPolicies] imp
INNER JOIN dbo.InsuranceCompanyPlan icp ON
icp.VendorID = imp.terinspayercode AND
icp.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase pc ON
pc.VendorID = imp.chartno AND
pc.VendorImportID = @VendorImportID
WHERE imp.terinspayercode <> '' AND imp.terinspolicy <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          imp.startdateest , -- StartDate - datetime
          imp.enddateest , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          imp.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE WHEN imp.[status] <> '' THEN imp.[status] ELSE 'C' END, -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          imp.starttmest , -- StartTm - smallint
          imp.endtmest  -- EndTm - smallint
FROM dbo.[_import_1_1_Appointment] imp
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = imp.chartno AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = pat.VendorID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = CAST(CAST(imp.startdateest AS DATE) AS DATETIME)   
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
		  app.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] AS imp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = imp.chartno AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS app ON
	app.PatientID = pat.PatientID AND
	app.StartDate = imp.startdateest  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Cases with no linked policies to Self Pay...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11
	WHERE VendorImportID = @VendorImportID AND
		  PayerScenarioID = 5 AND 
		  PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT
