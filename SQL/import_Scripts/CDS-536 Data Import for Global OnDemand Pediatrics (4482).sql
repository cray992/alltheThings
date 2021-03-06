USE superbill_4482_dev
--USE superbill_4482_dev
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 7
SET @VendorImportID = 1

SET NOCOUNT ON 

/*
DELETE FROM dbo.InsurancePolicyAuthorization WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy Auth records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.PracticeToInsuranceCompany WHERE PracticeID = @PracticeID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PracticetoInsuranceCompany records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource --WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.PracticeResource WHERE PracticeID = @PracticeID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PracticeResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.Appointment WHERE AppointmentType = 'O'
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
*/



PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( 
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
          --ReviewCode ,
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
          --i.reviewcode , -- ReviewCode - char(1)
          i.companytextid , -- CompanyTextID - varchar(10)
          i.clearinghousepayerid , -- ClearinghousePayerID - int
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.secondaryprecedencebillingformid , -- SecondaryPrecedenceBillingFormID - int
          i.insurancecompanyid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE WHEN i.defaultadjustmentcode = '' THEN NULL ELSE a.AdjustmentCode END , -- DefaultAdjustmentCode - varchar(10)
          i.referringprovidernumbertypeid , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          i.anesthesiatype , -- AnesthesiaType - varchar(1)
          i.institutionalbillingformid  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_7_InsuranceCompany] i
	LEFT JOIN dbo.Adjustment a ON
		i.defaultadjustmentcode = a.AdjustmentCode 
	INNER JOIN dbo.[_import_2_7_InsuranceCompanyPlan] icp ON 
		i.insurancecompanyid = icp.InsuranceCompanyID 
    INNER JOIN dbo.[_import_2_7_InsurancePolicy] ip ON 
		icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

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
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ptic.EClaimsProviderID , -- EClaimsProviderID - varchar(32)
          ptic.EClaimsProviderID , -- EClaimsEnrollmentStatusID - int
          ptic.EClaimsDisable , -- EClaimsDisable - int
          CASE WHEN ptic.AcceptAssignment = -1 THEN 1 ELSE ptic.acceptassignment END , -- AcceptAssignment - bit
          CASE WHEN ptic.usesecondaryelectronicbilling = -1 THEN 1 ELSE ptic.usesecondaryelectronicbilling END, -- UseSecondaryElectronicBilling - bit
          CASE WHEN ptic.UseCoordinationOfBenefits = -1 THEN 1 ELSE ptic.usecoordinationofbenefits END , -- UseCoordinationOfBenefits - bit
          CASE WHEN ptic.ExcludePatientPayment = -1 THEN 1 ELSE ptic.excludepatientpayment END , -- ExcludePatientPayment - bit
          CASE WHEN ptic.BalanceTransfer = -1 THEN 1 ELSE ptic.balancetransfer END -- BalanceTransfer - bit
FROM dbo.[_import_2_7_PracticeToInsuranceCompany] ptic
	INNER JOIN dbo.InsuranceCompany ic ON
		ptic.insurancecompanyid = ic.VendorID AND
		ic.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( 
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
          --ReviewCode ,
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
          0 ,
          GETDATE() ,
          0 ,
          --i.ReviewCode ,
          i.CreatedPracticeID ,
          i.Fax ,
          i.FaxExt ,
          i.KareoInsuranceCompanyPlanID ,
          CASE WHEN ISDATE(i.KareoLastModifiedDate) = 1 THEN i.kareolastmodifieddate ELSE NULL END ,
          ic.InsuranceCompanyID ,
          i.Copay ,
          i.Deductible ,
          i.InsuranceCompanyPlanID ,
          @VendorImportID 
FROM dbo.[_import_2_7_InsuranceCompanyPlan] i
	INNER JOIN dbo.InsuranceCompany ic ON 
		i.insurancecompanyid = ic.VendorID AND
		ic.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Updating Existing Provider Records with VendorID...'
UPDATE dbo.Doctor 
	SET VendorID = i.providerid
FROM dbo.Doctor d
INNER JOIN dbo.[_import_2_7_Providers] i ON
	d.FirstName = i.firstname AND
	d.LastName = i.lastname AND
	d.NPI = i.npi
WHERE d.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '

PRINT ''
PRINT 'Inserting Into Referring Provider...'
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
          --EmailAddress ,
          --Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          --TaxonomyCode ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          FaxNumberExt ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID ,
          i.prefix ,
          i.FirstName ,
          i.MiddleName ,
          i.LastName ,
          i.Suffix ,
          i.SSN ,
          i.AddressLine1 ,
          i.AddressLine2 ,
          i.City ,
          i.State ,
          i.Country ,
          i.ZipCode ,
          i.HomePhone ,
          i.HomePhoneExt ,
          i.WorkPhone ,
          i.WorkPhoneExt ,
          i.PagerNumber ,
          i.pagernumberext ,
          i.MobilePhone ,
          i.MobilePhoneExt ,
          i.DOB ,
          --i.EmailAddress ,
          --i.Notes ,
          i.active ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          i.Degree ,
          --CASE WHEN i.TaxonomyCode = '' THEN NULL ELSE i.taxonomycode END ,
          i.providerid ,
          @VendorImportID ,
          i.FaxNumber ,
          i.FaxNumberExt ,
          1 ,
          i.NPI 
FROM dbo.[_import_2_7_Providers] i
WHERE i.providertype = 'Referring' AND NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE d.VendorID = i.ProviderID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
          InsuranceProgramCode ,
          PatientReferralSourceID ,
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
          CASE WHEN p.referringphysicianid = '' THEN NULL ELSE rd.doctorID END, -- ReferringPhysicianID - int
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
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.EmploymentStatus , -- EmploymentStatus - char(1)
          CASE WHEN p.InsuranceProgramCode = '' THEN NULL ELSE p.insuranceprogramcode END , -- InsuranceProgramCode - char(2)
          prs.PatientReferralSourceID , -- PatientReferralSourceID - int
         CASE WHEN p.primaryproviderid = '' THEN NULL ELSE pp.DoctorID END  , -- PrimaryProviderID - int
          sl.ServiceLocationID , -- DefaultServiceLocationID - int
         -- p.EmployerID , -- EmployerID - int
          p.MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
          p.MobilePhone , -- MobilePhone - varchar(10)
          p.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
          CASE WHEN p.primarycarephysicianid = '' THEN NULL ELSE pcp.DoctorID END , -- PrimaryCarePhysicianID - int
          p.PatientID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          p.CollectionCategoryID , -- CollectionCategoryID - int
          CASE WHEN p.Active = -1 THEN 1 ELSE p.active END , -- Active - bit
          CASE WHEN p.SendEmailCorrespondence = -1 THEN 1 ELSE p.sendemailcorrespondence END , -- SendEmailCorrespondence - bit
          CASE WHEN p.PhonecallRemindersEnabled = -1 THEN 1 ELSE p.phonecallremindersenabled END, -- PhonecallRemindersEnabled - bit
          p.EmergencyName , -- EmergencyName - varchar(128)
          p.EmergencyPhone , -- EmergencyPhone - varchar(10)
          p.EmergencyPhoneExt , -- EmergencyPhoneExt - varchar(10)
          p.Ethnicity , -- Ethnicity - varchar(64)
          p.Race , -- Race - varchar(64)
          p.LicenseNumber , -- LicenseNumber - varchar(64)
          p.LicenseState , -- LicenseState - varchar(2)
          p.Language1 , -- Language1 - varchar(64)
          p.Language2  -- Language2 - varchar(64)
FROM dbo.[_import_2_7_Patient] p
LEFT JOIN dbo.Doctor pp ON
	p.primaryproviderid = pp.VendorID AND
	pp.PracticeID = @PracticeID
LEFT JOIN dbo.Doctor rd ON 
	p.referringphysicianid = rd.VendorID AND 
	rd.PracticeID = @PracticeID
LEFT JOIN dbo.Doctor pcp ON	
	p.primarycarephysicianid = pcp.VendorID  AND
	pcp.PracticeID = @PracticeID
LEFT JOIN dbo.ServiceLocation sl ON
	p.DefaultServiceLocationID = sl.VendorID AND
	sl.PracticeID = @PracticeID
LEFT JOIN dbo.PatientReferralSource prs ON 
	p.patientreferralsourceid = prs.PatientReferralSourceID AND
	prs.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT''
PRINT'Inserting into PatientCase ...'
INSERT INTO dbo.PatientCase
        ( 
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
SELECT DISTINCT   
		  
		  p.PatientID ,
          pc.Name ,
          CASE WHEN pc.Active = '-1' THEN 1 ELSE pc.active END ,
          pc.PayerScenarioID ,
          CASE WHEN pc.ReferringPhysicianID <> '' THEN rp.DoctorID ELSE NULL END ,
          CASE WHEN pc.EmploymentRelatedFlag = '-1' THEN 1 ELSE pc.employmentrelatedflag END ,
          CASE WHEN pc.AutoAccidentRelatedFlag = '-1' THEN 1 ELSE pc.autoaccidentrelatedflag END ,
          CASE WHEN pc.OtherAccidentRelatedFlag = '-1' THEN 1 ELSE pc.otheraccidentrelatedflag END,
          CASE WHEN pc.AbuseRelatedFlag = '-1' THEN 1 ELSE pc.abuserelatedflag END ,
          pc.AutoAccidentRelatedState ,
          pc.Notes ,
          CASE WHEN pc.ShowExpiredInsurancePolicies = -1 THEN 1 ELSE pc.showexpiredinsurancepolicies END,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          @PracticeID ,
          pc.CaseNumber ,
          --pc.WorkersCompContactInfoID ,
          pc.patientcaseid ,
          @VendorImportID ,
          CASE WHEN pc.PregnancyRelatedFlag = '-1' THEN 1 ELSE pc.pregnancyrelatedflag END ,
          CASE WHEN pc.StatementActive = '-1' THEN 1 ELSE pc.statementactive END ,
          CASE WHEN pc.EPSDT = '-1' THEN 1 ELSE pc.epsdt END,
          CASE WHEN pc.FamilyPlanning = '-1' THEN 1 ELSE pc.familyplanning END,
          CASE WHEN pc.EPSDTCodeID = '' THEN NULL ELSE pc.epsdtcodeid END ,
          CASE WHEN pc.EmergencyRelated = '-1' THEN 1 ELSE pc.emergencyrelated END,
          CASE WHEN pc.HomeboundRelatedFlag = '-1' THEN 1 ELSE pc.homeboundrelatedflag END
FROM dbo.[_import_2_7_PatientCase] pc
	INNER JOIN dbo.Patient p ON 
		pc.patientid = p.VendorID AND
		p.VendorImportID = @VendorImportID 
	LEFT JOIN dbo.Doctor rp ON 
		pc.referringphysicianid = rp.VendorID AND
		rp.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into PatientAlert ...'
INSERT INTO dbo.PatientAlert
        ( 
		  PatientID ,
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
          pa.AlertMessage , -- AlertMessage - text
          CASE WHEN pa.ShowInPatientFlag = '-1' THEN 1 ELSE pa.showinpatientflag END, -- ShowInPatientFlag - bit
          CASE WHEN pa.ShowInAppointmentFlag = '-1' THEN 1 ELSE pa.showinappointmentflag END , -- ShowInAppointmentFlag - bit
          CASE WHEN pa.ShowInEncounterFlag = '-1' THEN 1 ELSE pa.showinencounterflag END , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
		  0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pa.ShowInClaimFlag = '-1' THEN 1 ELSE pa.showinclaimflag END, -- ShowInClaimFlag - bit
          CASE WHEN pa.ShowInPaymentFlag = '-1' THEN 1 ELSE pa.showinpaymentflag END, -- ShowInPaymentFlag - bit
          CASE WHEN pa.ShowInPatientStatementFlag = '-1' THEN 1 ELSE pa.showinpatientstatementflag END -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_2_7_PatientAlert] pa
	INNER JOIN dbo.Patient p ON
		pa.patientid = p.VendorID AND
		p.VendorImportID = @VendorImportID
PRINT CAST(@@Rowcount AS VARCHAR) + ' records inserted'	

PRINT''
PRINT'Inserting into PatientJournalNotes ...'
INSERT INTO dbo.PatientJournalNote
        ( 
		  CreatedDate ,
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
	 	  
		  pjn.createddate  ,
          0 ,
          GETDATE() ,
          0 ,
          p.PatientID ,
          pjn.UserName ,
          pjn.SoftwareApplicationID ,
          CASE WHEN pjn.Hidden = '-1' THEN 1 ELSE pjn.hidden END ,
          pjn.NoteMessage ,
          pjn.AccountStatus ,
          pjn.NoteTypeCode ,
          CASE WHEN pjn.LastNote = '-1' THEN 1 ELSE pjn.lastnote END
FROM dbo.[_import_2_7_PatientJournalNote] pjn
	INNER JOIN dbo.Patient p ON
		pjn.patientid = p.VendorID AND 
		p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy
        ( 
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
SELECT DISTINCT   
          pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          ip.Precedence ,
          ip.PolicyNumber ,
          ip.GroupNumber ,
          CASE WHEN ISDATE(ip.PolicyStartDate) = 1 THEN ip.policystartdate ELSE NULL END ,
          CASE WHEN ISDATE(ip.PolicyEndDate) = 1 THEN ip.policyenddate ELSE NULL END ,
          ip.CardOnFile ,
          ip.PatientRelationshipToInsured ,
          ip.HolderPrefix ,
          ip.HolderFirstName ,
          ip.HolderMiddleName ,
          ip.HolderLastName ,
          ip.HolderSuffix ,
          ip.HolderDOB ,
          ip.HolderSSN ,
          CASE WHEN ip.HolderThroughEmployer = -1 THEN 1 ELSE ip.holderthroughemployer END ,
          ip.HolderEmployerName ,
          ip.PatientInsuranceStatusID ,
          GETDATE() ,
          -50 ,
          GETDATE() ,
          -50 ,
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
          ip.GroupName ,
          ip.ReleaseOfInformation 
FROM dbo.[_import_2_7_InsurancePolicy] ip
	INNER JOIN dbo.PatientCase pc ON 
		ip.patientcaseid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
    INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		ip.insurancecompanyplanid = icp.VendorID AND
		icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Insurance Policy Authorization...'
INSERT INTO dbo.InsurancePolicyAuthorization
        ( InsurancePolicyID ,
          AuthorizationNumber ,
          AuthorizedNumberOfVisits ,
          StartDate ,
          EndDate ,
          ContactFullname ,
          ContactPhone ,
          ContactPhoneExt ,
          AuthorizationStatusID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AuthorizedNumberOfVisitsUsed ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
		  ip.InsurancePolicyID , -- InsurancePolicyID - int
          i.authorizationnumber , -- AuthorizationNumber - varchar(65)
          i.authorizednumberofvisits , -- AuthorizedNumberOfVisits - int
          CASE WHEN ISDATE(i.startdate) = 1 THEN i.startdate END , -- StartDate - datetime
          CASE WHEN ISDATE(i.enddate) = 1 THEN i.enddate END , -- EndDate - datetime
          i.contactfullname , -- ContactFullname - varchar(65)
          i.contactphone , -- ContactPhone - varchar(10)
          i.contactphoneext , -- ContactPhoneExt - varchar(10)
          i.authorizationstatusid , -- AuthorizationStatusID - int
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.authorizednumberofvisitsused , -- AuthorizedNumberOfVisitsUsed - int
          i.insurancepolicyauthorizationid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_7_InsurancePolicyAuthorization] i
INNER JOIN dbo.InsurancePolicy ip ON
	i.insurancepolicyid = ip.VendorID AND
	ip.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT


