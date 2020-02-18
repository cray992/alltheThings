--CCHCA 48 

USE superbill_39795_prod
GO
SELECT * FROM dbo.InsuranceCompany WHERE CreatedPracticeID=48
SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 48
SET @VendorImportID = 100

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


/*
==========================================================================================================================================
CREATE INSURANCE PLANS FROM [Existing IC]
==========================================================================================================================================
*/	

-- Create insurance plans where an insurance company record already exists that is in the practice or global scope
PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactFirstName , ContactLastName , 
	Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	CASE WHEN ICP.planname <> '' THEN LEFT(ICP.planname,128)
		 ELSE ICP.InsuranceCompanyName END  , -- PlanName - varchar(128)
	LEFT(ICP.Address1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.Address2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.City,128) , -- City - varchar(128)
	LEFT(ICP.[State],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(ICP.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(ICP.ContactLastName,64) , -- ContactLastName - varchar(64)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Phone),10) , -- Phone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.PhoneExt),10) , -- PhoneExt - varchar(10)
	ICP.Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Fax), 10) , -- Fax - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.FaxExt), 10) , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	insuranceid,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM _import_107_48_InsuranceCOMPANYPLANList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE ICP.InsuranceCompanyName = InsuranceCompanyName AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

-- Grab a list of insurance company ids from practiceid 1 where the name matches the import dataset
CREATE TABLE #tempInsCo (InsCoID INT)
INSERT INTO #tempInsCo  (InsCoID)
SELECT DISTINCT ic.InsuranceCompanyID
FROM dbo._import_107_48_InsuranceCOMPANYPLANList i
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.InsuranceCompanyID = (SELECT MIN(ic2.InsuranceCompanyID) FROM dbo.InsuranceCompany ic2
							 WHERE ic2.InsuranceCompanyName = i.insurancecompanyname AND ic2.CreatedPracticeID = 1)


-- Copy and migrate those insurance companies to target practice
PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( 
		  InsuranceCompanyName ,
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
          CompanyTextID ,
          ClearinghousePayerID ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          --DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  
	      i.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
          'Insurance Company Record Created From Justin P Quock, MD' , -- Notes - text
          i.addressline1 , -- AddressLine1 - varchar(256)
          i.addressline2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.state , -- State - varchar(2)
          i.country , -- Country - varchar(32)
          i.zipcode , -- ZipCode - varchar(9)
          i.contactprefix , -- ContactPrefix - varchar(16)
          i.contactfirstname , -- ContactFirstName - varchar(64)
          i.contactmiddlename , -- ContactMiddleName - varchar(64)
          i.contactlastname , -- ContactLastName - varchar(64)
          i.contactsuffix , -- ContactSuffix - varchar(16)
          i.phone , -- Phone - varchar(10)
          i.phoneext , -- PhoneExt - varchar(10)
          i.fax , -- Fax - varchar(10)
          i.faxext , -- FaxExt - varchar(10)
          i.billsecondaryinsurance , -- BillSecondaryInsurance - bit
          i.eclaimsaccepts , -- EClaimsAccepts - bit
          i.billingformid , -- BillingFormID - int
          i.insuranceprogramcode , -- InsuranceProgramCode - char(2)
          i.hcfadiagnosisreferenceformatcode , -- HCFADiagnosisReferenceFormatCode - char(1)
          i.hcfasameasinsuredformatcode  , -- HCFASameAsInsuredFormatCode - char(1)
          i.localusefieldtypecode , -- LocalUseFieldTypeCode - char(5)
          '' , -- ReviewCode - char(1)
          i.companytextid , -- CompanyTextID - varchar(10)
          i.clearinghousepayerid , -- ClearinghousePayerID - int
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.secondaryprecedencebillingformid , -- SecondaryPrecedenceBillingFormID - int
          i.insurancecompanyid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          --a.AdjustmentCode , -- DefaultAdjustmentCode - varchar(10)
          i.referringprovidernumbertypeid , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int	
          1 , -- UseFacilityID - bit
          i.anesthesiatype , -- AnesthesiaType - varchar(1)
          i.institutionalbillingformid  -- InstitutionalBillingFormID - int
FROM dbo.[InsuranceCompany] i
	INNER JOIN #tempInsCo temp ON i.InsuranceCompanyID = temp.InsCoID
WHERE 
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE ic.InsuranceCompanyName = i.InsuranceCompanyName AND
														 (ic.ReviewCode = 'R' OR ic.CreatedPracticeID = @PracticeID))
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

-- import practicetoinsurancecompanysettings
PRINT ''
PRINT 'Inserting Into PracticetoInsurance Company...'
INSERT INTO dbo.PracticeToInsuranceCompany
        (
		  PracticeID ,
          InsuranceCompanyID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EClaimsProviderID ,
          EClaimsEnrollmentStatusID ,
          EClaimsDisable ,
          AcceptAssignment ,
          UseSecondaryElectronicBilling ,
          UseCoordinationOfBenefits ,
          ExcludePatientPayment ,
          BalanceTransfer
        )
SELECT DISTINCT   
          @PracticeID , -- PracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL, -- EClaimsProviderID - varchar(32)
          ptic.EClaimsEnrollmentStatusID , -- EClaimsEnrollmentStatusID - int
          ptic.EClaimsDisable , -- EClaimsDisable - int
          ptic.acceptassignment  , -- AcceptAssignment - bit
          ptic.usesecondaryelectronicbilling , -- UseSecondaryElectronicBilling - bit
          ptic.usecoordinationofbenefits  , -- UseCoordinationOfBenefits - bit
          ptic.excludepatientpayment  , -- ExcludePatientPayment - bit
          ptic.balancetransfer  -- BalanceTransfer - bit
FROM dbo.[PracticeToInsuranceCompany] ptic
	INNER JOIN dbo.InsuranceCompany ic ON
		CAST(ptic.insurancecompanyid AS VARCHAR) = ic.VendorID AND
		ic.VendorImportID = @VendorImportID AND 
		ic.CreatedPracticeID = @PracticeID
WHERE ptic.practiceid = 1
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

-- Create the plans from the import file matching on name
PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactFirstName , ContactLastName , 
	Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	CASE WHEN ICP.planname <> '' THEN LEFT(ICP.planname,128)
		 ELSE ICP.InsuranceCompanyName END  , -- PlanName - varchar(128)
	LEFT(ICP.Address1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.Address2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.City,128) , -- City - varchar(128)
	LEFT(ICP.[State],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(ICP.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(ICP.ContactLastName,64) , -- ContactLastName - varchar(64)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Phone),10) , -- Phone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.PhoneExt),10) , -- PhoneExt - varchar(10)
	ICP.Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Fax), 10) , -- Fax - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.FaxExt), 10) , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	insuranceid,  -- VendorID - varchar(50) --FIX
	@VendorImportID -- VendorImportID - int
FROM dbo._import_107_48_InsuranceCOMPANYPLANList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyName = ICP.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.Insuranceid = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


/*
==========================================================================================================================================
CREATE INSURANCE COMPANIES FROM [_import_107_48_InsuranceCOMPANYPLANList]
==========================================================================================================================================
*/	

-- Create the remaining insurance company records that did not name match on existing records
PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , ReviewCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN IICL.insurancecompanyname
		ELSE IICL.planname END,128)  , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	19 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	CASE scope WHEN 1 THEN 'R' ELSE '' END , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	13 , -- SecondaryPrecedenceBillingFormID - int
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN IICL.insurancecompanyname
		ELSE IICL.planname END,50) , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo._import_107_48_InsuranceCOMPANYPLANList AS IICL
WHERE ( insurancecompanyname <> '' OR planname <> '') AND
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.InsuranceCompanyName AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'															 

/*
==========================================================================================================================================
CREATE INSURANCE PLANS FROM [InsuranceCOMPANYPLANList]
==========================================================================================================================================
*/	

-- Create those plans linked to the company records above
PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactFirstName , ContactLastName , 
	Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	CASE WHEN ICP.planname <> '' THEN LEFT(ICP.planname,128)
		 ELSE ICP.InsuranceCompanyName END  , -- PlanName - varchar(128)
	LEFT(ICP.Address1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.Address2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.City,128) , -- City - varchar(128)
	LEFT(ICP.[State],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(ICP.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(ICP.ContactLastName,64) , -- ContactLastName - varchar(64)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Phone),10) , -- Phone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.PhoneExt),10) , -- PhoneExt - varchar(10)
	ICP.Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Fax), 10) , -- Fax - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.FaxExt), 10) , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	insuranceid,  -- VendorID - varchar(50) --FIX
	@VendorImportID -- VendorImportID - int
FROM dbo._import_107_48_InsuranceCOMPANYPLANList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.InsuranceCompanyName, 50) AND
	ICP.Insurancecompanyname = IC.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.Insuranceid = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	
/*
==========================================================================================================================================
CREATE REFERRING PHYSICIANS FROM [REFERRINGPHYSICIANS]
==========================================================================================================================================
*/	



PRINT ''
PRINT 'Inserting Into Doctor...'
INSERT INTO dbo.Doctor
( 
	PracticeID , Prefix, Suffix, FirstName , MiddleName , LastName , SSN , AddressLine1 , AddressLine2 , City , State , zipcode , HomePhone , HomePhoneExt , 
	WorkPhone , WorkPhoneExt , MobilePhone , MobilePhoneExt , DOB , EmailAddress , Notes , ActiveDoctor , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , UserID , Degree , TaxonomyCode , VendorID , VendorImportID , FaxNumber , FaxNumberExt , [External] , NPI 
)
SELECT DISTINCT 
	@PracticeID , -- PracticeID - int
	LEFT(RP.[prefix],16), -- Prefix
	LEFT(RP.suffix,16), -- Suffix
	LEFT(RP.firstname,64) , -- FirstName - varchar(64)
	LEFT(RP.middleinitial,64) , -- MiddleName - varchar(64)
	LEFT(RP.lastname,64) , -- LastName - varchar(64)
	CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.ssn)) >= 6 
					THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(RP.ssn) , 9)
	     WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.ssn)) >= 7 
					THEN RIGHT ('00' + dbo.fn_RemoveNonNumericCharacters(RP.ssn) , 9)
	     WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.ssn)) >= 8 
					THEN RIGHT ('0' + dbo.fn_RemoveNonNumericCharacters(RP.ssn) , 9)
	     ELSE dbo.fn_RemoveNonNumericCharacters(RP.ssn) END  , -- SSN - varchar(9)
	LEFT(RP.address1,256) , -- AddressLine1 - varchar(256)
	LEFT(RP.address2,256) , -- AddressLine2 - varchar(256)
	LEFT(RP.city,128) , -- City - varchar(128)
	UPPER(LEFT(RP.[state],2)) , -- State - varchar(2)
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(RP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(RP.zip)
		ELSE '' END , -- ZipCode - varchar(9)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.homephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(RP.homephone),10)
		ELSE '' END , -- HomePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.homephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(RP.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(RP.homephone))),10)
		ELSE NULL END , -- HomePhoneExt - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(RP.workphone),10)
		ELSE '' END , -- WorkPhone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(RP.workphoneextension),10) , -- WorkPhoneExt - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.cellphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(RP.cellphone),10)
		ELSE '' END , -- MobilePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.cellphone)) >= 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(RP.cellphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(RP.cellphone))),10)
		ELSE NULL END  , -- MobilePhoneExt - varchar(10)
	CASE
		WHEN ISDATE(RP.dateofbirth) = 1 THEN RP.dateofbirth
		ELSE NULL END , -- DOB - datetime
	LEFT(RP.email,256) , -- EmailAddress - varchar(256)
	rp.Notes + CHAR(13) + CHAR(10) + CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.  ' + RP.notes , -- Notes - text
	1 , -- ActiveDoctor - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	0 , -- UserID - int
	UPPER(LEFT(RP.degree,8)) , -- Degree - varchar(8)
	TC.TaxonomyCode , -- TaxonomyCode - char(10)
	RP.AutoTempID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(RP.fax),10) , -- FaxNumber - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(RP.faxext),10) , -- FaxNumberExt - varchar(10)
	1, -- External - bit
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.npi)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(RP.npi)
		ELSE NULL END -- NPI - varchar(10)
FROM dbo._import_105_48_ReferringDoctors AS RP 
	LEFT JOIN dbo.TaxonomyCode AS TC ON TC.TaxonomyCode = RP.taxonomycode
	LEFT JOIN dbo.Doctor AS OD ON OD.FirstName = RP.FirstName AND OD.LastName = RP.LastName AND OD.[External] = 1 AND OD.PracticeID = @PracticeID
WHERE RP.firstname <> '' AND RP.lastname <> '' 
	AND OD.DoctorId IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	




--ROLLBACK
--COMMIT
