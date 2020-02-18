USE superbill_25682_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @VendorImportID = 1
SET @PracticeID = 1


--DELETE FROM dbo.EncounterDiagnosis WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter Diagnosis records deleted'
--DELETE FROM dbo.EncounterProcedure WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter Procedure records deleted'
--DELETE FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter records deleted'
--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
--DELETE from dbo.DiagnosisCodeDictionary where DiagnosisCode = '000.00' 
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Diagnosis Code records deleted'

PRINT ''
PRINT 'Inserting Into Referring Doctor...'
INSERT INTO dbo.Doctor
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
          WorkPhone ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
          @PracticeID ,
		  '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          middlename , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          suffix , -- Suffix - varchar(16)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT([state],2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(zip) IN (4,8) THEN '0' + zip
			   WHEN LEN(zip) IN (3,7) THEN '00' + zip
			   WHEN LEN(zip) IN (5,9) THEN zip ELSE NULL END , -- ZipCode - varchar(9)
          phone , -- WorkPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          degree , -- Degree - varchar(8)
          refmd , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- External - bit
          npi  -- NPI - varchar(10)
FROM dbo.[_import_1_1_ReferringProvider]
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
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
		  planname , -- InsuranceCompanyName - varchar(128)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT(state, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(zip) IN (4,8) THEN '0' + zip 
			   WHEN LEN(zip) IN (3,7) THEN '00' + zip
			   WHEN LEN(zip) IN (5,9) THEN zip ELSE NULL END , -- ZipCode - varchar(9)
          phone , -- Phone - varchar(10)
          13 , -- BillingFormID - int
          insuranceprogramcode , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          inscoid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceList]
WHERE planname <> ''
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
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
          ReferringPhysicianID ,
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
          DOB ,
          SSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          d.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          i.middlename , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.address1 , -- AddressLine1 - varchar(256)
          i.address2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          LEFT(i.[state],2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip) 
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (3,7) THEN '00' + dbo.fn_RemoveNonNumericCharacters(i.zip) 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
			   ELSE NULL END , -- ZipCode - varchar(9)
          i.sex , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          i.homephone , -- HomePhone - varchar(10)
          CASE WHEN i.dob > GETDATE() THEN NULL ELSE i.dob END , -- DOB - datetime
          CASE WHEN LEN(i.ssn) >= 6 THEN RIGHT('000' + i.ssn, 9) ELSE NULL END , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          CASE WHEN i.kareodocid <> '' THEN i.kareodocid ELSE NULL END , -- PrimaryProviderID - int
          patid , -- MedicalRecordNumber - varchar(128)
          cellphone , -- MobilePhone - varchar(10)
          patid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_1_1_PatDemo] i
LEFT JOIN dbo.Doctor d ON 
i.refmd = d.VendorID AND
d.VendorImportID = @VendorImportID
WHERE i.patid <> '' AND i.firstname <> '' AND i.lastname <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



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
          0   -- HomeboundRelatedFlag - bit
FROM dbo.Patient 
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Insurance Policy'
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
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.precedence , -- Precedence - int
          i.[policy] , -- PolicyNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          i.copay , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          icp.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_Policies] i
INNER JOIN dbo.InsuranceCompanyPlan icp ON
icp.VendorID = i.inscoid AND
icp.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase pc ON
pc.VendorID = i.patid AND
pc.VendorImportID = @VendorImportID
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
          CASE WHEN imp.kareolocationid <> '' THEN kareolocationid ELSE NULL END , -- ServiceLocationID - int
          imp.startdateest , -- StartDate - datetime
          imp.enddateest , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          imp.starttmest , -- StartTm - smallint
          imp.endtmest  -- EndTm - smallint
FROM dbo.[_import_1_1_Appointment] imp
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = imp.patientid AND
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
          imp.kareodoctorid , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] AS imp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = imp.patientid AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS app ON
	app.PatientID = pat.PatientID AND
	app.StartDate = imp.startdateest
WHERE app.CreatedDate > DATEADD(mi,-2,GETDATE()) AND imp.kareodoctorid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
      INNER JOIN dbo.[_import_1_1_PatDemo] AS impPat ON
            realpat.VendorID = impPat.patid       
      WHERE impPat.sendbalanceforward = 1 AND impPat.balancefwd <> '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into Diagnosis Code Dictionary...'    
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
               VALUES  ( '000.00' , -- DiagnosisCode - varchar(16)
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
      SELECT        @PracticeID , -- PracticeID - int
                    realpat.PatientiD , -- PatientID - int
                    CASE WHEN impPat.kareodocid <> '' THEN impPat.kareodocid ELSE NULL END , -- DoctorID - int
                    NULL , -- AppointmentID - int
                    1 , -- LocationID - int
                    NULL , -- PatientEmployerID - int
                    GETDATE() , -- DateOfService - datetime
                    GETDATE() , -- DateCreated - datetime
                    CONVERT(VARCHAR(10),GETDATE(),101) + ': Balance Forward Created via Import File' , -- Notes - text
                    2 , -- EncounterStatusID - int            
                    '' , -- AdminNotes - text
                    NULL , -- AmountPaid - money
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0 , -- ModifiedUserID - int
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
                    impPat.patid , -- VendorID - varchar(50)
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
      FROM dbo.[_import_1_1_PatDemo] impPat
      INNER JOIN dbo.Patient realpat ON
               impPat.patid = realpat.VendorID AND
               realpat.VendorImportID = @VendorImportID
      INNER JOIN dbo.PatientCase PC ON
               realpat.PatientID = pc.PatientID AND
               pc.Name = 'Balance Forward' AND
               pc.VendorImportID = @VendorImportID
      WHERE impPat.sendbalanceforward = 1 AND impPat.balancefwd <> '0' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into Encounter Diagnosis...'
      --EncounterDiagnosis
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
      SELECT    E.EncounterID , -- EncounterID - int
                    dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0 , -- ModifiedUserID - int
                    1 , -- ListSequence - int
                    @PracticeID , -- PracticeID - int
                    impPat.patid , -- VendorID - varchar(50)
                    @VendorImportID  -- VendorImportID - int
      FROM dbo.[_import_1_1_PatDemo] impPat
      INNER JOIN dbo.Encounter E ON 
               impPat.patid = E.VendorID AND
               CAST(E.Notes AS VARCHAR) = CAST(CONVERT(VARCHAR(10),GETDATE(),101) + ': Balance Forward Created via Import File' AS VARCHAR) AND
               E.VendorImportID = @VendorImportID
      INNER JOIN dbo.DiagnosisCodeDictionary dcd ON
               dcd.DiagnosisCode = '000.00'
      WHERE impPat.sendbalanceforward = 1 AND impPat.balancefwd <> '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Encounter Procedure...'
      --EncounterProcedure
      INSERT INTO dbo.EncounterProcedure
                  ( EncounterID ,
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
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0 , -- ModifiedUserID - int
                    impPat.balancefwd , -- ServiceChargeAmount - money
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
                    impPat.patid , -- VendorID - varchar(50)
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
      FROM dbo.[_import_1_1_PatDemo] impPat
      INNER JOIN dbo.Encounter E ON 
               impPat.patid = E.VendorID AND 
               CAST(E.Notes AS VARCHAR) = CAST(CONVERT(VARCHAR(10),GETDATE(),101) + ': Balance Forward Created via Import File' AS VARCHAR) AND
               E.VendorImportID = @VendorImportID
      INNER JOIN dbo.ProcedureCodeDictionary pcd ON
               pcd.OfficialName = 'BALANCE FORWARD'
      INNER JOIN dbo.EncounterDiagnosis ED ON    
               impPat.patid = ED.VendorID AND
               ED.VendorImportID = @VendorImportID
      WHERE impPat.sendbalanceforward = 1 AND impPat.balancefwd <> '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Patient Cases to Self Pay Not Linked to Policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 ,
		  Name = 'Self Pay' 
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--COMMIT
--ROLLBACK

