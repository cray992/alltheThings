USE superbill_25977_dev
--USE superbill_25977_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 1
SET @PracticeID = 4

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

/*
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.ServiceLocation WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
*/

PRINT ''
PRINT 'Updating Insurance Company Records to All Practice...'
UPDATE dbo.InsuranceCompany
	SET ReviewCode = 'R'
FROM dbo.InsuranceCompany ic	
	INNER JOIN dbo.[_import_13_4_CaseInformation] i ON
		ic.insurancecompanyid = i.primaryinsurancepolicycompanyid OR
		ic.insurancecompanyid = i.secondaryinsurancepolicycompanyid OR
		ic.insurancecompanyid = i.tertiaryinsurancepolicycompanyid
WHERE ReviewCode = '' 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '
---Just incase

PRINT ''
PRINT 'Updating Insurance Company Plan Records to All Practice...'
UPDATE dbo.InsuranceCompanyPlan
	SET ReviewCode = 'R'
FROM dbo.InsuranceCompanyPlan ic
	INNER JOIN dbo.[_import_13_4_CaseInformation] i ON
		ic.insurancecompanyid = i.primaryinsurancepolicycompanyplanid OR
		ic.insurancecompanyid = i.secondaryinsurancepolicycompanyplanid OR
		ic.insurancecompanyid = i.tertiaryinsurancepolicycompanyplanid 
WHERE ReviewCode = '' 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Inserting Into Referring Providers...'
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
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          PagerPhone ,
          PagerPhoneExt ,
          MobilePhone ,
          MobilePhoneExt ,
          DOB ,
          EmailAddress ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          DefaultEncounterTemplateID ,
          TaxonomyCode ,
          DepartmentID ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          FaxNumberExt ,
          OrigReferringPhysicianID ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          d.Prefix , -- Prefix - varchar(16)
          d.FirstName , -- FirstName - varchar(64)
          d.MiddleName , -- MiddleName - varchar(64)
          d.LastName , -- LastName - varchar(64)
          d.Suffix , -- Suffix - varchar(16)
          d.SSN , -- SSN - varchar(9)
          d.AddressLine1 , -- AddressLine1 - varchar(256)
          d.AddressLine2 , -- AddressLine2 - varchar(256)
          d.City , -- City - varchar(128)
          d.[State] , -- State - varchar(2)
          d.Country , -- Country - varchar(32)
          d.ZipCode , -- ZipCode - varchar(9)
          d.HomePhone , -- HomePhone - varchar(10)
          d.HomePhoneExt , -- HomePhoneExt - varchar(10)
          d.WorkPhone , -- WorkPhone - varchar(10)
          d.WorkPhoneExt, -- WorkPhoneExt - varchar(10)
          d.PagerPhone , -- PagerPhone - varchar(10)
          d.PagerPhoneExt , -- PagerPhoneExt - varchar(10)
          d.MobilePhone , -- MobilePhone - varchar(10)
          d.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
          d.DOB , -- DOB - datetime
          d.EmailAddress , -- EmailAddress - varchar(256)
          d.ActiveDoctor , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          d.Degree , -- Degree - varchar(8)
          d.DefaultEncounterTemplateID , -- DefaultEncounterTemplateID - int
          d.TaxonomyCode , -- TaxonomyCode - char(10)
          d.DepartmentID , -- DepartmentID - int
          d.DoctorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          d.FaxNumber , -- FaxNumber - varchar(10)
          d.FaxNumberExt , -- FaxNumberExt - varchar(10)
          d.OrigReferringPhysicianID , -- OrigReferringPhysicianID - int
          1 , -- External - bit
          d.NPI  -- NPI - varchar(10)
FROM dbo.Doctor d
	INNER JOIN dbo.[_import_13_4_PatientDemographics] i ON
		d.DoctorID = i.defaultreferringphysicianid OR
		d.DoctorID = i.primarycarephysicianid AND
		d.[External] = 1
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '



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
          NPI ,
          TimeZoneID 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          internalname , -- Name - varchar(128)
          addressline1 , -- AddressLine1 - varchar(256)
          addressline2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          zipcode , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE placeofservice WHEN 'Assisted Living Facility' THEN '13'
							  WHEN 'Inpatient Hospital' THEN '21'
							  WHEN 'Nursing Facility' THEN '32'
							  WHEN 'Office' THEN '11'
							  WHEN 'Outpatient Hospital' THEN '22'
							  WHEN 'Skilled Nursing Facility' THEN '31' ELSE 11 END , -- PlaceOfServiceCode - char(2)
          billingname , -- BillingName - varchar(128)
          phonenumber , -- Phone - varchar(10)
          phonenumberext , -- PhoneExt - varchar(10)
          faxnumber , -- FaxPhone - varchar(10)
          faxnumberext , -- FaxPhoneExt - varchar(10)
          clianumber , -- CLIANumber - varchar(30)
          @VendorImportID , -- VendorImportID - int
          servicelocationid , -- VendorID - int
          npi , -- NPI - varchar(10)
          15  -- TimeZoneID - int
FROM dbo.[_import_13_4_ServiceLocations]
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '



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
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt ,
		  PrimaryCarePhysicianID ,
		  PatientReferralSourceID
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          CASE WHEN i.defaultreferringphysicianid <> '' THEN 
		   CASE WHEN i.defaultreferringphysicianid IN (12, 199) THEN 144
			    WHEN i.defaultreferringphysicianid IN (292, 44) THEN 13
			    WHEN i.defaultreferringphysicianid IN (15, 18) THEN 146
			    WHEN i.defaultreferringphysicianid IN (19, 165, 142) THEN 145
				WHEN i.defaultreferringphysicianid IN (655, 660, 646) THEN 640
				WHEN i.defaultreferringphysicianid IN (653 , 374, 645) THEN 639
				WHEN i.defaultreferringphysicianid IN (656, 659, 648) THEN 143
				WHEN i.defaultreferringphysicianid IN (658, 275) THEN 643
				WHEN i.defaultreferringphysicianid IN (657, 661, 649) THEN 642
				WHEN i.defaultreferringphysicianid IN (654, 662, 647) THEN 641
				WHEN i.defaultreferringphysicianid IN (663, 650) THEN 644
			    ELSE rp.doctorid END ELSE NULL END, -- ReferringPhysicianID - int
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE i.employmentstatus WHEN 'Employed' THEN 'E'
							      WHEN 'Retired' THEN 'R'
								  WHEN 'Unknown' THEN 'U' 
								  WHEN 'Student, Full-Time' THEN 'S' 
								  WHEN 'Student, Part-Time' THEN 'T' 
								  ELSE 'U' END , -- EmploymentStatus - char(1)
          CASE WHEN i.defaultrenderingproviderid <> '' THEN 
		   CASE WHEN i.defaultrenderingproviderid IN (12, 199) THEN 144
			    WHEN i.defaultrenderingproviderid IN (292, 44) THEN 13
			    WHEN i.defaultrenderingproviderid IN (15, 18) THEN 146
			    WHEN i.defaultrenderingproviderid IN (19, 165, 142) THEN 145
				WHEN i.defaultrenderingproviderid IN (655, 660, 646) THEN 640
				WHEN i.defaultrenderingproviderid IN (653 , 374, 645) THEN 639
				WHEN i.defaultrenderingproviderid IN (656, 659, 648) THEN 143
				WHEN i.defaultrenderingproviderid IN (658, 275) THEN 643
				WHEN i.defaultrenderingproviderid IN (657, 661, 649) THEN 642
				WHEN i.defaultrenderingproviderid IN (654, 662, 647) THEN 641
				WHEN i.defaultrenderingproviderid IN (663, 650) THEN 644
			    ELSE NULL END ELSE NULL END  , -- PrimaryProviderID - int , -- PrimaryProviderID - int
          CASE WHEN i.defaultservicelocationid <> '' THEN sl.ServiceLocationID END , -- DefaultServiceLocationID - int
          i.medicalrecordnumber , -- MedicalRecordNumber - varchar(128)
          i.mobilephone , -- MobilePhone - varchar(10)
          i.mobilephoneext , -- MobilePhoneExt - varchar(10)
          i.newpatientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE i.active WHEN 'FALSE' THEN 0 WHEN 'TRUE' THEN 1 ELSE 1 END , -- Active - bit
          CASE i.sendemailnotifications WHEN 'FALSE' THEN 0 WHEN 'TRUE' THEN 1 ELSE 0 END , -- SendEmailCorrespondence - bit
          i.emergencyname , -- EmergencyName - varchar(128)
          i.emergencyphone , -- EmergencyPhone - varchar(10)
          i.emergencyphoneext , -- EmergencyPhoneExt - varchar(10)
		  CASE WHEN i.primarycarephysicianid <> '' THEN 
		   CASE WHEN i.primarycarephysicianid IN (12, 199) THEN 144
			    WHEN i.primarycarephysicianid IN (292, 44) THEN 13
			    WHEN i.primarycarephysicianid IN (15, 18) THEN 146
			    WHEN i.primarycarephysicianid IN (19, 165, 142) THEN 145
				WHEN i.primarycarephysicianid IN (655, 660, 646) THEN 640
				WHEN i.primarycarephysicianid IN (653 , 374, 645) THEN 639
				WHEN i.primarycarephysicianid IN (656, 659, 648) THEN 143
				WHEN i.primarycarephysicianid IN (658, 275) THEN 643
				WHEN i.primarycarephysicianid IN (657, 661, 649) THEN 642
				WHEN i.primarycarephysicianid IN (654, 662, 647) THEN 641
				WHEN i.primarycarephysicianid IN (663, 650) THEN 644
			    ELSE pcp.DoctorID END ELSE NULL END , -- PrimaryCarePhysicianID - int
		  prs.PatientReferralSourceID -- PatientReferralSourceID - int
FROM dbo.[_import_13_4_PatientDemographics] i
LEFT JOIN dbo.Doctor rp ON
	rp.VendorID = i.defaultreferringphysicianid AND 
	rp.PracticeID = @PracticeID 
LEFT JOIN dbo.Doctor pcp ON
	pcp.VendorID = i.primarycarephysicianid AND
	pcp.PracticeID = @PracticeID
LEFT JOIN dbo.ServiceLocation sl ON	
	i.defaultservicelocationid = sl.VendorID AND
	sl.PracticeID = @PracticeID
LEFT JOIN dbo.PatientReferralSource prs ON
	prs.[Description] = i.referralsource AND
	prs.PracticeID = @PracticeID
WHERE NOT EXISTS (SELECT FirstName, LastName, DOB FROM dbo.Patient p 
					WHERE i.firstname = p.FirstName AND 
						  i.lastname = p.LastName AND
						  DATEADD(hh,12,CAST(dateofbirth AS DATETIME)) = p.DOB AND
						  p.PracticeID = @PracticeID)
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
          CASE i.defaultcaseconditionrelatedtoemployment WHEN 1 THEN 1 ELSE 0 END , -- EmploymentRelatedFlag - bit
          CASE i.defaultcaseconditionrelatedtoautoaccident WHEN 1 THEN 1 ELSE 0 END , -- AutoAccidentRelatedFlag - bit
          CASE i.defaultcaseconditionrelatedtoother WHEN 1 THEN 1 ELSE 0 END , -- OtherAccidentRelatedFlag - bit
          CASE i.defaultcaseconditionrelatedtoabuse WHEN 1 THEN 1 ELSE 0 END , -- AbuseRelatedFlag - bit
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
          p.VendorID + i.defaultcaseid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE i.defaultcaseconditionrelatedtopregnancy WHEN 1 THEN 1 ELSE 0 END , -- PregnancyRelatedFlag - bit
          CASE i.defaultcasesendpatientstatements WHEN 1 THEN 1 ELSE 0 END , -- StatementActive - bit
          CASE i.defaultcaseconditionrelatedtoepsdt WHEN 1 THEN 1 ELSE 0 END , -- EPSDT - bit
          CASE i.defaultcaseconditionrelatedtofamilyplanning WHEN 1 THEN 1 ELSE 0 END , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          CASE i.defaultcaseconditionrelatedtoemergency WHEN 1 THEN 1 ELSE 0 END , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_13_4_CaseInformation] i
INNER JOIN dbo.Patient p ON
	p.VendorID = i.newpatientid AND
	p.VendorImportID = @VendorImportID AND
	p.PracticeID = @PracticeID
LEFT JOIN dbo.PayerScenario ps ON
	ps.Name = i.defaultcasepayerscenario
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
         -50 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          mostrecentnote1user , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          i.mostrecentnote1message , -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_13_4_NotesAlerts] i
INNER JOIN dbo.Patient p ON
i.id = p.VendorID AND
p.VendorImportID = @VendorImportID
WHERE i.mostrecentnote1message <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Patient Journal Note 2 to mark imported patients...'
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
		  GETDATE(), -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
         -50 , -- ModifiedUserID - int
          PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          'Created via Data Import. Please verify before use.', -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          1  -- LastNote - bit
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
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
		  PolicyEndDate ,
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
          VendorImportID ,
		  Copay
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          i.primaryinsurancepolicycompanyplanid , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.primaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          i.primaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.primaryinsurancepolicyeffectivestartdate) = 1 THEN i.primaryinsurancepolicyeffectivestartdate
			   ELSE NULL END , -- PolicyStartDate - datetime
		  CASE WHEN ISDATE(i.primaryinsurancepolicyeffectiveenddate) = 1 THEN i.primaryinsurancepolicyeffectiveenddate
			   ELSE NULL END , -- PolicyEndDate - datetime
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
          @VendorImportID , -- VendorImportID - int
		  i.primaryinsurancepolicycopay
FROM dbo.[_import_13_4_CaseInformation] AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.newpatientid + i.defaultcaseid AND
	pc.VendorImportID = @VendorImportID 
WHERE i.primaryinsurancepolicycompanyplanid <> '' 
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
		  PolicyEndDate ,
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
          i.secondaryinsurancepolicycompanyplanid , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.secondaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          i.secondaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.secondaryinsurancepolicyeffectivestartdate) = 1 THEN i.secondaryinsurancepolicyeffectivestartdate
			   ELSE NULL END , -- PolicyStartDate - datetime
		  CASE WHEN ISDATE(i.secondaryinsurancepolicyeffectiveenddate) = 1 THEN i.secondaryinsurancepolicyeffectiveenddate
			   ELSE NULL END , -- PolicyEndDate - datetime
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
FROM dbo.[_import_13_4_CaseInformation]  AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.newpatientid + i.defaultcaseid AND
	pc.VendorImportID = @VendorImportID
WHERE i.secondaryinsurancepolicycompanyplanid <> '' 
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
		  PolicyEndDate ,
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
          i.tertiaryinsurancepolicycompanyplanid, -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          i.tertiaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          i.tertiaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.tertiaryinsurancepolicyeffectivestartdate) = 1 THEN i.tertiaryinsurancepolicyeffectivestartdate
			   ELSE NULL END , -- PolicyStartDate - datetime
		  CASE WHEN ISDATE(i.tertiaryinsurancepolicyeffectiveenddate) = 1 THEN i.tertiaryinsurancepolicyeffectiveenddate
			   ELSE NULL END , -- PolicyEndDate - datetime
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
FROM dbo.[_import_13_4_CaseInformation]  AS i
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = i.newpatientid + i.defaultcaseid AND
	pc.VendorImportID = @VendorImportID
WHERE i.tertiaryinsurancepolicycompanyplanid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
	      p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          sl.ServiceLocationID , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.appointmenttype , -- AppointmentType - varchar(1)
          i.appointmentid , -- Subject - varchar(64)
          i.notes , -- Notes - text 
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          i.appointmentresourcetypeid , -- AppointmentResourceTypeID - int
          i.appointmentconfirmationstatuscode , -- AppointmentConfirmationStatusCode - char(1)
          CASE WHEN i.patientcaseid <> '' THEN pc.PatientCaseID ELSE NULL END, -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_13_4_Appointment] i
	INNER JOIN dbo.Patient p ON
		i.newpatientid = p.VendorID AND
		p.VendorImportID = @VendorImportID AND
		p.PracticeID = @PracticeID
	INNER JOIN dbo.ServiceLocation sl ON
	 	i.servicelocationid = sl.VendorID AND
	 	sl.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON 
		pc.CaseNumber = i.patientcaseid AND 
		pc.PracticeID = @PracticeID
	INNER JOIN dbo.DateKeyToPractice dk ON
		dk.PracticeID = @PracticeID AND
		dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Practice Resource...'
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
SELECT DISTINCT
		  i.practiceresourcetypeid , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          i.resourcename , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
FROM dbo.[_import_13_4_PracticeResource] i
WHERE NOT EXISTS (SELECT resourcename FROM dbo.PracticeResource pr WHERE pr.resourcename = i.resourcename AND pr.PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Appointment Reason...'
INSERT INTO dbo.AppointmentReason
	    ( 
		  practiceid ,
          name ,
          defaultdurationminutes ,
          defaultcolorcode ,
          description ,
          modifieddate 
        )
SELECT DISTINCT
          @PracticeID , -- practiceid - varchar(max)
          i.name , -- name - varchar(max)
          '15' , -- defaultdurationminutes - varchar(max)
          i.defaultcolorcode , -- defaultcolorcode - varchar(max)
          i.[description] , -- description - varchar(max)
          GETDATE()  -- modifieddate - varchar(max)
FROM dbo.[_import_13_4_AppointmentReason] i
WHERE NOT EXISTS (SELECT name FROM dbo.AppointmentReason ar WHERE i.name = ar.Name AND ar.PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into AppointmenttoResource Type 2....'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          2 , -- AppointmentResourceTypeID - int
          pr.PracticeResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_13_4_AppointmentToResource] i
	INNER JOIN dbo.Appointment a ON
		CAST(i.appointmentstartdate AS DATETIME) = a.StartDate AND
		CAST(i.appointmentenddate AS DATETIME) = a.EndDate AND
		a.[Subject] = i.appointmentid AND
		a.PracticeID = @PracticeID 
	INNER JOIN dbo.PracticeResource pr ON
		i.appointmenttoresourcename = pr.ResourceName AND
		pr.PracticeID = @PracticeID
WHERE i.appointmentresourcetypeid = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Creating Practice Resource for Missing Providers...'
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
VALUES  ( 3 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          'Missing Provider' , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
        )
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into AppointmenttoResource Type 1....'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
		  CASE WHEN i.resourceid IN (12, 199) THEN 1
			   WHEN i.resourceid IN (292, 44) THEN 1
			   WHEN i.resourceid IN (15, 18) THEN 1
			   WHEN i.resourceid IN (19, 165, 142) THEN 1
		  	   WHEN i.resourceid IN (655, 660, 646) THEN 1
			   WHEN i.resourceid IN (653 , 374, 645) THEN 1
			   WHEN i.resourceid IN (656, 659, 648) THEN 1
			   WHEN i.resourceid IN (658, 275) THEN 1
			   WHEN i.resourceid IN (657, 661, 649) THEN 1
			   WHEN i.resourceid IN (654, 662, 647) THEN 1
			   WHEN i.resourceid IN (663, 650) THEN 1 
			   ELSE 2 END , -- AppointmentResourceTypeID - int
		  CASE WHEN i.resourceid IN (12, 199) THEN 144
			   WHEN i.resourceid IN (292, 44) THEN 13
			   WHEN i.resourceid IN (15, 18) THEN 146
			   WHEN i.resourceid IN (19, 165, 142) THEN 145
		  	   WHEN i.resourceid IN (655, 660, 646) THEN 640
			   WHEN i.resourceid IN (653 , 374, 645) THEN 639
			   WHEN i.resourceid IN (656, 659, 648) THEN 143
			   WHEN i.resourceid IN (658, 275) THEN 643
			   WHEN i.resourceid IN (657, 661, 649) THEN 642
			   WHEN i.resourceid IN (654, 662, 647) THEN 641
			   WHEN i.resourceid IN (663, 650) THEN 644 
			   ELSE pr.PracticeResourceID END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_13_4_AppointmentToResource] i
	INNER JOIN dbo.Appointment a ON
		CAST(i.appointmentstartdate AS DATETIME) = a.StartDate AND
		CAST(i.appointmentenddate AS DATETIME) = a.EndDate AND
		a.[Subject] = i.appointmentid AND
		a.PracticeID = @PracticeID 
	LEFT JOIN dbo.PracticeResource pr ON
		pr.ResourceName = 'Missing Provider' AND
		pr.PracticeID = @PracticeID
WHERE i.appointmentresourcetypeid = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Appointment to Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_13_4_Appointment i
	INNER JOIN dbo.Appointment a ON
		CAST(i.startdate AS DATETIME) = a.StartDate AND
		CAST(i.enddate AS DATETIME) = a.EndDate AND
		a.[Subject] = i.appointmentid AND
		a.PracticeID = @PracticeID 
	INNER JOIN dbo.AppointmentReason ar ON
		i.appointmentreason = ar.Name AND
		ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




--COMMIT
--ROLLBACK
