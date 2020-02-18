USE superbill_66920_dev
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
--ALTER TABLE dbo._import_3_1_patientappointments ADD name VARCHAR(50)
--ALTER TABLE dbo.ContractsAndFees_StandardFeeScheduleLink ADD vendorimportid INT 
--ALTER TABLE dbo.ContractsAndFees_StandardFeeSchedule ADD vendorimportid INT 
--ALTER TABLE dbo.ContractsAndFees_StandardFee ADD vendorimportid INT 

DECLARE @sourcepracticeID INT 
DECLARE @targetPracticeID INT
DECLARE @VendorImportID INT

SET @sourcepracticeID = 1
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
		  i.insuranceid, 
          i.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
          i.address1 , -- AddressLine1 - varchar(256)
		  i.address2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          s.State , -- State - varchar(2)
          --i.country , -- Country - varchar(32)
		  LEFT(CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) 
			THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) = 4 
			THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
			ELSE '' END,9) , -- ZipCode - varchar(9)
          i.contactfirstname , -- ContactFirstName - varchar(64)
          i.contactlastname , -- ContactLastName - varchar(64)
		  CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) >= 10 
			THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone),10)
			ELSE '' END , -- HomePhone - varchar(10)
          --i.phoneext , -- PhoneExt - varchar(10)
		  CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.fax)) >= 10 
			THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.fax),10)
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
          i.insuranceid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          19 ,  -- InstitutionalBillingFormID - int
		  '' --i.clearinghousepayerid
		  --SELECT * 
FROM _import_3_1_InsuranceCOMPANYPLANList i
	INNER JOIN dbo._import_3_1_PatientDemographics pd ON 
		pd.insurancecode1 = i.insuranceid OR
		pd.insurancecode2 = i.insuranceid
	LEFT JOIN dbo.State s ON 
		s.LongName = i.state

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
		  ip.insuranceid, 
		  ip.planname , -- PlanName - varchar(128)
          ip.address1 , -- AddressLine1 - varchar(256)
          ip.address2 , -- AddressLine2 - varchar(256)
          ip.city , -- City - varchar(128)
          s.state , -- State - varchar(2)
          --ip. , -- Country - varchar(32)
		  LEFT(CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.zip)) IN (5,9) 
			THEN dbo.fn_RemoveNonNumericCharacters(ip.zip)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.zip)) = 4 
			THEN '0' + dbo.fn_RemoveNonNumericCharacters(ip.zip)
			ELSE '' END,9) , -- ZipCode - varchar(9)
          ip.contactfirstname , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          ip.contactlastname , -- ContactLastName - varchar(64)
		  CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.phone)) >= 10 
			THEN LEFT(dbo.fn_RemoveNonNumericCharacters(ip.phone),10)
			ELSE '' END , -- HomePhone - varchar(10)
          ip.phoneext , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @targetPracticeID , -- CreatedPracticeID - int
          ip.fax , -- Fax - varchar(10)
          ip.faxext , -- FaxExt - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ip.insuranceid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
		  --SELECT * 
FROM dbo.[_import_3_1_InsuranceCOMPANYPLANList] ip
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.VendorID = ip.insuranceid AND 
	VendorImportID = @VendorImportID AND 
	ic.CreatedPracticeID = @targetpracticeid
LEFT JOIN state s ON 
	s.LongName = ip.state
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

SET IDENTITY_INSERT dbo.InsuranceCompanyPlan OFF 

INSERT INTO dbo.Doctor
(
    PracticeID,
    Prefix,
    FirstName,
    MiddleName,
    LastName,
    Suffix,
    SSN,
    AddressLine1,
    AddressLine2,
    City,
    State,
    Country,
    ZipCode,
    WorkPhone,
    EmailAddress,
    Notes,
    ActiveDoctor,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    UserID,
    Degree,
    VendorID,
    VendorImportID,
    FaxNumber,
    FaxNumberExt,
    OrigReferringPhysicianID,
    [External],
    NPI,
    ProviderTypeID,
    ProviderPerformanceReportActive,
    ProviderPerformanceScope,
    ProviderPerformanceFrequency,
    ProviderPerformanceDelay,
    ProviderPerformanceCarbonCopyEmailRecipients,
    ExternalBillingID,
    GlobalPayToAddressFlag,
    GlobalPayToName,
    GlobalPayToAddressLine1,
    GlobalPayToAddressLine2,
    GlobalPayToCity,
    GlobalPayToState,
    GlobalPayToZipCode,
    GlobalPayToCountry,
    CreatedFromEhr,
    ActivateAfterWizard,
    KareoSpecialtyId
)
VALUES
(   1,         -- PracticeID - int
    '',        -- Prefix - varchar(16)
    'OLGA',        -- FirstName - varchar(64)
    '',        -- MiddleName - varchar(64)
    'GOLDMAN',        -- LastName - varchar(64)
    '',        -- Suffix - varchar(16)
    '',        -- SSN - varchar(9)
    '5901 W Olympic Blvd',        -- AddressLine1 - varchar(256)
    'Suite 503',        -- AddressLine2 - varchar(256)
    'Los Angeles',        -- City - varchar(128)
    'CA',        -- State - varchar(2)
    '',        -- Country - varchar(32)
    '900364670',        -- ZipCode - varchar(9)
    '3239348877',        -- WorkPhone - varchar(10)
    '',        -- EmailAddress - varchar(256)
    '',        -- Notes - text
    1,      -- ActiveDoctor - bit
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    0,         -- UserID - int
    '',        -- Degree - varchar(8)
    '',        -- VendorID - varchar(50)
    0,         -- VendorImportID - int
    '',        -- FaxNumber - varchar(10)
    '',        -- FaxNumberExt - varchar(10)
    0,         -- OrigReferringPhysicianID - int
    NULL,      -- External - bit
    '',        -- NPI - varchar(10)
    0,         -- ProviderTypeID - int
    NULL,      -- ProviderPerformanceReportActive - bit
    0,         -- ProviderPerformanceScope - int
    '',        -- ProviderPerformanceFrequency - char(1)
    0,         -- ProviderPerformanceDelay - int
    '',        -- ProviderPerformanceCarbonCopyEmailRecipients - varchar(max)
    '',        -- ExternalBillingID - varchar(50)
    NULL,      -- GlobalPayToAddressFlag - bit
    '',        -- GlobalPayToName - varchar(128)
    '',        -- GlobalPayToAddressLine1 - varchar(256)
    '',        -- GlobalPayToAddressLine2 - varchar(256)
    '',        -- GlobalPayToCity - varchar(128)
    '',        -- GlobalPayToState - varchar(2)
    '',        -- GlobalPayToZipCode - varchar(9)
    '',        -- GlobalPayToCountry - varchar(32)
    0,      -- CreatedFromEhr - bit
    0,      -- ActivateAfterWizard - bit
    34          -- KareoSpecialtyId - int
    )

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
          i.address1 , -- AddressLine1 - varchar(256)
          i.address2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          s.State , -- State - varchar(2)
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
          i.email , -- EmailAddress - varchar(256)
          CASE WHEN i.responsiblepartylastname <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          --CASE WHEN i.res <> '' THEN i.guarantorprefix END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN i.responsiblepartyfirstname <> '' THEN i.responsiblepartyfirstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN i.responsiblepartymiddlename <> '' THEN i.responsiblepartymiddlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN i.responsiblepartylastname <> '' THEN i.responsiblepartylastname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN i.responsiblepartysuffix <> '' THEN i.responsiblepartysuffix END , -- ResponsibleSuffix - varchar(16)
          CASE i.responsiblepartyrelationship WHEN 'Other' THEN 'O'
												WHEN 'Spouse' THEN 'U'
												WHEN 'Child' THEN 'C'
												ELSE 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.responsiblepartyfirstname <> '' THEN i.responsiblepartyaddress1 END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.responsiblepartyfirstname <> '' THEN i.responsiblepartyaddress2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.responsiblepartyfirstname <> '' THEN i.responsiblepartycity END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.responsiblepartyfirstname <> '' THEN i.responsiblepartystate END , -- ResponsibleState - varchar(2)
          CASE WHEN i.responsiblepartyfirstname <> '' THEN '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN i.responsiblepartyfirstname <> '' THEN i.responsiblepartyzipcode END , -- ResponsibleZipCode - varchar(9)
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
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.cellphone)) >= 10 
			THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.cellphone),10)
			ELSE '' END , -- HomePhone - varchar(10)
          --i.cellphone , -- MobilePhone - varchar(10)
          '', -- , -- MobilePhoneExt - varchar(10)
          i.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE i.active WHEN 'FALSE' THEN 0 WHEN 'TRUE' THEN 1 ELSE 1 END , -- Active - bit
          '', --CASE i. WHEN 'FALSE' THEN 0 WHEN 'TRUE' THEN 1 ELSE 0 END , -- SendEmailCorrespondence - bit
          i.emergencyname , -- EmergencyName - varchar(128)
          i.emergencyphone , -- EmergencyPhone - varchar(10)
          i.emergencyphoneext  -- EmergencyPhoneExt - varchar(10)
		  --SELECT distinct * 
FROM dbo.[_import_3_1_PatientDemographics] i
LEFT JOIN dbo.Doctor rp ON
	rp.LastName = i.primaryproviderlastname AND 
	rp.PracticeID = @targetpracticeid
LEFT JOIN dbo.Doctor pcp ON
	pcp.LastName = i.primaryproviderlastname AND
	pcp.PracticeID = @targetpracticeid
LEFT JOIN dbo.State s ON 
	s.LongName = i.state

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
'',
1 ,
5 ,
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
pc.chartnumber , -- VendorID
@VendorImportID , -- VenorID
0,--pc.pregnancyrelatedflag ,
1,--pc.statementactive ,
0,--pc.epsdt ,
NULL,--pc.epsdtcodeid ,
0,--pc.emergencyrelated ,
0--pc.homeboundrelatedflag
	--SELECT * 
FROM dbo._import_3_1_patientDemographics pc
INNER JOIN dbo.Patient p ON
pc.chartnumber = p.VendorID AND
p.VendorImportID = @VendorImportID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
SELECT 
		  pc.PatientCaseID , -- PatientCaseID - int
          ip.insurancecode1 , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          ip.policynumber1 , -- PolicyNumber - varchar(32)
          LEFT(ip.groupnumber1,32) , -- GroupNumber - varchar(32)
		  GETDATE(),		--CASE WHEN ISDATE(i.) = 1 THEN i.primaryinsurancepolicyeffectivestartdate
		      --ELSE NULL END , -- PolicyStartDate - datetime
          CASE ip.responsiblepartyrelationship WHEN 'O' THEN 'O'
			   WHEN 'U' THEN 'U'
			   WHEN 'C' THEN 'C'
			   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.responsiblepartyfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN '' END , -- HolderSuffix - varchar(16)
      --         CASE WHEN ISDATE(i.holder1dateofbirth) = 1 THEN i.holder1dateofbirth
			   --ELSE NULL END 
		  '', -- HolderDOB - datetime
          '', --CASE WHEN LEN(i.primaryinsurancepolicyinsuredsocialsecuritynumber) >= 6 THEN RIGHT('000' + i.primaryinsurancepolicyinsuredsocialsecuritynumber , 9)
			  --ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
	
          CASE WHEN ip.holder1gender IN ('F','FEMALE') THEN 'F'
			   WHEN ip.holder1gender IN ('M','MALE') THEN 'M'
			   ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder1street1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder1street2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder1city END , -- HolderCity - varchar(128)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder1state END , -- HolderState - varchar(2)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN (CASE WHEN LEN(ip.holder1zipcode) IN (5,9) THEN ip.holder1zipcode
		       WHEN LEN(ip.holder1zipcode) IN (4,8) THEN '0' + ip.holder1zipcode
			   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder1policynumber END , -- DependentPolicyNumber - varchar(32)
          ip.policy1note , -- Notes - text
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder1policynumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @targetpracticeid , -- PracticeID - int
          ip.chartnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int

FROM dbo._import_3_1_PatientDemographics ip
    INNER JOIN dbo._import_3_1_InsuranceCOMPANYPLANList icpl
        ON ip.insurancecode1 = icpl.insuranceid
    INNER JOIN dbo.PatientCase pc
        ON ip.chartnumber = pc.VendorID
           AND pc.VendorImportID = @VendorImportID
    INNER JOIN dbo.InsuranceCompanyPlan icp
        ON icpl.planname = icp.PlanName
           AND CreatedPracticeID = @TargetPracticeID
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
           AND ipo.PracticeID = @TargetPracticeID
           AND ipo.PatientCaseID = pc.PatientCaseID
           AND policynumber1 = ipo.PolicyNumber
WHERE ipo.InsurancePolicyID IS NULL;

 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
SELECT 
		  pc.PatientCaseID , -- PatientCaseID - int
          ip.insurancecode2 , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          ip.policynumber2 , -- PolicyNumber - varchar(32)
          LEFT(ip.groupnumber2,32) , -- GroupNumber - varchar(32)
		  GETDATE(),
          CASE ip.responsiblepartyrelationship WHEN 'O' THEN 'O'
			   WHEN 'U' THEN 'U'
			   WHEN 'C' THEN 'C'
			   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.responsiblepartyfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN '' END , -- HolderSuffix - varchar(16)
		  '', -- HolderDOB - datetime
          '', -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
	
          CASE WHEN ip.holder2gender IN ('F','FEMALE') THEN 'F'
			   WHEN ip.holder2gender IN ('M','MALE') THEN 'M'
			   ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder2street1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder2street2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder2city END , -- HolderCity - varchar(128)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder2state END , -- HolderState - varchar(2)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN (CASE WHEN LEN(ip.holder2zipcode) IN (5,9) THEN ip.holder2zipcode
		       WHEN LEN(ip.holder2zipcode) IN (4,8) THEN '0' + ip.holder2zipcode
			   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder2policynumber END , -- DependentPolicyNumber - varchar(32)
          ip.policy1note , -- Notes - text
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder2policynumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @targetpracticeid , -- PracticeID - int
          ip.chartnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int

FROM dbo._import_3_1_PatientDemographics ip
    INNER JOIN dbo._import_3_1_InsuranceCOMPANYPLANList icpl
        ON ip.insurancecode2 = icpl.insuranceid
    INNER JOIN dbo.PatientCase pc
        ON ip.chartnumber = pc.VendorID
           AND pc.VendorImportID = @VendorImportID
    INNER JOIN dbo.InsuranceCompanyPlan icp
        ON icpl.planname = icp.PlanName
           AND CreatedPracticeID = @TargetPracticeID
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
           AND ipo.PracticeID = @TargetPracticeID
           AND ipo.PatientCaseID = pc.PatientCaseID
           AND policynumber2 = ipo.PolicyNumber
WHERE ipo.InsurancePolicyID IS NULL;


PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          ip.insurancecode3 , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          ip.policynumber3 , -- PolicyNumber - varchar(32)
          LEFT(ip.groupnumber3,32) , -- GroupNumber - varchar(32)
		  GETDATE(),		--CASE WHEN ISDATE(i.) = 1 THEN i.primaryinsurancepolicyeffectivestartdate
		      --ELSE NULL END , -- PolicyStartDate - datetime
          CASE ip.responsiblepartyrelationship WHEN 'O' THEN 'O'
			   WHEN 'U' THEN 'U'
			   WHEN 'C' THEN 'C'
			   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.responsiblepartyfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN '' END , -- HolderSuffix - varchar(16)
		  '', -- HolderDOB - datetime
          '', -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
	
          CASE WHEN ip.holder3gender IN ('F','FEMALE') THEN 'F'
			   WHEN ip.holder3gender IN ('M','MALE') THEN 'M'
			   ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder3street1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder3street2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder3city END , -- HolderCity - varchar(128)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder3state END , -- HolderState - varchar(2)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN (CASE WHEN LEN(ip.holder3zipcode) IN (5,9) THEN ip.holder3zipcode
		       WHEN LEN(ip.holder3zipcode) IN (4,8) THEN '0' + ip.holder3zipcode
			   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder3policynumber END , -- DependentPolicyNumber - varchar(32)
          ip.policy1note , -- Notes - text
          CASE WHEN ip.responsiblepartyrelationship <> 'S' THEN ip.holder3policynumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @targetpracticeid , -- PracticeID - int
          ip.chartnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int

--select * 
FROM dbo._import_3_1_PatientDemographics ip
    INNER JOIN dbo._import_3_1_InsuranceCOMPANYPLANList icpl
        ON ip.insurancecode3 = icpl.insuranceid
    INNER JOIN dbo.PatientCase pc
        ON ip.chartnumber = pc.VendorID
           AND pc.VendorImportID = @VendorImportID
    INNER JOIN dbo.InsuranceCompanyPlan icp
        ON icpl.planname = icp.PlanName
           AND CreatedPracticeID = @TargetPracticeID
    LEFT JOIN dbo.InsurancePolicy ipo
        ON ipo.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
           AND ipo.PracticeID = @TargetPracticeID
           AND ipo.PatientCaseID = pc.PatientCaseID
           AND policynumber3 = ipo.PolicyNumber
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
    8,         -- PracticeID - int
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
    9,         -- VendorImportID - int
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
--	INNER JOIN dbo._import_3_1_PatientAppointments i ON
--		i.servicelocationid = sl.ServiceLocationID

--UPDATE i SET 
--i.servicelocationid = sl.ServiceLocationID
----SELECT distinct * 
--FROM dbo.ServiceLocation sl 
--	INNER JOIN dbo._import_3_1_PatientAppointments i ON
--		i.name = sl.Name
--WHERE sl.PracticeID = @targetPracticeID

--SELECT * FROM servicelocation

PRINT ''
PRINT 'Inserting Into Appointments...'
INSERT INTO dbo.Appointment
        ( PatientID,
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
		  Recurrence,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm,
		  vendorimportid
        )
		--SELECT * FROM dbo.Appointment WHERE PracticeID =8
		--SELECT * FROM dbo.ServiceLocation WHERE PracticeID =8
SELECT DISTINCT
		  p.PatientID,
          @targetPracticeID , -- PracticeID - int
		  
		  --CASE 
		  --WHEN i.servicelocationname = 'Southwest ENT Consultant' THEN 407
		  --WHEN i.servicelocationname = 'Sierra Medical Center Hospital' THEN 427
		  --WHEN i.servicelocationname = 'Providence Memorial Hospital' THEN 426
		  --WHEN i.servicelocationname = 'Las Palmas Hospital' THEN 425
		  --WHEN i.servicelocationname = 'El Paso Day Surgery' THEN 442
		  --WHEN i.servicelocationname = 'Del Sol Medical Center Hospital' THEN 423
		  --WHEN i.servicelocationname = 'El Paso Childrens Hospital' THEN 422
		  --ELSE '287' END ,
		  1,  -- ServiceLocationID - int
          i.startdate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentstarttime , -- StartDate - datetime
          i.enddate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentendtime,  -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
		  --AppointmentConfirmationStatusCode,
          CASE i.status
			WHEN 'Check-Out' THEN 'O'
			WHEN 'Confirmed' THEN 'C'
			WHEN 'Check-In' THEN 'I'
			WHEN 'Scheduled' THEN 'S'
			ELSE'S' END , -- AppointmentConfirmationStatusCode - char(1)
		  0,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.startdate AS TIME),':',''),4) AS SMALLINT), -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.enddate AS TIME),':',''),4) AS SMALLINT),  -- EndTm - smallint
		  @VendorImportID
		
		  --SELECT distinct i.*
FROM dbo._import_3_1_PatientAppointments i 
	INNER JOIN dbo._import_3_1_PatientDemographics d ON 
		d.chartnumber = i.chartnumber
	INNER JOIN dbo.Patient p ON 
		d.lastname = p.LastName AND 
		d.firstname = p.FirstName AND 
		p.PracticeID = @targetPracticeID
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = 1 AND
		DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
WHERE p.PracticeID = @targetPracticeID
		--AND p.lastname = 'ordaz'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID,
		  vendorimportid
        )
		--SELECT * FROM dbo.PracticeResource WHERE PracticeID = 61
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
		  1, -- AppointmentResourceTypeID - int
			CASE 
				WHEN i.doctorfirstname = 'LUDMILA' THEN 1
				WHEN i.doctorfirstname = 'ZOYA' THEN 4
				WHEN i.doctorfirstname = 'OLEG' THEN 5
				WHEN i.doctorfirstname = 'CARLA' THEN 6
			ELSE '14' END ,
		  --195,
          GETDATE(),  -- ModifiedDate - datetime
          @targetPracticeID,  -- PracticeID - int
		  @VendorImportID
		
	--SELECT i.*
FROM dbo._import_3_1_PatientAppointments i 
	INNER JOIN dbo._import_3_1_PatientDemographics d ON 
		d.chartnumber = i.chartnumber
	INNER JOIN dbo.Patient p ON 
		d.lastname = p.LastName AND 
		d.firstname = p.FirstName AND 
		--CAST(d.dateofbirth AS DATE) = CAST(p.DOB AS DATE) AND 
		p.PracticeID = @targetPracticeID 		
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		a.StartDate = i.startdate AND 
		a.EndDate = i.enddate AND 
		a.PracticeID = @targetPracticeID
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Appointment Reasons...'


INSERT INTO dbo.AppointmentReason
(
    PracticeID,
    Name,
    DefaultDurationMinutes,
    DefaultColorCode,
    Description,
    ModifiedDate,
	vendorimportid

)
SELECT DISTINCT	
    @targetPracticeID,         -- PracticeID - int
    ip.reasons,        -- Name - varchar(128)
    DATEDIFF(MINUTE,ip.startdate,ip.enddate),         -- DefaultDurationMinutes - int
    null,      -- DefaultColorCode - int
    ip.reasons,        -- Description - varchar(256)
    GETDATE(), -- ModifiedDate - datetime
	@VendorImportID
	--SELECT *
FROM dbo._import_3_1_PatientAppointments ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.reasons
--AND ar.PracticeID = 8
WHERE ar.name IS NULL 


PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--SELECT * FROM dbo.Appointmentreason WHERE PracticeID = 8

PRINT''
PRINT'Inserting into Appointment to Appointment Reasons...'

INSERT INTO dbo.AppointmentToAppointmentReason
(
    AppointmentID,
    AppointmentReasonID,
    PrimaryAppointment,
    ModifiedDate,
    PracticeID,
	vendorimportid
)

SELECT DISTINCT a.AppointmentID, 
MIN(ar.AppointmentReasonID) AS AppointmentReasonID, 
1 ,
GETDATE() ,
@targetPracticeID,
@VendorImportID
--select * 
FROM dbo._import_3_1_PatientAppointments iapt
	INNER JOIN dbo._import_3_1_PatientDemographics pd ON 
		pd.chartnumber = iapt.chartnumber
	INNER JOIN dbo.AppointmentReason ar ON 
		ar.Name = iapt.reasons AND 
		ar.PracticeID = 1
	INNER JOIN dbo.Patient p ON 
		--pd.chartnumber = p.medicalrecordnumber
		p.LastName = pd.lastname AND 
        p.FirstName = pd.firstname
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		CAST(a.StartDate AS DATETIME) = CAST(iapt.startdate AS DATETIME) AND 
		CAST(a.EndDate AS DATETIME) = CAST(iapt.enddate AS DATETIME) AND 
		a.PracticeID = 1    --CONVERT(VARCHAR,CAST(iapt.appointmentdate AS DATETIME),120)+ CAST(iapt.appointmentstarttime AS DATETIME)
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())
GROUP BY a.AppointmentID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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