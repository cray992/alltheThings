USE superbill_54979_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE 
@PatientID INT ,
@PatientCaseID INT ,
@InsurancePolicyID INT ,
@InsuranceCompanyPlanID INT , 
@InsuranceCompanyID INT , 
@EncounterID INT 

-----------------------------------------------------------------------------------
--Import has been wiped. Resetting user facing Primary IDs to lowest possible value--
SELECT
@PatientID = (SELECT MAX(PatientID) + 1 FROM dbo.Patient) ,
@PatientCaseID = (SELECT MAX(PatientCaseID) + 1 FROM dbo.PatientCase) , 
@InsurancePolicyID = (SELECT MAX(InsurancePolicyID) + 1 FROM dbo.InsurancePolicy) , 
@InsuranceCompanyPlanID = (SELECT MAX(InsuranceCompanyPlanID) + 1 FROM dbo.InsuranceCompanyPlan) , 
@InsuranceCompanyID = (SELECT MAX(InsuranceCompanyID) + 1 FROM dbo.InsuranceCompany) 
 
DBCC CHECKIDENT (Patient , RESEED, @PatientID )
DBCC CHECKIDENT (PatientCase , RESEED, @PatientCaseID )
DBCC CHECKIDENT (InsurancePolicy , RESEED, @InsurancePolicyID )
DBCC CHECKIDENT (InsuranceCompanyPlan , RESEED, @InsuranceCompanyPlanID )
DBCC CHECKIDENT (InsuranceCompany , RESEED, @InsuranceCompanyID )
DBCC CHECKIDENT (Encounter , RESEED, 0 )
GO
-----------------------------------------------------------------------------------


DECLARE @PracticeID INT , @VendorImportID INT

SET @PracticeID = 1 
SET @VendorImportID = 7

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting Into Insurance Company...'
-- Insurance (only if table exists)
--Insurance Company
 INSERT INTO dbo.InsuranceCompany
   ( InsuranceCompanyName , Notes , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , Phone , PhoneExt , Fax ,
     BillSecondaryInsurance , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode ,
     HCFASameAsInsuredFormatCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , SecondaryPrecedenceBillingFormID , 
	 VendorID , VendorImportID , NDCFormat , UseFacilityID , AnesthesiaType , InstitutionalBillingFormID )
 SELECT DISTINCT
     LEFT([name] , 128) , -- InsuranceCompanyName - varchar(128)
     Convert(Varchar(10), GETDATE(),101) + ' : Created via Data Import, please verify before use.', -- Notes - text
     [street1] , -- AddressLine1 - varchar(256)
     [street2] , -- AddressLine2 - varchar(256)
     [city] , -- City - varchar(128)
     LEFT([state] , 2) , -- State - varchar(2)
     '' , -- Country - varchar(32)
     CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters([zipcode])) IN (5,9) THEN (dbo.fn_RemoveNonNumericCharacters([zipcode]))
     WHEN LEN(dbo.fn_RemoveNonNumericCharacters([zipcode])) IN (4,8) THEN '0' + (dbo.fn_RemoveNonNumericCharacters([zipcode]))
     ELSE '' END , -- ZipCode - varchar(9)
     LEFT(dbo.fn_RemoveNonNumericCharacters([phone]) , 10) , -- Phone - varchar(10)
     LEFT(dbo.fn_RemoveNonNumericCharacters([extension]) , 10) , -- PhoneExt - varchar(10)
     LEFT(dbo.fn_RemoveNonNumericCharacters([fax]) , 10) , -- Fax - varchar(10)
     0 , -- BillSecondaryInsurance - bit
     CASE [defaultbillingmethod] WHEN 'Electronic' THEN 1 ELSE 0 END , -- EClaimsAccepts - bit
     13 , -- BillingFormID - int
     CASE [type] WHEN 'Blue Cross/Shield' THEN 'BL'
				 WHEN 'Medicare' THEN 'MB'
				 WHEN 'Medicaid' THEN 'MC'
				 WHEN 'Worker''s Comp' THEN 'WC'
			     WHEN 'Champus' THEN 'CH'
				 ELSE 'CI' END , -- InsuranceProgramCode - char(2)
     'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
     'D' , -- HCFASameAsInsuredFormatCode - char(1)
     @PracticeID , -- CreatedPracticeID - int
     GETDATE() , -- CreatedDate - datetime
     0 , -- CreatedUserID - int
     GETDATE() , -- ModifiedDate - datetime
     0 , -- ModifiedUserID - int
     13 , -- SecondaryPrecedenceBillingFormID - int
     [code] , -- VendorID - varchar(50)
     @VendorImportID , -- VendorImportID - int
     1 , -- NDCFormat - int
     1 , -- UseFacilityID - bit
     'U' , -- AnesthesiaType - varchar(1)
     18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_7_1_Insurances]
 WHERE RTRIM(LTRIM([Name])) <> '' AND
    [code] NOT IN (SELECT VendorID FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID AND CreatedPracticeID = @PracticeID)  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
 --Insurance Company Plan
INSERT INTO dbo.InsuranceCompanyPlan
   ( PlanName , AddressLine1 , AddressLine2 , City , State , ZipCode , Phone , PhoneExt , Notes , CreatedDate , CreatedUserID ,
     ModifiedDate , ModifiedUserID , CreatedPracticeID , Fax , InsuranceCompanyID , VendorID , VendorImportID )
SELECT DISTINCT
     LEFT(impIns.[name] , 128) , -- PlanName - varchar(128)
     impIns.[street1] , -- AddressLine1 - varchar(256)
     impIns.[street2] , -- AddressLine2 - varchar(256)
     impIns.[city] , -- City - varchar(128)
     LEFT(impIns.[state] , 2) , -- State - varchar(2)
     CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impIns.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(impIns.[zipcode])
     WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impIns.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(impIns.[zipcode])
     ELSE '' END , -- ZipCode - varchar(9)
     LEFT(dbo.fn_RemoveNonNumericCharacters(impIns.[phone]) , 10) , -- Phone - varchar(10)
     LEFT(dbo.fn_RemoveNonNumericCharacters(impIns.[extension]) , 10) , -- PhoneExt - varchar(10)
     Convert(Varchar(10), GETDATE(),101) + ' : Created via Data Import, please verify before use.' , -- Notes - text
     GETDATE() , -- CreatedDate - datetime
     0 , -- CreatedUserID - int
     GETDATE() , -- ModifiedDate - datetime
     0 , -- ModifiedUserID - int
     @PracticeID , -- CreatedPracticeID - int
     LEFT(dbo.fn_RemoveNonNumericCharacters(impIns.[fax]) , 10) , -- Fax - varchar(10)
     ic.[InsuranceCompanyID] , -- InsuranceCompanyID - int
     impIns.[code] , -- VendorID - varchar(50)
     @VendorImportID  -- VendorImportID - int
 FROM dbo.[_import_7_1_Insurances] AS impIns
 INNER JOIN dbo.InsuranceCompany AS ic ON
  ic.[VendorID] = impIns.[code] AND
  ic.[VendorImportID] = @VendorImportID AND
  ic.[CreatedPracticeID] = @PracticeID  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- Referring Doctor (only if table exists)

PRINT ''
PRINT 'Inserting into Doctor - Referring...'
--Referring Doctor
INSERT INTO dbo.Doctor
	( PracticeID , Prefix , FirstName , MiddleName , LastName , Suffix , AddressLine1 , AddressLine2 , City , State ,
	  ZipCode , HomePhone , WorkPhone , MobilePhone , EmailAddress , Notes , ActiveDoctor , CreatedDate , CreatedUserID ,
	  ModifiedDate , ModifiedUserID , Degree , VendorID , VendorImportID , FaxNumber , [External] )
SELECT DISTINCT
		@PracticeID , -- PracticeID - int
		'' , -- Prefix - varchar(16)
		impRph.[firstname] , -- FirstName - varchar(64)
		impRph.[middleinitial] , -- MiddleName - varchar(64)
		impRph.[lastname] , -- LastName - varchar(64)
		'' , -- Suffix - varchar(16)
		impRph.[street1] , -- AddressLine1 - varchar(256)
		impRph.[street2] , -- AddressLine2 - varchar(256)
		impRph.[city] , -- City - varchar(128)
		LEFT(impRph.[state] , 2) , -- State - varchar(2)
		CASE	WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impRph.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(impRph.[zipcode])
					WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impRph.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(impRph.[zipcode])
					ELSE '' END , -- ZipCode - varchar(9)
		LEFT(dbo.fn_RemoveNonNumericCharacters(impRph.[phone]) , 10) , -- HomePhone - varchar(10)
		LEFT(dbo.fn_RemoveNonNumericCharacters(impRph.[office]) , 10) , -- WorkPhone - varchar(10)
		LEFT(dbo.fn_RemoveNonNumericCharacters(impRph.[cell]) , 10) , -- MobilePhone - varchar(10)
		impRph.[email] , -- EmailAddress - varchar(256)
		CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' +
		CASE impRph.[licensenumber]	WHEN '' THEN ''
											ELSE CHAR(13)+CHAR(10) + 'License Number: ' + impRph.[licensenumber] END +
		CASE impRph.[medicarepin]	WHEN '' THEN ''
										ELSE CHAR(13)+CHAR(10) + 'Medicare PIN: ' + impRph.[medicarepin] END +
		CASE impRph.[medicaidpin] WHEN '' THEN ''
										ELSE CHAR(13)+CHAR(10) + 'Medicaid PIN: ' + impRph.[medicaidpin] END +
		CASE impRph.[champuspin]	WHEN '' THEN ''
										ELSE CHAR(13)+CHAR(10) + 'Champus PIN: ' + impRph.[champuspin] END +
		CASE impRph.[bluecrossshieldpin]	WHEN '' THEN ''
												ELSE CHAR(13)+CHAR(10) + 'Blue Cross / Shield PIN: ' + impRph.[bluecrossshieldpin] END +
		CASE impRph.[commercialpin]	WHEN '' THEN ''
											ELSE CHAR(13)+CHAR(10) + 'Commercial PIN: ' + impRph.[commercialpin] END +
		CASE impRph.[grouppin]	WHEN '' THEN ''
										ELSE CHAR(13)+CHAR(10) + 'Group PIN: ' + impRph.[grouppin] END +
		CASE impRph.[hmopin]	WHEN '' THEN ''
									ELSE CHAR(13)+CHAR(10) + 'HMO PIN: ' + impRph.[hmopin] END +
		CASE impRph.[ppopin]	WHEN '' THEN ''
									ELSE CHAR(13)+CHAR(10) + 'PPO PIN: ' + impRph.[ppopin] END +
		CASE impRph.[medicaregroupid]	WHEN '' THEN ''
											ELSE CHAR(13)+CHAR(10) + 'Medicare Group ID: ' + impRph.[medicaregroupid] END +
		CASE impRph.[medicaidgroupid] WHEN '' THEN ''
											ELSE CHAR(13)+CHAR(10) + 'Medicaid Group ID: ' + impRph.[medicaidgroupid] END +
		CASE impRph.[bcbsgroupid] WHEN '' THEN ''
										ELSE CHAR(13)+CHAR(10) + 'BC/BS Group ID: ' + impRph.[bcbsgroupid] END + 
		CASE impRph.[othergroupid]	WHEN '' THEN ''
											ELSE CHAR(13)+CHAR(10) + 'Other Group ID: ' + impRph.[othergroupid] END +
		CASE impRph.[upin]	WHEN '' THEN ''
									ELSE CHAR(13)+CHAR(10) + 'UPIN: ' + impRph.[upin] END , -- Notes - text
		CASE impRph.[inactive] WHEN '1' THEN 0 ELSE 1 END , -- ActiveDoctor - bit
		GETDATE() , -- CreatedDate - datetime
		0 , -- CreatedUserID - int
		GETDATE() , -- ModifiedDate - datetime
		0 , -- ModifiedUserID - int
		LEFT(impRph.[credentials] , 8) , -- Degree - varchar(8)
		impRph.[code] , -- VendorID - varchar(50)
		@VendorImportID , -- VendorImportID - int
		LEFT(dbo.fn_RemoveNonNumericCharacters(impRph.[fax]) , 10) , -- FaxNumber - varchar(10)
		1  -- External - bit
	FROM dbo.[_import_7_1_ReferringPhys] AS impRph
	WHERE impRph.[firstname] <> '' AND impRph.[lastname] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



-- Patients (only if table exists)

 CREATE TABLE #tempcaseinfo
(
	ChartNumber VARCHAR(50) ,
	CaseNumber INT ,
	Guarantor VARCHAR(50) ,
	MaritalStatus VARCHAR(50) ,
	StudentStatus VARCHAR(50) , 
	EmploymentStatus VARCHAR(50)
)

INSERT INTO #tempcaseinfo
        ( ChartNumber ,
          CaseNumber ,
          Guarantor ,
          MaritalStatus ,
          EmploymentStatus
        )
SELECT DISTINCT
	      ci.chartnumber , -- ChartNumber - varchar(50)
          ci.casenumber , -- CaseNumber - int
          ci.guarantor , -- Guarantor - varchar(50)
          ci.maritalstatus , -- MaritalStatus - varchar(50)
          ci.employmentstatus  -- EmploymentStatus - varchar(50)
FROM dbo.[_import_7_1_CaseInformation] AS ci
	LEFT JOIN dbo.[_import_7_1_CaseInformation] AS ci2 ON
		ci.chartnumber = ci2.chartnumber AND CAST(ci.casenumber AS INT) < CAST(ci2.casenumber AS INT)
WHERE ci2.chartnumber IS NULL 

PRINT ''
PRINT 'Inserting Into Patient...'
--Patient
INSERT INTO dbo.Patient
	( PracticeID , Prefix , FirstName , MiddleName , LastName , Suffix , AddressLine1 ,	AddressLine2 , City , State , ZipCode ,
	  Country , Gender , HomePhone , WorkPhone , DOB , SSN , EmailAddress , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID ,
      PrimaryProviderID , MedicalRecordNumber , MobilePhone , PrimaryCarePhysicianID , VendorID , VendorImportID , Active ,
	  SendEmailCorrespondence , EmergencyName , EmergencyPhone , ResponsibleDifferentThanPatient , ResponsiblePrefix , ResponsibleFirstName ,
	  ResponsibleMiddleName , ResponsibleLastName , ResponsibleSuffix , ResponsibleRelationshipToPatient , ResponsibleAddressLine1 ,
      ResponsibleAddressLine2 , ResponsibleCity , ResponsibleState , ResponsibleCountry , ResponsibleZipCode , EmploymentStatus , 
	  MaritalStatus)
SELECT DISTINCT
     @PracticeID , -- PracticeID - int
     '' , -- Prefix - varchar(16)
     impPat.[firstname] , -- FirstName - varchar(64)
     impPat.[middleinitial] , -- MiddleName - varchar(64)
     impPat.[lastname] , -- LastName - varchar(64)
     '' , -- Suffix - varchar(16)
     impPat.[street1] , -- AddressLine1 - varchar(256)
     impPat.[street2] , -- AddressLine2 - varchar(256)
     impPat.[city] , -- City - varchar(128)
     LEFT(UPPER(impPat.[state]) , 2) , -- State - varchar(2)
     CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impPat.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(impPat.[zipcode])
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impPat.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(impPat.[zipcode])
     ELSE '' END , -- ZipCode - varchar(9)
	 '' , -- Country
     CASE impPat.[sex] WHEN 'Male' THEN 'M'
					   WHEN 'Female' THEN 'F'
					   ELSE 'U' END , -- Gender - varchar(1)
     LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[phone1]),10) , -- HomePhone - varchar(10)
     LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[phone2]),10) , -- WorkPhone - varchar(10)
     CASE WHEN ISDATE(impPat.[dateofbirth]) = 1 THEN impPat.dateofbirth	ELSE NULL END , -- DOB - datetime
     CASE impPat.[socialsecuritynumber] WHEN '' THEN '' ELSE RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(impPat.[socialsecuritynumber]) , 9) END , -- SSN - char(9)
     impPat.email , -- EmailAddress - varchar(256)
     GETDATE() , -- CreatedDate - datetime
     0 , -- CreatedUserID - int
     GETDATE() , -- ModifiedDate - datetime
     0 , -- ModifiedUserID - int
     doc.[DoctorID] , -- PrimaryProviderID - int
     impPat.[chartnumber] , -- MedicalRecordNumber - varchar(128)
     LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[phone3]),10) , -- MobilePhone - varchar(10)
     doc.[DoctorID] , -- PrimaryCarePhysicianID - int
     impPat.[chartnumber] , -- VendorID - varchar(50)
     @VendorImportID , -- VendorImportID - int
     CASE impPat.[Inactive] WHEN 1 THEN 0 ELSE 1 END , -- Active - bit
     CASE impPat.[email] WHEN '' THEN 0 ELSE 1 END , -- SendEmailCorrespondence - bit
     impPat.[contactname] , -- EmergencyName - varchar(128)
     CASE impPat.[contactphone1] WHEN '' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[contactphone2]) , 10) ELSE LEFT(dbo.fn_RemoveNonNumericCharacters(impPat.[contactphone1]) , 10) END , -- EmergencyPhone - varchar(10)
	 CASE WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN 1 ELSE 0 END AS [ResponsibleDifferentThanPatient], -- ResponsibleDifferentThanPatient 
	 CASE WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN '' END , -- ResponsiblePrefix 
	 CASE WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN gua.[firstname] END  , -- ResponsibleFirstName 
	 CASE WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN gua.[middleinitial] END  , -- ResponsibleMiddleName 
	 CASE WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN gua.[lastname] END   , -- ResponsibleLastName 
	 CASE WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN '' END , -- ResponsibleSuffix 
	 CASE WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN 'O' END , -- ResponsibleRelationshipToPatient 
	 CASE WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN LEFT(gua.[street1],256) END , -- ResponsibleAddressLine1 
	 CASE WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN LEFT(gua.[street2],256) END , -- ResponsibleAddressLine2 
	 CASE WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN LEFT(gua.[city],128) END , -- ResponsibleCity 
	 CASE WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN LEFT(UPPER(impPat.[state]),2) END  , -- ResponsibleState 
	 CASE WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN '' END , -- ResponsibleCountry 
	 CASE	
		WHEN impPat.[chartnumber] <> gua.[chartnumber] THEN 
			(CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(gua.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(gua.[zipcode])
				  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(gua.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(gua.[zipcode])
			  ELSE '' END) END , -- ResponsibleZipCode 
	 CASE tci.[EmploymentStatus]
		  WHEN 'Full Time' THEN 'E' 
		  WHEN 'Part Time' THEN 'E'
		  WHEN 'Retired' THEN 'R' 
	      ELSE 'U' END , -- EmploymentStatus - varchar(1) 
	 CASE tci.[MaritalStatus] 
		  WHEN 'Divorced' THEN 'D'
		  WHEN 'Annulled' THEN 'A'
		  WHEN 'Interlocutory' THEN 'I'
		  WHEN 'Legally Separated' THEN 'L'
		  WHEN 'Married' THEN 'M'
		  WHEN 'Polygamous' THEN 'P'
		  WHEN 'Domestic Partner' THEN 'T'
		  WHEN 'Widowed' THEN 'W' 
		  WHEN 'Single' THEN 'S'
		  WHEN 'Never Married' THEN 'S'
		  ELSE '' END  -- MaritalStatus - varchar(1)
FROM dbo.[_import_7_1_PatientData] AS impPat
	LEFT JOIN dbo.[_import_7_1_Providers] AS impPro ON
		impPro.[code] = impPat.[assignedprovider]
	LEFT JOIN dbo.Doctor AS doc ON
		doc.[FirstName] = impPro.[firstname] AND
		doc.[LastName] = impPro.[lastname] AND
		doc.[External] = 0 AND
		doc.[ActiveDoctor] = 1 AND
		doc.[PracticeID] = @PracticeID
	LEFT JOIN #tempcaseinfo AS tci ON
		impPat.[chartnumber] = tci.[chartnumber] 
	LEFT JOIN dbo.[_import_7_1_PatientData] AS gua ON
		tci.[guarantor] = gua.[chartnumber]
	LEFT JOIN dbo.Patient p ON 
		impPat.firstname = p.FirstName AND
		impPat.lastname = p.LastName AND 
		DATEADD(hh,12,CAST(impPat.dateofbirth AS DATETIME)) = p.DOB AND
		p.PracticeID = @PracticeID
WHERE p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- Patient Cases, Case Dates and Policies (onlyl if table exists)

PRINT ''
PRINT 'Inserting Into Patient Case...'
 --Patient Case (Depends on patient records already being imported, can only run after)
 INSERT INTO dbo.PatientCase
   ( PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag ,
     OtherAccidentRelatedFlag , AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies ,
     CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , PracticeID , VendorID , VendorImportID , PregnancyRelatedFlag ,
     StatementActive , EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag )
SELECT DISTINCT
	 realP.[PatientID] , -- PatientID - int
     CASE WHEN impCas.[description] = '' THEN 'Default Case' ELSE impCas.[description] END , -- Name - varchar(128)
     1 , -- Active - bit
     5 , -- Commercial
     realdoc.[DoctorID] , -- ReferringPhysicianID - int
     CASE WHEN impCas.[relatedtoemployment] = 1 AND impCas.[natureofaccident] LIKE 'Work Injury%' THEN 1 ELSE 0 END , -- EmploymentRelatedFlag - bit
     CASE WHEN impCas.[relatedtoaccident] = 'Auto' AND impCas.[accidentstate] <> '' THEN 1 ELSE 0 END , -- AutoAccidentRelatedFlag - bit
     CASE WHEN impCas.[relatedtoaccident] = 'Yes' AND impCas.[relatedtoemployment] <> 1 THEN 1 ELSE 0 END , -- OtherAccidentRelatedFlag - bit
     0 , -- AbuseRelatedFlag - bit
     CASE WHEN impCas.[relatedtoaccident] = 'Auto' AND impCas.[accidentstate] <> '' THEN LEFT(impCas.[accidentstate] , 2) ELSE '' END , -- AutoAccidentRelatedState - char(2)
     CASE WHEN impCas.comment <> '' THEN 'Comment: ' + impCas.comment + CHAR(13)+CHAR(10) +
     CHAR(13)+CHAR(10) + 'Medisoft Case Number: ' + impCas.[CaseNumber] ELSE 'Medisoft Case Number: ' + impCas.[CaseNumber] END , -- Notes - text
     0 , -- ShowExpiredInsurancePolicies - bit
     GETDATE() , -- CreatedDate - datetime
     0 , -- CreatedUserID - int
     GETDATE() , -- ModifiedDate - datetime
     0 , -- ModifiedUserID - int
     @PracticeID , -- PracticeID - int
     realp.VendorID + impCas.casenumber, -- VendorID - varchar(50)
     @VendorImportID , -- VendorImportID - int
     CASE WHEN impCas.[pregnancyindicator] = 1 THEN 1 ELSE 0 END , -- PregnancyRelatedFlag - bit
     CASE WHEN impCas.[printpatientstatements] = 1 THEN 1 ELSE 0 END , -- StatementActive - bit
     CASE WHEN impCas.[epsdt] = 1 THEN 1 ELSE 0 END , -- EPSDT - bit
     CASE WHEN impCas.[familyplanning] = 1 THEN 1 ELSE 0 END , -- FamilyPlanning - bit
     1 , -- EPSDTCodeID - int
     CASE WHEN impCas.[emergency] = 1 THEN 1 ELSE 0 END , -- EmergencyRelated - bit
     CASE WHEN impCas.[homeboundindicator] = 1 THEN 1 ELSE 0 END  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.Patient AS realP ON
		realp.VendorID = impCas.chartnumber AND
		realp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.Doctor AS realdoc ON
		realdoc.[VendorID] = impCas.[referringprovider] AND
		realdoc.[VendorImportID] = @VendorImportID AND
		realdoc.[PracticeID] = @PracticeID AND
		realdoc.ActiveDoctor = 1 AND
		realdoc.[External] = 1
WHERE impCas.chartnumber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	--PatientCaseDate
	INSERT INTO dbo.PatientCaseDate
			( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate ,
			  ModifiedUserID )
	SELECT DISTINCT
			  @PracticeID , -- PracticeID - int
			  realpc.[PatientCaseID] , -- PatientCaseID - int
			  1 , -- PatientCaseDateTypeID - int
			  CASE WHEN ISDATE(impCas.[datefirstconsulted]) = 1 THEN impCas.[datefirstconsulted]
				   ELSE NULL END , -- StartDate - datetime
			  NULL , -- EndDate - datetime
			  GETDATE() , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  0  -- ModifiedUserID - int
	FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID AND
		realpc.[VendorImportID] = @VendorImportID
	WHERE impCas.datefirstconsulted <> ''

	--PatientCaseDate
	INSERT INTO dbo.PatientCaseDate
			( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate ,
			  ModifiedUserID )
	SELECT DISTINCT
			  @PracticeID , -- PracticeID - int
			  realpc.[PatientCaseID] , -- PatientCaseID - int
			  2 , -- PatientCaseDateTypeID - int
			  CASE WHEN ISDATE(impCas.[dateofinjuryillness]) = 1 THEN impCas.[dateofinjuryillness]
				   ELSE NULL END , -- StartDate - datetime
			  NULL , -- EndDate - datetime
			  GETDATE() , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  0  -- ModifiedUserID - int
	FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID AND
		realpc.[VendorImportID] = @VendorImportID
	WHERE impCas.[dateofinjuryillness] <> ''

	--PatientCaseDate
	INSERT INTO dbo.PatientCaseDate
			( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate ,
			  ModifiedUserID )
	SELECT DISTINCT
			  @PracticeID , -- PracticeID - int
			  realpc.[PatientCaseID] , -- PatientCaseID - int
			  3 , -- PatientCaseDateTypeID - int
			  CASE	WHEN ISDATE(impCas.[datesimilarsymptoms]) = 1 THEN impCas.[datesimilarsymptoms]
					ELSE NULL END , -- StartDate - datetime
			  NULL , -- EndDate - datetime
			  GETDATE() , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  0  -- ModifiedUserID - int
	FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID AND
		realpc.[VendorImportID] = @VendorImportID
	WHERE impCas.[datesimilarsymptoms] <> ''


	--PatientCaseDate
	INSERT INTO dbo.PatientCaseDate
			( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate ,
			  ModifiedUserID )
	SELECT DISTINCT
			  @PracticeID , -- PracticeID - int
			  realpc.[PatientCaseID] , -- PatientCaseID - int
			  4 , -- PatientCaseDateTypeID - int
			  CASE	WHEN ISDATE(impCas.[dateunabletoworkfrom]) = 1 THEN impCas.[dateunabletoworkfrom]
					ELSE NULL END , -- StartDate - datetime
			  CASE	WHEN ISDATE(impCas.[dateunabletoworkto]) = 1 THEN impCas.[dateunabletoworkto]
					ELSE NULL END , -- EndDate - datetime
			  GETDATE() , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  0  -- ModifiedUserID - int
	FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID AND
		realpc.[VendorImportID] = @VendorImportID
	WHERE impCas.[dateunabletoworkfrom] <> ''

	--PatientCaseDate
	INSERT INTO dbo.PatientCaseDate
			( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate ,
			  ModifiedUserID )
	SELECT DISTINCT
			  @PracticeID , -- PracticeID - int
			  realpc.[PatientCaseID] , -- PatientCaseID - int
			  5 , -- PatientCaseDateTypeID - int
			  CASE	WHEN ISDATE(impCas.[datetotdisabilityfrom]) = 1 THEN impCas.[datetotdisabilityfrom]
					ELSE NULL END , -- StartDate - datetime
			  CASE	WHEN ISDATE(impCas.[datetotdisabilityto]) = 1 THEN impCas.[datetotdisabilityto]
					ELSE NULL END , -- EndDate - datetime
			  GETDATE() , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  0  -- ModifiedUserID - int
	FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID AND
		realpc.[VendorImportID] = @VendorImportID
	WHERE impCas.[datetotdisabilityfrom] <> ''


	--PatientCaseDate
	INSERT INTO dbo.PatientCaseDate
			( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate ,
			  ModifiedUserID )
	SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
			  realpc.[PatientCaseID] , -- PatientCaseID - int
			  6 , -- PatientCaseDateTypeID - int
			  CASE	WHEN ISDATE(impCas.[hospitaldatefrom]) = 1 THEN impCas.[hospitaldatefrom]
					ELSE NULL END , -- StartDate - datetime
			  CASE	WHEN ISDATE(impCas.[hospitaldateto]) = 1 THEN impCas.[hospitaldateto]
					ELSE NULL END , -- EndDate - datetime
			  GETDATE() , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  0  -- ModifiedUserID - int
	FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID AND
		realpc.[VendorImportID] = @VendorImportID
	WHERE impCas.[hospitaldatefrom] <> ''

	--PatientCaseDate
	INSERT INTO dbo.PatientCaseDate
			( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate ,
			  ModifiedUserID )
	SELECT DISTINCT
			  @PracticeID , -- PracticeID - int
			  realpc.[PatientCaseID] , -- PatientCaseID - int
			  8 , -- PatientCaseDateTypeID - int
			  CASE	WHEN ISDATE(impCas.[lastvisitdate]) = 1 THEN impCas.[lastvisitdate]
					ELSE NULL END , -- StartDate - datetime
			  NULL , -- EndDate - datetime
			  GETDATE() , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  0  -- ModifiedUserID - int
	FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID AND
		realpc.[VendorImportID] = @VendorImportID
	WHERE impCas.[lastvisitdate] <> ''

	--PatientCaseDate
	INSERT INTO dbo.PatientCaseDate
			( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate ,
			  ModifiedUserID )
	SELECT DISTINCT
			  @PracticeID , -- PracticeID - int
			  realpc.[PatientCaseID] , -- PatientCaseID - int
			  9 , -- PatientCaseDateTypeID - int
			  CASE	WHEN ISDATE(impCas.[referraldate]) = 1 THEN impCas.[referraldate]
					ELSE NULL END , -- StartDate - datetime
			  NULL , -- EndDate - datetime
			  GETDATE() , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  0  -- ModifiedUserID - int
	FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID AND
		realpc.[VendorImportID] = @VendorImportID
	WHERE impCas.[referraldate] <> ''

	--PatientCaseDate
	INSERT INTO dbo.PatientCaseDate
			( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate ,
			  ModifiedUserID )
	SELECT DISTINCT
			  @PracticeID , -- PracticeID - int
			  realpc.[PatientCaseID] , -- PatientCaseID - int
			  10 , -- PatientCaseDateTypeID - int
			  CASE	WHEN ISDATE(impCas.dateofmanifestation) = 1 THEN impCas.dateofmanifestation
					ELSE NULL END , -- StartDate - datetime
			  NULL , -- EndDate - datetime
			  GETDATE() , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  0  -- ModifiedUserID - int
	FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID AND
		realpc.[VendorImportID] = @VendorImportID
	WHERE impCas.[dateofmanifestation] <> ''

	--PatientCaseDate
	INSERT INTO dbo.PatientCaseDate
			( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate ,
			  ModifiedUserID )
	SELECT DISTINCT
			  @PracticeID , -- PracticeID - int
			  realpc.[PatientCaseID] , -- PatientCaseID - int
			  11 , -- PatientCaseDateTypeID - int
			  CASE	WHEN ISDATE(impCas.[lastxraydate]) = 1 THEN impCas.[lastxraydate]
					ELSE NULL END , -- StartDate - datetime
			  NULL , -- EndDate - datetime
			  GETDATE() , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  0  -- ModifiedUserID - int
	FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID AND
		realpc.[VendorImportID] = @VendorImportID
	WHERE impCas.[lastxraydate] <> ''


	--PatientCaseDate
	INSERT INTO dbo.PatientCaseDate
			( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate ,
			  ModifiedUserID )
	SELECT DISTINCT
			  @PracticeID , -- PracticeID - int
			  realpc.[PatientCaseID] , -- PatientCaseID - int
			  12 , -- PatientCaseDateTypeID - int
			  CASE	WHEN impCas.relatedtoaccident IN ('Yes','Auto') THEN (CASE WHEN ISDATE(impCas.[dateofinjuryillness]) = 1 THEN impCas.[dateofinjuryillness] ELSE NULL END)
					ELSE NULL END , -- StartDate - datetime
			  NULL , -- EndDate - datetime
			  GETDATE() , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  0  -- ModifiedUserID - int
	FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID AND
		realpc.[VendorImportID] = @VendorImportID
	WHERE impCas.[dateofinjuryillness] <> '' AND impCas.[relatedtoaccident] <> ''

PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
   ( PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate ,
	 PatientRelationshipToInsured , HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB ,
     HolderSSN , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 ,
     HolderCity , HolderState , HolderCountry , HolderZipCode , HolderPhone , DependentPolicyNumber , Notes , Copay , Deductible ,
	 Active , PracticeID , VendorID , VendorImportID , ReleaseOfInformation)
SELECT DISTINCT
     realpc.[PatientCaseID] , -- PatientCaseID - int
     realicp.[InsuranceCompanyPlanID] , -- InsuranceCompanyPlanID - int
     1 , -- Precedence - int
     impCas.[policynumber1] , -- PolicyNumber - varchar(32)
     impCas.[groupnumber1] , -- GroupNumber - varchar(32)
     CASE WHEN ISDATE(impCas.[policy1startdate]) = 1 THEN impCas.[policy1startdate] ELSE NULL END , -- PolicyStartDate - datetime
     CASE WHEN ISDATE(impCas.[policy1enddate]) = 1 THEN impCas.[policy1enddate] ELSE NULL END , -- PolicyEndDate - datetime
     CASE impCas.[insuredrelationship1] WHEN 'Self' THEN 'S'
										WHEN 'Child' THEN 'C'
										WHEN 'Spouse' THEN 'U'
										ELSE 'O' END , -- PatientRelationshipToInsured -- varchar(1)
     '' , -- varchar(16)
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[firstname] END ,-- varchar(64)
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[middleinitial] END ,-- varchar(64)
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[lastname] END ,-- varchar(64)
     '' ,-- varchar(16)
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN (CASE WHEN ISDATE(holder.[dateofbirth]) = 1 THEN holder.[dateofbirth] ELSE NULL END) ELSE NULL END ,-- datetime
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[socialsecuritynumber] END ,-- char(11)
     GETDATE() , -- CreatedDate - datetime
     0 , -- CreatedUserID - int
     GETDATE() , -- ModifiedDate - datetime
     0 , -- ModifiedUserID - int
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN
		(CASE holder.[sex] WHEN 'F' THEN 'F'
						   WHEN 'M' THEN 'M'
		 ELSE 'U' END) END AS HolderGender ,-- char(1)
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[street1] END , -- varchar(256)
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[street2] END ,-- varchar(256)
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN holder.[city] END , -- varchar(128)
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN LEFT(holder.[state] , 2) END , -- varchar(2)
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN '' END , -- varchar(32)
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN
		(CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])
		      WHEN LEN(dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(holder.[zipcode]) ELSE '' END) END , -- varchar(9)
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN LEFT(dbo.fn_RemoveNonNumericCharacters(holder.[phone1]) , 10) END , -- varchar(10)
     CASE WHEN impCas.[insuredrelationship1] <> 'Self' AND impCas.[insured1] <> impCas.[chartnumber] THEN impCas.[policynumber1] END ,-- varchar(32)
     impCas.[notes] , -- Notes - text
     impCas.[copaymentamount] , -- Copay - money
     impCas.[annualdeductible] , -- Deductible - money
     1 , -- Active - bit
     @PracticeID , -- PracticeID - int
     impCas.[chartnumber] + impCas.casenumber , -- VendorID - varchar(50)
     @VendorImportID , -- VendorImportID - int
	 'Y'
FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
		realpc.[VendorImportID] = @VendorImportID AND
		realpc.[PracticeID] = @PracticeID
	INNER JOIN dbo.InsuranceCompanyPlan AS realicp ON
		realicp.[VendorID] = impCas.[insurancecarrier1] AND
		realicp.[VendorImportID] = @VendorImportID AND
		realicp.[CreatedPracticeID] = @PracticeID
	INNER JOIN 
		(SELECT DISTINCT [chartnumber] , [firstname] , [middleinitial] , [lastname] , [street1] , [street2] , [city] ,
		 [state] , [zipcode] , [phone1] , [socialsecuritynumber] , [sex] , [dateofbirth] 
		FROM dbo.[_import_7_1_PatientData]) holder ON
			holder.[chartnumber] = impCas.[insured1]    
WHERE impCas.policynumber1 <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
   ( PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate ,
	 PatientRelationshipToInsured , HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB ,
     HolderSSN , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 ,
     HolderCity , HolderState , HolderCountry , HolderZipCode , HolderPhone , DependentPolicyNumber , Notes , Active , PracticeID , 
	 VendorID , VendorImportID, ReleaseOfInformation )
SELECT DISTINCT
     realpc.[PatientCaseID] , -- PatientCaseID - int
     realicp.[InsuranceCompanyPlanID] , -- InsuranceCompanyPlanID - int
     2 , -- Precedence - int
     impCas.[policynumber2] , -- PolicyNumber - varchar(32)
     impCas.[groupnumber2] , -- GroupNumber - varchar(32)
     CASE WHEN ISDATE(impCas.[policy2startdate]) = 1 THEN impCas.[policy2startdate] ELSE NULL END , -- PolicyStartDate - datetime
     CASE WHEN ISDATE(impCas.[policy2enddate]) = 1 THEN impCas.[policy2enddate] ELSE NULL END , -- PolicyEndDate - datetime
     CASE impCas.[insuredrelationship2] WHEN 'Self' THEN 'S'
									    WHEN 'Child' THEN 'C'
									    WHEN 'Spouse' THEN 'U'
										ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
     '' , -- HolderPrefix - varchar(16)
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[firstname] END , -- HolderFirstName - varchar(64)
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[middleinitial] END , -- HolderMiddleName - varchar(64)
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[lastname] END , -- HolderLastName - varchar(64)
     '' , -- HolderSuffix - varchar(16)
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN (CASE WHEN ISDATE(holder.[dateofbirth]) = 1 THEN holder.[dateofbirth] ELSE NULL END) ELSE NULL END , -- HolderDOB - datetime
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[socialsecuritynumber] END , -- HolderSSN - char(11)
     GETDATE() , -- CreatedDate - datetime
     0 , -- CreatedUserID - int
     GETDATE() , -- ModifiedDate - datetime
     0 , -- ModifiedUserID - int
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN
		(CASE holder.[sex] WHEN 'F' THEN 'F'
						   WHEN 'M' THEN 'M'
						   ELSE 'U' END) END , -- HolderGender - char(1)
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[street1] END , -- HolderAddressLine1 - varchar(256)
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[street2] END , -- HolderAddressLine2 - varchar(256)
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN holder.[city] END , -- HolderCity - varchar(128)
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN LEFT(holder.[state] , 2) END , -- HolderState - varchar(2)
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN '' END , -- HolderCountry - varchar(32)
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN
		(CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])
			  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])
		 ELSE '' END) END, -- HolderZipCode - varchar(9)
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN LEFT(dbo.fn_RemoveNonNumericCharacters(holder.[phone1]) , 10) END , -- HolderPhone - varchar(10)
     CASE WHEN impCas.[insuredrelationship2] <> 'Self' AND impCas.[insured2] <> impCas.[chartnumber] THEN impCas.[policynumber2] END , -- DependentPolicyNumber - varchar(32)
     impCas.[notes] , -- Notes - text
     1 , -- Active - bit
     @PracticeID , -- PracticeID - int
     impCas.[chartnumber] + impCas.[casenumber] , -- VendorID - varchar(50)
     @VendorImportID , -- VendorImportID - int
	 'Y'
FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
		realpc.[VendorImportID] = @VendorImportID AND
		realpc.[PracticeID] = @PracticeID  
	INNER JOIN dbo.InsuranceCompanyPlan AS realicp ON
		realicp.[VendorID] = impCas.[insurancecarrier2] AND
		realicp.[VendorImportID] = @VendorImportID AND
		realicp.[CreatedPracticeID] = @PracticeID  
	INNER JOIN 
		(SELECT DISTINCT [chartnumber] , [firstname] , [middleinitial] , [lastname] , [street1] , [street2] , [city] ,
		 [state] , [zipcode] , [phone1] , [socialsecuritynumber] , [sex] , [dateofbirth] 
		 FROM dbo.[_import_7_1_PatientData]) AS holder ON
			holder.[chartnumber] = impCas.[insured2]
WHERE impCas.[policynumber2] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy...'
 INSERT INTO dbo.InsurancePolicy
   ( PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate ,
	 PatientRelationshipToInsured , HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB ,
     HolderSSN , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 ,
     HolderCity , HolderState , HolderCountry , HolderZipCode , HolderPhone , DependentPolicyNumber , Notes , Active , PracticeID , 
	 VendorID , VendorImportID , ReleaseOfInformation )
 SELECT DISTINCT
     realpc.[PatientCaseID] , -- PatientCaseID - int
     realicp.[InsuranceCompanyPlanID] , -- InsuranceCompanyPlanID - int
     3 , -- Precedence - int
     impCas.[policynumber3] , -- PolicyNumber - varchar(32)
     impCas.[groupnumber3] , -- GroupNumber - varchar(32)
     CASE WHEN ISDATE(impCas.[policy3startdate]) = 1 THEN impCas.[policy2startdate] ELSE NULL END , -- PolicyStartDate - datetime
     CASE WHEN ISDATE(impCas.[policy3enddate]) = 1 THEN impCas.[policy2enddate] ELSE NULL END , -- PolicyEndDate - datetime
     CASE impCas.[insuredrelationship3] WHEN 'Self' THEN 'S'
										WHEN 'Child' THEN 'C'
										WHEN 'Spouse' THEN 'U'
										ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
     '' , -- HolderPrefix - varchar(16)
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[firstname] END , -- HolderFirstName - varchar(64)
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[middleinitial] END , -- HolderMiddleName - varchar(64)
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[lastname] END , -- HolderLastName - varchar(64)
     '' , -- HolderSuffix - varchar(16)
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN (CASE WHEN ISDATE(holder.[dateofbirth]) = 1 THEN holder.[dateofbirth] ELSE NULL END) ELSE NULL END , -- HolderDOB - datetime
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[socialsecuritynumber] END , -- HolderSSN - char(11)
     GETDATE() , -- CreatedDate - datetime
     0 , -- CreatedUserID - int
     GETDATE() , -- ModifiedDate - datetime
     0 , -- ModifiedUserID - int
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN
		(CASE holder.[sex] WHEN 'F' THEN 'F'
						   WHEN 'M' THEN 'M'
						   ELSE 'U' END) END , -- HolderGender - char(1)
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[street1] END , -- HolderAddressLine1 - varchar(256)
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[street2] END , -- HolderAddressLine2 - varchar(256)
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN holder.[city] END , -- HolderCity - varchar(128)
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN LEFT(holder.[state] , 2) END , -- HolderState - varchar(2)
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN '' END , -- HolderCountry - varchar(32)
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN
		(CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])
			  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(holder.[zipcode])
		 ELSE '' END) END, -- HolderZipCode - varchar(9)
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN LEFT(dbo.fn_RemoveNonNumericCharacters(holder.[phone1]) , 10) END , -- HolderPhone - varchar(10)
     CASE WHEN impCas.[insuredrelationship3] <> 'Self' AND impCas.[insured3] <> impCas.[chartnumber] THEN impCas.[policynumber3] END , -- DependentPolicyNumber - varchar(32)
     impCas.[notes] , -- Notes - text
     1 , -- Active - bit
     @PracticeID , -- PracticeID - int
     impCas.[chartnumber] + impCas.casenumber , -- VendorID - varchar(50)
     @VendorImportID , -- VendorImportID - int
	 'Y'
FROM dbo.[_import_7_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.casenumber AND
		realpc.[VendorImportID] = @VendorImportID AND
		realpc.[PracticeID] = @PracticeID  
	INNER JOIN dbo.InsuranceCompanyPlan AS realicp ON
		realicp.[VendorID] = impCas.[insurancecarrier3] AND
		realicp.[VendorImportID] = @VendorImportID AND
		realicp.[CreatedPracticeID] = @PracticeID  
	INNER JOIN 
		(SELECT DISTINCT [chartnumber] , [firstname] , [middleinitial] , [lastname] , [street1] , [street2] , [city] ,
		 [state] , [zipcode] , [phone1] , [socialsecuritynumber] , [sex] , [dateofbirth]  
		FROM dbo.[_import_7_1_PatientData]) holder ON
			holder.[chartnumber] = impCas.[insured3] 
WHERE impCas.[policynumber3] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11 
FROM dbo.PatientCase pc
	LEFT JOIN dbo.InsurancePolicy ip ON
		pc.PatientCaseID = ip.PatientCaseID  
WHERE pc.VendorImportID = @VendorImportID AND
      PayerScenarioID = 5 AND 
      ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case - Balance Forwad...'
--Create PatientCase for Balance Forward
INSERT INTO dbo.PatientCase
	( PatientID , Name , Active , PayerScenarioID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag ,
      AbuseRelatedFlag , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID ,
      PracticeID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , EPSDT , FamilyPlanning , EPSDTCodeID ,
      EmergencyRelated , HomeboundRelatedFlag )
SELECT DISTINCT
	pat.PatientID , -- PatientID - int
    'Balance Forward' , -- Name - varchar(128)
    1 , -- Active - bit
    11 , -- PayerScenarioID - int
    0 , -- EmploymentRelatedFlag - bit
    0 , -- AutoAccidentRelatedFlag - bit
    0 , -- OtherAccidentRelatedFlag - bit
    0 , -- AbuseRelatedFlag - bit
    CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
    0 , -- ShowExpiredInsurancePolicies - bit
    GETDATE() , -- CreatedDate - datetime
    0 , -- CreatedUserID - int
    GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
    @PracticeID , -- PracticeID - int
    pd.ChartNumber , -- VendorID - varchar(50)
    @VendorImportID , -- VendorImportID - int
    0 , -- PregnancyRelatedFlag - bit
    1 , -- StatementActive - bit
    0 , -- EPSDT - bit
    0 , -- FamilyPlanning - bit
    1 , -- EPSDTCodeID - int
    0 , -- EmergencyRelated - bit
    0  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_7_1_PatientData] as pd
	INNER JOIN dbo.Patient AS pat ON
		pat.VendorID = pd.ChartNumber AND
		pat.VendorImportID = @VendorImportID
WHERE pd.patientremainderbalance > '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Encounter...'
INSERT INTO dbo.Encounter
	( PracticeID , PatientID , DoctorID , LocationID , DateOfService , DateCreated , Notes , EncounterStatusID , CreatedDate ,
      CreatedUserID , ModifiedDate , ModifiedUserID , ReleaseSignatureSourceCode , PlaceOfServiceCode , PatientCaseID , PostingDate ,
      DateOfServiceTo , PaymentMethod ,	AddOns , DoNotSendElectronic , SubmittedDate , PaymentTypeID , VendorID , VendorImportID ,
      DoNotSendElectronicSecondary , overrideClosingDate , ClaimTypeID , SecondaryClaimTypeID , SubmitReasonIDCMS1500 , SubmitReasonIDUB04 ,
      PatientCheckedIn )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          PC.PatientID , -- PatientID - int
          CASE 
			WHEN doc.DoctorID IS NULL THEN (SELECT MIN(DoctorID) FROM dbo.Doctor AS Doc2 WHERE doc2.PracticeID = @PracticeID AND doc2.[External] = 0 AND doc2.ActiveDoctor = 1)
		  ELSE doc.DoctorID END  , -- DoctorID - int 
          SL.ServiceLocationID , -- LocationID - int
          GETDATE() , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          Convert(Varchar(10), GETDATE(),101) + ': Creating Balance Forward' , -- Notes - text
          2 , -- EncounterStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
          PC.PatientCaseID , -- PatientCaseID - int
          GETDATE() , -- PostingDate - datetime
          GETDATE() , -- DateOfServiceTo - datetime
          'U' , -- PaymentMethod - char(1)
          0 , -- AddOns - bigint
          0 , -- DoNotSendElectronic - bit
          GETDATE() , -- SubmittedDate - datetime
          0 , -- PaymentTypeID - int
          PC.VendorID , -- VendorID - varchar(50)                   
          @VendorImportID , -- VendorImportID - int
          0 , -- DoNotSendElectronicSecondary - bit
          0 , -- overrideClosingDate - bit
          0 , -- ClaimTypeID - int
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
          0  -- PatientCheckedIn - bit
	FROM dbo.[_import_7_1_PatientData] AS impPat
	INNER JOIN dbo.Patient realpat ON
		   impPat.ChartNumber = realpat.VendorID AND
		   realpat.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase PC ON
		   realpat.PatientID = pc.PatientID AND
		   pc.Name = 'Balance Forward' AND
		   pc.VendorImportID = @VendorImportID
	LEFT JOIN dbo.[_import_7_1_Providers] AS impPro ON
		   impPro.code = impPat.assignedprovider
	LEFT JOIN dbo.Doctor doc ON
		   impPro.firstname = doc.FirstName AND
		   impPro.lastname = doc.LastName AND
		   doc.PracticeID = @PracticeID AND
		   doc.[External] = 0
	LEFT JOIN dbo.ServiceLocation SL ON 
		SL.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE DiagnosisCode='000.00')
BEGIN

INSERT INTO dbo.DiagnosisCodeDictionary 
	( DiagnosisCode , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , Active , OfficialName , LocalName , 
	  OfficialDescription )
VALUES  
       ( 
          '000.00' , -- DiagnosisCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- Active - bit
         'Miscellaneous' ,  -- OfficialName - varchar(300)
         'Miscellaneous' ,  -- LocalName - varchar(100)
          NULL  -- OfficialDescription - varchar(500) 
        )
END

PRINT ''
PRINT 'Inserting Into Encounter Diagnosis...'
INSERT INTO dbo.EncounterDiagnosis
	( EncounterID , DiagnosisCodeDictionaryID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ListSequence ,
	  PracticeID , VendorID , VendorImportID )
SELECT DISTINCT
          enc.EncounterID , -- EncounterID - int
          dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- ListSequence - int
          @PracticeID  , -- PracticeID - int
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Encounter as enc 
INNER JOIN dbo.DiagnosisCodeDictionary AS dcd ON
    dcd.DiagnosisCode = '000.00' AND 
    enc.PracticeID = @PracticeID        
WHERE enc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Encounter Procedure...'
INSERT INTO dbo.EncounterProcedure
	( EncounterID , ProcedureCodeDictionaryID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ServiceChargeAmount ,   
	  ServiceUnitCount , ProcedureDateOfService , PracticeID , EncounterDiagnosisID1 , ServiceEndDate , VendorID ,
	  VendorImportID , TypeOfServiceCode , AnesthesiaTime , AssessmentDate , DoctorID , ConcurrentProcedures )
SELECT DISTINCT
          enc.EncounterID  , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.patientremainderbalance , -- ServiceChargeAmount - money    
          '1.000' , -- ServiceUnitCount - decimal
          GETDATE() , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          ed.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
          GETDATE() , -- ServiceEndDate - datetime
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          '1' , -- TypeOfServiceCode - char(1)
          0 , -- AnesthesiaTime - int
          GETDATE() , -- AssessmentDate - datetime
          enc.DoctorID , -- DoctorID - int
          1  -- ConcurrentProcedures - int
FROM dbo.Encounter AS enc
	INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
		pcd.OfficialName = 'BALANCE FORWARD' 
	INNER JOIN dbo.EncounterDiagnosis AS ed ON
		ed.vendorID = enc.VendorID AND 
		ed.VendorImportID = @VendorImportID   
	INNER JOIN dbo.[_import_7_1_PatientData] i ON
		enc.VendorID = i.ChartNumber AND
		enc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT 'Inserting Into Patient Alert - Balance Forward'
INSERT INTO dbo.PatientAlert
	( PatientID , AlertMessage , ShowInPatientFlag , ShowInAppointmentFlag , ShowInEncounterFlag , CreatedDate , CreatedUserID ,
	  ModifiedDate , ModifiedUserID , ShowInClaimFlag , ShowInPaymentFlag , ShowInPatientStatementFlag )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          'Balance Forward Encounter is Present' , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          1 , -- ShowInAppointmentFlag - bit
          1 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
		  0 , -- ShowInClaimFlag - biy
          1 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_7_1_PatientData] i
	INNER JOIN dbo.Patient p ON
		p.VendorID = i.ChartNumber AND
		p.VendorImportID = @VendorImportID
WHERE i.patientremainderbalance > '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DROP TABLE #tempcaseinfo


--ROLLBACK
--Commit


