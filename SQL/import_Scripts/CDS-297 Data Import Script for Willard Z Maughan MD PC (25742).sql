USE superbill_25742_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

--DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT )
--INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID)
--(
--	SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule 
--	WHERE Notes = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) 
--)

--DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'
--DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'
--DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'
--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'



PRINT ''
PRINT 'Updating dbo.[_import_2_1_Patient] where Chart Number is duplicated (Only 1 record)...'
UPDATE dbo.[_import_2_1_Patient] 
SET chartnumber = chartnumber + '1'
WHERE firstname = 'Nichole' AND lastname = 'Oenes, Jr' AND middleinitial = 'L'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '

PRINT ''
PRINT 'Updating dbo.[_import_2_1_Patient] zipplus4 column to 4 digits...'
UPDATE dbo.[_import_2_1_Patient] 
SET zipplus4 = CASE WHEN LEN(zipplus4) >= 1 THEN RIGHT('000' + zipplus4, 4)
					ELSE '' END
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '

PRINT ''
PRINT 'Updating dbo.[_import_2_1_Insurance] zipplus4 column to 4 digits'
UPDATE dbo.[_import_2_1_Insurance]
SET zipplus4 = CASE WHEN LEN(zipplus4) >= 1 THEN RIGHT('000' + zipplus4, 4)
					ELSE '' END
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Inserting Into Employer...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT  
		  employername , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_2_1_Patient] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '




PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
		  Phone ,
          Fax ,
          FaxExt ,
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
		  name , -- InsuranceCompanyName - varchar(128)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          zipcode + zipplus4, -- ZipCode - varchar(9)
		  phone ,
          fax , -- Fax - varchar(10)
          extension , -- FaxExt - varchar(10)
          13 , -- BillingFormID - int
          'CI', -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          code , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_Insurance] WHERE name <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
SELECT DISTINCT
		  InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          [State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
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
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '




PRINT ''
PRINT 'Inserting Into Patient...'
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
          WorkPhone ,
		  WorkPhoneExt ,
		  MobilePhone ,
          DOB ,
          SSN ,
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
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          Active ,
          EmergencyName ,
          EmergencyPhone ,
		  EmployerID , 
		  EmailAddress ,
		  EmploymentStatus
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          CASE imp.refphysiciancode WHEN 'MAUGHAN' THEN 2
									WHEN 3 THEN 3 
									WHEN 2 THEN 2 ELSE NULL END ,-- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          imp.firstname	 , -- FirstName - varchar(64)
          imp.middleinitial , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
		  imp.zipcode + imp.zipplus4 , -- ZipCode - varchar(9)
          CASE WHEN imp.sex <> '' THEN imp.sex ELSE 'U' END,  -- Gender - varchar(1)
          CASE WHEN imp.maritalstatus <> '' THEN imp.maritalstatus ELSE '' END , -- MaritalStatus - varchar(1)
          imp.homephone , -- HomePhone - varchar(10)
          imp.workphone , -- WorkPhone - varchar(10)
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.workphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(imp.workphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(imp.workphone))),10)
		  ELSE NULL END , -- WorkPhoneExt - varchar(10)
		  imp.mobilephone ,-- MobilePhone(10)
          CASE WHEN ISDATE(imp.birthdate) = 1 THEN imp.birthdate ELSE NULL END , -- DOB - datetime
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.socialsecurity)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(imp.socialsecurity), 9) ELSE NULL END  , -- SSN - char(9)
          CASE WHEN imp.responsibleis IN (2,3) THEN 1 ELSE 0 END  , -- ResponsibleDifferentThanPatient - bit
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN imp.responsibleis = 2 THEN patgua.firstname
			   WHEN imp.responsibleis = 3 THEN gua.firstname ELSE NULL END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN imp.responsibleis = 2 THEN patgua.middleinitial
			   WHEN imp.responsibleis = 3 THEN gua.middleinitial ELSE NULL END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN imp.responsibleis = 2 THEN patgua.lastname
			   WHEN imp.responsibleis = 3 THEN gua.lastname ELSE NULL END, -- ResponsibleLastName - varchar(64)
          '' , -- ResponsibleSuffix - varchar(16)
          CASE WHEN imp.responsibleis IN (2,3) THEN 'O' ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1)
		  CASE WHEN imp.responsibleis = 2 THEN patgua.address1
			   WHEN imp.responsibleis = 3 THEN gua.address1 ELSE NULL END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN imp.responsibleis = 2 THEN patgua.address2
			   WHEN imp.responsibleis = 3 THEN gua.address2 ELSE NULL END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN imp.responsibleis = 2 THEN patgua.city
			   WHEN imp.responsibleis = 3 THEN gua.city ELSE NULL END , -- ResponsibleCity - varchar(128)
          CASE WHEN imp.responsibleis = 2 THEN patgua.[state]
			   WHEN imp.responsibleis = 3 THEN gua.[state] ELSE NULL END , -- ResponsibleState - varchar(2)
          CASE WHEN imp.responsibleis IN (2,3) THEN '' ELSE NULL END , -- ResponsibleCountry - varchar(32)
          CASE WHEN imp.responsibleis = 2 THEN patgua.zipcode + patgua.zipplus4
			   WHEN imp.responsibleis = 3 THEN gua.zipcode + gua.zipplus4 ELSE NULL END, -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE imp.providercode WHEN 'M' THEN 2
								WHEN 1 THEN 2 
								WHEN 2 THEN 2 
								WHEN 3 THEN 3 
								ELSE NULL END , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          imp.chartnumber , -- MedicalRecordNumber - varchar(128)
          imp.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE imp.inactive WHEN 'N' THEN 1 
							WHEN 'Y' THEN 0 ELSE 1 END , -- Active - bit
          imp.contactname , -- EmergencyName - varchar(128)
          LEFT(imp.contactphone, 10) , -- EmergencyPhone - varchar(10)
		  emp.EmployerID , -- EmployerID - int
		  CASE WHEN imp.homeemail <> '' THEN imp.homeemail ELSE NULL END ,
		  'U' -- EmploymentStatus
FROM dbo.[_import_2_1_Patient] imp
	LEFT JOIN dbo.[_import_2_1_Guarantor] gua ON
		gua.code = imp.responsiblepartyguarantor
	LEFT JOIN dbo.[_import_2_1_Patient] patgua ON
		patgua.chartnumber = imp.responsiblepartypatient
	LEFT JOIN dbo.Employers emp ON
		emp.EmployerName = imp.employername
WHERE imp.chartnumber <> '' AND imp.firstname <> '' 
AND NOT EXISTS (SELECT * FROM dbo.Patient pat WHERE (pat.FirstName = imp.firstname AND pat.LastName = imp.lastname AND CAST(CAST(imp.birthdate AS DATE) AS DATETIME) = CAST(CAST(pat.DOB AS DATE) AS DATETIME)))
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted ' 




PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          Notes ,
          ShowExpiredInsurancePolicies ,
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
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient 
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Insurance Policy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
		  PolicyStartDate , 
		  PolicyEndDate , 
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
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
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
		  CASE WHEN ISDATE(imp.primaryinsuranceeffectivedatefrom) = 1 THEN imp.primaryinsuranceeffectivedatefrom ELSE NULL END , -- PolicyStartDate
		  CASE WHEN ISDATE(imp.primaryinsuranceeffectivedateto) = 1 THEN imp.primaryinsuranceeffectivedateto ELSE NULL END, --PolicyEndDate
          1 , -- Precedence - int
          imp.primaryid , -- PolicyNumber - varchar(32)
          imp.primarypolicy , -- GroupNumber - varchar(32)
          CASE WHEN imp.primaryinsuredis <> 1 THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN imp.primaryinsuredis <> 1 THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN imp.primaryinsuredis = 2 THEN pat.FirstName
			   WHEN imp.primaryinsuredis = 3 THEN gua.firstname 
			   ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN imp.primaryinsuredis = 2 THEN pat.MiddleName
			   WHEN imp.primaryinsuredis = 3 THEN gua.middleinitial
			   ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.primaryinsuredis = 2 THEN pat.LastName
			   WHEN imp.primaryinsuredis = 3 THEN gua.lastname
			   ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN imp.primaryinsuredis <> 1 THEN '' END, -- HolderSuffix - varchar(16)
          CASE WHEN imp.primaryinsuredis = 2 THEN pat.DOB
			   WHEN imp.primaryinsuredis = 3 THEN gua.birthdate
			   ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN imp.primaryinsuredis = 2 THEN pat.SSN
			   WHEN imp.primaryinsuredis = 3 THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(gua.socialsecurity)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(gua.socialsecurity),9)
			   ELSE NULL END END, -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.primaryinsuredis = 2 THEN pat.Gender
			   WHEN imp.primaryinsuredis = 3 THEN CASE WHEN gua.sex <> '' THEN gua.sex ELSE 'U' END
			   ELSE NULL END, -- HolderGender - char(1)
          CASE WHEN imp.primaryinsuredis = 2 THEN pat.AddressLine1
			   WHEN imp.primaryinsuredis = 3 THEN gua.address1
			   ELSE NULL END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.primaryinsuredis = 2 THEN pat.AddressLine2
			   WHEN imp.primaryinsuredis = 3 THEN gua.address2
			   ELSE NULL END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.primaryinsuredis = 2 THEN pat.City
			   WHEN imp.primaryinsuredis = 3 THEN gua.city
			   ELSE NULL END, -- HolderCity - varchar(128)
          CASE WHEN imp.primaryinsuredis = 2 THEN pat.[state]
			   WHEN imp.primaryinsuredis = 3 THEN gua.[state]
			   ELSE NULL END , -- HolderState - varchar(2)
		  CASE WHEN imp.primaryinsuredis <> 1 THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN imp.primaryinsuredis = 2 THEN pat.ZipCode
			   WHEN imp.primaryinsuredis = 3 THEN gua.zipcode + gua.zipplus4
			   ELSE NULL END , -- HolderZipCode - varchar(9)
          CASE WHEN imp.primaryinsuredis = 2 THEN pat.HomePhone
			   WHEN imp.primaryinsuredis = 3 THEN gua.homephone
			   ELSE NULL END , -- HolderPhone - varchar(10)
		  CASE WHEN imp.primaryinsuredis <> 1 THEN imp.primaryid END , -- DependentPolicyNumber - varchar(32)
		  CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          imp.copay , -- Copay - money
          CASE WHEN ISDATE(imp.primaryinsuranceeffectivedateto) = 1 THEN 
		  CASE WHEN imp.primaryinsuranceeffectivedateto < GETDATE() THEN 0 ELSE 1 END ELSE 1 END  , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_Patient] imp
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorImportID = @VendorImportID AND
		pc.VendorID = imp.chartnumber
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorImportID = @VendorImportId AND
		icp.VendorID = imp.primarycode
	LEFT JOIN dbo.Patient pat ON
		pat.VendorID = imp.primaryinsuredpatient AND
		pat.VendorImportID = @VendorImportID
	LEFT JOIN dbo.[_import_2_1_Guarantor] gua ON
		gua.code = imp.primaryinsuredguarantor 
WHERE imp.primarycode <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Insurance Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
		  PolicyStartDate ,
		  PolicyEndDate ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
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
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
		  CASE WHEN ISDATE(imp.secondaryinsuranceeffectivedatefrom) = 1 THEN imp.secondaryinsuranceeffectivedatefrom ELSE NULL END , -- PolicyStartDate
		  CASE WHEN ISDATE(imp.secondaryinsuranceeffectivedateto) = 1 THEN imp.secondaryinsuranceeffectivedateto ELSE NULL END, --PolicyEndDate
          2 , -- Precedence - int
          imp.secondaryid , -- PolicyNumber - varchar(32)
          imp.secondarypolicy , -- GroupNumber - varchar(32)
          CASE WHEN imp.secondaryinsredis <> 1 THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN imp.secondaryinsredis <> 1 THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.FirstName
			   WHEN imp.secondaryinsredis = 3 THEN gua.firstname 
			   ELSE '' END , -- HolderFirstName - varchar(64)
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.MiddleName
			   WHEN imp.secondaryinsredis = 3 THEN gua.middleinitial
			   ELSE '' END , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.LastName
			   WHEN imp.secondaryinsredis = 3 THEN gua.lastname
			   ELSE '' END , -- HolderLastName - varchar(64)
          CASE WHEN imp.secondaryinsredis <> 1 THEN '' END, -- HolderSuffix - varchar(16)
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.DOB
			   WHEN imp.secondaryinsredis = 3 THEN gua.birthdate
			   ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.SSN
			   WHEN imp.secondaryinsredis = 3 THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(gua.socialsecurity)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(gua.socialsecurity),9)
			   ELSE NULL END END, -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.Gender
			   WHEN imp.secondaryinsredis = 3 THEN CASE WHEN gua.sex <> '' THEN gua.sex ELSE 'U' END
			   ELSE NULL END, -- HolderGender - char(1)
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.AddressLine1
			   WHEN imp.secondaryinsredis = 3 THEN gua.address1
			   ELSE NULL END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.AddressLine2
			   WHEN imp.secondaryinsredis = 3 THEN gua.address2
			   ELSE NULL END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.City
			   WHEN imp.secondaryinsredis = 3 THEN gua.city
			   ELSE NULL END, -- HolderCity - varchar(128)
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.[state]
			   WHEN imp.secondaryinsredis = 3 THEN gua.[state]
			   ELSE NULL END , -- HolderState - varchar(2)
		  CASE WHEN imp.secondaryinsredis <> 1 THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.ZipCode
			   WHEN imp.secondaryinsredis = 3 THEN gua.zipcode + gua.zipplus4
			   ELSE NULL END , -- HolderZipCode - varchar(9)
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.HomePhone
			   WHEN imp.secondaryinsredis = 3 THEN gua.homephone
			   ELSE NULL END , -- HolderPhone - varchar(10)
		  CASE WHEN imp.secondaryinsredis <> 1 THEN imp.secondaryid END , -- DependentPolicyNumber - varchar(32)
		  CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          imp.copay , -- Copay - money
          CASE WHEN ISDATE(imp.secondaryinsuranceeffectivedateto) = 1 THEN 
		  CASE WHEN imp.secondaryinsuranceeffectivedateto < GETDATE() THEN 0 ELSE 1 END ELSE 1 END , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_Patient] imp
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorImportID = @VendorImportID AND
		pc.VendorID = imp.chartnumber
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorImportID = @VendorImportId AND
		icp.VendorID = imp.secondarycode
	LEFT JOIN dbo.Patient pat ON
		pat.VendorID = imp.secondaryinsuredpatient AND
		pat.VendorImportID = @VendorImportID
	LEFT JOIN dbo.[_import_2_1_Guarantor] gua ON
		gua.code = imp.secondaryinsuredguarantor
WHERE imp.secondarycode <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Insurance Policy 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
		  PolicyStartDate ,
		  PolicyEndDate ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
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
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
		  CASE WHEN ISDATE(imp.tertiaryinsuranceeffectivedatefrom) = 1 THEN imp.tertiaryinsuranceeffectivedatefrom ELSE NULL END , -- PolicyStartDate
		  CASE WHEN ISDATE(imp.tertiaryinsuranceeffectivedateto) = 1 THEN imp.tertiaryinsuranceeffectivedateto ELSE NULL END, --PolicyEndDate
          3 , -- Precedence - int
          imp.tertiaryid , -- PolicyNumber - varchar(32)
          imp.tertiarypolicy , -- GroupNumber - varchar(32)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN imp.tertiaryinsredis = 2 THEN pat.FirstName
			   WHEN imp.tertiaryinsredis = 3 THEN gua.firstname 
			   ELSE '' END , -- HolderFirstName - varchar(64)
          CASE WHEN imp.tertiaryinsredis = 2 THEN pat.MiddleName
			   WHEN imp.tertiaryinsredis = 3 THEN gua.middleinitial
			   ELSE '' END , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.tertiaryinsredis = 2 THEN pat.LastName
			   WHEN imp.tertiaryinsredis = 3 THEN gua.lastname
			   ELSE '' END , -- HolderLastName - varchar(64)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN '' END, -- HolderSuffix - varchar(16)
          CASE WHEN imp.tertiaryinsredis = 2 THEN pat.DOB
			   WHEN imp.tertiaryinsredis = 3 THEN gua.birthdate
			   ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN imp.tertiaryinsredis = 2 THEN pat.SSN
			   WHEN imp.tertiaryinsredis = 3 THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(gua.socialsecurity)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(gua.socialsecurity),9)
			   ELSE NULL END END, -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.tertiaryinsredis = 2 THEN pat.Gender
			   WHEN imp.tertiaryinsredis = 3 THEN CASE WHEN gua.sex <> '' THEN gua.sex ELSE 'U' END
			   ELSE NULL END, -- HolderGender - char(1)
          CASE WHEN imp.tertiaryinsredis = 2 THEN pat.AddressLine1
			   WHEN imp.tertiaryinsredis = 3 THEN gua.address1
			   ELSE NULL END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.tertiaryinsredis = 2 THEN pat.AddressLine2
			   WHEN imp.tertiaryinsredis = 3 THEN gua.address2
			   ELSE NULL END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.tertiaryinsredis = 2 THEN pat.City
			   WHEN imp.tertiaryinsredis = 3 THEN gua.city
			   ELSE NULL END, -- HolderCity - varchar(128)
          CASE WHEN imp.secondaryinsredis = 2 THEN pat.[state]
			   WHEN imp.secondaryinsredis = 3 THEN gua.[state]
			   ELSE NULL END , -- HolderState - varchar(2)
		  CASE WHEN imp.tertiaryinsredis <> 1 THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN imp.tertiaryinsredis = 2 THEN pat.ZipCode
			   WHEN imp.tertiaryinsredis = 3 THEN gua.zipcode + gua.zipplus4
			   ELSE NULL END , -- HolderZipCode - varchar(9)
          CASE WHEN imp.tertiaryinsredis = 2 THEN pat.HomePhone
			   WHEN imp.tertiaryinsredis = 3 THEN gua.homephone
			   ELSE NULL END , -- HolderPhone - varchar(10)
		  CASE WHEN imp.tertiaryinsredis <> 1 THEN imp.tertiaryid END , -- DependentPolicyNumber - varchar(32)
		  CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          imp.copay , -- Copay - money
          CASE WHEN ISDATE(imp.tertiaryinsuranceeffectivedateto) = 1 THEN 
		  CASE WHEN imp.tertiaryinsuranceeffectivedateto < GETDATE() THEN 0 ELSE 1 END ELSE 1 END   , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_Patient] imp
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorImportID = @VendorImportID AND
		pc.VendorID = imp.chartnumber
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorImportID = @VendorImportId AND
		icp.VendorID = imp.tertiarycode
	LEFT JOIN dbo.Patient pat ON
		pat.VendorID = imp.tertiaryinsuredpatient AND
		pat.VendorImportID = @VendorImportID
	LEFT JOIN dbo.[_import_2_1_Guarantor] gua ON
		gua.code = imp.tertiaryinsuredguarantor
WHERE imp.tertiarycode <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting into Standard Fee Schedule...'
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
VALUES  ( @PracticeID , -- PracticeID - int
          'Standard Fees' , -- Name - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          '2014-01-01 07:00:00' , -- EffectiveStartDate - datetime
          'F' , -- SourceType - char(1)
          'Import File' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
        )
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Standard Fee...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
		  --ModifierID , 
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT DISTINCT
		  sfs.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
		  --pm.ProcedureModifierID , --ModifierID
          imp.defaultcharge , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_2_1_TransactionCode] imp
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON	
		CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
		sfs.PracticeID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
		pcd.ProcedureCode = imp.defaultcptcode
--LEFT JOIN dbo.ProcedureModifier pm ON
--		pm.ProcedureModifierCode = imp.modifier1
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Standard Fee Link...'
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
WHERE doc.[External] = 0 AND	
	  doc.PracticeID = @PracticeID AND
	  sl.PracticeID = @PracticeID AND
	  CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	  sfs.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



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
		  pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          imp.startdatemst , -- StartDate - datetime
          imp.enddatemst , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          imp.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE imp.[status] WHEN 'Being Seen' THEN 'E'
							WHEN 'E' THEN 'E'
							WHEN 'Canceled' THEN 'X'
							WHEN 'X' THEN 'X'
							WHEN 'Completed' THEN 'O'
							WHEN 'O' THEN 'O'
							WHEN 'Confirmed' THEN 'C'
							WHEN 'C' THEN 'C'
							WHEN 'Late' THEN 'R'
							WHEN 'R' THEN 'R'
							WHEN 'Missed' THEN 'N'
							WHEN 'N' THEN 'N'
							WHEN 'Pending' THEN 'S'
							WHEN 'S' THEN 'S'
							WHEN 'Recall' THEN 'S'
							WHEN 'Rescheduled' THEN 'R'
							WHEN 'Waiting' THEN 'S'
							ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          imp.starttmmst , -- StartTm - smallint
          imp.endtmmst  -- EndTm - smallint
FROM dbo.[_import_2_1_Appointment] imp
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = imp.chart AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = pat.VendorID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = CAST(CAST(imp.startdatemst AS DATE) AS DATETIME)   
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
          1 , -- AppointmentResourceTypeID - int
          imp.[resource] , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_Appointment] AS imp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = imp.chart AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS app ON
	app.PatientID = pat.PatientID AND
	app.StartDate = imp.startdatemst 
WHERE app.CreatedDate > DATEADD(mi,-2,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Updating Patient Cases that are not linked to policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 ,
		  Name = 'Self Pay'
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
COMMIT


