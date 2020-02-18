--USE superbill_52844_dev
USE superbill_52844_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

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
INNER JOIN dbo.[_import_3_1_PatientDemographics] i ON p.PatientID = i.id

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

UPDATE dbo.Patient 
	SET   ResponsibleDifferentThanPatient = 0 
		, ResponsiblePrefix = NULL
		, ResponsibleFirstName = NULL
		, ResponsibleMiddleName = NULL
		, ResponsibleLastName = NULL
		, ResponsibleSuffix = NULL
		, ResponsibleRelationshipToPatient = 'O'
		, ResponsibleAddressLine1 = NULL
		, ResponsibleAddressLine2 = NULL
		, ResponsibleCity = NULL
		, ResponsibleState = NULL
		, ResponsibleCountry = NULL
		, ResponsibleZipCode = NULL
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID AND ModifiedUserID = 0

PRINT ''
PRINT 'Updating Patient...'''
UPDATE dbo.Patient 
	SET MaritalStatus = CASE i.maritalstatus
							WHEN 1 THEN 'S'
							WHEN 2 THEN 'M'
							WHEN 3 THEN 'D'
							WHEN 4 THEN 'W'
							WHEN 5 THEN 'L'
						ELSE '' END 
		, ResponsibleDifferentThanPatient = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN 1 ELSE 0 END 
		, ResponsiblePrefix = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN '' END
		, ResponsibleFirstName = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN ir.firstname END
		, ResponsibleMiddleName = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN ir.middlename END
		, ResponsibleLastName = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN ir.lastname END
		, ResponsibleSuffix = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN '' END
		, ResponsibleRelationshipToPatient = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN 
												CASE ic.relationship
													WHEN 'A' THEN 'U'
													WHEN 'I' THEN 'C'
													WHEN 'K' THEN 'C'
													WHEN 'R' THEN 'C'
													ELSE 'O' END 
											  ELSE 'O' END
		, ResponsibleAddressLine1 = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN ir.address1 END 
		, ResponsibleAddressLine2 = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN ir.address2 END 
		, ResponsibleCity = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN ir.city END
		, ResponsibleState = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN ir.[state] END
		, ResponsibleCountry = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN '' END
		, ResponsibleZipCode = CASE WHEN i.firstname <> ir.firstname OR i.lastname <> ir.lastname THEN 
									CASE WHEN LEN(ir.zipcode) IN (4,8) THEN '0' + ir.zipcode ELSE ir.zipcode END 
							   END
FROM dbo.Patient p  
INNER JOIN dbo._import_2_1_PATIENT i ON p.VendorID = i.patuniqueid AND p.PracticeID = @PracticeID
LEFT JOIN dbo._import_2_1_RESP ir ON i.respuniqueid = ir.respuniqueid
LEFT JOIN dbo._import_2_1_INSCOVERAGE ic ON i.patuniqueid = ic.patuniqueid
WHERE p.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Primary...'
UPDATE dbo.InsurancePolicy
	SET PatientRelationshipToInsured = CASE i.relationship
										WHEN 'A' THEN 'U'
										WHEN 'I' THEN 'C'
										WHEN 'K' THEN 'C'
										WHEN 'R' THEN 'C'
										WHEN 'Q' THEN 'O'
										WHEN 'Z' THEN 'O'
										ELSE 'S' 
									   END 
	   , HolderPrefix = p.ResponsiblePrefix 
	   , HolderFirstName = p.ResponsibleFirstName
	   , HolderMiddleName = p.ResponsibleMiddleName
	   , HolderLastName = p.ResponsibleLastName
	   , HolderSuffix = p.ResponsibleSuffix
	   , HolderAddressLine1 = p.ResponsibleAddressLine1
	   , HolderAddressLine2 = p.ResponsibleAddressLine2
	   , HolderCity = p.ResponsibleCity
	   , HolderState = p.ResponsibleState
	   , HolderCountry = p.ResponsibleCountry
	   , HolderZipCode = p.ResponsibleZipCode
	   , HolderDOB = CASE WHEN ipat.firstname <> iresp.firstname THEN 
					  CASE WHEN ISDATE(iresp.dob) = 1 THEN iresp.dob ELSE NULL END
					 END
	   , HolderSSN = CASE WHEN ipat.firstname <> iresp.firstname THEN 
					  CASE WHEN LEN(iresp.soc) >= 6 THEN RIGHT('000' + iresp.soc,9) END 
					 END
	   , HolderGender = CASE WHEN ipat.firstname <> iresp.firstname THEN iresp.sex END
FROM dbo.InsurancePolicy ip 
INNER JOIN dbo.PatientCase pc ON ip.PatientCaseID = pc.PatientCaseID
INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID
INNER JOIN dbo._import_2_1_INSCOVERAGE i ON pc.VendorID = i.patuniqueid AND i.plannumber = 1 AND i.relationship <> 'J'
INNER JOIN dbo._import_2_1_PATIENT ipat ON ip.VendorID = ipat.patuniqueid
LEFT JOIN dbo._import_2_1_RESP iresp ON ipat.respuniqueid = iresp.respuniqueid
WHERE ip.VendorImportID = @VendorImportID AND ip.Precedence = 1 AND ip.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Secondary...'
UPDATE dbo.InsurancePolicy
	SET PatientRelationshipToInsured = CASE i.relationship
										WHEN 'A' THEN 'U'
										WHEN 'I' THEN 'C'
										WHEN 'K' THEN 'C'
										WHEN 'R' THEN 'C'
										WHEN 'Q' THEN 'O'
										WHEN 'Z' THEN 'O'
										ELSE 'S' 
									   END 
	   , HolderPrefix = p.ResponsiblePrefix 
	   , HolderFirstName = p.ResponsibleFirstName
	   , HolderMiddleName = p.ResponsibleMiddleName
	   , HolderLastName = p.ResponsibleLastName
	   , HolderSuffix = p.ResponsibleSuffix
	   , HolderAddressLine1 = p.ResponsibleAddressLine1
	   , HolderAddressLine2 = p.ResponsibleAddressLine2
	   , HolderCity = p.ResponsibleCity
	   , HolderState = p.ResponsibleState
	   , HolderCountry = p.ResponsibleCountry
	   , HolderZipCode = p.ResponsibleZipCode
	   , HolderDOB = CASE WHEN ipat.firstname <> iresp.firstname THEN 
					  CASE WHEN ISDATE(iresp.dob) = 1 THEN iresp.dob ELSE NULL END
					 END
	   , HolderSSN = CASE WHEN ipat.firstname <> iresp.firstname THEN 
					  CASE WHEN LEN(iresp.soc) >= 6 THEN RIGHT('000' + iresp.soc,9) END 
					 END
	   , HolderGender = CASE WHEN ipat.firstname <> iresp.firstname THEN iresp.sex END
FROM dbo.InsurancePolicy ip 
INNER JOIN dbo.PatientCase pc ON ip.PatientCaseID = pc.PatientCaseID
INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID
INNER JOIN dbo._import_2_1_INSCOVERAGE i ON pc.VendorID = i.patuniqueid AND i.plannumber = 2 AND i.relationship <> 'J'
INNER JOIN dbo._import_2_1_PATIENT ipat ON ip.VendorID = ipat.patuniqueid
LEFT JOIN dbo._import_2_1_RESP iresp ON ipat.respuniqueid = iresp.respuniqueid
WHERE ip.VendorImportID = @VendorImportID AND ip.Precedence = 2 AND ip.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Tertiary...'
UPDATE dbo.InsurancePolicy
	SET PatientRelationshipToInsured = CASE i.relationship
										WHEN 'A' THEN 'U'
										WHEN 'I' THEN 'C'
										WHEN 'K' THEN 'C'
										WHEN 'R' THEN 'C'
										WHEN 'Q' THEN 'O'
										WHEN 'Z' THEN 'O'
										ELSE 'S' 
									   END 
	   , HolderPrefix = p.ResponsiblePrefix 
	   , HolderFirstName = p.ResponsibleFirstName
	   , HolderMiddleName = p.ResponsibleMiddleName
	   , HolderLastName = p.ResponsibleLastName
	   , HolderSuffix = p.ResponsibleSuffix
	   , HolderAddressLine1 = p.ResponsibleAddressLine1
	   , HolderAddressLine2 = p.ResponsibleAddressLine2
	   , HolderCity = p.ResponsibleCity
	   , HolderState = p.ResponsibleState
	   , HolderCountry = p.ResponsibleCountry
	   , HolderZipCode = p.ResponsibleZipCode
	   , HolderDOB = CASE WHEN ipat.firstname <> iresp.firstname THEN 
					  CASE WHEN ISDATE(iresp.dob) = 1 THEN iresp.dob ELSE NULL END
					 END
	   , HolderSSN = CASE WHEN ipat.firstname <> iresp.firstname THEN 
					  CASE WHEN LEN(iresp.soc) >= 6 THEN RIGHT('000' + iresp.soc,9) END 
					 END
	   , HolderGender = CASE WHEN ipat.firstname <> iresp.firstname THEN iresp.sex END
FROM dbo.InsurancePolicy ip 
INNER JOIN dbo.PatientCase pc ON ip.PatientCaseID = pc.PatientCaseID
INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID
INNER JOIN dbo._import_2_1_INSCOVERAGE i ON pc.VendorID = i.patuniqueid AND i.plannumber = 3 AND i.relationship <> 'J'
INNER JOIN dbo._import_2_1_PATIENT ipat ON ip.VendorID = ipat.patuniqueid
LEFT JOIN dbo._import_2_1_RESP iresp ON ipat.respuniqueid = iresp.respuniqueid
WHERE ip.VendorImportID = @VendorImportID AND ip.Precedence = 3 AND ip.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--temp table to map appointments from vendor import table to the account
CREATE TABLE #tempappt (PatVendorID VARCHAR(25) , StartDate DATETIME , EndDate DateTIME , ServiceLocationID VARCHAR(1) , [Status] INT)
INSERT INTO #tempappt
        ( PatVendorID ,
          StartDate ,
          EndDate ,
          ServiceLocationID ,
		  [Status]
        )
SELECT DISTINCT
		  ia.clientid , -- PatVendorID - varchar(25)
          CAST(ia.apptdate AS DATETIME) + DATEADD(hh,-2,CAST(CAST(ia.starttime AS TIME) AS DATETIME)) , -- StartDate - datetime
          CAST(ia.apptdate AS DATETIME) + DATEADD(hh,-2,CAST(CAST(ia.starttime AS TIME) AS DATETIME)) + CAST(CAST(ia.duration AS TIME) AS DATETIME) , -- EndDate - datetime
          CASE LEFT(ir.resourceiddesc,1) 
			WHEN 'D' THEN 1
			WHEN 'M' THEN 2
		  END , -- ServiceLocationID - varchar(1)
		  CASE WHEN ia.[status] = '101' THEN 1 ELSE 0 END
FROM dbo._import_2_1_APPTS ia
LEFT JOIN dbo._import_2_1_RESOURCE ir ON 
	ia.resourceid = ir.resourceid
WHERE ia.clientid <> '' 

PRINT ''
PRINT 'Updating Appointment - Service Location...'
UPDATE dbo.Appointment
	SET ServiceLocationID = i.ServiceLocationID
FROM dbo.Appointment a 
INNER JOIN dbo.Patient p ON 
	a.PatientID = p.PatientID AND 
	p.VendorImportID = @VendorImportID
INNER JOIN #tempappt i ON 
	a.StartDate = i.StartDate AND 
	a.EndDate = i.EndDate AND
	p.VendorID = i.PatVendorID
WHERE i.ServiceLocationID = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

-- temp table to select the location and provider from the oldest appointment
CREATE TABLE #deflocdoc (ServiceLocationID INT , PrimaryProviderID INT , PatientID INT)
INSERT INTO #deflocdoc
        ( ServiceLocationID ,
          PrimaryProviderID ,
		  PatientID
        )
SELECT DISTINCT
		  a.ServiceLocationID , -- ServiceLocationID - int
          atr.ResourceID , -- PrimaryProviderID - int
		  p.PatientID 
FROM dbo.Appointment a
INNER JOIN (
	SELECT PatientID , AppointmentID , ROW_NUMBER() OVER (PARTITION BY PatientID ORDER BY StartDate ASC) rn FROM dbo.Appointment 
	       ) AS a2 ON a.AppointmentID = a2.AppointmentID 
INNER JOIN dbo.Patient p ON 
	a2.PatientID = p.PatientID
INNER JOIN dbo.AppointmentToResource atr ON 
	a.AppointmentID = atr.AppointmentID AND
    atr.AppointmentResourceTypeID = 1
WHERE a2.rn = 1 


PRINT ''
PRINT 'Updating Patient - Default Service Location and Primary Provider...'
UPDATE dbo.Patient 
	SET DefaultServiceLocationID = i.ServiceLocationID
	  , PrimaryProviderID = i.PrimaryProviderID
FROM dbo.Patient p 
INNER JOIN #deflocdoc i ON 
	p.PatientID = i.PatientID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Appointment Start and End Dates...'
UPDATE dbo.Appointment 
	SET	 StartDate = '2009-01-01 08:00:00.000' 
		, EndDate = '2009-01-01 08:05:00.000' 
		, AppointmentConfirmationStatusCode = 'X'
FROM dbo.Appointment a 
INNER JOIN dbo.Patient p ON 
	a.PatientID = p.PatientID AND 
	p.VendorImportID = @VendorImportID
INNER JOIN #tempappt i ON 
	a.StartDate = i.StartDate AND 
	a.EndDate = i.EndDate AND 
	p.VendorID = i.PatVendorID
WHERE i.[Status] = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

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
	      PAT.PatientID , -- PatientID - int
	      'Kareo' , -- UserName - varchar(128)
	      'K' , -- SoftwareApplicationID - char(1)
	      0 , -- Hidden - bit
	      i.note , -- NoteMessage - varchar(max)
	      0 , -- AccountStatus - bit
	      1 , -- NoteTypeCode - int
	      0  -- LastNote - bit
FROM dbo._import_2_1_APPTS i
INNER JOIN dbo.Patient PAT ON
	i.clientid = PAT.VendorID AND
	PAT.PracticeID = @PracticeID
WHERE i.note <> ''	AND i.clientid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Alert...'
INSERT INTO dbo.PatientAlert
( 
	PatientID ,AlertMessage ,ShowInPatientFlag ,ShowInAppointmentFlag ,ShowInEncounterFlag ,CreatedDate ,CreatedUserID ,ModifiedDate ,
	ModifiedUserID ,ShowInClaimFlag ,ShowInPaymentFlag ,ShowInPatientStatementFlag
)
SELECT DISTINCT
	PAT.PatientID , -- PatientID - int
	ipd.msg1 + CASE WHEN ipd.msg2 = '' THEN '' ELSE ' | ' END
	+ CASE WHEN ipd.msg2 = '' THEN '' ELSE ipd.msg2 + CASE WHEN ipd.msg3 = '' THEN '' ELSE ' | ' END END
	+ CASE WHEN ipd.msg3 = '' THEN '' ELSE ipd.msg3 + CASE WHEN ipd.msg4 = '' THEN '' ELSE ' | ' END END
	+ CASE WHEN ipd.msg4 = '' THEN '' ELSE ipd.msg4 + CASE WHEN ipd.msg5 = '' THEN '' ELSE ' | ' END END
	+ CASE WHEN ipd.msg5 = '' THEN '' ELSE ipd.msg5 + CASE WHEN ipd.msg6 = '' THEN '' ELSE ' | ' END END
	+ CASE WHEN ipd.msg6 = '' THEN '' ELSE ipd.msg6 + CASE WHEN ipd.msg7 = '' THEN '' ELSE ' | ' END END
	+ CASE WHEN ipd.msg7 = '' THEN '' ELSE ipd.msg7 + CASE WHEN ipd.msg8 = '' THEN '' ELSE ' | ' END END
	+ CASE WHEN ipd.msg8 = '' THEN '' ELSE ipd.msg8 + CASE WHEN ipd.msg9 = '' THEN '' ELSE ' | ' END END
	+ CASE WHEN ipd.msg9 = '' THEN '' ELSE ipd.msg9 + CASE WHEN ipd.msg10 = '' THEN '' ELSE ' | ' END END
	+ CASE WHEN ipd.msg10 = '' THEN '' ELSE ipd.msg10 END, -- AlertMessage - text
	1, -- ShowInPatientFlag - bit
	1, -- ShowInAppointmentFlag - bit
	0, -- ShowInEncounterFlag - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	1, -- ShowInClaimFlag - bit
	0, -- ShowInPaymentFlag - bit
	0-- ShowInPatientStatementFlag - bit
FROM dbo._import_2_1_PATMEMO AS IPD
INNER JOIN dbo.Patient AS PAT ON 
	PAT.VendorID = IPD.patuniqueid AND 
	PAT.VendorImportID = @VendorImportID
WHERE IPD.msg1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DROP TABLE #tempappt
DROP TABLE #deflocdoc

--ROLLBACK
--COMMIT
