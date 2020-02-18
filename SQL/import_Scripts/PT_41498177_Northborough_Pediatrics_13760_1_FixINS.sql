

INSERT INTO DBO.InsuranceCompany
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
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
VALUES  ( 'Tufts Health Plan' , -- InsuranceCompanyName - varchar(128)
          'Created via data import. Please verify.' , -- Notes - text
          'PO Box 9185' , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          'Watertown' , -- City - varchar(128)
          'MA' , -- State - varchar(2)
          '' , -- Country - varchar(32)
          '024719103' , -- ZipCode - varchar(9)
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
          1 , -- EClaimsAccepts - bit
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
          5832 , -- ClearinghousePayerID - int
          1 , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- KareoInsuranceCompanyID - int
		  GETDATE() , -- KareoLastModifiedDate - datetime
          13 , -- SecondaryPrecedenceBillingFormID - int
          NULL , -- VendorID - varchar(50)
          4 , -- VendorImportID - int
          25 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
)

INSERT INTO dbo.InsuranceCompanyPlan 
        ( PlanName ,
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
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID
        )
SELECT    ic.InsuranceCompanyName, -- PlanName - varchar(128)
          ic.AddressLine1 , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          ic.City , -- City - varchar(128)
          ic.State , -- State - varchar(2)
          ic.Country , -- Country - varchar(32)
          ic.Zipcode , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.InsuranceCompanyName , -- VendorID - varchar(50)
          4  -- VendorImportID - int
FROM dbo.InsuranceCompany ic
where ic.InsuranceCompanyName in ('Cigna', 'United Healthcare', 'Tufts Health Plan')
AND ic.InsuranceCompanyID NOT IN (24, 25, 27,  12)


--Blue Cross Blue Shield of MA
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = 2
	WHERE InsurancePolicyID IN (SELECT InsurancePolicyID 
									 FROM dbo.InsurancePolicy
									 WHERE InsuranceCompanyPlanID IN 
											(SELECT InsuranceCompanyPlanID 
												FROM dbo.InsuranceCompanyPlan
												WHERE PlanName IN ('BLUE CROSS & BLUE SHIELD', 'BLUE CROSS AND BLUE SHIELD',
		 														 'BLUE CROSS BLUE SHIELD', 'BLUE CROSS BLUE SHIELD MA')))
--Mass Medicaid
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = 1
	WHERE InsurancePolicyID IN (SELECT InsurancePolicyID 
									 FROM dbo.InsurancePolicy
									 WHERE InsuranceCompanyPlanID IN 
											(SELECT InsuranceCompanyPlanID 
												FROM dbo.InsuranceCompanyPlan
												WHERE PlanName IN ('MASSHEALTH', 'MEDICAID',
																	 'MEDICAID MASSACHUSETTS NO')))
--Cigna	
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = (SELECT InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE VendorID = 'Cigna' AND VendorImportID = 4)
	WHERE InsurancePolicyID IN (SELECT InsurancePolicyID 
									 FROM dbo.InsurancePolicy
									 WHERE InsuranceCompanyPlanID IN 
											(SELECT InsuranceCompanyPlanID 
												FROM dbo.InsuranceCompanyPlan
												WHERE PlanName IN ('CIGNA', 'CIGNA HEALTH CARE',
																	 'CIGNA HEALTHCARE')))
--Tufts Health Plan	
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = (SELECT InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE VendorID = 'Tufts Health Plan' AND VendorImportID = 4)
	WHERE InsurancePolicyID IN (SELECT InsurancePolicyID 
									 FROM dbo.InsurancePolicy
									 WHERE InsuranceCompanyPlanID IN 
											(SELECT InsuranceCompanyPlanID 
												FROM dbo.InsuranceCompanyPlan
												WHERE PlanName IN ('TUFTS (LIBERTY)', 'Tufts Health Plan',
																	 'TUFTS HEALTH PLAN', 'TUFTS HEALTH PLAN')))	
--Network Health	
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = 4
	WHERE InsurancePolicyID IN (SELECT InsurancePolicyID 
									 FROM dbo.InsurancePolicy
									 WHERE InsuranceCompanyPlanID IN 
											(SELECT InsuranceCompanyPlanID 
												FROM dbo.InsuranceCompanyPlan
												WHERE PlanName IN ('NETWORK HEALTH', 'UNITED HEALTH CARE',
																	 'UNITED HEALTHCARE')))
--United Healthcare
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = (SELECT InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE VendorID = 'United Healthcare' AND VendorImportID = 4)
	WHERE InsurancePolicyID IN (SELECT InsurancePolicyID 
									 FROM dbo.InsurancePolicy
									 WHERE InsuranceCompanyPlanID IN 
											(SELECT InsuranceCompanyPlanID 
												FROM dbo.InsuranceCompanyPlan
												WHERE PlanName IN ('UNITED HEALTH CARE', 'NETWORKHEALTH',
																	 'TUFTS HEALTH PLAN')))	


	
SELECT * FROM dbo.InsuranceCompany WITH (NOLOCK) WHERE InsuranceCompanyID IN (9,10,11,42,12,47,24,25,91,61,71,72,22,83,27,94,95)
SELECT * FROM dbo.InsuranceCompanyPlan WITH (NOLOCK) WHERE InsuranceCompanyPlanID IN 
(30,31,32,67,33,34,72,46,47,116,41,96,44,108,49,50,119,120)


DELETE FROM dbo.InsuranceCompanyPlan WHERE InsuranceCompanyID IN (9,10,11,42,12,47,24,25,91,61,71,72,22,83,27,94,95)

DELETE FROM dbo.PracticeToInsuranceCompany WHERE InsuranceCompanyID IN (9,10,11,12)

DELETE FROM dbo.InsuranceCompany WHERE InsuranceCompanyID IN (9,10,11,42,12,47,24,25,91,61,71,72,22,83,27,94,95)