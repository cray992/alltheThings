USE superbill_66154_dev
GO
SET XACT_ABORT ON;

BEGIN TRANSACTION;
--rollback
--commit 

UPDATE a SET 
p.VendorID = ip.chartnumber
FROM dbo._import_1_1_PatientDemographics ip
	INNER JOIN patient p ON 
		p.LastName = ip.lastname AND 
		p.FirstName = ip.firstname
	


--ALTER TABLE dbo.InsuranceCompany ADD vendorimportid INT 

DECLARE @TargetPracticeID INT;
DECLARE @SourcePracticeID INT;
DECLARE @VendorImportID INT;

SET @TargetPracticeID = 1
SET @VendorImportID = 13

SET NOCOUNT ON;
--SELECT * FROM dbo._import_1_1_InsuranceCOMPANYPLANList
--SELECT * FROM dbo._import_1_1_PatientDemographics

--SELECT * FROM dbo.InsuranceCompany
--SELECT * FROM dbo.InsuranceCompanyPlan ORDER BY PlanName

PRINT''
PRINT'Inserting into InsuranceCompany...'

SET IDENTITY_INSERT dbo.InsuranceCompany ON 

INSERT INTO dbo.InsuranceCompany
(	InsuranceCompanyID,
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
	i.insuranceid,
    i.insurancecompanyname,        -- InsuranceCompanyName - varchar(128)
    i.notes,        -- Notes - text
    '',        -- AddressLine1 - varchar(256)
    '',        -- AddressLine2 - varchar(256)
    '',        -- City - varchar(128)
    '',        -- State - varchar(2)
    '',        -- Country - varchar(32)
    '',        -- ZipCode - varchar(9)
    '',        -- ContactPrefix - varchar(16)
    '',        -- ContactFirstName - varchar(64)
    '',        -- ContactMiddleName - varchar(64)
    '',        -- ContactLastName - varchar(64)
    '',        -- ContactSuffix - varchar(16)
    '',        -- Phone - varchar(10)
    '',        -- PhoneExt - varchar(10)
    '',        -- Fax - varchar(10)
    '',        -- FaxExt - varchar(10)
    0,      -- BillSecondaryInsurance - bit
    1,      -- EClaimsAccepts - bit
    19,         -- BillingFormID - int
    'CI',        -- InsuranceProgramCode - char(2)
    'C',        -- HCFADiagnosisReferenceFormatCode - char(1)
    'D',        -- HCFASameAsInsuredFormatCode - char(1)
    '',        -- LocalUseFieldTypeCode - char(5)
    '',        -- ReviewCode - char(1)
    NULL ,         -- ProviderNumberTypeID - int
    NULL ,         -- GroupNumberTypeID - int
    NULL ,         -- LocalUseProviderNumberTypeID - int
    NULL ,        -- CompanyTextID - varchar(10)
    ic2.ClearinghousePayerID,         -- ClearinghousePayerID - int
    1,         -- CreatedPracticeID - int
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    NULL ,         -- KareoInsuranceCompanyID - int
    GETDATE(), -- KareoLastModifiedDate - datetime
    19,         -- SecondaryPrecedenceBillingFormID - int
    '',        -- VendorID - varchar(50)
    @VendorImportID ,         -- VendorImportID - int
    null,        -- DefaultAdjustmentCode - varchar(10)
    NULL ,         -- ReferringProviderNumberTypeID - int
    1,         -- NDCFormat - int
    1,      -- UseFacilityID - bit
    'U',        -- AnesthesiaType - varchar(1)
    18,         -- InstitutionalBillingFormID - int
    GETDATE(), -- ICD10Date - datetime
    0       -- IsEnrollable - bit


--SELECT * 
FROM dbo._import_1_1_InsuranceCOMPANYPLANList i
    LEFT JOIN dbo.InsuranceCompany IC2
        ON i.insurancecompanyname = IC2.InsuranceCompanyName
           AND IC2.CreatedPracticeID = 1
WHERE IC2.InsuranceCompanyName IS NULL
      AND i.insurancecompanyname <> '';
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted ';



SET IDENTITY_INSERT dbo.InsuranceCompany OFF 

--SELECT * FROM dbo.InsuranceCompany
SET IDENTITY_INSERT dbo.InsuranceCompanyPlan ON 

PRINT''
PRINT'Inserting into InsuranceCompanyPlan...'

INSERT INTO dbo.InsuranceCompanyPlan
(	
InsuranceCompanyPlanID,
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
	ic.InsuranceCompanyID,
    i.planname,        -- PlanName - varchar(128)
    i.address1,        -- AddressLine1 - varchar(256)
    i.address2,        -- AddressLine2 - varchar(256)
    i.city,        -- City - varchar(128)
    i.state,        -- State - varchar(2)
    '',        -- Country - varchar(32)
    i.zip,        -- ZipCode - varchar(9)
    '',        -- ContactPrefix - varchar(16)
    '',        -- ContactFirstName - varchar(64)
    '',        -- ContactMiddleName - varchar(64)
    '',        -- ContactLastName - varchar(64)
    '',        -- ContactSuffix - varchar(16)
    '',        -- Phone - varchar(10)
    '',        -- PhoneExt - varchar(10)
    '',        -- Notes - text
    '',        -- MM_CompanyID - varchar(10)
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    '',        -- ReviewCode - char(1)
    0,         -- CreatedPracticeID - int
    '',        -- Fax - varchar(10)
    '',        -- FaxExt - varchar(10)
    0,         -- KareoInsuranceCompanyPlanID - int
    GETDATE(), -- KareoLastModifiedDate - datetime
    ic.InsuranceCompanyID,         -- InsuranceCompanyID - int
    '',        -- ADS_CompanyID - varchar(10)
    0.00,      -- Copay - money
    0.00,      -- Deductible - money
    '',        -- VendorID - varchar(50)
    13         -- VendorImportID - int
   
--SELECT * 
FROM dbo._import_1_1_InsuranceCOMPANYPLANList i
    INNER JOIN dbo.InsuranceCompany ic
        ON i.insuranceid = ic.InsuranceCompanyID AND ic.VendorImportID = 13
    LEFT JOIN dbo.InsuranceCompanyPlan a
        ON i.insuranceid = a.InsuranceCompanyPlanID
WHERE a.InsuranceCompanyPlanID IS NULL AND ic.VendorImportID =13;

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted ';
--SELECT * FROM dbo.InsuranceCompanyPlan
SET IDENTITY_INSERT dbo.InsuranceCompanyPlan OFF 

PRINT''
PRINT'Insert into PatientCase...'

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
    p.PatientID,         -- PatientID - int
    '',        -- Name - varchar(128)
    1,      -- Active - bit
    5,         -- PayerScenarioID - int
    NULL ,         -- ReferringPhysicianID - int
    0,      -- EmploymentRelatedFlag - bit
    0,      -- AutoAccidentRelatedFlag - bit
    0,      -- OtherAccidentRelatedFlag - bit
    0,      -- AbuseRelatedFlag - bit
    NULL ,        -- AutoAccidentRelatedState - char(2)
    '',        -- Notes - text
    0,      -- ShowExpiredInsurancePolicies - bit
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    1,         -- PracticeID - int
    NULL ,        -- CaseNumber - varchar(128)
    NULL ,         -- WorkersCompContactInfoID - int
    NULL ,        -- VendorID - varchar(50)
    @VendorImportID,         -- VendorImportID - int
    0,      -- PregnancyRelatedFlag - bit
    1,      -- StatementActive - bit
    0,      -- EPSDT - bit
    0,      -- FamilyPlanning - bit
    NULL ,         -- EPSDTCodeID - int
    NULL,      -- EmergencyRelated - bit
    0       -- HomeboundRelatedFlag - bit
--select * 
FROM dbo.Patient p 
	LEFT JOIN dbo.PatientCase pc ON pc.patientid = p.PatientID AND pc.VendorImportID = @VendorImportID
WHERE  (pc.PatientID IS NULL OR pc.PatientCaseID IS NULL) 
		
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
----SELECT * FROM dbo.PatientCase
----SELECT * FROM dbo._import_1_1_PatientDemographics
----SELECT * FROM dbo._import_1_1_InsuranceCOMPANYPLANList
----SELECT * FROM dbo.InsuranceCompany
----SELECT * FROM dbo.PayerScenario
----SELECT * FROM dbo.InsuranceProgram

PRINT''
PRINT'Inserting into InsurancePolicy...'

SET IDENTITY_INSERT dbo.InsurancePolicy ON 

INSERT INTO dbo.InsurancePolicy
(
	InsurancePolicyID,
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
SELECT DISTINCT 
	icp.InsuranceCompanyPlanID,
	pc.PatientCaseID,
    ip.insurancecode1,
    1,              --ip.Precedence ,
    LEFT(ip.policynumber1, 32),
    LEFT(ip.groupnumber1, 32),
	GETDATE(),
    --CASE
    --    WHEN ISDATE(ip.policy1startdate) = 1 THEN
    --        ip.policy1startdate
    --    ELSE
    --        NULL
    --END,
	GETDATE()+800,
    --CASE
    --    WHEN ISDATE(ip.policy1enddate) = 1 THEN
    --        ip.policy1enddate
    --    ELSE
    --        NULL
    --END,
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
    CASE ip.holder1gender
	WHEN 'Male' THEN 'M'
	WHEN 'Female' THEN 'F'
	ELSE '' END 
	,
    ip.holder1street1,
    ip.holder1street2,
    ip.holder1city,
    ip.holder1state,
    NULL,           --ip.HolderCountry ,
    ip.holder1zipcode,
    NULL,           --ip.HolderPhone ,
    NULL,           --ip.HolderPhoneExt ,
    REPLACE(REPLACE(ip.policynumber1,'-',''),' ',''),
    ip.policy1note,
    NULL,           --ip.Phone ,
    NULL,           --ip.PhoneExt ,
    NULL,           --ip.Fax ,
    NULL,           --ip.FaxExt ,
    ip.policy1copay,
    ip.policy1deductible,
    NULL,           --ip.PatientInsuranceNumber ,
    1,              --ip.active ,
    1,
    NULL,           --ip.AdjusterPrefix ,
    NULL,           --ip.AdjusterFirstName ,
    NULL,           --ip.AdjusterMiddleName ,
    NULL,           --ip.AdjusterLastName ,
    NULL,           --ip.AdjusterSuffix ,
    NULL , --ip.InsurancePolicyID ,
    13,
    NULL,           --ip.insuranceprogramtypeid ,
    LEFT(ip.groupnumber1, 14),
    NULL,           --ip.ReleaseOfInformation
    1               --syncwithehr (primary case flag)
--SELECT ip.policynumber1, * 
FROM dbo.Patient p
	INNER JOIN dbo._import_1_1_PatientDemographics ip ON 
		ip.chartnumber = p.VendorID
		--ip.lastname = p.LastName AND 
		--ip.firstname = p.FirstName AND 
		--ip.addressline1 = p.AddressLine1 AND 
		--ip.city = p.City
	INNER JOIN dbo._import_1_1_InsuranceCOMPANYPLANList icpl ON 
		icpl.insuranceid = ip.insurancecode1
	INNER JOIN dbo.PatientCase pc ON 
		pc.PatientID = p.PatientID AND 
        pc.VendorImportID = 13
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.InsuranceCompanyPlanID = icpl.insuranceid
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.PolicyNumber = ip.policynumber1
           AND ipo.PatientCaseID = pc.PatientCaseID
           AND ip.policynumber1 = ipo.PolicyNumber
WHERE ipo.PolicyNumber IS NULL



PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted ';



SET IDENTITY_INSERT dbo.InsurancePolicy OFF 


