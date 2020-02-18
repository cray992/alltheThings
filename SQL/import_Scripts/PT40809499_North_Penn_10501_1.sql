USE superbill_10501_dev
--USE superbill_10501_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT


SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))


DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientJournalNote records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
	

	
-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
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
          LocalUseFieldTypeCode ,
          ReviewCode ,
          ProviderNumberTypeID ,
          GroupNumberTypeID ,
          LocalUseProviderNumberTypeID ,
          CompanyTextID ,
          ClearinghousePayerID ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          KareoInsuranceCompanyID ,
          KareoLastModifiedDate ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
)
SELECT 
		  ic2.InsuranceCompanyName ,
          ic2.Notes ,
          ic2.AddressLine1 ,
          ic2.AddressLine2 ,
          ic2.City ,
          ic2.State ,
          ic2.Country ,
          ic2.ZipCode ,
          ic2.ContactPrefix ,
          ic2.ContactFirstName ,
          ic2.ContactMiddleName ,
          ic2.ContactLastName ,
          ic2.ContactSuffix ,
          ic2.Phone ,
          ic2.PhoneExt ,
          ic2.Fax ,
          ic2.FaxExt ,
          ic2.BillSecondaryInsurance ,
          ic2.EClaimsAccepts ,
          ic2.BillingFormID ,
          ic2.InsuranceProgramCode ,
          ic2.HCFADiagnosisReferenceFormatCode ,
          ic2.HCFASameAsInsuredFormatCode ,
          ic2.LocalUseFieldTypeCode ,
          ic2.ReviewCode ,
          ic2.ProviderNumberTypeID ,
          ic2.GroupNumberTypeID ,
          ic2.LocalUseProviderNumberTypeID ,
          ic2.CompanyTextID ,
          ic2.ClearinghousePayerID ,
          ic2.CreatedPracticeID ,
          ic2.CreatedDate ,
          ic2.CreatedUserID ,
          ic2.ModifiedDate ,
          ic2.ModifiedUserID ,
          ic2.KareoInsuranceCompanyID ,
          ic2.KareoLastModifiedDate ,
          ic2.SecondaryPrecedenceBillingFormID ,
          ic2.InsuranceCompanyID ,
          @VendorImportID ,
          ic2.DefaultAdjustmentCode ,
          ic2.ReferringProviderNumberTypeID ,
          ic2.NDCFormat ,
          ic2.UseFacilityID ,
          ic2.AnesthesiaType ,
          ic2.InstitutionalBillingFormID
FROM dbo.InsuranceCompany ic2
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic1 WHERE CreatedPracticeID = 1 AND
						ic1.InsuranceCompanyName = ic2.InsuranceCompanyName)
	AND ic2.CreatedPracticeID = 2

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
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
          EmergencyPhoneExt 
        )
SELECT	  @PracticeID ,
          pat2.ReferringPhysicianID ,
          pat2.Prefix ,
          pat2.FirstName ,
          pat2.MiddleName ,
          pat2.LastName ,
          pat2.Suffix ,
          pat2.AddressLine1 ,
          pat2.AddressLine2 ,
          pat2.City ,
          pat2.State ,
          pat2.Country ,
          pat2.ZipCode ,
          pat2.Gender ,
          pat2.MaritalStatus ,
          pat2.HomePhone ,
          pat2.HomePhoneExt ,
          pat2.WorkPhone ,
          pat2.WorkPhoneExt ,
          pat2.DOB ,
          pat2.SSN ,
          pat2.EmailAddress ,
          pat2.ResponsibleDifferentThanPatient ,
          pat2.ResponsiblePrefix ,
          pat2.ResponsibleFirstName ,
          pat2.ResponsibleMiddleName ,
          pat2.ResponsibleLastName ,
          pat2.ResponsibleSuffix ,
          pat2.ResponsibleRelationshipToPatient ,
          pat2.ResponsibleAddressLine1 ,
          pat2.ResponsibleAddressLine2 ,
          pat2.ResponsibleCity ,
          pat2.ResponsibleState ,
          pat2.ResponsibleCountry ,
          pat2.ResponsibleZipCode ,
          pat2.CreatedDate ,
          pat2.CreatedUserID ,
          pat2.ModifiedDate ,
          pat2.ModifiedUserID ,
          pat2.EmploymentStatus ,
          pat2.InsuranceProgramCode ,
          pat2.PatientReferralSourceID ,
          pat2.PrimaryProviderID ,
          pat2.DefaultServiceLocationID ,
          pat2.EmployerID ,
          pat2.MedicalRecordNumber ,
          pat2.MobilePhone ,
          pat2.MobilePhoneExt ,
          pat2.PrimaryCarePhysicianID ,
          pat2.PatientID ,
          @VendorImportID ,
          pat2.CollectionCategoryID ,
          pat2.Active ,
          pat2.SendEmailCorrespondence ,
          pat2.PhonecallRemindersEnabled ,
          pat2.EmergencyName ,
          pat2.EmergencyPhone ,
          pat2.EmergencyPhoneExt 
FROM dbo.Patient pat2
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pat1 WHERE pat1.PracticeID = @PracticeID
						AND pat1.FirstName = pat2.FirstName AND pat1.LastName = pat2.LastName AND pat1.SSN = pat2.SSN) 
	AND pat2.PracticeID = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Journal note
PRINT ''
PRINT 'Inserting records into PatientJournalNote ...'
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
SELECT	  pjn2.CreatedDate ,
          pjn2.CreatedUserID ,
          pjn2.ModifiedDate ,
          pjn2.ModifiedUserID ,
         (SELECT patientID FROM patient WHERE pjn2.PatientID = VendorID AND PracticeID = 1),
          pjn2.UserName ,
          pjn2.SoftwareApplicationID ,
          pjn2.Hidden ,
          pjn2.NoteMessage ,
          pjn2.AccountStatus ,
          pjn2.NoteTypeCode ,
          pjn2.LastNote
FROM dbo.PatientJournalNote pjn2
WHERE pjn2.PatientID NOT IN (SELECT p1.PatientID FROM dbo.Patient p1
		INNER JOIN dbo.patient p2 ON p1.FirstName = p2.FirstName AND p1.LastName = p2.LastName 
			AND p1.ssn = p2.ssn AND p2.PracticeID = 2 WHERE p1.practiceid = 1)
	 AND pjn2.PatientID IN (SELECT vendorID FROM patient WHERE practiceID = 1)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Case
PRINT ''
PRINT 'Inserting records into PatientCase ...'
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
SELECT	  (SELECT patientID FROM patient WHERE pc2.PatientID = VendorID AND PracticeID = 1),
          pc2.Name ,
          pc2.Active ,
          pc2.PayerScenarioID ,
          pc2.ReferringPhysicianID ,
          pc2.EmploymentRelatedFlag ,
          pc2.AutoAccidentRelatedFlag ,
          pc2.OtherAccidentRelatedFlag ,
          pc2.AbuseRelatedFlag ,
          pc2.AutoAccidentRelatedState ,
          pc2.Notes ,
          pc2.ShowExpiredInsurancePolicies ,
          pc2.CreatedDate ,
          pc2.CreatedUserID ,
          pc2.ModifiedDate ,
          pc2.ModifiedUserID ,
          pc2.PracticeID ,
          pc2.CaseNumber ,
          pc2.WorkersCompContactInfoID ,
          pc2.VendorID ,
          pc2.VendorImportID ,
          pc2.PregnancyRelatedFlag ,
          pc2.StatementActive ,
          pc2.EPSDT ,
          pc2.FamilyPlanning ,
          pc2.EPSDTCodeID ,
          pc2.EmergencyRelated ,
          pc2.HomeboundRelatedFlag
FROM patientCase pc2
WHERE pc2.PatientID NOT IN (SELECT p1.PatientID FROM dbo.Patient p1
		INNER JOIN dbo.patient p2 ON p1.FirstName = p2.FirstName AND p1.LastName = p2.LastName 
			AND p1.ssn = p2.ssn AND p2.PracticeID = 2 WHERE p1.practiceid = 1)
	 AND pc2.PatientID IN (SELECT vendorID FROM patient WHERE practiceID = 1)
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Appointment
PRINT ''
PRINT 'Inserting records into Appointment ...'
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
          AllDay ,
          InsurancePolicyAuthorizationID ,
          PatientCaseID ,
          Recurrence ,
          RecurrenceStartDate ,
          RangeEndDate ,
          RangeType ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm ,
        )
SELECT	  (SELECT patientID FROM patient WHERE app2.PatientID = VendorID AND PracticeID = 1),
          app2.PracticeID ,
          app2.ServiceLocationID ,
          app2.StartDate ,
          app2.EndDate ,
          app2.AppointmentType ,
          app2.Subject ,
          'Vendor:'(SELECT patientID FROM patient WHERE app2.PatientID = VendorID AND PracticeID = 1) + '   ' + app2.Notes ,
          app2.CreatedDate ,
          app2.CreatedUserID ,
          app2.ModifiedDate ,
          app2.ModifiedUserID ,
          app2.AppointmentResourceTypeID ,
          app2.AppointmentConfirmationStatusCode ,
          app2.AllDay ,
          app2.InsurancePolicyAuthorizationID ,
          app2.PatientCaseID ,
          app2.Recurrence ,
          app2.RecurrenceStartDate ,
          app2.RangeEndDate ,
          app2.RangeType ,
          app2.StartDKPracticeID ,
          app2.EndDKPracticeID ,
          app2.StartTm ,
          app2.EndTm 
FROM dbo.Appointment app2
WHERE app2.PatientID NOT IN (SELECT p1.patientID FROM dbo.Patient p1
								INNER JOIN dbo.patient p2 ON p1.FirstName = p2.FirstName AND p1.LastName = p2.LastName
									AND p1.SSN AND p2.ssn AND p1.PracticeID = 1 AND p2.PracticeID = 2)
	  AND app2.PatientID IN (SELECT vendorId FROM patient WHERE practiceID = 1)

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




-- AppointmentResource
PRINT ''
PRINT 'Inserting records into AppointmentToResource ...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
SELECT	  0 , -- AppointmentID - int
          0 , -- AppointmentResourceTypeID - int
          0 , -- ResourceID - int
          '2012-12-10 23:59:31' , -- ModifiedDate - datetime
          NULL , -- TIMESTAMP - timestamp
          0  -- PracticeID - int
FROM dbo.AppointmentToResource atr2

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          TIMESTAMP ,
          PracticeID
        )
SELECT    (SELECT a.AppointmentID FROM dbo.Appointment a WHERE a.patientid = (SELECT patientID FROM patient 
							WHERE app2.PatientID = VendorID AND PracticeID = 1) , -- AppointmentID - int
          (aar2.AppointmentReasonID - 19) , -- AppointmentReasonID - int
          NULL , -- PrimaryAppointment - bit
          '2012-12-11 00:43:19' , -- ModifiedDate - datetime
          NULL , -- TIMESTAMP - timestamp
          0  -- PracticeID - int
        )
FROM dbo.AppointmentToAppointmentReason aar2


COMMIT TRAN