USE superbill_40088_dev
--USE superbill_40088_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 5

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

--PRINT ''
--PRINT 'Updating Patient...'
--UPDATE dbo.Patient SET VendorID = i.chartnumber
--FROM dbo.[_import_3_1_PatientData] i
--INNER JOIN dbo.Patient p ON 
--i.firstname = p.FirstName AND i.lastname = p.LastName AND DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) = p.DOB
--WHERE p.VendorID IS NULL  
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into PatientCase...'
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
FROM dbo.[_import_5_1_CaseInformation] AS impCas
	INNER JOIN dbo.Patient AS realP ON
		realp.VendorID = impCas.chartnumber AND
		realp.PracticeID = @PracticeID
	LEFT JOIN dbo.Doctor AS realdoc ON
		realdoc.[VendorID] = impCas.[referringprovider] AND
		realdoc.[VendorImportID] = 4 AND
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
	FROM dbo.[_import_5_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID 
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
	FROM dbo.[_import_5_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID
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
	FROM dbo.[_import_5_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID 
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
	FROM dbo.[_import_5_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID 
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
	FROM dbo.[_import_5_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID 
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
	FROM dbo.[_import_5_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID 
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
	FROM dbo.[_import_5_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID 
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
	FROM dbo.[_import_5_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID 
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
	FROM dbo.[_import_5_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID 
	WHERE impCas.[dateofmanifestation] <> ''

	----PatientCaseDate
	--INSERT INTO dbo.PatientCaseDate
	--		( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate ,
	--		  ModifiedUserID )
	--SELECT DISTINCT
	--		  @PracticeID , -- PracticeID - int
	--		  realpc.[PatientCaseID] , -- PatientCaseID - int
	--		  11 , -- PatientCaseDateTypeID - int
	--		  CASE	WHEN ISDATE(impCas.[lastxraydate]) = 1 THEN impCas.[lastxraydate]
	--				ELSE NULL END , -- StartDate - datetime
	--		  NULL , -- EndDate - datetime
	--		  GETDATE() , -- CreatedDate - datetime
	--		  0 , -- CreatedUserID - int
	--		  GETDATE() , -- ModifiedDate - datetime
	--		  0  -- ModifiedUserID - int
	--FROM dbo.[_import_5_1_CaseInformation] AS impCas
	--INNER JOIN dbo.PatientCase AS realpc ON
	--	realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
	--	realpc.[PracticeID] = @PracticeID AND
	--	realpc.[VendorImportID] = @VendorImportID
	--WHERE impCas.[lastxraydate] <> ''


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
	FROM dbo.[_import_5_1_CaseInformation] AS impCas
	INNER JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impCas.[chartnumber] + impCas.[casenumber] AND
		realpc.[PracticeID] = @PracticeID 
	WHERE impCas.[dateofinjuryillness] <> '' AND impCas.[relatedtoaccident] <> ''

CREATE TABLE #tempins (insid VARCHAR(25))
INSERT INTO #tempins ( insid )
SELECT DISTINCT insurancecarrier1  -- chartnumber - varchar(25)
FROM dbo.[_import_5_1_CaseInformation] 
INNER JOIN dbo.Patient p ON p.VendorID = chartnumber
WHERE insurancecarrier1 <> ''

INSERT INTO #tempins ( insid )
SELECT DISTINCT insurancecarrier2  -- chartnumber - varchar(25)
FROM dbo.[_import_5_1_CaseInformation]
INNER JOIN dbo.Patient p ON p.VendorID = chartnumber
WHERE NOT EXISTS (SELECT * FROM #tempins WHERE insid = insurancecarrier2) AND insurancecarrier2 <> ''

INSERT INTO #tempins ( insid )
SELECT DISTINCT insurancecarrier3  -- chartnumber - varchar(25)
FROM dbo.[_import_5_1_CaseInformation]
INNER JOIN dbo.Patient p ON p.VendorID = chartnumber
WHERE NOT EXISTS (SELECT * FROM #tempins WHERE insid = insurancecarrier3) AND insurancecarrier3 <> ''

PRINT ''
PRINT 'Inserting Into Insurance Company...'
 INSERT INTO dbo.InsuranceCompany
   ( InsuranceCompanyName ,
     BillSecondaryInsurance , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode ,
     HCFASameAsInsuredFormatCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , SecondaryPrecedenceBillingFormID , 
	 VendorID , VendorImportID , NDCFormat , UseFacilityID , AnesthesiaType , InstitutionalBillingFormID )
 SELECT DISTINCT
     LEFT([name] , 128) , -- InsuranceCompanyName - varchar(128)
     0 , -- BillSecondaryInsurance - bit
     1 , -- EClaimsAccepts - bit
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
     LEFT(name,50) , -- VendorID - varchar(50)
     @VendorImportID , -- VendorImportID - int
     1 , -- NDCFormat - int
     1 , -- UseFacilityID - bit
     'U' , -- AnesthesiaType - varchar(1)
     18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_5_1_Insurances]
INNER JOIN #tempins ON insid = code
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
FROM dbo.[_import_5_1_Insurances] AS impIns
 INNER JOIN dbo.InsuranceCompany AS ic ON
  ic.[VendorID] = LEFT(impIns.name,50) AND
  ic.[VendorImportID] = @VendorImportID AND
  ic.[CreatedPracticeID] = @PracticeID  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 1'
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
     0 , -- Deductible - money
     1 , -- Active - bit
     @PracticeID , -- PracticeID - int
     impCas.[chartnumber] + impCas.casenumber , -- VendorID - varchar(50)
     @VendorImportID , -- VendorImportID - int
	 'Y'
FROM dbo.[_import_5_1_CaseInformation] AS impCas
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
		FROM dbo.[_import_2_1_PatientData]) holder ON
			holder.[chartnumber] = impCas.[insured1]    
WHERE impCas.policynumber1 <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 2...'
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
FROM dbo.[_import_5_1_CaseInformation] AS impCas
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
		 FROM dbo.[_import_2_1_PatientData]) AS holder ON
			holder.[chartnumber] = impCas.[insured2]
WHERE impCas.[policynumber2] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 3...'
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
FROM dbo.[_import_5_1_CaseInformation] AS impCas
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
		FROM dbo.[_import_2_1_PatientData]) holder ON
			holder.[chartnumber] = impCas.[insured3] 
WHERE impCas.[policynumber3] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Insurance Policy...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11 
FROM dbo.PatientCase pc
	LEFT JOIN dbo.InsurancePolicy ip ON
		pc.PatientCaseID = ip.PatientCaseID  
WHERE pc.VendorImportID = @VendorImportID AND
      PayerScenarioID = 5 AND 
      ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #tempins

--ROLLBACK
--COMMIT