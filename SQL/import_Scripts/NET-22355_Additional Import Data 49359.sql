USE superbill_49359_prod
GO
--SELECT * FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = 23
SET XACT_ABORT ON 
SET NOCOUNT ON 
BEGIN TRAN
--rollback
--commit
DECLARE @practiceid INT 
DECLARE @vendorimportid INT
--SELECT * FROM dbo.InsuranceCompany 
--ALTER TABLE dbo.Appointment ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentReason ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentToResource ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentToAppointmentReason ADD vendorimportid INT 

SET @practiceid= 23
SET @vendorimportid= 33

PRINT''
PRINT'Inserting into Insurance Company...'

SET IDENTITY_INSERT dbo.InsuranceCompany ON 

INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyID,
    InsuranceCompanyName,
    Notes,
    BillSecondaryInsurance,
    EClaimsAccepts,
    BillingFormID,
    InsuranceProgramCode,
    HCFADiagnosisReferenceFormatCode,
    HCFASameAsInsuredFormatCode,
    LocalUseFieldTypeCode,
    ReviewCode,
    ClearinghousePayerID,
    CreatedPracticeID,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    SecondaryPrecedenceBillingFormID,
    VendorID,
    VendorImportID,
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
    0,      -- BillSecondaryInsurance - bit
    1,      -- EClaimsAccepts - bit
    19,         -- BillingFormID - int
    'CI',        -- InsuranceProgramCode - char(2)
    'C',        -- HCFADiagnosisReferenceFormatCode - char(1)
    'D',        -- HCFASameAsInsuredFormatCode - char(1)
    NULL,         -- LocalUseFieldTypeCode - char(5)
    '',        -- ReviewCode - char(1)
    '',         -- ClearinghousePayerID - int
    @practiceid,         -- CreatedPracticeID - int
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    19,         -- SecondaryPrecedenceBillingFormID - int
    '',        -- VendorID - varchar(50)
    @vendorimportid,         -- VendorImportID - int
    1,         -- NDCFormat - int
    1,      -- UseFacilityID - bit
    'U',        -- AnesthesiaType - varchar(1)
    18,         -- InstitutionalBillingFormID - int
    GETDATE(), -- ICD10Date - datetime
    NULL       -- IsEnrollable - bit
     
--SELECT i.* 
FROM dbo._import_10_23_InsuranceCOMPANYPLANList i
	--LEFT JOIN dbo.InsuranceCompany ic ON 
	--	ic.InsuranceCompanyName = i.insurancecompanyname

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

SET IDENTITY_INSERT dbo.InsuranceCompany OFF 

PRINT''
PRINT'Inserting into Insurance Company Plans...'

SET IDENTITY_INSERT dbo.InsuranceCompanyPlan ON 

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
    Notes,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    ReviewCode,
    CreatedPracticeID,
    Fax,
    FaxExt,
    KareoLastModifiedDate,
    InsuranceCompanyID,
    Copay,
    Deductible,
    VendorID,
    VendorImportID
)
SELECT 
	i.insuranceid,
    i.planname,        -- PlanName - varchar(128)
    i.address1,        -- AddressLine1 - varchar(256)
    i.address2,        -- AddressLine2 - varchar(256)
    i.city,        -- City - varchar(128)
    i.state,        -- State - varchar(2)
    '',        -- Country - varchar(32)
    i.zip,        -- ZipCode - varchar(9)
    i.notes,        -- Notes - text
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    '',        -- ReviewCode - char(1)
    23,         -- CreatedPracticeID - int
    i.fax,        -- Fax - varchar(10)
    i.faxext,        -- FaxExt - varchar(10)
    GETDATE(), -- KareoLastModifiedDate - datetime
    ic.InsuranceCompanyID,         -- InsuranceCompanyID - int
    0.00,      -- Copay - money
    0.00,      -- Deductible - money
    '',        -- VendorID - varchar(50)
    33         -- VendorImportID - int
--	select * 

--FROM dbo._import_10_23_InsuranceCOMPANYPLANList i
--INNER JOIN dbo.InsuranceCompany IC ON 
--	IC.InsuranceCompanyID = (SELECT max(InsuranceCompanyID) FROM dbo.InsuranceCompany 
--									WHERE i.InsuranceCompanyName = InsuranceCompanyName AND
--										  (ReviewCode = 'R' OR CreatedPracticeID = 23))
--LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
--	icp.PlanName = i.planname
--WHERE icp.PlanName IS NULL AND 

FROM dbo._import_10_23_InsuranceCOMPANYPLANList i
	INNER JOIN dbo.InsuranceCompany ic ON 
		ic.InsuranceCompanyID = i.insuranceid AND ic.CreatedPracticeID = 23
WHERE PlanName<>'' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'
SELECT * FROM dbo.InsurancePolicy
SET IDENTITY_INSERT dbo.InsuranceCompanyPlan OFF 
--SET IDENTITY_INSERT dbo.InsurancePolicy ON 

PRINT '';
PRINT 'Inserting into InsurancePolicy ...';
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
    SyncWithEHR
)
SELECT DISTINCT 
	--ip.insurancecode1,
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
    23,
    NULL,           --ip.AdjusterPrefix ,
    NULL,           --ip.AdjusterFirstName ,
    NULL,           --ip.AdjusterMiddleName ,
    NULL,           --ip.AdjusterLastName ,
    NULL,           --ip.AdjusterSuffix ,
    ip.chartnumber, --ip.InsurancePolicyID ,
    33,
    NULL,           --ip.insuranceprogramtypeid ,
    LEFT(ip.groupnumber1, 14),
    NULL,           --ip.ReleaseOfInformation
    1               --syncwithehr (primary case flag)
--select distinct  ip.* 
FROM dbo._import_10_23_PatientDemographics ip 
    INNER JOIN dbo._import_10_23_InsuranceCOMPANYPLANList icpl
        ON ip.insurancecode1 = icpl.insuranceid
	INNER JOIN dbo.Patient p ON 
		p.LastName = ip.lastname AND 
		p.FirstName = ip.firstname AND 
		p.PracticeID = 23
     INNER JOIN dbo.PatientCase pc
        ON ip.chartnumber = pc.VendorID AND 
         p.PatientID = pc.PatientID AND pc.PracticeID = 23
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.InsuranceCompanyPlanID = ip.insurancecode1--icp.InsuranceCompanyPlanID
           AND ipo.PracticeID = 23
           AND ipo.PatientCaseID = pc.PatientCaseID
           AND ip.policynumber1 = ipo.PolicyNumber
WHERE ipo.PolicyNumber IS NULL;



--SET IDENTITY_INSERT dbo.InsurancePolicy OFF 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';

PRINT '';
PRINT 'Inserting into InsurancePolicy 2 ...';
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
    ip.insurancecode2,
    2,              --ip.Precedence ,
    LEFT(ip.policynumber2, 32),
    LEFT(ip.groupnumber2, 32),
	GETDATE(),
	GETDATE()+800,
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
    ip.employer2,
    0,              --ip.PatientInsuranceStatusID ,
    GETDATE(),
    0,
    GETDATE(),
    0,
    CASE ip.holder2gender
	WHEN 'Male' THEN 'M'
	WHEN 'Female' THEN 'F'
	ELSE '' END 
	,
    ip.holder2street1,
    ip.holder2street2,
    ip.holder2city,
    ip.holder2state,
    NULL,           --ip.HolderCountry ,
    ip.holder2zipcode,
    NULL,           --ip.HolderPhone ,
    NULL,           --ip.HolderPhoneExt ,
    REPLACE(REPLACE(ip.policynumber2,'-',''),' ',''),
    ip.policy2note,
    NULL,           --ip.Phone ,
    NULL,           --ip.PhoneExt ,
    NULL,           --ip.Fax ,
    NULL,           --ip.FaxExt ,
    ip.policy2copay,
    ip.policy2deductible,
    NULL,           --ip.PatientInsuranceNumber ,
    1,              --ip.active ,
    23,
    NULL,           --ip.AdjusterPrefix ,
    NULL,           --ip.AdjusterFirstName ,
    NULL,           --ip.AdjusterMiddleName ,
    NULL,           --ip.AdjusterLastName ,
    NULL,           --ip.AdjusterSuffix ,
    ip.chartnumber, --ip.InsurancePolicyID ,
    9,
    NULL,           --ip.insuranceprogramtypeid ,
    LEFT(ip.groupnumber2, 14),
    NULL,           --ip.ReleaseOfInformation
    1               --syncwithehr (primary case flag)
--select distinct  ip.* 
FROM dbo._import_10_23_PatientDemographics ip
    INNER JOIN dbo._import_10_23_InsuranceCOMPANYPLANList icpl
        ON ip.insurancecode2 = icpl.insuranceid
	INNER JOIN dbo.Patient p ON 
		p.VendorID = ip.chartnumber AND p.PracticeID = 23
    INNER JOIN dbo.PatientCase pc
        ON p.PatientID = pc.PatientID AND pc.PracticeID = 23
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.InsuranceCompanyPlanID = ip.insurancecode2--icp.InsuranceCompanyPlanID
           AND ipo.PracticeID = 23
           AND ipo.PatientCaseID = pc.PatientCaseID
           AND policynumber2 = ipo.PolicyNumber
--WHERE ipo.InsurancePolicyID IS NULL;

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';

PRINT '';
PRINT 'Inserting into InsurancePolicy 3 ...';
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
    ip.insurancecode3,
    3,              --ip.Precedence ,
    LEFT(ip.policynumber3, 32),
    LEFT(ip.groupnumber3, 32),
	GETDATE(),
	GETDATE()+800,
    0,              --ip.CardOnFile ,
    CASE
        WHEN patientrelationship3 = '' THEN
            'S'
        ELSE
            NULL
    END,
    NULL,           --ip.HolderPrefix ,
    ip.holder3firstname,
    ip.holder3middlename,
    ip.holder3lastname,
    NULL,           --ip.Holder1Suffix ,
    ip.holder3dateofbirth,
    ip.holder3ssn,
    0,              --ip.holderthroughemployer ,
    ip.employer3,
    0,              --ip.PatientInsuranceStatusID ,
    GETDATE(),
    0,
    GETDATE(),
    0,
    CASE ip.holder3gender
	WHEN 'Male' THEN 'M'
	WHEN 'Female' THEN 'F'
	ELSE '' END 
	,
    ip.holder3street1,
    ip.holder3street2,
    ip.holder3city,
    ip.holder3state,
    NULL,           --ip.HolderCountry ,
    ip.holder3zipcode,
    NULL,           --ip.HolderPhone ,
    NULL,           --ip.HolderPhoneExt ,
    REPLACE(REPLACE(ip.policynumber1,'-',''),' ',''),
    ip.policy3note,
    NULL,           --ip.Phone ,
    NULL,           --ip.PhoneExt ,
    NULL,           --ip.Fax ,
    NULL,           --ip.FaxExt ,
    ip.policy3copay,
    ip.policy3deductible,
    NULL,           --ip.PatientInsuranceNumber ,
    1,              --ip.active ,
    23,
    NULL,           --ip.AdjusterPrefix ,
    NULL,           --ip.AdjusterFirstName ,
    NULL,           --ip.AdjusterMiddleName ,
    NULL,           --ip.AdjusterLastName ,
    NULL,           --ip.AdjusterSuffix ,
    ip.chartnumber, --ip.InsurancePolicyID ,
    9,
    NULL,           --ip.insuranceprogramtypeid ,
    LEFT(ip.groupnumber3, 14),
    NULL,           --ip.ReleaseOfInformation
    1               --syncwithehr (primary case flag)
--select distinct  ip.* 
FROM dbo._import_10_23_PatientDemographics ip
    INNER JOIN dbo._import_10_23_InsuranceCOMPANYPLANList icpl
        ON ip.insurancecode3 = icpl.insuranceid
	INNER JOIN dbo.Patient p ON 
		p.VendorID = ip.chartnumber AND p.PracticeID = 23
    INNER JOIN dbo.PatientCase pc
        ON p.PatientID = pc.PatientID AND pc.PracticeID = 23
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.InsuranceCompanyPlanID = ip.insurancecode3--icp.InsuranceCompanyPlanID
           AND ipo.PracticeID = 23
           AND ipo.PatientCaseID = pc.PatientCaseID
           AND policynumber3 = ipo.PolicyNumber
--WHERE ipo.InsurancePolicyID IS NULL;

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';

--PRINT ''
--PRINT 'Inserting Into Appointments...'
--INSERT INTO dbo.Appointment
--        ( PatientID,
--          PracticeID ,
--          ServiceLocationID ,
--          StartDate ,
--          EndDate ,
--          AppointmentType ,
--          Subject ,
--          Notes ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          AppointmentResourceTypeID ,
--          AppointmentConfirmationStatusCode ,
--		  Recurrence,
--          StartDKPracticeID ,
--          EndDKPracticeID ,
--          StartTm ,
--          EndTm,
--		  vendorimportid
--        )
--SELECT DISTINCT
--		  p.PatientID,
--          23 , -- PracticeID - int
--          sl.ServiceLocationID,  -- ServiceLocationID - int
--          i.startdate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentstarttime , -- StartDate - datetime
--          i.enddate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentendtime,  -- EndDate - datetime
--          'P' , -- AppointmentType - varchar(1)
--          '' , -- Subject - varchar(64)
--          i.reasons , -- Notes - text
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          1 , -- AppointmentResourceTypeID - int

--          CASE i.status
--			WHEN 'cancelled' THEN 'X'
--			WHEN 'check-In' THEN 'I'
--			WHEN 'confirmed' THEN 'C'
--			WHEN 'no-show' THEN 'N'
--			WHEN 'rescheduled' THEN 'R'
--			WHEN 'scheduled' THEN 'S'
--			WHEN '' THEN 'S'
--			ELSE'' END , -- AppointmentConfirmationStatusCode - char(1)
--		  0,
--          dk.DKPracticeID , -- StartDKPracticeID - int
--          dk.DKPracticeID , -- EndDKPracticeID - int
--          CAST(LEFT(REPLACE(CAST(i.startdate AS TIME),':',''),4) AS SMALLINT), -- StartTm - smallint
--          CAST(LEFT(REPLACE(CAST(i.enddate AS TIME),':',''),4) AS SMALLINT),  -- EndTm - smallint
--		  9
--		  --SELECT *
--FROM _import_10_23_PatientAppointments i
--	INNER JOIN dbo._import_10_23_PatientDemographics d ON 
--		d.chartnumber = i.chartnumber
--	INNER JOIN dbo.Patient p ON 
--		d.LastName = p.LastName AND 
--		d.FirstName = p.FirstName --AND 
--	INNER JOIN dbo.DateKeyToPractice DK ON
--		DK.PracticeID = 23 AND
--		DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
--	INNER JOIN dbo.ServiceLocation sl ON
--		sl.ServiceLocationID = 43
--WHERE p.PracticeID = 23 
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT ''
--PRINT 'Inserting Into Appointment to Resource...'
--INSERT INTO dbo.AppointmentToResource
--        ( AppointmentID ,
--          AppointmentResourceTypeID ,
--          ResourceID ,
--          ModifiedDate ,
--          PracticeID
--        )
--SELECT DISTINCT	
--		  a.AppointmentID , -- AppointmentID - int
--          1, -- AppointmentResourceTypeID - int
--          CASE i.doctorlastname
--			WHEN 'griffin' THEN 468 
--			WHEN 'cook' THEN 469
--			WHEN 'faught' THEN 470
--			WHEN 'mar' THEN 507
--			ELSE '' END ,-- ResourceID - int
--          GETDATE(),  -- ModifiedDate - datetime
--          23  -- PracticeID - int
--	--SELECT *
--FROM _import_10_23_PatientAppointments i 
--	INNER JOIN dbo._import_10_23_PatientDemographics pd ON 
--		pd.chartnumber = i.chartnumber 
--	INNER JOIN dbo.Patient p ON 
--		p.VendorID = pd.chartnumber
--	INNER JOIN dbo.Appointment a ON 
--		a.StartDate = i.startdate AND 
--		a.EndDate = i.enddate AND 
--		a.PatientID = p.PatientID AND 
--		a.PracticeID = 23 
--		WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT ''
--PRINT 'Inserting Appointment Reasons...'

--INSERT INTO dbo.AppointmentReason
--(
--    PracticeID,
--    Name,
--    DefaultDurationMinutes,
--    DefaultColorCode,
--    Description,
--    ModifiedDate

--)
--SELECT DISTINCT 
--    23,         -- PracticeID - int
--    ip.servicelocationname,        -- Name - varchar(128)
--    DATEDIFF(MINUTE,ip.startdate,ip.enddate),         -- DefaultDurationMinutes - int
--    null,      -- DefaultColorCode - int
--    '',        -- Description - varchar(256)
--    GETDATE() -- ModifiedDate - datetime
--	--SELECT *
--FROM _import_10_23_PatientAppointments ip
--LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.reasons
----AND ar.PracticeID = 23
--WHERE ar.name IS NULL 

--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT''
--PRINT'Inserting into Appointment to Appointment Reasons...'

--INSERT INTO dbo.AppointmentToAppointmentReason
--(
--    AppointmentID,
--    AppointmentReasonID,
--    PrimaryAppointment,
--    ModifiedDate,
--    PracticeID
--)

--SELECT DISTINCT a.AppointmentID, 
--MIN(ar.AppointmentReasonID) AS AppointmentReasonID, 
--1 ,
--GETDATE() ,
--23 AS PracticeID
----select * 
--FROM _import_10_23_PatientAppointments iapt
--	INNER JOIN dbo._import_10_23_PatientDemographics pd ON 
--		pd.chartnumber = iapt.chartnumber
--	INNER JOIN dbo.Patient p ON 
--		p.VendorID = pd.chartnumber
--	INNER JOIN dbo.Appointment a ON 
--		a.PatientID = p.PatientID AND 
--		a.StartDate = iapt.startdate
--	INNER JOIN dbo.AppointmentReason ar ON 
--		ar.Name = iapt.reasons
--WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
--GROUP BY a.AppointmentID

--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
