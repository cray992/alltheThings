USE superbill_11729_dev 
--USE superbill_11729_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 17
SET @VendorImportID = 10 -- Vendor import record created through import tool


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
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID AND CreatedPracticeID = @PracticeId
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE
	PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST (@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE
	PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'		
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'


--Employers 
PRINT ''
PRINT 'Inserting records into Employer ...'
INSERT INTO dbo.Employers

        ( EmployerName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT    emp.name , -- EmployerName - varchar(128)
          emp.addressone , -- AddressLine1 - varchar(256)
          emp.addresstwo , -- AddressLine2 - varchar(256)
          emp.city , -- City - varchar(128)
          emp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          emp.zipcode , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_3_1_Employer] emp
WHERE emp.name NOT IN (SELECT EmployerName FROM dbo.Employers)

PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'


-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
	AddressLine1,
	AddressLine2,
	City,
	[State],
	Country,
	ZipCode,
	Phone,
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
	ic.Name
	,ic.AddressOne
	,ic.AddressTwo
	,ic.City
	,ic.[State] 
	,''
	,LEFT(REPLACE(ic.ZipCode, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ic.Phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,NULL -- Created Practice ID (since its global it will be null)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ic.CarrierID -- Hope it's unique!
	,@VendorImportID,
	0 , -- BillSecondaryInsurance - bit
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
FROM dbo._import_3_1_Carrier ic
WHERE ic.carrierid NOT IN (SELECT ISNULL(VendorID, '') FROM dbo.InsuranceCompany) 

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Company Plan
PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan (
	PlanName,
	AddressLine1,
	AddressLine2,
	City,
	[State],
	Country,
	ZipCode,
	Phone,
	CreatedPracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	InsuranceCompanyID
)
SELECT DISTINCT 
	impIns.Name
	,impIns.AddressOne
	,impIns.AddressTwo
	,impIns.City
	,impIns.[State]
	,''
	,LEFT(REPLACE(impIns.Zipcode, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.Phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impIns.CarrierID
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo._import_3_1_Carrier impIns
INNER JOIN dbo.InsuranceCompany ic ON
	impIns.CarrierID = ic.VendorID
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	Prefix ,
	LastName ,
	FirstName ,
	MiddleName ,
	Suffix ,
	AddressLine1 ,
	AddressLine2 ,
	City ,
	[State] ,
	Country ,
	ZipCode ,
	Gender ,
	MaritalStatus ,
	HomePhone ,
	WorkPhone,
	WorkPhoneExt,
	DOB ,
	SSN ,
	EmailAddress,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	EmploymentStatus ,
	PatientReferralSourceID,
	PrimaryProviderID,
	EmployerID , 
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,''
	,pat.lastname
	,pat.firstname
	,pat.middle
	,''
	,pat.AddressOne 
	,pat.AddressTwo
	,pat.City
	,LEFT(pat.[State], 2)
	,''
	,LEFT(REPLACE(pat.ZipCode, '-', ''), 9)
	,pat.Gender 
	,CASE pat.MaritalStatus 
		WHEN 'D' THEN 'D'
		WHEN 'M' THEN 'M'
		WHEN 'S' THEN 'S'
		WHEN 'W' THEN 'W'
		ELSE 'U'
	END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.HomePhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.WorkPhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE WHEN ISNUMERIC(pat.workext) = 1 THEN pat.workext ELSE '' END 
	,CASE ISDATE(pat.BirthDate) WHEN 1 
		THEN CASE WHEN pat.birthdate > GETDATE() THEN DATEADD(yy, -100, pat.birthdate) 
			ELSE pat.birthdate END 
		ELSE NULL END 
	,LEFT(REPLACE(pat.SSN, '-', ''), 9)
	,pat.emailAddress
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE pat.StudentStatus
		WHEN 'F' THEN 'S'
		WHEN 'P' THEN 'T'
		ELSE 'U' -- Employment Status
	END
	,CASE WHEN pat.referralid <> '' THEN (SELECT DoctorID FROM dbo.Doctor WHERE VendorID = referralid) ELSE NULL END 
	,(Select DoctorID FROM dbo.Doctor WHERE PracticeID = @PracticeID AND [External] = 0) -- PrimaryCarePhysicianID
	,CASE WHEN pat.employerid <> '' THEN emp.EmployerID ELSE NULL END 
	,pat.uid -- VendorID 
	,@VendorImportID
	,1
	,1
	,CASE WHEN emailAddress <> '' THEN 1 ELSE 0 END
	,1
FROM dbo.[_import_10_17_Patient] pat
LEFT JOIN dbo.[_import_3_1_Employer] impEmp ON	
	pat.employerid = impEmp.employerid
LEFT JOIN dbo.Employers emp ON
	impEmp.name = emp.EmployerName AND
	impEmp.addressone = emp.AddressLine1 AND
	impEmp.city = emp.City 

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Case - All records
PRINT ''
PRINT 'Inserting records into PatientCase ...'
INSERT INTO dbo.PatientCase (
	PatientID,
	[Name],
	PayerScenarioID,
	Notes,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	PracticeID,
	VendorID,
	VendorImportID
)
SELECT
	realP.PatientID
	,'Case ' + ic.InsuranceCompanyName
	,5 -- 'Commercial' (I was told this is a good default)
	,cov.patientid + cov.policyid
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impCase.uid
	,@VendorImportID
FROM 
	dbo.[_import_10_17_Patient] impCase
INNER JOIN dbo.Patient realP ON 
	realP.VendorImportID = @VendorImportID AND
	impCase.uid = realP.VendorID
INNER JOIN dbo._import_10_17_Coverage cov ON
	impCase.uid = cov.PatientID	
INNER JOIN dbo.[_import_10_17_Policy] pol ON
	cov.policyid = pol.[uid]
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	pol.carrierid = icp.VendorID AND 
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompany ic ON
	icp.InsuranceCompanyID = ic.InsuranceCompanyID
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


/*-- Patient Case -All that don't have one created
PRINT ''
PRINT 'Inserting records into PatientCase ...'
INSERT INTO dbo.PatientCase (
	PatientID,
	[Name],
	PayerScenarioID,
	Notes,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	PracticeID,
	VendorID,
	VendorImportID
)
SELECT
	realP.PatientID
	,'Default Case' 
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import, please review'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impCase.patientid
	,@VendorImportID
FROM 
	dbo.[_import_10_17_Patient] impCase
INNER JOIN dbo.Patient realP ON 
	realP.VendorImportID = @VendorImportID AND
	impCase.patientID = realP.VendorID
LEFT JOIN dbo.[_import_10_17_Coverage] cov ON
	impCase.patientid = cov.patientid
WHERE impCase.patientid NOT IN (SELECT patientid FROM dbo.[_import_10_17_Coverage])
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'
	*/
	
-- Patient Journal Note
PRINT ''
PRINT 'Inserting records into PatientJournalNote ...'
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
          'Import ',
          'K' , -- SoftwareApplicationID - char(1)
          pjn.text  -- NoteMessage - varchar(max)
FROM dbo._import_10_17_PatientNotes pjn
INNER JOIN dbo.Patient realP ON
	pjn.[uid] = realP.VendorID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Policy 
PRINT ''
PRINT 'Inserting records into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupName,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	Copay,
	PatientRelationshipToInsured,
	HolderFirstName,
	HolderLastName,
	HolderMiddleName,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderCountry,
	HolderDOB,
	HolderPhone,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,impIP.idnumber
	,LEFT(impIP.groupname, 14)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impIP.copayment
	,CASE WHEN impIP.holderid <> pc.VendorID THEN 'O'
		ELSE 'S' END
	,CASE WHEN impIP.holderid <> pc.VendorID THEN holder.FirstName ELSE '' end
	,CASE WHEN impIP.holderid <> pc.VendorID THEN holder.LastName ELSE '' END
	,CASE WHEN impIP.holderid <> pc.VendorID THEN holder.MiddleName ELSE '' END
	,CASE WHEN impIP.holderid <> pc.VendorID THEN holder.AddressLine1 ELSE '' END
	,CASE WHEN impIP.holderid <> pc.VendorID THEN holder.AddressLine2 ELSE '' END
	,CASE WHEN impIP.holderid <> pc.VendorID THEN holder.City ELSE '' end
	,CASE WHEN impIP.holderid <> pc.VendorID THEN holder.[State] ELSE '' END 
	,''	
	,CASE WHEN impIP.holderid <> pc.VendorID THEN holder.DOB ELSE '' END
	,CASE WHEN impIP.holderid <> pc.VendorID THEN holder.HomePhone ELSE '' end
	,@PracticeID
	,impIP.[uid] 
	,@VendorImportID
	,'Y'
FROM dbo.[_import_10_17_Policy] impIP
LEFT JOIN dbo._import_10_17_Coverage cov ON 
	impIP.[uid] = cov.policyid 
lEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	impIP.carrierid = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.PatientCase pc ON
	CAST(pc.Notes AS VARCHAR(20)) = cov.patientid + cov.policyid
LEFT JOIN dbo.Patient holder ON 
	holder.VendorID = impIP.holderid AND
	holder.VendorImportID = @VendorImportID
WHERE PatientCaseID IS NOT NULL 

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
		,0
		,GETDATE()
		,0
		,c.ContractID
		,'B'
		,[standard]
		,0
		,0
		,0
		,pcd.ProcedureCodeDictionaryID
		,0
		,0
		,0
	FROM dbo.[_import_10_17_FeeSchedule] impFS
	INNER JOIN dbo.[Contract] c ON 
		CAST(c.Notes AS VARCHAR) = CAST(@VendorImportID AS VARCHAR) AND
		c.PracticeID = @PracticeID
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON impFS.[uid] = pcd.ProcedureCode
	WHERE
		CAST([Standard] AS MONEY) > 0

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'





--Patient Alerts
PRINT ''
PRINT 'Inserting records into Patient Alerts ...'
INSERT INTO dbo.PatientAlert
        ( PatientID ,
          AlertMessage ,
          ShowInPatientFlag ,
          ShowInAppointmentFlag ,
          ShowInEncounterFlag ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT    realP.patientID , -- PatientID - int
          pa.AlertNote , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_10_17_Patient] pa
LEFT JOIN dbo.Patient realP ON	
	pa.uid = realP.VendorID AND
	realP.VendorImportID = @VendorImportID
WHERE pa.alertnote <> ''
PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'


COMMIT 
