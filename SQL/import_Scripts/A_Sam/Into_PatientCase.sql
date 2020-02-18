PRINT ''
PRINT 'Inserting into PatientCase ...'
INSERT INTO dbo.PatientCase
(
PatientID ,
Name ,
Active ,
PayerScenarioID ,
ReferringPhysicianID ,
EmploymentRelatedFlag ,
AutoAccidentRelatedFlag ,
OtherAccidentRelatedFlag ,
AbuseRelatedFlag ,
AutoAccidentRelatedState ,
Notes ,
ShowExpiredInsurancePolicies ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
PracticeID ,
CaseNumber ,
WorkersCompContactInfoID ,
VendorID ,
VendorImportID ,
PregnancyRelatedFlag ,
StatementActive ,
EPSDT ,
FamilyPlanning ,
EPSDTCodeID ,
EmergencyRelated ,
HomeboundRelatedFlag
)
SELECT DISTINCT	
p.PatientID ,
'Active' ,
1 ,

CASE 
pc.financialclass
WHEN 'Medi-Cal' THEN 8
WHEN 'Medical' THEN 8
WHEN 'Cash' THEN 11
WHEN 'Cash Patient' THEN 11
WHEN 'HMO' THEN 18
WHEN 'PI Lien' THEN 1
WHEN 'P.I. Lien' THEN 1
ELSE ps.PayerScenarioID
END
,

NULL,--d.DoctorID ,
0,--,pc.employmentrelatedflag ,
0,--pc.autoaccidentrelatedflag ,
0,--pc.otheraccidentrelatedflag ,
0,--pc.abuserelatedflag ,
0,--pc.AutoAccidentRelatedState ,
NULL, --pc.Notes ,
0,--pc.showexpiredinsurancepolicies ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
@TargetPracticeID ,
NULL,--pc.CaseNumber ,
NULL,--pc.WorkersCompContactInfoID ,
pc.chartnumber , -- VendorID
@VendorImportID , -- VenorID
0,--pc.pregnancyrelatedflag ,
1,--pc.statementactive ,
0,--pc.epsdt ,
0,--pc.familyplanning ,
NULL,--pc.epsdtcodeid ,
0,--pc.emergencyrelated ,
0--pc.homeboundrelatedflag
FROM dbo._import_5_12_patientDemographics pc
INNER JOIN dbo.Patient p ON
pc.chartnumber = p.VendorID AND
p.VendorImportID = @VendorImportID
left JOIN dbo.PayerScenario ps ON pc.financialclass=ps.Name
WHERE pc.chartnumber <>'MDSuite-109'

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
