USE superbill_27899_prod
GO

SET XACT_ABORT ON
 
BEGIN TRANSACTION
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 68
SET @VendorImportID = 58

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
PRINT ''


/*==========================================================================*/
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--

--CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
--INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo._import_59_68_PatientDemographics i ON p.PatientID = i.id

--PRINT ''
--PRINT 'Updating Existing Patients Demographics...'
--UPDATE dbo.Patient 
--	SET DOB = i.DateofBirth  ,
--		SSN = i.ssn
--FROM #updatepat i 
--INNER JOIN dbo.Patient p ON
--	p.PatientID = i.patientid
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--DROP TABLE #updatepat

/*==========================================================================*/

CREATE TABLE #PatNoExist (VendorID VARCHAR(50))
INSERT INTO #PatNoExist ( VendorID )
SELECT DISTINCT i.ptid  -- VendorID - varchar(50)
FROM dbo._import_59_68_ValantDataExportbf99c17ccc7847b i 
LEFT JOIN dbo.Patient p ON 
	p.FirstName = i.ptnamefirst AND 
    p.LastName = i.ptnamelast AND
	p.DOB = DATEADD(hh,12,CAST(i.ptbirthdate AS DATETIME)) AND 
	p.PracticeID = @PracticeID
WHERE p.PatientID IS NULL AND i.ptnamefirst <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Records Inserted into #PatNoExist'

CREATE TABLE #InsuranceCompanyPlanList (ID INT IDENTITY(1,1) PRIMARY KEY , Name VARCHAR(128) , Address1 VARCHAR(128) , Address2 VARCHAR(128) , City VARCHAR(100) , [State] VARCHAR(2) , Zip VARCHAR(9))

INSERT INTO #InsuranceCompanyPlanList
        ( Name ,
          Address1 ,
          Address2 ,
          City ,
          State ,
          Zip
        )
SELECT DISTINCT
		  i.ptins1name , -- Name - varchar(128)
          i.ptins1addressstreet1 , -- Address1 - varchar(128)
          i.ptins1addressstreet2 , -- Address2 - varchar(128)
          i.ptins1addresscity , -- City - varchar(100)
          i.ptins1addressstate , -- State - varchar(2)
          CASE WHEN i.ptins1addresszipcode = '' THEN i.ptins1addresszipplus4 ELSE i.ptins1addresszipcode END +
			CASE WHEN LEN(i.ptins1addresszipplus4) = 3 THEN '0' + i.ptins1addresszipplus4
	           WHEN LEN(i.ptins1addresszipplus4) = 4 THEN i.ptins1addresszipplus4
			ELSE '' END -- Zip - varchar(9)
FROM dbo._import_59_68_ValantDataExportbf99c17ccc7847b i
INNER JOIN #PatNoExist pat ON 
	i.ptid = pat.VendorID
WHERE ptins1name <> '' 

INSERT INTO #InsuranceCompanyPlanList
        ( Name ,
          Address1 ,
          Address2 ,
          City ,
          State ,
          Zip
        )
SELECT DISTINCT
		  i.ptins2name , -- Name - varchar(128)
          i.ptins2addressstreet1 , -- Address1 - varchar(128)
          i.ptins2addressstreet2 , -- Address2 - varchar(128)
          i.ptins2addresscity , -- City - varchar(100)
          i.ptins2addressstate , -- State - varchar(2)
          CASE WHEN i.ptins2addresszipcode = '' THEN i.ptins2addresszipplus4 ELSE i.ptins2addresszipcode END +
			CASE WHEN LEN(i.ptins2addresszipplus4) = 3 THEN '0' + i.ptins2addresszipplus4
	           WHEN LEN(i.ptins2addresszipplus4) = 4 THEN i.ptins2addresszipplus4
			ELSE '' END -- Zip - varchar(9)
FROM dbo._import_59_68_ValantDataExportbf99c17ccc7847b i
INNER JOIN #PatNoExist pat ON 
	i.ptid = pat.VendorID
WHERE ptins2name <> '' AND
	  NOT EXISTS (
				  SELECT * FROM #InsuranceCompanyPlanList icp 
				  WHERE i.ptins2name = icp.Name AND
						i.ptins2addressstreet1 = icp.Address1 AND
						CASE WHEN i.ptins2addresszipcode = '' THEN i.ptins2addresszipplus4 ELSE i.ptins2addresszipcode END +
							CASE WHEN LEN(i.ptins2addresszipplus4) = 3 THEN '0' + i.ptins2addresszipplus4
							WHEN LEN(i.ptins2addresszipplus4) = 4 THEN i.ptins2addresszipplus4
						ELSE '' END  = icp.Zip
				  ) 

INSERT INTO #InsuranceCompanyPlanList
        ( Name ,
          Address1 ,
          Address2 ,
          City ,
          State ,
          Zip
        )
SELECT DISTINCT
		  i.ptins3name , -- Name - varchar(128)
          i.ptins3addressstreet1 , -- Address1 - varchar(128)
          i.ptins3addressstreet2 , -- Address2 - varchar(128)
          i.ptins3addresscity , -- City - varchar(100)
          i.ptins3addressstate , -- State - varchar(2)
          CASE WHEN i.ptins3addresszipcode = '' THEN i.ptins3addresszipplus4 ELSE i.ptins3addresszipcode END +
			CASE WHEN LEN(i.ptins3addresszipplus4) = 3 THEN '0' + i.ptins3addresszipplus4
	           WHEN LEN(i.ptins3addresszipplus4) = 4 THEN i.ptins3addresszipplus4
			ELSE '' END -- Zip - varchar(9)
FROM dbo._import_59_68_ValantDataExportbf99c17ccc7847b i
INNER JOIN #PatNoExist pat ON 
	i.ptid = pat.VendorID
WHERE ptins3name <> '' AND
	  NOT EXISTS (
				  SELECT * FROM #InsuranceCompanyPlanList icp 
				  WHERE i.ptins3name = icp.Name AND
						i.ptins3addressstreet1 = icp.Address1 AND
						CASE WHEN i.ptins3addresszipcode = '' THEN i.ptins3addresszipplus4 ELSE i.ptins3addresszipcode END +
							CASE WHEN LEN(i.ptins3addresszipplus4) = 3 THEN '0' + i.ptins3addresszipplus4
							WHEN LEN(i.ptins3addresszipplus4) = 4 THEN i.ptins3addresszipplus4
						ELSE '' END  = icp.Zip
				  ) 

--ALTER TABLE dbo._import_59_68_ValantDataExportbf99c17ccc7847b 
--	ADD PrimaryIns INT , SecondaryIns INT , TertiaryIns INT

UPDATE i
	SET PrimaryIns = icp.ID 
FROM dbo._import_59_68_ValantDataExportbf99c17ccc7847b i
	INNER JOIN #InsuranceCompanyPlanList icp ON 
		i.ptins1name = icp.Name AND
		i.ptins1addressstreet1 = icp.Address1 AND
		CASE WHEN i.ptins1addresszipcode = '' THEN i.ptins1addresszipplus4 ELSE i.ptins1addresszipcode END +
			CASE WHEN LEN(i.ptins1addresszipplus4) = 3 THEN '0' + i.ptins1addresszipplus4
	           WHEN LEN(i.ptins1addresszipplus4) = 4 THEN i.ptins1addresszipplus4
		 ELSE '' END  = icp.Zip

UPDATE i
	SET SecondaryIns = icp.ID 
FROM dbo._import_59_68_ValantDataExportbf99c17ccc7847b i
	INNER JOIN #InsuranceCompanyPlanList icp ON 
		i.ptins2name = icp.Name AND
		i.ptins2addressstreet1 = icp.Address1 AND
        CASE WHEN i.ptins2addresszipcode = '' THEN i.ptins2addresszipplus4 ELSE i.ptins2addresszipcode END +
			CASE WHEN LEN(i.ptins2addresszipplus4) = 3 THEN '0' + i.ptins2addresszipplus4
	           WHEN LEN(i.ptins2addresszipplus4) = 4 THEN i.ptins2addresszipplus4
		 ELSE '' END  = icp.Zip

UPDATE i
	SET TertiaryIns = icp.ID 
FROM dbo._import_59_68_ValantDataExportbf99c17ccc7847b i
	INNER JOIN #InsuranceCompanyPlanList icp ON 
		i.ptins3name = icp.Name AND
		i.ptins3addressstreet1 = icp.Address1 AND
        CASE WHEN i.ptins3addresszipcode = '' THEN i.ptins3addresszipplus4 ELSE i.ptins3addresszipcode END +
			CASE WHEN LEN(i.ptins3addresszipplus4) = 3 THEN '0' + i.ptins3addresszipplus4
	           WHEN LEN(i.ptins3addresszipplus4) = 4 THEN i.ptins3addresszipplus4
		ELSE '' END = icp.Zip

INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
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
		  i.Name , -- PlanName - varchar(128)
          i.Address1 , -- AddressLine1 - varchar(256)
          i.Address2 , -- AddressLine2 - varchar(256)
          i.City , -- City - varchar(128)
          i.[State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.Zip , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          i.ID , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM #InsuranceCompanyPlanList i 
	INNER JOIN dbo.InsuranceCompany ic ON 
		ic.InsuranceCompanyID = (SELECT MIN(ic2.InsuranceCompanyID) FROM dbo.InsuranceCompany ic2 
				  WHERE i.Name = ic2.InsuranceCompanyName AND (ic2.CreatedPracticeID = @PracticeID OR ic2.ReviewCode = 'R'))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' InsuranceCompanyPlan - Existing Company records inserted'

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
          EmergencyPhone 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          i.ptnamefirst , -- FirstName - varchar(64)
          i.ptnamemi , -- MiddleName - varchar(64)
          i.ptnamelast , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.ptaddressstreet1 , -- AddressLine1 - varchar(256)
          i.ptaddressstreet2 , -- AddressLine2 - varchar(256)
          i.ptaddresscity , -- City - varchar(128)
          i.ptaddressstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN i.ptaddresszipcode = '' THEN i.ptaddresszipplus4 ELSE i.ptaddresszipcode END +
			CASE WHEN LEN(i.ptaddresszipplus4) = 3 THEN '0' + i.ptaddresszipplus4
	           WHEN LEN(i.ptaddresszipplus4) = 4 THEN i.ptaddresszipplus4
		  ELSE '' END  , -- ZipCode - varchar(9)
          CASE i.ptsex 
			WHEN 'F' THEN 'F'
			WHEN 'M' THEN 'M'
		  ELSE 'U' END , -- Gender - varchar(1)
          m.MaritalStatus , -- MaritalStatus - varchar(1)
          CASE WHEN i.ptphonemaintype = 'Home' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphonemain),10) ELSE
			CASE WHEN i.ptphone2type = 'Home' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphone2),10) ELSE 
				CASE WHEN i.ptphone3type = 'Home' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphone3),10)  
					ELSE '' END 
				END 
		  END , -- HomePhone - varchar(10)
          CASE WHEN i.ptphonemaintype = 'Home' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphonemainextension),10) ELSE
			CASE WHEN i.ptphone2type = 'Home' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphone2extension),10) ELSE 
				CASE WHEN i.ptphone3type = 'Home' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphone3extension),10)  
					ELSE '' END 
				END 
		  END , -- HomePhoneExt - varchar(10)
          CASE WHEN i.ptphonemaintype = 'Work' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphonemain),10) ELSE
			CASE WHEN i.ptphone2type = 'Work' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphone2),10) ELSE 
				CASE WHEN i.ptphone3type = 'Work' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphone3),10)  
					ELSE '' END 
				END 
		  END , -- WorkPhone - varchar(10)
          CASE WHEN i.ptphonemaintype = 'Work' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphonemainextension),10) ELSE
			CASE WHEN i.ptphone2type = 'Work' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphone2extension),10) ELSE 
				CASE WHEN i.ptphone3type = 'Work' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphone3extension),10)  
					ELSE '' END 
				END 
		  END  , -- WorkPhoneExt - varchar(10)
		  CASE
		  WHEN ISDATE(i.ptbirthdate) = 1 THEN DATEADD(hh,12,CAST(i.ptbirthdate AS DATETIME))
		  ELSE '1901-01-01 12:00:00.000' END , -- DOB - datetime
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ptssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.ptssn),9) END , -- SSN - char(9)
          i.ptemailhome , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          i.ptid , -- MedicalRecordNumber - varchar(128)
          CASE WHEN i.ptphonemaintype = 'Mobile' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphonemain),10) ELSE
			CASE WHEN i.ptphone2type = 'Mobile' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphone2),10) ELSE 
				CASE WHEN i.ptphone3type = 'Mobile' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphone3),10)  
					ELSE '' END 
				END 
		  END , -- MobilePhone - varchar(10)
          CASE WHEN i.ptphonemaintype = 'Mobile' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphonemainextension),10) ELSE
			CASE WHEN i.ptphone2type = 'Mobile' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphone2extension),10) ELSE 
				CASE WHEN i.ptphone3type = 'Mobile' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptphone3extension),10)  
					ELSE '' END 
				END 
		  END , -- MobilePhoneExt - varchar(10)
          i.ptid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
          CASE WHEN i.ptemergencycontactnote <> '' THEN i.ptemergencycontactname + ' - ' + i.ptemergencycontactnote
		  ELSE i.ptemergencycontactname END , -- EmergencyName - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptemergencycontactphone),10)  -- EmergencyPhone - varchar(10)
FROM dbo._import_59_68_ValantDataExportbf99c17ccc7847b i 
INNER JOIN #PatNoExist pat ON 
	i.ptid = pat.VendorID
LEFT JOIN dbo.MaritalStatus m ON 
	i.ptmartialstatus = m.LongName
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient records inserted'

INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	PatientID , 
	'Default Case' ,  -- Name - varchar(128)
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
	VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' PatientCase records inserted'

INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT		
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.ptins1idnumber , -- PolicyNumber - varchar(32)
          i.ptins1groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.ptins1effectivedatestart) = 1 THEN i.ptins1effectivedatestart
		  ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.ptins1effectivedateend) = 1 THEN i.ptins1effectivedatestart
		  ELSE NULL END , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
		  pc.VendorID , 
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_59_68_ValantDataExportbf99c17ccc7847b i
	INNER JOIN dbo.PatientCase pc ON 
		i.ptid = pc.VendorID AND
        pc.VendorImportID = @VendorImportID 
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.primaryins = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Primary - InsurancePolicy Records Inserted'

INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT		
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.ptins2idnumber , -- PolicyNumber - varchar(32)
          i.ptins2groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.ptins2effectivedatestart) = 1 THEN i.ptins2effectivedatestart
		  ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.ptins2effectivedateend) = 1 THEN i.ptins2effectivedateend
		  ELSE NULL END , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
		  pc.VendorID , 
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_59_68_ValantDataExportbf99c17ccc7847b i
	INNER JOIN dbo.PatientCase pc ON 
		i.ptid = pc.VendorID AND
        pc.VendorImportID = @VendorImportID 
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.secondaryins = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Secondary - InsurancePolicy Records Inserted'

--INSERT INTO dbo.InsurancePolicy
--        ( PatientCaseID ,
--          InsuranceCompanyPlanID ,
--          Precedence ,
--          PolicyNumber ,
--          GroupNumber ,
--          PolicyStartDate ,
--          PolicyEndDate ,
--          CardOnFile ,
--          PatientRelationshipToInsured ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          Active ,
--          PracticeID ,
--          VendorID ,
--          VendorImportID ,
--          ReleaseOfInformation 
--        )
--SELECT DISTINCT		
--		  pc.PatientCaseID , -- PatientCaseID - int
--          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
--          3 , -- Precedence - int
--          i.ptins3idnumber , -- PolicyNumber - varchar(32)
--          i.ptins3groupnumber , -- GroupNumber - varchar(32)
--          CASE WHEN ISDATE(i.ptins3effectivedatestart) = 1 THEN i.ptins3effectivedatestart
--		  ELSE NULL END , -- PolicyStartDate - datetime
--          CASE WHEN ISDATE(i.ptins3effectivedateend) = 1 THEN i.ptins3effectivedateend
--		  ELSE NULL END , -- PolicyEndDate - datetime
--          0 , -- CardOnFile - bit
--          'S' , -- PatientRelationshipToInsured - varchar(1)
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          1 , -- Active - bit
--          @PracticeID , -- PracticeID - int
--		  pc.VendorID , 
--          @VendorImportID , -- VendorImportID - int
--          'Y'  -- ReleaseOfInformation - varchar(1)
--FROM dbo._import_59_68_ValantDataExportbf99c17ccc7847b i
--	INNER JOIN dbo.PatientCase pc ON 
--		i.ptid = pc.VendorID AND
--        pc.VendorImportID = @VendorImportID 
--	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
--		i.tertiaryins = icp.VendorID AND 
--		icp.VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Tertiary - InsurancePolicy Records Inserted'

INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          CASE i.facilityid
			WHEN 'Clayton Clinic' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS- Clayton' AND PracticeID = @PracticeID)  
			WHEN 'Clayton CCSS' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS - Clayton CCSS' AND PracticeID = @PracticeID)
			WHEN 'Clayton PSR' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS- Clayton' AND PracticeID = @PracticeID)
			WHEN 'Raton CCSS' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS - Raton CCSS' AND PracticeID = @PracticeID)
			WHEN 'Raton Clinic' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS- Raton' AND PracticeID = @PracticeID)
			WHEN 'Raton PSR' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS- Raton' AND PracticeID = @PracticeID)
			WHEN 'Taos ACT' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS - Taos ACT' AND PracticeID = @PracticeID)
			WHEN 'Taos CCSS' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS - Taos CCSS' AND PracticeID = @PracticeID)
			WHEN 'Taos Clinic' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS- Taos' AND PracticeID = @PracticeID)
			WHEN 'Taos Drug Court' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS - Taos Drug Court' AND PracticeID = @PracticeID)
			WHEN 'Taos DWI' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS - Taos DWI' AND PracticeID = @PracticeID)
			WHEN 'Taos Forensic' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS - Taos Forensic' AND PracticeID = @PracticeID)
			WHEN 'TAOS IOP' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS - TAOS IOP' AND PracticeID = @PracticeID)
			WHEN 'Taos PSR' THEN (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE Name = 'TCCS - Taos PSR' AND PracticeID = @PracticeID)
		  ELSE 90 END , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.AutoTempID , -- Subject - varchar(64)
          CASE WHEN d.DoctorID IS NULL THEN 'Appointment Record Created to a Default Provider Record. Please Update this Appointment Record to the correct Provider Resource.' 
		  + CHAR(13) + CHAR(10) + 'Provider From Import File: ' + i.patientid + CHAR(13) + CHAR(10) ELSE '' END +
		  'Primary CPTcode: ' + i.primarycptcode +
		  CASE WHEN i.appointmentnote <> '' THEN CHAR(13) + CHAR(10) + i.appointmentnote ELSE '' END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          Dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo._import_59_68_AppointmentsByFacilityThenDay i
	INNER JOIN dbo.Patient p ON	
		i.patvendorid = p.VendorID AND 
        p.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON
		pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2 
							WHERE pc2.PatientID = p.PatientID AND pc2.PracticeID = @PracticeID)
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.Doctor d ON 
		i.patientid = D.LastName + ' ' + LEFT(d.FirstName,1) AND 
		d.ActiveDoctor = 1 AND
        d.[External] = 0 AND 
		d.PracticeID = @PracticeID
WHERE i.startdate <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment Records inserted'

INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment a 
	INNER JOIN dbo._import_59_68_AppointmentsByFacilityThenDay i ON 
		a.[Subject] = i.AutoTempID AND 
		a.PracticeID = @PracticeID
	INNER JOIN dbo.AppointmentReason ar ON	
		i.primarycptcode = ar.Name and 
		ar.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' AppointmentToAppointmentReason Records inserted'

INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE WHEN d.DoctorID IS NULL THEN (SELECT MIN(DoctorID)
											 FROM dbo.Doctor
											 WHERE [External] = 0 AND
												   ActiveDoctor = 1 AND
												   PracticeID = @PracticeID)
		  ELSE d.DoctorID END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_59_68_AppointmentsByFacilityThenDay i
	INNER JOIN dbo.Appointment a ON 
		a.[Subject] = i.AutoTempID AND 
		a.PracticeID = @PracticeID
	LEFT JOIN dbo.Doctor d ON 
		i.patientid = D.LastName + ' ' + LEFT(d.FirstName,1) AND 
		d.ActiveDoctor = 1 AND
        d.[External] = 0 AND 
		d.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' AppointmentToResouce Records inserted'

DROP TABLE #InsuranceCompanyPlanList , #PatNoExist

--ROLLBACK
--COMMIT


SELECT DISTINCT i.patientid
FROM dbo._import_61_68_AppointmentsByFacilityThenDay i
	LEFT JOIN dbo.Doctor d ON 
		i.patientid = D.LastName + ' ' + LEFT(d.FirstName,1) AND 
		d.ActiveDoctor = 1 AND
        d.[External] = 0 AND 
		d.PracticeID = 68
WHERE d.DoctorID IS NULL ORDER BY i.patientid


SELECT FirstName , LastName , lastname + ' ' + LEFT(firstname,1) , doctorid FROM dbo.Doctor  WHERE [External] = 0 AND PracticeID = 68 AND ActiveDoctor = 1 ORDER BY DoctorID