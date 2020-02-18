USE superbill_63463_dev
GO

SET XACT_ABORT ON

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 17
SET @SourcePracticeID = 6
SET @VendorImportID = 16

--SELECT * FROM dbo._import_16_17_InsuranceCOMPANYPLANList
--SELECT * FROM dbo.InsuranceCompany

----Patients
--SELECT COUNT(DISTINCT pt.MedicalRecordNumber) AS Inserted_Patient_Count 
--FROM patient pt INNER JOIN dbo._import_8_13_PatientDemographics pd ON pd.chartnumber = pt.VendorID
--SELECT COUNT(DISTINCT p.chartnumber) AS Original_Patient_Count FROM dbo._import_8_13_patientDemographics P

--Insurance Companies

--Run before the import
SELECT COUNT(DISTINCT i.InsuranceCompanyName)AS Original_Ins_Company_Count 
FROM dbo._import_16_17_Insurancecompanyplanlist i
INNER JOIN dbo.InsuranceCompany IC ON i.insurancecompanyname=ic.InsuranceCompanyName AND ic.CreatedPracticeID = 6
LEFT JOIN dbo.InsuranceCompany IC2 ON i.insurancecompanyname=ic2.InsuranceCompanyName AND ic2.CreatedPracticeID=17
WHERE ic2.insurancecompanyname IS NULL

--Insurance Companies 2
--Run before import but after first ins companies section
SELECT COUNT(DISTINCT i.InsuranceCompanyName)AS Original_Ins_Company_Count_2
FROM dbo._import_16_17_Insurancecompanyplanlist i
LEFT JOIN dbo.InsuranceCompany IC2 ON i.insurancecompanyname=ic2.InsuranceCompanyName AND ic2.CreatedPracticeID = 17
WHERE ic2.insurancecompanyname IS NULL and i.insurancecompanyname <>''

--Run after import, (total will be ins companies 1+2
SELECT COUNT(DISTINCT a.insurancecompanyname)AS Inserted_Ins_Company_Count 
FROM dbo.InsuranceCompany a
WHERE a.CreatedPracticeID=17 AND a.insurancecompanyname<>'' AND a.VendorImportID=16


--Insurance Company Plans
--Run before the import but after both ins companies imports
SELECT COUNT(*)AS Original_Ins_Company_Count 
FROM dbo._import_16_17_Insurancecompanyplanlist i
INNER JOIN dbo.InsuranceCompany ic ON i.insurancecompanyname = ic.InsuranceCompanyName AND 
--ic.VendorImportID =@VendorImportID AND -- @VendorImportID 
ic.CreatedPracticeID=17--@targetpracticeid 
LEFT JOIN dbo.InsuranceCompanyPlan a ON i.planname=a.PlanName AND a.CreatedPracticeID=17
WHERE a.planname IS NULL

--Run after
SELECT COUNT(a.planname)AS Inserted_Ins_Company_Count FROM dbo.InsuranceCompanyPlan a
WHERE a.CreatedPracticeID=17 AND a.PlanName<>'' AND a.VendorImportID=16


