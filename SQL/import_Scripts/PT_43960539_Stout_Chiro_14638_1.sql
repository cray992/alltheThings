--USE superbill_14638_dev
USE superbill_14638_prod
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

-- NUKE Standard fee schedules based on providers being nuked for this import
DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT)
INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID) 
(
	SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE Notes = 'Vendor Import '+ CAST(@VendorImportID AS VARCHAR)
)
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'
PRINT '    '

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
PRINT 'Inserting into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          Fax ,
          ContactFirstName ,
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
		  ic.[company] , -- InsuranceCompanyName - varchar(128)
          ic.[address] , -- AddressLine1 - varchar(256)
          ic.[address2] , -- AddressLine2 - varchar(256)
          ic.[city] , -- City - varchar(128)
          ic.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(ic.[zip], '-', ''), 9) ,-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(ic.phone,'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(ic.fax,'(',''),')',''),'-',''),10),-- Fax - varchar(10)
          ic.contact ,
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
          ic.id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_1_1_paaCarrier] ic
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
		  Fax ,
		  ContactFirstName ,
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
		  icp.fax ,
		  icp.ContactFirstName ,
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
          MobilePhone ,
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
          pd.[firstname] , -- FirstName - varchar(64)
          pd.[mi] , -- MiddleName - varchar(64)
          pd.[lastname] , -- LastName - varchar(64)
          '',
          pd.[address] , -- AddressLine1 - varchar(256)
          pd.[address2] , -- AddressLine2 - varchar(256)
          pd.[city] , -- City - varchar(128)
          pd.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          pd.[zip]  , -- ZipCode - varchar(9)
          pd.sex , -- Gender - varchar(1)
          CASE WHEN pd.maritalstatid = 1 THEN  'S'
			   WHEN pd.maritalstatid = 2 THEN 'M'
			   ELSE '' END  ,  -- MaritalStatus
          LEFT(REPLACE(REPLACE(REPLACE(pd.homephone,'(',''),')',''),'-',''),10), -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(pd.workphone,'(',''),')',''),'-',''),10),-- WorkPhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(pd.cellphone,'(',''),')',''),'-',''),10),-- WorkPhoneExt - varchar(10)
          CASE WHEN pd.dob > GETDATE() THEN DATEADD(yy, -100, pd.dob) 
			   ELSE pd.dob END , -- DOB - datetime
          LEFT(REPLACE(pd.ssn,'-',''),9) , -- SSN - char(9)
          pd.email , -- EmailAddress - varchar(256)
          pd.emercontact , --Emergency Contact
          pd.emerphone , -- Emergency Phone
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pd.acctno , -- MedicalRecordNumber - varchar(128)
          pd.id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          1  -- PhonecallRemindersEnabled - bit
FROM [dbo].[_import_1_1_paaPatient] pd
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
          note.note  -- NoteMessage - varchar(max)
FROM dbo.[_import_1_1_paaPatientNote] note 
LEFT JOIN dbo.Patient pat ON 
	note.patientid = pat.VendorID
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
          'Default Case' , -- Name - varchar(128)
          1 ,
          5 , -- PayerScenarioID - int
          'Created via Import. Please Review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          p.VendorID, -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.Patient p
WHERE p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Cases records inserted'



PRINT ''
PRINT 'Inserting into Insurance Policy  ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          GroupName ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          Copay ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          ip.precedence , -- Precedence - int
          LEFT(ip.idnum, 32) , -- PolicyNumber - varchar(32)
          LEFT(ip.groupno, 32) , -- GroupNumber - varchar(32)
          LEFT(ip.groupname, 14) , -- GroupName
          'S' ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- Notes - text
          ip.copayamt ,
          @PracticeID , -- PracticeID - int
          ip.id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_paaPatientIns2] ip
JOIN dbo.patient pat ON
	ip.patientid = pat.MedicalRecordNumber AND
	pat.VendorImportID = pat.VendorImportID 
JOIN dbo.PatientCase pc ON
	pat.PatientID = pc.PatientID AND 
	pc.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.carrierid = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--StandardFeeSchedule
PRINT ''
PRINT 'Inserting in a new StandardFeeSchedule ...'
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
          'f' , -- SourceType - char(1)
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
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--StandardFee
PRINT ''
PRINT 'Inserting in Standard Fees ...'
INSERT INTO dbo.ContractsAndFees_StandardFee
    ( StandardFeeScheduleID ,
      ProcedureCodeID ,
      ModifierID ,
      SetFee ,
      AnesthesiaBaseUnits
    )
SELECT DISTINCT
      c.StandardFeeScheduleID , -- StandardFeeScheduleID - int
      pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
      0 , -- ModifierID - int
      impSFS.unitprice , -- SetFee - money
      0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_1_1_FeeScheduleMaybe] impSFS
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule c ON
	CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
	c.practiceID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	impSFS.cptcode = pcd.ProcedureCode AND
	impSFS.unitprice <> ''	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--StandardFeeScheduleLink
PRINT ''
PRINT 'Inserting in Standard Fee Schedule Link ...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
    ( ProviderID ,
      LocationID ,
      StandardFeeScheduleID
    )
SELECT DISTINCT
      doc.DoctorID , -- ProviderID - int
      sl.ServiceLocationID , -- LocationID - int
      sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs 
WHERE doc.PracticeID = @PracticeID AND
	doc.[External] = 0 AND 
	sl.PracticeID = @PracticeID AND
	CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	sfs.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




COMMIT