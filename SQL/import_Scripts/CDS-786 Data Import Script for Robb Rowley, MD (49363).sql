--USE superbill_49363_dev
USE superbill_49363_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR) 

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
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode ,
	Phone , PhoneExt , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	ICP.payername  , -- PlanName - varchar(128)
	LEFT(ICP.payeraddressline1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.payeraddressline2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.payeraddresscity,128) , -- City - varchar(128)
	LEFT(ICP.payerstate,2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.payeraddresszip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.payeraddresszip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.payeraddresszip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.payeraddresszip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.payerphonenumber),10) , -- Phone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.payerphoneext),10) , -- PhoneExt - varchar(10)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	'' , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	RIGHT(ICP.payername, 15) + LEFT(ICP.payeraddressline1, 15) + LEFT(ICP.payeraddresszip, 10) + LEFT(ICP.payerphonenumber, 10) ,  -- VendorID - varchar(50) --FIX
	@VendorImportID -- VendorImportID - int
FROM dbo.[_import_1_1_DrRobbRowleyMDPLLCinsu] ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE ICP.payername = InsuranceCompanyName AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
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
	IICL.payername  , -- InsuranceCompanyName - varchar(128)
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
	IICL.payername , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_DrRobbRowleyMDPLLCinsu] AS IICL
WHERE IICL.payername <> '' AND
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.payername AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'		

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode ,
	Phone , PhoneExt , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	ICP.payername  , -- PlanName - varchar(128)
	LEFT(ICP.payeraddressline1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.payeraddressline2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.payeraddresscity,128) , -- City - varchar(128)
	LEFT(ICP.payerstate,2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.payeraddresszip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.payeraddresszip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.payeraddresszip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.payeraddresszip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.payerphonenumber),10) , -- Phone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.payerphoneext),10) , -- PhoneExt - varchar(10)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	'' , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	RIGHT(ICP.payername, 15) + LEFT(ICP.payeraddressline1, 15) + LEFT(ICP.payeraddresszip, 10) + LEFT(ICP.payerphonenumber, 10) ,  -- VendorID - varchar(50) --FIX
	@VendorImportID -- VendorImportID - int
FROM dbo.[_import_1_1_DrRobbRowleyMDPLLCinsu] ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.payername, 50) AND
	ICP.payername = IC.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	RIGHT(ICP.payername, 15) + LEFT(ICP.payeraddressline1, 15) + LEFT(ICP.payeraddresszip, 10) + LEFT(ICP.payerphonenumber, 10) = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Updating Existing Patients with VendorID...'
UPDATE dbo.Patient 
	SET VendorID = i.patientid
FROM dbo.Patient p 
	INNER JOIN dbo.[_import_1_1_DrRobbRowleyMDPLLCpatd] i ON
		p.FirstName = i.patientfirstname AND 
		p.LastName = i.patientlastname AND 
		p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) AND 
		p.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	

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
          [State] ,
          Country ,
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
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
          i.patientfirstname ,
          i.patientmiddlename ,
          i.patientlastname ,
          '' ,
          i.line1 ,
          i.line2 ,
          i.city ,
          i.[statecode] ,
          '' ,
          i.zipcode ,
          CASE i.gender WHEN 'Male' THEN 'M' WHEN 'Female' THEN 'F' ELSE 'U' END ,
          ms.MaritalStatus  ,
          dbo.fn_RemoveNonNumericCharacters(i.phonenumber) ,
          i.dob ,
          i.patientsfullssn ,
          i.email ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CASE i.employmentstatus 
			WHEN 'Employed' THEN 'E'
			WHEN 'Retired' THEN 'R'
			WHEN 'Student' THEN 'S'
		  ELSE 'U' END,
          2 ,
          1 ,
          i.chartnumber ,
          i.patientid ,
          @VendorImportID ,
          1 ,
          CASE i.patientstatus 
			WHEN 'DECEASED' THEN 0
		  ELSE 1 END ,
          0 ,
          0 
FROM dbo.[_import_1_1_DrRobbRowleyMDPLLCpatd] i
	LEFT JOIN dbo.MaritalStatus ms ON 
		i.maritalstatus = ms.LongName
	LEFT JOIN dbo.Patient p ON 
		p.FirstName = i.patientfirstname AND 
		p.LastName = i.patientlastname AND 
		p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) AND 
		p.PracticeID = @PracticeID
WHERE p.PatientID IS NULL
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
	INNER JOIN dbo.[_import_1_1_DrRobbRowleyMDPLLCpatd] i ON
		PAT.FirstName = i.patientfirstname AND 
		PAT.LastName = i.patientlastname AND 
		PAT.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) AND 
		PAT.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON 
		pat.PatientID = pc.PatientID AND  
		pc.PracticeID = @PracticeID
WHERE pc.PatientCaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Insurance Policy...'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          CASE i.policypriority 
			WHEN 'Primary' THEN 1 
			WHEN 'Secondary' THEN 2 
			WHEN 'Tertiary' THEN 3 
			WHEN 'Quaternary' THEN 4
		  END , -- Precedence - int
          i.membernumber , -- PolicyNumber - varchar(32)
          i.policynumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.effectivedate) = 1 THEN i.effectivedate END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.effectivedateend) = 1 THEN i.effectivedateend END , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.copayment , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.groupname ,14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_DrRobbRowleyMDPLLCinsu] i
	INNER JOIN dbo.PatientCase pc ON 
		i.patientid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		RIGHT(i.payername, 15) + LEFT(i.payeraddressline1, 15) + LEFT(i.payeraddresszip, 10) + LEFT(I.payerphonenumber, 10) = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
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
          2 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          CASE WHEN i.appointmentstatus = 'Cancelled' THEN i.cancellationcomments
		  ELSE i.appointmentcomments END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.appointmentstatus
			WHEN 'Billed' THEN 'E'
			WHEN 'Cancelled' THEN 'X'
			WHEN 'Checked-In' THEN 'I'
			WHEN 'Checked-Out' THEN 'O'
			WHEN 'IN-PROGRESS IN-ROOM' THEN 'C'
		  ELSE 'S' END, -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
		  CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.enddate,5), ':','') AS SMALLINT) -- EndTm - smallint
FROM dbo.[_import_1_1_DrRobbRowleyMDPLLCappo] i 
	INNER JOIN dbo.Patient p ON 
		i.patientid = p.VendorID AND 
		p.PracticeID = @PracticeID 
	LEFT JOIN dbo.PatientCase pc ON 
		p.PatientID = pc.PatientID AND 
		pc.PracticeID = @PracticeID
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.Appointment a ON 
		a.StartDate = CAST(i.startdate AS DATETIME) AND 
		a.EndDate = CAST(i.enddate AS DATETIME) AND 
		p.PatientID = a.PatientID
WHERE a.AppointmentID IS NULL AND i.patientid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointmen to Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_DrRobbRowleyMDPLLCappo] i 
	INNER JOIN dbo.AppointmentReason ar ON 
		i.natureofvisit = ar.Name AND 
		ar.PracticeID = @PracticeID
	INNER JOIN dbo.Patient p ON 
		p.VendorID = i.patientid AND 
		p.PracticeID = @PracticeID
	INNER JOIN dbo.Appointment a ON 
		p.PatientID = a.PatientID AND 
		a.StartDate = CAST(i.startdate AS DATETIME) AND 
		a.EndDate = CAST(i.enddate AS DATETIME) AND 
		a.CreatedUserID = 0 AND 
		a.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-5,GETDATE()) AND i.patientid <> ''
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
		  A.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          2 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_DrRobbRowleyMDPLLCappo] i 
	INNER JOIN dbo.Patient p ON 
		p.VendorID = i.patientid AND 
		p.PracticeID = @PracticeID
	INNER JOIN dbo.Appointment a ON 
		p.PatientID = a.PatientID AND 
		a.StartDate = CAST(i.startdate AS DATETIME) AND 
		a.EndDate = CAST(i.enddate AS DATETIME) AND 
		a.CreatedUserID = 0 AND 
		a.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-5,GETDATE()) AND i.patientid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ROLLBACK
--COMMIT