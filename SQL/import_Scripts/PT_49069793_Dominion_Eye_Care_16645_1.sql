--USE superbill_16645_dev
USE superbill_16645_prod
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



DELETE FROM dbo.InsurancePolicy WHERE (PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Policy records deleted '

DELETE FROM dbo.PatientCase WHERE PatientID IN (SELECT patientid FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient Case records deleted '

DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient records deleted '

DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Company Plans records deleted '

DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Companies records deleted '


--UPDATE dbo.[_import_1_1_Patient]
--SET chartnumber =  chartnumber + LEFT(lastname, 1)
--WHERE chartnumber = '1771'



PRINT''
PRINT'Inserting into Insurance Company ....'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
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
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT	  ins.name , -- InsuranceCompanyName - varchar(128)
          ins.address1 , -- AddressLine1 - varchar(256)
          ins.address2 , -- AddressLine2 - varchar(256)
          ins.city , -- City - varchar(128)
          ins.state , -- State - varchar(2)
          ins.zipcode + ins.zipplus4 , -- ZipCode - varchar(9)
          ins.phone , -- Phone - varchar(10)
          ins.extension , -- PhoneExt - varchar(10)
          ins.fax , -- Fax - varchar(10)
          0 , -- BillSecondaryInsurance - bit
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
          ins.code , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo._import_1_1_Insurance AS ins
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Company Plan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          ContactFirstName ,
          Phone ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT    InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          ZipCode , -- ZipCode - varchar(9)
          ContactFirstName , -- ContactFirstName - varchar(64)
          Phone , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int       
FROM dbo.InsuranceCompany
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Patient ...'
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
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
		  EmergencyName ,
		  EmergencyPhone 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          middleinitial , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          zipcode + zipplus4 , -- ZipCode - varchar(9)
          sex , -- Gender - varchar(1)
          CASE maritalstatus WHEN 'W' THEN 'W'
		                     WHEN 'M' THEN 'M'
							 WHEN 'S' THEN 'S'
							 WHEN 'D' THEN 'D'
							          ELSE ''
		  END , -- MaritalStatus - varchar(1)
          homephone , -- HomePhone - varchar(10)
          workphone , -- WorkPhone - varchar(10)
          birthdate , -- DOB - datetime
          REPLACE(socialsecurity, '-', '') , -- SSN - char(9)
          homeemail , -- EmailAddress - varchar(256)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE employmentstatus WHEN 'R' THEN 'R'
		                        WHEN 'F' THEN 'S'
								WHEN 'P' THEN 'T'
								ELSE 'U'
		  END , -- EmploymentStatus - char(1)
          chartnumber , -- MedicalRecordNumber - varchar(128)
          mobilephone , -- MobilePhone - varchar(10)
          chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          CASE homeemail WHEN '' THEN 0
		                         ELSE 1
		  END , -- SendEmailCorrespondence - bit
          1 , -- PhonecallRemindersEnabled - bit
		  contactname , -- EmergencyName
		  contactphone  -- EmergencyPhone
FROM [dbo].[_import_1_1_Patient]
WHERE firstname <> '' AND
	  lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Patient Case ...'
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
          'Created via data import, please review.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.Patient
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Policy ...'
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
          HolderDOB ,
          HolderSSN ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          HolderPhone ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pol.primaryid , -- PolicyNumber - varchar(32)
          pol.primarypolicy , -- GroupNumber - varchar(32)
          CASE pol.primaryinsrelation WHEN '18' THEN 'S'
								      WHEN '19' THEN 'C'
									  WHEN '1' THEN 'U'
									  ELSE 'O'
	      END , -- PatientRelationshipToInsured - varchar(1)
          CASE pol.primaryinsuredis WHEN '1' THEN ''
		                                 ELSE guar.firstname
		  END , -- HolderFirstName - varchar(64)
          CASE pol.primaryinsuredis WHEN '1' THEN ''
		                                 ELSE guar.lastname
		  END  , -- HolderLastName - varchar(64)
          CASE pol.primaryinsuredis WHEN '1' THEN ''
		                                 ELSE ''
		  END  , -- HolderSuffix - varchar(16)
          CASE pol.primaryinsuredis WHEN '1' THEN ''
		                                 ELSE guar.birthdate
		  END  , -- HolderDOB - datetime
          REPLACE(guar.socialsecurity,'-','') , -- HolderSSN - char(11)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE pol.primaryinsuredis WHEN '1' THEN ''
		                                 ELSE guar.sex
		  END  , -- HolderGender - char(1)
          CASE pol.primaryinsuredis WHEN '1' THEN ''
		                                 ELSE guar.address1
		  END  , -- HolderAddressLine1 - varchar(256)
          CASE pol.primaryinsuredis WHEN '1' THEN ''
		                                 ELSE guar.address2
		  END  , -- HolderAddressLine2 - varchar(256)
          CASE pol.primaryinsuredis WHEN '1' THEN ''
		                                 ELSE guar.city
		  END  , -- HolderCity - varchar(128)
          CASE pol.primaryinsuredis WHEN '1' THEN ''
		                                 ELSE guar.state
		  END  , -- HolderState - varchar(2)
		  CASE pol.primaryinsuredis WHEN '1' THEN ''
		                                 ELSE guar.zipcode + guar.zipplus4
		  END , -- HolderZipCode - varchar(9)
          CASE pol.primaryinsuredis WHEN '1' THEN ''
		                                 ELSE guar.homephone
		  END , -- HolderPhone - varchar(10)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.chartnumber , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo._import_1_1_Patient AS pol
JOIN dbo.PatientCase AS pc
ON pc.vendorID=pol.chartnumber AND pc.VendorImportID=@VendorImportID
JOIN dbo.InsuranceCompanyPlan AS icp
ON icp.vendorID=pol.primarycode AND icp.VendorImportID=@VendorImportID
LEFT JOIN dbo._import_1_1_Guarantor AS guar
ON guar.code=pol.primaryinsuredguarantor
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Policy Round 2...'
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
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          HolderPhone ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          pol.secondaryid , -- PolicyNumber - varchar(32)
          pol.secondarypolicy , -- GroupNumber - varchar(32)
          pol.secondaryinsuranceeffectivedatefrom , -- PolicyStartDate - datetime
          pol.secondaryinsuranceeffectivedateto , -- PolicyEndDate - datetime
          CASE pol.secondinsrelation WHEN '18' THEN 'S'
								        WHEN '19' THEN 'C'
									    WHEN '1' THEN 'U'
									             ELSE 'O'
	      END , -- PatientRelationshipToInsured - varchar(1)
          CASE pol.secondaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.firstname
		  END , -- HolderFirstName - varchar(64)
          CASE pol.secondaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.lastname
		  END  , -- HolderLastName - varchar(64)
          CASE pol.secondaryinsredis WHEN '1' THEN ''
		                                 ELSE ''
		  END  , -- HolderSuffix - varchar(16)
          CASE pol.secondaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.birthdate
		  END  , -- HolderDOB - datetime
          REPLACE(guar.socialsecurity,'-','') , -- HolderSSN - char(11)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE pol.secondaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.sex
		  END  , -- HolderGender - char(1)
          CASE pol.secondaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.address1
		  END  , -- HolderAddressLine1 - varchar(256)
          CASE pol.secondaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.address2
		  END  , -- HolderAddressLine2 - varchar(256)
          CASE pol.secondaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.city
		  END  , -- HolderCity - varchar(128)
          CASE pol.secondaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.state
		  END  , -- HolderState - varchar(2)
		  CASE pol.secondaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.zipcode + guar.zipplus4
		  END , -- HolderZipCode - varchar(9)
          CASE pol.secondaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.homephone
		  END , -- HolderPhone - varchar(10)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.chartnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo._import_1_1_Patient AS pol
JOIN dbo.PatientCase AS pc
ON pc.vendorID=pol.chartnumber AND pc.VendorImportID=@VendorImportID
JOIN dbo.InsuranceCompanyPlan AS icp
ON icp.vendorID=pol.secondarycode AND icp.VendorImportID=@VendorImportID
LEFT JOIN dbo._import_1_1_Guarantor AS guar
ON guar.code=pol.primaryinsuredguarantor
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Policy Round 3...'
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
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          HolderPhone ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          pol.tertiaryid , -- PolicyNumber - varchar(32)
          pol.tertiarypolicy , -- GroupNumber - varchar(32)
          pol.tertiaryinsuranceeffectivedatefrom , -- PolicyStartDate - datetime
          pol.tertiaryinsuranceeffectivedateto , -- PolicyEndDate - datetime
          CASE pol.tertinsrelation WHEN '18' THEN 'S'
								      WHEN '19' THEN 'C'
									  WHEN '1' THEN 'U'
									  ELSE 'O'
	      END , -- PatientRelationshipToInsured - varchar(1)
          CASE pol.tertiaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.firstname
		  END , -- HolderFirstName - varchar(64)
          CASE pol.tertiaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.lastname
		  END  , -- HolderLastName - varchar(64)
          CASE pol.tertiaryinsredis WHEN '1' THEN ''
		                                 ELSE ''
		  END  , -- HolderSuffix - varchar(16)
          CASE pol.tertiaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.birthdate
		  END  , -- HolderDOB - datetime
          REPLACE(guar.socialsecurity,'-','') , -- HolderSSN - char(11)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE pol.tertiaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.sex
		  END  , -- HolderGender - char(1)
          CASE pol.tertiaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.address1
		  END  , -- HolderAddressLine1 - varchar(256)
          CASE pol.tertiaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.address2
		  END  , -- HolderAddressLine2 - varchar(256)
          CASE pol.tertiaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.city
		  END  , -- HolderCity - varchar(128)
          CASE pol.tertiaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.state
		  END  , -- HolderState - varchar(2)
		  CASE pol.tertiaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.zipcode + guar.zipplus4
		  END , -- HolderZipCode - varchar(9)
          CASE pol.tertiaryinsredis WHEN '1' THEN ''
		                                 ELSE guar.homephone
		  END , -- HolderPhone - varchar(10)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.chartnumber , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo._import_1_1_Patient AS pol
JOIN dbo.PatientCase AS pc
ON pc.vendorID=pol.chartnumber AND pc.VendorImportID=@VendorImportID
JOIN dbo.InsuranceCompanyPlan AS icp
ON icp.vendorID=pol.tertiarycode AND icp.VendorImportID=@VendorImportID
LEFT JOIN dbo._import_1_1_Guarantor AS guar
ON guar.code=pol.primaryinsuredguarantor
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Updating PatientCase'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11 
WHERE 
	@VendorImportID = VendorImportID AND 
	@PracticeID = PracticeID AND
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID) AND
	PayerScenarioID <> 11
	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN