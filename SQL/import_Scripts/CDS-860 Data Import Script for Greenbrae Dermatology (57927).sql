USE superbill_57927_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

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
DELETE FROM dbo.EncounterDiagnosis WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter Diagnosis records deleted'
DELETE FROM dbo.EncounterProcedure WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter Procedure records deleted'
DELETE FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter records deleted'
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
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
*/


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          --Notes ,
          --AddressLine1 ,
          --AddressLine2 ,
          --City ,
          --State ,
          --Country ,
          --ZipCode ,
          --Fax ,
          --FaxExt ,
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
    --      CASE WHEN i.clmeligph = '' THEN '' ELSE 'Eligibility Phone: ' + i.clmeligph +
				--CASE WHEN i.clmeligx = '' THEN CHAR(13) + CHAR(10) ELSE ' Ext: ' + i.clmeligx + CHAR(13) + CHAR(10) END END +
		  --CASE WHEN i.clmauth = '' THEN '' ELSE 'Authorization Phone: ' + i.clmauth +
				--CASE WHEN i.clmauthx = '' THEN CHAR(13) + CHAR(10) ELSE ' Ext: ' + i.clmauthx + CHAR(13) + CHAR(10) END END , -- Notes - text
    --      i.clmaddr , -- AddressLine1 - varchar(256)
    --      i.clmattn , -- AddressLine2 - varchar(256)
    --      i.clmcity , -- City - varchar(128)
    --      LEFT(i.clmstate, 2) , -- State - varchar(2)
    --      '' , -- Country - varchar(32)
    --      CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (4,8) THEN '0' + (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.',''))
		  --ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.',''),9) END , -- ZipCode - varchar(9)
          --i.clmfax , -- Fax - varchar(10)
          --i.clmfaxx , -- FaxExt - varchar(10)
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
          i.clmname , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_Clmfile] i
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
SELECT    i.clmname ,
          i.clmaddr , -- AddressLine1 - varchar(256)
          i.clmattn , -- AddressLine2 - varchar(256)
          i.clmcity , -- City - varchar(128)
          LEFT(i.clmstate, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (4,8) THEN '0' + (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.',''))
		  ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.',''),9) END , -- ZipCode - varchar(9)
          Phone ,
          PhoneExt ,
          CASE WHEN i.clmeligph = '' THEN '' ELSE 'Eligibility Phone: ' + i.clmeligph +
				CASE WHEN i.clmeligx = '' THEN CHAR(13) + CHAR(10) ELSE ' Ext: ' + i.clmeligx + CHAR(13) + CHAR(10) END END +
		  CASE WHEN i.clmauth = '' THEN '' ELSE 'Authorization Phone: ' + i.clmauth +
				CASE WHEN i.clmauthx = '' THEN CHAR(13) + CHAR(10) ELSE ' Ext: ' + i.clmauthx + CHAR(13) + CHAR(10) END END ,  
          ic.CreatedDate ,
          ic.CreatedUserID ,
          ic.ModifiedDate ,
          ic.ModifiedUserID ,
          @PracticeID ,
          i.clmfax ,
          i.clmfaxx ,
          ic.InsuranceCompanyID ,
          i.clmcono ,
          @VendorImportID 
FROM dbo.InsuranceCompany ic
INNER JOIN dbo.[_import_1_1_clmfile] i ON
	i.clmname = ic.VendorID AND 
	ic.VendorImportID = @VendorImportID
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
FROM dbo.[_import_1_1_Reffile]
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
FROM dbo.[_import_1_1_Patfile] WHERE patemplname NOT IN ('','*****','.','no')
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
          PhonecallRemindersEnabled , 
		  PrimaryProviderID
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
          CASE WHEN i.patdob = 8 THEN CONVERT(VARCHAR(10),CAST(i.patdob AS DATE),101) END , -- DOB - datetime
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
          0 , -- PhonecallRemindersEnabled - bit
		  dr.DoctorID
FROM dbo.[_import_1_1_Patfile] i
LEFT JOIN dbo.Doctor rd ON
	rd.VendorID = i.patrefdr AND
	rd.VendorImportID = @VendorImportID
LEFT JOIN dbo.Employers e ON 
	i.patemplname = e.EmployerName 
LEFT JOIN dbo._import_1_1_DrFile pdr ON 
	i.patdoctor = pdr.drno
LEFT JOIN dbo.Doctor dr ON
	pdr.drfname = dr.FirstName AND 
	pdr.drnatlprovid = dr.NPI AND
	dr.PracticeID = @PracticeID AND
    dr.[External] = 0
WHERE i.patfname <> '' AND i.patlname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientCase'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          ReferringPhysicianID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          AutoAccidentRelatedState ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          CaseNumber ,
          WorkersCompContactInfoID ,
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
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          NULL , -- ReferringPhysicianID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          NULL , -- AutoAccidentRelatedState - char(2)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          NULL , -- CaseNumber - varchar(128)
          NULL , -- WorkersCompContactInfoID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          NULL , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
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
          irsn.[description] , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          irsn.[description] , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_1_1_aptfile] i
	INNER JOIN dbo._import_1_1_RsnFile irsn	ON 
		i.aptreason = irsn.reason
WHERE irsn.[description] <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.PracticeID = @PracticeID AND ar.Name = irsn.[description])
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
		  CAST(REPLACE(RIGHT(i.startdate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.enddate,5), ':','') AS SMALLINT)   -- EndTm - smallint
FROM dbo.[_import_1_1_Aptfile] i
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
FROM dbo.[_import_1_1_Aptfile] i
INNER JOIN dbo._import_1_1_RsnFile irsn ON 
	i.aptreason = irsn.reason
INNER JOIN dbo.AppointmentReason ar ON
	ar.Name = irsn.[description] AND
	ar.PracticeID = @PracticeID
INNER JOIN dbo.Patient p ON 
	i.aptaccount = p.VendorID AND 
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON
	a.PatientID = p.PatientID AND
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
          CASE WHEN dr.DoctorID IS NULL THEN 1 ELSE dr.DoctorID END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Aptfile] i
INNER JOIN dbo.Patient p ON 
	i.aptaccount = p.VendorID AND 
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON
	a.PatientID = p.PatientID AND
	a.StartDate = CAST(i.startdate AS DATETIME) AND
	a.EndDate = CAST(i.enddate AS DATETIME) AND
	a.PracticeID = @PracticeID
INNER JOIN dbo._import_1_1_DrFile idr ON 
	i.aptdr = idr.drno
LEFT JOIN dbo.Doctor dr ON 
	idr.drfname = dr.FirstName AND
	idr.drnatlprovid = dr.NPI AND
	dr.PracticeID = @PracticeID AND 
	dr.[External] = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Procedure Code...'
INSERT INTO dbo.ProcedureCodeDictionary
        ( ProcedureCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          TypeOfServiceCode ,
          Active ,
          OfficialName ,
          CustomCode
        )
SELECT DISTINCT
		  i.procedurecode , -- ProcedureCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- TypeOfServiceCode - char(1)
          1 , -- Active - bit
          i.[description] , -- OfficialName - varchar(300)
          1  -- CustomCode - bit
FROM dbo.[_import_1_1_ServCode] i
WHERE i.procedurecode <> '' AND NOT EXISTS (SELECT * FROM dbo.ProcedureCodeDictionary pcd WHERE i.procedurecode = pcd.ProcedureCode)
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
                    --ModifierID ,
                    SetFee ,
                    AnesthesiaBaseUnits
                  )
      SELECT DISTINCT
                    sfs.[StandardFeeScheduleID], -- StandardFeeScheduleID - int
                    pcd.[ProcedureCodeDictionaryID] , -- ProcedureCodeID - int
                    --pm.[ProcedureModifierID] , -- ModifierID - int
                    i.standardfeeamounts , -- SetFee - money
                    0  -- AnesthesiaBaseUnits - int
      FROM dbo.[_import_1_1_servCode] AS i
      INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule AS sfs ON
            CAST(sfs.[Notes] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID  
      INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
            pcd.[ProcedureCode] = i.procedurecode
      --LEFT JOIN dbo.ProcedureModifier AS pm ON
      --      pm.[ProcedureModifierCode] = i.servmod
      WHERE i.standardfeeamounts > '0'
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

DELETE FROM dbo._import_1_1_InsFile WHERE insaccount = '127431'

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
          polnum.Num , -- Precedence - int
          polnum.insid , -- PolicyNumber - varchar(32)
          polnum.insgroup , -- GroupNumber - varchar(32)
		  CASE WHEN ISDATE(polnum.insstartdt) = 1 THEN polnum.insstartdt ELSE NULL END , -- PolicyStartDate - datetime
		  CASE WHEN ISDATE(polnum.insenddt) = 1 THEN polnum.insenddt ELSE NULL END  , -- PolicyEndDate - datetime
          CASE WHEN polnum.insipr <> '0' THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN ip.iprfname END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN ip.iprmi END , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN ip.iprlname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN 
			CASE WHEN ISDATE(ip.iprdob) = 1 THEN ip.iprdob ELSE NULL END END , -- HolderDOB - datetime
		  CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN 
			CASE ip.iprsex WHEN 'M' THEN 'M' WHEN 'F' THEN 'F' ELSE 'U' END END , --HolderGender - char(1)
          CASE WHEN polnum.insempl = 'Y' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
          CASE WHEN polnum.insempl = 'Y' THEN e.EmployerName END , -- HolderEmployerName - varchar(128)
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
          CASE WHEN ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN polnum.insid END , -- DependentPolicyNumber - varchar(32)
          CASE WHEN polnum.insstatus = '' THEN '' ELSE 'Insurance Status: ' + polnum.insstatus END , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.PatientCase pc
INNER JOIN 
		(
	SELECT i.insipr, i.insconum , i.insaccount , i.insid , i.insgroup , i.insstatus , i.insempl ,
		  CASE WHEN i.insstartdt = '0' THEN NULL ELSE CONVERT(VARCHAR(10),CAST(i.insstartdt AS DATE),101) END AS [insstartdt] , 
          CASE WHEN i.insenddt = '0' THEN NULL ELSE CONVERT(VARCHAR(10),CAST(i.insenddt AS DATE),101) END AS insenddt , 
	      ROW_NUMBER() OVER(PARTITION BY i.insaccount ORDER BY i.AutoTempID DESC) AS Num  
	FROM dbo._import_1_1_InsFile i ) 

    AS polnum ON polnum.insaccount = pc.VendorID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = polnum.insconum AND
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.Patient p ON	
	pc.PatientID = p.PatientID AND
	p.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_Iprfile] ip ON
	polnum.insipr = ip.iprno 
LEFT JOIN dbo.Employers e ON
	p.EmployerID = e.EmployerID
WHERE pc.VendorImportID = @VendorImportID 
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
              ip.PatientCaseID IS NULL AND
              pc.Name <> 'Balance Forward'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT



