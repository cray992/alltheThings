USE superbill_65584_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--ALTER TABLE dbo.Appointment ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentReason ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentToResource ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentToAppointmentReason ADD vendorimportid INT
--ALTER TABLE dbo._import_1_1_patientappointments ADD name VARCHAR(50)
--ALTER TABLE dbo.ContractsAndFees_StandardFeeScheduleLink ADD vendorimportid INT 
--ALTER TABLE dbo.ContractsAndFees_StandardFeeSchedule ADD vendorimportid INT 
--ALTER TABLE dbo.ContractsAndFees_StandardFee ADD vendorimportid INT 

DECLARE @sourcepracticeID INT 
DECLARE @targetPracticeID INT
DECLARE @VendorImportID INT

SET @sourcepracticeID = 2
SET @targetPracticeID = 1
SET @VendorImportID = 9

PRINT 'PracticeID = ' + CAST(@targetPracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @targetpracticeid AND VendorImportID = @VendorImportID
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.PracticeToInsuranceCompany WHERE InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID)
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Practice to Insurance Company records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @targetpracticeid AND VendorImportID = @VendorImportID)
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @targetpracticeid AND VendorImportID = @VendorImportID
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @targetpracticeid AND VendorImportID = @VendorImportID)
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @targetpracticeid)
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @targetpracticeid AND VendorImportID = @VendorImportID
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @targetpracticeid AND VendorImportID = @VendorImportID
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @targetpracticeid))
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment to Appointment Resource records deleted'
--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @targetpracticeid))
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment to Appointment Reason Resource records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @targetpracticeid)
--PRINT '††† ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'

SET IDENTITY_INSERT dbo.InsuranceCompany ON 

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyID, 
		  InsuranceCompanyName ,
          AddressLine1 ,
		  AddressLine2 ,
          City ,
          State ,
          --Country ,
          ZipCode ,
          ContactFirstName ,
          ContactLastName ,
          Phone ,
          --PhoneExt ,
          Fax ,
          --FaxExt ,
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
          InstitutionalBillingFormID ,
		  ClearinghousePayerID
        )
SELECT DISTINCT
		  i.insurancecompanyid, 
          i.name , -- InsuranceCompanyName - varchar(128)
          i.addressline1 , -- AddressLine1 - varchar(256)
		  i.addressline2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.State , -- State - varchar(2)
          --i.country , -- Country - varchar(32)
		  LEFT(CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (5,9) 
			THEN dbo.fn_RemoveNonNumericCharacters(i.zipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) = 4 
			THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zipcode)
			ELSE '' END,9) , -- ZipCode - varchar(9)
          i.contactfirstname , -- ContactFirstName - varchar(64)
          i.contactlastname , -- ContactLastName - varchar(64)
		  CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.contactphone)) >= 10 
			THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.contactphone),10)
			ELSE '' END , -- HomePhone - varchar(10)
          --i.phoneext , -- PhoneExt - varchar(10)
		  CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.contactfax)) >= 10 
			THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.contactfax),10)
			ELSE '' END , -- HomePhone - varchar(10)
          --i.faxext , -- FaxExt - varchar(10)
          '', --i.autobillssecondaryinsurance , -- BillSecondaryInsurance - bit
		  1 , -- EClaimsAccepts - bit ,
          19 , -- BillingFormID - int
		  'CI',--CASE WHEN ip.insuranceprogramcode IS NULL THEN 'CI' ELSE ip.InsuranceProgramCode END , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @targetPracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          19 , -- SecondaryPrecedenceBillingFormID - int
          i.insurancecompanyid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          19 ,  -- InstitutionalBillingFormID - int
		  '' --i.clearinghousepayerid
		  --SELECT * 
FROM _import_1_1_InsuranceCOMPANY i

PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

SET IDENTITY_INSERT dbo.InsuranceCompany OFF 

SET IDENTITY_INSERT dbo.InsuranceCompanyPlan ON 

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( 
		  InsuranceCompanyplanID,
		  PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          --Country ,
          ZipCode ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          Phone ,
          PhoneExt ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  ip.insurancecompanyplanid, 
		  ip.planname , -- PlanName - varchar(128)
          ip.addressline1 , -- AddressLine1 - varchar(256)
          ip.addressline2 , -- AddressLine2 - varchar(256)
          ip.city , -- City - varchar(128)
          ip.state , -- State - varchar(2)
          --ip. , -- Country - varchar(32)
		  LEFT(CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.zipcode)) IN (5,9) 
			THEN dbo.fn_RemoveNonNumericCharacters(ip.zipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.zipcode)) = 4 
			THEN '0' + dbo.fn_RemoveNonNumericCharacters(ip.zipcode)
			ELSE '' END,9) , -- ZipCode - varchar(9)
          ip.contactfirstname , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          ip.contactlastname , -- ContactLastName - varchar(64)
		  CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.contactphone)) >= 10 
			THEN LEFT(dbo.fn_RemoveNonNumericCharacters(ip.contactphone),10)
			ELSE '' END , -- HomePhone - varchar(10)
          ip.contactphoneext , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @targetPracticeID , -- CreatedPracticeID - int
          ip.contactfax , -- Fax - varchar(10)
          ip.contactfaxext , -- FaxExt - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ip.createdpracticeid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
		  --SELECT * 
FROM dbo.[_import_1_1_InsuranceCOMPANYPLAN] ip
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.InsuranceCompanyID = ip.insurancecompanyid AND 
	VendorImportID = @VendorImportID AND 
	ic.CreatedPracticeID = @targetpracticeid
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

SET IDENTITY_INSERT dbo.InsuranceCompanyPlan OFF 

--UPDATE a SET 
--a.planname = 'Anthem Blue Cross 3'
----SELECT * 
--FROM dbo._import_1_1_InsuranceCompanyPlan a 
--WHERE a.insurancecompanyplanid = 1047

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( 
		  PracticeID ,
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
          --ResponsiblePrefix ,
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
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          --EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt 
        )
		
SELECT DISTINCT
		  @targetPracticeID , -- PracticeID - int
          rp.DoctorID , -- ReferringPhysicianID - int
          '', --i.prefix , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          '',  --i.middlename , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          i.suffix , -- Suffix - varchar(16)
          i.addressline1 , -- AddressLine1 - varchar(256)
          i.addressline2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.State , -- State - varchar(2)
          '' , -- Country - varchar(32)
		  LEFT(CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (5,9) 
			THEN dbo.fn_RemoveNonNumericCharacters(i.zipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) = 4 
			THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zipcode)
			ELSE '' END,9) , -- ZipCode - varchar(9)
          --i.zipcode , -- ZipCode - varchar(9)
		  CASE WHEN i.gender = 'Female' THEN 'F'
			   WHEN i.gender = 'Male' THEN 'M' 
			   ELSE '' END ,
          --i.gender , -- Gender - varchar(1)
          CASE i.maritalstatus WHEN 'Anulled' THEN 'A'
							   WHEN 'Divorced' THEN 'D'
							   WHEN 'Domestic Partner' THEN 'T'
							   WHEN 'Interlocutory' THEN 'I'
							   WHEN 'Legally Separated' THEN 'L'
							   WHEN 'Married' THEN 'M'
							   WHEN 'Never Married' THEN 'S'
							   WHEN 'Widowed' THEN 'W' ELSE '' END  , -- MaritalStatus - varchar(1)
		  CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.homephone)) >= 10 
			THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.homephone),10)
			ELSE '' END , -- HomePhone - varchar(10)
          --i.homephone , -- HomePhone - varchar(10)
          '', --i.phon , -- HomePhoneExt - varchar(10)
		  CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.workphone)) >= 10 
			THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.workphone),10)
			ELSE '' END , -- HomePhone - varchar(10)
          --i.workphone , -- WorkPhone - varchar(10)
          '', --i.workphoneext , -- WorkPhoneExt - varchar(10)
          CAST(i.dateofbirth AS DATETIME) , -- DOB - datetime
		  CASE
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.SSN), 9)
			ELSE NULL END , -- SSN - char(9)
          --i.ssn , -- SSN - char(9)
          i.emailaddress , -- EmailAddress - varchar(256)
          CASE WHEN i.guarantorlastname <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          --CASE WHEN i.res <> '' THEN i.guarantorprefix END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorfirstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN i.guarantormiddlename <> '' THEN i.guarantormiddlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN i.guarantorlastname <> '' THEN i.guarantorlastname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN i.guarantorsuffix <> '' THEN i.guarantorsuffix END , -- ResponsibleSuffix - varchar(16)
          CASE i.guarantorrelationshiptopatient WHEN 'Other' THEN 'O'
												WHEN 'Spouse' THEN 'U'
												WHEN 'Child' THEN 'C'
												ELSE 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantoraddressline1 END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantoraddressline2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorcity END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorstate END , -- ResponsibleState - varchar(2)
          CASE WHEN i.guarantorfirstname <> '' THEN '' END , --  - varchar(32)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorzip END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE i.employmentstatus WHEN 'Employed' THEN 'E'
							      WHEN 'Retired' THEN 'R'
								  WHEN 'Unknown' THEN 'U' ELSE 'U' END , -- EmploymentStatus - char(1)
          pcp.DoctorID , -- PrimaryProviderID - int
          NULL, --tsl.slID , -- DefaultServiceLocationID - int
          --te.EmpID , -- EmployerID - int
          '' , -- MedicalRecordNumber - varchar(128)
		  CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.mobilephone)) >= 10 
			THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.mobilephone),10)
			ELSE '' END , -- HomePhone - varchar(10)
          --i.cellphone , -- MobilePhone - varchar(10)
          '', -- , -- MobilePhoneExt - varchar(10)
          i.id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE i.active WHEN 'FALSE' THEN 0 WHEN 'TRUE' THEN 1 ELSE 1 END , -- Active - bit
          '', --CASE i. WHEN 'FALSE' THEN 0 WHEN 'TRUE' THEN 1 ELSE 0 END , -- SendEmailCorrespondence - bit
          i.emergencyname , -- EmergencyName - varchar(128)
          i.emergencyphone , -- EmergencyPhone - varchar(10)
          i.emergencyphoneext  -- EmergencyPhoneExt - varchar(10)
		  --SELECT  * 
FROM dbo.[_import_1_1_PatientDemographics] i
LEFT JOIN dbo.Doctor rp ON
	rp.LastName = i.lastname AND 
	rp.PracticeID = 1
LEFT JOIN dbo.Doctor pcp ON
	pcp.LastName = i.lastname AND
	pcp.PracticeID = 1
--LEFT JOIN patient p ON 
--	p.LastName = i.lastname AND 
--	p.FirstName = i.firstname 
WHERE 
--p.LastName IS NULL 
NOT EXISTS(
	SELECT * FROM dbo.Patient pd WHERE pd.PracticeID = 1 AND 
	pd.LastName = i.lastname AND pd.FirstName = i.firstname
	)

PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
		  Name, 
          Active ,
          PayerScenarioID ,
		  --financialclass, 
		  ReferringPhysicianID, 
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
          VendorID ,
          VendorImportID ,
          PregnancyRelatedFlag ,
          StatementActive ,
          EPSDT ,
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag
        )
SELECT DISTINCT	
p.PatientID ,
ci.defaultcasename,
1 ,
ps.PayerScenarioID ,
NULL,--d.DoctorID ,
0,--,pc.employmentrelatedflag ,
0,--pc.autoaccidentrelatedflag ,
0,--pc.otheraccidentrelatedflag ,
0,--pc.abuserelatedflag ,
0,--pc.AutoAccidentRelatedState ,
NULL, --pc.Notes ,
0,--pc.showexpiredinsurancepolicies ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
@TargetPracticeID ,
pc.id, -- VendorID
@VendorImportID , -- VenorID
0,--pc.pregnancyrelatedflag ,
1,--pc.statementactive ,
0,--pc.epsdt ,
NULL,--pc.epsdtcodeid ,
0,--pc.emergencyrelated ,
0--pc.homeboundrelatedflag
	--SELECT * 
FROM dbo._import_1_1_patientDemographics pc
INNER JOIN dbo.Patient p ON
pc.id = p.VendorID AND
p.VendorImportID = @VendorImportID
INNER JOIN dbo._import_1_1_CaseInformation ci ON 
ci.patientid = p.VendorID
INNER JOIN dbo.PayerScenario ps ON 
ps.Name = ci.defaultcasepayerscenario


PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--rollback
PRINT ''
PRINT 'Inserting into Primary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
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
          HolderZipCode ,
          DependentPolicyNumber ,
          Notes ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT 
		  pc.PatientCaseID , -- PatientCaseID - int
          ip.primaryinsurancepolicycompanyplanid , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          ip.primaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          LEFT(ip.primaryinsurancepolicygroupnumber,32) , -- GroupNumber - varchar(32)
		  GETDATE(),		--CASE WHEN ISDATE(i.) = 1 THEN i.primaryinsurancepolicyeffectivestartdate
		      --ELSE NULL END , -- PolicyStartDate - datetime
          CASE ip.guarantorrelationshiptopatient WHEN 'O' THEN 'O'
			   WHEN 'U' THEN 'U'
			   WHEN 'C' THEN 'C'
			   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.guarantorfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN '' END , -- HolderSuffix - varchar(16)
      --         CASE WHEN ISDATE(i.holder1dateofbirth) = 1 THEN i.holder1dateofbirth
			   --ELSE NULL END 
		  '', -- HolderDOB - datetime
          '', --CASE WHEN LEN(i.primaryinsurancepolicyinsuredsocialsecuritynumber) >= 6 THEN RIGHT('000' + i.primaryinsurancepolicyinsuredsocialsecuritynumber , 9)
			  --ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
	
          CASE WHEN ip.gender IN ('F','FEMALE') THEN 'F'
			   WHEN ip.gender IN ('M','MALE') THEN 'M'
			   ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.guarantoraddressline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.addressline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.guarantorcity END , -- HolderCity - varchar(128)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.guarantorstate END , -- HolderState - varchar(2)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN (CASE WHEN LEN(ip.guarantorzip) IN (5,9) THEN ip.guarantorzip
		       WHEN LEN(ip.guarantorzip) IN (4,8) THEN '0' + ip.guarantorzip
			   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.primaryinsurancepolicynumber END , -- DependentPolicyNumber - varchar(32)
          ip.primaryinsurancepolicyinsurednotes , -- Notes - text
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.primaryinsurancepolicynumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @targetpracticeid , -- PracticeID - int
          ip.id , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
 --select * 
FROM dbo._import_1_1_PatientDemographics ip
    INNER JOIN dbo._import_1_1_InsuranceCOMPANYPLAN icpl
        ON ip.primaryinsurancepolicycompanyplanid = icpl.insurancecompanyplanid
    INNER JOIN dbo.PatientCase pc
        ON ip.id = pc.VendorID
           AND pc.VendorImportID = @VendorImportID
    INNER JOIN dbo.InsuranceCompanyPlan icp
        ON icpl.planname = icp.PlanName
           AND icp.CreatedPracticeID = @TargetPracticeID
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
           AND ipo.PracticeID = @TargetPracticeID
           AND ipo.PatientCaseID = pc.PatientCaseID
           AND ip.primaryinsurancepolicynumber = ipo.PolicyNumber
WHERE ipo.InsurancePolicyID IS NULL;

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--SELECT * FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = 1 AND VendorImportID = 9

PRINT ''
PRINT 'Inserting into InsurancePolicy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
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
          HolderZipCode ,
          DependentPolicyNumber ,
          Notes ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT 
		  pc.PatientCaseID , -- PatientCaseID - int
          ip.secondaryinsurancepolicycompanyplanid , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          ip.secondaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          LEFT(ip.secondaryinsurancepolicygroupnumber,32) , -- GroupNumber - varchar(32)
		  GETDATE(),		--CASE WHEN ISDATE(i.) = 1 THEN i.primaryinsurancepolicyeffectivestartdate
		      --ELSE NULL END , -- PolicyStartDate - datetime
          CASE ip.guarantorrelationshiptopatient WHEN 'O' THEN 'O'
			   WHEN 'U' THEN 'U'
			   WHEN 'C' THEN 'C'
			   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.guarantorfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN '' END , -- HolderSuffix - varchar(16)
      --         CASE WHEN ISDATE(i.holder1dateofbirth) = 1 THEN i.holder1dateofbirth
			   --ELSE NULL END 
		  '', -- HolderDOB - datetime
          '', --CASE WHEN LEN(i.primaryinsurancepolicyinsuredsocialsecuritynumber) >= 6 THEN RIGHT('000' + i.primaryinsurancepolicyinsuredsocialsecuritynumber , 9)
			  --ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
	
          CASE WHEN ip.gender IN ('F','FEMALE') THEN 'F'
			   WHEN ip.gender IN ('M','MALE') THEN 'M'
			   ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.guarantoraddressline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.addressline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.guarantorcity END , -- HolderCity - varchar(128)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.guarantorstate END , -- HolderState - varchar(2)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN (CASE WHEN LEN(ip.guarantorzip) IN (5,9) THEN ip.guarantorzip
		       WHEN LEN(ip.guarantorzip) IN (4,8) THEN '0' + ip.guarantorzip
			   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.secondaryinsurancepolicynumber END , -- DependentPolicyNumber - varchar(32)
          ip.secondaryinsurancepolicyinsurednotes , -- Notes - text
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.secondaryinsurancepolicynumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @targetpracticeid , -- PracticeID - int
          ip.id , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
 --select * 
FROM dbo._import_1_1_PatientDemographics ip
    INNER JOIN dbo._import_1_1_InsuranceCOMPANYPLAN icpl
        ON ip.secondaryinsurancepolicycompanyplanid = icpl.insurancecompanyplanid
    INNER JOIN dbo.PatientCase pc
        ON ip.id = pc.VendorID
           AND pc.VendorImportID = @VendorImportID
    INNER JOIN dbo.InsuranceCompanyPlan icp
        ON icpl.planname = icp.PlanName
           AND icp.CreatedPracticeID = @TargetPracticeID
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
           AND ipo.PracticeID = @TargetPracticeID
           AND ipo.PatientCaseID = pc.PatientCaseID
           AND ip.secondaryinsurancepolicynumber = ipo.PolicyNumber
WHERE ipo.InsurancePolicyID IS NULL;

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--rollback

PRINT ''
PRINT 'Inserting into Tertiary Insurance Policy 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
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
          HolderZipCode ,
          DependentPolicyNumber ,
          Notes ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT 
		  pc.PatientCaseID , -- PatientCaseID - int
          ip.tertiaryinsurancepolicycompanyplanid , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          ip.tertiaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          LEFT(ip.tertiaryinsurancepolicygroupnumber,32) , -- GroupNumber - varchar(32)
		  GETDATE(),		--CASE WHEN ISDATE(i.) = 1 THEN i.primaryinsurancepolicyeffectivestartdate
		      --ELSE NULL END , -- PolicyStartDate - datetime
          CASE ip.guarantorrelationshiptopatient WHEN 'O' THEN 'O'
			   WHEN 'U' THEN 'U'
			   WHEN 'C' THEN 'C'
			   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.guarantorfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN '' END , -- HolderSuffix - varchar(16)
      --         CASE WHEN ISDATE(i.holder1dateofbirth) = 1 THEN i.holder1dateofbirth
			   --ELSE NULL END 
		  '', -- HolderDOB - datetime
          '', --CASE WHEN LEN(i.primaryinsurancepolicyinsuredsocialsecuritynumber) >= 6 THEN RIGHT('000' + i.primaryinsurancepolicyinsuredsocialsecuritynumber , 9)
			  --ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
	
          CASE WHEN ip.gender IN ('F','FEMALE') THEN 'F'
			   WHEN ip.gender IN ('M','MALE') THEN 'M'
			   ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.guarantoraddressline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.addressline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.guarantorcity END , -- HolderCity - varchar(128)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.guarantorstate END , -- HolderState - varchar(2)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN (CASE WHEN LEN(ip.guarantorzip) IN (5,9) THEN ip.guarantorzip
		       WHEN LEN(ip.guarantorzip) IN (4,8) THEN '0' + ip.guarantorzip
			   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.tertiaryinsurancepolicynumber END , -- DependentPolicyNumber - varchar(32)
          ip.tertiaryinsurancepolicyinsurednotes , -- Notes - text
          CASE WHEN ip.guarantorrelationshiptopatient <> 'S' THEN ip.tertiaryinsurancepolicynumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @targetpracticeid , -- PracticeID - int
          ip.id , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
 --select * 
FROM dbo._import_1_1_PatientDemographics ip
    INNER JOIN dbo._import_1_1_InsuranceCOMPANYPLAN icpl
        ON ip.tertiaryinsurancepolicycompanyplanid = icpl.insurancecompanyplanid
    INNER JOIN dbo.PatientCase pc
        ON ip.id = pc.VendorID
           AND pc.VendorImportID = @VendorImportID
    INNER JOIN dbo.InsuranceCompanyPlan icp
        ON icpl.planname = icp.PlanName
           AND icp.CreatedPracticeID = @TargetPracticeID
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
           AND ipo.PracticeID = @TargetPracticeID
           AND ipo.PatientCaseID = pc.PatientCaseID
           AND ip.tertiaryinsurancepolicynumber = ipo.PolicyNumber
WHERE ipo.InsurancePolicyID IS NULL;

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into ServiceLocation...'
INSERT INTO dbo.ServiceLocation
(
    PracticeID,
    Name,
    AddressLine1,
    AddressLine2,
    City,
    State,
    Country,
    ZipCode,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    PlaceOfServiceCode,
    BillingName,
    Phone,
    PhoneExt,
    FaxPhone,
    FaxPhoneExt,
    HCFABox32FacilityID,
    CLIANumber,
    RevenueCode,
    VendorImportID,
    VendorID,
    NPI,
    FacilityIDType,
    TimeZoneID,
    PayToName,
    PayToAddressLine1,
    PayToAddressLine2,
    PayToCity,
    PayToState,
    PayToCountry,
    PayToZipCode,
    PayToPhone,
    PayToPhoneExt,
    PayToFax,
    PayToFaxExt,
    EIN,
    BillTypeID
)
SELECT DISTINCT 
    @targetPracticeID,         -- PracticeID - int
    sl.Name,        -- Name - varchar(128)
    sl.addressline1,        -- AddressLine1 - varchar(256)
    sl.addressline2,        -- AddressLine2 - varchar(256)
    sl.city,        -- City - varchar(128)
    sl.state,        -- State - varchar(2)
    sl.country,        -- Country - varchar(32)
    sl.zipcode,        -- ZipCode - varchar(9)
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    sl.PlaceOfServiceCode,        -- PlaceOfServiceCode - char(2)
    sl.BillingName,        -- BillingName - varchar(128)
    sl.Phone,        -- Phone - varchar(10)
    sl.PhoneExt,        -- PhoneExt - varchar(10)
    sl.FaxPhone,        -- FaxPhone - varchar(10)
    sl.FaxPhoneExt,        -- FaxPhoneExt - varchar(10)
    NULL ,         -- HCFABox32FacilityID - varchar(50)
    NULL ,        -- CLIANumber - varchar(30)
    sl.RevenueCode,        -- RevenueCode - varchar(4)
    @VendorImportID,         -- VendorImportID - int
    NULL ,         -- VendorID - int
    sl.NPI,        -- NPI - varchar(10)
    sl.FacilityIDType,         -- FacilityIDType - int
    sl.TimeZoneID,         -- TimeZoneID - int
    NULL ,        -- PayToName - varchar(60)
    '',        -- PayToAddressLine1 - varchar(256)
    '',        -- PayToAddressLine2 - varchar(256)
    '',        -- PayToCity - varchar(128)
    '',        -- PayToState - varchar(2)
    '',        -- PayToCountry - varchar(32)
    '',        -- PayToZipCode - varchar(9)
    NULL ,        -- PayToPhone - varchar(10)
    NULL ,        -- PayToPhoneExt - varchar(10)
    NULL ,        -- PayToFax - varchar(10)
    NULL ,        -- PayToFaxExt - varchar(10)
    NULL ,        -- EIN - varchar(9)
    NULL          -- BillTypeID - int
     
--SELECT * 

FROM dbo.ServiceLocation sl 
WHERE sl.PracticeID = @targetPracticeID;

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';

----commit
----rollback 
----------------------------------------------------------------------------
------Appointments

--UPDATE i SET 
--i.name = sl.Name
----SELECT * 
--FROM dbo.ServiceLocation sl 
--	INNER JOIN dbo._import_1_1_PatientAppointments i ON
--		i.servicelocationid = sl.ServiceLocationID

--UPDATE i SET 
--i.servicelocationid = sl.ServiceLocationID
----SELECT distinct * 
--FROM dbo.ServiceLocation sl 
--	INNER JOIN dbo._import_1_1_PatientAppointments i ON
--		i.name = sl.Name
--WHERE sl.PracticeID = @targetPracticeID

--SELECT * FROM servicelocation

--PRINT ''
--PRINT 'Inserting Into Appointments...'
--INSERT INTO dbo.Appointment
--        ( PatientID,
--          PracticeID ,
--          ServiceLocationID ,
--          StartDate ,
--          EndDate ,
--          AppointmentType ,
--          Subject ,
--          Notes ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          AppointmentResourceTypeID ,
--          AppointmentConfirmationStatusCode ,
--		  Recurrence,
--          StartDKPracticeID ,
--          EndDKPracticeID ,
--          StartTm ,
--          EndTm,
--		  vendorimportid
--        )
--		--SELECT * FROM dbo.Appointment WHERE PracticeID =8
--		--SELECT * FROM dbo.ServiceLocation WHERE PracticeID =8
--SELECT DISTINCT
--		  p.PatientID,
--          @targetPracticeID , -- PracticeID - int
		  
--		  --CASE 
--		  --WHEN i.servicelocationname = 'Southwest ENT Consultant' THEN 407
--		  --WHEN i.servicelocationname = 'Sierra Medical Center Hospital' THEN 427
--		  --WHEN i.servicelocationname = 'Providence Memorial Hospital' THEN 426
--		  --WHEN i.servicelocationname = 'Las Palmas Hospital' THEN 425
--		  --WHEN i.servicelocationname = 'El Paso Day Surgery' THEN 442
--		  --WHEN i.servicelocationname = 'Del Sol Medical Center Hospital' THEN 423
--		  --WHEN i.servicelocationname = 'El Paso Childrens Hospital' THEN 422
--		  --ELSE '287' END ,
--		  1,  -- ServiceLocationID - int
--          i.startdate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentstarttime , -- StartDate - datetime
--          i.enddate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentendtime,  -- EndDate - datetime
--          'P' , -- AppointmentType - varchar(1)
--          '' , -- Subject - varchar(64)
--          i.note , -- Notes - text
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          1 , -- AppointmentResourceTypeID - int
--		  --AppointmentConfirmationStatusCode,
--          CASE i.status
--			WHEN 'Check-Out' THEN 'O'
--			WHEN 'Confirmed' THEN 'C'
--			WHEN 'Check-In' THEN 'I'
--			WHEN 'Scheduled' THEN 'S'
--			ELSE'S' END , -- AppointmentConfirmationStatusCode - char(1)
--		  0,
--          dk.DKPracticeID , -- StartDKPracticeID - int
--          dk.DKPracticeID , -- EndDKPracticeID - int
--          CAST(LEFT(REPLACE(CAST(i.startdate AS TIME),':',''),4) AS SMALLINT), -- StartTm - smallint
--          CAST(LEFT(REPLACE(CAST(i.enddate AS TIME),':',''),4) AS SMALLINT),  -- EndTm - smallint
--		  @VendorImportID
		
--		  --SELECT distinct i.*
--FROM dbo._import_1_1_PatientAppointments i 
--	INNER JOIN dbo._import_1_1_PatientDemographics d ON 
--		d.chartnumber = i.chartnumber
--	INNER JOIN dbo.Patient p ON 
--		d.lastname = p.LastName AND 
--		d.firstname = p.FirstName AND 
--		p.PracticeID = @targetPracticeID
--	INNER JOIN dbo.DateKeyToPractice DK ON
--		DK.PracticeID = 1 AND
--		DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
--WHERE p.PracticeID = @targetPracticeID
--		--AND p.lastname = 'ordaz'
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT ''
--PRINT 'Inserting Into Appointment to Resource...'
--INSERT INTO dbo.AppointmentToResource
--        ( AppointmentID ,
--          AppointmentResourceTypeID ,
--          ResourceID ,
--          ModifiedDate ,
--          PracticeID,
--		  vendorimportid
--        )
--		--SELECT * FROM dbo.PracticeResource WHERE PracticeID = 61
--SELECT DISTINCT	
--		  a.AppointmentID , -- AppointmentID - int
--		  1, -- AppointmentResourceTypeID - int
--			CASE 
--				WHEN i.doctorfirstname = 'LUDMILA' THEN 1
--				WHEN i.doctorfirstname = 'ZOYA' THEN 4
--				WHEN i.doctorfirstname = 'OLEG' THEN 5
--				WHEN i.doctorfirstname = 'CARLA' THEN 6
--			ELSE '18' END ,
--		  --195,
--          GETDATE(),  -- ModifiedDate - datetime
--          @targetPracticeID,  -- PracticeID - int
--		  @VendorImportID
		
--	--SELECT i.*
--FROM dbo._import_1_1_PatientAppointments i 
--	INNER JOIN dbo._import_1_1_PatientDemographics d ON 
--		d.chartnumber = i.chartnumber
--	INNER JOIN dbo.Patient p ON 
--		d.lastname = p.LastName AND 
--		d.firstname = p.FirstName AND 
--		--CAST(d.dateofbirth AS DATE) = CAST(p.DOB AS DATE) AND 
--		p.PracticeID = @targetPracticeID 		
--	INNER JOIN dbo.Appointment a ON 
--		a.PatientID = p.PatientID AND 
--		a.StartDate = i.startdate AND 
--		a.EndDate = i.enddate AND 
--		a.PracticeID = @targetPracticeID
--WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())

--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Appointment Reasons...'


--INSERT INTO dbo.AppointmentReason
--(
--    PracticeID,
--    Name,
--    DefaultDurationMinutes,
--    DefaultColorCode,
--    Description,
--    ModifiedDate,
--	vendorimportid

--)
--SELECT DISTINCT	
--    @targetPracticeID,         -- PracticeID - int
--    ip.reasons,        -- Name - varchar(128)
--    DATEDIFF(MINUTE,ip.startdate,ip.enddate),         -- DefaultDurationMinutes - int
--    null,      -- DefaultColorCode - int
--    ip.reasons,        -- Description - varchar(256)
--    GETDATE(), -- ModifiedDate - datetime
--	@VendorImportID
--	--SELECT *
--FROM dbo._import_1_1_PatientAppointments ip
--LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.reasons
----AND ar.PracticeID = 8
--WHERE ar.name IS NULL 


--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
----SELECT * FROM dbo.Appointmentreason WHERE PracticeID = 8

--PRINT''
--PRINT'Inserting into Appointment to Appointment Reasons...'

--INSERT INTO dbo.AppointmentToAppointmentReason
--(
--    AppointmentID,
--    AppointmentReasonID,
--    PrimaryAppointment,
--    ModifiedDate,
--    PracticeID,
--	vendorimportid
--)

--SELECT DISTINCT a.AppointmentID, 
--MIN(ar.AppointmentReasonID) AS AppointmentReasonID, 
--1 ,
--GETDATE() ,
--@targetPracticeID,
--@VendorImportID
----select * 
--FROM dbo._import_1_1_PatientAppointments iapt
--	INNER JOIN dbo._import_1_1_PatientDemographics pd ON 
--		pd.chartnumber = iapt.chartnumber
--	INNER JOIN dbo.AppointmentReason ar ON 
--		ar.Name = iapt.reasons AND 
--		ar.PracticeID = 1
--	INNER JOIN dbo.Patient p ON 
--		--pd.chartnumber = p.medicalrecordnumber
--		p.LastName = pd.lastname AND 
--        p.FirstName = pd.firstname
--	INNER JOIN dbo.Appointment a ON 
--		a.PatientID = p.PatientID AND 
--		CAST(a.StartDate AS DATETIME) = CAST(iapt.startdate AS DATETIME) AND 
--		CAST(a.EndDate AS DATETIME) = CAST(iapt.enddate AS DATETIME) AND 
--		a.PracticeID = 1    --CONVERT(VARCHAR,CAST(iapt.appointmentdate AS DATETIME),120)+ CAST(iapt.appointmentstarttime AS DATETIME)
--WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())
--GROUP BY a.AppointmentID

--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--rollback
--commit


--PRINT''
--PRINT'Insert Into ContractsAndFees_StandardFeeSchedule...'
--INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
--(
--    PracticeID,
--    Name,
--    Notes,
--    EffectiveStartDate,
--    SourceType,
--    SourceFileName,
--    EClaimsNoResponseTrigger,
--    PaperClaimsNoResponseTrigger,
--    MedicareFeeScheduleGPCICarrier,
--    MedicareFeeScheduleGPCILocality,
--    MedicareFeeScheduleGPCIBatchID,
--    MedicareFeeScheduleRVUBatchID,
--    AddPercent,
--    AnesthesiaTimeIncrement,
--	vendorimportid
--)
--SELECT DISTINCT 
--    8,         -- PracticeID - int
--    fs.Name,        -- Name - varchar(128)
--    fs.Notes,        -- Notes - varchar(1024)
--    GETDATE(), -- EffectiveStartDate - datetime
--    fs.SourceType,        -- SourceType - char(1)
--    fs.SourceFileName,        -- SourceFileName - varchar(256)
--    fs.EClaimsNoResponseTrigger,         -- EClaimsNoResponseTrigger - int
--    fs.PaperClaimsNoResponseTrigger,         -- PaperClaimsNoResponseTrigger - int
--    fs.MedicareFeeScheduleGPCICarrier,         -- MedicareFeeScheduleGPCICarrier - int
--    fs.MedicareFeeScheduleGPCILocality,         -- MedicareFeeScheduleGPCILocality - int
--    fs.MedicareFeeScheduleGPCIBatchID,         -- MedicareFeeScheduleGPCIBatchID - int
--    fs.MedicareFeeScheduleRVUBatchID,         -- MedicareFeeScheduleRVUBatchID - int
--    fs.AddPercent,      -- AddPercent - decimal(18, 0)
--    fs.AnesthesiaTimeIncrement,          -- AnesthesiaTimeIncrement - int
--    9
--   --select *  
--FROM dbo.ContractsAndFees_StandardFeeSchedule fs
--WHERE fs.PracticeID=1 AND fs.Name = 'Standard Fees 2'
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--PRINT''
--PRINT'Insert Into ContractsAndFees_StandardFee...'
--INSERT INTO dbo.ContractsAndFees_StandardFee
--(
--    StandardFeeScheduleID,
--    ProcedureCodeID,
--    ModifierID,
--    SetFee,
--    AnesthesiaBaseUnits,
--	vendorimportid
--)
--SELECT 
--    12,--(SELECT a.StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule a WHERE a.PracticeID=2 AND a.Name='Standard Fees'),    -- StandardFeeScheduleID - int
--    sf.ProcedureCodeID,    -- ProcedureCodeID - int
--    sf.ModifierID,    -- ModifierID - int
--    sf.SetFee, -- SetFee - money
--    sf.AnesthesiaBaseUnits,     -- AnesthesiaBaseUnits - int
--    9

----select * 
--FROM dbo.ContractsAndFees_StandardFee sf 
--	INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON sfs.StandardFeeScheduleID=sf.StandardFeeScheduleID
--WHERE sf.StandardFeeScheduleID=sfs.StandardFeeScheduleID AND sfs.PracticeID=1

--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--SELECT * FROM dbo.ContractsAndFees_StandardFeeschedulelink WHERE StandardFeeScheduleID = 12

--PRINT''
--PRINT'Insert Into ContractsAndFees_StandardFeeScheduleLink...'

--INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
--(
--    ProviderID,
--    LocationID,
--    StandardFeeScheduleID,
--	vendorimportid
--)
--SELECT DISTINCT 
--    doc.doctorid, -- ProviderID - int
--    sl.ServiceLocationID, -- LocationID - int
--    sfs.StandardFeeScheduleID,  -- StandardFeeScheduleID - int
--    9


--FROM dbo.Doctor doc 
--	INNER JOIN dbo.ServiceLocation sl ON sl.practiceid=doc.PracticeID
--	INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON sfs.PracticeID = 8
--WHERE doc.[External]<>1

--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

------rollback
------commit