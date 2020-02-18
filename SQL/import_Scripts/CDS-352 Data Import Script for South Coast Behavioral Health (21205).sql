USE superbill_21205_dev
--USE superbill_21205_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT


SET @PracticeID = 2
SET @VendorImportID = 2


PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
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
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'


PRINT ''
PRINT 'Updating Insurance Company to All Practice Scope...'
UPDATE dbo.InsuranceCompany
	SET ReviewCode = 'R'
WHERE ReviewCode = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'



PRINT ''
PRINT 'Updating Insurance Company Plan to All Practice Scope...'
UPDATE dbo.InsuranceCompanyPlan
	SET ReviewCode = 'R'
WHERE ReviewCode = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'



PRINT ''
PRINT 'Inserting into Referring Doctor...'
INSERT INTO dbo.Doctor
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
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          FaxNumberExt ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          prefix , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          middlename , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          suffix , -- Suffix - varchar(16)
          addressline1 , -- AddressLine1 - varchar(256)
          addressline2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          country , -- Country - varchar(32)
          CASE WHEN LEN(zipcode) IN (5,9) THEN zipcode
			   WHEN LEN(zipcode) IN (4,8) THEN '0' + zipcode
			   ELSE '' END , -- ZipCode - varchar(9)
          homephone , -- HomePhone - varchar(10)
          homephoneext , -- HomePhoneExt - varchar(10)
          workphone , -- WorkPhone - varchar(10)
          workphoneext , -- WorkPhoneExt - varchar(10)
          pagernumber , -- PagerPhone - varchar(10)
          pagernumberext , -- PagerPhoneExt - varchar(10)
          mobilephone , -- MobilePhone - varchar(10)
          mobilephoneext , -- MobilePhoneExt - varchar(10)
          CASE WHEN ISDATE(dob) = 1 THEN dob
			   ELSE NULL END , -- DOB - datetime
          '' , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          degree , -- Degree - varchar(8)
          providerid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          faxnumber , -- FaxNumber - varchar(10)
          faxnumberext , -- FaxNumberExt - varchar(10)
          1 , -- External - bit
          npi  -- NPI - varchar(10)
FROM dbo.[_import_2_2_RefProvider]
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
          EmployerID ,
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE impPat.employmentstatus WHEN 'Retired' THEN 'R'
									   WHEN 'Employed' THEN 'E'
									   WHEN 'Student, Full-Time' THEN 'S'
									   WHEN 'Student, Part-Time' THEN 'T'
									   ELSE 'U' END , -- EmploymentStatus - char(1)
          prs.PatientReferralSourceID , -- PatientReferralSourceID - int
          doc.DoctorID , -- PrimaryProviderID - int
          14 , -- DefaultServiceLocationID - int
          emp.EmployerID , -- EmployerID - int
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
FROM dbo.[_import_2_2_PatientDemographics] AS impPat
LEFT JOIN dbo.Doctor AS doc1 ON
	doc1.VendorID = impPat.defaultreferringphysicianid AND
	doc1.[External] = 1 AND
	doc1.PracticeID = @PracticeID
LEFT JOIN dbo.Doctor AS doc2 ON
	doc2.VendorID = impPat.primarycarephysicianid AND
	doc2.[External] = 1 AND
	doc2.PracticeID = @PracticeID
LEFT JOIN dbo.Employers AS emp ON
	emp.EmployerID = impPat.employerid
LEFT JOIN dbo.[_import_2_2_Providers] AS impAppP ON
	impAppP.providerid = impPat.defaultrenderingproviderid
LEFT JOIN dbo.Doctor AS doc ON
	doc.FirstName = impAppP.firstname AND
	doc.LastName = impAppP.lastname AND
	doc.[External] = 0 AND
	doc.PracticeID = @PracticeID
LEFT JOIN dbo.PatientReferralSource prs ON
	prs.PatientReferralSourceCaption = impPat.referralsource AND
	prs.PracticeID = @PracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pat WHERE impPat.medicalrecordnumber = pat.MedicalRecordNumber AND pat.PracticeID = @PracticeID) AND impPat.id NOT IN (1,2)
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
		  impNA.mostrecentnote4date , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          realP.PatientID , -- PatientID - int
          impNA.mostrecentnote4user , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          impNA.mostrecentnote4message , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_2_2_NotesAlerts] AS impNA
INNER JOIN dbo.Patient AS realP ON
	realP.VendorID = impNA.id AND
	realp.VendorImportID = @VendorImportID
WHERE impNA.mostrecentnote4message <> ''
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
		  impNA.mostrecentnote3date , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          realP.PatientID , -- PatientID - int
          impNA.mostrecentnote3user , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          impNA.mostrecentnote3message , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_2_2_NotesAlerts] AS impNA
INNER JOIN dbo.Patient AS realP ON
	realP.VendorID = impNA.id AND
	realp.VendorImportID = @VendorImportID
WHERE impNA.mostrecentnote3message <> ''
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
		  impNA.mostrecentnote2date , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          realP.PatientID , -- PatientID - int
          impNA.mostrecentnote2user, -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          impNA.mostrecentnote2message , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_2_2_NotesAlerts] AS impNA
INNER JOIN dbo.Patient AS realP ON
	realP.VendorID = impNA.id AND
	realp.VendorImportID = @VendorImportID
WHERE impNA.mostrecentnote2message <> ''
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
		  impNA.mostrecentnote1date , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          realP.PatientID , -- PatientID - int
          impNA.mostrecentnote1user , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          impNA.mostrecentnote1message , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_2_2_NotesAlerts] AS impNA
INNER JOIN dbo.Patient AS realP ON
	realP.VendorID = impNA.id AND
	realp.VendorImportID = @VendorImportID
WHERE impNA.mostrecentnote1message <> ''
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE impNA.alertshowwhenviewingclaimdetails WHEN 1 THEN 1
				ELSE 0 END , -- ShowInClaimFlag - bit
          CASE impNA.alertshowwhenpostingpayments WHEN 1 THEN 1
				ELSE 0 END , -- ShowInPaymentFlag - bit
          CASE impNA.alertshowwhenpreparingpatientstatements WHEN 1 THEN 1
				ELSE 0 END  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_2_2_NotesAlerts] AS impNA
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
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
FROM dbo.[_import_2_2_CaseInformation] AS impCas
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.[_import_2_2_CaseInformation] AS impCas
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = impCas.patientid AND
	pc.PracticeID = @PracticeID
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
          impCas.primaryinsurancepolicycompanyplanid , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          impCas.primaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          impCas.primaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(impCas.primaryinsurancepolicyeffectivestartdate) = 1 THEN impCas.primaryinsurancepolicyeffectivestartdate
			   ELSE NULL END , -- PolicyStartDate - datetime
          CASE impCas.primaryinsurancepolicypatientrelationshiptoinsured WHEN 'O' THEN 'O'
																		 WHEN 'U' THEN 'U'
																		 WHEN 'C' THEN 'C'
																		 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredprefix END , -- HolderPrefix - varchar(16)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredmiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredlastname END , -- HolderLastName - varchar(64)
          CASE WHEN impCas.primaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.primaryinsurancepolicyinsuredsuffix END , -- HolderSuffix - varchar(16)
          CASE WHEN ISDATE(impCas.primaryinsurancepolicyinsureddateofbirth) = 1 THEN impCas.primaryinsurancepolicyinsureddateofbirth
			   ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN LEN(impCas.primaryinsurancepolicyinsuredsocialsecuritynumber) >= 6 THEN RIGHT('000' + impCas.primaryinsurancepolicyinsuredsocialsecuritynumber , 9)
			   ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
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
FROM dbo.[_import_2_2_CaseInformation]AS impCas
--INNER JOIN dbo.InsuranceCompanyPlan AS realICP ON
--	realICP.VendorID = impCas.primaryinsurancepolicycompanyplanid AND
--	realICP.VendorImportID = @VendorImportID  
INNER JOIN dbo.PatientCase AS realPC ON
	realPC.VendorID = impCas.patientid AND
	realPC.VendorImportID = @VendorImportID AND
	realPC.PracticeID = @PracticeID  
WHERE impCas.primaryinsurancepolicycompanyplanid <> ''
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
          impCas.secondaryinsurancepolicycompanyplanid , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          impCas.secondaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          impCas.secondaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(impCas.secondaryinsurancepolicyeffectivestartdate) = 1 THEN impCas.secondaryinsurancepolicyeffectivestartdate
			   ELSE NULL END , -- PolicyStartDate - datetime
          CASE impCas.secondaryinsurancepolicypatientrelationshiptoinsured WHEN 'O' THEN 'O'
																		   WHEN 'U' THEN 'U'
																		   WHEN 'C' THEN 'C'
																		   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredprefix END , -- HolderPrefix - varchar(16)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredmiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredlastname END , -- HolderLastName - varchar(64)
          CASE WHEN impCas.secondaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.secondaryinsurancepolicyinsuredsuffix END , -- HolderSuffix - varchar(16)
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
FROM dbo.[_import_2_2_CaseInformation] AS impCas
--INNER JOIN dbo.InsuranceCompanyPlan AS realICP ON
--	realICP.VendorID = impCas.secondaryinsurancepolicycompanyplanid AND
--	realICP.VendorImportID = @VendorImportID  
INNER JOIN dbo.PatientCase AS realPC ON
	realPC.VendorID = impCas.patientid AND
	realPC.VendorImportID = @VendorImportID AND
	realPC.PracticeID = @PracticeID  
WHERE impCas.secondaryinsurancepolicycompanyplanid <> ''
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
          impCas.tertiaryinsurancepolicycompanyplanid  , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          impCas.tertiaryinsurancepolicynumber , -- PolicyNumber - varchar(32)
          impCas.tertiaryinsurancepolicygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(impCas.tertiaryinsurancepolicyeffectivestartdate) = 1 THEN impCas.tertiaryinsurancepolicyeffectivestartdate
			   ELSE NULL END , -- PolicyStartDate - datetime
          CASE impCas.tertiaryinsurancepolicypatientrelationshiptoinsured WHEN 'O' THEN 'O'
																		  WHEN 'U' THEN 'U'
																		  WHEN 'C' THEN 'C'
																		  ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredprefix END , -- HolderPrefix - varchar(16)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredmiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredlastname END , -- HolderLastName - varchar(64)
          CASE WHEN impCas.tertiaryinsurancepolicypatientrelationshiptoinsured <> 'S' THEN impCas.tertiaryinsurancepolicyinsuredsuffix END , -- HolderSuffix - varchar(16)
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
FROM dbo.[_import_2_2_CaseInformation] AS impCas
--INNER JOIN dbo.InsuranceCompanyPlan AS realICP ON
--	realICP.VendorID = impCas.tertiaryinsurancepolicycompanyplanid AND
--	realICP.VendorImportID = @VendorImportID  
INNER JOIN dbo.PatientCase AS realPC ON
	realPC.VendorID = impCas.patientid AND
	realPC.VendorImportID = @VendorImportID AND
	realPC.PracticeID = @PracticeID  
WHERE impCas.tertiaryinsurancepolicycompanyplanid  <> ''
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