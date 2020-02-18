USE superbill_58672_dev
GO 
SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit 

DECLARE @TargetPracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 61
SET @VendorImportID = 16

SET NOCOUNT ON

--ALTER TABLE dbo.Appointment
--ADD vendorimportid INT 

--ALTER TABLE dbo._import_13_61_PatientAppointments
--ADD apptduration DATETIME 

------------------------------------
--Update DOB between DBsó FOR Dev Use

--UPDATE dp 
--SET dp.DOB = rp.DOB
--FROM superbill_58672_dev_v2.dbo.patient rp 
--INNER JOIN superbill_58672_dev.dbo.Patient dp
--	ON rp.PatientID = dp.PatientID

------------------------------------

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
(
InsuranceCompanyName ,
Notes ,
AddressLine1 ,
AddressLine2 ,
City ,
State ,
Country ,
ZipCode ,
ContactPrefix ,
ContactFirstName ,
ContactMiddleName ,
ContactLastName ,
ContactSuffix ,
Phone ,
PhoneExt ,
Fax ,
FaxExt ,
BillSecondaryInsurance ,
EClaimsAccepts ,
BillingFormID ,
InsuranceProgramCode ,
HCFADiagnosisReferenceFormatCode ,
HCFASameAsInsuredFormatCode ,
LocalUseFieldTypeCode ,
ReviewCode ,
CompanyTextID ,
ClearinghousePayerID ,
CreatedPracticeID ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
SecondaryPrecedenceBillingFormID ,
VendorID ,
VendorImportID ,
--DefaultAdjustmentCode ,
ReferringProviderNumberTypeID ,
NDCFormat ,
UseFacilityID ,
AnesthesiaType ,
InstitutionalBillingFormID
)

SELECT Distinct

i.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
NULL,--ic.notes , -- Notes - text
NULL, --i.address1 , -- AddressLine1 - varchar(256)
NULL, --NULL, --i.address2 , -- AddressLine2 - varchar(256)
NULL, --i.city , -- City - varchar(128)
NULL, --i.state , -- State - varchar(2)
NULL, --i.country , -- Country - varchar(32)
NULL, --LEFT(CASE 
--WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
--WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
--ELSE '' END,9) , -- ZipCode - varchar(9)
NULL, --ic.contactprefix , -- ContactPrefix - varchar(16)
NULL, --ic.contactfirstname , -- ContactFirstName - varchar(64)
NULL, --ic.contactmiddlename , -- ContactMiddleName - varchar(64)
NULL, --ic.contactlastname , -- ContactLastName - varchar(64)
NULL, --ic.contactsuffix , -- ContactSuffix - varchar(16)
NULL, --CASE
--WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone),10)
--ELSE '' END , -- HomePhone - varchar(10)
NULL, --i.phoneext , -- PhoneExt - varchar(10)
NULL, --i.fax , -- Fax - varchar(10)
NULL, --i.faxext , -- FaxExt - varchar(10)
'',-- , -- BillSecondaryInsurance - bit
'' , -- EClaimsAccepts - bit
'' , -- BillingFormID - int
'CI' , -- InsuranceProgramCode - char(2)
'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
'D' , -- HCFASameAsInsuredFormatCode - char(1)
NULL, --ic.localusefieldtypecode , -- LocalUseFieldTypeCode - char(5)
'' , -- ReviewCode - char(1)''
NULL, --ic.companytextid , -- CompanyTextID - varchar(10)
NULL , -- ClearinghousePayerID - int
@TargetPracticeID , -- CreatedPracticeID - int
GETDATE() , -- CreatedDate - datetime
0 , -- CreatedUserID - int
GETDATE() , -- ModifiedDate - datetime
0 , -- ModifiedUserID - int
'', --ic.secondaryprecedencebillingformid , -- SecondaryPrecedenceBillingFormID - int
LEFT(i.insurancecompanyname,50) , -- VendorID - varchar(50)
@VendorImportID , -- VendorImportID - int
--ic.defaultAdjustmentCode , -- DefaultAdjustmentCode - varchar(10)
NULL, --ic.referringprovidernumbertypeid , -- ReferringProviderNumberTypeID - int
1 , -- NDCFormat - int
1 , -- UseFacilityID - bit
'', --ic.anesthesiatype , -- AnesthesiaType - varchar(1)
NULL --ic.institutionalbillingformid -- InstitutionalBillingFormID - int

--select * 
FROM dbo._import_13_61_InsuranceCOMPANYPLANList i 
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE ic.InsuranceCompanyName = i.InsuranceCompanyName AND
														 (ic.ReviewCode = 'R' OR ic.CreatedPracticeID = @TargetPracticeID))
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

--rollback
PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
(
PlanName ,
AddressLine1 ,
AddressLine2 ,
City ,
State ,
Country ,
ZipCode ,
ContactPrefix ,
ContactFirstName ,
ContactMiddleName ,
ContactLastName ,
ContactSuffix ,
Phone ,
PhoneExt ,
Notes ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
--ReviewCode ,
CreatedPracticeID ,
Fax ,
FaxExt ,
KareoInsuranceCompanyPlanID ,
KareoLastModifiedDate ,
InsuranceCompanyID ,
Copay ,
Deductible ,
VendorID ,
VendorImportID
)
SELECT
DISTINCT	
i.PlanName ,
i.Address1 ,
i.Address2 ,
i.City ,
i.State ,
NULL, --i.Country ,
CASE 
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(I.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(I.zip)
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(I.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(I.zip)
ELSE '' END,
NULL, --i.ContactPrefix ,
i.ContactFirstName ,
NULL, --i.ContactMiddleName ,
i.ContactLastName ,
NULL, --i.ContactSuffix ,
CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) > 10 THEN
LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.phone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.phone))),10)
ELSE NULL END  ,
i.PhoneExt ,
i.Notes ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
--i.ReviewCode ,
@TargetPracticeID,
CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.fax)) > 10 THEN
LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.fax),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.fax))),10)
ELSE NULL END ,
i.FaxExt ,
NULL, --i.KareoInsuranceCompanyPlanID ,
NULL, --CASE WHEN ISDATE(i.KareoLastModifiedDate) = 1 THEN i.kareolastmodifieddate ELSE NULL END ,
ic.InsuranceCompanyID ,
0 , --copay
0 , --deductible
i.Insuranceid ,
@VendorImportID

--SELECT * 
FROM dbo._import_13_61_InsuranceCOMPANYPLANList i
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE i.InsuranceCompanyName = InsuranceCompanyName AND
										  (ReviewCode = 'R' OR CreatedPracticeID = 61))
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.PlanName = i.planname
WHERE icp.PlanName IS NULL 
	

									

PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

	  --SELECT * FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID=61 AND CreatedDate>'2018-01-23 01:47:43.097'ORDER BY PlanName


PRINT''
PRINT'Inserting into Patient...'

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
    EmergencyPhoneExt
   -- PatientGuid,
)

SELECT DISTINCT 
    @TargetPracticeID,         -- PracticeID - int
    NULL ,         -- ReferringPhysicianID - int
    '' ,        -- Prefix - varchar(16)
    p.firstname,        -- FirstName - varchar(64)
    p.middleinitial,        -- MiddleName - varchar(64)
    p.lastname,        -- LastName - varchar(64)
    p.suffix,        -- Suffix - varchar(16)
    p.address1,        -- AddressLine1 - varchar(256)
    p.address2,        -- AddressLine2 - varchar(256)
    p.city,        -- City - varchar(128)
    p.state,        -- State - varchar(2)
    NULL ,        -- Country - varchar(32)
    LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(p.zipcode)) IN (5,9) 
		THEN dbo.fn_RemoveNonNumericCharacters(p.zipcode)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(p.zipcode)) = 4 
		THEN '0' + dbo.fn_RemoveNonNumericCharacters(p.zipcode)
		ELSE '' END,9) , -- ZipCode - varchar(9),        -- ZipCode - varchar(9)
    p.gender,        -- Gender - varchar(1)
    CASE p.maritalstatus
		WHEN 'Married' THEN 'M'
		WHEN 'Single' THEN 'S'
		ELSE ''
		end,        -- MaritalStatus - varchar(1)
    CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(p.homephone)) >= 10 
		THEN LEFT(dbo.fn_RemoveNonNumericCharacters(p.homephone),10)
		ELSE '' END , -- HomePhone - varchar(10),        -- HomePhone - varchar(10)
    NULL ,        -- HomePhoneExt - varchar(10)
    CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(p.workphone)) >= 10 
		THEN LEFT(dbo.fn_RemoveNonNumericCharacters(p.workphone),10)
		ELSE '' END , -- HomePhone - varchar(10),        -- WorkPhone - varchar(10)
    p.workextension,        -- WorkPhoneExt - varchar(10)
    p.dateofbirth, -- DOB - datetime
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.ssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(P.SSN), 9)
		ELSE NULL END , -- SSN - char(9),        -- SSN - char(9)
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
    LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(p.responsiblepartyzipcode)) IN (5,9) 
		THEN dbo.fn_RemoveNonNumericCharacters(p.responsiblepartyzipcode)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(p.responsiblepartyzipcode)) = 4 
		THEN '0' + dbo.fn_RemoveNonNumericCharacters(p.responsiblepartyzipcode)
		ELSE '' END,9) , -- ZipCode - varchar(9),        -- ResponsibleZipCode - varchar(9)
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
    CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(p.cellphone)) >= 10 
		THEN LEFT(dbo.fn_RemoveNonNumericCharacters(p.cellphone),10)
		ELSE '' END , -- HomePhone - varchar(10),        -- MobilePhone - varchar(10)
    NULL ,        -- MobilePhoneExt - varchar(10)
    NULL ,         -- PrimaryCarePhysicianID - int
    p.chartnumber,        -- VendorID - varchar(50)
    @VendorImportID,         -- VendorImportID - int
    1,         -- CollectionCategoryID - int
    1,      -- Active - bit
    1,      -- SendEmailCorrespondence - bit
    0,      -- PhonecallRemindersEnabled - bit
    p.emergencyname,        -- EmergencyName - varchar(128)
    CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(p.emergencyphone)) >= 10 
		THEN LEFT(dbo.fn_RemoveNonNumericCharacters(p.emergencyphone),10)
		ELSE '' END,        -- EmergencyPhone - varchar(10)
    p.emergencyphoneext       -- EmergencyPhoneExt - varchar(10)
    --NULL,      -- PatientGuid - uniqueidentifier
--SELECT * 
FROM dbo._import_13_61_PatientDemographics p
WHERE
NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.Dob = p.dateofbirth AND pp.PracticeID = @TargetPracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT''
PRINT'Inserting into PatientCase...'

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
    CASE 
	WHEN pc.policynumber1 <> '' THEN 'Default Case'
	ELSE 'Self Pay'
	END ,        -- Name - varchar(128)
    p.Active,      -- Active - bit
    CASE 
	WHEN pc.policynumber1 = '' THEN 5
	ELSE 11 
	END ,         -- PayerScenarioID - int
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
    61,         -- PracticeID - int
    NULL ,        -- CaseNumber - varchar(128)
    NULL ,         -- WorkersCompContactInfoID - int
    pc.chartnumber,        -- VendorID - varchar(50)
    @VendorImportID,         -- VendorImportID - int
    0,      -- PregnancyRelatedFlag - bit
    1,      -- StatementActive - bit
    0,      -- EPSDT - bit
    0,      -- FamilyPlanning - bit
    1,         -- EPSDTCodeID - int
    0,      -- EmergencyRelated - bit
    0       -- HomeboundRelatedFlag - bit
     
--select * 
FROM dbo._import_13_61_PatientDemographics pc
INNER JOIN dbo.Patient p ON
pc.chartnumber = p.VendorID AND
p.VendorImportID = @VendorImportID
--left JOIN dbo.PayerScenario ps ON pc.financialclass=ps.Name
--WHERE p.PatientID=271552
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--UPDATE a SET
--a.PlanName = 'HealthSCOPE Benefits 2'
--FROM dbo.InsuranceCompanyPlan a 
--WHERE a.InsuranceCompanyPlanID = 5906
--UPDATE a SET
--a.PlanName = 'United Healthcare 2'
--FROM dbo.InsuranceCompanyPlan a 
--WHERE a.InsuranceCompanyPlanID = 5865
--UPDATE a SET
--a.PlanName = 'United Healthcare 3'
--FROM dbo.InsuranceCompanyPlan a 
--WHERE a.InsuranceCompanyPlanID = 5866
--commit
--SELECT * FROM dbo.InsuranceCompany ORDER BY InsuranceCompanyName
--SELECT * FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID=61 ORDER BY PlanName

----------------Policy 1----------------------
PRINT ''
PRINT 'Inserting into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy
(
PatientCaseID ,
InsuranceCompanyPlanID ,
Precedence ,
PolicyNumber ,
GroupNumber ,
PolicyStartDate ,
PolicyEndDate ,
CardOnFile ,
PatientRelationshipToInsured,
HolderPrefix ,
HolderFirstName ,
HolderMiddleName ,
HolderLastName ,
HolderSuffix ,
HolderDOB ,
HolderSSN ,
HolderThroughEmployer ,
HolderEmployerName ,
PatientInsuranceStatusID ,
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
--HolderZipCode ,
HolderPhone ,
HolderPhoneExt ,
PracticeID ,
--AdjusterPrefix ,
--AdjusterFirstName ,
--AdjusterMiddleName ,
--AdjusterLastName ,
--AdjusterSuffix ,
VendorID ,
VendorImportID ,
InsuranceProgramTypeID ,
--GroupName ,
ReleaseOfInformation, 
SyncWithEHR
)
SELECT
DISTINCT

pc.PatientCaseID ,
icp.InsuranceCompanyPlanID ,
1, --ip.Precedence ,
ip.policynumber1 ,
LEFT(ip.GroupNumber1,32) ,
CASE WHEN ISDATE(ip.Policy1StartDate) = 1 THEN ip.policy1startdate ELSE NULL END ,
CASE WHEN ISDATE(ip.Policy1EndDate) = 1 THEN ip.policy1enddate ELSE NULL END ,
0, --ip.CardOnFile ,
CASE WHEN  PatientRelationship1 ='' THEN 'S' ELSE NULL END ,
NULL, --ip.HolderPrefix ,
ip.Holder1FirstName ,
ip.Holder1MiddleName ,
ip.Holder1LastName ,
NULL, --ip.Holder1Suffix ,
CAST(ip.dateofbirth AS DATETIME),
ip.Holder1SSN ,
0, --ip.holderthroughemployer ,
ip.Employer1 ,
0, --ip.PatientInsuranceStatusID ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
ip.holder1Gender ,
ip.holder1street1 ,
ip.holder1street2 ,
ip.Holder1City ,
ip.Holder1State ,
NULL, --ip.HolderCountry ,
--ip.Holder1ZipCode ,
NULL, --ip.HolderPhone ,
NULL, --ip.HolderPhoneExt ,
@TargetPracticeID,
--NULL, --ip.AdjusterPrefix ,
--NULL, --ip.AdjusterFirstName ,
--NULL, --ip.AdjusterMiddleName ,
--NULL, --ip.AdjusterLastName ,
--NULL, --ip.AdjusterSuffix ,
ip.chartnumber, --ip.InsurancePolicyID ,
@VendorImportID ,
NULL, --ip.insuranceprogramtypeid ,
 --LEFT(ip.primaryGroupName,14) ,
NULL, --ip.ReleaseOfInformation
1 --syncwithehr (primary case flag)
--rollback
--select * 
FROM dbo.Patient p 
INNER JOIN dbo.PatientCase pc ON pc.PatientID = p.PatientID 
INNER JOIN dbo._import_13_61_PatientDemographics ip ON ip.chartnumber = p.VendorID 
INNER JOIN dbo._import_13_61_InsuranceCOMPANYPLANList icpl ON icpl.insuranceid = ip.insurancecode1 
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.PlanName = icpl.planname AND icp.CreatedPracticeID=@TargetPracticeID AND icp.InsuranceCompanyPlanID IS NOT NULL
WHERE p.VendorImportID =@VendorImportID AND 
	icp.CreatedDate > DATEADD(mi,-3,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


----------------Policy 2----------------------
PRINT ''
PRINT 'Inserting into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy
(
PatientCaseID ,
InsuranceCompanyPlanID ,
Precedence ,
PolicyNumber ,
GroupNumber ,
PolicyStartDate ,
PolicyEndDate ,
CardOnFile ,
 PatientRelationshipToInsured,
HolderPrefix ,
HolderFirstName ,
HolderMiddleName ,
HolderLastName ,
HolderSuffix ,
HolderDOB ,
HolderSSN ,
HolderThroughEmployer ,
HolderEmployerName ,
PatientInsuranceStatusID ,
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
HolderPhoneExt ,
DependentPolicyNumber ,
Notes ,
Phone ,
PhoneExt ,
Fax ,
FaxExt ,
Copay ,
Deductible ,
PatientInsuranceNumber ,
Active ,
PracticeID ,
AdjusterPrefix ,
AdjusterFirstName ,
AdjusterMiddleName ,
AdjusterLastName ,
AdjusterSuffix ,
VendorID ,
VendorImportID ,
InsuranceProgramTypeID ,
--GroupName ,
ReleaseOfInformation, 
SyncWithEHR
)
SELECT
DISTINCT

pc.PatientCaseID ,
icp.InsuranceCompanyPlanID ,
2, --ip.Precedence ,
LEFT(ip.PolicyNumber1,32) ,
LEFT(ip.GroupNumber1,32) ,
CASE WHEN ISDATE(ip.Policy1StartDate) = 1 THEN ip.policy1startdate ELSE NULL END ,
CASE WHEN ISDATE(ip.Policy1EndDate) = 1 THEN ip.policy1enddate ELSE NULL END ,
0, --ip.CardOnFile ,
CASE WHEN  PatientRelationship1 ='' THEN 'S' ELSE NULL END ,
NULL, --ip.HolderPrefix ,
ip.Holder1FirstName ,
ip.Holder1MiddleName ,
ip.Holder1LastName ,
NULL, --ip.Holder1Suffix ,
CAST(ip.dateofbirth AS DATETIME),
ip.Holder1SSN ,
0, --ip.holderthroughemployer ,
ip.Employer1 ,
0, --ip.PatientInsuranceStatusID ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
ip.holder1Gender ,
ip.holder1street1 ,
ip.holder1street2 ,
ip.Holder1City ,
ip.Holder1State ,
NULL, --ip.HolderCountry ,
ip.Holder1ZipCode ,
NULL, --ip.HolderPhone ,
NULL, --ip.HolderPhoneExt ,
ip.policynumber1 ,
ip.policy1Note ,
NULL, --ip.Phone ,
NULL, --ip.PhoneExt ,
NULL, --ip.Fax ,
NULL, --ip.FaxExt ,
ip.policy1Copay ,
ip.policy1Deductible ,
NULL, --ip.PatientInsuranceNumber ,
1, --ip.active ,
@TargetPracticeID ,
NULL, --ip.AdjusterPrefix ,
NULL, --ip.AdjusterFirstName ,
NULL, --ip.AdjusterMiddleName ,
NULL, --ip.AdjusterLastName ,
NULL, --ip.AdjusterSuffix ,
ip.chartnumber, --ip.InsurancePolicyID ,
@VendorImportID ,
NULL, --ip.insuranceprogramtypeid ,
 --LEFT(ip.primaryGroupName,14) ,
NULL, --ip.ReleaseOfInformation
1 --syncwithehr (primary case flag)
--select ip.* 
FROM dbo.Patient p 
INNER JOIN dbo.PatientCase pc ON pc.PatientID = p.PatientID 
INNER JOIN dbo._import_13_61_PatientDemographics ip ON ip.chartnumber = p.VendorID 
INNER JOIN dbo._import_13_61_InsuranceCOMPANYPLANList icpl ON icpl.insuranceid = ip.insurancecode2
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.PlanName = icpl.planname AND icp.CreatedPracticeID=@TargetPracticeID AND icp.InsuranceCompanyPlanID IS NOT NULL 
WHERE p.VendorImportID =@VendorImportID AND 
	icp.CreatedDate > DATEADD(mi,-3,GETDATE())

--SELECT * FROM dbo._import_13_61_PatientDemographics WHERE policynumber2<>''


PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointments...'
INSERT INTO dbo.Appointment
        ( PatientID,
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
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm,
		  vendorimportid
        )
SELECT DISTINCT
		  p.PatientID,
          61 , -- PracticeID - int
          422, --sl.ServiceLocationID , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.EndDate , -- EndDate - datetime
          'P'   , -- AppointmentType - varchar(1)
          NULL  , -- Subject - varchar(64)
          i.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.StartDate AS TIME),':',''),4) AS SMALLINT) , --CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.EndDate AS TIME),':',''),4) AS SMALLINT), --CAST(REPLACE(RIGHT(i.EndDate,5), ':','') AS SMALLINT)  -- EndTm - smallint
		  @VendorImportID
		  --SELECT * 
FROM dbo._import_13_61_PatientAppointments i 
	INNER JOIN dbo.Patient p ON 
		p.VendorID = i.chartnumber AND 
		--p.LastName = i.lastname AND 
		--p.FirstName = i.firstname AND
		--CAST(dbo.fn_DateOnly(p.DOB)AS DATE) = CAST(i.dob AS DATE) AND 
		--p.AddressLine1 = i.address1 AND 
        p.PracticeID = @TargetPracticeID
		--p.patientid = i.patientid
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @TargetPracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
	--INNER JOIN dbo.ServiceLocation sl ON 
	--	sl.Name = i.servicelocationname AND 
	--	sl.PracticeID = 61
	--rollback
	--commit
	--SELECT * FROM dbo.Appointment
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
          1,--CASE WHEN i.resource = 'Nurse' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          8219,--CASE WHEN i.resource = 'Nurse' THEN (SELECT PracticeResourceID FROM dbo.PracticeResource WHERE ResourceName = 'Nurse' AND PracticeID = @PracticeID)
		  --ELSE (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Irene' AND LastName = 'Edwards' AND PracticeID = @PracticeID AND [External] = 0) 
		  --END  , -- ResourceID - int
          GETDATE(),  -- ModifiedDate - datetime
          @targetpracticeid  -- PracticeID - int
	--SELECT * 
FROM dbo._import_13_61_PatientAppointments i
	INNER JOIN dbo.Appointment a ON 
		a.StartDate = i.startdate AND 
		a.EndDate = i.enddate AND 
		a.PracticeID = @targetpracticeid
	--INNER JOIN dbo.Doctor d ON 
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Appointment Reasons...'

INSERT INTO dbo.AppointmentReason
(
    PracticeID,
    Name,
    DefaultDurationMinutes,
    DefaultColorCode,
    Description,
    ModifiedDate

)
SELECT DISTINCT	
    @targetpracticeid,         -- PracticeID - int
    ip.reasons,        -- Name - varchar(128)
    DATEDIFF(MINUTE,ip.startdate,ip.enddate),         -- DefaultDurationMinutes - int
    NULL ,      -- DefaultColorCode - int
    ip.note,        -- Description - varchar(256)
    GETDATE() -- ModifiedDate - datetime
	--SELECT * 
FROM dbo._import_13_61_PatientAppointments ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.reasons

WHERE ar.name IS NULL AND ip.reasons<>''

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

UPDATE a SET 
a.apptduration=
DATEDIFF(MINUTE,a.startdate,a.enddate)
FROM dbo._import_13_61_PatientAppointments a 

--BEGIN TRAN 
PRINT''
PRINT'Inserting into Appointment to Appointment Reasons...'

INSERT INTO dbo.AppointmentToAppointmentReason
(
    AppointmentID,
    AppointmentReasonID,
    PrimaryAppointment,
    ModifiedDate,
    PracticeID
)
SELECT DISTINCT 
    apt.AppointmentID,         -- AppointmentID - int
    ar.AppointmentReasonID,         -- AppointmentReasonID - int
    1,      -- PrimaryAppointment - bit
    GETDATE(), -- ModifiedDate - datetime
    @TargetPracticeID         -- PracticeID - int
     
	 --SELECT *
FROM dbo._import_13_61_PatientAppointments imp
	INNER JOIN dbo.Patient p ON 
		p.VendorID = imp.chartnumber AND 
		--imp.LastName = p.LastName AND 
		--imp.FirstName = p.FirstName AND 
		--CAST(dbo.fn_DateOnly(p.DOB)AS DATE) = CAST(imp.dob AS DATE) AND 
		--imp.address1 = p.AddressLine1 AND 
		--imp.MiddleName = p.MiddleName AND
	p.PracticeID = @TargetPracticeID
INNER JOIN dbo.Appointment apt ON
	apt.PatientID = p.PatientID AND
	apt.StartDate = imp.startdate AND 
	apt.EndDate = imp.enddate AND 
	apt.practiceid=@TargetPracticeID
INNER JOIN dbo.AppointmentReason ar ON
	ar.Name = imp.reasons AND 
	ar.PracticeID =@TargetPracticeID
and apt.CreatedDate > DATEADD(mi,-3,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'






