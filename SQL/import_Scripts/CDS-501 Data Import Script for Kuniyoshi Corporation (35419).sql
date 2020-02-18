USE superbill_35419_dev
--USE superbill_XXX_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 3


PRINT ''
PRINT 'Inserting into PatientCase- Balance Forward'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
     --   ReferringPhysicianID ,
     --   EmploymentRelatedFlag ,
     --   AutoAccidentRelatedFlag ,
     --   OtherAccidentRelatedFlag ,
     --   AbuseRelatedFlag ,
     --   AutoAccidentRelatedState ,
          Notes ,
     --   ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
     --   CaseNumber ,
     --   WorkersCompContactInfoID ,
          VendorID ,
          VendorImportID 
     --   PregnancyRelatedFlag ,
     --   StatementActive ,
     --   EPSDT ,
     --   FamilyPlanning ,
     --   EPSDTCodeID ,
     --   EmergencyRelated ,
     --   HomeboundRelatedFlag
        )
SELECT DISTINCT
          pat.PatientID , -- PatientID - int
          'Balance Forward' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
      --  0 , -- ReferringPhysicianID - int
      --  NULL , -- EmploymentRelatedFlag - bit
      --  NULL , -- AutoAccidentRelatedFlag - bit
      --  NULL , -- OtherAccidentRelatedFlag - bit
      --  NULL , -- AbuseRelatedFlag - bit
      --  '' , -- AutoAccidentRelatedState - char(2)
          'Created via data import, please review' , -- Notes - text
      --  NULL , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
      --  '' , -- CaseNumber - varchar(128)
      --  0 , -- WorkersCompContactInfoID - int
          ip.firstname + ip.lastname + ip.birthdate , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  NULL , -- PregnancyRelatedFlag - bit
      --  NULL , -- StatementActive - bit
      --  NULL , -- EPSDT - bit
      --  NULL , -- FamilyPlanning - bit
      --  0 , -- EPSDTCodeID - int
      --  NULL , -- EmergencyRelated - bit
      --  NULL  -- HomeboundRelatedFlag - bit
FROM dbo.patient as pat 
INNER JOIN dbo.[_import_1_1_Sheet1] AS ip ON
pat.FirstName = ip.firstname AND
pat.LastName = ip.lastname AND
pat.DOB = DATEADD(hh,12,CAST(ip.birthdate AS DATETIME))
AND pat.vendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase- Balance Forward'

IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE DiagnosisCode='000.00')
BEGIN
PRINT ''
PRINT 'Inserting into DiagnosisCodeDictionary' 
INSERT INTO dbo.DiagnosisCodeDictionary 
        ( 
		  DiagnosisCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      /*  RecordTimeStamp ,
          KareoDiagnosisCodeDictionaryID ,
          KareoLastModifiedDate ,   */
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
      --  NULL , -- RecordTimeStamp - timestamp
      /*  NULL , -- KareoDiagnosisCodeDictionaryID - int
          GETDATE() , -- KareoLastModifiedDate - datetime   */
          1 , -- Active - bit
         'Miscellaneous' ,  -- OfficialName - varchar(300)
         'Miscellaneous' ,  -- LocalName - varchar(100)
          NULL  -- OfficialDescription - varchar(500) 
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into DiagnosisCodeDictionary ' 
END

PRINT ''
PRINT 'Inserting into Encounter '
INSERT INTO dbo.Encounter
        ( PracticeID ,
          PatientID ,
          DoctorID ,
      --  AppointmentID ,
          LocationID ,
      --  PatientEmployerID ,
          DateOfService ,
          DateCreated ,
          Notes ,
          EncounterStatusID ,
      --  AdminNotes ,
      --  AmountPaid ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      --  MedicareAssignmentCode ,
      --  ReleaseOfInformationCode ,
          ReleaseSignatureSourceCode ,
          PlaceOfServiceCode ,
      --  ConditionNotes ,
          PatientCaseID ,
      --  InsurancePolicyAuthorizationID ,
          PostingDate ,
          DateOfServiceTo ,
      --  SupervisingProviderID ,
      --  ReferringPhysicianID ,
          PaymentMethod ,
      --  Reference ,
          AddOns ,
      --  HospitalizationStartDT ,
      --  HospitalizationEndDT ,
      --  Box19 ,
          DoNotSendElectronic ,
          SubmittedDate ,
          PaymentTypeID ,
      --  PaymentDescription ,
      --  EDIClaimNoteReferenceCode ,
      --  EDIClaimNote ,
          VendorID ,
          VendorImportID ,
      --  AppointmentStartDate ,
      --  BatchID ,
      --  SchedulingProviderID ,
          DoNotSendElectronicSecondary ,
      --  PaymentCategoryID ,
          overrideClosingDate ,
      --  Box10d ,
          ClaimTypeID ,
      /*  OperatingProviderID ,
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
          PTAProviderID ,                 */
          SecondaryClaimTypeID ,
          SubmitReasonIDCMS1500 ,
          SubmitReasonIDUB04 ,
      /*  DocumentControlNumberCMS1500 ,
          DocumentControlNumberUB04 ,
          EDIClaimNoteReferenceCodeCMS1500 ,
          EDIClaimNoteReferenceCodeUB04 ,
          EDIClaimNoteCMS1500 ,
          EDIClaimNoteUB04 ,
          EncounterGuid ,        */
          PatientCheckedIn 
     --   RoomNumber
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          patcase.PatientID , -- PatientID - int
          1 , -- DoctorID - int
      --  '' , -- AppointmentID - int
          1 , -- LocationID - int
      --  '' , -- PatientEmployerID - int
          GETDATE() , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          Convert(Varchar(10), GETDATE(),101) + ': Balance Forward' , -- Notes - text
          2 , -- EncounterStatusID - int
     --   '' , -- AdminNotes - text
     --   '' , -- AmountPaid - money
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- MedicareAssignmentCode - char(1)
      --  '' , -- ReleaseOfInformationCode - char(1)
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
      --  '' , -- ConditionNotes - text
          patcase.PatientCaseID , -- PatientCaseID - int
      --  0 , -- InsurancePolicyAuthorizationID - int         
          GETDATE() , -- PostingDate - datetime
          GETDATE() , -- DateOfServiceTo - datetime
      --  0 , -- SupervisingProviderID - int
      --  '' , -- ReferringPhysicianID - int
          'U' , -- PaymentMethod - char(1)
     --   '' , -- Reference - varchar(40)
          0 , -- AddOns - bigint
      --  GETDATE() , -- HospitalizationStartDT - datetime
      --  GETDATE() , -- HospitalizationEndDT - datetime
      --  '' , -- Box19 - varchar(51)
          0 , -- DoNotSendElectronic - bit
          GETDATE() , -- SubmittedDate - datetime
          0 , -- PaymentTypeID - int
      --  '' , -- PaymentDescription - varchar(250)
     --   '' , -- EDIClaimNoteReferenceCode - char(3)
     --   '' , -- EDIClaimNote - varchar(1600)
          patcase.VendorID , -- VendorID - varchar(50)                
          @VendorImportID , -- VendorImportID - int
      --  app.startdate , -- AppointmentStartDate - datetime
      --  '' , -- BatchID - varchar(50)
      --  0 , -- SchedulingProviderID - int
          0 , -- DoNotSendElectronicSecondary - bit
      --  0 , -- PaymentCategoryID - int
          0 , -- overrideClosingDate - bit
      --  '' , -- Box10d - varchar(40)
          0 , -- ClaimTypeID - int
     /*   0 , -- OperatingProviderID - int
     --   0 , -- OtherProviderID - int
     --   0 , -- PrincipalDiagnosisCodeDictionaryID - int
     --   0 , -- AdmittingDiagnosisCodeDictionaryID - int
     --   0 , -- PrincipalProcedureCodeDictionaryID - int
     --   0 , -- DRGCodeID - int
     --   GETDATE() , -- ProcedureDate - datetime
     --   0 , -- AdmissionTypeID - int
     --   GETDATE() , -- AdmissionDate - datetime
          0 , -- PointOfOriginCodeID - int
          '' , -- AdmissionHour - varchar(2)
          '' , -- DischargeHour - varchar(2)
          0 , -- DischargeStatusCodeID - int
          '' , -- Remarks - varchar(255)
          0 , -- SubmitReasonID - int
          '' , -- DocumentControlNumber - varchar(26)
          0 , -- PTAProviderID - int                    */
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
      /*    '' , -- DocumentControlNumberCMS1500 - varchar(26)
          '' , -- DocumentControlNumberUB04 - varchar(26)
          '' , -- EDIClaimNoteReferenceCodeCMS1500 - char(3)
          '' , -- EDIClaimNoteReferenceCodeUB04 - char(3)
          '' , -- EDIClaimNoteCMS1500 - varchar(1600)
          '' , -- EDIClaimNoteUB04 - varchar(1600)
          NULL , -- EncounterGuid - uniqueidentifier      */
          0  -- PatientCheckedIn - bit
     --   ''  -- RoomNumber - varchar(32)
FROM dbo.PatientCase AS patcase
WHERE patcase.Name = 'Balance Forward' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Encounter' 

PRINT ''
PRINT 'Inserting into EncounterDiagnosis '
INSERT INTO dbo.EncounterDiagnosis
        ( 
		  EncounterID ,
          DiagnosisCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          ListSequence ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
          enc.EncounterID , -- EncounterID - int
          dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          1 , -- ListSequence - int
          @PracticeID  , -- PracticeID - int
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Encounter as enc 
INNER JOIN dbo.DiagnosisCodeDictionary AS dcd ON
    dcd.DiagnosisCode = '000.00' AND 
    enc.PracticeID = @PracticeID        
WHERE enc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into EncounterDiagnosis' 

PRINT ''
PRINT 'Inserting into EncounterProcedure '
INSERT INTO dbo.EncounterProcedure
        ( 
		  EncounterID ,
          ProcedureCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
          ServiceChargeAmount ,   
          ServiceUnitCount ,
     /*   ProcedureModifier1 ,
          ProcedureModifier2 ,
          ProcedureModifier3 ,
          ProcedureModifier4 ,   */
          ProcedureDateOfService ,
          PracticeID ,
          EncounterDiagnosisID1 ,
     /*   EncounterDiagnosisID2 ,
          EncounterDiagnosisID3 ,
          EncounterDiagnosisID4 ,   */
          ServiceEndDate ,
          VendorID ,
          VendorImportID ,
     /*   ContractID ,
          Description ,
          EDIServiceNoteReferenceCode ,
          EDIServiceNote ,   */
          TypeOfServiceCode ,
          AnesthesiaTime ,
     /*   ApplyPayment ,
          PatientResp ,    */
          AssessmentDate ,
     /*   RevenueCodeID ,
          NonCoveredCharges ,     */
          DoctorID ,
     /*   StartTime ,
          EndTime ,  */
          ConcurrentProcedures 
     /*   StartTimeText ,
          EndTimeText    */
        )
SELECT DISTINCT
          enc.EncounterID  , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          ip.currentbalance , -- ServiceChargeAmount - money   
          '1.000' , -- ServiceUnitCount - decimal
     /*   '' , -- ProcedureModifier1 - varchar(16)
          '' , -- ProcedureModifier2 - varchar(16)
          '' , -- ProcedureModifier3 - varchar(16)
          '' , -- ProcedureModifier4 - varchar(16)   */
          GETDATE() , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          ed.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
     /*   0 , -- EncounterDiagnosisID2 - int
          0 , -- EncounterDiagnosisID3 - int
          0 , -- EncounterDiagnosisID4 - int    */
          GETDATE() , -- ServiceEndDate - datetime
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
     /*   0 , -- ContractID - int
          '' , -- Description - varchar(80)
          '' , -- EDIServiceNoteReferenceCode - char(3)
          '' , -- EDIServiceNote - varchar(80)     */
          '1' , -- TypeOfServiceCode - char(1)
          0 , -- AnesthesiaTime - int
     /*   NULL , -- ApplyPayment - money
          NULL , -- PatientResp - money    */
          GETDATE() , -- AssessmentDate - datetime
     /*   0 , -- RevenueCodeID - int
          NULL , -- NonCoveredCharges - money    */
          enc.DoctorID , -- DoctorID - int
     /*   ''  , -- StartTime - datetime
          '' , -- EndTime - datetime   */
          1  -- ConcurrentProcedures - int
     /*   '' , -- StartTimeText - varchar(4)
          ''  -- EndTimeText - varchar(4)   */
FROM dbo.Encounter AS enc
INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
   pcd.OfficialName = 'Balance Forward' AND 
   enc.PracticeID = @PracticeID
INNER JOIN dbo.EncounterDiagnosis AS ed ON
   ed.vendorID = enc.VendorID AND 
   enc.VendorImportID = @VendorImportID   
INNER JOIN [dbo].[_import_1_1_Sheet1] as ip ON 
   enc.vendorID = ip.firstname + ip.lastname + ip.birthdate AND
   enc.VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into EncounterProcedure'


--ROLLBACK
--COMMIT


