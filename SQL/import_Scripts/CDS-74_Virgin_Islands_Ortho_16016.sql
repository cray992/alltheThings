--USE superbill_16016_dev
USE superbill_16016_prod
GO  

SET XACT_ABORT ON 

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1



PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

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
PRINT 'Inserting into Insurance Company ...'
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
        CreatedPracticeID ,
        CreatedDate ,
        CreatedUserID ,
        ModifiedDate ,
        ModifiedUserID ,
        SecondaryPrecedenceBillingFormID ,
        VendorID ,
        VendorImportID ,
        NDCFormat ,
        UseFacilityID ,
        AnesthesiaType ,
        InstitutionalBillingFormID
      )
SELECT    name , -- InsuranceCompanyName - varchar(128)
        '' , -- Notes - text
        AddressLine1 , -- AddressLine1 - varchar(256)
        AddressLine2 , -- AddressLine2 - varchar(256)
        City , -- City - varchar(128)
        State , -- State - varchar(2)
        Country  , -- Country - varchar(32)
        ZipCode , -- ZipCode - varchar(9)
        ContactPrefix , -- ContactPrefix - varchar(16)
        ContactFirstName , -- ContactFirstName - varchar(64)
        ContactMiddleName , -- ContactMiddleName - varchar(64)
        ContactLastName , -- ContactLastName - varchar(64)
        ContactSuffix , -- ContactSuffix - varchar(16)
        '' , -- Phone - varchar(10)
        '' , -- PhoneExt - varchar(10)
        '' , -- Fax - varchar(10)
        '' , -- FaxExt - varchar(10)
        AutoBillsSecondaryInsurance , -- BillSecondaryInsurance - bit
        0 , -- EClaimsAccepts - bit
        13 , -- BillingFormID - int
        'CI' , -- InsuranceProgramCode - char(2)
        'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
        'D' , -- HCFASameAsInsuredFormatCode - char(1)
        @PracticeID , -- CreatedPracticeID - int
        GETDATE() , -- CreatedDate - datetime
        0 , -- CreatedUserID - int
        GETDATE() , -- ModifiedDate - datetime
        0 , -- ModifiedUserID - int
        13 , -- SecondaryPrecedenceBillingFormID - int
        InsuranceCompanyID , -- VendorID - varchar(50)
        @VendorImportID , -- VendorImportID - int
        1 , -- NDCFormat - int
        1 , -- UseFacilityID - bit
        'U' , -- AnesthesiaType - varchar(1)
        18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceCompany] 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Insurance Company Plan ...'
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
      InsuranceCompanyID ,
      VendorID ,
      VendorImportID 
    )
SELECT    
	  icp.PlanName , -- PlanName - varchar(128)
      icp.AddressLine1 , -- AddressLine1 - varchar(256)
      icp.AddressLine2 , -- AddressLine2 - varchar(256)
      icp.City , -- City - varchar(128)
      icp.State , -- State - varchar(2)
      icp.Country , -- Country - varchar(32)
      icp.ZipCode , -- ZipCode - varchar(9)
      icp.ContactPrefix , -- ContactPrefix - varchar(16)
      icp.ContactFirstName , -- ContactFirstName - varchar(64)
      icp.ContactMiddleName , -- ContactMiddleName - varchar(64)
      icp.ContactLastName , -- ContactLastName - varchar(64)
      icp.ContactSuffix , -- ContactSuffix - varchar(16)
      '' , -- Phone - varchar(10)
      '' , -- PhoneExt - varchar(10)
      '' , -- Notes - text
      '' , -- MM_CompanyID - varchar(10)
      GETDATE() , -- CreatedDate - datetime
      0 , -- CreatedUserID - int
      GETDATE() , -- ModifiedDate - datetime
      0 , -- ModifiedUserID - int
      CASE WHEN icp.insuranceplanpracticespecific = 'True' THEN 'R' ELSE '' END , 
      @PracticeID , -- CreatedPracticeID - int
      ic.InsuranceCompanyID , -- InsuranceCompanyID - int
      icp.insurancecompanyplanid , -- VendorID - varchar(50)
      @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_InsuranceCompanyPlan] icp 
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.VendorID = icp.insurancecompanyid AND 
	ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) +  ' records inserted'


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
      MedicalRecordNumber ,
      MobilePhone ,
      MobilePhoneExt ,
      VendorID ,
      VendorImportID ,
      Active ,
      SendEmailCorrespondence ,
      PhonecallRemindersEnabled ,
      EmergencyName ,
      EmergencyPhone ,
      EmergencyPhoneExt 
    )
SELECT    
	  @PracticeiD , -- PracticeID - int
      Prefix , -- Prefix - varchar(16)
      FirstName , -- FirstName - varchar(64)
      MiddleName , -- MiddleName - varchar(64)
      LastName , -- LastName - varchar(64)
      Suffix , -- Suffix - varchar(16)
      AddressLine1 , -- AddressLine1 - varchar(256)
      AddressLine2 , -- AddressLine2 - varchar(256)
      City , -- City - varchar(128)
      State , -- State - varchar(2)
      Country , -- Country - varchar(32)
      ZipCode , -- ZipCode - varchar(9)
      Gender , -- Gender - varchar(1)
      CASE MaritalStatus WHEN 'Never Married' THEN 'S'
						 WHEN 'Married' THEN 'M'
						 WHEN 'Widowed' THEN 'W'
						 WHEN 'Divorced' THEN 'D'
						 ELSE '' END  , -- MaritalStatus - varchar(1)
      HomePhone , -- HomePhone - varchar(10)
      HomePhoneExt , -- HomePhoneExt - varchar(10)
      WorkPhone , -- WorkPhone - varchar(10)
      WorkPhoneExt , -- WorkPhoneExt - varchar(10)
      dateofbirth , -- DOB - datetime
      SSN , -- SSN - char(9)
      EmailAddress , -- EmailAddress - varchar(256)
      CASE WHEN guarantorrelationshiptopatient = 'Other' AND guarantorfirstname <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
      guarantorprefix , -- ResponsiblePrefix - varchar(16)
      guarantorfirstname , -- ResponsibleFirstName - varchar(64)
      guarantormiddlename , -- ResponsibleMiddleName - varchar(64)
      guarantorlastname , -- ResponsibleLastName - varchar(64)
      guarantorsuffix , -- ResponsibleSuffix - varchar(16)
      CASE guarantorrelationshiptopatient WHEN 'Other' THEN 'O'
										  WHEN 'Self' THEN 'S'
										  WHEN 'Child' THEN 'C'
										  WHEN 'Spouse' THEN 'U'
										  ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1)
      guarantoraddressline1 , -- ResponsibleAddressLine1 - varchar(256)
      guarantoraddressline2 , -- ResponsibleAddressLine2 - varchar(256)
      guarantorcity , -- ResponsibleCity - varchar(128)
      guarantorstate , -- ResponsibleState - varchar(2)
      guarantorcountry , -- ResponsibleCountry - varchar(32)
      guarantorzip , -- ResponsibleZipCode - varchar(9)
      GETDATE() , -- CreatedDate - datetime
      0 , -- CreatedUserID - int
      GETDATE() , -- ModifiedDate - datetime
      0 , -- ModifiedUserID - int
      MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
      MobilePhone , -- MobilePhone - varchar(10)
      MobilePhoneExt , -- MobilePhoneExt - varchar(10)
      id , -- VendorID - varchar(50)
      @VendorImportID , -- VendorImportID - int
      1 , -- Active - bit
      sendemailnotifications , -- SendEmailCorrespondence - bit
      1 , -- PhonecallRemindersEnabled - bit
      EmergencyName , -- EmergencyName - varchar(128)
      LEFT(EmergencyPhone, 10) , -- EmergencyPhone - varchar(10)
      EmergencyPhoneExt  -- EmergencyPhoneExt - varchar(10)
FROM dbo.[_import_1_1_PatientDemographics]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into PatientCase'
INSERT INTO dbo.PatientCase
    ( PatientID ,
      Name ,
      Active ,
      PayerScenarioID ,
      EmploymentRelatedFlag ,
      AutoAccidentRelatedFlag ,
      OtherAccidentRelatedFlag ,
      AbuseRelatedFlag ,
      AutoAccidentRelatedState ,
      Notes ,
      CreatedDate ,
      CreatedUserID ,
      ModifiedDate ,
      ModifiedUserID ,
      PracticeID ,
      VendorID ,
      VendorImportID ,
      PregnancyRelatedFlag ,
      StatementActive ,
      EPSDT ,
      FamilyPlanning ,
      EmergencyRelated 
    )
SELECT    pat.patientID , -- PatientID - int
      pc.defaultcasename , -- Name - varchar(128)
      1 , -- Active - bit
      CASE pc.defaultcasepayerscenario WHEN 'Commercial' THEN 5
									WHEN 'BC/BS' THEN 3
									WHEN 'Medicaid' THEN 8
									WHEN 'Medicaid HMO' THEN 9
									WHEN 'Medicare' THEN 7
									WHEN 'PPO' THEN 10
									WHEN 'Self Pay' THEN 11
									WHEN 'VA' THEN 14
									WHEN 'Workers Comp' THEN 1 
									ELSE 5 end , -- PayerScenarioID - int
      pc.DefaultCaseConditionRelatedToEmployment , -- EmploymentRelatedFlag - bit
      pc.defaultcaseconditionrelatedtoautoaccident , -- AutoAccidentRelatedFlag - bit
      pc.defaultcaseconditionrelatedtoother , -- OtherAccidentRelatedFlag - bit
      pc.defaultcaseconditionrelatedtoabuse , -- AbuseRelatedFlag - bit
      pc.defaultcaseconditionrelatedtoautoaccidentstate , -- AutoAccidentRelatedState - char(2)
      pc.defaultcasedescription , -- Notes - text
      GETDATE() , -- CreatedDate - datetime
      0 , -- CreatedUserID - int
      GETDATE() , -- ModifiedDate - datetime
      0 , -- ModifiedUserID - int
      @PracticeID , -- PracticeID - int
      pc.defaultcaseid , -- VendorID - varchar(50)
      @VendorImportID , -- VendorImportID - int
      pc.defaultcaseconditionrelatedtopregnancy , -- PregnancyRelatedFlag - bit
      pc.DefaultCaseSendPatientStatements , -- StatementActive - bit
      pc.DefaultCaseConditionRelatedToEPSDT , -- EPSDT - bit
      pc.defaultcaseconditionrelatedtofamilyplanning , -- FamilyPlanning - bit
      pc.DefaultCaseConditionRelatedToEmergency  -- EmergencyRelated - bit
FROM dbo.[_import_1_1_CaseInformation] pc 
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = pc.patientid AND 
	pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into InsurancePolicy'
INSERT INTO dbo.InsurancePolicy
    ( PatientCaseID ,
      InsuranceCompanyPlanID ,
      Precedence ,
      PolicyNumber ,
      GroupNumber ,
      PolicyStartDate ,
      PolicyEndDate ,
      PatientRelationshipToInsured ,
      HolderFirstName ,
      HolderSSN ,
      CreatedDate ,
      CreatedUserID ,
      ModifiedDate ,
      ModifiedUserID ,
      HolderAddressLine1 ,
      HolderAddressLine2 ,
      HolderCity ,
      HolderState ,
      HolderCountry ,
      HolderZipCode ,
      DependentPolicyNumber ,
      Notes ,
      Copay ,
      Deductible ,
      Active ,
      PracticeID ,
      VendorID ,
      VendorImportID 
    )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
      icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
      1 , -- Precedence - int
      ip.PrimaryInsurancePolicyNumber , -- PolicyNumber - varchar(32)
      ip.PrimaryInsurancePolicyGroupNumber , -- GroupNumber - varchar(32)
      ip.PrimaryInsurancePolicyEffectiveStartDate , -- PolicyStartDate - datetime
      ip.PrimaryInsurancePolicyEffectiveEndDate , -- PolicyEndDate - datetime
      ip.PrimaryInsurancePolicyPatientRelationshipToInsured , -- PatientRelationshipToInsured - varchar(1)
      ip.PrimaryInsurancePolicyInsuredFullName , -- HolderFirstName - varchar(64)
      ip.PrimaryInsurancePolicyInsuredSocialSecurityNumber , -- HolderSSN - char(11)
      GETDATE() , -- CreatedDate - datetime
      0 , -- CreatedUserID - int
      GETDATE() , -- ModifiedDate - datetime
      0 , -- ModifiedUserID - int
      ip.PrimaryInsurancePolicyInsuredAddressLine1 , -- HolderAddressLine1 - varchar(256)
      ip.PrimaryInsurancePolicyInsuredAddressLine2 , -- HolderAddressLine2 - varchar(256)
      ip.PrimaryInsurancePolicyInsuredCity , -- HolderCity - varchar(128)
      ip.PrimaryInsurancePolicyInsuredState , -- HolderState - varchar(2)
      '' , -- HolderCountry - varchar(32)
      ip.PrimaryInsurancePolicyInsuredZipCode , -- HolderZipCode - varchar(9)
      ip.PrimaryInsurancePolicyInsuredIDNumber , -- DependentPolicyNumber - varchar(32)
      ip.PrimaryInsurancePolicyInsuredNotes , -- Notes - text
      ip.PrimaryInsurancePolicyCopay , -- Copay - money
      ip.PrimaryInsurancePolicyDeductible , -- Deductible - money
      1 , -- Active - bit
      @PracticeID , -- PracticeID - int
      ip.PrimaryInsurancePolicyNumber , -- VendorID - varchar(50)
      @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_CaseInformation] ip
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorID = ip.defaultcaseid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorID = ip.PrimaryInsurancePolicyCompanyPlanID AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




PRINT ''
PRINT 'Inserting into InsurancePolicy'
INSERT INTO dbo.InsurancePolicy
    ( PatientCaseID ,
      InsuranceCompanyPlanID ,
      Precedence ,
      PolicyNumber ,
      GroupNumber ,
      PolicyStartDate ,
      PolicyEndDate ,
      PatientRelationshipToInsured ,
      HolderFirstName ,
      HolderSSN ,
      CreatedDate ,
      CreatedUserID ,
      ModifiedDate ,
      ModifiedUserID ,
      HolderAddressLine1 ,
      HolderAddressLine2 ,
      HolderCity ,
      HolderState ,
      HolderCountry ,
      HolderZipCode ,
      DependentPolicyNumber ,
      Notes ,
      Copay ,
      Deductible ,
      Active ,
      PracticeID ,
      VendorID ,
      VendorImportID 
    )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
      icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
      2 , -- Precedence - int
      ip.SecondaryInsurancePolicyNumber , -- PolicyNumber - varchar(32)
      ip.SecondaryInsurancePolicyGroupNumber , -- GroupNumber - varchar(32)
      ip.SecondaryInsurancePolicyEffectiveStartDate , -- PolicyStartDate - datetime
      ip.SecondaryInsurancePolicyEffectiveEndDate , -- PolicyEndDate - datetime
      ip.SecondaryInsurancePolicyPatientRelationshipToInsured , -- PatientRelationshipToInsured - varchar(1)
      ip.SecondaryInsurancePolicyInsuredFullName , -- HolderFirstName - varchar(64)
      ip.SecondaryInsurancePolicyInsuredSocialSecurityNumber , -- HolderSSN - char(11)
      GETDATE() , -- CreatedDate - datetime
      0 , -- CreatedUserID - int
      GETDATE() , -- ModifiedDate - datetime
      0 , -- ModifiedUserID - int
      ip.SecondaryInsurancePolicyInsuredAddressLine1 , -- HolderAddressLine1 - varchar(256)
      ip.SecondaryInsurancePolicyInsuredAddressLine2 , -- HolderAddressLine2 - varchar(256)
      ip.SecondaryInsurancePolicyInsuredCity , -- HolderCity - varchar(128)
      ip.SecondaryInsurancePolicyInsuredState , -- HolderState - varchar(2)
      '' , -- HolderCountry - varchar(32)
      ip.SecondaryInsurancePolicyInsuredZipCode , -- HolderZipCode - varchar(9)
      ip.SecondaryInsurancePolicyInsuredIDNumber , -- DependentPolicyNumber - varchar(32)
      ip.SecondaryInsurancePolicyInsuredNotes , -- Notes - text
      ip.SecondaryInsurancePolicyCopay , -- Copay - money
      ip.SecondaryInsurancePolicyDeductible , -- Deductible - money
      1 , -- Active - bit
      @PracticeID , -- PracticeID - int
      ip.SecondaryInsurancePolicyNumber , -- VendorID - varchar(50)
      @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_CaseInformation] ip
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorID = ip.defaultcaseid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorID = ip.SecondaryInsurancePolicyCompanyPlanID AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into InsurancePolicy'
INSERT INTO dbo.InsurancePolicy
    ( PatientCaseID ,
      InsuranceCompanyPlanID ,
      Precedence ,
      PolicyNumber ,
      GroupNumber ,
      PolicyStartDate ,
      PolicyEndDate ,
      PatientRelationshipToInsured ,
      HolderFirstName ,
      HolderSSN ,
      CreatedDate ,
      CreatedUserID ,
      ModifiedDate ,
      ModifiedUserID ,
      HolderAddressLine1 ,
      HolderAddressLine2 ,
      HolderCity ,
      HolderState ,
      HolderCountry ,
      HolderZipCode ,
      DependentPolicyNumber ,
      Notes ,
      Copay ,
      Deductible ,
      Active ,
      PracticeID ,
      VendorID ,
      VendorImportID 
    )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
      icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
      3 , -- Precedence - int
      ip.TertiaryInsurancePolicyNumber , -- PolicyNumber - varchar(32)
      ip.TertiaryInsurancePolicyGroupNumber , -- GroupNumber - varchar(32)
      ip.TertiaryInsurancePolicyEffectiveStartDate , -- PolicyStartDate - datetime
      ip.TertiaryInsurancePolicyEffectiveEndDate , -- PolicyEndDate - datetime
      ip.TertiaryInsurancePolicyPatientRelationshipToInsured , -- PatientRelationshipToInsured - varchar(1)
      ip.TertiaryInsurancePolicyInsuredFullName , -- HolderFirstName - varchar(64)
      ip.TertiaryInsurancePolicyInsuredSocialSecurityNumber , -- HolderSSN - char(11)
      GETDATE() , -- CreatedDate - datetime
      0 , -- CreatedUserID - int
      GETDATE() , -- ModifiedDate - datetime
      0 , -- ModifiedUserID - int
      ip.TertiaryInsurancePolicyInsuredAddressLine1 , -- HolderAddressLine1 - varchar(256)
      ip.TertiaryInsurancePolicyInsuredAddressLine2 , -- HolderAddressLine2 - varchar(256)
      ip.TertiaryInsurancePolicyInsuredCity , -- HolderCity - varchar(128)
      ip.TertiaryInsurancePolicyInsuredState , -- HolderState - varchar(2)
      '' , -- HolderCountry - varchar(32)
      ip.TertiaryInsurancePolicyInsuredZipCode , -- HolderZipCode - varchar(9)
      ip.TertiaryInsurancePolicyInsuredIDNumber , -- DependentPolicyNumber - varchar(32)
      ip.TertiaryInsurancePolicyInsuredNotes , -- Notes - text
      ip.TertiaryInsurancePolicyCopay , -- Copay - money
      ip.TertiaryInsurancePolicyDeductible , -- Deductible - money
      1 , -- Active - bit
      @PracticeID , -- PracticeID - int
      ip.TertiaryInsurancePolicyNumber , -- VendorID - varchar(50)
      @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_CaseInformation] ip
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorID = ip.defaultcaseid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorID = ip.TertiaryInsurancePolicyCompanyPlanID AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

COMMIT 