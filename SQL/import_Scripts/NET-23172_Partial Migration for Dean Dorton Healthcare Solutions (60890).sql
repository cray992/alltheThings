USE superbill_60890_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--ALTER TABLE dbo.Appointment ADD vendorimportid INT 
--ALTER TABLE dbo._import_3_8_appointments ADD name VARCHAR(50)

DECLARE @sourcepracticeID INT 
DECLARE @targetPracticeID INT
DECLARE @VendorImportID INT

SET @sourcepracticeID = 1
SET @targetPracticeID = 8
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
          19 ,  -- InstitutionalBillingFormID - int
		  i.clearinghousepayerid
		  --SELECT * FROM dbo.InsuranceCompany
FROM dbo._import_2_8_InsuranceCompany i
	LEFT JOIN dbo.InsuranceProgram ip ON
		i.insuranceprogram = ip.ProgramName 
	INNER JOIN dbo.[_import_2_8_CaseInformation] ci ON
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
FROM dbo.[_import_2_8_InsuranceCompanyPlan] ip
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.VendorID = ip.insurancecompanyid AND 
	VendorImportID = @VendorImportID AND 
	ic.CreatedPracticeID = @targetpracticeid
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



--CREATE TABLE #tempsl
--( PatientID INT , slID INT )
--INSERT INTO #tempsl
--        ( PatientID, slID )
--SELECT DISTINCT
--		   i.id , 
--		   sl.ServiceLocationID
--FROM dbo._import_2_8_PatientDemographics i 
--INNER JOIN dbo._import_2_8_ServiceLocations isl ON 
--	i.id = isl.servicelocationid
--INNER JOIN dbo.ServiceLocation sl ON 
--	isl.internalname = sl.Name AND 
--	isl.addressline1 = sl.AddressLine1 AND 
--	sl.PracticeID = @targetPracticeID

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
          NULL ,--rp.DoctorID , -- ReferringPhysicianID - int
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
          NULL, --tsl.slID , -- DefaultServiceLocationID - int
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
		  --SELECT * 
FROM dbo.[_import_2_8_PatientDemographics] i
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
--LEFT JOIN #tempsl tsl ON 
--	i.id = tsl.PatientID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

--UPDATE  p SET 
--p.ReferringPhysicianID = id.defaultreferringphysicianid
----SELECT * 
--FROM dbo._import_2_8_PatientDemographics id 
--INNER JOIN dbo.Patient p ON p.PatientID = id.id


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
		  --SELECT * 
FROM dbo.[_import_2_8_CaseInformation] i
INNER JOIN dbo.Patient p ON
	p.VendorID = i.patientid AND
	p.VendorImportID = @VendorImportID AND
	p.PracticeID = @targetpracticeid
LEFT JOIN dbo.PayerScenario ps ON
	ps.Name = i.defaultcasepayerscenario
WHERE i.defaultcaseid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- PatientCaseDate data. Exists? Begin
IF (SELECT COUNT(*) FROM dbo._import_2_8_CaseInformation WHERE defaultcasedatesinjurystartdate <> '') >= 1 
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
FROM dbo.[_import_2_8_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedatesinjurystartdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_2_8_CaseInformation WHERE DefaultCaseDatesSameOrSimilarIllnessStartDate <> '') >= 1 
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
FROM dbo.[_import_2_8_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.DefaultCaseDatesSameOrSimilarIllnessStartDate <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_2_8_CaseInformation WHERE DefaultCaseDatesUnableToWorkStartDate <> '') >= 1 
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
FROM dbo.[_import_2_8_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.DefaultCaseDatesUnableToWorkStartDate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_2_8_CaseInformation WHERE DefaultCaseDatesRelatedDisabilityStartDate <> '') >= 1 
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
FROM dbo.[_import_2_8_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.DefaultCaseDatesRelatedDisabilityStartDate <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_2_8_CaseInformation WHERE DefaultCaseDatesRelatedHospitalizationStartDate <> '') >= 1 
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
FROM dbo.[_import_2_8_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedatesrelatedhospitalizationstartdate <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_2_8_CaseInformation WHERE DefaultCaseDatesLastMenstrualPeriodDate <> '') >= 1 
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
FROM dbo.[_import_2_8_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.DefaultCaseDatesLastMenstrualPeriodDate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_2_8_CaseInformation WHERE defaultcasedateslastseendate <> '') >= 1 
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
FROM dbo.[_import_2_8_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedateslastseendate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_2_8_CaseInformation WHERE defaultcasedatesreferraldate <> '') >= 1 
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
FROM dbo.[_import_2_8_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedatesreferraldate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_2_8_CaseInformation WHERE defaultcasedatesacutemanifestationdate <> '') >= 1 
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
FROM dbo.[_import_2_8_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedatesacutemanifestationdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_2_8_CaseInformation WHERE defaultcasedateslastxraydate <> '') >= 1 
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
FROM dbo.[_import_2_8_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedateslastxraydate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

IF (SELECT COUNT(*) FROM dbo._import_2_8_CaseInformation WHERE defaultcasedatesaccidentdate <> '') >= 1 
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
FROM dbo.[_import_2_8_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.defaultcaseid AND
	pc.PracticeID = @targetpracticeid
WHERE i.defaultcasedatesaccidentdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

END

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
FROM dbo.[_import_2_8_CaseInformation] AS i
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
FROM dbo.[_import_2_8_CaseInformation]  AS i
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
FROM dbo.[_import_2_8_CaseInformation]  AS i
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
WHERE --NOT EXISTS
--(
--    SELECT *
--    FROM dbo.ServiceLocation d 
--    WHERE d.Name = sl.Name
--          AND d.PracticeID = 8
--) AND 
	sl.PracticeID = 1;
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated';

--commit
--------------------------------------------------------------------------
----Appointments

UPDATE i SET 
i.name = sl.Name
--SELECT * 
FROM dbo.ServiceLocation sl 
	INNER JOIN dbo._import_3_8_appointments i ON
		i.servicelocationid = sl.ServiceLocationID

UPDATE i SET 
i.servicelocationid = sl.ServiceLocationID
--SELECT distinct * 
FROM dbo.ServiceLocation sl 
	INNER JOIN dbo._import_3_8_appointments i ON
		i.name = sl.Name
WHERE sl.PracticeID = @targetPracticeID




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
		  i.servicelocationid,  -- ServiceLocationID - int
          i.startdate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentstarttime , -- StartDate - datetime
          i.enddate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentendtime,  -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
		  AppointmentConfirmationStatusCode,
   --       CASE i.
			--WHEN 'cancelled' THEN 'X'
			--WHEN 'check-In' THEN 'I'
			--WHEN 'confirmed' THEN 'C'
			--WHEN 'no-show' THEN 'N'
			--WHEN 'rescheduled' THEN 'R'
			--WHEN 'scheduled' THEN 'S'
			--ELSE'' END , -- AppointmentConfirmationStatusCode - char(1)
		  0,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.startdate AS TIME),':',''),4) AS SMALLINT), -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.enddate AS TIME),':',''),4) AS SMALLINT),  -- EndTm - smallint
		  @VendorImportID
		  --SELECT distinct i.*
FROM dbo._import_3_8_appointments i 
	--INNER JOIN dbo._import_44_61_PatientDemographics d ON 
	--	d.chartnumber = i.chartnumber
	INNER JOIN dbo.Patient p ON 
		i.lastname = p.LastName AND 
		i.firstname = p.FirstName AND 
		--CAST(d.dateofbirth AS DATE) = CAST(p.DOB AS DATE) AND 
		--d.chartnumber = p.VendorID AND 
		p.PracticeID = @targetPracticeID 
	INNER JOIN dbo.ServiceLocation sl ON 
		sl.Name = i.name AND 
		sl.PracticeID = @targetPracticeID
--SELECT * FROM dbo.ServiceLocation WHERE practiceid=61
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @targetPracticeID AND
		DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
WHERE p.PracticeID = @targetPracticeID
		--AND p.lastname = 'ordaz'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--UPDATE sl SET 
--sl.RevenueCode = '0521', 
--sl.TimeZoneID = 15

--FROM dbo.ServiceLocation sl WHERE billingname = 'Cardiovascular Medical Specialists LLC'--PracticeID IN (8,1)




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
			--CASE 
			--	WHEN i.doctorlastname = 'Jamison' THEN 5350
			--	WHEN i.doctorlastname = 'Bright' THEN 5347
			--	WHEN i.doctorlastname = 'Hart' THEN 5349
			--	WHEN i.doctorlastname = 'Reiersen' THEN 5351
			--	WHEN i.doctorlastname = 'Sweetnam' THEN 5352
			--ELSE '' END ,
		  195,
          GETDATE(),  -- ModifiedDate - datetime
          @targetPracticeID,  -- PracticeID - int
		  @VendorImportID
		
	--SELECT i.*
FROM dbo._import_3_8_appointments i 
	--INNER JOIN dbo._import_44_61_PatientDemographics d ON 
	--	d.chartnumber = i.chartnumber
	INNER JOIN dbo.Patient p ON 
		i.lastname = p.LastName AND 
		i.firstname = p.FirstName AND 
		--CAST(d.dateofbirth AS DATE) = CAST(p.DOB AS DATE) AND 
		p.PracticeID = @targetPracticeID 		
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		a.StartDate = i.startdate AND 
		a.EndDate = i.enddate AND 
		a.PracticeID = @targetPracticeID
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--SELECT * FROM dbo.Appointment WHERE PracticeID = 8
--SELECT * FROM dbo.Patient WHERE patientid=13055
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
    8,         -- PracticeID - int
    ip.resourcename,        -- Name - varchar(128)
    DATEDIFF(MINUTE,ip.startdate,ip.enddate),         -- DefaultDurationMinutes - int
    null,      -- DefaultColorCode - int
    ip.resourcename,        -- Description - varchar(256)
    GETDATE(), -- ModifiedDate - datetime
	9
	--SELECT *
FROM dbo._import_3_8_appointments ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.resourcename
--AND ar.PracticeID = 8
--WHERE ar.name IS NULL 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--SELECT * FROM dbo.AppointmentToResource WHERE PracticeID = 8

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
FROM _import_3_8_Appointments iapt
	--INNER JOIN dbo._import_44_61_PatientDemographics pd ON 
	--	pd.chartnumber = iapt.chartnumber
	INNER JOIN dbo.AppointmentReason ar ON 
		ar.Name = iapt.resourcename AND 
		ar.PracticeID = @targetPracticeID
	INNER JOIN dbo.Patient p ON 
		--pd.chartnumber = p.medicalrecordnumber
		p.LastName = iapt.lastname AND 
        p.FirstName = iapt.firstname
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		CAST(a.StartDate AS DATETIME) = CAST(iapt.startdate AS DATETIME) AND 
		CAST(a.EndDate AS DATETIME) = CAST(iapt.enddate AS DATETIME) AND 
		a.PracticeID = @targetPracticeID    --CONVERT(VARCHAR,CAST(iapt.appointmentdate AS DATETIME),120)+ CAST(iapt.appointmentstarttime AS DATETIME)
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())
GROUP BY a.AppointmentID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

------rollback
------commit