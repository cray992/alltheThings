USE superbill_36359_dev
--USE superbill_36359_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool

/*
DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT )
INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID)
(
       SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule 
       WHERE Notes = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) 
)
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.AppointmentReason WHERE ModifiedDate > '2015-01-23 16:55:57.700'
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Reason Records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
*/

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Fax ,
          FaxExt ,
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
		  i.clmname , -- InsuranceCompanyName - varchar(128)
          CASE WHEN i.clmeligph = '' THEN '' ELSE 'Eligibility Phone: ' + i.clmeligph +
				CASE WHEN i.clmeligx = '' THEN CHAR(13) + CHAR(10) ELSE ' Ext: ' + i.clmeligx + CHAR(13) + CHAR(10) END END +
		  CASE WHEN i.clmauth = '' THEN '' ELSE 'Authorization Phone: ' + i.clmauth +
				CASE WHEN i.clmauthx = '' THEN CHAR(13) + CHAR(10) ELSE ' Ext: ' + i.clmauthx + CHAR(13) + CHAR(10) END END , -- Notes - text
          i.clmaddr , -- AddressLine1 - varchar(256)
          i.clmattn , -- AddressLine2 - varchar(256)
          i.clmcity , -- City - varchar(128)
          LEFT(i.clmstate, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (4,8) THEN '0' + (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.',''))
		  ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.',''),9) END , -- ZipCode - varchar(9)
          i.clmfax , -- Fax - varchar(10)
          i.clmfaxx , -- FaxExt - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
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
          i.clmcono , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsPlanClmfiledat] i
WHERE i.clmname <> ''
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
          Notes ,
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
SELECT    InsuranceCompanyName ,
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
          Notes ,
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
FROM dbo.InsuranceCompany WHERE VendorImportID = VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Referring Doctor...'
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
          PagerPhone ,
          PagerPhoneExt ,
          MobilePhone ,
          MobilePhoneExt ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          FaxNumberExt ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          reffname , -- FirstName - varchar(64)
          refmi , -- MiddleName - varchar(64)
          reflname , -- LastName - varchar(64)
          refsuffix , -- Suffix - varchar(16)
          refaddr , -- AddressLine1 - varchar(256)
          refaddr2 , -- AddressLine2 - varchar(256)
          refcity , -- City - varchar(128)
          LEFT(refstate ,2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(refzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (4,8) THEN '0' + (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(refzip,'-',''),' ',''),'=',''),'r',''),'.',''))
		  ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(refzip,'-',''),' ',''),'=',''),'r',''),'.',''),9) END , -- ZipCode - varchar(9)
          refphone , -- WorkPhone - varchar(10)
          refphonext , -- WorkPhoneExt - varchar(10)
          refpage , -- PagerPhone - varchar(10)
          refpagext , -- PagerPhoneExt - varchar(10)
          refmobile , -- MobilePhone - varchar(10)
          refmobilext , -- MobilePhoneExt - varchar(10)
          CASE WHEN refid1 = '' THEN '' ELSE 'ID1: ' + refid1 + CHAR(13) + CHAR(10) END +
		  CASE WHEN refid2 = '' THEN '' ELSE 'ID2: ' + refid2 + CHAR(13) + CHAR(10) END +
		  CASE WHEN refid3 = '' THEN '' ELSE 'ID3: ' + refid3 + CHAR(13) + CHAR(10) END + 
		  CASE WHEN refid4 = '' THEN '' ELSE 'ID4: ' + refid4 + CHAR(13) + CHAR(10) END + 
		  CASE WHEN refid5 = '' THEN '' ELSE 'UPIN: '+ refid5 + CHAR(13) + CHAR(10) END , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          refdrno , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          reffax , -- FaxNumber - varchar(10)
          reffaxext , -- FaxNumberExt - varchar(10)
          1 , -- External - bit
          refnatlprovid -- NPI - varchar(10)
FROM dbo.[_import_1_1_ReferringProvReffiledat]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  patemplname , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_1_PatientFilePatfiledat] WHERE patemplname NOT IN ('','*****','.','no')
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
          EmployerID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
	      @PracticeID , -- PracticeID - int
          rd.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.patfname , -- FirstName - varchar(64)
          i.patmi , -- MiddleName - varchar(64)
          i.patlname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.pataddr1 , -- AddressLine1 - varchar(256)
          i.pataddr2 , -- AddressLine2 - varchar(256)
          i.patcity, -- City - varchar(128)
          LEFT(i.patstate ,2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.patzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (4,8) 
			THEN '0' + (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.patzip,'-',''),' ',''),'=',''),'r',''),'.',''))
		  ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.patzip,'-',''),' ',''),'=',''),'r',''),'.',''),9) END , -- ZipCode - varchar(9)
          i.patsex , -- Gender - varchar(1)
          CASE i.patmarital WHEN 'D' THEN 'D'
							WHEN 'S' THEN 'S'
							WHEN 'W' THEN 'W' 
							WHEN 'M' THEN 'M' ELSE '' END , -- MaritalStatus - varchar(1)
          i.patphone , -- HomePhone - varchar(10)
          i.patworkphone , -- WorkPhone - varchar(10)
		  i.patwkext , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(i.patdob) = 1 THEN i.patdob END , -- DOB - datetime
          CASE WHEN LEN(i.patssn) >= 6 THEN RIGHT('000' + i.patssn, 9) ELSE '' END , -- SSN - char(9)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE patempl WHEN 'E' THEN 'E'
					   WHEN 'R' THEN 'R'
					   WHEN 'RE' THEN 'R'
					   WHEN 'RET' THEN 'R'
					   WHEN 'S' THEN 'S'
					   WHEN 'Y' THEN 'E'
					   WHEN 'YES' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
          e.EmployerID , -- EmployerID - int
          i.pataccount , -- MedicalRecordNumber - varchar(128)
          i.pataccount , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          CASE i.patstatus WHEN 0 THEN 0 ELSE 1 END , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_1_1_PatientFilePatfiledat] i
LEFT JOIN dbo.Doctor rd ON
	rd.VendorID = i.patrefdr AND
	rd.VendorImportID = @VendorImportID
LEFT JOIN dbo.Employers e ON 
	i.patemplname = e.EmployerName 
WHERE i.patfname <> '' AND i.patlname <> ''
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
SELECT DISTINCT
          PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted'


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
          i.aptreason , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          i.aptreason , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_1_1_Aptfiledat] i
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.Name = i.aptreason) AND i.aptreason <> ''
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
          p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.aptuniq , -- Subject - varchar(64)
          '' , -- Notes - text
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
FROM dbo.[_import_1_1_Aptfiledat] i
INNER JOIN dbo.patient AS p ON
  p.VendorID = i.aptaccount and
  p.VendorImportID = @VendorImportID
LEFT JOIN dbo.patientcase AS pc ON
  pc.patientID = p.patientID AND
  pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(i.startdate AS date) AS DATETIME) 
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
FROM dbo.[_import_1_1_Aptfiledat] i
INNER JOIN dbo.AppointmentReason ar ON
	ar.Name = i.aptreason AND
	ar.PracticeID = @PracticeID
INNER JOIN dbo.Appointment a ON
	a.[Subject] = i.aptuniq AND
	a.StartDate = CAST(i.startdate AS DATETIME) AND
	a.EndDate = CAST(i.enddate AS DATETIME) AND
	a.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into AppointmenttoResource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
		  1, -- AppointmentResourceTypeID - int
          CASE WHEN i.aptdr IN (4,6) THEN 1
		       WHEN i.aptdr IN (2,5) THEN 2
		  ELSE 1 END  , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Aptfiledat] i
INNER JOIN dbo.Appointment a ON
	a.[Subject] = i.aptuniq AND
	a.StartDate = CAST(i.startdate AS DATETIME) AND
	a.EndDate = CAST(i.enddate AS DATETIME) AND
	a.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
		  PolicyStartDate ,
		  PolicyEndDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
		  HolderGender , 
          HolderThroughEmployer ,
          HolderEmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.precedence , -- Precedence - int
          i.insid , -- PolicyNumber - varchar(32)
          i.insgroup , -- GroupNumber - varchar(32)
		  CASE WHEN ISDATE(i.insstartdt) = 1 THEN i.insstartdt ELSE NULL END , -- PolicyStartDate - datetime
		  CASE WHEN ISDATE(i.insenddt) = 1 THEN i.insenddt ELSE NULL END  , -- PolicyEndDate - datetime
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN ip.iprfname END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN ip.iprmi END , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN ip.iprlname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN 
			CASE WHEN ISDATE(ip.iprdob) = 1 THEN ip.iprdob ELSE NULL END END , -- HolderDOB - datetime
		  CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN 
			CASE ip.iprsex WHEN 'M' THEN 'M' WHEN 'F' THEN 'F' ELSE 'U' END END , --HolderGender - char(1)
          CASE WHEN i.insempl = 'Y' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
          CASE WHEN i.insempl = 'Y' THEN e.EmployerName END , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN ip.ipraddr END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN ip.iprcity END , -- HolderCity - varchar(128)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN LEFT(ip.iprstate, 2) END , -- HolderState - varchar(2)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN 
			CASE WHEN LEN(REPLACE(REPLACE(ip.iprzip,' ',''),'-','')) IN (4,8) THEN '0' + REPLACE(REPLACE(ip.iprzip,' ',''),'-','')
			ELSE LEFT(REPLACE(REPLACE(ip.iprzip,' ',''),'-',''), 9) END END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN ip.iprphone END , -- HolderPhone - varchar(10)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN i.insid END , -- DependentPolicyNumber - varchar(32)
          CASE WHEN i.insstatus = '' THEN '' ELSE 'Insurance Status: ' + i.insstatus END , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID+i.precedence , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_InsPolicyInsfiledat] i
INNER JOIN dbo.PatientCase pc ON	
	pc.VendorID = i.insaccount AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = i.insconum AND
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.Patient p ON	
	pc.PatientID = p.PatientID AND
	p.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_InsuredPartyIprfiledat] ip ON
	i.insipr = ip.iprno 
LEFT JOIN dbo.Employers e ON
	p.EmployerID = e.EmployerID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into PatientCase- Balance Forward'
INSERT INTO dbo.PatientCase
	( PatientID , Name , Active , PayerScenarioID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag ,
      AbuseRelatedFlag , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID ,
      PracticeID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , EPSDT , FamilyPlanning , EPSDTCodeID ,
      EmergencyRelated , HomeboundRelatedFlag )
SELECT DISTINCT
	pat.PatientID , -- PatientID - int
    'Balance Forward' , -- Name - varchar(128)
    1 , -- Active - bit
    11 , -- PayerScenarioID - int
    0 , -- EmploymentRelatedFlag - bit
    0 , -- AutoAccidentRelatedFlag - bit
    0 , -- OtherAccidentRelatedFlag - bit
    0 , -- AbuseRelatedFlag - bit
    CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
    0 , -- ShowExpiredInsurancePolicies - bit
    GETDATE() , -- CreatedDate - datetime
    0 , -- CreatedUserID - int
    GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
    @PracticeID , -- PracticeID - int
    i.pataccount , -- VendorID - varchar(50)
    @VendorImportID , -- VendorImportID - int
    0 , -- PregnancyRelatedFlag - bit
    1 , -- StatementActive - bit
    0 , -- EPSDT - bit
    0 , -- FamilyPlanning - bit
    1 , -- EPSDTCodeID - int
    0 , -- EmergencyRelated - bit
    0  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_1_1_PatientFilePatfiledat] i
	INNER JOIN dbo.Patient AS pat ON
		pat.VendorID = i.pataccount AND
		pat.VendorImportID = @VendorImportID
WHERE i.patbal > '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase- Balance Forward'

PRINT ''
PRINT 'Inserting into Encounter '
INSERT INTO dbo.Encounter
	( PracticeID , PatientID , DoctorID , LocationID , DateOfService , DateCreated , Notes , EncounterStatusID , CreatedDate ,
      CreatedUserID , ModifiedDate , ModifiedUserID , ReleaseSignatureSourceCode , PlaceOfServiceCode , PatientCaseID , PostingDate ,
      DateOfServiceTo , PaymentMethod ,	AddOns , DoNotSendElectronic , SubmittedDate , PaymentTypeID , VendorID , VendorImportID ,
      DoNotSendElectronicSecondary , overrideClosingDate , ClaimTypeID , SecondaryClaimTypeID , SubmitReasonIDCMS1500 , SubmitReasonIDUB04 ,
      PatientCheckedIn )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          PC.PatientID , -- PatientID - int
          2  , -- DoctorID - int 
          1 , -- LocationID - int
          GETDATE() , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          Convert(Varchar(10), GETDATE(),101) + ': Creating Balance Forward' , -- Notes - text
          2 , -- EncounterStatusID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
          PC.PatientCaseID , -- PatientCaseID - int
          GETDATE() , -- PostingDate - datetime
          GETDATE() , -- DateOfServiceTo - datetime
          'U' , -- PaymentMethod - char(1)
          0 , -- AddOns - bigint
          0 , -- DoNotSendElectronic - bit
          GETDATE() , -- SubmittedDate - datetime
          0 , -- PaymentTypeID - int
          PC.VendorID , -- VendorID - varchar(50)                   
          @VendorImportID , -- VendorImportID - int
          0 , -- DoNotSendElectronicSecondary - bit
          0 , -- overrideClosingDate - bit
          0 , -- ClaimTypeID - int
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
          0  -- PatientCheckedIn - bit
	FROM dbo.[_import_1_1_PatientFilePatfiledat] AS impPat
	INNER JOIN dbo.Patient realpat ON
		   impPat.pataccount = realpat.VendorID AND
		   realpat.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase PC ON
		   realpat.PatientID = pc.PatientID AND
		   pc.Name = 'Balance Forward' AND
		   pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Encounter' 

IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE DiagnosisCode='000.00')
BEGIN
PRINT ''
PRINT 'Inserting into DiagnosisCodeDictionary' 
INSERT INTO dbo.DiagnosisCodeDictionary 
	( DiagnosisCode , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , Active , OfficialName , LocalName , 
	  OfficialDescription )
VALUES  
       ( 
          '000.00' , -- DiagnosisCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- Active - bit
         'Miscellaneous' ,  -- OfficialName - varchar(300)
         'Miscellaneous' ,  -- LocalName - varchar(100)
          NULL  -- OfficialDescription - varchar(500) 
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into DiagnosisCodeDictionary ' 
END

PRINT ''
PRINT 'Inserting into EncounterDiagnosis '
INSERT INTO dbo.EncounterDiagnosis
	( EncounterID , DiagnosisCodeDictionaryID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ListSequence ,
	  PracticeID , VendorID , VendorImportID )
SELECT DISTINCT
          enc.EncounterID , -- EncounterID - int
          dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- ListSequence - int
          @PracticeID  , -- PracticeID - int
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Encounter as enc 
INNER JOIN dbo.DiagnosisCodeDictionary AS dcd ON
    dcd.DiagnosisCode = '000.00' AND 
    enc.PracticeID = @PracticeID        
WHERE enc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into EncounterDiagnosis' 

PRINT ''
PRINT 'Inserting into EncounterProcedure '
INSERT INTO dbo.EncounterProcedure
	( EncounterID , ProcedureCodeDictionaryID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ServiceChargeAmount ,   
	  ServiceUnitCount , ProcedureDateOfService , PracticeID , EncounterDiagnosisID1 , ServiceEndDate , VendorID ,
	  VendorImportID , TypeOfServiceCode , AnesthesiaTime , AssessmentDate , DoctorID , ConcurrentProcedures )
SELECT DISTINCT
          enc.EncounterID  , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          i.patbal , -- ServiceChargeAmount - money    
          '1.000' , -- ServiceUnitCount - decimal
          GETDATE() , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          ed.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
          GETDATE() , -- ServiceEndDate - datetime
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          '1' , -- TypeOfServiceCode - char(1)
          0 , -- AnesthesiaTime - int
          GETDATE() , -- AssessmentDate - datetime
          enc.DoctorID , -- DoctorID - int
          1  -- ConcurrentProcedures - int
FROM dbo.Encounter AS enc
	INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
		pcd.OfficialName = 'BALANCE FORWARD' 
	INNER JOIN dbo.EncounterDiagnosis AS ed ON
		ed.vendorID = enc.VendorID AND 
		ed.VendorImportID = @VendorImportID   
	INNER JOIN dbo.[_import_1_1_PatientFilePatfiledat] i ON
		enc.VendorID = i.pataccount AND
		enc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into EncounterProcedure' 

UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 , 
		  Name = 'Self Pay'
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL AND pc.Name 


--ROLLBACK
--COMMIT


