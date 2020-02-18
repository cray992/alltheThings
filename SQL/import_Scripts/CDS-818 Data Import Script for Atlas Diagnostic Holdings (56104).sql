USE superbill_56104_prod
--USE superbill_56104_dev
GO


SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 1
SET @SourcePracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

/*
==========================================================================================================================================
QA COUNT CHECK
==========================================================================================================================================
*/

/*
CREATE TABLE #tempdocqa (firstname VARCHAR(65), lastname VARCHAR(65), NPI INT , [External] INT) INSERT INTO #tempdocqa (firstname, lastname, NPI, [External])
SELECT DISTINCT d.firstname ,d.lastname, d.npi, d.[External] FROM dbo._import_2_1_Doctor d WHERE d.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Existing Renderring Doctors To Be Updated] FROM dbo.Doctor d 
INNER JOIN #tempdocqa i ON d.FirstName = i.firstname AND d.LastName = i.lastname AND d.NPI = i.npi
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 0 

SELECT COUNT(*) AS [Existing Referring Doctors To Be Updated] FROM dbo.Doctor d 
INNER JOIN #tempdocqa i ON d.FirstName = i.firstname AND d.LastName = i.lastname AND d.NPI = i.npi
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 1 DROP TABLE #tempdocqa

SELECT DISTINCT COUNT(DISTINCT i.insurancecompanyid) AS [Insurance Company Records To Be Inserted] FROM _import_2_1_InsuranceCompany i
INNER JOIN dbo.[_import_2_1_InsuranceCompanyPlan] icp ON i.InsuranceCompanyID = icp.InsuranceCompanyID
INNER JOIN dbo.[_import_2_1_InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

SELECT COUNT(DISTINCT ptic.pk_id) AS [Practice to Insurance Company Records To Be Inserted] FROM _import_2_1_PracticetoInsuranceCompany ptic 
INNER JOIN dbo._import_2_1_InsuranceCompany ic ON ptic.InsuranceCompanyId = ic.InsuranceCompanyID AND ptic.PracticeID = @SourcePracticeID
INNER JOIN dbo.[_import_2_1_InsuranceCompanyPlan] icp ON ic.InsuranceCompanyID = icp.InsuranceCompanyID
INNER JOIN dbo.[_import_2_1_InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

SELECT COUNT(DISTINCT icp.insurancecompanyplanid) AS [Insurance Company Plan Records To Be Inserted] FROM _import_2_1_InsuranceCompanyPlan icp
INNER JOIN dbo._import_2_1_InsuranceCompany ic ON icp.insurancecompanyid = ic.insurancecompanyid
INNER JOIN dbo.[_import_2_1_InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

--SELECT COUNT(*) AS [Existing Insurance Company Records to be Updated with ReviewCode] FROM dbo.InsuranceCompany ic
--INNER JOIN dbo.InsuranceCompanyPlan icp ON ic.InsuranceCompanyID = icp.InsuranceCompanyID 
--INNER JOIN dbo.InsurancePolicy ip ON ip.PracticeID = @SourcePracticeID AND icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
--WHERE ic.ReviewCode = '' OR ic.ReviewCode IS NULL

--SELECT COUNT(*) AS [Existing Insurance Company Plan Records to be Updated with ReviewCode] FROM dbo.InsuranceCompanyPlan icp 
--INNER JOIN dbo.InsurancePolicy ip ON ip.PracticeID = @SourcePracticeID AND icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
--WHERE icp.ReviewCode = '' OR icp.ReviewCode IS NULL

SELECT COUNT(*) AS [Referring Provider Records To Be Inserted] FROM dbo._import_2_1_Doctor d 
WHERE NOT EXISTS(SELECT * FROM dbo.Doctor d2 WHERE d.FirstName = d2.FirstName AND d.LastName = d2.LastName AND d.NPI = d2.NPI AND d2.[External] = 1 AND d2.PracticeID = @TargetPracticeID)
AND d.[External] = 1 AND d.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Patients To Be Inserted] FROM dbo._import_2_1_Patient p WHERE p.PracticeID = @SourcePracticeID 
AND NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Patient Alert Records To Be Inserted] FROM dbo._import_2_1_PatientAlert pa 
INNER JOIN dbo._import_2_1_Patient p ON pa.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Patient Journal Records To Be Inserted] FROM dbo._import_2_1_PatientJournalNote pjn
INNER JOIN dbo._import_2_1_Patient p ON pjn.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Patient Case Records To Be Inserted] FROM dbo._import_2_1_PatientCase pc 
INNER JOIN dbo._import_2_1_Patient p ON pc.PatientID = p.PatientID AND pc.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Patient Case Date Records To Be Inserted] FROM dbo._import_2_1_PatientCaseDate pcd 
INNER JOIN dbo._import_2_1_PatientCase pc ON pcd.PatientCaseID = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
INNER JOIN dbo._import_2_1_Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Insurance Policy Records To Be Inserted] FROM dbo._import_2_1_InsurancePolicy ip
INNER JOIN dbo._import_2_1_PatientCase pc ON ip.patientcaseid = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
INNER JOIN dbo._import_2_1_Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Insurance Policy Authorization Records To Be Inserted] FROM dbo._import_2_1_InsurancePolicyAuthorization ipa 
INNER JOIN dbo._import_2_1_InsurancePolicy ip ON ipa.InsurancePolicyID = ip.InsurancePolicyID AND ip.PracticeID = @SourcePracticeID
INNER JOIN dbo._import_2_1_PatientCase pc ON ip.PatientCaseID = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
INNER JOIN dbo._import_2_1_Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment Records To Be Inserted] FROM dbo._import_2_1_Appointment a
INNER JOIN dbo._import_2_1_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment Reason Records To Be Inserted] FROM dbo._import_2_1_AppointmentReason ars
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ars.Name = ar.Name AND ar.PracticeID = @TargetPracticeID) AND ars.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Practice Resource Records To Be Inserted] FROM dbo._import_2_1_PracticeResource prs 
WHERE NOT EXISTS (SELECT * FROM dbo.PracticeResource pr WHERE prs.ResourceName = pr.resourcename AND prs.PracticeID = @TargetPracticeID) and prs.practiceid = @SourcePracticeID

SELECT COUNT(*) AS [Appointment to Appointment Reason Records To Be Inserted] FROM dbo._import_2_1_AppointmentToAppointmentReason atar 
INNER JOIN dbo._import_2_1_Appointment a ON atar.AppointmentID = a.AppointmentID
INNER JOIN dbo._import_2_1_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment to Resource - Doctor Resource Records To Be Inserted] FROM dbo._import_2_1_AppointmentToResource atr
INNER JOIN dbo._import_2_1_Appointment a ON atr.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
INNER JOIN dbo._import_2_1_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
AND atr.AppointmentResourceTypeID = 1 AND atr.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Appointment to Resource - Practice Resource Records To Be Inserted] FROM dbo._import_2_1_AppointmentToResource atr
INNER JOIN dbo._import_2_1_Appointment a ON atr.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
INNER JOIN dbo._import_2_1_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
AND atr.AppointmentResourceTypeID = 2 AND atr.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Appointment Recurrence Records To Be Inserted] FROM dbo._import_2_1_AppointmentRecurrence ar 
INNER JOIN dbo._import_2_1_Appointment a ON ar.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
INNER JOIN dbo._import_2_1_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment Recurrence Exception Records To Be Inserted] FROM dbo._import_2_1_AppointmentRecurrenceException are 
INNER JOIN dbo._import_2_1_Appointment a ON are.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
INNER JOIN dbo._import_2_1_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 


*/

/*
==========================================================================================================================================
DELETE SCRIPT
==========================================================================================================================================
*/

/*
DELETE FROM dbo.InsurancePolicyAuthorization WHERE InsurancePolicyID IN (SELECT InsurancePolicyID FROM dbo.InsurancePolicy WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy Auth records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.AppointmentRecurrenceException WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment  WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Recurr Excep records deleted'
DELETE FROM dbo.AppointmentRecurrence WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment  WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Recurr records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @TargetPracticeID)
DELETE FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.ServiceLocation WHERE VendorImportID = @VendorImportID AND PracticeID = @TargetPracticeID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Service Location records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.PracticeToInsuranceCompany WHERE PracticeID = @TargetPracticeID AND InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Practice To Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
*/


/*==========================================================================*/
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--
--CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
--INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo.[_import_2_1_PatientDemographics] i ON p.PatientID = i.id

--PRINT ''
--PRINT 'Updating Existing Patients Demographics...'
--UPDATE dbo.Patient 
--	SET DOB = i.DateofBirth  ,
--		SSN = i.ssn
--FROM #updatepat i 
--INNER JOIN dbo.Patient p ON
--	p.PatientID = i.patientid
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--DROP TABLE #updatepat

/*==========================================================================*/

PRINT ''
PRINT 'Inserting Into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  i.EmployerName , -- EmployerName - varchar(128)
          i.AddressLine1 , -- AddressLine1 - varchar(256)
          i.AddressLine2 , -- AddressLine2 - varchar(256)
          i.City , -- City - varchar(128)
          i.[State] , -- State - varchar(2)
          i.Country , -- Country - varchar(32)
          i.ZipCode , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_2_1_Employers] i
	INNER JOIN dbo.[_import_2_1_Patient] p ON
		i.EmployerID = p.EmployerID AND
		p.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Employers e WHERE i.EmployerName = e.EmployerName)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #tempemp
( id INT , NAME VARCHAR(128))

INSERT INTO #tempemp
        ( id, NAME )
SELECT DISTINCT
		  e.EmployerID, -- id - int
          oe.EmployerName  -- NAME - varchar(128)
FROM dbo.[_import_2_1_Employers] e 
INNER JOIN dbo.Employers oe ON
	oe.EmployerName = e.EmployerName

CREATE TABLE #tempsl
( id INT , NAME VARCHAR(128))

INSERT INTO #tempsl
        ( id, NAME )
SELECT DISTINCT
		  sl.ServiceLocationID, -- id - int
          osl.Name  -- NAME - varchar(128)
FROM dbo.ServiceLocation sl 
INNER JOIN dbo._import_2_1_ServiceLocation osl ON
	osl.Name = sl.Name and
	OSl.PracticeID = @SourcePracticeID
WHERE sl.PracticeID = @TargetPracticeID

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( 
		  PracticeID , 
          ReferringPhysicianID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleCountry ,
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          InsuranceProgramCode ,
          --PatientReferralSourceID ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt ,
          Ethnicity ,
          Race ,
          LicenseNumber ,
          LicenseState ,
          Language1 ,
          Language2
        )
SELECT DISTINCT
		  @TargetPracticeID , -- PracticeID - int
          rd.doctorID , -- ReferringPhysicianID - int
          p.Prefix , -- Prefix - varchar(16)
          p.FirstName , -- FirstName - varchar(64)
          p.MiddleName , -- MiddleName - varchar(64)
          p.LastName , -- LastName - varchar(64)
          p.Suffix , -- Suffix - varchar(16)
          p.AddressLine1 , -- AddressLine1 - varchar(256)
          p.AddressLine2 , -- AddressLine2 - varchar(256)
          p.City , -- City - varchar(128)
          p.[State] , -- State - varchar(2)
          p.Country , -- Country - varchar(32)
          p.ZipCode , -- ZipCode - varchar(9)
          p.Gender , -- Gender - varchar(1)
          p.MaritalStatus , -- MaritalStatus - varchar(1)
          p.HomePhone , -- HomePhone - varchar(10)
          p.HomePhoneExt , -- HomePhoneExt - varchar(10)
          p.WorkPhone , -- WorkPhone - varchar(10)
          p.WorkPhoneExt , -- WorkPhoneExt - varchar(10)
          p.DOB , -- DOB - datetime
          p.SSN , -- SSN - char(9)
          p.EmailAddress , -- EmailAddress - varchar(256)
          p.responsibledifferentthanpatient , -- ResponsibleDifferentThanPatient - bit
          p.ResponsiblePrefix , -- ResponsiblePrefix - varchar(16)
          p.ResponsibleFirstName , -- ResponsibleFirstName - varchar(64)
          p.ResponsibleMiddleName , -- ResponsibleMiddleName - varchar(64)
          p.ResponsibleLastName , -- ResponsibleLastName - varchar(64)
          p.ResponsibleSuffix , -- ResponsibleSuffix - varchar(16)
          p.ResponsibleRelationshipToPatient , -- ResponsibleRelationshipToPatient - varchar(1)
          p.ResponsibleAddressLine1 , -- ResponsibleAddressLine1 - varchar(256)
          p.ResponsibleAddressLine2 , -- ResponsibleAddressLine2 - varchar(256)
          p.ResponsibleCity , -- ResponsibleCity - varchar(128)
          p.ResponsibleState , -- ResponsibleState - varchar(2)
          p.ResponsibleCountry , -- ResponsibleCountry - varchar(32)
          p.ResponsibleZipCode , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.EmploymentStatus , -- EmploymentStatus - char(1)
          p.insuranceprogramcode  , -- InsuranceProgramCode - char(2)
          --prs.PatientReferralSourceID , -- PatientReferralSourceID - int
          pp.DoctorID , -- PrimaryProviderID - int
          CASE WHEN sl.ServiceLocationID IS NULL THEN (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @TargetPracticeID) ELSE sl.ServiceLocationID END , -- DefaultServiceLocationID - int
          emp.EmployerID , -- EmployerID - int
          p.MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
          p.MobilePhone , -- MobilePhone - varchar(10)
          p.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
          pcp.DoctorID , -- PrimaryCarePhysicianID - int
          p.PatientID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          p.CollectionCategoryID , -- CollectionCategoryID - int
          p.active , -- Active - bit
          p.sendemailcorrespondence , -- SendEmailCorrespondence - bit
          p.phonecallremindersenabled , -- PhonecallRemindersEnabled - bit
          p.EmergencyName , -- EmergencyName - varchar(128)
          p.EmergencyPhone , -- EmergencyPhone - varchar(10)
          p.EmergencyPhoneExt , -- EmergencyPhoneExt - varchar(10)
          p.Ethnicity , -- Ethnicity - varchar(64)
          p.Race , -- Race - varchar(64)
          p.LicenseNumber , -- LicenseNumber - varchar(64)
          p.LicenseState , -- LicenseState - varchar(2)
          p.Language1 , -- Language1 - varchar(64)
          p.Language2  -- Language2 - varchar(64)
FROM dbo.[_import_2_1_Patient] p
LEFT JOIN dbo.Doctor pp ON
	p.primaryproviderid = pp.VendorID AND
	pp.PracticeID = @TargetPracticeID
LEFT JOIN dbo.Doctor rd ON 
	p.referringphysicianid = rd.VendorID AND 
	rd.PracticeID = @TargetPracticeID
LEFT JOIN dbo.Doctor pcp ON	
	p.primarycarephysicianid = pcp.VendorID  AND
	pcp.PracticeID = @TargetPracticeID
LEFT JOIN dbo.#tempemp te ON
	p.EmployerID = te.id 
LEFT JOIN dbo.Employers emp ON
	emp.EmployerID = (SELECT TOP 1 emp2.EmployerID FROM dbo.Employers emp2 WHERE te.NAME = emp2.EmployerName)
LEFT JOIN dbo.#tempsl tsl ON
	p.DefaultServiceLocationID = tsl.id 
LEFT JOIN dbo.ServiceLocation sl ON
	tsl.NAME = sl.Name AND
    sl.PracticeID = @TargetPracticeID
WHERE p.PracticeID = @SourcePracticeID AND
	p.CreatedDate > '2016-08-01 00:00:01.000' AND p.CreatedDate < '2016-08-08 23:59:00.000' 
AND NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Insert Into Patient Alert...'
INSERT INTO dbo.PatientAlert
        ( PatientID ,
          AlertMessage ,
          ShowInPatientFlag ,
          ShowInAppointmentFlag ,
          ShowInEncounterFlag ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT 
		  p.PatientID , -- PatientID - int
          pa.AlertMessage , -- AlertMessage - text
          pa.ShowInPatientFlag , -- ShowInPatientFlag - bit
          pa.ShowInAppointmentFlag , -- ShowInAppointmentFlag - bit
          pa.ShowInEncounterFlag , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pa.ShowInClaimFlag , -- ShowInClaimFlag - bit
          pa.ShowInPaymentFlag , -- ShowInPaymentFlag - bit
          pa.ShowInPatientStatementFlag  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_2_1_PatientAlert] pa
INNER JOIN dbo.Patient p ON 
	p.VendorImportID = @VendorImportID AND
	p.VendorID = pa.PatientID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

INSERT INTO dbo.PayerScenario
        ( Name ,
          Description ,
          PayerScenarioTypeID ,
          StatementActive
        )
SELECT DISTINCT
		  i.Name , -- Name - varchar(128)
          i.[Description] , -- Description - varchar(256)
          i.PayerScenarioTypeID , -- PayerScenarioTypeID - int
          i.StatementActive  -- StatementActive - bit
FROM dbo._import_2_1_PayerScenario i
WHERE NOT EXISTS (SELECT * FROM dbo.PayerScenario ps WHERE i.Name = ps.Name)

CREATE TABLE #temppay
( id INT , NAME VARCHAR(128))

INSERT INTO #temppay
        ( id, NAME )
SELECT DISTINCT
		  p.PayerScenarioID, -- id - int
          op.Name  -- NAME - varchar(128)
FROM dbo._import_2_1_PayerScenario p 
INNER JOIN dbo.PayerScenario op ON
	op.Name = p.Name

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
          --WorkersCompContactInfoID ,
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
SELECT    
		  p.PatientID ,
          pc.Name ,
          pc.active  ,
          ps.PayerScenarioID ,
          d.DoctorID ,
          pc.employmentrelatedflag  ,
          pc.autoaccidentrelatedflag  ,
          pc.otheraccidentrelatedflag ,
          pc.abuserelatedflag  ,
          pc.AutoAccidentRelatedState ,
          pc.Notes ,
          pc.showexpiredinsurancepolicies ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          @TargetPracticeID ,
          pc.CaseNumber ,
          --pc.WorkersCompContactInfoID ,
          pc.patientcaseid ,
          @VendorImportID ,
          pc.pregnancyrelatedflag  ,
          pc.statementactive  ,
          pc.epsdt ,
          pc.familyplanning ,
          pc.epsdtcodeid  ,
          pc.emergencyrelated ,
          pc.homeboundrelatedflag 
FROM dbo.[_import_2_1_PatientCase] pc
	INNER JOIN dbo.Patient p ON 
		pc.patientid = p.VendorID AND
		p.VendorImportID = @VendorImportID 
	LEFT JOIN dbo.Doctor d ON 
		pc.ReferringPhysicianID = d.VendorID AND 
	    d.PracticeID = @TargetPracticeID
	LEFT JOIN #temppay tp ON
		pc.PayerScenarioID = tp.id 
	LEFT JOIN dbo.PayerScenario ps ON
		tp.NAME = ps.Name
	--LEFT JOIN dbo.PayerScenario ps ON 
	--	pc.PayerScenarioID = ps.PayerScenarioID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          ip.Precedence ,
          ip.PolicyNumber ,
          ip.GroupNumber ,
          CASE WHEN ISDATE(ip.PolicyStartDate) = 1 THEN ip.policystartdate ELSE NULL END ,
          CASE WHEN ISDATE(ip.PolicyEndDate) = 1 THEN ip.policyenddate ELSE NULL END ,
          ip.CardOnFile ,
          ip.PatientRelationshipToInsured ,
          ip.HolderPrefix ,
          ip.HolderFirstName ,
          ip.HolderMiddleName ,
          ip.HolderLastName ,
          ip.HolderSuffix ,
          ip.HolderDOB ,
          ip.HolderSSN ,
          ip.holderthroughemployer  ,
          ip.HolderEmployerName ,
          ip.PatientInsuranceStatusID ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          ip.HolderGender ,
          ip.HolderAddressLine1 ,
          ip.HolderAddressLine2 ,
          ip.HolderCity ,
          ip.HolderState ,
          ip.HolderCountry ,
          ip.HolderZipCode ,
          ip.HolderPhone ,
          ip.HolderPhoneExt ,
          ip.DependentPolicyNumber ,
          ip.Notes ,
          ip.Phone ,
          ip.PhoneExt ,
          ip.Fax ,
          ip.FaxExt ,
          ip.Copay ,
          ip.Deductible ,
          ip.PatientInsuranceNumber ,
          ip.active  ,
          @TargetPracticeID ,
          ip.AdjusterPrefix ,
          ip.AdjusterFirstName ,
          ip.AdjusterMiddleName ,
          ip.AdjusterLastName ,
          ip.AdjusterSuffix ,
          ip.InsurancePolicyID ,
          @VendorImportID ,
          ip.insuranceprogramtypeid ,
          ip.GroupName ,
          ip.ReleaseOfInformation 
FROM dbo.[_import_2_1_InsurancePolicy] ip
	INNER JOIN dbo.PatientCase pc ON 
		ip.patientcaseid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		ip.InsuranceCompanyPlanID = icp.VendorID AND 
		icp.VendorImportID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy Authorization...'
INSERT INTO dbo.InsurancePolicyAuthorization
        ( InsurancePolicyID ,
          AuthorizationNumber ,
          AuthorizedNumberOfVisits ,
          StartDate ,
          EndDate ,
          ContactFullname ,
          ContactPhone ,
          ContactPhoneExt ,
          AuthorizationStatusID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AuthorizedNumberOfVisitsUsed ,
          VendorID ,
          VendorImportID
        )
SELECT 		
          ip.InsurancePolicyID , -- InsurancePolicyID - int
          i.AuthorizationNumber , -- AuthorizationNumber - varchar(65)
          i.AuthorizedNumberOfVisits , -- AuthorizedNumberOfVisits - int
          i.StartDate , -- StartDate - datetime
          i.EndDate , -- EndDate - datetime
          i.ContactFullname , -- ContactFullname - varchar(65)
          i.ContactPhone , -- ContactPhone - varchar(10)
          i.ContactPhoneExt , -- ContactPhoneExt - varchar(10)
          i.AuthorizationStatusID , -- AuthorizationStatusID - int
          i.Notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.AuthorizedNumberOfVisits , -- AuthorizedNumberOfVisitsUsed - int
          i.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_InsurancePolicyAuthorization] i
INNER JOIN dbo.InsurancePolicy ip ON
	i.InsurancePolicyID = ip.VendorID AND
	ip.VendorImportID = @VendorImportID	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DROP TABLE #tempemp
DROP TABLE #tempsl
DROP TABLE #temppay



--COMMIT 
--ROLLBACK