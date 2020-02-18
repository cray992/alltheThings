USE superbill_63463_prod
GO
--UPDATE a SET 
--npi=''
--FROM dbo._import_322_137_ReferringDoctors a WHERE a.lastname = 'galpin'

--SELECT * FROM [dbo].[_import_322_137_PatientDemographics] WHERE lastname = 'hirst'
--UPDATE d SET 
--d.state=''
----SELECT * 
--FROM [dbo].[_import_322_137_PatientDemographics] d WHERE lastname = 'hirst' AND chartnumber = 'MDSuite-5250'

--SELECT * FROM dbo.InsurancePolicy WHERE PracticeID = 137 and precedence = 3
--SELECT * FROM dbo.PatientCase WHERE practiceid = 137 AND PatientCaseID = 766196
--SELECT * FROM dbo.Patient WHERE PatientID = 760810

SET XACT_ABORT ON;

BEGIN TRANSACTION;
--rollback
--commit 

--322_137

DECLARE @TargetPracticeID INT;
DECLARE @SourcePracticeID INT;
DECLARE @VendorImportID INT;

SET @TargetPracticeID = 137
SET @SourcePracticeID = 6
SET @VendorImportID = 322
 

--ALTER TABLE dbo.ContractsAndFees_StandardFee ADD vendorimportid VARCHAR(10)
--ALTER TABLE dbo.ContractsAndFees_StandardFeeSchedule ADD vendorimportid VARCHAR(10)
--ALTER TABLE dbo.ContractsAndFees_StandardFeeScheduleLink ADD vendorimportid VARCHAR(10)

SET NOCOUNT ON;

--SELECT * FROM dbo.PatientCase WHERE practiceid = 137 AND PatientCaseID = 598568
--SELECT * FROM dbo.Patient WHERE PracticeID = 137 AND PatientID = 593427

/*
==========================================================================================================================================
DELETE SCRIPT
==========================================================================================================================================
*/

/*
DELETE FROM dbo.InsurancePolicyAuthorization WHERE InsurancePolicyID IN (SELECT InsurancePolicyID FROM dbo.InsurancePolicy WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy Auth records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.AppointmentRecurrenceException WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Recurr Excep records deleted'
DELETE FROM dbo.AppointmentRecurrence WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Recurr records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @TargetPracticeID)
DELETE FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.ServiceLocation WHERE VendorImportID = @VendorImportID AND PracticeID = @TargetPracticeID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Service Location records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.PracticeToInsuranceCompany WHERE PracticeID = @TargetPracticeID AND InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Practice To Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
*/

PRINT 'PracticeID = ' + CAST(@TargetPracticeID AS VARCHAR(10));
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10));

PRINT '';
PRINT 'Inserting Into Insurance Company...';
INSERT INTO dbo.InsuranceCompany
(
    InsuranceCompanyName,
    Notes,
    AddressLine1,
    AddressLine2,
    City,
    State,
    Country,
    ZipCode,
    ContactPrefix,
    ContactFirstName,
    ContactMiddleName,
    ContactLastName,
    ContactSuffix,
    Phone,
    PhoneExt,
    Fax,
    FaxExt,
    BillSecondaryInsurance,
    EClaimsAccepts,
    BillingFormID,
    InsuranceProgramCode,
    HCFADiagnosisReferenceFormatCode,
    HCFASameAsInsuredFormatCode,
    LocalUseFieldTypeCode,
    ReviewCode,
    CompanyTextID,
    ClearinghousePayerID,
    CreatedPracticeID,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    SecondaryPrecedenceBillingFormID,
    VendorID,
    VendorImportID,
    --DefaultAdjustmentCode ,
    ReferringProviderNumberTypeID,
    NDCFormat,
    UseFacilityID,
    AnesthesiaType,
    InstitutionalBillingFormID
)




-----NOT PRACTICEID 6***************************************** ------ENTERING INSURANCE COMPANY FROM PRACTICE 6 THAT DON"T ALREADY EXIST
SELECT DISTINCT
    IC.InsuranceCompanyName,             -- InsuranceCompanyName - varchar(128)
    NULL,                                --ic.notes , -- Notes - text
    NULL,                                --i.address1 , -- AddressLine1 - varchar(256)
    NULL,                                --NULL, --i.address2 , -- AddressLine2 - varchar(256)
    NULL,                                --i.city , -- City - varchar(128)
    NULL,                                --i.state , -- State - varchar(2)
    NULL,                                --i.country , -- Country - varchar(32)
    NULL,                                --LEFT(CASE 
                                         --WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
                                         --WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
                                         --ELSE '' END,9) , -- ZipCode - varchar(9)
    NULL,                                --ic.contactprefix , -- ContactPrefix - varchar(16)
    NULL,                                --ic.contactfirstname , -- ContactFirstName - varchar(64)
    NULL,                                --ic.contactmiddlename , -- ContactMiddleName - varchar(64)
    NULL,                                --ic.contactlastname , -- ContactLastName - varchar(64)
    NULL,                                --ic.contactsuffix , -- ContactSuffix - varchar(16)
    NULL,                                --CASE
                                         --WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone),10)
                                         --ELSE '' END , -- HomePhone - varchar(10)
    NULL,                                --i.phoneext , -- PhoneExt - varchar(10)
    NULL,                                --i.fax , -- Fax - varchar(10)
    NULL,                                --i.faxext , -- FaxExt - varchar(10)
    IC.BillSecondaryInsurance,           -- BillSecondaryInsurance - bit
    IC.EClaimsAccepts,                   -- EClaimsAccepts - bit
    IC.BillingFormID,                    -- BillingFormID - int
    IC.InsuranceProgramCode,             -- InsuranceProgramCode - char(2)
    IC.HCFADiagnosisReferenceFormatCode, -- HCFADiagnosisReferenceFormatCode - char(1)
    IC.HCFASameAsInsuredFormatCode,      -- HCFASameAsInsuredFormatCode - char(1)
    NULL,                                --ic.localusefieldtypecode , -- LocalUseFieldTypeCode - char(5)
    '',                                  -- ReviewCode - char(1)''
    NULL,                                --ic.companytextid , -- CompanyTextID - varchar(10)
    IC.ClearinghousePayerID,             -- ClearinghousePayerID - int
    @TargetPracticeID,                   -- CreatedPracticeID - int
    GETDATE(),                           -- CreatedDate - datetime
    0,                                   -- CreatedUserID - int
    GETDATE(),                           -- ModifiedDate - datetime
    0,                                   -- ModifiedUserID - int
    '',                                  --ic.secondaryprecedencebillingformid , -- SecondaryPrecedenceBillingFormID - int
    LEFT(i.insurancecompanyname, 50),    -- VendorID - varchar(50)
    @VendorImportID,                     -- VendorImportID - int
                                         --ic.defaultAdjustmentCode , -- DefaultAdjustmentCode - varchar(10)
    NULL,                                --ic.referringprovidernumbertypeid , -- ReferringProviderNumberTypeID - int
    1,                                   -- NDCFormat - int
    1,                                   -- UseFacilityID - bit
    '',                                  --ic.anesthesiatype , -- AnesthesiaType - varchar(1)
    NULL                                 --ic.institutionalbillingformid -- InstitutionalBillingFormID - int
--SELECT * 
FROM dbo._import_322_137_InsuranceCOMPANYPLANList i
    INNER JOIN dbo.InsuranceCompany IC
        ON i.insurancecompanyname = IC.InsuranceCompanyName
           AND IC.CreatedPracticeID = @SourcePracticeID
    LEFT JOIN dbo.InsuranceCompany IC2
        ON i.insurancecompanyname = IC2.InsuranceCompanyName
           AND IC2.CreatedPracticeID = @TargetPracticeID
WHERE IC2.InsuranceCompanyName IS NULL;
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted ';


-----------------Not Practice 6 #2

PRINT '';
PRINT 'Inserting Into Insurance Company2...';
INSERT INTO dbo.InsuranceCompany
(
    InsuranceCompanyName,
    Notes,
    AddressLine1,
    AddressLine2,
    City,
    State,
    Country,
    ZipCode,
    ContactPrefix,
    ContactFirstName,
    ContactMiddleName,
    ContactLastName,
    ContactSuffix,
    Phone,
    PhoneExt,
    Fax,
    FaxExt,
    BillSecondaryInsurance,
    EClaimsAccepts,
    BillingFormID,
    InsuranceProgramCode,
    HCFADiagnosisReferenceFormatCode,
    HCFASameAsInsuredFormatCode,
    LocalUseFieldTypeCode,
    ReviewCode,
    CompanyTextID,
    ClearinghousePayerID,
    CreatedPracticeID,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    SecondaryPrecedenceBillingFormID,
    VendorID,
    VendorImportID,
    --DefaultAdjustmentCode ,
    ReferringProviderNumberTypeID,
    NDCFormat,
    UseFacilityID,
    AnesthesiaType,
    InstitutionalBillingFormID
)
SELECT DISTINCT
    i.insurancecompanyname,           -- InsuranceCompanyName - varchar(128)
    NULL,                             --.notes , -- Notes - text
    NULL,                             -- AddressLine1 - varchar(256)
    NULL,                             -- AddressLine2 - varchar(256)
    NULL,                             -- City - varchar(128)
    NULL,                             -- State - varchar(2)
    NULL,                             --ic.country , -- Country - varchar(32)
    NULL,                             -- ZipCode - varchar(9)
    NULL,                             --ic.contactprefix , -- ContactPrefix - varchar(16)
    i.contactfirstname,               -- ContactFirstName - varchar(64)
    NULL,                             --ic.contactmiddlename , -- ContactMiddleName - varchar(64)
    i.contactlastname,                -- ContactLastName - varchar(64)
    NULL,                             --ic.contactsuffix , -- ContactSuffix - varchar(16)
    NULL,                             -- HomePhone - varchar(10)
    i.phoneext,                       -- PhoneExt - varchar(10)
    NULL,                             -- Fax - varchar(10)
    NULL,                             -- FaxExt - varchar(10)
    '',                               --ic.billsecondaryinsurance , -- BillSecondaryInsurance - bit
    '',                               --ic.eclaimsaccepts , -- EClaimsAccepts - bit
    '',                               --ic.billingformid , -- BillingFormID - int
    'CI',                             --ic.insuranceprogramcode , -- InsuranceProgramCode - char(2)
    'R',                              --ic.hcfadiagnosisreferenceformatcode , -- HCFADiagnosisReferenceFormatCode - char(1)
    'D',                              --ic.hcfasameasinsuredformatcode , -- HCFASameAsInsuredFormatCode - char(1)
    NULL,                             --ic.localusefieldtypecode , -- LocalUseFieldTypeCode - char(5)
    '',                               -- ReviewCode - char(1)
    NULL,                             --ic.companytextid , -- CompanyTextID - varchar(10)
    IC2.ClearinghousePayerID,         -- ClearinghousePayerID - int
    @TargetPracticeID,                -- CreatedPracticeID - int
    GETDATE(),                        -- CreatedDate - datetime
    0,                                -- CreatedUserID - int
    GETDATE(),                        -- ModifiedDate - datetime
    0,                                -- ModifiedUserID - int
    '',                               --ic.secondaryprecedencebillingformid , -- SecondaryPrecedenceBillingFormID - int
    LEFT(i.insurancecompanyname, 50), -- VendorID - varchar(50)
    @VendorImportID,                  -- VendorImportID - int
                                      --ic.defaultAdjustmentCode , -- DefaultAdjustmentCode - varchar(10)
    NULL,                             --ic.referringprovidernumbertypeid , -- ReferringProviderNumberTypeID - int
    1,                                -- NDCFormat - int
    1,                                -- UseFacilityID - bit
    '',                               --ic.anesthesiatype , -- AnesthesiaType - varchar(1)
    NULL                              --ic.institutionalbillingformid -- InstitutionalBillingFormID - int

FROM dbo._import_322_137_InsuranceCOMPANYPLANList i
    LEFT JOIN dbo.InsuranceCompany IC2
        ON i.insurancecompanyname = IC2.InsuranceCompanyName
           AND IC2.CreatedPracticeID = @TargetPracticeID
WHERE IC2.InsuranceCompanyName IS NULL
      AND i.insurancecompanyname <> '';
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted ';

PRINT '';
PRINT 'Inserting Into PracticetoInsurance Company...';
INSERT INTO dbo.PracticeToInsuranceCompany
(
    PracticeID,
    InsuranceCompanyID,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    EClaimsProviderID,
    EClaimsEnrollmentStatusID,
    EClaimsDisable,
    AcceptAssignment,
    UseSecondaryElectronicBilling,
    UseCoordinationOfBenefits,
    ExcludePatientPayment,
    BalanceTransfer
)
SELECT DISTINCT
    @TargetPracticeID,                  -- PracticeID - int
    ic.InsuranceCompanyID,              -- InsuranceCompanyID - int
    GETDATE(),                          -- CreatedDate - datetime
    0,                                  -- CreatedUserID - int
    GETDATE(),                          -- ModifiedDate - datetime
    0,                                  -- ModifiedUserID - int
    NULL,                               -- EClaimsProviderID - varchar(32)
    ptic.EClaimsEnrollmentStatusID,     -- EClaimsEnrollmentStatusID - int
    ptic.EClaimsDisable,                -- EClaimsDisable - int
    ptic.AcceptAssignment,              -- AcceptAssignment - bit
    ptic.UseSecondaryElectronicBilling, -- UseSecondaryElectronicBilling - bit
    ptic.UseCoordinationOfBenefits,     -- UseCoordinationOfBenefits - bit
    ptic.ExcludePatientPayment,         -- ExcludePatientPayment - bit
    ptic.BalanceTransfer                -- BalanceTransfer - bit
FROM dbo.PracticeToInsuranceCompany ptic
    INNER JOIN dbo.InsuranceCompany ic
        ON ptic.InsuranceCompanyID = ic.VendorID
           AND ic.VendorImportID = @VendorImportID
           AND ic.CreatedPracticeID = @SourcePracticeID
WHERE ptic.PracticeID = @SourcePracticeID;
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted ';

PRINT '';
PRINT 'Inserting Into Insurance Company Plan...';
INSERT INTO dbo.InsuranceCompanyPlan
(
    PlanName,
    AddressLine1,
    AddressLine2,
    City,
    State,
    Country,
    ZipCode,
    ContactPrefix,
    ContactFirstName,
    ContactMiddleName,
    ContactLastName,
    ContactSuffix,
    Phone,
    PhoneExt,
    Notes,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    --ReviewCode ,
    CreatedPracticeID,
    Fax,
    FaxExt,
    KareoInsuranceCompanyPlanID,
    KareoLastModifiedDate,
    InsuranceCompanyID,
    Copay,
    Deductible,
    VendorID,
    VendorImportID
)
SELECT DISTINCT
    i.planname,
    i.address1,
    i.address2,
    i.city,
    i.state,
    NULL, --i.Country ,
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN ( 5, 9 ) THEN
            dbo.fn_RemoveNonNumericCharacters(i.zip)
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) = 4 THEN
            '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
        ELSE
            ''
    END,
    NULL, --i.ContactPrefix ,
    i.contactfirstname,
    NULL, --i.ContactMiddleName ,
    i.contactlastname,
    NULL, --i.ContactSuffix ,
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) > 10 THEN
            LEFT(SUBSTRING(
                              dbo.fn_RemoveNonNumericCharacters(i.phone),
                              11,
                              LEN(dbo.fn_RemoveNonNumericCharacters(i.phone))
                          ), 10)
        ELSE
            NULL
    END,
    i.phoneext,
    i.notes,
    GETDATE(),
    0,
    GETDATE(),
    0,
          --i.ReviewCode ,
    @TargetPracticeID,
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.fax)) > 10 THEN
            LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.fax), 11, LEN(dbo.fn_RemoveNonNumericCharacters(i.fax))), 10)
        ELSE
            NULL
    END,
    i.faxext,
    NULL, --i.KareoInsuranceCompanyPlanID ,
    NULL, --CASE WHEN ISDATE(i.KareoLastModifiedDate) = 1 THEN i.kareolastmodifieddate ELSE NULL END ,
    ic.InsuranceCompanyID,
    0,    --copay
    0,    --deductible
    i.insuranceid,
    @VendorImportID

--SELECT * from insurancecompany
FROM dbo._import_322_137_InsuranceCOMPANYPLANList i
    INNER JOIN dbo.InsuranceCompany ic
        ON i.insurancecompanyname = ic.InsuranceCompanyName
           AND
        --ic.VendorImportID =@VendorImportID AND -- @VendorImportID 
        ic.CreatedPracticeID = @TargetPracticeID --@targetpracticeid 
    LEFT JOIN dbo.InsuranceCompanyPlan a
        ON i.insuranceid = a.InsuranceCompanyPlanID
           AND a.CreatedPracticeID = @TargetPracticeID
WHERE a.PlanName IS NULL;

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted ';
----rollback

PRINT '';
PRINT 'Inserting Into Patient...';
INSERT INTO dbo.Patient
(
    PracticeID,
    ReferringPhysicianID,
    Prefix,
    FirstName,
    MiddleName,
    LastName,
    Suffix,
    AddressLine1,
    AddressLine2,
    City,
    State,
    Country,
    ZipCode,
    Gender,
    MaritalStatus,
    HomePhone,
    HomePhoneExt,
    WorkPhone,
    WorkPhoneExt,
    DOB,
    SSN,
    EmailAddress,
    ResponsibleDifferentThanPatient,
    ResponsiblePrefix,
    ResponsibleFirstName,
    ResponsibleMiddleName,
    ResponsibleLastName,
    ResponsibleSuffix,
    ResponsibleRelationshipToPatient,
    ResponsibleAddressLine1,
    ResponsibleAddressLine2,
    ResponsibleCity,
    ResponsibleState,
    ResponsibleCountry,
    ResponsibleZipCode,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    EmploymentStatus,
    InsuranceProgramCode,
    PatientReferralSourceID,
    PrimaryProviderID,
    DefaultServiceLocationID,
    EmployerID,
    MedicalRecordNumber,
    MobilePhone,
    MobilePhoneExt,
    PrimaryCarePhysicianID,
    VendorID,
    VendorImportID,
    CollectionCategoryID,
    Active,
    SendEmailCorrespondence,
    --PhonecallRemindersEnabled ,
    EmergencyName,
    EmergencyPhone,
    EmergencyPhoneExt,
    Ethnicity,
    Race,
    LicenseNumber,
    LicenseState,
    Language1,
    Language2
)
SELECT DISTINCT
    @TargetPracticeID,              -- PracticeID - int
    NULL,                           --rd.doctorID , – ReferringPhysicianID - int
    '',                             -- Prefix - varchar(16)
    P.firstname,                    -- FirstName - varchar(64)
    '',                             --p.MiddleName , – MiddleName - varchar(64)
    P.lastname,                     -- LastName - varchar(64)
    '',                             --p.Suffix , – Suffix - varchar(16)
    P.address1,                     -- AddressLine1 - varchar(256)
    P.address2,                     -- AddressLine2 - varchar(256)
    P.city,                         -- City - varchar(128)
    P.state,                        -- State - varchar(2)
    NULL,                           --p.Country , – Country - varchar(32)
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.zipcode)) IN ( 5, 9 ) THEN
            dbo.fn_RemoveNonNumericCharacters(P.zipcode)
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.zipcode)) = 4 THEN
            '0' + dbo.fn_RemoveNonNumericCharacters(P.zipcode)
        ELSE
            ''
    END,                            -- ZipCode - varchar(9)
    P.gender,                       -- Gender - varchar(1)
    NULL,                           -- p.MaritalStatus , – MaritalStatus - varchar(1)
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.homephone)) >= 10 THEN
            LEFT(dbo.fn_RemoveNonNumericCharacters(P.homephone), 10)
        ELSE
            ''
    END,                            -- HomePhone - varchar(10)
    NULL,                           --p.HomePhoneExt , – HomePhoneExt - varchar(10)
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.workphone)) >= 10 THEN
            LEFT(dbo.fn_RemoveNonNumericCharacters(P.workphone), 10)
        ELSE
            ''
    END,                            -- WorkPhone - varchar(10)
    NULL,                           --p.WorkExtension , – WorkPhoneExt - varchar(10)
    P.dateofbirth,                  -- DOB - datetime
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.ssn)) >= 6 THEN
            RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(P.ssn), 9)
        ELSE
            NULL
    END,                            -- SSN - char(9)
    P.email,                        -- EmailAddress - varchar(256)
    CASE
        WHEN P.responsiblepartylastname = '' THEN
            0
        ELSE
            1
    END,                            -- ResponsibleDifferentThanPatient - bit
    NULL,                           --p.ResponsiblePrefix , -- ResponsiblePrefix - varchar(16)
    P.responsiblepartyfirstname,    -- ResponsibleFirstName - varchar(64)
    P.responsiblepartymiddlename,   -- ResponsibleMiddleName - varchar(64)
    P.responsiblepartylastname,     -- ResponsibleLastName - varchar(64)
    P.responsiblepartysuffix,       -- ResponsibleSuffix - varchar(16)
    P.responsiblepartyrelationship, -- ResponsibleRelationshipToPatient - varchar(1)
    P.responsiblepartyaddress1,     -- ResponsibleAddressLine1 - varchar(256)
    P.responsiblepartyaddress2,     -- ResponsibleAddressLine2 - varchar(256)
    P.responsiblepartycity,         -- ResponsibleCity - varchar(128)
    P.responsiblepartystate,        -- ResponsibleState - varchar(2)
    NULL,                           --p.ResponsiblepartyCountry , -- ResponsibleCountry - varchar(32)
    P.responsiblepartyzipcode,      -- ResponsibleZipCode - varchar(9)
    GETDATE(),                      -- CreatedDate - datetime
    0,                              -- CreatedUserID - int
    GETDATE(),                      -- ModifiedDate - datetime
    0,                              -- ModifiedUserID - int
    NULL,                           --p.EmploymentStatus , – EmploymentStatus - char(1)
    NULL,                           --p.insuranceprogramcode , – InsuranceProgramCode - char(2)
    NULL,                           --prs.PatientReferralSourceID , – PatientReferralSourceID - int
    NULL,                           --pp.DoctorID , – PrimaryProviderID - int
    NULL,                           --CASE WHEN sl.ServiceLocationID IS NULL THEN (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @TargetPracticeID) ELSE sl.ServiceLocationID END , – DefaultServiceLocationID - int
    NULL,                           --emp.EmployerID , – EmployerID - int
    chartnumber,                    -- MedicalRecordNumber - varchar(128)
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.cellphone)) >= 10 THEN
            LEFT(dbo.fn_RemoveNonNumericCharacters(P.cellphone), 10)
        ELSE
            ''
    END,                            -- MobilePhone - varchar(10)
    NULL,                           --p.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
    NULL,                           --pcp.DoctorID , – PrimaryCarePhysicianID - int
    chartnumber,                    -- VendorID - varchar(50)
    @VendorImportID,                -- VendorImportID - int
    NULL,                           -- CollectionCategoryID - int
    1,                              -- Active - bit
    NULL,                           -- SendEmailCorrespondence - bit
                                    -- PhonecallRemindersEnabled - bit
    emergencyname,                  -- varchar(128)
    emergencyphone,                 -- varchar(10)
    emergencyphoneext,              -- varchar(10)
    NULL,                           --Ethnicity - varchar(64)
    NULL,                           --Race - varchar(64)
    NULL,                           -- LicenseNumber - varchar(64)
    NULL,                           -- LicenseState - varchar(2)
    NULL,                           -- Language1 - varchar(64)
    NULL                            -- Language2 - varchar(64)
--select * 
FROM dbo._import_322_137_PatientDemographics P
WHERE NOT EXISTS
(
    SELECT *
    FROM dbo.Patient pp
    WHERE pp.FirstName = P.firstname
          AND pp.LastName = P.lastname
          AND pp.DOB = P.dateofbirth
          AND pp.PracticeID = @TargetPracticeID
);
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';


PRINT '';
PRINT 'Insert Into Patient Alert...';
INSERT INTO dbo.PatientAlert
(
    PatientID,
    AlertMessage,
    ShowInPatientFlag,
    ShowInAppointmentFlag,
    ShowInEncounterFlag,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    ShowInClaimFlag,
    ShowInPaymentFlag,
    ShowInPatientStatementFlag
)
SELECT p.PatientID,            -- PatientID - int
       pa.patientalertmessage, -- AlertMessage - text
       1,                      -- ShowInPatientFlag - bit
       1,                      -- ShowInAppointmentFlag - bit
       1,                      -- ShowInEncounterFlag - bit
       GETDATE(),              -- CreatedDate - datetime
       0,                      -- CreatedUserID - int
       GETDATE(),              -- ModifiedDate - datetime
       0,                      -- ModifiedUserID - int
       1,                      -- ShowInClaimFlag - bit
       1,                      -- ShowInPaymentFlag - bit
       1                       -- ShowInPatientStatementFlag - bit
FROM dbo._import_322_137_PatientDemographics pa
    INNER JOIN dbo.Patient p
        ON p.VendorImportID = @VendorImportID
           AND p.VendorID = pa.chartnumber
WHERE pa.patientalertmessage <> '';
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';


INSERT INTO dbo.PayerScenario
(
    Name,
    Description,
    PayerScenarioTypeID,
    StatementActive
)
SELECT DISTINCT
    financialclass,
    financialclass,
    1,
    1
FROM dbo._import_322_137_PatientDemographics d
    LEFT JOIN dbo.PayerScenario ps
        ON d.financialclass = ps.Name
WHERE financialclass <> ''
      AND ps.Name IS NULL
      AND financialclass NOT IN ( 'Medi-Cal', 'Medical', 'Cash', 'Cash Patient', 'PI Lien', 'P.I. Lien' );

PRINT '';
PRINT 'Inserting into PatientCase ...';
INSERT INTO dbo.PatientCase
(
    PatientID,
    Name,
    Active,
    PayerScenarioID,
    ReferringPhysicianID,
    EmploymentRelatedFlag,
    AutoAccidentRelatedFlag,
    OtherAccidentRelatedFlag,
    AbuseRelatedFlag,
    AutoAccidentRelatedState,
    Notes,
    ShowExpiredInsurancePolicies,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    PracticeID,
    CaseNumber,
    WorkersCompContactInfoID,
    VendorID,
    VendorImportID,
    PregnancyRelatedFlag,
    StatementActive,
    EPSDT,
    FamilyPlanning,
    EPSDTCodeID,
    EmergencyRelated,
    HomeboundRelatedFlag
)
SELECT DISTINCT
    p.PatientID,
    'Active',
    1,
    CASE pc.financialclass
        WHEN 'Medi-Cal' THEN
            8
        WHEN 'Medical' THEN
            8
        WHEN 'Cash' THEN
            11
        WHEN 'Cash Patient' THEN
            11
        WHEN 'HMO' THEN
            18
        WHEN 'PI Lien' THEN
            1
        WHEN 'P.I. Lien' THEN
            1
        WHEN '' THEN
            11
        ELSE
            ps.PayerScenarioID
    END,
    NULL,            --d.DoctorID ,
    0,               --,pc.employmentrelatedflag ,
    0,               --pc.autoaccidentrelatedflag ,
    0,               --pc.otheraccidentrelatedflag ,
    0,               --pc.abuserelatedflag ,
    0,               --pc.AutoAccidentRelatedState ,
    NULL,            --pc.Notes ,
    0,               --pc.showexpiredinsurancepolicies ,
    GETDATE(),
    0,
    GETDATE(),
    0,
    @TargetPracticeID,
    NULL,            --pc.CaseNumber ,
    NULL,            --pc.WorkersCompContactInfoID ,
    pc.chartnumber,  -- VendorID
    @VendorImportID, -- VenorID
    0,               --pc.pregnancyrelatedflag ,
    1,               --pc.statementactive ,
    0,               --pc.epsdt ,
    0,               --pc.familyplanning ,
    NULL,            --pc.epsdtcodeid ,
    0,               --pc.emergencyrelated ,
    0                --pc.homeboundrelatedflag
	--select * 
FROM dbo._import_322_137_PatientDemographics pc
    INNER JOIN dbo.Patient p
        ON pc.chartnumber = p.VendorID 
           AND p.VendorImportID = @VendorImportID
    LEFT JOIN dbo.PayerScenario ps
        ON pc.financialclass = ps.Name
WHERE pc.chartnumber <> 'MDSuite-109';

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';


----------------Policy 1----------------------
PRINT '';
PRINT 'Inserting into InsurancePolicy ...';
INSERT INTO dbo.InsurancePolicy
(
    PatientCaseID,
    InsuranceCompanyPlanID,
    Precedence,
    PolicyNumber,
    GroupNumber,
    PolicyStartDate,
    PolicyEndDate,
    CardOnFile,
    PatientRelationshipToInsured,
    HolderPrefix,
    HolderFirstName,
    HolderMiddleName,
    HolderLastName,
    HolderSuffix,
    HolderDOB,
    HolderSSN,
    HolderThroughEmployer,
    HolderEmployerName,
    PatientInsuranceStatusID,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    HolderGender,
    HolderAddressLine1,
    HolderAddressLine2,
    HolderCity,
    HolderState,
    HolderCountry,
    HolderZipCode,
    HolderPhone,
    HolderPhoneExt,
    DependentPolicyNumber,
    Notes,
    Phone,
    PhoneExt,
    Fax,
    FaxExt,
    Copay,
    Deductible,
    PatientInsuranceNumber,
    Active,
    PracticeID,
    AdjusterPrefix,
    AdjusterFirstName,
    AdjusterMiddleName,
    AdjusterLastName,
    AdjusterSuffix,
    VendorID,
    VendorImportID,
    InsuranceProgramTypeID,
    GroupName,
    ReleaseOfInformation,
    SyncWithEHR
)
SELECT 
    pc.PatientCaseID,
    icp.InsuranceCompanyPlanID,
    1,              --ip.Precedence ,
    LEFT(ip.policynumber1, 32),
    LEFT(ip.groupnumber1, 32),
    CASE
        WHEN ISDATE(ip.policy1startdate) = 1 THEN
            ip.policy1startdate
        ELSE
            NULL
    END,
    CASE
        WHEN ISDATE(ip.policy1enddate) = 1 THEN
            ip.policy1enddate
        ELSE
            NULL
    END,
    0,              --ip.CardOnFile ,
    CASE
        WHEN patientrelationship1 = '' THEN
            'S'
        ELSE
            NULL
    END,
    NULL,           --ip.HolderPrefix ,
    ip.holder1firstname,
    ip.holder1middlename,
    ip.holder1lastname,
    NULL,           --ip.Holder1Suffix ,
    ip.holder1dateofbirth,
    ip.holder1ssn,
    0,              --ip.holderthroughemployer ,
    ip.employer1,
    0,              --ip.PatientInsuranceStatusID ,
    GETDATE(),
    0,
    GETDATE(),
    0,
    ip.holder1gender,
    ip.holder1street1,
    ip.holder1street2,
    ip.holder1city,
    ip.holder1state,
    NULL,           --ip.HolderCountry ,
    ip.holder1zipcode,
    NULL,           --ip.HolderPhone ,
    NULL,           --ip.HolderPhoneExt ,
    ip.policynumber1,
    ip.policy1note,
    NULL,           --ip.Phone ,
    NULL,           --ip.PhoneExt ,
    NULL,           --ip.Fax ,
    NULL,           --ip.FaxExt ,
    ip.policy1copay,
    ip.policy1deductible,
    NULL,           --ip.PatientInsuranceNumber ,
    1,              --ip.active ,
    @TargetPracticeID,
    NULL,           --ip.AdjusterPrefix ,
    NULL,           --ip.AdjusterFirstName ,
    NULL,           --ip.AdjusterMiddleName ,
    NULL,           --ip.AdjusterLastName ,
    NULL,           --ip.AdjusterSuffix ,
    ip.chartnumber, --ip.InsurancePolicyID ,
    @VendorImportID,
    NULL,           --ip.insuranceprogramtypeid ,
    LEFT(ip.primarygroupname, 14),
    NULL,           --ip.ReleaseOfInformation
    1               --syncwithehr (primary case flag)
--select * from dbo.InsuranceCompanyPlan icp where createdpracticeid = 137
--FROM dbo._import_322_137_PatientDemographics ip
--    INNER JOIN dbo._import_322_137_InsuranceCOMPANYPLANList icpl
--        ON ip.insurancecode1 = icpl.insuranceid
--    INNER JOIN dbo.PatientCase pc
--        ON ip.chartnumber = pc.VendorID
--           AND pc.VendorImportID = @VendorImportID
--    INNER JOIN dbo.InsuranceCompanyPlan icp
--        ON icpl.planname = icp.PlanName
--           AND icp.CreatedPracticeID = @TargetPracticeID
--    LEFT JOIN dbo.InsurancePolicy ipo
--        ON ipo.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
--           AND ipo.PracticeID = @TargetPracticeID
--           AND ipo.PatientCaseID = pc.PatientCaseID
--           AND policynumber1 = ipo.PolicyNumber
--WHERE ipo.InsurancePolicyID IS NULL;
--rollback
--SELECT * 
FROM dbo._import_322_137_PatientDemographics ip 
    INNER JOIN dbo._import_322_137_InsuranceCOMPANYPLANList icpl
        ON ip.insurancecode1 = icpl.insuranceid
    INNER JOIN dbo.PatientCase pc
        ON ip.chartnumber = pc.VendorID
	       	AND pc.VendorImportID = @VendorImportID
    INNER JOIN dbo.InsuranceCompanyPlan icp
        ON icpl.planname = icp.PlanName
           AND icp.createdpracticeid = @TargetPracticeID
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
           AND ipo.PracticeID = @TargetPracticeID
           AND ipo.PatientCaseID = pc.PatientCaseID
           AND policynumber1 = ipo.PolicyNumber
WHERE ipo.InsurancePolicyID IS NULL AND ip.policynumber1 <>'';

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';
--rollback
------------------Policy 2----------------------
PRINT '';
PRINT 'Inserting into InsurancePolicy2 ...';
INSERT INTO dbo.InsurancePolicy
(
    PatientCaseID,
    InsuranceCompanyPlanID,
    Precedence,
    PolicyNumber,
    GroupNumber,
    PolicyStartDate,
    PolicyEndDate,
    CardOnFile,
    PatientRelationshipToInsured,
    HolderPrefix,
    HolderFirstName,
    HolderMiddleName,
    HolderLastName,
    HolderSuffix,
    HolderDOB,
    HolderSSN,
    HolderThroughEmployer,
    HolderEmployerName,
    PatientInsuranceStatusID,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    HolderGender,
    HolderAddressLine1,
    HolderAddressLine2,
    HolderCity,
    HolderState,
    HolderCountry,
    HolderZipCode,
    HolderPhone,
    HolderPhoneExt,
    DependentPolicyNumber,
    Notes,
    Phone,
    PhoneExt,
    Fax,
    FaxExt,
    Copay,
    Deductible,
    PatientInsuranceNumber,
    Active,
    PracticeID,
    AdjusterPrefix,
    AdjusterFirstName,
    AdjusterMiddleName,
    AdjusterLastName,
    AdjusterSuffix,
    VendorID,
    VendorImportID,
    InsuranceProgramTypeID,
    GroupName,
    ReleaseOfInformation
)
SELECT DISTINCT
    pc.PatientCaseID,
    icp.InsuranceCompanyPlanID,
    2,              --ip.Precedence ,
    ip.policynumber2,
    ip.groupnumber2,
    CASE
        WHEN ISDATE(ip.policy2startdate) = 1 THEN
            ip.policy2startdate
        ELSE
            NULL
    END,
    CASE
        WHEN ISDATE(ip.policy2enddate) = 1 THEN
            ip.policy2enddate
        ELSE
            NULL
    END,
    0,              --ip.CardOnFile ,
    CASE
        WHEN patientrelationship2 = '' THEN
            'S'
        ELSE
            NULL
    END,
    NULL,           --ip.HolderPrefix ,
    ip.holder2firstname,
    ip.holder2middlename,
    ip.holder2lastname,
    NULL,           --ip.Holder1Suffix ,
    ip.holder2dateofbirth,
    ip.holder2ssn,
    0,              --ip.holderthroughemployer ,
    ip.employer1,
    0,              --ip.PatientInsuranceStatusID ,
    GETDATE(),
    0,
    GETDATE(),
    0,
    ip.holder2gender,
    ip.holder2street1,
    ip.holder2street2,
    ip.holder2city,
    ip.holder2state,
    NULL,           --ip.HolderCountry ,
    ip.holder2zipcode,
    NULL,           --ip.HolderPhone ,
    NULL,           --ip.HolderPhoneExt ,
    ip.policynumber2,
    ip.policy2note,
    NULL,           --ip.Phone ,
    NULL,           --ip.PhoneExt ,
    NULL,           --ip.Fax ,
    NULL,           --ip.FaxExt ,
    ip.policy2copay,
    ip.policy2deductible,
    NULL,           --ip.PatientInsuranceNumber , 
    1,              --ip.active ,
    @TargetPracticeID,
    NULL,           --ip.AdjusterPrefix ,
    NULL,           --ip.AdjusterFirstName ,
    NULL,           --ip.AdjusterMiddleName ,
    NULL,           --ip.AdjusterLastName ,
    NULL,           --ip.AdjusterSuffix ,
    ip.chartnumber, --ip.InsurancePolicyID ,
    @VendorImportID,
    NULL,           --ip.insuranceprogramtypeid ,
    LEFT(ip.secondarygroupname, 14),
    NULL            --ip.ReleaseOfInformation

FROM dbo._import_322_137_PatientDemographics ip
    INNER JOIN dbo._import_322_137_InsuranceCOMPANYPLANList icpl
        ON ip.insurancecode2 = icpl.insuranceid
    INNER JOIN dbo.PatientCase pc
        ON ip.chartnumber = pc.VendorID
           AND pc.VendorImportID = @VendorImportID
    INNER JOIN dbo.InsuranceCompanyPlan icp
        ON icpl.planname = icp.PlanName
           AND CreatedPracticeID = @TargetPracticeID
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
           AND ipo.PracticeID = @TargetPracticeID --AND ipo.PatientCaseID=pc.PatientCaseID  
           AND policynumber2 = ipo.PolicyNumber
           AND ipo.Precedence = 2
WHERE ip.insurancecode2 <> 'patient';

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';


----------------Policy 3----------------------
PRINT '';
PRINT 'Inserting into InsurancePolicy3 ...';
INSERT INTO dbo.InsurancePolicy
(
    PatientCaseID,
    InsuranceCompanyPlanID,
    Precedence,
    PolicyNumber,
    GroupNumber,
    PolicyStartDate,
    PolicyEndDate,
    CardOnFile,
    PatientRelationshipToInsured,
    HolderPrefix,
    HolderFirstName,
    HolderMiddleName,
    HolderLastName,
    HolderSuffix,
    HolderDOB,
    HolderSSN,
    HolderThroughEmployer,
    HolderEmployerName,
    PatientInsuranceStatusID,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    HolderGender,
    HolderAddressLine1,
    HolderAddressLine2,
    HolderCity,
    HolderState,
    HolderCountry,
    HolderZipCode,
    HolderPhone,
    HolderPhoneExt,
    DependentPolicyNumber,
    Notes,
    Phone,
    PhoneExt,
    Fax,
    FaxExt,
    Copay,
    Deductible,
    PatientInsuranceNumber,
    Active,
    PracticeID,
    AdjusterPrefix,
    AdjusterFirstName,
    AdjusterMiddleName,
    AdjusterLastName,
    AdjusterSuffix,
    VendorID,
    VendorImportID,
    InsuranceProgramTypeID,
    GroupName,
    ReleaseOfInformation
)
SELECT DISTINCT
    pc.PatientCaseID,
    icp.InsuranceCompanyPlanID,
    3,                              --ip.Precedence ,
    ip.policynumber3,
    ip.groupnumber3,
    CASE
        WHEN ISDATE(ip.policy3startdate) = 1 THEN
            ip.policy3startdate
        ELSE
            NULL
    END,
    CASE
        WHEN ISDATE(ip.policy3enddate) = 1 THEN
            ip.policy3enddate
        ELSE
            NULL
    END,
    0,                              --ip.CardOnFile ,
    CASE
        WHEN patientrelationship1 = '' THEN
            'S'
        ELSE
            NULL
    END,
    NULL,                           --ip.HolderPrefix ,
    ip.holder3firstname,
    ip.holder3middlename,
    ip.holder3lastname,
    NULL,                           --ip.Holder3Suffix ,
    ip.holder3dateofbirth,
    ip.holder3ssn,
    0,                              --ip.holderthroughemployer ,
    ip.employer3,
    0,                              --ip.PatientInsuranceStatusID ,
    GETDATE(),
    0,
    GETDATE(),
    0,
    ip.holder3gender,
    ip.holder3street1,
    ip.holder3street2,
    ip.holder3city,
    ip.holder3state,
    NULL,                           --ip.HolderCountry ,
    ip.holder3zipcode,
    NULL,                           --ip.HolderPhone ,
    NULL,                           --ip.HolderPhoneExt ,
    ip.policynumber3,
    ip.policy3note,
    NULL,                           --ip.Phone ,
    NULL,                           --ip.PhoneExt ,
    NULL,                           --ip.Fax ,
    NULL,                           --ip.FaxExt ,
    ip.policy3copay,
    ip.policy3deductible,
    NULL,                           --ip.PatientInsuranceNumber , 
    1,                              --ip.active ,
    @TargetPracticeID,
    NULL,                           --ip.AdjusterPrefix ,
    NULL,                           --ip.AdjusterFirstName ,
    NULL,                           --ip.AdjusterMiddleName ,
    NULL,                           --ip.AdjusterLastName ,
    NULL,                           --ip.AdjusterSuffix ,
    ip.chartnumber,                 --ip.InsurancePolicyID ,
    @VendorImportID,
    NULL,                           --ip.insuranceprogramtypeid ,
    LEFT(ip.tertiarygroupname, 14), --ip.GroupName3 ,
    NULL                            --ip.ReleaseOfInformation


	--SELECT * FROM dbo.InsuranceCompanyPlan WHERE InsuranceCompanyPlanID = 23476
	--SELECT * 

--FROM dbo._import_322_137_PatientDemographics ip WHERE ip.policynumber3 <>''
--    INNER JOIN dbo.PatientCase pc
--        ON ip.chartnumber = pc.VendorID 
--           AND pc.VendorImportID = @VendorImportID
--    INNER JOIN dbo.InsuranceCompanyPlan icp
--        ON ip.insurancecode3 = icp.VendorID
--           AND icp.VendorImportID = @VendorImportID
--WHERE ip.insurancecode3 <> 'patient';


FROM dbo._import_322_137_PatientDemographics ip
    INNER JOIN dbo._import_322_137_InsuranceCOMPANYPLANList icpl
        ON ip.insurancecode3 = icpl.insuranceid
    INNER JOIN dbo.PatientCase pc
        ON ip.chartnumber = pc.VendorID
           AND pc.VendorImportID = @VendorImportID
    INNER JOIN dbo.InsuranceCompanyPlan icp
        ON icpl.planname = icp.PlanName
           AND CreatedPracticeID = @TargetPracticeID
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
           AND ipo.PracticeID = @TargetPracticeID --AND ipo.PatientCaseID=pc.PatientCaseID  
           AND policynumber3 = ipo.PolicyNumber
           AND ipo.Precedence = 3
WHERE ip.insurancecode2 <> 'patient';

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';
--rollback

PRINT '';
PRINT 'Inserting Into Doctor...';
INSERT INTO dbo.Doctor
(
    PracticeID,
    Prefix,
    FirstName,
    MiddleName,
    LastName,
    Suffix,
    SSN,
    AddressLine1,
    AddressLine2,
    City,
    State,
    Country,
    ZipCode,
    HomePhone,
    HomePhoneExt,
    WorkPhone,
    WorkPhoneExt,
    PagerPhone,
    PagerPhoneExt,
    MobilePhone,
    MobilePhoneExt,
    DOB,
    EmailAddress,
    Notes,
    ActiveDoctor,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    Degree,
    TaxonomyCode,
    VendorID,
    VendorImportID,
    FaxNumber,
    FaxNumberExt,
    [External],
    NPI,
    ProviderTypeID,
    ProviderPerformanceReportActive,
    ProviderPerformanceScope,
    ProviderPerformanceFrequency,
    ProviderPerformanceDelay,
    ProviderPerformanceCarbonCopyEmailRecipients,
    ExternalBillingID,
    GlobalPayToAddressFlag,
    GlobalPayToName,
    GlobalPayToAddressLine1,
    GlobalPayToAddressLine2,
    GlobalPayToCity,
    GlobalPayToState,
    GlobalPayToZipCode,
    GlobalPayToCountry,
    KareoSpecialtyId
)
SELECT @TargetPracticeID, -- PracticeID - int
       i.prefix,          -- Prefix - varchar(16)
       i.firstname,       -- FirstName - varchar(64)
       i.middleinitial,   -- MiddleName - varchar(64)
       i.lastname,        -- LastName - varchar(64)
       i.suffix,          -- Suffix - varchar(16)
       i.ssn,             -- SSN - varchar(9)
       i.address1,        -- AddressLine1 - varchar(256)
       i.address2,        -- AddressLine2 - varchar(256)
       i.city,            -- City - varchar(128)
       i.state,           -- State - varchar(2)
       NULL,              --i.Country  -- Country - varchar(32)
       i.zip,             -- ZipCode - varchar(9)
       CASE
           WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.homephone)) >= 10 THEN
               LEFT(dbo.fn_RemoveNonNumericCharacters(i.homephone), 10)
           ELSE
               ''
       END,               -- HomePhone - varchar(10)
       NULL,              --i.HomePhoneExt  -- HomePhoneExt - varchar(10)
       CASE
           WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.workphone)) >= 10 THEN
               LEFT(dbo.fn_RemoveNonNumericCharacters(i.workphone), 10)
           ELSE
               ''
       END,               -- WorkPhone - varchar(10)
       NULL,              --i.WorkPhoneExt  -- WorkPhoneExt - varchar(10)
       NULL,              --i.PagerPhone  -- PagerPhone - varchar(10)
       NULL,              --i.PagerPhoneExt  -- PagerPhoneExt - varchar(10)
       i.cellphone,       -- MobilePhone - varchar(10)
       NULL,              --i.MobilePhoneExt  -- MobilePhoneExt - varchar(10)
       i.dateofbirth,     -- DOB - datetime
       i.email,           -- EmailAddress - varchar(256)
       NULL,              --i.Notes , -- Notes - text
       1,                 -- i.ActiveDoctor  -- ActiveDoctor - bit
       GETDATE(),         -- CreatedDate - datetime
       0,                 -- CreatedUserID - int
       GETDATE(),         -- ModifiedDate - datetime
       0,                 -- ModifiedUserID - int
       NULL,              --i.Degree  -- Degree - varchar(8)
       NULL,              --i.TaxonomyCode  -- TaxonomyCode - char(10)
       i.AutoTempID,      -- VendorID - varchar(50)
       @VendorImportID,   -- VendorImportID - int
       i.fax,             -- FaxNumber - varchar(10)
       i.faxext,          -- FaxNumberExt - varchar(10)
       1,                 --i.[External]  -- External - bit
       i.npi,             -- NPI - varchar(10)
       NULL,              --i.ProviderTypeID  -- ProviderTypeID - int
       NULL,              --i.ProviderPerformanceReportActive  -- ProviderPerformanceReportActive - bit
       NULL,              --i.ProviderPerformanceScope  -- ProviderPerformanceScope - int
       NULL,              --i.ProviderPerformanceFrequency  -- ProviderPerformanceFrequency - char(1)
       NULL,              --i.ProviderPerformanceDelay  -- ProviderPerformanceDelay - int
       NULL,              --i.ProviderPerformanceCarbonCopyEmailRecipients , -- ProviderPerformanceCarbonCopyEmailRecipients - varchar(max)
       NULL,              --i.ExternalBillingID , -- ExternalBillingID - varchar(50)
       NULL,              --i.GlobalPayToAddressFlag , -- GlobalPayToAddressFlag - bit
       NULL,              --i.GlobalPayToName , -- GlobalPayToName - varchar(128)
       NULL,              --i.GlobalPayToAddressLine1 , -- GlobalPayToAddressLine1 - varchar(256)
       NULL,              --i.GlobalPayToAddressLine2 , -- GlobalPayToAddressLine2 - varchar(256)
       NULL,              --i.GlobalPayToCity , -- GlobalPayToCity - varchar(128)
       NULL,              --i.GlobalPayToState , -- GlobalPayToState - varchar(2)
       NULL,              --i.GlobalPayToZipCode , -- GlobalPayToZipCode - varchar(9)
       NULL,              --i.GlobalPayToCountry , -- GlobalPayToCountry - varchar(32)
       NULL               --i.KareoSpecialtyId  -- KareoSpecialtyId - int

	--select * 
FROM dbo._import_322_137_ReferringDoctors i 
WHERE --i.PracticeID = @SourcePracticeID  AND
    NOT EXISTS
(
    SELECT *
    FROM dbo.Doctor d
    WHERE d.VendorID = i.AutoTempID
          AND d.PracticeID = @TargetPracticeID
)
    AND i.lastname <> '';
--AND i.lastname<>'kunde'

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';

--PRINT '';
--PRINT 'Inserting into ServiceLocation ...';
--INSERT INTO dbo.ServiceLocation
--(
--    PracticeID,
--    Name,
--    AddressLine1,
--    AddressLine2,
--    City,
--    State,
--    Country,
--    ZipCode,
--    CreatedDate,
--    CreatedUserID,
--    ModifiedDate,
--    ModifiedUserID,
--    PlaceOfServiceCode,
--    BillingName,
--    Phone,
--    PhoneExt,
--    FaxPhone,
--    FaxPhoneExt,
--    HCFABox32FacilityID,
--    CLIANumber,
--    RevenueCode,
--    VendorImportID,
--    VendorID,
--    NPI,
--    FacilityIDType,
--    TimeZoneID,
--    PayToName,
--    PayToAddressLine1,
--    PayToAddressLine2,
--    PayToCity,
--    PayToState,
--    PayToCountry,
--    PayToZipCode,
--    PayToPhone,
--    PayToPhoneExt,
--    PayToFax,
--    PayToFaxExt,
--    EIN,
--    BillTypeID
--)
--SELECT @TargetPracticeID,     -- PracticeID - int
--       i.servicelocationname, -- Name - varchar(128)
--       i.address1,            -- AddressLine1 - varchar(256)
--       i.address2,            -- AddressLine2 - varchar(256)
--       i.city,                -- City - varchar(128)
--       i.state,               -- State - varchar(2)
--       '',                    -- Country - varchar(32)
--       i.zip,                 -- ZipCode - varchar(9)
--       GETDATE(),             -- CreatedDate - datetime
--       0,                     -- CreatedUserID - int
--       GETDATE(),             -- ModifiedDate - datetime
--       0,                     -- ModifiedUserID - int
--       i.placeofservice,      -- PlaceOfServiceCode - char(2)
--       i.billingname,         -- BillingName - varchar(128)
--       i.phone,               -- Phone - varchar(10)
--       NULL,                  -- PhoneExt - varchar(10)
--       i.fax,                 -- FaxPhone - varchar(10)
--       NULL,                  -- FaxPhoneExt - varchar(10)
--       NULL,                  -- HCFABox32FacilityID - varchar(50)
--       NULL,                  -- CLIANumber - varchar(30)
--       0521,                  -- RevenueCode - varchar(4)
--       @VendorImportID,       -- VendorImportID - int
--       i.AutoTempID,          -- VendorID - int
--       i.npi,                 -- NPI - varchar(10)
--       28,                    -- FacilityIDType - int
--       5,                     -- TimeZoneID - int
--       NULL,                  -- PayToName - varchar(60)
--       NULL,                  -- PayToAddressLine1 - varchar(256)
--       NULL,                  -- PayToAddressLine2 - varchar(256)
--       NULL,                  -- PayToCity - varchar(128)
--       NULL,                  -- PayToState - varchar(2)
--       NULL,                  -- PayToCountry - varchar(32)
--       NULL,                  -- PayToZipCode - varchar(9)
--       NULL,                  -- PayToPhone - varchar(10)
--       NULL,                  -- PayToPhoneExt - varchar(10)
--       NULL,                  -- PayToFax - varchar(10)
--       NULL,                  -- PayToFaxExt - varchar(10)
--       NULL,                  -- EIN - varchar(9)
--       NULL                   -- BillTypeID - int
----SELECT * 
--FROM dbo._import_322_137_ServiceLocations i 
--WHERE NOT EXISTS
--(
--    SELECT *
--    FROM dbo.ServiceLocation d 
--    WHERE d.Name = i.servicelocationname
--          AND d.PracticeID = @TargetPracticeID
--);
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';


--PRINT''
--PRINT'Insert Into ContractsAndFees_StandardFeeSchedule...'
--INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
--(
--    PracticeID,
--    Name,
--    Notes,
--    EffectiveStartDate,
--    SourceType,
--    SourceFileName,
--    EClaimsNoResponseTrigger,
--    PaperClaimsNoResponseTrigger,
--    MedicareFeeScheduleGPCICarrier,
--    MedicareFeeScheduleGPCILocality,
--    MedicareFeeScheduleGPCIBatchID,
--    MedicareFeeScheduleRVUBatchID,
--    AddPercent,
--    AnesthesiaTimeIncrement,
--	vendorimportid
--)
--SELECT DISTINCT 
--    @TargetPracticeID,         -- PracticeID - int
--    fs.Name,        -- Name - varchar(128)
--    fs.Notes,        -- Notes - varchar(1024)
--    GETDATE(), -- EffectiveStartDate - datetime
--    fs.SourceType,        -- SourceType - char(1)
--    fs.SourceFileName,        -- SourceFileName - varchar(256)
--    fs.EClaimsNoResponseTrigger,         -- EClaimsNoResponseTrigger - int
--    fs.PaperClaimsNoResponseTrigger,         -- PaperClaimsNoResponseTrigger - int
--    fs.MedicareFeeScheduleGPCICarrier,         -- MedicareFeeScheduleGPCICarrier - int
--    fs.MedicareFeeScheduleGPCILocality,         -- MedicareFeeScheduleGPCILocality - int
--    fs.MedicareFeeScheduleGPCIBatchID,         -- MedicareFeeScheduleGPCIBatchID - int
--    fs.MedicareFeeScheduleRVUBatchID,         -- MedicareFeeScheduleRVUBatchID - int
--    fs.AddPercent,      -- AddPercent - decimal(18, 0)
--    fs.AnesthesiaTimeIncrement,          -- AnesthesiaTimeIncrement - int
--    @vendorimportid
--   --select *  
--FROM dbo.ContractsAndFees_StandardFeeSchedule fs
--WHERE fs.PracticeID=@SourcePracticeID AND fs.Name = 'Standard Fees'
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--PRINT''
--PRINT'Insert Into ContractsAndFees_StandardFee...'
--INSERT INTO dbo.ContractsAndFees_StandardFee
--(
--    StandardFeeScheduleID,
--    ProcedureCodeID,
--    ModifierID,
--    SetFee,
--    AnesthesiaBaseUnits,
--	vendorimportid
--)
--SELECT 
--    (SELECT a.StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule a WHERE a.PracticeID=@TargetPracticeID AND a.Name='Standard Fees'),    -- StandardFeeScheduleID - int
--    sf.ProcedureCodeID,    -- ProcedureCodeID - int
--    sf.ModifierID,    -- ModifierID - int
--    sf.SetFee, -- SetFee - money
--    sf.AnesthesiaBaseUnits,     -- AnesthesiaBaseUnits - int
--    @VendorImportID
----select * 
--FROM dbo.ContractsAndFees_StandardFee sf 
--	INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON sfs.StandardFeeScheduleID=sf.StandardFeeScheduleID
--WHERE sf.StandardFeeScheduleID=sfs.StandardFeeScheduleID AND sfs.PracticeID=@SourcePracticeID

--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--PRINT''
--PRINT'Insert Into ContractsAndFees_StandardFeeScheduleLink...'

--INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
--(
--    ProviderID,
--    LocationID,
--    StandardFeeScheduleID,
--	vendorimportid
--)
--SELECT DISTINCT 
--    doc.doctorid, -- ProviderID - int
--    sl.ServiceLocationID, -- LocationID - int
--    sfs.StandardFeeScheduleID,  -- StandardFeeScheduleID - int
--    @VendorImportID
--FROM dbo.Doctor doc 
--	INNER JOIN dbo.ServiceLocation sl ON sl.practiceid=doc.PracticeID
--	INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON sfs.PracticeID = @TargetPracticeID
--WHERE doc.[External]<>1

--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--rollback
--commit



   