USE superbill_32246_dev 
--USE superbill_32246_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10)


PRINT ''
PRINT 'Inserting Into Referring Provider...'
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
          WorkPhoneExt ,
          MobilePhone ,
          EmailAddress ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          TaxonomyCode ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI ,
		  Notes
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          firstname ,
          middlename ,
          LastName ,
          '' ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          '' ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(zip)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zip)
		  ELSE '' END ,
          phone ,
          phoneext ,
          MobilePhone ,
          emailaddress ,
          1 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          LEFT(degree, 8) ,
          tx.TaxonomyCode ,
          [description] ,
          @VendorImportID ,
          fax ,
          1 ,
          nationalproviderid ,
		  i.note
FROM dbo.[_import_1_1_ReferringProviders] i
LEFT JOIN dbo.TaxonomyCode tx ON	
	tx.TaxonomyCode = i.taxonomycode 
WHERE i.[description] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactPrefix ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          Fax ,
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
          payername ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          '' ,
          CASE WHEN LEN(REPLACE(zip,' ','')) = 4 THEN '0' + zip ELSE REPLACE(zip,' ','') END ,
          '' ,
          contactfirstname ,
          ContactLastName ,
          '' ,
          contactphone ,
          contactext ,
          contactfax ,
          0 ,
          0 ,
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
          payerid ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18
FROM dbo.[_import_1_1_PracticePayer]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT	
		  InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
FROM dbo.InsuranceCompany 
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Service Location...'
INSERT INTO dbo.ServiceLocation
        ( PracticeID ,
          Name ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PlaceOfServiceCode ,
          BillingName ,
          Phone ,
          FaxPhone ,
          CLIANumber ,
          VendorImportID ,
          VendorID ,
          TimeZoneID ,
          EIN 
        )
SELECT DISTINCT
		  @PracticeID ,
          servicelocationinternalname ,
          servicelocationstreet1 ,
          servicelocationstreet2 ,
          servicelocationcity ,
          servicelocationstate ,
          '' ,
          servicelocationzip ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          11 ,
          servicelocationinternalname ,
          servicelocationphone ,
          servicelocationfax ,
          clianumber ,
          @VendorImportId ,
          AutoTempID ,
          9 ,
          locationtaxid 
FROM dbo.[_import_1_1_ServiceLocations] i
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  i.employmentstatusemployer , -- EmployerName - varchar(128)
          i.employeraddress1 , -- AddressLine1 - varchar(256)
          i.employeraddress2 , -- AddressLine2 - varchar(256)
          i.employercitu , -- City - varchar(128)
          i.employerstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.employerzip , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_1_PatientDemographics] i
WHERE i.employeraddress1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
		  ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          EmployerID ,
          MedicalRecordNumber ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          rf.doctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          i.middlename , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.street1 , -- AddressLine1 - varchar(256)
          i.street2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          LEFT(i.STATE,2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(REPLACE(zip,' ','')) = 4 THEN '0' + zip ELSE LEFT(REPLACE(zip,' ',''), 9) END , -- ZipCode - varchar(9)
          CASE i.gender WHEN 'F' THEN 'F' WHEN 'M' THEN 'M' ELSE 'U' END , -- Gender - varchar(1)
          CASE WHEN ms.MaritalStatus IS NULL THEN '' ELSE ms.MaritalStatus END , -- MaritalStatus - varchar(1)
          LEFT(i.homephone , 10) , -- HomePhone - varchar(10)
          LEFT(i.workphone , 10) , -- WorkPhone - varchar(10)
          LEFT(i.workextn , 10) , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(i.dateofbirth) = 1 THEN i.dateofbirth ELSE NULL END ,
		  CASE WHEN LEN(i.socialsecuritynumber) >= 6 THEN RIGHT('000' + i.socialsecuritynumber, 9) ELSE '' END , -- SSN - char(9)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.employmentstatusemployer = 'Retired' THEN 'R'
			   WHEN i.employmentstatusemployer = 'Student' THEN 'S'
			   WHEN i.employmentstatusemployer <> '' THEN 'E'
		  ELSE 'U' END , -- EmploymentStatus - char(1)
          CASE i.defaultrenderingprovider WHEN 'Ballard APRNNarendra' THEN 2
										  WHEN 'Blake MDJacob' THEN 3
										  WHEN 'Canner PetersonChristine' THEN 4
										  WHEN 'Davis MDJohn' THEN 5
										  WHEN 'Demers MDChristopher' THEN 6
										  WHEN 'Edwards MDMichael' THEN 7
										  WHEN 'Erickson' THEN 8
										  WHEN 'Fleming MD PhDHilari' THEN 9
										  WHEN 'Graves' THEN 10 
										  WHEN 'Keller APRNJennifer' THEN 11
										  WHEN 'Khosla MDDeven' THEN 12
										  WHEN 'Lasko MDKevin' THEN 13
										  WHEN 'Leppla MDDavid' THEN 1
										  WHEN 'Minard APRNJennifer' THEN 14
										  WHEN 'Morgan MDJay' THEN 15
										  WHEN 'Sands PA CAmber' THEN 16
										  WHEN 'Sapir APRNLeora' THEN 17
										  WHEN 'Sekhon MDLali' THEN 18
										  WHEN 'Teixeira-Smith' THEN 19
										  WHEN 'Vacca MDDante' THEN 20
										  WHEN 'Walker MDJoseph' THEN 21
										  WHEN 'WatersJenli' THEN 22
										  ELSE NULL END , -- PrimaryProviderID - int
          e.EmployerID , -- EmployerID - int
          i.mrnchartnumber , -- MedicalRecordNumber - varchar(128)
          pcp.DoctorID , -- PrimaryCarePhysicianID - int
          i.personguinbr , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE i.expired WHEN 'Y' THEN 0 ELSE 1 END  , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
          i.emergencyname , -- EmergencyName - varchar(128)
          i.emergencyphone  -- EmergencyPhone - varchar(10)
FROM dbo.[_import_1_1_PatientDemographics] i
LEFT JOIN dbo.Doctor rf ON
	rf.VendorID = i.defaultreferingprovider AND
	rf.VendorImportID = @VendorImportID
LEFT JOIN dbo.Doctor pcp ON
	pcp.VendorID = i.primarycarephysician AND
	pcp.VendorImportID = @VendorImportID
LEFT JOIN dbo.MaritalStatus ms ON	
	ms.MaritalStatus = i.maritalstatus
LEFT JOIN dbo.Employers e ON
	e.EmployerName = i.employmentstatusemployer
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into PatientCase'
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
SELECT  DISTINCT
          pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import, please review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient as pat
WHERE VendorImportID=@VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DELETE FROM dbo.[_import_1_1_PatientPayer] WHERE personguid = '{01827A68-ECC0-47D5-AA8F-EF0BEF9BE8A6}'

PRINT ''
PRINT 'Inserting Into Insurance Policy - Primary...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          PatientRelationshipToInsured ,
          HolderThroughEmployer ,
          HolderEmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Copay ,
          Deductible ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName 
        )
SELECT DISTINCT
          pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.precedence , -- Precedence - int
          i.policynumber1 , -- PolicyNumber - varchar(32)
          LEFT(i.groupnumber1 ,32) , -- GroupNumber - varchar(32)
          CASE WHEN i.policy1startdate <> '' THEN CONVERT(DATETIME,i.policy1startdate, 101) ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN i.policy1enddate <> '' THEN CONVERT(DATETIME,i.policy1enddate, 101) ELSE NULL END , -- PolicyEndDate - datetime
          'S'  , -- PatientRelationshipToInsured - varchar(1)
		  CASE WHEN i.insuredempname <> '' THEN 1 ELSE 0 END,
		  CASE WHEN i.insuredempname <> '' THEN i.insuredempname END ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.policy1copay , -- Copay - money
          i.policy1deductible , -- Deductible - money
          CASE i.payerinsuranceactivestatus WHEN 'N' THEN 0 ELSE 1 END ,  -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.groupname1, 14) -- GroupName - varchar(14)
FROM dbo.[_import_1_1_PatientPayer] i
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = i.personguid AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	--icp.InsuranceCompanyPlanID = (SELECT TOP 1 InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan icp2 
	--							  WHERE icp2.AddressLine1 = i.payeraddress1 AND
	--									icp2.AddressLine2 = i.payeraddress2 AND
	--									icp2.City = i.payercity AND
	--									icp2.ZipCode = i.payerzip)
	i.insuranceid = icp.VendorID
	AND icp.VendorImportID = @VendorImportID
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
          i.event , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          '' , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_1_1_Appointment] i
WHERE i.event <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.Name = i.event)
PRINT CAST(@@ROWCOUNT AS VARCHAR)


PRINT ''
PRINT 'Inserting Into Apppointment...'
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
          CASE WHEN sl.ServiceLocationID IS NULL THEN 19 ELSE sl.ServiceLocationID END  , -- ServiceLocationID - int *************
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.apptnbr , -- Subject - varchar(64)
          CASE WHEN i.userdefined1 = '' THEN '' ELSE 'User Defined 1: ' + i.userdefined1 + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.userdefined2 = '' THEN '' ELSE 'User Defined 2: ' + i.userdefined2 + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.details = '' THEN '' ELSE 'Details: ' + i.details + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.notes = '' THEN '' ELSE 'Notes: ' + i.notes END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_1_1_Appointment] i
INNER JOIN dbo.Patient p ON 
i.personid = p.VendorID AND
p.VendorImportID = @VendorImportID
LEFT JOIN dbo.PatientCase pc ON
p.PatientID = pc.PatientID AND 
pc.VendorImportID = @VendorImportID
LEFT JOIN dbo.ServiceLocation sl ON 
sl.Name = i.locationname AND 
sl.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(i.startdate AS date) AS DATETIME) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into AppointmenttoAppointment Reason...'
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
a.Subject = i.apptnbr AND
a.StartDate = CAST(i.startdate AS DATETIME) 
INNER JOIN dbo.AppointmentReason ar ON 
i.event = ar.Name
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into AppointmentoResource 1'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          TIMESTAMP ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.providerlastname WHEN 'Leppla MD' THEN 1
								  WHEN 'Ballard APRN' THEN 2
								  WHEN 'Blake MD' THEN 3
								  WHEN 'Canner Peterson' THEN 4
								  WHEN 'Davis MD' THEN 5
								  WHEN 'Demers MD' THEN 6
								  WHEN 'Edwards MD' THEN 7
								  WHEN 'Erickson, PA-C' THEN 8
								  WHEN 'Fleming MD PhD' THEN 9
								  WHEN 'Graves, PA-C' THEN 10 
								  WHEN 'Keller APRN' THEN 11
								  WHEN 'Khosla MD' THEN 12
								  WHEN 'Lasko MD' THEN 13 
								  WHEN 'Minard APRN' THEN 14
								  WHEN 'Morgan MD' THEN 15
								  WHEN 'Sands PA C' THEN 16
								  WHEN 'Sapir APRN' THEN 17
								  WHEN 'Sekhon MD' THEN 18
								  WHEN 'Teixeira-Smith, MSN' THEN 19
								  WHEN 'Vacca MD' THEN 20
								  WHEN 'Walker MD' THEN 21
								  WHEN 'Waters' THEN 22
								  END , -- ResourceID - int **********************
          GETDATE() , -- ModifiedDate - datetime
          NULL , -- TIMESTAMP - timestamp
          0  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] i 
INNER JOIN dbo.Appointment a ON
a.Subject = i.apptnbr AND
a.StartDate = CAST(i.startdate AS DATETIME) 
WHERE i.providerlastname NOT IN ('Halvorsen CRNFA' , 'Mandell PAC')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Practice Resource...'
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
VALUES  (
		  3 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          'Candace Halvorsen CRNFA' , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Practice Resource...'
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
VALUES  (
		  3 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          'Lisa Mandell PAC' , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into AppointmentoResource 2'
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
          CASE i.providerlastname WHEN 'Halvorsen CRNFA' THEN (SELECT PracticeResourceID from dbo.PracticeResource WHERE ResourceName = 'Candace Halvorsen CRNFA')
								   WHEN 'Mandell PAC' THEN (SELECT PracticeResourceID from dbo.PracticeResource WHERE ResourceName = 'Lisa Mandell PAC') 
								   END , -- ResourceID - int **********************
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] i 
INNER JOIN dbo.Appointment a ON
a.Subject = i.apptnbr AND
a.StartDate = CAST(i.startdate AS DATETIME) 
WHERE i.providerlastname IN ('Halvorsen CRNFA' , 'Mandell PAC')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




PRINT ''
PRINT 'Inserting into Standard Fee Schedule...'
      INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
                  ( PracticeID ,
                    Name ,
                    Notes ,
                    EffectiveStartDate ,
                    SourceType ,
                    SourceFileName ,
                    EClaimsNoResponseTrigger ,
                    PaperClaimsNoResponseTrigger ,
                    MedicareFeeScheduleGPCICarrier ,
                    MedicareFeeScheduleGPCILocality ,
                    MedicareFeeScheduleGPCIBatchID ,
                    MedicareFeeScheduleRVUBatchID ,
                    AddPercent ,
                    AnesthesiaTimeIncrement
                  )
      VALUES  
                  ( 
                    @PracticeID , -- PracticeID - int
                    'Default Contract' , -- Name - varchar(128)
                    'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
                    GETDATE() , -- EffectiveStartDate - datetime
                    'F' , -- SourceType - char(1)
                    'Import File' , -- SourceFileName - varchar(256)
                    30 , -- EClaimsNoResponseTrigger - int
                    30 , -- PaperClaimsNoResponseTrigger - int
                    NULL , -- MedicareFeeScheduleGPCICarrier - int
                    NULL , -- MedicareFeeScheduleGPCILocality - int
                    NULL , -- MedicareFeeScheduleGPCIBatchID - int
                    NULL , -- MedicareFeeScheduleRVUBatchID - int
                    0 , -- AddPercent - decimal
                    15  -- AnesthesiaTimeIncrement - int
                  )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into Standard Fee...'
      --StandardFee
      INSERT INTO dbo.ContractsAndFees_StandardFee
                  ( StandardFeeScheduleID ,
                    ProcedureCodeID ,
                    ModifierID ,
                    SetFee ,
                    AnesthesiaBaseUnits
                  )
      SELECT DISTINCT
                    sfs.[StandardFeeScheduleID], -- StandardFeeScheduleID - int
                    pcd.[ProcedureCodeDictionaryID] , -- ProcedureCodeID - int
                    pm.[ProcedureModifierID] , -- ModifierID - int
                    i.currentprice , -- SetFee - money
                    0  -- AnesthesiaBaseUnits - int
      FROM dbo.[_import_1_1_PracticeFeeSchedule] AS i
      INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule AS sfs ON
            CAST(sfs.[Notes] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID  
      INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
            pcd.[ProcedureCode] = i.cpt4codeid
      LEFT JOIN dbo.ProcedureModifier AS pm ON
            pm.[ProcedureModifierCode] = i.modifier1
      WHERE CAST(i.currentprice AS MONEY) > 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Standard Fee Schedule Link...'
      --Standard Fee Schedule Link
      INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
                  ( ProviderID ,
                    LocationID ,
                    StandardFeeScheduleID
                  )
      SELECT DISTINCT
                    doc.[DoctorID] , -- ProviderID - int
                    sl.[ServiceLocationID] , -- LocationID - int
                    sfs.[StandardFeeScheduleID]  -- StandardFeeScheduleID - int
      FROM dbo.Doctor AS doc, dbo.ServiceLocation AS sl, dbo.ContractsAndFees_StandardFeeSchedule AS sfs
      WHERE doc.[External] = 0 AND
            doc.[PracticeID] = @PracticeID AND
            sl.PracticeID = @PracticeID AND
            sfs.[Notes] = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--ROLLBACK
--COMMIT

