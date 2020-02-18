USE superbill_43537_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

----add vendorimportid to appointments table
--ALTER TABLE dbo.Appointment ADD vendorimportid INT 

DECLARE @sourcepracticeID INT 
DECLARE @targetPracticeID INT
DECLARE @VendorImportID INT

SET @sourcepracticeID = 1
SET @targetPracticeID = 2
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@targetPracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @targetpracticeid AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.PracticeToInsuranceCompany WHERE InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Practice to Insurance Company records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @targetpracticeid AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @targetpracticeid AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @targetpracticeid AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @targetpracticeid)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @targetpracticeid AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @targetpracticeid AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @targetpracticeid))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment to Appointment Resource records deleted'
--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @targetpracticeid))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment to Appointment Reason Resource records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @targetpracticeid)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'


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
          ContactFirstName ,
          ContactLastName ,
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
          i.name , -- InsuranceCompanyName - varchar(128)
          i.AddressLine1 , -- AddressLine1 - varchar(256)
		  i.addressline2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          i.country , -- Country - varchar(32)
          i.zipcode , -- ZipCode - varchar(9)
          i.contactfirstname , -- ContactFirstName - varchar(64)
          i.contactlastname , -- ContactLastName - varchar(64)
          i.contactphone , -- Phone - varchar(10)
          i.contactphoneext , -- PhoneExt - varchar(10)
          i.contactfax , -- Fax - varchar(10)
          i.contactfaxext , -- FaxExt - varchar(10)
          i.autobillssecondaryinsurance , -- BillSecondaryInsurance - bit
		  1 , -- EClaimsAccepts - bit ,
          19 , -- BillingFormID - int
		  CASE WHEN ip.insuranceprogramcode IS NULL THEN 'CI' ELSE ip.InsuranceProgramCode END , -- InsuranceProgramCode - char(2)
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
          18 ,  -- InstitutionalBillingFormID - int
		  i.clearinghousepayerid
FROM dbo._import_1_2_InsuranceCompany i
	LEFT JOIN dbo.InsuranceProgram ip ON
		i.insuranceprogram = ip.ProgramName 
	INNER JOIN dbo.[_import_1_2_CaseInformation] ci ON
		i.insurancecompanyid = ci.primaryinsurancepolicycompanyid OR
		i.insurancecompanyid = ci.secondaryinsurancepolicycompanyid OR
		i.insurancecompanyid = ci.tertiaryinsurancepolicycompanyid 
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
		  ip.planname , -- PlanName - varchar(128)
          ip.addressline1 , -- AddressLine1 - varchar(256)
          ip.addressline2 , -- AddressLine2 - varchar(256)
          ip.city , -- City - varchar(128)
          ip.state , -- State - varchar(2)
          ip.country , -- Country - varchar(32)
          ip.zipcode , -- ZipCode - varchar(9)
          ip.contactfirstname , -- ContactFirstName - varchar(64)
          ip.contactmiddlename , -- ContactMiddleName - varchar(64)
          ip.contactlastname , -- ContactLastName - varchar(64)
          ip.contactphone , -- Phone - varchar(10)
          ip.contactphoneext , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @targetPracticeID , -- CreatedPracticeID - int
          ip.contactfax , -- Fax - varchar(10)
          ip.contactfaxext , -- FaxExt - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ip.insurancecompanyplanid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_2_InsuranceCompanyPlan] ip
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.VendorID = ip.insurancecompanyid AND 
	VendorImportID = @VendorImportID AND 
	ic.CreatedPracticeID = @targetpracticeid
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

UPDATE dbo.Doctor 
	SET VendorID = i.providerid
FROM dbo.Doctor d
INNER JOIN dbo.[_import_1_2_Providers] i ON
	d.FirstName = i.firstname AND
	d.LastName = i.lastname AND
	d.NPI = i.npi 
WHERE d.PracticeID = @targetPracticeID AND d.[External] = 0 AND i.providertype = 'Rendering'

UPDATE dbo.Doctor 
	SET VendorID = i.providerid
FROM dbo.Doctor d
INNER JOIN dbo.[_import_1_2_Providers] i ON
	d.FirstName = i.firstname AND
	d.LastName = i.lastname AND
	d.NPI = i.npi 
WHERE d.PracticeID = @targetPracticeID AND d.[External] = 1 AND i.providertype = 'Referring'

PRINT ''
PRINT 'Inserting Into Referring Doctor...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          SSN ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          HomePhone ,
          WorkPhone ,
          MobilePhone ,
          DOB ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          [External] ,
          NPI 
        )
SELECT DISTINCT  
		  @targetPracticeID , -- PracticeID - int
          i.prefix , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          i.middlename , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          i.suffix , -- Suffix - varchar(16)
          i.ssn , -- SSN - varchar(9)
          i.addressline1 , -- AddressLine1 - varchar(256)
          i.addressline2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.zipcode , -- ZipCode - varchar(9)
          i.homephone , -- HomePhone - varchar(10)
          i.workphone , -- WorkPhone - varchar(10)
          i.mobilephone , -- MobilePhone - varchar(10)
          i.dob , -- DOB - datetime
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.providerid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- External - bit
          i.npi  -- NPI - varchar(10)
FROM dbo.[_import_1_2_Providers] i 
LEFT JOIN dbo.Doctor d ON 
	d.FirstName = i.firstname AND 
	d.LastName = i.lastname AND 
	d.NPI = i.npi AND d.[External] = 1 AND 
	d.PracticeID = @targetpracticeid
WHERE providertype = 'Referring' AND d.DoctorID IS NULL AND active = 'TRUE'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

IF (SELECT COUNT(*) FROM dbo._import_1_2_ServiceLocations) >= 1 
BEGIN

PRINT ''
PRINT 'Inserting Into Service Location...'
INSERT INTO dbo.ServiceLocation
        ( PracticeID ,
          Name ,
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
          PlaceOfServiceCode ,
          BillingName ,
          Phone ,
          PhoneExt ,
          FaxPhone ,
          FaxPhoneExt ,
          CLIANumber ,
          VendorImportID ,
          VendorID ,
          NPI 
        )
SELECT DISTINCT  
		  @targetPracticeID , -- PracticeID - int
          internalname , -- Name - varchar(128)
          i.addressline1 , -- AddressLine1 - varchar(256)
          i.addressline2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.zipcode , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE placeofservice WHEN 'Assisted Living Facility' THEN '13'
							  WHEN 'Inpatient Hospital' THEN '21'
							  WHEN 'Nursing Facility' THEN '32'
							  WHEN 'Office' THEN '11'
							  WHEN 'Outpatient Hospital' THEN '22'
							  WHEN 'Skilled Nursing Facility' THEN '31' ELSE 11 END , -- PlaceOfServiceCode - char(2)
          i.billingname , -- BillingName - varchar(128)
          i.phonenumber , -- Phone - varchar(10)
          i.phonenumberext , -- PhoneExt - varchar(10)
          i.faxnumber , -- FaxPhone - varchar(10)
          i.faxnumberext , -- FaxPhoneExt - varchar(10)
          i.clianumber , -- CLIANumber - varchar(30)
          @VendorImportID , -- VendorImportID - int
          i.servicelocationid , -- VendorID - int
          i.npi  -- NPI - varchar(10)
FROM dbo.[_import_1_2_ServiceLocations] i
LEFT JOIN dbo.ServiceLocation sl ON 
	i.internalname = sl.Name AND 
	sl.PracticeID = @targetpracticeid
WHERE sl.ServiceLocationID IS NULL 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

END


CREATE TABLE #tempsl
( PatientID INT , slID INT )
INSERT INTO #tempsl
        ( PatientID, slID )
SELECT DISTINCT
		   i.id , 
		   sl.ServiceLocationID
FROM dbo._import_1_2_PatientDemographics i 
INNER JOIN dbo._import_1_2_ServiceLocations isl ON 
	i.id = isl.servicelocationid
INNER JOIN dbo.ServiceLocation sl ON 
	isl.internalname = sl.Name AND 
	isl.addressline1 = sl.AddressLine1 AND 
	sl.PracticeID = @targetPracticeID

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
          NULL, --rp.DoctorID , -- ReferringPhysicianID - int
          i.prefix , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          i.middlename , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          i.suffix , -- Suffix - varchar(16)
          i.addressline1 , -- AddressLine1 - varchar(256)
          i.addressline2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.zipcode , -- ZipCode - varchar(9)
          i.gender , -- Gender - varchar(1)
          CASE i.maritalstatus WHEN 'Anulled' THEN 'A'
							   WHEN 'Divorced' THEN 'D'
							   WHEN 'Domestic Partner' THEN 'T'
							   WHEN 'Interlocutory' THEN 'I'
							   WHEN 'Legally Separated' THEN 'L'
							   WHEN 'Married' THEN 'M'
							   WHEN 'Never Married' THEN 'S'
							   WHEN 'Widowed' THEN 'W' ELSE '' END  , -- MaritalStatus - varchar(1)
          i.homephone , -- HomePhone - varchar(10)
          i.homephoneext , -- HomePhoneExt - varchar(10)
          i.workphone , -- WorkPhone - varchar(10)
          i.workphoneext , -- WorkPhoneExt - varchar(10)
          i.dateofbirth , -- DOB - datetime
          i.ssn , -- SSN - char(9)
          i.emailaddress , -- EmailAddress - varchar(256)
          CASE WHEN i.guarantorfirstname <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorprefix END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorfirstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantormiddlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorlastname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN i.guarantorfirstname <> '' THEN i.suffix END , -- ResponsibleSuffix - varchar(16)
          CASE i.guarantorrelationshiptopatient WHEN 'Other' THEN 'O'
												WHEN 'Spouse' THEN 'U'
												WHEN 'Child' THEN 'C'
												ELSE 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantoraddressline1 END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantoraddressline2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorcity END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorstate END , -- ResponsibleState - varchar(2)
          CASE WHEN i.guarantorfirstname <> '' THEN '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorzip END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE i.employmentstatus WHEN 'Employed' THEN 'E'
							      WHEN 'Retired' THEN 'R'
								  WHEN 'Unknown' THEN 'U' ELSE 'U' END , -- EmploymentStatus - char(1)
          drp.DoctorID , -- PrimaryProviderID - int
          tsl.slID , -- DefaultServiceLocationID - int
          --te.EmpID , -- EmployerID - int
          i.medicalrecordnumber , -- MedicalRecordNumber - varchar(128)
          i.mobilephone , -- MobilePhone - varchar(10)
          i.mobilephoneext , -- MobilePhoneExt - varchar(10)
          i.id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE i.active WHEN 'FALSE' THEN 0 WHEN 'TRUE' THEN 1 ELSE 1 END , -- Active - bit
          CASE i.sendemailnotifications WHEN 'FALSE' THEN 0 WHEN 'TRUE' THEN 1 ELSE 0 END , -- SendEmailCorrespondence - bit
          i.emergencyname , -- EmergencyName - varchar(128)
          i.emergencyphone , -- EmergencyPhone - varchar(10)
          i.emergencyphoneext  -- EmergencyPhoneExt - varchar(10)
FROM dbo.[_import_1_2_PatientDemographics] i
LEFT JOIN dbo.Doctor rp ON
	rp.VendorID = i.defaultreferringphysicianid AND 
	rp.PracticeID = @targetpracticeid
LEFT JOIN dbo.Doctor pcp ON
	pcp.VendorID = i.primarycarephysicianid AND
	pcp.PracticeID = @targetpracticeid
LEFT JOIN dbo.Doctor drp ON
	drp.VendorID = i.defaultrenderingproviderid AND
	drp.PracticeID = @targetpracticeid AND
	drp.[External] = 0
LEFT JOIN #tempsl tsl ON 
	i.id = tsl.PatientID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

--UPDATE  p SET 
--p.ReferringPhysicianID = id.defaultreferringphysicianid
----SELECT * 
--FROM dbo._import_1_2_PatientDemographics id 
--INNER JOIN dbo.Patient p ON p.PatientID = id.id
--rollback

PRINT ''
PRINT 'Inserting into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
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
          FamilyPlanning ,
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          i.defaultcasename , -- Name - varchar(128)
          1 , -- Active - bit
          CASE WHEN ps.PayerScenarioID IS NULL THEN '5' ELSE ps.PayerScenarioID END , -- PayerScenarioID - int
          CASE i.defaultcaseconditionrelatedtoemployment WHEN 1 THEN 1
				ELSE 0 END , -- EmploymentRelatedFlag - bit
          CASE i.defaultcaseconditionrelatedtoautoaccident WHEN 1 THEN 1
				ELSE 0 END , -- AutoAccidentRelatedFlag - bit
          CASE i.defaultcaseconditionrelatedtoother WHEN 1 THEN 1
				ELSE 0 END , -- OtherAccidentRelatedFlag - bit
          CASE i.defaultcaseconditionrelatedtoabuse WHEN 1 THEN 1
				ELSE 0 END , -- AbuseRelatedFlag - bit
          CASE i.defaultcaseconditionrelatedtoautoaccidentstate WHEN '' THEN ''
				ELSE LEFT(defaultcaseconditionrelatedtoautoaccidentstate , 2) END , -- AutoAccidentRelatedState - char(2)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @targetPracticeID , -- PracticeID - int
          i.defaultcaseid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE i.defaultcaseconditionrelatedtopregnancy WHEN 1 THEN 1
				ELSE 0 END , -- PregnancyRelatedFlag - bit
          CASE i.defaultcasesendpatientstatements WHEN 1 THEN 1
				ELSE 0 END , -- StatementActive - bit
          CASE i.defaultcaseconditionrelatedtoepsdt WHEN 1 THEN 1
				ELSE 0 END , -- EPSDT - bit
          CASE i.defaultcaseconditionrelatedtofamilyplanning WHEN 1 THEN 1
				ELSE 0 END , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          CASE i.defaultcaseconditionrelatedtoemergency WHEN 1 THEN 1
				ELSE 0 END , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_1_2_CaseInformation] i
INNER JOIN dbo.Patient p ON
	p.VendorID = i.patientid AND
	p.VendorImportID = @VendorImportID AND
	p.PracticeID = @targetpracticeid
LEFT JOIN dbo.PayerScenario ps ON
	ps.Name = i.defaultcasepayerscenario
WHERE i.defaultcaseid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- PatientCaseDate data. Exists? Begin
IF (SELECT COUNT(*) FROM dbo._import_1_2_CaseInformation WHERE defaultcasedatesinjurystartdate <> '') >= 1 
BEGIN

PRINT ''
PRINT 'Inserting into Patient Case Date - Injury Date...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  @targetPracticeID , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          2 , -- PatientCaseDateTypeID - int
          CASE WHEN ISDATE(i.defaultcasedatesinjurystartdate) = 1 THEN i.defaultcasedatesinjurystartdate
				ELSE NULL END  , -- StartDate - datetime
          CASE WHEN ISDATE(i.defaultcasedatesinjuryenddate) = 1 THEN i.defaultcasedatesinjuryenddate
				ELSE NULL END  , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_2_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedatesinjurystartdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_1_2_CaseInformation WHERE DefaultCaseDatesSameOrSimilarIllnessStartDate <> '') >= 1 
BEGIN

PRINT ''
PRINT 'Inserting into Patient Case Date - Same or Similar Illness...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  @targetPracticeID , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          3 , -- PatientCaseDateTypeID - int
          CASE WHEN ISDATE(i.DefaultCaseDatesSameOrSimilarIllnessStartDate) = 1 THEN i.DefaultCaseDatesSameOrSimilarIllnessStartDate
				ELSE NULL END  , -- StartDate - datetime
          CASE WHEN ISDATE(i.DefaultCaseDatesSameOrSimilarIllnessEndDate) = 1 THEN i.DefaultCaseDatesSameOrSimilarIllnessEndDate
				ELSE NULL END  , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_2_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.DefaultCaseDatesSameOrSimilarIllnessStartDate <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_1_2_CaseInformation WHERE DefaultCaseDatesUnableToWorkStartDate <> '') >= 1 
BEGIN

PRINT ''
PRINT 'Inserting into Patient Case Date - Unable to Work...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  @targetPracticeID , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          4 , -- PatientCaseDateTypeID - int
          CASE WHEN ISDATE(i.DefaultCaseDatesUnableToWorkStartDate) = 1 THEN i.DefaultCaseDatesUnableToWorkStartDate
				ELSE NULL END  , -- StartDate - datetime
          CASE WHEN ISDATE(i.DefaultCaseDatesUnableToWorkEndDate) = 1 THEN i.DefaultCaseDatesUnableToWorkEndDate
				ELSE NULL END  , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_2_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.DefaultCaseDatesUnableToWorkStartDate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_1_2_CaseInformation WHERE DefaultCaseDatesRelatedDisabilityStartDate <> '') >= 1 
BEGIN

PRINT ''
PRINT 'Inserting into PatientCaseDate - Date Total Disability...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  @targetpracticeid , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          5 , -- PatientCaseDateTypeID - int
          CASE WHEN ISDATE(i.DefaultCaseDatesRelatedDisabilityStartDate) = 1 THEN i.DefaultCaseDatesRelatedDisabilityStartDate
				ELSE NULL END  , -- StartDate - datetime
          CASE WHEN ISDATE(i.DefaultCaseDatesRelatedDisabilityEndDate) = 1 THEN i.DefaultCaseDatesRelatedDisabilityEndDate
				ELSE NULL END  , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_2_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.DefaultCaseDatesRelatedDisabilityStartDate <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_1_2_CaseInformation WHERE DefaultCaseDatesRelatedHospitalizationStartDate <> '') >= 1 
BEGIN      

PRINT ''
PRINT 'Inserting into Patient Case Date - Hospital Date...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  @targetpracticeid , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          6 , -- PatientCaseDateTypeID - int
          CASE WHEN ISDATE(i.DefaultCaseDatesRelatedHospitalizationStartDate) = 1 THEN i.DefaultCaseDatesRelatedHospitalizationStartDate
				ELSE NULL END  , -- StartDate - datetime
          CASE WHEN ISDATE(i.DefaultCaseDatesRelatedHospitalizationEndDate) = 1 THEN i.DefaultCaseDatesRelatedHospitalizationEndDate
				ELSE NULL END  , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_2_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedatesrelatedhospitalizationstartdate <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_1_2_CaseInformation WHERE DefaultCaseDatesLastMenstrualPeriodDate <> '') >= 1 
BEGIN      

PRINT ''
PRINT 'Inserting into Patient Case Date - LMP...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  @targetpracticeid , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          7 , -- PatientCaseDateTypeID - int
          CASE WHEN ISDATE(i.DefaultCaseDatesLastMenstrualPeriodDate) = 1 THEN i.DefaultCaseDatesLastMenstrualPeriodDate
				ELSE NULL END  , -- StartDate - datetime
          NULL , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_2_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.DefaultCaseDatesLastMenstrualPeriodDate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_1_2_CaseInformation WHERE defaultcasedateslastseendate <> '') >= 1 
BEGIN      

PRINT ''
PRINT 'Inserting into PatientCaseDate - Date Last Seen...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  @targetpracticeid , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          8 , -- PatientCaseDateTypeID - int
          CASE WHEN ISDATE(i.defaultcasedateslastseendate) = 1 THEN i.defaultcasedateslastseendate
				ELSE NULL END  , -- StartDate - datetime
          NULL , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_2_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedateslastseendate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_1_2_CaseInformation WHERE defaultcasedatesreferraldate <> '') >= 1 
BEGIN      

PRINT ''
PRINT 'Inserting into PatientCaseDate - Referral Date...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  @targetpracticeid , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          9 , -- PatientCaseDateTypeID - int
          CASE WHEN ISDATE(i.defaultcasedatesreferraldate) = 1 THEN i.defaultcasedatesreferraldate
				ELSE NULL END  , -- StartDate - datetime
          NULL  , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_2_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedatesreferraldate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_1_2_CaseInformation WHERE defaultcasedatesacutemanifestationdate <> '') >= 1 
BEGIN 

PRINT ''
PRINT 'Inserting into PatientCaseDate - Date of Manifestation...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  @targetpracticeid , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          10 , -- PatientCaseDateTypeID - int
          CASE WHEN ISDATE(i.defaultcasedatesacutemanifestationdate) = 1 THEN i.defaultcasedatesacutemanifestationdate
				ELSE NULL END  , -- StartDate - datetime
          NULL , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_2_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedatesacutemanifestationdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_1_2_CaseInformation WHERE defaultcasedateslastxraydate <> '') >= 1 
BEGIN 

PRINT ''
PRINT 'Inserting into PatientCaseDate - Last XRAY...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  @targetpracticeid , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          11 , -- PatientCaseDateTypeID - int
          CASE WHEN ISDATE(i.defaultcasedateslastxraydate) = 1 THEN i.defaultcasedateslastxraydate
				ELSE NULL END  , -- StartDate - datetime
          NULL , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_2_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedateslastxraydate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_1_2_CaseInformation WHERE defaultcasedatesaccidentdate <> '') >= 1 
BEGIN 
      
PRINT ''
PRINT 'Inserting into PatientCaseDate - Related to Accident...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  @targetpracticeid , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          11 , -- PatientCaseDateTypeID - int
          CASE WHEN ISDATE(i.defaultcasedatesaccidentdate) = 1 THEN i.defaultcasedatesaccidentdate
				ELSE NULL END  , -- StartDate - datetime
          NULL , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_2_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedatesaccidentdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

-- patient journal notes are separated into 4 columns. this puts them together into 1 temp table
CREATE TABLE #ImpPJN (PatientID INT , PJNCreatedDate DATETIME , PJNUserName VARCHAR(128) , NoteMessage VARCHAR(MAX))
INSERT INTO #ImpPJN
        ( PatientID ,
          PJNCreatedDate ,
          PJNUserName ,
          NoteMessage
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          i.mostrecentnote4date , -- PJNCreatedDate - datetime
          i.mostrecentnote4user , -- PJNUserName - varchar(128)
          i.mostrecentnote4message  -- NoteMessage - varchar(max)
FROM dbo._import_1_2_NotesAlerts i 
INNER JOIN dbo.Patient p ON 
	i.id = p.VendorID AND 
	p.VendorImportID = @VendorImportID
WHERE i.mostrecentnote4message <> ''

UNION

SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          i.mostrecentnote3date , -- PJNCreatedDate - datetime
          i.mostrecentnote3user , -- PJNUserName - varchar(128)
          i.mostrecentnote3message  -- NoteMessage - varchar(max)
FROM dbo._import_1_2_NotesAlerts i 
INNER JOIN dbo.Patient p ON 
	i.id = p.VendorID AND 
	p.VendorImportID = @VendorImportID
WHERE i.mostrecentnote3message <> ''

UNION

SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          i.mostrecentnote2date , -- PJNCreatedDate - datetime
          i.mostrecentnote2user , -- PJNUserName - varchar(128)
          i.mostrecentnote2message  -- NoteMessage - varchar(max)
FROM dbo._import_1_2_NotesAlerts i 
INNER JOIN dbo.Patient p ON 
	i.id = p.VendorID AND 
	p.VendorImportID = @VendorImportID
WHERE i.mostrecentnote2message <> ''

UNION

SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          i.mostrecentnote1date , -- PJNCreatedDate - datetime
          i.mostrecentnote1user , -- PJNUserName - varchar(128)
          i.mostrecentnote1message  -- NoteMessage - varchar(max)
FROM dbo._import_1_2_NotesAlerts i 
INNER JOIN dbo.Patient p ON 
	i.id = p.VendorID AND 
	p.VendorImportID = @VendorImportID
WHERE i.mostrecentnote1message <> ''

PRINT ''
PRINT 'Inserting Into Patient Journal Note...'
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
		  PJNCreatedDate , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          PatientID , -- PatientID - int
          PJNUserName , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          NoteMessage , -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          1  -- LastNote - bit
FROM #ImpPJN
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Alert...'
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
	      p.PatientID , -- PatientID - int
          i.alertmessage , -- AlertMessage - text
          i.alertshowwhendisplayingpatientdetails , -- ShowInPatientFlag - bit
          i.alertshowwhenschedulingappointments , -- ShowInAppointmentFlag - bit
          i.alertshowwhenenteringencounters , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.AlertShowWhenViewingClaimDetails , -- ShowInClaimFlag - bit
          i.AlertShowWhenPostingPayments , -- ShowInPaymentFlag - bit
          i.AlertShowWhenPreparingPatientStatements -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_1_2_NotesAlerts] i
INNER JOIN dbo.Patient p ON
	i.id = p.VendorID AND
	p.VendorImportID = @VendorImportID
WHERE i.alertmessage <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- not enough time to put this into a temp table. 3 separate inserts it is
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
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.primaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          i.primaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.primaryinsurancepolicyeffectivestartdate) = 1 THEN i.primaryinsurancepolicyeffectivestartdate
			   ELSE NULL END , -- PolicyStartDate - datetime
          CASE i.primaryinsurancepolicypatientrelationshiptoinsured WHEN 'O' THEN 'O'
																		 WHEN 'U' THEN 'U'
																		 WHEN 'C' THEN 'C'
																		 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.primaryinsurancepolicyinsuredfullname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN ISDATE(i.primaryinsurancepolicyinsureddateofbirth) = 1 THEN i.primaryinsurancepolicyinsureddateofbirth
			   ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN LEN(i.primaryinsurancepolicyinsuredsocialsecuritynumber) >= 6 THEN RIGHT('000' + i.primaryinsurancepolicyinsuredsocialsecuritynumber , 9)
			   ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.primaryinsurancepolicyinsuredgender IN ('F','FEMALE') THEN 'F'
			   WHEN i.primaryinsurancepolicyinsuredgender IN ('M','MALE') THEN 'M'
			   ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN i.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.primaryinsurancepolicyinsuredaddressline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.primaryinsurancepolicyinsuredaddressline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.primaryinsurancepolicyinsuredcity END , -- HolderCity - varchar(128)
          CASE WHEN i.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.primaryinsurancepolicyinsuredstate END , -- HolderState - varchar(2)
          CASE WHEN i.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN (CASE WHEN LEN(i.primaryinsurancepolicyinsuredzipcode) IN (5,9) THEN i.primaryinsurancepolicyinsuredzipcode
																								WHEN LEN(i.primaryinsurancepolicyinsuredzipcode) IN (4,8) THEN '0' + i.primaryinsurancepolicyinsuredzipcode
																								ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN i.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.primaryinsurancepolicyinsuredidnumber END , -- DependentPolicyNumber - varchar(32)
          i.primaryinsurancepolicyinsurednotes , -- Notes - text
          CASE WHEN i.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.primaryinsurancepolicyinsuredidnumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @targetpracticeid , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_2_CaseInformation] AS i
INNER JOIN dbo.InsuranceCompanyPlan AS icp  ON
	icp.VendorID = i.primaryinsurancepolicycompanyplanid AND
	icp.VendorImportID = @VendorImportID AND 
	icp.CreatedPracticeID = @targetpracticeid
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.VendorImportID = @VendorImportID  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Secondary Insurance Policy...'
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
          icp .InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.secondaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          i.secondaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.secondaryinsurancepolicyeffectivestartdate) = 1 THEN i.secondaryinsurancepolicyeffectivestartdate
			   ELSE NULL END , -- PolicyStartDate - datetime
          CASE i.secondaryinsurancepolicypatientrelationshiptoinsured WHEN 'O' THEN 'O'
																		   WHEN 'U' THEN 'U'
																		   WHEN 'C' THEN 'C'
																		   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.secondaryinsurancepolicyinsuredfullname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN ISDATE(i.secondaryinsurancepolicyinsureddateofbirth) = 1 THEN i.secondaryinsurancepolicyinsureddateofbirth
			   ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN LEN(i.secondaryinsurancepolicyinsuredsocialsecuritynumber) >= 6 THEN RIGHT('000' + i.secondaryinsurancepolicyinsuredsocialsecuritynumber , 9)
			   ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.secondaryinsurancepolicyinsuredgender IN ('F','FEMALE') THEN 'F'
			   WHEN i.secondaryinsurancepolicyinsuredgender IN ('M','MALE') THEN 'M'
			   ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN i.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.secondaryinsurancepolicyinsuredaddressline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.secondaryinsurancepolicyinsuredaddressline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.secondaryinsurancepolicyinsuredcity END , -- HolderCity - varchar(128)
          CASE WHEN i.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.secondaryinsurancepolicyinsuredstate END , -- HolderState - varchar(2)
          CASE WHEN i.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN (CASE WHEN LEN(i.secondaryinsurancepolicyinsuredzipcode) IN (5,9) THEN i.secondaryinsurancepolicyinsuredzipcode
																								  WHEN LEN(i.secondaryinsurancepolicyinsuredzipcode) IN (4,8) THEN '0' + i.secondaryinsurancepolicyinsuredzipcode
																								  ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN i.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.secondaryinsurancepolicyinsuredidnumber END , -- DependentPolicyNumber - varchar(32)
          i.secondaryinsurancepolicyinsurednotes , -- Notes - text
          i.secondaryinsurancepolicycopay , -- Copay - money
          i.secondaryinsurancepolicydeductible , -- Deductible - money
          CASE WHEN i.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.secondaryinsurancepolicyinsuredidnumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @targetpracticeid , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_2_CaseInformation]  AS i
INNER JOIN dbo.InsuranceCompanyPlan AS icp  ON
	icp.VendorID = i.secondaryinsurancepolicycompanyplanid AND
    icp.VendorImportID = @VendorImportID AND 
    icp.CreatedPracticeID = @targetpracticeid
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @targetpracticeid  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Tertiary Insurance Policy...'
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
          icp .InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          i.tertiaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          i.tertiaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.tertiaryinsurancepolicyeffectivestartdate) = 1 THEN i.tertiaryinsurancepolicyeffectivestartdate
			   ELSE NULL END , -- PolicyStartDate - datetime
          CASE i.tertiaryinsurancepolicypatientrelationshiptoinsured WHEN 'O' THEN 'O'
																		  WHEN 'U' THEN 'U'
																		  WHEN 'C' THEN 'C'
																		  ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.tertiaryinsurancepolicyinsuredfullname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN ISDATE(i.tertiaryinsurancepolicyinsureddateofbirth) = 1 THEN i.tertiaryinsurancepolicyinsureddateofbirth
			   ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN LEN(i.tertiaryinsurancepolicyinsuredsocialsecuritynumber) >= 6 THEN RIGHT('000' + i.tertiaryinsurancepolicyinsuredsocialsecuritynumber , 9)
			   ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.tertiaryinsurancepolicyinsuredgender IN ('F','FEMALE') THEN 'F'
			   WHEN i.tertiaryinsurancepolicyinsuredgender IN ('M','MALE') THEN 'M'
			   ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN i.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.tertiaryinsurancepolicyinsuredaddressline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.tertiaryinsurancepolicyinsuredaddressline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.tertiaryinsurancepolicyinsuredcity END , -- HolderCity - varchar(128)
          CASE WHEN i.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.tertiaryinsurancepolicyinsuredstate END , -- HolderState - varchar(2)
          CASE WHEN i.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN (CASE WHEN LEN(i.tertiaryinsurancepolicyinsuredzipcode) IN (5,9) THEN i.tertiaryinsurancepolicyinsuredzipcode
																								 WHEN LEN(i.tertiaryinsurancepolicyinsuredzipcode) IN (4,8) THEN '0' + i.tertiaryinsurancepolicyinsuredzipcode
																								 ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN i.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.tertiaryinsurancepolicyinsuredidnumber END , -- DependentPolicyNumber - varchar(32)
          i.tertiaryinsurancepolicyinsurednotes , -- Notes - text
          i.tertiaryinsurancepolicycopay , -- Copay - money
          i.tertiaryinsurancepolicydeductible , -- Deductible - money
          CASE WHEN i.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN i.tertiaryinsurancepolicyinsuredidnumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @targetpracticeid , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_2_CaseInformation]  AS i
INNER JOIN dbo.InsuranceCompanyPlan AS icp  ON
	icp.VendorID = i.tertiaryinsurancepolicycompanyplanid AND
	icp.VendorImportID = @VendorImportID AND
    icp.CreatedPracticeID = @targetpracticeid
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @targetpracticeid  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
SELECT DISTINCT
		  p.PatientID,
          @targetpracticeid , -- PracticeID - int
          sl.ServiceLocationID,  -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.EndDate,  -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
		  0,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.StartDate AS TIME),':',''),4) AS SMALLINT) , --CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.EndDate AS TIME),':',''),4) AS SMALLINT), --CAST(REPLACE(RIGHT(i.EndDate,5), ':','') AS SMALLINT)  -- EndTm - smallint
		  @VendorImportID
		  --SELECT * 
FROM dbo._import_2_2_appointmentdata1 i 
	INNER JOIN dbo.Patient p ON 
		i.LastName = p.LastName AND 
		i.FirstName = p.FirstName AND 
		i.MiddleName = p.MiddleName
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @targetPracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
	INNER JOIN dbo.ServiceLocation sl ON 
		sl.Name = i.servicelocationname AND 
		sl.PracticeID=@targetpracticeid
		--SELECT * FROM dbo.Appointment
		--SELECT * FROM dbo._import_2_2_appointmentdata1
		--select * from servicelocation
	WHERE p.PracticeID = @targetpracticeid

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
          1,--CASE WHEN i.resource = 'Nurse' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          1021,--CASE WHEN i.resource = 'Nurse' THEN (SELECT PracticeResourceID FROM dbo.PracticeResource WHERE ResourceName = 'Nurse' AND PracticeID = @PracticeID)
		  --ELSE (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Irene' AND LastName = 'Edwards' AND PracticeID = @PracticeID AND [External] = 0) 
		  --END  , -- ResourceID - int
          GETDATE(),  -- ModifiedDate - datetime
          @targetpracticeid  -- PracticeID - int
	--SELECT * 
FROM dbo._import_2_2_appointmentdata1 i
	INNER JOIN dbo.Appointment a ON 
		a.StartDate = i.startdate AND 
		a.EndDate = i.enddate 
		--a.PracticeID = 1
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
    ModifiedDate

)
SELECT DISTINCT	
    @targetpracticeid,         -- PracticeID - int
    ip.appointmentreason1,        -- Name - varchar(128)
    DATEDIFF(MINUTE,ip.startdate,ip.enddate),         -- DefaultDurationMinutes - int
    null,      -- DefaultColorCode - int
    ip.notes,        -- Description - varchar(256)
    GETDATE() -- ModifiedDate - datetime
	--SELECT * 
FROM dbo._import_2_2_appointmentdata1 ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.appointmentreason1
AND ar.PracticeID = @targetpracticeid
WHERE ar.name IS NULL 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SELECT * FROM dbo.AppointmentReason WHERE PracticeID=@targetpracticeid

PRINT''
PRINT'Inserting into Appointment to Appointment Reasons...'

INSERT INTO dbo.AppointmentToAppointmentReason
(
    AppointmentID,
    AppointmentReasonID,
    PrimaryAppointment,
    ModifiedDate,
    PracticeID
)
SELECT DISTINCT 
    apt.AppointmentID,         -- AppointmentID - int
    ar.AppointmentReasonID,         -- AppointmentReasonID - int
    1,      -- PrimaryAppointment - bit
    GETDATE(), -- ModifiedDate - datetime
    2          -- PracticeID - int
     

	 --SELECT *
FROM dbo._import_2_2_appointmentdata1 imp
	INNER JOIN dbo.Patient p ON 
		imp.LastName = p.LastName AND 
		imp.FirstName = p.FirstName AND 
		imp.MiddleName = p.MiddleName AND
	p.PracticeID = 2
INNER JOIN dbo.Appointment apt ON
	apt.PatientID = p.PatientID AND
	apt.StartDate = imp.startdate AND 
	apt.EndDate = imp.enddate
INNER JOIN dbo.AppointmentReason ar ON
	ar.Name = imp.appointmentreason1
WHERE p.PracticeID = @targetpracticeid AND ar.PracticeID=@targetpracticeid

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT''
PRINT'Inserting into Contract Rate Schedule...'
INSERT INTO dbo.ContractsAndFees_ContractRateSchedule

(
    PracticeID,
	InsuranceCompanyID,
    EffectiveStartDate,
	EffectiveEndDate,
    SourceType,
    SourceFileName,
    EClaimsNoResponseTrigger,
    PaperClaimsNoResponseTrigger,
    MedicareFeeScheduleGPCICarrier,
    MedicareFeeScheduleGPCILocality,
    MedicareFeeScheduleGPCIBatchID,
    MedicareFeeScheduleRVUBatchID,
    AddPercent,
    AnesthesiaTimeIncrement,
	Capitated
)
SELECT 
    @TargetPracticeID,         -- PracticeID - int
	a.InsuranceCompanyID,
    GETDATE(), -- EffectiveStartDate - datetime
	a.EffectiveEndDate, --EffectiveEndDate
    a.SourceType,        -- SourceType - char(1)
    a.SourceFileName,        -- SourceFileName - varchar(256)
    a.EClaimsNoResponseTrigger,         -- EClaimsNoResponseTrigger - int
    a.PaperClaimsNoResponseTrigger,         -- PaperClaimsNoResponseTrigger - int
    a.MedicareFeeScheduleGPCICarrier,         -- MedicareFeeScheduleGPCICarrier - int
    a.MedicareFeeScheduleGPCILocality,         -- MedicareFeeScheduleGPCILocality - int
    a.MedicareFeeScheduleGPCIBatchID,         -- MedicareFeeScheduleGPCIBatchID - int
    a.MedicareFeeScheduleRVUBatchID,         -- MedicareFeeScheduleRVUBatchID - int
    a.AddPercent,      -- AddPercent - decimal(18, 0)
    a.AnesthesiaTimeIncrement,          -- AnesthesiaTimeIncrement - int
	0 -- capitated
     --SELECT *
FROM dbo.ContractsAndFees_ContractRateSchedule a 
WHERE a.PracticeID=@SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT''
PRINT'Inserting into Contract Rate...'
--SELECT * FROM dbo.ContractsAndFees_ContractRate
--rollback
INSERT INTO dbo.ContractsAndFees_ContractRate
(
    ContractRateScheduleID,
    ProcedureCodeID,
    ModifierID,
    SetFee,
    AnesthesiaBaseUnits
)
SELECT 
   2,    -- ContractRateScheduleID - int
    cr.ProcedureCodeID,    -- ProcedureCodeID - int
    NULL ,    -- ModifierID - int
    cr.SetFee, -- SetFee - money
    0     -- AnesthesiaBaseUnits - int
    
--SELECT cr.*
FROM dbo.ContractsAndFees_ContractRate cr
INNER JOIN dbo.ContractsAndFees_ContractRateSchedule crs
ON crs.ContractRateScheduleID = cr.ContractRateScheduleID
WHERE crs.PracticeID=2

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT''
PRINT'Inserting into Contract Rate Schedule Link'
INSERT INTO dbo.ContractsAndFees_ContractRateScheduleLink
(
    ProviderID,
    LocationID,
    ContractRateScheduleID
)
SELECT 
		  doc.doctorID , -- ProviderID - int
          sl.ServiceLocationID,  -- LocationID - int
          sfs.ContractRateScheduleID  -- ContractRateScheduleID - int
   
FROM dbo.Doctor doc 
INNER JOIN dbo.ServiceLocation sl ON sl.practiceid=doc.PracticeID
INNER JOIN dbo.ContractsAndFees_ContractRateSchedule sfs ON sfs.PracticeID = @targetPracticeID
WHERE doc.[External]<>1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


UPDATE dbo.AppointmentToResource
SET
ResourceID=
--SELECT * 
--,
CASE
WHEN i.resourcename1 LIKE '%tawakol' THEN 1023
WHEN i.resourcename1 LIKE '%gay' THEN 1020
WHEN i.resourcename1 LIKE '%khan' THEN 1024
WHEN i.resourcename1 LIKE '%white' THEN 1021
WHEN i.resourcename1 LIKE '%powell' THEN 1032
ELSE ''
end
FROM dbo._import_2_2_appointmentdata1 i
INNER JOIN dbo.Appointment a ON
a.StartDate = i.startdate AND
a.EndDate = i.enddate
--a.PracticeID = 1
INNER JOIN dbo.AppointmentToResource atr ON
atr.AppointmentID = a.AppointmentID
WHERE a.vendorimportid=1 AND a.PracticeID=2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'