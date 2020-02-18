USE superbill_21855_prod
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
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'

PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
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
          AnesthesiaType 
        )
SELECT DISTINCT
		  IMP.planname1 , -- InsuranceCompanyName - varchar(128)
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
          IMP.planid1, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
		  1 , -- UseFacilityID - bitk
          'U'  -- AnesthesiaType - varchar(1)
FROM dbo.[_import_2_1_Sheet1] IMP
WHERE IMP.planname1 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
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
		  IMP.planname1, -- PlanName - varchar(128)
          IMP.plan1address1 , -- AddressLine1 - varchar(256)
          IMP.plan1address2 , -- AddressLine2 - varchar(256)
          IMP.plan1city, -- City - varchar(128)
          IMP.plan1state , -- State - varchar(2)
          IMP.plan1zip , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- M- RecordTimeStamp - timestamp
          @PracticeID, -- CreatedPracticeID - int
          IC.InsuranceCompanyID, -- InsuranceCompanyID - int
          IMP.planid1 , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_Sheet1] IMP
INNER JOIN dbo.InsuranceCompany IC ON
	IC.VendorID = IMP.planid1 AND
	IC.VendorImportID = @VendorImportID
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
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
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
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          zip , -- ZipCode - varchar(9)
          gender , -- Gender - varchar(1)
          maritalstatus , -- MaritalStatus - varchar(1)
          homephone , -- HomePhone - varchar(10)
          workphone , -- WorkPhone - varchar(10)
          workext , -- WorkPhoneExt - varchar(10)
        CASE WHEN ISDATE(dob) = 1 THEN dob
			   ELSE NULL END , -- DOB - datetime
          ssn , -- SSN - char(9)
          email , -- EmailAddress - varchar(256)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
		  GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN primaryprovlastname = 'Ohearn' THEN 1
			   WHEN primaryprovlastname = 'Hanscom' THEN 2 
			   ELSE '' END , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          chartnumber , -- MedicalRecordNumber - varchar(128)
          mobilephone , -- MobilePhone - varchar(10)
          chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_1_1_PatientDemo]
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Insert Into PayerScenario'
INSERT INTO dbo.PayerScenario
        ( Name ,
          Description ,
          PayerScenarioTypeID ,
          StatementActive
        )
VALUES  ( 'Medicare Part B' , -- Name - varchar(128)
          NULL , -- Description - varchar(256)
          1 , -- PayerScenarioTypeID - int
          1  -- StatementActive - bit
        )
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Patient Alert'
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
	      PAT.PatientID , -- PatientID - int
          'Patient Balance from Misys' + '' + IMP.patientbalance , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_1_1_PatientCasePolicy] IMP
	INNER JOIN dbo.Patient PAT ON
	PAT.VendorID = IMP.chartnumber AND
	PAT.VendorImportID = @VendorImportID
WHERE IMP.patientbalance <> ''
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
          CASE IMP.patientcasepayerscenario1 WHEN 11 THEN 7
											 WHEN 17 THEN 5
											 WHEN 20 THEN 17
											 WHEN 21 THEN 8 
											 ELSE 5 END  , -- PayerScenarioID - int
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
FROM dbo.Patient PAT
INNER JOIN dbo.[_import_1_1_PatientCasePolicy] IMP ON
	IMP.chartnumber = PAT.VendorID AND
	PAT.VendorImportID = @VendorImportID

WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into Policy1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderDOB ,
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
	      PAT.PatientCaseID , -- PatientCaseID - int
          ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          IMP.policy1 , -- PolicyNumber - varchar(32)
          IMP.group1 , -- GroupNumber - varchar(32)
          CASE IMP.patientrelationship1 WHEN 'Self' THEN 'S'
										WHEN 'Other' THEN 'O'
										WHEN 'Child' THEN 'C'
										WHEN 'Spouse' THEN 'U'
										ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN IMP.patientrelationship1 <> 'Self' THEN IMP.sub1firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN IMP.patientrelationship1 <> 'Self' THEN IMP.sub1middlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN IMP.patientrelationship1 <> 'Self' THEN IMP.sub1lastname END , -- HolderLastName - varchar(64)
		  CASE WHEN IMP.patientrelationship1 <> 'Self' THEN IMP.sub1dob END , --HolderDOB - datetime
          CASE WHEN IMP.patientrelationship1 <> 'Self' THEN IMP.sub1ssn END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
         GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN IMP.patientrelationship1 <> 'Self' THEN IMP.sub1sex END , -- HolderGender - char(1)
          CASE WHEN IMP.patientrelationship1 <> 'Self' THEN IMP.policy1 END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          IMP.chartnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientCasePolicy] IMP
INNER JOIN dbo.PatientCase PAT ON 
	IMP.chartnumber = PAT.VendorID AND
	PAT.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan ICP ON
	ICP.VendorID = IMP.planid1 AND
	ICP.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Policy2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderDOB ,
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
	      PAT.PatientCaseID , -- PatientCaseID - int
          ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          IMP.policy2 , -- PolicyNumber - varchar(32)
          IMP.group2 , -- GroupNumber - varchar(32)
          CASE IMP.patientrelationship2 WHEN 'Self' THEN 'S'
										WHEN 'Other' THEN 'O'
										WHEN 'Child' THEN 'C'
										WHEN 'Spouse' THEN 'U'
										ELSE 'S' END , -- PatientRelationshipToInsured - varchar(2)
          CASE WHEN IMP.patientrelationship2 <> 'Self' THEN IMP.sub2firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN IMP.patientrelationship2 <> 'Self' THEN IMP.sub2middlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN IMP.patientrelationship2 <> 'Self' THEN IMP.sub2lastname END , -- HolderLastName - varchar(64)
		  CASE WHEN IMP.patientrelationship2 <> 'Self' THEN IMP.sub2dob END , --HolderDOB - datetime
          CASE WHEN IMP.patientrelationship2 <> 'Self' THEN IMP.sub2ssn END , -- HolderSSN - char(22)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
         GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN IMP.patientrelationship2 <> 'Self' THEN IMP.sub2gender END , -- HolderGender - char(2)
          CASE WHEN IMP.patientrelationship2 <> 'Self' THEN IMP.policy2 END , -- DependentPolicyNumber - varchar(32)
          2 , -- Active - bit
          @PracticeID , -- PracticeID - int
          IMP.chartnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientCasePolicy] IMP
INNER JOIN dbo.PatientCase PAT ON 
	IMP.chartnumber = PAT.VendorID AND
	PAT.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan ICP ON
	ICP.VendorID = IMP.planid2 AND
	ICP.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'





PRINT ''
PRINT 'Inserting Into Policy3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderDOB ,
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
	      PAT.PatientCaseID , -- PatientCaseID - int
          ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          IMP.policy3 , -- PolicyNumber - varchar(33)
          IMP.group3 , -- GroupNumber - varchar(33)
          CASE IMP.patientrelationship3 WHEN 'Self' THEN 'S'
										WHEN 'Other' THEN 'O'
										WHEN 'Child' THEN 'C'
										WHEN 'Spouse' THEN 'U'
										ELSE 'S' END , -- PatientRelationshipToInsured - varchar(3)
          CASE WHEN IMP.patientrelationship3 <> 'Self' THEN IMP.sub3firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN IMP.patientrelationship3 <> 'Self' THEN IMP.sub3middlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN IMP.patientrelationship3 <> 'Self' THEN IMP.sub3lastname END , -- HolderLastName - varchar(64)
		  CASE WHEN IMP.patientrelationship3 <> 'Self' THEN IMP.sub3dob END , --HolderDOB - datetime
          CASE WHEN IMP.patientrelationship3 <> 'Self' THEN IMP.sub3ssn END , -- HolderSSN - char(33)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
         GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN IMP.patientrelationship3 <> 'Self' THEN IMP.sub3gender END , -- HolderGender - char(3)
          CASE WHEN IMP.patientrelationship3 <> 'Self' THEN IMP.policy3 END , -- DependentPolicyNumber - varchar(33)
          3 , -- Active - bit
          @PracticeID , -- PracticeID - int
          IMP.chartnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientCasePolicy] IMP
INNER JOIN dbo.PatientCase PAT ON 
	IMP.chartnumber = PAT.VendorID AND
	PAT.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan ICP ON
	ICP.VendorID = IMP.planid3 AND
	ICP.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Referring Doctor...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
		  Prefix ,
		  Suffix ,
          FirstName ,
          MiddleName ,
          LastName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          WorkPhone ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] 
        )
SELECT DISTINCT 
		  @PracticeID , -- PracticeID - int
		  '', --Prefix
          '', -- Suffix
		  firstname , -- FirstName - varchar(64)
          middleinitial , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          street1 , -- AddressLine1 - varchar(256)
          street2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT(state, 2) , -- State - varchar(2)
          LEFT(zip, 9) , -- ZipCode - varchar(9)
          workphone , -- WorkPhone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          degree , -- Degree - varchar(8)
          id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(REPLACE(fax,'',''),10) , -- FaxNumber - varchar(10)
          1  -- External - bit
FROM dbo.[_import_1_1_ReferringPhysician]
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
          IMP.fee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_1_1_FeeSchedule] IMP
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule SFS ON
	SFS.PracticeID = @PracticeID AND
	SFS.Notes = 'Vendor Import ' + CAST (@VendorImportID AS VARCHAR)
INNER JOIN dbo.ProcedureCodeDictionary PCD ON
	PCD.ProcedureCode = IMP.identifier
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





/*
----------------------------------------------------------------------------------------------------------------------------------

UPDATE FOR PATIENT CASES THAT DON'T EXIST BECAUSE THEY HAD NO INSURANCE AS SELF-PAY (11)

----------------------------------------------------------------------------------------------------------------------------------
*/

PRINT ''
PRINT 'Updating Patient Cases...'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11,
	NAME = 'Self Pay'
WHERE 
	@VendorImportID = VendorImportID AND 
	@PracticeID = PracticeID AND
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID) AND
	PayerScenarioID <> 11
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated'




COMMIT