--USE superbill_14029_dev
USE superbill_14029_prod
GO

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
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted '
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted '
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted '
PRINT ''

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@rowcount AS VARCHAR(10)) + ' PatientJournalNote records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@rowcount AS VARCHAR(10)) + ' PatientJournalNote records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'



--InsuranceCompany
PRINT ''
PRINT 'Inserting into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
          Fax ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CompanyTextID ,
          ClearinghousePayerID ,
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
SELECT    
		  ins.insurance_name , -- InsuranceCompanyName - varchar(128)
          '' , -- Notes - text
          ins.insurance_address1 , -- AddressLine1 - varchar(256)
          ins.insurance_address2 , -- AddressLine2 - varchar(256)
          ins.insurance_city , -- City - varchar(128)
          st.user_code , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(ins.insurance_zip_cd, '-', ''), 9) , -- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(ins.insurance_phone_no, '(', ''), ')', ''), '-', ''), 9) , -- Phone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(ins.insurance_fax_no, '(', ''), ')', ''), '-', ''), 9) , -- Fax - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          1 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          '' , -- CompanyTextID - varchar(10)
          0 , -- ClearinghousePayerID - int
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          ins.insurance_no , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo._import_1_1_insurance ins
LEFT JOIN dbo._import_1_1_code st ON 
	ins.state_cd = st.code 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--InsuranceCompanyPlan
PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          KareoLastModifiedDate ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT 
		  icp.plan_name , -- PlanName - varchar(128)
          ic.AddressLine1 , -- AddressLine1 - varchar(256)
          ic.AddressLine2 , -- AddressLine2 - varchar(256)
          ic.City , -- City - varchar(128)
          ic.State , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ic.ZipCode , -- ZipCode - varchar(9)
          ic.Phone , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ic.fax , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)
          GETDATE() , -- KareoLastModifiedDate - datetime
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.plan_no , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo._import_1_1_insurance_plans icp
INNER JOIN dbo.InsuranceCompany ic ON 
	icp.insurance_no = ic.VendorID AND
	ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Doctor ...'
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
          Notes ,
          EmailAddress ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          UserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          refdoc.refer_first_name , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          refdoc.refer_last_name , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          refdoc.refer_address1 , -- AddressLine1 - varchar(256)
          refdoc.refer_address2 , -- AddressLine2 - varchar(256)
          refdoc.refer_city , -- City - varchar(128)
          'NC' , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(refdoc.refer_zip_code, '-', ''), 9) , -- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(refdoc.refer_phone, '(', ''), ')', ''), '-', ''), 10) , -- WorkPhone - varchar(10)
          'UPINUSINNO: ' + refdoc.refer_upin_usin_no , -- Notes - text
          refdoc.refer_email , 
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- UserID - int
          'DR.' , -- Degree - varchar(8)
          refdoc.refer_no , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
           LEFT(REPLACE(REPLACE(REPLACE(refdoc.refer_fax, '(', ''), ')', ''), '-', ''), 10) , -- FaxNumber - varchar(10)
          1 , -- External - bit
          refdoc.npi_num  -- NPI - varchar(10)
FROM dbo._import_1_1_referring_professional refdoc
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--Patient

PRINT ''
PRINT 'Inserting into Patient ...'
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
          MaritalStatus ,
          HomePhone ,
          MobilePhone ,
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
          MedicalRecordNumber ,
          PrimaryProviderID ,
          VendorID ,
          VendorImportID ,
          Active ,
          PhonecallRemindersEnabled 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.first_name , -- FirstName - varchar(64)
          pat.mid_name , -- MiddleName - varchar(64)
          pat.last_name , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pa.address1 , -- AddressLine1 - varchar(256)
          pa.address2 , -- AddressLine2 - varchar(256)
          pa.city , -- City - varchar(128)
          st.user_code , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(pa.zip, '-', ''), 9) , -- ZipCode - varchar(9)
          CASE WHEN pat.sex = 1 THEN 'F' ELSE 'M'  END , -- Gender - varchar(1)
          CASE WHEN ms.user_code = 'X' THEN 'L'
				ELSE ms.user_code END , -- MaritalStatus - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(pat.day_phone, '(', ''), '-', ''), ')', ''), 10) , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(pat.cell_phone, '(', ''), '-', ''), ')', ''), 10) , -- MobilePhone - varchar(10)
          pat.birth_date , -- DOB - datetime
          LEFT(REPLACE(pat.ss_no, '-', ''), 9) , -- SSN - char(9)
          pat.email_address , --email address
          CASE WHEN pat.patient_no <> pat.guarantor_no THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN pat.patient_no <> pat.guarantor_no THEN guar.first_name END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN pat.patient_no <> pat.guarantor_no THEN guar.mid_name END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN pat.patient_no <> pat.guarantor_no THEN guar.last_name END , -- ResponsibleLastName - varchar(64)
          '' , -- ResponsibleSuffix - varchar(16)
          CASE WHEN pat.relation_to_guarantor_no IN (335, 656, 664) THEN 'S'
			   WHEN	pat.relation_to_guarantor_no = 531 THEN 'U'
			   ELSE 'C' END  , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN pat.patient_no <> pat.guarantor_no THEN guaradd.address1 END  , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN pat.patient_no <> pat.guarantor_no THEN guaradd.address2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN pat.patient_no <> pat.guarantor_no THEN guaradd.city END , -- ResponsibleCity - varchar(128)
          CASE WHEN pat.patient_no <> pat.guarantor_no THEN gst.user_code END , -- ResponsibleState - varchar(2)
          '' , -- ResponsibleCountry - varchar(32)
          CASE WHEN pat.patient_no <> pat.guarantor_no THEN LEFT(REPLACE(guaradd.zip, '-', ''), 9) END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.chart_no , -- MedicalRecordNumber - varchar(128)
          1 ,
          pat.patient_no , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          1  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_1_1_patient] pat 
LEFT JOIN dbo.[_import_1_1_patient] guar ON
	pat.guarantor_no = guar.patient_no 
LEFT JOIN dbo.[_import_1_1_address] pa ON
	pat.address_no = pa.address_no 
LEFT JOIN dbo.[_import_1_1_code] st ON
	pa.state = st.code
LEFT JOIN dbo.[_import_1_1_code] ms ON
	pat.marital_status = ms.code
LEFT JOIN dbo.[_import_1_1_address] guaradd ON	
	guar.address_no = guaradd.address_no
LEFT JOIN dbo.[_import_1_1_code] gst ON
	guaradd.state = gst.code
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into PatientJournalNotes ...'
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
SELECT    GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          realP.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          pat.notes  -- NoteMessage - varchar(max)
FROM dbo._import_1_1_patient pat
LEFT  JOIN dbo.Patient realP ON
	pat.patient_no = realP.VendorID AND
	realP.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID
WHERE pat.notes IS NOT NULL 
PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into PatientAlert ...'
INSERT INTO dbo.PatientAlert
        ( PatientID ,
          AlertMessage ,
          ShowInPatientFlag ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT    realP.PatientID , -- PatientID - int
          pat.med_alert , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo._import_1_1_patient pat
LEFT JOIN dbo.Patient realP ON
	realP.VendorID = pat.patient_no AND
	realP.VendorImportID = @VendorImportID
WHERE pat.med_alert IS NOT NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




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
WHERE p.PracticeID = @PracticeID AND
	p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          Copay ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderLastName ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          HolderDOB ,
          HolderGender ,
          HolderPhone ,
          HolderSSN ,
          DependentPolicyNumber ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          ins.ins_seq , -- Precedence - int
          ins.insured_id , -- PolicyNumber - varchar(32)
          CASE WHEN ins.policy_group_no <> '' AND ins.policy_group_no <> 'NONE' THEN ins.policy_group_no ELSE '' END  , -- GroupNumber - varchar(32)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- Notes - text
          ins.ins_copay , -- Copay - money
          CASE WHEN ins.relation_to_insured IN (335, 656, 664) THEN 'S'
			   WHEN	ins.relation_to_insured = 531 THEN 'U'
			   ELSE 'C' END , --PatientRelationshipToInsured
          CASE WHEN ins.relation_to_insured NOT IN (335, 656, 664) THEN guar.first_name END ,  --HolderFirstName 
          CASE WHEN ins.relation_to_insured NOT IN (335, 656, 664) THEN guar.last_name END , --HolderLastName 
          CASE WHEN ins.relation_to_insured NOT IN (335, 656, 664) THEN guaradd.address1 END ,  --HolderAddressLine1 
          CASE WHEN ins.relation_to_insured NOT IN (335, 656, 664) THEN guaradd.address1 END , --HolderAddressLine2 
          CASE WHEN ins.relation_to_insured NOT IN (335, 656, 664) THEN guaradd.city END , --HolderCity 
          CASE WHEN ins.relation_to_insured NOT IN (335, 656, 664) THEN gst.user_code  END ,  --HolderState 
          CASE WHEN ins.relation_to_insured NOT IN (335, 656, 664) THEN LEFT(REPLACE(guaradd.zip, '-', ''), 9) END ,  --HolderZipCode 
          CASE WHEN ins.relation_to_insured NOT IN (335, 656, 664) THEN guar.birth_date END , --HolderDOB 
          CASE WHEN ins.relation_to_insured NOT IN (335, 656, 664) THEN CASE WHEN guar.sex = 1 THEN 'F' ELSE 'M' END  END , --HolderGender 
          CASE WHEN ins.relation_to_insured NOT IN (335, 656, 664) 
				THEN LEFT(REPLACE(REPLACE(REPLACE(guar.day_phone, '(', ''), ')', ''), '-', ''), 10) END , --HolderPhone 
          CASE WHEN ins.relation_to_insured NOT IN (335, 656, 664) THEN guar.ss_no END , --HolderSSN 
          ins.insured_id , --DependentPolicyNumber 
          @PracticeID , -- PracticeID - int
          pc.vendorID + ins.ins_seq , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_1_1_Patient_insurances ins
JOIN dbo.PatientCase pc ON
	ins.patient_no = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	ins.insurance_no = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_patient] guar ON
	ins.insured_no = guar.patient_no 
LEFT JOIN dbo.[_import_1_1_address] guaradd ON	
	guar.address_no = guaradd.address_no
LEFT JOIN dbo.[_import_1_1_code] gst ON
	guaradd.state = gst.code	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records inserted'



PRINT ''
PRINT 'Inserting into StandardFeeSchedule ...'
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
VALUES  (  @PracticeID , -- PracticeID - int
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
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into StandardFee ...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT    c.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          0 , -- ModifierID - int
          impSFS.prd_fee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo._import_1_1_product impSFS
JOIN dbo.ContractsAndFees_StandardFeeSchedule c ON
	CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
	c.practiceID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	impSFS.prd_style_name = pcd.ProcedureCode AND
	impSFS.prd_fee <> '0.00'	
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