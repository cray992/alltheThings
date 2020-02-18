USE superbill_64394_prod;
GO
--rollback
--commit
SET XACT_ABORT ON;

BEGIN TRANSACTION;

------Run all of the commented out scripts beforehand------------------------------------------------------------


--ALTER TABLE dbo.Appointment ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentToResource ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentReason ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentToAppointmentReason ADD vendorimportid INT 

-----------------------------------------------------------------------------------------------------------------

----Update DOB between DBs----

--UPDATE dp 
--SET dp.DOB = rp.DOB
--FROM superbill_64394_restore.dbo.patient rp 
--INNER JOIN superbill_64394_dev.dbo.Patient dp
--	ON rp.PatientID = dp.PatientID


--Update the existing patients as stated in the description.

--PRINT '';
--PRINT 'Updating existing patient demos...';
--UPDATE p SET 
--p.SSN = replace(ip.ssn,'-',''),
--p.MaritalStatus = ip.marital,
--p.Race = ip.race,
--p.EmailAddress = ip.email,
--p.HomePhone = REPLACE(ip.phone,'-',''),
--p.MobilePhone = REPLACE(ip.mobile,'-','')
----SELECT * 
--FROM dbo._import_2_1_EXISTINGPatientDemographics ip 
--	INNER JOIN dbo.Patient p ON 
--		p.LastName=ip.lastname AND 
--		p.FirstName=ip.firstname AND 
--		--p.AddressLine1=ip.address1 
--		dbo.fn_DateOnly(p.DOB)=CAST(ip.dob AS DATETIME) 


--UPDATE p SET
--p.EmergencyName = ip.emergcontactname,
--p.EmergencyPhone = REPLACE(ip.emerghomephone,'-','')
----SELECT ip.*
--FROM dbo._import_2_1_NEWEmergencyContact ip
--INNER JOIN dbo.Patient p ON
--p.LastName=ip.patientlastname AND
--p.FirstName=ip.patientfirstname AND
--p.AddressLine1=ip.patientaddress1 
	


DECLARE @TargetPracticeID INT;
DECLARE @SourcePracticeID INT;
DECLARE @VendorImportID INT;

SET @TargetPracticeID = 1;
SET @SourcePracticeID = 5;
SET @VendorImportID = 13;

SET NOCOUNT ON;

PRINT 'Source PracticeID = ' + CAST(@SourcePracticeID AS VARCHAR);
PRINT 'Target PracticeID = ' + CAST(@TargetPracticeID AS VARCHAR);
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR);

PRINT '';
PRINT 'Inserting Into Insurance Companies...';

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
    ProviderNumberTypeID,
    GroupNumberTypeID,
    LocalUseProviderNumberTypeID,
    CompanyTextID,
    ClearinghousePayerID,
    CreatedPracticeID,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    KareoInsuranceCompanyID,
    KareoLastModifiedDate,
    SecondaryPrecedenceBillingFormID,
    VendorID,
    VendorImportID,
    DefaultAdjustmentCode,
    ReferringProviderNumberTypeID,
    NDCFormat,
    UseFacilityID,
    AnesthesiaType,
    InstitutionalBillingFormID,
    ICD10Date,
    IsEnrollable
)
SELECT DISTINCT 
    icp.inscompany,        -- InsuranceCompanyName - varchar(128)
    NULL ,        -- Notes - text
    NULL ,        -- AddressLine1 - varchar(256)
    NULL ,        -- AddressLine2 - varchar(256)
    NULL ,        -- City - varchar(128)
    NULL ,        -- State - varchar(2)
    NULL ,        -- Country - varchar(32)
    NULL ,        -- ZipCode - varchar(9)
    NULL ,        -- ContactPrefix - varchar(16)
    NULL ,        -- ContactFirstName - varchar(64)
    NULL ,        -- ContactMiddleName - varchar(64)
    NULL ,        -- ContactLastName - varchar(64)
    NULL ,        -- ContactSuffix - varchar(16)
    NULL ,        -- Phone - varchar(10)
    NULL ,        -- PhoneExt - varchar(10)
    NULL ,        -- Fax - varchar(10)
    NULL ,        -- FaxExt - varchar(10)
    0,      -- BillSecondaryInsurance - bit
    1,      -- EClaimsAccepts - bit
    19,         -- BillingFormID - int
    'CI' ,       -- InsuranceProgramCode - char(2)
    'C' ,        -- HCFADiagnosisReferenceFormatCode - char(1)
    'D',        -- HCFASameAsInsuredFormatCode - char(1)
    NULL ,        -- LocalUseFieldTypeCode - char(5)
    '',        -- ReviewCode - char(1)
    NULL ,         -- ProviderNumberTypeID - int
    NULL ,         -- GroupNumberTypeID - int
    NULL ,         -- LocalUseProviderNumberTypeID - int
    NULL ,       -- CompanyTextID - varchar(10)
    NULL ,         -- ClearinghousePayerID - int
    1,         -- CreatedPracticeID - int
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    0,         -- KareoInsuranceCompanyID - int
    GETDATE(), -- KareoLastModifiedDate - datetime
    19,         -- SecondaryPrecedenceBillingFormID - int
    NULL ,        -- VendorID - varchar(50)
    NULL ,       -- VendorImportID - int
    NULL ,        -- DefaultAdjustmentCode - varchar(10)
    NULL ,         -- ReferringProviderNumberTypeID - int
    0,         -- NDCFormat - int
    1,      -- UseFacilityID - bit
    'U',        -- AnesthesiaType - varchar(1)
    18,         -- InstitutionalBillingFormID - int
    GETDATE(), -- ICD10Date - datetime
    0       -- IsEnrollable - bit
    
	--select * 
FROM dbo._import_2_1_NEWPatientInsurance icp
WHERE NOT EXISTS
(
    SELECT *
    FROM dbo.InsuranceCompany ic
    WHERE ic.InsuranceCompanyName = icp.inscompany
);
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';

PRINT '';
PRINT 'Inserting Into Insurance Company Plans...';

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
    MM_CompanyID,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    ReviewCode,
    CreatedPracticeID,
    Fax,
    FaxExt,
    KareoInsuranceCompanyPlanID,
    KareoLastModifiedDate,
    InsuranceCompanyID,
    ADS_CompanyID,
    Copay,
    Deductible,
    VendorID,
    VendorImportID
)
SELECT DISTINCT 
	   icp.inscompany,          -- PlanName - varchar(128)
       NULL,                  -- AddressLine1 - varchar(256)
       NULL,                  -- AddressLine2 - varchar(256)
       NULL,                  -- City - varchar(128)
       NULL,                  -- State - varchar(2)
       NULL,                  -- Country - varchar(32)
       NULL,                  -- ZipCode - varchar(9)
       NULL,                  -- ContactPrefix - varchar(16)
       NULL,                  -- ContactFirstName - varchar(64)
       NULL,                  -- ContactMiddleName - varchar(64)
       NULL,                  -- ContactLastName - varchar(64)
       NULL,                  -- ContactSuffix - varchar(16)
       NULL,                  -- Phone - varchar(10)
       NULL,                  -- PhoneExt - varchar(10)
       NULL,                  -- Notes - text
       NULL,                  -- MM_CompanyID - varchar(10)
       GETDATE(),             -- CreatedDate - datetime
       0,                     -- CreatedUserID - int
       GETDATE(),             -- ModifiedDate - datetime
       0,                     -- ModifiedUserID - int
       '',                    -- ReviewCode - char(1)
       @TargetPracticeID,     -- CreatedPracticeID - int
       NULL,                  -- Fax - varchar(10)
       NULL,                  -- FaxExt - varchar(10)
       NULL,                  -- KareoInsuranceCompanyPlanID - int
       GETDATE(),             -- KareoLastModifiedDate - datetime
       ic.InsuranceCompanyID, -- InsuranceCompanyID - int
       '',                    -- ADS_CompanyID - varchar(10)
       0.00,                  -- Copay - money
       0.00,                  -- Deductible - money
       '',                    -- VendorID - varchar(50)
       @VendorImportID        -- VendorImportID - int
--select * 
FROM dbo._import_2_1_NEWPatientInsurance icp
    INNER JOIN dbo.InsuranceCompany ic
        ON ic.InsuranceCompanyName = icp.inscompany
WHERE NOT EXISTS
(
    SELECT *
    FROM dbo.InsuranceCompanyPlan icp2
    WHERE icp2.PlanName = icp.inscompany
);
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';



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
    PhonecallRemindersEnabled,
    EmergencyName,
    EmergencyPhone,
    EmergencyPhoneExt,
    --PatientGuid,
    Ethnicity,
    Race,
    LicenseNumber,
    LicenseState,
    Language1,
    Language2,
    ResponsibleDOB,
    ResponsibleSSN
)
SELECT DISTINCT
    @TargetPracticeID,       -- PracticeID - int
    NULL,                    -- ReferringPhysicianID - int
    '', --i.prefix,                -- Prefix - varchar(16)
    i.firstname,             -- FirstName - varchar(64)
    i.middlename,            -- MiddleName - varchar(64)
    i.lastname,              -- LastName - varchar(64)
    '', --i.suffix,                -- Suffix - varchar(16)
    i.address1,          -- AddressLine1 - varchar(256)
    i.address2,          -- AddressLine2 - varchar(256)
    i.city,                  -- City - varchar(128)
    i.state,                 -- State - varchar(2)
    '',                      --i.country,        -- Country - varchar(32)
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN ( 5, 9 ) THEN
            dbo.fn_RemoveNonNumericCharacters(i.zip)
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) = 4 THEN
            '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
        ELSE
            ''
    END,                     -- ZipCode - varchar(9)
    i.gender,                -- Gender - varchar(1)
	i.marital,   -- MaritalStatus - varchar(1)
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) >= 10 THEN
            LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone), 10)
        ELSE
            ''
    END,                     -- HomePhone - varchar(10)
    NULL ,          -- HomePhoneExt - varchar(10)
	NULL,   -- WorkPhone - varchar(10)
    NULL,                    --p.WorkExtension , – WorkPhoneExt - varchar(10)
    i.dob,           -- DOB - datetime
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ssn)) >= 6 THEN
            RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.ssn), 9)
        ELSE
            NULL
    END,                     -- SSN - char(9)
    i.email,          -- EmailAddress - varchar(256)
    CASE
        WHEN i.guarantorlastname = '' THEN
            0
        ELSE
            1
    END,                     -- ResponsibleDifferentThanPatient - bit
    NULL,                    --i.guarantorprefix,        -- ResponsiblePrefix - varchar(16)
    i.guarantorfirstname,    -- ResponsibleFirstName - varchar(64)
    '',   -- ResponsibleMiddleName - varchar(64)
    i.guarantorlastname,     -- ResponsibleLastName - varchar(64)
    '', --i.guarantorsuffix,       -- ResponsibleSuffix - varchar(16)
    r.Relationship,          -- ResponsibleRelationshipToPatient - varchar(1)
    '', --i.guarantoraddressline1, -- ResponsibleAddressLine1 - varchar(256)
    '', --i.guarantoraddressline2, -- ResponsibleAddressLine2 - varchar(256)
    '', --i.guarantorcity,         -- ResponsibleCity - varchar(128)
    '', --i.guarantorstate,        -- ResponsibleState - varchar(2)
    '',                      --i.guarantorcountry,        -- ResponsibleCountry - varchar(32)
    '', --i.guarantorzip,          -- ResponsibleZipCode - varchar(9)
    GETDATE(),               -- CreatedDate - datetime
    0,                       -- CreatedUserID - int
    GETDATE(),               -- ModifiedDate - datetime
    0,                       -- ModifiedUserID - int
    'U',                     -- EmploymentStatus - char(1)
    NULL,                    -- InsuranceProgramCode - char(2)
    NULL,                    -- PatientReferralSourceID - int
    1,                      -- PrimaryProviderID - int
    1,                       -- DefaultServiceLocationID - int
    NULL,                    -- EmployerID - int
    NULL,                    -- MedicalRecordNumber - varchar(128)
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.mobile)) >= 10 THEN
            LEFT(dbo.fn_RemoveNonNumericCharacters(i.mobile), 10)
        ELSE
            ''
    END,                     -- MobilePhone - varchar(10)
    NULL,                    -- MobilePhoneExt - varchar(10)
    NULL,                    -- PrimaryCarePhysicianID - int
    NULL,                    -- VendorID - varchar(50)
    @VendorImportID,         -- VendorImportID - int
    1,                       -- CollectionCategoryID - int
    1, --i.active,                -- Active - bit
    0,                       -- SendEmailCorrespondence - bit
    0,                       -- PhonecallRemindersEnabled - bit
    NULL,                    -- EmergencyName - varchar(128)
    NULL,                    -- EmergencyPhone - varchar(10)
    NULL,                    -- EmergencyPhoneExt - varchar(10)
                             --NULL,      -- PatientGuid - uniqueidentifier
    NULL,                    -- Ethnicity - varchar(64)
    NULL,                    -- Race - varchar(64)
    NULL,                    -- LicenseNumber - varchar(64)
    NULL,                    -- LicenseState - varchar(2)
    NULL,                    -- Language1 - varchar(64)
    NULL,                    -- Language2 - varchar(64)
    NULL,                    -- ResponsibleDOB - datetime
    NULL                     -- ResponsibleSSN - char(9)


	--SELECT * FROM dbo._import_2_1_NEWPatientDemographics WHERE lastname='lewis'
	--SELECT * FROM dbo._import_2_1_NEWPatientInsurance WHERE patientid=9664
----select * 
FROM dbo._import_2_1_NEWPatientDemographics i
    INNER JOIN dbo.Relationship r
        ON r.LongName = i.guarantorrelation
WHERE NOT EXISTS
(
    SELECT *
    FROM dbo.Patient p
    WHERE p.FirstName = i.firstname
          AND p.LastName = i.lastname
		  --AND p.DOB = i.dateofbirth
          AND i.lastname<>''
		  AND p.AddressLine1 = i.address1
);
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';


PRINT '';
PRINT 'Inserting Into Patient Case...';

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
    p.PatientID,        -- PatientID - int
    'Created in Kareo - 3/1/2018', -- Name - varchar(128)
    1, --i.active,           -- Active - bit
    5, --ps.PayerScenarioID, -- PayerScenarioID - int
    NULL,               -- ReferringPhysicianID - int
    0,                  -- EmploymentRelatedFlag - bit
    0,                  -- AutoAccidentRelatedFlag - bit
    0,                  -- OtherAccidentRelatedFlag - bit
    0,                  -- AbuseRelatedFlag - bit
    NULL,               -- AutoAccidentRelatedState - char(2)
    NULL,               -- Notes - text
    0,                  -- ShowExpiredInsurancePolicies - bit
    GETDATE(),          -- CreatedDate - datetime
    0,                  -- CreatedUserID - int
    GETDATE(),          -- ModifiedDate - datetime
    0,                  -- ModifiedUserID - int
    @TargetPracticeID,  -- PracticeID - int
    NULL,               -- CaseNumber - varchar(128)
    NULL,               -- WorkersCompContactInfoID - int
    NULL,               -- VendorID - varchar(50)
    @VendorImportID,    -- VendorImportID - int
    0,                  -- PregnancyRelatedFlag - bit
    1,                  -- StatementActive - bit
    0,                  -- EPSDT - bit
    0,                  -- FamilyPlanning - bit
    NULL,               -- EPSDTCodeID - int
    NULL,               -- EmergencyRelated - bit
    0                   -- HomeboundRelatedFlag - bit
--select * 
FROM dbo._import_2_1_NEWPatientDemographics i
    INNER JOIN Patient p
        ON p.FirstName = i.firstname
           AND p.LastName = i.lastname
		   --AND p.DOB = i.dob
		   AND p.AddressLine1 = i.address1

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';

--SELECT * FROM dbo.PatientCase

PRINT '';
PRINT 'Insert Into Insurance Policy...';

INSERT INTO dbo.InsurancePolicy
(
    --InsurancePolicyID,
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
    SyncWithEHR,
    --InsurancePolicyGuid,
    MedicareFormularyID
)
SELECT DISTINCT ci.PatientCaseID,                     -- PatientCaseID - int
       pl.InsuranceCompanyPlanID,            -- InsuranceCompanyPlanID - int
       1,                                    -- Precedence - int
       icp.policynum,      -- PolicyNumber - varchar(32)
       icp.groupnum, -- GroupNumber - varchar(32)
       GETDATE(),                            -- PolicyStartDate - datetime
       '2025-02-26 12:00:00.000',                            -- PolicyEndDate - datetime
       0,                                    -- CardOnFile - bit
       r.Relationship,                       -- PatientRelationshipToInsured - varchar(1)
       '',                                   -- HolderPrefix - varchar(16)
       i.guarantorfirstname,                 -- HolderFirstName - varchar(64)
       '',                -- HolderMiddleName - varchar(64)
       i.guarantorlastname ,                -- HolderLastName - varchar(64)
       '',--i.guarantorsuffix                    -- HolderSuffix - varchar(16)
       GETDATE(),                            -- HolderDOB - datetime
       '',                                   -- HolderSSN - char(11)
       '',                                   -- HolderThroughEmployer - bit
       '',                                   -- HolderEmployerName - varchar(128)
       0,                                    -- PatientInsuranceStatusID - int
       GETDATE(),                            -- CreatedDate - datetime
       0,                                    -- CreatedUserID - int
       GETDATE(),                            -- ModifiedDate - datetime
       0,                                    -- ModifiedUserID - int
       i.gender,                             -- HolderGender - char(1)
       '', --i.guarantoraddressline1,              -- HolderAddressLine1 - varchar(256)
       '', --i.guarantoraddressline2,              -- HolderAddressLine2 - varchar(256)
       '', --i.guarantorcity,                      -- HolderCity - varchar(128)
       '', --i.guarantorstate,                     -- HolderState - varchar(2)
       '', --i.guarantorcountry,                   -- HolderCountry - varchar(32)
       '', --i.guarantorzip,                       -- HolderZipCode - varchar(9)
       '',                                   -- HolderPhone - varchar(10)
       '',                                   -- HolderPhoneExt - varchar(10)
       NULL,                                 -- DependentPolicyNumber - varchar(32)
       NULL,                                 -- Notes - text
       '', --icp.contactphone,                     -- Phone - varchar(10)
       '', --icp.contactphoneext,                  -- PhoneExt - varchar(10)
       '', --icp.contactfax,                       -- Fax - varchar(10)
       '', --icp.contactfaxext,                    -- FaxExt - varchar(10)
       0.00,                                 -- Copay - money
       0.00,                                 -- Deductible - money
       NULL,                                 -- PatientInsuranceNumber - varchar(32)
       1,                                    -- Active - bit
       1,                    -- PracticeID - int
       NULL,                                 -- AdjusterPrefix - varchar(16)
       NULL,                                 -- AdjusterFirstName - varchar(64)
       NULL,                                 -- AdjusterMiddleName - varchar(64)
       NULL,                                 -- AdjusterLastName - varchar(64)
       NULL,                                 -- AdjusterSuffix - varchar(16)
       NULL,                                 -- VendorID - varchar(50)
       13,                      -- VendorImportID - int
       NULL,                                 -- InsuranceProgramTypeID - int
       NULL,                                 -- GroupName - varchar(14)
       NULL,                                 -- ReleaseOfInformation - varchar(1)
       1,                                    -- SyncWithEHR - bit
                                             --NULL,      -- InsurancePolicyGuid - uniqueidentifier
       NULL                                  -- MedicareFormularyID - int

--select *
FROM dbo._import_2_1_NEWPatientDemographics i 
    INNER JOIN dbo.Patient p
        ON p.FirstName = i.firstname
           AND p.LastName = i.lastname
		   AND p.AddressLine1 = i.address1 
		   --AND p.DOB=i.dateofbirth
    INNER JOIN dbo.PatientCase ci
        ON ci.PatientID = p.PatientID 
    INNER JOIN dbo._import_2_1_NEWPatientInsurance icp ON 
		icp.patientid = i.patientid 
    INNER JOIN dbo.InsuranceCompanyPlan pl
        ON pl.PlanName = icp.inscompany
           AND pl.CreatedPracticeID = 1 
    INNER JOIN dbo.PatientCase pc
        ON pc.PatientID = p.PatientID 
    INNER JOIN dbo.Relationship r
        ON r.LongName = i.guarantorrelation
	LEFT JOIN dbo.InsurancePolicy po 
		ON po.PolicyNumber = icp.policynum
WHERE po.PolicyNumber IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';


--SELECT * FROM 
--dbo._import_2_1_NEWPatientInsurance icp  
--    INNER JOIN dbo.InsuranceCompanyPlan pl
--        ON pl.PlanName = icp.inscompany WHERE icp.inscompany='Harvard Pilgrim HealthCare'
--		--WHERE icp.insuredlastname='lewis'

--		SELECT * FROM dbo.InsuranceCompanyPlan
-----------------------------------------------------------------------------------------------------------------

PRINT '';
PRINT 'Inserting Into Appointments...';
INSERT INTO dbo.Appointment
(
    PatientID,
    PracticeID,
    ServiceLocationID,
    StartDate,
    EndDate,
    AppointmentType,
    Subject,
    Notes,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    AppointmentResourceTypeID,
    AppointmentConfirmationStatusCode,
    Recurrence,
    StartDKPracticeID,
    EndDKPracticeID,
    StartTm,
    EndTm,
    vendorimportid
)

SELECT p.PatientID,
       @TargetPracticeID,                                                                      -- PracticeID - int
       1,                                                                      --sl.ServiceLocationID,  -- ServiceLocationID - int
       i.startdate,                                                            -- StartDate - datetime
       i.EndDate,                                                              -- EndDate - datetime
       'P',                                                                    -- AppointmentType - varchar(1)
       '',                                                                     -- Subject - varchar(64)
       i.apptnotes,                                                                -- Notes - text
       GETDATE(),                                                              -- CreatedDate - datetime
       0,                                                                      -- CreatedUserID - int
       GETDATE(),                                                              -- ModifiedDate - datetime
       0,                                                                      -- ModifiedUserID - int
       1,                                                                      -- AppointmentResourceTypeID - int
       'O',                                   -- AppointmentConfirmationStatusCode - char(1)
       0,
       DK.DKPracticeID,                                                        -- StartDKPracticeID - int
       DK.DKPracticeID,                                                        -- EndDKPracticeID - int
       CAST(LEFT(REPLACE(CAST(i.StartDate AS TIME), ':', ''), 4) AS SMALLINT), --CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
       CAST(LEFT(REPLACE(CAST(i.EndDate AS TIME), ':', ''), 4) AS SMALLINT),   --CAST(REPLACE(RIGHT(i.EndDate,5), ':','') AS SMALLINT)  -- EndTm - smallint
       @VendorImportID
	  --select * 
FROM dbo._import_2_1_NEWPatientAppointments i 
	INNER JOIN dbo._import_2_1_NEWPatientDemographics pd
		ON pd.patientid = i.patientid
    INNER JOIN dbo.Patient p
        ON pd.LastName = p.LastName
           AND pd.FirstName = p.FirstName --AND 
    --	--i.MiddleName = p.MiddleName
    INNER JOIN dbo.DateKeyToPractice DK
        ON DK.PracticeID = @TargetPracticeID
           AND DK.Dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
WHERE p.PracticeID = @TargetPracticeID;
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';


PRINT '';
PRINT 'Inserting Into Appointment to Resource...';
INSERT INTO dbo.AppointmentToResource
(
    AppointmentID,
    AppointmentResourceTypeID,
    ResourceID,
    ModifiedDate,
    PracticeID,
    vendorimportid
)
SELECT DISTINCT
    b.AppointmentID,   -- AppointmentID - int
    1,                 --CASE WHEN i.resource = 'Nurse' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
    d.DoctorID,
    GETDATE(),         -- ModifiedDate - datetime
    @TargetPracticeID, -- PracticeID - int
    @VendorImportID
--SELECT * 
FROM dbo._import_2_1_NEWPatientAppointments i
	INNER JOIN dbo._import_2_1_NEWPatientDemographics pd
		ON pd.patientid = i.patientid
    INNER JOIN dbo.Patient p
        ON p.LastName = pd.LastName
           AND p.FirstName = pd.FirstName 
    INNER JOIN dbo.Appointment b
        ON b.PatientID = p.PatientID
           AND b.StartDate = i.StartDate
           AND p.PracticeID = @TargetPracticeID
    INNER JOIN dbo.Doctor d
        ON d.LastName = i.doctorlastname
           AND d.FirstName = i.doctorfirstname
           AND d.PracticeID = @TargetPracticeID
--WHERE apt.CreatedDate > DATEADD(mi, -3, GETDATE());
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';

PRINT '';
PRINT 'Inserting Appointment Reasons...';

INSERT INTO dbo.AppointmentReason
(
    PracticeID,
    Name,
    DefaultDurationMinutes,
    DefaultColorCode,
    Description,
    ModifiedDate,
    dbo.VendorImportid
)
SELECT DISTINCT
    @TargetPracticeID,         -- PracticeID - int
    ip.facilityname,                   -- Name - varchar(128)
    DATEDIFF(MINUTE,ip.startdate,ip.enddate), -- DefaultDurationMinutes - int
    ar.DefaultColorCode,       -- DefaultColorCode - int
    ar.Description,            -- Description - varchar(256)
    GETDATE(),                 -- ModifiedDate - datetime
    @VendorImportID
--SELECT * 
FROM dbo._import_2_1_NEWPatientAppointments ip
    LEFT JOIN dbo.AppointmentReason ar
        ON ar.Name = ip.apptreason
WHERE ar.Name IS NULL;
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';


PRINT '';
PRINT 'Inserting into Appointment to Appointment Reasons...';

INSERT INTO dbo.AppointmentToAppointmentReason
(
    AppointmentID,
    AppointmentReasonID,
    PrimaryAppointment,
    ModifiedDate,
    PracticeID,
    vendorimportid
)
SELECT DISTINCT
    apt.AppointmentID,      -- AppointmentID - int
    ar.AppointmentReasonID, -- AppointmentReasonID - int
    1,                      -- PrimaryAppointment - bit
    GETDATE(),              -- ModifiedDate - datetime
    @TargetPracticeID,      -- PracticeID - int
    @VendorImportID


--SELECT *
FROM dbo._import_2_1_NEWPatientAppointments i 
	INNER JOIN dbo._import_2_1_NEWPatientDemographics pd
		ON pd.patientid = pd.patientid
    INNER JOIN dbo.Patient p
        ON p.LastName = pd.LastName
           AND p.FirstName = pd.FirstName
           AND p.PracticeID = @TargetPracticeID
    INNER JOIN dbo.Appointment apt
        ON apt.PatientID = p.PatientID
           AND apt.StartDate = i.startdate
           AND apt.EndDate = i.EndDate
    INNER JOIN dbo.AppointmentReason ar
        ON ar.Name = i.apptreason
WHERE p.PracticeID = @TargetPracticeID
      AND apt.CreatedDate > DATEADD(mi, -3, GETDATE());
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';
--rollback
--commit

--------For use only in dev----
--UPDATE dp 
--SET dp.DOB = rp.DOB
--FROM superbill_4873_restore.dbo.patient rp 
--INNER JOIN superbill_4873_dev.dbo.Patient dp
--	ON rp.PatientID = dp.PatientID

--USE superbill_63317_dev
--GO
--UPDATE dp 
--SET dp.DOB = rp.DOB
--FROM superbill_63317_restore.dbo.patient rp 
--INNER JOIN superbill_63317_dev.dbo.Patient dp
--	ON rp.PatientID = dp.PatientID
