USE superbill_10781_dev
--USE superbill_10781_prod
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
SET @VendorName = 'Smith Matza Kutner MDs'
SET @ImportNote = 'Initial import for customer 10781. FBID: 4917.'

-- If the VendorImport record doesn't exist create it
IF NOT EXISTS (SELECT * FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)
BEGIN
	INSERT INTO dbo.VendorImport (VendorName, VendorFormat, DateCreated, Notes) 
	VALUES (@VendorName, 'XLSX', GETDATE(), @ImportNote)
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
	ins_company_name
	,street1
	,street2
	,city
	,LEFT(state, 2)
	,'USA'
	,LEFT(REPLACE(zip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ins_code
	,@VendorImportID
	,0 -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13 -- BillingFormID - int
	,'CI' -- InsuranceProgramCode - char(2)
	,'C' -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D' -- HCFASameAsInsuredFormatCode - char(1)
	,NULL -- DefaultAdjustmentCode - varchar(10)
	,NULL -- ReferringProviderNumberTypeID - int
	,1 -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U' -- AnesthesiaType - varchar(1)
	,18 -- InstitutionalBillingFormID - int,
	,13
FROM dbo.[_import_20120621_Insurance]

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
	impIns.ins_plan_name
	,impIns.street1
	,impIns.street2
	,impIns.city
	,LEFT(impIns.state, 2)
	,'USA'
	,LEFT(REPLACE(impIns.zip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impIns.ins_code
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_import_20120621_Insurance] impIns
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.VendorImportID = @VendorImportID AND
	impins.ins_code = ic.VendorID AND
	impIns.ins_company_name = ic.InsuranceCompanyName
		
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
	DOB ,
	SSN ,
	ResponsibleRelationshipToPatient,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	EmploymentStatus ,
	MedicalRecordNumber ,
	PrimaryCarePhysicianID,
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
	,impP.[last_name]
	,impP.[first_name]
	,impP.mi
	,''
	,impP.street1
	,impP.street2
	,impP.[city]
	,LEFT(impP.[state], 2)
	,'USA'
	,LEFT(REPLACE(impP.zip, '-', ''), 9)
	,CASE impP.sex 
		WHEN 'M' THEN 'M' 
		WHEN 'F' THEN 'F' 
		ELSE 'U' 
	END
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.dob) WHEN 1 THEN impP.dob ELSE NULL END 
	,REPLACE(impP.[ss#], '-', '')
	,'U'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'U'
	,impP.[chart_#]
	,d.DoctorID
	,impP.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,1
	,1
	,0
	,1
FROM dbo.[_import_20120621_Patient] impP
LEFT OUTER JOIN dbo.Doctor d ON 
	d.PracticeID = @PracticeID AND 
	d.[External] = 0 AND 
	CHARINDEX(d.FirstName, impP.provider) > 0 AND
	CHARINDEX(d.LastName, impP.provider) > 0

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
SELECT DISTINCT
	realP.PatientID
	,'Default Case'
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impP.[chart_#]
	,impP.[ID]
	,@VendorImportID
FROM 
	dbo.[_import_20120621_Patient] impP
INNER JOIN dbo.Patient realP ON 
	impP.ID = realP.VendorID AND 
	realP.VendorImportID = @VendorImportID AND
	realP.PracticeID = @PracticeID
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
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation,
	HolderFirstName,
	HolderLastName,
	HolderDOB,
	HolderGender,
	HolderAddressLine1,
	HolderCity,
	HolderState,
	HolderZipCode
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,LEFT(impP.policy1, 32)
	,LEFT(impP.group1, 32)
	,CASE impP.sub1_rel
		WHEN '1' THEN 'S' 
		WHEN 'S' THEN 'S'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impP.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,impP.sub1_firstn
	,impP.sub1_lastn
	,CASE ISDATE(impP.sub1dob) WHEN 1 THEN impP.sub1dob ELSE NULL END 
	,CASE impP.sub1_sex 
		WHEN 'M' THEN 'M' 
		WHEN 'F' THEN 'F' 
		ELSE 'U' 
	END
	,impP.sub1_street1
	,impP.sub1_city
	,LEFT(impP.sub1_state, 2)
	,LEFT(REPLACE(impP.sub1zip, '-', ''), 9)
FROM dbo.[_import_20120621_Patient] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.[ID] = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID
INNER JOIN 
(
	SELECT DISTINCT MAX(InsuranceCompanyPlanID) AS 'InsuranceCompanyPlanID', VendorID FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID GROUP BY VendorID
) icp ON impP.ins1_code = icp.VendorID
WHERE
	impP.ins1_code <> '' AND
	pc.VendorImportID = @VendorImportID 

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
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation,
	HolderFirstName,
	HolderLastName,
	HolderDOB,
	HolderGender,
	HolderAddressLine1,
	HolderCity,
	HolderState,
	HolderZipCode
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,LEFT(impP.policy2, 32)
	,LEFT(impP.group2, 32)
	,CASE impP.sub2_rel
		WHEN '1' THEN 'S' 
		WHEN 'S' THEN 'S'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impP.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,impP.sub2_firstn
	,impP.sub2_lastn
	,CASE ISDATE(impP.sub2dob) WHEN 1 THEN impP.sub2dob ELSE NULL END 
	,CASE impP.sub2_sex 
		WHEN 'M' THEN 'M' 
		WHEN 'F' THEN 'F' 
		ELSE 'U' 
	END
	,impP.sub2_street1
	,impP.sub2_city
	,LEFT(impP.sub2_state, 2)
	,LEFT(REPLACE(impP.sub2_zip, '-', ''), 9)
FROM dbo.[_import_20120621_Patient] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.[ID] = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID
INNER JOIN 
(
	SELECT DISTINCT MAX(InsuranceCompanyPlanID) AS 'InsuranceCompanyPlanID', VendorID FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID GROUP BY VendorID
) icp ON impP.ins2_code = icp.VendorID
WHERE
	impP.ins2_code <> '' AND
	pc.VendorImportID = @VendorImportID 

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Set cases without policies to self-pay (11)
PRINT ''
PRINT 'Setting cases without policies to Self-Pay'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11 
WHERE 
	@VendorImportID = VendorImportID AND 
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy) AND
	PayerScenarioID <> 11
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records updated'



COMMIT TRAN