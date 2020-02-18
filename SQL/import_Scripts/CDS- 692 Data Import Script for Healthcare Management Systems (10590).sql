--USE superbill_10590_dev
USE superbill_10590_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 33
SET @VendorImportID = 19

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

/*
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID AND InsuranceCompanyPlanID NOT IN (SELECT InsuranceCompanyPlanID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT patientid FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
*/

--PRINT ''
--PRINT 'Inserting into Insurance Company Plan - 3 Records - Not for Prod'
--SET IDENTITY_INSERT dbo.InsuranceCompanyPlan ON
--INSERT INTO dbo.InsuranceCompanyPlan
--        ( InsuranceCompanyPlanID ,
--		  PlanName ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          ReviewCode ,
--          CreatedPracticeID ,
--          InsuranceCompanyID ,
--          VendorID ,
--          VendorImportID 
--        )
--SELECT DISTINCT
--		  i.insurancecompanyplanid ,
--		  PlanName ,
--          GETDATE() ,
--          0 ,
--          GETDATE() ,
--          0 ,
--          'R' ,
--          @PracticeID ,
--          ic.InsuranceCompanyID ,
--          insurancecompanyplanid ,
--          @VendorImportID 
--FROM dbo.[_import_19_33_InsuranceCompanyPlan] i 
--INNER JOIN dbo.InsuranceCompany ic ON 
--	i.insurancecompanyid = ic.insurancecompanyid
--WHERE i.planname <> '' AND NOT EXISTS (SELECT * FROM dbo.InsuranceCompanyPlan icp2 WHERE i.insurancecompanyplanid = icp2.InsuranceCompanyPlanID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--SET IDENTITY_INSERT dbo.InsuranceCompanyPlan OFF

SELECT * FROM dbo.[_import_28_33_drfile]

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Fax ,
          FaxExt ,
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
          CASE WHEN i.clmeligph = '' THEN '' ELSE 'Eligibility Phone: ' + i.clmeligph +
				CASE WHEN i.clmeligx = '' THEN CHAR(13) + CHAR(10) ELSE ' Ext: ' + i.clmeligx + CHAR(13) + CHAR(10) END END +
		  CASE WHEN i.clmauth = '' THEN '' ELSE 'Authorization Phone: ' + i.clmauth +
				CASE WHEN i.clmauthx = '' THEN CHAR(13) + CHAR(10) ELSE ' Ext: ' + i.clmauthx + CHAR(13) + CHAR(10) END END , -- Notes - text
          i.clmaddr , -- AddressLine1 - varchar(256)
          i.clmattn , -- AddressLine2 - varchar(256)
          i.clmcity , -- City - varchar(128)
          LEFT(i.clmstate, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (4,8) THEN '0' + (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.',''))
		  ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.',''),9) END , -- ZipCode - varchar(9)
          i.clmfax , -- Fax - varchar(10)
          i.clmfaxx , -- FaxExt - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          CASE WHEN ip.InsuranceProgramCode IS NULL THEN 'CI' ELSE ip.InsuranceProgramCode END , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          i.clmcono , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_19_33_Clmfile] i
LEFT JOIN dbo.InsuranceProgram ip ON
	i.cmlgovttype = ip.InsuranceProgramCode
WHERE i.clmname <> '' AND i.insurancecompanyplanid = ''
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
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID ,
		  Notes
        )
SELECT 
		  InsuranceCompanyName ,
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID ,
		  Notes
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID AND CreatedPracticeID = @PracticeID
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
FROM dbo.[_import_19_33_Patfile]
LEFT JOIN dbo.Employers e ON 
	patemplname = e.EmployerName
WHERE patemplname NOT IN ('','*****','.','no') AND e.EmployerID IS NULL
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
		  PrimaryProviderID ,
		  DefaultServiceLocationID ,
		  EmergencyName
        )
SELECT DISTINCT
	      @PracticeID , -- PracticeID - int
          CASE WHEN refd.DoctorID IS NULL THEN rend.DoctorID END , -- ReferringPhysicianID - int
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
          CASE WHEN ISDATE(i.patdob) = 1 THEN i.patdob END , -- DOB - datetime
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
		  rend.DoctorID , 
		  175 ,
		  emerg.emergencycontact
FROM dbo.[_import_19_33_Patfile] i
LEFT JOIN dbo.[_import_19_33_drfile] rd ON
	rd.drno = i.patdoctor 
LEFT JOIN dbo.Doctor rend ON 
	rd.drfname = rend.FirstName AND 
	rd.drlname = rend.LastName AND 
	rend.PracticeID = @PracticeID
LEFT JOIN dbo.[_import_19_33_drfile] rfd ON
	rd.drno = i.patrefdr 
LEFT JOIN dbo.Doctor refd ON 
	rfd.drfname = refd.FirstName AND 
	rfd.drlname = refd.LastName AND 
	refd.PracticeID = @PracticeID
LEFT JOIN dbo.Employers e ON 
	i.patemplname = e.EmployerName AND
    i.patemplname <> ''
LEFT JOIN dbo.[_import_19_33_comtextdat] emerg ON
	i.pataccount = emerg.pt
WHERE i.patfname <> '' AND i.patlname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into PatientJournalNote - Pharmacy...'
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
          'Pharmacy: ' + i.pharmacy + CHAR(13) + CHAR(10) +
		  CASE WHEN i.pharmacyaddress = '' THEN '' ELSE 'Address: ' + i.pharmacyaddress + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.pharmacycity = '' THEN '' ELSE 'City: ' + i.pharmacycity + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.pharmacyst = '' THEN '' ELSE 'State: ' + i.pharmacyst + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.pharmacyzip = '' THEN '' ELSE 'Zip: ' + i.pharmacyzip + CHAR(13) + CHAR(10) END + 
		  CASE WHEN i.[2ndpharmacy] = '' THEN '' ELSE '2nd Pharmacy: ' + i.[2ndpharmacy] END , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_19_33_extfile] i
	INNER JOIN dbo.Patient p ON 
		i.account = p.VendorID AND 
		p.VendorImportID = @VendorImportID
WHERE i.pharmacy <> ''
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
          p.patientid , -- PatientID - int
          'Kareo' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          CASE i.preferredcontact 
								WHEN 'NO PREFERRED #' THEN 'Preferred phone # to Contact: None' + CHAR(13) + CHAR(10)
								WHEN 'NO PREFERRED CONTACT' THEN 'Preferred phone # to Contact: None' + CHAR(13) + CHAR(10)
								WHEN 'PREFERERED # CELL' THEN 'Preferred phone # to Contact: Cell' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRD # HOME' THEN 'Preferred phone # to Contact: Home' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # - ANY #' THEN 'Preferred phone # to Contact: Any # on file' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # CELL' THEN 'Preferred phone # to Contact: Cell' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # CELL/HOME' THEN 'Preferred phone # to Contact: Cell or Home' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # CELL/WORK' THEN 'Preferred phone # to Contact: Cell or Work' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # HOME' THEN 'Preferred phone # to Contact: Home' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # HOME & CELL' THEN 'Preferred phone # to Contact: Home or Cell' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # HOME OR CELL' THEN 'Preferred phone # to Contact: Home or Cell' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # HOME/CELL' THEN 'Preferred phone # to Contact: Home or Cell' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # HOME/EMAIL' THEN 'Preferred phone # to Contact: Home or Email' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # HOME/WORK' THEN 'Preferred phone # to Contact: Home or Work' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # SON CELL' THEN 'Preferred phone # to Contact: Son Cell' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # WORK' THEN 'Preferred phone # to Contact: Work' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # WORK/CELL' THEN 'Preferred phone # to Contact: Work or Cell' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED # WORK/HOME' THEN 'Preferred phone # to Contact: Work or Home' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED #CELL THEN HOME' THEN 'Preferred phone # to Contact: Cell first then Home' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED #HOME THEN CELL' THEN 'Preferred phone # to Contact: Home first then Cell' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED CONTACT # HOME' THEN 'Preferred phone # to Contact: Home' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED HOME #' THEN 'Preferred phone # to Contact: Home' + CHAR(13) + CHAR(10)
								WHEN 'PREFERRED# CELL/WORK' THEN 'Preferred phone # to Contact: Cell or Work' + CHAR(13) + CHAR(10) 
								WHEN 'PREFFERED # CELL' THEN 'Preferred phone # to Contact: Cell' + CHAR(13) + CHAR(10)
								WHEN 'PREFFERED # HOME' THEN 'Preferred phone # to Contact: Home' + CHAR(13) + CHAR(10)
								WHEN 'PREFFERED CELL' THEN 'Preferred phone # to Contact: Cell' + CHAR(13) + CHAR(10) 
							    ELSE '' END +
		 CASE i.oktoleavemessage  
								WHEN 'DO NOT LM ON ANY #' THEN 'OK to leave message with health info? No' + CHAR(13) + CHAR(10)
								WHEN 'DO NOT LM ON HOME #' THEN 'OK to leave message with health info? No' + CHAR(13) + CHAR(10)
								WHEN 'DO NOT LM ON WORK #' THEN 'OK to leave message with health info? Not at Work #' + CHAR(13) + CHAR(10)
								WHEN 'DONT LM ON ANY #' THEN 'OK to leave message with health info? No - Any #' + CHAR(13) + CHAR(10)
								WHEN 'NO ANSWERING MACHINE' THEN 'OK to leave message with health info? No' + CHAR(13) + CHAR(10)
								WHEN 'NO MESSAGE' THEN 'OK to leave message with health info? No ' + CHAR(13) + CHAR(10)
								WHEN 'NO MESSAGES' THEN 'OK to leave message with health info? No' + CHAR(13) + CHAR(10)
								WHEN 'OK LM # CELL' THEN 'OK to leave message with health info? Yes - Cell' + CHAR(13) + CHAR(10)
								WHEN 'OK LM # HOME' THEN 'OK to leave message with health info? Yes - Home' + CHAR(13) + CHAR(10)
								WHEN 'OK LM CELL' THEN 'OK to leave message with health info? Yes - Cell' + CHAR(13) + CHAR(10)
								WHEN 'OK LM ON CELL' THEN 'OK to leave message with health info? Yes - Cell' + CHAR(13) + CHAR(10)
								WHEN 'OK LM ON CELL #' THEN 'OK to leave message with health info? Yes - Cell' + CHAR(13) + CHAR(10)
								WHEN 'OK LM ON CELL # ONLY' THEN 'OK to leave message with health info? Yes - Cell Only' + CHAR(13) + CHAR(10)
								WHEN 'OK LM ON EITHER #' THEN 'OK to leave message with health info? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK LM ON HOME #' THEN 'OK to leave message with health info? Yes - Home' + CHAR(13) + CHAR(10)
								WHEN 'OK LM ON HOME # ONLY' THEN 'OK to leave message with health info? Yes - Home Only ' + CHAR(13) + CHAR(10)
								WHEN 'OK LM ON WORK #' THEN 'OK to leave message with health info? Yes - Work' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM' THEN 'OK to leave message with health info? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM & TXT CELL #' THEN 'OK to leave message with health info? Yes - Cell' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM AT WORK #' THEN 'OK to leave message with health info? Yes - Work' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM CELL #' THEN 'OK to leave message with health info? Yes - Cell' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM HOME #' THEN 'OK to leave message with health info? Yes - Home' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON ANY #' THEN 'OK to leave message with health info? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON BOTH' THEN 'OK to leave message with health info? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON CEL #' THEN 'OK to leave message with health info? Yes - Cell' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON CELL' THEN 'OK to leave message with health info? Yes - Cell' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON CELL #' THEN 'OK to leave message with health info? Yes - Cell' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON CELL/HOME' THEN 'OK to leave message with health info? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON EITHER #' THEN 'OK to leave message with health info? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON HOME' THEN 'OK to leave message with health info? Yes - Home' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON HOME #' THEN 'OK to leave message with health info? Yes - Home' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON HOME & CELL #' THEN 'OK to leave message with health info? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON HOME/CELL#' THEN 'OK to leave message with health info? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON SON CELL' THEN 'OK to leave message with health info? Yes - Son Cell' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM ON WORK #' THEN 'OK to leave message with health info? Yes - Work' + CHAR(13) + CHAR(10)
								WHEN 'OK TO LM WORK' THEN 'OK to leave message with health info? Yes - Work ' + CHAR(13) + CHAR(10)
								WHEN 'OK TO ON CELL #' THEN 'OK to leave message with health info? Yes - Cell' + CHAR(13) + CHAR(10)
							    ELSE '' END +
		  CASE i.oktospeakto		
								WHEN 'CALL DTR BETH' THEN 'OK to discuss with spouse/partner/children? No' + CHAR(13) + CHAR(10)
								WHEN 'EMERGENCY ONLY' THEN 'OK to discuss with spouse/partner/children? Yes - Emergency Only' + CHAR(13) + CHAR(10)
								WHEN 'NO SPOUSE' THEN 'OK to discuss with spouse/partner/children? No' + CHAR(13) + CHAR(10)
								WHEN 'NO TALK SPOUSE' THEN 'OK to discuss with spouse/partner/children? No' + CHAR(13) + CHAR(10)
								WHEN 'NO TLK SPOUSE' THEN 'OK to discuss with spouse/partner/children? No' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK -SPOUSE' THEN 'OK to discuss with spouse/partner/children? Yes - Spouse' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK CHILD' THEN 'OK to discuss with spouse/partner/children? Yes - Child' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK CHLDRN' THEN 'OK to discuss with spouse/partner/children? Yes - Child' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK DAUGHTR' THEN 'OK to discuss with spouse/partner/children? Yes - Daughter' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK DGHTER' THEN 'OK to discuss with spouse/partner/children? Yes - Daughter' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK DGHTR' THEN 'OK to discuss with spouse/partner/children? Yes - Daughter' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK DGHTRS' THEN 'OK to discuss with spouse/partner/children? Yes - Daughters' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK FRIEND' THEN 'OK to discuss with spouse/partner/children? Yes - Friend' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK KIDS' THEN 'OK to discuss with spouse/partner/children? Yes - Child' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK MOM' THEN 'OK to discuss with spouse/partner/children? Yes - Mom' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK NIECE' THEN 'OK to discuss with spouse/partner/children? Yes - Niece' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK PARENT' THEN 'OK to discuss with spouse/partner/children? Yes - Parents' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK PARENTS' THEN 'OK to discuss with spouse/partner/children? Yes - Parents' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK PARTNER' THEN 'OK to discuss with spouse/partner/children? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK SONS' THEN 'OK to discuss with spouse/partner/children? Yes - Children' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK SPOUS' THEN 'OK to discuss with spouse/partner/children? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK SPOUSE' THEN 'OK to discuss with spouse/partner/children? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK TO MOM' THEN 'OK to discuss with spouse/partner/children? Yes - Mom' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK- SPOUSE' THEN 'OK to discuss with spouse/partner/children? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TALK-SPOUSE' THEN 'OK to discuss with spouse/partner/children? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TLK DAUGHTER' THEN 'OK to discuss with spouse/partner/children? Yes - Daughter' + CHAR(13) + CHAR(10)
								WHEN 'OK TLK PARENTS' THEN 'OK to discuss with spouse/partner/children? Yes- Parents' + CHAR(13) + CHAR(10)
								WHEN 'OK TLK PARTNER' THEN 'OK to discuss with spouse/partner/children? Yes' + CHAR(13) + CHAR(10)
								WHEN 'OK TLK SON/DGHT' THEN 'OK to discuss with spouse/partner/children? Yes - Children' + CHAR(13) + CHAR(10)
								WHEN 'OK TLK TO MOM' THEN 'OK to discuss with spouse/partner/children? Yes - Mom' + CHAR(13) + CHAR(10)
								WHEN 'SON/DTR IN LAW' THEN 'OK to discuss with spouse/partner/children? Yes - Children in laws' + CHAR(13) + CHAR(10)
								WHEN 'YES SPOUSE' THEN 'OK to discuss with spouse/partner/children? Yes' + CHAR(13) + CHAR(10)
								ELSE '' END +
		  CASE i.dependents     
								WHEN 'NO DEPEDENTS' THEN 'Dependents in Practice? No' + CHAR(13) + CHAR(10)
								WHEN 'NO DEPENDANTS' THEN 'Dependents in Practice? No' + CHAR(13) + CHAR(10)
								WHEN 'NO DEPENDENT' THEN 'Dependents in Practice? No' + CHAR(13) + CHAR(10)
								WHEN 'NO DEPENDENTS' THEN 'Dependents in Practice? No' + CHAR(13) + CHAR(10)
								WHEN 'NO DEPENDETS' THEN 'Dependents in Practice? No' + CHAR(13) + CHAR(10)
								WHEN 'SON' THEN 'Dependents in Practice? Yes - Son' + CHAR(13) + CHAR(10)
								WHEN 'YES - DEPENDENT' THEN 'Dependents in Practice? Yes' + CHAR(13) + CHAR(10)
								WHEN 'YES DEPENDENT' THEN 'Dependents in Practice? Yes' + CHAR(13) + CHAR(10)
								WHEN 'YES DEPENDENTS' THEN 'Dependents in Practice? Yes' + CHAR(13) + CHAR(10)
								ELSE '' END +
		  CASE i.checkedemail   
								WHEN 'CHCK EMAI' THEN 'Patient checks email? Yes' + CHAR(13) + CHAR(10)
								WHEN 'CHCK EMAIL' THEN 'Patient checks email? Yes' + CHAR(13) + CHAR(10)
								WHEN 'CHK EMAIL' THEN 'Patient checks email? Yes' + CHAR(13) + CHAR(10)
								WHEN 'CK EMAIL' THEN 'Patient checks email? Yes' + CHAR(13) + CHAR(10)
								WHEN 'DNT CK EML' THEN 'Patient checks email? No' + CHAR(13) + CHAR(10)
								WHEN 'EMAIL MOM' THEN 'Patient checks email? Yes - Mom' + CHAR(13) + CHAR(10)
								WHEN 'EMAIL SON' THEN 'Patient checks email? Yes - Son' + CHAR(13) + CHAR(10)
								WHEN 'NO CHK EML' THEN 'Patient checks email? No' + CHAR(13) + CHAR(10)
								WHEN 'NO CK EML' THEN 'Patient checks email? No' + CHAR(13) + CHAR(10)
								WHEN 'NO EMAIL' THEN 'Patient checks email? No' + CHAR(13) + CHAR(10)
								WHEN 'NOCHCK EML' THEN 'Patient checks email? No' + CHAR(13) + CHAR(10)
								WHEN 'OK EMAIL' THEN 'Patient checks email? Yes' + CHAR(13) + CHAR(10)
								WHEN 'YES EMAIL' THEN 'Patient checks email? Yes' + CHAR(13) + CHAR(10)
								ELSE '' END +

		  CASE i.oktoemail      
								WHEN 'CHCK EMAIL' THEN 'OK to send emails: Yes' + CHAR(13) + CHAR(10) 
								WHEN 'EMAIL SON' THEN 'OK to send emails: Yes - Son' + CHAR(13) + CHAR(10) 
								WHEN 'NO ANSWER' THEN 'OK to send emails: No' + CHAR(13) + CHAR(10) 
								WHEN 'NO EMAIL' THEN 'OK to send emails: No' + CHAR(13) + CHAR(10) 
								WHEN 'OK - EMAIL' THEN 'OK to send emails: Yes' + CHAR(13) + CHAR(10) 
								WHEN 'OK EMAIL' THEN 'OK to send emails: Yes' + CHAR(13) + CHAR(10) 
								WHEN 'OK TO EMAI' THEN 'OK to send emails: Yes' + CHAR(13) + CHAR(10) 
								WHEN 'YES EMAIL' THEN 'OK to send emails: Yes' + CHAR(13) + CHAR(10) 
								WHEN 'YES MAIL' THEN 'OK to send emails: Yes' + CHAR(13) + CHAR(10) 	
							    ELSE '' END +
		  CASE i.okaytovideoconference 
								WHEN 'No' THEN 'Consent to Video Conference: No' + CHAR(13) + CHAR(10)
								WHEN 'Yes' THEN 'Consent to Video Conference: Yes' + CHAR(13) + CHAR(10)
								ELSE '' END , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_19_33_extfile] i
	INNER JOIN dbo.Patient p ON 
		p.VendorID = i.account AND 
		p.VendorImportID = @VendorImportID
WHERE i.preferredcontact <> '' OR i.oktoleavemessage <> '' OR i.oktospeakto <> '' OR i.dependents <> '' OR i.checkedemail <> ''
	  OR i.oktoemail <> '' OR i.okaytovideoconference <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientCase'
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
          PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          CASE WHEN ins.precedencecheck = 1 THEN 'Duplicate insurance primary policy precedence has been found in the source file from Medical Manager. Please confirm the policy information is correct. ' + CONVERT(VARCHAR(10),GETDATE(),101) 
		  ELSE CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient p
LEFT JOIN dbo.[_import_19_33_insfile] ins ON 
	p.VendorID = ins.insaccount
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Into Appointment...'
--INSERT INTO dbo.Appointment
--        ( PatientID ,
--          PracticeID ,
--          ServiceLocationID ,
--          StartDate ,
--          EndDate ,
--          AppointmentType ,
--          Subject ,
--          Notes ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          AppointmentResourceTypeID ,
--          AppointmentConfirmationStatusCode ,
--          PatientCaseID ,
--          StartDKPracticeID ,
--          EndDKPracticeID ,
--          StartTm ,
--          EndTm 
--        )
--SELECT DISTINCT
--          p.PatientID , -- PatientID - int
--          @PracticeID , -- PracticeID - int
--          1 , -- ServiceLocationID - int
--          i.startdate , -- StartDate - datetime
--          i.enddate , -- EndDate - datetime
--          'P' , -- AppointmentType - varchar(1)
--          i.aptuniq , -- Subject - varchar(64)
--          '' , -- Notes - text
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          1 , -- AppointmentResourceTypeID - int
--          'S' , -- AppointmentConfirmationStatusCode - char(1)
--          pc.PatientCaseID , -- PatientCaseID - int
--          dk.DKPracticeID , -- StartDKPracticeID - int
--          dk.DKPracticeID , -- EndDKPracticeID - int
--          i.starttm , -- StartTm - smallint
--          i.endtm  -- EndTm - smallint
--FROM dbo.[_import_19_33_Aptfile] i
--INNER JOIN dbo.patient AS p ON
--  p.VendorID = i.aptaccount and
--  p.VendorImportID = @VendorImportID
--LEFT JOIN dbo.patientcase AS pc ON
--  pc.patientID = p.patientID AND
--  pc.VendorImportID = @VendorImportID
--INNER JOIN dbo.DateKeyToPractice AS dk ON 
--  dk.PracticeID = @PracticeID AND 
--  dk.Dt = CAST(CAST(i.startdate AS date) AS DATETIME) 
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT ''
--PRINT 'Inserting Into AppointmenttoAppointmentReason...'
--INSERT INTO dbo.AppointmentToAppointmentReason
--        ( AppointmentID ,
--          AppointmentReasonID ,
--          PrimaryAppointment ,
--          ModifiedDate ,
--          PracticeID
--        )
--SELECT DISTINCT
--		  a.AppointmentID , -- AppointmentID - int
--          ar.AppointmentReasonID , -- AppointmentReasonID - int
--          1 , -- PrimaryAppointment - bit
--          GETDATE() , -- ModifiedDate - datetime
--          @PracticeID  -- PracticeID - int
--FROM dbo.[_import_19_33_Aptfile] i
--INNER JOIN dbo.AppointmentReason ar ON
--	ar.Name = i.aptreason AND
--	ar.PracticeID = @PracticeID
--INNER JOIN dbo.Appointment a ON
--	a.[Subject] = i.aptuniq AND
--	a.StartDate = CAST(i.startdate AS DATETIME) AND
--	a.EndDate = CAST(i.enddate AS DATETIME) AND
--	a.PracticeID = @PracticeID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT ''
--PRINT 'Inserting Into AppointmenttoResource...'
--INSERT INTO dbo.AppointmentToResource
--        ( AppointmentID ,
--          AppointmentResourceTypeID ,
--          ResourceID ,
--          ModifiedDate ,
--          PracticeID
--        )
--SELECT DISTINCT
--		  a.AppointmentID , -- AppointmentID - int
--		  1, -- AppointmentResourceTypeID - int
--          CASE WHEN i.aptdr IN (4,6) THEN 1
--		       WHEN i.aptdr IN (2,5) THEN 2
--		  ELSE 1 END  , -- ResourceID - int
--          GETDATE() , -- ModifiedDate - datetime
--          @PracticeID  -- PracticeID - int
--FROM dbo.[_import_19_33_Aptfile] i
--INNER JOIN dbo.Appointment a ON
--	a.[Subject] = i.aptuniq AND
--	a.StartDate = CAST(i.startdate AS DATETIME) AND
--	a.EndDate = CAST(i.enddate AS DATETIME) AND
--	a.PracticeID = @PracticeID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
		  pc.PatientCaseID , -- PatientCaseID - int
          CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN icp2.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END , -- InsuranceCompanyPlanID - int
          CASE i.insstatus 
			WHEN 'PIRMARY' THEN 1
			WHEN 'PRIAMRY' THEN 1
			WHEN 'PRIMARY' THEN 1
			WHEN 'PRIMARY853' THEN 1
			WHEN 'PRIMAY' THEN 1
			WHEN 'PRMARY' THEN 1
			WHEN 'SECODARY' THEN 2
		    WHEN 'SECODNARY' THEN 2
		    WHEN 'SECONDADY' THEN 2
		    WHEN 'SECONDARY' THEN 2
		    WHEN 'SECONDAY' THEN 2
		    WHEN 'SEDONDARY' THEN 2
			WHEN 'Tertiary' THEN 3 
			WHEN 'thirtary' THEN 3
		  END, -- Precedence - int
          i.insid , -- PolicyNumber - varchar(32)
          i.insgroup , -- GroupNumber - varchar(32)
		  CASE WHEN ISDATE(i.insstartdt) = 1 THEN i.insstartdt ELSE NULL END , -- PolicyStartDate - datetime
		  CASE WHEN ISDATE(i.insenddt) = 1 THEN i.insenddt ELSE NULL END  , -- PolicyEndDate - datetime
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.insstatusedited = '' THEN '' ELSE 'Insurance Status: ' + i.insstatusedited END , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_19_33_Insfile] i
INNER JOIN dbo.PatientCase pc ON	
	pc.VendorID = i.insaccount AND
	pc.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = i.insconum AND
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.[_import_19_33_clmfile] clm ON
	i.insconum = clm.clmcono
LEFT JOIN dbo.InsuranceCompanyPlan icp2 ON 
	clm.insurancecompanyplanid = icp2.InsuranceCompanyPlanID
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
      ip.PatientCaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Patient Cases Payer Scenario that DO have policies...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = CASE ic.InsuranceProgramCode
							WHEN 'MC' THEN 7
							WHEN 'WC' THEN 13
							WHEN 'VA' THEN 14
							WHEN '09' THEN 11
						  ELSE 5 END
FROM dbo.PatientCase pc 
	INNER JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND
        pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID 
	INNER JOIN dbo.InsuranceCompany ic ON 
		icp.InsuranceCompanyID = ic.InsuranceCompanyID
WHERE pc.Name <> 'Self Pay' AND pc.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

