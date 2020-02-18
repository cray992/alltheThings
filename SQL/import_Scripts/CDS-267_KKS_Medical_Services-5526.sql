USE superbill_5526_dev
--USE superbill_5526_prod
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


DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Service Location records deleted'


PRINT ''
PRINT 'Inserting into Insurance Company...'
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
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  name , -- InsuranceCompanyName - varchar(128)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          addressline1 , -- AddressLine1 - varchar(256)
          addressline2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          country , -- Country - varchar(32)
          CASE WHEN LEN(zipcode) IN (5,9) THEN zipcode
			   WHEN LEN(zipcode) IN (4,8) THEN '0' + zipcode
			   ELSE '' END , -- ZipCode - varchar(9)
          contactprefix , -- ContactPrefix - varchar(16)
          contactfirstname , -- ContactFirstName - varchar(64)
          contactmiddlename , -- ContactMiddleName - varchar(64)
          contactlastname , -- ContactLastName - varchar(64)
          contactsuffix , -- ContactSuffix - varchar(16)
          contactphone , -- Phone - varchar(10)
          contactphoneext , -- PhoneExt - varchar(10)
          contactfax , -- Fax - varchar(10)
          contactfaxext , -- FaxExt - varchar(10)
          CASE WHEN autobillssecondaryinsurance = 1 THEN 1
			   ELSE 0 END , -- BillSecondaryInsurance - bit
          CASE WHEN clearinghouse <> '' THEN 1 ELSE 0 END , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          CASE insuranceprogram WHEN 'Medicare Part B' THEN 'MB'
								WHEN 'Other Federal Program' THEN 'OF'
								WHEN 'Workers Compensation Health Claim' THEN 'WC'
								ELSE 'CI' END , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          insurancecompanyid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceCompany]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Insurance Company Plan...'
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
          PhoneExt ,
          Notes ,
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
		  icp.planname , -- PlanName - varchar(128)
          icp.addressline1 , -- AddressLine1 - varchar(256)
          icp.addressline2 , -- AddressLine2 - varchar(256)
          icp.city , -- City - varchar(128)
          icp.state , -- State - varchar(2)
          icp.country , -- Country - varchar(32)
          CASE WHEN LEN(icp.zipcode) IN (5,9) THEN icp.zipcode
			   WHEN LEN(icp.zipcode) IN (4,8) THEN '0' + icp.zipcode
			   ELSE '' END , -- ZipCode - varchar(9)
          icp.contactprefix , -- ContactPrefix - varchar(16)
          icp.contactfirstname , -- ContactFirstName - varchar(64)
          icp.contactmiddlename , -- ContactMiddleName - varchar(64)
          icp.contactlastname , -- ContactLastName - varchar(64)
          icp.contactsuffix , -- ContactSuffix - varchar(16)
          icp.contactphone , -- Phone - varchar(10)
          icp.contactphoneext , -- PhoneExt - varchar(10)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          icp.contactfax , -- Fax - varchar(10)
          icp.contactfaxext , -- FaxExt - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.insurancecompanyplanid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_InsuranceCompanyPlan] icp
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorID = icp.insurancecompanyid AND
	ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Service Location...'
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
          sl.internalname , -- Name - varchar(128)
          sl.addressline1 , -- AddressLine1 - varchar(256)
          sl.addressline2 , -- AddressLine2 - varchar(256)
          sl.city , -- City - varchar(128)
          sl.state , -- State - varchar(2)
          sl.country , -- Country - varchar(32)
          CASE WHEN LEN(sl.zipcode) IN (5,9) THEN sl.zipcode
			   WHEN LEN(sl.zipcode) IN (4,8) THEN '0' + sl.zipcode
			   ELSE '' END , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE sl.placeofservice WHEN 'Office' THEN 11
							  WHEN 'Ambulatory Surgical Center' THEN 24
							  WHEN 'Emergency Room - Hospital' THEN 23
							  WHEN 'Inpatient Hospital' THEN 21
							  ELSE 11 END , -- PlaceOfServiceCode - char(2)
          sl.billingname , -- BillingName - varchar(128)
          sl.phonenumber , -- Phone - varchar(10)
          sl.phonenumberext , -- PhoneExt - varchar(10)
          sl.faxnumber , -- FaxPhone - varchar(10)
          sl.faxnumberext , -- FaxPhoneExt - varchar(10)
          sl.clianumber , -- CLIANumber - varchar(30)
          @VendorImportID , -- VendorImportID - int
          sl.servicelocationid , -- VendorID - int
          sl.npi , -- NPI - varchar(10)
          15  -- TimeZoneID - int
FROM dbo.[_import_1_1_ServiceLocations] sl
WHERE NOT EXISTS (SELECT * FROM dbo.ServiceLocation realsl WHERE realsl.Name = sl.internalname)
AND (sl.internalname <> '' AND sl.billingname <> '')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient...'
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
          PatientReferralSourceID ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          doc1.DoctorID , -- ReferringPhysicianID - int
          impPat.Prefix , -- Prefix - varchar(16)
          impPat.firstname , -- FirstName - varchar(64)
          impPat.middlename , -- MiddleName - varchar(64)
          impPat.lastname , -- LastName - varchar(64)
          impPat.suffix , -- Suffix - varchar(16)
          impPat.addressline1 , -- AddressLine1 - varchar(256)
          impPat.addressline2 , -- AddressLine2 - varchar(256)
          impPat.city , -- City - varchar(128)
          impPat.state , -- State - varchar(2)
          impPat.country , -- Country - varchar(32)
          CASE WHEN LEN(impPat.zipcode) IN (5,9) THEN impPat.zipcode
			   WHEN LEN(impPat.zipcode) IN (4,8) THEN '0' + impPat.zipcode
			   ELSE '' END , -- ZipCode - varchar(9)
          impPat.gender , -- Gender - varchar(1)
          CASE impPat.maritalstatus WHEN 'Married' THEN 'M'
									WHEN 'Widowed' THEN 'W'
									WHEN 'Divorced' THEN 'D'
									WHEN 'Interlocutory' THEN 'I'
									WHEN 'Legally Separated' THEN 'L'
									WHEN 'Anulled' THEN 'A'
									WHEN 'Domestic Partner' THEN 'T'
									WHEN 'Never Married' THEN 'S'
									WHEN 'Polygamous' THEN 'P'
									ELSE '' END , -- MaritalStatus - varchar(1)
          impPat.homephone , -- HomePhone - varchar(10)
          impPat.homephoneext , -- HomePhoneExt - varchar(10)
          impPat.workphone , -- WorkPhone - varchar(10)
          impPat.workphoneext , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(impPat.dateofbirth) = 1 THEN impPat.dateofbirth
			   ELSE NULL END , -- DOB - datetime
          impPat.ssn , -- SSN - char(9)
          impPat.emailaddress , -- EmailAddress - varchar(256)
          CASE WHEN impPat.guarantorlastname <> '' THEN 1
			   ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN impPat.guarantorprefix IS NOT NULL THEN impPat.guarantorprefix ELSE '' END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN impPat.guarantorfirstname IS NOT NULL THEN impPat.guarantorfirstname ELSE '' END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN impPat.guarantormiddlename IS NOT NULL THEN impPat.guarantormiddlename ELSE '' END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN impPat.guarantorlastname IS NOT NULL THEN impPat.guarantorlastname ELSE '' END , -- ResponsibleLastName - varchar(64)
          CASE WHEN impPat.guarantorsuffix IS NOT NULL THEN impPat.guarantorsuffix ELSE '' END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN impPat.guarantorrelationshiptopatient IS NOT NULL THEN (CASE impPat.guarantorrelationshiptopatient WHEN 'Child' THEN 'C'
																										 WHEN 'Spouse' THEN 'U'
																										 WHEN 'Other' THEN 'O'
																										 ELSE 'S' END) ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN impPat.guarantoraddressline1 IS NOT NULL THEN impPat.guarantoraddressline1 ELSE '' END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN impPat.guarantoraddressline2 IS NOT NULL THEN impPat.guarantoraddressline2 ELSE '' END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN impPat.guarantorcity IS NOT NULL THEN impPat.guarantorcity ELSE '' END , -- ResponsibleCity - varchar(128)
          CASE WHEN impPat.guarantorstate IS NOT NULL THEN impPat.guarantorstate ELSE '' END , -- ResponsibleState - varchar(2)
          CASE WHEN impPat.guarantorcountry IS NOT NULL THEN impPat.guarantorcountry ELSE '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN impPat.guarantorzip IS NOT NULL THEN (CASE WHEN LEN(impPat.guarantorzip) IN (5,9) THEN impPat.guarantorzip
																   WHEN LEN(impPat.guarantorzip) IN (4,8) THEN '0' + impPat.guarantorzip 
																   ELSE '' END) ELSE '' END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE impPat.employmentstatus WHEN 'Retired' THEN 'R'
									   WHEN 'Employed' THEN 'E'
									   WHEN 'Student, Full-Time' THEN 'S'
									   WHEN 'Student, Part-Time' THEN 'T'
									   ELSE 'U' END , -- EmploymentStatus - char(1)
          CASE impPat.referralsource WHEN 'Physician' THEN 37
									 WHEN 'Print Ad' THEN 34
									 WHEN 'Workers Comp' THEN 40
									 ELSE NULL END , -- PatientReferralSourceID - int
          doc.DoctorID , -- PrimaryProviderID - int
          sl.ServiceLocationID , -- DefaultServiceLocationID - int
          impPat.medicalrecordnumber , -- MedicalRecordNumber - varchar(128)
          impPat.mobilephone , -- MobilePhone - varchar(10)
          impPat.mobilephoneext , -- MobilePhoneExt - varchar(10)
          doc2.DoctorID , -- PrimaryCarePhysicianID - int
          impPat.id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE impPat.active WHEN 'False' THEN 0
							 ELSE 1 END , -- Active - bit
          CASE impPat.sendemailnotifications WHEN 'FALSE' THEN 0
											 ELSE 1 END , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
          impPat.emergencyname , -- EmergencyName - varchar(128)
          impPat.emergencyphone , -- EmergencyPhone - varchar(10)
          impPat.emergencyphoneext  -- EmergencyPhoneExt - varchar(10)
FROM dbo.[_import_1_1_PatientDemographics] AS impPat
LEFT JOIN dbo.Doctor AS doc1 ON
	doc1.VendorID = impPat.defaultreferringphysicianid AND
	doc1.[External] = 1 AND
	doc1.PracticeID = @PracticeID
LEFT JOIN dbo.Doctor AS doc2 ON
	doc2.VendorID = impPat.primarycarephysicianid AND
	doc2.[External] = 1 AND
	doc2.PracticeID = @PracticeID
LEFT JOIN dbo.[_import_1_1_Providers] AS impAppP ON
	impAppP.providerid = impPat.defaultrenderingproviderid
LEFT JOIN dbo.Doctor AS doc ON
	doc.FirstName = impAppP.firstname AND
	doc.LastName = impAppP.lastname AND
	doc.[External] = 0 AND
	doc.PracticeID = @PracticeID
LEFT JOIN dbo.[_import_1_1_ServiceLocations] AS impSL ON
	impSL.servicelocationid = impPat.defaultservicelocationid
LEFT JOIN dbo.ServiceLocation AS sl ON
	sl.VendorID = impSL.servicelocationid AND
	sl.PracticeID = @PracticeID  
WHERE NOT EXISTS (SELECT * FROM dbo.Patient realP WHERE impPat.firstname = realP.FirstName AND impPat.lastname = realP.LastName AND CAST(CAST(impPat.dateofbirth AS DATE) AS DATETIME) = CAST(CAST(realP.DOB AS DATE) AS DATETIME))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into Patient Journal Note 1...'
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
          realP.PatientID , -- PatientID - int
          'Kareo Import' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          impNA.mostrecentnote1message , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_1_1_NotesAlerts] AS impNA
INNER JOIN dbo.Patient AS realP ON
	realP.VendorID = impNA.id AND
	realp.VendorImportID = @VendorImportID
WHERE impNA.mostrecentnote1message <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Patient Journal Note 2...'
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
          realP.PatientID , -- PatientID - int
          'Kareo Import' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          impNA.mostrecentnote2message , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_1_1_NotesAlerts] AS impNA
INNER JOIN dbo.Patient AS realP ON
	realP.VendorID = impNA.id AND
	realp.VendorImportID = @VendorImportID
WHERE impNA.mostrecentnote2message <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Journal Note 3...'
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
          realP.PatientID , -- PatientID - int
          'Kareo Import' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          impNA.mostrecentnote3message , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_1_1_NotesAlerts] AS impNA
INNER JOIN dbo.Patient AS realP ON
	realP.VendorID = impNA.id AND
	realp.VendorImportID = @VendorImportID
WHERE impNA.mostrecentnote3message <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Patient Journal Note 4...'
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
          realP.PatientID , -- PatientID - int
          'Kareo Import' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          impNA.mostrecentnote4message , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_1_1_NotesAlerts] AS impNA
INNER JOIN dbo.Patient AS realP ON
	realP.VendorID = impNA.id AND
	realp.VendorImportID = @VendorImportID
WHERE impNA.mostrecentnote4message <> ''
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
		  realP.PatientID , -- PatientID - int
          impNA.alertmessage , -- AlertMessage - text
          CASE impNA.alertshowwhendisplayingpatientdetails WHEN 1 THEN 1
				ELSE 0 END , -- ShowInPatientFlag - bit
          CASE impNA.alertshowwhenschedulingappointments WHEN 1 THEN 1
				ELSE 0 END , -- ShowInAppointmentFlag - bit
          CASE impNA.alertshowwhenenteringencounters WHEN 1 THEN 1
				ELSE 0 END , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE impNA.alertshowwhenviewingclaimdetails WHEN 1 THEN 1
				ELSE 0 END , -- ShowInClaimFlag - bit
          CASE impNA.alertshowwhenpostingpayments WHEN 1 THEN 1
				ELSE 0 END , -- ShowInPaymentFlag - bit
          CASE impNA.alertshowwhenpreparingpatientstatements WHEN 1 THEN 1
				ELSE 0 END  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_1_1_NotesAlerts] AS impNA
INNER JOIN dbo.Patient AS realP ON
	realP.VendorID = impNA.id AND
	realp.VendorImportID = @VendorImportID
WHERE impNA.alertmessage <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
		  pat.PatientID , -- PatientID - int
          impCas.defaultcasename , -- Name - varchar(128)
          1 , -- Active - bit
          CASE impCas.defaultcasepayerscenario WHEN '' THEN 5
				ELSE ps.PayerScenarioID END , -- PayerScenarioID - int
          CASE impCas.defaultcaseconditionrelatedtoemployment WHEN 1 THEN 1
				ELSE 0 END , -- EmploymentRelatedFlag - bit
          CASE impCas.defaultcaseconditionrelatedtoautoaccident WHEN 1 THEN 1
				ELSE 0 END , -- AutoAccidentRelatedFlag - bit
          CASE impCas.defaultcaseconditionrelatedtoother WHEN 1 THEN 1
				ELSE 0 END , -- OtherAccidentRelatedFlag - bit
          CASE impCas.defaultcaseconditionrelatedtoabuse WHEN 1 THEN 1
				ELSE 0 END , -- AbuseRelatedFlag - bit
          CASE impCas.defaultcaseconditionrelatedtoautoaccidentstate WHEN '' THEN ''
				ELSE LEFT(defaultcaseconditionrelatedtoautoaccidentstate , 2) END , -- AutoAccidentRelatedState - char(2)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          impCas.defaultcaseid , -- CaseNumber - varchar(128)
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE impCas.defaultcaseconditionrelatedtopregnancy WHEN 1 THEN 1
				ELSE 0 END , -- PregnancyRelatedFlag - bit
          CASE impCas.defaultcasesendpatientstatements WHEN 1 THEN 1
				ELSE 0 END , -- StatementActive - bit
          CASE impCas.defaultcaseconditionrelatedtoepsdt WHEN 1 THEN 1
				ELSE 0 END , -- EPSDT - bit
          CASE impCas.defaultcaseconditionrelatedtofamilyplanning WHEN 1 THEN 1
				ELSE 0 END , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          CASE impCas.defaultcaseconditionrelatedtoemergency WHEN 1 THEN 1
				ELSE 0 END , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_1_1_CaseInformation] AS impCas
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = impCas.patientid AND
	pat.VendorImportID = @VendorImportID AND
	pat.PracticeID = @PracticeID
LEFT JOIN dbo.PayerScenario AS ps ON
	ps.Name = impCas.defaultcasepayerscenario
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
		  @PracticeID , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          2 , -- PatientCaseDateTypeID - int
          CASE WHEN ISDATE(impCas.defaultcasedatesinjurystartdate) = 1 THEN impCas.defaultcasedatesinjurystartdate
				ELSE NULL END  , -- StartDate - datetime
          CASE WHEN ISDATE(impCas.defaultcasedatesinjuryenddate) = 1 THEN impCas.defaultcasedatesinjuryenddate
				ELSE NULL END  , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_1_CaseInformation] AS impCas
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = impCas.patientid AND
	pc.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

      
PRINT ''
PRINT 'Inserting into Patient Case Date - Date Similar Symptoms...'
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
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    3 , -- PatientCaseDateTypeID - int
                    CASE WHEN ISDATE(impCas.defaultcasedatessameorsimilarillnessstartdate) = 1 THEN impCas.defaultcasedatessameorsimilarillnessstartdate
                         ELSE NULL END , -- StartDate - datetime
                    CASE WHEN ISDATE(impCas.defaultcasedatessameorsimilarillnessenddate) = 1 THEN impCas.defaultcasedatessameorsimilarillnessenddate
                         ELSE NULL END , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo.[_import_1_1_CaseInformation] AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.patientid AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.defaultcasedatessameorsimilarillnessstartdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
      
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
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    4 , -- PatientCaseDateTypeID - int
                    CASE WHEN ISDATE(impCas.defaultcasedatesunabletoworkstartdate) = 1 THEN impCas.defaultcasedatesunabletoworkstartdate
                         ELSE NULL END , -- StartDate - datetime
                    CASE WHEN ISDATE(impCas.defaultcasedatesunabletoworkenddate) = 1 THEN impCas.defaultcasedatesunabletoworkenddate
                         ELSE NULL END , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo.[_import_1_1_CaseInformation] AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.patientid AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.defaultcasedatesunabletoworkstartdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
      
PRINT ''
PRINT 'Inserting into Patient Case Date - Total Disability...'
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
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    5 , -- PatientCaseDateTypeID - int
                    CASE WHEN ISDATE(impCas.defaultcasedatesrelateddisabilitystartdate) = 1 THEN impCas.defaultcasedatesrelateddisabilitystartdate
                         ELSE NULL END , -- StartDate - datetime
                    CASE WHEN ISDATE(impCas.defaultcasedatesrelateddisabilityenddate) = 1 THEN impCas.defaultcasedatesrelateddisabilityenddate
                         ELSE NULL END , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo.[_import_1_1_CaseInformation] AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.patientid AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.defaultcasedatesrelateddisabilitystartdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
      
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
              @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    6 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.defaultcasedatesrelatedhospitalizationstartdate) = 1 THEN impCas.defaultcasedatesrelatedhospitalizationstartdate
                              ELSE NULL END , -- StartDate - datetime
                    CASE      WHEN ISDATE(impCas.defaultcasedatesrelatedhospitalizationenddate) = 1 THEN impCas.defaultcasedatesrelatedhospitalizationenddate
                              ELSE NULL END , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo.[_import_1_1_CaseInformation] AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.patientid AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.defaultcasedatesrelatedhospitalizationstartdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
      
PRINT ''
PRINT 'Inserting into Patient Case Date - Date Last Seen...'
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
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    8 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.defaultcasedateslastseendate) = 1 THEN impCas.defaultcasedateslastseendate
                              ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo.[_import_1_1_CaseInformation] AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.patientid AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.defaultcasedateslastseendate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
      
PRINT ''
PRINT 'Inserting into Patient Case Date - Referral Date...'
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
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    9 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.defaultcasedatesreferraldate) = 1 THEN impCas.defaultcasedatesreferraldate
                              ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo.[_import_1_1_CaseInformation] AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.patientid AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.defaultcasedatesreferraldate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
      
PRINT ''
PRINT 'Inserting into Patient Case Date - Date of Manifestation...'
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
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    10 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.defaultcasedatesacutemanifestationdate) = 1 THEN impCas.defaultcasedatesacutemanifestationdate
                              ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo.[_import_1_1_CaseInformation] AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.patientid AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.defaultcasedatesacutemanifestationdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
      
PRINT ''
PRINT 'Inserting into Patient Case Date - Last XRay Date...'
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
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    11 , -- PatientCaseDateTypeID - int
                    CASE      WHEN ISDATE(impCas.defaultcasedateslastxraydate) = 1 THEN impCas.defaultcasedateslastxraydate
                              ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo.[_import_1_1_CaseInformation] AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.patientid AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.defaultcasedateslastxraydate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
      
PRINT ''
PRINT 'Inserting into Patient Case Date - Related to Accident...'
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
                    @PracticeID , -- PracticeID - int
                    realpc.[PatientCaseID] , -- PatientCaseID - int
                    12 , -- PatientCaseDateTypeID - int
                    CASE WHEN ISDATE(impCas.DefaultCaseDatesAccidentDate) = 1 THEN impCas.defaultcasedatesaccidentdate
                         ELSE NULL END , -- StartDate - datetime
                    NULL , -- EndDate - datetime
                    GETDATE() , -- CreatedDate - datetime
                    0 , -- CreatedUserID - int
                    GETDATE() , -- ModifiedDate - datetime
                    0  -- ModifiedUserID - int
      FROM dbo.[_import_1_1_CaseInformation] AS impCas
      INNER JOIN dbo.PatientCase AS realpc ON
            realpc.[VendorID] = impCas.patientid AND
            realpc.[PracticeID] = @PracticeID AND
            realpc.[VendorImportID] = @VendorImportID
      WHERE impCas.defaultcasedatesaccidentdate <> ''
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
		  realPC.PatientCaseID , -- PatientCaseID - int
          realICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          impCas.primaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          impCas.primaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(impCas.primaryinsurancepolicyeffectivestartdate) = 1 THEN impCas.primaryinsurancepolicyeffectivestartdate
			   ELSE NULL END , -- PolicyStartDate - datetime
          CASE impCas.primaryinsurancepolicypatientrelationshiptoinsured WHEN 'O' THEN 'O'
																		 WHEN 'U' THEN 'U'
																		 WHEN 'C' THEN 'C'
																		 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredfullname END , -- HolderPrefix - varchar(16)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredfullname END , -- HolderFirstName - varchar(64)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredfullname END , -- HolderMiddleName - varchar(64)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredfullname END , -- HolderLastName - varchar(64)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredfullname END , -- HolderSuffix - varchar(16)
          CASE WHEN ISDATE(impCas.primaryinsurancepolicyinsureddateofbirth) = 1 THEN impCas.primaryinsurancepolicyinsureddateofbirth
			   ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN LEN(impCas.primaryinsurancepolicyinsuredsocialsecuritynumber) >= 6 THEN RIGHT('000' + impCas.primaryinsurancepolicyinsuredsocialsecuritynumber , 9)
			   ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN impCas.primaryinsurancepolicyinsuredgender IN ('F','FEMALE') THEN 'F'
			   WHEN impCas.primaryinsurancepolicyinsuredgender IN ('M','MALE') THEN 'M'
			   ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredaddressline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredaddressline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredcity END , -- HolderCity - varchar(128)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredstate END , -- HolderState - varchar(2)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN (CASE WHEN LEN(impCas.primaryinsurancepolicyinsuredzipcode) IN (5,9) THEN impCas.primaryinsurancepolicyinsuredzipcode
																								WHEN LEN(impCas.primaryinsurancepolicyinsuredzipcode) IN (4,8) THEN '0' + impCas.primaryinsurancepolicyinsuredzipcode
																								ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredidnumber END , -- DependentPolicyNumber - varchar(32)
          impCas.primaryinsurancepolicyinsurednotes , -- Notes - text
          impCas.primaryinsurancepolicycopay , -- Copay - money
          impCas.primaryinsurancepolicydeductible , -- Deductible - money
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredidnumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          realPC.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_CaseInformation] AS impCas
INNER JOIN dbo.[_import_1_1_InsuranceCompanyPlan] AS impICP ON
	impICP.insurancecompanyplanid = impCas.primaryinsurancepolicycompanyplanid
INNER JOIN dbo.InsuranceCompanyPlan AS realICP ON
	realICP.VendorID = impICP.insurancecompanyplanid AND
	realICP.VendorImportID = @VendorImportID  
INNER JOIN dbo.PatientCase AS realPC ON
	realPC.VendorID = impCas.patientid AND
	realPC.VendorImportID = @VendorImportID AND
	realPC.PracticeID = @PracticeID  
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
		  realPC.PatientCaseID , -- PatientCaseID - int
          realICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          impCas.secondaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          impCas.secondaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(impCas.secondaryinsurancepolicyeffectivestartdate) = 1 THEN impCas.secondaryinsurancepolicyeffectivestartdate
			   ELSE NULL END , -- PolicyStartDate - datetime
          CASE impCas.secondaryinsurancepolicypatientrelationshiptoinsured WHEN 'O' THEN 'O'
																		   WHEN 'U' THEN 'U'
																		   WHEN 'C' THEN 'C'
																		   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredfullname END , -- HolderPrefix - varchar(16)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredfullname END , -- HolderFirstName - varchar(64)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredfullname END , -- HolderMiddleName - varchar(64)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredfullname END , -- HolderLastName - varchar(64)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredfullname END , -- HolderSuffix - varchar(16)
          CASE WHEN ISDATE(impCas.secondaryinsurancepolicyinsureddateofbirth) = 1 THEN impCas.secondaryinsurancepolicyinsureddateofbirth
			   ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN LEN(impCas.secondaryinsurancepolicyinsuredsocialsecuritynumber) >= 6 THEN RIGHT('000' + impCas.secondaryinsurancepolicyinsuredsocialsecuritynumber , 9)
			   ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN impCas.secondaryinsurancepolicyinsuredgender IN ('F','FEMALE') THEN 'F'
			   WHEN impCas.secondaryinsurancepolicyinsuredgender IN ('M','MALE') THEN 'M'
			   ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredaddressline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredaddressline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredcity END , -- HolderCity - varchar(128)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredstate END , -- HolderState - varchar(2)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN (CASE WHEN LEN(impCas.secondaryinsurancepolicyinsuredzipcode) IN (5,9) THEN impCas.secondaryinsurancepolicyinsuredzipcode
																								  WHEN LEN(impCas.secondaryinsurancepolicyinsuredzipcode) IN (4,8) THEN '0' + impCas.secondaryinsurancepolicyinsuredzipcode
																								  ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredidnumber END , -- DependentPolicyNumber - varchar(32)
          impCas.secondaryinsurancepolicyinsurednotes , -- Notes - text
          impCas.secondaryinsurancepolicycopay , -- Copay - money
          impCas.secondaryinsurancepolicydeductible , -- Deductible - money
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredidnumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          realPC.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_CaseInformation] AS impCas
INNER JOIN dbo.[_import_1_1_InsuranceCompanyPlan] AS impICP ON
	impICP.insurancecompanyplanid = impCas.secondaryinsurancepolicycompanyplanid
INNER JOIN dbo.InsuranceCompanyPlan AS realICP ON
	realICP.VendorID = impCas.secondaryinsurancepolicycompanyplanid AND
	realICP.VendorImportID = @VendorImportID  
INNER JOIN dbo.PatientCase AS realPC ON
	realPC.VendorID = impCas.patientid AND
	realPC.VendorImportID = @VendorImportID AND
	realPC.PracticeID = @PracticeID  
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
		  realPC.PatientCaseID , -- PatientCaseID - int
          realICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          impCas.tertiaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          impCas.tertiaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(impCas.tertiaryinsurancepolicyeffectivestartdate) = 1 THEN impCas.tertiaryinsurancepolicyeffectivestartdate
			   ELSE NULL END , -- PolicyStartDate - datetime
          CASE impCas.tertiaryinsurancepolicypatientrelationshiptoinsured WHEN 'O' THEN 'O'
																		  WHEN 'U' THEN 'U'
																		  WHEN 'C' THEN 'C'
																		  ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredfullname END , -- HolderPrefix - varchar(16)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredfullname END , -- HolderFirstName - varchar(64)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredfullname END , -- HolderMiddleName - varchar(64)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredfullname END , -- HolderLastName - varchar(64)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredfullname END , -- HolderSuffix - varchar(16)
          CASE WHEN ISDATE(impCas.tertiaryinsurancepolicyinsureddateofbirth) = 1 THEN impCas.tertiaryinsurancepolicyinsureddateofbirth
			   ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN LEN(impCas.tertiaryinsurancepolicyinsuredsocialsecuritynumber) >= 6 THEN RIGHT('000' + impCas.tertiaryinsurancepolicyinsuredsocialsecuritynumber , 9)
			   ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN impCas.tertiaryinsurancepolicyinsuredgender IN ('F','FEMALE') THEN 'F'
			   WHEN impCas.tertiaryinsurancepolicyinsuredgender IN ('M','MALE') THEN 'M'
			   ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredaddressline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredaddressline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredcity END , -- HolderCity - varchar(128)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredstate END , -- HolderState - varchar(2)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN (CASE WHEN LEN(impCas.tertiaryinsurancepolicyinsuredzipcode) IN (5,9) THEN impCas.tertiaryinsurancepolicyinsuredzipcode
																								 WHEN LEN(impCas.tertiaryinsurancepolicyinsuredzipcode) IN (4,8) THEN '0' + impCas.tertiaryinsurancepolicyinsuredzipcode
																								 ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredidnumber END , -- DependentPolicyNumber - varchar(32)
          impCas.tertiaryinsurancepolicyinsurednotes , -- Notes - text
          impCas.tertiaryinsurancepolicycopay , -- Copay - money
          impCas.tertiaryinsurancepolicydeductible , -- Deductible - money
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredidnumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          realPC.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_CaseInformation] AS impCas
INNER JOIN dbo.[_import_1_1_InsuranceCompanyPlan] AS impICP ON
	impICP.insurancecompanyplanid = impCas.tertiaryinsurancepolicycompanyplanid
INNER JOIN dbo.InsuranceCompanyPlan AS realICP ON
	realICP.VendorID = impCas.tertiaryinsurancepolicycompanyplanid AND
	realICP.VendorImportID = @VendorImportID  
INNER JOIN dbo.PatientCase AS realPC ON
	realPC.VendorID = impCas.patientid AND
	realPC.VendorImportID = @VendorImportID AND
	realPC.PracticeID = @PracticeID  
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
	  PayerScenarioID = 5 AND 
      ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'







--ROLLBACK
--COMMIT