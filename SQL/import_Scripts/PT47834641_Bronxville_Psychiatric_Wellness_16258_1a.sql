--USE superbill_16258_dev
USE superbill_16258_prod
go

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 9



PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))


DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID))
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientJournalNote records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PracticeID = @PracticeID AND PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID) 
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCaseDate records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientAler records deleted'	
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
	

-- Insurance (only if table exists)
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_9_1_Insurances]') AND type in (N'U'))
BEGIN
	PRINT ''
	PRINT 'Inserting into InsuranceCompany ...'
	-- Insurance Company
	INSERT INTO dbo.InsuranceCompany (
		InsuranceCompanyName,
		AddressLine1,
		AddressLine2,
		City,
		[State],
		Country,
		ZipCode,
		Phone,
		PhoneExt,
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
		[Name]
		,[Street1]
		,[Street2]
		,[City]
		,[State]
		,'USA'
		,LEFT(REPLACE([ZipCode], '-',''), 9)
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([Phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		,Extension
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([Fax], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		,@PracticeID
		,GETDATE()
		,0
		,GETDATE()
		,0
		,code -- Hope it's unique!
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
	FROM dbo.[_import_9_1_Insurances]
	WHERE
		RTRIM(LTRIM([Name])) <> '' AND
		[code] NOT IN (SELECT VendorID FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID AND CreatedPracticeID = @PracticeID)  
	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

	PRINT ''
	PRINT 'Inserting into InsuranceCompanyPlan ...'
	-- Insurance Company Plan
	INSERT INTO dbo.InsuranceCompanyPlan (
		PlanName,
		AddressLine1,
		City,
		[State],
		Country,
		ZipCode,
		Phone,
		Notes,
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
		impIns.[Name] + ' - ' + impIns.[Type]
		,impIns.[Street1]
		,impIns.[City]
		,impIns.[State]
		,'USA'
		,LEFT(REPLACE(impIns.[ZipCode], '-',''), 9)
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.[Phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		,impIns.Code
		,@PracticeID
		,GETDATE()
		,0
		,GETDATE()
		,0
		,impIns.code
		,@VendorImportID
		,ic.InsuranceCompanyID
	FROM dbo.[_import_9_1_Insurances] impIns
	INNER JOIN dbo.InsuranceCompany ic ON
		ic.VendorImportID = @VendorImportID AND
		ic.CreatedPracticeID = @PracticeID AND
		impIns.Code = ic.VendorID		
	PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'
END





-- Referring Doctor (only if table exists)
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_9_1_ReferringPhys]') AND type in (N'U'))
BEGIN

-- Doctor Referring
	PRINT ''
	PRINT 'Inserting into Doctor ...'
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
		FaxNumber,
		MobilePhone,
		Notes,
		ActiveDoctor,
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID,
		Degree,
		TaxonomyCode,
		VendorID,
		VendorImportID,
		[External],
		NPI,
		ProviderTypeID
	)
	SELECT DISTINCT
		@PracticeID
		,''
		,firstname
		,middleinitial
		,lastname
		,''
		,street1
		,street2
		,city
		,LEFT(state, 2)
		,'USA'
		,LEFT(REPLACE(zipcode, '-',''), 9)
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(COALESCE(
														CASE WHEN office <> '' THEN OFFICE ELSE NULL END,
														CASE WHEN phone <> '' THEN phone ELSE NULL END), '')
											, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(cell, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		,CASE WHEN office <> '' AND phone <> '' THEN 'Phone: ' + phone END
		,1
		,GETDATE()
		,0
		,GETDATE()
		,0
		,LEFT([credentials], 8)
		,CASE WHEN [taxonomycode] <> '' THEN LEFT([taxonomycode], 10) ELSE NULL END
		,code -- Appears to be unique in source data
		,@VendorImportID
		,1
		,LEFT(nationalprovideridentifier, 10)
		,1
	FROM dbo.[_import_9_1_ReferringPhys]
	WHERE lastname <> ''
	PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'

END


-- Patients (only if table exists)
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_9_1_PatientData]') AND type in (N'U'))
BEGIN

	DECLARE @PatientMaritalStatus TABLE (ChartNumber VARCHAR(100), MaritalStatus VARCHAR(20))
	IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[_import_9_1_CaseInformation]') AND type IN (N'U'))
	BEGIN
		-- isolate just one marital status per patient. They may have multiple records, so using MAX, (even though MAX won't necessarily grab the latest case).
		INSERT INTO @PatientMaritalStatus (ChartNumber, MaritalStatus) SELECT ChartNumber, MAX(MaritalStatus) FROM dbo.[_import_9_1_CaseInformation] WHERE MaritalStatus <> '' GROUP BY ChartNumber
	END
    
    PRINT ''
    PRINT 'Inserting into Patient ...'
	-- Patient
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
		MobilePhone,
		DOB ,
		ResponsibleRelationshipToPatient,
		CreatedDate ,
		CreatedUserID ,
		ModifiedDate ,
		ModifiedUserID ,
		EmploymentStatus ,
		PrimaryProviderID,
		MedicalRecordNumber,
		VendorID ,
		VendorImportID ,
		CollectionCategoryID ,
		Active ,
		SendEmailCorrespondence ,
		PhonecallRemindersEnabled,
		EmergencyPhone
		)
	SELECT DISTINCT
		@PracticeID
		,''
		,impP.[LastName]
		,impP.[FirstName]
		,impP.[MiddleInitial]
		,''
		,impP.[Street1]
		,impP.[Street2]
		,impP.[City]
		,impP.[State]
		,''
		,LEFT(REPLACE(impP.[ZipCode], '-', ''), 9)
		,CASE impP.[Sex] WHEN 'Female' THEN 'F' WHEN 'Male' THEN 'M' ELSE 'U' END
		,NULL -- Can be NULL, and that's ok
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[Phone1], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[Phone2], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[Phone3], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		,CASE ISDATE(impP.[DateOfBirth]) WHEN 1 THEN impP.[DateOfBirth] ELSE NULL END 
		,'S'
		,GETDATE()
		,0
		,GETDATE()
		,0
		,'U'
		,Doctor.DoctorID -- PrimaryProviderID
		,impP.[ChartNumber]
		,impP.[ChartNumber] -- VendorID - Hope it's unique!
		,@VendorImportID
		,1 -- CollectionCategoryID
		,1 -- Active
		,CASE WHEN impP.Email <> '' THEN 1 ELSE 0 END -- SendEmailCorrespondence
		,1 -- PhonecallRemindersEnabled
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[ContactPhone1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) -- EmergencyPhone
	FROM dbo.[_import_9_1_PatientData] impP
	LEFT OUTER JOIN @PatientMaritalStatus pms ON impP.ChartNumber = pms.ChartNumber
	LEFT OUTER JOIN dbo.Doctor ON 
		@VendorImportID = Doctor.VendorImportID AND 
		@PracticeID = Doctor.PracticeID AND
		impP.assignedprovider = Doctor.VendorID AND 
		Doctor.[External] = 0
	PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'


END


-- Patient Journal Notes present in CaseInformation sheet (only if the table exists)
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_9_1_CaseInformation]') AND type in (N'U'))
BEGIN
	PRINT ''
	PRINT 'Inserting into PatientJournalNote'
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
	SELECT  
	      GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          realP.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          impCase.Notes  -- NoteMessage - varchar(max)
    FROM dbo.[_import_9_1_CaseInformation] impCase
	INNER JOIN dbo.Patient realP ON
		impCase.[CaseNumber] = realP.VendorImportID AND
		realP.VendorImportID = @VendorImportID AND 
		realP.PracticeID = @PracticeID 
	WHERE impCase.[Notes] <> ''  
	PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'

END

-- Patient Cases and Policies (only if table exists)
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_9_1_CaseInformation]') AND type in (N'U'))
BEGIN

	PRINT ''
	PRINT 'Inserting into PatientCase ...'
	-- Patient Case (Depends on patient records already being imported, can only run after)
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
		,[Description]
		,5 -- 'Commercial' (I was told this is a good default)
		,'Created via data import'
		,GETDATE()
		,0
		,GETDATE()
		,0
		,@PracticeID
		,chartnumber
		,AutoTempID -- Auto ID added by Kareo process MUST BE UNIQUE PER CASE record, so the chart_number, (patient handle), won't work here. since a patient can have multiple "cases" (aka polciies in kareo world)
		,@VendorImportID
	FROM 
		dbo.[_import_9_1_CaseInformation] impCase
	INNER JOIN dbo.Patient realP ON 
		impCase.[ChartNumber] = realP.VendorID AND 
		realP.VendorImportID = @VendorImportID AND
		realP.PracticeID = @PracticeID
	WHERE impCase.[Description] <> ''
	PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'

	
	PRINT ''
	PRINT 'Inserting into InsurancePolicy 1...'
	-- Insurance Policy 1
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
		Copay,
		PracticeID,
		VendorID,
		VendorImportID,
		ReleaseOfInformation,
		HolderPrefix,
		HolderSuffix,
		HolderFirstName,
		HolderMiddleName,
		HolderLastName,
		HolderDOB,
		HolderGender,
		HolderAddressLine1,
		HolderAddressLine2,
		HolderCity,
		HolderState,
		HolderZipCode,
		HolderPhone
	)
	SELECT DISTINCT
		pc.PatientCaseID
		,icp.InsuranceCompanyPlanID
		,1
		,impPC.[PolicyNumber1]
		,impPC.[GroupNumber1]
		,CASE ISDATE(impPC.[Policy1StartDate]) WHEN 1 THEN impPC.[Policy1StartDate] ELSE NULL END
		,CASE ISDATE(impPC.[Policy1EndDate]) WHEN 1 THEN impPC.[Policy1EndDate] ELSE NULL END
		,CASE impPC.[InsuredRelationship1]
			WHEN 'Self' THEN 'S' 
			WHEN 'Child' THEN 'C'
			WHEN 'Spouse' THEN 'U'
			ELSE 'O' END
		,GETDATE()
		,0
		,GETDATE()
		,0
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] = impPC.[ChartNumber] THEN 'WARNING: Relationship set to NOT self, but the policy holder information was not present in the original data, so it was not entered.' ELSE 'Record created via data import, please review.' END
		,impPC.[CopaymentAmount]
		,@PracticeID
		,impPC.AutoTempID -- auto ID we added to temp table
		,@VendorImportID
		,'Y'
		,''
		,''
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[FirstName] END
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[MiddleInitial] END
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[LastName] END
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN 
			CASE WHEN ISDATE(holder.[DateOfBirth]) = 1 THEN holder.[DateOfBirth] END 
		END 
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN 
			CASE holder.[Sex]
				WHEN 'Male' THEN 'M' 
				WHEN 'Female' THEN 'F'
				ELSE 'U' 
			END 
		END
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[Street1] END 
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[Street2] END 
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[City] END 
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[State] END 
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[ZipCode], '-', ''), 9) END 
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) END 
	FROM dbo.[_import_9_1_CaseInformation] impPC
	INNER JOIN dbo.PatientCase pc ON impPC.AutoTempID = pc.VendorID AND pc.VendorImportID = @VendorImportID AND pc.PracticeID = @PracticeID
	INNER JOIN (
		SELECT DISTINCT [ChartNumber], [LastName], [FirstName], [MiddleInitial], [Street1], [Street2], [City], [State], [ZipCode], [Phone1], [Sex], [DateofBirth] FROM dbo.[_import_9_1_PatientData]
	) holder ON holder.[ChartNumber] = impPC.[Insured1]
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.VendorImportID = @VendorImportID AND
		icp.CreatedPracticeID = @PracticeID AND
		impPC.[InsuranceCarrier1] = icp.VendorID
	WHERE
		pc.PracticeID = @PracticeID AND
		pc.VendorImportID = @VendorImportID AND
		(impPC.[PolicyNumber1] <> '' OR impPC.[InsuranceCarrier1] <> '')
	PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'



	PRINT ''
	PRINT 'Inserting into InsurancePolicy 2...'	-- Insurance Policy 2
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
		Copay,
		PracticeID,
		VendorID,
		VendorImportID,
		ReleaseOfInformation,
		HolderPrefix,
		HolderSuffix,
		HolderFirstName,
		HolderMiddleName,
		HolderLastName,
		HolderDOB,
		HolderGender,
		HolderAddressLine1,
		HolderAddressLine2,
		HolderCity,
		HolderState,
		HolderZipCode,
		HolderPhone
	)
	SELECT DISTINCT
		pc.PatientCaseID
		,icp.InsuranceCompanyPlanID
		,2
		,impPC.[PolicyNumber2]
		,impPC.[GroupNumber2]
		,CASE ISDATE(impPC.[Policy2StartDate]) WHEN 1 THEN impPC.[Policy2StartDate] ELSE NULL END
		,CASE ISDATE(impPC.[Policy2EndDate]) WHEN 1 THEN impPC.[Policy2EndDate] ELSE NULL END
		,CASE impPC.[InsuredRelationship2]
			WHEN 'Self' THEN 'S' 
			WHEN 'Child' THEN 'C'
			WHEN 'Spouse' THEN 'U'
			ELSE 'O' END
		,GETDATE()
		,0
		,GETDATE()
		,0
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] = impPC.[ChartNumber] THEN 'WARNING: Relationship set to NOT self, but the policy holder information was not present in the original data, so it was not entered.' ELSE 'Record created via data import, please review.' END
		,impPC.[CopaymentAmount]
		,@PracticeID
		,impPC.AutoTempID -- auto ID we added to temp table
		,@VendorImportID
		,'Y'
		,''
		,''
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[FirstName] END
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[MiddleInitial] END
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[LastName] END
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN 
			CASE WHEN ISDATE(holder.[DateOfBirth]) = 1 THEN holder.[DateOfBirth] END 
		END 
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN 
			CASE holder.[Sex]
				WHEN 'Male' THEN 'M' 
				WHEN 'Female' THEN 'F'
				ELSE 'U' 
			END 
		END
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[Street1] END 
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[Street2] END 
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[City] END 
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[State] END 
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[ZipCode], '-', ''), 9) END 
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) END 
	FROM dbo.[_import_9_1_CaseInformation] impPC
	INNER JOIN dbo.PatientCase pc ON impPC.AutoTempID = pc.VendorID AND pc.VendorImportID = @VendorImportID AND pc.PracticeID = @PracticeID
	INNER JOIN (
		SELECT DISTINCT [ChartNumber], [LastName], [FirstName], [MiddleInitial], [Street1], [Street2], [City], [State], [ZipCode], [Phone1], [Sex], [DateofBirth] FROM dbo.[_import_9_1_PatientData]
	) holder ON holder.[ChartNumber] = impPC.[Insured2]
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.VendorImportID = @VendorImportID AND
		icp.CreatedPracticeID = @PracticeID AND
		impPC.[InsuranceCarrier2] = icp.VendorID
	WHERE
		pc.PracticeID = @PracticeID AND
		pc.VendorImportID = @VendorImportID AND
		(impPC.[PolicyNumber2] <> '' OR impPC.[InsuranceCarrier2] <> '')
	PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'


	PRINT ''
	PRINT 'Inserting into InsurancePolicy 3...'
	-- Insurance Policy 3
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
		Copay,
		PracticeID,
		VendorID,
		VendorImportID,
		ReleaseOfInformation,
		HolderPrefix,
		HolderSuffix,
		HolderFirstName,
		HolderMiddleName,
		HolderLastName,
		HolderDOB,
		HolderGender,
		HolderAddressLine1,
		HolderAddressLine2,
		HolderCity,
		HolderState,
		HolderZipCode,
		HolderPhone
	)
	SELECT DISTINCT
		pc.PatientCaseID
		,icp.InsuranceCompanyPlanID
		,3
		,impPC.[PolicyNumber3]
		,impPC.[GroupNumber3]
		,CASE ISDATE(impPC.[Policy3StartDate]) WHEN 1 THEN impPC.[Policy3StartDate] ELSE NULL END
		,CASE ISDATE(impPC.[Policy3EndDate]) WHEN 1 THEN impPC.[Policy3EndDate] ELSE NULL END
		,CASE impPC.[InsuredRelationship3]
			WHEN 'Self' THEN 'S' 
			WHEN 'Child' THEN 'C'
			WHEN 'Spouse' THEN 'U'
			ELSE 'O' END
		,GETDATE()
		,0
		,GETDATE()
		,0
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] = impPC.[ChartNumber] THEN 'WARNING: Relationship set to NOT self, but the policy holder information was not present in the original data, so it was not entered.' ELSE 'Record created via data import, please review.' END
		,impPC.[CopaymentAmount]
		,@PracticeID
		,impPC.AutoTempID -- auto ID we added to temp table
		,@VendorImportID
		,'Y'
		,''
		,''
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN holder.[FirstName] END
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN holder.[MiddleInitial] END
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN holder.[LastName] END
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN 
			CASE WHEN ISDATE(holder.[DateOfBirth]) = 1 THEN holder.[DateOfBirth] END 
		END 
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN 
			CASE holder.[Sex]
				WHEN 'Male' THEN 'M' 
				WHEN 'Female' THEN 'F'
				ELSE 'U' 
			END 
		END
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN holder.[Street1] END 
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN holder.[Street2] END 
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN holder.[City] END 
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN holder.[State] END 
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[ZipCode], '-', ''), 9) END 
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) END 
	FROM dbo.[_import_9_1_CaseInformation] impPC
	INNER JOIN dbo.PatientCase pc ON impPC.AutoTempID = pc.VendorID AND pc.VendorImportID = @VendorImportID AND pc.PracticeID = @PracticeID
	INNER JOIN (
		SELECT DISTINCT [ChartNumber], [LastName], [FirstName], [MiddleInitial], [Street1], [Street2], [City], [State], [ZipCode], [Phone1], [Sex], [DateofBirth] FROM dbo.[_import_9_1_PatientData]
	) holder ON holder.[ChartNumber] = impPC.[Insured3]
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.VendorImportID = @VendorImportID AND
		icp.CreatedPracticeID = @PracticeID AND
		impPC.[InsuranceCarrier3] = icp.VendorID
	WHERE
		pc.PracticeID = @PracticeID AND
		pc.VendorImportID = @VendorImportID AND
		(impPC.[PolicyNumber3] <> '' OR impPC.[InsuranceCarrier3] <> '')
	PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'

END



-- Standard fee schedule (only if table exists)
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_9_1_StandardFeeSchedule]') AND type in (N'U'))
BEGIN
	PRINT ''
	PRINT 'Inserting into StandardFeeSchedule...'
	--StandardFeeSchedule
	INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
        ( PracticeID ,
          Name ,
          Notes ,
          EffectiveStartDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          MedicareFeeScheduleGPCICarrier ,
          MedicareFeeScheduleGPCILocality ,
          MedicareFeeScheduleGPCIBatchID ,
          MedicareFeeScheduleRVUBatchID ,
          AddPercent ,
          AnesthesiaTimeIncrement
        )
	VALUES  
		( @PracticeID ,
          'Default contract' ,
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) ,
          GETDATE() ,
          'f' ,
          'Import File' ,
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
        )
	
	PRINT ''
	PRINT 'Inserting into StandardFee...'
	--StandardFee
	INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
	SELECT  
		  c.StandardFeeScheduleID , 
          pcd.ProcedureCodeDictionaryID , 
          0 ,
          impSFS.[AmountA] , 
          0  
	FROM dbo.[_import_9_1_StandardFeeSchedule] impSFS
	INNER JOIN dbo.[ContractsAndFees_StandardFeeSchedule] c ON 
		CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
		c.practiceID = @PracticeID
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON 
		impSFS.[Code1] = pcd.ProcedureCode
	WHERE CAST(impSFS.[AmountA] AS MONEY) > 0
	PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'


	PRINT ''
	PRINT 'Inserting into StandardFeeScheduleLink...'
	--StandardFeeScheduleLink
	INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
	SELECT    doc.DoctorID , 
			  sl.ServiceLocationID , 
			  sfs.StandardFeeScheduleID  
	FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs
	WHERE doc.PracticeID = @PracticeID AND
		CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
		sfs.PracticeID = @PracticeID AND
		sl.PracticeID = @PracticeID AND
		doc.[External] = 0      
			PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'

END




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_9_1_Appointments]') AND type in (N'U'))
BEGIN
	PRINT ''
	PRINT 'Inserting into Appointment...'
		--Appointments
		INSERT INTO dbo.Appointment
				( PatientID ,
				  PracticeID ,
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
				  realP.PatientID , -- PatientID - int
				  @PracticeID , -- PracticeID - int
				  DATEADD(hh, -3, DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
					   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
							THEN  replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')
							ELSE (replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
							END
						ELSE
							CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
								THEN REPLACE(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 				ELSE replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', '')
							END 
						END ), 2) AS SMALLINT), 
				  DATEADD(hh, CAST(
						(CASE WHEN (LEFT((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 2)) > 24 
						THEN  left((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 1)
						ELSE  left((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 2) END) AS SMALLINT), date))) , --Starttime 
				DATEADD( hh, -3, DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
					   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
							THEN  replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
							ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
							END
						ELSE
							CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
								THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 				ELSE replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
							END 
						END ), 2) AS SMALLINT), 
				DATEADD(hh, CAST(
					(CASE WHEN (LEFT((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 2)) > 24 
					THEN  left((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 1)
					ELSE  left((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 2) END) AS SMALLINT), date))) , -- Endtime
				  'P' , -- AppointmentType - varchar(1)
				  '' , -- Subject - varchar(64)
				  app.note , -- Notes - text
				  GETDATE() , -- CreatedDate - datetime
				  0 , -- CreatedUserID - int
				  GETDATE() , -- ModifiedDate - datetime
				  0 , -- ModifiedUserID - int
				  0 , -- AppointmentResourceTypeID - int
				  'S' , -- AppointmentConfirmationStatusCode - char(1)
				  pc.PatientCaseID , -- PatientCaseID - int
				  dk.DKPracticeID , -- StartDKPracticeID - int
				  dk.DKPracticeID , -- EndDKPracticeID - int
				  CASE WHEN charindex( 'PM' , app.[starttime] , 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')
						ELSE (replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
					  END
					  ELSE
						replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', '')
				  END ,  -- StartTm - smallint
				  CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, CAST(app.[length] AS SMALLINT), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(DATEADD(mi, CAST(app.[length] AS SMALLINT), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
						  ELSE (replace(replace(ltrim(right(DATEADD(mi, CAST(app.[length] AS SMALLINT), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
					  END
					  ELSE
						CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, CAST(app.[length] AS SMALLINT), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
							 THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, CAST(app.[length] AS SMALLINT), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 			ELSE replace(replace(ltrim(right(DATEADD(mi, CAST(app.[length] AS SMALLINT), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
						END 
				   END   -- EndTm - smallint
		FROM dbo.[_import_9_1_Appointments] app 
		LEFT JOIN dbo.Patient realP ON
			app.chartnumber = realP.VendorID AND
			realP.PracticeID = @PracticeID
		LEFT JOIN dbo.PatientCase pc ON 
			realP.patientID = pc.PatientCaseID and
			pc.PracticeID = @PracticeID
		LEFT JOIN dbo.DateKeyToPractice dk ON
			dk.Dt = CAST(date AS VARCHAR) AND
			dk.PracticeID = @PracticeID
		WHERE date > GETDATE() AND
			realP.PatientID IS NOT NULL 
		PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted '

	PRINT ''
	PRINT 'Inserting into AppointmentToResource...'
		--AppointmentResource
		INSERT INTO dbo.AppointmentToResource
				( AppointmentID ,
				  AppointmentResourceTypeID ,
				  ResourceID ,
				  ModifiedDate ,
				  PracticeID
				)
		SELECT 
			App.AppointmentID,
			1,
			Doc.DoctorID,
			GETDATE(),
			@PracticeID
		FROM dbo.[_import_9_1_Appointments] impAppt
		INNER JOIN dbo.Patient Pat ON 
			impAppt.chartnumber = Pat.VendorID AND 
			Pat.VendorImportID = @VendorImportID
		INNER JOIN dbo.Appointment App ON 
			Pat.PatientID = App.PatientID AND
			CASE WHEN charindex( 'PM' , impAppt.[starttime] , 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(CAST(impAppt.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(CAST(impAppt.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')
						ELSE (replace(replace(ltrim(right(CAST(impAppt.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
					  END
					  ELSE
						replace(replace(ltrim(right(CAST(impAppt.[starttime] AS DATETIME), 7)), 'AM', ''), ':', '')
				  END = App.StartTm
		INNER JOIN dbo.Doctor Doc ON 
			impAppt.provider = Doc.VendorID AND 
			Doc.VendorImportID = @VendorImportID
		WHERE CAST(impAppt.Date AS DATETIME) > GETDATE()
		PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'

END 

	PRINT ''
	PRINT 'Updating PatientCase...'
-- Set cases without policies to self-pay (11)
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11 
WHERE 
	@VendorImportID = VendorImportID AND 
	@PracticeID = PracticeID AND
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID) AND
	PayerScenarioID <> 11
		PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records updated'



UPDATE dbo.Appointment 
			SET StartTm = (StartTm - 300),
				EndTm = (EndTm - 300) 



COMMIT 


		
/*
SELECT * FROM dbo.Practice

SELECT * FROM dbo.[_import_9_1_PatientData]
*/