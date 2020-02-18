USE superbill_39795_dev
GO

--insurance company 
SELECT COUNT(DISTINCT i.insurancecompanyname) 
FROM dbo._import_82_42_InsuranceCOMPANYPLANList i
LEFT JOIN dbo.InsuranceCompany ic ON ic.InsuranceCompanyName = i.insurancecompanyname
WHERE ic.InsuranceCompanyName IS NULL 

--insurance company plan
SELECT COUNT(DISTINCT i.planname) FROM dbo._import_82_42_InsuranceCOMPANYPLANList i
SELECT COUNT(DISTINCT i.planname) 
FROM dbo._import_82_42_InsuranceCOMPANYPLANList i
INNER JOIN dbo.InsuranceCompanyPlan ic ON ic.PlanName = i.planname

--doctor
SELECT rd.* FROM dbo._import_82_42_ReferringDoctors rd
LEFT JOIN dbo.Doctor d ON d.NPI=rd.npi
WHERE d.npi IS NULL AND d.PracticeID=42

--insurance policy
SELECT * FROM dbo._import_82_42_PatientDemographics pd WHERE pd.policynumber1<>''ORDER BY pd.chartnumber

SELECT * FROM dbo._import_82_42_PatientDemographics pd 
INNER JOIN dbo.PatientCase pc ON pc.VendorID=pd.chartnumber
INNER JOIN dbo.InsurancePolicy ip ON ip.PatientCaseID=pc.PatientCaseID
ORDER BY pd.chartnumber

--appointment
SELECT * FROM dbo._import_82_42_PatientAppointments ia 
SELECT * FROM dbo.Appointment WHERE PracticeID=42

--appointment reasons
SELECT DISTINCT ar.reasons FROM dbo._import_82_42_PatientAppointments ar WHERE ar.reasons<>''
SELECT DISTINCT ia.reasons FROM dbo._import_82_42_PatientAppointments ia
INNER JOIN dbo.AppointmentReason ar ON ar.Name=ia.reasons

--aptar 
SELECT * FROM dbo.AppointmentToAppointmentReason a WHERE a.PracticeID=42




SELECT * FROM dbo.Appointment WHERE PracticeID=42
SELECT * FROM dbo.InsuranceCompanyPlan
SELECT DISTINCT planname FROM dbo._import_82_42_InsuranceCOMPANYPLANList
SELECT * FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID=42




SELECT * FROM dbo._import_82_42_PatientDemographics p

