USE superbill_63463_dev
GO

SET XACT_ABORT ON

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 13
SET @SourcePracticeID = 6
SET @VendorImportID = 8

--Patients
SELECT COUNT(DISTINCT pt.MedicalRecordNumber) AS Inserted_Patient_Count 
FROM patient pt INNER JOIN dbo._import_8_13_PatientDemographics pd ON pd.chartnumber = pt.VendorID
SELECT COUNT(DISTINCT p.chartnumber) AS Original_Patient_Count FROM dbo._import_8_13_patientDemographics P

--Insurance Companies
SELECT COUNT(DISTINCT a.insurancecompanyname)AS Inserted_Ins_Company_Count FROM dbo._import_8_13_InsuranceCOMPANYPLANList a
SELECT COUNT(DISTINCT a.InsuranceCompanyName)AS Original_Ins_Company_Count FROM dbo.InsuranceCompany a WHERE CreatedPracticeID=@TargetPracticeID

--Insurance Company Plans
SELECT COUNT(DISTINCT ic.InsuranceCompanyPlanID) AS Inserted_Ins_Company_Plans_Count
FROM dbo.InsuranceCompanyplan ic INNER JOIN dbo._import_8_13_InsuranceCOMPANYPLANList icp ON icp.insuranceid = ic.VendorID 
WHERE ic.CreatedPracticeID=@TargetPracticeID
SELECT COUNT(DISTINCT icp.planname) AS Original_Ins_Company_Plans_Count
FROM dbo._import_8_13_InsuranceCOMPANYPLANList icp

--Patient Alerts
SELECT COUNT(DISTINCT pd.policynumber1)AS Inserted_Patient_Alert_Count
FROM dbo.PatientAlert pa INNER JOIN dbo._import_8_13_PatientDemographics pd 
ON pd.patientalertmessage = CAST(pa.AlertMessage AS VARCHAR (MAX))
SELECT COUNT (pd.patientalertmessage) as Original_Patient_Alert_Count
FROM dbo._import_8_13_PatientDemographics pd WHERE pd.patientalertmessage<>''

--Patient Case
SELECT COUNT(DISTINCT pt.VendorID)AS Inserted_Patient_Case_Count 
FROM patient pt INNER JOIN dbo._import_8_13_PatientDemographics pd ON pd.chartnumber = pt.VendorID
WHERE pt.PracticeID=@TargetPracticeID
SELECT COUNT(DISTINCT pd.chartnumber)AS Original_Patient_Case_Count FROM dbo._import_8_13_PatientDemographics pd 

--Insurance Policies 1
SELECT count (ip.PolicyNumber)AS Inserted_Policies_Count1
FROM dbo.InsurancePolicy ip INNER JOIN dbo._import_8_13_PatientDemographics pd ON pd.policynumber1=ip.PolicyNumber AND ip.Precedence=1 AND ip.PracticeID=@TargetPracticeID
SELECT count (pd.policynumber1)AS Original_Policies_Count1 FROM dbo._import_8_13_PatientDemographics pd WHERE pd.policynumber1<>''

--Insurance Policies 2
SELECT count (DISTINCT ip.PolicyNumber)AS Inserted_Policies_Count2 
FROM dbo.InsurancePolicy ip INNER JOIN dbo._import_8_13_PatientDemographics pd ON pd.policynumber2=ip.PolicyNumber AND ip.Precedence=2 AND ip.PracticeID=@TargetPracticeID
SELECT count (DISTINCT pd.policynumber2)AS Original_Policies_Count2 FROM dbo._import_8_13_PatientDemographics pd WHERE pd.policynumber2<>''

--Insurance Policies 3
SELECT count (DISTINCT ip.PolicyNumber)AS Inserted_Policies_Count3 
FROM dbo.InsurancePolicy ip INNER JOIN dbo._import_8_13_PatientDemographics pd ON pd.policynumber3=ip.PolicyNumber AND ip.Precedence=3 AND ip.PracticeID=@TargetPracticeID
SELECT count (DISTINCT pd.policynumber3)AS Original_Policies_Count3 FROM dbo._import_8_13_PatientDemographics pd WHERE pd.policynumber3<>'' 

SELECT a.policynumber1,a.insurancecode1,* FROM dbo._import_8_13_PatientDemographics a WHERE a.insurancecode1 LIKE'ama%'
SELECT a.policynumber2,a.insurancecode2,* FROM dbo._import_8_13_PatientDemographics a WHERE a.insurancecode2 LIKE'ama%'


