USE superbill_39795_dev
--USE superbill_35137_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID5 INT
DECLARE @Practice5VendorImportID INT
DECLARE @PracticeID4 INT
DECLARE @Practice4VendorImportID INT

SET @PracticeID5 = 5
SET @Practice5VendorImportID = 17
SET @PracticeID4 = 4
SET @Practice4VendorImportID = 18

SET NOCOUNT ON 


/*
==========================================================================================================================================
PRACTICE 5
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan-5...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactFirstName , ContactLastName , 
	Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	CASE WHEN ICP.planname <> '' THEN LEFT(ICP.planname,128)
		 ELSE ICP.InsuranceCompanyName END  , -- PlanName - varchar(128)
	LEFT(ICP.Address1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.Address2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.City,128) , -- City - varchar(128)
	LEFT(ICP.[State],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(ICP.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(ICP.ContactLastName,64) , -- ContactLastName - varchar(64)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Phone),10) , -- Phone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.PhoneExt),10) , -- PhoneExt - varchar(10)
	ICP.Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID5 , -- CreatedPracticeID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Fax), 10) , -- Fax - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.FaxExt), 10) , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	insuranceid,  -- VendorID - varchar(50) --FIX
	@Practice5VendorImportID  -- VendorImportID - int
FROM dbo._import_17_5_InsuranceCOMPANYPLANList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE ICP.InsuranceCompanyName = InsuranceCompanyName AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID5))
WHERE icp.import = 'Y' AND icp.insuranceid <> 159
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into InsuranceCompany-5...'
INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , ReviewCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN IICL.insurancecompanyname
		ELSE IICL.planname END,128)  , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	13 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	CASE scope WHEN 1 THEN 'R' ELSE '' END , -- ReviewCode - char(1)
	@PracticeID5 , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	13 , -- SecondaryPrecedenceBillingFormID - int
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN IICL.insurancecompanyname
		ELSE IICL.planname END,50) , -- VendorID - varchar(50)
	@Practice5VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo._import_17_5_InsuranceCOMPANYPLANList AS IICL
WHERE ( insurancecompanyname <> '' OR planname <> '') AND
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.InsuranceCompanyName AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @Practice5VendorImportID))
AND iicl.import = 'Y' AND iicl.insuranceid <> 159
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'															 

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan-5...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactFirstName , ContactLastName , 
	Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	CASE WHEN ICP.planname <> '' THEN LEFT(ICP.planname,128)
		 ELSE ICP.InsuranceCompanyName END  , -- PlanName - varchar(128)
	LEFT(ICP.Address1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.Address2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.City,128) , -- City - varchar(128)
	LEFT(ICP.[State],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(ICP.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(ICP.ContactLastName,64) , -- ContactLastName - varchar(64)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Phone),10) , -- Phone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.PhoneExt),10) , -- PhoneExt - varchar(10)
	ICP.Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID5 , -- CreatedPracticeID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Fax), 10) , -- Fax - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.FaxExt), 10) , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	insuranceid,  -- VendorID - varchar(50) --FIX
	@Practice5VendorImportID -- VendorImportID - int
FROM dbo._import_17_5_InsuranceCOMPANYPLANList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.InsuranceCompanyName, 50) AND
	ICP.Insurancecompanyname = IC.InsuranceCompanyName AND
	IC.VendorImportID = @Practice5VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.Insuranceid = OICP.VendorID AND
	OICP.VendorImportID = @Practice5VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID5 AND
	  IC.VendorImportID = @Practice5VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL AND 
	  icp.import = 'Y' AND
	  icp.insuranceid <> 159
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Insurance Policy 1-5...'
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
          i.policynumber1 , -- PolicyNumber - varchar(32)
          i.groupnumber1 , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.policy1startdate) = 1 THEN i.policy1startdate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.policy1enddate) = 1 THEN i.policy1enddate ELSE NULL END, -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID5 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @Practice5VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_17_5_PatientDemographics] i
INNER JOIN dbo.PatientCase pc ON i.chartnumber = pc.VendorID AND pc.VendorImportID = 13 AND pc.Name = 'Self Pay'
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.VendorID = i.insurancecode1 AND icp.CreatedPracticeID = @PracticeID5
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 2-5...'
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
          i.policynumber2 , -- PolicyNumber - varchar(32)
          i.groupnumber2 , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.policy2startdate) = 1 THEN i.policy2startdate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.policy2enddate) = 1 THEN i.policy2enddate ELSE NULL END, -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID5 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @Practice5VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_17_5_PatientDemographics] i
INNER JOIN dbo.PatientCase pc ON i.chartnumber = pc.VendorID AND pc.VendorImportID = 13 AND pc.Name = 'Self Pay'
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.VendorID = i.insurancecode2 AND icp.CreatedPracticeID = @PracticeID5
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 3-5...'
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
          3 , -- Precedence - int
          i.policynumber3 , -- PolicyNumber - varchar(32)
          i.groupnumber3 , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.policy3startdate) = 1 THEN i.policy3startdate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.policy3enddate) = 1 THEN i.policy3enddate ELSE NULL END, -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID5 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @Practice5VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_17_5_PatientDemographics] i
INNER JOIN dbo.PatientCase pc ON i.chartnumber = pc.VendorID AND pc.VendorImportID = 13 AND pc.Name = 'Self Pay'
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.VendorID = i.insurancecode3 AND icp.CreatedPracticeID = @PracticeID5
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
PRACTICE 4
==========================================================================================================================================
*/	


PRINT ''
PRINT 'Inserting Into InsuranceCompany-4...'
INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , ReviewCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN IICL.insurancecompanyname
		ELSE IICL.planname END,128)  , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	13 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	CASE scope WHEN 1 THEN 'R' ELSE '' END , -- ReviewCode - char(1)
	@PracticeID4 , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	13 , -- SecondaryPrecedenceBillingFormID - int
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN IICL.insurancecompanyname
		ELSE IICL.planname END,50) , -- VendorID - varchar(50)
	@Practice4VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo.[_import_18_4_InsuranceCOMPANYPLANList] AS IICL
WHERE ( insurancecompanyname <> '' OR planname <> '') AND
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.InsuranceCompanyName AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @Practice4VendorImportID))
AND iicl.import = 'Y' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'															 

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan-4...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactFirstName , ContactLastName , 
	Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	CASE WHEN ICP.planname <> '' THEN LEFT(ICP.planname,128)
		 ELSE ICP.InsuranceCompanyName END  , -- PlanName - varchar(128)
	LEFT(ICP.Address1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.Address2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.City,128) , -- City - varchar(128)
	LEFT(ICP.[State],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(ICP.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(ICP.ContactLastName,64) , -- ContactLastName - varchar(64)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Phone),10) , -- Phone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.PhoneExt),10) , -- PhoneExt - varchar(10)
	ICP.Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID4 , -- CreatedPracticeID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Fax), 10) , -- Fax - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.FaxExt), 10) , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	insuranceid,  -- VendorID - varchar(50) --FIX
	@Practice4VendorImportID -- VendorImportID - int
FROM dbo.[_import_18_4_InsuranceCOMPANYPLANList] ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.InsuranceCompanyName, 50) AND
	ICP.Insurancecompanyname = IC.InsuranceCompanyName AND
	IC.VendorImportID = @Practice4VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.Insuranceid = OICP.VendorID AND
	OICP.VendorImportID = @Practice4VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID4 AND
	  IC.VendorImportID = @Practice4VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL AND 
	  icp.import = 'Y'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Insurance Policy 1-4...'
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
          i.policynbr , -- PolicyNumber - varchar(32)
          i.groupnbr , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.policyeffdate) = 1 THEN i.policyeffdate ELSE NULL END , -- PolicyStartDate - datetime
          NULL , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID4 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @Practice4VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_18_4_1] i
INNER JOIN dbo.PatientCase pc ON i.patchart = pc.VendorID AND pc.VendorImportID = 14 AND pc.Name = 'Self Pay'
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.VendorID = i.inscode1 AND icp.CreatedPracticeID = @PracticeID4
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 2-4...'
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
          i.policynbr , -- PolicyNumber - varchar(32)
          i.groupnbr , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.policyeffdate) = 1 THEN i.policyeffdate ELSE NULL END , -- PolicyStartDate - datetime
          NULL , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID4 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @Practice4VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_18_4_2] i
INNER JOIN dbo.PatientCase pc ON i.patchart = pc.VendorID AND pc.VendorImportID = 14 AND pc.Name = 'Self Pay'
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.VendorID = i.inscode2 AND icp.CreatedPracticeID = @PracticeID4
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 3-4...'
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
          3 , -- Precedence - int
          i.policynbr , -- PolicyNumber - varchar(32)
          i.groupnbr , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.policyeffdate) = 1 THEN i.policyeffdate ELSE NULL END , -- PolicyStartDate - datetime
          NULL , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID4 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @Practice4VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_18_4_3] i
INNER JOIN dbo.PatientCase pc ON i.patchart = pc.VendorID AND pc.VendorImportID = 14 AND pc.Name = 'Self Pay'
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.VendorID = i.inscode3 AND icp.CreatedPracticeID = @PracticeID4
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


DECLARE @DefaultCollectionCategory INT
SET @DefaultCollectionCategory = (SELECT CollectionCategoryID FROM dbo.CollectionCategory WHERE IsDefaultCategory = 1)
PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
( 
	PracticeID , ReferringPhysicianID , Prefix, Suffix, FirstName , MiddleName , LastName , AddressLine1 , AddressLine2 , City , State , ZipCode , Gender , 
	MaritalStatus , HomePhone , HomePhoneExt , WorkPhone , WorkPhoneExt , DOB , SSN , EmailAddress , ResponsibleDifferentThanPatient , ResponsiblePrefix, ResponsibleFirstName,
	ResponsibleMiddleName, ResponsibleLastName, ResponsibleSuffix, ResponsibleRelationshipToPatient, ResponsibleAddressLine1, ResponsibleAddressline2, ResponsibleCity, ResponsibleState,
	ResponsibleZipCode, CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , EmploymentStatus , PrimaryProviderID , DefaultServiceLocationID , EmployerID , MedicalRecordNumber , 
	MobilePhone , MobilePhoneExt , PrimaryCarePhysicianID , VendorID , VendorImportID , CollectionCategoryID , Active , SendEmailCorrespondence , 
	PhonecallRemindersEnabled, EmergencyName, EmergencyPhone, EmergencyPhoneExt
)
SELECT DISTINCT
	@PracticeID4 , -- PracticeID - int
	ReferringDoc.DoctorID , -- ReferringPhysicianID - int
	'' , -- Prefix 
	LEFT(PD.suffix, 16) , -- Suffix
	LEFT(PD.firstname,64) , -- FirstName - varchar(64)
	LEFT(PD.middleinitial,64) , -- MiddleName - varchar(64)
	LEFT(PD.lastname,64) , -- LastName - varchar(64)
	LEFT(PD.address1,256) , -- AddressLine1 - varchar(256)
	LEFT(PD.address2,256) , -- AddressLine2 - varchar(256)
	LEFT(PD.city,128) , -- City - varchar(128)
	UPPER(LEFT(PD.state,2)) , -- State - varchar(2)
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(PD.zipcode)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(PD.zipcode)
		ELSE '' END , -- ZipCode - varchar(9)
	CASE
		WHEN PD.gender IN ('M','Male') THEN 'M'
		WHEN PD.gender IN ('F','Female') THEN 'F'
		ELSE 'U' END , -- Gender - varchar(1)
	CASE 
		WHEN PD.maritalstatus IN ('D','Divorced') THEN 'D'
		WHEN PD.maritalstatus IN ('M','Married') THEN 'M'
		WHEN PD.maritalstatus IN ('S','Single') THEN 'S'
		WHEN PD.maritalstatus IN ('W','Widowed') THEN 'W'
		ELSE '' END , -- MaritalStatus - varchar(1)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.homephone),10)
		ELSE '' END, -- HomePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(PD.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone))),10)
		ELSE NULL END , -- HomePhoneExt - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.workphone),10)
		ELSE '' END , -- WorkPhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.workphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(PD.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone))),10)
		ELSE NULL END , -- WorkPhoneExt - varchar(10)
	CASE
		WHEN ISDATE(PD.dateofbirth) = 1 THEN PD.dateofbirth
		ELSE NULL END , -- DOB - datetime
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.SSN)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(PD.SSN), 9)
		ELSE NULL END , -- SSN - char(9)
	LEFT(PD.email,256) , -- EmailAddress - varchar(256)
	CASE WHEN PD.responsiblepartyrelationship  <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
	'' , -- ResponsiblePrefix - varchar(16)
	LEFT(PD.responsiblepartyfirstname, 64) , -- ResponsibleFirstName - varchar(64)
	LEFT(PD.responsiblepartymiddlename, 64) , -- ResponsibleMiddleName - varchar(64)
	LEFT(PD.responsiblepartylastname, 64) , -- ResposibleLastName - varchar(64)
	LEFT(PD.responsiblepartysuffix, 16) , -- ResponsibleSuffix - varchar(16)
	CASE WHEN PD.responsiblepartyrelationship IN ('C','Child') THEN 'C'
         WHEN PD.responsiblepartyrelationship IN ('U','Spouse') THEN 'U'
         WHEN PD.responsiblepartyrelationship IN ('O','Other') THEN 'O'
	ELSE NULL END , -- ResponsibleRelationshipToPatient (char)
	LEFT(PD.responsiblepartyaddress1, 256) , -- ResponsibleAddressLine1 - varchar(256)
	LEFT(PD.responsiblepartyaddress2, 256) , -- ResponsibleAddressLine2 - varchar(256)
	LEFT(PD.responsiblepartycity, 128) , -- ResponsibleCity - varchar(128) 
	LEFT(PD.responsiblepartystate, 2) , -- ResponsibleState - varchar(2)
	LEFT(REPLACE(PD.responsiblepartyzipcode, '-',''), 9) , -- ResponsibleZipCode - varchar(9)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	CASE
		WHEN PD.employmentstatus IN ('E','Employed') THEN 'E'
		WHEN PD.employmentstatus IN ('R','Retired') THEN 'R'
		WHEN PD.employmentstatus IN ('S','Student, Full-Time') THEN 'S'
		WHEN PD.employmentstatus IN ('T','Student, Part-Time') THEN 'T'
		ELSE 'U' END, -- EmploymentStatus - char(1)
	PrimaryProvider.DoctorID , -- PrimaryProviderID - int 
	CASE WHEN SL.ServiceLocationID IS NOT NULL THEN SL.ServiceLocationID
		ELSE SL2.ServiceLocationID END , -- DefaultServiceLocationID - int 
	E.EmployerID, -- EmployerID - int 
	LEFT(PD.chartnumber,128) , -- MedicalRecordNumber - varchar(128)
	CASE
		WHEN LEN(PD.cellphone) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.cellphone),10)
		ELSE '' END , -- MobilePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.cellphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(PD.cellphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(PD.cellphone))),10)
		ELSE NULL END , -- MobilePhoneExt - varchar(10)
	PrimaryCare.DoctorID , -- PrimaryCarePhysicianID - int 
	PD.ChartNumber , -- VendorID - varchar(50)
	@Practice4VendorImportID , -- VendorImportID - int
	@DefaultCollectionCategory , -- CollectionCategoryID - int
	CASE 
		WHEN PD.Active IN ('0','No','N','Inactive') THEN 0
		ELSE 1 END, -- Active - bit
	1, -- SendEmailCorrespondence - bit
	0,  -- PhonecallRemindersEnabled - bit
	LEFT(PD.EmergencyName,128) , -- EmergencyName - varchar(128)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphone),10)
		ELSE '' END , -- EmergencyPhone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphoneext),10) -- EmergencyPhoneExt - varchar(10)
FROM dbo.[_import_18_4_PatientDemographics] AS PD
	LEFT JOIN dbo.Doctor AS ReferringDoc ON 
			ReferringDoc.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS RD WHERE RD.FirstName = PD.ReferringPhysicianFirstName AND 
											RD.LastName = PD.ReferringPhysicianLastName AND RD.PracticeID = @PracticeID4 AND RD.ActiveDoctor = 1)
	LEFT JOIN dbo.Doctor AS PrimaryProvider ON 
			PrimaryProvider.FirstName = PD.PrimaryProviderFirstName AND 
			PrimaryProvider.LastName = PD.PrimaryProviderLastName AND 
			PrimaryProvider.[External] = 0 AND 
			PrimaryProvider.PracticeID = @PracticeID4 AND
			PrimaryProvider.ActiveDoctor = 1
	LEFT JOIN dbo.Doctor AS PrimaryCare ON 
		PrimaryCare.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS PC WHERE PC.FirstName = PD.primarycarephysicianfirstname AND 
									PC.LastName = PD.Primarycarephysicianlastname AND PC.PracticeID = @PracticeID4 AND PC.ActiveDoctor = 1)
	LEFT JOIN dbo.ServiceLocation AS SL ON SL.Name = PD.defaultservicelocation
	LEFT JOIN dbo.ServiceLocation AS SL2 ON 1 = 1 AND SL2.ServiceLocationID = (SELECT TOP 1 ServiceLocationID FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID4) 
	LEFT JOIN dbo.Employers AS E ON E.EmployerID = (SELECT TOP 1 E2.EmployerID FROM dbo.Employers E2 WHERE E2.EmployerName = LEFT(PD.employername,128) AND E2.AddressLine1 = LEFT(PD.employeraddress1,256) AND E2.State = LEFT(PD.employerstate,2))
WHERE PD.firstname <> '' AND PD.lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	PAT.PatientID , -- PatientID - int
	CASE WHEN pd.DefaultCase = '' THEN 'Default Case' 
		ELSE LEFT(pd.DefaultCase, 128) END , -- Name - varchar(128)
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
	@PracticeID4 , -- PracticeID - int
	NULL , -- CaseNumber - varchar(128)
	NULL , -- WorkersCompContactInfoID - int
	PAT.VendorID , -- VendorID - varchar(50)
	@Practice4VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.[_import_18_4_PatientDemographics] pd
	JOIN dbo.Patient AS PAT ON VendorImportID = @Practice4VendorImportID AND VendorID = pd.chartnumber
WHERE 
	pd.DefaultCase NOT IN (SELECT Name FROM dbo.PatientCase WHERE PatientID = PAT.PatientID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


PRINT ''
PRINT 'Inserting Into Insurance Policy 1-4 New Pat...'
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
          i.policynbr , -- PolicyNumber - varchar(32)
          i.groupnbr , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.policyeffdate) = 1 THEN i.policyeffdate ELSE NULL END , -- PolicyStartDate - datetime
          NULL , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID4 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @Practice4VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_18_4_1] i
INNER JOIN dbo.PatientCase pc ON i.patchart = pc.VendorID AND pc.VendorImportID = @Practice4VendorImportID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.VendorID = i.inscode1 AND icp.CreatedPracticeID = @PracticeID4
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 2-4 New Pat...'
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
          i.policynbr , -- PolicyNumber - varchar(32)
          i.groupnbr , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.policyeffdate) = 1 THEN i.policyeffdate ELSE NULL END , -- PolicyStartDate - datetime
          NULL , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID4 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @Practice4VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_18_4_2] i
INNER JOIN dbo.PatientCase pc ON i.patchart = pc.VendorID AND pc.VendorImportID = @Practice4VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.VendorID = i.inscode2 AND icp.CreatedPracticeID = @PracticeID4
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Into Insurance Policy 3-4 New Pat...'
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
--          i.policynbr , -- PolicyNumber - varchar(32)
--          i.groupnbr , -- GroupNumber - varchar(32)
--          CASE WHEN ISDATE(i.policyeffdate) = 1 THEN i.policyeffdate ELSE NULL END , -- PolicyStartDate - datetime
--          NULL , -- PolicyEndDate - datetime
--          0 , -- CardOnFile - bit
--          'S' , -- PatientRelationshipToInsured - varchar(1)
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          1 , -- Active - bit
--          @PracticeID4 , -- PracticeID - int
--          pc.VendorID , -- VendorID - varchar(50)
--          @Practice4VendorImportID , -- VendorImportID - int
--          'Y'  -- ReleaseOfInformation - varchar(1)
--FROM dbo.[_import_18_4_3] i
--INNER JOIN dbo.PatientCase pc ON i.patchart = pc.VendorID AND pc.VendorImportID = @Practice4VendorImportID
--INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.VendorID = i.inscode3 AND icp.CreatedPracticeID = @PracticeID4
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Appointment...'
	INSERT INTO dbo.Appointment
	        ( PatientID ,
	          PracticeID ,
	          ServiceLocationID ,
	          StartDate ,
	          EndDate ,
	          AppointmentType ,
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
	SELECT  DISTINCT  PAT.PatientID , -- PatientID - int
	          @PracticeID4 , -- PracticeID - int
	          CASE WHEN SL.ServiceLocationID IS NULL THEN SL2.ServiceLocationID ELSE SL.ServiceLocationID END , -- ServiceLocationID - int
	          PA.StartDate , -- StartDate - datetime
	          PA.EndDate , -- EndDate - datetime
	          'P' , -- AppointmentType - varchar(1)
	          PA.Note , -- Notes - text
	          GETDATE() , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          1 , -- AppointmentResourceTypeID - int
	           CASE WHEN PA.[STATUS] IN ('C','Confirmed') THEN 'C' 
					WHEN PA.[STATUS] IN ('E','Seen') THEN 'E'
					WHEN PA.[STATUS] IN ('I','Check-in') THEN 'I'
					WHEN PA.[STATUS] IN ('N','No-show') THEN 'N'
					WHEN PA.[STATUS] IN ('O','Check-out') THEN 'O' 
					WHEN PA.[STATUS] IN ('R','Rescheduled') THEN 'R'
					WHEN PA.[STATUS] IN ('S','Scheduled') THEN 'S'
					WHEN PA.[STATUS] IN ('X','Cancelled') THEN 'X'
					ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
	          PC.PatientCaseID , -- PatientCaseID - int
	          DK.DKPracticeID , -- StartDKPracticeID - int
	          DK.DKPracticeID , -- EndDKPracticeID - int
			  CAST(REPLACE(RIGHT(PA.StartDate,5), ':','') AS SMALLINT)   , -- StartTm - smallint
	          CAST(REPLACE(RIGHT(PA.EndDate,5),  ':', '') AS SMALLINT)
	FROM dbo.[_import_18_4_PatientAppointments] PA
	INNER JOIN dbo.Patient PAT ON 
		PA.ChartNumber = PAT.VendorID AND
		PAT.PracticeID = @PracticeID4
	INNER JOIN dbo.PatientCase PC ON 
		PC.PatientID = PAT.PatientID AND
		PC.PracticeID = @PracticeID4  AND
		PC.NAME <> 'Balance Forward'    
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID4 AND
		DK.dt = CAST(CAST(PA.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation SL ON
		SL.NAME = PA.ServiceLocationName AND
		SL.PracticeID = @PracticeID4  
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID4)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Appointment To Appointment Reason...'
	INSERT INTO dbo.AppointmentToAppointmentReason
	        ( AppointmentID ,
	          AppointmentReasonID ,
	          PrimaryAppointment ,
	          ModifiedDate ,
	          PracticeID
	        )
	SELECT DISTINCT    
			  APP.AppointmentID , -- AppointmentID - int
	          AR.AppointmentReasonID , -- AppointmentReasonID - int
	          1 , -- PrimaryAppointment - bit
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID4  -- PracticeID - int
	FROM dbo.[_import_18_4_PatientAppointments] PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID4      
	INNER JOIN dbo.Appointment APP ON 
		PAT.PatientID = APP.PatientID AND
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.ENDDate = CAST(PA.EndDate AS DateTime)      
	INNER JOIN dbo.AppointmentReason AR ON
		PA.[Reasons] = AR.NAME AND
		AR.PracticeID = @PracticeID4
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	
  
PRINT ''
PRINT 'Inserting Into Appointmen to Resource...'	
	INSERT INTO dbo.AppointmentToResource
	        ( AppointmentID ,
	          AppointmentResourceTypeID ,
	          ResourceID ,
	          ModifiedDate ,
	          PracticeID
	        )
	SELECT DISTINCT  APP.AppointmentID , -- AppointmentID - int
	          1 , -- AppointmentResourceTypeID - int
	          DOC.DoctorID , -- ResourceID - int
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID4  -- PracticeID - int
	FROM dbo.[_import_18_4_PatientAppointments] PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID4    
	INNER JOIN dbo.Appointment APP ON 
		APP.PatientId = PAT.PatientID AND 
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.EndDate = CAST(PA.EndDate AS Datetime)      
	INNER JOIN dbo.Doctor DOC ON
		DOC.FirstName = PA.DoctorFirstName AND
		DOC.LastName = PA.DoctorLastName AND
		DOC.PracticeID = @PracticeID4 AND
		DOC.[EXTERNAL] = 0  AND
		DOC.ActiveDoctor = 1    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11,
	NAME = 'Self Pay'
WHERE 
	@Practice4VendorImportID = VendorImportID AND 
	@PracticeID4 = PracticeID AND
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID4) AND
	PayerScenarioID <> 11
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	

PRINT ''
PRINT 'Updating Patient Case - Default Practice 4...'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 5,
	NAME = 'Default Case'
WHERE 
	@PracticeID4 = PracticeID AND
	PatientCaseID IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID4) AND
	PayerScenarioID <> 5 AND
    ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	

PRINT ''
PRINT 'Updating Patient Case - Default Practice 5...'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 5,
	NAME = 'Default Case'
WHERE 
	@PracticeID5 = PracticeID AND
	PatientCaseID IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID5) AND
	PayerScenarioID <> 5 AND
    ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	


--ROLLBACK
--COMMIT

