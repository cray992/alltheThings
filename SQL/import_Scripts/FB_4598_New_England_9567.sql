USE superbill_9567_dev
--USE superbill_9567_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(100)
DECLARE @ImportNote VARCHAR(100)

-- This script ASSUMES that someone has created the first practice record. On dev I did this myself
-- But on prod please make sure her practice exists first, (and it's ID is 1).
SET @PracticeID = 1
SET @VendorName = 'New England Center For Plastic & Reconstructive Surgery'
SET @ImportNote = 'Initial import for customer 9567. FB 4598'

-- If the VendorImport record doesn't exist create it
IF NOT EXISTS (SELECT * FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)
BEGIN
	INSERT INTO dbo.VendorImport (VendorName, VendorFormat, DateCreated, Notes) 
	VALUES (@VendorName, 'CSV', GETDATE(), @ImportNote)
END

SET @VendorImportID = (SELECT VendorImportID FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- delete records
DELETE dbo.InsurancePolicy WHERE VendorImportID=@vendorImportID
DELETE dbo.PatientCase WHERE VendorImportID=@vendorImportID
DELETE dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID=@vendorIMportID)
DELETE dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID=@vendorIMportID)
DELETE dbo.Patient WHERE VendorImportID=@vendorImportID

DELETE dbo.InsuranceCompanyPlan WHERE VendorImportID=@vendorImportID
DELETE dbo.InsuranceCompany WHERE VendorImportID=@vendorImportID

-- patient
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
          RecordTimeStamp ,
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
SELECT SP.PracticeID , -- PracticeID - int
          NULL , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          SP.FirstName , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          SP.LastName, -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          SP.Street1 , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          SP.City , -- City - varchar(128)
          LEFT(SP.[State], 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(SP.Zip, 9) , -- ZipCode - varchar(9)
			case SP.Gender WHEN 'Male' THEN 'M' WHEN 'Female' THEN 'F' ELSE 'U' END   , -- Gender - varchar(1)
          case SP.MaritalStatus WHEN 'Single' THEN 'S' WHEN 'Divorced' THEN 'D' WHEN 'Widowed' THEN 'W' WHEN 'Married' THEN 'M' ELSE 'U' END , -- MaritalStatus - varchar(1)
          SP.HomePhone , -- HomePhone - varchar(10)
          '' , -- HomePhoneExt - varchar(10)
          SP.WorkPhone , -- WorkPhone - varchar(10)
          '' , -- WorkPhoneExt - varchar(10)
          SP.DOB , -- DOB - datetime
          SP.SSN , -- SSN - char(9)
          SP.Email , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          NULL , -- ResponsiblePrefix - varchar(16)
          NULL , -- ResponsibleFirstName - varchar(64)
          NULL , -- ResponsibleMiddleName - varchar(64)
          NULL , -- ResponsibleLastName - varchar(64)
          NULL , -- ResponsibleSuffix - varchar(16)
          'O' , -- ResponsibleRelationshipToPatient - varchar(1)
          NULL , -- ResponsibleAddressLine1 - varchar(256)
          NULL , -- ResponsibleAddressLine2 - varchar(256)
          NULL , -- ResponsibleCity - varchar(128)
          NULL , -- ResponsibleState - varchar(2)
          NULL , -- ResponsibleCountry - varchar(32)
          NULL , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          case SP.EmploymentStatus WHEN 'Employed Full Time' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
          NULL , -- InsuranceProgramCode - char(2)
          NULL , -- PatientReferralSourceID - int
          NULL , -- PrimaryProviderID - int
          NULL , -- DefaultServiceLocationID - int
          NULL , -- EmployerID - int
          [Case] , -- MedicalRecordNumber - varchar(128)
          '' , -- MobilePhone - varchar(10)
          '' , -- MobilePhoneExt - varchar(10)
          NULL , -- PrimaryCarePhysicianID - int
          SP.OID , -- VendorID - varchar(50)
          @vendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
          NULL , -- EmergencyName - varchar(128)
          NULL, -- EmergencyPhone - varchar(10)
          NULL  -- EmergencyPhoneExt - varchar(10)
FROM dbo.[_import] SP

-- create alerts
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
          RecordTimeStamp ,
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT DISTINCT P.PatientID , -- PatientID - int
          DM.Alert , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          1 , -- ShowInAppointmentFlag - bit
          1 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          1 , -- ShowInClaimFlag - bit
          1 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM _import DM
	JOIN dbo.Patient P ON P.VendorImportID=@vendorImportID AND P.VendorID=DM.OID
WHERE ISNULL(Alert, '')>''

-- create Cases
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          ReferringPhysicianID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          AutoAccidentRelatedState ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          CaseNumber ,
          WorkersCompContactInfoID ,
          VendorID ,
          VendorImportID ,
          PregnancyRelatedFlag ,
          StatementActive ,
          EPSDT ,
          FamilyPlanning ,
          EPSDTCodeID ,
          EmergencyRelated
        )
        
select P.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          3 , -- PayerScenarioID - int
          NULL , -- ReferringPhysicianID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          NULL , -- AutoAccidentRelatedState - char(2)
          'Created via data import. Please verify.' , -- Notes - text
          1 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          P.PracticeID , -- PracticeID - int
          NULL , -- CaseNumber - varchar(128)
          NULL , -- WorkersCompContactInfoID - int
          P.VendorID , -- VendorID - varchar(50)
          @vendorimportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0  -- EmergencyRelated - bit
FROM dbo.Patient P
WHERE P.VendorImportID=@vendorIMportID

-- insurance companies

CREATE TABLE #IC (CompanyName VARCHAR(100), Street1 VARCHAR(100), Street2 VARCHAR(100), City VARCHAR(100), [STATE] VARCHAR(100), Zip VARCHAR(100))

INSERT INTO #IC 
        ( CompanyName ,
          Street1 ,
          Street2 ,
          City ,
          STATE ,
          Zip
        )

SELECT DISTINCT Ins1CompanyName, Ins1Street1, Ins1Street2, Ins1City, Ins1State, Ins1Zip
FROM [_import]

UNION 

SELECT DISTINCT Ins2CompanyName, Ins2Street1, Ins2Street2, Ins2City, Ins2State, Ins2Zip
FROM [_import]

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
          RecordTimeStamp ,
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
SELECT DISTINCT SIC.CompanyName , -- InsuranceCompanyName - varchar(128)
          'Created via data import. Please verify/merge before use.' , -- Notes - text
          SIC.Street1 , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          SIC.City , -- City - varchar(128)
          LEFT(SIC.[STATE], 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(SIC.Zip, 9) , -- ZipCode - varchar(9)
          NULL , -- ContactPrefix - varchar(16)
          NULL , -- ContactFirstName - varchar(64)
          NULL , -- ContactMiddleName - varchar(64)
          NULL , -- ContactLastName - varchar(64)
          NULL , -- ContactSuffix - varchar(16)
          NULL , -- Phone - varchar(10)
          NULL , -- PhoneExt - varchar(10)
          NULL , -- Fax - varchar(10)
          NULL , -- FaxExt - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          NULL , -- LocalUseFieldTypeCode - char(5)
          'R' , -- ReviewCode - char(1)
          NULL , -- ProviderNumberTypeID - int
          NULL , -- GroupNumberTypeID - int
          NULL , -- LocalUseProviderNumberTypeID - int
          NULL , -- CompanyTextID - varchar(10)
          NULL , -- ClearinghousePayerID - int
          NULL , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- KareoInsuranceCompanyID - int
          NULL , -- KareoLastModifiedDate - datetime
          NULL , -- RecordTimeStamp - timestamp
          13 , -- SecondaryPrecedenceBillingFormID - int
          NULL , -- VendorID - varchar(50)
          @vendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM #IC SIC WHERE CompanyName IS NOT NULL

DROP TABLE #IC

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
          RecordTimeStamp ,
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
select IC.InsuranceCompanyName , -- PlanName - varchar(128)
          IC.AddressLine1 , -- AddressLine1 - varchar(256)
          IC.AddressLine2 , -- AddressLine2 - varchar(256)
          IC.City , -- City - varchar(128)
          IC.[State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          IC.ZipCode , -- ZipCode - varchar(9)
		  ic.ContactPrefix , -- ContactPrefix - varchar(16)
          '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          IC.Phone , -- Phone - varchar(10)
          IC.PhoneExt , -- PhoneExt - varchar(10)
          IC.Notes , -- Notes - text
          NULL , -- MM_CompanyID - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          ' ' , -- ReviewCode - char(1)
          NULL , -- CreatedPracticeID - int
          NULL , -- Fax - varchar(10)
          NULL , -- FaxExt - varchar(10)
          NULL , -- KareoInsuranceCompanyPlanID - int
          NULL , -- KareoLastModifiedDate - datetime
          IC.InsuranceCompanyID , -- InsuranceCompanyID - int
          NULL , -- ADS_CompanyID - varchar(10)
          0 , -- Copay - money
          0 , -- Deductible - money
          NULL , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany IC
WHERE IC.VendorImportID=@VendorImportID

-- policy
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
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,
          VendorID ,
          VendorImportID ,
          InsuranceProgramTypeID ,
          GroupName ,
          ReleaseOfInformation
        )
select PC.PatientCaseID , -- PatientCaseID - int
          ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          SP.Ins1Policy , -- PolicyNumber - varchar(32)
          SP.Ins1Group , -- GroupNumber - varchar(32)
          SP.Ins1effectiveDate , -- PolicyStartDate - datetime
          SP.Ins1expirationDate , -- PolicyEndDate - datetime
          1 , -- CardOnFile - bit
          case SP.Ins1INsuredRelationship WHEN 'Self' THEN 'S' WHEN 'Spouse' THEN 'U' WHEN 'Other' THEN 'O' WHEN 'Child' THEN 'C' ELSE 'O' END  , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          SP.Ins1InsuredFirstName , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          SP.Ins1InsuredLastName , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          SP.Ins1InsuredDOB , -- HolderDOB - datetime
          SP.Ins1InsuredSSN , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          NULL , -- HolderEmployerName - varchar(128)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          'U' , -- HolderGender - char(1)
          SP.Ins1InsuredStreet1 , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          SP.Ins1InsuredCity , -- HolderCity - varchar(128)
          SP.Ins1InsuredState , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          SP.Ins1InsuredZIP , -- HolderZipCode - varchar(9)
          '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10)
          '' , -- DependentPolicyNumber - varchar(32)
          SP.Ins1PatientNotes, -- Notes - text
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)
          0 , -- Copay - money
          0 , -- Deductible - money
          NULL , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          PC.PracticeID , -- PracticeID - int
          NULL , -- AdjusterPrefix - varchar(16)
          NULL , -- AdjusterFirstName - varchar(64)
          NULL , -- AdjusterMiddleName - varchar(64)
          NULL , -- AdjusterLastName - varchar(64)
          NULL , -- AdjusterSuffix - varchar(16)
          PC.VendorID , -- VendorID - varchar(50)
          @vendorImportID , -- VendorImportID - int
          NULL , -- InsuranceProgramTypeID - int
          NULL , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import] SP
	JOIN dbo.PatientCase PC ON PC.VendorID=SP.OID AND PC.VendorImportID=@vendorIMportID
	JOIN dbo.InsuranceCompanyPlan ICP ON ICP.VendorImportID=@vendorImportID and ICP.PlanName=SP.Ins1CompanyName AND SP.Ins1Street1=ICP.AddressLine1 AND SP.Ins1City=ICP.City AND Sp.Ins1Zip=ICP.ZipCode
WHERE ICP.InsuranceCompanyPlanID IS NOT NULL


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
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,
          VendorID ,
          VendorImportID ,
          InsuranceProgramTypeID ,
          GroupName ,
          ReleaseOfInformation
        )
select PC.PatientCaseID , -- PatientCaseID - int
          ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          SP.Ins2Policy , -- PolicyNumber - varchar(32)
          SP.Ins2Group , -- GroupNumber - varchar(32)
          SP.Ins2effectiveDate , -- PolicyStartDate - datetime
          SP.Ins2expirationDate , -- PolicyEndDate - datetime
          1 , -- CardOnFile - bit
          case SP.Ins2INsuredRelationship WHEN 'Self' THEN 'S' WHEN 'Spouse' THEN 'U' WHEN 'Other' THEN 'O' WHEN 'Child' THEN 'C' ELSE 'O' END  , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          SP.Ins2InsuredFirstName , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          SP.Ins2InsuredLastName , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          SP.Ins2InsuredDOB , -- HolderDOB - datetime
          SP.Ins2InsuredSSN , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          NULL , -- HolderEmployerName - varchar(128)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          'U' , -- HolderGender - char(1)
          SP.Ins2InsuredStreet1 , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          SP.Ins2InsuredCity , -- HolderCity - varchar(128)
          SP.Ins2InsuredState , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          SP.Ins2InsuredZIP , -- HolderZipCode - varchar(9)
          '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10)
          '' , -- DependentPolicyNumber - varchar(32)
          SP.Ins2PatientNotes , -- Notes - text
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)
          0 , -- Copay - money
          0 , -- Deductible - money
          NULL , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          PC.PracticeID , -- PracticeID - int
          NULL , -- AdjusterPrefix - varchar(16)
          NULL , -- AdjusterFirstName - varchar(64)
          NULL , -- AdjusterMiddleName - varchar(64)
          NULL , -- AdjusterLastName - varchar(64)
          NULL , -- AdjusterSuffix - varchar(16)
          PC.VendorID , -- VendorID - varchar(50)
          @vendorImportID , -- VendorImportID - int
          NULL , -- InsuranceProgramTypeID - int
          NULL , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import] SP
	JOIN dbo.PatientCase PC ON PC.VendorID=SP.OID AND PC.VendorImportID=@vendorIMportID
	JOIN dbo.InsuranceCompanyPlan ICP ON ICP.VendorImportID=@vendorImportID and ICP.PlanName=SP.Ins2CompanyName AND SP.Ins2Street1=ICP.AddressLine1 AND SP.Ins2City=ICP.City AND Sp.Ins2Zip=ICP.ZipCode
WHERE ICP.InsuranceCompanyPlanID IS NOT NULL



COMMIT TRAN