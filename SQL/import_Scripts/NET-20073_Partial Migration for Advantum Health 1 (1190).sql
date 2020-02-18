--USE superbill_1190_dev
USE superbill_1190_prod
GO
--rollback
--commit
SET XACT_ABORT ON

BEGIN TRANSACTION

--SELECT* FROM  dbo.InsuranceCompanyPlan WHERE CreatedPracticeID=54 ORDER BY PlanName,addressline1
DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 53
SET @SourcePracticeID = 44
SET @VendorImportID = 16

SET NOCOUNT ON 

PRINT 'Source PracticeID = ' + CAST(@SourcePracticeID AS VARCHAR) 
PRINT 'Target PracticeID = ' + CAST(@TargetPracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR) 
----rollback
----SELECT * FROM dbo.InsuranceCompany WHERE CreatedPracticeID=51
--/*
--==========================================================================================================================================
--QA COUNT CHECK
--==========================================================================================================================================
--*/

--/**/
--CREATE TABLE #tempdocqa (firstname VARCHAR(65), lastname VARCHAR(65), NPI INT , [External] INT) INSERT INTO #tempdocqa (firstname, lastname, NPI, [External])
--SELECT DISTINCT d.firstname ,d.lastname, d.npi, d.[External] FROM dbo.Doctor d WHERE d.PracticeID = @SourcePracticeID

--SELECT COUNT(*) AS [Existing Renderring Doctors To Be Updated] FROM dbo.Doctor d 
--INNER JOIN #tempdocqa i ON d.FirstName = i.firstname AND d.LastName = i.lastname AND d.NPI = i.npi
--WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 0 

--SELECT COUNT(*) AS [Existing Referring Doctors To Be Updated] FROM dbo.Doctor d 
--INNER JOIN #tempdocqa i ON d.FirstName = i.firstname AND d.LastName = i.lastname AND d.NPI = i.npi
--WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 1 DROP TABLE #tempdocqa

----SELECT DISTINCT COUNT(DISTINCT i.insurancecompanyid) AS [Insurance Company Records To Be Inserted] FROM InsuranceCompany i
----INNER JOIN dbo.[InsuranceCompanyPlan] icp ON i.InsuranceCompanyID = icp.InsuranceCompanyID
----INNER JOIN dbo.[InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

----SELECT COUNT(DISTINCT ptic.pk_id) AS [Practice to Insurance Company Records To Be Inserted] FROM PracticetoInsuranceCompany ptic 
----INNER JOIN dbo.InsuranceCompany ic ON ptic.InsuranceCompanyId = ic.InsuranceCompanyID AND ptic.PracticeID = @SourcePracticeID
----INNER JOIN dbo.[InsuranceCompanyPlan] icp ON ic.InsuranceCompanyID = icp.InsuranceCompanyID
----INNER JOIN dbo.[InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

----SELECT COUNT(DISTINCT icp.insurancecompanyplanid) AS [Insurance Company Plan Records To Be Inserted] FROM InsuranceCompanyPlan icp
----INNER JOIN dbo.InsuranceCompany ic ON icp.insurancecompanyid = ic.insurancecompanyid
----INNER JOIN dbo.[InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

----SELECT COUNT(*) AS [Existing Insurance Company Records to be Updated with ReviewCode] FROM dbo.InsuranceCompany ic
----INNER JOIN dbo.InsuranceCompanyPlan icp ON ic.InsuranceCompanyID = icp.InsuranceCompanyID 
----INNER JOIN dbo.InsurancePolicy ip ON ip.PracticeID = @SourcePracticeID AND icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
----WHERE ic.ReviewCode = '' OR ic.ReviewCode IS NULL

----SELECT COUNT(*) AS [Existing Insurance Company Plan Records to be Updated with ReviewCode] FROM dbo.InsuranceCompanyPlan icp 
----INNER JOIN dbo.InsurancePolicy ip ON ip.PracticeID = @SourcePracticeID AND icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
----WHERE icp.ReviewCode = '' OR icp.ReviewCode IS NULL

----SELECT COUNT(*) AS [Referring Provider Records To Be Inserted] FROM dbo.Doctor d 
----WHERE NOT EXISTS(SELECT * FROM dbo.Doctor d2 WHERE d.FirstName = d2.FirstName AND d.LastName = d2.LastName AND d.NPI = d2.NPI AND d2.[External] = 1 AND d2.PracticeID = @TargetPracticeID)
----AND d.[External] = 1 AND d.PracticeID = @SourcePracticeID

--SELECT COUNT(*) AS [Patients To Be Inserted] FROM dbo.Patient p WHERE p.PracticeID = @SourcePracticeID 
--AND NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Patient Alert Records To Be Inserted] FROM dbo.PatientAlert pa 
--INNER JOIN dbo.Patient p ON pa.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Patient Journal Records To Be Inserted] FROM dbo.PatientJournalNote pjn
--INNER JOIN dbo.Patient p ON pjn.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Patient Case Records To Be Inserted] FROM dbo.PatientCase pc 
--INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID AND pc.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Patient Case Date Records To Be Inserted] FROM dbo.PatientCaseDate pcd 
--INNER JOIN dbo.PatientCase pc ON pcd.PatientCaseID = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
--INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Insurance Policy Records To Be Inserted] FROM dbo.InsurancePolicy ip
--INNER JOIN dbo.PatientCase pc ON ip.patientcaseid = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
--INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Insurance Policy Authorization Records To Be Inserted] FROM dbo.InsurancePolicyAuthorization ipa 
--INNER JOIN dbo.InsurancePolicy ip ON ipa.InsurancePolicyID = ip.InsurancePolicyID AND ip.PracticeID = @SourcePracticeID
--INNER JOIN dbo.PatientCase pc ON ip.PatientCaseID = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
--INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Appointment Records To Be Inserted] FROM dbo.Appointment a
--INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Appointment Reason Records To Be Inserted] FROM dbo.AppointmentReason ars
--WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ars.Name = ar.Name AND ar.PracticeID = @TargetPracticeID) AND ars.PracticeID = @SourcePracticeID

--SELECT COUNT(*) AS [Practice Resource Records To Be Inserted] FROM dbo.PracticeResource prs 
--WHERE NOT EXISTS (SELECT * FROM dbo.PracticeResource pr WHERE prs.ResourceName = pr.resourcename AND prs.PracticeID = @TargetPracticeID) and prs.practiceid = @SourcePracticeID

--SELECT COUNT(*) AS [Appointment to Appointment Reason Records To Be Inserted] FROM dbo.AppointmentToAppointmentReason atar 
--INNER JOIN dbo.Appointment a ON atar.AppointmentID = a.AppointmentID
--INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Appointment to Resource - Doctor Resource Records To Be Inserted] FROM dbo.AppointmentToResource atr
--INNER JOIN dbo.Appointment a ON atr.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
--INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
--AND atr.AppointmentResourceTypeID = 1 AND atr.PracticeID = @SourcePracticeID

--SELECT COUNT(*) AS [Appointment to Resource - Practice Resource Records To Be Inserted] FROM dbo.AppointmentToResource atr
--INNER JOIN dbo.Appointment a ON atr.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
--INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
--AND atr.AppointmentResourceTypeID = 2 AND atr.PracticeID = @SourcePracticeID

--SELECT COUNT(*) AS [Appointment Recurrence Records To Be Inserted] FROM dbo.AppointmentRecurrence ar 
--INNER JOIN dbo.Appointment a ON ar.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
--INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Appointment Recurrence Exception Records To Be Inserted] FROM dbo.AppointmentRecurrenceException are 
--INNER JOIN dbo.Appointment a ON are.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
--INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 




/*
==========================================================================================================================================
DELETE SCRIPT
==========================================================================================================================================
*/

/*
DELETE FROM dbo.InsurancePolicyAuthorization WHERE InsurancePolicyID IN (SELECT InsurancePolicyID FROM dbo.InsurancePolicy WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy Auth records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.AppointmentRecurrenceException WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment  WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Recurr Excep records deleted'
DELETE FROM dbo.AppointmentRecurrence WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment  WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Recurr records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @TargetPracticeID)
DELETE FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.ServiceLocation WHERE VendorImportID = @VendorImportID AND PracticeID = @TargetPracticeID
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Service Location records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.PracticeToInsuranceCompany WHERE PracticeID = @TargetPracticeID AND InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Practice To Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
*/
--SELECT * FROM dbo.InsuranceCompany
--CREATE TABLE #tempinsurance (insurancecompanyid INT, insurancecompanyname VARCHAR(70), billsecondaryinsurance BIT, eclaims BIT, billingform INT, insprogcode VARCHAR(2), 
--	hcfadiag VARCHAR(1), hcfasame VARCHAR(1), reviewcode CHAR(1), secprecbfid INT, ndcformat INT, anethesia VARCHAR(1) )

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany

        ( InsuranceCompanyName ,
          AddressLine1 ,
		  AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactFirstName ,
          ContactLastName ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,
          BillSecondaryInsurance ,
		  EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
		  CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID ,
		  ClearinghousePayerID
        )
SELECT DISTINCT
          i.name, -- InsuranceCompanyName - varchar(128)
          i.AddressLine1 , -- AddressLine1 - varchar(256)
		  i.addressline2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          i.country , -- Country - varchar(32)
          i.zipcode , -- ZipCode - varchar(9)
          i.contactfirstname , -- ContactFirstName - varchar(64)
          i.contactlastname , -- ContactLastName - varchar(64)
          i.contactphone , -- Phone - varchar(10)
          i.contactphoneext , -- PhoneExt - varchar(10)
          i.contactfax , -- Fax - varchar(10)
          i.contactfaxext , -- FaxExt - varchar(10)
          i.autobillssecondaryinsurance , -- BillSecondaryInsurance - bit
		  1 , -- EClaimsAccepts - bit ,
          19 , -- BillingFormID - int
		  CASE WHEN ip.InsuranceProgramCode IS NULL THEN 'CI' ELSE ip.InsuranceProgramCode END , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @TargetPracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          19 , -- SecondaryPrecedenceBillingFormID - int
          i.insurancecompanyid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18 ,  -- InstitutionalBillingFormID - int
		  i.clearinghousepayerid
	 ----SELECT * FROM dbo.InsuranceProgram
		--FROM dbo.[InsuranceCompany] AS i
		--	LEFT JOIN dbo.InsuranceProgram AS ip ON
		--		i.InsuranceProgramCode = ip.InsuranceProgramCode
		--WHERE EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE ic.InsuranceCompanyName = i.InsuranceCompanyName AND i.CreatedPracticeID = @SourcePracticeID) 

FROM dbo._import_7_51_InsuranceCompany i
	LEFT JOIN dbo.InsuranceProgram ip ON
		i.insuranceprogram = ip.ProgramName 
	INNER JOIN dbo.[_import_7_51_CaseInformation] ci ON
		i.insurancecompanyid = ci.primaryinsurancepolicycompanyid OR
		i.insurancecompanyid = ci.secondaryinsurancepolicycompanyid OR
		i.insurancecompanyid = ci.tertiaryinsurancepolicycompanyid 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          Phone ,
          PhoneExt ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  ip.planname , -- PlanName - varchar(128)
          ip.addressline1 , -- AddressLine1 - varchar(256)
          ip.addressline2 , -- AddressLine2 - varchar(256)
          ip.city , -- City - varchar(128)
          ip.state , -- State - varchar(2)
          ip.country , -- Country - varchar(32)
          ip.zipcode , -- ZipCode - varchar(9)
          ip.contactfirstname , -- ContactFirstName - varchar(64)
          ip.contactmiddlename , -- ContactMiddleName - varchar(64)
          ip.contactlastname , -- ContactLastName - varchar(64)
          ip.contactphone , -- Phone - varchar(10)
          ip.contactphoneext , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @TargetPracticeID , -- CreatedPracticeID - int
          ip.contactfax , -- Fax - varchar(10)
          ip.contactfaxext , -- FaxExt - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ip.insurancecompanyplanid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int

--FROM dbo.[InsuranceCompanyPlan] AS ip
--INNER JOIN dbo.InsuranceCompany AS ic ON 
--	ic.VendorID = ip.insurancecompanyid AND 
--	VendorImportID = @VendorImportID AND 
--	ic.CreatedPracticeID = @TargetPracticeID

FROM dbo.[_import_7_51_InsuranceCompanyPlan] ip
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.VendorID = ip.insurancecompanyid AND 
	VendorImportID = @VendorImportID AND 
	ic.CreatedPracticeID = @TargetPracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
    

PRINT ''
PRINT 'Updating Insurance Company Review Code...'
UPDATE dbo.InsuranceCompany 
	SET ReviewCode = 'R'
FROM dbo.InsuranceCompany ic 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	ic.InsuranceCompanyID = icp.InsuranceCompanyID 
INNER JOIN dbo.InsurancePolicy ip ON 
	ip.PracticeID = @SourcePracticeID AND 
	icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
WHERE ic.ReviewCode = '' OR ic.ReviewCode IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Company Plan Review Code...'
UPDATE dbo.InsuranceCompanyPlan  
	SET ReviewCode = 'R'
FROM dbo.InsuranceCompanyPlan icp 
INNER JOIN dbo.InsurancePolicy ip ON 
	ip.PracticeID = @SourcePracticeID AND 
	icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
WHERE icp.ReviewCode = '' OR icp.ReviewCode IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

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
          --DefaultServiceLocationID ,
          --EmployerID ,
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
          --CASE WHEN sl.ServiceLocationID IS NULL THEN (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @TargetPracticeID) ELSE sl.ServiceLocationID END , -- DefaultServiceLocationID - int
          --emp.EmployerID , -- EmployerID - int
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
PRINT 'Inserting Into Patient Alert...'
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
          i.alertmessage , -- AlertMessage - text
          i.ShowInPatientFlag , -- ShowInPatientFlag - bit
          i.ShowInAppointmentFlag , -- ShowInAppointmentFlag - bit
          i.ShowInEncounterFlag , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.ShowInClaimFlag , -- ShowInClaimFlag - bit
          i.ShowInPaymentFlag , -- ShowInPaymentFlag - bit
          i.ShowInPatientStatementFlag -- ShowInPatientStatementFlag - bit

FROM [dbo].[PatientAlert] i 
	INNER JOIN dbo.Patient p ON
		i.patientid = p.VendorID AND 
		p.VendorImportID = @VendorImportID
WHERE EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

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
          pc.PayerScenarioID ,
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
FROM dbo.[PatientCase] pc
	INNER JOIN dbo.Patient p ON 
		pc.patientid = p.VendorID AND
		p.VendorImportID = @VendorImportID 
	LEFT JOIN dbo.Doctor d ON 
		pc.ReferringPhysicianID = d.VendorID AND 
	    d.PracticeID = @TargetPracticeID
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
          ip.InsuranceCompanyPlanID ,
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
FROM dbo.[InsurancePolicy] ip
	INNER JOIN dbo.PatientCase pc ON 
		ip.patientcaseid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--SELECT * FROM dbo.ContractsAndFees_StandardFeeSchedule

PRINT''
PRINT'Inserting into Standard Fee Schedule...'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
(
    PracticeID,
    Name,
    Notes,
    EffectiveStartDate,
    SourceType,
    SourceFileName,
    EClaimsNoResponseTrigger,
    PaperClaimsNoResponseTrigger,
    MedicareFeeScheduleGPCICarrier,
    MedicareFeeScheduleGPCILocality,
    MedicareFeeScheduleGPCIBatchID,
    MedicareFeeScheduleRVUBatchID,
    AddPercent,
    AnesthesiaTimeIncrement
)
SELECT 
    @TargetPracticeID,         -- PracticeID - int
    a.Name,        -- Name - varchar(128)
    a.Notes,        -- Notes - varchar(1024)
    GETDATE(), -- EffectiveStartDate - datetime
    a.SourceType,        -- SourceType - char(1)
    a.SourceFileName,        -- SourceFileName - varchar(256)
    a.EClaimsNoResponseTrigger,         -- EClaimsNoResponseTrigger - int
    a.PaperClaimsNoResponseTrigger,         -- PaperClaimsNoResponseTrigger - int
    a.MedicareFeeScheduleGPCICarrier,         -- MedicareFeeScheduleGPCICarrier - int
    a.MedicareFeeScheduleGPCILocality,         -- MedicareFeeScheduleGPCILocality - int
    a.MedicareFeeScheduleGPCIBatchID,         -- MedicareFeeScheduleGPCIBatchID - int
    a.MedicareFeeScheduleRVUBatchID,         -- MedicareFeeScheduleRVUBatchID - int
    a.AddPercent,      -- AddPercent - decimal(18, 0)
    a.AnesthesiaTimeIncrement          -- AnesthesiaTimeIncrement - int
     --select 
FROM dbo.ContractsAndFees_StandardFeeSchedule a 
WHERE a.PracticeID=@SourcePracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

----SELECT * FROM dbo.ContractsAndFees_StandardFee

PRINT''
PRINT'Inserting into Standard Fee...'

INSERT INTO dbo.ContractsAndFees_StandardFee
(
    StandardFeeScheduleID,
    ProcedureCodeID,
    ModifierID,
    SetFee,
    AnesthesiaBaseUnits
)
SELECT 
    (SELECT a.StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule a WHERE a.PracticeID=@TargetPracticeID),    -- StandardFeeScheduleID - int
    sf.ProcedureCodeID,    -- ProcedureCodeID - int
    sf.ModifierID,    -- ModifierID - int
    sf.SetFee, -- SetFee - money
    sf.AnesthesiaBaseUnits     -- AnesthesiaBaseUnits - int

	--SELECT sf.* 
FROM dbo.ContractsAndFees_StandardFee sf
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON sfs.StandardFeeScheduleID=sf.StandardFeeScheduleID
WHERE sf.StandardFeeScheduleID=sfs.StandardFeeScheduleID AND sfs.PracticeID=@SourcePracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--SELECT * FROM dbo.ContractsAndFees_StandardFeeSchedule
--SELECT * FROM dbo.ContractsAndFees_StandardFee

PRINT''
PRINT'Inserting into Contract Rate Schedule...'
INSERT INTO dbo.ContractsAndFees_ContractRateSchedule

(
    PracticeID,
	InsuranceCompanyID,
    EffectiveStartDate,
	EffectiveEndDate,
    SourceType,
    SourceFileName,
    EClaimsNoResponseTrigger,
    PaperClaimsNoResponseTrigger,
    MedicareFeeScheduleGPCICarrier,
    MedicareFeeScheduleGPCILocality,
    MedicareFeeScheduleGPCIBatchID,
    MedicareFeeScheduleRVUBatchID,
    AddPercent,
    AnesthesiaTimeIncrement,
	Capitated
)
SELECT 
    @TargetPracticeID,         -- PracticeID - int
	a.InsuranceCompanyID,
    GETDATE(), -- EffectiveStartDate - datetime
	a.EffectiveEndDate, --EffectiveEndDate
    a.SourceType,        -- SourceType - char(1)
    a.SourceFileName,        -- SourceFileName - varchar(256)
    a.EClaimsNoResponseTrigger,         -- EClaimsNoResponseTrigger - int
    a.PaperClaimsNoResponseTrigger,         -- PaperClaimsNoResponseTrigger - int
    a.MedicareFeeScheduleGPCICarrier,         -- MedicareFeeScheduleGPCICarrier - int
    a.MedicareFeeScheduleGPCILocality,         -- MedicareFeeScheduleGPCILocality - int
    a.MedicareFeeScheduleGPCIBatchID,         -- MedicareFeeScheduleGPCIBatchID - int
    a.MedicareFeeScheduleRVUBatchID,         -- MedicareFeeScheduleRVUBatchID - int
    a.AddPercent,      -- AddPercent - decimal(18, 0)
    a.AnesthesiaTimeIncrement,          -- AnesthesiaTimeIncrement - int
	0 -- capitated
     --SELECT *
FROM dbo.ContractsAndFees_ContractRateSchedule a 
WHERE a.PracticeID=@SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT''
PRINT'Inserting into Contract Rate...'

INSERT INTO dbo.ContractsAndFees_ContractRate
(
    ContractRateScheduleID,
    ProcedureCodeID,
    ModifierID,
    SetFee,
    AnesthesiaBaseUnits
)
SELECT 
   (SELECT a.ContractRateScheduleID FROM dbo.ContractsAndFees_ContractRateSchedule a WHERE a.PracticeID=@TargetPracticeID),    -- ContractRateScheduleID - int
    cr.ProcedureCodeID,    -- ProcedureCodeID - int
    NULL ,    -- ModifierID - int
    cr.SetFee, -- SetFee - money
    0     -- AnesthesiaBaseUnits - int
    
--SELECT cr.*
FROM dbo.ContractsAndFees_ContractRate cr
INNER JOIN dbo.ContractsAndFees_ContractRateSchedule crs
ON crs.ContractRateScheduleID = cr.ContractRateScheduleID
WHERE crs.PracticeID=@SourcePracticeID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




PRINT''
PRINT'Inserting into Standard Fee Schedule Link'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT    doc.doctorID , -- ProviderID - int
          sl.ServiceLocationID,  -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc 
INNER JOIN dbo.ServiceLocation sl ON sl.practiceid=doc.PracticeID
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON sfs.PracticeID = @TargetPracticeID
WHERE doc.[External]<>1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT''
PRINT'Inserting into Contract Rate Schedule Link'
INSERT INTO dbo.ContractsAndFees_ContractRateScheduleLink
(
    ProviderID,
    LocationID,
    ContractRateScheduleID
)
SELECT 
		  doc.doctorID , -- ProviderID - int
          sl.ServiceLocationID,  -- LocationID - int
          sfs.ContractRateScheduleID  -- ContractRateScheduleID - int
   
FROM dbo.Doctor doc 
INNER JOIN dbo.ServiceLocation sl ON sl.practiceid=doc.PracticeID
INNER JOIN dbo.ContractsAndFees_ContractRateSchedule sfs ON sfs.PracticeID = @TargetPracticeID
WHERE doc.[External]<>1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


DROP TABLE #tempdoc
DROP TABLE #tempemp
DROP TABLE #tempsl


--COMMIT
--ROLLBACK


