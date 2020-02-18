--USE superbill_5359_dev
USE superbill_5359_prod
go

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @OldPracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @OldPracticeID = 2
SET @VendorImportID = 101

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

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
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' + CAST(@@Rowcount AS VARCHAR) + ' Insurance Policies deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' Patient Journal Notes deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' PatientAlerts deleted'
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


SET IDENTITY_INSERT dbo.Patient OFF

PRINT''
PRINT'Inserting into Patient ...'
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
SELECT    @PracticeID ,
          p.ReferringPhysicianID ,
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
          p.PatientReferralSourceID ,
          p.PrimaryProviderID ,
          p.DefaultServiceLocationID ,
          p.EmployerID ,
          p.MedicalRecordNumber ,
          p.MobilePhone ,
          p.MobilePhoneExt ,
          p.PrimaryCarePhysicianID ,
          p.PatientID ,
          @VendorImportID ,
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
WHERE p.PracticeID = @OldPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.Patient ON



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
WHERE ip.PracticeID = @OldPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT ''
--PRINT 'Inserting into StandardFeeSchedule ...'
--INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
--        ( PracticeID ,
--          Name ,
--          Notes ,
--          EffectiveStartDate ,
--          SourceType ,
--          SourceFileName ,
--          EClaimsNoResponseTrigger ,
--          PaperClaimsNoResponseTrigger ,
--          MedicareFeeScheduleGPCICarrier ,
--          MedicareFeeScheduleGPCILocality ,
--          MedicareFeeScheduleGPCIBatchID ,
--          MedicareFeeScheduleRVUBatchID ,
--          AddPercent ,
--          AnesthesiaTimeIncrement
--        )
--SELECT    @PracticeID , -- PracticeID - int
--          sfs.Name , -- Name - varchar(128)
--          sfs.Notes , -- Notes - varchar(1024)
--          sfs.EffectiveStartDate , -- EffectiveStartDate - datetime
--          sfs.SourceType , -- SourceType - char(1)
--          sfs.SourceFileName , -- SourceFileName - varchar(256)
--          sfs.EClaimsNoResponseTrigger , -- EClaimsNoResponseTrigger - int
--          sfs.PaperClaimsNoResponseTrigger , -- PaperClaimsNoResponseTrigger - int
--          sfs.MedicareFeeScheduleGPCICarrier , -- MedicareFeeScheduleGPCICarrier - int
--          sfs.MedicareFeeScheduleGPCILocality , -- MedicareFeeScheduleGPCILocality - int
--          sfs.MedicareFeeScheduleGPCIBatchID , -- MedicareFeeScheduleGPCIBatchID - int
--          sfs.MedicareFeeScheduleRVUBatchID , -- MedicareFeeScheduleRVUBatchID - int
--          sfs.AddPercent , -- AddPercent - decimal
--          sfs.AnesthesiaTimeIncrement  -- AnesthesiaTimeIncrement - int
--FROM dbo.ContractsAndFees_StandardFeeSchedule sfs 
--WHERE sfs.PracticeID = @OldPracticeID
--PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--PRINT ''
--PRINT 'Inserting into StandardFee ...'
--INSERT INTO dbo.ContractsAndFees_StandardFee
--        ( StandardFeeScheduleID ,
--          ProcedureCodeID ,
--          ModifierID ,
--          SetFee ,
--          AnesthesiaBaseUnits
--        )
--SELECT    newsfs.StandardFeeScheduleID , -- StandardFeeScheduleID - int
--          sf.ProcedureCodeID , -- ProcedureCodeID - int
--          sf.ModifierID , -- ModifierID - int
--          sf.SetFee , -- SetFee - money
--          sf.AnesthesiaBaseUnits  -- AnesthesiaBaseUnits - int
--FROM dbo.ContractsAndFees_StandardFee sf
--INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule oldsfs ON
--	oldsfs.PracticeID = @OldPracticeID AND
--	oldsfs.StandardFeeScheduleID = sf.StandardFeeScheduleID
--INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule newsfs ON
--	newsfs.PracticeID = @PracticeID AND
--	newsfs.NAME = oldsfs.NAME 
--PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--PRINT ''
--PRINT 'Inserting into ContractRateScheduleLink ...'
--INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
--        ( ProviderID ,
--          LocationID ,
--          StandardFeeScheduleID
--        )
--SELECT    doc.DoctorID , -- ProviderID - int
--          (SELECT ServicelocationID FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID) , -- LocationID - int
--          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
--FROM dbo.ContractsAndFees_StandardFeeSchedule sfs, dbo.Doctor doc
--WHERE sfs.PracticeID = @PracticeID AND
--	  doc.PracticeID = @PracticeID
--PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--PRINT ''
--PRINT 'Inserting into Appointment ...'
--INSERT INTO dbo.Appointment
--        ( PatientID ,
--          PracticeID ,
--          ServiceLocationID ,
--          StartDate ,
--          EndDate ,
--          AppointmentType ,
--          Subject ,
--          Notes ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          AppointmentResourceTypeID ,
--          AppointmentConfirmationStatusCode ,
--          AllDay ,
--          InsurancePolicyAuthorizationID ,
--          PatientCaseID ,
--          Recurrence ,
--          RecurrenceStartDate ,
--          RangeEndDate ,
--          RangeType ,
--          StartDKPracticeID ,
--          EndDKPracticeID ,
--          StartTm ,
--          EndTm 
--        )
--SELECT    pat.PatientID ,
--          @PracticeID ,
--          sl.ServiceLocationID ,
--          app.StartDate ,
--          app.EndDate ,
--          app.AppointmentType ,
--          app.AppointmentID ,
--          app.Notes ,
--          app.CreatedDate ,
--          app.CreatedUserID ,
--          GETDATE() ,
--          app.ModifiedUserID ,
--          app.AppointmentResourceTypeID ,
--          app.AppointmentConfirmationStatusCode ,
--          app.AllDay ,
--          app.InsurancePolicyAuthorizationID ,
--          pc.PatientCaseID ,
--          app.Recurrence ,
--          app.RecurrenceStartDate ,
--          app.RangeEndDate ,
--          app.RangeType ,
--          dk.DKPracticeID ,
--          dk.DKPracticeID ,
--          app.StartTm ,
--          app.EndTm
--FROM dbo.Appointment app
--INNER JOIN dbo.Patient pat ON 
--    app.PatientID = pat.VendorID AND
--    pat.PracticeID = @PracticeID
--INNER JOIN dbo.ServiceLocation sl ON
--	sl.PracticeID = @PracticeID
--INNER JOIN dbo.PatientCase pc ON
--	pc.PatientID = pat.PatientID AND
--	pc.VendorID = app.PatientCaseID AND
--	pc.PracticeID = @PracticeID
--INNER JOIN dbo.DateKeyToPractice dk ON
--	dk.PracticeID = @PracticeID AND
--	dk.Dt = (SELECT Dt FROM dbo.DateKeyToPractice WHERE DKPracticeID = app.StartDKPracticeID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--PRINT ''
--PRINT 'Inserting into AppointmentToResource ...'
--INSERT INTO dbo.AppointmentToResource 
--        ( AppointmentID ,
--          AppointmentResourceTypeID ,
--          ResourceID ,
--          ModifiedDate ,
--          PracticeID
--        )
--SELECT    app.AppointmentID , -- AppointmentID - int
--          app.APpointmentResourceTypeID , -- AppointmentResourceTypeID - int
--          0 , -- ResourceID - int
--          GETDATE() , -- ModifiedDate - datetime
--          @PracticeID  -- PracticeID - int
--FROM dbo.AppointmentToResource atr 
--INNER JOIN dbo.Appointment app ON
--	app.Subject = atr.AppointmentID AND
--	app.PracticeID = @PracticeID
--INNER JOIN dbo.Doctor doc ON 
--	doc.FirstName = (SELECT FirstName FROM dbo.Doctor WHERE DoctorID = atr.ResourceID) AND 
--	doc.lastName = (SELECT LastName FROM dbo.Doctor WHERE DoctorID = atr.ResourceID) AND
--	doc.[External] <> 1
--WHERE doc.DoctorID IS NOT NULL
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--PRINT ''
--PRINT 'Inserting into AppointmentReason ...'
--INSERT INTO dbo.AppointmentReason
--        ( PracticeID ,
--          Name ,
--          DefaultDurationMinutes ,
--          DefaultColorCode ,
--          Description ,
--          ModifiedDate 
--        )
--SELECT    @PracticeID , -- PracticeID - int
--          ar.NAME , -- Name - varchar(128)
--          ar.DefaultDurationMinutes , -- DefaultDurationMinutes - int
--          ar.DefaultColorCode , -- DefaultColorCode - int
--          ar.[Description] , -- Description - varchar(256)
--          GETDATE()  -- ModifiedDate - datetime
--FROM dbo.AppointmentReason  ar
--WHERE ar.PracticeID = 1
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting into AppointmentToAppointmentReason ...'
--INSERT INTO dbo.AppointmentToAppointmentReason
--        ( AppointmentID ,
--          AppointmentReasonID ,
--          PrimaryAppointment ,
--          ModifiedDate ,
--          PracticeID
--        )
--SELECT    app.AppointmentID , -- AppointmentID - int
--          ar.AppointmentReasonID , -- AppointmentReasonID - int
--          atar.PrimaryAppointment , -- PrimaryAppointment - bit
--          GETDATE() , -- ModifiedDate - datetime
--          @PracticeID  -- PracticeID - int
--FROM dbo.AppointmentToAppointmentReason atar
--INNER JOIN dbo.Appointment app ON 
--	app.Subject = atar.AppointmentID AND
--	app.PracticeID = @PracticeID
--INNER JOIN dbo.AppointmentReason ar ON
--	ar.NAME = (SELECT name FROM dbo.AppointmentReason WHERE atar.AppointmentReasonID = AppointmentReasonID AND PracticeID = @OldPracticeID) AND
--	ar.PracticeID = @PracticeID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--INSERT INTO dbo.PracticeToInsuranceCompany
--        ( PracticeID ,
--          InsuranceCompanyID ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          EClaimsProviderID ,
--          EClaimsEnrollmentStatusID ,
--          EClaimsDisable ,
--          AcceptAssignment ,
--          UseSecondaryElectronicBilling ,
--          UseCoordinationOfBenefits ,
--          ExcludePatientPayment ,
--          BalanceTransfer
--        )
--SELECT    @PracticeID , -- PracticeID - int
--          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          ptic.EClaimsProviderID , -- EClaimsProviderID - varchar(32)
--          ptic.EClaimsProviderID , -- EClaimsEnrollmentStatusID - int
--          ptic.EClaimsDisable , -- EClaimsDisable - int
--          ptic.AcceptAssignment , -- AcceptAssignment - bit
--          ptic.AcceptAssignment , -- UseSecondaryElectronicBilling - bit
--          ptic.UseCoordinationOfBenefits , -- UseCoordinationOfBenefits - bit
--          ptic.ExcludePatientPayment , -- ExcludePatientPayment - bit
--          ptic.BalanceTransfer  -- BalanceTransfer - bit
--FROM dbo.PracticeToInsuranceCompany ptic
--INNER JOIN dbo.InsuranceCompany ic ON
--	ic.InsuranceCompanyID = ptic.InsuranceCompanyID
--WHERE ptic.PracticeID = @OldPracticeID
	

COMMIT