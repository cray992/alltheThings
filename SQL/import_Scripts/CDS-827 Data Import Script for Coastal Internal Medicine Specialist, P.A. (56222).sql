USE superbill_56222_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

/*
/*==========================================================================*/
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--

CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
SELECT DISTINCT
		     p.PatientID , -- PatientID - int
			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
			 i.ssn  -- SSN - varchar(9)
FROM dbo.Patient p 
INNER JOIN dbo.[_import_2_1_PatientDemographics] i ON p.PatientID = i.id

PRINT ''
PRINT 'Updating Existing Patients Demographics...'
UPDATE dbo.Patient 
	SET DOB = i.DateofBirth  ,
		SSN = i.ssn
FROM #updatepat i 
INNER JOIN dbo.Patient p ON
	p.PatientID = i.patientid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #updatepat

/*==========================================================================*/
*/

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan - Existing Companies...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , CreatedPracticeID , 
	InsuranceCompanyID , VendorID , VendorImportID 
)
SELECT DISTINCT
	ICP.nameofinsuranceinkareo , -- PlanName - varchar(128)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- CreatedPracticeID - int
	ic.InsuranceCompanyID ,
	nameofinsuranceinkareo,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM dbo._import_2_1_ins ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE ICP.nameofinsuranceinkareo = InsuranceCompanyName AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	IICL.nameofinsuranceinkareo , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	13 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	13 , -- SecondaryPrecedenceBillingFormID - int
	nameofinsuranceinkareo , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo._import_2_1_ins AS IICL
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.nameofinsuranceinkareo AND
					(ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'															 

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , CreatedPracticeID , 
	InsuranceCompanyID , VendorID , VendorImportID 
)
SELECT DISTINCT
	ICP.nameofinsuranceinkareo , -- PlanName - varchar(128)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- CreatedPracticeID - int
	ic.InsuranceCompanyID ,
	ICP.nameofinsuranceinkareo,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM dbo._import_2_1_ins ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.nameofinsuranceinkareo, 50) AND
	ICP.nameofinsuranceinkareo = IC.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.nameofinsuranceinkareo = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


PRINT ''
PRINT 'Inserting Into Insurance Policy...'
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
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          i.prec ,
          i.insuranceid ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          @PracticeID ,
          pc.VendorID ,
          @VendorImportID ,
          'Y'
FROM dbo._import_2_1_ins i
	INNER JOIN dbo.Patient p ON 
		p.VendorID = i.medicalrecord AND 
		p.PracticeID = @PracticeID
	INNER JOIN dbo.PatientCase pc ON
		p.PatientID = pc.PatientID AND 
		pc.PracticeID = @PracticeID 
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.nameofinsuranceinkareo = icp.VendorID  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy - Name Match...' -- inserts only where primary policy does not already exist based on first matching patient first and last name
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
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          i.prec ,
          i.insuranceid ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          @PracticeID ,
          p.PatientID ,
          @VendorImportID ,
          'Y'
FROM dbo._import_2_1_ins i
	INNER JOIN dbo.Patient p ON 
		p.PatientID = (SELECT MIN(p2.patientid) FROM dbo.Patient p2 WHERE p2.FirstName = i.firstname AND 
																		  p2.LastName = i.lastname AND
																	      p2.PracticeID = @PracticeID)
	INNER JOIN dbo.PatientCase pc ON
		p.PatientID = pc.PatientID AND 
		pc.PracticeID = @PracticeID 
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.nameofinsuranceinkareo = icp.VendorID 
	LEFT JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND 
		ip.PracticeID = @PracticeID AND
        ip.Precedence = i.prec
WHERE ip.InsurancePolicyID IS NULL AND i.existingmrn = '#N/A'
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
          [Subject] ,
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
          1 , -- ServiceLocationID - int
          CAST(apptdate AS DATETIME) + DATEADD(hh,-3,CAST(appttime AS DATETIME)) , -- StartDate - datetime
          CAST(apptdate AS DATETIME) + DATEADD(mi,15,DATEADD(hh,-3,CAST(appttime AS DATETIME))) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.ticket , -- Subject - varchar(64)
          i.reasonloc , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(REPLACE(REPLACE(RIGHT(DATEADD(hh,-3,CAST(i.appttime AS DATETIME)),7), ':',''),'AM',''),'PM','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(REPLACE(REPLACE(RIGHT(DATEADD(mi,15,DATEADD(hh,-3,CAST(i.appttime AS DATETIME))),7), ':',''),'AM',''),'PM','') AS SMALLINT)  -- EndTm - smallint
FROM dbo._import_2_1_Appointment i
	INNER JOIN dbo.Patient p ON 
		i.mrn = p.VendorID AND 
		p.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON 
		p.PatientID = pc.PatientID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.DateKeyToPractice dk ON 
		CAST(i.apptdate AS DATETIME) = dk.Dt AND
		dk.PracticeID = @PracticeID
WHERE i.provider <> 'perez' AND i.provider <> 'ruth'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment - Name Match...'
INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          [Subject] ,
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
          1 , -- ServiceLocationID - int
          CAST(apptdate AS DATETIME) + DATEADD(hh,-3,CAST(appttime AS DATETIME)) , -- StartDate - datetime
          CAST(apptdate AS DATETIME) + DATEADD(mi,15,DATEADD(hh,-3,CAST(appttime AS DATETIME))) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.ticket , -- Subject - varchar(64)
          i.reasonloc , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(REPLACE(REPLACE(RIGHT(DATEADD(hh,-3,CAST(i.appttime AS DATETIME)),7), ':',''),'AM',''),'PM','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(REPLACE(REPLACE(RIGHT(DATEADD(mi,15,DATEADD(hh,-3,CAST(i.appttime AS DATETIME))),7), ':',''),'AM',''),'PM','') AS SMALLINT)  -- EndTm - smallint
FROM dbo._import_2_1_Appointment i
	INNER JOIN dbo.Patient p ON 
		i.firstname = p.FirstName AND 
		i.lastname = p.LastName AND 
		p.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON 
		p.PatientID = pc.PatientID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.DateKeyToPractice dk ON 
		CAST(i.apptdate AS DATETIME) = dk.Dt AND
		dk.PracticeID = @PracticeID
	LEFT JOIN dbo.Appointment a ON 
		i.ticket = a.[Subject] AND 
		a.PracticeID = @PracticeID
WHERE a.AppointmentID IS NULL AND i.provider <> 'perez' AND i.provider <> 'ruth'
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
          [Subject] ,
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
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          CAST(apptdate AS DATETIME) + DATEADD(hh,-3,CAST(appttime AS DATETIME)) , -- StartDate - datetime
          CAST(apptdate AS DATETIME) + DATEADD(mi,15,DATEADD(hh,-3,CAST(appttime AS DATETIME))) , -- EndDate - datetime
          'O' , -- AppointmentType - varchar(1)
          i.ticket , -- Subject - varchar(64)
          i.reasonloc , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(REPLACE(REPLACE(RIGHT(DATEADD(hh,-3,CAST(i.appttime AS DATETIME)),7), ':',''),'AM',''),'PM','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(REPLACE(REPLACE(RIGHT(DATEADD(mi,15,DATEADD(hh,-3,CAST(i.appttime AS DATETIME))),7), ':',''),'AM',''),'PM','') AS SMALLINT)  -- EndTm - smallint
FROM dbo._import_2_1_Appointment i
	INNER JOIN dbo.DateKeyToPractice dk ON 
		CAST(i.apptdate AS DATETIME) = dk.Dt AND
		dk.PracticeID = @PracticeID
	LEFT JOIN dbo.Appointment a ON 
		i.ticket = a.[Subject] AND 
		a.PracticeID = @PracticeID
WHERE a.AppointmentID IS NULL AND i.ticket <> '' AND i.provider <> 'perez' AND i.provider <> 'ruth'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment Reason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          i.reason , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          '' , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo._import_2_1_Appointment i WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE i.reason = ar.Name AND ar.PracticeID = @PracticeID) AND
i.reason <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmenttoAppointmentReason...'
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
FROM dbo._import_2_1_Appointment i 
	INNER JOIN dbo.Appointment a ON 
		i.ticket = a.[Subject] AND 
        a.PracticeID = @PracticeID
	INNER JOIN dbo.AppointmentReason ar ON 
		ar.Name = i.reason AND 
		ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

IF NOT EXISTS (SELECT * FROM dbo.PracticeResource WHERE ResourceName= 'Ultasound' AND PracticeID = @PracticeID)
BEGIN

INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
VALUES  ( 1 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          'Ultasound' , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
        )
END

IF NOT EXISTS (SELECT * FROM dbo.PracticeResource WHERE ResourceName= 'Nurse' AND PracticeID = @PracticeID)
BEGIN

INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
VALUES  ( 1 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          'Nurse' , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
        )

END

IF NOT EXISTS (SELECT * FROM dbo.PracticeResource WHERE ResourceName= 'X-ray' AND PracticeID = @PracticeID)
BEGIN

INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
VALUES  ( 1 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          'X-ray' , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
        )

END


PRINT ''
PRINT 'Inserting Into Appointmen to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          CASE WHEN i.provider IN ('Ultrasound','Nurse','X-ray') THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          CASE 
		  WHEN i.provider = 'Ultrasound' THEN (SELECT practiceresourceid FROM dbo.PracticeResource WHERE ResourceName = 'Ultrasound' AND PracticeID = @PracticeID)  -- ResourceID - int
		  WHEN i.provider = 'Nurse' THEN (SELECT practiceresourceid FROM dbo.PracticeResource WHERE ResourceName = 'Nurse' AND PracticeID = @PracticeID)  -- ResourceID - int
		  WHEN i.provider = 'X-ray' THEN (SELECT practiceresourceid FROM dbo.PracticeResource WHERE ResourceName = 'X-ray' AND PracticeID = @PracticeID)  -- ResourceID - int
          WHEN i.provider = 'Hemed' THEN (SELECT DoctorID FROM dbo.Doctor WHERE LastName = 'HEMED' AND [External] = 0 AND PracticeID = @PracticeID) 
		  WHEN i.provider = 'Jacobs' THEN (SELECT DoctorID FROM dbo.Doctor WHERE LastName = 'JACOBS' AND [External] = 0 AND PracticeID = @PracticeID) 
		  WHEN i.provider = 'Martin' THEN (SELECT DoctorID FROM dbo.Doctor WHERE LastName = 'MARTIN' AND [External] = 0 AND PracticeID = @PracticeID) 
		  END ,
		  GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_2_1_Appointment i 
	INNER JOIN dbo.Appointment a ON 
		i.ticket = a.[Subject] AND 
		a.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase
	SET PayerScenarioID = 5 , Name = 'Default Case'
FROM dbo.PatientCase pc 
	INNER JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND
        ip.PracticeID = @PracticeID
WHERE pc.Name = 'Self Pay' AND pc.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Appointment - Other...'
UPDATE dbo.Appointment 
	SET [Subject] = CASE WHEN i.middle = '' THEN i.firstname + ' ' + i.lastname 
				    ELSE i.firstname + ' ' + i.middle + ' ' + i.lastname END
FROM dbo.Appointment a
	INNER JOIN dbo._import_2_1_Appointment i ON
		a.[Subject] = i.ticket AND
        a.PracticeID = @PracticeID
WHERE a.AppointmentType = 'O' AND a.CreatedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT


