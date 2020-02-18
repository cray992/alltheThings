USE superbill_27869_dev
--USE superbill_27869_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID8 INT
DECLARE @Practice8VendorImportID INT

SET @PracticeID8 = 8
SET @Practice8VendorImportID = 8


PRINT ''
PRINT ''
PRINT 'PracticeID = ' + CAST(@PracticeID8 AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@Practice8VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID8 AND VendorImportID = @Practice8VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID8 AND VendorImportID = @Practice8VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID8 AND VendorImportID = @Practice8VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'

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
          WorkPhone ,
          PagerPhone ,
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
          [External] ,
          NPI 
        )
SELECT DISTINCT
	      @PracticeID8 , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          referringfirstname , -- FirstName - varchar(64)
          referringmiddleinitial , -- MiddleName - varchar(64)
          referringlastname , -- LastName - varchar(64)
          referringsuffix , -- Suffix - varchar(16)
		  referringsocialsecurity , -- SSN 
          referringaddress1 , -- AddressLine1 - varchar(256)
          referringaddress2 , -- AddressLine2 - varchar(256)
          referringcity , -- City - varchar(128)
          referringstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(referringzipcode,'-','') , -- ZipCode - varchar(9)
          referringphone , -- WorkPhone - varchar(10)
		  referringpager , -- Pager
		  referringemail , -- Email
          CASE WHEN referringupin = '' THEN '' ELSE 'Upin: ' + referringupin + CHAR(13) + CHAR(10) END +
		 (CASE WHEN referringtaxid = '' THEN '' ELSE 'TaxID: ' + referringtaxid + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN referringnotes = '' THEN '' ELSE 'Notes: ' + referringnotes END) , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          referringcredentials , -- Degree - varchar(8)
          referringidentity , -- VendorID - varchar(50)
          @Practice8VendorImportID , -- VendorImportID - int
          referringfax , -- FaxNumber - varchar(10)
          1 , -- External - bit
          referringnpi  -- NPI - varchar(10)
FROM dbo.[_import_8_8_ReferringMaster]
WHERE referringidentity <> ''
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
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt 
        )
SELECT DISTINCT
		  @PracticeID8 , -- PracticeID - int
          rd.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.patientfirstname , -- FirstName - varchar(64)
          i.patientmiddleinitial , -- MiddleName - varchar(64)
          i.patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.patientaddress1 , -- AddressLine1 - varchar(256)
          i.patientaddress2 , -- AddressLine2 - varchar(256)
          i.patientcity , -- City - varchar(128)
          i.patientstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
           CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)
                WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)
            ELSE '' END , -- ZipCode - varchar(9)
          CASE i.patientsex WHEN 'Female' THEN 'F'
							WHEN 'Male' THEN 'M'
							ELSE 'U' END , -- Gender - varchar(1)
          CASE i.patientmaritalstatus WHEN 'Married' THEN 'M'
									  WHEN 'Separated' THEN 'L'
									  WHEN 'Divorced' THEN 'D'
									  WHEN 'Widowed' THEN 'W'
									  WHEN 'Partnered' THEN 'T'
									  WHEN 'Single' THEN 'S'
									  ELSE '' END  , -- MaritalStatus - varchar(1)
	      CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientphone))>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientphone),10) ELSE '' END , -- HomePhone - varchar(10)
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientphone))),10)
		  ELSE NULL END  , -- HomePhoneExt - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone))>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone),10) ELSE '' END , -- WorkPhone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone))),10)
		  ELSE NULL END , -- WorkPhoneExt - varchar(10)
          CONVERT(DATETIME,i.PatientDateOfBirth,102) , -- DOB - datetime
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientsocialsecurity)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.patientsocialsecurity), 9)
		  ELSE NULL END  , -- SSN - char(9)
          i.patientemailaddress , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.patientemployercode <> '' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
          i.patientaccountnumber , -- MedicalRecordNumber - varchar(128)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone))>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone),10) ELSE '' END , -- MobilePhone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone))),10)
		  ELSE NULL END , -- MobilePhoneExt - varchar(10)
          i.patientaccountnumber , -- VendorID - varchar(50)
          @Practice8VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
          i.patientemergencyfirstname + ' ' + i.patientemergencymiddleinitial + ' ' + i.patientlastname + CASE WHEN i.patientemergencyrelationship <> '' THEN ' | ' + i.patientemergencyrelationship ELSE '' END , -- EmergencyName - varchar(128)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientemergencyphone))>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientemergencyphone),10) ELSE '' END, -- EmergencyPhone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientemergencyphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientemergencyphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientemergencyphone))),10)
		  ELSE NULL END   -- EmergencyPhoneExt - varchar(10)
FROM dbo.[_import_8_8_DodisKohanMDPC8]  i
	LEFT JOIN dbo.Doctor rd ON
		i.patientreferringcode = rd.VendorID AND
		rd.VendorImportID = @Practice8VendorImportID
WHERE i.patientaccountnumber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



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
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
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
          @PracticeID8 , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @Practice8VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient 
WHERE VendorImportID = @Practice8VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'End of Import'

--COMMIT
--ROLLBACK


