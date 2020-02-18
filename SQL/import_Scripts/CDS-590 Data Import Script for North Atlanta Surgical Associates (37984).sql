USE superbill_37984_dev
--USE superbill_37984_prod
GO

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
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID and VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
*/

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
		  carriername ,
          1 ,
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
          legacycarriercode ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM dbo.[_import_2_1_importcarrier]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #temppolid (ID VARCHAR(50))

INSERT INTO #temppolid  ( ID )
SELECT DISTINCT insplan  
FROM dbo.[_import_6_1_importpatplan] i
INNER JOIN dbo.[_import_4_1_patient] p ON	
i.patientlegacyaccountnumber = p.patientlegacyaccountnumber
INNER JOIN dbo.[_import_2_1_importinsplan] ip ON
i.insplan = ip.insuranceplanidentifier
WHERE CONVERT(DATETIME,p.ptlastdateofservice) > '2011-01-01 00:00:000' OR p.ptlastdateofservice = ''

INSERT INTO #temppolid  ( ID )
SELECT DISTINCT insplan  
FROM dbo._import_7_1_importpatplan2 i
INNER JOIN dbo.[_import_4_1_patient] p ON	
i.patientlegacyaccountnumber = p.patientlegacyaccountnumber
INNER JOIN dbo.[_import_2_1_importinsplan] ip ON
i.insplan = ip.insuranceplanidentifier
WHERE CONVERT(DATETIME,p.ptlastdateofservice) > '2011-01-01 00:00:000' OR p.ptlastdateofservice = ''
AND NOT EXISTS (SELECT * FROM #temppolid WHERE insplan = ID)

INSERT INTO #temppolid  ( ID )
SELECT DISTINCT insplan  
FROM dbo.[_import_6_1_importpatplan] i
INNER JOIN dbo.[_import_5_1_patient2] p ON	
i.patientlegacyaccountnumber = p.patientlegacyaccountnumber
INNER JOIN dbo.[_import_2_1_importinsplan] ip ON
i.insplan = ip.insuranceplanidentifier
WHERE CONVERT(DATETIME,p.ptlastdateofservice) > '2011-01-01 00:00:000' OR p.ptlastdateofservice = ''
AND NOT EXISTS (SELECT * FROM #temppolid WHERE insplan = ID)

INSERT INTO #temppolid  ( ID )
SELECT DISTINCT insplan  
FROM dbo._import_7_1_importpatplan2 i
INNER JOIN dbo.[_import_5_1_patient2] p ON	
i.patientlegacyaccountnumber = p.patientlegacyaccountnumber
INNER JOIN dbo.[_import_2_1_importinsplan] ip ON
i.insplan = ip.insuranceplanidentifier
WHERE CONVERT(DATETIME,p.ptlastdateofservice) > '2011-01-01 00:00:000' OR p.ptlastdateofservice = ''
AND NOT EXISTS (SELECT * FROM #temppolid WHERE insplan = ID)

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
          Copay ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  i.insuranceplanname , -- PlanName - varchar(128)
          i.insuranceplanaddress , -- AddressLine1 - varchar(256)
          i.insuranceplanaddress2 , -- AddressLine2 - varchar(256)
          i.insuranceplancity , -- City - varchar(128)
          i.insuranceplanstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.insuranceplanzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.insuranceplanzipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.insuranceplanzipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.insuranceplanzipcode)
		  ELSE '' END   , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
		  CASE
			WHEN LEN(i.insplanbusinessphone) >= 10 THEN LEFT(i.insplanbusinessphone,10)
		  ELSE '' END  , -- Phone - varchar(10)
		  CASE
			WHEN LEN(i.insplanbusinessphone) > 10 THEN LEFT(SUBSTRING(i.insplanbusinessphone,11,LEN(i.insplanbusinessphone)),10)
		  ELSE NULL END , -- PhoneExt - varchar(10)
          CASE WHEN i.insplanauthorizationphone = '' THEN '' ELSE 'Authorization Phone: ' + i.insplanauthorizationphone + CHAR(13) + CHAR(10) END + 
		  CASE WHEN i.insplaneligibilityphone = '' THEN '' ELSE 'Eligibility Phone: ' + i.insplaneligibilityphone + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.insplancontactphone = '' THEN '' ELSE 'Contact Phone: ' + i.insplancontactphone + CHAR(13) + CHAR(10) END +
		  CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
		  CASE
			WHEN LEN(i.insplanfax) >= 10 THEN LEFT(i.insplanfax,10)
		  ELSE '' END , -- Fax - varchar(10)
		  CASE
			WHEN LEN(i.insplanfax) > 10 THEN LEFT(SUBSTRING(i.insplanfax,11,LEN(i.insplanfax)),10)
		  ELSE NULL END  , -- FaxExt - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          i.copayamount , -- Copay - money
          i.insuranceplanidentifier , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_importinsplan] i
INNER JOIN #temppolid tid ON i.insuranceplanidentifier = tid.ID 
INNER JOIN dbo.InsuranceCompany ic ON i.carriercode = ic.VendorID AND ic.VendorImportID = @VendorImportID
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
          PhoneExt ,
          FaxPhone ,
          FaxPhoneExt ,
          CLIANumber ,
          VendorImportID ,
          VendorID ,
          NPI ,
          TimeZoneID ,
          PayToName ,
          PayToAddressLine1 ,
          PayToAddressLine2 ,
          PayToCity ,
          PayToState ,
          PayToCountry ,
          PayToZipCode ,
          PayToPhone ,
          PayToPhoneExt ,
          PayToFax ,
          PayToFaxExt 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          i.legacylocationcode + ' - ' + i.locationdescription , -- Name - varchar(128)
          i.address1 , -- AddressLine1 - varchar(256)
          i.address2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zipcode)
		  ELSE '' END   , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.placeofservice , -- PlaceOfServiceCode - char(2)
          '' , -- BillingName - varchar(128)
		  CASE
			WHEN LEN(i.phonenumber) >= 10 THEN LEFT(i.phonenumber,10)
		  ELSE '' END , -- Phone - varchar(10)
		  CASE
			WHEN LEN(i.phonenumber) > 10 THEN LEFT(SUBSTRING(i.phonenumber,11,LEN(i.phonenumber)),10)
		  ELSE NULL END  , -- PhoneExt - varchar(10)
		  CASE
			WHEN LEN(i.faxnumber) >= 10 THEN LEFT(i.faxnumber,10)
		  ELSE '' END  , -- FaxPhone - varchar(10)
		  CASE
			WHEN LEN(i.faxnumber) > 10 THEN LEFT(SUBSTRING(i.faxnumber,11,LEN(i.faxnumber)),10)
		  ELSE NULL END  , -- FaxPhoneExt - varchar(10)
          i.medicareid , -- CLIANumber - varchar(30)
          @VendorImportID , -- VendorImportID - int
          i.AutoTempID , -- VendorID - int
          i.npi , -- NPI - varchar(10)
          15 , -- TimeZoneID - int
          '' , -- PayToName - varchar(60)
          '' , -- PayToAddressLine1 - varchar(256)
          '' , -- PayToAddressLine2 - varchar(256)
          '' , -- PayToCity - varchar(128)
          '' , -- PayToState - varchar(2)
          '' , -- PayToCountry - varchar(32)
          '' , -- PayToZipCode - varchar(9)
          '' , -- PayToPhone - varchar(10)
          '' , -- PayToPhoneExt - varchar(10)
          '' , -- PayToFax - varchar(10)
          ''  -- PayToFaxExt - varchar(10)
FROM dbo.[_import_2_1_importlocation] i
WHERE i.import = 'Y'
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
          SSN ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          HomePhone ,
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          PagerPhone ,
          PagerPhoneExt ,
          MobilePhone ,
          MobilePhoneExt ,
          EmailAddress ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
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
          i.firstname , -- FirstName - varchar(64)
          i.middlename , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.ssn , -- SSN - varchar(9)
          i.[address] , -- AddressLine1 - varchar(256)
          i.address2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zipcode)
		  ELSE '' END   , -- ZipCode - varchar(9)
          '' , -- HomePhone - varchar(10)
          '' , -- HomePhoneExt - varchar(10)
		  CASE
			WHEN LEN(i.officephone) >= 10 THEN LEFT(i.officephone,10)
		  ELSE '' END , -- WorkPhone - varchar(10)
		  CASE
			WHEN LEN(i.officephone) > 10 THEN LEFT(SUBSTRING(i.officephone,11,LEN(i.officephone)),10)
		  ELSE NULL END , -- WorkPhoneExt - varchar(10)
		  CASE
			WHEN LEN(i.pager) >= 10 THEN LEFT(i.pager,10)
		  ELSE '' END , -- PagerPhone - varchar(10)
		  CASE
			WHEN LEN(i.pager) > 10 THEN LEFT(SUBSTRING(i.pager,11,LEN(i.pager)),10)
		  ELSE NULL END  , -- PagerPhoneExt - varchar(10)
		  CASE
			WHEN LEN(i.mobilephone) >= 10 THEN LEFT(i.mobilephone,10)
		  ELSE '' END , -- MobilePhone - varchar(10)
		  CASE
			WHEN LEN(i.mobilephone) > 10 THEN LEFT(SUBSTRING(i.mobilephone,11,LEN(i.mobilephone)),10)
		  ELSE NULL END  , -- MobilePhoneExt - varchar(10)
          '' , -- EmailAddress - varchar(256)
          CASE WHEN i.bcbsidnumber = '' THEN '' ELSE 'BCBS ID Number: ' + i.bcbsidnumber + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.champusidnumber = '' THEN '' ELSE 'Champus ID Number: ' + i.champusidnumber + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.medicaididnumber = '' THEN '' ELSE 'Medicaid ID Number: ' + i.medicaididnumber + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.medicareidnumber = '' THEN '' ELSE 'Nedicare ID Number: ' + i.medicareidnumber + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.taxidnumber = '' THEN '' ELSE 'Tax ID: ' + i.taxidnumber + CHAR(13) + CHAR(10) END + 
		  CASE WHEN i.upinnumber = '' THEN '' ELSE 'Upin: ' + i.upinnumber END , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          LEFT(i.suffix, 8) , -- Degree - varchar(8)
          i.legacyreferringprovidercode , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
		  CASE
			WHEN LEN(i.fax) >= 10 THEN LEFT(i.fax,10)
		  ELSE '' END , -- FaxNumber - varchar(10)
		  CASE
			WHEN LEN(i.fax) > 10 THEN LEFT(SUBSTRING(i.fax,11,LEN(i.fax)),10)
		  ELSE NULL END  , -- FaxNumberExt - varchar(10)
          1 , -- External - bit
          LEFT(i.npi,10)  -- NPI - varchar(10)
FROM dbo.[_import_2_1_importrefprov] i
WHERE i.firstname <> '' AND i.lastname <> ''
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
		  i.legacyemployercode + ' - ' + i.employername , -- EmployerName - varchar(128)
          i.address1 , -- AddressLine1 - varchar(256)
          i.address2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zipcode)
		  ELSE '' END  , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_2_1_importemployer] i
WHERE i.legacyemployercode <> '' AND i.employername <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DELETE FROM dbo.[_import_2_1_importproccode] WHERE legacyprocedurecode = 'MEDREC'

PRINT ''
PRINT 'Inserting into Diagnosis Code Dictionary...'
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
		  i.cptcode , -- ProcedureCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN tos.TypeOfServiceCode IS NULL THEN '1' ELSE i.toscode END  , -- TypeOfServiceCode - char(1)
          1 , -- Active - bit
          i.cptdescription , -- OfficialName - varchar(300)
          0  -- CustomCode - bit
FROM dbo.[_import_2_1_importproccode] i
LEFT JOIN dbo.TypeOfService tos ON i.toscode = tos.TypeOfServiceCode
WHERE NOT EXISTS (SELECT * FROM dbo.ProcedureCodeDictionary pcd WHERE i.cptcode = pcd.ProcedureCode)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
VALUES  ( 
		  @PracticeID , -- PracticeID - int
          'Default contract' , -- Name - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          GETDATE() , -- EffectiveStartDate - datetime
          'F' , -- SourceType - char(1)
          'Import file' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
        )

PRINT ''
PRINT 'Inserting Into Standard Fee...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT
	      c.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          NULL , -- ModifierID - int
          impSFS.standardFee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_2_1_importproccode] impSFS
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule c ON
	CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
	c.practiceID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	impSFS.cptcode = pcd.ProcedureCode
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
  
PRINT ''
PRINT 'Inserting Into Standard Fee Link...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT
	      doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs 
WHERE doc.PracticeID = @PracticeID AND
	doc.[External] = 0 AND 
	sl.PracticeID = @PracticeID AND
	CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	sfs.PracticeID = @PracticeID 
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
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleCountry ,
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          d.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.ptfirstname , -- FirstName - varchar(64)
          i.ptmiddlename , -- MiddleName - varchar(64)
          i.ptlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.ptaddress , -- AddressLine1 - varchar(256)
          i.ptaddress2 , -- AddressLine2 - varchar(256)
          i.ptcity , -- City - varchar(128)
          i.ptstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ptzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.ptzipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ptzipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.ptzipcode)
		  ELSE '' END   , -- ZipCode - varchar(9)
          i.ptsex , -- Gender - varchar(1)
          CASE i.ptmaritalstatus WHEN 'U' THEN ''
								 WHEN 'X' THEN ''
								 WHEN 'O' THEN ''
		  ELSE i.ptmaritalstatus END , -- MaritalStatus - varchar(1)
		  CASE
			WHEN LEN(i.ptphone) >= 10 THEN LEFT(i.ptphone,10)
		  ELSE '' END , -- HomePhone - varchar(10)
		  CASE
			WHEN LEN(i.ptphone) > 10 THEN LEFT(SUBSTRING(i.ptphone,11,LEN(i.ptphone)),10)
		  ELSE NULL END  , -- HomePhoneExt - varchar(10)
          		  CASE
			WHEN LEN(i.ptworkphone) >= 10 THEN LEFT(i.ptworkphone,10)
		  ELSE '' END  , -- WorkPhone - varchar(10)
		  CASE
			WHEN LEN(i.ptworkphone) > 10 THEN LEFT(SUBSTRING(i.ptworkphone,11,LEN(i.ptworkphone)),10)
		  ELSE NULL END  , -- WorkPhoneExt - varchar(10)
          DATEADD(hh,12,CONVERT(DATETIME,i.ptdob))  , -- DOB - datetime
          CASE WHEN LEN(i.ptssn) >= 6 THEN RIGHT('000' + i.ptssn, 9) ELSE NULL END , -- SSN - char(9)
          i.ptemail , -- EmailAddress - varchar(256)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN '' END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantorfirstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantormiddlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantorlastcompanyname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN '' END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantoraddress END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantoraddress2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantorcity END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantorstate END , -- ResponsibleState - varchar(2)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)
		  ELSE '' END END  , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.ptemploymentstatus <> '' THEN i.ptemploymentstatus ELSE 'U' END , -- EmploymentStatus - char(1)
          rd.DoctorID , -- PrimaryProviderID - int
          NULL , -- DefaultServiceLocationID - int
          e.EmployerID , -- EmployerID - int
          i.ptchart , -- MedicalRecordNumber - varchar(128)
		  CASE
			WHEN LEN(i.patientcellphonenumber) >= 10 THEN LEFT(i.patientcellphonenumber,10)
		  ELSE '' END  , -- MobilePhone - varchar(10)
		  CASE
			WHEN LEN(i.patientcellphonenumber) > 10 THEN LEFT(SUBSTRING(i.patientcellphonenumber,11,LEN(i.patientcellphonenumber)),10)
		  ELSE NULL END  , -- MobilePhoneExt - varchar(10)
          NULL , -- PrimaryCarePhysicianID - int
          i.patientlegacyaccountnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_4_1_patient] i
LEFT JOIN dbo.Employers e ON LEFT(e.EmployerName, CHARINDEX(' ', e.EmployerName) - 1) = i.ptemployer
LEFT JOIN dbo.Doctor d ON d.[External] = 1 AND d.VendorID = i.ptreferringprovider AND d.PracticeID = @PracticeID
LEFT JOIN dbo.[_import_1_1_importprovider] ip ON i.ptassignedprovider = ip.legacyprovidercode
LEFT JOIN dbo.Doctor rd ON rd.FirstName = ip.firstname AND rd.LastName = ip.lastname AND rd.[External] = 0 AND rd.ActiveDoctor = 1 AND rd.PracticeID = @PracticeID
WHERE CONVERT(DATETIME,i.ptlastdateofservice) > '2011-01-01 00:00:000' OR i.ptlastdateofservice = ''
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
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleCountry ,
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          d.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.ptfirstname , -- FirstName - varchar(64)
          i.ptmiddlename , -- MiddleName - varchar(64)
          i.ptlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.ptaddress , -- AddressLine1 - varchar(256)
          i.ptaddress2 , -- AddressLine2 - varchar(256)
          i.ptcity , -- City - varchar(128)
          i.ptstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ptzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.ptzipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ptzipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.ptzipcode)
		  ELSE '' END   , -- ZipCode - varchar(9)
          i.ptsex , -- Gender - varchar(1)
          CASE i.ptmaritalstatus WHEN 'U' THEN ''
								 WHEN 'X' THEN ''
								 WHEN 'O' THEN ''
		  ELSE i.ptmaritalstatus END , -- MaritalStatus - varchar(1)
		  CASE
			WHEN LEN(i.ptphone) >= 10 THEN LEFT(i.ptphone,10)
		  ELSE '' END , -- HomePhone - varchar(10)
		  CASE
			WHEN LEN(i.ptphone) > 10 THEN LEFT(SUBSTRING(i.ptphone,11,LEN(i.ptphone)),10)
		  ELSE NULL END  , -- HomePhoneExt - varchar(10)
          		  CASE
			WHEN LEN(i.ptworkphone) >= 10 THEN LEFT(i.ptworkphone,10)
		  ELSE '' END  , -- WorkPhone - varchar(10)
		  CASE
			WHEN LEN(i.ptworkphone) > 10 THEN LEFT(SUBSTRING(i.ptworkphone,11,LEN(i.ptworkphone)),10)
		  ELSE NULL END  , -- WorkPhoneExt - varchar(10)
          DATEADD(hh,12,CONVERT(DATETIME,i.ptdob)) , -- DOB - datetime
          CASE WHEN LEN(i.ptssn) >= 6 THEN RIGHT('000' + i.ptssn, 9) ELSE NULL END , -- SSN - char(9)
          i.ptemail , -- EmailAddress - varchar(256)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN '' END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantorfirstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantormiddlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantorlastcompanyname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN '' END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantoraddress END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantoraddress2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantorcity END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantorstate END , -- ResponsibleState - varchar(2)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)
		  ELSE '' END END  , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.ptemploymentstatus <> '' THEN i.ptemploymentstatus ELSE 'U' END , -- EmploymentStatus - char(1)
          NULL , -- PrimaryProviderID - int
          NULL , -- DefaultServiceLocationID - int
          e.EmployerID , -- EmployerID - int
          i.ptchart , -- MedicalRecordNumber - varchar(128)
		  CASE
			WHEN LEN(i.patientcellphonenumber) >= 10 THEN LEFT(i.patientcellphonenumber,10)
		  ELSE '' END  , -- MobilePhone - varchar(10)
		  CASE
			WHEN LEN(i.patientcellphonenumber) > 10 THEN LEFT(SUBSTRING(i.patientcellphonenumber,11,LEN(i.patientcellphonenumber)),10)
		  ELSE NULL END  , -- MobilePhoneExt - varchar(10)
          NULL , -- PrimaryCarePhysicianID - int
          i.patientlegacyaccountnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_5_1_Patient2] i
LEFT JOIN dbo.Employers e ON LEFT(e.EmployerName, CHARINDEX(' -', e.EmployerName) - 1) = i.ptemployer 
LEFT JOIN dbo.Doctor d ON d.[External] = 1 AND d.VendorID = i.ptreferringprovider AND d.PracticeID = @PracticeID
WHERE CONVERT(DATETIME,i.ptlastdateofservice) > '2011-01-01 00:00:000' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	PatientID , -- PatientID - int
	'Default Case' , -- Name - varchar(128)
	1 , -- Active - bit
	5 , -- PayerScenarioID - int
	NULL , -- ReferringPhysicianID - int
	0 , -- EmploymentRelatedFlag - bit
	0, -- AutoAccidentRelatedFlag - bit
	0, -- OtherAccidentRelatedFlag - bit
	0, -- AbuseRelatedFlag - bit
	NULL , -- AutoAccidentRelatedState - char(2)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	0, -- ShowExpiredInsurancePolicies - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- PracticeID - int
	NULL , -- CaseNumber - varchar(128)
	NULL , -- WorkersCompContactInfoID - int
	VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.Patient WHERE  VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

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
SELECT    
			  CASE WHEN PJN.dateadded = '' THEN GETDATE() ELSE DATEADD(hh,12,CONVERT(DATETIME,pjn.dateadded))  END , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          PAT.PatientID , -- PatientID - int
	          'Kareo' , -- UserName - varchar(128)
	          'K' , -- SoftwareApplicationID - char(1)
	          0 , -- Hidden - bit
	          'Note Class: ' + nc.[description] + CHAR(13) + CHAR(10) + PJN.note , -- NoteMessage - varchar(max)
	          0 , -- AccountStatus - bit
	          1 , -- NoteTypeCode - int
	          0  -- LastNote - bit
FROM dbo.[_import_2_1_importpatnotes] PJN
INNER JOIN dbo.Patient PAT ON PJN.legacypatientaccount = PAT.VendorID AND PAT.PracticeID = @PracticeID
INNER JOIN dbo.[_import_2_1_importnoteclas] nc ON PJN.noteclass = nc.noteclass
WHERE pjn.note <> ''	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

DELETE FROM dbo.[_import_7_1_importpatplan2] WHERE subscriberuniqueid IN ('19039', '19041')
UPDATE dbo.[_import_7_1_importpatplan2] SET subscriberdob = '' WHERE subscriberuniqueid IN ('20419','48873')
UPDATE dbo.[_import_7_1_importpatplan2] SET startdate = '' WHERE subscriberuniqueid IN ('48873','27480')
UPDATE dbo.[_import_7_1_importpatplan2] SET enddate = '' WHERE subscriberuniqueid = '51782'

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
          CardOnFile ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation ,
          SyncWithEHR 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.coverageorder , -- Precedence - int
          i.memberidforclaims , -- PolicyNumber - varchar(32)
          i.[group] , -- GroupNumber - varchar(32)
          CASE WHEN i.startdate <> '' THEN CONVERT(DATETIME,i.startdate) ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN i.enddate <> '' THEN CONVERT(DATETIME,i.enddate) ELSE NULL END , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN 'O' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscribermiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberlastname END , -- HolderLastName - varchar(64)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN 
			CASE WHEN i.subscriberdob <> '' THEN DATEADD(hh,12,CONVERT(DATETIME,i.subscriberdob)) ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN
			CASE WHEN LEN(i.subscriberssn) >= 6 THEN RIGHT('000' + i.subscriberssn, 9) ELSE NULL END END  , -- HolderSSN - char(11)
          CASE WHEN i.subscriberemployer <> '' THEN 1 ELSE 0 END  , -- HolderThroughEmployer - bit
          CASE WHEN i.subscriberemployer <> '' THEN e.EmployerName END , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscribersex END , -- HolderGender - char(1)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberaddress END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberaddress2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscribercity END , -- HolderCity - varchar(128)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberstate END , -- HolderState - varchar(2)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.subscriberzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.subscriberzip)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.subscriberzip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.subscriberzip)
		  ELSE '' END END  , -- HolderZipCode - varchar(9)
		  CASE
			WHEN LEN(i.subscriberhomephone) >= 10 THEN LEFT(i.subscriberhomephone,10)
		  ELSE '' END            , -- HolderPhone - varchar(10)
		  CASE
			WHEN LEN(i.subscriberhomephone) > 10 THEN LEFT(SUBSTRING(i.subscriberhomephone,11,LEN(i.subscriberhomephone)),10)
		  ELSE NULL END , -- HolderPhoneExt - varchar(10)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.memberidforclaims END , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)
          0 , -- Copay - money
          0 , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)
          i.subscriberuniqueid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          '' , -- GroupName - varchar(14)
          'Y' , -- ReleaseOfInformation - varchar(1)
          1  -- SyncWithEHR - bit
FROM dbo.[_import_6_1_importpatplan] i
INNER JOIN dbo.PatientCase pc ON i.patientlegacyaccountnumber = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID AND p.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON i.insplan = icp.VendorID AND icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.Employers e ON LEFT(e.EmployerName, CHARINDEX(' ', e.EmployerName) - 1) = i.subscriberemployer
WHERE i.recordstatus = 'A' and i.coverageorder <> '99'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

UPDATE dbo.[_import_7_1_importpatplan2] SET coverageorder = 2 WHERE patientlegacyaccountnumber = '48630'

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
          CardOnFile ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation ,
          SyncWithEHR 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.coverageorder , -- Precedence - int
          i.memberidforclaims , -- PolicyNumber - varchar(32)
          i.[group] , -- GroupNumber - varchar(32)
          CASE WHEN i.startdate <> '' OR LEN(i.startdate) = 8 THEN CONVERT(DATETIME,i.startdate) ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN i.enddate <> '' OR LEN(i.enddate) = 8 THEN CONVERT(DATETIME,i.enddate) ELSE NULL END , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN 'O' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscribermiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberlastname END , -- HolderLastName - varchar(64)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN 
			CASE WHEN i.subscriberdob <> '' OR LEN(i.subscriberdob) = 8 THEN DATEADD(hh,12,CONVERT(DATETIME,i.subscriberdob)) ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN
			CASE WHEN LEN(i.subscriberssn) >= 6 THEN RIGHT('000' + i.subscriberssn, 9) ELSE NULL END END  , -- HolderSSN - char(11)
          CASE WHEN i.subscriberemployer <> '' THEN 1 ELSE 0 END  , -- HolderThroughEmployer - bit
          CASE WHEN i.subscriberemployer <> '' THEN e.EmployerName END , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscribersex END , -- HolderGender - char(1)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberaddress END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberaddress2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscribercity END , -- HolderCity - varchar(128)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberstate END , -- HolderState - varchar(2)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.subscriberzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.subscriberzip)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.subscriberzip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.subscriberzip)
		  ELSE '' END END  , -- HolderZipCode - varchar(9)
		  CASE
			WHEN LEN(i.subscriberhomephone) >= 10 THEN LEFT(i.subscriberhomephone,10)
		  ELSE '' END            , -- HolderPhone - varchar(10)
		  CASE
			WHEN LEN(i.subscriberhomephone) > 10 THEN LEFT(SUBSTRING(i.subscriberhomephone,11,LEN(i.subscriberhomephone)),10)
		  ELSE NULL END , -- HolderPhoneExt - varchar(10)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.memberidforclaims END , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)
          0 , -- Copay - money
          0 , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          1 , -- PracticeID - int
          '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)
          i.subscriberuniqueid , -- VendorID - varchar(50)
          1 , -- VendorImportID - int
          '' , -- GroupName - varchar(14)
          'Y' , -- ReleaseOfInformation - varchar(1)
          1  -- SyncWithEHR - bit
FROM dbo.[_import_7_1_importpatplan2] i
INNER JOIN dbo.PatientCase pc ON i.patientlegacyaccountnumber = pc.VendorID AND pc.VendorImportID = 1
INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID AND p.VendorImportID = 1
INNER JOIN dbo.InsuranceCompanyPlan icp ON i.insplan = icp.VendorID AND icp.VendorImportID = 1
LEFT JOIN dbo.Employers e ON LEFT(e.EmployerName, CHARINDEX(' ', e.EmployerName) - 1) = i.subscriberemployer
WHERE i.recordstatus = 'A' and i.coverageorder <> '99' 
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
          i.legacyreasoncode , -- Name - varchar(128)
          i.duration , -- DefaultDurationMinutes - int
          NULL , -- DefaultColorCode - int
          i.reasoncodedescription , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_1_1_importaptrsn] i 
INNER JOIN dbo.[_import_1_1_importappt] ia ON i.legacyreasoncode = ia.appointmentreasoncode
AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE i.legacyreasoncode = ar.Name AND ar.PracticeID = @PracticeID)
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
          AllDay ,
          InsurancePolicyAuthorizationID ,
          PatientCaseID ,
          Recurrence ,
          RecurrenceStartDate ,
          RangeEndDate ,
          RangeType ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
	      CASE WHEN SL.ServiceLocationID IS NULL 
			THEN CASE WHEN SL2.ServiceLocationID IS NULL 
			   THEN SL3.ServiceLocationID 
		  ELSE SL2.ServiceLocationID END ELSE sl.ServiceLocationID END , -- ServiceLocationID - int
          CONVERT(DATETIME,appointmentdate) + DATEADD(hh,-3,STUFF(REPLACE(STR(appointmenttime, 4), ' ', '0'), 3, 0, ':')) , -- StartDate - datetime
          CONVERT(DATETIME,appointmentdate) + DATEADD(n,CAST(appointmentlength AS INT) ,DATEADD(hh,-3,STUFF(REPLACE(STR(appointmenttime, 4), ' ', '0'), 3, 0, ':')))  , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.legacyappointmentid , -- Subject - varchar(64)
          i.appointmentnotes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          0 , -- AllDay - bit
          NULL , -- InsurancePolicyAuthorizationID - int
          pc.PatientCaseID , -- PatientCaseID - int
          0 , -- Recurrence - bit
          NULL , -- RecurrenceStartDate - datetime
          NULL , -- RangeEndDate - datetime
          '' , -- RangeType - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.appointmenttime - 300 , -- StartTm - smallint
          REPLACE(LTRIM(REPLACE(LEFT(REPLACE(REPLACE(DATEADD(hh,-3,DATEADD(n,CAST(appointmentlength AS INT),CAST(STUFF(REPLACE(STR(appointmenttime, 4), ' ', '0'), 3, 0, ':') AS TIME))),':',''),'.',''), 4),'0', ' ')),' ','0')   -- EndTm - smallint
FROM dbo.[_import_1_1_importappt] i
INNER JOIN dbo.Patient p ON i.patientnumber = p.VendorID AND p.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase pc ON p.PatientID = pc.PatientID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice dk ON CONVERT(DATETIME,i.appointmentdate) = dk.Dt AND dk.PracticeID = @PracticeID
LEFT JOIN dbo.ServiceLocation sl ON LEFT(sl.Name, CHARINDEX(' -', sl.Name) - 1) = i.appointmentlocationcode AND sl.VendorImportID = @VendorImportID
LEFT JOIN dbo.ServiceLocation SL2 ON SL2.Name = i.appointmentlocationcode
LEFT JOIN dbo.ServiceLocation SL3 ON SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID)
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
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_importappt] i
INNER JOIN dbo.Appointment a ON i.legacyappointmentid = a.[Subject] AND a.PracticeID = @PracticeID
INNER JOIN dbo.AppointmentReason ar ON i.appointmentreasoncode = ar.Name AND ar.PracticeID = @PracticeID
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
SELECT DISTINCT		
		  2 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          i.roomcode + ' - ' + i.roomdescription , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
FROM dbo.[_import_1_1_importroom] i
INNER JOIN dbo.[_import_1_1_importappt] ia ON i.roomcode = ia.drorroomorequip
WHERE i.roomcode NOT IN ('TEST','') AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.Name = i.roomcode + ' - ' + i.roomdescription)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Appointment to Resource - Doctor...'
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
          CASE WHEN d.DoctorID IS NULL THEN d2.DoctorID ELSE d.DoctorID END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_importappt] i 
INNER JOIN dbo.Appointment a ON i.legacyappointmentid = a.[Subject]
LEFT JOIN dbo.[_import_1_1_importprovider] ip ON i.drorroomorequip = ip.legacyprovidercode
LEFT JOIN dbo.Doctor d ON d.FirstName = ip.firstname AND d.LastName = ip.lastname AND d.[External] = 0 AND d.ActiveDoctor = 1 AND d.PracticeID = @PracticeID
LEFT JOIN dbo.Doctor d2 ON d2.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor WHERE [external] = 0 AND ActiveDoctor = 1 AND PracticeID = @PracticeID)
WHERE i.appttypedrroomequipmentorcancellation = 'D'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Appointment to Resource - PracticeResource...'
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
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_importappt] i 
INNER JOIN dbo.Appointment a ON i.legacyappointmentid = a.[Subject]
INNER JOIN dbo.PracticeResource pr ON LEFT(pr.ResourceName, CHARINDEX(' -', pr.ResourceName) - 1) = i.drorroomorequip AND pr.PracticeID = @PracticeID
WHERE i.appttypedrroomequipmentorcancellation = 'R' AND pr.ModifiedDate > DATEADD(mi,-5,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase SET Name = 'Self Pay' , PayerScenarioID = 11 
FROM dbo.PatientCase pc LEFT JOIN dbo.InsurancePolicy ip ON ip.PatientCaseID = pc.PatientCaseID
WHERE pc.VendorImportID = @VendorImportID AND ip.PatientCaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

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
          'Balance Forward' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          Pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient as pat 
INNER JOIN dbo.[_import_4_1_patient] AS m ON
   pat.VendorID = m.patientlegacyaccountnumber AND 
   pat.VendorImportID = @VendorImportID 
WHERE m.patientbalance <> '' AND m.patientbalance > '0'
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
          'Balance Forward' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          Pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient as pat 
INNER JOIN dbo.[_import_5_1_Patient2] AS m ON
   pat.VendorID = m.patientlegacyaccountnumber AND 
   pat.VendorImportID = @VendorImportID 
WHERE m.patientbalance <> '' AND m.patientbalance > '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE DiagnosisCode='000.00')
BEGIN

INSERT INTO dbo.DiagnosisCodeDictionary 
        ( 
		  DiagnosisCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          OfficialName ,
          LocalName ,
          OfficialDescription    
        )
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
END

PRINT ''
PRINT 'Inserting Into Encounter...'
INSERT INTO dbo.Encounter
        ( PracticeID ,
          PatientID ,
          DoctorID ,
          LocationID ,
          DateOfService ,
          DateCreated ,
          Notes ,
          EncounterStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReleaseSignatureSourceCode ,
          PlaceOfServiceCode ,
          PatientCaseID ,
          PostingDate ,
          DateOfServiceTo ,
          PaymentMethod ,
          AddOns ,
          DoNotSendElectronic ,
          SubmittedDate ,
          PaymentTypeID ,
          VendorID ,
          VendorImportID ,
          DoNotSendElectronicSecondary ,
          overrideClosingDate ,
          ClaimTypeID ,
          SecondaryClaimTypeID ,
          SubmitReasonIDCMS1500 ,
          SubmitReasonIDUB04 ,
          PatientCheckedIn 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          pc.PatientID , -- PatientID - int
          CASE WHEN PAT.PrimaryProviderID IS NULL THEN Doc.DoctorID ELSE PAT.PrimaryProviderID END , -- DoctorID - int
          CASE WHEN PAT.DefaultServiceLocationID IS NULL THEN SL.ServiceLocationID ELSE PAT.DefaultServiceLocationID END , -- LocationID - int
          GETDATE() , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          Convert(Varchar(10), GETDATE(),101) + ' : Balance Forward Created, please verify before use.' , -- Notes - text
          2 , -- EncounterStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
          pc.PatientCaseID , -- PatientCaseID - int       
          GETDATE() , -- PostingDate - datetime
          GETDATE() , -- DateOfServiceTo - datetime
          'U' , -- PaymentMethod - char(1)
          0 , -- AddOns - bigint
          0 , -- DoNotSendElectronic - bit
          GETDATE() , -- SubmittedDate - datetime
          0 , -- PaymentTypeID - int
          pc.VendorID , -- VendorID - varchar(50)                
          @VendorImportID , -- VendorImportID - int
          0 , -- DoNotSendElectronicSecondary - bit
          0 , -- overrideClosingDate - bit
          0 , -- ClaimTypeID - int
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
          0  -- PatientCheckedIn - bit
FROM dbo.PatientCase AS PC  
INNER JOIN dbo.Patient PAT ON
	PC.PatientID = PAT.PatientID AND
	PC.VendorID = PAT.VendorID  
LEFT JOIN dbo.Doctor Doc ON
	Doc.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS D WHERE d.ActiveDoctor =1 AND d.[External] = 0 AND d.PracticeID = @PracticeID AND d.ActiveDoctor = 1)
LEFT JOIN dbo.ServiceLocation SL ON
	SL.ServicelocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation S WHERE s.PracticeID = @PracticeID)
WHERE pc.Name = 'Balance Forward' AND pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Encounter Diagnosis...'
INSERT INTO dbo.EncounterDiagnosis
        ( 
		  EncounterID ,
          DiagnosisCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          ListSequence ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
          enc.EncounterID , -- EncounterID - int
          dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          1 , -- ListSequence - int
          @PracticeID  , -- PracticeID - int
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Encounter as enc 
INNER JOIN dbo.DiagnosisCodeDictionary AS dcd ON
    dcd.DiagnosisCode = '000.00' AND 
    enc.PracticeID = @PracticeID        
WHERE enc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Encounter Procedure...'
INSERT INTO dbo.EncounterProcedure
        ( 
		  EncounterID ,
          ProcedureCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ServiceChargeAmount ,   
          ServiceUnitCount ,
          ProcedureDateOfService ,
          PracticeID ,
          EncounterDiagnosisID1 ,
          ServiceEndDate ,
          VendorID ,
          VendorImportID ,
          TypeOfServiceCode ,
          AnesthesiaTime ,
          AssessmentDate ,
          DoctorID ,
          ConcurrentProcedures 
        )
SELECT DISTINCT
          enc.EncounterID  , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pd.patientbalance , -- ServiceChargeAmount - money   
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
   pcd.OfficialName = 'Balance Forward' AND 
   enc.PracticeID = @PracticeID
INNER JOIN dbo.EncounterDiagnosis AS ed ON
   ed.vendorID = enc.VendorID AND 
   enc.VendorImportID = @VendorImportID   
INNER JOIN dbo.[_import_4_1_patient] as pd ON 
    pd.patientlegacyaccountnumber = enc.vendorID AND 
	enc.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	 

PRINT ''
PRINT 'Inserting Into Encounter Procedure...'
INSERT INTO dbo.EncounterProcedure
        ( 
		  EncounterID ,
          ProcedureCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ServiceChargeAmount ,   
          ServiceUnitCount ,
          ProcedureDateOfService ,
          PracticeID ,
          EncounterDiagnosisID1 ,
          ServiceEndDate ,
          VendorID ,
          VendorImportID ,
          TypeOfServiceCode ,
          AnesthesiaTime ,
          AssessmentDate ,
          DoctorID ,
          ConcurrentProcedures 
        )
SELECT DISTINCT
          enc.EncounterID  , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pd.patientbalance , -- ServiceChargeAmount - money   
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
   pcd.OfficialName = 'Balance Forward' AND 
   enc.PracticeID = @PracticeID
INNER JOIN dbo.EncounterDiagnosis AS ed ON
   ed.vendorID = enc.VendorID AND 
   enc.VendorImportID = @VendorImportID   
INNER JOIN dbo.[_import_5_1_Patient2] as pd ON 
    pd.patientlegacyaccountnumber = enc.vendorID AND 
	enc.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	   

DROP TABLE #temppolid

--ROLLBACK
--COMMIT
