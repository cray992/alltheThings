USE superbill_27495_dev
--USE superbill_27495_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT

SET @VendorImportID = 4
SET @PracticeID = 1


--DELETE FROM dbo.EncounterDiagnosis WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter Diagnosis records deleted'
--DELETE FROM dbo.EncounterProcedure WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter Procedure records deleted'
--DELETE FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter records deleted'
--DELETE FROM dbo.PatientCase WHERE name LIKE 'Balance%' AND ModifiedUserID = -50 AND CreatedUserID = -50 AND PracticeID = @PracticeID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Balance Forward Case records deleted'


PRINT ''
PRINT 'Updating Medical Records Number on Patients...'
UPDATE dbo.Patient
	SET MedicalRecordNumber = imppat.mrn
FROM dbo.Patient AS pat
INNER JOIN dbo.[_import_6_1_MRNUpdate] AS imppat ON
	imppat.patientname = pat.VendorID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
	PRINT 'Inserting into Patient Case for Balance Forward...'
      --Create PatientCase for Balance Forward
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
                    realpat.PatientID , -- PatientID - int
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
                    realpat.VendorID , -- VendorID - varchar(50)
                    @VendorImportID , -- VendorImportID - int
                    0 , -- PregnancyRelatedFlag - bit
                    1 , -- StatementActive - bit
                    0 , -- EPSDT - bit
                    0 , -- FamilyPlanning - bit
                    1 , -- EPSDTCodeID - int
                    0 , -- EmergencyRelated - bit
                    0  -- HomeboundRelatedFlag - bit
      FROM dbo.Patient realpat
      INNER JOIN dbo.[_import_4_1_patientdemographics] AS impPat ON
            realpat.VendorID = impPat.patientname
      WHERE realpat.VendorImportID = @VendorImportID AND CAST(impPat.balance AS VARCHAR) > '$0.00' AND impPat.balance NOT LIKE '($%'
	  PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


      --Creating Diagnosis Code for Balance Forward
      IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE OfficialName = 'Miscellaneous')
      BEGIN
  PRINT ''
  PRINT 'Inserting into Diagnosis Code Dictionary...'    
               INSERT INTO dbo.DiagnosisCodeDictionary
                       ( 
						DiagnosisCode ,
                        CreatedDate ,
                        CreatedUserID ,
                        ModifiedDate ,
                        ModifiedUserID ,
                        KareoDiagnosisCodeDictionaryID ,
                        Active ,
                        OfficialName ,
                        LocalName ,
                        OfficialDescription
                       )
               VALUES  
					   ( 
						'000.00' , -- DiagnosisCode - varchar(16)
                        GETDATE() , -- CreatedDate - datetime
                        -50 , -- CreatedUserID - int
                        GETDATE() , -- ModifiedDate - datetime
                        -50 , -- ModifiedUserID - int
                        NULL , -- KareoDiagnosisCodeDictionaryID - int
                        1 , -- Active - bit
                        'Miscellaneous' , -- OfficialName - varchar(300)
                        'Miscellaneous' , -- LocalName - varchar(100)
                        NULL  -- OfficialDescription - varchar(500)
                       )

	PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
	  END


	  
	PRINT ''
	PRINT 'Inserting into Encounter for Balance Forward...'
      --Create Encounter for Balance Forward
      INSERT INTO dbo.Encounter
                  ( PracticeID ,
                    PatientID ,
                    DoctorID ,
                    AppointmentID ,
                    LocationID ,
                    PatientEmployerID ,
                    DateOfService ,
                    DateCreated ,
                    Notes ,
                    EncounterStatusID ,
                    AdminNotes ,
                    AmountPaid ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID ,
                    MedicareAssignmentCode ,
                    ReleaseOfInformationCode ,
                    ReleaseSignatureSourceCode ,
                    PlaceOfServiceCode ,
                    ConditionNotes ,
                    PatientCaseID ,
                    InsurancePolicyAuthorizationID ,
                    PostingDate ,
                    DateOfServiceTo ,
                    SupervisingProviderID ,
                    ReferringPhysicianID ,
                    PaymentMethod ,
                    Reference ,
                    AddOns ,
                    HospitalizationStartDT ,
                    HospitalizationEndDT ,
                    Box19 ,
                    DoNotSendElectronic ,
                    SubmittedDate ,
                    PaymentTypeID ,
                    PaymentDescription ,
                    EDIClaimNoteReferenceCode ,
                    EDIClaimNote ,
                    VendorID ,
                    VendorImportID ,
                    AppointmentStartDate ,
                    BatchID ,
                    SchedulingProviderID ,
                    DoNotSendElectronicSecondary ,
                    PaymentCategoryID ,
                    overrideClosingDate ,
                    Box10d ,
                    ClaimTypeID ,
                    OperatingProviderID ,
                    OtherProviderID ,
                    PrincipalDiagnosisCodeDictionaryID ,
                    AdmittingDiagnosisCodeDictionaryID ,
                    PrincipalProcedureCodeDictionaryID ,
                    DRGCodeID ,
                    ProcedureDate ,
                    AdmissionTypeID ,
                    AdmissionDate ,
                    PointOfOriginCodeID ,
                    AdmissionHour ,
                    DischargeHour ,
                    DischargeStatusCodeID ,
                    Remarks ,
                    SubmitReasonID ,
                    DocumentControlNumber ,
                    PTAProviderID ,
                    SecondaryClaimTypeID ,
                    SubmitReasonIDCMS1500 ,
                    SubmitReasonIDUB04 ,
                    DocumentControlNumberCMS1500 ,
                    DocumentControlNumberUB04 ,
                    EDIClaimNoteReferenceCodeCMS1500 ,
                    EDIClaimNoteReferenceCodeUB04 ,
                    EDIClaimNoteCMS1500 ,
                    EDIClaimNoteUB04 ,
                    PatientCheckedIn ,
                    RoomNumber
                  )
      SELECT		@PracticeID , -- PracticeID - int
                    realpat.PatientiD , -- PatientID - int
                    2 , -- DoctorID - int
                    NULL , -- AppointmentID - int
					1 , -- LocationID - int
                    NULL , -- PatientEmployerID - int
                    GETDATE() , -- DateOfService - datetime
                    GETDATE() , -- DateCreated - datetime
                    CONVERT(VARCHAR(10),GETDATE(),101) + ': Creating Balance Forward' , -- Notes - text
                    2 , -- EncounterStatusID - int            
                    '' , -- AdminNotes - text
                    NULL , -- AmountPaid - money
                    GETDATE() , -- CreatedDate - datetime
                    -50 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    -50 , -- ModifiedUserID - int
                    NULL , -- MedicareAssignmentCode - char(1)
                    NULL , -- ReleaseOfInformationCode - char(1)
                    'B' , -- ReleaseSignatureSourceCode - char(1)
                    11 , -- PlaceOfServiceCode - char(2)
                    NULL , -- ConditionNotes - text
                    pc.PatientCaseID , -- PatientCaseID - int
                    NULL , -- InsurancePolicyAuthorizationID - int
                    GETDATE()  , -- PostingDate - datetime
                    GETDATE() , -- DateOfServiceTo - datetime
                    NULL , -- SupervisingProviderID - int
                    NULL , -- ReferringPhysicianID - int
                    'U' , -- PaymentMethod - char(1)                     
                    NULL , -- Reference - varchar(40)
                    0 , -- AddOns - bigint
                    NULL , -- HospitalizationStartDT - datetime
                    NULL , -- HospitalizationEndDT - datetime
                    NULL , -- Box19 - varchar(51)
                    0 , -- DoNotSendElectronic - bit
                    GETDATE() , -- SubmittedDate - datetime
                    0 , -- PaymentTypeID - int                                           
                    NULL , -- PaymentDescription - varchar(250)
                    NULL , -- EDIClaimNoteReferenceCode - char(3)
                    NULL , -- EDIClaimNote - varchar(1600)
                    impPat.patientname , -- VendorID - varchar(50)
                    @VendorImportID , -- VendorImportID - int
                    NULL , -- AppointmentStartDate - datetime
                    NULL , -- BatchID - varchar(50)
                    NULL , -- SchedulingProviderID - int
                    0 , -- DoNotSendElectronicSecondary - bit
                    NULL , -- PaymentCategoryID - int
                    0 , -- overrideClosingDate - bit
                    NULL , -- Box10d - varchar(40)
                    0 , -- ClaimTypeID - int  
                    NULL , -- OperatingProviderID - int
                    NULL , -- OtherProviderID - int
                    NULL , -- PrincipalDiagnosisCodeDictionaryID - int
                    NULL , -- AdmittingDiagnosisCodeDictionaryID - int
                    NULL , -- PrincipalProcedureCodeDictionaryID - int
                    NULL , -- DRGCodeID - int
                    NULL , -- ProcedureDate - datetime
                    NULL , -- AdmissionTypeID - int
                    NULL , -- AdmissionDate - datetime
                    NULL , -- PointOfOriginCodeID - int
                    NULL , -- AdmissionHour - varchar(2)
                    NULL , -- DischargeHour - varchar(2)
                    NULL , -- DischargeStatusCodeID - int
                    NULL , -- Remarks - varchar(255)
                    NULL , -- SubmitReasonID - int
                    NULL , -- DocumentControlNumber - varchar(26)
                    NULL , -- PTAProviderID - int
                    0 , -- SecondaryClaimTypeID - int
                    2 , -- SubmitReasonIDCMS1500 - int
                    2 , -- SubmitReasonIDUB04 - int
                    '' , -- DocumentControlNumberCMS1500 - varchar(26)
                    '' , -- DocumentControlNumberUB04 - varchar(26)
                    NULL , -- EDIClaimNoteReferenceCodeCMS1500 - char(3)
                    NULL , -- EDIClaimNoteReferenceCodeUB04 - char(3)
                    NULL , -- EDIClaimNoteCMS1500 - varchar(1600)
                    NULL , -- EDIClaimNoteUB04 - varchar(1600)
                    0 , -- PatientCheckedIn - bit
                    NULL  -- RoomNumber - varchar(32)
      FROM dbo.[_import_4_1_patientdemographics] impPat
      INNER JOIN dbo.Patient realpat ON
               impPat.patientname = realpat.VendorID AND
               realpat.VendorImportID = @VendorImportID
      INNER JOIN dbo.PatientCase PC ON
               realpat.PatientID = pc.PatientID AND
               pc.Name = 'Balance Forward' AND
               pc.VendorImportID = @VendorImportID
      WHERE CAST(impPat.balance AS VARCHAR) > '$0.00' AND impPat.balance NOT LIKE '($%'
	  PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	  
	PRINT ''
	PRINT 'Inserting into Encounter Diagnosis...'
      --EncounterDiagnosis
      INSERT INTO dbo.EncounterDiagnosis
                  ( 
				  EncounterID ,
                  DiagnosisCodeDictionaryID ,
                  CreatedDate ,
                  CreatedUserID ,
                  ModifiedDate ,
                  ModifiedUserID ,
                  ListSequence ,
                  PracticeID ,
                  VendorID ,
                  VendorImportID
                  )
      SELECT    E.EncounterID , -- EncounterID - int
                dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
                GETDATE() , -- CreatedDate - datetime
                -50 , -- CreatedUserID - int
                GETDATE() , -- ModifiedDate - datetime
                -50 , -- ModifiedUserID - int
                1 , -- ListSequence - int
                @PracticeID , -- PracticeID - int
                impPat.patientname , -- VendorID - varchar(50)
                @VendorImportID  -- VendorImportID - int
      FROM dbo.[_import_4_1_patientdemographics] impPat
      INNER JOIN dbo.Encounter E ON 
               impPat.patientname = E.VendorID AND
               CAST(E.Notes AS VARCHAR) = CAST(CONVERT(VARCHAR(10),GETDATE(),101) + ': Creating Balance Forward' AS VARCHAR) AND
               E.VendorImportID = @VendorImportID
      INNER JOIN dbo.DiagnosisCodeDictionary dcd ON
               dcd.DiagnosisCode = '000.00'
      WHERE CAST(impPat.balance AS VARCHAR) > '$0.00' AND impPat.balance NOT LIKE '($%'
	  PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



	PRINT ''
	PRINT 'Inserting into Encounter Procedure...'
      --EncounterProcedure
      INSERT INTO dbo.EncounterProcedure
                  ( 
				  EncounterID ,
                  ProcedureCodeDictionaryID ,
                  CreatedDate ,
                  CreatedUserID ,
                  ModifiedDate ,
                  ModifiedUserID ,
                  ServiceChargeAmount ,
                  ServiceUnitCount ,
                  ProcedureModifier1 ,
                  ProcedureModifier2 ,
                  ProcedureModifier3 ,
                  ProcedureModifier4 ,
                  ProcedureDateOfService ,
                  PracticeID ,
                  EncounterDiagnosisID1 ,
                  EncounterDiagnosisID2 ,
                  EncounterDiagnosisID3 ,
                  EncounterDiagnosisID4 ,
                  ServiceEndDate ,
                  VendorID ,
                  VendorImportID ,
                  ContractID ,
                  Description ,
                  EDIServiceNoteReferenceCode ,
                  EDIServiceNote ,
                  TypeOfServiceCode ,
                  AnesthesiaTime ,
                  ApplyPayment ,
                  PatientResp ,
                  AssessmentDate ,
                  RevenueCodeID ,
                  NonCoveredCharges ,
                  DoctorID ,
                  StartTime ,
                  EndTime ,
                  ConcurrentProcedures ,
                  StartTimeText ,
                  EndTimeText
                  )
      SELECT   
                    E.EncounterID , -- EncounterID - int
                    pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
                    GETDATE() , -- CreatedDate - datetime
                    -50 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    -50 , -- ModifiedUserID - int
                    impPat.balance , -- ServiceChargeAmount - money
                    '1.0000' , -- ServiceUnitCount - decimal
                    NULL , -- ProcedureModifier1 - varchar(16)
                    NULL , -- ProcedureModifier2 - varchar(16)
                    NULL , -- ProcedureModifier3 - varchar(16)
                    NULL , -- ProcedureModifier4 - varchar(16)
                    GETDATE() , -- ProcedureDateOfService - datetime
                    @PracticeID , -- PracticeID - int
                    ED.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
                    NULL , -- EncounterDiagnosisID2 - int
                    NULL , -- EncounterDiagnosisID3 - int
                    NULL , -- EncounterDiagnosisID4 - int
                    GETDATE() , -- ServiceEndDate - datetime
                    impPat.patientname , -- VendorID - varchar(50)
                    @VendorImportID , -- VendorImportID - int
                    NULL , -- ContractID - int
                    NULL , -- Description - varchar(80)
                    NULL , -- EDIServiceNoteReferenceCode - char(3)
                    NULL , -- EDIServiceNote - varchar(80)
                    '1' , -- TypeOfServiceCode - char(1)
                    0 , -- AnesthesiaTime - int
                    NULL , -- ApplyPayment - money
                    NULL , -- PatientResp - money
                    NULL , -- AssessmentDate - datetime
                    NULL , -- RevenueCodeID - int
                    NULL , -- NonCoveredCharges - money
                    NULL , -- DoctorID - int
                    NULL , -- StartTime - datetime
                    NULL , -- EndTime - datetime
                    1 , -- ConcurrentProcedures - int
                    NULL , -- StartTimeText - varchar(4)
                    NULL  -- EndTimeText - varchar(4)
      FROM dbo.[_import_4_1_patientdemographics] impPat
      INNER JOIN dbo.Encounter E ON 
               impPat.patientname = E.VendorID AND 
               CAST(E.Notes AS VARCHAR) = CAST(CONVERT(VARCHAR(10),GETDATE(),101) + ': Creating Balance Forward' AS VARCHAR) AND
               E.VendorImportID = @VendorImportID
      INNER JOIN dbo.ProcedureCodeDictionary pcd ON
               pcd.OfficialName = 'BALANCE FORWARD'
      INNER JOIN dbo.EncounterDiagnosis ED ON    
               impPat.patientname = ED.VendorID AND
               ED.VendorImportID = @VendorImportID
      WHERE CAST(impPat.balance AS VARCHAR) > '$0.00' AND impPat.balance NOT LIKE '($%'
	  PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Updating Phone Numbers on Patient Records...'
UPDATE dbo.Patient
	SET HomePhone = imppat.home ,
		HomePhoneExt = LEFT(imppat.homeextension , 10) ,
		WorkPhone = imppat.work ,
		WorkPhoneExt = LEFT(imppat.workextension , 10) ,
		MobilePhone = imppat.mobile ,
		MobilePhoneExt = LEFT(imppat.mobileextension , 10)
FROM dbo.Patient AS pat
INNER JOIN dbo.[_import_6_1_PhoneUpdate1] AS imppat ON
	imppat.name = pat.VendorID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Updating Phone Numbers from 2nd Sheet on Patient Records...'
UPDATE dbo.Patient
	SET HomePhone = CASE WHEN pat.HomePhone = '' THEN imppat.home ELSE pat.HomePhone END ,
		HomePhoneExt = CASE WHEN pat.HomePhoneExt = '' AND pat.HomePhone = '' THEN LEFT(imppat.homeextension , 10) ELSE pat.HomePhoneExt END ,
		WorkPhone = CASE WHEN pat.WorkPhone = '' THEN imppat.work ELSE pat.WorkPhone END ,
		WorkPhoneExt = CASE WHEN pat.WorkPhoneExt = '' AND pat.WorkPhone = '' THEN LEFT(imppat.workextension , 10) ELSE pat.WorkPhoneExt END ,
		MobilePhone = CASE WHEN pat.MobilePhone = '' THEN imppat.mobile ELSE pat.MobilePhone END ,
		MobilePhoneExt = CASE WHEN pat.MobilePhoneExt = '' AND pat.MobilePhoneExt = '' THEN LEFT(imppat.mobileextension , 10) ELSE pat.MobilePhoneExt END
FROM dbo.Patient AS pat
INNER JOIN dbo.[_import_6_1_PhoneUpdate2] AS imppat ON
	imppat.patientname = pat.VendorID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'



--ROLLBACK
--COMMIT

