USE superbill_29086_dev
-- USE superbill_29086_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 1
SET @PracticeID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))



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
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone 
        )
SELECT DISTINCT
	      @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          middleinitial , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          street1 , -- AddressLine1 - varchar(256)
          street2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(zipcode) IN (4,8) THEN '0' + zipcode WHEN LEN(zipcode) IN (5,9) THEN zipcode ELSE '' END , -- ZipCode - varchar(9)
          CASE WHEN Sex <> '' THEN Sex ELSE 'U' END , -- Gender - varchar(1)
          Home , -- HomePhone - varchar(10)
          WorkPhone , -- WorkPhone - varchar(10)
          WorkExtension , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(dateofbirth) = 1 THEN dateofbirth ELSE NULL END , -- DOB - datetime
          CASE WHEN LEN(socsecnum)>= 6 THEN RIGHT('000' + socsecnum, 9) ELSE '' END  , -- SSN - char(9)
		  EMail , -- EmailAddress - varchar
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN employmentstatus = '' THEN 'U' ELSE employmentstatus END , -- EmploymentStatus - char(1)
          1 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          chartnumber , -- MedicalRecordNumber - varchar(128)
          Mobile , -- MobilePhone - varchar(10)
          chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          inactive , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
          contactname , -- EmergencyName - varchar(128)
          dbo.fn_RemoveNonNumericCharacters(contactphone1)  -- EmergencyPhone - varchar(10)
FROM dbo.[_import_0_1_import1patdemo] WHERE firstname <> '' AND lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Patient Case...'
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
          'Self Pay' , -- Name - varchar(128)
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
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Misc into Diagnosis Code Dictionary...' 
  IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE OfficialName = 'Miscellaneous')   
               INSERT INTO dbo.DiagnosisCodeDictionary
                        ( DiagnosisCode ,
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
               VALUES  (     '000.00' , -- DiagnosisCode - varchar(16)
                              GETDATE() , -- CreatedDate - datetime
                              0 , -- CreatedUserID - int
                              GETDATE() , -- ModifiedDate - datetime
                              0 , -- ModifiedUserID - int
                              NULL , -- KareoDiagnosisCodeDictionaryID - int
                              1 , -- Active - bit
                              'Miscellaneous' , -- OfficialName - varchar(300)
                              'Miscellaneous' , -- LocalName - varchar(100)
                              NULL  -- OfficialDescription - varchar(500)
                              )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into Patient Case for Balance Forward...'
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
                    p.PatientID , -- PatientID - int
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
                    p.VendorID , -- VendorID - varchar(50)
                    @VendorImportID , -- VendorImportID - int
                    0 , -- PregnancyRelatedFlag - bit
                    1 , -- StatementActive - bit
                    0 , -- EPSDT - bit
                    0 , -- FamilyPlanning - bit
                    1 , -- EPSDTCodeID - int
                    0 , -- EmergencyRelated - bit
                    0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient p
INNER JOIN dbo.[_import_0_1_import1patdemo] AS i ON
    p.VendorID = i.chartnumber       
WHERE p.VendorImportID = @VendorImportID AND i.patientreferencebalance <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Encounter...'
INSERT INTO dbo.Encounter
        ( PracticeID ,
          PatientID ,
          DoctorID ,
          LocationID ,
          DateOfService ,
          DateCreated ,
          Notes ,
          EncounterStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReleaseSignatureSourceCode ,
          PlaceOfServiceCode ,
          PatientCaseID ,
          PostingDate ,
          DateOfServiceTo ,
          PaymentMethod ,
          AddOns ,
          DoNotSendElectronic ,
          SubmittedDate ,
          PaymentTypeID ,
          VendorID ,
          VendorImportID ,
          DoNotSendElectronicSecondary ,
          overrideClosingDate ,
          ClaimTypeID ,
          SecondaryClaimTypeID ,
          SubmitReasonIDCMS1500 ,
          SubmitReasonIDUB04 ,
          PatientCheckedIn 
        )
SELECT DISTINCT	
		  @PracticeID , -- PracticeID - int
          p.PatientID , -- PatientID - int
          1 , -- DoctorID - int
          1 , -- LocationID - int
          GETDATE() , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          Convert(Varchar(10), GETDATE(),101) + ': Creating Balance Forward' , -- Notes - text
          2 , -- EncounterStatusID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
          pc.PatientCaseID , -- PatientCaseID - int
          GETDATE() , -- PostingDate - datetime
          GETDATE() , -- DateOfServiceTo - datetime
          'U' , -- PaymentMethod - char(1)
          0 , -- AddOns - bigint
          0 , -- DoNotSendElectronic - bit
          GETDATE() , -- SubmittedDate - datetime
          0 , -- PaymentTypeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- DoNotSendElectronicSecondary - bit
          0 , -- overrideClosingDate - bit
          0 , -- ClaimTypeID - int
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
          0  -- PatientCheckedIn - bit
FROM dbo.[_import_0_1_import1patdemo] i
      INNER JOIN dbo.Patient p ON
               i.chartnumber = p.VendorID AND
               p.VendorImportID = @VendorImportID
      INNER JOIN dbo.PatientCase pc ON
               p.VendorID = pc.VendorID AND
               pc.Name = 'Balance Forward' AND
               pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Encounter Diagnosis...'
INSERT INTO dbo.EncounterDiagnosis
        ( EncounterID ,
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
SELECT DISTINCT
		  e.EncounterID , -- EncounterID - int
          dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- ListSequence - int
          @PracticeID , -- PracticeID - int
          e.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_0_1_import1patdemo] i
INNER JOIN dbo.Encounter E ON 
    i.chartnumber = E.VendorID AND
    CAST(E.Notes AS VARCHAR) = CAST(CONVERT(VARCHAR(10),GETDATE(),101) + ': Creating Balance Forward' AS VARCHAR) AND
    E.VendorImportID = @VendorImportID
INNER JOIN dbo.DiagnosisCodeDictionary dcd ON
    dcd.DiagnosisCode = '000.00'
WHERE i.patientreferencebalance <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Encounter Procedure...'
INSERT INTO dbo.EncounterProcedure
        ( EncounterID ,
          ProcedureCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ServiceChargeAmount ,
          ServiceUnitCount ,
          ProcedureDateOfService ,
          PracticeID ,
          EncounterDiagnosisID1 ,
          VendorID ,
          VendorImportID ,
          TypeOfServiceCode ,
          AnesthesiaTime ,
          ConcurrentProcedures 
        )
SELECT DISTINCT
		  e.EncounterID , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          i.patientreferencebalance , -- ServiceChargeAmount - money
          '1.000' , -- ServiceUnitCount - decimal
          GETDATE() , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          ed.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
          i.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          '1' , -- TypeOfServiceCode - char(1)
          0 , -- AnesthesiaTime - int
          1  -- ConcurrentProcedures - int
FROM dbo.[_import_0_1_import1patdemo] i
	INNER JOIN dbo.Encounter e ON 
		i.chartnumber = e.VendorID AND
		CAST(E.Notes AS VARCHAR) = CAST(CONVERT(VARCHAR(10),GETDATE(),101) + ': Creating Balance Forward' AS VARCHAR) AND
		e.VendorImportID = @VendorImportID
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON 
		pcd.OfficialName = 'BALANCE FORWARD'
	INNER JOIN dbo.EncounterDiagnosis ed ON
		i.chartnumber = ed.VendorID AND
		ed.VendorImportID = @VendorImportID
WHERE i.patientreferencebalance <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Patient Alert where Balance Forward Case Exists...'
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
		  p.PatientID , -- PatientID - int
          'Balance Forward Encounter Attached' , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          1 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          1 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.Patient p
	INNER JOIN dbo.[_import_0_1_import1patdemo] i ON
		p.VendorID = i.chartnumber AND
		p.VendorImportID = @VendorImportID
WHERE i.patientreferencebalance <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




--COMMIT
--ROLLBACK


