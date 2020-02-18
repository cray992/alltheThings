USE superbill_9701_dev
--USE superbill_33955_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 10
SET @VendorImportID = 4

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting Into Appointment...'
INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          16 , -- ServiceLocationID - int
          DATEADD(hh,3,i.startdate) , -- StartDate - datetime
          DATEADD(hh,3,i.enddate) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.AutoTempID , -- Subject - varchar(64)
          'Exam Room: ' + i.examroom , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.appointmentstatus WHEN 'No Show' THEN 'N'
								   WHEN 'Rescheduled' THEN 'R'
								   WHEN 'Arrived' THEN 'I'
								   WHEN 'Complete' THEN 'E'
								   WHEN 'Cancelled' THEN 'X'
		  ELSE 'S' END, -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(RIGHT(i.startdate,5), ':','') AS SMALLINT) + 300 , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.enddate,5), ':','') AS SMALLINT) + 300   -- EndTm - smallint
FROM dbo.[_import_4_10_appointmentreport05192015] i
INNER JOIN dbo.Patient p ON
	p.FirstName = i.firstname AND 
	p.LastName = i.lastname
LEFT JOIN dbo.PatientCase pc ON
	pc.PatientCaseID = (SELECT TOP 1 PatientCaseID FROM dbo.PatientCase WHERE pc.PatientID = p.PatientID)  AND 
    pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice DK ON
	DK.PracticeID = @PracticeID AND
	DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT  
		  a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          20 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_4_10_appointmentreport05192015] i
INNER JOIN dbo.Appointment a ON
	i.AutoTempID = a.Subject AND 
	a.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #tempins (name VARCHAR(50))

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
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
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          i.FirstName ,
		  '' ,
          i.LastName ,
          '' ,
          i.streetaddress ,
          '' ,
          i.city ,
          LEFT(i.State ,2) ,
          '' ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
		  ELSE '' END ,
          CASE i.gender WHEN 'Female' THEN 'F'
						WHEN 'Male' THEN 'M'
		  ELSE 'U' END ,
          LEFT(dbo.fn_RemoveNonNumericCharacters(i.homephone) ,10) ,
          LEFT(dbo.fn_RemoveNonNumericCharacters(i.WorkPhone) ,10) ,
          CASE WHEN ISDATE(i.dateofbirth) = 1 THEN i.dateofbirth ELSE NULL END ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.socialsecuritynumber)) >= 6 THEN RIGHT('000' + i.socialsecuritynumber, 9) ELSE NULL END ,
          i.email ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          'U' ,
          20 ,
          16 ,
          i.chartid ,
          dbo.fn_RemoveNonNumericCharacters(i.cellphone) ,
          i.chartid ,
          @VendorImportID ,
          1 ,
          1 ,
          0 ,
          0 
FROM dbo.[_import_4_10_patientlist05192015] i
WHERE NOT EXISTS (SELECT * FROM dbo.Patient p WHERE i.firstname = p.FirstName AND i.lastname = p.LastName)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
       ( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	PAT.PatientID , -- PatientID - int
	'Default Case' , -- Name - varchar(128)
	1 , -- Active - bit
	5 , -- PayerScenarioID - int
	NULL , -- ReferringPhysicianID - int
	0 , -- EmploymentRelatedFlag - bit
	0, -- AutoAccidentRelatedFlag - bit
	0, -- OtherAccidentRelatedFlag - bit
	0, -- AbuseRelatedFlag - bit
	NULL , -- AutoAccidentRelatedState - char(2)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	0, -- ShowExpiredInsurancePolicies - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- PracticeID - int
	NULL , -- CaseNumber - varchar(128)
	NULL , -- WorkersCompContactInfoID - int
	PAT.VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.Patient PAT 
WHERE pat.VendorImportID = @VendorImportID AND pat.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into #tempins...'
INSERT INTO #tempins
        ( name )
SELECT DISTINCT  i.insurancecompany  -- name - varchar(50)
FROM dbo.[_import_4_10_patientlist05192015] i 
INNER JOIN dbo.Patient p ON 
	i.chartid = p.VendorID AND 
	p.VendorImportID = @VendorImportID
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE i.insurancecompany = ic.InsuranceCompanyName) AND i.insurancecompany <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
          InstitutionalBillingFormID 
        )
SELECT DISTINCT
		  name ,
          1 ,
          13 ,
          'CI' ,
          'C' ,
          'D' ,
          @PracticeID ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0,
          13 ,
          name ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM #tempins
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  InsuranceCompanyName ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          @PracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          @VendorImportID 
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 1 of 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
		  HolderThroughEmployer ,
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
          i.insuranceidnumber , -- PolicyNumber - varchar(32)
          i.insurancegroupnumber , -- GroupNumber - varchar(32)
          1 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_4_10_patientlist05192015] i
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorID = i.chartid AND
    pc.VendorImportID = @VendorImportID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.InsuranceCompanyPlanID = (SELECT TOP 1 InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE PlanName = i.insurancecompany)
WHERE i.insurancecompany <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 2 of 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
		  HolderThroughEmployer ,
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
          i.secondaryinsuranceidnumber , -- PolicyNumber - varchar(32)
          i.secondaryinsurancegroupnumber , -- GroupNumber - varchar(32)
          1 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_4_10_patientlist05192015] i
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorID = i.chartid AND
    pc.VendorImportID = @VendorImportID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.InsuranceCompanyPlanID = (SELECT TOP 1 InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE PlanName = i.secondaryinsurance)
WHERE i.secondaryinsurance <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment...'
INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          16 , -- ServiceLocationID - int
          DATEADD(hh,3,i.startdate) , -- StartDate - datetime
          DATEADD(hh,3,i.enddate) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.AutoTempID , -- Subject - varchar(64)
          'Exam Room: ' + i.examroom , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.appointmentstatus WHEN 'No Show' THEN 'N'
								   WHEN 'Rescheduled' THEN 'R'
								   WHEN 'Arrived' THEN 'I'
								   WHEN 'Complete' THEN 'E'
								   WHEN 'Cancelled' THEN 'X'
		  ELSE 'S' END, -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(RIGHT(i.startdate,5), ':','') AS SMALLINT) + 300 , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.enddate,5), ':','') AS SMALLINT) + 300   -- EndTm - smallint
FROM dbo.[_import_4_10_appointmentreport05192015] i
INNER JOIN dbo.Patient p ON
	p.FirstName = i.firstname AND 
	p.LastName = i.lastname AND
    p.VendorImportID = @VendorImportID
LEFT JOIN dbo.PatientCase pc ON
	pc.PatientID = p.PatientID AND
    pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice DK ON
	DK.PracticeID = @PracticeID AND
	DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
WHERE NOT EXISTS (SELECT * FROM dbo.Appointment a WHERE i.AutoTempID = a.Subject AND a.PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT  
		  a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          20 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_4_10_appointmentreport05192015] i
INNER JOIN dbo.Patient p ON
	p.FirstName = i.firstname AND
    p.LastName = i.lastname AND
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON
	p.PatientID = p.PatientID AND
	a.Subject = i.AutoTempID
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Cases...'
UPDATE dbo.PatientCase SET Name = 'Self Pay' , PayerScenarioID = 11 
FROM dbo.PatientCase pc
LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID
WHERE ip.PatientCaseID IS NULL AND pc.VendorImportID = @VendorImportID AND pc.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


DROP TABLE #tempins

--ROLLBACK
--COMMIT

