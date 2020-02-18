USE superbill_64204_dev
GO 
--rollback
--commit

--DELETE FROM dbo.EligibilityHistory WHERE requestid=10
--DELETE FROM dbo.InsurancePolicy WHERE VendorImportID=1000

BEGIN TRANSACTION 

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 5

--UPDATE ip
--SET ip.policynumber1 = NULL 
--FROM dbo._import_9_1_PatientDemographicsv2 ip 
--WHERE ip.PolicyNumber1 = '#N/A'

SET NOCOUNT ON 

UPDATE ip
SET ip.lastname = p.lastname
FROM dbo._import_9_1_PatientDemographicsv2 ip 
INNER JOIN dbo.Patient p ON ip.firstname = p.FirstName AND dbo.fn_DateOnly(ip.dateofbirth) = dbo.fn_DateOnly(p.DOB)
WHERE ip.chartnumber IN ('10032','60242')

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
GroupName ,
ReleaseOfInformation
)
SELECT
DISTINCT
pc.PatientCaseID ,
icp.InsuranceCompanyPlanID ,
1, --ip.Precedence ,
d.policynumber1, --ip.PolicyNumber1 ,
NULL, --ip.GroupNumber1 ,
NULL, --CASE WHEN ISDATE(ip.Policy1StartDate) = 1 THEN ip.policy1startdate ELSE NULL END ,
NULL, --CASE WHEN ISDATE(ip.Policy1EndDate) = 1 THEN ip.policy1enddate ELSE NULL END ,
0, --ip.CardOnFile ,
'S',--patientrelationshipcode 
NULL, --ip.HolderPrefix ,
NULL, --ip.Holder1FirstName ,
NULL, --ip.Holder1MiddleName ,
NULL, --ip.Holder1LastName ,
NULL, --ip.Holder1Suffix ,
NULL, --ip.Holder1dateofbirth ,
NULL, --ip.Holder1SSN ,
0, --ip.holderthroughemployer ,
null, --ip.Employer1 ,
0, --ip.PatientInsuranceStatusID ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
NULL, --ip.holder1Gender ,
NULL, --ip.holder1street1 ,
NULL, --ip.holder1street2 ,
NULL, --ip.Holder1City ,
NULL, --ip.Holder1State ,
NULL, --ip.HolderCountry ,
NULL, --ip.Holder1ZipCode ,
NULL, --ip.HolderPhone ,
NULL, --ip.HolderPhoneExt ,
NULL, --ip.policynumber1 ,
NULL, --ip.policy1Note ,
NULL, --ip.Phone ,
NULL, --ip.PhoneExt ,
NULL, --ip.Fax ,
NULL, --ip.FaxExt ,
0, --ip.policy1Copay ,
0, --ip.policy1Deductible ,
NULL, --ip.PatientInsuranceNumber , -- ASK SHEA what this number is referring to
1, --ip.active ,
@PracticeID, --@TargetPracticeID ,
NULL, --ip.AdjusterPrefix ,
NULL, --ip.AdjusterFirstName ,
NULL, --ip.AdjusterMiddleName ,
NULL, --ip.AdjusterLastName ,
NULL, --ip.AdjusterSuffix ,
NULL, --ip.chartnumber, --ip.InsurancePolicyID ,
@VendorImportID, --@VendorImportID ,
NULL, --ip.insuranceprogramtypeid ,
NULL, --ip.primaryGroupName ,
NULL --ip.ReleaseOfInformation

--SELECT d.policynumber1,d.insurancecode1,*
FROM
dbo._import_9_1_PatientDemographicsv2 d 
INNER JOIN dbo.Patient p ON p.LastName = d.lastname AND p.FirstName = d.firstname AND dbo.fn_DateOnly(p.DOB)= dbo.fn_DateOnly(d.dateofbirth)
inner JOIN dbo._import_9_1_InsuranceCOMPANYPLANListv2 icpl ON icpl.insuranceid = d.insurancecode1
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.PlanName = icpl.planname
INNER JOIN dbo.patientcase pc ON pc.PatientID = p.PatientID
LEFT  JOIN dbo.InsurancePolicy ip ON ip.PatientCaseID = pc.PatientCaseID AND ip.Precedence=1
WHERE ip.PolicyNumber IS null AND d.policynumber1<>'' 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into InsurancePolicy 2 ...'
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
GroupName ,
ReleaseOfInformation
)
SELECT
DISTINCT
pc.PatientCaseID ,
icp.InsuranceCompanyPlanID ,
2, --ip.Precedence ,
d.policynumber2, --ip.PolicyNumber1 ,
NULL, --ip.GroupNumber1 ,
NULL, --CASE WHEN ISDATE(ip.Policy1StartDate) = 1 THEN ip.policy1startdate ELSE NULL END ,
NULL, --CASE WHEN ISDATE(ip.Policy1EndDate) = 1 THEN ip.policy1enddate ELSE NULL END ,
0, --ip.CardOnFile ,
'S',--patientrelationshipcode 
NULL, --ip.HolderPrefix ,
NULL, --ip.Holder1FirstName ,
NULL, --ip.Holder1MiddleName ,
NULL, --ip.Holder1LastName ,
NULL, --ip.Holder1Suffix ,
NULL, --ip.Holder1dateofbirth ,
NULL, --ip.Holder1SSN ,
0, --ip.holderthroughemployer ,
null, --ip.Employer1 ,
0, --ip.PatientInsuranceStatusID ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
NULL, --ip.holder1Gender ,
NULL, --ip.holder1street1 ,
NULL, --ip.holder1street2 ,
NULL, --ip.Holder1City ,
NULL, --ip.Holder1State ,
NULL, --ip.HolderCountry ,
NULL, --ip.Holder1ZipCode ,
NULL, --ip.HolderPhone ,
NULL, --ip.HolderPhoneExt ,
NULL, --ip.policynumber1 ,
NULL, --ip.policy1Note ,
NULL, --ip.Phone ,
NULL, --ip.PhoneExt ,
NULL, --ip.Fax ,
NULL, --ip.FaxExt ,
0, --ip.policy1Copay ,
0, --ip.policy1Deductible ,
NULL, --ip.PatientInsuranceNumber , -- ASK SHEA what this number is referring to
1, --ip.active ,
@PracticeID, --@TargetPracticeID ,
NULL, --ip.AdjusterPrefix ,
NULL, --ip.AdjusterFirstName ,
NULL, --ip.AdjusterMiddleName ,
NULL, --ip.AdjusterLastName ,
NULL, --ip.AdjusterSuffix ,
NULL, --ip.chartnumber, --ip.InsurancePolicyID ,
@VendorImportID, --@VendorImportID ,
NULL, --ip.insuranceprogramtypeid ,
NULL, --ip.primaryGroupName ,
NULL --ip.ReleaseOfInformation

--SELECT d.policynumber1,d.insurancecode1,*
FROM
dbo._import_9_1_PatientDemographicsv2 d 
INNER JOIN dbo.Patient p ON p.LastName = d.lastname AND p.FirstName = d.firstname AND dbo.fn_DateOnly(p.DOB)= dbo.fn_DateOnly(d.dateofbirth)
inner JOIN dbo._import_9_1_InsuranceCOMPANYPLANListv2 icpl ON icpl.insuranceid = d.insurancecode2
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.PlanName = icpl.planname
INNER JOIN dbo.patientcase pc ON pc.PatientID = p.PatientID
LEFT  JOIN dbo.InsurancePolicy ip ON ip.PatientCaseID = pc.PatientCaseID AND ip.Precedence=2
WHERE ip.PolicyNumber IS null AND d.policynumber2<>'' 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'