USE superbill_10972_dev
--USE superbill_10972_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(100)
DECLARE @ImportNote VARCHAR(100)

SET @PracticeID = 1
SET @VendorName = 'Athena Healthcare'
SET @ImportNote = 'Initial import for customer 10972. FBID: 4791.'

-- If the VendorImport record doesn't exist create it
IF NOT EXISTS (SELECT * FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)
BEGIN
	INSERT INTO dbo.VendorImport (VendorName, VendorFormat, DateCreated, Notes) 
	VALUES (@VendorName, 'CSV', GETDATE(), @ImportNote)
END

SET @VendorImportID = (SELECT VendorImportID FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)

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
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'


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
	DefaultAdjustmentCode ,
	ReferringProviderNumberTypeID ,
	NDCFormat ,
	UseFacilityID ,
	AnesthesiaType ,
	InstitutionalBillingFormID,
	SecondaryPrecedenceBillingFormID 
)
SELECT DISTINCT
	[INS COMPANY NAME]
	,STREET1
	,STREET2
	,CITY
	,[STATE]
	,'USA'
	,LEFT(REPLACE(ZIP, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(PHONE, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[INS CODE]
	,@VendorImportID,
	0 , -- BillSecondaryInsurance - bit
	0, -- EClaimsAccepts - bit
	13 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	NULL , -- DefaultAdjustmentCode - varchar(10)
	NULL , -- ReferringProviderNumberTypeID - int
	1 , -- NDCFormat - int
	1, -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 , -- InstitutionalBillingFormID - int,
	13
FROM dbo.[_importInsurance]

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
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	CreatedPracticeID,
	VendorID,
	VendorImportID,
	InsuranceCompanyID
)
SELECT DISTINCT
	impIns.[INS PLAN NAME]
	,impIns.STREET1
	,impIns.STREET2
	,impIns.CITY
	,impIns.[STATE]
	,'USA'
	,LEFT(REPLACE(impIns.ZIP, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.PHONE, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,[INS CODE]
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_importInsurance] impIns
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.VendorImportID = @VendorImportID AND
	impIns.[INS CODE] = ic.VendorID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Doctor Referring
PRINT ''
PRINT 'Inserting records into Doctor (Referring) ...'
INSERT INTO dbo.Doctor (
	PracticeID,
	Prefix,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	AddressLine1,
	AddressLine2,
	City,
	STATE,
	Country,
	ZipCode,
	WorkPhone,
	ActiveDoctor,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	VendorID,
	VendorImportID,
	FaxNumber,
	[External],
	NPI,
	ProviderTypeID
)
SELECT
	@PracticeID
	,''
	,[REF PROVIDER FIRST NAME]
	,[REF PROVIDER MI]
	,[REF PROVIDER LAST NAME]
	,''
	,Address1
	,Address2
	,City
	,State
	,'USA'
	,LEFT(REPLACE(Zip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([Phone 1], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[REF PROVIDER CREDENTIAL]
	,0
	,@VendorImportID
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([Phone 2], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,1
	,LEFT([REF PROVIDER NPI], 10)
	,1
FROM dbo.[_importReferringPhysician]


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	ReferringPhysicianID,
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
	ZipCode,
	Gender,
	MaritalStatus,
	HomePhone,
	WorkPhone,
	DOB,
	SSN,
	EmailAddress,
	ResponsibleDifferentThanPatient,
	ResponsiblePrefix,
	ResponsibleFirstName,
	ResponsibleMiddleName,
	ResponsibleLastName,
	ResponsibleSuffix,
	ResponsibleRelationshipToPatient,
	ResponsibleAddressLine1,
	ResponsibleAddressLine2,
	ResponsibleCity,
	ResponsibleState,
	ResponsibleCountry,
	ResponsibleZipCode,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	EmploymentStatus,
	MedicalRecordNumber,
	VendorID,
	VendorImportID,
	CollectionCategoryID,
	Active,
	SendEmailCorrespondence,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,referring.DoctorID
	,''
	,impP.[LAST NAME]
	,impP.[FIRST NAME]
	,impP.[MI]
	,''
	,impP.STREET1
	,impP.STREET2 
	,impP.CITY
	,LEFT(impP.[STATE], 2)
	,'USA'
	,LEFT(REPLACE(impP.ZIP, '-', ''), 9)
	,CASE impP.SEX 
		WHEN '' THEN 'U' 
		ELSE impP.SEX 
	END
	,CASE impP.MaritalStatus 
		WHEN 'Married' THEN 'M' 
		WHEN 'Separated' THEN 'U' 
		WHEN 'Other' THEN 'U' 
		WHEN '' THEN 'U' 
		WHEN 'Divorced' THEN 'D'
		WHEN 'Widowed' THEN 'W'
		WHEN 'Single' THEN 'S'
		ELSE 'U'
	END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.PHONE1, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.PHONE2, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.DOB) WHEN 1 THEN impP.DOB ELSE NULL END 
	,REPLACE(impP.SS#, '-', '')
	,Email
	,CASE impP.SameAsGuarantor 
		WHEN '1' THEN 0
		ELSE 1
	END
	,''
	,impP.[Gurantor First Name]
	,impP.[Guarantor Middle]
	,impP.[Gurantor Last Name]
	,impP.[Guarantor Suffix]
	,CASE impP.RelationToGuarantor 
		WHEN 'Child' THEN 'C' 
		WHEN 'Self' THEN 'S' 
		WHEN 'Spouse' THEN 'U' 
		ELSE 'O'
	END
	,impP.[Guarantor Address 1]
	,impP.[Guarantor Address 2]
	,impP.[Guarantor City]
	,impP.[Guarantor State]
	,'USA'
	,LEFT(REPLACE(impP.[Guarantor Zip], '-', ''), 9)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE impP.EmploymentStatus 
		WHEN 'Student' THEN 'S'
		WHEN 'Full-time' THEN 'E'
		WHEN 'Self-employed' THEN 'E'
		WHEN 'Full Time Student' THEN 'S'
		WHEN 'Retired' THEN 'R'
		WHEN 'Part Time Student' THEN 'T'
		WHEN 'Employed' THEN 'E'
		WHEN 'Part-time' THEN 'E'
		ELSE 'U'
	END
	,impP.[CHART #]
	,impP.[CHART #] -- I verified it's unique
	,@VendorImportID
	,1
	,1
	,1
	,1
FROM dbo.[_importPatient] impP
LEFT OUTER JOIN 
(
	SELECT DISTINCT DoctorID, NPI, VendorImportID FROM dbo.Doctor 
	WHERE 
		PracticeID = @PracticeID AND 
		[External] = 1 AND 
		VendorImportID = @VendorImportID AND 
		NPI <> '' AND 
		NOT (NPI IS NULL) -- 10 docs total for this practice with an NPI of ''. When joined increases the record count from 8072 to over 79,000
) referring ON
	impP.REFPRONPI = referring.NPI


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Case (Depends on patient records already being imported, can only run after)
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
	CaseNumber,
	VendorID,
	VendorImportID
)
SELECT
	realP.PatientID
	,'Default Case'
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impP.[CHART #]
	,impP.[CHART #] -- I verified it's unique
	,@VendorImportID
FROM 
	dbo.[_importPatient] impP
INNER JOIN dbo.Patient realP ON 
	impP.[CHART #] = realP.VendorID
WHERE
	realP.VendorImportID = @VendorImportID -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 
	
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Policy #1
PRINT ''
PRINT 'Inserting records into InsurancePolicy #1...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PolicyStartDate,
	PolicyEndDate,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	Deductible,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation,
	HolderPrefix,
	HolderSuffix,
	HolderFirstName,
	HolderLastName,
	HolderDOB,
	HolderAddressLine1,
	HolderCity,
	HolderState,
	HolderCountry,
	HolderZipCode
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,impP.[Insured1 Id]
	,impP.[Group1 Id]
	,CASE ISDATE(impP.[Ins1 Card Eff Date]) WHEN 1 THEN impP.[Ins1 Card Eff Date] ELSE NULL END
	,CASE ISDATE(impP.[Ins1 Card Term Date]) WHEN 1 THEN impP.[Ins1 Card Term Date] ELSE NULL END
	,CASE impP.[Pat Relation To Insured1]
		WHEN 'Child' THEN 'C'
		WHEN 'Self' THEN 'S'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O'
	END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impP.[Deductible1]
	,@PracticeID
	,impP.[CHART #] -- Tie to patient and patient case. I verified it's unique. 
	,@VendorImportID
	,'Y'
	,''
	,''
	,impP.[Insured1 First]
	,impP.[Insured1 Last]
	,CASE ISDATE(impP.[Insured1 BirthDate]) WHEN 1 THEN impP.[Insured1 BirthDate] ELSE NULL END
	,impP.[Insured1 Address1]
	,impP.[Insured1 City]
	,impP.[Insured1 State]
	,'USA'
	,LEFT(REPLACE(impP.[Insured1 Zip], '-', ''), 9)
FROM dbo.[_importPatient] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.[CHART #] = pc.VendorID AND 
	@VendorImportID = pc.VendorImportID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	@VendorImportID = icp.VendorImportID AND
	impP.[Ins1 Carrier Id] = icp.VendorID
WHERE impP.[Ins1 Carrier Id] <> '' AND NOT ([Ins1 Carrier Id] IS NULL)


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'





-- Insurance Policy #2
PRINT ''
PRINT 'Inserting records into InsurancePolicy #2...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PolicyStartDate,
	PolicyEndDate,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	Deductible,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation,
	HolderPrefix,
	HolderSuffix,
	HolderFirstName,
	HolderLastName,
	HolderDOB,
	HolderAddressLine1,
	HolderCity,
	HolderState,
	HolderCountry,
	HolderZipCode
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,impP.[Insured2 Id]
	,impP.[Group2 Id]
	,CASE ISDATE(impP.[Ins2 Card Eff Date]) WHEN 1 THEN impP.[Ins2 Card Eff Date] ELSE NULL END
	,CASE ISDATE(impP.[Ins2 Card Term Date]) WHEN 1 THEN impP.[Ins2 Card Term Date] ELSE NULL END
	,CASE impP.[Pat Relation To Insured2]
		WHEN 'Child' THEN 'C'
		WHEN 'Self' THEN 'S'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O'
	END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impP.[Deductible2]
	,@PracticeID
	,impP.[CHART #] -- Tie to patient and patient case. I verified it's unique. 
	,@VendorImportID
	,'Y'
	,''
	,''
	,impP.[Insured2 First]
	,impP.[Insured2 Last]
	,CASE ISDATE(impP.[Insured2 BirthDate]) WHEN 1 THEN impP.[Insured2 BirthDate] ELSE NULL END
	,impP.[Insured2 Address1]
	,impP.[Insured2 City]
	,impP.[Insured2 State]
	,'USA'
	,LEFT(REPLACE(impP.[Insured2 Zip], '-', ''), 9)
FROM dbo.[_importPatient] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.[CHART #] = pc.VendorID AND 
	@VendorImportID = pc.VendorImportID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	@VendorImportID = icp.VendorImportID AND
	impP.[Ins2 Carrier Id] = icp.VendorID
WHERE impP.[Ins2 Carrier Id] <> '' AND NOT ([Ins2 Carrier Id] IS NULL)


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #3
PRINT ''
PRINT 'Inserting records into InsurancePolicy #3...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PolicyStartDate,
	PolicyEndDate,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	Deductible,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation,
	HolderPrefix,
	HolderSuffix,
	HolderFirstName,
	HolderLastName,
	HolderDOB,
	HolderAddressLine1,
	HolderCity,
	HolderState,
	HolderCountry,
	HolderZipCode
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,3
	,impP.[Insured3 Id]
	,impP.[Group3 Id]
	,CASE ISDATE(impP.[Ins3 Card Eff Date]) WHEN 1 THEN impP.[Ins3 Card Eff Date] ELSE NULL END
	,CASE ISDATE(impP.[Ins3 Card Term Date]) WHEN 1 THEN impP.[Ins3 Card Term Date] ELSE NULL END
	,CASE impP.[Pat Relation To Insured3]
		WHEN 'Child' THEN 'C'
		WHEN 'Self' THEN 'S'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O'
	END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impP.[Deductible3]
	,@PracticeID
	,impP.[CHART #] -- Tie to patient and patient case. I verified it's unique. 
	,@VendorImportID
	,'Y'
	,''
	,''
	,impP.[Insured3 First]
	,impP.[Insured3 Last]
	,CASE ISDATE(impP.[Insured3 BirthDate]) WHEN 1 THEN impP.[Insured3 BirthDate] ELSE NULL END
	,impP.[Insured3 Address1]
	,impP.[Insured3 City]
	,impP.[Insured3 State]
	,'USA'
	,LEFT(REPLACE(impP.[Insured3 Zip], '-', ''), 9)
FROM dbo.[_importPatient] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.[CHART #] = pc.VendorID AND 
	@VendorImportID = pc.VendorImportID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	@VendorImportID = icp.VendorImportID AND
	impP.[Ins3 Carrier Id] = icp.VendorID
WHERE impP.[Ins3 Carrier Id] <> '' AND NOT ([Ins3 Carrier Id] IS NULL)

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN