USE superbill_18606_prod


PRINT ''
PRINT 'Inserting into Patient ...'
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
SELECT    CASE WHEN pat.PracticeID = 1 THEN 5 WHEN pat.PracticeID = 2 THEN 6 END ,
          NULL ,
          pat.Prefix ,
          pat.FirstName ,
          pat.MiddleName ,
          pat.LastName ,
          pat.Suffix ,
          pat.AddressLine1 ,
          pat.AddressLine2 ,
          pat.City ,
          pat.State ,
          pat.Country ,
          pat.ZipCode ,
          pat.Gender ,
          pat.MaritalStatus ,
          pat.HomePhone ,
          pat.HomePhoneExt ,
          pat.WorkPhone ,
          pat.WorkPhoneExt ,
          pat.DOB ,
          pat.SSN ,
          pat.EmailAddress ,
          pat.ResponsibleDifferentThanPatient ,
          pat.ResponsiblePrefix ,
          pat.ResponsibleFirstName ,
          pat.ResponsibleMiddleName ,
          pat.ResponsibleLastName ,
          pat.ResponsibleSuffix ,
          pat.ResponsibleRelationshipToPatient ,
          pat.ResponsibleAddressLine1 ,
          pat.ResponsibleAddressLine2 ,
          pat.ResponsibleCity ,
          pat.ResponsibleState ,
          pat.ResponsibleCountry ,
          pat.ResponsibleZipCode ,
          pat.CreatedDate ,
          pat.CreatedUserID ,
          GETDATE() ,
          0 ,
          pat.EmploymentStatus ,
          pat.InsuranceProgramCode ,
          pat.PatientReferralSourceID ,
          CASE WHEN pat.PrimaryProviderID = 2 THEN 195 WHEN pat.PrimaryProviderID = 6 THEN 328 END  ,
          CASE WHEN pat.DefaultServiceLocationID = 1 THEN 113 WHEN pat.DefaultServiceLocationID = 2 THEN 112 END ,
          pat.EmployerID ,
          pat.MedicalRecordNumber ,
          pat.MobilePhone ,
          pat.MobilePhoneExt ,
          NULL ,
          pat.PatientID ,
          pat.VendorImportID ,
          pat.CollectionCategoryID ,
          pat.Active ,
          pat.SendEmailCorrespondence ,
          pat.PhonecallRemindersEnabled ,
          pat.EmergencyName ,
          pat.EmergencyPhone ,
          pat.EmergencyPhoneExt ,
          pat.Ethnicity ,
          pat.Race ,
          pat.LicenseNumber ,
          pat.LicenseState ,
          pat.Language1 ,
          pat.Language2
FROM dbo.[PatientTEMP] pat WHERE
	pat.patientid IN (4, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
	
	--14 patients inserted
	
PRINT ''
PRINT 'Updated Patients ...'	
UPDATE dbo.Patient
	SET VendorID = (SELECT PatientID FROM dbo.[PatientTEMP] pat 
					WHERE lower(pat.FirstName) = lower(p.Firstname) AND lower(pat.LastName) = lower(p.LastName) and pat.DOB = p.DOB)
	FROM dbo.Patient p
	WHERE p.PatientID IN (5746, 19772, 6535, 16424, 19747, 7413, 15839, 9447, 19767, 19568, 19658, 9754, 11231)
 PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

	-- 13 patients updated
	
UPDATE dbo.Patient
	SET VendorID = 8 
	WHERE PatientID = 7371	

	--1 patient updated

PRINT ''
PRINT 'Inserting into PatientCase ...'
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
          CASE WHEN pc.PracticeID = 1 THEN 5 WHEN pc.PracticeID = 2 THEN 6 END  ,
          pc.CaseNumber ,
          pc.WorkersCompContactInfoID ,
          pc.PatientCaseID ,
          pc.VendorImportID ,
          pc.PregnancyRelatedFlag ,
          pc.StatementActive ,
          pc.EPSDT ,
          pc.FamilyPlanning ,
          pc.EPSDTCodeID ,
          pc.EmergencyRelated ,
          pc.HomeboundRelatedFlag
FROM dbo.[PatientCaseTEMP] pc 
INNER JOIN dbo.Patient PAT ON 
	PC.PatientID = PAT.VendorID AND
	PAT.PracticeID IN (5,6)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	--28 patient cases created

PRINT ''
PRINT 'Inserting into Doctor ...'
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
          CreatedFromEhr 
         )
SELECT    CASE WHEN doc.PracticeID = 1 THEN 5 WHEN doc.PracticeID = 2 THEN 6 END ,
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
          doc.VendorImportID ,
          doc.FaxNumber ,
          doc.FaxNumberExt ,
          doc.OrigReferringPhysicianID ,
          doc.[External] ,
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
          doc.GlobalPayToCountry ,
          doc.CreatedFromEhr 
FROM dbo.[DoctorTEMP] doc
WHERE doc.DoctorID IN (4,5,7,8)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

	--4 Doctors inserted

UPDATE dbo.Doctor 
	SET VendorID = 2 
	WHERE DoctorID = 195
	
	--1 doctor updated
			
UPDATE dbo.Doctor
	SET VendorID = 6
	WHERE DoctorID = 328	
	
	--1 doctor updated

PRINT ''
PRINT 'Inserted into Encounter ...'	
INSERT INTO dbo.Encounter
        ( PracticeID ,
          PatientID ,
          DoctorID ,
          AppointmentID ,
          LocationID ,
          PatientEmployerID ,
          DateOfService ,
          DateCreated ,
          Notes ,
          EncounterStatusID ,
          AdminNotes ,
          AmountPaid ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicareAssignmentCode ,
          ReleaseOfInformationCode ,
          ReleaseSignatureSourceCode ,
          PlaceOfServiceCode ,
          ConditionNotes ,
          PatientCaseID ,
          InsurancePolicyAuthorizationID ,
          PostingDate ,
          DateOfServiceTo ,
          SupervisingProviderID ,
          ReferringPhysicianID ,
          PaymentMethod ,
          Reference ,
          AddOns ,
          HospitalizationStartDT ,
          HospitalizationEndDT ,
          Box19 ,
          DoNotSendElectronic ,
          SubmittedDate ,
          PaymentTypeID ,
          PaymentDescription ,
          EDIClaimNoteReferenceCode ,
          EDIClaimNote ,
          VendorID ,
          VendorImportID ,
          AppointmentStartDate ,
          BatchID ,
          SchedulingProviderID ,
          DoNotSendElectronicSecondary ,
          PaymentCategoryID ,
          overrideClosingDate ,
          Box10d ,
          ClaimTypeID ,
          OperatingProviderID ,
          OtherProviderID ,
          PrincipalDiagnosisCodeDictionaryID ,
          AdmittingDiagnosisCodeDictionaryID ,
          PrincipalProcedureCodeDictionaryID ,
          DRGCodeID ,
          ProcedureDate ,
          AdmissionTypeID ,
          AdmissionDate ,
          PointOfOriginCodeID ,
          AdmissionHour ,
          DischargeHour ,
          DischargeStatusCodeID ,
          Remarks ,
          SubmitReasonID ,
          DocumentControlNumber ,
          PTAProviderID ,
          SecondaryClaimTypeID ,
          SubmitReasonIDCMS1500 ,
          SubmitReasonIDUB04 ,
          DocumentControlNumberCMS1500 ,
          DocumentControlNumberUB04 ,
          EDIClaimNoteReferenceCodeCMS1500 ,
          EDIClaimNoteReferenceCodeUB04 ,
          EDIClaimNoteCMS1500 ,
          EDIClaimNoteUB04 ,
          PatientCheckedIn ,
          RoomNumber
        )
SELECT    CASE WHEN E.PracticeID= 1 THEN 5 WHEN E.PracticeID = 2 THEN 6 END  ,
          pat.PatientID ,
          doc.DoctorID ,
          E.AppointmentID ,
          CASE WHEN E.LocationID = 1 THEN 113 WHEN E.LocationID = 2 THEN 112 END   ,
          E.PatientEmployerID ,
          E.DateOfService ,
          E.DateCreated ,
          E.Notes , 
          E.EncounterStatusID ,
          E.AdminNotes ,
          E.AmountPaid ,
          E.CreatedDate ,
          E.CreatedUserID ,
          E.ModifiedDate ,
          E.ModifiedUserID ,
          E.MedicareAssignmentCode ,
          E.ReleaseOfInformationCode ,
          E.ReleaseSignatureSourceCode ,
          E.PlaceOfServiceCode ,
          E.ConditionNotes ,
          pc.PatientCaseID ,
          E.InsurancePolicyAuthorizationID ,
          E.PostingDate ,
          E.DateOfServiceTo ,
          E.SupervisingProviderID ,
          refdoc.DoctorID ,
          E.PaymentMethod ,
          E.Reference ,
          E.AddOns ,
          E.HospitalizationStartDT ,
          E.HospitalizationEndDT ,
          E.Box19 ,
          E.DoNotSendElectronic ,
          E.SubmittedDate ,
          E.PaymentTypeID ,
          E.PaymentDescription ,
          E.EDIClaimNoteReferenceCode ,
          E.EDIClaimNote ,
          E.EncounterID ,
          E.VendorImportID ,
          E.AppointmentStartDate ,
          E.BatchID ,
          E.SchedulingProviderID ,
          E.DoNotSendElectronicSecondary ,
          E.PaymentCategoryID ,
          E.overrideClosingDate ,
          E.Box10d ,
          E.ClaimTypeID ,
          E.OperatingProviderID ,
          E.OtherProviderID ,
          E.PrincipalDiagnosisCodeDictionaryID ,
          E.AdmittingDiagnosisCodeDictionaryID ,
          E.PrincipalProcedureCodeDictionaryID ,
          E.DRGCodeID ,
          E.ProcedureDate ,
          E.AdmissionTypeID ,
          E.AdmissionDate ,
          E.PointOfOriginCodeID ,
          E.AdmissionHour ,
          E.DischargeHour ,
          E.DischargeStatusCodeID ,
          E.Remarks ,
          E.SubmitReasonID ,
          E.DocumentControlNumber ,
          E.PTAProviderID ,
          E.SecondaryClaimTypeID ,
          E.SubmitReasonIDCMS1500 ,
          E.SubmitReasonIDUB04 ,
          E.DocumentControlNumberCMS1500 ,
          E.DocumentControlNumberUB04 ,
          E.EDIClaimNoteReferenceCodeCMS1500 ,
          E.EDIClaimNoteReferenceCodeUB04 ,
          E.EDIClaimNoteCMS1500 ,
          E.EDIClaimNoteUB04 ,
          E.PatientCheckedIn ,
          E.RoomNumber
FROM dbo.[EncounterTEMP] E
INNER JOIN dbo.Patient pat ON
	E.patientID = pat.VendorID AND
	pat.PracticeID IN (5, 6)
INNER JOIN dbo.PatientCase pc ON
	E.patientCaseID = pc.VendorID AND
	pc.PracticeID IN (5,6)
INNER JOIN dbo.Doctor doc ON 
	E.DoctorID = doc.VendorID AND
	doc.PracticeID IN (5,6)
LEFT JOIN dbo.Doctor refdoc ON
	E.ReferringPhysicianID = refdoc.VendorID AND	
	refdoc.PracticeID IN (5,6)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

	--28 encounters inserted

PRINT ''
PRINT 'Inserting into EncounterDiagnosis'	
INSERT INTO dbo.EncounterDiagnosis
        ( EncounterID ,
          DiagnosisCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ListSequence ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT 
		  E.EncounterID ,
          ED.DiagnosisCodeDictionaryID ,
          ED.CreatedDate ,
          ED.CreatedUserID ,
          ED.ModifiedDate ,
          ED.ModifiedUserID ,
          ED.ListSequence ,
          CASE WHEN ED.PracticeID = 1 THEN 5 WHEN ED.PracticeID = 2 THEN 6 END  , 
          ED.EncounterDiagnosisID ,
          ED.VendorImportID
FROM dbo.[EncounterDiagnosisTEMP] ED
INNER JOIN dbo.Encounter E ON
	ED.EncounterID = E.VendorID AND 
	E.PracticeID IN (5,6)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

	--28 Encounter Diagnoses created	

PRINT ''	
PRINT 'Inserting into EncounterProcedure ....'
INSERT INTO dbo.EncounterProcedure
        ( EncounterID ,
          ProcedureCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ServiceChargeAmount ,
          ServiceUnitCount ,
          ProcedureModifier1 ,
          ProcedureModifier2 ,
          ProcedureModifier3 ,
          ProcedureModifier4 ,
          ProcedureDateOfService ,
          PracticeID ,
          EncounterDiagnosisID1 ,
          EncounterDiagnosisID2 ,
          EncounterDiagnosisID3 ,
          EncounterDiagnosisID4 ,
          ServiceEndDate ,
          VendorID ,
          VendorImportID ,
          ContractID ,
          Description ,
          EDIServiceNoteReferenceCode ,
          EDIServiceNote ,
          TypeOfServiceCode ,
          AnesthesiaTime ,
          ApplyPayment ,
          PatientResp ,
          AssessmentDate ,
          RevenueCodeID ,
          NonCoveredCharges ,
          DoctorID ,
          StartTime ,
          EndTime ,
          ConcurrentProcedures ,
          StartTimeText ,
          EndTimeText
        )
SELECT    ED.EncounterID ,
          EP.ProcedureCodeDictionaryID ,
          EP.CreatedDate ,
          EP.CreatedUserID ,
          EP.ModifiedDate ,
          EP.ModifiedUserID ,
          EP.ServiceChargeAmount ,
          EP.ServiceUnitCount ,
          EP.ProcedureModifier1 ,
          EP.ProcedureModifier2 ,
          EP.ProcedureModifier3 ,
          EP.ProcedureModifier4 ,
          EP.ProcedureDateOfService ,
          CASE WHEN EP.PracticeID = 1 THEN 5 WHEN EP.PracticeID = 2 THEN 6 END ,
          ED.EncounterDiagnosisID ,
          EP.EncounterDiagnosisID2 ,
          EP.EncounterDiagnosisID3 ,
          EP.EncounterDiagnosisID4 ,
          EP.ServiceEndDate ,
          EP.VendorID ,
          EP.VendorImportID ,
          EP.ContractID ,
          EP.Description ,
          EP.EDIServiceNoteReferenceCode ,
          EP.EDIServiceNote ,
          EP.TypeOfServiceCode ,
          EP.AnesthesiaTime ,
          EP.ApplyPayment ,
          EP.PatientResp ,
          EP.AssessmentDate ,
          EP.RevenueCodeID ,
          EP.NonCoveredCharges ,
          EP.DoctorID ,
          EP.StartTime ,
          EP.EndTime ,
          EP.ConcurrentProcedures ,
          EP.StartTimeText ,
          EP.EndTimeText
FROM dbo.[EncounterProcedureTEMP] EP
INNER JOIN dbo.EncounterDiagnosis ED ON 
	EP.EncounterDiagnosisID1 = ED.VendorID AND
	ED.PracticeID IN (5,6)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	--60 Encounter Procedures Created

PRINT ''
PRINT 'Inserting into InsuranceCompany ...'
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
SELECT    IC.InsuranceCompanyName ,
          IC.Notes ,
          IC.AddressLine1 ,
          IC.AddressLine2 ,
          IC.City ,
          IC.State ,
          IC.Country ,
          IC.ZipCode ,
          IC.ContactPrefix ,
          IC.ContactFirstName ,
          IC.ContactMiddleName ,
          IC.ContactLastName ,
          IC.ContactSuffix ,
          IC.Phone ,
          IC.PhoneExt ,
          IC.Fax ,
          IC.FaxExt ,
          IC.BillSecondaryInsurance ,
          IC.EClaimsAccepts ,
          IC.BillingFormID ,
          IC.InsuranceProgramCode ,
          IC.HCFADiagnosisReferenceFormatCode ,
          IC.HCFASameAsInsuredFormatCode ,
          IC.LocalUseFieldTypeCode ,
          IC.ReviewCode ,
          IC.ProviderNumberTypeID ,
          IC.GroupNumberTypeID ,
          IC.LocalUseProviderNumberTypeID ,
          IC.CompanyTextID ,
          IC.ClearinghousePayerID ,
          CASE WHEN IC.CreatedPracticeID = 1 THEN 5 WHEN IC.CreatedPracticeID = 6 THEN 2 END ,
          IC.CreatedDate ,
          IC.CreatedUserID ,
          GETDATE() ,
          0 ,
          IC.KareoInsuranceCompanyID ,
          IC.KareoLastModifiedDate ,
          IC.SecondaryPrecedenceBillingFormID ,
          IC.InsuranceCompanyID ,
          IC.VendorImportID ,
          IC.DefaultAdjustmentCode ,
          IC.ReferringProviderNumberTypeID ,
          IC.NDCFormat ,
          IC.UseFacilityID ,
          IC.AnesthesiaType ,
          IC.InstitutionalBillingFormID
FROM dbo.[InsuranceCompanyTEMP] IC
WHERE IC.InsuranceCompanyID IN (1, 4, 7)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	
	
PRINT ''
PRINT 'Updating Insurance Company'
UPDATE dbo.InsuranceCompany 
	SET VendorID = 6 
	WHERE InsuranceCompanyID = 5
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	

PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
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
          MM_CompanyID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReviewCode ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          KareoInsuranceCompanyPlanID ,
          KareoLastModifiedDate ,
          InsuranceCompanyID ,
          ADS_CompanyID ,
          Copay ,
          Deductible ,
          VendorID ,
          VendorImportID 
        )
SELECT    ICP.PlanName ,
          ICP.AddressLine1 ,
          ICP.AddressLine2 ,
          ICP.City ,
          ICP.State ,
          ICP.Country ,
          ICP.ZipCode ,
          ICP.ContactPrefix ,
          ICP.ContactFirstName ,
          ICP.ContactMiddleName ,
          ICP.ContactLastName ,
          ICP.ContactSuffix ,
          ICP.Phone ,
          ICP.PhoneExt ,
          ICP.Notes ,
          ICP.MM_CompanyID ,
          ICP.CreatedDate ,
          ICP.CreatedUserID ,
          GETDATE() ,
          0 ,
          ICP.ReviewCode ,
          CASE WHEN ICP.CreatedPracticeID = 1 THEN 5 WHEN ICP.CreatedPRacticeID = 2 THEN 6 END ,
          ICP.Fax ,
          ICP.FaxExt ,
          ICP.KareoInsuranceCompanyPlanID ,
          ICP.KareoLastModifiedDate ,
          IC.InsuranceCompanyID ,
          ICP.ADS_CompanyID ,
          ICP.Copay ,
          ICP.Deductible ,
          ICP.InsuranceCompanyPlanID ,
          ICP.VendorImportID 
FROM dbo.[InsuranceCompanyPlanTEMP] ICP
INNER JOIN dbo.InsuranceCompany IC ON
	ICP.InsuranceCompanyID = IC.VendorID 
WHERE ICP.InsuranceCompanyPlanID IN (1, 2)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	--2 Insurance Company Plans created

PRINT ''
PRINT 'Inserting into Insurance Policy ...'
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
          ReleaseOfInformation ,
          SyncWithEHR 
        )
SELECT    pc.PatientCaseID ,
          ICP.InsuranceCompanyPlanID ,
          IP.Precedence ,
          IP.PolicyNumber ,
          IP.GroupNumber ,
          IP.PolicyStartDate ,
          IP.PolicyEndDate ,
          IP.CardOnFile ,
          IP.PatientRelationshipToInsured ,
          IP.HolderPrefix ,
          IP.HolderFirstName ,
          IP.HolderMiddleName ,
          IP.HolderLastName ,
          IP.HolderSuffix ,
          IP.HolderDOB ,
          IP.HolderSSN ,
          IP.HolderThroughEmployer ,
          IP.HolderEmployerName ,
          IP.PatientInsuranceStatusID ,
          IP.CreatedDate ,
          IP.CreatedUserID ,
          IP.ModifiedDate ,
          IP.ModifiedUserID ,
          IP.HolderGender ,
          IP.HolderAddressLine1 ,
          IP.HolderAddressLine2 ,
          IP.HolderCity ,
          IP.HolderState ,
          IP.HolderCountry ,
          IP.HolderZipCode ,
          IP.HolderPhone ,
          IP.HolderPhoneExt ,
          IP.DependentPolicyNumber ,
          IP.Notes ,
          IP.Phone ,
          IP.PhoneExt ,
          IP.Fax ,
          IP.FaxExt ,
          IP.Copay ,
          IP.Deductible ,
          IP.PatientInsuranceNumber ,
          IP.Active ,
          CASE WHEN IP.PracticeID = 1 THEN 5 WHEN IP.PracticeID = 2 THEN 6 END  ,
          IP.AdjusterPrefix ,
          IP.AdjusterFirstName ,
          IP.AdjusterMiddleName ,
          IP.AdjusterLastName ,
          IP.AdjusterSuffix ,
          IP.InsurancePolicyID ,
          IP.VendorImportID ,
          IP.InsuranceProgramTypeID ,
          IP.GroupName ,
          IP.ReleaseOfInformation ,
          IP.SyncWithEHR
FROM dbo.[InsurancePolicyTEMP] IP
INNER JOIN dbo.PatientCase PC ON
	IP.PatientCaseID = PC.VendorID AND
	PC.PracticeID IN (5,6)
INNER JOIN dbo.InsuranceCompanyPlan ICP ON
	IP.InsuranceCompanyPlanID = ICP.VendorID AND
	ICP.CreatedPracticeID IN (5,6)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	
	
ALTER TABLE dbo.Claim DISABLE TRIGGER [tr_Claim_CreateClaimTransaction]
PRINT ''
PRINT 'Inserting into Claim ...'
INSERT INTO dbo.Claim
        ( PracticeID ,
          ClaimStatusCode ,
          PatientID ,
          ReleaseSignatureSourceCode ,
          EncounterProcedureID ,
          CreatedDate ,
          ModifiedDate ,
          LocalUseData ,
          ReferringProviderIDNumber ,
          NonElectronicOverrideFlag ,
          ClearinghouseTrackingNumber ,
          PayerTrackingNumber ,
          ClearinghouseProcessingStatus ,
          PayerProcessingStatus ,
          ClearinghousePayer ,
          ClearinghousePayerReported ,
          PayerProcessingStatusTypeCode ,
          CurrentPayerProcessingStatusTypeCode ,
          CurrentClearinghouseProcessingStatus ,
          CreatedUserID ,
          ModifiedUserID ,
          DKProcedureDateOfServiceID
        )
SELECT    CASE WHEN C.PracticeID = 1 THEN 5 WHEN C.PracticeID = 2 THEN 6 END ,
          C.ClaimStatusCode ,
          pat.PatientID ,
          C.ReleaseSignatureSourceCode ,
          EPT.EncounterProcedureID ,
          C.CreatedDate ,
          C.ModifiedDate ,
          C.LocalUseData ,
          C.ReferringProviderIDNumber ,
          C.NonElectronicOverrideFlag ,
          C.ClearinghouseTrackingNumber ,
          C.PayerTrackingNumber ,
          C.ClearinghouseProcessingStatus ,
          C.PayerProcessingStatus ,
          C.ClearinghousePayer ,
          C.ClearinghousePayerReported ,
          C.PayerProcessingStatusTypeCode ,
          C.CurrentPayerProcessingStatusTypeCode ,
          C.CurrentClearinghouseProcessingStatus ,
          C.CreatedUserID ,
          C.ModifiedUserID ,
          C.DKProcedureDateOfServiceID
FROM dbo.[ClaimTEMP] C
INNER JOIN dbo.Patient pat ON
	C.PatientID = pat.VendorID
INNER JOIN dbo.[EncounterProcedureTEMP] EPS ON
	C.EncounterProcedureID = EPS.EncounterProcedureID
INNER JOIN dbo.EncounterProcedure EPT ON
	EPS.ProcedureCodeDictionaryID = EPT.ProcedureCodeDictionaryID AND
	EPS.CreatedDate = EPT.CreatedDate AND
	EPS.ServiceChargeAmount = EPS.ServiceChargeAmount
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
ALTER TABLE dbo.Claim ENABLE TRIGGER [tr_Claim_CreateClaimTransaction]
	--60 Claims Created


ALTER TABLE dbo.ClaimTransaction DISABLE TRIGGER [tr_ClaimTransaction_MaintainClaimAccounting_Insert]
ALTER TABLE dbo.ClaimTransaction DISABLE TRIGGER [tr_ClaimTransaction_MaintainClaimAccounting_Update]
PRINT ''
PRINT 'Inserting into ClaimTransaction ...'
INSERT INTO dbo.ClaimTransaction
        ( ClaimTransactionTypeCode ,
          ClaimID ,
          Amount ,
          Quantity ,
          Code ,
          ReferenceID ,
          ReferenceData ,
          Notes ,
          CreatedDate ,
          ModifiedDate ,
          PatientID ,
          PracticeID ,
          BatchKey ,
          Original_ClaimTransactionID ,
          Claim_ProviderID ,
          IsFirstBill ,
          PostingDate ,
          CreatedUserID ,
          ModifiedUserID ,
          PaymentID ,
          AdjustmentGroupID ,
          AdjustmentReasonCode ,
          AdjustmentCode ,
          Reversible ,
          overrideClosingDate ,
          FollowUpDate ,
          ClaimResponseStatusID
        )
SELECT    CT.ClaimTransactionTypeCode ,
          C.ClaimID ,
          CT.Amount ,
          CT.Quantity ,
          CT.Code ,
          CT.ReferenceID ,
          CT.ReferenceData ,
          CT.Notes ,
          CT.CreatedDate ,
          CT.ModifiedDate ,
          PAT.PatientID ,
          CT.PracticeID ,
          CT.BatchKey ,
          CT.Original_ClaimTransactionID ,
          CT.Claim_ProviderID ,
          CT.IsFirstBill ,
          CT.PostingDate ,
          CT.CreatedUserID ,
          0 ,
          CT.PaymentID ,
          CT.AdjustmentGroupID ,
          CT.AdjustmentReasonCode ,
          CT.AdjustmentCode ,
          CT.Reversible ,
          CT.overrideClosingDate ,
          CT.FollowUpDate ,
          CT.ClaimResponseStatusID
FROM dbo.[ClaimTransactionTEMP] CT
INNER JOIN dbo.[ClaimTEMP] CS ON
	CS.ClaimID = CT.ClaimID
INNER JOIN dbo.Patient PAT ON
	CT.PatientID = PAT.VendorID AND 
	PAT.PracticeID IN (5,6)
INNER JOIN dbo.[EncounterProcedureTEMP] EPS ON
	CS.EncounterProcedureID = EPS.EncounterProcedureID
INNER JOIN dbo.EncounterProcedure EPT ON
	EPS.ProcedureCodeDictionaryID = EPT.ProcedureCodeDictionaryID AND
	EPS.CreatedDate = EPT.CreatedDate AND
	EPS.ServiceChargeAmount = EPS.ServiceChargeAmount
INNER JOIN dbo.Claim C ON
	CS.ClearinghouseTrackingNumber = C.ClearinghouseTrackingNumber AND
	CS.PayerTrackingNumber = C.PayerTrackingNumber AND
	CS.CreatedDate = C.CreatedDate AND
	C.PatientID = Pat.PatientID AND
	C.ModifiedDate = CS.ModifiedDate AND
	EPT.EncounterProcedureID = C.EncounterProcedureID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
ALTER TABLE dbo.ClaimTransaction ENABLE TRIGGER [tr_ClaimTransaction_MaintainClaimAccounting_Insert]
ALTER TABLE dbo.ClaimTransaction ENABLE TRIGGER [tr_ClaimTransaction_MaintainClaimAccounting_Update]

--671 Claim Transactions created 

PRINT ''
PRINT 'Inserting into ClaimAccounting ...'
INSERT INTO dbo.ClaimAccounting
        ( PracticeID ,
          ClaimID ,
          ProviderID ,
          PatientID ,
          ClaimTransactionID ,
          ClaimTransactionTypeCode ,
          Status ,
          ProcedureCount ,
          Amount ,
          ARAmount ,
          PostingDate ,
          CreatedUserID ,
          PaymentID ,
          EncounterProcedureID
        )
SELECT    CASE WHEN CA.PracticeID = 1 THEN 5 WHEN CA.PracticeID = 2 THEN 6 END ,
          C.ClaimID ,
          DOC.DoctorID ,
          PAT.PatientID ,
          CT.ClaimTransactionID ,
          CA.ClaimTransactionTypeCode ,
          CA.Status ,
          CA.ProcedureCount ,
          CA.Amount ,
          CA.ARAmount ,
          CA.PostingDate ,
          CA.CreatedUserID ,
          CA.PaymentID ,
          EPT.EncounterProcedureID
FROM dbo.[ClaimAccountingTEMP] CA
INNER JOIN dbo.[ClaimTEMP] CS ON
	CS.ClaimID = CA.ClaimID
LEFT JOIN dbo.Claim C ON
	CS.ClearinghouseTrackingNumber = C.ClearinghouseTrackingNumber AND
	CS.PayerTrackingNumber = C.PayerTrackingNumber AND
	CS.CreatedDate = C.CreatedDate AND
	CS.ModifiedDate = C.ModifiedDate
LEFT JOIN dbo.Doctor DOC ON 
	CA.ProviderID = DOC.VendorID AND
	DOC.PracticeID IN (5,6)
INNER JOIN dbo.Patient PAT ON 
	CA.PatientID = PAT.VendorID AND
	PAT.PracticeID IN (5,6)
INNER JOIN dbo.[ClaimTransactionTEMP] CTS ON
	CA.ClaimTransactionID = CTS.ClaimTransactionID	
INNER JOIN dbo.ClaimTransaction CT ON 
	CAST(CTS.Notes AS VARCHAR) = CAST(CT.Notes AS VARCHAR) AND
	CTS.ClaimTransactionTypeCode = CT.ClaimTransactionTypeCode AND
	CTS.CreatedDate = CT.CreatedDate AND
	CT.ModifiedDate = CTS.ModifiedDate AND 
	C.ClaimID = CT.ClaimID AND
	Pat.PatientID = CT.PatientID
INNER JOIN dbo.[EncounterProcedureTEMP] EPS ON
	CS.EncounterProcedureID = EPS.EncounterProcedureID
INNER JOIN dbo.EncounterProcedure EPT ON
	EPS.ProcedureCodeDictionaryID = EPT.ProcedureCodeDictionaryID AND
	EPS.CreatedDate = EPT.CreatedDate AND
	EPS.ModifiedDate = EPT.ModifiedDate AND
	EPS.ServiceChargeAmount = EPS.ServiceChargeAmount
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--120 ClaimAccounting records inserted

PRINT ''
PRINT 'Inserting into ClaimAccounting_Assignments ...'
INSERT INTO dbo.ClaimAccounting_Assignments
        ( PracticeID ,
          ClaimID ,
          ClaimTransactionID ,
          InsurancePolicyID ,
          InsuranceCompanyPlanID ,
          PatientID ,
          LastAssignment ,
          Status ,
          PostingDate ,
          EndPostingDate ,
          LastAssignmentOfEndPostingDate ,
          EndClaimTransactionID ,
          DKPostingDateID ,
          DKEndPostingDateID ,
          RelativePrecedence
        )
SELECT    CAA.PracticeID ,
          C.ClaimID ,
          CT.ClaimTransactionID ,
          IP.InsurancePolicyID ,
          ICP.InsuranceCompanyPlanID ,
          PAT.PatientID ,
          CAA.LastAssignment ,
          CAA.Status ,
          CAA.PostingDate ,
          CAA.EndPostingDate ,
          CAA.LastAssignmentOfEndPostingDate ,
          CAA.EndClaimTransactionID ,
          CASE WHEN CAA.DKPostingDateID = 4927 THEN 152487 WHEN CAA.DKPostingDateID = 41818 THEN 189378 END ,
          CASE WHEN CAA.DKPostingDateID = 4927 THEN 152487 WHEN CAA.DKPostingDateID = 41818 THEN 189378 END ,
          CAA.RelativePrecedence
FROM dbo.[ClaimAccounting_AssignmentsTEMP] CAA
INNER JOIN dbo.[ClaimTemp] CS ON
	CS.ClaimID = CAA.ClaimID
INNER JOIN dbo.Claim C ON
	CS.ClearinghouseTrackingNumber = C.ClearinghouseTrackingNumber AND
	CS.PayerTrackingNumber = C.PayerTrackingNumber AND
	CS.ModifiedDate = C.ModifiedDate AND
	CS.CreatedDate = C.CreatedDate 
INNER JOIN dbo.Patient PAT ON
	CAA.PatientID = PAT.VendorID AND
	PAT.PracticeID IN (5,6)
INNER JOIN dbo.[ClaimTransactionTEMP] CTS ON
	CAA.ClaimTransactionID = CTS.ClaimTransactionID	
INNER JOIN dbo.ClaimTransaction CT ON 
	CAST(CTS.Notes AS VARCHAR) = CAST(CT.Notes AS VARCHAR) AND
	CTS.ClaimTransactionTypeCode = CT.ClaimTransactionTypeCode AND
	CTS.CreatedDate = CT.CreatedDate AND
	CT.ModifiedDate = CTS.ModifiedDate AND 
	C.ClaimID = CT.ClaimID AND
	Pat.PatientID = CT.PatientID
INNER JOIN dbo.InsurancePolicy IP ON  
	CAA.InsurancePolicyID = IP.VendorID AND
	IP.PracticeID IN (5,6)
INNER JOIN dbo.InsuranceCompanyPlan ICP ON 
	IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID AND
	ICP.CreatedPracticeID IN (5,6)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	--60 ClaimAccounting_Assignments inserted

PRINT ''
PRINT 'Inserting into ClaimAccounting_Billings'
INSERT INTO dbo.ClaimAccounting_Billings
        ( PracticeID ,
          ClaimID ,
          ClaimTransactionID ,
          Status ,
          PostingDate ,
          BatchType ,
          LastBilled ,
          EndPostingDate ,
          LastBilledOfEndPostingDate ,
          EndClaimTransactionID ,
          DKPostingDateID ,
          DKEndPostingDateID ,
          ResponsePostingDate
        )
SELECT    CAB.PracticeID ,
          C.ClaimID ,
          CT.ClaimTransactionID ,
          CAB.Status ,
          CAB.PostingDate ,
          CAB.BatchType ,
          CAB.LastBilled ,
          CAB.EndPostingDate ,
          CAB.LastBilledOfEndPostingDate ,
          CAB.EndClaimTransactionID ,
          CASE WHEN CAB.DKPostingDateID = 4927 THEN 152487
			   WHEN CAB.DKPostingDateID = 4931 THEN 152491
			   WHEN CAB.DKPostingDateID = 4932 THEN 152492
			   WHEN CAB.DKPostingDateID = 41817 THEN 189377
			   WHEN CAB.DKPostingDateID = 41818 THEN 189378 END ,
          CASE WHEN CAB.DKEndPostingDateID = 4931 THEN 152491
               WHEN CAB.DKEndPostingDateID = 4931 THEN 152492 END ,
          CAB.ResponsePostingDate
FROM dbo.[ClaimAccounting_BillingsTEMP] CAB
INNER JOIN dbo.[ClaimTEMP] CS ON
	CS.ClaimID = CAB.ClaimID
INNER JOIN dbo.Claim C ON
	CS.ClearinghouseTrackingNumber = C.ClearinghouseTrackingNumber AND
	CS.PayerTrackingNumber = C.PayerTrackingNumber AND
	CS.ModifiedDate = C.ModifiedDate AND
	CS.CreatedDate = C.CreatedDate 
INNER JOIN dbo.Patient PAT ON
	C.PatientID = PAT.PatientID AND
	PAT.PracticeID IN (5,6)
INNER JOIN dbo.[ClaimTransactionTEMP] CTS ON
	CAB.ClaimTransactionID = CTS.ClaimTransactionID	
INNER JOIN dbo.ClaimTransaction CT ON 
	CAST(CTS.Notes AS VARCHAR) = CAST(CT.Notes AS VARCHAR) AND
	CTS.ClaimTransactionTypeCode = CT.ClaimTransactionTypeCode AND
	CTS.CreatedDate = CT.CreatedDate AND
	CT.ModifiedDate = CTS.ModifiedDate AND 
	C.ClaimID = CT.ClaimID AND
	Pat.PatientID = CT.PatientID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--92 ClaimAccounting_Billings inserted

PRINT ''
PRINT 'Insert into ClaimAccounting_ClaimPeriod ....'
INSERT INTO dbo.ClaimAccounting_ClaimPeriod
        ( ProviderID ,
          PatientID ,
          ClaimID ,
          DKInitialPostingDateID ,
          DKEndPostingDateID
        )
SELECT    DOC.DoctorID ,
          PAT.PatientID ,
          C.ClaimID ,
          CASE WHEN CACP.DKInitialPostingDateID = 4927 THEN 152487
			   WHEN CACP.DKInitialPostingDateID = 41817 THEN 189377
			   WHEN CACP.DKInitialPostingDateID = 41818 THEN 189378  END ,
          CACP.DKEndPostingDateID
FROM dbo.[ClaimAccounting_ClaimPeriodTEMP] CACP
INNER JOIN dbo.Doctor DOC ON	
	CACP.ProviderID = DOC.VendorID AND
	DOC.PracticeID IN (5,6)
INNER JOIN dbo.Patient PAT ON
	CACP.PatientID = PAT.VendorID AND
	PAT.PracticeID IN (5,6)
INNER JOIN dbo.[ClaimTEMP] CS ON
	CS.ClaimID = CACP.ClaimID
INNER JOIN dbo.Claim C ON
	CS.ClearinghouseTrackingNumber = C.ClearinghouseTrackingNumber AND
	CS.PayerTrackingNumber = C.PayerTrackingNumber AND
	CS.ModifiedDate = C.ModifiedDate AND
	CS.CreatedDate = C.CreatedDate 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'





PRINT ''
PRINT 'Insert into ClaimAccounting_Errors ...'
INSERT INTO dbo.ClaimAccounting_Errors
        ( PracticeID ,
          ClaimID ,
          ClaimTransactionTypeCode
        )
SELECT    CASE WHEN CAE.PracticeID = 1 THEN 5 WHEN CAE.PracticeID = 2 THEN 6 END ,
          C.ClaimID ,
          CAE.ClaimTransactionTypeCode
FROM dbo.[ClaimAccounting_ErrorsTEMP] CAE
INNER JOIN dbo.[ClaimTEMP] CS ON
	CS.ClaimID = CAE.ClaimID
INNER JOIN dbo.Claim C ON
	CS.ClearinghouseTrackingNumber = C.ClearinghouseTrackingNumber AND
	CS.PayerTrackingNumber = C.PayerTrackingNumber AND
	CS.ModifiedDate = C.ModifiedDate AND
	CS.CreatedDate = C.CreatedDate 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	--3 ClaimAccounting Errors inserted

PRINT ''
PRINT 'Insert into BillBatch ...'
INSERT INTO dbo.BillBatch
        ( PracticeID ,
          BillBatchTypeCode ,
          CreatedDate ,
          ConfirmedDate ,
          FormatId
        )
SELECT    CASE WHEN BB.PracticeID = 1 THEN 5 WHEN BB.PracticeID = 2 THEN 6 END ,
          BB.BillBatchTypeCode ,
          BB.CreatedDate ,
          BB.ConfirmedDate ,
          BB.FormatId
FROM dbo.[BillBatchTEMP] BB
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	--12 BillBatch inserted

PRINT ''
PRINT 'Insert into Bill_EDI ...'
INSERT INTO dbo.Bill_EDI
        ( BillBatchID ,
          RepresentativeClaimID ,
          PayerResponsibilityCode ,
          PayerInsurancePolicyID ,
          OtherPayerInsurancePolicyID ,
          BillStateCode ,
          BillStateModifiedDate
        )
SELECT    BB.BillBatchID ,
          C.ClaimID ,
          BE.PayerResponsibilityCode ,
          IP.InsurancePolicyID ,
          BE.OtherPayerInsurancePolicyID ,
          BE.BillStateCode ,
          BE.BillStateModifiedDate
FROM dbo.[Bill_EDITEMP] BE        
INNER JOIN dbo.[BillBatchTEMP] BBS  ON
	BE.BillBatchID = BBS.BillBatchID
INNER JOIN dbo.[BillBatch] BB ON
	BBS.BillBatchTypeCode = BB.BillBatchTypeCode AND
	BBS.CreatedDate = BB.CreatedDate AND
	BBS.ConfirmedDate = BB.ConfirmedDate
INNER JOIN dbo.[ClaimTEMP] CS ON
	BE.RepresentativeClaimID = CS.ClaimID
INNER JOIN dbo.Claim C ON
	CS.ClearinghouseTrackingNumber = C.ClearinghouseTrackingNumber AND
	CS.PayerTrackingNumber = C.PayerTrackingNumber AND
	CS.ModifiedDate = C.ModifiedDate AND
	CS.CreatedDate = C.CreatedDate 
INNER JOIN dbo.[InsurancePolicy] IP ON
	BE.PayerInsurancePolicyID = IP.VendorID AND
	IP.PracticeID IN (5,6)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

  --44 Bill_EDI inserted

PRINT ''
PRINT 'Insert into BillTransmission ...'
INSERT INTO dbo.BillTransmission
        ( BillTransmissionFileTypeCode ,
          TransmissionDate ,
          DestinationAddress ,
          FileName ,
          FileContents ,
          ReferenceID ,
          PracticeID ,
          PatientID ,
          ClaimID ,
          FileDataFormatVersion ,
          FileData ,
          ClaimPcn ,
          ClaimPcnSV ,
          ParsedPayerNumber
        )
SELECT    BT.BillTransmissionFileTypeCode ,
          BT.TransmissionDate ,
          BT.DestinationAddress ,
          BT.FileName ,
          BT.FileContents ,
          BT.ReferenceID ,
          CASE WHEN BT.PracticeID = 1 THEN 5 WHEN BT.PracticeID = 2 THEN 6 END ,
          PAT.PatientID ,
          C.ClaimID ,
          BT.FileDataFormatVersion ,
          BT.FileData ,
          BT.ClaimPcn ,
          BT.ClaimPcnSV ,
          BT.ParsedPayerNumber
FROM dbo.[BillTransmissionTEMP] BT
LEFT JOIN dbo.[ClaimTEMP] CS ON
	CS.ClaimID = BT.ClaimID
LEFT JOIN dbo.Claim C ON
	CS.ClearinghouseTrackingNumber = C.ClearinghouseTrackingNumber AND
	CS.PayerTrackingNumber = C.PayerTrackingNumber AND
	CS.ModifiedDate = C.ModifiedDate AND
	CS.CreatedDate = C.CreatedDate 
LEFT JOIN dbo.Patient PAT ON
	BT.PatientID = PAT.VendorID AND
	PAT.PracticeID IN (5,6)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

	--104 BillTransmission inserted

PRINT ''
PRINT 'Insert into BillClaim ...'
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
SELECT	  BE.BillID ,  
          BC.BillBatchTypeCode ,
          C.ClaimID ,  
          BC.ClaimTransactionID ,
          BC.isCopay  
FROM dbo.[BillClaimTEMP] BC
INNER JOIN dbo.[Bill_EDITEMP] BET ON
	BC.BillID = BET.BillID
INNER JOIN dbo.[InsurancePolicy] IP ON 
	BET.PayerInsurancePolicyID = IP.VendorID
INNER JOIN dbo.[ClaimTEMP] CS ON
	CS.ClaimID = BC.ClaimID
INNER JOIN dbo.Claim C ON
	CS.ClearinghouseTrackingNumber = C.ClearinghouseTrackingNumber AND
	CS.PayerTrackingNumber = C.PayerTrackingNumber AND
	CS.ModifiedDate = C.ModifiedDate AND
	CS.CreatedDate = C.CreatedDate 
INNER JOIN dbo.[Bill_EDI] BE ON
	BET.BillStateModifiedDate = BE.BillStateModifiedDate AND
	IP.InsurancePolicyID = BE.PayerInsurancePolicyID AND
	C.ClaimID = BE.RepresentativeClaimID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into ClearinghouseResponse ...'
INSERT INTO dbo.ClearinghouseResponse
        ( ResponseType ,
          PracticeID ,
          SourceAddress ,
          FileName ,
          FileReceiveDate ,
          FileContents ,
          ReviewedFlag ,
          ProcessedFlag ,
          Title ,
          PaymentID ,
          ClearinghouseResponseReportTypeID ,
          ClearinghouseResponseSourceTypeID ,
          SourceName ,
          Notes ,
          TotalAmount ,
          ItemCount ,
          Rejected ,
          Denied ,
          CheckList
        )
SELECT    CR.ResponseType ,
          CASE WHEN CR.PracticeID = 1 THEN 5 WHEN CR.PracticeID = 2 THEN 6 END ,
          CR.SourceAddress ,
          CR.FileName ,
          CR.FileReceiveDate ,
          CR.FileContents ,
          CR.ReviewedFlag ,
          CR.ProcessedFlag ,
          CR.Title ,
          CR.PaymentID ,
          CR.ClearinghouseResponseReportTypeID ,
          CR.ClearinghouseResponseSourceTypeID ,
          CR.SourceName ,
          CR.Notes ,
          CR.TotalAmount ,
          CR.ItemCount ,
          CR.Rejected ,
          CR.Denied ,
          CR.CheckList
FROM dbo.[ClearinghouseResponseTEMP] CR
PRINT CAST(@@rowcount AS VARCHAR) + ' records inserted'

	
	
	--NEED TO LOOK AT THE CLAIMIDS BEFORE YOU RUN THIS IN PROD IT WILL NOT MATCH WHAT THESE ARE!!!!!!!
	INSERT INTO dbo.BillClaim
	        ( BillID ,
	          BillBatchTypeCode ,
	          ClaimID ,
	          ClaimTransactionID ,
	          isCopay
	        )
	VALUES  ( 80500 , -- BillID - int
	          'E' , -- BillBatchTypeCode - char(1)
	          111371 , -- ClaimID - int
	          0 , -- ClaimTransactionID - int
	          0  -- isCopay - bit
	        )
	INSERT INTO dbo.BillClaim
	        ( BillID ,
	          BillBatchTypeCode ,
	          ClaimID ,
	          ClaimTransactionID ,
	          isCopay
	        )
	VALUES  ( 80494 , -- BillID - int
	          'E' , -- BillBatchTypeCode - char(1)
	          111359 , -- ClaimID - int
	          0 , -- ClaimTransactionID - int
	          0  -- isCopay - bit
	        )
	INSERT INTO dbo.BillClaim
	        ( BillID ,
	          BillBatchTypeCode ,
	          ClaimID ,
	          ClaimTransactionID ,
	          isCopay
	        )
	VALUES  ( 80496 , -- BillID - int
	          'E' , -- BillBatchTypeCode - char(1)
	          111373 , -- ClaimID - int
	          0 , -- ClaimTransactionID - int
	          0  -- isCopay - bit
	        )
	INSERT INTO dbo.BillClaim
	        ( BillID ,
	          BillBatchTypeCode ,
	          ClaimID ,
	          ClaimTransactionID ,
	          isCopay
	        )
	VALUES  ( 80492 , -- BillID - int
	          'E' , -- BillBatchTypeCode - char(1)
	          111367 , -- ClaimID - int
	          0 , -- ClaimTransactionID - int
	          0  -- isCopay - bit
	        )
	INSERT INTO dbo.BillClaim
	        ( BillID ,
	          BillBatchTypeCode ,
	          ClaimID ,
	          ClaimTransactionID ,
	          isCopay
	        )
	VALUES  ( 80490 , -- BillID - int
	          'E' , -- BillBatchTypeCode - char(1)
	          111365 , -- ClaimID - int
	          0 , -- ClaimTransactionID - int
	          0  -- isCopay - bit
	        )
	INSERT INTO dbo.BillClaim
	        ( BillID ,
	          BillBatchTypeCode ,
	          ClaimID ,
	          ClaimTransactionID ,
	          isCopay
	        )
	VALUES  ( 80488 , -- BillID - int
	          'E' , -- BillBatchTypeCode - char(1)
	          111349 , -- ClaimID - int
	          0 , -- ClaimTransactionID - int
	          0  -- isCopay - bit
	        )
	INSERT INTO dbo.BillClaim
	        ( BillID ,
	          BillBatchTypeCode ,
	          ClaimID ,
	          ClaimTransactionID ,
	          isCopay
	        )
	VALUES  ( 80486 , -- BillID - int
	          'E' , -- BillBatchTypeCode - char(1)
	          111347 , -- ClaimID - int
	          0 , -- ClaimTransactionID - int
	          0  -- isCopay - bit
	        )
	INSERT INTO dbo.BillClaim
	        ( BillID ,
	          BillBatchTypeCode ,
	          ClaimID ,
	          ClaimTransactionID ,
	          isCopay
	        )
	VALUES  ( 80484 , -- BillID - int
	          'E' , -- BillBatchTypeCode - char(1)
	          111345 , -- ClaimID - int
	          0 , -- ClaimTransactionID - int
	          0  -- isCopay - bit
	        )	
	INSERT INTO dbo.BillClaim
	        ( BillID ,
	          BillBatchTypeCode ,
	          ClaimID ,
	          ClaimTransactionID ,
	          isCopay
	        )
	VALUES  ( 80482 , -- BillID - int
	          'E' , -- BillBatchTypeCode - char(1)
	          111357 , -- ClaimID - int
	          0 , -- ClaimTransactionID - int
	          0  -- isCopay - bit
	        )	
	INSERT INTO dbo.BillClaim
	        ( BillID ,
	          BillBatchTypeCode ,
	          ClaimID ,
	          ClaimTransactionID ,
	          isCopay
	        )
	VALUES  ( 80480 , -- BillID - int
	          'E' , -- BillBatchTypeCode - char(1)
	          111351 , -- ClaimID - int
	          0 , -- ClaimTransactionID - int
	          0  -- isCopay - bit
	        )	
	INSERT INTO dbo.BillClaim
	        ( BillID ,
	          BillBatchTypeCode ,
	          ClaimID ,
	          ClaimTransactionID ,
	          isCopay
	        )
	VALUES  ( 80478 , -- BillID - int
	          'E' , -- BillBatchTypeCode - char(1)
	          111369 , -- ClaimID - int
	          0 , -- ClaimTransactionID - int
	          0  -- isCopay - bit
	        )

INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80476 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111361 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80474 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111363 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80472 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111353 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80470 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111355 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80498 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111343 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
		)
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80513 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111375 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80511 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111378 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80510 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111380 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80509 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111382 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80509 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111383 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80508 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111385 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80506 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111390 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80506 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111391 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80505 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111393 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80505 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111394 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80504 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111396 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
		)
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80503 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111398 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80507 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111387 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
		)          
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80507 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111388, -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80502 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111400 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80502 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111401 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80501 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111371 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80495 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111359 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80497 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111373 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80493 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111367 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80491 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111365 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80489 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111349 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80487 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111347 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80485 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111345 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80483 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111357 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80481 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111351 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80479 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111369 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80477 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111361 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80475 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111363 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80473 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111353 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80471 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111355 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )
INSERT INTO dbo.BillClaim
        ( BillID ,
          BillBatchTypeCode ,
          ClaimID ,
          ClaimTransactionID ,
          isCopay
        )
VALUES  ( 80499 , -- BillID - int
          'E' , -- BillBatchTypeCode - char(1)
          111343 , -- ClaimID - int
          0 , -- ClaimTransactionID - int
          0  -- isCopay - bit
        )