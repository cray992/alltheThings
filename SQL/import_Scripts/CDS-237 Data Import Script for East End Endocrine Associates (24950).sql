USE superbill_30332_dev
--USE superbill_30332_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 2
SET @PracticeID = 1


PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Inserting Into Insurance Company...'
SET IDENTITY_INSERT dbo.InsuranceCompany ON
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyID ,
		  InsuranceCompanyName ,
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
          CompanyTextID ,
          ClearinghousePayerID ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
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
SELECT DISTINCT
		  i.insurancecompanyid ,
	      i.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
          i.notes , -- Notes - text
          i.addressline1 , -- AddressLine1 - varchar(256)
          i.addressline2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.state , -- State - varchar(2)
          i.country , -- Country - varchar(32)
          i.zipcode , -- ZipCode - varchar(9)
          i.contactprefix , -- ContactPrefix - varchar(16)
          i.contactfirstname , -- ContactFirstName - varchar(64)
          i.contactmiddlename , -- ContactMiddleName - varchar(64)
          i.contactlastname , -- ContactLastName - varchar(64)
          i.contactsuffix , -- ContactSuffix - varchar(16)
          i.phone , -- Phone - varchar(10)
          i.phoneext , -- PhoneExt - varchar(10)
          i.fax , -- Fax - varchar(10)
          i.faxext , -- FaxExt - varchar(10)
          CASE i.billsecondaryinsurance WHEN -1 THEN 1 ELSE i.billsecondaryinsurance END , -- BillSecondaryInsurance - bit
          CASE i.eclaimsaccepts WHEN -1 THEN 1 ELSE i.eclaimsaccepts END, -- EClaimsAccepts - bit
          i.billingformid , -- BillingFormID - int
          i.insuranceprogramcode , -- InsuranceProgramCode - char(2)
          i.hcfadiagnosisreferenceformatcode , -- HCFADiagnosisReferenceFormatCode - char(1)
          CASE WHEN i.hcfadiagnosisreferenceformatcode = '' THEN NULL ELSE i.hcfasameasinsuredformatcode END , -- HCFASameAsInsuredFormatCode - char(1)
          i.localusefieldtypecode , -- LocalUseFieldTypeCode - char(5)
          i.reviewcode , -- ReviewCode - char(1)
          i.companytextid , -- CompanyTextID - varchar(10)
          i.clearinghousepayerid , -- ClearinghousePayerID - int
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          i.secondaryprecedencebillingformid , -- SecondaryPrecedenceBillingFormID - int
          i.insurancecompanyid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          a.AdjustmentCode , -- DefaultAdjustmentCode - varchar(10)
          i.referringprovidernumbertypeid , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          i.anesthesiatype , -- AnesthesiaType - varchar(1)
          i.institutionalbillingformid  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_InsuranceCompany] i
	LEFT JOIN dbo.Adjustment a ON i.defaultadjustmentcode = a.AdjustmentCode
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
SET IDENTITY_INSERT dbo.InsuranceCompany OFF


PRINT ''
PRINT 'Inserting Into PracticetoInsurance Company...'
INSERT INTO dbo.PracticeToInsuranceCompany
        ( 
		  PracticeID ,
          InsuranceCompanyID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EClaimsProviderID ,
          EClaimsEnrollmentStatusID ,
          EClaimsDisable ,
          AcceptAssignment ,
          UseSecondaryElectronicBilling ,
          UseCoordinationOfBenefits ,
          ExcludePatientPayment ,
          BalanceTransfer
        )
SELECT   
          @PracticeID , -- PracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          ptic.EClaimsProviderID , -- EClaimsProviderID - varchar(32)
          ptic.EClaimsProviderID , -- EClaimsEnrollmentStatusID - int
          ptic.EClaimsDisable , -- EClaimsDisable - int
          CASE WHEN ptic.AcceptAssignment = -1 THEN 1 ELSE ptic.acceptassignment END , -- AcceptAssignment - bit
          CASE WHEN ptic.usesecondaryelectronicbilling = -1 THEN 1 ELSE ptic.usesecondaryelectronicbilling END, -- UseSecondaryElectronicBilling - bit
          CASE WHEN ptic.UseCoordinationOfBenefits = -1 THEN 1 ELSE ptic.usecoordinationofbenefits END , -- UseCoordinationOfBenefits - bit
          CASE WHEN ptic.ExcludePatientPayment = -1 THEN 1 ELSE ptic.excludepatientpayment END , -- ExcludePatientPayment - bit
          CASE WHEN ptic.BalanceTransfer = -1 THEN 1 ELSE ptic.balancetransfer END -- BalanceTransfer - bit
FROM dbo.[_import_2_1_PracticeToInsuranceCompany] ptic
	INNER JOIN dbo.InsuranceCompany ic ON
		ic.InsuranceCompanyID = ptic.insurancecompanyid AND
		ic.VendorImportID = @VendorImportID
WHERE ptic.practiceid = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
SET IDENTITY_INSERT dbo.InsuranceCompanyPlan ON
INSERT INTO dbo.InsuranceCompanyPlan
        ( InsuranceCompanyPlanID ,
		  PlanName ,
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
          ReviewCode ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          KareoInsuranceCompanyPlanID ,
          KareoLastModifiedDate ,
          InsuranceCompanyID ,
          Copay ,
          Deductible ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
          i.InsuranceCompanyPlanID ,
		  i.PlanName ,
          i.AddressLine1 ,
          i.AddressLine2 ,
          i.City ,
          i.State ,
          i.Country ,
          i.ZipCode ,
          i.ContactPrefix ,
          i.ContactFirstName ,
          i.ContactMiddleName ,
          i.ContactLastName ,
          i.ContactSuffix ,
          i.Phone ,
          i.PhoneExt ,
          i.Notes ,
          GETDATE() ,
          -50 ,
          GETDATE() ,
          -50 ,
          i.ReviewCode ,
          i.CreatedPracticeID ,
          i.Fax ,
          i.FaxExt ,
          i.KareoInsuranceCompanyPlanID ,
          CASE WHEN ISDATE(i.KareoLastModifiedDate) = 1 THEN i.kareolastmodifieddate ELSE NULL END ,
          i.InsuranceCompanyID ,
          i.Copay ,
          i.Deductible ,
          i.InsuranceCompanyPlanID ,
          @VendorImportID 
FROM dbo.[_import_2_1_InsuranceCompanyPlan] i
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
SET IDENTITY_INSERT dbo.InsuranceCompanyPlan OFF


SET IDENTITY_INSERT dbo.Doctor ON
PRINT ''
PRINT 'Inserting into Doctor'
INSERT INTO dbo.Doctor
        ( DoctorID ,
		  PracticeID ,
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
          TaxonomyCode ,
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
SELECT    DoctorID ,
		  @PracticeID ,
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
          CASE WHEN ISDATE(DOB) = 1 THEN dob ELSE NULL END ,
          EmailAddress ,
          Notes ,
          CASE WHEN ActiveDoctor = -1 THEN 1 ELSE activedoctor END ,
          GETDATE() ,
          -50 ,
          GETDATE() ,
          -50 ,
          UserID ,
          Degree ,
          CASE WHEN TaxonomyCode =  '' THEN NULL ELSE taxonomycode END ,
          DoctorID ,
          @VendorImportID ,
          FaxNumber ,
          FaxNumberExt ,
          OrigReferringPhysicianID ,
          CASE WHEN [External] = -1 THEN 1 ELSE [external] END ,
          NPI ,
          ProviderTypeID ,
          CASE WHEN providerperformancereportactive = -1 THEN 1 ELSE providerperformancereportactive END ,
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
          CASE WHEN createdfromehr = -1 THEN 1 ELSE createdfromehr END ,
          CASE WHEN activateafterwizard = 1 THEN 1 ELSE activateafterwizard END
FROM dbo.[_import_2_1_Doctor] WHERE [external] = -1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.Doctor OFF


SET IDENTITY_INSERT dbo.ServiceLocation ON
PRINT''
PRINT 'Inserting into ServiceLocation'
INSERT INTO dbo.ServiceLocation
        ( ServiceLocationID ,
		  PracticeID ,
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
          HCFABox32FacilityID ,
          CLIANumber ,
          RevenueCode ,
          VendorImportID ,
          VendorID ,
          NPI ,
          FacilityIDType ,
          TimeZoneID ,
          PayToName ,
          PayToAddressLine1 ,
          PayToAddressLine2 ,
          PayToCity ,
          PayToState ,
          PayToCountry ,
          PayToZipCode ,
          PayToPhone ,
          PayToPhoneExt ,
          PayToFax ,
          PayToFaxExt ,
          EIN ,
          BillTypeID 
        )
SELECT    ServiceLocationID ,
		  @PracticeID ,
          Name ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          GETDATE() ,
          -50 ,
          GETDATE() ,
          -50 ,
          PlaceOfServiceCode ,
          BillingName ,
          Phone ,
          PhoneExt ,
          FaxPhone ,
          FaxPhoneExt ,
          HCFABox32FacilityID ,
          CLIANumber ,
          RevenueCode ,
          @VendorImportID ,
          ServiceLocationID ,
          NPI ,
          FacilityIDType ,
          TimeZoneID ,
          PayToName ,
          PayToAddressLine1 ,
          PayToAddressLine2 ,
          PayToCity ,
          PayToState ,
          PayToCountry ,
          PayToZipCode ,
          PayToPhone ,
          PayToPhoneExt ,
          PayToFax ,
          PayToFaxExt ,
          EIN ,
          CASE WHEN BillTypeID = '' THEN NULL ELSE billtypeid END
FROM dbo.[_import_2_1_ServiceLocations] 		
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'		
SET IDENTITY_INSERT dbo.ServiceLocation OFF


SET IDENTITY_INSERT dbo.Patient ON
PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PatientID ,
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
          --InsuranceProgramCode ,
          --PatientReferralSourceID ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
         -- EmployerID ,
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
SELECT DISTINCT
		  p.patientid ,
		  @PracticeID , -- PracticeID - int
          CASE WHEN p.referringphysicianid = '' THEN NULL ELSE p.referringphysicianid END, -- ReferringPhysicianID - int
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
          CASE WHEN p.ResponsibleDifferentThanPatient = -1 THEN 1 ELSE p.responsibledifferentthanpatient END, -- ResponsibleDifferentThanPatient - bit
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
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          p.EmploymentStatus , -- EmploymentStatus - char(1)
          --p.InsuranceProgramCode , -- InsuranceProgramCode - char(2)
         -- p.PatientReferralSourceID , -- PatientReferralSourceID - int
          CASE WHEN p.primaryproviderid = '' THEN NULL ELSE primaryproviderid END , -- PrimaryProviderID - int
          CASE WHEN p.DefaultServiceLocationID = '' THEN NULL ELSE p.defaultservicelocationid END , -- DefaultServiceLocationID - int
         -- p.EmployerID , -- EmployerID - int
          p.MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
          p.MobilePhone , -- MobilePhone - varchar(10)
          p.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
          CASE WHEN p.primarycarephysicianid = '' THEN NULL ELSE p.primarycarephysicianid END, -- PrimaryCarePhysicianID - int
          p.PatientID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          p.CollectionCategoryID , -- CollectionCategoryID - int
          CASE WHEN p.Active = -1 THEN 1 ELSE p.active END , -- Active - bit
          CASE WHEN p.SendEmailCorrespondence = -1 THEN 1 ELSE p.sendemailcorrespondence END , -- SendEmailCorrespondence - bit
          CASE WHEN p.PhonecallRemindersEnabled = -1 THEN 1 ELSE p.phonecallremindersenabled END, -- PhonecallRemindersEnabled - bit
          p.EmergencyName , -- EmergencyName - varchar(128)
          p.EmergencyPhone , -- EmergencyPhone - varchar(10)
          p.EmergencyPhoneExt  -- EmergencyPhoneExt - varchar(10)
FROM dbo.[_import_2_1_PatientDemo] p 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.Patient OFF


SET IDENTITY_INSERT dbo.PatientCase ON
PRINT''
PRINT'Inserting into PatientCase ...'
INSERT INTO dbo.PatientCase
        ( PatientCaseID ,
		  PatientID ,
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
          --WorkersCompContactInfoID ,
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
SELECT    pc.patientcaseid ,
		  pc.PatientID ,
          pc.Name ,
          CASE WHEN pc.Active = -1 THEN 1 ELSE pc.active END ,
          CASE WHEN ps.PayerScenarioID IS NULL THEN 5 ELSE ps.PayerScenarioID END ,
          CASE pc.ReferringPhysicianID WHEN '' THEN NULL
									   WHEN 39883 THEN 4
									   WHEN 30 THEN 2
									   WHEN 37616 THEN 3
									   WHEN 37629 THEN 5
									   WHEN 39883 THEN 4 ELSE pc.referringphysicianid END ,
          CASE WHEN pc.EmploymentRelatedFlag = -1 THEN 1 ELSE pc.EmploymentRelatedFlag END ,
          CASE WHEN pc.AutoAccidentRelatedFlag = -1 THEN 1 ELSE pc.autoaccidentrelatedflag END,
          CASE WHEN pc.OtherAccidentRelatedFlag = -1 THEN 1 ELSE pc.otheraccidentrelatedflag END ,
          CASE WHEN pc.AbuseRelatedFlag = -1 THEN 1 ELSE pc.abuserelatedflag END,
          CASE WHEN pc.AutoAccidentRelatedState = -1 THEN 1 ELSE pc.autoaccidentrelatedflag END,
          pc.Notes ,
          CASE WHEN pc.ShowExpiredInsurancePolicies = -1 THEN 1 ELSE pc.showexpiredinsurancepolicies END,
          GETDATE() ,
          -50 ,
          GETDATE() ,
          -50 ,
          @PracticeID ,
          pc.CaseNumber ,
          --pc.WorkersCompContactInfoID ,
          pc.PatientCaseID ,
          @VendorImportID ,
          CASE WHEN pc.PregnancyRelatedFlag = -1 THEN 1 ELSE pc.PregnancyRelatedFlag END,
          CASE WHEN pc.StatementActive = -1 THEN 1 ELSE pc.statementactive END ,
          CASE WHEN pc.EPSDT = -1 THEN 1 ELSE pc.epsdt END ,
          CASE WHEN pc.FamilyPlanning = -1 THEN 1 ELSE pc.familyplanning END ,
          CASE WHEN pc.EPSDTCodeID = '' THEN NULL ELSE pc.epsdtcodeid END ,
          CASE WHEN pc.EmergencyRelated = -1 THEN 1 ELSE pc.emergencyrelated END,
          CASE WHEN pc.HomeboundRelatedFlag = -1 THEN 1 ELSE pc.homeboundrelatedflag END
FROM dbo.[_import_2_1_PatientCase] pc
LEFT JOIN dbo.PayerScenario ps ON
	pc.payerscenarioid = ps.PayerScenarioID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.PatientCase OFF


SET IDENTITY_INSERT dbo.PatientCaseDate ON
PRINT ''
PRINT 'Inserting Into Patient Case Date...'
INSERT INTO dbo.PatientCaseDate
        ( PatientCaseDateID ,
		  PracticeID ,
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
	      pcd.patientcasedateid ,
		  @PracticeID , -- PracticeID - int
          pcd.PatientCaseID , -- PatientCaseID - int
          pcd.PatientCaseDateTypeID , -- PatientCaseDateTypeID - int
          pcd.StartDate , -- StartDate - datetime
          pcd.EndDate , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          -50, -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.[_import_2_1_PatientCaseDate] pcd
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.PatientCaseDate OFF


--SET IDENTITY_INSERT dbo.PatientAlert ON
--PRINT ''
--PRINT 'Inserting into PatientAlert ...'
--INSERT INTO dbo.PatientAlert
--        ( PatientAlertID ,
--		  PatientID ,
--          AlertMessage ,
--          ShowInPatientFlag ,
--          ShowInAppointmentFlag ,
--          ShowInEncounterFlag ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          ShowInClaimFlag ,
--          ShowInPaymentFlag ,
--          ShowInPatientStatementFlag
--        )
--SELECT    pa.patientalertid ,
--          pa.PatientID , -- PatientID - int
--          pa.AlertMessage , -- AlertMessage - text
--          CASE WHEN pa.ShowInPatientFlag = -1 THEN 1 ELSE pa.showinpatientflag END, -- ShowInPatientFlag - bit
--          CASE WHEN pa.ShowInAppointmentFlag = -1 THEN 1 ELSE pa.showinappointmentflag END , -- ShowInAppointmentFlag - bit
--          CASE WHEN pa.ShowInEncounterFlag = -1 THEN 1 ELSE pa.showinencounterflag END , -- ShowInEncounterFlag - bit
--          GETDATE() , -- CreatedDate - datetime
--		  -50 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          -50 , -- ModifiedUserID - int
--          CASE WHEN pa.ShowInClaimFlag = -1 THEN 1 ELSE pa.showinclaimflag END, -- ShowInClaimFlag - bit
--          CASE WHEN pa.ShowInPaymentFlag = -1 THEN 1 ELSE pa.showinpaymentflag END, -- ShowInPaymentFlag - bit
--          CASE WHEN pa.ShowInPatientStatementFlag = 1 THEN 1 ELSE pa.showinpatientstatementflag END -- ShowInPatientStatementFlag - bit
--FROM dbo.[_import_2_1_PatientAlert] pa
--PRINT CAST(@@Rowcount AS VARCHAR) + ' records inserted'	
--SET IDENTITY_INSERT dbo.PatientAlert OFF	


--SET IDENTITY_INSERT dbo.PatientJournalNote ON
--PRINT''
--PRINT'Inserting into PatientJournalNotes ...'
--INSERT INTO dbo.PatientJournalNote
--        ( PatientJournalNoteID ,
--		  CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          PatientID ,
--          UserName ,
--          SoftwareApplicationID ,
--          Hidden ,
--          NoteMessage ,
--          AccountStatus ,
--          NoteTypeCode ,
--          LastNote
--        )
--SELECT	  pjn.patientjournalnoteid ,
--		  pjn.CreatedDate ,
--          -50 ,
--          GETDATE() ,
--          -50 ,
--          pjn.PatientID ,
--          pjn.UserName ,
--          pjn.SoftwareApplicationID ,
--          CASE WHEN pjn.Hidden = -1 THEN 1 ELSE pjn.hidden END ,
--          pjn.NoteMessage ,
--          pjn.AccountStatus ,
--          pjn.NoteTypeCode ,
--          CASE WHEN pjn.LastNote = -1 THEN 1 ELSE pjn.lastnote END
--FROM dbo.[_import_2_1_PatientJournalNote] pjn
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--SET IDENTITY_INSERT dbo.PatientJournalNote OFF	


SET IDENTITY_INSERT dbo.InsurancePolicy ON	
PRINT ''
PRINT 'Inserting into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy
        ( InsurancePolicyID ,
		  PatientCaseID ,
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
SELECT    ip.insurancepolicyid ,
          ip.PatientCaseID ,
          ip.InsuranceCompanyPlanID ,
          ip.Precedence ,
          ip.PolicyNumber ,
          ip.GroupNumber ,
          CASE WHEN ISDATE(ip.PolicyStartDate) = 1 THEN ip.policystartdate ELSE NULL END ,
          CASE WHEN ISDATE(ip.PolicyEndDate) = 1 THEN ip.policyenddate ELSE NULL END ,
          ip.CardOnFile ,
          CASE ip.PatientRelationshipToInsured WHEN '0' THEN 'O' ELSE ip.patientrelationshiptoinsured END,
          ip.HolderPrefix ,
          ip.HolderFirstName ,
          ip.HolderMiddleName ,
          ip.HolderLastName ,
          ip.HolderSuffix ,
          ip.HolderDOB ,
          ip.HolderSSN ,
          CASE WHEN ip.HolderThroughEmployer = -1 THEN 1 ELSE ip.holderthroughemployer END ,
          ip.HolderEmployerName ,
          GETDATE() ,
          -50 ,
          GETDATE() ,
          -50 ,
          CASE ip.HolderGender WHEN '0x0000000001D356A9' THEN 'U' 
							   WHEN '' THEN 'U' ELSE ip.holdergender END ,
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
          CASE WHEN ip.Active = -1 THEN 1 ELSE ip.active END ,
          @PracticeID ,
          ip.AdjusterPrefix ,
          ip.AdjusterFirstName ,
          ip.AdjusterMiddleName ,
          ip.AdjusterLastName ,
          ip.AdjusterSuffix ,
          ip.InsurancePolicyID ,
          @VendorImportID ,
          CASE WHEN ip.InsuranceProgramTypeID = '' THEN NULL ELSE ip.insuranceprogramtypeid END ,
          LEFT(ip.GroupName , 14) ,
          CASE ip.releaseofinformation WHEN 'Y' THEN 'Y' ELSE 'I' END
FROM dbo.[_import_3_1_InsurancePolicy] ip
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.InsurancePolicy OFF


SET IDENTITY_INSERT dbo.Appointment ON
PRINT ''
PRINT 'Inserting into Appointment ...'
INSERT INTO dbo.Appointment
        ( AppointmentID ,
		  PatientID ,
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
          EndTm 
        )
SELECT    app.appointmentid ,
		  CASE WHEN app.PatientID = '' THEN NULL ELSE app.patientid END ,
          @PracticeID ,
          app.ServiceLocationID ,
          app.StartDate ,
          app.EndDate ,
          app.AppointmentType ,
          app.[subject] ,
          app.Notes ,
          GETDATE() ,
          -50 ,
          GETDATE() ,
          -50 ,
          app.AppointmentResourceTypeID ,
          app.AppointmentConfirmationStatusCode ,
          app.AllDay ,
          app.InsurancePolicyAuthorizationID ,
          CASE WHEN app.PatientCaseID = '' THEN NULL ELSE app.patientcaseid END ,
          0 ,--app.Recurrence ,
          app.RecurrenceStartDate ,
          app.RangeEndDate ,
          app.RangeType ,
          dk.DKPracticeID ,
          dk.DKPracticeID ,
          app.StartTm ,
          app.EndTm
FROM dbo.[_import_2_1_Appointment] app
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(app.startdate AS date) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.Appointment OFF


PRINT ''
PRINT 'Inserting Into PracticetoResource...'
SET IDENTITY_INSERT dbo.PracticeResource ON
INSERT INTO dbo.PracticeResource
        ( PracticeResourceID ,
		  PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
SELECT    practiceresourceid ,
          practiceresourcetypeid , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          resourcename , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
FROM dbo.[_import_2_1_PracticeResource]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.PracticeResource OFF


SET IDENTITY_INSERT dbo.AppointmentToResource ON
PRINT ''
PRINT 'Inserting into AppointmentToResource ...'
INSERT INTO dbo.AppointmentToResource 
        ( AppointmentToResourceID ,
		  AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT    appointmenttoresourceid ,
		  AppointmentID , -- AppointmentID - int
          APpointmentResourceTypeID , -- AppointmentResourceTypeID - int
          resourceid , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_AppointmentToResource]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.AppointmentToResource OFF


PRINT ''
PRINT 'Inserting into AppointmentReason ...'
INSERT INTO dbo.AppointmentReason
        ( 
		  PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
        )
SELECT    
		  @PracticeID , -- PracticeID - int
          appointmentreasonid + '-' + name , -- Name - varchar(128)
          DefaultDurationMinutes , -- DefaultDurationMinutes - int
          DefaultColorCode , -- DefaultColorCode - int
          [Description] , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_2_1_AppointmentReason]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



SET IDENTITY_INSERT dbo.AppointmentToAppointmentReason ON
PRINT ''
PRINT 'Inserting into AppointmentToAppointmentReason ...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentToAppointmentReasonID ,
		  AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT    i.appointmenttoappointmentreasonid ,
		  i.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          CASE WHEN i.PrimaryAppointment = -1 THEN 1 ELSE i.primaryappointment END , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_AppttoApptReason] i
INNER JOIN dbo.AppointmentReason ar ON 
	i.appointmentreasonid = LEFT(ar.Name,CHARINDEX('-',ar.Name)-1) AND
	ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.AppointmentToAppointmentReason OFF


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

