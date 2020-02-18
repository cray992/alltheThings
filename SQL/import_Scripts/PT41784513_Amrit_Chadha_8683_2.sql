--USE superbill_8683_dev
USE superbill_8683_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 2 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.ContractFeeSchedule WHERE ContractID IN (SELECT ContractID FROM 
	dbo.[Contract] WHERE CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR))
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractFeeSchedule records deleted'
DELETE FROM dbo.[Contract] WHERE CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Contract records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'



PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany(
    InsuranceCompanyName,
    AddressLine1,
    AddressLine2,
    City,
    State,
    ZipCode,
	Phone,
	Fax,
	CreatedPracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	BillSecondaryInsurance ,
	EClaimsAccepts ,
	BillingFormID ,
	InsuranceProgramCode ,
	HCFADiagnosisReferenceFormatCode ,
	HCFASameAsInsuredFormatCode ,
	DefaultAdjustmentCode ,
	ReferringProviderNumberTypeID ,
	NDCFormat ,
	UseFacilityID ,
	AnesthesiaType ,
	InstitutionalBillingFormID,
	SecondaryPrecedenceBillingFormID 
)
SELECT DISTINCT
	ic.[payername]
	,ic.[addr1]
	,ic.[addr2]
	,ic.[payercity]
	,LEFT(ic.[payerstate], 2)
	,ic.[payerzip]
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ic.[contphone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ic.[contactfax], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,LEFT(ic.[payername], 50)  -- Hope it's unique!
	,@VendorImportID
	,0  -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13  -- BillingFormID - int
	,'CI'  -- InsuranceProgramCode - char(2)
	,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D'  -- HCFASameAsInsuredFormatCode - char(1)
	,NULL -- DefaultAdjustmentCode - varchar(10)
	,NULL  -- ReferringProviderNumberTypeID - int
	,1  -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U'  -- AnesthesiaType - varchar(1)
	,18  -- InstitutionalBillingFormID - int,
	,13
FROM [dbo].[_import_2_2_InsuranceList] ic
WHERE ic.[payername] <> ''
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
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(icp.Phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10) , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          icp.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.InsuranceCompanyID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany icp 
WHERE icp.CreatedPracticeID = @PracticeID AND 
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--Referring Doctors
PRINT ''
PRINT 'Inserting into Doctor ...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          [External] ,
          NPI 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          doc.reffirstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          doc.reflastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          1 , -- ActiveDoctor - bit
		  GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          doc.name , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- External - bit
          doc.npi  -- NPI - varchar(10)
FROM dbo.[_import_2_2_ReferringPhysician] doc
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
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT DISTINCT 
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.[patfirstname] , -- FirstName - varchar(64)
          pat.[patmiddlename] , -- MiddleName - varchar(64)
          pat.[patlastname] , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.[addr1] , -- AddressLine1 - varchar(256)
          pat.[addr2] , -- AddressLine2 - varchar(256)
          pat.[city] , -- City - varchar(128)
          pat.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(pat.[zip], '-', ''), 9) , -- ZipCode - varchar(9)
          pat.[gen] ,
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[hmphone], '(', ''), ')', ''), '-', ''), ' ', ''), 9) , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[dayphone], '(', ''), ')', ''), '-', ''), ' ', ''), 9) , -- WorkPhone - varchar(10)
          CASE WHEN ISDATE(pat.[birthdt]) = 1 THEN pat.[birthdt] ELSE NULL END , -- DOB - datetime
          LEFT(REPLACE(pat.[ssn], '-', ''), 9) , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
           LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[altphone], '(', ''), ')', ''), '-', ''), ' ', ''), 9) , -- MobilePhone - varchar(10)
           pat.pernbr , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_2_2_PatientDemographics] pat
LEFT JOIN dbo.Doctor doc ON
	doc.FirstName + doc.LastName = pat.referring AND
	doc.PracticeID = @PracticeID AND
	doc.VendorImportID = @VendorImportID
WHERE pat.patfirstname <> '' AND pat.patlastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--PatientCase
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
SELECT    pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import, please review.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pat
WHERE pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--InsurancePolicy #1
PRINT ''
PRINT 'Inserting into InsurancePolicy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          pol.precedence , -- Precedence - int
          '' , -- PolicyNumber - varchar(32)
          '' , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          DATEADD(YEAR, 1, GETDATE()) , -- PolicyEndDate - datetime
          CASE WHEN pol.relation = 'SELF' THEN 'S'
				WHEN pol.relation = 'SPOUSE' THEN 'U'
				WHEN pol.relation = 'Parent, Child is THE PATIENT' THEN 'C'
				ELSE 'O' END  , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN pol.relation = 'SELF' THEN ''
			ELSE pol.insfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN pol.relation = 'SELF' THEN ''
			ELSE pol.insmiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN pol.relation = 'SELF' THEN ''
			ELSE pol.inslastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN pol.relation = 'SELF' THEN NULL
			ELSE holder.DOB END , -- HolderDOB - datetime
          CASE WHEN pol.relation = 'SELF' THEN ''
			ELSE holder.SSN END , -- HolderSSN - char(11)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pol.relation = 'SELF' THEN ''
			ELSE holder.Gender END , -- HolderGender - char(1)
          CASE WHEN pol.relation = 'SELF' THEN ''
				ELSE CASE WHEN holder.AddressLine1 IS NOT NULL THEN holder.AddressLine1 
					ELSE pol.addr1 END
				END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN pol.relation = 'SELF' THEN ''
				ELSE CASE WHEN holder.AddressLine2 IS NOT NULL THEN holder.AddressLine2 
					ELSE pol.addr2 END
				END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pol.relation = 'SELF' THEN ''
				ELSE CASE WHEN holder.city IS NOT NULL THEN holder.City 
					ELSE pol.inscity END
				END , -- HolderCity - varchar(128)
          CASE WHEN pol.relation = 'SELF' THEN ''
				ELSE CASE WHEN holder.STATE IS NOT NULL THEN holder.State 
					ELSE pol.insstate END
				END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pol.relation = 'SELF' THEN ''
				ELSE CASE WHEN holder.Zipcode IS NOT NULL THEN holder.ZipCode 
					ELSE pol.inszip	END
				END , -- HolderZipCode - varchar(9)
          CASE WHEN pol.relation = 'SELF' THEN ''
			ELSE holder.HomePhone END , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pat.PatientID + pol.precedence , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_2_CaseInformation2] pol
INNER JOIN dbo.Patient pat ON 
	pat.FirstName = pol.firstname AND
	pat.LastName = pol.lastname AND
	pat.MiddleName = pol.middlename AND
	pat.AddressLine1 = pol.addr1 AND
	pat.VendorImportID = @VendorImportID
LEFT JOIN dbo.patient holder ON 
	holder.FirstName = pol.insfirstname AND
	holder.LastName = pol.inslastname AND
	holder.MiddleName = pol.insmiddlename
INNER JOIN dbo.PatientCase pc ON
	pc.PatientID = pat.PatientID
INNER JOIN dbo.InsuranceCompanyPlan icp  ON
	icp.InsuranceCompanyPlanID =
	( SELECT TOP 1 InsuranceCompanyPlanID 
			FROM dbo.InsuranceCompanyPlan  
			WHERE InsuranceCompanyPlan.PlanName = pol.insurancecompany)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--Contract
PRINT ''
PRINT 'Inserting into Contract ...'
INSERT INTO dbo.Contract
        ( PracticeID,
			CreatedDate,
			CreatedUserID,
			ModifiedDate,
			ModifiedUserID,
			ContractName,
			[Description],
			ContractType,
			NoResponseTriggerPaper,
			NoResponseTriggerElectronic,
			Notes,
			Capitated,
			AnesthesiaTimeIncrement,
			EffectiveStartDate,
			EffectiveEndDate,
			PolicyValidator
		)
VALUES  ( @PracticeID , -- PracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'Standard Contract' , -- ContractName - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Description - text
          'S' , -- ContractType - char(1)
		  45 ,
		  45 ,
		  CAST(@VendorImportID AS VARCHAR) ,
		  0 ,
 		  15 , 
		  GETDATE() ,
		  DATEADD(yy, 1, GETDATE()) ,
		  'NULL' 
          )
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




-- Contract Fee Schedule
PRINT ''
PRINT 'Inserting records into ContractFeeSchedule (Standard)...'
	INSERT INTO dbo.ContractFeeSchedule (
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID,
		ContractID,
		Gender,
		StandardFee,
		Allowable,
		ExpectedReimbursement,
		RVU,
		ProcedureCodeDictionaryID,
		PracticeRVU,
		MalpracticeRVU,
		BaseUnits
	)
SELECT
		GETDATE()
		,0
		,GETDATE()
		,0
		,c.ContractID
		,'B'
		,[charge]
		,0
		,0
		,0
		,pcd.ProcedureCodeDictionaryID
		,0
		,0
		,0
	FROM dbo.[_import_1_2_FeeSchedule] impFS
	INNER JOIN dbo.[Contract] c ON 
		CAST(c.Notes AS VARCHAR) = CAST(@VendorImportID AS VARCHAR) AND
		c.PracticeID = @PracticeID
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON impFS.[cpt4] = pcd.ProcedureCode
	WHERE
		CAST([charge] AS MONEY) > 0
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT

