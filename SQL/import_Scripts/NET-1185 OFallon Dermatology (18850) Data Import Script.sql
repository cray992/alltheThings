USE --superbill_18850_prod
superbill_18850_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Purging existing records in detination tables for VendorImport ' + CAST(@@ROWCOUNT AS VARCHAR(10)) 

DELETE FROM dbo.InsurancePolicyAuthorization WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Authorization records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Employers
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
/*
==========================================================================================================================================
CREATE EMPLOYERS
==========================================================================================================================================
*/

--PRINT ''
--PRINT 'Inserting into Employers...'
--INSERT INTO dbo.Employers
--        ( EmployerName ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID 
--        )
--SELECT DISTINCT
--		  employername , -- EmployerName - varchar(128)
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0  -- ModifiedUserID - int
--FROM dbo.[_import_2_1_PatientDemo]
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PATIENTS
==========================================================================================================================================
*/

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
          EmployerID ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          EmergencyName ,
          EmergencyPhone 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          imp.firstname , -- FirstName - varchar(64)
          imp.mi , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.state , -- State - varchar(2)
          CASE WHEN LEN(imp.zip) IN (5,9) THEN imp.zip
			   WHEN LEN(imp.zip) = 4 THEN '0' + imp.zip
			   WHEN LEN(imp.zip) = 8 THEN '0' + imp.zip
			   ELSE '' END , -- ZipCode - varchar(9)
          CASE imp.sex WHEN 'M' THEN 'M'
					   WHEN 'F' THEN 'F'
					   ELSE 'U' END , -- Gender - varchar(1)
          CASE imp.maritalstatus WHEN 'S' THEN 'S'
								 WHEN 'M' THEN 'M'
								 WHEN 'D' THEN 'D'
								 WHEN 'W' THEN 'W'
								 ELSE 'S' END , -- MaritalStatus - varchar(1)
          imp.homephone , -- HomePhone - varchar(10)
          imp.workphone , -- WorkPhone - varchar(10)
          CASE WHEN ISDATE(imp.dob) = 1 THEN imp.dob
			   ELSE NULL END , -- DOB - datetime
          imp.ssn , -- SSN - char(9)
          imp.emailnotifications , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.employername <> '' THEN 'E' ELSE 'U' END  , -- EmploymentStatus - char(1)
          2 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          emp.EmployerID , -- EmployerID - int
          imp.mobilephone , -- MobilePhone - varchar(10)
          doc.DoctorID, -- PrimaryCarePhysicianID - int
          imp.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          1 , -- SendEmailCorrespondence - bit
          imp.emergencycontactname , -- EmergencyName - varchar(128)
          imp.emergencycontactphone  -- EmergencyPhone - varchar(10)
FROM dbo.[_import_3_1_PatientDemo] AS imp
LEFT JOIN dbo.Doctor AS doc ON
doc.FirstName = imp.primarycarephysicianfirstname AND
doc.LastName = imp.primarycarephysicianlastname AND
doc.MiddleName = imp.primarycarephysicianmiddlename AND
doc.PracticeID = @PracticeID AND
doc.DoctorID NOT IN (194, 252, 451, 545, 267)
LEFT JOIN dbo.Employers AS emp ON
	emp.EmployerName = imp.employername
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pat WHERE imp.firstname = pat.FirstName AND imp.lastname = pat.LastName AND imp.ssn = pat.SSN)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PATIENT CASES
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patient Cases...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'MEDICAL' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import. Please verify before using.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PRIMARY INSURANCE POLICIES
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Primary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          imp.primarypolicy , -- PolicyNumber - varchar(32)
          imp.primarygroup , -- GroupNumber - varchar(32)
          CASE imp.relationshiptogurantor WHEN 'Spouse' THEN 'U'
										  WHEN 'Child' THEN 'C'
										  WHEN 'Other' THEN 'O'
										  ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          guar.firstname , -- HolderFirstName - varchar(64)
          guar.mi , -- HolderMiddleName - varchar(64)
          guar.lastname , -- HolderLastName - varchar(64)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          guar.address1 , -- HolderAddressLine1 - varchar(256)
          guar.address2 , -- HolderAddressLine2 - varchar(256)
          guar.city , -- HolderCity - varchar(128)
          guar.state , -- HolderState - varchar(2)
          CASE WHEN LEN(guar.zipcode) IN (5,9) THEN guar.zipcode
			   WHEN LEN(guar.zipcode) = 4 THEN '0' + guar.zipcode
			   WHEN LEN(guar.zipcode) = 8 THEN '0' + guar.zipcode
			   ELSE '' END , -- HolderZipCode - varchar(9)
          imp.primarypolicy , -- DependentPolicyNumber - varchar(32)
          imp.primarycopay , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemo] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.primaryinsurance AND
	icp.CreatedPracticeID = @PracticeID
LEFT JOIN dbo.[_import_3_1_Guarantor] AS guar ON
	guar.chartnumber = imp.guarantor
WHERE imp.primaryinsurance <> '' AND icp.InsuranceCompanyPlanID NOT IN (70,148,178,277)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE SECONDARY INSURANCE POLICIES
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Secondary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          imp.secondarypolicy , -- PolicyNumber - varchar(32)
          imp.secondarygroup , -- GroupNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemo] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.secondaryinsurance AND
	icp.CreatedPracticeID = @PracticeID
WHERE imp.secondaryinsurance <> '' AND icp.InsuranceCompanyPlanID NOT IN (70,148,178,277)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE TERTIARY INSURANCE POLICIES
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Tertiary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          imp.tertiarypolicy , -- PolicyNumber - varchar(32)
          imp.tertiarygroup , -- GroupNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemo] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.tertiaryinsurance AND
	icp.CreatedPracticeID = @PracticeID
WHERE imp.tertiaryinsurance <> '' AND icp.InsuranceCompanyPlanID NOT IN (70,148,178,277)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
/*
==========================================================================================================================================
CREATE INSURANCE POLICY AUTHORIZATIONS
==========================================================================================================================================
*/
PRINT ''
PRINT 'Inserting into InsurancePolicyAuthorization...'
INSERT INTO dbo.InsurancePolicyAuthorization
        ( InsurancePolicyID ,
          AuthorizationNumber ,
		  AuthorizedNumberOfVisits ,
          AuthorizationStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
	      ip.InsurancePolicyID , -- InsurancePolicyID - int
          imp.authorizationnumber , -- AuthorizationNumber - varchar(65)
		  0 ,-- AuthorizedNumberOfVisits
          1 , -- AuthorizationStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          imp.chartnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemo] imp
		INNER JOIN dbo.InsurancePolicy ip ON 
			ip.VendorID = imp.chartnumber AND
			ip.VendorImportID = @VendorImportID
WHERE imp.authorizationnumber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
			
		


/*
==========================================================================================================================================
CREATE APPOINTMENTS
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Appointments...'
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
          1 , -- ServiceLocationID - int
          app.startdate , -- StartDate - datetime
          app.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          app.appointmentnote , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          app.starttm , -- StartTm - smallint
          app.endtm  -- EndTm - smallint
FROM dbo.[_import_3_1_Appointment] AS app
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = app.chartnumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = pat.VendorID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = (SELECT Dt FROM dbo.DateKeyToPractice WHERE Dt = DATEADD(d , 0, DATEDIFF(d , 0 , app.startdate))) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE APPOINTMENT RESOURCES 1
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Appointment Resources 1...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  appt.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          doc.DoctorID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_3_1_Appointment] AS app
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = app.chartnumber AND
	pat.PracticeID = @PracticeID  
INNER JOIN dbo.Appointment AS appt ON
	appt.PatientID = pat.PatientID AND
	appt.StartDate = app.startdate
INNER JOIN dbo.Doctor AS doc ON
	doc.FirstName + ' ' + doc.LastName = app.defaultprovider AND
	doc.PracticeID = @PracticeID AND
	doc.[External] = 0
WHERE app.[resource] = 'DR SPRAY - EST PT' OR app.[resource] = 'DR SPRAY - NEW PT'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE APPOINTMENT RESOURCES 2
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Appointment Resources 2...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  appt.AppointmentID , -- AppointmentID - int
          2 , -- AppointmentResourceTypeID - int
          pr.PracticeResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_Appointment] AS app
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = app.chartnumber AND
	pat.PracticeID = @PracticeID  
INNER JOIN dbo.Appointment AS appt ON
	appt.PatientID = pat.PatientID AND
	appt.StartDate = app.startdate
INNER JOIN dbo.PracticeResource AS pr ON
	pr.ResourceName = app.[resource] AND
	pr.PracticeID = @PracticeID
WHERE app.[resource] = 'DR SPRAY - EST PT' OR app.[resource] = 'DR SPRAY - NEW PT'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE APPOINTMENT RESOURCES 3
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Appointment Resources 3...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  appt.AppointmentID , -- AppointmentID - int
          2 , -- AppointmentResourceTypeID - int
          pr.PracticeResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_Appointment] AS app
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = app.chartnumber AND
	pat.PracticeID = @PracticeID  
INNER JOIN dbo.Appointment AS appt ON
	appt.PatientID = pat.PatientID AND
	appt.StartDate = app.startdate
INNER JOIN dbo.PracticeResource AS pr ON
	pr.ResourceName = app.[resource] AND
	pr.PracticeID = @PracticeID
WHERE app.[resource] = 'JULIE' OR app.[resource] = 'NURSE'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



/*
==========================================================================================================================================
CREATE APPOINTMENT TO APPOINTMENT REASON
==========================================================================================================================================
*/



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
		  apt.AppointmentID , -- AppointmentID - int
          CASE imp.[resource] WHEN 'DR SPRAY - EST PT' THEN 102
							  WHEN 'DR SPRAY - NEW PT' THEN 109
							  END , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_3_1_Appointment] imp
INNER JOIN dbo.Patient pat ON
	pat.VendorID = imp.chartnumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment apt ON
	apt.PatientID = pat.PatientID AND
	apt.StartDate = imp.startdate
WHERE imp.[resource] = 'DR SPRAY - EST PT' OR imp.[resource] = 'DR SPRAY - NEW PT'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



/*
==========================================================================================================================================
UPDATE APPOINTMENTS TO CENTRAL STANDARD TIME
==========================================================================================================================================
*/
PRINT ''
PRINT 'Updating Appointments to Central Standard Time...'
UPDATE dbo.Appointment
	SET StartDate = DATEADD(hh,- 2,StartDate) ,
		EndDate = DATEADD(hh,- 2, EndDate) ,
		StartTm = - 200 , 
		EndTm = - 200
WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'



COMMIT