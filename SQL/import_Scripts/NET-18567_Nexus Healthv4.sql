USE superbill_63463_prod
GO
--UPDATE a SET 
--npi=''
--FROM dbo._import_330_185_ReferringDoctors a WHERE a.lastname = 'galpin'

--SELECT * FROM [dbo].[_import_330_185_PatientDemographics] WHERE lastname = 'hirst'
--UPDATE d SET 
--d.state=''
----SELECT * 
--FROM [dbo].[_import_330_185_PatientDemographics] d WHERE lastname = 'hirst' AND chartnumber = 'MDSuite-5250'

--SELECT * FROM dbo.InsurancePolicy WHERE PracticeID = 137 and precedence = 3
--SELECT * FROM dbo.PatientCase WHERE practiceid = 137 AND PatientCaseID = 766196
--SELECT * FROM dbo.Patient WHERE PatientID = 760810

SET XACT_ABORT ON;

BEGIN TRANSACTION;
--rollback
--commit 

--330_185

DECLARE @TargetPracticeID INT;
DECLARE @SourcePracticeID INT;
DECLARE @VendorImportID INT;

SET @TargetPracticeID = 185
SET @SourcePracticeID = 6
SET @VendorImportID = 330
 

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
FROM dbo._import_330_185_InsuranceCOMPANYPLANList i
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

FROM dbo._import_330_185_InsuranceCOMPANYPLANList i
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

--SELECT * 
FROM dbo._import_330_185_InsuranceCOMPANYPLANList i
    INNER JOIN dbo.InsuranceCompany ic
        ON i.insurancecompanyname = ic.InsuranceCompanyName
           AND
        --ic.VendorImportID =@VendorImportID AND -- @VendorImportID 
        ic.CreatedPracticeID = @TargetPracticeID --@targetpracticeid 
    LEFT JOIN dbo.InsuranceCompanyPlan a
        ON i.planname = a.PlanName
           AND a.CreatedPracticeID = @TargetPracticeID
WHERE a.PlanName IS NULL;

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted ';
--rollback

--rollback
--commit



   