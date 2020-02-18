USE superbill_56205_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          --Notes ,
          --AddressLine1 ,
          --AddressLine2 ,
          --City ,
          --State ,
          --Country ,
          --ZipCode ,
          --Fax ,
          --FaxExt ,
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
    --      CASE WHEN i.clmeligph = '' THEN '' ELSE 'Eligibility Phone: ' + i.clmeligph +
				--CASE WHEN i.clmeligx = '' THEN CHAR(13) + CHAR(10) ELSE ' Ext: ' + i.clmeligx + CHAR(13) + CHAR(10) END END +
		  --CASE WHEN i.clmauth = '' THEN '' ELSE 'Authorization Phone: ' + i.clmauth +
				--CASE WHEN i.clmauthx = '' THEN CHAR(13) + CHAR(10) ELSE ' Ext: ' + i.clmauthx + CHAR(13) + CHAR(10) END END , -- Notes - text
    --      i.clmaddr , -- AddressLine1 - varchar(256)
    --      i.clmattn , -- AddressLine2 - varchar(256)
    --      i.clmcity , -- City - varchar(128)
    --      LEFT(i.clmstate, 2) , -- State - varchar(2)
    --      '' , -- Country - varchar(32)
    --      CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (4,8) THEN '0' + (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.',''))
		  --ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.',''),9) END , -- ZipCode - varchar(9)
          --i.clmfax , -- Fax - varchar(10)
          --i.clmfaxx , -- FaxExt - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          i.clmname , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_Clmfile] i
WHERE i.clmname <> ''
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
          Phone ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT    i.clmname ,
          i.clmaddr , -- AddressLine1 - varchar(256)
          i.clmattn , -- AddressLine2 - varchar(256)
          i.clmcity , -- City - varchar(128)
          LEFT(i.clmstate, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (4,8) THEN '0' + (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.',''))
		  ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.clmzip,'-',''),' ',''),'=',''),'r',''),'.',''),9) END , -- ZipCode - varchar(9)
          i.clmphone ,
          ic.CreatedDate ,
          ic.CreatedUserID ,
          ic.ModifiedDate ,
          ic.ModifiedUserID ,
          @PracticeID ,
          i.clmfax ,
          i.clmfaxx ,
          ic.InsuranceCompanyID ,
          i.clmcono ,
          @VendorImportID 
FROM dbo.InsuranceCompany ic
INNER JOIN dbo.[_import_1_1_clmfile] i ON
	i.clmname = ic.VendorID AND 
	ic.VendorImportID = @VendorImportID
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
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          WorkPhone ,
          WorkPhoneExt ,
          PagerPhone ,
          PagerPhoneExt ,
          MobilePhone ,
          MobilePhoneExt ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
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
          reffname , -- FirstName - varchar(64)
          refmi , -- MiddleName - varchar(64)
          reflname , -- LastName - varchar(64)
          refsuffix , -- Suffix - varchar(16)
          refaddr , -- AddressLine1 - varchar(256)
          refaddr2 , -- AddressLine2 - varchar(256)
          refcity , -- City - varchar(128)
          LEFT(refstate ,2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(refzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (4,8) THEN '0' + (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(refzip,'-',''),' ',''),'=',''),'r',''),'.',''))
		  ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(refzip,'-',''),' ',''),'=',''),'r',''),'.',''),9) END , -- ZipCode - varchar(9)
          refphone , -- WorkPhone - varchar(10)
          refphonext , -- WorkPhoneExt - varchar(10)
          refpage , -- PagerPhone - varchar(10)
          refpagext , -- PagerPhoneExt - varchar(10)
          refmobile , -- MobilePhone - varchar(10)
          refmobilext , -- MobilePhoneExt - varchar(10)
          CASE WHEN refid1 = '' THEN '' ELSE 'ID1: ' + refid1 + CHAR(13) + CHAR(10) END +
		  CASE WHEN refid2 = '' THEN '' ELSE 'ID2: ' + refid2 + CHAR(13) + CHAR(10) END +
		  CASE WHEN refid3 = '' THEN '' ELSE 'ID3: ' + refid3 + CHAR(13) + CHAR(10) END + 
		  CASE WHEN refid4 = '' THEN '' ELSE 'ID4: ' + refid4 + CHAR(13) + CHAR(10) END + 
		  CASE WHEN refid5 = '' THEN '' ELSE 'UPIN: '+ refid5 + CHAR(13) + CHAR(10) END , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          refdrno , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          reffax , -- FaxNumber - varchar(10)
          reffaxext , -- FaxNumberExt - varchar(10)
          1 , -- External - bit
          refnatlprovid -- NPI - varchar(10)
FROM dbo.[_import_1_1_Reffile]
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
FROM dbo.[_import_1_1_Patfile] WHERE patemplname NOT IN ('','*****','.','no')
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
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
	      @PracticeID , -- PracticeID - int
          rd.DoctorID , -- ReferringPhysicianID - int
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
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_1_1_Patfile] i
LEFT JOIN dbo.Doctor rd ON
	rd.VendorID = i.patrefdr AND
	rd.VendorImportID = @VendorImportID
LEFT JOIN dbo.Employers e ON 
	i.patemplname = e.EmployerName 
WHERE i.patfname <> '' AND i.patlname <> ''
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
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
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
              ip.PatientCaseID IS NULL AND
              pc.Name <> 'Balance Forward'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT



e