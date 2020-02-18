USE superbill_35211_dev
--USE superbill_35211_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 3

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10)) 

PRINT ''
PRINT 'Inserting Into Insurance Company...'
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
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT	  
		  companyname ,
          0 ,
          0 ,
          13 ,
          'CI' ,
          'C' ,
          'D' ,
          @PracticeID ,
          GETDATE() ,
          0 ,
          13 ,
          companyid ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18
FROM dbo.[_import_1_1_CompaniesPlans]
WHERE companyname <> ''
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
          VendorImportID 
        )
SELECT DISTINCT
		  i.planname ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          @PracticeID ,
          ic.InsuranceCompanyID ,
          i.planid ,
          @VendorImportID 
FROM dbo.[_import_1_1_CompaniesPlans] i
INNER JOIN dbo.InsuranceCompany ic ON
ic.VendorID = i.companyid AND
ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Doctor...'
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
          HomePhone ,
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
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          referringfirst ,
          referringmiddle ,
          referringlast ,
          '' ,
          Address1 ,
          Address2 ,
          City ,
          State ,
          '' ,
          REPLACE(Zip,'-','') ,
          dbo.fn_RemoveNonNumericCharacters(HomePhone) ,
          dbo.fn_RemoveNonNumericCharacters(WorkPhone) ,
          'Specialty: ' + specialty ,
          1 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          Degree ,
          AutoTempID ,
          @VendorImportID ,
          1 ,
          NPI 
FROM dbo.[_import_1_1_ReferringProvider]
WHERE referringfirst <> '' AND referringlast <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          DOB ,
          SSN ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          [first] ,
          '' ,
          [Last] ,
          '' ,
          primaryaddress1 ,
          primaryaddress2 ,
          i.City ,
          i.State ,
          '' ,
          REPLACE(Zip,'-','') ,
          CASE gender WHEN 'Male' THEN 'M' WHEN 'Female' THEN 'F' ELSE 'U' END ,
          '' ,
          areacode + REPLACE(phone1,'-','') ,
          i.dob ,
          CASE WHEN LEN(REPLACE(i.ssn,'-','')) >= 6 THEN RIGHT('000' + REPLACE(i.ssn,'-',''), 9) ELSE '' END ,
		  0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          'U' ,
          1 ,
          id ,
          d.DoctorID ,
          id ,
          @VendorImportID ,
          1 
FROM dbo.[_import_1_1_PatDemo] i
LEFT JOIN dbo.Doctor d ON
i.pcpfirst = d.FirstName AND 
i.pcplast = d.LastName AND
d.[External] = 0 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case...'
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
          pat.PatientID , -- PatientID - int
         'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient as pat
WHERE VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
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
          ip.InsuranceCompanyPlanID ,
          i.precedence ,
          i.memberid ,
          CASE WHEN ISDATE(i.insurancestartdate) = 1 THEN i.insurancestartdate ELSE NULL END ,
          CASE WHEN ISDATE(i.insuranceenddate) = 1 THEN i.insuranceenddate ELSE NULL END ,
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
FROM dbo.[_import_1_1_Policies] i
INNER JOIN dbo.PatientCase pc ON
i.patientid = pc.VendorID AND 
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan ip ON
i.planid = ip.VendorID AND
ip.VendorImportID = @VendorImportID
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
		  p.PatientID ,
          @PracticeID ,
          1 ,
          i.StartDate ,
          i.EndDate ,
          'P' ,
          p.FirstName + ' ' + p.LastName + ' - ' + i.kareoaptreason ,
          i.apptnotes ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          CASE i.apptstatus WHEN 'Cancelled' THEN 'X'
							WHEN 'Check In' THEN 'I'
							WHEN 'Check Out' THEN 'O'
							WHEN 'No Show' THEN 'N'
							WHEN 'Rescheduled' THEN 'R' 
							WHEN 'Scheduled' THEN 'S'
							WHEN 'Seen' THEN 'E' ELSE 'S' END,
          pc.PatientCaseID ,
          dk.DKPracticeID ,
          dk.DKPracticeID ,
          i.StartTm ,
          i.EndTm 
FROM dbo.[_import_1_1_Appointment] i
INNER JOIN dbo.Patient p ON	
p.FirstName = i.patientfirst AND
p.LastName = i.patientlast AND
p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) AND
p.VendorImportID = @VendorImportID
LEFT JOIN dbo.PatientCase pc ON
p.PatientID = pc.PatientID AND 
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
 dk.PracticeID = @PracticeID AND 
 dk.Dt = CAST(CAST(i.startdate AS date) AS DATETIME) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment Reason'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
        )
VALUES  ( @PracticeID , -- PracticeID - int
          'Surgery' , -- Name - varchar(128)
          120 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          'Surgery' , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Appointment Reason...'
UPDATE dbo.AppointmentReason 
SET Name = 'Fracture Followup'
WHERE Name = 'Fracture follwup'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

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
FROM dbo.[_import_1_1_Appointment] i 
INNER JOIN dbo.Appointment a ON
i.patientfirst + ' ' + i.patientlast + ' - ' + i.kareoaptreason = a.[Subject] AND
CAST(i.startdate AS DATETIME) = a.StartDate AND
a.PracticeID = @PracticeID
INNER JOIN dbo.AppointmentReason ar ON
i.kareoaptreason = ar.Name AND 
ar.PracticeID = @PracticeID
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
          a.AppointmentResourceTypeID , -- AppointmentResourceTypeID - int
          2 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] i 
INNER JOIN dbo.Appointment a ON
i.patientfirst + ' ' + i.patientlast + ' - ' + i.kareoaptreason = a.[Subject] AND
CAST(i.startdate AS DATETIME) = a.StartDate AND
a.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT


