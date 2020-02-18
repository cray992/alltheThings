USE superbill_4605_dev
--USE superbill_4605_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 20
SET @SourcePracticeID = 15
SET @VendorImportID = 23

SET NOCOUNT ON 

/*
==========================================================================================================================================
QA COUNT CHECK
==========================================================================================================================================
*/

/*
CREATE TABLE #tempdocqa (firstname VARCHAR(65), lastname VARCHAR(65), NPI INT , [External] INT) INSERT INTO #tempdocqa (firstname, lastname, NPI, [External])
SELECT DISTINCT d.firstname ,d.lastname, d.npi, d.[External] FROM dbo.Doctor d WHERE d.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Existing Renderring Doctors To Be Updated] FROM dbo.Doctor d 
INNER JOIN #tempdocqa i ON d.FirstName = i.firstname AND d.LastName = i.lastname AND d.NPI = i.npi
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 0 

SELECT COUNT(*) AS [Existing Referring Doctors To Be Updated] FROM dbo.Doctor d 
INNER JOIN #tempdocqa i ON d.FirstName = i.firstname AND d.LastName = i.lastname AND d.NPI = i.npi
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 1 DROP TABLE #tempdocqa

SELECT DISTINCT COUNT(DISTINCT i.insurancecompanyid) AS [Insurance Company Records To Be Inserted] FROM InsuranceCompany i
INNER JOIN dbo.[InsuranceCompanyPlan] icp ON i.InsuranceCompanyID = icp.InsuranceCompanyID
INNER JOIN dbo.[InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

SELECT COUNT(DISTINCT ptic.pk_id) AS [Practice to Insurance Company Records To Be Inserted] FROM PracticetoInsuranceCompany ptic 
INNER JOIN dbo.InsuranceCompany ic ON ptic.InsuranceCompanyId = ic.InsuranceCompanyID AND ptic.PracticeID = @SourcePracticeID
INNER JOIN dbo.[InsuranceCompanyPlan] icp ON ic.InsuranceCompanyID = icp.InsuranceCompanyID
INNER JOIN dbo.[InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

SELECT COUNT(DISTINCT icp.insurancecompanyplanid) AS [Insurance Company Plan Records To Be Inserted] FROM InsuranceCompanyPlan icp
INNER JOIN dbo.InsuranceCompany ic ON icp.insurancecompanyid = ic.insurancecompanyid
INNER JOIN dbo.[InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

--SELECT COUNT(*) AS [Existing Insurance Company Records to be Updated with ReviewCode] FROM dbo.InsuranceCompany ic
--INNER JOIN dbo.InsuranceCompanyPlan icp ON ic.InsuranceCompanyID = icp.InsuranceCompanyID 
--INNER JOIN dbo.InsurancePolicy ip ON ip.PracticeID = @SourcePracticeID AND icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
--WHERE ic.ReviewCode = '' OR ic.ReviewCode IS NULL

--SELECT COUNT(*) AS [Existing Insurance Company Plan Records to be Updated with ReviewCode] FROM dbo.InsuranceCompanyPlan icp 
--INNER JOIN dbo.InsurancePolicy ip ON ip.PracticeID = @SourcePracticeID AND icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
--WHERE icp.ReviewCode = '' OR icp.ReviewCode IS NULL

SELECT COUNT(*) AS [Referring Provider Records To Be Inserted] FROM dbo.Doctor d 
WHERE NOT EXISTS(SELECT * FROM dbo.Doctor d2 WHERE d.FirstName = d2.FirstName AND d.LastName = d2.LastName AND d.NPI = d2.NPI AND d2.[External] = 1 AND d2.PracticeID = @TargetPracticeID)
AND d.[External] = 1 AND d.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Patients To Be Inserted] FROM dbo.Patient p WHERE p.PracticeID = @SourcePracticeID 
AND NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Patient Alert Records To Be Inserted] FROM dbo.PatientAlert pa 
INNER JOIN dbo.Patient p ON pa.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Patient Journal Records To Be Inserted] FROM dbo.PatientJournalNote pjn
INNER JOIN dbo.Patient p ON pjn.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Patient Case Records To Be Inserted] FROM dbo.PatientCase pc 
INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID AND pc.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Patient Case Date Records To Be Inserted] FROM dbo.PatientCaseDate pcd 
INNER JOIN dbo.PatientCase pc ON pcd.PatientCaseID = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Insurance Policy Records To Be Inserted] FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON ip.patientcaseid = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Insurance Policy Authorization Records To Be Inserted] FROM dbo.InsurancePolicyAuthorization ipa 
INNER JOIN dbo.InsurancePolicy ip ON ipa.InsurancePolicyID = ip.InsurancePolicyID AND ip.PracticeID = @SourcePracticeID
INNER JOIN dbo.PatientCase pc ON ip.PatientCaseID = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment Records To Be Inserted] FROM dbo.Appointment a
INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment Reason Records To Be Inserted] FROM dbo.AppointmentReason ars
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ars.Name = ar.Name AND ar.PracticeID = @TargetPracticeID) AND ars.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Practice Resource Records To Be Inserted] FROM dbo.PracticeResource prs 
WHERE NOT EXISTS (SELECT * FROM dbo.PracticeResource pr WHERE prs.ResourceName = pr.resourcename AND prs.PracticeID = @TargetPracticeID) and prs.practiceid = @SourcePracticeID

SELECT COUNT(*) AS [Appointment to Appointment Reason Records To Be Inserted] FROM dbo.AppointmentToAppointmentReason atar 
INNER JOIN dbo.Appointment a ON atar.AppointmentID = a.AppointmentID
INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment to Resource - Doctor Resource Records To Be Inserted] FROM dbo.AppointmentToResource atr
INNER JOIN dbo.Appointment a ON atr.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
AND atr.AppointmentResourceTypeID = 1 AND atr.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Appointment to Resource - Practice Resource Records To Be Inserted] FROM dbo.AppointmentToResource atr
INNER JOIN dbo.Appointment a ON atr.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
AND atr.AppointmentResourceTypeID = 2 AND atr.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Appointment Recurrence Records To Be Inserted] FROM dbo.AppointmentRecurrence ar 
INNER JOIN dbo.Appointment a ON ar.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment Recurrence Exception Records To Be Inserted] FROM dbo.AppointmentRecurrenceException are 
INNER JOIN dbo.Appointment a ON are.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
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

CREATE TABLE #tempdoc (doctorid INT, firstname VARCHAR(65), lastname VARCHAR(65), NPI INT , [External] INT)
INSERT INTO #tempdoc (doctorid, firstname, lastname, NPI , [External] )
SELECT DISTINCT
		  d.doctorid ,
		  d.firstname ,-- firstname - varchar(65)
          d.lastname, -- lastname - varchar(65)
          d.npi ,  -- NPI - int
		  d.[External]
FROM dbo.Doctor d 
WHERE d.PracticeID = @SourcePracticeID 

PRINT ''
PRINT 'Updating Existing Rendering Doctor Records with VendorID...'
UPDATE dbo.Doctor 
	SET VendorID = i.DoctorID
FROM dbo.Doctor d
INNER JOIN #tempdoc i ON
	i.FirstName = d.FirstName AND
    i.LastName = d.LastName AND
    i.NPI = d.NPI 
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Existing Referring Doctor Records with VendorID...'
UPDATE dbo.Doctor 
	SET VendorID = i.DoctorID
FROM dbo.Doctor d
INNER JOIN #tempdoc i ON
	i.FirstName = d.FirstName AND
    i.LastName = d.LastName AND
    i.NPI = d.NPI 
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Doctor...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          SSN ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          HomePhone ,
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          PagerPhone ,
          PagerPhoneExt ,
          MobilePhone ,
          MobilePhoneExt ,
          DOB ,
          EmailAddress ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          TaxonomyCode ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          FaxNumberExt ,
          [External] ,
          NPI ,
          ProviderTypeID ,
          ProviderPerformanceReportActive ,
          ProviderPerformanceScope ,
          ProviderPerformanceFrequency ,
          ProviderPerformanceDelay ,
          ProviderPerformanceCarbonCopyEmailRecipients ,
          ExternalBillingID ,
          GlobalPayToAddressFlag ,
          GlobalPayToName ,
          GlobalPayToAddressLine1 ,
          GlobalPayToAddressLine2 ,
          GlobalPayToCity ,
          GlobalPayToState ,
          GlobalPayToZipCode ,
          GlobalPayToCountry ,
          KareoSpecialtyId
        )
SELECT 
		  @TargetPracticeID , -- PracticeID - int
          i.prefix , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          i.MiddleName , -- MiddleName - varchar(64)
          i.LastName , -- LastName - varchar(64)
          i.Suffix , -- Suffix - varchar(16)
          i.SSN , -- SSN - varchar(9)
          i.AddressLine1 , -- AddressLine1 - varchar(256)
          i.AddressLine2 , -- AddressLine2 - varchar(256)
          i.City , -- City - varchar(128)
          i.State , -- State - varchar(2)
          i.Country , -- Country - varchar(32)
          i.ZipCode , -- ZipCode - varchar(9)
          i.HomePhone , -- HomePhone - varchar(10)
          i.HomePhoneExt , -- HomePhoneExt - varchar(10)
          i.WorkPhone , -- WorkPhone - varchar(10)
          i.WorkPhoneExt , -- WorkPhoneExt - varchar(10)
          i.PagerPhone , -- PagerPhone - varchar(10)
          i.PagerPhoneExt , -- PagerPhoneExt - varchar(10)
          i.MobilePhone , -- MobilePhone - varchar(10)
          i.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
          i.DOB , -- DOB - datetime
          i.EmailAddress , -- EmailAddress - varchar(256)
          i.Notes , -- Notes - text
          i.ActiveDoctor , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.Degree , -- Degree - varchar(8)
          i.TaxonomyCode , -- TaxonomyCode - char(10)
          i.DoctorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          i.FaxNumber , -- FaxNumber - varchar(10)
          i.FaxNumberExt , -- FaxNumberExt - varchar(10)
          i.[External] , -- External - bit
          i.NPI , -- NPI - varchar(10)
          i.ProviderTypeID , -- ProviderTypeID - int
          i.ProviderPerformanceReportActive , -- ProviderPerformanceReportActive - bit
          i.ProviderPerformanceScope , -- ProviderPerformanceScope - int
          i.ProviderPerformanceFrequency , -- ProviderPerformanceFrequency - char(1)
          i.ProviderPerformanceDelay , -- ProviderPerformanceDelay - int
          i.ProviderPerformanceCarbonCopyEmailRecipients , -- ProviderPerformanceCarbonCopyEmailRecipients - varchar(max)
          i.ExternalBillingID , -- ExternalBillingID - varchar(50)
          i.GlobalPayToAddressFlag , -- GlobalPayToAddressFlag - bit
          i.GlobalPayToName , -- GlobalPayToName - varchar(128)
          i.GlobalPayToAddressLine1 , -- GlobalPayToAddressLine1 - varchar(256)
          i.GlobalPayToAddressLine2 , -- GlobalPayToAddressLine2 - varchar(256)
          i.GlobalPayToCity , -- GlobalPayToCity - varchar(128)
          i.GlobalPayToState , -- GlobalPayToState - varchar(2)
          i.GlobalPayToZipCode , -- GlobalPayToZipCode - varchar(9)
          i.GlobalPayToCountry , -- GlobalPayToCountry - varchar(32)
          i.KareoSpecialtyId  -- KareoSpecialtyId - int
FROM dbo.[Doctor] i WHERE i.PracticeID = @SourcePracticeID AND i.[External] = 1 AND
NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE d.VendorID = i.DoctorID AND d.PracticeID = @TargetPracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

CREATE TABLE #tempemp
( id INT , NAME VARCHAR(128))

INSERT INTO #tempemp
        ( id, NAME )
SELECT DISTINCT
		  e.EmployerID, -- id - int
          oe.EmployerName  -- NAME - varchar(128)
FROM dbo.[Employers] e 
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
INNER JOIN dbo.ServiceLocation osl ON
	osl.Name = sl.Name and
	OSl.PracticeID = @TargetPracticeID

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
FROM dbo.[Patient] p
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
WHERE p.PracticeID = @SourcePracticeID 
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
FROM dbo.[PatientAlert] pa
INNER JOIN dbo.Patient p ON 
	p.VendorImportID = @VendorImportID AND
	p.VendorID = pa.PatientID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT''
PRINT'Inserting into PatientJournalNotes ...'
INSERT INTO dbo.PatientJournalNote
        ( 
		  CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          Hidden ,
          NoteMessage ,
          AccountStatus ,
          NoteTypeCode ,
          LastNote
        )
SELECT DISTINCT
		  pjn.createddate  ,
          0 ,
          GETDATE() ,
          0 ,
          p.PatientID ,
          pjn.UserName ,
          pjn.SoftwareApplicationID ,
          pjn.hidden  ,
          pjn.NoteMessage ,
          pjn.AccountStatus ,
          pjn.NoteTypeCode ,
          pjn.lastnote 
FROM dbo.[PatientJournalNote] pjn
	INNER JOIN dbo.Patient p ON
		pjn.patientid = p.VendorID AND 
		p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Payment...'
INSERT INTO dbo.Payment
        ( PracticeID ,
          PaymentAmount ,
          PaymentMethodCode ,
          PayerTypeCode ,
          PayerID ,
          PaymentNumber ,
          Description ,
          CreatedDate ,
          ModifiedDate ,
          SourceEncounterID ,
          PostingDate ,
          PaymentTypeID ,
          DefaultAdjustmentCode ,
          BatchID ,
          CreatedUserID ,
          ModifiedUserID ,
          SourceAppointmentID ,
          EOBEditable ,
          AdjudicationDate ,
          ClearinghouseResponseID ,
          ERAErrors ,
          AppointmentID ,
          AppointmentStartDate ,
          PaymentCategoryID ,
          overrideClosingDate ,
          IsOnline
        )
SELECT DISTINCT
		  @TargetPracticeID , -- PracticeID - int
          REPLACE(REPLACE(i.creditbalance,'(',''),')','') , -- PaymentAmount - money
          'C' , -- PaymentMethodCode - char(1)
          'P' , -- PayerTypeCode - char(1)
          p.PatientID , -- PayerID - int
          NULL , -- PaymentNumber - varchar(30)
          'Patient Credit Forward Payment. Please verify before use.' , -- Description - varchar(250)
          GETDATE() , -- CreatedDate - datetime
          GETDATE() , -- ModifiedDate - datetime
          NULL , -- SourceEncounterID - int
          GETDATE() , -- PostingDate - datetime
          0 , -- PaymentTypeID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          'CreditFwd' , -- BatchID - varchar(50)
          0 , -- CreatedUserID - int
          0 , -- ModifiedUserID - int
          NULL , -- SourceAppointmentID - int
          1 , -- EOBEditable - bit
          NULL , -- AdjudicationDate - datetime
          NULL , -- ClearinghouseResponseID - int
          NULL , -- ERAErrors - xml
          NULL , -- AppointmentID - int
          NULL , -- AppointmentStartDate - datetime
          NULL , -- PaymentCategoryID - int
          0 , -- overrideClosingDate - bit
          0  -- IsOnline - bit
FROM dbo.[_import_43_20_rptPatientCollectionsDetail] i	
INNER JOIN dbo.Patient p ON
	i.id = p.VendorID AND 
	p.PracticeID = @TargetPracticeID AND
    p.VendorImportID = @VendorImportID
WHERE i.creditbalance <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Payment Patient...'
INSERT INTO dbo.PaymentPatient
        ( PaymentID, PatientID, PracticeID )
SELECT DISTINCT
		  pay.PaymentID, -- PaymentID - int
          p.PatientID, -- PatientID - int
          @TargetPracticeID  -- PracticeID - int
FROM dbo.Patient p 
INNER JOIN dbo.Payment pay ON
	p.PatientID = pay.PayerID AND
	pay.PracticeID = @TargetPracticeID
WHERE pay.CreatedDate > DATEADD(mi,-1,GETDATE()) AND pay.PayerTypeCode = 'P' AND pay.BatchID = 'CreditFwd'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Unapplied Payments...'
INSERT INTO dbo.UnappliedPayments
        ( PracticeID, PaymentID )
SELECT DISTINCT
		  @TargetPracticeID, -- PracticeID - int
          pay.PaymentID  -- PaymentID - int
FROM dbo.Payment pay
WHERE pay.CreatedDate > DATEADD(mi,-1,GETDATE()) AND pay.PayerTypeCode = 'P' AND pay.BatchID = 'CreditFwd'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
          pat.PatientID , -- PatientID - int
          'Balance Forward' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @TargetPracticeID , -- PracticeID - int
          Pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient as pat 
INNER JOIN dbo.[_import_43_20_rptPatientCollectionsDetail] AS m ON
   pat.VendorID = m.id AND 
   pat.VendorImportID = @VendorImportID 
WHERE m.balance <> '' AND m.balance > '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE DiagnosisCode='000.00')
BEGIN

INSERT INTO dbo.DiagnosisCodeDictionary 
        ( 
		  DiagnosisCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          OfficialName ,
          LocalName ,
          OfficialDescription    
        )
VALUES  
       ( 
          '000.00' , -- DiagnosisCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- Active - bit
         'Miscellaneous' ,  -- OfficialName - varchar(300)
         'Miscellaneous' ,  -- LocalName - varchar(100)
          NULL  -- OfficialDescription - varchar(500) 
        )
END

PRINT ''
PRINT 'Inserting Into Encounter...'
INSERT INTO dbo.Encounter
        ( PracticeID ,
          PatientID ,
          DoctorID ,
          LocationID ,
          DateOfService ,
          DateCreated ,
          Notes ,
          EncounterStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReleaseSignatureSourceCode ,
          PlaceOfServiceCode ,
          PatientCaseID ,
          PostingDate ,
          DateOfServiceTo ,
          PaymentMethod ,
          AddOns ,
          DoNotSendElectronic ,
          SubmittedDate ,
          PaymentTypeID ,
          VendorID ,
          VendorImportID ,
          DoNotSendElectronicSecondary ,
          overrideClosingDate ,
          ClaimTypeID ,
          SecondaryClaimTypeID ,
          SubmitReasonIDCMS1500 ,
          SubmitReasonIDUB04 ,
          PatientCheckedIn 
        )
SELECT DISTINCT
          @TargetPracticeID , -- PracticeID - int
          pc.PatientID , -- PatientID - int
          CASE WHEN PAT.PrimaryProviderID IS NULL THEN Doc.DoctorID ELSE PAT.PrimaryProviderID END , -- DoctorID - int
          CASE WHEN PAT.DefaultServiceLocationID IS NULL THEN SL.ServiceLocationID ELSE PAT.DefaultServiceLocationID END , -- LocationID - int
          GETDATE() , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          Convert(Varchar(10), GETDATE(),101) + ' : Balance Forward Created, please verify before use.' , -- Notes - text
          2 , -- EncounterStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
          pc.PatientCaseID , -- PatientCaseID - int       
          GETDATE() , -- PostingDate - datetime
          GETDATE() , -- DateOfServiceTo - datetime
          'U' , -- PaymentMethod - char(1)
          0 , -- AddOns - bigint
          0 , -- DoNotSendElectronic - bit
          GETDATE() , -- SubmittedDate - datetime
          0 , -- PaymentTypeID - int
          pc.VendorID , -- VendorID - varchar(50)                
          @VendorImportID , -- VendorImportID - int
          0 , -- DoNotSendElectronicSecondary - bit
          0 , -- overrideClosingDate - bit
          0 , -- ClaimTypeID - int
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
          0  -- PatientCheckedIn - bit
FROM dbo.PatientCase AS PC  
INNER JOIN dbo.Patient PAT ON
	PC.PatientID = PAT.PatientID AND
	PC.VendorID = PAT.VendorID  
LEFT JOIN dbo.Doctor Doc ON
	Doc.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS D WHERE d.ActiveDoctor =1 AND d.[External] = 0 AND d.PracticeID = @TargetPracticeID AND d.ActiveDoctor = 1)
LEFT JOIN dbo.ServiceLocation SL ON
	SL.ServicelocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation S WHERE s.PracticeID = @TargetPracticeID)
WHERE pc.Name = 'Balance Forward' AND pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Encounter Diagnosis...'
INSERT INTO dbo.EncounterDiagnosis
        ( 
		  EncounterID ,
          DiagnosisCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          ListSequence ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
          enc.EncounterID , -- EncounterID - int
          dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          1 , -- ListSequence - int
          @TargetPracticeID  , -- PracticeID - int
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Encounter as enc 
INNER JOIN dbo.DiagnosisCodeDictionary AS dcd ON
    dcd.DiagnosisCode = '000.00' AND 
    enc.PracticeID = @TargetPracticeID        
WHERE enc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Encounter Procedure...'
INSERT INTO dbo.EncounterProcedure
        ( 
		  EncounterID ,
          ProcedureCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ServiceChargeAmount ,   
          ServiceUnitCount ,
          ProcedureDateOfService ,
          PracticeID ,
          EncounterDiagnosisID1 ,
          ServiceEndDate ,
          VendorID ,
          VendorImportID ,
          TypeOfServiceCode ,
          AnesthesiaTime ,
          AssessmentDate ,
          DoctorID ,
          ConcurrentProcedures 
        )
SELECT DISTINCT
          enc.EncounterID  , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pd.balance , -- ServiceChargeAmount - money   
          '1.000' , -- ServiceUnitCount - decimal
          GETDATE() , -- ProcedureDateOfService - datetime
          @TargetPracticeID , -- PracticeID - int
          ed.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
          GETDATE() , -- ServiceEndDate - datetime
          enc.VendorID , -- VendorID - varchar(50)              
          @VendorImportID , -- VendorImportID - int
          '1' , -- TypeOfServiceCode - char(1)
          0 , -- AnesthesiaTime - int
          GETDATE() , -- AssessmentDate - datetime
          enc.DoctorID , -- DoctorID - int
          1  -- ConcurrentProcedures - int
FROM dbo.Encounter AS enc
INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
   pcd.OfficialName = 'Balance Forward' AND 
   enc.PracticeID = @TargetPracticeID
INNER JOIN dbo.EncounterDiagnosis AS ed ON
   ed.vendorID = enc.VendorID AND 
   enc.VendorImportID = @VendorImportID   
INNER JOIN dbo.[_import_43_20_rptPatientCollectionsDetail] as pd ON 
    pd.id = enc.vendorID AND 
	enc.PracticeID = @TargetPracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



DROP TABLE #tempdoc
DROP TABLE #tempemp
DROP TABLE #tempsl





--COMMIT 
--ROLLBACK
