--USE superbill_47172_dev
USE superbill_47172_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3

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
--INNER JOIN dbo.[_import_6_1_PatientDemographics] i ON p.PatientID = i.id

--UPDATE dbo.Patient 
--	SET DOB = i.DateofBirth  ,
--		SSN = i.ssn
--FROM #updatepat i 
--INNER JOIN dbo.Patient p ON
--	p.PatientID = i.patientid

--DROP TABLE #updatepat

/*==========================================================================*/

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
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
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
          i.patientfirst ,
          '' ,
          i.patientlast ,
          '' ,
          i.patientstreet ,
          '' ,
          i.patientcitystatezip ,
          i.[state] ,
          '' ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientzip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.patientzip)
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.patientzip)
		  ELSE '' END ,
          CASE WHEN i.patientsex = '' THEN 'U' ELSE i.patientsex END ,
          '' ,
          i.homephone ,
          i.workphone ,
          i.patientbirth ,
          i.patientemail ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          'U' ,
          i.patunique ,
          @VendorImportID ,
          1 ,
          1 ,
          0 ,
		  0
FROM dbo._import_4_1_ptdemographics i 
WHERE i.patientfirst <> '' AND NOT EXISTS (SELECT * FROM dbo.Patient p WHERE (p.FirstName = i.patientfirst AND p.LastName = i.patientlast AND
p.DOB = DATEADD(hh,12,CAST(i.patientbirth AS DATETIME))) OR (i.patunique = p.VendorID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
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
          WorkersCompContactInfoID ,
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
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          NULL , -- ReferringPhysicianID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          NULL , -- AutoAccidentRelatedState - char(2)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          NULL , -- CaseNumber - varchar(128)
          NULL , -- WorkersCompContactInfoID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient 
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment - Existing Patients...'
INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
          PatientCaseID ,
          Recurrence ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.AutoTempID , -- Subject - varchar(64)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.apptstatus 
			WHEN 'No Show' THEN 'N'
			WHEN 'Kept' THEN 'C'
			WHEN 'Re Schedule' THEN 'R'
			WHEN 'Canceled' THEN 'X'
			WHEN 'Walked In' THEN 'I'
			WHEN 'Late Cancellation' THEN 'X'
		  ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          0 , -- Recurrence - bit
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.EndDate,5),  ':', '') AS SMALLINT)  -- EndTm - smallint
FROM dbo._import_4_1_schedule1 i
	INNER JOIN dbo.Patient p ON 
		p.FirstName = i.patfirst AND
		p.LastName = i.patlast AND 
		p.DOB = DATEADD(hh,12,CAST(i.patdob AS DATETIME)) AND 
		p.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MAX(pc2.patientcaseid) FROM dbo.PatientCase pc2
							WHERE pc2.PatientID = p.PatientID AND pc2.Name <> 'Balance Forward')
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.Appointment a ON 
		CAST(i.startdate AS DATETIME) = a.StartDate AND 
		CAST(i.enddate AS DATETIME) = a.EndDate AND
		p.PatientID = a.PatientID
WHERE i.apptid IN ('GR1','AB1','KA1','RC1','BC1','BI1','BM1','GC1','FA1','TMS') AND a.AppointmentID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Appointment Reason...'
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
FROM dbo._import_4_1_schedule1 i 
	INNER JOIN dbo.Patient p ON 
		p.FirstName = i.patfirst AND
		p.LastName = i.patlast AND 
		p.DOB = DATEADD(hh,12,CAST(i.patdob AS DATETIME)) AND 
		p.PracticeID = @PracticeID
	INNER JOIN dbo.Appointment a ON 
		i.AutoTempID = a.[Subject] AND 
		p.PatientID = a.PatientID AND 
		a.PracticeID = @PracticeID
	INNER JOIN dbo.AppointmentReason ar ON 
		i.apptreason = ar.Name AND 
		ar.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-5,GETDATE()) AND i.patientid <> '#N/A'
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
          CASE i.apptid
			WHEN 'GR1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'GEORGE' AND LastName = 'RHOADS' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'AB1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'AMJAD' AND LastName = 'BAHNASSI' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'KA1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'KIMBERLY' AND LastName = 'ABDOW' AND [External] = 0 AND PracticeID = @PracticeID AND ActiveDoctor = 1)
			WHEN 'RC1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RODNEY' AND LastName = 'COURNOYER' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'BC1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BRENDA' AND LastName = 'CASTRICHINI' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'BI1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BETH' AND LastName = 'IRVING' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'BM1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BRENDA' AND LastName = 'MCCARTHY-TRAYAH' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'GC1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'GWEN' AND LastName = 'CARELLI' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'FA1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Falashade' AND LastName = 'Adewuyi' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'TMS' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'AMJAD' AND LastName = 'BAHNASSI' AND [External] = 0 AND PracticeID = @PracticeID)
		  END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_4_1_schedule1 i 
	INNER JOIN dbo.Patient p ON 
		p.FirstName = i.patfirst AND
		p.LastName = i.patlast AND 
		p.DOB = DATEADD(hh,12,CAST(i.patdob AS DATETIME)) AND 
		p.PracticeID = @PracticeID
	INNER JOIN dbo.Appointment a ON 
		i.AutoTempID = a.[Subject] AND 
		p.PatientID = a.PatientID AND 
		a.PracticeID = @PracticeID
WHERE i.apptid IN ('GR1','AB1','KA1','RC1','BC1','BI1','BM1','GC1','FA1','TMS') AND 
a.CreatedDate > DATEADD(mi,-5,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment - Other...'
INSERT INTO dbo.Appointment
        ( 
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
          Recurrence ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'O' , -- AppointmentType - varchar(1)
          i.apptname , -- Subject - varchar(64)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.apptstatus 
			WHEN 'No Show' THEN 'N'
			WHEN 'Kept' THEN 'C'
			WHEN 'Re Schedule' THEN 'R'
			WHEN 'Canceled' THEN 'X'
			WHEN 'Walked In' THEN 'I'
			WHEN 'Late Cancellation' THEN 'X'
		  ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
          0 , -- Recurrence - bit
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
           CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.EndDate,5),  ':', '') AS SMALLINT)  -- EndTm - smallint
FROM dbo._import_4_1_schedule1 i
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
WHERE i.apptid IN ('GR1','AB1','KA1','RC1','BC1','BI1','BM1','GC1','FA1','TMS') AND i.patientid = '#N/A' 
AND NOT EXISTS (SELECT * FROM dbo.Appointment a WHERE CAST(i.AutoTempID AS VARCHAR) = a.[Subject])
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Appointment Reason...'
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
FROM dbo._import_4_1_schedule1 i 
	INNER JOIN dbo.Appointment a ON 
		i.apptname = a.[Subject] AND 
		CAST(i.startdate AS DATETIME) = a.StartDate AND 
		CAST(i.enddate AS DATETIME) = a.EndDate AND
		a.AppointmentType = 'O'
	INNER JOIN dbo.AppointmentReason ar ON 
		i.apptreason = ar.Name AND 
		ar.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-5,GETDATE()) AND i.patientid = '#N/A'
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
          CASE i.apptid
			WHEN 'GR1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'GEORGE' AND LastName = 'RHOADS' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'AB1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'AMJAD' AND LastName = 'BAHNASSI' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'KA1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'KIMBERLY' AND LastName = 'ABDOW' AND [External] = 0 AND PracticeID = @PracticeID AND ActiveDoctor = 1)
			WHEN 'RC1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RODNEY' AND LastName = 'COURNOYER' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'BC1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BRENDA' AND LastName = 'CASTRICHINI' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'BI1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BETH' AND LastName = 'IRVING' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'BM1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BRENDA' AND LastName = 'MCCARTHY-TRAYAH' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'GC1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'GWEN' AND LastName = 'CARELLI' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'FA1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Falashade' AND LastName = 'Adewuyi' AND [External] = 0 AND PracticeID = @PracticeID)
			WHEN 'TMS' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'AMJAD' AND LastName = 'BAHNASSI' AND [External] = 0 AND PracticeID = @PracticeID)
		  END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_4_1_schedule1 i 
	INNER JOIN dbo.Appointment a ON 
		i.apptname = a.[Subject] AND 
		CAST(i.startdate AS DATETIME) = a.StartDate AND 
		CAST(i.enddate AS DATETIME) = a.EndDate AND 
		a.AppointmentType = 'O'
WHERE i.apptid IN ('GR1','AB1','KA1','RC1','BC1','BI1','BM1','GC1','FA1','TMS') AND 
a.CreatedDate > DATEADD(mi,-5,GETDATE()) AND i.patientid = '#N/A'
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
          InstitutionalBillingFormID , 
		  Notes
        )
SELECT DISTINCT
		  i.insuredconame , -- InsuranceCompanyName - varchar(128)
		  1 ,
          13 ,
          'CI' ,
          'C' ,
          'D' ,
          @PracticeID ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          13 ,
          i.insuredconame ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 , 
		  CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.'
FROM dbo._import_4_1_inspolicy i 
WHERE i.insuredconame <> '' 
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
          VendorImportID , 
		  Notes
        )
SELECT 
		  InsuranceCompanyName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID ,
		  Notes
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy - Existing Patients...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.insuredid , -- Precedence - int
          i.insuredinsnum , -- PolicyNumber - varchar(32)
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.patientcopay , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_4_1_inspolicy i
	INNER JOIN dbo.Patient p ON 
		i.patientid = p.PatientID AND 
		p.PracticeID = @PracticeID
	INNER JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MAX(pc2.patientcaseID) FROM dbo.PatientCase pc2
							WHERE p.PatientID = pc2.PatientID AND 
								  pc2.Name <> 'Balance Forward')
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.insuredconame = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND 
		i.insuredid = ip.Precedence
WHERE ip.InsurancePolicyID IS NULL AND i.patientid <> '#N/A'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'		

PRINT ''
PRINT 'Updating Patient Case - Existing Patients...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 5 , Name = 'Default Case'
FROM dbo.PatientCase pc 
	INNER JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND ip.VendorImportID = @VendorImportID
WHERE pc.Name = 'Self Pay'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Insurance Policy - New Patients...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.insuredid , -- Precedence - int
          i.insuredinsnum , -- PolicyNumber - varchar(32)
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.patientcopay , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_4_1_inspolicy i
	INNER JOIN dbo.Patient p ON 
		i.patfirst = p.FirstName AND 
		i.patlast = p.LastName AND 
		DATEADD(hh,12,CAST(i.patdob AS DATETIME)) = p.DOB AND 
		p.PracticeID = @PracticeID
	INNER JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MAX(pc2.patientcaseID) FROM dbo.PatientCase pc2
							WHERE p.PatientID = pc2.PatientID AND 
								  pc2.Name <> 'Balance Forward')
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.insuredconame = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND 
		i.insuredid = ip.Precedence
WHERE ip.InsurancePolicyID IS NULL AND i.patientid = '#N/A'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'		

PRINT ''
PRINT 'Updating Patient Case - New Patients...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11 , Name = 'Self Pay'
FROM dbo.PatientCase pc 
	LEFT JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND ip.PracticeID = @PracticeID
WHERE pc.VendorImportID = @VendorImportID AND ip.InsurancePolicyID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK 
--COMMIT
