USE superbill_8023_dev
--USE superbill_8023_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 33
SET @SourcePracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

/*
==========================================================================================================================================
QA COUNT CHECK
==========================================================================================================================================
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
--INNER JOIN dbo.[_import_2_33_PatientDemographics8023targe] i ON p.PatientID = i.id

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
/*
CREATE TABLE #tempdocqa (firstname VARCHAR(65), lastname VARCHAR(65), NPI INT , [External] INT) INSERT INTO #tempdocqa (firstname, lastname, NPI, [External])
SELECT DISTINCT d.firstname ,d.lastname, d.npi, d.[External] FROM dbo._import_2_33_Doctor d WHERE d.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Existing Renderring Doctors To Be Updated] FROM dbo.Doctor d 
INNER JOIN #tempdocqa i ON d.FirstName = i.firstname AND d.LastName = i.lastname AND d.NPI = i.npi
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 0 

--SELECT COUNT(*) AS [Existing Referring Doctors To Be Updated] FROM dbo.Doctor d 
--INNER JOIN #tempdocqa i ON d.FirstName = i.firstname AND d.LastName = i.lastname AND d.NPI = i.npi
--WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 1 

DROP TABLE #tempdocqa

--SELECT DISTINCT COUNT(DISTINCT i.insurancecompanyid) AS [Insurance Company Records To Be Inserted] FROM _import_2_33_InsuranceCompany i
--INNER JOIN dbo.[_import_2_33_InsuranceCompanyPlan] icp ON i.InsuranceCompanyID = icp.InsuranceCompanyID
--INNER JOIN dbo.[_import_2_33_InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

--SELECT COUNT(DISTINCT ptic.pk_id) AS [Practice to Insurance Company Records To Be Inserted] FROM _import_2_33_PracticetoInsuranceCompany ptic 
--INNER JOIN dbo._import_2_33_InsuranceCompany ic ON ptic.InsuranceCompanyId = ic.InsuranceCompanyID AND ptic.PracticeID = @SourcePracticeID
--INNER JOIN dbo.[_import_2_33_InsuranceCompanyPlan] icp ON ic.InsuranceCompanyID = icp.InsuranceCompanyID
--INNER JOIN dbo.[_import_2_33_InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

--SELECT COUNT(DISTINCT icp.insurancecompanyplanid) AS [Insurance Company Plan Records To Be Inserted] FROM _import_2_33_InsuranceCompanyPlan icp
--INNER JOIN dbo._import_2_33_InsuranceCompany ic ON icp.insurancecompanyid = ic.insurancecompanyid
--INNER JOIN dbo.[_import_2_33_InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

--SELECT COUNT(*) AS [Existing Insurance Company Records to be Updated with ReviewCode] FROM dbo.InsuranceCompany ic
--INNER JOIN dbo.InsuranceCompanyPlan icp ON ic.InsuranceCompanyID = icp.InsuranceCompanyID 
--INNER JOIN dbo.InsurancePolicy ip ON ip.PracticeID = @SourcePracticeID AND icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
--WHERE ic.ReviewCode = '' OR ic.ReviewCode IS NULL

--SELECT COUNT(*) AS [Existing Insurance Company Plan Records to be Updated with ReviewCode] FROM dbo.InsuranceCompanyPlan icp 
--INNER JOIN dbo.InsurancePolicy ip ON ip.PracticeID = @SourcePracticeID AND icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
--WHERE icp.ReviewCode = '' OR icp.ReviewCode IS NULL

--SELECT COUNT(*) AS [Referring Provider Records To Be Inserted] FROM dbo._import_2_33_Doctor d 
--WHERE NOT EXISTS(SELECT * FROM dbo.Doctor d2 WHERE d.FirstName = d2.FirstName AND d.LastName = d2.LastName AND d.NPI = d2.NPI AND d2.[External] = 1 AND d2.PracticeID = @TargetPracticeID)
--AND d.[External] = 1 AND d.PracticeID = @SourcePracticeID

--SELECT COUNT(*) AS [Patients To Be Inserted] FROM dbo._import_2_33_Patient p WHERE p.PracticeID = @SourcePracticeID 
--AND NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Patient Alert Records To Be Inserted] FROM dbo._import_2_33_PatientAlert pa 
--INNER JOIN dbo._import_2_33_Patient p ON pa.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Patient Journal Records To Be Inserted] FROM dbo._import_2_33_PatientJournalNote pjn
--INNER JOIN dbo._import_2_33_Patient p ON pjn.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Patient Case Records To Be Inserted] FROM dbo._import_2_33_PatientCase pc 
--INNER JOIN dbo._import_2_33_Patient p ON pc.PatientID = p.PatientID AND pc.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Patient Case Date Records To Be Inserted] FROM dbo._import_2_33_PatientCaseDate pcd 
--INNER JOIN dbo._import_2_33_PatientCase pc ON pcd.PatientCaseID = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
--INNER JOIN dbo._import_2_33_Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Insurance Policy Records To Be Inserted] FROM dbo._import_2_33_InsurancePolicy ip
--INNER JOIN dbo._import_2_33_PatientCase pc ON ip.patientcaseid = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
--INNER JOIN dbo._import_2_33_Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Insurance Policy Authorization Records To Be Inserted] FROM dbo._import_2_33_InsurancePolicyAuthorization ipa 
--INNER JOIN dbo._import_2_33_InsurancePolicy ip ON ipa.InsurancePolicyID = ip.InsurancePolicyID AND ip.PracticeID = @SourcePracticeID
--INNER JOIN dbo._import_2_33_PatientCase pc ON ip.PatientCaseID = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
--INNER JOIN dbo._import_2_33_Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment Records To Be Inserted] FROM dbo._import_2_33_Appointment a
--INNER JOIN dbo._import_2_33_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment Reason Records To Be Inserted] FROM dbo._import_2_33_AppointmentReason ars
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ars.Name = ar.Name AND ar.PracticeID = @TargetPracticeID) AND ars.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Practice Resource Records To Be Inserted] FROM dbo._import_2_33_PracticeResource prs 
WHERE NOT EXISTS (SELECT * FROM dbo.PracticeResource pr WHERE prs.ResourceName = pr.resourcename AND prs.PracticeID = @TargetPracticeID) and prs.practiceid = @SourcePracticeID

SELECT COUNT(*) AS [Appointment to Appointment Reason Records To Be Inserted] FROM dbo._import_2_33_AppointmentToAppointmentReason atar 
INNER JOIN dbo._import_2_33_Appointment a ON atar.AppointmentID = a.AppointmentID
--INNER JOIN dbo._import_2_33_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment to Resource - Doctor Resource Records To Be Inserted] FROM dbo._import_2_33_AppointmentToResource atr
INNER JOIN dbo._import_2_33_Appointment a ON atr.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
--INNER JOIN dbo._import_2_33_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE --NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
atr.AppointmentResourceTypeID = 1 AND atr.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Appointment to Resource - Practice Resource Records To Be Inserted] FROM dbo._import_2_33_AppointmentToResource atr
INNER JOIN dbo._import_2_33_Appointment a ON atr.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
--INNER JOIN dbo._import_2_33_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE --NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
 atr.AppointmentResourceTypeID = 2 AND atr.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Appointment Recurrence Records To Be Inserted] FROM dbo._import_2_33_AppointmentRecurrence ar 
INNER JOIN dbo._import_2_33_Appointment a ON ar.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
--INNER JOIN dbo._import_2_33_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment Recurrence Exception Records To Be Inserted] FROM dbo._import_2_33_AppointmentRecurrenceException are 
INNER JOIN dbo._import_2_33_Appointment a ON are.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
--INNER JOIN dbo._import_2_33_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

*/ 

/*
==========================================================================================================================================
DELETE SCRIPT
==========================================================================================================================================
*/

/*
DELETE FROM dbo.AppointmentRecurrenceException WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE CreatedDate = '2016-05-17 19:40:12.777')
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Recurr Excep records deleted'
DELETE FROM dbo.AppointmentRecurrence WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE CreatedDate = '2016-05-17 19:40:12.777')
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Recurr records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE CreatedDate = '2016-05-17 19:40:12.777')
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE CreatedDate = '2016-05-17 19:40:12.777')
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment  WHERE CreatedDate = '2016-05-17 19:40:12.777'
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
*/


PRINT ''
PRINT 'Updating Existing Patient Records - VendorID...'
UPDATE dbo.Patient 
	SET VendorID = i.id
FROM dbo.Patient p 
INNER JOIN dbo.[_import_2_33_PatientDemographics20577Source] i ON 
	p.PatientID = (SELECT MIN(p2.patientid) FROM dbo.Patient p2 
				   WHERE p2.FirstName = i.firstname AND 
					     p2.LastName = i.lastname AND 
					     p2.DOB = DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)))
WHERE p.VendorID IS NULL OR p.VendorID = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--SELECT p.patientid , p.firstname , p.lastname , p.dob
--FROM dbo.Patient p
--INNER JOIN dbo.[_import_2_33_PatientDemographics20577Source] i ON 
--	p.PatientID = (SELECT MIN(p2.patientid) FROM dbo.Patient p2 
--				   WHERE p2.FirstName = i.firstname AND 
--					     p2.LastName = i.lastname AND 
--					     p2.DOB = DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)))
--WHERE p.VendorID IS NULL OR p.VendorID = ''
--ORDER BY p.FirstName


--SELECT pc.patientcaseid , pc.patientid , pc.VendorID , p.VendorID
--FROM dbo.Patient p
--INNER JOIN dbo.PatientCase pc ON 
--	pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2
--						WHERE pc2.PatientID = p.PatientID AND
--							  pc2.PracticeID = 33 AND 
--							  pc2.Active = 1)
--WHERE p.PracticeID = 33 AND (p.VendorID IS NOT NULL OR p.VendorID <> '') AND (pc.VendorID IS NULL OR pc.VendorID = '')
--ORDER BY pc.PatientID

PRINT ''
PRINT 'Updating Patient Case Reoords - VendorID...'
UPDATE dbo.PatientCase 
	SET VendorID = p.VendorID
FROM dbo.Patient p
INNER JOIN dbo.PatientCase pc ON 
	pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2
						WHERE pc2.PatientID = p.PatientID AND
							  pc2.PracticeID = @TargetPracticeID AND 
							  pc2.Active = 1)
WHERE p.PracticeID = @TargetPracticeID AND (p.VendorID IS NOT NULL OR p.VendorID <> '') AND (pc.VendorID IS NULL OR pc.VendorID = '')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

CREATE TABLE #tempdoc (doctorid INT, firstname VARCHAR(65), lastname VARCHAR(65), NPI INT , [External] INT)
INSERT INTO #tempdoc (doctorid, firstname, lastname, NPI , [External] )
SELECT DISTINCT
		  d.doctorid ,
		  d.firstname ,-- firstname - varchar(65)
          d.lastname, -- lastname - varchar(65)
          d.npi ,  -- NPI - int
		  d.[External]
FROM dbo._import_2_33_Doctor d 
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

CREATE TABLE #tempsl
( id INT , NAME VARCHAR(128))

INSERT INTO #tempsl
        ( id, NAME )
SELECT DISTINCT
		  sl.ServiceLocationID, -- id - int
          osl.Name  -- NAME - varchar(128)
FROM dbo.ServiceLocation sl 
INNER JOIN dbo._import_2_33_ServiceLocation osl ON
	osl.Name = sl.Name and
	OSl.PracticeID = @SourcePracticeID
WHERE sl.PracticeID = @TargetPracticeID

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
		  AllDay ,
          PatientCaseID ,
          Recurrence ,
          RecurrenceStartDate ,
          RangeEndDate ,
          RangeType ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm , 
		  InsurancePolicyAuthorizationID
        )
SELECT 
		  p.PatientID , -- PatientID - int
          @TargetPracticeID , -- PracticeID - int
          CASE WHEN SL.ServiceLocationID IS NULL THEN SL2.ServiceLocationID ELSE SL.ServiceLocationID END , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.appointmenttype , -- AppointmentType - varchar(1)
          i.appointmentid , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          i.ModifiedDate , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.appointmentresourcetypeid , -- AppointmentResourceTypeID - int
          i.appointmentconfirmationstatuscode , -- AppointmentConfirmationStatusCode - char(1)
		  i.AllDay ,
          pc.PatientCaseID ,
          i.recurrence ,
          i.RecurrenceStartDate ,
          NULL ,
          i.RangeType ,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm , -- EndTm - smallint
		  CASE WHEN ipa.InsurancePolicyAuthorizationID IS NOT NULL THEN ipa.InsurancePolicyAuthorizationID ELSE NULL END
FROM dbo.[_import_2_33_Appointment] i
	INNER JOIN dbo.Patient p ON
		p.VendorID = i.patientid AND
		p.PracticeID = @TargetPracticeID
	LEFT JOIN dbo.PatientCase pc ON
		pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2
					        WHERE p.VendorID = pc2.VendorID AND
							      pc2.PracticeID = @TargetPracticeID AND 
								  pc2.Active = 1)
	INNER JOIN dbo.DateKeyToPractice dk ON
        dk.[PracticeID] = @TargetPracticeID AND
        dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
	LEFT JOIN dbo.InsurancePolicyAuthorization ipa ON
		ipa.VendorID = i.insurancepolicyauthorizationid AND
		ipa.VendorImportID = @VendorImportID
	LEFT JOIN dbo.#tempsl tsl ON
		i.ServiceLocationID = tsl.id 
	LEFT JOIN dbo.ServiceLocation sl ON
		tsl.NAME = sl.Name AND
		sl.PracticeID = @TargetPracticeID
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @TargetPracticeID)
	LEFT JOIN dbo.Appointment a ON 
		i.StartDate = a.StartDate AND 
        i.EndDate = a.EndDate AND 
		a.PatientID = p.PatientID
WHERE i.PracticeID = @SourcePracticeID AND a.AppointmentID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into PracticeResource...'
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
SELECT DISTINCT
		  i.practiceresourcetypeid , -- PracticeResourceTypeID - int
          @TargetPracticeID , -- PracticeID - int
          i.resourcename , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
FROM dbo.[_import_2_33_PracticeResource] i
WHERE i.resourcename <> '' AND NOT EXISTS (SELECT * FROM dbo.PracticeResource pr WHERE pr.ResourceName = i.resourcename AND pr.PracticeID = @TargetPracticeID) and i.practiceid = @SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmentReason...'
INSERT  INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
		  @TargetPracticeID , -- PracticeID - int
          i.Name , -- Name - varchar(128)
          i.DefaultDurationMinutes , -- DefaultDurationMinutes - int
          i.DefaultColorCode , -- DefaultColorCode - int
          i.[Description] , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_2_33_AppointmentReason] i
WHERE i.name <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE i.Name = ar.Name AND ar.PracticeID = @TargetPracticeID) and i.practiceid = @SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #apptreason
(
	appointmentid INT , 
	reasonname VARCHAR(50)
)

PRINT ''
PRINT 'Inserting Into #apptreason...'
INSERT INTO #apptreason
	(appointmentid, reasonname)
SELECT DISTINCT
	atar.AppointmentID ,
	ar.Name
FROM dbo.[_import_2_33_AppointmentReason] ar
INNER JOIN dbo.[_import_2_33_AppointmentToAppointmentReason] atar ON
	ar.AppointmentReasonID = atar.AppointmentReasonID AND
	ar.PracticeID = @SourcePracticeID
INNER JOIN dbo.[_import_2_33_Appointment] a ON 
	a.PracticeID = @SourcePracticeID AND
	a.AppointmentID = atar.AppointmentID
INNER JOIN dbo.Appointment app ON 
	a.AppointmentID = app.[Subject] AND 
	app.PracticeID = @TargetPracticeID
WHERE ar.PracticeID = @SourcePracticeID AND app.CreatedDate > DATEADD(mi,-10,GETDATE())
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
          sar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @TargetPracticeID  -- PracticeID - int
	FROM #apptreason ar
		INNER JOIN dbo.AppointmentReason sar ON
			sar.AppointmentReasonID = (SELECT MAX(AppointmentReasonID) FROM dbo.AppointmentReason sar2 
									  WHERE sar2.Name = ar.reasonname AND sar2.PracticeID = @TargetPracticeID) 
	INNER JOIN dbo.Appointment a ON 
		a.PracticeID = @TargetPracticeID AND
		ar.appointmentid = a.[Subject]
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #appttopracres
(
	appointmentid INT , 
	pracresourcename VARCHAR(50)
)

PRINT ''
PRINT 'Inserting Into #appttopracres...'
INSERT INTO #appttopracres
	(appointmentid, pracresourcename)
SELECT DISTINCT
	atr.AppointmentID ,
	pr.ResourceName
FROM dbo.[_import_2_33_AppointmentToResource] atr
INNER JOIN dbo.[_import_2_33_PracticeResource] pr ON
	atr.ResourceID = pr.PracticeResourceID  AND
	atr.PracticeID = @SourcePracticeID
INNER JOIN dbo.[_import_2_33_Appointment] a ON 
	a.AppointmentID = atr.AppointmentID AND
	a.PracticeID = @SourcePracticeID
INNER JOIN dbo.Appointment app ON 
	a.AppointmentID = app.[Subject] AND 
	app.PracticeID = @TargetPracticeID
WHERE atr.AppointmentResourceTypeID = 2 AND app.CreatedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Resource - Practice Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          2 , -- AppointmentResourceTypeID - int
          pr.PracticeResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @TargetPracticeID  -- PracticeID - int
FROM #appttopracres atpr
	INNER JOIN dbo.PracticeResource pr ON	
		pr.ResourceName = atpr.pracresourcename AND
		pr.PracticeID = @TargetPracticeID
	INNER JOIN dbo.Appointment a ON
		a.[Subject] = atpr.appointmentid AND
		a.PracticeID = @TargetPracticeID
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Resource - Doctor Resource'
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
          CASE WHEN d.DoctorID IS NULL THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'JOHN' AND LastName = 'NELSON' AND PracticeID = @TargetPracticeID AND [External] = 0) ELSE d.DoctorID END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @TargetPracticeID  -- PracticeID - int
FROM dbo.[_import_2_33_AppointmentToResource] i
	INNER JOIN dbo.Appointment a ON
		a.[Subject] = i.appointmentid AND
		a.PracticeID = @TargetPracticeID
	LEFT JOIN dbo.Doctor d ON
		i.resourceid = d.VendorID AND
		d.PracticeID = @TargetPracticeID
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE()) AND i.AppointmentResourceTypeID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #apptrecurappt (AppointmentID INT, RangeEndDate DATETIME)

INSERT INTO #apptrecurappt
        ( AppointmentID, RangeEndDate )
SELECT DISTINCT
		  i.AppointmentID, -- AppointmentID - int
          i.RangeEndDate  -- RangeEndDate - datetime
FROM dbo.[_import_2_33_Appointment] i
INNER JOIN dbo.Appointment a ON 
	i.AppointmentID = a.[Subject] AND
    a.PracticeID = @TargetPracticeID  
WHERE i.PracticeID = @SourcePracticeID AND a.CreatedDate > DATEADD(mi,-10,GETDATE()) AND a.RangeEndDate IS NOT NULL

PRINT ''
PRINT 'Updating Appointment RangeEndDate...'
UPDATE dbo.Appointment
	SET RangeEndDate = i.RangeEndDate
FROM dbo.Appointment a 
INNER JOIN #apptrecurappt i ON
	i.AppointmentID = a.[Subject] AND
    a.PracticeID = @TargetPracticeID
WHERE a.PracticeID = @TargetPracticeID AND a.CreatedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated...'

USE superbill_8023_prod
GO 
DISABLE TRIGGER ALL ON dbo.AppointmentRecurrence
GO


DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 33
SET @SourcePracticeID = 1
SET @VendorImportID = 2

SET XACT_ABORT ON

PRINT ''
PRINT 'Inserting Into Appointment Recurrence...'
INSERT INTO dbo.AppointmentRecurrence
        ( AppointmentID ,
          Type ,
          WeeklyNumWeeks ,
          WeeklyOnSunday ,
          WeeklyOnMonday ,
          WeeklyOnTuesday ,
          WeeklyOnWednesday ,
          WeeklyOnThursday ,
          WeeklyOnFriday ,
          WeeklyOnSaturday ,
          DailyType ,
          DailyNumDays ,
          MonthlyType ,
          MonthlyNumMonths ,
          MonthlyDayOfMonth ,
          MonthlyWeekTypeOfMonth ,
          MonthlyTypeOfDay ,
          YearlyType ,
          YearlyDayTypeOfMonth ,
          YearlyTypeOfDay ,
          YearlyDayOfMonth ,
          YearlyMonth ,
          RangeType ,
          RangeEndOccurrences ,
          RangeEndDate ,
          ModifiedDate ,
          ModifiedUserID ,
          StartDate 
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          i.[Type] , -- Type - char(1)
          i.WeeklyNumWeeks , -- WeeklyNumWeeks - int
          i.WeeklyOnSunday , -- WeeklyOnSunday - bit
          i.WeeklyOnMonday , -- WeeklyOnMonday - bit
          i.WeeklyOnTuesday , -- WeeklyOnTuesday - bit
          i.WeeklyOnWednesday , -- WeeklyOnWednesday - bit
          i.weeklyonthursday , -- WeeklyOnThursday - bit
          i.WeeklyOnFriday , -- WeeklyOnFriday - bit
          i.WeeklyOnSaturday , -- WeeklyOnSaturday - bit
          i.DailyType , -- DailyType - char(1)
          i.DailyNumDays , -- DailyNumDays - int
          i.MonthlyType , -- MonthlyType - char(1)
          i.MonthlyNumMonths , --  - int
          i.MonthlyDayOfMonth , -- MonthlyDayOfMonth - int
          i.MonthlyWeekTypeOfMonth , -- MonthlyWeekTypeOfMonth - char(1)
          i.MonthlyTypeOfDay , -- MonthlyTypeOfDay - char(1)
          i.YearlyType , -- YearlyType - char(1)
          i.YearlyDayTypeOfMonth , -- YearlyDayTypeOfMonth - char(1)
          i.YearlyTypeOfDay , -- YearlyTypeOfDay - char(1)
          i.YearlyDayOfMonth , -- YearlyDayOfMonth - int
          i.YearlyMonth , -- YearlyMonth - int
          i.RangeType , -- RangeType - char(1)
          i.RangeEndOccurrences , -- RangeEndOccurrences - int
          a.RangeEndDate , -- RangeEndDate - datetime
          i.ModifiedDate , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.StartDate  -- StartDate - datetime
FROM dbo.[_import_2_33_AppointmentRecurrence] i 
INNER JOIN dbo.Appointment a ON
	i.AppointmentID = a.[Subject] AND
	a.PracticeID = @TargetPracticeID 
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE()) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

USE superbill_8023_prod
GO
 ENABLE TRIGGER ALL ON dbo.AppointmentRecurrence
GO


USE superbill_8023_prod
GO
 DISABLE TRIGGER ALL ON dbo.AppointmentRecurrenceException
GO
SET XACT_ABORT ON

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 33
SET @SourcePracticeID = 1
SET @VendorImportID = 2

PRINT ''
PRINT 'Inserting Into Appointment Recurrence Exception...'
INSERT INTO dbo.AppointmentRecurrenceException
        ( AppointmentID ,
          ExceptionDate ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
	      a.AppointmentID , -- AppointmentID - int
          i.exceptiondate , -- ExceptionDate - datetime
          i.ModifiedDate , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_2_33_AppointmentRecurrenceException] i
INNER JOIN dbo.Appointment a ON 
	i.AppointmentID = a.[subject] AND
	a.PracticeID = @TargetPracticeID 
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

USE superbill_8023_prod
GO
ENABLE TRIGGER ALL ON dbo.AppointmentRecurrenceException
GO

SET XACT_ABORT ON

DROP TABLE #tempdoc
DROP TABLE #tempsl
DROP TABLE #apptreason 
DROP TABLE #appttopracres
DROP TABLE #apptrecurappt



--COMMIT
--ROLLBACK
