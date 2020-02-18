USE superbill_19631_dev
--USE superbill_19631_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 26
SET @VendorImportID = 39

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

CREATE TABLE #tempinsco
(
		Name VARCHAR(128)
)


PRINT ''
PRINT 'Inserting Into #tempinsco 1 of 2'
INSERT INTO #tempinsco
( 
		Name 
)
SELECT DISTINCT insuranceplan  -- Name - varchar(128)
FROM dbo.[_import_39_26_ElationPatients] i
INNER JOIN dbo.Patient p ON
p.FirstName = i.firstname AND
p.LastName = i.lastname AND
p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) AND
p.PracticeID = @PracticeID
WHERE i.insuranceplan <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into #tempinsco 2 of 2'
INSERT INTO #tempinsco
( 
		Name 
)
SELECT DISTINCT i.secondaryinsuranceplan  -- Name - varchar(128)
FROM dbo.[_import_39_26_ElationPatients] i
INNER JOIN dbo.Patient p ON
p.FirstName = i.firstname AND
p.LastName = i.lastname AND
p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) AND
p.PracticeID = @PracticeID
WHERE secondaryinsuranceplan <> '' AND NOT EXISTS (SELECT * FROM dbo.[_import_39_26_ElationPatients] ii WHERE i.secondaryinsuranceplan = ii.insuranceplan)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Insurance Company...'
UPDATE dbo.InsuranceCompany 
SET VendorID = Name
FROM #tempinsco i
INNER JOIN dbo.InsuranceCompany ic ON
i.Name = ic.InsuranceCompanyName AND
ic.CreatedPracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Insurance Company'
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
		  Name ,
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
          name ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18
FROM #tempinsco i
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE i.Name = ic.VendorID AND ic.CreatedPracticeID = @PracticeID)
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
		  ic.InsuranceCompanyName ,
          GETDATE() ,
          0 ,
          GETANSINULL() ,
          0 ,
          @PracticeID ,
          ic.InsuranceCompanyID ,
          ic.VendorID ,
          @VendorImportID 
FROM dbo.InsuranceCompany ic
INNER JOIN #tempinsco i ON
ic.InsuranceCompanyName = i.Name
WHERE ic.CreatedPracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DROP TABLE #tempinsco

PRINT ''
PRINT 'Updating Patient MRN...'
UPDATE dbo.Patient 
SET MedicalRecordNumber = i.id
FROM dbo.[_import_39_26_ElationPatients] i
INNER JOIN dbo.Patient p ON 
i.firstname = p.FirstName AND 
i.lastname = p.LastName AND
DATEADD(hh,12,CAST(i.dob AS DATETIME)) = p.DOB AND
p.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

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
          WorkPhone ,
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
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          i.FirstName ,
          i.MiddleName ,
          i.LastName ,
          '' ,
          i.AddressLine1 ,
          i.AddressLine2 ,
          i.City ,
          i.[State] ,
          '' ,
          CASE 
			WHEN LEN(REPLACE(i.zip,'-','')) IN (4,8) THEN '0' + REPLACE(i.zip,'-','')
			WHEN LEN(REPLACE(i.zip,'-','')) IN (5,9) THEN REPLACE(i.zip,'-','')
		  ELSE '' END ,
          CASE	
			WHEN i.gender = 'N' THEN 'U' ELSE i.gender
		  END ,
          REPLACE(i.homephone,'-','') ,
          REPLACE(i.workphone,'-','') ,
          CASE
			WHEN ISDATE(i.dob) = 1 THEN i.dob 
		  ELSE NULL END ,
          CASE WHEN LEN(i.ssn) >= 6 THEN RIGHT('000' + i.ssn, 9) ELSE '' END ,
          i.email ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          'U' ,
          i.id ,
          REPLACE(i.cellphone,'-','') ,
          143 ,
          i.id ,
          @VendorImportID ,
          1 ,
          CASE
			WHEN i.email <> '' THEN 1 
		  ELSE 0 END ,
          0 
FROM dbo.[_import_39_26_ElationPatients] i
WHERE NOT EXISTS (SELECT * FROM dbo.Patient p WHERE i.id = p.MedicalRecordNumber AND p.PracticeID = @PracticeID)
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
          p.PatientID , -- PatientID - int
         'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          p.MedicalRecordNumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient as p
INNER JOIN dbo.[_import_39_26_ElationPatients] i ON
p.FirstName = i.firstname AND
p.LastName = i.lastname AND
p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) AND
p.PracticeID = @PracticeID AND
i.insuranceplan <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 1 of 2...'
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
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          1 ,
          i.insurancememberid ,
          i.insurancegroup ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.'  ,
          1 ,
          @PracticeID ,
          i.id + i.insurancememberid ,
          @VendorImportID ,
          'Y' 
FROM dbo.[_import_39_26_ElationPatients] i
INNER JOIN dbo.PatientCase pc ON
pc.VendorID = i.id AND 
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
icp.VendorID = i.insuranceplan AND
icp.CreatedPracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 2 of 2...'
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
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          2 ,
          i.secondaryinsurancememberid ,
          i.secondaryinsurancegroup ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.'  ,
          1 ,
          @PracticeID ,
          i.id + i.secondaryinsurancememberid ,
          @VendorImportID ,
          'Y' 
FROM dbo.[_import_39_26_ElationPatients] i
INNER JOIN dbo.PatientCase pc ON
pc.VendorID = i.id AND 
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
icp.VendorID = i.secondaryinsuranceplan AND
icp.CreatedPracticeID = @PracticeID
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
SELECT DISTINCT
	      GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          'Kareo' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          i.notes , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_39_26_ElationPatients] i
INNER JOIN dbo.Patient p ON
i.id = p.MedicalRecordNumber AND
p.PracticeID = @PracticeID
WHERE i.notes <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




--COMMIT
--ROLLBACK

