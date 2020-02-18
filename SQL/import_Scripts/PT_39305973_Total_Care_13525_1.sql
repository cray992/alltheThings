USE superbill_13525_dev
--USE superbill_13525_prod
GO
	

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool

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
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'

DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'

DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'

DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'

DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'



PRINT ''
PRINT 'Inserting into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          PhoneExt ,
          Fax ,
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
          DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  ic.name , -- InsuranceCompanyName - varchar(128)
          ic.address1 , -- AddressLine1 - varchar(256)
          ic.address2 , -- AddressLine2 - varchar(256)
          ic.city , -- City - varchar(128)
          ic.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(ic.zipcode,'-',''),9),-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(ic.phone,'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(ic.extension,'(',''),')',''),'-',''),10),-- Phone Extension - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(ic.fax,'(',''),')',''),'-',''),10),-- Fax - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13, -- SecondaryPrecedenceBillingFormID - int
          ic.code , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_1_1_InsuranceList] ic
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records inserted'






PRINT ''
PRINT 'Inserting into Insurance Company Plan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          PhoneExt,
          Fax,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
		  icp.name , -- PlanName - varchar(128)
          icp.address1 , -- AddressLine1 - varchar(256)
          icp.address2 , -- AddressLine2 - varchar(256)
          icp.city , -- City - varchar(128)
          icp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(icp.zipcode,'-',''),9),-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(icp.phone,'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(icp.extension,'(',''),')',''),'-',''),10),-- Phone Extension - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(icp.fax,'(',''),')',''),'-',''),10),-- Fax - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID, --@PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.code , -- VendorID - varchar(50)
          @VendorImportID --@VendorImportID  -- VendorImportID - int
FROM [dbo].[_import_1_1_InsuranceList] icp
LEFT JOIN dbo.InsuranceCompany ic
ON icp.code = ic.VendorID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records inserted'



PRINT ''
PRINT 'Inserting into Patient'
INSERT INTO dbo.Patient
        ( PracticeID ,
		  Prefix,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PrimaryProviderID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
		  '',
          pd.firstname , -- FirstName - varchar(64)
          pd.middleinitial , -- MiddleName - varchar(64)
          pd.lastname , -- LastName - varchar(64)
          '',
          pd.address1 , -- AddressLine1 - varchar(256)
          pd.address2 , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          pd.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(pd.zipcode,'-',''),9),-- ZipCode - varchar(9)
          pd.sex , -- Gender - varchar(1)
          REPLACE(pd.maritalstatus,'X','U') , -- MaritalStatus - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(pd.homephone,'(',''),')',''),'-',''),10), -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(pd.workphone,'(',''),')',''),'-',''),10),-- WorkPhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(pd.workextension,'(',''),')',''),'-',''),10),-- WorkPhoneExt - varchar(10)
          CASE ISDATE(pd.dateofbirth) WHEN 1  -- DOB - datetime
			THEN CASE WHEN pd.dateofbirth > GETDATE() THEN DATEADD(yy, -100, pd.dateofbirth) 
			ELSE pd.dateofbirth END 
			ELSE NULL END,
          LEFT(REPLACE(pd.socialsecuritynumber,'-',''),9) , -- SSN - char(9)
          pd.homeemail , -- EmailAddress - varchar(256)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN provider = 'SCH'
			THEN (SELECT DoctorID FROM dbo.Doctor WHERE LEFT(LastName,3) = pd.provider) END, -- PrimaryProviderID - int
          '' , -- MedicalRecordNumber - varchar(128)
          pd.chartnumber + LEFT(pd.lastname, 3) , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          1  -- PhonecallRemindersEnabled - bit
FROM [dbo].[_import_1_1_PatientDemographics] pd
WHERE pd.lastname <> '' AND pd.firstname <> '' 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records inserted'








PRINT ''
PRINT 'Inserting into Patient Cases'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
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
SELECT DISTINCT    
		   p.PatientID, -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          5 , -- PayerScenarioID - int
          'Created via Import. Please Review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pc.chartnumber + LEFT(p.lastName, 3), -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemographics] pc
JOIN dbo.Patient p ON (pc.chartnumber + LEFT(pc.lastname, 3)) = p.VendorID

PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Cases records inserted'




PRINT ''
PRINT 'Inserting into Insurance Policy  1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderDOB ,
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          Notes ,
          Copay ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation
        )
SELECT DISTINCT
		  p.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pd.insuranceinsuredid1 , -- PolicyNumber - varchar(32)
          pd.insurancegroupnumber1 , -- GroupNumber - varchar(32)
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured1 = g.code) -- PatientRelationshipToInsured - varchar(1)
			THEN 'O'
			ELSE 'S'
		  END,
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured1 = g.code)
			THEN  gi.firstname
		  END , -- HolderFirstName - varchar(64)
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured1 = g.code)
			THEN  gi.middleinitial
		  END , -- HolderMiddleName - varchar(64)
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured1 = g.code)
			THEN  gi.lastname
		  END , -- HolderLastName - varchar(64)
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g  -- HolderDOB - datetime
			WHERE pd.insuranceinsured1 = g.code)
			THEN
				CASE ISDATE(gi.dateofbirth) WHEN 1  -- DOB - datetime
					THEN
						CASE WHEN gi.dateofbirth > GETDATE() 
							THEN DATEADD(yy, -100, gi.dateofbirth) 
							ELSE gi.dateofbirth
						END
				END 
		  END,
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured1 = g.code)
			THEN  LEFT(REPLACE(gi.socialsecuritynumber,'-',''),9)
		  END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured1 = g.code)
			THEN  gi.sex
		  END , -- HolderGender - char(1)
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured1 = g.code)
			THEN  gi.address1
		  END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured1 = g.code)
			THEN  gi.address2
		  END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured1 = g.code)
			THEN  gi.city
		  END , -- HolderCity - varchar(128)
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured1 = g.code)
			THEN  gi.[state]
		  END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured1 = g.code)
			THEN  gi.zipcode
			END , -- HolderZipCode - varchar(9)
          CASE WHEN pd.insuranceinsured1 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured1 = g.code)
			THEN CASE WHEN gi.homephone <> ''
				THEN LEFT(REPLACE(REPLACE(REPLACE(gi.homephone,'(',''),')',''),'-',''),10)
				ELSE LEFT(REPLACE(REPLACE(REPLACE(gi.workphone,'(',''),')',''),'-',''),10)
				END
		  END , -- HolderPhone - varchar(10)
          '' , -- Notes - text
          pd.copay , -- Copay - money
          @PracticeID , -- PracticeID - int
          pd.chartnumber + '1' , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_PatientDemographics] pd
JOIN dbo.PatientCase p ON
	(pd.chartnumber + LEFT(pd.lastname, 3))= p.VendorID AND 
	p.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	pd.insurancecode1 = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_GuarantorInformation] gi ON 
	pd.insuranceinsured1 = gi.code
WHERE pd.insurancecode1 <> ''

PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records inserted'




PRINT ''
PRINT 'Inserting into Insurance Policy  2... '
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderDOB ,
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          Notes ,
          Copay ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation
        )
SELECT DISTINCT
		  p.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          pd.insuranceinsuredid2 , -- PolicyNumber - varchar(32)
          pd.insurancegroupnumber2 , -- GroupNumber - varchar(32)
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured2 = g.code) -- PatientRelationshipToInsured - varchar(1)
			THEN 'O'
			ELSE 'S'
		  END,
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured2 = g.code)
			THEN  gi.firstname
		  END , -- HolderFirstName - varchar(64)
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured2 = g.code)
			THEN  gi.middleinitial
		  END , -- HolderMiddleName - varchar(64)
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured2 = g.code)
			THEN  gi.lastname
		  END , -- HolderLastName - varchar(64)
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g  -- HolderDOB - datetime
			WHERE pd.insuranceinsured2 = g.code)
			THEN
				CASE ISDATE(gi.dateofbirth) WHEN 1  -- DOB - datetime
					THEN
						CASE WHEN gi.dateofbirth > GETDATE() 
							THEN DATEADD(yy, -100, gi.dateofbirth) 
							ELSE gi.dateofbirth
						END
				END 
		  END,
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured2 = g.code)
			THEN  LEFT(REPLACE(gi.socialsecuritynumber,'-',''),9)
		  END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured2 = g.code)
			THEN  gi.sex
		  END , -- HolderGender - char(1)
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured2 = g.code)
			THEN  gi.address1
		  END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured2 = g.code)
			THEN  gi.address2
		  END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured2 = g.code)
			THEN  gi.city
		  END , -- HolderCity - varchar(128)
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured2 = g.code)
			THEN  gi.[state]
		  END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured2 = g.code)
			THEN  gi.zipcode
			END , -- HolderZipCode - varchar(9)
          CASE WHEN pd.insuranceinsured2 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured2 = g.code)
			THEN CASE WHEN gi.homephone <> ''
				THEN LEFT(REPLACE(REPLACE(REPLACE(gi.homephone,'(',''),')',''),'-',''),10)
				ELSE LEFT(REPLACE(REPLACE(REPLACE(gi.workphone,'(',''),')',''),'-',''),10)
				END
		  END , -- HolderPhone - varchar(10)
          '' , -- Notes - text
          pd.copay , -- Copay - money
          @PracticeID , -- PracticeID - int
          pd.chartnumber + '1' , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_PatientDemographics] pd
JOIN dbo.PatientCase p ON
	(pd.chartnumber + LEFT(pd.lastname, 3))= p.VendorID AND 
	p.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	pd.insurancecode2 = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_GuarantorInformation] gi ON 
	pd.insuranceinsured2 = gi.code
WHERE pd.insurancecode2 <> ''

PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records inserted'




PRINT ''
PRINT 'Inserting into Insurance Policy  3... '
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderDOB ,
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          Notes ,
          Copay ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation
        )
SELECT DISTINCT
		  p.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          pd.insuranceinsuredid3 , -- PolicyNumber - varchar(32)
          pd.insurancegroupnumber3 , -- GroupNumber - varchar(32)
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured3 = g.code) -- PatientRelationshipToInsured - varchar(1)
			THEN 'O'
			ELSE 'S'
		  END,
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured3 = g.code)
			THEN  gi.firstname
		  END , -- HolderFirstName - varchar(64)
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured3 = g.code)
			THEN  gi.middleinitial
		  END , -- HolderMiddleName - varchar(64)
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured3 = g.code)
			THEN  gi.lastname
		  END , -- HolderLastName - varchar(64)
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g  -- HolderDOB - datetime
			WHERE pd.insuranceinsured3 = g.code)
			THEN
				CASE ISDATE(gi.dateofbirth) WHEN 1  -- DOB - datetime
					THEN
						CASE WHEN gi.dateofbirth > GETDATE() 
							THEN DATEADD(yy, -100, gi.dateofbirth) 
							ELSE gi.dateofbirth
						END
				END 
		  END,
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured3 = g.code)
			THEN  LEFT(REPLACE(gi.socialsecuritynumber,'-',''),9)
		  END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured3 = g.code)
			THEN  gi.sex
		  END , -- HolderGender - char(1)
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured3 = g.code)
			THEN  gi.address1
		  END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured3 = g.code)
			THEN  gi.address2
		  END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured3 = g.code)
			THEN  gi.city
		  END , -- HolderCity - varchar(128)
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured3 = g.code)
			THEN  gi.[state]
		  END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured3 = g.code)
			THEN  gi.zipcode
			END , -- HolderZipCode - varchar(9)
          CASE WHEN pd.insuranceinsured3 = (SELECT code FROM dbo.[_import_1_1_GuarantorInformation] g 
			WHERE pd.insuranceinsured3 = g.code)
			THEN CASE WHEN gi.homephone <> ''
				THEN LEFT(REPLACE(REPLACE(REPLACE(gi.homephone,'(',''),')',''),'-',''),10)
				ELSE LEFT(REPLACE(REPLACE(REPLACE(gi.workphone,'(',''),')',''),'-',''),10)
				END
		  END , -- HolderPhone - varchar(10)
          '' , -- Notes - text
          pd.copay , -- Copay - money
          @PracticeID , -- PracticeID - int
          pd.chartnumber + '1' , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_PatientDemographics] pd
JOIN dbo.PatientCase p ON
	(pd.chartnumber + LEFT(pd.lastname, 3))= p.VendorID AND 
	p.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	pd.insurancecode3 = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_GuarantorInformation] gi ON 
	pd.insuranceinsured3 = gi.code
WHERE pd.insurancecode3 <> ''

PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records inserted'



PRINT ''
PRINT 'Inserting records into Contract'
INSERT INTO dbo.Contract
        ( PracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ContractName ,
          Description ,
          EffectiveStartDate,
		  EffectiveEndDate,
          ContractType ,
          PolicyValidator ,
          NoResponseTriggerPaper ,
          NoResponseTriggerElectronic ,
          Notes ,
          Capitated ,
          AnesthesiaTimeIncrement
        )
VALUES  ( @PracticeID , -- PracticeID - int
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'Standard Contract' , -- ContractName - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Description
          GETDATE(),
		  DATEADD(dd, 1, DATEADD(yy, 1, GETDATE())) ,
          'S' , -- ContractType - char(1)
          'NULL' , -- PolicyValidator - varchar(64)
          45 , -- NoResponseTriggerPaper - int
          45 , -- NoResponseTriggerElectronic - int
          CAST(@VendorImportID AS VARCHAR) , -- Notes - text
          0, -- Capitated - bit
          15  -- AnesthesiaTimeIncrement - int
        )
PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



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
		,CASE WHEN impFS.standardcost <> '' THEN [standardcost]
			ELSE impFS.defaultcharge
			END
		,0
		,0
		,0
		,pcd.ProcedureCodeDictionaryID
		,0
		,0
		,0
	FROM dbo.[_import_1_1_FeeSchedule] impFS
	INNER JOIN dbo.[Contract] c ON 
		CAST(c.Notes AS VARCHAR) = CAST(@VendorImportID AS VARCHAR) AND
		c.PracticeID = @PracticeID
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON impFS.[defaultcptcode] = pcd.ProcedureCode
	WHERE
		impFS.standardcost <> '' or impFS.defaultcharge <> ''

PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT