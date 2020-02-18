USE superbill_19040_dev
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
          ZipCode ,
          Phone ,
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
		  insurancename , -- InsuranceCompanyName - varchar(128)
          address, -- AddressLine1 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          LEFT(dbo.fn_RemoveNonNumericCharacters(zip), 9) , -- ZipCode - varchar(9)
          RIGHT(dbo.fn_RemoveNonNumericCharacters(phone), 10) , -- Phone - varchar(10)
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
          insurancename , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U'  -- AnesthesiaType - varchar(1)
		  18
FROM dbo.[_import_1_1_InsuranceList]
WHERE insurancename <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
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
SELECT DISTINCT
	      imp.insurancename, -- PlanName - varchar(128)
          imp.address, -- AddressLine1 - varchar(256)
          imp.City , -- City - varchar(128)
          imp.State , -- State - varchar(2)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.zip), 9) , -- ZipCode - varchar(9)
          RIGHT(dbo.fn_RemoveNonNumericCharacters(imp.phone), 10) , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPractimpeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          imp.insurancename , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_InsuranceList] imp
	INNER JOIN dbo.InsuranceCompany ic ON 
		ic.VendorID = imp.insurancename AND
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
          Gender ,
          HomePhone ,
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
		  MaritalStatus ,
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
          Active ,
          SendEmailCorrespondence 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          imp.firstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          CASE imp.state WHEN 'Massachusetts' THEN 'MA'
						 WHEN 'New Mexico' THEN 'NM'
						 WHEN 'Pennsylvania' THEN 'PA'
						 WHEN 'New Hampshire' THEN 'NH'
						 WHEN 'Delaware' THEN 'DE'
						 WHEN 'New Jersey' THEN 'NJ'
						 WHEN 'New York' THEN 'NY'
						 WHEN 'Maryland' THEN 'MD'
						 WHEN 'Louisiana' THEN 'LA'
						 WHEN 'Alabama' THEN 'AL'
						 ELSE '' END , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.zipcode), 9) , -- ZipCode - varchar(9)
          imp.gender , -- Gender - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.home), 10) , -- HomePhone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.homeext), 10) , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.work), 10) , -- WorkPhone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.workext), 10), -- WorkPhoneExt - varchar(10)
          imp.dateofbirth , -- DOB - datetime
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.ssnno), 10) , -- SSN - char(9)
		  'U' , --MaritalStatus ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          imp.defaultproviderid , -- PrimaryProviderID - int
          CASE imp.location WHEN 'Lewis M. Milrod, M.D., P.C.' THEN 1
							ELSE NULL END  , -- DefaultServiceLocationID - int
          imp.chartno , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.cell), 10) , -- MobilePhone - varchar(10)
          imp.chartno , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          NULL  -- SendEmailCorrespondence - bit
FROM dbo.[_import_1_1_PatientDemoInsFirst] imp
WHERE imp.chartno <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Patient(2)... '
INSERT INTO dbo.Patient
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Gender ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
		  MaritalStatus ,
          EmailAddress ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          imp.firstname , -- FirstName - varchar(64)
          imp.middlename , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          imp.suffix , -- Suffix - varchar(16)
          imp.homestreet , -- AddressLine1 - varchar(256)
          imp.homecity , -- City - varchar(128)
          imp.homestate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.homepostalcode), 9) , -- ZipCode - varchar(9)
          imp.gender , -- Gender - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.homephone), 10) , -- HomePhone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.businessphone), 10) , -- WorkPhone - varchar(10)
          GETDATE() , -- DOB - datetime
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.ssn), 9) , -- SSN - char(9)
		  'U' , --MaritalStatus
          imp.emailaddress , -- EmailAddress - varchar(256)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          imp.chartno , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.mobilephone), 10) , -- MobilePhone - varchar(10)
          imp.chartno , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          NULL  -- SendEmailCorrespondence - bit
FROM dbo.[_import_1_1_PatientDemoSecond] imp
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pat
				 WHERE imp.chartno = pat.MedicalRecordNumber)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'





PRINT ''
PRINT 'Insert Into PatientCase...'
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
          StatementActive 
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
          1  -- StatementActive - bit
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting InsurancePolicy1...'
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
		  'S', -- PatientRelationship to Insured
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.chartno , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemoInsFirst] imp
	INNER JOIN dbo.PatientCase pc ON	
		pc.VendorID = imp.chartno AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = imp.priinspayer AND
		icp.VendorImportID = @VendorImportID
WHERE imp.priinspolicy <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Insurance Policy2...'
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
		  'S', -- PatientRelationship to Insured
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.chartno , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemoInsFirst] imp
	INNER JOIN dbo.PatientCase pc ON	
		pc.VendorID = imp.chartno AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = imp.secinspayer AND
		icp.VendorImportID = @VendorImportID
WHERE imp.secinspayer <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Insurance Policy3...'
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
		  'S', -- PatientRelationship to Insured
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.chartno , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemoInsFirst] imp
	INNER JOIN dbo.PatientCase pc ON	
		pc.VendorID = imp.chartno AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = imp.terinspayer AND
		icp.VendorImportID = @VendorImportID
WHERE imp.terinspayer <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into Standard Fee Schedule...'
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
VALUES
        ( @PracticeID , -- PracticeID - int
          'Default Fee Schedule' , -- Name - varchar(128)
          'Vendor Import ' + CAST (@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          '2013-01-01 07:00:00' , -- EffectiveStartDate - datetime
          'F' , -- SourceType - char(1)
          'Import File' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL ,-- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
		  )
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Standard Fees...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT DISTINCT
	      SFS.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          PCD.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          IMP.amount , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_1_1_FeeSchedule] IMP
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule SFS ON
	SFS.PracticeID = @PracticeID AND
	SFS.Notes = 'Vendor Import ' + CAST (@VendorImportID AS VARCHAR)
INNER JOIN dbo.ProcedureCodeDictionary PCD ON
	PCD.ProcedureCode = IMP.cptcode
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Standard Fee Schedule Link...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT DISTINCT
	      DOC.DoctorID , -- ProviderID - int
          SL.ServiceLocationID , -- LocationID - int
          SFS.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor AS DOC, dbo.ServiceLocation AS SL, dbo.ContractsAndFees_StandardFeeSchedule AS SFS 
WHERE DOC.[External] = 0 AND 
	DOC.PracticeID = @PracticeID AND
	SL.PracticeID = @PracticeID AND
	SFS.Notes = 'Vendor Import ' + CAST (@VendorImportID AS VARCHAR) AND
	SFS.PracticeID = @PracticeID 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting into Appointments...'
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
          AppointmentConfirmationStatusCode ,
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT 
		  pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          imp.startdate , -- StartDate - datetime
          imp.enddate, -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          imp.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          imp.status , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          imp.starttime, -- StartTm - smallint
          imp.endtime  -- EndTm - smallint
FROM dbo.[_import_2_1_AppointmentReUp] imp
INNER JOIN dbo.Patient pat ON
	pat.VendorID = imp.chartno AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON
	pc.PatientID = pat.PatientID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = (SELECT Dt from dbo.DateKeyToPractice WHERE Dt = DATEADD(d,0,DATEDIFF(d,0,imp.startdate)))
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting into AppointmentToResource...'
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
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_AppointmentReUp] impAppt
INNER JOIN dbo.Patient pat ON 
	impAppt.chartno = pat.VendorID AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment appt ON 
	pat.PatientID = appt.PatientID AND
	appt.StartDate = impAppt.startdate

PRINT CAST(@@rowcount AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating into PatientCase ...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11
	WHERE PayerScenarioID = 5 AND
		VendorImportID = @VendorImportID AND
		PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

	

COMMIT