--USE superbill_11667_dev
USE superbill_11667_prod
go

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON


DECLARE @PracticeID INT
DECLARE @OldPracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 3
SET @OldPracticeID = 1
SET @VendorImportID = '999'

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))



DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' + CAST(@@Rowcount AS VARCHAR) + ' Insurance Policies deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' Patient Journal Notes deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' +  CAST(@@rowcount AS VARCHAR) + ' Patient Cases deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' Patients deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' Doctors deleted'



UPDATE dbo.InsuranceCompany 
	SET ReviewCode = 'R'
	WHERE CreatedPracticeID = @OldPracticeID
	
UPDATE dbo.InsuranceCompanyPlan
	SET ReviewCode = 'R'
	WHERE CreatedPracticeID = @OldPracticeID


PRINT''
PRINT'Inserting into Doctor ...'
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
          GlobalPayToCountry 
        )
SELECT    @PracticeID ,
          doc.Prefix ,
          doc.FirstName ,
          doc.MiddleName ,
          doc.LastName ,
          doc.Suffix ,
          doc.SSN ,
          doc.AddressLine1 ,
          doc.AddressLine2 ,
          doc.City ,
          doc.State ,
          doc.Country ,
          doc.ZipCode ,
          doc.HomePhone ,
          doc.HomePhoneExt ,
          doc.WorkPhone ,
          doc.WorkPhoneExt ,
          doc.PagerPhone ,
          doc.PagerPhoneExt ,
          doc.MobilePhone ,
          doc.MobilePhoneExt ,
          doc.DOB ,
          doc.EmailAddress ,
          doc.Notes ,
          doc.ActiveDoctor ,
          doc.CreatedDate ,
          doc.CreatedUserID ,
          doc.ModifiedDate ,
          doc.ModifiedUserID ,
          doc.UserID ,
          doc.Degree ,
          doc.DefaultEncounterTemplateID ,
          doc.TaxonomyCode ,
          doc.DepartmentID ,
          doc.DoctorID ,
          @VendorImportID ,
          doc.FaxNumber ,
          doc.FaxNumberExt ,
          doc.OrigReferringPhysicianID ,
          [External] ,
          doc.NPI ,
          doc.ProviderTypeID ,
          doc.ProviderPerformanceReportActive ,
          doc.ProviderPerformanceScope ,
          doc.ProviderPerformanceFrequency ,
          doc.ProviderPerformanceDelay ,
          doc.ProviderPerformanceCarbonCopyEmailRecipients ,
          doc.ExternalBillingID ,
          doc.GlobalPayToAddressFlag ,
          doc.GlobalPayToName ,
          doc.GlobalPayToAddressLine1 ,
          doc.GlobalPayToAddressLine2 ,
          doc.GlobalPayToCity ,
          doc.GlobalPayToState ,
          doc.GlobalPayToZipCode ,
          doc.GlobalPayToCountry 
FROM dbo.Doctor doc
WHERE doc.PracticeID = @OldPracticeID AND
	doc.[External] = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT''
PRINT'Inserting into Patient ...'
INSERT INTO dbo.Patient 
        ( PracticeID ,
          ReferringPhysicianID,
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
SELECT    @PracticeID ,
          rdoc.DoctorID ,
          p.Prefix ,
          p.FirstName ,
          p.MiddleName ,
          p.LastName ,
          p.Suffix ,
          p.AddressLine1 ,
          p.AddressLine2 ,
          p.City ,
          p.State ,
          p.Country ,
          p.ZipCode ,
          p.Gender ,
          p.MaritalStatus ,
          p.HomePhone ,
          p.HomePhoneExt ,
          p.WorkPhone ,
          p.WorkPhoneExt ,
          p.DOB ,
          p.SSN ,
          p.EmailAddress ,
          p.ResponsibleDifferentThanPatient ,
          p.ResponsiblePrefix ,
          p.ResponsibleFirstName ,
          p.ResponsibleMiddleName ,
          p.ResponsibleLastName ,
          p.ResponsibleSuffix ,
          p.ResponsibleRelationshipToPatient ,
          p.ResponsibleAddressLine1 ,
          p.ResponsibleAddressLine2 ,
          p.ResponsibleCity ,
          p.ResponsibleState ,
          p.ResponsibleCountry ,
          p.ResponsibleZipCode ,
          p.CreatedDate ,
          p.CreatedUserID ,
          p.ModifiedDate ,
          p.ModifiedUserID ,
          p.EmploymentStatus ,
          p.InsuranceProgramCode ,
          pp.DoctorID ,
          4 ,
          p.EmployerID ,
          p.MedicalRecordNumber ,
          p.MobilePhone ,
          p.MobilePhoneExt ,
          pcp.DoctorID ,
          p.PatientID , --VendorID
          @VendorImportID,
          p.CollectionCategoryID ,
          p.Active ,
          p.SendEmailCorrespondence ,
          p.PhonecallRemindersEnabled ,
          p.EmergencyName ,
          p.EmergencyPhone ,
          p.EmergencyPhoneExt ,
          p.Ethnicity ,
          p.Race ,
          p.LicenseNumber ,
          p.LicenseState ,
          p.Language1 ,
          p.Language2
FROM dbo.Patient p
LEFT JOIN dbo.Doctor rdoc ON
	p.ReferringPhysicianID = rdoc.VendorID AND
	rdoc.VendorImportID = @VendorImportID AND 
	rdoc.PracticeID = @PracticeID AND
	rdoc.[External] = 1
LEFT JOIN dbo.Doctor pcp ON
	p.PrimaryCarePhysicianID = pcp.VendorID AND 
	pcp.VendorImportID = @VendorImportID AND 
	pcp.PracticeID = @PracticeID 
LEFT JOIN dbo.Doctor pp ON
	p.PrimaryProviderID = pp.VendorID AND 
	pp.VendorImportID = @VendorImportID AND 
	pp.PracticeID = @PracticeID 
WHERE p.PracticeID = @OldPracticeID AND
      p.PrimaryCarePhysicianID IS NULL AND
      p.PrimaryProviderID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'





PRINT''
PRINT'Inserting into Patient ...'
INSERT INTO dbo.Patient 
        ( PracticeID ,
          ReferringPhysicianID,
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
SELECT    @PracticeID ,
          rdoc.DoctorID ,
          p.Prefix ,
          p.FirstName ,
          p.MiddleName ,
          p.LastName ,
          p.Suffix ,
          p.AddressLine1 ,
          p.AddressLine2 ,
          p.City ,
          p.State ,
          p.Country ,
          p.ZipCode ,
          p.Gender ,
          p.MaritalStatus ,
          p.HomePhone ,
          p.HomePhoneExt ,
          p.WorkPhone ,
          p.WorkPhoneExt ,
          p.DOB ,
          p.SSN ,
          p.EmailAddress ,
          p.ResponsibleDifferentThanPatient ,
          p.ResponsiblePrefix ,
          p.ResponsibleFirstName ,
          p.ResponsibleMiddleName ,
          p.ResponsibleLastName ,
          p.ResponsibleSuffix ,
          p.ResponsibleRelationshipToPatient ,
          p.ResponsibleAddressLine1 ,
          p.ResponsibleAddressLine2 ,
          p.ResponsibleCity ,
          p.ResponsibleState ,
          p.ResponsibleCountry ,
          p.ResponsibleZipCode ,
          p.CreatedDate ,
          p.CreatedUserID ,
          p.ModifiedDate ,
          p.ModifiedUserID ,
          p.EmploymentStatus ,
          p.InsuranceProgramCode ,
          pp.DoctorID ,
          4 ,
          p.EmployerID ,
          p.MedicalRecordNumber ,
          p.MobilePhone ,
          p.MobilePhoneExt ,
          pcp.DoctorID ,
          p.PatientID , --VendorID
          @VendorImportID,
          p.CollectionCategoryID ,
          p.Active ,
          p.SendEmailCorrespondence ,
          p.PhonecallRemindersEnabled ,
          p.EmergencyName ,
          p.EmergencyPhone ,
          p.EmergencyPhoneExt ,
          p.Ethnicity ,
          p.Race ,
          p.LicenseNumber ,
          p.LicenseState ,
          p.Language1 ,
          p.Language2
FROM dbo.Patient p
LEFT JOIN dbo.Doctor rdoc ON
	p.ReferringPhysicianID = rdoc.VendorID AND
	rdoc.VendorImportID = @VendorImportID AND 
	rdoc.PracticeID = @PracticeID AND
	rdoc.[External] = 1
LEFT JOIN dbo.Doctor pcp ON
	p.PrimaryCarePhysicianID = pcp.VendorID AND 
	pcp.VendorImportID = @VendorImportID AND 
	pcp.PracticeID = @PracticeID 
LEFT JOIN dbo.Doctor pp ON
	p.PrimaryProviderID = pp.VendorID AND 
	pp.VendorImportID = @VendorImportID AND 
	pp.PracticeID = @PracticeID 
WHERE p.PracticeID = @OldPracticeID AND
      p.PrimaryCarePhysicianID = 2 AND
      p.PrimaryProviderID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




PRINT''
PRINT'Inserting into Patient ...'
INSERT INTO dbo.Patient 
        ( PracticeID ,
          ReferringPhysicianID,
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
SELECT    @PracticeID ,
          rdoc.DoctorID ,
          p.Prefix ,
          p.FirstName ,
          p.MiddleName ,
          p.LastName ,
          p.Suffix ,
          p.AddressLine1 ,
          p.AddressLine2 ,
          p.City ,
          p.State ,
          p.Country ,
          p.ZipCode ,
          p.Gender ,
          p.MaritalStatus ,
          p.HomePhone ,
          p.HomePhoneExt ,
          p.WorkPhone ,
          p.WorkPhoneExt ,
          p.DOB ,
          p.SSN ,
          p.EmailAddress ,
          p.ResponsibleDifferentThanPatient ,
          p.ResponsiblePrefix ,
          p.ResponsibleFirstName ,
          p.ResponsibleMiddleName ,
          p.ResponsibleLastName ,
          p.ResponsibleSuffix ,
          p.ResponsibleRelationshipToPatient ,
          p.ResponsibleAddressLine1 ,
          p.ResponsibleAddressLine2 ,
          p.ResponsibleCity ,
          p.ResponsibleState ,
          p.ResponsibleCountry ,
          p.ResponsibleZipCode ,
          p.CreatedDate ,
          p.CreatedUserID ,
          p.ModifiedDate ,
          p.ModifiedUserID ,
          p.EmploymentStatus ,
          p.InsuranceProgramCode ,
          pp.DoctorID ,
          4 ,
          p.EmployerID ,
          p.MedicalRecordNumber ,
          p.MobilePhone ,
          p.MobilePhoneExt ,
          pcp.DoctorID ,
          p.PatientID , --VendorID
          @VendorImportID,
          p.CollectionCategoryID ,
          p.Active ,
          p.SendEmailCorrespondence ,
          p.PhonecallRemindersEnabled ,
          p.EmergencyName ,
          p.EmergencyPhone ,
          p.EmergencyPhoneExt ,
          p.Ethnicity ,
          p.Race ,
          p.LicenseNumber ,
          p.LicenseState ,
          p.Language1 ,
          p.Language2
FROM dbo.Patient p
LEFT JOIN dbo.Doctor rdoc ON
	p.ReferringPhysicianID = rdoc.VendorID AND
	rdoc.VendorImportID = @VendorImportID AND 
	rdoc.PracticeID = @PracticeID AND
	rdoc.[External] = 1
LEFT JOIN dbo.Doctor pcp ON
	p.PrimaryCarePhysicianID = pcp.VendorID AND 
	pcp.VendorImportID = @VendorImportID AND 
	pcp.PracticeID = @PracticeID 
LEFT JOIN dbo.Doctor pp ON
	p.PrimaryProviderID = pp.VendorID AND 
	pp.VendorImportID = @VendorImportID AND 
	pp.PracticeID = @PracticeID 
WHERE p.PracticeID = @OldPracticeID AND
      p.PrimaryCarePhysicianID IS NULL AND
      p.PrimaryProviderID = 2
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
          pc.PatientCaseID , --VendorID
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
	pc.PatientID = pat.VendorID AND
	pat.VendorImportID = @VendorImportID
LEFT JOIN dbo.Doctor rdoc ON
	pc.ReferringPhysicianID = rdoc.VendorID AND
	rdoc.VendorImportID = @VendorImportID
WHERE pc.PracticeID = @OldPracticeID AND 
	pat.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


	

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
	pjn.PatientID = pat.VendorID AND
	pat.VendorImportID = @VendorImportID
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
INNER JOIN dbo.PatientCase pc ON
	ip.PatientCaseID = pc. VendorID AND
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID
WHERE ip.PracticeID = @OldPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


COMMIT 



/*
SELECT * FROM patient WHERE PracticeID = 1

DELETE FROM dbo.Patient WHERE PracticeID = 3
SELECT * FROM dbo.Patient WHERE PracticeID = 3





SELECT DISTINCT PrimaryCarePhysicianID, PrimaryProviderID FROM dbo.Patient WHERE PracticeID = 1
SELECT * FROM dbo.Doctor
SELECT * FROM dbo.ServiceLocation
SELECT * FROM dbo.Practice

SELECT COUNT(*) FROM patient WHERE PracticeID = 1 AND PrimaryCarePhysicianID IS NULL AND PrimaryProviderID IS NULL 


SELECT * FROM patient WHERE PracticeID = 1 AND PrimaryCarePhysicianID IS NOT NULL
SELECT * FROM patient WHERE PracticeID = 1 AND PrimaryProviderID = 1 AND PrimaryCarePhysicianID = 2
SELECT * FROM patient WHERE PracticeID = 1 AND PrimaryProviderID = 2 AND PrimaryCarePhysicianID = 1
*/