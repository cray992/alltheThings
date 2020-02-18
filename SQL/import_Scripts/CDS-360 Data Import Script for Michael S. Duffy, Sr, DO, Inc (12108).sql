USE superbill_12108_dev
--USE superbill_12108_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 5

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.PracticeToInsuranceCompany WHERE InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Practice to Insurance Company records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'



PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
		  Notes ,
          AddressLine1 ,
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
		  ClearinghousePayerID ,
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
		  i.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
		  i.notes ,
          i.AddressLine1 , -- AddressLine1 - varchar(256)
          i.city , -- City - varchar(128)
          i.state , -- State - varchar(2)
          i.country , -- Country - varchar(32)
          i.zipcode , -- ZipCode - varchar(9)
          i.contactfirstname , -- ContactFirstName - varchar(64)
          i.contactlastname , -- ContactLastName - varchar(64)
          i.phone , -- Phone - varchar(10)
          i.phoneext , -- PhoneExt - varchar(10)
          i.fax , -- Fax - varchar(10)
          i.faxext , -- FaxExt - varchar(10)
          i.billsecondaryinsurance , -- BillSecondaryInsurance - bit
		  i.eclaimsaccepts , 
          i.billingformid , -- BillingFormID - int
		  CASE WHEN ip.insuranceprogramcode IS NULL THEN 'CI' ELSE ip.InsuranceProgramCode END , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          ClearinghousePayerID , -- ClearinghousePayerID - int
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          i.secondaryprecedencebillingformid , -- SecondaryPrecedenceBillingFormID - int
          i.insurancecompanyid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_5_1_InsuranceCompany] i
	LEFT JOIN dbo.InsuranceProgram ip ON
		i.insuranceprogramcode = ip.InsuranceProgramCode 
	INNER JOIN dbo.[_import_5_1_CaseInformation] ci ON
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ip.contactfax , -- Fax - varchar(10)
          ip.contactfaxext , -- FaxExt - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ip.insurancecompanyplanid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_5_1_InsuranceCompanyPlan] ip
INNER JOIN dbo.InsuranceCompany ic ON 
ic.VendorID = ip.insurancecompanyid AND VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Updating Existing Provider Records with VendorID...'
UPDATE dbo.Doctor 
	SET VendorID = i.providerid
FROM dbo.Doctor d
INNER JOIN dbo.[_import_5_1_Providers] i ON
	d.FirstName = i.firstname AND
	d.LastName = i.lastname AND
	d.NPI = i.npi
WHERE d.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


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
		  @PracticeID , -- PracticeID - int
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          i.providerid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- External - bit
          i.npi  -- NPI - varchar(10)
FROM dbo.[_import_5_1_Providers] i WHERE providertype = 'Referring' 
								 AND NOT EXISTS
									(SELECT VendorID, PracticeID FROM dbo.Doctor d 
									 WHERE i.providerid = d.VendorID AND d.PracticeID = @PracticeID)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into PracticetoInsuranceCompany... '
INSERT INTO dbo.PracticeToInsuranceCompany
        ( PracticeID ,
          InsuranceCompanyID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EClaimsEnrollmentStatusID ,
          EClaimsDisable ,
          AcceptAssignment ,
          UseSecondaryElectronicBilling ,
          UseCoordinationOfBenefits ,
          ExcludePatientPayment ,
          BalanceTransfer
        )
SELECT DISTINCT  
		  @PracticeID , -- PracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          ics.eclaimsenrollmentstatusid , -- EClaimsEnrollmentStatusID - int
          ics.eclaimsdisable , -- EClaimsDisable - int
          ics.acceptassignment , -- AcceptAssignment - bit
          ics.usesecondaryelectronicbilling , -- UseSecondaryElectronicBilling - bit
          ics.usecoordinationofbenefits , -- UseCoordinationOfBenefits - bit
          ics.excludepatientpayment , -- ExcludePatientPayment - bit
          ics.balancetransfer  -- BalanceTransfer - bit
FROM dbo.[_import_5_1_InsuranceCompanySettings] ics
INNER JOIN dbo.InsuranceCompany ic ON
ic.VendorID = ics.insurancecompanyid AND
ic.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



--PRINT ''
--PRINT 'Inserting Into Employers...'
--SET IDENTITY_INSERT dbo.Employers ON
--INSERT INTO dbo.Employers
--        ( EmployerID ,
--		  EmployerName ,
--          AddressLine1 ,
--          AddressLine2 ,
--          City ,
--          State ,
--          Country ,
--          ZipCode ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID 
--        )
--SELECT DISTINCT
--		  employerid ,
--		  employername , -- EmployerName - varchar(128)
--          addressline1 , -- AddressLine1 - varchar(256)
--          addressline2 , -- AddressLine2 - varchar(256)
--          city , -- City - varchar(128)
--          state , -- State - varchar(2)
--          '' , -- Country - varchar(32)
--          zipcode , -- ZipCode - varchar(9)
--          GETDATE() , -- CreatedDate - datetime
--          -50 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          -50  -- ModifiedUserID - int
--FROM dbo.[_import_5_1_Employers]
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--SET IDENTITY_INSERT dbo.Employers OFF




--PRINT ''
--PRINT 'Inserting Into Service Location...'
--SET IDENTITY_INSERT dbo.ServiceLocation ON
--INSERT INTO dbo.ServiceLocation
--        ( ServiceLocationID ,
--		  PracticeID ,
--          Name ,
--          AddressLine1 ,
--          AddressLine2 ,
--          City ,
--          State ,
--          Country ,
--          ZipCode ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          PlaceOfServiceCode ,
--          BillingName ,
--          Phone ,
--          PhoneExt ,
--          FaxPhone ,
--          FaxPhoneExt ,
--          CLIANumber ,
--          VendorImportID ,
--          VendorID ,
--          NPI 
--        )
--SELECT DISTINCT  
--		   servicelocationid ,
--		   @PracticeID , -- PracticeID - int
--          internalname , -- Name - varchar(128)
--          addressline1 , -- AddressLine1 - varchar(256)
--          addressline2 , -- AddressLine2 - varchar(256)
--          city , -- City - varchar(128)
--          state , -- State - varchar(2)
--          '' , -- Country - varchar(32)
--          zipcode , -- ZipCode - varchar(9)
--          GETDATE() , -- CreatedDate - datetime
--          -50 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          -50 , -- ModifiedUserID - int
--          CASE placeofservice WHEN 'Assisted Living Facility' THEN '13'
--							  WHEN 'Inpatient Hospital' THEN '21'
--							  WHEN 'Nursing Facility' THEN '32'
--							  WHEN 'Office' THEN '11'
--							  WHEN 'Outpatient Hospital' THEN '22'
--							  WHEN 'Skilled Nursing Facility' THEN '31' ELSE 11 END , -- PlaceOfServiceCode - char(2)
--          billingname , -- BillingName - varchar(128)
--          phonenumber , -- Phone - varchar(10)
--          phonenumberext , -- PhoneExt - varchar(10)
--          faxnumber , -- FaxPhone - varchar(10)
--          faxnumberext , -- FaxPhoneExt - varchar(10)
--          clianumber , -- CLIANumber - varchar(30)
--          @VendorImportID , -- VendorImportID - int
--          servicelocationid , -- VendorID - int
--          npi  -- NPI - varchar(10)
--FROM dbo.[_import_5_1_ServiceLocations]
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--SET IDENTITY_INSERT dbo.ServiceLocation OFF


--Updated with _import_doctor

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
          --DefaultServiceLocationID ,
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
		  @PracticeID , -- PracticeID - int
          rp.DoctorID , -- ReferringPhysicianID - int
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
												ELSE 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantoraddressline1 END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantoraddressline2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorcity END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorstate END , -- ResponsibleState - varchar(2)
          CASE WHEN i.guarantorfirstname <> '' THEN '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorzip END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE i.employmentstatus WHEN 'Employed' THEN 'E'
							      WHEN 'Retired' THEN 'R'
								  WHEN 'Unknown' THEN 'U' ELSE 'U' END , -- EmploymentStatus - char(1)
          drp.DoctorID , -- PrimaryProviderID - int
         -- CASE WHEN i.defaultservicelocationid <> '' THEN i.defaultservicelocationid END , -- DefaultServiceLocationID - int
         -- CASE WHEN i.employerid <> '' THEN i.employerid END , -- EmployerID - int
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
FROM dbo.[_import_5_1_PatientDemographics] i
LEFT JOIN dbo.Doctor rp ON
	rp.VendorID = i.defaultreferringphysicianid AND 
	rp.PracticeID = @PracticeID
LEFT JOIN dbo.Doctor pcp ON
	pcp.VendorID = i.primarycarephysicianid AND
	pcp.PracticeID = @PracticeID
LEFT JOIN dbo.Doctor drp ON
	drp.VendorID = i.defaultrenderingproviderid AND
	drp.PracticeID = @PracticeID AND
	drp.[External] = 0
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '




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
          CaseNumber ,
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
          @PracticeID , -- PracticeID - int
          i.defaultcaseid , -- CaseNumber - varchar(128)
          p.VendorID , -- VendorID - varchar(50)
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
FROM dbo.[_import_5_1_CaseInformation] i
INNER JOIN dbo.Patient p ON
	p.VendorID = i.patientid AND
	p.VendorImportID = @VendorImportID AND
	p.PracticeID = @PracticeID
LEFT JOIN dbo.PayerScenario ps ON
	ps.Name = i.defaultcasepayerscenario
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




--PRINT ''
--PRINT 'Inserting into Patient Case Date - Injury Date...'
--INSERT INTO dbo.PatientCaseDate
--        ( PracticeID ,
--          PatientCaseID ,
--          PatientCaseDateTypeID ,
--          StartDate ,
--          EndDate ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID
--        )
--SELECT DISTINCT
--		  @PracticeID , -- PracticeID - int
--          pc.PatientCaseID , -- PatientCaseID - int
--          2 , -- PatientCaseDateTypeID - int
--          CASE WHEN ISDATE(i.defaultcasedatesinjurystartdate) = 1 THEN i.defaultcasedatesinjurystartdate
--				ELSE NULL END  , -- StartDate - datetime
--          CASE WHEN ISDATE(i.defaultcasedatesinjuryenddate) = 1 THEN i.defaultcasedatesinjuryenddate
--				ELSE NULL END  , -- EndDate - datetime
--          GETDATE() , -- CreatedDate - datetime
--          -50 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          -50  -- ModifiedUserID - int
--FROM dbo.[_import_5_1_CaseInformation] AS i
--INNER JOIN dbo.PatientCase AS pc ON
--	pc.VendorID = i.patientid AND
--	pc.PracticeID = @PracticeID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


      
--PRINT ''
--PRINT 'Inserting into Patient Case Date - Hospital Date...'
--      INSERT INTO dbo.PatientCaseDate
--                  ( PracticeID ,
--                    PatientCaseID ,
--                    PatientCaseDateTypeID ,
--                    StartDate ,
--                    EndDate ,
--                    CreatedDate ,
--                    CreatedUserID ,
--                    ModifiedDate ,
--                    ModifiedUserID
--                  )
--      SELECT DISTINCT
--              @PracticeID , -- PracticeID - int
--                    pc.[PatientCaseID] , -- PatientCaseID - int
--                    6 , -- PatientCaseDateTypeID - int
--                    CASE      WHEN ISDATE(i.defaultcasedatesrelatedhospitalizationstartdate) = 1 THEN i.defaultcasedatesrelatedhospitalizationstartdate
--                              ELSE NULL END , -- StartDate - datetime
--                    CASE      WHEN ISDATE(i.defaultcasedatesrelatedhospitalizationenddate) = 1 THEN i.defaultcasedatesrelatedhospitalizationenddate
--                              ELSE NULL END , -- EndDate - datetime
--                    GETDATE() , -- CreatedDate - datetime
--                    0 , -- CreatedUserID - int
--                    GETDATE() , -- ModifiedDate - datetime
--                    0  -- ModifiedUserID - int
--      FROM dbo.[_import_5_1_CaseInformation] AS i
--      INNER JOIN dbo.PatientCase AS pc ON
--            pc.[VendorID] = i.patientid AND
--            pc.[PracticeID] = @PracticeID AND
--            pc.[VendorImportID] = @VendorImportID
--      WHERE i.defaultcasedatesrelatedhospitalizationstartdate <> ''
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
      


PRINT ''
PRINT 'Inserting Into Patient Journal Note 4...'
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
		  i.mostrecentnote4date , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          i.mostrecentnote4user , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          i.mostrecentnote4message , -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          1  -- LastNote - bit
FROM dbo.[_import_5_1_NotesAlerts] i
INNER JOIN dbo.Patient p ON
i.id = p.VendorID AND
p.VendorImportID = @VendorImportID
WHERE i.mostrecentnote4message <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Patient Journal Note 3...'
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
		  i.mostrecentnote3date , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          mostrecentnote3user , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          i.mostrecentnote3message , -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          1  -- LastNote - bit
FROM dbo.[_import_5_1_NotesAlerts] i
INNER JOIN dbo.Patient p ON
i.id = p.VendorID AND
p.VendorImportID = @VendorImportID
WHERE i.mostrecentnote3message <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Patient Journal Note 2...'
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
		  i.mostrecentnote2date , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          mostrecentnote2user , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          i.mostrecentnote2message , -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          1  -- LastNote - bit
FROM dbo.[_import_5_1_NotesAlerts] i
INNER JOIN dbo.Patient p ON
i.id = p.VendorID AND
p.VendorImportID = @VendorImportID
WHERE i.mostrecentnote2message <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Patient Journal Note 1...'
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
		  i.mostrecentnote1date , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
         -500 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          mostrecentnote1user , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          i.mostrecentnote1message , -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          1  -- LastNote - bit
FROM dbo.[_import_5_1_NotesAlerts] i
INNER JOIN dbo.Patient p ON
i.id = p.VendorID AND
p.VendorImportID = @VendorImportID
WHERE i.mostrecentnote1message <> ''
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          i.AlertShowWhenViewingClaimDetails , -- ShowInClaimFlag - bit
          i.AlertShowWhenPostingPayments , -- ShowInPaymentFlag - bit
          i.AlertShowWhenPreparingPatientStatements -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_5_1_NotesAlerts] i
INNER JOIN dbo.Patient p ON
i.id = p.VendorID AND
p.VendorImportID = @VendorImportID
WHERE i.alertmessage <> ''
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
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp .InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
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
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_5_1_CaseInformation] AS i
INNER JOIN dbo.InsuranceCompanyPlan AS icp  ON
	icp .VendorID = i.primaryinsurancepolicycompanyplanid AND
	icp .VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.patientid AND
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
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
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_5_1_CaseInformation]  AS i
INNER JOIN dbo.InsuranceCompanyPlan AS icp  ON
	icp .VendorID = i.secondaryinsurancepolicycompanyplanid
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.patientid AND
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID  
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
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
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_5_1_CaseInformation]  AS i
INNER JOIN dbo.InsuranceCompanyPlan AS icp  ON
	icp .VendorID = i.tertiaryinsurancepolicycompanyplanid
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.patientid AND
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




--PRINT ''
--PRINT 'Inserting into Standard Fee Schedule...'
--      --Standard Fee Schedule
--      INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
--                  ( PracticeID ,
--                    Name ,
--                    Notes ,
--                    EffectiveStartDate ,
--                    SourceType ,
--                    SourceFileName ,
--                    EClaimsNoResponseTrigger ,
--                    PaperClaimsNoResponseTrigger ,
--                    MedicareFeeScheduleGPCICarrier ,
--                    MedicareFeeScheduleGPCILocality ,
--                    MedicareFeeScheduleGPCIBatchID ,
--                    MedicareFeeScheduleRVUBatchID ,
--                    AddPercent ,
--                    AnesthesiaTimeIncrement
--                  )
--      VALUES  
--                  ( 
--                    @PracticeID , -- PracticeID - int
--                    'Default Contract' , -- Name - varchar(128)
--                    'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
--                    GETDATE() , -- EffectiveStartDate - datetime
--                    'F' , -- SourceType - char(1)
--                    'Import File' , -- SourceFileName - varchar(256)
--                    30 , -- EClaimsNoResponseTrigger - int
--                    30 , -- PaperClaimsNoResponseTrigger - int
--                    NULL , -- MedicareFeeScheduleGPCICarrier - int
--                    NULL , -- MedicareFeeScheduleGPCILocality - int
--                    NULL , -- MedicareFeeScheduleGPCIBatchID - int
--                    NULL , -- MedicareFeeScheduleRVUBatchID - int
--                    0 , -- AddPercent - decimal
--                    15  -- AnesthesiaTimeIncrement - int
--                  )
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--PRINT ''
--PRINT 'Inserting into Standard Fee...'
--      --StandardFee
--      INSERT INTO dbo.ContractsAndFees_StandardFee
--                  ( StandardFeeScheduleID ,
--                    ProcedureCodeID ,
--                    ModifierID ,
--                    SetFee ,
--                    AnesthesiaBaseUnits
--                  )
--      SELECT DISTINCT
--                    sfs.[StandardFeeScheduleID], -- StandardFeeScheduleID - int
--                    pcd.[ProcedureCodeDictionaryID] , -- ProcedureCodeID - int
--                    pm.[ProcedureModifierID] , -- ModifierID - int
--                    Impsfs.fee , -- SetFee - money
--                    0  -- AnesthesiaBaseUnits - int
--      FROM dbo.[_import_0_1_FeeSchedule] AS Impsfs
--      INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule AS sfs ON
--            CAST(sfs.[Notes] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
--            sfs.PracticeID = @PracticeID  
--      INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
--            pcd.[ProcedureCode] = Impsfs.code
--      LEFT JOIN dbo.ProcedureModifier AS pm ON
--            pm.[ProcedureModifierCode] = Impsfs.modifier
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT ''
--PRINT 'Inserting into Standard Fee Schedule Link...'
--      --Standard Fee Schedule Link
--      INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
--                  ( ProviderID ,
--                    LocationID ,
--                    StandardFeeScheduleID
--                  )
--      SELECT DISTINCT
--                    doc.[DoctorID] , -- ProviderID - int
--                    sl.[ServiceLocationID] , -- LocationID - int
--                    sfs.[StandardFeeScheduleID]  -- StandardFeeScheduleID - int
--      FROM dbo.Doctor AS doc, dbo.ServiceLocation AS sl, dbo.ContractsAndFees_StandardFeeSchedule AS sfs
--      WHERE doc.[External] = 0 AND
--            doc.[PracticeID] = @PracticeID AND
--            sl.PracticeID = @PracticeID AND
--            sfs.[Notes] = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
--            sfs.PracticeID = @PracticeID    
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Updating Patient Cases with no Policies...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11 ,
		Name = 'Self Pay'
FROM dbo.PatientCase pc
LEFT JOIN dbo.InsurancePolicy ip ON
		pc.PatientCaseID = ip.PatientCaseID  
WHERE pc.VendorImportID = @VendorImportID AND
      ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--COMMIT
--ROLLBACK

