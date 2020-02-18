--USE superbill_53336_dev
USE superbill_53336_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @DefaultCollectionCategory INT

SET @PracticeID = 1
SET @VendorImportID = 1
SET @DefaultCollectionCategory = (SELECT CollectionCategoryID FROM dbo.CollectionCategory WHERE IsDefaultCategory = 1)


PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

SET NOCOUNT ON

/*==========================================================================*/

--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
--DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'

 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--

--CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
--INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo.impor i ON p.PatientID = REPLACE(REPLACE(i.id,'.00',''),',','')

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


CREATE TABLE #tempins 
(
	insconame VARCHAR(128) , insplanname VARCHAR(128), address1 VARCHAR(256) , address2 VARCHAR(256), city VARCHAR(128), 
	[state] VARCHAR(2) , zipcode VARCHAR(9)
)

PRINT ''
PRINT 'Inserting Into #tempins - Primary'
INSERT INTO #tempins
(
	insconame , insplanname , address1 , address2 , city , [state] , zipcode 
)
SELECT DISTINCT
		  primaryinsurancepolicycompanyname , -- insconame - varchar(128)
          primaryinsurancepolicyplanname , -- insplanname - varchar(128)
          primaryinsurancepolicyplanaddressline1 , -- address1 - varchar(256)
          primaryinsurancepolicyplanaddressline2 , -- address2 - varchar(256)
          primaryinsurancepolicyplancity , -- city - varchar(128)
          primaryinsurancepolicyplanstate , -- state - varchar(2)
          primaryinsurancepolicyplanzipcode  -- zipcode - varchar(9)
FROM dbo.[_import_1_1_DrHudacekPatientDemographic] 
WHERE primaryinsurancepolicycompanyname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into #tempins - Secondary'
INSERT INTO #tempins
( 
	insconame , insplanname , address1 , address2 , city , [state] , zipcode 
)
SELECT DISTINCT
		  i.secondaryinsurancepolicycompanyname , -- insconame - varchar(128)
          i.secondaryinsurancepolicyplanname , -- insplanname - varchar(128)
          i.secondaryinsurancepolicyplanaddressline1 , -- address1 - varchar(256)
          i.secondaryinsurancepolicyplanaddressline2 , -- address2 - varchar(256)
          i.secondaryinsurancepolicyplanstate , -- city - varchar(128)
          i.secondaryinsurancepolicyplanstate , -- state - varchar(2)
          i.secondaryinsurancepolicyplanzipcode  -- zipcode - varchar(9)
FROM dbo.[_import_1_1_DrHudacekPatientDemographic] i 
WHERE NOT EXISTS 
	(SELECT * FROM #tempins ti WHERE
		i.secondaryinsurancepolicyplanname = ti.insplanname AND
        i.secondaryinsurancepolicyplanaddressline1 = ti.address1 AND 
		i.secondaryinsurancepolicyplanzipcode = ti.zipcode
	) AND
i.secondaryinsurancepolicycompanyname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , ReviewCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	i.insconame , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	13 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	'' , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	13 , -- SecondaryPrecedenceBillingFormID - int
	LEFT(i.insconame, 50) , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM #tempins i
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'		

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , CreatedDate , CreatedUserID , 
	ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , InsuranceCompanyID , Copay , Deductible , 
	VendorID , VendorImportID 
)
SELECT DISTINCT
	ICP.insplanname  , -- PlanName - varchar(128)
	LEFT(ICP.address1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.address2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.City,128) , -- City - varchar(128)
	LEFT(ICP.[State],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zipcode)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zipcode)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	LEFT(ICP.insplanname, 25) + LEFT(ICP.address1, 25),  -- VendorID - varchar(50) --FIX
	@VendorImportID -- VendorImportID - int
FROM #tempins ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.insconame, 50) AND
	ICP.insconame = IC.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

--PRINT ''
--PRINT 'Inserting Into Employers...'
--INSERT INTO dbo.Employers
--        ( EmployerName ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID 
--        )
--SELECT DISTINCT
--		  patientemployername , -- EmployerName - varchar(128)
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0  -- ModifiedUserID - int
--FROM dbo.[_import_1_1_DrHudacekPatientDemographic]
--WHERE patientemployername <> ''
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

SET IDENTITY_INSERT dbo.Patient ON

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PatientID ,
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
          PatientReferralSourceID ,
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
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  i.patientid ,
		  @PracticeID , -- PracticeID - int
          CASE i.referringprovderfullname 
			WHEN 'ANN MARIE HUDACEK, DPM' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Ann' AND LastName = 'Hudacek' AND [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @PracticeID)
		  ELSE NULL END  , -- ReferringPhysicianID - int
          i.patientprefix , -- Prefix - varchar(16)
          i.patientfirstname , -- FirstName - varchar(64)
          i.patientmiddlename , -- MiddleName - varchar(64)
          i.patientlastname , -- LastName - varchar(64)
          i.patientsuffix , -- Suffix - varchar(16)
          i.patientaddressline1 , -- AddressLine1 - varchar(256)
          i.patientaddressline2 , -- AddressLine2 - varchar(256)
          i.patientcity , -- City - varchar(128)
          i.patientstate , -- State - varchar(2)
          i.patientcountry , -- Country - varchar(32)
          i.patientzipcode , -- ZipCode - varchar(9)
          i.patientgender , -- Gender - varchar(1)
          i.patientmaritialstatus , -- MaritalStatus - varchar(1)
          i.patienthomephone , -- HomePhone - varchar(10)
          i.patientphoneext , -- HomePhoneExt - varchar(10)
          i.patientworkphone , -- WorkPhone - varchar(10)
          i.patientworkphoneext , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(i.patientdob) = 1 THEN i.patientdob ELSE NULL END , -- DOB - datetime
          i.patientssn , -- SSN - char(9)
          i.patientemailaddress , -- EmailAddress - varchar(256)
          i.patientresponsibledifferentthanpatient , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN i.patientresponsibledifferentthanpatient = 'TRUE' THEN i.patientresponsibleprefix ELSE NULL END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN i.patientresponsibledifferentthanpatient = 'TRUE' THEN i.patientresponsiblefirstname ELSE NULL END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN i.patientresponsibledifferentthanpatient = 'TRUE' THEN i.patientresponsiblefirstname ELSE NULL END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN i.patientresponsibledifferentthanpatient = 'TRUE' THEN i.patientresponsiblelastname ELSE NULL END , -- ResponsibleLastName - varchar(64)
          CASE WHEN i.patientresponsibledifferentthanpatient = 'TRUE' THEN i.patientresponsiblesuffix ELSE NULL END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN i.patientresponsibledifferentthanpatient = 'TRUE' THEN 'O' ELSE NULL END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.patientresponsibledifferentthanpatient = 'TRUE' THEN i.patientaddressline1 ELSE '' END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.patientresponsibledifferentthanpatient = 'TRUE' THEN i.patientaddressline2 ELSE '' END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.patientresponsibledifferentthanpatient = 'TRUE' THEN i.patientcity ELSE '' END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.patientresponsibledifferentthanpatient = 'TRUE' THEN i.patientstate ELSE '' END , -- ResponsibleState - varchar(2)
          CASE WHEN i.patientresponsibledifferentthanpatient = 'TRUE' THEN i.patientcountry ELSE '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN i.patientresponsibledifferentthanpatient = 'TRUE' THEN i.patientzipcode ELSE '' END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          es.EmploymentStatusCode , -- EmploymentStatus - char(1)
          prs.PatientReferralSourceID , -- PatientReferralSourceID - int
          CASE i.defaultrenderingproviderfullname 
			WHEN 'ANN MARIE HUDACEK, DPM' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Ann' AND LastName = 'Hudacek' AND [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @PracticeID)
		  ELSE NULL END  , -- PrimaryProviderID - int
          CASE i.servicelocationname 
			WHEN 'Monterey Bay Podiatry' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'Monterey Bay Podiatry' AND PracticeID = @PracticeID) 
		  ELSE NULL END , -- DefaultServiceLocationID - int
          e.EmployerID , -- EmployerID - int
          i.patientmedicalrecordnumber , -- MedicalRecordNumber - varchar(128)
          i.patientmobilephone , -- MobilePhone - varchar(10)
          i.patientmobilephoneext , -- MobilePhoneExt - varchar(10)
          CASE i.primarycarephysicianfullname
			WHEN 'ANN MARIE HUDACEK, DPM' THEN (SELECT MAX(DoctorID) FROM dbo.Doctor WHERE FirstName = 'Ann' AND LastName = 'Hudacek' AND PracticeID = @PracticeID)  
		  ELSE NULL END, -- PrimaryCarePhysicianID - int
          i.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          cc.CollectionCategoryID , -- CollectionCategoryID - int
          1 , -- Active - bit
          CASE WHEN i.patientemailaddress <> '' THEN 1 ELSE 0 END , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_1_1_DrHudacekPatientDemographic] i
	LEFT JOIN dbo.Patient p ON	
		p.FirstName = i.patientfirstname AND 
		p.LastName = i.patientlastname AND 
		p.DOB = DATEADD(hh,12,CAST(i.patientdob AS DATETIME))
	LEFT JOIN dbo.EmploymentStatus es ON 
		i.patientemploymentstatus = es.StatusName
	LEFT JOIN dbo.PatientReferralSource prs ON 
		i.patientreferralsource = prs.PatientReferralSourceCaption
	LEFT JOIN dbo.Employers e ON 
		i.patientemployername = e.EmployerName
	LEFT JOIN dbo.CollectionCategory cc ON 
		i.patientcollectioncategoryname = cc.CollectionCategoryName
WHERE p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

SET IDENTITY_INSERT dbo.Patient OFF

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          --ReferringPhysicianID ,
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
          --CaseNumber ,
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
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          CASE WHEN i.defaultcasename = '' THEN 'Default Case' ELSE i.defaultcasename END , -- Name - varchar(128)
          1 , -- Active - bit
          CASE WHEN ps.PayerScenarioID IS NULL THEN 5 ELSE ps.PayerScenarioID END , -- PayerScenarioID - int
          --0 , -- ReferringPhysicianID - int
          CASE WHEN i.defaultcaseconditionrelatedtoemployment = 'TRUE' THEN 1 ELSE 0 END , -- EmploymentRelatedFlag - bit
          CASE WHEN i.defaultcaseconditionrelatedtoautoaccident = 'TRUE' THEN 1 ELSE 0 END , -- AutoAccidentRelatedFlag - bit
          CASE WHEN i.defaultcaseconditionrelatedtoother = 'TRUE' THEN 1 ELSE 0 END , -- OtherAccidentRelatedFlag - bit
          CASE WHEN i.defaultcaseconditionrelatedtoabuse = 'TRUE' THEN 1 ELSE 0 END , -- AbuseRelatedFlag - bit
          CASE WHEN i.defaultcaseconditionrelatedtoautoaccidentstate <> '' THEN i.defaultcaseconditionrelatedtoautoaccidentstate ELSE NULL END , -- AutoAccidentRelatedState - char(2)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          --'' , -- CaseNumber - varchar(128)
          --0 , -- WorkersCompContactInfoID - int
          p.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE WHEN i.defaultcaseconditionrelatedtopregnancy = 'TRUE' THEN 1 ELSE 0 END , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          CASE WHEN i.defaultcaseconditionrelatedtoepsdt = 'TRUE' THEN 1 ELSE 0 END , -- EPSDT - bit
          CASE WHEN i.defaultcaseconditionrelatedtofamilyplanning = 'TRUE' THEN 1 ELSE 0 END , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_1_1_DrHudacekPatientDemographic] i
	INNER JOIN dbo.Patient p ON 
		i.patientid = p.VendorID AND 
		p.VendorImportID = @VendorImportID
	LEFT JOIN dbo.PayerScenario ps ON
		i.defaultcasepayerscenario = ps.Name
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy - Primary...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.primaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          i.primaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.primaryinsurancepolicyeffectivestartdate) = 1 THEN i.primaryinsurancepolicyeffectivestartdate END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.primaryinsurancepolicyeffectiveenddate) = 1 THEN i.primaryinsurancepolicyeffectiveenddate END , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          i.primaryinsurancepolicyinsuredrelationshiptopatient , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.primaryinsurancepolicyinsuredrelationshiptopatient NOT IN ('S','') THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN i.primaryinsurancepolicyinsuredrelationshiptopatient NOT IN ('S','') THEN i.primaryinsurancepolicyinsuredfullname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.primaryinsurancepolicyinsuredrelationshiptopatient NOT IN ('S','') THEN '' ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.primaryinsurancepolicyinsuredrelationshiptopatient NOT IN ('S','') THEN '' ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.primaryinsurancepolicyinsuredrelationshiptopatient NOT IN ('S','') THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_DrHudacekPatientDemographic] i 
	INNER JOIN dbo.PatientCase pc ON 
		i.patientid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		LEFT(i.primaryinsurancepolicyplanname, 25) + LEFT(i.primaryinsurancepolicyplanaddressline1, 25) = icp.VendorID AND
        icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy - Secondary...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.secondaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          i.secondaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.secondaryinsurancepolicyeffectivestartdate) = 1 THEN i.secondaryinsurancepolicyeffectivestartdate END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.secondaryinsurancepolicyeffectiveenddate) = 1 THEN i.secondaryinsurancepolicyeffectiveenddate END , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          i.secondaryinsurancepolicyinsuredrelationshiptopatient , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.secondaryinsurancepolicyinsuredrelationshiptopatient NOT IN ('S','') THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN i.secondaryinsurancepolicyinsuredrelationshiptopatient NOT IN ('S','') THEN i.secondaryinsurancepolicyinsuredfullname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.secondaryinsurancepolicyinsuredrelationshiptopatient NOT IN ('S','') THEN '' ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.secondaryinsurancepolicyinsuredrelationshiptopatient NOT IN ('S','') THEN '' ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.secondaryinsurancepolicyinsuredrelationshiptopatient NOT IN ('S','') THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_DrHudacekPatientDemographic] i 
	INNER JOIN dbo.PatientCase pc ON 
		i.patientid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		LEFT(i.secondaryinsurancepolicyplanname, 25) + LEFT(i.secondaryinsurancepolicyplanaddressline1, 25) = icp.VendorID AND
        icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DROP TABLE #tempins

PRINT ''
PRINT 'Inserting Into Patient Journal Note...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
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
		  GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          'Kareo' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          CASE WHEN i.charges = '' THEN '' ELSE 'Charges:                      ' + i.charges + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.adjustments = '' THEN '' ELSE 'Adjustments:              ' + i.adjustments + CHAR(13) + CHAR(10) END + 
		  CASE WHEN i.insurancepayments = '' THEN '' ELSE 'Insurance Payments: ' + i.insurancepayments + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.patientpayments = '' THEN '' ELSE 'Patient Payments:       ' + i.patientpayments + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.insurancebalance = '' THEN '' ELSE 'Insurance Balance:     ' + i.insurancebalance + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.patientbalance = '' THEN '' ELSE 'Patient Balance:          ' + i.patientbalance + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.claimtotalbalance = '' THEN '' ELSE 'Claim Total Balance:  ' + i.claimtotalbalance + CHAR(13) + CHAR(10) END , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_1_1_DrHudacekPatientDemographic] i
	INNER JOIN dbo.Patient p ON 
		i.patientid = p.VendorID AND
		p.VendorImportID = @VendorImportID 
WHERE i.charges <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET Name = 'Self Pay' , PayerScenarioID = 11
FROM dbo.PatientCase pc 
	LEFT JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND
        ip.VendorImportID = @VendorImportID AND
        ip.PracticeID = @PracticeID
WHERE ip.InsurancePolicyID IS NULL AND pc.VendorImportID = @VendorImportID AND pc.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--COMMIT
--ROLLBACK

