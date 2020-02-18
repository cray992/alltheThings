USE superbill_58672_dev
GO 
SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit 

DECLARE @TargetPracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 61
SET @VendorImportID = 11

SET NOCOUNT ON

--INSERT INTO dbo.Patient
--(
--    PracticeID,
--    ReferringPhysicianID,
--    Prefix,
--    FirstName,
--    MiddleName,
--    LastName,
--    Suffix,
--    AddressLine1,
--    AddressLine2,
--    City,
--    State,
--    Country,
--    ZipCode,
--    Gender,
--    MaritalStatus,
--    HomePhone,
--    HomePhoneExt,
--    WorkPhone,
--    WorkPhoneExt,
--    DOB,
--    SSN,
--    EmailAddress,
--    ResponsibleDifferentThanPatient,
--    ResponsiblePrefix,
--    ResponsibleFirstName,
--    ResponsibleMiddleName,
--    ResponsibleLastName,
--    ResponsibleSuffix,
--    ResponsibleRelationshipToPatient,
--    ResponsibleAddressLine1,
--    ResponsibleAddressLine2,
--    ResponsibleCity,
--    ResponsibleState,
--    ResponsibleCountry,
--    ResponsibleZipCode,
--    CreatedDate,
--    CreatedUserID,
--    ModifiedDate,
--    ModifiedUserID,
--    EmploymentStatus,
--    InsuranceProgramCode,
--    PatientReferralSourceID,
--    PrimaryProviderID,
--    DefaultServiceLocationID,
--    EmployerID,
--    MedicalRecordNumber,
--    MobilePhone,
--    MobilePhoneExt,
--    PrimaryCarePhysicianID,
--    VendorID,
--    VendorImportID,
--    CollectionCategoryID,
--    Active,
--    SendEmailCorrespondence,
--    PhonecallRemindersEnabled,
--    EmergencyName,
--    EmergencyPhone,
--    EmergencyPhoneExt
--   -- PatientGuid,
--)

SELECT DISTINCT 
    @TargetPracticeID,         -- PracticeID - int
    NULL ,         -- ReferringPhysicianID - int
    NULL ,        -- Prefix - varchar(16)
    p.firstname,        -- FirstName - varchar(64)
    p.middleinitial,        -- MiddleName - varchar(64)
    p.lastname,        -- LastName - varchar(64)
    p.suffix,        -- Suffix - varchar(16)
    p.address1,        -- AddressLine1 - varchar(256)
    p.address2,        -- AddressLine2 - varchar(256)
    p.city,        -- City - varchar(128)
    p.state,        -- State - varchar(2)
    NULL ,        -- Country - varchar(32)
    p.zipcode,        -- ZipCode - varchar(9)
    p.gender,        -- Gender - varchar(1)
    p.maritalstatus,        -- MaritalStatus - varchar(1)
    p.homephone,        -- HomePhone - varchar(10)
    NULL ,        -- HomePhoneExt - varchar(10)
    p.workphone,        -- WorkPhone - varchar(10)
    p.workextension,        -- WorkPhoneExt - varchar(10)
    p.dateofbirth, -- DOB - datetime
    p.ssn,        -- SSN - char(9)
    p.email,        -- EmailAddress - varchar(256)
    NULL,      -- ResponsibleDifferentThanPatient - bit
    '',        -- ResponsiblePrefix - varchar(16)
    p.responsiblepartyfirstname,        -- ResponsibleFirstName - varchar(64)
    p.responsiblepartymiddlename,        -- ResponsibleMiddleName - varchar(64)
    p.responsiblepartylastname,        -- ResponsibleLastName - varchar(64)
    p.responsiblepartysuffix,        -- ResponsibleSuffix - varchar(16)
    p.responsiblepartyrelationship,        -- ResponsibleRelationshipToPatient - varchar(1)
    p.responsiblepartyaddress1,        -- ResponsibleAddressLine1 - varchar(256)
    p.responsiblepartyaddress2,        -- ResponsibleAddressLine2 - varchar(256)
    p.responsiblepartycity,        -- ResponsibleCity - varchar(128)
    p.responsiblepartystate,        -- ResponsibleState - varchar(2)
    '',        -- ResponsibleCountry - varchar(32)
    p.responsiblepartyzipcode,        -- ResponsibleZipCode - varchar(9)
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    NULL ,        -- EmploymentStatus - char(1)
    NULL ,        -- InsuranceProgramCode - char(2)
    NULL ,         -- PatientReferralSourceID - int
    NULL ,         -- PrimaryProviderID - int
    NULL ,         -- DefaultServiceLocationID - int
    NULL ,         -- EmployerID - int
    p.chartnumber,        -- MedicalRecordNumber - varchar(128)
    p.cellphone,        -- MobilePhone - varchar(10)
    NULL ,        -- MobilePhoneExt - varchar(10)
    NULL ,         -- PrimaryCarePhysicianID - int
    p.chartnumber,        -- VendorID - varchar(50)
    @VendorImportID,         -- VendorImportID - int
    1,         -- CollectionCategoryID - int
    1,      -- Active - bit
    1,      -- SendEmailCorrespondence - bit
    0,      -- PhonecallRemindersEnabled - bit
    p.emergencyname,        -- EmergencyName - varchar(128)
    p.emergencyphone,        -- EmergencyPhone - varchar(10)
    p.emergencyphoneext       -- EmergencyPhoneExt - varchar(10)
    --NULL,      -- PatientGuid - uniqueidentifier
--SELECT * 
FROM dbo._import_11_61_PatientDemographics p
WHERE
NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.Dob = p.dateofbirth AND pp.PracticeID = @TargetPracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--SELECT * FROM dbo.Patient
--SELECT * FROM dbo._import_11_61_PatientDemographics