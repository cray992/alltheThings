BEGIN TRAN

--SELECT *
--FROM dbo.[_import_1_1_PatientDemographics] AS IPD
--ORDER BY firstname, lastname

--SELECT DISTINCT firstname, lastname
--FROM dbo.[_import_1_1_PatientDemographics] AS IPD
--LEFT JOIN dbo.[_import_1_1_InsuranceCaseInformation] AS IICI ON IPD.patientid = IICI.patientid
----LEFT JOIN dbo.Employers AS E ON e.EmployerName = IPD.employer WHERE ipd.employer <> ''
--ORDER BY firstname, lastname

--SELECT DISTINCT REPLACE(insuredparty,' ','.'), 
--CASE WHEN PARSENAME(REPLACE(insuredparty,' ','.'),2) IS NULL THEN PARSENAME(REPLACE(insuredparty,' ','.'),1) WHEN PARSENAME(REPLACE(insuredparty,' ','.'),3) IS NULL THEN PARSENAME(REPLACE(insuredparty,' ','.'),2) ELSE PARSENAME(REPLACE(insuredparty,' ','.'),3) END AS FirstName,
--CASE WHEN PARSENAME(REPLACE(insuredparty,' ','.'),3) IS NOT NULL THEN PARSENAME(REPLACE(insuredparty,' ','.'),2) ELSE '' END AS MiddleName,
--CASE WHEN PARSENAME(REPLACE(insuredparty,' ','.'),2) IS NULL THEN '' ELSE PARSENAME(REPLACE(insuredparty,' ','.'),1) END AS LastName
--FROM dbo.[_import_1_1_InsuranceCaseInformation] AS IICI

DECLARE @practiceid INT, @vendorimportid INT
SELECT @practiceid = 1, @vendorimportid = 2


--=================================================================================
-- EMPLOYERS
--=================================================================================

INSERT INTO dbo.Employers
        ( EmployerName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT employer , -- EmployerName - varchar(128)
          '' , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          '' , -- City - varchar(128)
          '' , -- State - varchar(2)
          '' , -- Country - varchar(32)
          '' , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_1_PatientDemographics] AS IPD WHERE employer <> ''




--=================================================================================
-- PATIENTS
--=================================================================================

INSERT INTO dbo.Patient
        ( PracticeID ,
          ReferringPhysicianID ,
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
          MaritalStatus ,
          HomePhone ,
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleCountry ,
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          InsuranceProgramCode ,
          PatientReferralSourceID ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt 
        )
SELECT	DISTINCT  @practiceid, 
          NULL ,
          '' ,
          IPD.FirstName ,
          IPD.MiddleName ,
          IPD.LastName ,
          IPD.Suffix ,
          IPD.[Address] ,
          IPD.Address2 ,
          IPD.City , 
          LEFT(IPD.[State],2) ,
          '' ,
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ipd.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ipd.zip) ELSE '' END,
          CASE WHEN sex = 'female' THEN 'F' WHEN sex = 'male' THEN 'M' ELSE 'U' END,
          CASE WHEN maritalstatus = 'Married' THEN 'M' WHEN maritalstatus = 'single' THEN 'S' WHEN maritalstatus = 'widowed' THEN 'W' ELSE '' END	,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ipd.phone)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(ipd.phone) ELSE '' END,
          '',
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(workphone)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(workphone) ELSE '' END,
          '',
		  CASE WHEN ISDATE(dob) = 1 THEN CAST(dob AS DATETIME) ELSE NULL END,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ssn)) = 9 THEN dbo.fn_RemoveNonNumericCharacters(ssn) ELSE '' END,
          IPD.email,
          0,--CASE WHEN iici.insuredparty = '' THEN 0 ELSE 1 END ,
          '', --IPD.ResponsiblePrefix ,
          '',--CASE WHEN PARSENAME(REPLACE(insuredparty,' ','.'),2) IS NULL THEN PARSENAME(REPLACE(insuredparty,' ','.'),1) WHEN PARSENAME(REPLACE(insuredparty,' ','.'),3) IS NULL THEN PARSENAME(REPLACE(insuredparty,' ','.'),2) ELSE PARSENAME(REPLACE(insuredparty,' ','.'),3) END AS FirstName, --IPD.ResponsibleFirstName ,
		  '',--CASE WHEN PARSENAME(REPLACE(insuredparty,' ','.'),3) IS NOT NULL THEN PARSENAME(REPLACE(insuredparty,' ','.'),2) ELSE '' END AS MiddleName,--IPD.ResponsibleMiddleName ,
		  '',--CASE WHEN PARSENAME(REPLACE(insuredparty,' ','.'),2) IS NULL THEN '' ELSE PARSENAME(REPLACE(insuredparty,' ','.'),1) END AS LastName,--IPD.ResponsibleLastName ,
          '', --IPD.ResponsibleSuffix ,
          'S', --CASE WHEN IICI.insuredparty = '' THEN 'S' ELSE 'O' END,--IPD.ResponsibleRelationshipToPatient ,
          '',--IPD.ResponsibleAddressLine1 ,
          '',--IPD.ResponsibleAddressLine2 ,
          '',--IPD.ResponsibleCity ,
          '',--IPD.ResponsibleState ,
          '',--IPD.ResponsibleCountry ,
          '',--IPD.ResponsibleZipCode ,
          GETDATE(),
          0, 
          GETDATE(),
          0,
          CASE WHEN employmentstatus = 'employed' THEN 'E' WHEN employmentstatus = 'FT Student' THEN 'S' WHEN employmentstatus = 'PT Student' THEN 'T' ELSE 'U' END,
          NULL,
          NULL,
          NULL,
          NULL,
          E.EmployerID,
          IPD.patientid ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(phonealternate)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(phonealternate) ELSE '' END,
          '',
          NULL ,
          IPD.AutoTempID ,
          @vendorimportid ,
          1 ,--IPD.CollectionCategoryID ,
          CASE WHEN isactive = 'y' THEN 1 ELSE 0 END	,
          CASE WHEN LEN(email) > 0 THEN 1 ELSE 0 END,
          1,
          IPD.emergencycontact,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(emergencyphone)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(emergencyphone) ELSE '' END ,
          ''
FROM dbo.[_import_1_1_PatientDemographics] AS IPD
LEFT JOIN dbo.Employers AS E ON e.EmployerName = IPD.employer and ipd.employer <> ''
ORDER BY ipd.firstname, ipd.lastname

--=================================================================================
-- PATIENT CASES
--=================================================================================

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
SELECT    PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import. Please review before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID


--=================================================================================
-- INSURANCE COMPANIES
--=================================================================================

INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          LocalUseFieldTypeCode ,
          ReviewCode ,
          ProviderNumberTypeID ,
          GroupNumberTypeID ,
          LocalUseProviderNumberTypeID ,
          CompanyTextID ,
          ClearinghousePayerID ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          KareoInsuranceCompanyID ,
          KareoLastModifiedDate ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT 
		  CASE WHEN typename IN ( 'Commercial', 'Miscellaneous') THEN payorname ELSE typename END , -- InsuranceCompanyName - varchar(128)
          '' , -- Notes - text
          [address] , -- AddressLine1 - varchar(256)
          [address2] , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT(state,2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zip) ELSE '' END , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
           CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(phone)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(phone) ELSE '' END , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)
          0, -- BillSecondaryInsurance - bit
          0, -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          '' , -- LocalUseFieldTypeCode - char(5)
          'R' , -- ReviewCode - char(1)
          NULL , -- ProviderNumberTypeID - int
          NULL , -- GroupNumberTypeID - int
          NULL  , -- LocalUseProviderNumberTypeID - int
          '' , -- CompanyTextID - varchar(10)
          NULL  , -- ClearinghousePayerID - int
          @practiceid , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL  , -- KareoInsuranceCompanyID - int
          GETDATE() , -- KareoLastModifiedDate - datetime
          13 , -- SecondaryPrecedenceBillingFormID - int
          NULL , -- VendorID - varchar(50)
          @vendorimportid , -- VendorImportID - int
          NULL  , -- DefaultAdjustmentCode - varchar(10)
          NULL  , -- ReferringProviderNumberTypeID - int
          1  , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceCaseInformation] AS IICI



--=================================================================================
-- INSURANCE COMPANY PLANS
--=================================================================================

INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          Notes ,
          MM_CompanyID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReviewCode ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          KareoInsuranceCompanyPlanID ,
          KareoLastModifiedDate ,
          InsuranceCompanyID ,
          ADS_CompanyID ,
          Copay ,
          Deductible ,
          VendorID ,
          VendorImportID 
        )
SELECT InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          Country , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          ContactPrefix , -- ContactPrefix - varchar(16)
          ContactFirstName , -- ContactFirstName - varchar(64)
          ContactMiddleName , -- ContactMiddleName - varchar(64)
          ContactLastName , -- ContactLastName - varchar(64)
          ContactSuffix , -- ContactSuffix - varchar(16)
          Phone , -- Phone - varchar(10)
          PhoneExt , -- PhoneExt - varchar(10)
          Notes , -- Notes - text
          NULL , -- MM_CompanyID - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'R' , -- ReviewCode - char(1)
          CreatedPracticeID , -- CreatedPracticeID - int
          Fax , -- Fax - varchar(10)
          Fax , -- FaxExt - varchar(10)
          NULL , -- KareoInsuranceCompanyPlanID - int
          NULL , -- KareoLastModifiedDate - datetime
          InsuranceCompanyID , -- InsuranceCompanyID - int
          NULL , -- ADS_CompanyID - varchar(10)
          0.0, -- Copay - money
          0.0 , -- Deductible - money
          NULL , -- VendorID - varchar(50)
          @vendorimportid -- VendorImportID - int
FROM dbo.InsuranceCompany AS IC
WHERE VendorImportID = @vendorimportid





--=================================================================================
-- INSURANCE POLICIES
--=================================================================================

INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderLastName ,
          HolderSuffix ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          --HolderAddressLine2 ,
          --HolderCity ,
          --HolderState ,
          --HolderZipCode ,
          HolderPhone ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID,
		  PolicyStartDate ,
          PolicyEndDate ,
		  Copay ,
          Deductible 
        )
SELECT DISTINCT pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          CASE WHEN IICI.priority = 'Terminated' THEN 0 ELSE CAST(IICI.priority AS INT) END , -- Precedence - int
          LEFT(iici.policyid,32) , -- PolicyNumber - varchar(32)
          LEFT(iici.groupnumber,32) , -- GroupNumber - varchar(32)
          p.ResponsibleRelationshipToPatient , -- PatientRelationshipToInsured - varchar(1)
          p.ResponsibleFirstName, -- HolderFirstName - varchar(64)
          p.ResponsibleLastName, -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
		  '', -- HolderAddressLine1 - varchar(256)
		'' , -- HolderPhone - varchar(10)
          CASE WHEN [priority] = 'terminated' THEN 0 ELSE 1 END , -- Active - bit
          @PracticeID , -- PracticeID - int
          iici.AutoTempID, -- VendorID - varchar(50)
          @VendorImportID, -- VendorImportID - int
		 CASE WHEN ISDATE(policystartdate) = 1 THEN CAST(policystartdate AS DATETIME) ELSE NULL END,	--PolicyStartDate ,
			CASE WHEN ISDATE(policyenddate) = 1 THEN CAST(policyenddate AS DATETIME) ELSE NULL END, --PolicyEndDate ,
		iici.copayamount,	--Copay ,
		iici.deductible--Deductible  
FROM dbo.[_import_1_1_InsuranceCaseInformation] AS IICI
JOIN dbo.Patient AS P ON P.MedicalRecordNumber = IICI.patientid AND P.VendorImportID = @vendorimportid
JOIN dbo.PatientCase AS PC ON PC.PatientID = P.PatientID
JOIN dbo.InsuranceCompanyPlan AS ICP ON ICP.PlanName = CASE WHEN typename IN ( 'Commercial', 'Miscellaneous') THEN payorname ELSE typename END
	AND ICP.AddressLine1 = IICI.address AND ICP.AddressLine2 = IICI.address2 AND icp.City = IICI.city
	AND ICP.State = LEFT(IICI.state, 2) AND icp.ZipCode = CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zip) ELSE '' END
	AND ICP.Phone = CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IICI.phone)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(IICI.phone) ELSE '' END  
	AND ICP.VendorImportID = @vendorimportid	
WHERE iici.priority <> 'terminated'
ORDER BY PatientCaseID

INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderLastName ,
          HolderSuffix ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          --HolderAddressLine2 ,
          --HolderCity ,
          --HolderState ,
          --HolderZipCode ,
          HolderPhone ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID,
		  PolicyStartDate ,
          PolicyEndDate ,
		  Copay ,
          Deductible 
        )
SELECT DISTINCT pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          ROW_NUMBER() OVER(PARTITION BY PatientCaseID ORDER BY PatientCaseID) + 89 , -- Precedence - int
          LEFT(iici.policyid,32) , -- PolicyNumber - varchar(32)
          LEFT(iici.groupnumber,32) , -- GroupNumber - varchar(32)
          p.ResponsibleRelationshipToPatient , -- PatientRelationshipToInsured - varchar(1)
          p.ResponsibleFirstName, -- HolderFirstName - varchar(64)
          p.ResponsibleLastName, -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
		  '', -- HolderAddressLine1 - varchar(256)
		'' , -- HolderPhone - varchar(10)
          CASE WHEN [priority] = 'terminated' THEN 0 ELSE 1 END , -- Active - bit
          @PracticeID , -- PracticeID - int
          iici.AutoTempID, -- VendorID - varchar(50) 
          @VendorImportID, -- VendorImportID - int
		 CASE WHEN ISDATE(policystartdate) = 1 THEN CAST(policystartdate AS DATETIME) ELSE NULL END,	--PolicyStartDate ,
			CASE WHEN ISDATE(policyenddate) = 1 THEN CAST(policyenddate AS DATETIME) ELSE NULL END, --PolicyEndDate ,
		iici.copayamount,	--Copay ,
		iici.deductible--Deductible  
FROM dbo.[_import_1_1_InsuranceCaseInformation] AS IICI
JOIN dbo.Patient AS P ON P.MedicalRecordNumber = IICI.patientid AND P.VendorImportID = @vendorimportid
JOIN dbo.PatientCase AS PC ON PC.PatientID = P.PatientID
JOIN dbo.InsuranceCompanyPlan AS ICP ON ICP.PlanName = CASE WHEN typename IN ( 'Commercial', 'Miscellaneous') THEN payorname ELSE typename END
	AND ICP.AddressLine1 = IICI.address AND ICP.AddressLine2 = IICI.address2 AND icp.City = IICI.city
	AND ICP.State = LEFT(IICI.state, 2) AND icp.ZipCode = CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zip) ELSE '' END
	AND ICP.Phone = CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IICI.phone)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(IICI.phone) ELSE '' END  
	AND ICP.VendorImportID = @vendorimportid	
WHERE iici.priority = 'terminated'
ORDER BY PatientCaseID
	
	
ROLLBACK TRAN
