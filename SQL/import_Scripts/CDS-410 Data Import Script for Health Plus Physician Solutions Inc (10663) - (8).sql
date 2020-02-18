USE superbill_10663_dev
--USE superbill_10663_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @OldPracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 8
SET @OldPracticeID = 2
SET @VendorImportID = 17

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
--PRINT ''
--PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT  AppointmentID FROM dbo.Appointment WHERE PatientID IN 
--		(SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' AppointmentToAppointmentReasons deleted'
--DELETE FROM dbo.AppointmentReason WHERE PracticeID = @PracticeID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' AppointmentReasons deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN 
--		(SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' AppointmentToResources deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' Appointments deleted'
--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
--PRINT '    ' + CAST(@@Rowcount AS VARCHAR) + ' Insurance Policies deleted'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' Patient Journal Notes deleted'
--DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' PatientAlerts deleted'
--DELETE FROM dbo.PatientCaseDate WHERE PracticeID = @PracticeID 
--PRINT '    ' +  CAST(@@rowcount AS VARCHAR) + ' Patient Case Dates deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
--PRINT '    ' +  CAST(@@rowcount AS VARCHAR) + ' Patient Cases deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
--PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' Patients deleted'
--DELETE FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
--PRINT '    ' + CAST(@@Rowcount AS VARCHAR) + ' Service Locations deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' Doctors deleted'

PRINT ''
PRINT 'Updating Insurance Company to All Practice...'
UPDATE dbo.InsuranceCompany 
	SET ReviewCode = 'R'
	WHERE CreatedPracticeID = @OldPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Company Plan to All Practice...'	
UPDATE dbo.InsuranceCompanyPlan
	SET ReviewCode = 'R'
	WHERE CreatedPracticeID = @OldPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'
PRINT ''
PRINT 'Updating Existing Doctor Records with VendorID...'


UPDATE dbo.Doctor 
	SET VendorID = DoctorID
FROM dbo.Doctor d
WHERE PracticeID = @PracticeID AND EXISTS 
(SELECT * FROM dbo.Doctor d2 where d.FirstName = d2.FirstName AND 
								   d.LastName = d2.LastName AND 
								   d.NPI = d2.NPI and 
								   PracticeID = @OldPracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Inserting into Doctor'
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
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          UserID ,
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
          NPI ,
          ProviderTypeID ,
          ProviderPerformanceReportActive ,
          ProviderPerformanceScope ,
          ProviderPerformanceFrequency ,
          ProviderPerformanceDelay ,
          ProviderPerformanceCarbonCopyEmailRecipients ,
          ExternalBillingID ,
          GlobalPayToAddressFlag ,
          GlobalPayToName ,
          GlobalPayToAddressLine1 ,
          GlobalPayToAddressLine2 ,
          GlobalPayToCity ,
          GlobalPayToState ,
          GlobalPayToZipCode ,
          GlobalPayToCountry ,
          CreatedFromEhr ,
          ActivateAfterWizard
        )
SELECT    @PracticeID ,
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
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          UserID ,
          Degree ,
          DefaultEncounterTemplateID ,
          TaxonomyCode ,
          DepartmentID ,
          DoctorID ,
          @VendorImportID ,
          FaxNumber ,
          FaxNumberExt ,
          OrigReferringPhysicianID ,
          [External] ,
          NPI ,
          ProviderTypeID ,
          ProviderPerformanceReportActive ,
          ProviderPerformanceScope ,
          ProviderPerformanceFrequency ,
          ProviderPerformanceDelay ,
          ProviderPerformanceCarbonCopyEmailRecipients ,
          ExternalBillingID ,
          GlobalPayToAddressFlag ,
          GlobalPayToName ,
          GlobalPayToAddressLine1 ,
          GlobalPayToAddressLine2 ,
          GlobalPayToCity ,
          GlobalPayToState ,
          GlobalPayToZipCode ,
          GlobalPayToCountry ,
          CreatedFromEhr ,
          ActivateAfterWizard
FROM dbo.Doctor doc
WHERE doc.PracticeID = @OldPracticeID AND
NOT EXISTS (SELECT * FROM dbo.Doctor WHERE PracticeID = @PracticeID AND FirstName = doc.Firstname AND 
													LastName = doc.lastname AND npi = doc.npi and [External] = 1)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
				


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
          InsuranceProgramCode ,
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
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt ,
          Ethnicity ,
          Race ,
          LicenseNumber ,
          LicenseState ,
          Language1 ,
          Language2
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          ref.DoctorID , -- ReferringPhysicianID - int
          p.Prefix , -- Prefix - varchar(16)
          p.FirstName , -- FirstName - varchar(64)
          p.MiddleName , -- MiddleName - varchar(64)
          p.LastName , -- LastName - varchar(64)
          p.Suffix , -- Suffix - varchar(16)
          p.AddressLine1 , -- AddressLine1 - varchar(256)
          p.AddressLine2 , -- AddressLine2 - varchar(256)
          p.City , -- City - varchar(128)
          p.[State] , -- State - varchar(2)
          p.Country , -- Country - varchar(32)
          p.ZipCode , -- ZipCode - varchar(9)
          p.Gender , -- Gender - varchar(1)
          p.MaritalStatus , -- MaritalStatus - varchar(1)
          p.HomePhone , -- HomePhone - varchar(10)
          p.HomePhoneExt , -- HomePhoneExt - varchar(10)
          p.WorkPhone , -- WorkPhone - varchar(10)
          p.WorkPhoneExt , -- WorkPhoneExt - varchar(10)
          p.DOB , -- DOB - datetime
          p.SSN , -- SSN - char(9)
          p.EmailAddress , -- EmailAddress - varchar(256)
          p.ResponsibleDifferentThanPatient , -- ResponsibleDifferentThanPatient - bit
          p.ResponsiblePrefix , -- ResponsiblePrefix - varchar(16)
          p.ResponsibleFirstName , -- ResponsibleFirstName - varchar(64)
          p.ResponsibleMiddleName , -- ResponsibleMiddleName - varchar(64)
          p.ResponsibleLastName , -- ResponsibleLastName - varchar(64)
          p.ResponsibleSuffix , -- ResponsibleSuffix - varchar(16)
          p.ResponsibleRelationshipToPatient , -- ResponsibleRelationshipToPatient - varchar(1)
          p.ResponsibleAddressLine1 , -- ResponsibleAddressLine1 - varchar(256)
          p.ResponsibleAddressLine2 , -- ResponsibleAddressLine2 - varchar(256)
          p.ResponsibleCity , -- ResponsibleCity - varchar(128)
          p.ResponsibleState , -- ResponsibleState - varchar(2)
          p.ResponsibleCountry , -- ResponsibleCountry - varchar(32)
          p.ResponsibleZipCode , -- ResponsibleZipCode - varchar(9)
          p.CreatedDate , -- CreatedDate - datetime
          p.CreatedUserID , -- CreatedUserID - int
          p.ModifiedDate , -- ModifiedDate - datetime
          p.ModifiedUserID , -- ModifiedUserID - int
          p.EmploymentStatus , -- EmploymentStatus - char(1)
          p.InsuranceProgramCode , -- InsuranceProgramCode - char(2)
          p.PatientReferralSourceID , -- PatientReferralSourceID - int
          pp.DoctorID , -- PrimaryProviderID - int
          p.DefaultServiceLocationID , -- DefaultServiceLocationID - int
          p.EmployerID , -- EmployerID - int
          p.MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
          p.MobilePhone , -- MobilePhone - varchar(10)
          p.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
          pcp.DoctorID , -- PrimaryCarePhysicianID - int
          p.PatientID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          p.CollectionCategoryID , -- CollectionCategoryID - int
          p.Active , -- Active - bit
          p.SendEmailCorrespondence , -- SendEmailCorrespondence - bit
          p.PhonecallRemindersEnabled , -- PhonecallRemindersEnabled - bit
          p.EmergencyName , -- EmergencyName - varchar(128)
          p.EmergencyPhone , -- EmergencyPhone - varchar(10)
          p.EmergencyPhoneExt , -- EmergencyPhoneExt - varchar(10)
          p.Ethnicity , -- Ethnicity - varchar(64)
          p.Race , -- Race - varchar(64)
          p.LicenseNumber , -- LicenseNumber - varchar(64)
          p.LicenseState , -- LicenseState - varchar(2)
          p.Language1 , -- Language1 - varchar(64)
          p.Language2  -- Language2 - varchar(64)
FROM dbo.Patient p
LEFT JOIN dbo.doctor ref ON 
	p.ReferringPhysicianID = ref.VendorID AND
    ref.PracticeID = @PracticeID 
LEFT JOIN dbo.Doctor pcp ON 
	p.primaryCarePhysicianID = pcp.VendorId AND
	pcp.PracticeID = @PracticeID
LEFT JOIN dbo.Doctor pp ON
	p.PrimaryProviderID = pp.VendorID AND
	pcp.PracticeID = @PracticeID  
LEFT JOIN dbo.ServiceLocation sl ON
	p.DefaultServiceLocationID = sl.VendorID
WHERE p.PracticeID = @OldPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT''
PRINT'Inserting into PatientCase ...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          ReferringPhysicianID ,
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
          WorkersCompContactInfoID ,
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
SELECT    pat.PatientID ,
          pc.Name ,
          pc.Active ,
          pc.PayerScenarioID ,
          pc.ReferringPhysicianID ,
          pc.EmploymentRelatedFlag ,
          pc.AutoAccidentRelatedFlag ,
          pc.OtherAccidentRelatedFlag ,
          pc.AbuseRelatedFlag ,
          pc.AutoAccidentRelatedState ,
          pc.Notes ,
          pc.ShowExpiredInsurancePolicies ,
          pc.CreatedDate ,
          pc.CreatedUserID ,
          pc.ModifiedDate ,
          pc.ModifiedUserID ,
          @PracticeID ,
          pc.CaseNumber ,
          pc.WorkersCompContactInfoID ,
          pc.PatientCaseID ,
          @VendorImportID ,
          pc.PregnancyRelatedFlag ,
          pc.StatementActive ,
          pc.EPSDT ,
          pc.FamilyPlanning ,
          pc.EPSDTCodeID ,
          pc.EmergencyRelated ,
          pc.HomeboundRelatedFlag
FROM dbo.PatientCase pc
LEFT JOIN dbo.Patient pat ON
	pc.PatientID = pat.VendorID 
WHERE pc.PracticeID = @OldPracticeID AND 
	pat.PracticeID = @PracticeID
	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Patient Case Date...'
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
          pcd.PatientCaseDateTypeID , -- PatientCaseDateTypeID - int
          pcd.StartDate , -- StartDate - datetime
          pcd.EndDate , -- EndDate - datetime
          pcd.CreatedDate , -- CreatedDate - datetime
          pcd.CreatedUserID , -- CreatedUserID - int
          pcd.ModifiedDate , -- ModifiedDate - datetime
          pcd.ModifiedUserID  -- ModifiedUserID - int
FROM dbo.PatientCaseDate pcd
	INNER JOIN dbo.PatientCase pc ON
		pcd.PatientCaseID = pc.VendorID
WHERE pc.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into PatientAlert ...'
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
SELECT    p.PatientID , -- PatientID - int
          pa.AlertMessage , -- AlertMessage - text
          pa.ShowInPatientFlag , -- ShowInPatientFlag - bit
          pa.ShowInAppointmentFlag , -- ShowInAppointmentFlag - bit
          pa.ShowInEncounterFlag , -- ShowInEncounterFlag - bit
          pa.CreatedDate , -- CreatedDate - datetime
		  pa.CreatedUserID , -- CreatedUserID - int
          pa.ModifiedDate , -- ModifiedDate - datetime
          pa.ModifiedUserID , -- ModifiedUserID - int
          pa.ShowInClaimFlag , -- ShowInClaimFlag - bit
          pa.ShowInPaymentFlag , -- ShowInPaymentFlag - bit
          pa.ShowInPatientStatementFlag  -- ShowInPatientStatementFlag - bit
FROM dbo.PatientAlert pa
INNER JOIN dbo.Patient p ON 
	pa.PatientID = p.VendorID AND
	p.VendorImportID = @VendorImportID
PRINT CAST(@@Rowcount AS VARCHAR) + ' records inserted'	
	


PRINT''
PRINT'Inserting into PatientJournalNotes ...'
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
SELECT	  pjn.CreatedDate ,
          pjn.CreatedUserID ,
          pjn.ModifiedDate ,
          pjn.ModifiedUserID ,
          pat.PatientID ,
          pjn.UserName ,
          pjn.SoftwareApplicationID ,
          pjn.Hidden ,
          pjn.NoteMessage ,
          pjn.AccountStatus ,
          pjn.NoteTypeCode ,
          pjn.LastNote
FROM dbo.PatientJournalNote pjn
LEFT JOIN dbo.Patient pat ON
	pjn.PatientID = pat.VendorID
WHERE pat.PracticeID = @PracticeID AND
	pjn.PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @OldPracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
          PatientInsuranceStatusID ,
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
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,
          VendorID ,
          VendorImportID ,
          InsuranceProgramTypeID ,
          GroupName ,
          ReleaseOfInformation 
        )
SELECT    pc.PatientCaseID ,
          ip.InsuranceCompanyPlanID ,
          ip.Precedence ,
          ip.PolicyNumber ,
          ip.GroupNumber ,
          ip.PolicyStartDate ,
          ip.PolicyEndDate ,
          ip.CardOnFile ,
          ip.PatientRelationshipToInsured ,
          ip.HolderPrefix ,
          ip.HolderFirstName ,
          ip.HolderMiddleName ,
          ip.HolderLastName ,
          ip.HolderSuffix ,
          ip.HolderDOB ,
          ip.HolderSSN ,
          ip.HolderThroughEmployer ,
          ip.HolderEmployerName ,
          ip.PatientInsuranceStatusID ,
          ip.CreatedDate ,
          ip.CreatedUserID ,
          ip.ModifiedDate ,
          ip.ModifiedUserID ,
          ip.HolderGender ,
          ip.HolderAddressLine1 ,
          ip.HolderAddressLine2 ,
          ip.HolderCity ,
          ip.HolderState ,
          ip.HolderCountry ,
          ip.HolderZipCode ,
          ip.HolderPhone ,
          ip.HolderPhoneExt ,
          ip.DependentPolicyNumber ,
          ip.Notes ,
          ip.Phone ,
          ip.PhoneExt ,
          ip.Fax ,
          ip.FaxExt ,
          ip.Copay ,
          ip.Deductible ,
          ip.PatientInsuranceNumber ,
          ip.Active ,
          @PracticeID ,
          ip.AdjusterPrefix ,
          ip.AdjusterFirstName ,
          ip.AdjusterMiddleName ,
          ip.AdjusterLastName ,
          ip.AdjusterSuffix ,
          ip.InsurancePolicyID ,
          @VendorImportID ,
          ip.InsuranceProgramTypeID ,
          ip.GroupName ,
          ip.ReleaseOfInformation 
FROM dbo.InsurancePolicy ip 
LEFT JOIN dbo.PatientCase pc ON
	ip.PatientCaseID = pc. VendorID
WHERE ip.PracticeID = @OldPracticeID AND pc.PracticeID = @PracticeID
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

