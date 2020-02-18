--USE superbill_14127_dev
USE superbill_14127_prod
GO


 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))


DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientJournalNote records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'




PRINT ''
PRINT 'Inserting into Insurance Company 1..'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
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
          DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  ic.patientinspkgname , -- InsuranceCompanyName - varchar(128)
          ic.[patientinspkgaddrs1]  , -- AddressLine1 - varchar(256)
          ic.[patientinspkgaddrs2] , -- AddressLine2 - varchar(256)
          ic.[patientinspkgcity] , -- City - varchar(128)
          ic.[patientinspkgstate] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(ic.[patientinspkgzip], '-', ''), 9) ,-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(ic.[patientinspkgphn],'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13, -- SecondaryPrecedenceBillingFormID - int
          ic.[patientinspkgid] , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_1_1_printcsvreportsinsruance2] ic
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records inserted'




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
		  Phone ,
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
		  icp.phone ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          icp.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany icp 
WHERE icp.CreatedPracticeID = @PracticeID AND 
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--Patient
PRINT ''
PRINT 'Inserting into Patient'
INSERT INTO dbo.Patient
        ( PracticeID ,
		  Prefix,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          EmergencyName ,
          EmergencyPhone ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
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
		  '',
          pd.[patientfirstname] , -- FirstName - varchar(64)
          pd.[patientmiddleinitial] , -- MiddleName - varchar(64)
          pd.[patientlastname] , -- LastName - varchar(64)
          '',
          pd.[patientaddress1] , -- AddressLine1 - varchar(256)
          pd.[patientaddress2] , -- AddressLine2 - varchar(256)
          pd.[patientcity] , -- City - varchar(128)
          pd.[patientstate] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(pd.[patientzip], '-', ''), 9)  , -- ZipCode - varchar(9)
          pd.[patientsex] , -- Gender - varchar(1)
          CASE WHEN pd.[patientmaritalstatus]  = 'MARRIED' THEN 'M'
			   WHEN pd.[patientmaritalstatus] = 'SINGLE' THEN 'S'
			   WHEN pd.[patientmaritalstatus] = 'DIVORCED' THEN 'D'
			   WHEN pd.[patientmaritalstatus] = 'SEPARATED' THEN 'L'
			   WHEN pd.[patientmaritalstatus] = 'WIDOWED'  THEN 'W'
			   ELSE '' END  ,  -- MaritalStatus
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pd.[patientmobileno],'(',''),')',''),'-',''), ' ', ''), 10), -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pd.[patientworkphone],'(',''),')',''),'-',''), ' ', ''), 10),-- WorkPhone - varchar(10)
          pd.[patientdob] , -- DOB - datetime
          LEFT(REPLACE(pd.[patientssn],'-',''),9) , -- SSN - char(9)
          pd.[patientemail] , -- EmailAddress - varchar(256)
          pd.[ptntemrgncycntctname] , --Emergency Contact
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pd.[ptntemrgncycntctph],'(',''),')',''),'-',''), ' ', ''), 10) , -- Emergency Phone
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pd.patientid , -- MedicalRecordNumber - varchar(128)
          pd.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          1  -- PhonecallRemindersEnabled - bit
FROM [dbo].[_import_1_1_printcsvreports] pd
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records inserted'



PRINT ''
PRINT 'Inserting into PatientJournalNote ...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          NoteMessage           
        )
SELECT	  GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          note.[patientnotes]  -- NoteMessage - varchar(max)
FROM dbo.[_import_1_1_printcsvreports] note 
LEFT JOIN dbo.Patient pat ON 
	note.patientid = pat.VendorID
WHERE note.[patientnotes] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Patient Cases'
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
		   p.PatientID, -- PatientID - int
          CASE WHEN ip.patientprimaryinspkgname = '*SELF PAY*' THEN 'Self Pay' 
			ELSE  'Case: ' + ip.patientprimaryinspkgname END , -- Name - varchar(128)
          1 ,
          CASE WHEN ip.patientprimaryinspkgname = '*SELF PAY*' THEN 11 ELSE 5 END , -- PayerScenarioID - int
          'Created via Import. Please Review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          ip.AutoTempID, -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.[_import_1_1_printcsvreportsinsruance2] ip 
LEFT JOIN dbo.Patient p ON
	ip.patientid = p.VendorID AND
	p.VendorImportID = @VendorImportID
WHERE p.VendorImportID = @VendorImportID AND
	ip.patientprimaryinspkgname <> '*SELF PAY*'
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Cases records inserted'


PRINT ''
PRINT 'Inserting into Patient Cases'
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
SELECT  pat.PatientID , -- PatientID - int
          'Self Pay' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
          'Created via data import, please review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pat
WHERE pat.PatientID NOT IN (SELECT PatientID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Cases records inserted'



PRINT ''
PRINT 'Inserting into Insurance Policy  ...'
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
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          ip.patientprimarypolicyidnumber , -- PolicyNumber - varchar(32)
          ip.patientprimarypolicygrpnu , -- GroupNumber - varchar(32)
          's',      
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- Notes - text
          @PracticeID , -- PracticeID - int
          ip.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_printcsvreportsinsruance2] ip
JOIN dbo.[_import_1_1_printcsvreports] imppat ON 
	imppat.patientid = ip.patientid
JOIN dbo.PatientCase pc ON
	ip.AutoTempID = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.patientprimaryinspkgname = icp.PlanName AND
	ip.patientprimaryinspkgid = icp.VendorID AND 	
	icp.VendorImportID = @VendorImportID
WHERE pc.Name <> 'Self Pay'
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Insurance Policy  2...'
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
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          ip.patientsecondarypolicyidn , -- PolicyNumber - varchar(32)
          ip.patientsecondarypolicygrp , -- GroupNumber - varchar(32)
          's',      
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- Notes - text
          @PracticeID , -- PracticeID - int
          ip.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_printcsvreportsinsruance2] ip
JOIN dbo.[_import_1_1_printcsvreports] imppat ON 
	imppat.patientid = ip.patientid
JOIN dbo.PatientCase pc ON
	ip.AutoTempID = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.patientsecondaryinspkgname = icp.PlanName AND
	ip.patientsecondaryinspkgid = icp.VendorID AND 	
	icp.VendorImportID = @VendorImportID
WHERE pc.Name <> 'Self Pay' AND
	ip.patientsecondaryinspkgname <> '*SELF PAY*'
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT