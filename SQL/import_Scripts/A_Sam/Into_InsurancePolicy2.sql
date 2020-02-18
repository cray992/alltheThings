PRINT ''
PRINT 'Inserting into InsurancePolicy2 ...'
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
PatientRelationshipToInsured ,
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
ip.PolicyNumber2 ,
ip.GroupNumber2 ,
CASE WHEN ISDATE(ip.Policy2StartDate) = 1 THEN ip.policy2startdate ELSE NULL END ,
CASE WHEN ISDATE(ip.Policy2EndDate) = 1 THEN ip.policy2enddate ELSE NULL END ,
0, --ip.CardOnFile ,
CASE WHEN  PatientRelationship2 ='' THEN 'S' ELSE NULL END , 
NULL, --ip.HolderPrefix ,
ip.Holder2FirstName ,
ip.Holder2MiddleName ,
ip.Holder2LastName ,
NULL, --ip.Holder1Suffix ,
ip.Holder2dateofbirth ,
ip.Holder2SSN ,
0, --ip.holderthroughemployer ,
ip.Employer1 ,
0, --ip.PatientInsuranceStatusID ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
ip.holder2Gender ,
ip.holder2street1 ,
ip.holder2street2 ,
ip.Holder2City ,
ip.Holder2State ,
NULL, --ip.HolderCountry ,
ip.Holder2ZipCode ,
NULL, --ip.HolderPhone ,
NULL, --ip.HolderPhoneExt ,
ip.policynumber2 ,
ip.policy2Note ,
NULL, --ip.Phone ,
NULL, --ip.PhoneExt ,
NULL, --ip.Fax ,
NULL, --ip.FaxExt ,
ip.policy2Copay ,
ip.policy2Deductible ,
NULL, --ip.PatientInsuranceNumber , -- ASK SHEA what this number is referring to
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
ip.secondaryGroupName ,
NULL --ip.ReleaseOfInformation
--FROM dbo._import_5_12_patientDemographics ip
--INNER JOIN dbo.PatientCase pc ON ip.chartnumber = pc.VendorID AND pc.VendorImportID = @VendorImportID
--INNER JOIN dbo.InsuranceCompanyPlan icp ON ip.insurancecode2 = icp.VendorID AND icp.VendorImportID = @VendorImportID

FROM dbo._import_5_12_patientDemographics ip
INNER JOIN dbo._import_5_12_Insurancecompanyplanlist icpl ON ip.insurancecode2=icpl.insuranceid
INNER JOIN dbo.PatientCase pc ON
ip.chartnumber = pc.VendorID AND
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
icpl.insuranceid = icp.vendorid AND
icp.VendorImportID =@VendorImportID AND CreatedPracticeID=@TargetPracticeID
LEFT JOIN dbo.InsurancePolicy ipo ON ipo.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID AND ipo.PracticeID=@TargetPracticeID --AND ipo.PatientCaseID=pc.PatientCaseID  
AND policynumber1=ipo.PolicyNumber AND ipo.Precedence=2
WHERE ip.insurancecode2 <> 'patient'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'