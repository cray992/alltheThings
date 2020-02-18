USE superbill_26579_dev
--USE superbill_26579_prod
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

/*
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
*/

PRINT ''
PRINT 'Inserting into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
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
SELECT DISTINCT
		  carriername , -- InsuranceCompanyName - varchar(128)
          CASE WHEN eligibilityphonenumber = '' THEN '' ELSE 'Eligibility Phone Number: ' + eligibilityphonenumber END + CHAR(13)+CHAR(10) +
		  CASE WHEN eligibilityphoneextension = '' THEN '' ELSE 'Eligibility Phone Extension: ' + eligibilityphoneextension END + CHAR(13)+CHAR(10) +    
		  CASE WHEN preauthphonenumber = '' THEN '' ELSE 'Pre-Authorization Phone Number: ' + preauthphonenumber END + CHAR(13)+CHAR(10) +
		  CASE WHEN preauthphoneextension = '' THEN '' ELSE 'Pre-Authorization Phone Extension: ' + preauthphoneextension END + CHAR(13)+CHAR(10) +
		  CASE WHEN providerrelationsphonenumber = '' THEN '' ELSE 'Provider Relations Phone Number: ' + providerrelationsphonenumber END + CHAR(13)+CHAR(10) +
		  CASE WHEN providerrelationsphoneextension = '' THEN '' ELSE 'Provider Relations Phone Extension: ' + providerrelationsphoneextension END + CHAR(13)+CHAR(10) +
		  CASE WHEN emailaddress = '' THEN '' ELSE 'Email Address: ' + emailaddress END + CHAR(13)+CHAR(10) +
		  CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT(state , 2) , -- State - varchar(2)
          CASE WHEN LEN(zipcode) IN (5,9) THEN ZipCode
			   WHEN LEN(zipcode) IN (4,8) THEN '0' + ZipCode
			   ELSE '' END , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          ContactFirst , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          ContactLast , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          LEFT(faxnumber , 10) , -- Fax - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          CASE typeofinsurance WHEN 'MB' THEN 'MB'
							   WHEN 'MC' THEN 'MC'
							   WHEN 'C1' THEN 'CI'
							   ELSE 'CI' END , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          carrieruid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_Insurance]
WHERE carriername <> '' AND carriercode <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
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
		  InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          ZipCode , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          ContactFirstName , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          ContactLastName , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
		  0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          Fax , -- Fax - varchar(10)
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  employer , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo._import_1_1_PatientDemographic
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into Patient...'
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
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          imppat.title , -- Prefix - varchar(16)
          imppat.firstname , -- FirstName - varchar(64)
          imppat.middlename , -- MiddleName - varchar(64)
          imppat.lastname , -- LastName - varchar(64)
          imppat.suffix , -- Suffix - varchar(16)
          imppat.address1 , -- AddressLine1 - varchar(256)
          imppat.address2 , -- AddressLine2 - varchar(256)
          imppat.city , -- City - varchar(128)
          LEFT(imppat.STATE , 2) , -- State - varchar(2)
          CASE WHEN LEN(imppat.zipcode) IN (5,9) THEN imppat.zipcode
			   WHEN LEN(imppat.zipcode) IN (4,8) THEN '0' + imppat.zipcode
			   ELSE '' END , -- ZipCode - varchar(9)
          imppat.gender , -- Gender - varchar(1)
          CASE imppat.maritalstatus WHEN 1 THEN 'S'
									WHEN 2 THEN 'M'
									WHEN 3 THEN 'D'
									WHEN 4 THEN 'L'
									WHEN 5 THEN 'W'
									ELSE '' END , -- MaritalStatus - varchar(1)
          LEFT(imppat.homephone , 10) , -- HomePhone - varchar(10)
          LEFT(imppat.officephone , 10) , -- WorkPhone - varchar(10)
          LEFT(imppat.officeextension , 10) , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(imppat.dob) = 1 THEN imppat.dob
			   ELSE NULL END , -- DOB - datetime
          CASE WHEN LEN(imppat.ssn) >= 6 THEN RIGHT('000' + imppat.ssn , 9) ELSE '' END , -- SSN - char(9)
          imppat.email , -- EmailAddress - varchar(256)
          CASE WHEN imppat.firstname <> impg.firstname AND imppat.lastname <> impg.lastname AND 
		  CAST(CAST(imppat.dob AS DATE)AS datetime) <> CAST(CAST(impg.dob AS DATE)AS datetime) THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN imppat.firstname <> impg.firstname AND imppat.lastname <> impg.lastname AND 
		  CAST(CAST(imppat.dob AS DATE)AS datetime) <> CAST(CAST(impg.dob AS DATE)AS datetime) THEN impg.firstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN imppat.firstname <> impg.firstname AND imppat.lastname <> impg.lastname AND 
		  CAST(CAST(imppat.dob AS DATE)AS datetime) <> CAST(CAST(impg.dob AS DATE)AS datetime) THEN impg.middlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN imppat.firstname <> impg.firstname AND imppat.lastname <> impg.lastname AND 
		  CAST(CAST(imppat.dob AS DATE)AS datetime) <> CAST(CAST(impg.dob AS DATE)AS datetime) THEN impg.lastname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN imppat.firstname <> impg.firstname AND imppat.lastname <> impg.lastname AND 
		  CAST(CAST(imppat.dob AS DATE)AS datetime) <> CAST(CAST(impg.dob AS DATE)AS datetime) THEN impg.suffix END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN imppat.firstname <> impg.firstname AND imppat.lastname <> impg.lastname AND 
		  CAST(CAST(imppat.dob AS DATE)AS datetime) <> CAST(CAST(impg.dob AS DATE)AS datetime) THEN 'O' ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN imppat.firstname <> impg.firstname AND imppat.lastname <> impg.lastname AND 
		  CAST(CAST(imppat.dob AS DATE)AS datetime) <> CAST(CAST(impg.dob AS DATE)AS datetime) THEN impg.address1 END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN imppat.firstname <> impg.firstname AND imppat.lastname <> impg.lastname AND 
		  CAST(CAST(imppat.dob AS DATE)AS datetime) <> CAST(CAST(impg.dob AS DATE)AS datetime) THEN impg.address2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN imppat.firstname <> impg.firstname AND imppat.lastname <> impg.lastname AND 
		  CAST(CAST(imppat.dob AS DATE)AS datetime) <> CAST(CAST(impg.dob AS DATE)AS datetime) THEN impg.city END , -- ResponsibleCity - varchar(128)
          CASE WHEN imppat.firstname <> impg.firstname AND imppat.lastname <> impg.lastname AND 
		  CAST(CAST(imppat.dob AS DATE)AS datetime) <> CAST(CAST(impg.dob AS DATE)AS datetime) THEN LEFT(impg.state , 2) END , -- ResponsibleState - varchar(2)
          CASE WHEN imppat.firstname <> impg.firstname AND imppat.lastname <> impg.lastname AND 
		  CAST(CAST(imppat.dob AS DATE)AS datetime) <> CAST(CAST(impg.dob AS DATE)AS datetime) THEN
				CASE WHEN LEN(impg.zipcode) IN (5,9) THEN impg.zipcode
					 WHEN LEN(impg.zipcode) IN (4,8) THEN '0' + impg.zipcode
					 ELSE '' END END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          1 , -- PrimaryProviderID - int
          emp.EmployerID , -- EmployerID - int
          imppat.chartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(imppat.other , 10) , -- MobilePhone - varchar(10)
          imppat.patientuid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE WHEN ISDATE(imppat.deceased) = 1 THEN 0 ELSE 1 END , -- Active - bit
          CASE WHEN imppat.email <> '' THEN 1 ELSE 0 END -- SendEmailCorrespondence - bit
FROM dbo._import_1_1_PatientDemographic imppat
LEFT JOIN dbo.Employers AS emp ON
	emp.EmployerName = imppat.employer
LEFT JOIN dbo.[_import_1_1_Guarantor] AS impg ON
	impg.responsiblepartyuid = imppat.responsiblepartyfid
WHERE imppat.firstname <> '' AND imppat.lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Alert...'
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
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT DISTINCT
		  pat.PatientID , -- PatientID - int
          impPA.memotext , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_1_1_PatientAlert] AS impPA
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = impPA.patientfid AND
	pat.VendorImportID = @VendorImportID
WHERE impPA.memotext <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Patient Journal Note...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          Hidden ,
          NoteMessage ,
          AccountStatus ,
          NoteTypeCode ,
          LastNote
        )
SELECT DISTINCT
		  GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.PatientID , -- PatientID - int
          'Kareo Import' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          impPN.note , -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_1_1_PatientNote] AS impPN
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = impPN.patientfid AND
	pat.VendorImportID = @VendorImportID
WHERE impPN.note <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Patient Case...'
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
          VendorImportID ,
          StatementActive ,
          EPSDTCodeID ,
		  ShowExpiredInsurancePolicies
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- StatementActive - bit
          1 , -- EPSDTCodeID - int
		  1 -- ShowExpiredInsurancePolicies - bit
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Insurance Policy...'
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
          HolderThroughEmployer ,
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
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          impPI.sequencenumber , -- Precedence - int
          impPI.subscriberidnumber , -- PolicyNumber - varchar(32)
          impPI.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(impPI.effectivestartdate) = 1 THEN impPI.effectivestartdate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(impPI.effectiveenddate) = 1 THEN impPI.effectiveenddate ELSE NULL END , -- PolicyEndDate - datetime
          CASE impPI.relationshippatienttosubscriber WHEN 1 THEN 'S'
													 WHEN 2 THEN 'U'
													 WHEN 3 THEN 'C'
													 WHEN 4 THEN 'O'
													 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN impG.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN impG.middlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN impG.lastname END , -- HolderLastName - varchar(64)
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN impg.suffix END , -- HolderSuffix - varchar(16)
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN CASE WHEN ISDATE(impg.dob) = 1 THEN impg.dob ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN CASE WHEN LEN(impg.ssn) >= 6 THEN RIGHT('000' + impg.ssn, 9) ELSE '' END END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN CASE impg.gender WHEN 'M' THEN 'M'
																							 WHEN 'F' THEN 'F'
																							 ELSE 'U' END END , -- HolderGender - char(1)
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN impG.address1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN impG.address2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN impG.city END , -- HolderCity - varchar(128)
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN LEFT(impg.state , 2) END , -- HolderState - varchar(2)
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN CASE WHEN LEN(impG.zipcode) IN (5,9) THEN impG.zipcode
																				 WHEN LEN(impG.zipcode) IN (4,8) THEN '0' + impG.zipcode
																				 ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN LEFT(impG.homephone , 10) END , -- HolderPhone - varchar(10)
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN impPI.subscriberidnumber END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          impPI.copaydollaramount , -- Copay - money
          impPI.annualdeductible , -- Deductible - money
          CASE WHEN impPI.relationshippatienttosubscriber NOT IN (1,0) THEN impPI.subscriberidnumber END , -- PatientInsuranceNumber - varchar(32)
          CASE WHEN impPI.active <> 0 THEN 1 ELSE 0 END  , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PolicyInformation] AS impPI
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = impPI.patientfid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.VendorID = impPI.carrierfid AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_Guarantor] AS impG ON
	impg.responsiblepartyuid = impPI.responsiblepartysubscriberfid
WHERE impPI.carrierfid <> '' AND impPI.subscriberidnumber <> '' AND impPI.sequencenumber <> 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
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
--COMMIT

