USE superbill_27869_dev
--USE superbill_27869_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID8 INT
DECLARE @Practice8VendorImportID INT

SET @PracticeID8 = 8
SET @Practice8VendorImportID = 8


PRINT ''
PRINT ''
PRINT 'PracticeID = ' + CAST(@PracticeID8 AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@Practice8VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID8 AND VendorImportID = @Practice8VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @Practice8VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @Practice8VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'


PRINT ''
PRINT 'Inserting Into Insurance Company...'
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
SELECT DISTINCT
	      i.insurancename , -- InsuranceCompanyName - varchar(128)
          CASE WHEN i.insurancenotes = '' THEN '' ELSE 'Notes: ' + i.insurancenotes + CHAR(13) + CHAR(10) END +
		 (CASE WHEN i.insurancetelephonebenefits = '' THEN '' ELSE 'Phone Benefits: ' + i.insurancetelephonebenefits + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN i.insurancetelephoneauthorization = '' THEN '' ELSE 'Phone Authorization: ' + i.insurancetelephoneauthorization + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN i.insurancetelephonerelations = '' THEN '' ELSE 'Phone Relations: ' + i.insurancetelephonerelations END) , -- Notes - text
          i.insuranceaddress1 , -- AddressLine1 - varchar(256)
          i.insuranceaddress2 , -- AddressLine2 - varchar(256)
          i.insurancecity , -- City - varchar(128)
          i.insurancestate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(insurancezipcode,'-','') , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          i.insurancecontact , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.insurancephone))>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.insurancephone),10) ELSE '' END , -- Phone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.insurancephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.insurancephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.insurancephone))),10)
		  ELSE NULL END , -- PhoneExt
		  i.insurancetelephonefax , -- Fax - varchar(10)
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID8 , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          i.insurancecode , -- VendorID - varchar(50)
          @Practice8VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_9_8_InsuranceMaster] i
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
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
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  ic.InsuranceCompanyName , -- PlanName - varchar(128)
          ic.AddressLine1 , -- AddressLine1 - varchar(256)
          ic.AddressLine2 , -- AddressLine2 - varchar(256)
          ic.City , -- City - varchar(128)
          ic.[State] , -- State - varchar(2)
          ic.Country , -- Country - varchar(32)
          ic.ZipCode , -- ZipCode - varchar(9)
          ic.ContactPrefix , -- ContactPrefix - varchar(16)
          ic.ContactFirstName , -- ContactFirstName - varchar(64)
          ic.ContactMiddleName , -- ContactMiddleName - varchar(64)
          ic.ContactLastName , -- ContactLastName - varchar(64)
          ic.ContactSuffix , -- ContactSuffix - varchar(16)
          ic.Phone , -- Phone - varchar(10)
          CAST(Notes AS VARCHAR) , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID8 , -- CreatedPracticeID - int
          ic.Fax , -- Fax - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.VendorID , -- VendorID - varchar(50)
          @Practice8VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany ic
WHERE VendorImportID = @Practice8VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Insert Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
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
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.policylevel , -- Precedence - int
          i.policynumber , -- PolicyNumber - varchar(32)
          i.policygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(CONVERT(DATETIME,i.policystartdate,102)) = 1 THEN CONVERT(DATETIME,i.policystartdate,102) ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(CONVERT(DATETIME,i.policyenddate,102)) = 1 THEN CONVERT(DATETIME,i.policyenddate,102) ELSE NULL END , -- PolicyEndDate - datetime
          CASE i.policyrelationship WHEN 1 THEN 'S' 
									WHEN 2 THEN 'U' 
									WHEN 3 THEN 'C'
									ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1), -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.policyrelationship <> 1 THEN '' ELSE NULL END, -- HolderPrefix - varchar(16)
          CASE WHEN i.policyrelationship <> 1 THEN i.policyfirstname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.policyrelationship <> 1 THEN i.policymiddleinitial ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.policyrelationship <> 1 THEN i.policylastname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.policyrelationship <> 1 THEN '' ELSE NULL END, -- HolderSuffix - varchar(16)
          CASE WHEN i.policyrelationship <> 1 THEN CONVERT(DATETIME,i.policydateofbirth,102) ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN i.policyrelationship <> 1 THEN 
			CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.policysocialsecurity)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.policysocialsecurity), 9)
			ELSE NULL END ELSE NULL END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.policyrelationship <> 1 THEN CASE i.policysex WHEN 'Female' THEN 'F'
																	WHEN 'Male' THEN 'M'
																	ELSE 'U' END ELSE NULL END , -- HolderGender - char(1)
          CASE WHEN i.policyrelationship <> 1 THEN i.policyaddress1 ELSE NULL END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.policyrelationship <> 1 THEN i.policyaddress2 ELSE NULL END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.policyrelationship <> 1 THEN i.policycity ELSE NULL END , -- HolderCity - varchar(128)
          CASE WHEN i.policyrelationship <> 1 THEN i.policystate ELSE NULL END , -- HolderState - varchar(2)
          CASE WHEN i.policyrelationship <> 1 THEN '' ELSE NULL END , -- HolderCountry - varchar(32)
          CASE WHEN i.policyrelationship <> 1 THEN 
			CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.policyzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.policyzipcode)
            WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.policyzipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.policyzipcode)
            ELSE '' END ELSE NULL END , -- HolderZipCode - varchar(9)
          CASE WHEN i.policyrelationship <> 1 THEN 
			CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.policyphone))>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.policyphone),10) 
			ELSE '' END ELSE NULL END , -- HolderPhone - varchar(10)
          CASE WHEN i.policyrelationship <> 1 THEN 
			CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.policyphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.policyphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.policyphone))),10) 
			ELSE '' END ELSE NULL END, -- HolderPhoneExt - varchar(10)
          CASE WHEN i.policyrelationship <> 1 THEN i.policynumber ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          CASE WHEN dbo.IsInteger(i.policycopay) = 1 THEN i.policycopay ELSE '0' END , -- Copay - money
          1 , -- Active - bit
          @PracticeID8 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @Practice8VendorImportID , -- VendorImportID - int
          LEFT(i.policygroupname, 14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_9_8_PolicyMaster] i
	INNER JOIN dbo.PatientCase pc ON
		i.policyaccountnumber = pc.VendorID AND
		pc.VendorImportID = @Practice8VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		i.policyinsurancecode = icp.VendorID AND
		icp.CreatedPracticeID = @PracticeID8
WHERE CAST(i.policyenddate AS DATETIME) > GETDATE()
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 ,
		  Name = 'Self Pay'
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @Practice8VendorImportID AND
              ip.PatientCaseID IS NULL AND
			  pc.PayerScenarioID = 5
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--COMMIT
--ROLLBACK