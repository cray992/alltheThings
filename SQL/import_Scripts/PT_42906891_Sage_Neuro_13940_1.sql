USE superbill_13940_dev
--USE superbill_13940_prod
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

-- NUKE Standard fee schedules based on providers being nuked for this import
DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT)
INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID) 
(
	SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE Notes = 'Vendor Import '+ CAST(@VendorImportID AS VARCHAR)
)
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'

DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeId AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'

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
          ic.[zipcode] + ic.zipplus4,-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(ic.phone,'(',''),')',''),'-',''),10),-- Phone - varchar(10)
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
FROM [dbo].[_import_1_1_Insurance] ic
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records inserted'


--InsuranceCompanyPlan
PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
		  AddressLine1 ,
		  AddressLine2 ,
		  city ,
		  State ,
		  ZipCode ,
		  Phone ,
		  Fax ,
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
		  icp.InsuranceCompanyName , -- PlanName - varchar(128)
		  icp.addressline1 ,
		  icp.addressline2 ,
		  icp.city ,
		  icp.[State] ,
		  icp.zipcode ,
		  icp.phone ,
		  icp.fax ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          icp.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany icp 
WHERE icp.CreatedPracticeID = @PracticeID AND 
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

--Referring Doctor
PRINT ''
PRINT 'Inserting into Doctor ...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          WorkPhone ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          UserID ,
          VendorID ,
          VendorImportID ,
          [External] 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          doc.firstname , -- FirstName - varchar(64)
          doc.middleinitial , -- MiddleName - varchar(64)
          doc.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          doc.address1 , -- AddressLine1 - varchar(256)
          doc.address2 , -- AddressLine2 - varchar(256)
          doc.city , -- City - varchar(128)
          doc.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
		  doc.zipcode , -- ZipCode - varchar(9)
          CASE WHEN doc.phone <> '' THEN doc.phone ELSE doc.mainphone END , -- WorkPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- UserID - int
          doc.code , -- VendorID - varchar(50)
          @VendorImportId , -- VendorImportID - int
          1  -- External - bit
FROM dbo.[_import_1_1_ReferringPhysicians] doc

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--Patient
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
          MobilePhone ,
          DOB ,
          SSN ,
          ReferringPhysicianID ,
          EmailAddress ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
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
          pd.[zipcode] + pd.[zipplus4] , -- ZipCode - varchar(9)
          pd.sex , -- Gender - varchar(1)
          CASE WHEN pd.[maritalstatus] = 'M' THEN 'M'
				WHEN pd.[maritalstatus] = 'W' THEN 'W'
				WHEN pd.[maritalstatus] = 'D' THEN 'D'
				WHEN pd.[maritalstatus] = 'X' THEN ''
				WHEN pd.[maritalstatus] = 'S' THEN 'S'
				ELSE NULL 
			END ,
          LEFT(REPLACE(REPLACE(REPLACE(pd.homephone,'(',''),')',''),'-',''),10), -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(pd.workphone,'(',''),')',''),'-',''),10),-- WorkPhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(pd.mobilephone,'(',''),')',''),'-',''),10),-- WorkPhoneExt - varchar(10)
          CASE ISDATE(pd.birthdate) WHEN 1  -- DOB - datetime
			THEN CASE WHEN pd.birthdate > GETDATE() THEN DATEADD(yy, -100, pd.birthdate) 
			ELSE pd.birthdate END 
			ELSE NULL END,
          LEFT(REPLACE(pd.socialsecurity,'-',''),9) , -- SSN - char(9)
          refdoc.DoctorID ,
          pd.homeemail , -- EmailAddress - varchar(256)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pd.chartnumber , -- MedicalRecordNumber - varchar(128)
          pd.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          1  -- PhonecallRemindersEnabled - bit
FROM [dbo].[_import_1_1_Patient] pd
LEFT JOIN dbo.Doctor refdoc ON
	pd.refphysiciancode = refdoc.VendorID AND
	refdoc.VendorImportID = @VendorImportID AND
	refdoc.[External] = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records inserted'





PRINT ''
PRINT 'Inserting into Patient Cases'
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
SELECT DISTINCT    
		   p.PatientID, -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 ,
          5 , -- PayerScenarioID - int
          'Created via Import. Please Review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          p.VendorID, -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.Patient p
WHERE p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Cases records inserted'


----In middle of policy 1

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
          pd.primaryid , -- PolicyNumber - varchar(32)
          pd.primarypolicy , -- GroupNumber - varchar(32)
          CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code) -- PatientRelationshipToInsured - varchar(1)
			THEN 'O'
			ELSE 'S'
		  END,
		  CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code)
			THEN  gi.firstname
		  END , -- HolderFirstName - varchar(64)
          CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code)
			THEN  gi.middleinitial
		  END , -- HolderMiddleName - varchar(64)
          CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code)
			THEN  gi.lastname
		  END , -- HolderLastName - varchar(64)
          CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code)
			THEN
				CASE ISDATE(gi.birthdate) WHEN 1  -- DOB - datetime
					THEN
						CASE WHEN gi.birthdate > GETDATE() 
							THEN DATEADD(yy, -100, gi.birthdate) 
							ELSE gi.birthdate
						END
				END 
		  END,
          CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code)
			THEN  LEFT(REPLACE(gi.socialsecurity,'-',''),9)
		  END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code)
			THEN  gi.sex
		  END , -- HolderGender - char(1)
          CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code)
			THEN  gi.address1
		  END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code)
			THEN  gi.address2
		  END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code)
			THEN  gi.city
		  END , -- HolderCity - varchar(128)
          CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code)
			THEN  gi.[state]
		  END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code)
			THEN  LEFT(REPLACE(gi.zipcode,'-',''),9)
			END , -- HolderZipCode - varchar(9)
          CASE WHEN pd.primaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.primaryinsuredguarantor = g.code)
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
FROM dbo.[_import_1_1_Patient] pd
JOIN dbo.PatientCase p ON
	pd.chartnumber = p.VendorID AND 
	p.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	pd.primarycode = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_Guarantor] gi ON 
	pd.primaryinsuredguarantor = gi.code
WHERE pd.primarycode <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records inserted'



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
          pd.secondaryid , -- PolicyNumber - varchar(32)
          pd.secondarypolicy , -- GroupNumber - varchar(32)
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code) -- PatientRelationshipToInsured - varchar(1)
			THEN 'O'
			ELSE 'S'
		  END,
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code)
			THEN  gi.firstname
		  END , -- HolderFirstName - varchar(64)
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code)
			THEN  gi.middleinitial
		  END , -- HolderMiddleName - varchar(64)
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code)
			THEN  gi.lastname
		  END , -- HolderLastName - varchar(64)
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code)
			THEN
				CASE ISDATE(gi.birthdate) WHEN 1  -- DOB - datetime
					THEN
						CASE WHEN gi.birthdate > GETDATE() 
							THEN DATEADD(yy, -100, gi.birthdate) 
							ELSE gi.birthdate
						END
				END 
		  END,
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code)
			THEN  LEFT(REPLACE(gi.socialsecurity,'-',''),9)
		  END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code)
			THEN  gi.sex
		  END , -- HolderGender - char(1)
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code)
			THEN  gi.address1
		  END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code)
			THEN  gi.address2
		  END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code)
			THEN  gi.city
		  END , -- HolderCity - varchar(128)
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code)
			THEN  gi.[state]
		  END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code)
			THEN  LEFT(REPLACE(gi.zipcode,'-',''),9)
			END , -- HolderZipCode - varchar(9)
          CASE WHEN pd.secondaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.secondaryinsuredguarantor = g.code)
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
FROM dbo.[_import_1_1_Patient] pd
JOIN dbo.PatientCase p ON
	pd.chartnumber = p.VendorID AND 
	p.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	pd.secondarycode = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_Guarantor] gi ON 
	pd.secondaryinsuredguarantor = gi.code
WHERE pd.secondarycode <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records inserted'




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
          pd.tertiaryid , -- PolicyNumber - varchar(32)
          pd.tertiarypolicy , -- GroupNumber - varchar(32)
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code) -- PatientRelationshipToInsured - varchar(1)
			THEN 'O'
			ELSE 'S'
		  END,
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code)
			THEN  gi.firstname
		  END , -- HolderFirstName - varchar(64)
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code)
			THEN  gi.middleinitial
		  END , -- HolderMiddleName - varchar(64)
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code)
			THEN  gi.lastname
		  END , -- HolderLastName - varchar(64)
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code)
			THEN
				CASE ISDATE(gi.birthdate) WHEN 1  -- DOB - datetime
					THEN
						CASE WHEN gi.birthdate > GETDATE() 
							THEN DATEADD(yy, -100, gi.birthdate) 
							ELSE gi.birthdate
						END
				END 
		  END,
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code)
			THEN  LEFT(REPLACE(gi.socialsecurity,'-',''),9)
		  END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code)
			THEN  gi.sex
		  END , -- HolderGender - char(1)
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code)
			THEN  gi.address1
		  END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code)
			THEN  gi.address2
		  END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code)
			THEN  gi.city
		  END , -- HolderCity - varchar(128)
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code)
			THEN  gi.[state]
		  END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code)
			THEN  LEFT(REPLACE(gi.zipcode,'-',''),9)
			END , -- HolderZipCode - varchar(9)
          CASE WHEN pd.tertiaryinsuredguarantor = (SELECT code FROM dbo.[_import_1_1_Guarantor] g 
			WHERE pd.tertiaryinsuredguarantor = g.code)
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
FROM dbo.[_import_1_1_Patient] pd
JOIN dbo.PatientCase p ON
	pd.chartnumber = p.VendorID AND 
	p.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	pd.tertiarycode = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_Guarantor] gi ON 
	pd.tertiaryinsuredguarantor = gi.code
WHERE pd.tertiarycode <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records inserted'



--StandardFeeSchedule
PRINT ''
PRINT 'Inserting in a new StandardFeeSchedule ...'
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
VALUES  ( 
		  @PracticeID , -- PracticeID - int
          'Default contract' , -- Name - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          GETDATE() , -- EffectiveStartDate - datetime
          'f' , -- SourceType - char(1)
          'Import file' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--StandardFee
PRINT ''
PRINT 'Inserting in Standard Fees ...'
INSERT INTO dbo.ContractsAndFees_StandardFee
    ( StandardFeeScheduleID ,
      ProcedureCodeID ,
      ModifierID ,
      SetFee ,
      AnesthesiaBaseUnits
    )
SELECT DISTINCT
      c.StandardFeeScheduleID , -- StandardFeeScheduleID - int
      pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
      0 , -- ModifierID - int
      impSFS.standardcost , -- SetFee - money
      0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_1_1_TransactionCode] impSFS
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule c ON
	CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
	c.practiceID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	impSFS.code = pcd.ProcedureCode AND
	impSFS.standardcost <> ''	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--StandardFeeScheduleLink
PRINT ''
PRINT 'Inserting in Standard Fee Schedule Link ...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
    ( ProviderID ,
      LocationID ,
      StandardFeeScheduleID
    )
SELECT DISTINCT
      doc.DoctorID , -- ProviderID - int
      sl.ServiceLocationID , -- LocationID - int
      sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs 
WHERE doc.PracticeID = @PracticeID AND
	doc.[External] = 0 AND 
	sl.PracticeID = @PracticeID AND
	CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	sfs.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




COMMIT