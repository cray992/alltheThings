USE superbill_63073_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

CREATE TABLE #inslist (InsName VARCHAR(126))
INSERT INTO #inslist  (InsName)
SELECT DISTINCT personprimaryinsurance
FROM dbo._import_1_2_PatientList
WHERE personprimaryinsurance <> ''

INSERT INTO #inslist  (InsName)
SELECT DISTINCT personsecondaryinsurance
FROM dbo._import_1_2_PatientList pl
LEFT JOIN #inslist i ON i.InsName = pl.personsecondaryinsurance
WHERE personsecondaryinsurance <> '' AND i.InsName IS NULL

UPDATE p 
SET VendorID = i.mrnnumber
FROM dbo.Patient p 
INNER JOIN dbo._import_1_2_PatientList i ON 
	p.FirstName = i.firstname AND 
	p.LastName = i.lastname AND
	p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) AND
	p.PracticeID = @PracticeID

PRINT ''
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
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
		  WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
		  ResponsibleRelationshipToPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
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
          i.firstname ,
          i.middlename ,
          i.lastname ,
          '' ,
          i.address1 ,
          i.addres2 ,
          i.city ,
          LEFT(i.[state],2) ,
          '' ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zipcode)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zipcode)
		  ELSE '' END ,
          CASE i.sex 
			WHEN 'Female' THEN 'F'
			WHEN 'Male' THEN 'M'
		  ELSE 'U' END ,
          '' ,
          dbo.fn_RemoveNonNumericCharacters(i.homephone) ,
          CASE WHEN i.cellphone = '(000)000-0000' THEN '' ELSE LEFT(dbo.fn_RemoveNonNumericCharacters(i.cellphone),10) END ,
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.cellphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.cellphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.cellphone))),10)
		  END,
          i.dob ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.ssn),9) END ,
          i.email ,
          0 ,
		  'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          'U' ,
          i.mrnnumber ,
          dbo.fn_RemoveNonNumericCharacters(i.mobilephone) ,
          i.mrnnumber ,
          @VendorImportID ,
          1 ,
          1 ,
          0 ,
          0 
FROM dbo._import_1_2_PatientList i
LEFT JOIN dbo.Patient p ON
	i.firstname = p.FirstName AND 
	i.lastname = p.LastName AND
    DATEADD(hh,12,CAST(i.dob AS DATETIME)) = p.DOB AND
	p.PracticeID = @PracticeID
WHERE p.PatientID IS NULL AND i.mrnnumber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Patient'

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
	PAT.PatientID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.Patient PAT
LEFT JOIN dbo.PatientCase pc ON 
	PAT.PatientID = pc.PatientID AND 
	PAT.PracticeID = @PracticeID
WHERE pc.PatientCaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into PatientCase'

INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , 
	CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	icp.InsName , -- PlanName - varchar(128)
	'' , -- AddressLine1 - varchar(256)
	'' , -- AddressLine2 - varchar(256)
	'', -- City - varchar(128)
	'' , -- State - varchar(2)
	'' , -- Country - varchar(32)
	'' , -- ZipCode - varchar(9)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	'' , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	LEFT(icp.InsName,50),  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM #inslist ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE ICP.InsName = InsuranceCompanyName AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
--LEFT JOIN dbo.InsuranceCompanyPlan ricp ON
--	icp.InsName = ricp.PlanName
--WHERE ricp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into InsuranceCompanyPlan [Existing Company]'	

INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , ReviewCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	InsName , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	19 , -- BillingFormID - int
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
	LEFT(InsName,50) , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM #inslist AS IICL
WHERE 
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.InsName AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into InsuranceCompany'		

INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , 
	CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	icp.InsName , -- PlanName - varchar(128)
	'' , -- AddressLine1 - varchar(256)
	'' , -- AddressLine2 - varchar(256)
	'', -- City - varchar(128)
	'' , -- State - varchar(2)
	'' , -- Country - varchar(32)
	'' , -- ZipCode - varchar(9)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	'' , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	LEFT(icp.InsName,50),  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM #inslist ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.InsName, 50) AND
	ICP.InsName = IC.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.InsName = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into InsuranceCompanyPlan'	

INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
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
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          1 ,
          i.personprimaryinsid ,
          i.personsecondaryinsgroupnumber ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          @PracticeID ,
          pc.PatientCaseID ,
          @VendorImportID ,
          'Y'
FROM dbo._import_1_2_PatientList i
INNER JOIN dbo.Patient p ON 
	p.PatientID = (SELECT MAX(p2.patientid) FROM dbo.Patient p2 WHERE 
				   i.firstname = p2.FirstName AND 
				   i.lastname = p2.LastName AND 
				   DATEADD(hh,12,CAST(i.dob AS DATETIME)) = p2.DOB AND 
				   p2.PracticeID = @PracticeID)
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	LEFT(i.personprimaryinsurance,50) = icp.VendorID AND
	icp.CreatedPracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Insurance Policy - Primary'

INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
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
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          2 ,
          i.personsecondaryinsid ,
          i.personsecondaryinsgroupnumber ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          @PracticeID ,
          i.mrnnumber ,
          @VendorImportID ,
          'Y'
FROM dbo._import_1_2_PatientList i
INNER JOIN dbo.Patient p ON 
	p.PatientID = (SELECT MAX(p2.patientid) FROM dbo.Patient p2 WHERE 
				   i.firstname = p2.FirstName AND 
				   i.lastname = p2.LastName AND 
				   DATEADD(hh,12,CAST(i.dob AS DATETIME)) = p2.DOB AND 
				   p2.PracticeID = @PracticeID)
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	LEFT(i.personsecondaryinsurance,50) = icp.VendorID AND
	icp.CreatedPracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Insurance Policy - Secondary'

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
          CASE WHEN i.doctor = 'HILLIARD - LAURA' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'Dermatology and Laser Center - Hilliard')
		  ELSE (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'Dermatology and Laser Center - Orange Park')
		  END , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.AutoTempID , -- Subject - varchar(64)
          i.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(RIGHT(i.startdate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.enddate,5), ':','') AS SMALLINT) -- EndTm - smallint
FROM dbo._import_1_2_Appointments i
	INNER JOIN dbo.Patient p ON 
		i.chartnumber = p.VendorID AND
        p.PracticeID = @PracticeID
	INNER JOIN dbo.PatientCase pc ON
		p.PatientID = pc.PatientID AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Appointment'

INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          CASE WHEN pr.PracticeResourceID IS NULL THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          CASE i.doctor
			WHEN 'Paley, Bruce H. DO' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Bruce' AND LastName = 'Paley' AND ActiveDoctor = 1 AND [External] = 0 AND PracticeID = @PracticeID) 
			WHEN 'Swearingen, Laura ARNP' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Laura' AND LastName = 'Swearingen' AND ActiveDoctor = 1 AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'Trimble, James S. MD' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Janice' AND LastName = 'White' AND ActiveDoctor = 1 AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'White, Janice l. ARNP' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'James' AND LastName = 'Trimble' AND ActiveDoctor = 1 AND [External] = 0 AND PracticeID = @PracticeID)
		  ELSE pr.PracticeResourceID END, -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_1_2_Appointments i 
	INNER JOIN dbo.Appointment a ON 
		i.AutoTempID = a.[Subject] AND
        a.PracticeID = @PracticeID
	LEFT JOIN dbo.PracticeResource pr ON 
		i.doctor = pr.ResourceName AND
		pr.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE()) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into AppointmentToResource'

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
FROM dbo._import_1_2_Appointments i
	INNER JOIN dbo.AppointmentReason ar ON 
		ar.AppointmentReasonID = (SELECT MAX(ar2.AppointmentReasonID) FROM dbo.AppointmentReason ar2 WHERE
								  i.reason = ar2.Name AND 
								  ar2.PracticeID = @PracticeID)
	INNER JOIN dbo.Appointment a ON 
		i.AutoTempID = a.[Subject] AND
		a.PracticeID = @PracticeID 
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into AppointmentToAppointmentReason'

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
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          3 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'O' , -- AppointmentType - varchar(1)
          CASE WHEN i.chartnumber = '' THEN LEFT(i.note,64)
		  ELSE i.firstname + ' ' + i.lastname + ' | ' + i.chartnumber END , -- Subject - varchar(64)
          CASE WHEN i.chartnumber = '' THEN 'Appointment Reason: ' + i.reason
		  ELSE 'Patient Record Missing from Import File' + CHAR(13) + CHAR(10) +  CHAR(13) + CHAR(10) +
			    'ChartNumber: ' + i.chartnumber + CHAR(13) + CHAR(10) + 
				CASE WHEN i.reason <> '' THEN 'Reason: ' + i.reason ELSE '' END +
				CASE WHEN i.note <> '' THEN 'Note: ' + i.note ELSE '' END
		  END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(RIGHT(i.startdate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.enddate,5), ':','') AS SMALLINT) -- EndTm - smallint
FROM dbo._import_1_2_Appointments i
	LEFT JOIN dbo.Patient p ON 
		i.chartnumber = p.VendorID AND
        p.PracticeID = @PracticeID
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
WHERE p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Appointment - Other'

INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          CASE WHEN pr.PracticeResourceID IS NULL THEN 2 ELSE 1 END  , -- AppointmentResourceTypeID - int
          CASE i.doctor
			WHEN 'Paley, Bruce H. DO' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Bruce' AND LastName = 'Paley' AND ActiveDoctor = 1 AND [External] = 0 AND PracticeID = @PracticeID) 
			WHEN 'Swearingen, Laura ARNP' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Laura' AND LastName = 'Swearingen' AND ActiveDoctor = 1 AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'Trimble, James S. MD' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Janice' AND LastName = 'White' AND ActiveDoctor = 1 AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'White, Janice l. ARNP' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'James' AND LastName = 'Trimble' AND ActiveDoctor = 1 AND [External] = 0 AND PracticeID = @PracticeID)
		  ELSE pr.PracticeResourceID END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_1_2_Appointments i 
	INNER JOIN dbo.Appointment a ON 
		CASE WHEN i.chartnumber = '' THEN LEFT(i.note,64)
		 ELSE i.firstname + ' ' + i.lastname + ' | ' + i.chartnumber END = a.[Subject] AND
        a.PracticeID = @PracticeID AND
		a.AppointmentType = 'O'
	LEFT JOIN dbo.PracticeResource pr ON 
		i.doctor = pr.ResourceName AND
		pr.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into AppointmentToResource - Other'

INSERT INTO dbo.Doctor
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
          WorkPhone ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
		  [External] 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          i.middlename , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.[address] , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          LEFT(i.[state],2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
		  ELSE '' END  , -- ZipCode - varchar(9)
          dbo.fn_RemoveNonNumericCharacters(i.workphone) , -- WorkPhone - varchar(10)
          CASE WHEN i.upin <> '' THEN 'UPIN: ' + i.upin END , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          LEFT(i.degree,8) , -- Degree - varchar(8)
          i.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          dbo.fn_RemoveNonNumericCharacters(i.fax) , -- FaxNumber - varchar(10)
          1  -- External - bit
FROM dbo._import_1_2_ReferringProvider i
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Doctor'

DROP TABLE #inslist

--COMMIT
--ROLLBACK


USE superbill_63073_dev
GO

SET XACT_ABORT ON
BEGIN TRANSACTION
SET NOCOUNT ON 

UPDATE atr 
SET AppointmentResourceTypeID = CASE WHEN atr.ResourceID IN (11,12,1) AND atr.AppointmentResourceTypeID = 1 THEN 2 ELSE 1 END
FROM dbo.AppointmentToResource atr
INNER JOIN dbo.Appointment a ON 
	atr.AppointmentID = a.AppointmentID AND 
	a.PracticeID = 2
WHERE atr.PracticeID = 2 AND a.CreatedUserID = 0 AND a.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--COMMIT
--ROLLBACK


