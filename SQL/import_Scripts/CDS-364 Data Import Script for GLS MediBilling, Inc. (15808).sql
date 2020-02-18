USE superbill_15808_dev
--USE superbill_15808_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID =	2
SET @PracticeID = 3

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.AppointmentReason WHERE ModifiedDate BETWEEN DATEADD(mi , 20 , GETDATE()) AND DATEADD(mi, -20, GETDATE())
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Reason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


PRINT ''
PRINT 'Inserting into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          BillSecondaryInsurance ,
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
		  primaryinsurance , -- InsuranceCompanyName - varchar(128)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          primaryinsurance , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_3_PolicyInformation] i
WHERE primaryinsurance <> '' 
AND NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic where i.primaryinsurance = ic.InsuranceCompanyName and 
															ic.CreatedPracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Insurance Company Plan...'
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
		  InsuranceCompanyName , -- PlanName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient...'
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
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
		  HomePhoneExt ,
          DOB ,
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
          Active 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          middlename , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          suffix , -- Suffix - varchar(16)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT(state,2) , -- State - varchar(2)
          CASE WHEN LEN(zip) = 5 THEN zip + 
								(CASE WHEN LEN(zipext) >=1 THEN RIGHT('000' + zipext, 4) ELSE '' END) 
			   WHEN LEN(zip) = 4 THEN '0' + zip + 
								(CASE WHEN LEN(zipext) >=1 THEN RIGHT('000' + zipext, 4) ELSE '' END)
			   ELSE '' END  , -- ZipCode - varchar(9)
          sex , -- Gender - varchar(1)
          'U' , -- MaritalStatus - varchar(1)
	      CASE
		  WHEN LEN(phone)>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(phone),10)
		  ELSE '' END , -- HomePhone - varchar(10)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(phone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(phone),11,LEN(dbo.fn_RemoveNonNumericCharacters(phone))),10)
		  ELSE NULL END , -- HomePhoneExt - varchar(10)
          CASE WHEN ISDATE(dob) = 1 THEN dob ELSE NULL END , -- DOB - datetime
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          4 , -- PrimaryProviderID - int
          NULL , -- DefaultServiceLocationID - int
          pid , -- MedicalRecordNumber - varchar(128)
          pid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_2_3_PatientDemo]
WHERE firstname <> '' AND lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Alert...'
INSERT INTO dbo.PatientAlert
        ( PatientID ,
          AlertMessage ,
          ShowInPatientFlag ,
          ShowInAppointmentFlag ,
          ShowInEncounterFlag ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT DISTINCT
		  pat.PatientID , -- PatientID - int
          'Patient Balance: ' + imppat.accountbalance , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          1 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          1 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_2_3_PatientBalance] AS imppat
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = imppat.pid AND
	pat.VendorImportID = @VendorImportID
WHERE imppat.accountbalance <> '$0.00'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
		  Notes ,
          Active ,
          PayerScenarioID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          StatementActive ,
          EPSDTCodeID 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
		  CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
           @PracticeID, -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- StatementActive - bit
          1  -- EPSDTCodeID - int
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Primary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
          1 , -- Precedence - int
          imppi.insurancepolicynumber , -- PolicyNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          imppi.copayamount , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
		  'Y'
FROM dbo.[_import_2_3_PolicyInformation] AS imppi
INNER JOIN dbo.PatientCase AS pc ON	
	pc.VendorID = imppi.pid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.InsuranceCompanyPlanID = (SELECT TOP 1 icp2.InsuranceCompanyPlanID 
								  FROM dbo.InsuranceCompanyPlan icp2
								  WHERE icp2.PlanName = imppi.primaryinsurance
								  ORDER BY icp2.InsuranceCompanyPlanID ASC) AND
	icp.CreatedPracticeID = @PracticeID  
WHERE imppi.primaryinsurance <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Secondary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          imppi.secondaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
		  'Y'
FROM dbo.[_import_2_3_PolicyInformation] AS imppi
INNER JOIN dbo.PatientCase AS pc ON	
	pc.VendorID = imppi.pid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.InsuranceCompanyPlanID = (SELECT TOP 1 icp2.InsuranceCompanyPlanID 
								  FROM dbo.InsuranceCompanyPlan icp2
								  WHERE icp2.PlanName = imppi.secondaryinsurance
								  ORDER BY icp2.InsuranceCompanyPlanID ASC) AND
	icp.CreatedPracticeID = @PracticeID  
WHERE secondaryinsurance <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment Reason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          impapp.reason , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          impapp.reason , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_2_3_Appointment] impapp
WHERE impapp.reason <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason WHERE impapp.reason = Name)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Appointment...'
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
		  pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          8 , -- ServiceLocationID - int
          DATEADD(hh,-3,impapp.startdate) , -- StartDate - datetime
          DATEADD(hh,-3,impapp.enddate) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          impapp.pid + ' - ' + impapp.[resource] , -- Subject - varchar(64)
          impapp.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE impapp.STATUS WHEN 'COMPLETE' THEN 'S'
							 WHEN 'CANCELLED' THEN 'X'
							 WHEN 'MISSED' THEN 'N'
							 WHEN 'RESCHEDULED' THEN 'R'
							 ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          impapp.starttm - 300 , -- StartTm - smallint
          impapp.endtm - 300  -- EndTm - smallint
FROM dbo.[_import_2_3_Appointment] impapp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = impapp.pid AND
	pat.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase pc ON
	pc.PatientID = pat.PatientID AND
	pc.VendorImportID = @VendorImportID  
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = CAST(CAST(impApp.startdate AS DATE) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  app.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE impapp.RESOURCE WHEN 'E. APPIADU' THEN 4
							   WHEN 'E. KELLY' THEN 6
							   WHEN 'M. COULTER' THEN 5
							   WHEN 'N. NIHALANI' THEN 4
							   ELSE 4 END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_3_Appointment] AS impapp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = impapp.pid AND
	pat.VendorImportID = @VendorImportID  
INNER JOIN dbo.Appointment app ON
	app.PatientID = pat.PatientID AND
	app.StartDate = CAST(DATEADD(hh,-3,impapp.startdate) AS DATETIME) AND
	app.EndDate = CAST(DATEADD(hh,-3,impapp.enddate) AS DATETIME) AND
	app.[Subject] = impapp.pid + ' - ' + impapp.[resource]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Appointment to Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  app.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_3_Appointment] impapp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = impapp.pid AND
	pat.VendorImportID = @VendorImportID  
INNER JOIN dbo.Appointment AS app ON
	app.PatientID = pat.PatientID AND
	app.PracticeID = @PracticeID AND
	app.StartDate = CAST(DATEADD(hh,-3,impapp.startdate) AS DATETIME) AND
	app.EndDate = CAST(DATEADD(hh,-3,impapp.enddate) AS DATETIME) AND
	app.[Subject] = impapp.pid + ' - ' + impapp.[resource]
INNER JOIN dbo.AppointmentReason ar ON
	ar.name = impapp.reason AND
	ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 ,
		  Name = 'Self Pay'
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'






--ROLLBACK
--COMMIT