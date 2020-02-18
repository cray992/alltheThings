USE superbill_62032_prod
GO
BEGIN TRANSACTION
-----------------------------------
----Update DOB between DBs— for Dev Only

--UPDATE dp 
--SET dp.DOB = rp.DOB
--FROM superbill_62032_dev_v2.dbo.patient rp 
--INNER JOIN superbill_62032_dev.dbo.Patient dp
--	ON rp.PatientID = dp.PatientID

-----------------------------------

UPDATE p SET 
p.ResponsibleDifferentThanPatient = 1,
p.ResponsibleFirstName = i.guardianfrstnm,
p.ResponsibleMiddleName = i.guardianmddlinitial,
p.ResponsibleLastName = i.guardianlastnm,
p.ResponsibleSuffix = i.guardiannmsuffix,
p.ResponsibleAddressLine1 = i.guarantoraddr,
p.ResponsibleAddressLine2 = i.guarantoraddr2,
p.ResponsibleCity = i.guarantorcity,
p.ResponsibleState = i.guarantorstate,
p.ResponsibleZipCode = 
LEFT(CASE 
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)) IN (5,9) 
THEN dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)) = 4 
THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)
ELSE '' END,9) , -- ZipCode - varchar(9)
p.ResponsibleRelationshipToPatient = 
	CASE WHEN i.ptntgrntrrltnshp = 
		'Child' THEN 'C' ELSE 'O' END 
--SELECT CAST(i.patientdob AS DATETIME),* 
FROM dbo._import_5_1_PatientDemographics i 
INNER JOIN dbo.Patient p ON 
	p.LastName = i.patientlastname AND 
	p.FirstName = i.patientfirstname AND 
	dbo.fn_DateOnly(p.DOB) = dbo.fn_DateOnly(i.patientdob)
WHERE p.ModifiedUserID=0 AND i.patientlastname IS NOT NULL 

--rollback
--commit

--DBCC OPENTRAN ()

