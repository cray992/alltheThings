USE superbill_14250_dev
--USE superbill_14250_prod
GO


 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeId AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@rowcount AS VARCHAR(10)) + ' PatientJournalNote records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'




PRINT ''
PRINT 'Inserting into Insurance Company ...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
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
		  ic.insurancename , -- InsuranceCompanyName - varchar(128)
          ic.insuranceaddress1 , -- AddressLine1 - varchar(256)
          ic.insuranceaddress2 , -- AddressLine2 - varchar(256)
          ic.insurancecity , -- City - varchar(128)
          st.usercode , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(ic.[insurancezipcd],'-', ''), 9) ,-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(ic.insurancephoneno,'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          ic.insurancecontact , -- contactfirstname
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
          ic.insuranceno , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_2_1_Insurance] ic
LEFT JOIN dbo.[_import_2_1_code] st ON
	ic.statecd = st.code
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


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
          refdoc.referfirstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          refdoc.referlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          refdoc.referaddress1 , -- AddressLine1 - varchar(256)
          refdoc.referaddress2 , -- AddressLine2 - varchar(256)
          refdoc.refercity , -- City - varchar(128)
          'PA' , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(refdoc.referzipcode, '-', ''), 9) , -- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(refdoc.referphone, '(', ''), ')', ''), '-', ''), 10) , -- WorkPhone - varchar(10)
          'UPINUSINNO: ' + refdoc.referupinusinno , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- UserID - int
          'DR.' , -- Degree - varchar(8)
          refdoc.referno , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
           LEFT(REPLACE(REPLACE(REPLACE(refdoc.referfax, '(', ''), ')', ''), '-', ''), 10) , -- FaxNumber - varchar(10)
          1 , -- External - bit
          refdoc.npinum  -- NPI - varchar(10)
FROM dbo.[_import_2_1_referringprofessional] refdoc
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



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
          DOB ,
          SSN ,
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
          MobilePhone ,
          PrimaryProviderID ,
          VendorID ,
          VendorImportID ,
          Active ,
          PhonecallRemindersEnabled 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.firstname , -- FirstName - varchar(64)
          pat.midname , -- MiddleName - varchar(64)
          pat.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pa.address1 , -- AddressLine1 - varchar(256)
          pa.address2 , -- AddressLine2 - varchar(256)
          pa.city , -- City - varchar(128)
          st.usercode , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(pa.zip, '-', ''), 9) , -- ZipCode - varchar(9)
          CASE WHEN pat.sex = 1 THEN 'F' ELSE 'M'  END , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(pat.dayphone, '(', ''), '-', ''), ')', ''), 10) , -- HomePhone - varchar(10)
          CASE WHEN pat.birthdate > GETDATE() THEN DATEADD(yy, -100, pat.birthdate) 
				WHEN pat.birthdate <> '' THEN pat.birthdate END , -- DOB - datetime
          LEFT(REPLACE(pat.ssno, '-', ''), 9) , -- SSN - char(9)
          CASE WHEN pat.patientno <> pat.guarantorno THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN pat.patientno <> pat.guarantorno THEN guar.firstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN pat.patientno <> pat.guarantorno THEN guar.midname END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN pat.patientno <> pat.guarantorno THEN guar.lastname END , -- ResponsibleLastName - varchar(64)
          '' , -- ResponsibleSuffix - varchar(16)
          CASE WHEN pat.patientno <> pat.guarantorno THEN 'O' END  , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN pat.patientno <> pat.guarantorno THEN guaradd.address1 END  , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN pat.patientno <> pat.guarantorno THEN guaradd.address2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN pat.patientno <> pat.guarantorno THEN guaradd.city END , -- ResponsibleCity - varchar(128)
          CASE WHEN pat.patientno <> pat.guarantorno THEN gst.usercode END , -- ResponsibleState - varchar(2)
          '' , -- ResponsibleCountry - varchar(32)
          CASE WHEN pat.patientno <> pat.guarantorno THEN guaradd.zip END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.chartno , -- MedicalRecordNumber - varchar(128)
          LEFT(REPLACE(REPLACE(REPLACE(pat.cellphone, '(', ''), '-', ''), ')', ''), 10) , -- MobilePhone - varchar(10)
          1 ,
          pat.patientno , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          1  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_2_1_patient] pat 
LEFT JOIN dbo.[_import_2_1_patient] guar ON
	pat.guarantorno = guar.patientno 
LEFT JOIN dbo.[_import_2_1_address] pa ON
	pa.addressno = pat.addressno
LEFT JOIN dbo.[_import_2_1_code] st ON
	pa.[state] = st.code
LEFT JOIN dbo.[_import_2_1_address] guaradd ON
	guaradd.addressno = guar.addressno
LEFT JOIN dbo.[_import_2_1_code] gst ON
	guaradd.[state] = gst.code
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
FROM dbo.[_import_2_1_patient] pat
LEFT  JOIN dbo.Patient realP ON
	pat.patientno = realP.VendorID AND
	realP.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID
WHERE pat.notes <> ''
PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'



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
          ins.insseq , -- Precedence - int
          ins.insuredid , -- PolicyNumber - varchar(32)
          CASE WHEN ins.policygroupno <> '' AND ins.policygroupno <> 'NONE' THEN ins.policygroupno ELSE '' END  , -- GroupNumber - varchar(32)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- Notes - text
          ins.inscopay , -- Copay - money
          CASE WHEN ins.relationtoinsured IN (335, 656, 664) THEN 'S'
			   WHEN	ins.relationtoinsured = 531 THEN 'U'
			   ELSE 'C' END , --PatientRelationshipToInsured
          CASE WHEN ins.relationtoinsured NOT IN (335, 656, 664) THEN guar.firstname END ,  --HolderFirstName 
          CASE WHEN ins.relationtoinsured NOT IN (335, 656, 664) THEN guar.lastname END , --HolderLastName 
          CASE WHEN ins.relationtoinsured NOT IN (335, 656, 664) THEN guaradd.address1 END ,  --HolderAddressLine1 
          CASE WHEN ins.relationtoinsured NOT IN (335, 656, 664) THEN guaradd.address1 END , --HolderAddressLine2 
          CASE WHEN ins.relationtoinsured NOT IN (335, 656, 664) THEN guaradd.city END , --HolderCity 
          CASE WHEN ins.relationtoinsured NOT IN (335, 656, 664) THEN gst.usercode  END ,  --HolderState 
          CASE WHEN ins.relationtoinsured NOT IN (335, 656, 664) THEN LEFT(REPLACE(guaradd.zip, '-', ''), 9) END ,  --HolderZipCode 
          CASE WHEN ins.relationtoinsured NOT IN (335, 656, 664) THEN guar.birthdate END , --HolderDOB 
          CASE WHEN ins.relationtoinsured NOT IN (335, 656, 664) THEN CASE WHEN guar.sex = 1 THEN 'F' ELSE 'M' END  END , --HolderGender 
          CASE WHEN ins.relationtoinsured NOT IN (335, 656, 664) 
				THEN LEFT(REPLACE(REPLACE(REPLACE(guar.dayphone, '(', ''), ')', ''), '-', ''), 10) END , --HolderPhone 
          CASE WHEN ins.relationtoinsured NOT IN (335, 656, 664) THEN guar.ssno END , --HolderSSN 
          ins.insuredid , --DependentPolicyNumber 
          @PracticeID , -- PracticeID - int
          pc.vendorID + ins.insseq , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_2_1_Patientinsurances] ins
JOIN dbo.PatientCase pc ON
	ins.patientno = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	ins.insuranceno = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_2_1_patient] guar ON
	ins.insuredno = guar.patientno 
LEFT JOIN dbo.[_import_2_1_address] guaradd ON	
	guar.addressno = guaradd.addressno
LEFT JOIN dbo.[_import_2_1_code] gst ON
	guaradd.state = gst.code
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records inserted'




COMMIT