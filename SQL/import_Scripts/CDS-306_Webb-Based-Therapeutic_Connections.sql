USE superbill_27002_dev
--USE superbill_27002_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 39
SET @PracticeID = 38


/*
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
DELETE FROM dbo.EncounterDiagnosis WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter Diagnosis records deleted'
DELETE FROM dbo.EncounterProcedure WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter Procedure records deleted'
DELETE FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
*/


-- Insurance (only if table exists)
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_39_38_Insurances]') AND type in (N'U'))
BEGIN

PRINT ''
PRINT 'Inserting into Insurance Company...'
      --Insurance Company
      INSERT INTO dbo.InsuranceCompany
                  ( InsuranceCompanyName ,
                    Notes ,
                    AddressLine1 ,
                    AddressLine2 ,
                    City ,
                    State ,
                    Country ,
                    ZipCode ,
                    Phone ,
                    PhoneExt ,
                    Fax ,
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
              LEFT([name] , 128) , -- InsuranceCompanyName - varchar(128)
                    [note] , -- Notes - text
                    [street1] , -- AddressLine1 - varchar(256)
                    [street2] , -- AddressLine2 - varchar(256)
                    [city] , -- City - varchar(128)
                    LEFT([state] , 2) , -- State - varchar(2)
                    '' , -- Country - varchar(32)
                    CASE      WHEN LEN(dbo.fn_RemoveNonNumericCharacters([zipcode])) IN (5,9) THEN (dbo.fn_RemoveNonNumericCharacters([zipcode]))
                              WHEN LEN(dbo.fn_RemoveNonNumericCharacters([zipcode])) IN (4,8) THEN '0' + (dbo.fn_RemoveNonNumericCharacters([zipcode]))
                              ELSE '' END , -- ZipCode - varchar(9)
                    LEFT(dbo.fn_RemoveNonNumericCharacters([phone]) , 10) , -- Phone - varchar(10)
                    LEFT(dbo.fn_RemoveNonNumericCharacters([extension]) , 10) , -- PhoneExt - varchar(10)
                    LEFT(dbo.fn_RemoveNonNumericCharacters([fax]) , 10) , -- Fax - varchar(10)
                    0 , -- BillSecondaryInsurance - bit
                    CASE [defaultbillingmethod] WHEN 'Electronic' THEN 1 ELSE 0 END , -- EClaimsAccepts - bit
                    13 , -- BillingFormID - int
                    CASE [type]     WHEN 'Blue Cross/Shield' THEN 'BL'
                                          WHEN 'Medicare' THEN 'MB'
                                          WHEN 'Medicaid' THEN 'MC'
                                          WHEN 'Worker''s Comp' THEN 'WC'
                                          WHEN 'Champus' THEN 'CH'
                                          ELSE 'CI' END , -- InsuranceProgramCode - char(2)
                    'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
                    'D' , -- HCFASameAsInsuredFormatCode - char(1)
                    @PracticeID , -- CreatedPracticeID - int
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0 , -- ModifiedUserID - int
                    13 , -- SecondaryPrecedenceBillingFormID - int
                    [code] , -- VendorID - varchar(50)
                    @VendorImportID , -- VendorImportID - int
                    1 , -- NDCFormat - int
                    1 , -- UseFacilityID - bit
                    'U' , -- AnesthesiaType - varchar(1)
                    18  -- InstitutionalBillingFormID - int
      FROM dbo._import_39_38_Insurances
      WHERE RTRIM(LTRIM([Name])) <> '' AND
         [code] NOT IN (SELECT VendorID FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID AND CreatedPracticeID = @PracticeID)  
  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Insurance Company Plan...'
      --Insurance Company Plan
      INSERT INTO dbo.InsuranceCompanyPlan
                  ( PlanName ,
                    AddressLine1 ,
                    AddressLine2 ,
                    City ,
                    State ,
                    ZipCode ,
                    Phone ,
                    PhoneExt ,
                    Notes ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID ,
                    CreatedPracticeID ,
                    Fax ,
                    InsuranceCompanyID ,
                    VendorID ,
                    VendorImportID 
                  )
      SELECT DISTINCT
                    LEFT(impIns.[name] , 128) , -- PlanName - varchar(128)
                    impIns.[street1] , -- AddressLine1 - varchar(256)
                    impIns.[street2] , -- AddressLine2 - varchar(256)
                    impIns.[city] , -- City - varchar(128)
                    LEFT(impIns.[state] , 2) , -- State - varchar(2)
                    CASE      WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impIns.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(impIns.[zipcode])
                              WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impIns.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(impIns.[zipcode])
                              ELSE '' END , -- ZipCode - varchar(9)
                    LEFT(dbo.fn_RemoveNonNumericCharacters(impIns.[phone]) , 10) , -- Phone - varchar(10)
                    LEFT(dbo.fn_RemoveNonNumericCharacters(impIns.[extension]) , 10) , -- PhoneExt - varchar(10)
                    impIns.[note] , -- Notes - text
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0 , -- ModifiedUserID - int
                    @PracticeID , -- CreatedPracticeID - int
                    LEFT(dbo.fn_RemoveNonNumericCharacters(impIns.[fax]) , 10) , -- Fax - varchar(10)
                    ic.[InsuranceCompanyID] , -- InsuranceCompanyID - int
                    impIns.[code] , -- VendorID - varchar(50)
                    @VendorImportID  -- VendorImportID - int
      FROM dbo._import_39_38_Insurances AS impIns
      INNER JOIN dbo.InsuranceCompany AS ic ON
            ic.[VendorID] = impIns.[code] AND
            ic.[VendorImportID] = @VendorImportID AND
            ic.[CreatedPracticeID] = @PracticeID  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
END

-- Referring Doctor (only if table exists)
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_39_38_ReferringPhys]') AND type in (N'U'))
BEGIN

PRINT ''
PRINT 'Inserting into Referring Doctor...'
      --Referring Doctor
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
                    ZipCode ,
                    HomePhone ,
                    WorkPhone ,
                    MobilePhone ,
                    EmailAddress ,
                    Notes ,
                    ActiveDoctor ,
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
                    '' , -- Prefix - varchar(16)
                    impRph.[firstname] , -- FirstName - varchar(64)
                    impRph.[middleinitial] , -- MiddleName - varchar(64)
                    impRph.[lastname] , -- LastName - varchar(64)
                    '' , -- Suffix - varchar(16)
                    impRph.[street1] , -- AddressLine1 - varchar(256)
                    impRph.[street2] , -- AddressLine2 - varchar(256)
                    impRph.[city] , -- City - varchar(128)
                    LEFT(impRph.[state] , 2) , -- State - varchar(2)
                    CASE      WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impRph.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(impRph.[zipcode])
                              WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impRph.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(impRph.[zipcode])
                              ELSE '' END , -- ZipCode - varchar(9)
                    LEFT(dbo.fn_RemoveNonNumericCharacters(impRph.[phone]) , 10) , -- HomePhone - varchar(10)
                    LEFT(dbo.fn_RemoveNonNumericCharacters(impRph.[office]) , 10) , -- WorkPhone - varchar(10)
                    LEFT(dbo.fn_RemoveNonNumericCharacters(impRph.[cell]) , 10) , -- MobilePhone - varchar(10)
                    impRph.[email] , -- EmailAddress - varchar(256)
                    CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' +
                    CASE impRph.[licensenumber] WHEN '' THEN ''
                                                                  ELSE CHAR(13)+CHAR(10) + 'License Number: ' + impRph.[licensenumber] END +
                    CASE impRph.[medicarepin]   WHEN '' THEN ''
                                                            ELSE CHAR(13)+CHAR(10) + 'Medicare PIN: ' + impRph.[medicarepin] END +
                    CASE impRph.[medicaidpin] WHEN '' THEN ''
                                                            ELSE CHAR(13)+CHAR(10) + 'Medicaid PIN: ' + impRph.[medicaidpin] END +
                    CASE impRph.[champuspin]    WHEN '' THEN ''
                                                            ELSE CHAR(13)+CHAR(10) + 'Champus PIN: ' + impRph.[champuspin] END +
                    CASE impRph.[bluecrossshieldpin]  WHEN '' THEN ''
                                                                        ELSE CHAR(13)+CHAR(10) + 'Blue Cross / Shield PIN: ' + impRph.[bluecrossshieldpin] END +
                    CASE impRph.[commercialpin] WHEN '' THEN ''
                                                                  ELSE CHAR(13)+CHAR(10) + 'Commercial PIN: ' + impRph.[commercialpin] END +
                    CASE impRph.[grouppin]      WHEN '' THEN ''
                                                            ELSE CHAR(13)+CHAR(10) + 'Group PIN: ' + impRph.[grouppin] END +
                    CASE impRph.[hmopin]  WHEN '' THEN ''
                                                      ELSE CHAR(13)+CHAR(10) + 'HMO PIN: ' + impRph.[hmopin] END +
                    CASE impRph.[ppopin]  WHEN '' THEN ''
                                                      ELSE CHAR(13)+CHAR(10) + 'PPO PIN: ' + impRph.[ppopin] END +
                    CASE impRph.[medicaregroupid]     WHEN '' THEN ''
                                                                  ELSE CHAR(13)+CHAR(10) + 'Medicare Group ID: ' + impRph.[medicaregroupid] END +
                    CASE impRph.[medicaidgroupid] WHEN '' THEN ''
                                                                  ELSE CHAR(13)+CHAR(10) + 'Medicaid Group ID: ' + impRph.[medicaidgroupid] END +
                    CASE impRph.[bcbsgroupid] WHEN '' THEN ''
                                                            ELSE CHAR(13)+CHAR(10) + 'BC/BS Group ID: ' + impRph.[bcbsgroupid] END + 
                    CASE impRph.[othergroupid]  WHEN '' THEN ''
                                                                  ELSE CHAR(13)+CHAR(10) + 'Other Group ID: ' + impRph.[othergroupid] END +
                    CASE impRph.[upin]    WHEN '' THEN ''
                                                      ELSE CHAR(13)+CHAR(10) + 'UPIN: ' + impRph.[upin] END , -- Notes - text
                    CASE impRph.[inactive] WHEN '1' THEN 0 ELSE 1 END , -- ActiveDoctor - bit
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0 , -- ModifiedUserID - int
                    LEFT(impRph.[credentials] , 8) , -- Degree - varchar(8)
                    impRph.[code] , -- VendorID - varchar(50)
                    @VendorImportID , -- VendorImportID - int
                    LEFT(dbo.fn_RemoveNonNumericCharacters(impRph.[fax]) , 10) , -- FaxNumber - varchar(10)
                    1  -- External - bit
      FROM dbo._import_39_38_ReferringPhys AS impRph
      WHERE impRph.[firstname] <> '' AND impRph.[lastname] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
END 

-- Patients (only if table exists)
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_39_38_PatientData]') AND type in (N'U'))
BEGIN

PRINT ''
PRINT 'Inserting into Patient...'
      --Patient
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
                    HomePhone ,
                    WorkPhone ,
                    DOB ,
                    SSN ,
                    EmailAddress ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID ,
                    EmploymentStatus ,
                    PrimaryProviderID ,
                    MedicalRecordNumber ,
                    MobilePhone ,
                    PrimaryCarePhysicianID ,
                    VendorID ,
                    VendorImportID ,
                    Active ,
                    SendEmailCorrespondence ,
                    EmergencyName ,
                    EmergencyPhone ,
                    EmergencyPhoneExt 
                  )
      SELECT DISTINCT
                    @PracticeID , -- PracticeID - int
                    '' , -- Prefix - varchar(16)
                    impPat.[firstname] , -- FirstName - varchar(64)
                    impPat.[middleinitial] , -- MiddleName - varchar(64)
                    impPat.[lastname] , -- LastName - varchar(64)
                    impPat.[suffix] , -- Suffix - varchar(16)
                    impPat.[street1] , -- AddressLine1 - varchar(256)
                    impPat.[street2] , -- AddressLine2 - varchar(256)
                    impPat.[city] , -- City - varchar(128)
                    LEFT(impPat.[state] , 2) , -- State - varchar(2)
                    CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impPat.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(impPat.[zipcode])
                         WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impPat.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(impPat.[zipcode])
                         ELSE '' END , -- ZipCode - varchar(9)
                    CASE impPat.[sex] WHEN 'Male' THEN 'M'
                                      WHEN 'Female' THEN 'F'
                                      ELSE 'U' END , -- Gender - varchar(1)
                    LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[phone1]) , 10) , -- HomePhone - varchar(10)
                    LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[phone2]) , 10) , -- WorkPhone - varchar(10)
                    CASE WHEN ISDATE(impPat.[dateofbirth]) = 1 THEN impPat.dateofbirth
                         ELSE NULL END , -- DOB - datetime
                    CASE impPat.[socialsecuritynumber] WHEN '' THEN ''
                         ELSE RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(impPat.[socialsecuritynumber]) , 9) END , -- SSN - char(9)
                    impPat.email , -- EmailAddress - varchar(256)
                   
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0 , -- ModifiedUserID - int
                    CASE impPat.[employmentstatus] WHEN 'Full time' THEN 'S'
                                                   WHEN 'Part time' THEN 'T'
                                                   WHEN 'Retired' THEN 'R'
                                                   ELSE 'U' END , -- EmploymentStatus - char(1)
                    doc.[DoctorID] , -- PrimaryProviderID - int
                    impPat.[chartnumber] , -- MedicalRecordNumber - varchar(128)
                    LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[phone3]) , 10) , -- MobilePhone - varchar(10)
                    doc.[DoctorID] , -- PrimaryCarePhysicianID - int
                    impPat.[chartnumber] , -- VendorID - varchar(50)
                    @VendorImportID , -- VendorImportID - int
                    CASE impPat.[Inactive] WHEN 1 THEN 0 ELSE 1 END , -- Active - bit
                    CASE impPat.[email] WHEN '' THEN 0 ELSE 1 END , -- SendEmailCorrespondence - bit
                    impPat.[contactname] , -- EmergencyName - varchar(128)
                    CASE LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[contactphone1]) , 10) WHEN '' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[contactphone2]) , 10)
                           ELSE LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[contactphone1]) , 10) END , -- EmergencyPhone - varchar(10)
                    CASE LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[contactphone1]) , 10) WHEN '' THEN ''
                           ELSE LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[contactphone2]) , 10) END  -- EmergencyPhoneExt - varchar(10)
      FROM dbo._import_39_38_PatientData AS impPat
      LEFT OUTER JOIN dbo._import_39_38_Providers AS impPro ON
            impPro.[code] = impPat.[assignedprovider]
      LEFT OUTER JOIN dbo.Doctor AS doc ON
            doc.[FirstName] = impPro.[firstname] AND
            doc.[LastName] = impPro.[lastname] AND
            doc.[External] = 0 AND
            doc.[PracticeID] = @PracticeID
WHERE impPat.[firstname] <> '' AND impPat.[lastname] <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
END 

-- Patient Cases, Case Dates and Policies (onlyl if table exists)
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_39_38_CaseInformation]') AND type in (N'U'))
BEGIN

PRINT ''
PRINT 'Inserting into Patient Case...'
      --Patient Case (Depends on patient records already being imported, can only run after)
      INSERT INTO dbo.PatientCase
                  ( PatientID ,
                    Name ,
                    Active ,
                    PayerScenarioID ,
                    ReferringPhysicianID ,
                    EmploymentRelatedFlag ,
                    AutoAccidentRelatedFlag ,
                    OtherAccidentRelatedFlag ,
                    AbuseRelatedFlag ,
                    AutoAccidentRelatedState ,
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
					realP.[PatientID] , -- PatientID - int
                    CASE WHEN impCas.[description] IS NULL THEN 'Default Case' ELSE impCas.[description] END , -- Name - varchar(128)
                    1 , -- Active - bit
                    5 , -- Commercial
                    realdoc.[DoctorID] , -- ReferringPhysicianID - int
                    CASE WHEN impCas.[relatedtoemployment] = 1 AND impCas.[natureofaccident] LIKE 'Work Injury%' THEN 1
                           ELSE 0 END , -- EmploymentRelatedFlag - bit
                    CASE WHEN impCas.[relatedtoaccident] = 'Auto' AND impCas.[accidentstate] <> '' THEN 1
                           ELSE 0 END , -- AutoAccidentRelatedFlag - bit
                    CASE WHEN impCas.[relatedtoaccident] = 'Yes' AND impCas.[relatedtoemployment] <> 1 THEN 1
                           ELSE 0 END , -- OtherAccidentRelatedFlag - bit
                    0 , -- AbuseRelatedFlag - bit
                    CASE WHEN impCas.[relatedtoaccident] = 'Auto' AND impCas.[accidentstate] <> '' THEN LEFT(impCas.[accidentstate] , 2)
                           ELSE '' END , -- AutoAccidentRelatedState - char(2)
                    CASE WHEN impCas.comment <> '' THEN 'Comment: ' + impCas.comment + CHAR(13)+CHAR(10) END +
					CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' +
                    CHAR(13)+CHAR(10) + 'Medisoft Case Number: ' + impCas.[CaseNumber] , -- Notes - text
                    0 , -- ShowExpiredInsurancePolicies - bit
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0 , -- ModifiedUserID - int
                    @PracticeID , -- PracticeID - int
                    realp.VendorID + impCas.casenumber, -- VendorID - varchar(50)
                    @VendorImportID , -- VendorImportID - int
                    CASE WHEN impCas.[pregnancyindicator] = 1 THEN 1 ELSE 0 END , -- PregnancyRelatedFlag - bit
                    CASE WHEN impCas.[printpatientstatements] = 1 THEN 1 ELSE 0 END , -- StatementActive - bit
                    CASE WHEN impCas.[epsdt] = 1 THEN 1 ELSE 0 END , -- EPSDT - bit
                    CASE WHEN impCas.[familyplanning] = 1 THEN 1 ELSE 0 END , -- FamilyPlanning - bit
                    1 , -- EPSDTCodeID - int
                    CASE WHEN impCas.[emergency] = 1 THEN 1 ELSE 0 END , -- EmergencyRelated - bit
                    CASE WHEN impCas.[homeboundindicator] = 1 THEN 1 ELSE 0 END  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_39_38_CaseInformation] AS impCas
INNER JOIN dbo.Patient AS realP ON
	realp.VendorID + impCas.casenumber = impCas.chartnumber + impCas.casenumber AND
	realp.VendorImportID = @VendorImportID
LEFT JOIN dbo.Doctor AS realdoc ON
	realdoc.[VendorID] = impCas.[referringprovider] AND
	realdoc.[VendorImportID] = @VendorImportID AND
    realdoc.[PracticeID] = @PracticeID AND
    realdoc.[External] = 1
WHERE impCas.chartnumber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientCaseDate - First Consulted...'
      --PatientCaseDate
      INSERT INTO dbo.PatientCaseDate
                  ( PracticeID ,
                    PatientCaseID ,
                    PatientCaseDateTypeID ,
                    StartDate ,
                    EndDate ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID
                  )
      SELECT DISTINCT
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    1 , -- PatientCaseDateTypeID - int
                    CASE WHEN ISDATE(impCas.[datefirstconsulted]) = 1 THEN impCas.[datefirstconsulted]
                           ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.datefirstconsulted <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientCaseDate - Date of Injury...'
      --PatientCaseDate
      INSERT INTO dbo.PatientCaseDate
                  ( PracticeID ,
                    PatientCaseID ,
                    PatientCaseDateTypeID ,
                    StartDate ,
                    EndDate ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID
                  )
      SELECT DISTINCT
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    2 , -- PatientCaseDateTypeID - int
                    CASE WHEN ISDATE(impCas.[dateofinjuryillness]) = 1 THEN impCas.[dateofinjuryillness]
                           ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.[dateofinjuryillness] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientCaseDate - Similiar Symptoms...'
      --PatientCaseDate
      INSERT INTO dbo.PatientCaseDate
                  ( PracticeID ,
                    PatientCaseID ,
                    PatientCaseDateTypeID ,
                    StartDate ,
                    EndDate ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID
                  )
      SELECT DISTINCT
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    3 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.[datesimilarsymptoms]) = 1 THEN impCas.[datesimilarsymptoms]
                              ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.[datesimilarsymptoms] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientCaseDate - Unable to work...'
      --PatientCaseDate
      INSERT INTO dbo.PatientCaseDate
                  ( PracticeID ,
                    PatientCaseID ,
                    PatientCaseDateTypeID ,
                    StartDate ,
                    EndDate ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID
                  )
      SELECT DISTINCT
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    4 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.[dateunabletoworkfrom]) = 1 THEN impCas.[dateunabletoworkfrom]
                              ELSE NULL END , -- StartDate - datetime
                    CASE      WHEN ISDATE(impCas.[dateunabletoworkto]) = 1 THEN impCas.[dateunabletoworkto]
                              ELSE NULL END , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.[dateunabletoworkfrom] <> ''
	  PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientCaseDate - Date Total Disability...'
      --PatientCaseDate
      INSERT INTO dbo.PatientCaseDate
                  ( PracticeID ,
                    PatientCaseID ,
                    PatientCaseDateTypeID ,
                    StartDate ,
                    EndDate ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID
                  )
      SELECT DISTINCT
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    5 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.[datetotdisabilityfrom]) = 1 THEN impCas.[datetotdisabilityfrom]
                              ELSE NULL END , -- StartDate - datetime
                    CASE      WHEN ISDATE(impCas.[datetotdisabilityto]) = 1 THEN impCas.[datetotdisabilityto]
                              ELSE NULL END , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.[datetotdisabilityfrom] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientCaseDate - Hospital Date...'
      --PatientCaseDate
      INSERT INTO dbo.PatientCaseDate
                  ( PracticeID ,
                    PatientCaseID ,
                    PatientCaseDateTypeID ,
                    StartDate ,
                    EndDate ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID
                  )
      SELECT DISTINCT
              @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    6 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.[hospitaldatefrom]) = 1 THEN impCas.[hospitaldatefrom]
                              ELSE NULL END , -- StartDate - datetime
                    CASE      WHEN ISDATE(impCas.[hospitaldateto]) = 1 THEN impCas.[hospitaldateto]
                              ELSE NULL END , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.[hospitaldatefrom] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientCaseDate - Last Visit...'
      --PatientCaseDate
      INSERT INTO dbo.PatientCaseDate
                  ( PracticeID ,
                    PatientCaseID ,
                    PatientCaseDateTypeID ,
                    StartDate ,
                    EndDate ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID
                  )
      SELECT DISTINCT
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    8 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.[lastvisitdate]) = 1 THEN impCas.[lastvisitdate]
                              ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.chartnumber + impCas.casenumber AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.[lastvisitdate] <> ''
	  PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientCaseDate - Referral Date...'
      --PatientCaseDate
      INSERT INTO dbo.PatientCaseDate
                  ( PracticeID ,
                    PatientCaseID ,
                    PatientCaseDateTypeID ,
                    StartDate ,
                    EndDate ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID
                  )
      SELECT DISTINCT
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    9 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.[referraldate]) = 1 THEN impCas.[referraldate]
                              ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.[referraldate] <> ''
	  PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientCaseDate - Date of Manifestation...'
      --PatientCaseDate
      INSERT INTO dbo.PatientCaseDate
                  ( PracticeID ,
                    PatientCaseID ,
                    PatientCaseDateTypeID ,
                    StartDate ,
                    EndDate ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID
                  )
      SELECT DISTINCT
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    10 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.dateofmanifestation) = 1 THEN impCas.dateofmanifestation
                              ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.[dateofmanifestation] <> ''
	  PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientCaseDate - Last XRAY...'
      --PatientCaseDate
      INSERT INTO dbo.PatientCaseDate
                  ( PracticeID ,
                    PatientCaseID ,
                    PatientCaseDateTypeID ,
                    StartDate ,
                    EndDate ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID
                  )
      SELECT DISTINCT
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    11 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.[lastxraydate]) = 1 THEN impCas.[lastxraydate]
                              ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.[lastxraydate] <> ''
	PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



      
PRINT ''
PRINT 'Inserting into PatientCaseDate - Related to Accident...'
      --PatientCaseDate
      INSERT INTO dbo.PatientCaseDate
                  ( PracticeID ,
                    PatientCaseID ,
                    PatientCaseDateTypeID ,
                    StartDate ,
                    EndDate ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID
                  )
      SELECT DISTINCT
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    12 , -- PatientCaseDateTypeID - int
                    CASE      WHEN impCas.relatedtoaccident IN ('Yes','Auto') THEN (CASE WHEN ISDATE(impCas.[dateofinjuryillness]) = 1 THEN impCas.[dateofinjuryillness] ELSE NULL END)
                              ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.[dateofinjuryillness] <> '' AND impCas.[relatedtoaccident] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Primary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
                  ( PatientCaseID ,
                    InsuranceCompanyPlanID ,
                    Precedence ,
                    PolicyNumber ,
                    GroupNumber ,
                    PolicyStartDate ,
                    PolicyEndDate ,
                    PatientRelationshipToInsured ,
                    HolderPrefix ,
                    HolderFirstName ,
                    HolderMiddleName ,
                    HolderLastName ,
                    HolderSuffix ,
                    HolderDOB ,
                    HolderSSN ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID ,
                    HolderGender ,
                    HolderAddressLine1 ,
                    HolderAddressLine2 ,
                    HolderCity ,
                    HolderState ,
                    HolderCountry ,
                    HolderZipCode ,
                    HolderPhone ,
                    DependentPolicyNumber ,
                    Notes ,
                    Copay ,
                    Deductible ,
                    PatientInsuranceNumber ,
                    Active ,
                    PracticeID ,
                    VendorID ,
                    VendorImportID ,
                    GroupName 
                  )
      SELECT DISTINCT
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    realicp.[InsuranceCompanyPlanID] , -- InsuranceCompanyPlanID - int
                    1 , -- Precedence - int
                    impCas.[policynumber1] , -- PolicyNumber - varchar(32)
                    impCas.[groupnumber1] , -- GroupNumber - varchar(32)
                    CASE      WHEN ISDATE(impCas.[policy1startdate]) = 1 THEN impCas.[policy1startdate]
                              ELSE NULL END , -- PolicyStartDate - datetime
                    CASE      WHEN ISDATE(impCas.[policy1enddate]) = 1 THEN impCas.[policy1enddate]
                              ELSE NULL END , -- PolicyEndDate - datetime
                    CASE impCas.[insuredrelationship1]      WHEN 'Self' THEN 'S'
                                                                              WHEN 'Child' THEN 'C'
                                                                              WHEN 'Spouse' THEN 'U'
                                                                              ELSE 'O' END , -- PatientRelationshipToInsured -- varchar(1)
                    '' as HolderPrefix ,-- varchar(16)
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[firstname] END AS HolderFirstName ,-- varchar(64)
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[middleinitial] END AS HolderMiddleName ,-- varchar(64)
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[lastname] END AS HolderLastName ,-- varchar(64)
                    '' as HolderSuffix ,-- varchar(16)
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN (CASE WHEN ISDATE(holder.[dateofbirth]) = 1 THEN holder.[dateofbirth] ELSE NULL END)
                         ELSE NULL END AS HolderDOB ,-- datetime
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[socialsecuritynumber] END AS HolderSSN ,-- char(11)
                    GETDATE() AS createddate, -- CreatedDate - datetime
                    0 AS createduserid, -- CreatedUserID - int
                    GETDATE() AS modifieddate, -- ModifiedDate - datetime
                    0 AS modifieduserid, -- ModifiedUserID - int
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN
                              (CASE holder.[sex] WHEN 'F' THEN 'F'
                                                 WHEN 'M' THEN 'M'
                                                 ELSE 'U' END) END AS HolderGender ,-- char(1)
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[street1] END as HolderAddressLine1, -- varchar(256)
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[street2] END as HolderAddressLine2 ,-- varchar(256)
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[city] END AS  HolderCity, -- varchar(128)
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN LEFT(holder.[state] , 2) END as HolderState, -- varchar(2)
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN '' END as HolderCountry, -- varchar(32)
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN
                                    (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])
                                          WHEN LEN(dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])
                                          ELSE '' END) END as HolderZipCode, -- varchar(9)
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN LEFT(dbo.fn_RemoveNonNumericCharacters(holder.[phone1]) , 10) END AS HolderPhone, -- varchar(10)
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN impCas.[policynumber1] END AS DependentPolicyNumber ,-- varchar(32)
                    impCas.[notes] , -- Notes - text
                    impCas.[copaymentamount] , -- Copay - money
                    impCas.[annualdeductible] , -- Deductible - money
                    CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN impCas.[policynumber1] END as PatientInsuranceNumber ,-- varchar(32)
                    1 , -- Active - bit
                    @PracticeID , -- PracticeID - int
                    impCas.[chartnumber] + impCas.casenumber , -- VendorID - varchar(50)
                    @VendorImportID , -- VendorImportID - int
                    CASE WHEN impCas.[groupname1] = '' THEN ''
                         ELSE LEFT(impCas.[groupname1] , 14) END AS GroupName -- varchar(14)
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[VendorImportID] = @VendorImportID AND
            realpc.[PracticeID] = @PracticeID
      INNER JOIN dbo.InsuranceCompanyPlan AS realicp ON
            realicp.[VendorID] = impCas.[insurancecarrier1] AND
            realicp.[VendorImportID] = @VendorImportID AND
            realicp.[CreatedPracticeID] = @PracticeID
      INNER JOIN 
            (SELECT DISTINCT [chartnumber] , [firstname] , [middleinitial] , [lastname] , [street1] , [street2] , [city] ,
            [state] , [zipcode] , [phone1] , [socialsecuritynumber] , [sex] , [dateofbirth] 
            FROM dbo._import_39_38_PatientData) AS holder ON
                  holder.[chartnumber] = impCas.[insured1]    
WHERE impCas.policynumber1 <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Secondary Insurance Policy...'
      --InsurancePolicy
      INSERT INTO dbo.InsurancePolicy
                  ( PatientCaseID ,
                    InsuranceCompanyPlanID ,
                    Precedence ,
                    PolicyNumber ,
                    GroupNumber ,
                    PolicyStartDate ,
                    PolicyEndDate ,
                    PatientRelationshipToInsured ,
                    HolderPrefix ,
                    HolderFirstName ,
                    HolderMiddleName ,
                    HolderLastName ,
                    HolderSuffix ,
                    HolderDOB ,
                    HolderSSN ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID ,
                    HolderGender ,
                    HolderAddressLine1 ,
                    HolderAddressLine2 ,
                    HolderCity ,
                    HolderState ,
                    HolderCountry ,
                    HolderZipCode ,
                    HolderPhone ,
                    DependentPolicyNumber ,
                    Notes ,
                    PatientInsuranceNumber ,
                    Active ,
                    PracticeID ,
                    VendorID ,
                    VendorImportID ,
                    GroupName 
                  )
      SELECT DISTINCT
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    realicp.[InsuranceCompanyPlanID] , -- InsuranceCompanyPlanID - int
                    2 , -- Precedence - int
                    impCas.[policynumber2] , -- PolicyNumber - varchar(32)
                    impCas.[groupnumber2] , -- GroupNumber - varchar(32)
                    CASE      WHEN ISDATE(impCas.[policy2startdate]) = 1 THEN impCas.[policy2startdate]
                              ELSE NULL END , -- PolicyStartDate - datetime
                    CASE      WHEN ISDATE(impCas.[policy2enddate]) = 1 THEN impCas.[policy2enddate]
                              ELSE NULL END , -- PolicyEndDate - datetime
                    CASE impCas.[insuredrelationship2]      WHEN 'Self' THEN 'S'
                                                                              WHEN 'Child' THEN 'C'
                                                                              WHEN 'Spouse' THEN 'U'
                                                                              ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
                    '' , -- HolderPrefix - varchar(16)
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[firstname] END , -- HolderFirstName - varchar(64)
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[middleinitial] END , -- HolderMiddleName - varchar(64)
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[lastname] END , -- HolderLastName - varchar(64)
                    '' , -- HolderSuffix - varchar(16)
                    CASE      WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN (CASE WHEN ISDATE(holder.[dateofbirth]) = 1 THEN holder.[dateofbirth] ELSE NULL END)
                              ELSE NULL END , -- HolderDOB - datetime
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[socialsecuritynumber] END , -- HolderSSN - char(11)
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0 , -- ModifiedUserID - int
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN
                                    (CASE holder.[sex]      WHEN 'F' THEN 'F'
                                                                  WHEN 'M' THEN 'M'
                                                                  ELSE 'U' END) END , -- HolderGender - char(1)
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[street1] END , -- HolderAddressLine1 - varchar(256)
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[street2] END , -- HolderAddressLine2 - varchar(256)
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[city] END , -- HolderCity - varchar(128)
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN LEFT(holder.[state] , 2) END , -- HolderState - varchar(2)
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN '' END , -- HolderCountry - varchar(32)
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN
                                    (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])
                                                WHEN LEN(dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])
                                                ELSE '' END) END, -- HolderZipCode - varchar(9)
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN LEFT(dbo.fn_RemoveNonNumericCharacters(holder.[phone1]) , 10) END , -- HolderPhone - varchar(10)
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN impCas.[policynumber2] END , -- DependentPolicyNumber - varchar(32)
                    impCas.[notes] , -- Notes - text
                    CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN impCas.[policynumber2] END , -- PatientInsuranceNumber - varchar(32)
                    1 , -- Active - bit
                    @PracticeID , -- PracticeID - int
                    impCas.[chartnumber] + impCas.casenumber , -- VendorID - varchar(50)
                    @VendorImportID , -- VendorImportID - int
                    CASE      WHEN impCas.[groupname2] = '' THEN ''
                              ELSE LEFT(impCas.[groupname2] , 14) END  -- GroupName - varchar(14)
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[VendorImportID] = @VendorImportID AND
            realpc.[PracticeID] = @PracticeID  
      INNER JOIN dbo.InsuranceCompanyPlan AS realicp ON
            realicp.[VendorID] = impCas.[insurancecarrier2] AND
            realicp.[VendorImportID] = @VendorImportID AND
            realicp.[CreatedPracticeID] = @PracticeID  
      INNER JOIN 
            (SELECT DISTINCT [chartnumber] , [firstname] , [middleinitial] , [lastname] , [street1] , [street2] , [city] ,
            [state] , [zipcode] , [phone1] , [socialsecuritynumber] , [sex] , [dateofbirth] 
            FROM dbo._import_39_38_PatientData) AS holder ON
                  holder.[chartnumber] = impCas.[insured2]
      WHERE impCas.[policynumber2] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Tertiary Insurance Policy...'
      --InsurancePolicy
      INSERT INTO dbo.InsurancePolicy
                  ( PatientCaseID ,
                    InsuranceCompanyPlanID ,
                    Precedence ,
                    PolicyNumber ,
                    GroupNumber ,
                    PolicyStartDate ,
                    PolicyEndDate ,
                    PatientRelationshipToInsured ,
                    HolderPrefix ,
                    HolderFirstName ,
                    HolderMiddleName ,
                    HolderLastName ,
                    HolderSuffix ,
                    HolderDOB ,
                    HolderSSN ,
                    CreatedDate ,
                    CreatedUserID ,
                    ModifiedDate ,
                    ModifiedUserID ,
                    HolderGender ,
                    HolderAddressLine1 ,
                    HolderAddressLine2 ,
                    HolderCity ,
                    HolderState ,
                    HolderCountry ,
                    HolderZipCode ,
                    HolderPhone ,
                    DependentPolicyNumber ,
                    Notes ,
                    PatientInsuranceNumber ,
                    Active ,
                    PracticeID ,
                    VendorID ,
                    VendorImportID ,
                    GroupName 
                  )
      SELECT DISTINCT
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    realicp.[InsuranceCompanyPlanID] , -- InsuranceCompanyPlanID - int
                    3 , -- Precedence - int
                    impCas.[policynumber3] , -- PolicyNumber - varchar(32)
                    impCas.[groupnumber3] , -- GroupNumber - varchar(32)
                    CASE      WHEN ISDATE(impCas.[policy3startdate]) = 1 THEN impCas.[policy2startdate]
                              ELSE NULL END , -- PolicyStartDate - datetime
                    CASE      WHEN ISDATE(impCas.[policy3enddate]) = 1 THEN impCas.[policy2enddate]
                              ELSE NULL END , -- PolicyEndDate - datetime
                    CASE  impCas.[insuredrelationship3]     WHEN 'Self' THEN 'S'
                                                                              WHEN 'Child' THEN 'C'
                                                                              WHEN 'Spouse' THEN 'U'
                                                                              ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
                    '' , -- HolderPrefix - varchar(16)
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[firstname] END , -- HolderFirstName - varchar(64)
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[middleinitial] END , -- HolderMiddleName - varchar(64)
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[lastname] END , -- HolderLastName - varchar(64)
                    '' , -- HolderSuffix - varchar(16)
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN (CASE WHEN ISDATE(holder.[dateofbirth]) = 1 THEN holder.[dateofbirth] ELSE NULL END)
                              ELSE NULL END , -- HolderDOB - datetime
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[socialsecuritynumber] END , -- HolderSSN - char(11)
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0 , -- ModifiedUserID - int
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN
                                    (CASE holder.[sex]      WHEN 'F' THEN 'F'
                                                                  WHEN 'M' THEN 'M'
                                                                  ELSE 'U' END) END , -- HolderGender - char(1)
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[street1] END , -- HolderAddressLine1 - varchar(256)
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[street2] END , -- HolderAddressLine2 - varchar(256)
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[city] END , -- HolderCity - varchar(128)
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN LEFT(holder.[state] , 2) END , -- HolderState - varchar(2)
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN '' END , -- HolderCountry - varchar(32)
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN
                                    (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])
                                                WHEN LEN(dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])
                                                ELSE '' END) END, -- HolderZipCode - varchar(9)
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN LEFT(dbo.fn_RemoveNonNumericCharacters(holder.[phone1]) , 10) END , -- HolderPhone - varchar(10)
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN impCas.[policynumber3] END , -- DependentPolicyNumber - varchar(32)
                    impCas.[notes] , -- Notes - text
                    CASE      WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN impCas.[policynumber3] END , -- PatientInsuranceNumber - varchar(32)
                    1 , -- Active - bit
                    @PracticeID , -- PracticeID - int
                    impCas.[chartnumber] + impCas.casenumber , -- VendorID - varchar(50)
                    @VendorImportID , -- VendorImportID - int
                    CASE      WHEN impCas.[groupname3] = '' THEN ''
                              ELSE LEFT(impCas.[groupname3] , 14) END  -- GroupName - varchar(14)
      FROM dbo._import_39_38_CaseInformation AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
            realpc.[VendorImportID] = @VendorImportID AND
            realpc.[PracticeID] = @PracticeID  
      INNER JOIN dbo.InsuranceCompanyPlan AS realicp ON
            realicp.[VendorID] = impCas.[insurancecarrier3] AND
            realicp.[VendorImportID] = @VendorImportID AND
            realicp.[CreatedPracticeID] = @PracticeID  
      INNER JOIN 
            (SELECT DISTINCT [chartnumber] , [firstname] , [middleinitial] , [lastname] , [street1] , [street2] , [city] ,
            [state] , [zipcode] , [phone1] , [socialsecuritynumber] , [sex] , [dateofbirth]  
            FROM dbo._import_39_38_PatientData) AS holder ON
                  holder.[chartnumber] = impCas.[insured3]
      WHERE impCas.[policynumber3] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
 

END

-- Standard fee schedule (only if table exists)
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_39_38_StandardFeeSchedule]') AND type in (N'U'))
BEGIN

PRINT ''
PRINT 'Inserting into Standard Fee Schedule...'
      --Standard Fee Schedule
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
                  ( 
                    @PracticeID , -- PracticeID - int
                    'Default Contract' , -- Name - varchar(128)
                    'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
                    GETDATE() , -- EffectiveStartDate - datetime
                    'F' , -- SourceType - char(1)
                    'Import File' , -- SourceFileName - varchar(256)
                    30 , -- EClaimsNoResponseTrigger - int
                    30 , -- PaperClaimsNoResponseTrigger - int
                    NULL , -- MedicareFeeScheduleGPCICarrier - int
                    NULL , -- MedicareFeeScheduleGPCILocality - int
                    NULL , -- MedicareFeeScheduleGPCIBatchID - int
                    NULL , -- MedicareFeeScheduleRVUBatchID - int
                    0 , -- AddPercent - decimal
                    15  -- AnesthesiaTimeIncrement - int
                  )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Standard Fee...'
      --StandardFee
      INSERT INTO dbo.ContractsAndFees_StandardFee
                  ( StandardFeeScheduleID ,
                    ProcedureCodeID ,
                    ModifierID ,
                    SetFee ,
                    AnesthesiaBaseUnits
                  )
      SELECT DISTINCT
                    sfs.[StandardFeeScheduleID], -- StandardFeeScheduleID - int
                    pcd.[ProcedureCodeDictionaryID] , -- ProcedureCodeID - int
                    pm.[ProcedureModifierID] , -- ModifierID - int
                    Impsfs.[amounta] , -- SetFee - money
                    0  -- AnesthesiaBaseUnits - int
      FROM dbo._import_39_38_StandardFeeSchedule AS Impsfs
      INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule AS sfs ON
            CAST(sfs.[Notes] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID  
      INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
            pcd.[ProcedureCode] = Impsfs.[code1]
      LEFT JOIN dbo.ProcedureModifier AS pm ON
            pm.[ProcedureModifierCode] = Impsfs.[defaultmodifier1]
      WHERE CAST(Impsfs.[amounta] AS MONEY) > 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Standard Fee Schedule Link...'
      --Standard Fee Schedule Link
      INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
                  ( ProviderID ,
                    LocationID ,
                    StandardFeeScheduleID
                  )
      SELECT DISTINCT
                    doc.[DoctorID] , -- ProviderID - int
                    sl.[ServiceLocationID] , -- LocationID - int
                    sfs.[StandardFeeScheduleID]  -- StandardFeeScheduleID - int
      FROM dbo.Doctor AS doc, dbo.ServiceLocation AS sl, dbo.ContractsAndFees_StandardFeeSchedule AS sfs
      WHERE doc.[External] = 0 AND
            doc.[PracticeID] = @PracticeID AND
            sl.PracticeID = @PracticeID AND
            sfs.[Notes] = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
END


-- Appointments (only if table exists)
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_39_38_Appointment]') AND type in (N'U'))
BEGIN

PRINT ''
PRINT 'Inserting into Appointment...'
      --Appointment
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
                    realpat.[PatientID] , -- PatientID - int
                    @PracticeID ,
                     -- PracticeID - int
                    CASE      WHEN realpat.[defaultserviceLocationID] IS NOT NULL THEN realpat.[defaultServiceLocationID] 
                              ELSE (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID AND 
                                                            ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation WHERE practiceID = @PracticeID)) END , -- ServiceLocationID - int
                    DATEADD(hh, -1 , impApp.[startdate]) , -- StartDate - datetime
                    DATEADD(hh, -1 , impApp.[enddate]) , -- EndDate - datetime
                    'P' , -- AppointmentType - varchar(1)
                    '' , -- Subject - varchar(64)
                    impApp.[note] , -- Notes - text
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0 , -- ModifiedUserID - int
                    1 , -- AppointmentResourceTypeID - int
                    'S' , -- AppointmentConfirmationStatusCode - char(1)
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    dk.[DKPracticeID] , -- StartDKPracticeID - int
                    dk.[DKPracticeID] , -- EndDKPracticeID - int
                    impApp.[starttm] - 100 , -- StartTm - smallint
                    impApp.[endtm] - 100  -- EndTm - smallint
      FROM dbo.[_import_39_38_Appointment] AS impApp
      INNER JOIN dbo.Patient AS realpat ON
            realpat.[VendorID] = impApp.[chartnumber] AND
            realpat.[VendorImportID] = @VendorImportID  
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impApp.[chartnumber] + impApp.casenumber AND
            realpc.[VendorImportID] = @VendorImportID AND
			realpc.[PracticeID] = @PracticeID
      INNER JOIN dbo.DateKeyToPractice dk ON
            dk.[PracticeID] = @PracticeID AND
            dk.Dt = CAST(CAST(impApp.[startdate] AS DATE) AS DATETIME)   
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment To Resource...'
      --AppointmentToResource
      INSERT INTO dbo.AppointmentToResource
                  ( AppointmentID ,
                    AppointmentResourceTypeID ,
                    ResourceID ,
                    ModifiedDate ,
                    PracticeID
                  )
      SELECT DISTINCT
                    realapp.[AppointmentID] , -- AppointmentID - int
                    1 , -- AppointmentResourceTypeID - int
                    realdoc.[DoctorID] , -- ResourceID - int
                    GETDATE() , -- ModifiedDate - datetime
                    @PracticeID  -- PracticeID - int
      FROM dbo.[_import_39_38_Appointment] AS impApp
      INNER JOIN dbo.Patient AS realpat ON 
            realpat.[VendorID] = impApp.[chartnumber] AND
            realpat.[VendorImportID] = @VendorImportID
      INNER JOIN dbo.Appointment AS realapp ON
            realapp.[PatientID] = realpat.[PatientID] AND
            realapp.[StartDate] = DATEADD(hh , - 1, impApp.[startdate])
      INNER JOIN dbo._import_39_38_Providers AS impPro ON
            impPro.[code] = impApp.[provider]
      INNER JOIN dbo.Doctor AS realdoc ON
            realdoc.[FirstName] = impPro.[firstname] AND
            realdoc.[LastName] = impPro.[lastname] AND
            realdoc.[External] = 0 AND
            realdoc.[PracticeID] = @PracticeID  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_39_38_CaseInformation]') AND type in (N'U'))
BEGIN

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
      INNER JOIN dbo._import_39_38_PatientData AS impPat ON
            realpat.VendorID = impPat.chartnumber       
      WHERE realpat.VendorImportID = @VendorImportID AND dbo.fn_RemoveNonNumericCharacters(impPat.patientremainderbalance) > 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


      --Creating Diagnosis Code for Balance Forward
      IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE OfficialName = 'Miscellaneous')
      BEGIN
  PRINT ''
  PRINT 'Inserting into Diagnosis Code Dictrionary...'    
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
      SELECT    @PracticeID , -- PracticeID - int
                    realpat.PatientiD , -- PatientID - int
                    doc.DoctorID , -- DoctorID - int
                    NULL , -- AppointmentID - int
                    CASE      WHEN realpat.[defaultserviceLocationID] IS NOT NULL THEN realpat.[defaultServiceLocationID] 
                              ELSE (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID AND 
                                          ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation WHERE practiceID = @PracticeID)) END, -- LocationID - int
                    NULL , -- PatientEmployerID - int
                    GETDATE() , -- DateOfService - datetime
                    GETDATE() , -- DateCreated - datetime
                    CONVERT(VARCHAR(10),GETDATE(),101) + ': Creating Balance Forward' , -- Notes - text
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
                    impPat.ChartNumber , -- VendorID - varchar(50)
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
      FROM dbo._import_39_38_PatientData impPat
      INNER JOIN dbo.Patient realpat ON
               impPat.ChartNumber = realpat.VendorID AND
               realpat.VendorImportID = @VendorImportID
      INNER JOIN dbo.PatientCase PC ON
               realpat.PatientID = pc.PatientID AND
               pc.Name = 'Balance Forward' AND
               pc.VendorImportID = @VendorImportID
      INNER JOIN dbo._import_39_38_Providers AS impPro ON
               impPro.code = impPat.assignedprovider
      INNER JOIN dbo.Doctor doc ON
               impPro.firstname = doc.FirstName AND
               impPro.lastname = doc.LastName AND
               doc.PracticeID = @PracticeID AND
               doc.[External] = 0
      WHERE dbo.fn_RemoveNonNumericCharacters(impPat.patientremainderbalance) <> 0
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
                    impPat.ChartNumber , -- VendorID - varchar(50)
                    @VendorImportID  -- VendorImportID - int
      FROM dbo._import_39_38_PatientData impPat
      INNER JOIN dbo.Encounter E ON 
               impPat.ChartNumber = E.VendorID AND
               CAST(E.Notes AS VARCHAR) = CAST(CONVERT(VARCHAR(10),GETDATE(),101) + ': Creating Balance Forward' AS VARCHAR) AND
               E.VendorImportID = @VendorImportID
      INNER JOIN dbo.DiagnosisCodeDictionary dcd ON
               dcd.DiagnosisCode = '000.00'
      WHERE dbo.fn_RemoveNonNumericCharacters(impPat.patientremainderbalance) <> 0
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
                    impPat.patientremainderbalance , -- ServiceChargeAmount - money
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
                    impPat.ChartNumber , -- VendorID - varchar(50)
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
      FROM dbo._import_39_38_PatientData impPat
      INNER JOIN dbo.Encounter E ON 
               impPat.ChartNumber = E.VendorID AND 
               CAST(E.Notes AS VARCHAR) = CAST(CONVERT(VARCHAR(10),GETDATE(),101) + ': Creating Balance Forward' AS VARCHAR) AND
               E.VendorImportID = @VendorImportID
      INNER JOIN dbo.ProcedureCodeDictionary pcd ON
               pcd.OfficialName = 'BALANCE FORWARD'
      INNER JOIN dbo.EncounterDiagnosis ED ON    
               impPat.ChartNumber = ED.VendorID AND
               ED.VendorImportID = @VendorImportID
      WHERE dbo.fn_RemoveNonNumericCharacters(impPat.patientremainderbalance) <> 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

PRINT ''
PRINT 'Updating Guarantor Records on Patient...'
UPDATE dbo.Patient
	SET ResponsibleDifferentThanPatient = CASE WHEN impCas.[Guarantor] <> impCas.[chartnumber] THEN 1 ELSE 0 END ,
		ResponsibleFirstName = CASE WHEN impCas.[Guarantor] <> impCas.[chartnumber] THEN impPat.firstname END ,
		ResponsibleMiddleName = CASE WHEN impCas.[Guarantor] <> impCas.[chartnumber] THEN impPat.middleinitial END ,
		ResponsibleLastName = CASE WHEN impCas.[Guarantor] <> impCas.[chartnumber] THEN impPat.lastname END ,
		ResponsibleRelationshipToPatient = CASE WHEN impCas.[Guarantor] <> impCas.[chartnumber] THEN 'O' ELSE 'S' END ,
		ResponsibleAddressLine1 = CASE WHEN impCas.[Guarantor] <> impCas.[chartnumber] THEN impPat.street1 END ,
		ResponsibleAddressLine2 = CASE WHEN impCas.[Guarantor] <> impCas.[chartnumber] THEN impPat.street2 END ,
		ResponsibleCity = CASE WHEN impCas.[Guarantor] <> impCas.[chartnumber] THEN impPat.city END ,
		ResponsibleState = CASE WHEN impCas.[Guarantor] <> impCas.[chartnumber] THEN impPat.state END ,
		ResponsibleZipCode = CASE WHEN impCas.[Guarantor] <> impCas.[chartnumber] THEN (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impPat.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(impPat.zipcode)
								  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impPat.zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(impPat.zipcode)
								  ELSE '' END)END ,
		MaritalStatus = CASE impCas.[maritalstatus] WHEN 'Divorced' THEN 'D'
                                                    WHEN 'Annulled' THEN 'A'
                                                    WHEN 'Interlocutory' THEN 'I'
                                                    WHEN 'Legally separated' THEN 'L'
                                                    WHEN 'Married' THEN 'M'
                                                    WHEN 'Polygamous' THEN 'P'
                                                    WHEN 'Domestic Partner' THEN 'T'
                                                    WHEN 'Widowed' THEN 'W'
                                                    ELSE 'S' END
FROM dbo.Patient pat
INNER JOIN dbo.[_import_39_38_CaseInformation] impCas ON
	impCas.chartnumber = pat.VendorID
INNER JOIN dbo.[_import_39_38_PatientData] impPat ON
	impPat.chartnumber = impCas.guarantor
WHERE impCas.chartnumber <> '' AND pat.PracticeID = @PracticeID AND pat.VendorImportID = @VendorImportID AND
impCas.chartnumber = (SELECT TOP 1 impCas.chartnumber FROM dbo.[_import_39_38_CaseInformation] WHERE
	impCas.[Guarantor] <> impCas.[chartnumber] ORDER BY impCas.chartnumber DESC)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
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





--ROLLBACK
--COMMIT