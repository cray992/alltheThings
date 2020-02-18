--USE superbill_19205_dev
USE superbill_19205_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2 -- Vendor import record created through import tool

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

DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'

DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'

DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'

DELETE FROM dbo.InsurancePolicy WHERE (PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Policy records deleted '

DELETE FROM dbo.PatientCase WHERE PatientID IN (SELECT patientid FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient Case records deleted '

DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient Alert records deleted '

DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient records deleted '

DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Company Plans records deleted '

DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Companies records deleted '

PRINT ''
PRINT 'Inserting into Insurance Company ....'
INSERT INTO dbo.InsuranceCompany
		( 
			InsuranceCompanyName ,
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
			ins.insurance , -- InsuranceCompanyName - varchar(128)
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
			'0' , -- VendorID - varchar(50)
			@VendorImportID , -- VendorImportID - int
			1 , -- NDCFormat - int
			1 , -- UseFacilityID - bit
			'U' , -- AnesthesiaType - varchar(1)
			18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_Policies] AS ins
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Insurance Company Plan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( 
			PlanName ,
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


PRINT ''
PRINT 'Inserting into Patient ...'
INSERT INTO dbo.Patient
        ( 
			PracticeID ,
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
			[firstname] , -- FirstName - varchar(64)
			[middleinitial] , -- MiddleName - varchar(64)
			[lastname] , -- LastName - varchar(64)
			'' , -- Suffix - varchar(16)
			[address1] , -- AddressLine1 - varchar(256)
			[address2] , -- AddressLine2 - varchar(256)
			[city] , -- City - varchar(128)
			[state] , -- State - varchar(2)
			LEFT(REPLACE([zip], '-', ''), 9) , -- ZipCode - varchar(9)
			'' , -- Country
			[sex] , -- Gender - varchar(1)
			LEFT(REPLACE(REPLACE(REPLACE(REPLACE([homephone], ' ', ''), '(', ''), ')', ''), '-', ''), 10), -- HomePhone - varchar(10)
			REPLACE([ssn], '-', '') , -- SSN - char(9)
			GETDATE() , -- CreatedDate - datetime
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			[chartnumber] , -- MedicalRecordNumber
			[chartnumber] , -- VendorID - varchar(50)
			@VendorImportID , -- VendorImportID - int
			1 , -- Active - bit
			0 , -- SendEmailCorrespondence - bit
			1  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_2_1_PatientDemographics] 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Patient Alert ...'
INSERT INTO dbo.PatientAlert
        ( 
			PatientID ,
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
SELECT 
			PatientID , -- PatientID - int
			imp.alerts , -- AlertMessage - text
			1, -- ShowInPatientFlag - bit
			0, -- ShowInAppointmentFlag - bit
			0, -- ShowInEncounterFlag - bit
			GETDATE() , -- CreatedDate - datetime
			0, -- CreatedUserID - int
			GETDATE(), -- ModifiedDate - datetime
			0, -- ModifiedUserID - int
			0, -- ShowInClaimFlag - bit
			0, -- ShowInPaymentFlag - bit
			0  -- ShowInPatientStatementFlag - bit
FROM [_import_2_1_PatientDemographics] imp
INNER JOIN dbo.Patient pat ON
	imp.chartnumber = pat.VendorID
WHERE imp.alerts <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Patient Case ...'
INSERT INTO dbo.PatientCase
        ( 
			PatientID ,
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
			PAT.PatientID , -- PatientID - int
			'Default Case' , -- Name - varchar(128)
			1 , -- Active - bit
			5 , -- PayerScenarioID - int (5 is 'Commercial')
			'Created via data import, please review.' , -- Notes - text
			GETDATE() , -- CreatedDate - datetime
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			@PracticeID , -- PracticeID - int
			impCase.[chartnumber], -- VendorID - varchar(50)
			@VendorImportID -- VendorImportID - int
FROM dbo.[_import_2_1_PatientDemographics] impCase
INNER JOIN dbo.Patient PAT ON 
	impCase.[chartnumber] = PAT.VendorID AND 
	PAT.VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Policy ...'
INSERT INTO dbo.InsurancePolicy
        ( 
			PatientCaseID ,
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
SELECT  distinct  
			pc.PatientCaseID , -- PatientCaseID - int
			icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
			CASE WHEN ip.priority = 'Primary' THEN 1
				 WHEN ip.priority = 'Secondary' THEN 2
				 WHEN ip.priority = 'Tertiary' THEN 3
				 end , -- Precedence - int
			ip.policy , -- PolicyNumber - varchar(32)
			'S' , -- PatientRelationshipToInsured - varchar(1)
			GETDATE() , -- CreatedDate - datetime
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			1 , -- Active - bit
			@PracticeID , -- PracticeID - int
			ip.account + ip.priority , -- VendorID - varchar(50)
			@VendorImportID -- VendorImportID - int
FROM dbo.[_import_2_1_Policies] AS ip
INNER JOIN dbo.PatientCase AS pc ON 
	pc.VendorImportID = @VendorImportID AND
	pc.vendorID = ip.account
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON 
	icp.VendorImportID = @VendorimportID AND
	icp.PlanName = ip.insurance
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


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
VALUES  
		( 
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
          CAST(impSFS.standardfee AS MONEY), -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_2_1_StandardFeeSchedule] impSFS
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule c ON
	CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
	c.practiceID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	impSFS.cpt = pcd.ProcedureCode AND
	ISNUMERIC(impSFS.standardfee) = 1	
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
	sl.PracticeID = @PracticeID AND
	CAST(sfs.notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	sfs.PracticeID = @PracticeID
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



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