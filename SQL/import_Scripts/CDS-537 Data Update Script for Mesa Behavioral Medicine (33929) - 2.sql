USE superbill_33929_dev
--USE superbill_33929_prod
GO
 

 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 5

PRINT ''
PRINT 'Inserting Into PatientCase...'
INSERT INTO dbo.PatientCase
	( PatientID , Name , Active , PayerScenarioID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag ,
      AbuseRelatedFlag , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID ,
      PracticeID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , EPSDT , FamilyPlanning , EPSDTCodeID ,
      EmergencyRelated , HomeboundRelatedFlag )
SELECT DISTINCT
	pat.PatientID , -- PatientID - int
    'Balance Forward' , -- Name - varchar(128)
    1 , -- Active - bit
    11 , -- PayerScenarioID - int
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
    pd.ChartNumber , -- VendorID - varchar(50)
    @VendorImportID , -- VendorImportID - int
    0 , -- PregnancyRelatedFlag - bit
    1 , -- StatementActive - bit
    0 , -- EPSDT - bit
    0 , -- FamilyPlanning - bit
    1 , -- EPSDTCodeID - int
    0 , -- EmergencyRelated - bit
    0  -- HomeboundRelatedFlag - bit
FROM dbo._import_4_1_PatientData as pd
	INNER JOIN dbo.Patient AS pat ON
		pat.VendorID = pd.ChartNumber AND
		pat.VendorImportID IN (1,3,4) AND
        pat.CreatedUserID = 0
	LEFT JOIN dbo.PatientCase pc ON
		pc.PatientID = pat.PatientID AND
		pc.Name = 'Balance Forward'
WHERE pc.PatientCaseID IS NULL AND pd.patientreferencebalance > '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Encounter...'
INSERT INTO dbo.Encounter
	( PracticeID , PatientID , DoctorID , LocationID , DateOfService , DateCreated , Notes , EncounterStatusID , CreatedDate ,
      CreatedUserID , ModifiedDate , ModifiedUserID , ReleaseSignatureSourceCode , PlaceOfServiceCode , PatientCaseID , PostingDate ,
      DateOfServiceTo , PaymentMethod ,	AddOns , DoNotSendElectronic , SubmittedDate , PaymentTypeID , VendorID , VendorImportID ,
      DoNotSendElectronicSecondary , overrideClosingDate , ClaimTypeID , SecondaryClaimTypeID , SubmitReasonIDCMS1500 , SubmitReasonIDUB04 ,
      PatientCheckedIn )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          realpat.PatientID , -- PatientID - int
          2  , -- DoctorID - int 
          1 , -- LocationID - int
          GETDATE() , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          Convert(Varchar(10), GETDATE(),101) + ': Creating Balance Forward' , -- Notes - text
          2 , -- EncounterStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
          PC.PatientCaseID , -- PatientCaseID - int
          GETDATE() , -- PostingDate - datetime
          GETDATE() , -- DateOfServiceTo - datetime
          'U' , -- PaymentMethod - char(1)
          0 , -- AddOns - bigint
          0 , -- DoNotSendElectronic - bit
          GETDATE() , -- SubmittedDate - datetime
          0 , -- PaymentTypeID - int
          realpat.VendorID , -- VendorID - varchar(50)                   
          @VendorImportID , -- VendorImportID - int
          0 , -- DoNotSendElectronicSecondary - bit
          0 , -- overrideClosingDate - bit
          0 , -- ClaimTypeID - int
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
          0  -- PatientCheckedIn - bit
	FROM dbo._import_4_1_PatientData AS impPat
	INNER JOIN dbo.Patient realpat ON
		   impPat.ChartNumber = realpat.VendorID AND
		   realpat.VendorImportID IN (1,3,4)
	INNER JOIN dbo.PatientCase PC ON
		   realpat.PatientID = pc.PatientID AND
		   pc.Name = 'Balance Forward' AND
           pc.VendorImportID = @VendorImportID
WHERE impPat.patientreferencebalance > '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Encounter Diagnosis...'
INSERT INTO dbo.EncounterDiagnosis
	( EncounterID , DiagnosisCodeDictionaryID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ListSequence ,
	  PracticeID , VendorID , VendorImportID )
SELECT DISTINCT
          enc.EncounterID , -- EncounterID - int
          dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- ListSequence - int
          @PracticeID  , -- PracticeID - int
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Encounter as enc 
INNER JOIN dbo.DiagnosisCodeDictionary AS dcd ON
    dcd.DiagnosisCode = '000.00' AND 
    enc.PracticeID = @PracticeID        
WHERE enc.VendorImportID = @VendorImportID AND enc.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Encounter Procedure...'
INSERT INTO dbo.EncounterProcedure
	( EncounterID , ProcedureCodeDictionaryID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ServiceChargeAmount ,   
	  ServiceUnitCount , ProcedureDateOfService , PracticeID , EncounterDiagnosisID1 , ServiceEndDate , VendorID ,
	  VendorImportID , TypeOfServiceCode , AnesthesiaTime , AssessmentDate , DoctorID , ConcurrentProcedures )
SELECT DISTINCT
          enc.EncounterID  , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.patientreferencebalance , -- ServiceChargeAmount - money    
          '1.000' , -- ServiceUnitCount - decimal
          GETDATE() , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          ed.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
          GETDATE() , -- ServiceEndDate - datetime
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          '1' , -- TypeOfServiceCode - char(1)
          0 , -- AnesthesiaTime - int
          GETDATE() , -- AssessmentDate - datetime
          enc.DoctorID , -- DoctorID - int
          1  -- ConcurrentProcedures - int
FROM dbo.Encounter AS enc
	INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
		pcd.OfficialName = 'BALANCE FORWARD' 
	INNER JOIN dbo.EncounterDiagnosis AS ed ON
		ed.vendorID = enc.VendorID AND 
		ed.VendorImportID = @VendorImportID   
	INNER JOIN dbo._import_4_1_PatientData i ON
		enc.VendorID = i.ChartNumber AND
		enc.VendorImportID = @VendorImportID
WHERE enc.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Alert...'
INSERT INTO dbo.PatientAlert
	( PatientID , AlertMessage , ShowInPatientFlag , ShowInAppointmentFlag , ShowInEncounterFlag , CreatedDate , CreatedUserID ,
	  ModifiedDate , ModifiedUserID , ShowInClaimFlag , ShowInPaymentFlag , ShowInPatientStatementFlag )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          'Balance Forward Encounter is Present' , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          1 , -- ShowInAppointmentFlag - bit
          1 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
		  0 , -- ShowInClaimFlag - biy
          1 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo._import_4_1_PatientData i
	INNER JOIN dbo.Patient p ON
		p.VendorID = i.ChartNumber AND
		p.VendorImportID IN (1,4,@VendorImportID)
	INNER JOIN dbo.Encounter e ON
		p.PatientID = e.PatientID AND
		e.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT




