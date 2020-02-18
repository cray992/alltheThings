USE superbill_28577_dev
--USE superbill_28577_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 2
SET @PracticeID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0


PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          1 , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.patientfirstname , -- FirstName - varchar(64)
          i.patientmiddleinitial , -- MiddleName - varchar(64)
          i.patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.patientaddress1 , -- AddressLine1 - varchar(256)
          i.patientaddress2 , -- AddressLine2 - varchar(256)
          i.patientcity , -- City - varchar(128)
          LEFT(i.patientstate , 2), -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)) IN (4,8) THEN '0' + (dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)) 
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)) IN (5,9) THEN (dbo.fn_RemoveNonNumericCharacters(i.patientzipcode))
		  ELSE '' END, -- ZipCode - varchar(9)
          CASE WHEN i.patientsex = '' THEN 'U' ELSE i.patientsex END , -- Gender - varchar(1)
          CASE i.patientmaritalstatus WHEN 'Married' THEN 'M'
									  WHEN 'Separated' THEN 'L'
									  WHEN 'Married' THEN 'M'
									  WHEN 'Divorced' THEN 'D'
									  WHEN 'Widowed' THEN 'W'
									  WHEN 'Partnered' THEN 'T'
									  WHEN 'Single' THEN 'S'
									  ELSE '' END, -- MaritalStatus - varchar(1)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientphone),10)
		  ELSE '' END  , -- HomePhone - varchar(10)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientphone))),10)
		  ELSE NULL END , -- HomePhoneExt - varchar(10)
          CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone),10)
		  ELSE '' END   , -- WorkPhone - varchar(10)
          CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientworkextension)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientworkextension),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientworkextension))),10)
		  ELSE NULL END , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(i.patientdateofbirth) = 1 THEN i.patientdateofbirth ELSE NULL END , -- DOB - datetime
          CASE WHEN LEN(i.patientsocialsecurity)>= 6 THEN RIGHT('000' + i.patientsocialsecurity, 9) ELSE NULL END , -- SSN - char(9)
          i.patientemailaddress , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.patientemployercode <> '' THEN 'E' ELSE 'U' END, -- EmploymentStatus - char(1)
          i.patientaccountnumber , -- MedicalRecordNumber - varchar(128)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone),10)
		  ELSE '' END , -- MobilePhone - varchar(10)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone))),10)
		  ELSE NULL END  , -- MobilePhoneExt - varchar(10)
          i.patientaccountnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- PhonecallRemindersEnabled - bit
          i.patientemergencyfirstname + ' ' + i.patientemergencylastname , -- EmergencyName - varchar(128)
          LEFT(i.patientemergencyphone,10)  -- EmergencyPhone - varchar(10)
FROM dbo.[_import_2_1_PatientMaster] i
WHERE i.patientfirstname <> '' AND i.patientlastname <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
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
          'Self Pay' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
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
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          'Kareo Import' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          CASE WHEN i.patientlastvisit = '' THEN '' ELSE 'Patient Last Visit: ' + i.patientlastvisit + CHAR(13) + CHAR(10) END +
		 (CASE WHEN i.patientlaststatementdate = '' THEN '' ELSE 'Patient Last Statement Date: ' + i.patientlaststatementdate + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN i.patientlaststatementamount = '' THEN '' ELSE 'Patient Last Statement Amount: ' + i.patientlaststatementamount + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN i.patientdriverslicense = '' THEN '' ELSE 'Patient Drivers License: '  + i.patientdriverslicense + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN i.patientcontactinstruction = '' THEN '' ELSE 'Patient Contact Instruction: ' + i.patientcontactinstruction END), -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          1  -- LastNote - bit
FROM dbo.[_import_2_1_PatientMaster] i
INNER JOIN dbo.Patient p ON
	i.patientaccountnumber = p.VendorID AND
	p.VendorImportID = @VendorImportID AND 
	p.PracticeID = @PracticeID
WHERE i.patientlastvisit <> '' OR patientlaststatementdate <> '' OR patientlaststatementamount <> '' OR patientdriverslicense <> '' OR patientcontactinstruction <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          1 , -- ServiceLocationID - int
          i.startdateest , -- StartDate - datetime
          i.enddateest , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.apptcomment + CASE WHEN i.apptphone = '' THEN '' ELSE CHAR(13) + CHAR(10) + 'Phone: ' + i.apptphone END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttmest , -- StartTm - smallint
          i.endtmest  -- EndTm - smallint
FROM dbo.[_import_2_1_AppointmentMaster] i
INNER JOIN dbo.Patient p ON 
	i.apptaccountnumber = p.VendorID AND
	p.VendorImportID = @VendorImportId
INNER JOIN dbo.PatientCase pc ON 
	i.apptaccountnumber = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice dk ON	
	dk.PracticeID = @PracticeID AND
	dk.dt = CAST(CAST(i.startdateest AS DATE) AS DATETIME)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_AppointmentMaster] i
INNER JOIN dbo.Patient p ON
	i.apptaccountnumber = p.VendorID AND
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON
	p.PatientID = a.PatientID AND
	a.StartDate = CAST(i.startdateest AS DATETIME) AND
	a.enddate = CAST(i.enddateest AS DATETIME) 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--ROLLBACK
--COMMIT

