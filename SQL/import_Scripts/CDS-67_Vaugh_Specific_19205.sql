--USE superbill_19205_dev
USE superbill_19205_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 5 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))


DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.PatientAlert WHERE patientid IN (SELECT patientid FROM dbo.Patient WHERE vendorimportid = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'

	
UPDATE dbo.[_import_5_1_patientdemo]
	SET patientcity = (SELECT city2 FROM dbo.[_import_5_1_cityneedspaces] WHERE city1 = p.patientcity)
	from dbo.[_import_5_1_patientdemo] p	
	WHERE p.patientcity IN (SELECT city1 FROM dbo.[_import_5_1_cityneedspaces])
	
UPDATE dbo.[_import_5_1_patientdemo]
	SET medicalrecord = 308890
	WHERE medicalrecord = 'Account No:308890'
	
	
PRINT ''
PRINT 'Updating Patient.....'
UPDATE dbo.Patient
	SET DOB = (SELECT patientdob FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord  AND AutoTempID <> '4682'),
		SSN = (SELECT LEFT(patientssn, 9) FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord AND AutoTempID <> '4682' ),
		Gender = (SELECT CASE patientgender WHEN 'M' THEN 'M'
											WHEN 'F' THEN 'F'
											ELSE 'U' END FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord  AND AutoTempID <> '4682' ),
		MaritalStatus = (SELECT CASE patientmarriage WHEN 'Married' then 'M'
													 WHEN 'Never Married' THEN 'S'
													 WHEN 'Divorced' THEN 'D'
													 WHEN 'Domestic Partner' THEN 'T'
													 WHEN 'Widowed' THEN 'W'
													 ELSE '' END FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord  AND AutoTempID <> '4682' ),
		AddressLine1 = (SELECT patientaddress1 FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord  AND AutoTempID <> '4682' ),
		addressline2 = (SELECT patientaddress2 FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord  AND AutoTempID <> '4682' ),
		city = (SELECT patientcity FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord  AND AutoTempID <> '4682' ),
		State = (SELECT LEFT(patientstate, 2) FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord  AND AutoTempID <> '4682' ),
		ZipCode = (SELECT patientzip FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord  AND AutoTempID <> '4682' ),
		HomePhone = (SELECT LEFT(patienthomephone, 10) FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord  AND AutoTempID <> '4682' ),
		MobilePhone = (SELECT LEFT(patientmobile, 10) FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord  AND AutoTempID <> '4682' ),
		EmploymentStatus = (SELECT CASE patientemploymentstatus WHEN 'Employed' THEN 'E'
																WHEN 'Retired' THEN 'R'
																ELSE 'U' END FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord  AND AutoTempID <> '4682' ),
		WorkPhone = (SELECT patientworkphone FROM dbo.[_import_5_1_patientdemo] WHERE pat.vendorid = medicalrecord  AND AutoTempID <> '4682' ),
		ModifiedDate = GETDATE()
	FROM dbo.Patient pat 	
	WHERE pat.PracticeID = 1 AND pat.patientid <> 2361	AND
		pat.ModifiedDate < '2013-09-11 07:00:00.000'
PRINT CAST(@@rowcount AS VARCHAR) + ' records updated'



PRINT ''
PRINT 'Inserting into Patient'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          patienttitle , -- Prefix - varchar(16)
          patientfirstname , -- FirstName - varchar(64)
          patientmiddleinitial , -- MiddleName - varchar(64)
          patientlastname , -- LastName - varchar(64)
          patientsuffix , -- Suffix - varchar(16)
          patientaddress1 , -- AddressLine1 - varchar(256)
          patientaddress2 , -- AddressLine2 - varchar(256)
          patientcity , -- City - varchar(128)
          LEFT(patientstate, 2) , -- State - varchar(2)
          LEFT(REPLACE(REPLACE(patientzip, ' ', ''), '-', ''), 9) , -- ZipCode - varchar(9)
          CASE patientgender WHEN 'M' THEN 'M'
									WHEN 'F' THEN 'F'
									ELSE 'U' END , -- Gender - varchar(1)
          CASE patientmarriage WHEN 'Married' THEN 'M'
							   WHEN 'Domestic Partner' THEN 'T'
							   WHEN 'Divorced' THEN 'D'
							   WHEN 'Widowed' THEN 'W'
							   WHEN 'Never Married' THEN 'S'
							   ELSE '' END	, -- MaritalStatus - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(patienthomephone, '(', ''), ')', ''), '-', ''), 10) , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(patientworkphone, '(', ''), ')', ''), '-', ''), 10) , -- WorkPhone - varchar(10)
          patientdob , -- DOB - datetime
          patientssn , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE patientemploymentstatus WHEN 'Employed' THEN 'E'
									   WHEN 'Retired' THEN 'R'
									   ELSE 'U' END , -- EmploymentStatus - char(1)
          medicalrecord , -- MedicalRecordNumber - varchar(128)
          LEFT(REPLACE(REPLACE(REPLACE(patientmobile, '(', ''), ')', ''), '-', ''), 10) , -- MobilePhone - varchar(10)
          medicalrecord , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_5_1_patientdemo]
WHERE medicalrecord NOT IN (SELECT vendorid FROM dbo.Patient WHERE vendorImportID = 2)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Patient Alert...'
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
SELECT    pat.PatientID , -- PatientID - int
          impalert.alert , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_5_1_patientdemo] impalert
INNER JOIN dbo.Patient pat ON 
           impalert.medicalrecord = pat.MedicalRecordNumber
WHERE impalert.alert <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR) + ' records inserted'          
           


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
SELECT    PatientID  , -- PatientID - int
          'Default Case 2' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import. Please Review before using.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID, -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient
PRINT CAST (@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into InsurancePolicy ...'
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
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          imp.policy , -- PolicyNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          imp.copay , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          medicalrecord , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_5_1_patientdemo] imp
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorID = imp.medicalrecord AND
	pc.VendorImportID = 5
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.PlanName = imp.insuranceco AND
	icp.InsuranceCompanyPlanID NOT IN (213, 214, 215, 216, 218, 171, 220)
PRINT CAST (@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Patient Case.....'
UPDATE dbo.patientcase 
SET PayerScenarioID = 11
WHERE PayerScenarioID = 5 AND 
	Vendorimportid = @vendorimportid AND 
	PatientCaseID NOT IN (SELECT PatientCaseID  FROM dbo.InsurancePolicy)
PRINT CAST(@@ROWCOUNT AS VARchar) + ' records inserted'																	 


COMMIT

