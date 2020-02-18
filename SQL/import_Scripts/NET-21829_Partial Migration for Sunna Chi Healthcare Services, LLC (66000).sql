USE superbill_66000_prod;
GO
--rollback
--commit
SET XACT_ABORT ON;

BEGIN TRANSACTION;

--ALTER TABLE dbo._import_2_1_CaseInformation ADD planname VARCHAR(50)
--ALTER TABLE dbo.Appointment ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentToResource ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentReason ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentToAppointmentReason ADD vendorimportid INT 
--ALTER TABLE dbo._import_2_1_Appointments ADD plastname VARCHAR(30),pfirstname VARCHAR(30)
--ALTER TABLE dbo._import_2_1_Appointments ADD appointmentreason VARCHAR(30)

--UPDATE a SET 
--a.plastname=d.LastName,
--a.pfirstname=d.FirstName
--FROM dbo._import_2_1_Appointmenttoresource ar 
--INNER JOIN dbo._import_2_1_Appointments a ON 
--a.appointmentid = ar.appointmentid
--INNER JOIN dbo.Doctor d ON 
--d.DoctorID=ar.resourceid
--UPDATE a SET 
--a.appointmentreason=ar.name
--FROM dbo._import_2_1_Appointments a 
--INNER JOIN dbo._import_2_1_Appointmenttoappointmentreason atar ON 
--atar.AppointmentID = a.appointmentid
--INNER JOIN dbo._import_2_1_AppointmentReason ar ON 
--ar.AppointmentReasonID=atar.appointmentreasonid

DECLARE @TargetPracticeID INT;
DECLARE @SourcePracticeID INT;
DECLARE @VendorImportID INT;

SET @TargetPracticeID = 1;
SET @SourcePracticeID = 1;
SET @VendorImportID = 9;

SET NOCOUNT ON;

PRINT 'Source PracticeID = ' + CAST(@SourcePracticeID AS VARCHAR);
PRINT 'Target PracticeID = ' + CAST(@TargetPracticeID AS VARCHAR);
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR);

SET IDENTITY_INSERT dbo.InsuranceCompany ON;

PRINT '';
PRINT 'Inserting Into Insurance Companies...';

INSERT INTO dbo.InsuranceCompany
(
    InsuranceCompanyID,
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
SELECT DISTINCT ic.insurancecompanyid,
       ic.name,                        -- InsuranceCompanyName - varchar(128)
       '',                             -- Notes - text
       ic.addressline1,                -- AddressLine1 - varchar(256)
       ic.addressline2,                -- AddressLine2 - varchar(256)
       ic.city,                        -- City - varchar(128)
       ic.state,                       -- State - varchar(2)
       ic.country,                     -- Country - varchar(32)
       ic.zipcode,                     -- ZipCode - varchar(9)
       ic.contactprefix,               -- ContactPrefix - varchar(16)
       ic.contactfirstname,            -- ContactFirstName - varchar(64)
       ic.contactmiddlename,           -- ContactMiddleName - varchar(64)
       contactlastname,                -- ContactLastName - varchar(64)
       ic.contactsuffix,               -- ContactSuffix - varchar(16)
       ic.contactphone,                -- Phone - varchar(10)
       ic.contactphoneext,             -- PhoneExt - varchar(10)
       ic.contactfax,                  -- Fax - varchar(10)
       ic.contactfaxext,               -- FaxExt - varchar(10)
       ic.autobillssecondaryinsurance, -- BillSecondaryInsurance - bit
       1,                              -- EClaimsAccepts - bit
       19,                             -- BillingFormID - int
       ip.InsuranceProgramCode,        -- InsuranceProgramCode - char(2)
       'C',                            -- HCFADiagnosisReferenceFormatCode - char(1)
       'D',                            -- HCFASameAsInsuredFormatCode - char(1)
       NULL,                           -- LocalUseFieldTypeCode - char(5)
       '',                             -- ReviewCode - char(1)
       NULL,                           -- ProviderNumberTypeID - int
       NULL,                           -- GroupNumberTypeID - int
       NULL,                           -- LocalUseProviderNumberTypeID - int
       NULL,                           -- CompanyTextID - varchar(10)
       ic.clearinghousepayerid,        -- ClearinghousePayerID - int
       @TargetPracticeID,              -- CreatedPracticeID - int
       GETDATE(),                      -- CreatedDate - datetime
       0,                              -- CreatedUserID - int
       GETDATE(),                      -- ModifiedDate - datetime
       0,                              -- ModifiedUserID - int
       NULL,                           -- KareoInsuranceCompanyID - int
       GETDATE(),                      -- KareoLastModifiedDate - datetime
       19,                             -- SecondaryPrecedenceBillingFormID - int
       NULL,                           -- VendorID - varchar(50)
       @VendorImportID,                -- VendorImportID - int
       NULL,                           -- DefaultAdjustmentCode - varchar(10)
       NULL,                           -- ReferringProviderNumberTypeID - int
       1,                              -- NDCFormat - int
       1,                              -- UseFacilityID - bit
       'U',                            -- AnesthesiaType - varchar(1)
       18,                             -- InstitutionalBillingFormID - int
       GETDATE(),                      -- ICD10Date - datetime
       0                               -- IsEnrollable - bit
--select * 
FROM dbo._import_2_1_InsuranceCompany ic
    INNER JOIN dbo.InsuranceProgram ip
        ON ip.ProgramName = ic.insuranceprogram;
--WHERE NOT EXISTS(SELECT * FROM dbo.InsuranceCompany ic2 WHERE ic2.InsuranceCompanyName=ic.name)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';

SET IDENTITY_INSERT dbo.InsuranceCompany OFF;

UPDATE ip
SET ip.planname = icp.planname
--SELECT icp.planname,* 
FROM dbo._import_2_1_CaseInformation ip
    INNER JOIN _import_2_1_InsuranceCompanyPlan icp
        ON icp.insurancecompanyplanid = ip.primaryinsurancepolicycompanyplanid;

SET IDENTITY_INSERT dbo.InsuranceCompanyPlan ON;

PRINT '';
PRINT 'Inserting Into Insurance Company Plans...';

INSERT INTO dbo.InsuranceCompanyPlan
(	InsuranceCompanyPlanID,
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
	   icp.insurancecompanyplanid,
	   icp.planname,          -- PlanName - varchar(128)
       ic.AddressLine1,                  -- AddressLine1 - varchar(256)
       ic.AddressLine2,                  -- AddressLine2 - varchar(256)
       ic.City,                  -- City - varchar(128)
       ic.State,                  -- State - varchar(2)
       NULL,                  -- Country - varchar(32)
       ic.ZipCode,                  -- ZipCode - varchar(9)
       NULL,                  -- ContactPrefix - varchar(16)
       NULL,                  -- ContactFirstName - varchar(64)
       NULL,                  -- ContactMiddleName - varchar(64)
       NULL,                  -- ContactLastName - varchar(64)
       NULL,                  -- ContactSuffix - varchar(16)
           CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ic.Phone)) >= 10 THEN
            LEFT(dbo.fn_RemoveNonNumericCharacters(ic.Phone), 10)
        ELSE
            ''
		END,                  -- Phone - varchar(10)
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
FROM dbo._import_2_1_InsuranceCompanyPlan icp
    INNER JOIN dbo.InsuranceCompany ic
        ON ic.InsuranceCompanyID = icp.insurancecompanyid
WHERE NOT EXISTS
(
    SELECT *
    FROM dbo.InsuranceCompanyPlan icp2
    WHERE icp2.PlanName = icp.planname
);
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';
SELECT Notes,* FROM dbo.InsuranceCompanyPlan
SET IDENTITY_INSERT dbo.InsuranceCompanyPlan Off;

SET IDENTITY_INSERT dbo.Patient ON ;
PRINT '';
PRINT 'Inserting Into Patient...';

INSERT INTO dbo.Patient
(	PatientID,
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
	i.id,
    @TargetPracticeID,       -- PracticeID - int
    NULL ,                    -- ReferringPhysicianID - int
    i.prefix,                -- Prefix - varchar(16)
    i.firstname,             -- FirstName - varchar(64)
    i.middlename,            -- MiddleName - varchar(64)
    i.lastname,              -- LastName - varchar(64)
    i.suffix,                -- Suffix - varchar(16)
    i.addressline1,          -- AddressLine1 - varchar(256)
    i.addressline2,          -- AddressLine2 - varchar(256)
    i.city,                  -- City - varchar(128)
    i.state,                 -- State - varchar(2)
    '',                      --i.country,        -- Country - varchar(32)
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN ( 5, 9 ) THEN
            dbo.fn_RemoveNonNumericCharacters(i.zipcode)
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) = 4 THEN
            '0' + dbo.fn_RemoveNonNumericCharacters(i.zipcode)
        ELSE
            ''
    END,                     -- ZipCode - varchar(9)
    i.gender,                -- Gender - varchar(1)
    CASE i.maritalstatus
        WHEN 'Never Married' THEN
            'S'
        ELSE
            'U'
    END,                     -- MaritalStatus - varchar(1)
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.homephone)) >= 10 THEN
            LEFT(dbo.fn_RemoveNonNumericCharacters(i.homephone), 10)
        ELSE
            ''
    END,                     -- HomePhone - varchar(10)
    i.homephoneext,          -- HomePhoneExt - varchar(10)
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.workphone)) >= 10 THEN
            LEFT(dbo.fn_RemoveNonNumericCharacters(i.workphone), 10)
        ELSE
            ''
    END,                     -- WorkPhone - varchar(10)
    NULL,                    --p.WorkExtension , – WorkPhoneExt - varchar(10)
    i.dateofbirth,           -- DOB - datetime
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ssn)) >= 6 THEN
            RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.ssn), 9)
        ELSE
            NULL
    END,                     -- SSN - char(9)
    i.emailaddress,          -- EmailAddress - varchar(256)
    CASE
        WHEN i.guarantorlastname = '' THEN
            0
        ELSE
            1
    END,                     -- ResponsibleDifferentThanPatient - bit
    NULL,                    --i.guarantorprefix,        -- ResponsiblePrefix - varchar(16)
    i.guarantorfirstname,    -- ResponsibleFirstName - varchar(64)
    i.guarantormiddlename,   -- ResponsibleMiddleName - varchar(64)
    i.guarantorlastname,     -- ResponsibleLastName - varchar(64)
    i.guarantorsuffix,       -- ResponsibleSuffix - varchar(16)
    			CASE
				WHEN i.guarantorrelationshiptopatient = '' THEN
					0
				ELSE
					1
			
			END,          -- ResponsibleRelationshipToPatient - varchar(1)
    i.guarantoraddressline1, -- ResponsibleAddressLine1 - varchar(256)
    i.guarantoraddressline2, -- ResponsibleAddressLine2 - varchar(256)
    i.guarantorcity,         -- ResponsibleCity - varchar(128)
    i.guarantorstate,        -- ResponsibleState - varchar(2)
    '',                      --i.guarantorcountry,        -- ResponsibleCountry - varchar(32)
    i.guarantorzip,          -- ResponsibleZipCode - varchar(9)
    GETDATE(),               -- CreatedDate - datetime
    0,                       -- CreatedUserID - int
    GETDATE(),               -- ModifiedDate - datetime
    0,                       -- ModifiedUserID - int
    'U',                     -- EmploymentStatus - char(1)
    NULL,                    -- InsuranceProgramCode - char(2)
    NULL,                    -- PatientReferralSourceID - int
    2,                      -- PrimaryProviderID - int
    1,                       -- DefaultServiceLocationID - int
    NULL,                    -- EmployerID - int
    i.medicalrecordnumber,                    -- MedicalRecordNumber - varchar(128)
    CASE
        WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.mobilephone)) >= 10 THEN
            LEFT(dbo.fn_RemoveNonNumericCharacters(i.mobilephone), 10)
        ELSE
            ''
    END,                     -- MobilePhone - varchar(10)
    NULL,                    -- MobilePhoneExt - varchar(10)
    NULL,                    -- PrimaryCarePhysicianID - int
    NULL,                    -- VendorID - varchar(50)
    @VendorImportID,         -- VendorImportID - int
    1,                       -- CollectionCategoryID - int
    i.active,                -- Active - bit
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
----select *
FROM dbo._import_2_1_PatientDemographics i 
    --INNER JOIN dbo.Relationship r
    --    ON r.LongName = i.guarantorrelationshiptopatient
WHERE NOT EXISTS
(
    SELECT *
    FROM dbo.Patient p
    WHERE p.FirstName = i.firstname
          AND p.LastName = i.lastname
--AND p.DOB = i.dateofbirth
);
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';

SET IDENTITY_INSERT dbo.Patient OFF ;
--SELECT * FROM dbo.InsurancePolicy WHERE PolicyNumber='818596641'
--SELECT * FROM dbo.InsuranceCompanyPlan WHERE InsuranceCompanyPlanID=83

SET IDENTITY_INSERT dbo.PatientCase ON ;
PRINT '';
PRINT 'Inserting Into Patient Case...';

INSERT INTO dbo.PatientCase
(  PatientCaseID,
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
	ci.defaultcaseid,
    p.PatientID,        -- PatientID - int
    ci.defaultcasename, -- Name - varchar(128)
    1,           -- Active - bit
    ps.PayerScenarioID, -- PayerScenarioID - int
    NULL,               -- ReferringPhysicianID - int
    0,                  -- EmploymentRelatedFlag - bit
    0,                  -- AutoAccidentRelatedFlag - bit
    0,                  -- OtherAccidentRelatedFlag - bit
    0,                  -- AbuseRelatedFlag - bit
    NULL,               -- AutoAccidentRelatedState - char(2)
    ci.defaultcasedescription,               -- Notes - text
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
--select ci.* 
FROM dbo._import_2_1_CaseInformation ci
	INNER JOIN dbo.Patient p ON 
		p.PatientID = ci.patientid
        
    INNER JOIN dbo.PayerScenario ps
        ON ps.Name = ci.defaultcasepayerscenario
WHERE p.CreatedDate > DATEADD(mi, -1, GETDATE());

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';

SET IDENTITY_INSERT dbo.PatientCase OFF ;

SET IDENTITY_INSERT dbo.InsurancePolicy ON ;

PRINT''
PRINT 'Inserting into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy
        ( InsurancePolicyID,
		  PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          --PolicyStartDate ,
          --PolicyEndDate ,
          ----CardOnFile ,
          PatientRelationshipToInsured ,
          --HolderPrefix ,
          HolderFirstName ,
          --HolderMiddleName ,
          HolderLastName ,
          --HolderSuffix ,
          --HolderDOB ,
          --HolderSSN ,
          --HolderThroughEmployer ,
          --HolderEmployerName ,
          --PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          --HolderGender ,
          --HolderAddressLine1 ,
          --HolderAddressLine2 ,
          --HolderCity ,
          --HolderState ,
          --HolderCountry ,
          --HolderZipCode ,
          --HolderPhone ,
          --HolderPhoneExt ,
          --DependentPolicyNumber ,
          Notes ,
          --Phone ,
          --PhoneExt ,
          --Fax ,
          --FaxExt ,
          Copay ,
          Deductible ,
          --PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          --AdjusterPrefix ,
          --AdjusterFirstName ,
          --AdjusterMiddleName ,
          --AdjusterLastName ,
          --AdjusterSuffix ,
          VendorID ,
          VendorImportID 
          --InsuranceProgramTypeID ,
          --GroupName ,
          --ReleaseOfInformation 
		  )

		  --SELECT * FROM dbo.Relationship

SELECT 
		  ip.InsurancePolicyID,
          pc.PatientCaseID ,
          icp.insurancecompanyplanid ,
          ip.Precedence ,
          ip.PolicyNumber ,
          ip.GroupNumber ,
    --      CASE WHEN ISDATE(ip.PolicyStartDate) = 1 THEN ip.policystartdate ELSE NULL END ,
    --      CASE WHEN ISDATE(ip.PolicyEndDate) = 1 THEN ip.policyenddate ELSE NULL END ,
    --      --ip.CardOnFile ,
	--ip.patientrelationshiptoinsured,
		   CASE WHEN ip.patientrelationshiptoinsured='S'
				THEN 'S'
				ELSE 'U'
		   END ,                      -- PatientRelationshipToInsured - varchar(1)
          --ip.HolderPrefix ,
          ip.HolderFirstName ,
          --ip.HolderMiddleName ,
          ip.HolderLastName ,
          --ip.HolderSuffix ,
          --CAST(ip.HolderDOB AS DATETIME),
          --ip.HolderSSN ,
          --ip.holderthroughemployer  ,
          --ip.HolderEmployerName ,
          --ip.PatientInsuranceStatusID ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          --ip.HolderGender ,
          --ip.HolderAddressLine1 ,
          --ip.HolderAddressLine2 ,
          --ip.HolderCity ,
          --ip.HolderState ,
          --ip.HolderCountry ,
          --ip.HolderZipCode ,
          --ip.HolderPhone ,
          --ip.HolderPhoneExt ,
          --ip.DependentPolicyNumber ,
          ip.Notes ,
          --ip.Phone ,
          --ip.PhoneExt ,
          --ip.Fax ,
          --ip.FaxExt ,
          ip.Copay ,
          ip.Deductible ,
          --ip.PatientInsuranceNumber ,
          ip.active  ,
          @TargetPracticeID ,
          --ip.AdjusterPrefix ,
          --ip.AdjusterFirstName ,
          --ip.AdjusterMiddleName ,
          --ip.AdjusterLastName ,
          --ip.AdjusterSuffix ,
          ip.InsurancePolicyID ,
          @VendorImportID 
          --ip.insuranceprogramtypeid ,
          --ip.GroupName ,
          --ip.ReleaseOfInformation 

	--SELECT * 
FROM dbo._import_2_1_inspolicytable ip
	INNER JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = ip.patientcaseid 
	INNER JOIN dbo.InsuranceCompanyPlan icp
        ON icp.InsuranceCompanyPlanID = ip.insurancecompanyplanid
WHERE PatientRelationshipToInsured<>'1'


PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.InsurancePolicy OFF ;


------------------------------------------------------------------------


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
       i.notes,                                                                -- Notes - text
       GETDATE(),                                                              -- CreatedDate - datetime
       0,                                                                      -- CreatedUserID - int
       GETDATE(),                                                              -- ModifiedDate - datetime
       0,                                                                      -- ModifiedUserID - int
       1,                                                                      -- AppointmentResourceTypeID - int
       cs.AppointmentConfirmationStatusCode,                                   -- AppointmentConfirmationStatusCode - char(1)
       0,
       DK.DKPracticeID,                                                        -- StartDKPracticeID - int
       DK.DKPracticeID,                                                        -- EndDKPracticeID - int
       CAST(LEFT(REPLACE(CAST(i.StartDate AS TIME), ':', ''), 4) AS SMALLINT), --CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
       CAST(LEFT(REPLACE(CAST(i.EndDate AS TIME), ':', ''), 4) AS SMALLINT),   --CAST(REPLACE(RIGHT(i.EndDate,5), ':','') AS SMALLINT)  -- EndTm - smallint
       @VendorImportID
--SELECT * 
FROM _import_2_1_appointments i
    INNER JOIN dbo.Patient p
		ON p.PatientID = i.patientid AND i.patientid IS NOT NULL 
        --ON i.LastName = p.LastName
        --   AND i.FirstName = p.FirstName --AND 
    --	--i.MiddleName = p.MiddleName
    INNER JOIN dbo.DateKeyToPractice DK
        ON DK.PracticeID = 1
           AND DK.Dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
    --INNER JOIN dbo.ServiceLocation sl ON 
    --	sl.ServiceLocationID = i.servicelocationid AND 
    --	sl.PracticeID=2 
    INNER JOIN dbo.AppointmentConfirmationStatus cs
        ON cs.AppointmentConfirmationStatusCode = i.AppointmentConfirmationStatusCode
WHERE p.PracticeID = 1 AND 
		 --ISNUMERIC(i.AppointmentID)=1 AND 
		 i.patientid IS NOT NULL 
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
    2,--d.DoctorID,
    GETDATE(),         -- ModifiedDate - datetime
    @TargetPracticeID, -- PracticeID - int
    @VendorImportID
--SELECT * 
FROM dbo._import_2_1_Appointments i
    INNER JOIN dbo.Patient p
		ON p.PatientID = i.patientid
        --ON p.LastName = i.LastName
        --   AND p.FirstName = i.FirstName --AND 
    --p.DOB=i.dob
    INNER JOIN dbo.Appointment b
        ON b.PatientID = p.PatientID
           AND b.StartDate = i.StartDate
           AND p.PracticeID = @TargetPracticeID
    --INNER JOIN dbo.Doctor d
    --    ON d.LastName = i.plastname
    --       AND d.FirstName = i.pfirstname
    --       AND d.PracticeID = @TargetPracticeID
WHERE b.CreatedDate > DATEADD(mi, -1, GETDATE());
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
    ip.Name,                   -- Name - varchar(128)
    ar.DefaultDurationMinutes, -- DefaultDurationMinutes - int
    ar.DefaultColorCode,       -- DefaultColorCode - int
    ar.Description,            -- Description - varchar(256)
    GETDATE(),                 -- ModifiedDate - datetime
    @VendorImportID
--SELECT * 
FROM dbo._import_2_1_appointmentreason ip
    LEFT JOIN dbo.AppointmentReason ar
        ON ar.Name = ip.Name
           AND ar.PracticeID = @TargetPracticeID
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

--SELECT * FROM dbo.AppointmentReason WHERE PracticeID=2
--SELECT *
FROM dbo._import_2_1_Appointments imp
    INNER JOIN dbo.Patient p
		ON p.PatientID = imp.patientid
        --ON imp.LastName = p.LastName
        --   AND imp.FirstName = p.FirstName
           AND
        --imp.MiddleName = p.MiddleName AND
        p.PracticeID = @TargetPracticeID
    INNER JOIN dbo.Appointment apt
        ON apt.PatientID = p.PatientID
           AND apt.StartDate = imp.StartDate
           AND apt.EndDate = imp.EndDate
    INNER JOIN dbo.AppointmentReason ar
        ON ar.Name = imp.appointmentreason
WHERE p.PracticeID = @TargetPracticeID
      AND apt.CreatedDate > DATEADD(mi, -1, GETDATE());
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';
--rollback
--commit
