--USE superbill_14371_dev
USE superbill_14371_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.AppointmentToResource WHERE PracticeID = @PracticeID AND AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment
						WHERE PracticeID = @PracticeID AND PatientID IN (SELECT PatientId FROM dbo.Patient WHERE PracticeID = @PracticeID AND
							VendorImportID = @VendorImportID))
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE PracticeID = @PracticeID AND AppointmentID	IN (SELECT AppointmentID FROM dbo.Appointment
						WHERE PracticeID = @PracticeID AND PatientID IN (SELECT PatientId FROM dbo.Patient WHERE PracticeID = @PracticeID AND
							VendorImportID = @VendorImportID))
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'						
DELETE FROM dbo.Appointment WHERE PracticeID = @PracticeID  AND PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = 
										@PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'									
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'



PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany(
    InsuranceCompanyName,
    AddressLine1,
    AddressLine2,
    City,
    State,
    ZipCode,
	CreatedPracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	BillSecondaryInsurance ,
	EClaimsAccepts ,
	BillingFormID ,
	InsuranceProgramCode ,
	HCFADiagnosisReferenceFormatCode ,
	HCFASameAsInsuredFormatCode ,
	DefaultAdjustmentCode ,
	ReferringProviderNumberTypeID ,
	NDCFormat ,
	UseFacilityID ,
	AnesthesiaType ,
	InstitutionalBillingFormID,
	SecondaryPrecedenceBillingFormID 
)
SELECT DISTINCT
	ic.[insurancecompany]
	,ic.[addr1b]
	,ic.[addr2b]
	,ic.[cityb]
	,LEFT(ic.[stateb], 2)
	,LEFT(REPLACE(ic.[zipb], '-',''), 9)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,LEFT(ic.[insurancecompany], 50)  -- Hope it's unique!
	,@VendorImportID
	,0  -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13  -- BillingFormID - int
	,'CI'  -- InsuranceProgramCode - char(2)
	,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D'  -- HCFASameAsInsuredFormatCode - char(1)
	,NULL -- DefaultAdjustmentCode - varchar(10)
	,NULL  -- ReferringProviderNumberTypeID - int
	,1  -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U'  -- AnesthesiaType - varchar(1)
	,18  -- InstitutionalBillingFormID - int,
	,13
FROM [dbo].[_import_3_1_PolicyHOlder] ic
WHERE ic.[insurancecompany] <> '' AND
	ic.addr1b <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


INSERT INTO dbo.InsuranceCompany(
    InsuranceCompanyName,
	CreatedPracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	BillSecondaryInsurance ,
	EClaimsAccepts ,
	BillingFormID ,
	InsuranceProgramCode ,
	HCFADiagnosisReferenceFormatCode ,
	HCFASameAsInsuredFormatCode ,
	DefaultAdjustmentCode ,
	ReferringProviderNumberTypeID ,
	NDCFormat ,
	UseFacilityID ,
	AnesthesiaType ,
	InstitutionalBillingFormID,
	SecondaryPrecedenceBillingFormID 
)
VALUES ('Sagicor'
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Sagicor'  -- Hope it's unique!
	,@VendorImportID
	,0  -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13  -- BillingFormID - int
	,'CI'  -- InsuranceProgramCode - char(2)
	,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D'  -- HCFASameAsInsuredFormatCode - char(1)
	,NULL -- DefaultAdjustmentCode - varchar(10)
	,NULL  -- ReferringProviderNumberTypeID - int
	,1  -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U'  -- AnesthesiaType - varchar(1)
	,18  -- InstitutionalBillingFormID - int,
	,13)


--InsuranceCompanyPlan
PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
		  AddressLine1 ,
		  AddressLine2 ,
		  city ,
		  State ,
		  ZipCode ,
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
		  icp.InsuranceCompanyName , -- PlanName - varchar(128)
		  icp.addressline1 ,
		  icp.addressline2 ,
		  icp.city ,
		  icp.[State] ,
		  icp.zipcode ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          icp.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.InsuranceCompanyName , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany icp 
WHERE icp.CreatedPracticeID = @PracticeID AND 
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--Patient
PRINT ''
PRINT 'Inserting into Patient ...'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT DISTINCT 
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.[patfirstname] , -- FirstName - varchar(64)
          pat.[patmiddlename] , -- MiddleName - varchar(64)
          pat.[patlastname] , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.[addr1] , -- AddressLine1 - varchar(256)
          pat.[addr2] , -- AddressLine2 - varchar(256)
          pat.[city] , -- City - varchar(128)
          pat.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(pat.[zip], '-', ''), 9) , -- ZipCode - varchar(9)
          pat.[gen] ,
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[hmphone], '(', ''), ')', ''), '-', ''), ' ', ''), 9) , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[dayphone], '(', ''), ')', ''), '-', ''), ' ', ''), 9) , -- WorkPhone - varchar(10)
          CASE WHEN ISDATE(pat.[birthdt]) = 1 THEN pat.[birthdt] ELSE NULL END , -- DOB - datetime
          LEFT(REPLACE(pat.[ssn], '-', ''), 9) , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.patname , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_3_1_PatientDemo] pat
LEFT JOIN dbo.Doctor doc ON
	doc.FirstName + doc.LastName = pat.referring AND
	doc.PracticeID = @PracticeID AND
	doc.VendorImportID = @VendorImportID
WHERE pat.patfirstname <> '' AND pat.patlastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--PatientCase
PRINT ''
PRINT 'Inserting into PatientCase ...'
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
SELECT    pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import, please review.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pat
WHERE pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--InsurancePolicy #1
PRINT ''
PRINT 'Inserting into InsurancePolicy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName 
        )
SELECT    
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          pol.defcob , -- Precedence - int
          pol.polnbr , -- PolicyNumber - varchar(32)
          pol.[group] , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          DATEADD(yy, 1, GETDATE()), -- PolicyEndDate - datetime
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pol.note , -- Notes - text
          pol.coamt , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.pernbr , -- VendorID - varchar(50)
          @VendorImportId, -- VendorImportID - int
          LEFT(pol.groupname, 14)  -- GroupName - varchar(14)
FROM dbo.[_import_3_1_PolicyHolder] pol 
INNER JOIN dbo.PatientCase pc ON
	pol.name = pc.VendorID AND
	pc.VendorImportID = @VendorImportId
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	pol.insurancecompany = icp.VendorID AND
	pol.addr1b = icp.AddressLine1 AND
	pol.addr2b = icp.AddressLine2 AND
	icp.VendorImportID = @VendorImportID
WHERE pol.insurancecompany <> '' AND 
	pol.defcob IN (1,2,3) AND
	pol.defcob <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT 'Inserting into Appointment'
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
          InsurancePolicyAuthorizationID ,
          PatientCaseID ,
          Recurrence ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT	  
		  pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          CAST(app.apptdt AS datetime)+ begtm  , -- StartDate - datetime
          CAST(app.apptdt AS datetime)+ DATEADD(mm, -5, endtm) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          app.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          NULL , -- InsurancePolicyAuthorizationID - int
          pc.PatientCaseID , -- PatientCaseID - int
          NULL , -- Recurrence - bit
          dk.dkPracticeID , -- StartDKPracticeID - int
          dk.dkPracticeID , -- EndDKPracticeID - int
          REPLACE(begtm, ':', '') , -- StartTm - smallint
          replace(endtm, ':', '')  -- EndTm - smallint
FROM dbo.[_import_3_1_AppointmentSchedule] app 
INNER JOIN dbo.Patient pat ON 
	app.patname = pat.VendorID AND
	pat.VendorImportID = @VendorImportID
LEFT JOIN dbo.DateKeyToPractice dk ON 
	app.apptdt = dk.Dt AND
	dk.PracticeID = @PracticeID
LEFT JOIN dbo.PatientCase pc ON 
	pat.PatientID = pc.PatientID AND
	pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into AppointmentToResource ...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          TIMESTAMP ,
          PracticeID
        )
SELECT DISTINCT
		  appt.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_3_1_AppointmentSchedule] impappt
INNER JOIN dbo.Patient pat ON 
	impappt.patname = pat.VendorID AND
	pat.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment appt ON
	pat.PatientID = appt.PatientID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting into AppointmentToAppointmentReason'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          ModifiedDate ,
          PracticeID
        )
SELECT    appt.AppointmentID , -- AppointmentID - int
          CASE WHEN impApp.dur = 60 THEN (SELECT appointmentReasonID FROM dbo.AppointmentReason WHERE NAME = 'New Patient')
			   ELSE (SELECT appointmentReasonID FROM dbo.AppointmentReason WHERE NAME = 'Established Pt Follow Up')
			    END , -- AppointmentReasonID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeId  -- PracticeID - int
FROM dbo.[_import_3_1_AppointmentSchedule] impApp
INNER JOIN dbo.Patient pat ON
	impApp.patname = pat.VendorID AND
	pat.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment appt ON
	pat.PatientID = appt.PatientID AND 
	appt.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




COMMIT

