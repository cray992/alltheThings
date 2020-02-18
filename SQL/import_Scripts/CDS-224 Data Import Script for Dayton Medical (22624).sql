USE superbill_22624_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 4

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@@ROWCOUNT AS VARCHAR(10)) 


DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


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
          HomePhone ,
		  HomePhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
		  EmploymentStatus
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          middleinitial , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          suffix , -- Suffix - varchar(16)
          street1 , -- AddressLine1 - varchar(256)
          street2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
			WHEN LEN(zipcode) IN (5,9) THEN zipcode
			WHEN LEN(zipcode) = 4 THEN '0' + zipcode
		ELSE '' END , -- ZipCode - varchar(9)
          gender , -- Gender - varchar(1)
          LEFT(homephone, 10) , -- HomePhone - varchar(10)
		  CASE
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(homephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(homephone))),10)
			ELSE NULL END , --HomePhoneExt
          CASE
			WHEN ISDATE(dateofbirth) = 1 THEN dateofbirth
			ELSE NULL END   , -- DOB - datetime
          CASE
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(socialsecuritynumber)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(socialsecuritynumber), 9)
			ELSE NULL END  , -- SSN - char(9)
          email , -- EmailAddress - varchar(256)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          2 , -- DefaultServiceLocationID - int
          chartnumber , -- MedicalRecordNumber - varchar(128)
          cellphone , -- MobilePhone - varchar(10)
          chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE activestatusyesorno WHEN 'Y' THEN 1
								   WHEN 'N' THEN 0
								   WHEN 0 THEN 0
								   WHEN 1 THEN 1
								   ELSE 1 END ,-- Active - bit
		  'U' -- Employment Status
FROM dbo.[_import_4_2_PatientDemographics] 
WHERE firstname <> '' AND lastname <> ''
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
		0 , -- CreatedUserID - int
		GETDATE() , -- ModifiedDate - datetime
		0 , -- ModifiedUserID - int
		pat.PatientID , -- PatientID - int
		'Kareo' , -- UserName - varchar(128)
		'K' , -- SoftwareApplicationID - char(1)
		0 , -- Hidden - bit
		'Created via data import. Please verify before use.' , -- NoteMessage - varchar(max)
		0, -- AccountStatus - bit
		1 , -- NoteTypeCode - int
		0-- LastNote - bit
FROM dbo.[_import_4_2_PatientDemographics] AS imppat
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = imppat.chartnumber AND
	pat.VendorImportID = @VendorImportID
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
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	pat.PatientID , -- PatientID - int
	'Kareo' , -- UserName - varchar(128)
	'K' , -- SoftwareApplicationID - char(1)
	0 , -- Hidden - bit
	imppat.patientnote, -- NoteMessage - varchar(max)
	0, -- AccountStatus - bit
	1 , -- NoteTypeCode - int
	0-- LastNote - bit
FROM dbo.[_import_4_2_PatientDemographics] AS imppat
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = imppat.chartnumber AND
	pat.VendorImportID = @VendorImportID
WHERE imppat.patientnote <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient Case...'
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
		PAT.PatientID , -- PatientID - int
		'Default Case'	, -- Name - varchar(128)
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
		PAT.VendorID , -- VendorID - varchar(50)
		@VendorImportID , -- VendorImportID - int
		0, -- PregnncyRelatedFlag - bit
		1, -- StatementActive - bit
		0, -- EPSDT - bit
		0, -- FamilyPlanning - bit
		1 , -- EPSDTCodeID - int
		0 , -- EmergencyRelated - bit
		0 -- HomeboundRelatedFlag
FROM dbo.Patient PAT
WHERE VendorImportID = @VendorImportId
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Policy 1...'
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
		  Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          imp.policynumber1 , -- PolicyNumber - varchar(32)
          imp.groupnumber1 , -- GroupNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          PC.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_2_PatientDemographics] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.chartnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.insurancecode1 AND
	icp.VendorImportID = 3
WHERE imp.defaultcase <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Policy 2...'
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
		  Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          imp.policynumber2, -- PolicyNumber - varchar(32)
          imp.groupnumber2 , -- GroupNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          PC.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_2_PatientDemographics] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.chartnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.insurancecode2 AND
	icp.VendorImportID = 3
WHERE imp.case2 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into Insurance Policy 3...'
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
		  Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          imp.policynumber3, -- PolicyNumber - varchar(32)
          imp.groupnumber3 , -- GroupNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          PC.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_2_PatientDemographics] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.chartnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.insurancecode3 AND
	icp.VendorImportID = 3
WHERE imp.case3 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



--ROLLBACK
--COMMIT

