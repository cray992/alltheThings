USE superbill_10590_dev

PRINT ''
PRINT 'Records Updated PracticeID 36...'
UPDATE dbo.Patient 
SET MedicalRecordNumber = a.chartnumber 
FROM dbo._import_28_36_PatientDemographics a
INNER JOIN dbo.Patient b ON b.LastName = a.lastname AND b.FirstName = a.firstname AND 
a.address1 = b.AddressLine1 
WHERE a.chartnumber IS NOT NULL AND b.PracticeID=36

PRINT ''
PRINT 'Records Updated PracticeID 11...'
UPDATE dbo.Patient 
SET MedicalRecordNumber = a.chartnumber 
FROM dbo._import_29_11_PatientDemographics a
INNER JOIN dbo.Patient b ON b.LastName = a.lastname AND b.FirstName = a.firstname AND 
a.address1 = b.AddressLine1 
WHERE a.chartnumber IS NOT NULL AND b.PracticeID=11

PRINT ''
PRINT 'Records Updated PracticeID 9...'
UPDATE dbo.Patient 
SET MedicalRecordNumber = a.chartnumber 
FROM dbo._import_30_9_PatientDemographics a
INNER JOIN dbo.Patient b ON b.LastName = a.lastname AND b.FirstName = a.firstname AND 
a.address1 = b.AddressLine1 
WHERE a.chartnumber IS NOT NULL AND b.PracticeID=9

PRINT ''
PRINT 'Records Updated PracticeID 10...'
UPDATE dbo.Patient 
SET MedicalRecordNumber = a.chartnumber 
FROM dbo._import_31_10_PatientDemographics a
INNER JOIN dbo.Patient b ON b.LastName = a.lastname AND b.FirstName = a.firstname AND 
a.address1 = b.AddressLine1 
WHERE a.chartnumber IS NOT NULL AND b.PracticeID=10


--Patient records with no match, Chartnumber on MRN
SELECT a.PracticeID,a.MedicalRecordNumber,a.LastName,a.FirstName,a.AddressLine1,a.City,a.State,a.ZipCode,a.DOB 
FROM dbo.Patient a WHERE a.MedicalRecordNumber IS null AND a.PracticeID IN(36,11,9,10)