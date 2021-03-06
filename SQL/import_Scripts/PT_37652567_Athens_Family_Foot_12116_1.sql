USE superbill_12116_dev
--USE superbill_12116_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

-- This script ASSUMES that someone has created the first practice record.
SET @PracticeID = 1
SET @VendorImportID = 1 -- Spreadsheet uploaded via tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ServiceLocation records deleted'
DELETE FROM dbo.ContractFeeSchedule WHERE ContractID IN (SELECT ContractID FROM 
	dbo.[Contract] WHERE CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR))
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractFeeSchedule records deleted'
DELETE FROM dbo.[Contract] WHERE CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Contract records deleted'


	
	
 --Create Statelookup
 PRINT ''
 PRINT 'Creating state lookup'

CREATE TABLE dbo.StateCode ( 
  StateCodeID INT    IDENTITY ( 1 , 1 ), 
  State       VARCHAR(30), 
  Code        CHAR(2)    PRIMARY KEY); 

 

-- SQL populate lookup table 
INSERT INTO dbo.StateCode VALUES('ALABAMA','AL');
INSERT INTO dbo.StateCode VALUES('ALASKA','AK');
INSERT INTO dbo.StateCode VALUES('AMERICAN SAMOA','AS');
INSERT INTO dbo.StateCode VALUES('ARIZONA ','AZ');
INSERT INTO dbo.StateCode VALUES('ARKANSAS','AR');
INSERT INTO dbo.StateCode VALUES('CALIFORNIA ','CA');
INSERT INTO dbo.StateCode VALUES('COLORADO ','CO');
INSERT INTO dbo.StateCode VALUES('CONNECTICUT','CT');
INSERT INTO dbo.StateCode VALUES('DELAWARE','DE');
INSERT INTO dbo.StateCode VALUES('DISTRICT OF COLUMBIA','DC');
INSERT INTO dbo.StateCode VALUES('FEDERATED STATES OF MICRONESIA','FM');
INSERT INTO dbo.StateCode VALUES('FLORIDA','FL');
INSERT INTO dbo.StateCode VALUES('GEORGIA','GA');
INSERT INTO dbo.StateCode VALUES('GUAM ','GU');
INSERT INTO dbo.StateCode VALUES('HAWAII','HI');
INSERT INTO dbo.StateCode VALUES('IDAHO','ID');
INSERT INTO dbo.StateCode VALUES('ILLINOIS','IL');
INSERT INTO dbo.StateCode VALUES('INDIANA','IN');
INSERT INTO dbo.StateCode VALUES('IOWA','IA');
INSERT INTO dbo.StateCode VALUES('KANSAS','KS');
INSERT INTO dbo.StateCode VALUES('KENTUCKY','KY');
INSERT INTO dbo.StateCode VALUES('LOUISIANA','LA');
INSERT INTO dbo.StateCode VALUES('MAINE','ME');
INSERT INTO dbo.StateCode VALUES('MARSHALL ISLANDS','MH');
INSERT INTO dbo.StateCode VALUES('MARYLAND','MD');
INSERT INTO dbo.StateCode VALUES('MASSACHUSETTS','MA');
INSERT INTO dbo.StateCode VALUES('MICHIGAN','MI');
INSERT INTO dbo.StateCode VALUES('MINNESOTA','MN');
INSERT INTO dbo.StateCode VALUES('MISSISSIPPI','MS');
INSERT INTO dbo.StateCode VALUES('MISSOURI','MO');
INSERT INTO dbo.StateCode VALUES('MONTANA','MT');
INSERT INTO dbo.StateCode VALUES('NEBRASKA','NE');
INSERT INTO dbo.StateCode VALUES('NEVADA','NV');
INSERT INTO dbo.StateCode VALUES('NEW HAMPSHIRE','NH');
INSERT INTO dbo.StateCode VALUES('NEW JERSEY','NJ');
INSERT INTO dbo.StateCode VALUES('NEW MEXICO','NM');
INSERT INTO dbo.StateCode VALUES('NEW YORK','NY');
INSERT INTO dbo.StateCode VALUES('NORTH CAROLINA','NC');
INSERT INTO dbo.StateCode VALUES('NORTH DAKOTA','ND');
INSERT INTO dbo.StateCode VALUES('NORTHERN MARIANA ISLANDS','MP');
INSERT INTO dbo.StateCode VALUES('OHIO','OH');
INSERT INTO dbo.StateCode VALUES('OKLAHOMA','OK');
INSERT INTO dbo.StateCode VALUES('OREGON','OR');
INSERT INTO dbo.StateCode VALUES('PENNSYLVANIA','PA');
INSERT INTO dbo.StateCode VALUES('PUERTO RICO','PR');
INSERT INTO dbo.StateCode VALUES('RHODE ISLAND','RI');
INSERT INTO dbo.StateCode VALUES('SOUTH CAROLINA','SC');
INSERT INTO dbo.StateCode VALUES('SOUTH DAKOTA','SD');
INSERT INTO dbo.StateCode VALUES('TENNESSEE','TN');
INSERT INTO dbo.StateCode VALUES('TEXAS','TX');
INSERT INTO dbo.StateCode VALUES('UTAH','UT');
INSERT INTO dbo.StateCode VALUES('VERMONT','VT');
INSERT INTO dbo.StateCode VALUES('VIRGIN ISLANDS','VI');
INSERT INTO dbo.StateCode VALUES('VIRGINIA ','VA');
INSERT INTO dbo.StateCode VALUES('WASHINGTON','WA');
INSERT INTO dbo.StateCode VALUES('WEST VIRGINIA','WV');
INSERT INTO dbo.StateCode VALUES('WISCONSIN','WI');
INSERT INTO dbo.StateCode VALUES('WYOMING','WY');



--Insurance Company
	PRINT ''
	PRINT 'Inserting records into InsuranceCompany'
	INSERT INTO dbo.InsuranceCompany (
		InsuranceCompanyName,
		AddressLine1,
		AddressLine2,
		City,
		[State],
		Country,
		ZipCode,
		CreatedPracticeID,
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID,
		VendorId,
		VendorImportID,
		BillSecondaryInsurance ,
		EClaimsAccepts ,
		BillingFormID ,
		InsuranceProgramCode ,
		HCFADiagnosisReferenceFormatCode ,
		HCFASameAsInsuredFormatCode ,
		ReviewCode ,
		DefaultAdjustmentCode ,
		ReferringProviderNumberTypeID ,
		NDCFormat ,
		UseFacilityID ,
		AnesthesiaType ,
		InstitutionalBillingFormID,
		SecondaryPrecedenceBillingFormID
	)
	SELECT DISTINCT
		importComp.insurancecompany
		,importComp.addressline1
		,''
		,importComp.city
		,StateCode.Code
		,''
		,LEFT(REPLACE(importComp.zippostalcode, '-', ''), 9)
		,@PracticeID
		,GETDATE()
		,0
		,GETDATE()
		,0
		,importComp.ID		--Kareo created identifier
		,@VendorImportID
		,0 , -- BillSecondaryInsurance - bit
		0, -- EClaimsAccepts - bit
		13 , -- BillingFormID - int
		'CI' , -- InsuranceProgramCode - char(2)
		'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
		'D' , -- HCFASameAsInsuredFormatCode - char(1)
		'R' , -- Review Code
		NULL , -- DefaultAdjustmentCode - varchar(10)
		NULL , -- ReferringProviderNumberTypeID - int
		1 , -- NDCFormat - int
		1, -- UseFacilityID - bit
		'U' , -- AnesthesiaType - varchar(1)
		18 , -- InstitutionalBillingFormID - int,
		13

	FROM dbo._import_1_1_AllInsurancePlans as importComp
	join StateCode on importComp.stateprovince = StateCode.[State]
	
	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'
	
-- Insurance Company Plan

	PRINT ''
	PRINT 'Inserting records into InsuranceCompanyPlan'
	INSERT INTO dbo.InsuranceCompanyPlan (
		PlanName,
		AddressLine1,
		AddressLine2,
		City,
		[State],
		Country,
		ZipCode,
		CreatedPracticeID,
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID,
		VendorID,
		VendorImportID,
		InsuranceCompanyID
	)
	SELECT
		  importPlan.planname
		, importPlan.addressline1
		, ''
		, importPlan.city
		, StateCode.[Code]
		, ''
		, LEFT(REPLACE(importPlan.zippostalcode, '-', ''), 9)
		, @PracticeID
		, GETDate()
		, 0
		, GETDate()
		, 0
		, importPlan.ID
		, @VendorImportID
		, InsuranceCompany.InsuranceCompanyID

	FROM dbo._import_1_1_AllInsurancePlans as importPlan	
	join StateCode on importPlan.stateprovince = StateCode.[State]
	join InsuranceCompany on importPlan.ID = InsuranceCompany.VendorID

	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'
	

-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	Prefix ,
	FirstName ,
	MiddleName ,
	LastName ,
	Suffix ,
	AddressLine1 ,
	City ,
	[State] ,
	Country ,
	ZipCode ,
	HomePhone ,
	DOB ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	  @PracticeID
	, ''
	, impP.LastName -- First name and last name are reversed
	, ''
	, impP.FirstName	--First name and last name are reversed
	, ''
	, impP.[homeaddress1]
	, ''						-- impP.[Demographics_City] Ack! Not present
	, ''						-- LEFT(impP.[Demographics_ST], 2) Ack! Not present
	, ''
	, ''						-- LEFT(REPLACE(impP.[Demographics_Zip], '-', ''), 9) Not present!
	, LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.homephone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	, CASE ISDATE(impP.[dateofbirth]) WHEN 1 THEN impP.[dateofbirth] ELSE NULL END 
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, impP.patient
	, @VendorImportID
	, 1
	, 1
	, 1
FROM dbo.[_import_1_1_AllPatients] impP

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Creating Precedence temp table'
SELECT ROW_NUMBER() OVER (ORDER BY x.patientname) AS tempID, * INTO #PrecedentTemp FROM
(
	SELECT 
		CASE WHEN y.RecordID = 1 THEN 'Default Case'
			WHEN y.RecordID = 2 THEN 'Secondary Case'
			ELSE 'Tertiary Case'
		END AS PatientCase
		, SUBSTRING(y.cleanedName, 0, dotPos) AS lastN
		, SUBSTRING(y.cleanedName, dotPos+1, LEN(cleanedName)) AS firstN
		,*
	FROM 
	(
		SELECT ROW_NUMBER() OVER(PARTITION BY patientname, responsibility ORDER BY effectivedate) AS RecordID
				, UPPER(REPLACE(patientname, ', ', '.')) AS cleanedName
				, CHARINDEX(', ', patientname, 0) AS dotPos
				, iaic.ID AS InsuranceImportId
				, *
		FROM dbo.[_import_1_1_AllInsuranceCoverages] AS iaic
		WHERE (responsibility like 'Primary' OR responsibility like 'Secondary' OR responsibility like 'Tertiary')
				AND terminationdate = ''
	) y
) x
JOIN dbo.Patient AS p ON UPPER(p.FirstName) = UPPER(x.firstN) AND UPPER(p.LastName) = UPPER(x.lastN)
WHERE 
	p.PracticeID = @PracticeID
	AND p.VendorID IS NOT NULL
	AND p.VendorImportID = @VendorImportID
ORDER BY x.patientname

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Case (Depends on patient records already being imported, can only run after)
PRINT ''
PRINT 'Inserting records into PatientCase ...'
INSERT INTO dbo.PatientCase (
	PatientID,
	[Name],
	PayerScenarioID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	PracticeID,
	VendorImportID,
	VendorID
)
SELECT
	  pt.PatientID
	, pt.PatientCase
	, 5 -- 'Commercial' (I was told this is a good default)
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, @PracticeID
	, @VendorImportID
	, (pt.PatientCase + CAST (pt.PatientID AS VARCHAR)) 
FROM 
	#PrecedentTemp AS pt
WHERE
	pt.PracticeID = @PracticeID AND
	pt.VendorImportID = @VendorImportID -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 
GROUP BY pt.PatientID, pt.PatientCase
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Policy 1
PRINT ''
PRINT 'Inserting records into InsurancePolicy for primary insurance ...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT 
	  y.PatientCaseID
	, y.InsuranceCompanyPlanID
	--, CASE WHEN y.PatientCase = 'Default Case' THEN 1 WHEN y.PatientCase = 'Secondary Case' THEN 2 ELSE 3 END
	, 1--CASE WHEN y.responsibility = 'Primary' THEN 1 WHEN y.responsibility = 'Secondary' THEN 2 ELSE 3 END
	, y.insuredid
	, y.[group]
	, 'S'
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 'Record created via data import, please review.'
	, @PracticeID
	, @VendorImportID
	, 'Y'
FROM 
(
	SELECT ROW_NUMBER() OVER(PARTITION BY pt.PatientID, pt.responsibility, pt.PatientCase ORDER BY ic.State) AS patientRowId
			, pt.PatientID
			, pt.PatientCase
			, pt.insuredid
			, pt.[group]
			, icp.InsuranceCompanyPlanID
			, icp.PlanName
			, ic.InsuranceCompanyID
			, ic.InsuranceCompanyName
			, pc.PatientCaseID
			, pt.responsibility
	FROM #PrecedentTemp AS pt
	JOIN dbo.InsuranceCompanyPlan AS icp ON icp.PlanName = pt.insuranceplan
	JOIN dbo.InsuranceCompany AS ic ON icp.InsuranceCompanyID = ic.InsuranceCompanyID AND ic.InsuranceCompanyName = pt.insurancecompany 
	JOIN dbo.PatientCase AS pc ON pc.VendorID = (pt.PatientCase + CAST (pt.PatientID AS VARCHAR)) 
	WHERE pt.responsibility = 'Primary'
) y
WHERE patientRowId = 1

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Insurance Policy 2
PRINT ''
PRINT 'Inserting records into InsurancePolicy for secondary insurance ...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT 
	  y.PatientCaseID
	, y.InsuranceCompanyPlanID
	, 2
	, y.insuredid
	, y.[group]
	, 'S'
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 'Record created via data import, please review.'
	, @PracticeID
	, @VendorImportID
	, 'Y'
FROM 
(
	SELECT ROW_NUMBER() OVER(PARTITION BY pt.PatientID, pt.responsibility, pt.PatientCase ORDER BY ic.State) AS patientRowId
			, pt2.PatientID
			, pt.PatientCase
			, pt2.insuredid
			, pt2.[group]
			, icp.InsuranceCompanyPlanID
			, icp.PlanName
			, ic.InsuranceCompanyID
			, ic.InsuranceCompanyName
			, pc.PatientCaseID
			, pt2.responsibility
	FROM #PrecedentTemp AS pt
	JOIN #PrecedentTemp AS pt2 ON pt.PatientID = pt2.PatientID AND pt.PatientCase = pt2.PatientCase
	JOIN dbo.InsuranceCompanyPlan AS icp ON icp.PlanName = pt2.insuranceplan
	JOIN dbo.InsuranceCompany AS ic ON icp.InsuranceCompanyID = ic.InsuranceCompanyID
		AND ic.InsuranceCompanyName = pt2.insurancecompany 
	JOIN dbo.PatientCase AS pc ON pc.VendorID = (pt.PatientCase + CAST (pt.PatientID AS VARCHAR)) 	
	WHERE pt.responsibility = 'Primary' AND pt2.responsibility = 'Secondary'
) y
WHERE patientRowId = 1

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Insurance Policy 3
PRINT ''
PRINT 'Inserting records into InsurancePolicy for tertiary insurance ...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT 
	  y.PatientCaseID
	, y.InsuranceCompanyPlanID
	, 3
	, y.insuredid
	, y.[group]
	, 'S'
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 'Record created via data import, please review.'
	, @PracticeID
	, @VendorImportID
	, 'Y'
FROM 
(
	SELECT ROW_NUMBER() OVER(PARTITION BY pt.PatientID, pt.responsibility, pt.PatientCase ORDER BY ic.State) AS patientRowId
			, pt2.PatientID
			, pt.PatientCase
			, pt2.insuredid
			, pt2.[group]
			, icp.InsuranceCompanyPlanID
			, icp.PlanName
			, ic.InsuranceCompanyID
			, ic.InsuranceCompanyName
			, pc.PatientCaseID
			, pt2.responsibility
	FROM #PrecedentTemp AS pt
	JOIN #PrecedentTemp AS pt2 ON pt.PatientID = pt2.PatientID AND pt.PatientCase = pt2.PatientCase
	JOIN dbo.InsuranceCompanyPlan AS icp ON icp.PlanName = pt2.insuranceplan
	JOIN dbo.InsuranceCompany AS ic ON icp.InsuranceCompanyID = ic.InsuranceCompanyID 
		AND ic.InsuranceCompanyName = pt2.insurancecompany 
	JOIN dbo.PatientCase AS pc ON pc.VendorID = (pt.PatientCase + CAST (pt.PatientID AS VARCHAR)) 
	WHERE pt.responsibility = 'Primary' AND pt2.responsibility = 'Tertiary'
) y
WHERE patientRowId = 1




PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Contract for fee schedule
PRINT ''
PRINT 'Inserting records into Contract (Standard)...'
	INSERT INTO dbo.[Contract] (
		PracticeID,
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
	VALUES 
	(
		@PracticeID
		,GETDATE()
		,0
		,GETDATE()
		,0
		,'Default contract'
		,'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
		,'S'
		,45
		,45
		,CAST(@VendorImportID AS VARCHAR)
		,0
		,15
		,GETDATE()
		,DATEADD(dd, 1, DATEADD(yy, 1, GETDATE()))
		,'NULL'
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
		, 0
		, GETDATE()
		, 0
		, c.ContractID
		, 'B'
		, impFS.fee
		, 0
		, 0
		, 0
		, pcd.ProcedureCodeDictionaryID
		, 0
		, 0
		, 0
	FROM dbo._import_1_1_AllFeeScheduleCodes impFS
	INNER JOIN dbo.[Contract] c ON 
		CAST(c.Notes AS VARCHAR) = CAST(@VendorImportID AS VARCHAR) AND
		c.PracticeID = @PracticeID
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON impFS.code = pcd.ProcedureCode
	WHERE
		CAST(fee AS MONEY) > 0 AND LEN(impFS.code) > 4

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting records into Service Location table'

	INSERT INTO dbo.ServiceLocation
        ( PracticeID ,
          Name ,
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
          RecordTimeStamp ,
          PlaceOfServiceCode ,
          BillingName ,
          Phone ,
          VendorImportID ,
          VendorID ,
          FacilityIDType ,
          TimeZoneID
        )
	SELECT 
		  @PracticeID -- PracticeID - int
		, name		-- Name - varchar(128)
		, address	-- AddressLine1 - varchar(256)
		, address2 		-- AddressLine2 - varchar(256)
		, city		-- City - varchar(128)
		, sc.Code		-- State - varchar(2)
		, '' 		-- Country - varchar(32)
		, LEFT(REPLACE(ial.zippostalcode, '-', ''), 9)		-- ZipCode - varchar(9)
		, GETDATE()	-- CreatedDate - datetime
		, 0			-- CreatedUserID - int
		, GETDATE()	-- ModifiedDate - datetime
		, 0			-- ModifiedUserID - int
		, NULL		-- RecordTimeStamp - timestamp
		, SUBSTRING(placeofservice, CHARINDEX('(', placeofservice)+1, 2) -- PlaceOfServiceCode - char(2)
		, name		-- BillingName - varchar(128)
		, LEFT(REPLACE(REPLACE(REPLACE(REPLACE(phonenumber, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		, @VendorImportID	-- VendorImportID - int
		, ial.ID	-- VendorID - int
		, 35			-- FacilityIDType - int
		, 15		-- TimeZoneID - int
	FROM dbo.[_import_1_1_AllLocations] AS ial
	JOIN StateCode sc ON ial.stateprovince = sc.[State]
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Dropping state lookup'
DROP TABLE dbo.StateCode

PRINT ''
PRINT 'Dropping precendent temp table'
DROP TABLE #PrecedentTemp


COMMIT TRAN