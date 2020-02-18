--USE superbill_14911_dev
USE superbill_14911_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 4 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))


DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'

DELETE FROM dbo.InsurancePolicy WHERE (PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@rowcount AS varchar(10)) + ' Insurance Policy records deleted '

DELETE FROM dbo.PatientCase WHERE PatientID IN (SELECT patientid FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@rowcount AS varchar(10)) + ' Patient Case records deleted '

DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@rowcount AS varchar(10)) + ' Patient records deleted '

DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@rowcount AS varchar(10)) + ' Insurance Company Plans records deleted '

DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@rowcount AS varchar(10)) + ' Insurance Companies records deleted '



PRINT''
PRINT'Inserting into Insurance Company ....'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Phone ,
          Notes ,
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
SELECT	DISTINCT 
          ins.name , -- InsuranceCompanyName - varchar(128)
          LEFT(ins.address1, 256) , -- AddressLine1 - varchar(256)
          LEFT(ins.address2, 256) , -- AddressLine2 - varchar(256)
          LEFT(ins.city, 128) , -- City - varchar(128)
          LEFT(ins.state, 2) , -- State - varchar(2)
          LEFT(ins.zipcode, 9)  , -- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ins.phone, ' ',''), '-',''),'(',''),')',''), 10) , -- Phone - varchar(10)
          CASE WHEN address1 IS NULL AND address2 IS NULL THEN address END , -- Notes
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
          ins.code , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo._import_4_3_Insurance AS ins
	WHERE ins.name <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Insurance Company Plan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          ContactFirstName ,
          Phone ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT   
		  InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          ZipCode , -- ZipCode - varchar(9)
          ContactFirstName , -- ContactFirstName - varchar(64)
          Phone , -- Phone - varchar(10)
          Notes ,
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
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


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
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          Ethnicity ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
          PhonecallRemindersEnabled 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          LEFT(firstname, 64) , -- FirstName - varchar(64)
          middle , -- MiddleName - varchar(64)
          LEFT(lastname, 64) , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          LEFT(address1, 256) , -- AddressLine1 - varchar(256)
          LEFT(address2, 256) , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT(state, 2) , -- State - varchar(2)
          LEFT(REPLACE(zip, '-', ''), 9) , -- ZipCode - varchar(9)
          LEFT(sex, 1) , -- Gender - varchar(1)
          CASE [status] WHEN 'W' THEN 'W'
		              WHEN 'M' THEN 'M'
			          WHEN 'S' THEN 'S'
					  WHEN 'D' THEN 'D'
					  ELSE ''
		  END , -- MaritalStatus - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(phonehome, ' ', ''), '-', ''), '(', ''), ')', ''), 10) , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(phone, ' ', ''), '-', ''), '(', ''), ')', ''), 10) , -- WorkPhone - varchar(10)
          CASE WHEN ISDATE(birthdate) = 1 THEN birthdate END , -- DOB - datetime
          LEFT(REPLACE(REPLACE(ss, '-', ''), ' ', ''), 9) , -- SSN - char(9)
          client, 
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          code , -- MedicalRecordNumber - varchar(128)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(phonecell, ' ', ''), '-', ''), '(', ''), ')', ''), 10) , -- MobilePhone - varchar(10)
          AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          1  -- PhonecallRemindersEnabled - bit
FROM [dbo].[_import_4_3_PatientsDemographics]
WHERE firstname <> '' AND
	  lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Patient Case ...'
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
SELECT    PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import, please review.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Policy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderLastName ,
          HolderSuffix ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          --HolderAddressLine2 ,
          --HolderCity ,
          --HolderState ,
          --HolderZipCode ,
          HolderPhone ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pol.ins1id , -- PolicyNumber - varchar(32)
          pol.ins1group , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          'S' , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN pol.code <> pol.ins1guar THEN guar.first
				ELSE ''
		  END , -- HolderFirstName - varchar(64)
          CASE WHEN pol.code <> pol.ins1guar THEN guar.lastname
				ELSE ''
		  END  , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
		  CASE WHEN pol.code <> pol.ins1guar THEN guar.address
				ELSE ''
		  END   , -- HolderAddressLine1 - varchar(256)
    --      CASE pol.primaryinsuredis WHEN '1' THEN ''
		  --                               ELSE guar.address2
		  --END  , -- HolderAddressLine2 - varchar(256)
    --      CASE pol.primaryinsuredis WHEN '1' THEN ''
		  --                               ELSE guar.city
		  --END  , -- HolderCity - varchar(128)
    --      CASE pol.primaryinsuredis WHEN '1' THEN ''
		  --                               ELSE guar.state
		  --END  , -- HolderState - varchar(2)
		  --CASE pol.primaryinsuredis WHEN '1' THEN ''
		  --                               ELSE guar.zipcode + guar.zipplus4
		  --END , -- HolderZipCode - varchar(9)
          CASE WHEN pol.code <> pol.ins1guar THEN LEFT(REPLACE(REPLACE(REPLACE(guar.homephone, '(', ''), ')', ''), '-', ''), 9)
				ELSE ''
		  END , -- HolderPhone - varchar(10)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.code  , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.[_import_4_3_PatientsDemographics] AS pol
JOIN dbo.PatientCase AS pc ON 
	pc.vendorID=pol.AutoTempID AND 
	pc.VendorImportID=@VendorImportID
JOIN dbo.InsuranceCompanyPlan AS icp ON 
	icp.vendorID=pol.ins1code AND 
	icp.VendorImportID=@VendorImportID
LEFT JOIN dbo.[_import_3_1_Sheet1] guar ON
	guar.code = pol.ins1guar AND
	pol.ins1guar <> 'TAMBE'
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'
 
 
PRINT''
PRINT'Inserting into Insurance Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderLastName ,
          HolderSuffix ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          --HolderAddressLine2 ,
          --HolderCity ,
          --HolderState ,
          --HolderZipCode ,
          HolderPhone ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          pol.ins2id , -- PolicyNumber - varchar(32)
          pol.ins2group , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          'S' , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN pol.code <> pol.ins2guar THEN guar.first
				ELSE ''
		  END , -- HolderFirstName - varchar(64)
          CASE WHEN pol.code <> pol.ins2guar THEN guar.lastname
				ELSE ''
		  END  , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pol.code <> pol.ins2guar THEN guar.address
				ELSE ''
		  END  , -- HolderAddressLine1 - varchar(256)
    --      CASE pol.primaryinsuredis WHEN '1' THEN ''
		  --                               ELSE guar.address2
		  --END  , -- HolderAddressLine2 - varchar(256)
    --      CASE pol.primaryinsuredis WHEN '1' THEN ''
		  --                               ELSE guar.city
		  --END  , -- HolderCity - varchar(128)
    --      CASE pol.primaryinsuredis WHEN '1' THEN ''
		  --                               ELSE guar.state
		  --END  , -- HolderState - varchar(2)
		  --CASE pol.primaryinsuredis WHEN '1' THEN ''
		  --                               ELSE guar.zipcode + guar.zipplus4
		  --END , -- HolderZipCode - varchar(9)
          CASE WHEN pol.code <> pol.ins2guar THEN LEFT(REPLACE(REPLACE(REPLACE(guar.homephone, '(', ''), ')', ''), '-', ''), 9)
				ELSE ''
		  END , -- HolderPhone - varchar(10)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.code  , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.[_import_4_3_PatientsDemographics] AS pol
JOIN dbo.PatientCase AS pc
ON pc.vendorID=pol.AutoTempID AND pc.VendorImportID=@VendorImportID
JOIN dbo.InsuranceCompanyPlan AS icp
ON icp.vendorID=pol.ins2code AND icp.VendorImportID=@VendorImportID
LEFT JOIN dbo.[_import_3_1_Sheet1] guar ON
	guar.code = pol.ins2guar 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT''
PRINT'Inserting into Insurance Policy 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderLastName ,
          HolderSuffix ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          --HolderAddressLine2 ,
          --HolderCity ,
          --HolderState ,
          --HolderZipCode ,
          HolderPhone ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          pol.ins3id , -- PolicyNumber - varchar(32)
          pol.ins3group , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          'S' , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN pol.code <> pol.ins3guar THEN guar.first
				ELSE ''
		  END , -- HolderFirstName - varchar(64)
          CASE WHEN pol.code <> pol.ins3guar THEN guar.lastname
				ELSE ''
		  END  , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
		  CASE WHEN pol.code <> pol.ins3guar THEN guar.address
				ELSE ''
		  END   , -- HolderAddressLine1 - varchar(256)
    --      CASE pol.primaryinsuredis WHEN '1' THEN ''
		  --                               ELSE guar.address2
		  --END  , -- HolderAddressLine2 - varchar(256)
    --      CASE pol.primaryinsuredis WHEN '1' THEN ''
		  --                               ELSE guar.city
		  --END  , -- HolderCity - varchar(128)
    --      CASE pol.primaryinsuredis WHEN '1' THEN ''
		  --                               ELSE guar.state
		  --END  , -- HolderState - varchar(2)
		  --CASE pol.primaryinsuredis WHEN '1' THEN ''
		  --                               ELSE guar.zipcode + guar.zipplus4
		  --END , -- HolderZipCode - varchar(9)
          CASE WHEN pol.code <> pol.ins3guar THEN LEFT(REPLACE(REPLACE(REPLACE(guar.homephone, '(', ''), ')', ''), '-', ''), 9)
				ELSE ''
		  END , -- HolderPhone - varchar(10)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.code  , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.[_import_4_3_PatientsDemographics] AS pol
JOIN dbo.PatientCase AS pc
ON pc.vendorID=pol.AutoTempID AND pc.VendorImportID=@VendorImportID
JOIN dbo.InsuranceCompanyPlan AS icp
ON icp.vendorID=pol.ins3code AND icp.VendorImportID=@VendorImportID
LEFT JOIN dbo.[_import_3_1_Sheet1] guar ON
	guar.code = pol.ins3guar 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Appointment ...'
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
SELECT    pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID) , -- ServiceLocationID - int
          DATEADD(mi, CAST(RIGHT(time, 2) AS INT), DATEADD(hh, time/100, CAST(date AS DATETIME))) , -- StartDate - datetime
          DATEADD(mi,15, DATEADD(mi, CAST(RIGHT(time, 2) AS INT), DATEADD(hh, time/100, CAST(date AS DATETIME)))) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          app.[desc] , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'C' , -- AppointmentConfirmationStatusCode
          pc.patientcaseid , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          time , -- StartTm - smallint
          time + 15  -- EndTm - smallint
FROM dbo.[_import_4_3_Appointments] app
LEFT JOIN dbo.Patient pat ON 
	app.patient = pat.MedicalRecordNumber AND 
	pat.VendorImportID = @VendorImportID
LEFT JOIN dbo.patientcase pc ON 
	pat.PatientID = pc.PatientID 
LEFT JOIN dbo.DateKeyToPractice dk ON
	dk.Dt = app.date AND 
	dk.PracticeID = @PracticeID
WHERE client <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'
	
	
	
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
          'Default Fee' , -- Name - varchar(128)
           'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          GETDATE() , -- EffectiveStartDate - datetime
          'F' , -- SourceType - char(1)
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


PRINT ''
PRINT 'Insert into StandardFee ...'
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
          impSFS.amount , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_4_3_FeeSchedule] impSFS
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule c ON
	CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
	c.practiceID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	impSFS.cptcode = pcd.ProcedureCode AND
	impSFS.amount <> ''	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'	
	
	
	
PRINT ''
PRINT 'Insert into StandardFeeLink ...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT    doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc , dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule	 sfs 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'	
	


PRINT ''
PRINT 'Updating PatientCase'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11 
WHERE 
	@VendorImportID = VendorImportID AND 
	@PracticeID = PracticeID AND
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID) AND
	PayerScenarioID <> 11
	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN
