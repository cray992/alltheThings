USE superbill_25324_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @OldVendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 16
SET @OldVendorImportID = 12

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Updating Patient Records created by customer with a VendorID...'
UPDATE dbo.Patient
SET VendorID = imp.chartnumber ,
	VendorImportID = 16
FROM dbo.Patient pat
INNER JOIN dbo.[_import_16_1_CaseInformation] imp ON 
imp.chartnumber = pat.MedicalRecordNumber AND
pat.PracticeID = @PracticeID
WHERE pat.VendorID IS NULL AND pat.VendorImportID IS NULL
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
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
		,''
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
	FROM dbo.[_import_16_1_Insurance]
	WHERE
		RTRIM(LTRIM([Name])) <> '' AND
		[code] NOT IN (SELECT VendorID FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID AND CreatedPracticeID = @PracticeID)  
		PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
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
		,''
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
	FROM dbo.[_import_16_1_Insurance] impIns
	INNER JOIN dbo.InsuranceCompany ic ON
		ic.VendorImportID = @VendorImportID AND
		ic.CreatedPracticeID = @PracticeID AND
		impIns.Code = ic.VendorID		
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into Patient...'
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
		SSN ,
		EmailAddress,
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
		Active ,
		SendEmailCorrespondence ,
		EmergencyName,
		EmergencyPhone
		)
	SELECT DISTINCT
		@PracticeID
		,''
		,impP.[LastName]
		,impP.[FirstName]
		,impP.[MiddleName]
		,''
		,impP.[Street1]
		,impP.[Street2]
		,impP.[City]
		,impP.[State]
		,impP.[Country]
		,LEFT(REPLACE(impP.[ZipCode], '-', ''), 9)
		,CASE impP.[Sex] WHEN 'Female' THEN 'F' WHEN 'Male' THEN 'M' ELSE 'U' END
		,CASE pms.[MaritalStatus] 
			WHEN 'Divorced' THEN 'D' 
			WHEN 'Single' THEN 'S' 
			WHEN 'Married' THEN 'M' 
			WHEN 'Widowed' THEN 'W' 
			ELSE NULL -- Can be NULL, and that's ok
		END
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[Phone1], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[Phone2], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[Phone3], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		,CASE ISDATE(impP.[DateOfBirth]) WHEN 1 THEN impP.[DateOfBirth] ELSE NULL END 
		,LEFT(REPLACE(impP.[SocialSecurityNumber], '-', ''), 9)
		,impP.Email
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
		,1 -- Active
		,CASE WHEN impP.Email <> '' THEN 1 ELSE 0 END -- SendEmailCorrespondence
		,impP.[ContactName] -- EmergencyName
		,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[ContactPhone1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) -- EmergencyPhone
	FROM dbo.[_import_16_1_PatientData] impP
	LEFT OUTER JOIN dbo.[_import_16_1_CaseInformation] pms ON impP.ChartNumber = pms.ChartNumber
	LEFT OUTER JOIN dbo.Doctor ON 
		@VendorImportID = Doctor.VendorImportID AND 
		@PracticeID = Doctor.PracticeID AND
		impP.assignedprovider = Doctor.VendorID AND 
		Doctor.[External] = 0
    LEFT JOIN dbo.Patient pat ON
        impP.Chartnumber = pat.MedicalRecordNumber
    LEFT JOIN dbo.Patient rpat ON 
        impP.Firstname = rpat.firstname AND
        impP.Lastname = rpat.LastName AND
        impP.socialsecuritynumber = rpat.ssn
WHERE pat.patientid IS NULL and rpat.patientid IS NULL


PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into PatientCase...'
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
		 pat.PatientID
		,impcase.[Description]
		,5 -- 'Commercial' (I was told this is a good default)
		,'Created via data import'
		,GETDATE()
		,0
		,GETDATE()
		,0
		,@PracticeID
		,chartnumber
		,VendorID -- Auto ID added by Kareo process MUST BE UNIQUE PER CASE record, so the chart_number, (patient handle), won't work here. since a patient can have multiple "cases" (aka polciies in kareo world)
		,@VendorImportID
	FROM 
	 dbo.Patient pat
	INNER JOIN dbo.[_import_16_1_CaseInformation] impcase ON 
		impCase.[ChartNumber] = pat.VendorID AND 
		pat.VendorImportID = @VendorImportID AND
		pat.PracticeID = @PracticeID
	WHERE impCase.[Description] <> '' 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into PatientCase for VendorImportID 12...'
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
		 pat.PatientID
		,impcase.[Description]
		,5 -- 'Commercial' (I was told this is a good default)
		,'Import Date: ' + CONVERT(VARCHAR(10),GETDATE(),101)
		,GETDATE()
		,0
		,GETDATE()
		,0
		,@PracticeID
		,chartnumber
		,VendorID  -- Auto ID added by Kareo process MUST BE UNIQUE PER CASE record, so the chart_number, (patient handle), won't work here. since a patient can have multiple "cases" (aka polciies in kareo world)
		,@OldVendorImportID
	FROM 
	 dbo.Patient pat
	INNER JOIN dbo.[_import_16_1_CaseInformation] impcase ON 
		impCase.[ChartNumber] = pat.VendorID AND 
		pat.VendorImportID = @OldVendorImportID AND
		pat.PracticeID = @PracticeID
	WHERE impCase.[Description] <> '' 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Insert Into InsurancePolicy1 for VendorImportID 15...'
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
		HolderSSN,
		HolderGender,
		HolderAddressLine1,
		HolderAddressLine2,
		HolderCity,
		HolderState,
		HolderCountry,
		HolderZipCode,
		HolderPhone
	)
	SELECT DISTINCT
		 pc.PatientCaseID
		,icp.InsuranceCompanyPlanID
		,1
		,impPC.[PolicyNumber1]
		,impPC.[GroupNumber1]
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
		,PC.VendorID -- auto ID we added to temp table
		,@VendorImportID
		,'Y'
		,''
		,''
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[FirstName] END
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[MiddleName] END
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[LastName] END
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN 
			CASE WHEN ISDATE(holder.[DateOfBirth]) = 1 THEN holder.[DateOfBirth] END 
		END 
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[SocialSecurityNumber], '-', ''), 9) END
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
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[Country] END 
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[ZipCode], '-', ''), 9) END 
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) END 
	FROM dbo.[_import_16_1_CaseInformation] impPC
	INNER JOIN dbo.PatientCase pc ON 
		pc.VendorID = impPC.chartnumber AND 
		pc.VendorImportID = @VendorImportID
	LEFT JOIN (
		SELECT DISTINCT [ChartNumber], [LastName], [FirstName], [MiddleName], [Street1], [Street2], [City], [State], [ZipCode], [Phone1], [SocialSecurityNumber], [Sex], [DateofBirth], [Country] FROM dbo.[_import_15_1_PatientData]
	) holder ON holder.[ChartNumber] = impPC.[Insured1]
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.VendorImportID IN (@OldVendorImportID,@VendorImportID) AND
		icp.CreatedPracticeID = @PracticeID AND
		impPC.[InsuranceCarrier1] = icp.VendorID
	WHERE
		pc.PracticeID = @PracticeID AND
		impPC.[PolicyNumber1] <> '' OR impPC.[InsuranceCarrier1] <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Insert Into InsurancePolicy2 for VendorImportID 15...'
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
		HolderSSN,
		HolderGender,
		HolderAddressLine1,
		HolderAddressLine2,
		HolderCity,
		HolderState,
		HolderCountry,
		HolderZipCode,
		HolderPhone
	)
	SELECT DISTINCT
		pc.PatientCaseID
		,icp.InsuranceCompanyPlanID
		,2
		,impPC.[PolicyNumber2]
		,impPC.[GroupNumber2]
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
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[MiddleName] END
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[LastName] END
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN 
			CASE WHEN ISDATE(holder.[DateOfBirth]) = 1 THEN holder.[DateOfBirth] END 
		END 
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[SocialSecurityNumber], '-', ''), 9) END
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
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[Country] END 
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[ZipCode], '-', ''), 9) END 
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) END 
	FROM dbo.[_import_16_1_CaseInformation] impPC
	INNER JOIN dbo.PatientCase pc ON 
		pc.VendorID = impPC.chartnumber AND 
		pc.VendorImportID =@VendorImportID
	LEFT JOIN (
		SELECT DISTINCT [ChartNumber], [LastName], [FirstName], [MiddleName], [Street1], [Street2], [City], [State], [ZipCode], [Phone1], [SocialSecurityNumber], [Sex], [DateofBirth], [Country] FROM dbo.[_import_15_1_PatientData]
	) holder ON holder.[ChartNumber] = impPC.[Insured2]
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.VendorImportID IN (@OldVendorImportID,@VendorImportID) AND
		icp.CreatedPracticeID = @PracticeID AND
		impPC.[InsuranceCarrier2] = icp.VendorID
	WHERE
		pc.PracticeID = @PracticeID AND
		impPC.[PolicyNumber2] <> '' OR impPC.[InsuranceCarrier2] <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into InsurancePolicy1 for VendorImportID 12...'
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
		HolderSSN,
		HolderGender,
		HolderAddressLine1,
		HolderAddressLine2,
		HolderCity,
		HolderState,
		HolderCountry,
		HolderZipCode,
		HolderPhone
	)
	SELECT DISTINCT
		 pc.PatientCaseID
		,icp.InsuranceCompanyPlanID
		,1
		,impPC.[PolicyNumber1]
		,impPC.[GroupNumber1]
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
		,12
		,'Y'
		,''
		,''
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[FirstName] END
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[MiddleName] END
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[LastName] END
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN 
			CASE WHEN ISDATE(holder.[DateOfBirth]) = 1 THEN holder.[DateOfBirth] END 
		END 
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[SocialSecurityNumber], '-', ''), 9) END
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
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN holder.[Country] END 
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[ZipCode], '-', ''), 9) END 
		,CASE WHEN impPC.[InsuredRelationship1] <> 'Self' AND impPC.[Insured1] <> impPC.[ChartNumber] THEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) END 
	FROM dbo.[_import_16_1_CaseInformation] impPC
	INNER JOIN dbo.PatientCase pc ON 
		pc.VendorID = impPC.chartnumber  AND
		pc.VendorImportID = @OldVendorImportID AND 
		pc.PracticeID = @PracticeID
	LEFT JOIN (
		SELECT DISTINCT [ChartNumber], [LastName], [FirstName], [MiddleName], [Street1], [Street2], [City], [State], [ZipCode], [Phone1], [SocialSecurityNumber], [Sex], [DateofBirth], [Country] FROM dbo.[_import_15_1_PatientData]
	) holder ON holder.[ChartNumber] = impPC.[Insured1]
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.VendorImportID = @OldVendorImportID AND
		icp.CreatedPracticeID = @PracticeID AND
		impPC.[InsuranceCarrier1] = icp.VendorID
	WHERE
		impPC.[PolicyNumber1] <> '' OR impPC.[InsuranceCarrier1] <> '' 
	PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

	
	
PRINT ''
PRINT 'Inserting Into InsurancePolicy2 for VendorImportID 12...'
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
		HolderSSN,
		HolderGender,
		HolderAddressLine1,
		HolderAddressLine2,
		HolderCity,
		HolderState,
		HolderCountry,
		HolderZipCode,
		HolderPhone
	)
	SELECT DISTINCT
		pc.PatientCaseID
		,icp.InsuranceCompanyPlanID
		,2
		,impPC.[PolicyNumber2]
		,impPC.[GroupNumber2]
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
		,12
		,'Y'
		,''
		,''
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[FirstName] END
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[MiddleName] END
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[LastName] END
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN 
			CASE WHEN ISDATE(holder.[DateOfBirth]) = 1 THEN holder.[DateOfBirth] END 
		END 
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[SocialSecurityNumber], '-', ''), 9) END
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
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN holder.[Country] END 
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[ZipCode], '-', ''), 9) END 
		,CASE WHEN impPC.[InsuredRelationship2] <> 'Self' AND impPC.[Insured2] <> impPC.[ChartNumber] THEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) END 
	FROM dbo.[_import_16_1_CaseInformation] impPC
	INNER JOIN dbo.PatientCase pc ON 
		pc.VendorID = impPC.chartnumber  AND
		pc.VendorImportID = @OldVendorImportID AND 
		pc.PracticeID = @PracticeID
	LEFT JOIN (
		SELECT DISTINCT [ChartNumber], [LastName], [FirstName], [MiddleName], [Street1], [Street2], [City], [State], [ZipCode], [Phone1], [SocialSecurityNumber], [Sex], [DateofBirth], [Country] FROM dbo.[_import_15_1_PatientData]
	) holder ON holder.[ChartNumber] = impPC.[Insured1]
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.VendorImportID = @OldVendorImportID AND
		icp.CreatedPracticeID = @PracticeID AND
		impPC.[InsuranceCarrier1] = icp.VendorID
	WHERE
		impPC.[PolicyNumber2] <> '' OR impPC.[InsuranceCarrier2] <> '' 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Insert Into InsurancePolicy3 for VendorImportID 12...'
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
		HolderSSN,
		HolderGender,
		HolderAddressLine1,
		HolderAddressLine2,
		HolderCity,
		HolderState,
		HolderCountry,
		HolderZipCode,
		HolderPhone
	)
	SELECT DISTINCT
		pc.PatientCaseID
		,icp.InsuranceCompanyPlanID
		,3
		,impPC.[PolicyNumber3]
		,impPC.[GroupNumber3]
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
		,12
		,'Y'
		,''
		,''
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN holder.[FirstName] END
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN holder.[MiddleName] END
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN holder.[LastName] END
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN 
			CASE WHEN ISDATE(holder.[DateOfBirth]) = 1 THEN holder.[DateOfBirth] END 
		END 
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[SocialSecurityNumber], '-', ''), 9) END
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
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN holder.[Country] END 
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN LEFT(REPLACE(holder.[ZipCode], '-', ''), 9) END 
		,CASE WHEN impPC.[InsuredRelationship3] <> 'Self' AND impPC.[Insured3] <> impPC.[ChartNumber] THEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) END 
	FROM dbo.[_import_16_1_CaseInformation] impPC
	INNER JOIN dbo.PatientCase pc ON 
		pc.VendorID = impPC.chartnumber  AND
		pc.VendorImportID = @OldVendorImportID AND 
		pc.PracticeID = @PracticeID
	LEFT JOIN (
		SELECT DISTINCT [ChartNumber], [LastName], [FirstName], [MiddleName], [Street1], [Street2], [City], [State], [ZipCode], [Phone1], [SocialSecurityNumber], [Sex], [DateofBirth], [Country] FROM dbo.[_import_15_1_PatientData]
	) holder ON holder.[ChartNumber] = impPC.[Insured1]
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.VendorImportID = @OldVendorImportID AND
		icp.CreatedPracticeID = @PracticeID AND
		impPC.[InsuranceCarrier1] = icp.VendorID
	WHERE
		impPC.[PolicyNumber3] <> '' OR impPC.[InsuranceCarrier3] <> '' 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Appointment...'
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
          pat.PatientID , --PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          imp.startdateest , -- StartDate - datetime
          imp.enddateest , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          imp.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          imp.starttmest , -- StartTm - smallint
          imp.endtmest  -- EndTm - smallint
FROM dbo.[_import_16_1_Appointment] imp
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = imp.chartnumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = pat.VendorID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc2 ON 
	pc2.CaseNumber = pat.VendorID AND
	pc2.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = CAST(CAST(imp.startdateest AS DATE) AS DATETIME)
LEFT JOIN dbo.Appointment app ON
	app.StartDate = CAST(imp.startdateest AS DATETIME) AND
	app.PatientID = pat.PatientID
WHERE app.StartDate IS NULL and app.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Appointment for VendorImportID 12...'
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
          pat.PatientID , --PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          imp.startdateest , -- StartDate - datetime
          imp.enddateest , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          imp.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc2.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          imp.starttmest , -- StartTm - smallint
          imp.endtmest  -- EndTm - smallint
FROM dbo.[_import_16_1_Appointment] imp
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = imp.chartnumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc2 ON 
	pc2.CaseNumber = pat.VendorID AND
	pc2.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = CAST(CAST(imp.startdateest AS DATE) AS DATETIME)
LEFT JOIN dbo.Appointment app ON
	app.StartDate = CAST(imp.startdateest AS DATETIME) AND
	app.PatientID = pat.PatientID
WHERE app.StartDate IS NULL and app.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




PRINT ''
PRINT 'Inserting into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  app.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int;
          doc.DoctorID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_16_1_Appointment] AS imp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = imp.chartnumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS app ON
	app.PatientID = pat.PatientID AND
	app.StartDate = imp.startdateest 
INNER JOIN dbo.[_import_16_1_Providers] AS impPro ON
	impPro.code = imp.provider
INNER JOIN dbo.Doctor AS doc ON
	doc.FirstName = impPro.firstname AND
	doc.LastName = impPro.lastname AND
	doc.[External] = 0 AND
	doc.PracticeID = @PracticeID
WHERE app.CreatedDate > DATEADD(mi,-2,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT

-- PLEASE RUN THE QUERY BELOW AFTER THE ABOVE HAS BEEN COMMITED. PLEASE COPY THE RESULTS WITH THE HEADERS TO EXCEL, SAVE, ATTACH TO 
-- OUTLOOK EMAIL AND SEND TO TRAVIS.BROWN@KAREO.COM 
-- THANK YOU
	
--SELECT MedicalRecordNumber AS MRN, FirstName AS [FIRST NAME] , LastName AS [LAST NAME] , AddressLine1 AS [STREET1], AddressLine2 AS [STREET2], City AS [CITY], [State] AS [STATE], ZipCode AS [ZIPCODE], SSN AS [SSN] FROM dbo.Patient WITH (NOLOCK) WHERE MedicalRecordNumber IS NULL

