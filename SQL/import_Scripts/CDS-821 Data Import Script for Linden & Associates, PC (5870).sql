--USE superbill_5870_dev
USE superbill_5870_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 3
SET @SourcePracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

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
--INNER JOIN dbo.[_import_1_3_PatientDemographics] i ON p.PatientID = i.id

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

UPDATE dbo.Doctor 
	SET VendorID = i.DoctorID
FROM dbo.Doctor d
INNER JOIN #tempdoc i ON
	i.FirstName = d.FirstName AND
    i.LastName = d.LastName AND
    i.NPI = d.NPI 
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 0

UPDATE dbo.ServiceLocation 
	SET VendorID = CASE ServiceLocationID WHEN 31 THEN 26 WHEN 30 THEN 15 ELSE VendorID END

CREATE TABLE #temppat (PatientID INT , FirstName VARCHAR(64) , MiddleName VARCHAR(64) , LastName VARCHAR(64) , dob DATETIME , mrn VARCHAR(50) , 
					   address1 VARCHAR(256) , address2 VARCHAR(256) , city VARCHAR(128) , state VARCHAR(2) , country VARCHAR(32) , zipcode VARCHAR(9) , 
					   maritalstatus VARCHAR(1) , homephone VARCHAR(10) , homephoneext VARCHAR(10) , workphone VARCHAR(10) , 
					   workphoneext VARCHAR(10) , ssn CHAR(9) , email VARCHAR(256) , cellphone VARCHAR(10) , cellphoneext VARCHAR(10) ,
					   ResponsiblePartyFirstName VARCHAR(64) , ResponsiblePartyLastName VARCHAR(64), ResponsiblePartyMiddleName VARCHAR(64), 
					   ResponsiblePartyAddress1 VARCHAR(256), ResponsiblePartyAddress2 VARCHAR(256) , ResponsiblePartyCity VARCHAR(256) ,
					   ResponsiblePartyState VARCHAR(2) , ResponsiblePartyZipCode VARCHAR(9) , ResponsibleDifferentThanPatient BIT , 
					   ResponsibleRelationshipToPatient VARCHAR(1) , ReferringPhysicianID INT , EmploymentStatus CHAR(1) , PrimaryProviderID INT ,
					   DefaultServiceLocationID INT , PrimaryCarePhysicianID INT , SendEmailCorrespondence BIT , PhonecallRemindersEnabled BIT ,
					   EmergencyName VARCHAR(128) , EmergencyPhone VARCHAR(10) , EmergencyPhoneExt VARCHAR(10) , CollectionCategoryID INT)



INSERT INTO	#temppat
        ( PatientID , FirstName , MiddleName , LastName , dob , mrn , address1 , address2 , city , state , country , zipcode , 
		  maritalstatus , homephone , homephoneext , workphone , workphoneext , ssn , email , cellphone , cellphoneext ,
		  ResponsiblePartyFirstName , ResponsiblePartyLastName , ResponsiblePartyMiddleName , ResponsiblePartyAddress1 , 
		  ResponsiblePartyAddress2 , ResponsiblePartyCity , ResponsiblePartyState , ResponsiblePartyZipCode , ResponsibleDifferentThanPatient , 
		  ResponsibleRelationshipToPatient , ReferringPhysicianID , EmploymentStatus , PrimaryProviderID , DefaultServiceLocationID , 
		  PrimaryCarePhysicianID , SendEmailCorrespondence , PhonecallRemindersEnabled , EmergencyName , EmergencyPhone , EmergencyPhoneExt ,
		  CollectionCategoryID) 
SELECT DISTINCT    
		  i.PatientID , 
          i.firstname , 
		  i.MiddleName ,
          i.lastname , 
		  i.DOB ,
		  i.MedicalRecordNumber , 
		  i.AddressLine1  , 
		  i.AddressLine2 , 
		  i.city , 
		  i.state , 
		  i.Country ,
		  i.ZipCode ,
		  i.maritalstatus , 
		  i.homephone , 
		  i.HomePhoneExt ,
		  i.WorkPhone , 
		  i.WorkPhoneExt ,
		  i.ssn ,
		  i.EmailAddress , 
		  i.MobilePhone , 
		  i.MobilePhoneExt ,
		  i.ResponsibleFirstName , 
		  i.ResponsibleLastName , 
		  i.ResponsibleMiddleName , 
		  i.ResponsibleAddressLine1 , 
		  i.ResponsibleAddressLine2 , 
		  i.ResponsibleCity , 
		  i.ResponsibleState , 
		  i.ResponsibleZipCode , 
		  i.ResponsibleDifferentThanPatient ,
		  i.ResponsibleRelationshipToPatient , 
		  i.ReferringPhysicianID , 
		  i.EmploymentStatus , 
		  i.PrimaryProviderID , 
		  i.DefaultServiceLocationID , 
		  i.PrimaryCarePhysicianID , 
		  i.SendEmailCorrespondence , 
		  i.PhonecallRemindersEnabled , 
		  i.EmergencyName , 
		  i.EmergencyPhone , 
		  i.EmergencyPhoneExt , 
		  i.CollectionCategoryID
FROM dbo.Patient i
WHERE i.PracticeID = @SourcePracticeID

PRINT ''
PRINT 'Updating Patient...'
UPDATE dbo.Patient 
	SET MedicalRecordNumber = CASE WHEN p.MedicalRecordNumber IS NULL OR p.MedicalRecordNumber = '' THEN i.mrn ELSE p.MedicalRecordNumber END ,
		AddressLine1 = CASE WHEN p.AddressLine1 IS NULL OR p.AddressLine1 = '' THEN i.address1 ELSE p.AddressLine1 END ,
		AddressLine2 = CASE WHEN p.AddressLine2 IS NULL OR p.AddressLine2 = '' THEN i.address2 ELSE p.AddressLine2 END ,
		City = CASE WHEN p.City IS NULL OR p.City = '' THEN i.city ELSE p.city END ,
		[State] = CASE WHEN p.[state] IS NULL OR p.[State] = '' THEN i.[state] ELSE p.[state] END ,
		Country = CASE WHEN p.Country IS NULL OR p.Country = '' THEN i.Country ELSE p.Country END ,
		ZipCode = CASE WHEN p.ZipCode IS NULL OR p.ZipCode = '' THEN i.zipcode ELSE p.zipcode END ,
		MaritalStatus = CASE WHEN p.maritalstatus IS NULL OR p.MaritalStatus = '' OR p.MaritalStatus <> i.maritalstatus THEN i.maritalstatus ELSE p.maritalstatus END ,
		HomePhone = CASE WHEN p.homephone IS NULL OR p.HomePhone = '' THEN i.homephone ELSE p.homephone END ,
		HomePhoneExt = CASE WHEN p.HomePhoneExt IS NULL OR p.HomePhoneExt = '' THEN i.homephoneext ELSE p.homephoneext END ,
		WorkPhone = CASE WHEN p.WorkPhone IS NULL OR p.WorkPhone = '' THEN i.WorkPhone ELSE p.WorkPhone END ,
		WorkPhoneExt = CASE WHEN p.workphoneext IS NULL OR p.WorkPhoneExt = '' THEN i.workphoneext ELSE p.workphoneext END ,
		SSN = CASE WHEN p.SSN IS NULL OR p.SSN = '' THEN i.ssn ELSE p.SSN END ,
		EmailAddress = CASE WHEN p.EmailAddress IS NULL OR p.EmailAddress = '' THEN i.email ELSE p.EmailAddress END ,
		MobilePhone = CASE WHEN p.MobilePhone IS NULL OR p.MobilePhone = '' THEN i.cellphone ELSE p.MobilePhone END ,
		MobilePhoneExt = CASE WHEN p.MobilePhoneExt IS NULL OR p.MobilePhoneExt = '' THEN i.cellphoneext ELSE p.MobilePhoneExt END ,
		ResponsibleFirstName = CASE WHEN p.ResponsibleFirstName IS NULL OR p.ResponsibleFirstName = '' THEN i.ResponsiblePartyFirstName ELSE p.ResponsibleFirstName END ,
		ResponsibleLastName = CASE WHEN p.ResponsibleLastName IS NULL OR p.ResponsibleLastName = '' THEN i.ResponsiblePartyLastName ELSE p.ResponsibleLastName END ,
		ResponsibleMiddleName = CASE WHEN p.ResponsibleMiddleName IS NULL OR p.ResponsibleMiddleName = '' THEN i.ResponsiblePartyMiddleName ELSE p.ResponsibleMiddleName END ,
		ResponsibleAddressLine1 = CASE WHEN p.ResponsibleAddressLine1 IS NULL OR p.ResponsibleAddressLine1 = '' THEN i.ResponsiblePartyAddress1 ELSE p.ResponsibleAddressLine1 END ,
		ResponsibleAddressLine2 = CASE WHEN p.ResponsibleAddressLine2 IS NULL OR p.ResponsibleAddressLine2 = '' THEN i.ResponsiblePartyAddress2 ELSE p.ResponsibleAddressLine2 END ,
		ResponsibleCity = CASE WHEN p.ResponsibleCity IS NULL OR p.ResponsibleCity = '' THEN i.ResponsiblePartyCity ELSE p.ResponsibleCity END ,
		ResponsibleState = CASE WHEN p.ResponsibleState IS NULL OR p.ResponsibleState = '' THEN i.ResponsiblePartyState ELSE p.ResponsibleState END ,
		ResponsibleZipCode = CASE WHEN p.ResponsibleZipCode IS NULL OR p.ResponsibleZipCode = '' THEN i.ResponsiblePartyZipCode ELSE p.ResponsibleZipCode END ,
		ResponsibleDifferentThanPatient = CASE WHEN p.ResponsibleDifferentThanPatient IS NULL OR p.ResponsibleDifferentThanPatient <> i.ResponsibleDifferentThanPatient THEN i.ResponsibleDifferentThanPatient ELSE p.ResponsibleDifferentThanPatient END ,
		ResponsibleRelationshipToPatient = CASE WHEN p.ResponsibleRelationshipToPatient IS NULL OR p.ResponsibleRelationshipToPatient <> i.ResponsibleRelationshipToPatient THEN i.ResponsibleRelationshipToPatient ELSE p.ResponsibleRelationshipToPatient END ,
		EmploymentStatus = CASE WHEN p.EmploymentStatus IS NULL OR p.EmploymentStatus = '' THEN i.EmploymentStatus ELSE p.EmploymentStatus END , 
		SendEmailCorrespondence = CASE WHEN p.SendEmailCorrespondence IS NULL OR p.SendEmailCorrespondence <> i.SendEmailCorrespondence THEN i.SendEmailCorrespondence ELSE p.SendEmailCorrespondence END , 
		PhonecallRemindersEnabled = CASE WHEN p.PhonecallRemindersEnabled IS NULL OR p.PhonecallRemindersEnabled <> i.PhonecallRemindersEnabled THEN i.PhonecallRemindersEnabled ELSE p.PhonecallRemindersEnabled END , 
		EmergencyName = CASE WHEN p.EmergencyName IS NULL OR p.EmergencyName = '' THEN i.EmergencyName ELSE p.EmergencyName END , 
		EmergencyPhone = CASE WHEN p.EmergencyPhone IS NULL OR p.EmergencyPhone = '' THEN i.EmergencyPhone ELSE p.EmergencyPhone END , 
		EmergencyPhoneExt = CASE WHEN p.EmergencyPhoneExt IS NULL OR p.EmergencyPhoneExt = '' THEN i.EmergencyPhoneExt ELSE p.EmergencyPhoneExt END ,
		PrimaryProviderID = CASE WHEN p.PrimaryProviderID IS NULL OR p.PrimaryProviderID = '' THEN pd.DoctorID ELSE p.PrimaryProviderID END ,
		CollectionCategoryID = CASE WHEN p.CollectionCategoryID IS NULL OR p.CollectionCategoryID = '' THEN i.CollectionCategoryID ELSE p.CollectionCategoryID END ,
		DefaultServiceLocationID = CASE WHEN p.DefaultServiceLocationID IS NULL OR p.DefaultServiceLocationID = '' THEN sl.ServiceLocationID ELSE p.DefaultServiceLocationID END ,
		VendorID = i.PatientID ,
		VendorImportID = @VendorImportID
FROM dbo.Patient p 
	INNER JOIN #temppat i ON 
		p.FirstName = i.FirstName AND 
		p.LastName = i.LastName AND 
		p.DOB = i.dob 
	LEFT JOIN dbo.Doctor pd ON 
		i.PrimaryProviderID = pd.VendorID AND 
		pd.PracticeID = @TargetPracticeID
	LEFT JOIN dbo.ServiceLocation sl ON 
		i.DefaultServiceLocationID = sl.VendorID AND 
		sl.PracticeID = @TargetPracticeID
WHERE p.PracticeID = @TargetPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' as records updated'

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
	LEFT JOIN dbo.PatientCase opc ON 
		p.PatientID = opc.PatientID AND
        opc.PracticeID = @TargetPracticeID
WHERE opc.PatientCaseID IS NULL
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

DROP TABLE #tempdoc
DROP TABLE #temppat


--COMMIT 
--ROLLBACK


