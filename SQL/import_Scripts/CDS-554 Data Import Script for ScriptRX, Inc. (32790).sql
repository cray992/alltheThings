USE superbill_32790_dev
--USE superbill_32790_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @SourcePracticeID INT
DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @SourcePracticeID = 25
SET @PracticeID = 9
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.InsurancePolicyAuthorization WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy Auth records deleted'
--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.PracticeToInsuranceCompany WHERE PracticeID = @PracticeID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PracticetoInsuranceCompany records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( 
		  InsuranceCompanyName ,
          --Notes ,
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
          --DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  
	      i.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
          --i.notes , -- Notes - text
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
          i.billsecondaryinsurance , -- BillSecondaryInsurance - bit
          i.eclaimsaccepts , -- EClaimsAccepts - bit
          i.billingformid , -- BillingFormID - int
          i.insuranceprogramcode , -- InsuranceProgramCode - char(2)
          i.hcfadiagnosisreferenceformatcode , -- HCFADiagnosisReferenceFormatCode - char(1)
          i.hcfasameasinsuredformatcode  , -- HCFASameAsInsuredFormatCode - char(1)
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
          --a.AdjustmentCode , -- DefaultAdjustmentCode - varchar(10)
          i.referringprovidernumbertypeid , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int	
          1 , -- UseFacilityID - bit
          i.anesthesiatype , -- AnesthesiaType - varchar(1)
          i.institutionalbillingformid  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_9_InsuranceCompany] i
	INNER JOIN dbo.[_import_2_9_InsuranceCompanyPlan] icp ON
		i.InsuranceCompanyID = icp.InsuranceCompanyID
	INNER JOIN dbo.[_import_2_9_InsurancePolicy] ip ON
		icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND
		ip.PracticeID = @SourcePracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Updating Insurance Company Notes...'
UPDATE dbo.InsuranceCompany
	SET Notes = i.Notes
FROM dbo.InsuranceCompany ic 
	INNER JOIN dbo.[_import_2_9_InsuranceCompany] i ON
		ic.VendorID = i.InsuranceCompanyID AND
		ic.VendorImportID = @VendorImportID
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
SELECT DISTINCT   
          @PracticeID , -- PracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ptic.EClaimsProviderID , -- EClaimsProviderID - varchar(32)
          ptic.EClaimsProviderID , -- EClaimsEnrollmentStatusID - int
          ptic.EClaimsDisable , -- EClaimsDisable - int
          ptic.acceptassignment  , -- AcceptAssignment - bit
          ptic.usesecondaryelectronicbilling , -- UseSecondaryElectronicBilling - bit
          ptic.usecoordinationofbenefits  , -- UseCoordinationOfBenefits - bit
          ptic.excludepatientpayment  , -- ExcludePatientPayment - bit
          ptic.balancetransfer  -- BalanceTransfer - bit
FROM dbo.[_import_2_9_PracticeToInsuranceCompany] ptic
	INNER JOIN dbo.InsuranceCompany ic ON
		ptic.insurancecompanyid = ic.VendorID AND
		ic.VendorImportID = @VendorImportID
WHERE ptic.practiceid = @SourcePracticeID
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
SELECT 
          
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
FROM dbo.[_import_2_9_InsuranceCompanyPlan] i
	INNER JOIN dbo.InsuranceCompany ic ON 
		i.insurancecompanyid = ic.VendorID AND
		ic.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Updating Existing Provider Records with VendorID...'
UPDATE dbo.Doctor 
	SET VendorID = i.providerid
FROM dbo.Doctor d
INNER JOIN dbo.[_import_2_9_Providers] i ON
	d.FirstName = i.firstname AND
	d.LastName = i.lastname AND
	d.NPI = i.npi
WHERE d.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '

SET IDENTITY_INSERT dbo.CollectionCategory ON
PRINT ''
PRINT 'Inserting Into Collection Category...'
INSERT INTO dbo.CollectionCategory
        ( CollectionCategoryID ,
		  CollectionCategoryName ,
          [Description] ,
          SendStatement ,
          IsDefaultCategory ,
          DunningMessage ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ShowAlert ,
          AlertMessage
        )
SELECT DISTINCT
		  i.collectioncategoryid ,
		  i.collectioncategoryname , -- CollectionCategoryName - nchar(200)
          i.[description] , -- Description - nchar(256)
          i.sendstatement , -- SendStatement - bit
          i.isdefaultcategory , -- IsDefaultCategory - bit
          i.dunningmessage , -- DunningMessage - nchar(1500)
          i.notes , -- Notes - nchar(1000)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.showalert , -- ShowAlert - bit
          i.alertmessage  -- AlertMessage - varchar(max)
FROM dbo.[_import_2_9_CollectionCategory] i 
WHERE NOT EXISTS (SELECT * FROM dbo.CollectionCategory cc WHERE i.CollectionCategoryID = cc.CollectionCategoryID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.CollectionCategory OFF

PRINT ''
PRINT 'Inserting Into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  i.EmployerName , -- EmployerName - varchar(128)
          i.AddressLine1 , -- AddressLine1 - varchar(256)
          i.AddressLine2 , -- AddressLine2 - varchar(256)
          i.City , -- City - varchar(128)
          i.[State] , -- State - varchar(2)
          i.Country , -- Country - varchar(32)
          i.ZipCode , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_2_9_Employers] i
	INNER JOIN dbo.[_import_2_9_Patient] p ON
		i.EmployerID = p.EmployerID AND
		p.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Employers e WHERE i.EmployerName = e.EmployerName)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #tempemp
( id INT , NAME VARCHAR(128))

INSERT INTO #tempemp
        ( id, NAME )
SELECT DISTINCT
		  e.EmployerID, -- id - int
          oe.EmployerName  -- NAME - varchar(128)
FROM dbo.[_import_2_9_Employers] e 
INNER JOIN dbo.Employers oe ON
	oe.EmployerName = e.EmployerName

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
          14, -- DefaultServiceLocationID - int
          e.EmployerID , -- EmployerID - int
          p.MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
          p.MobilePhone , -- MobilePhone - varchar(10)
          p.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
          pcp.DoctorID  , -- PrimaryCarePhysicianID - int
          p.PatientID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          p.CollectionCategoryID , -- CollectionCategoryID - int
          p.active  , -- Active - bit
          p.sendemailcorrespondence  , -- SendEmailCorrespondence - bit
          p.phonecallremindersenabled , -- PhonecallRemindersEnabled - bit
          p.EmergencyName , -- EmergencyName - varchar(128)
          p.EmergencyPhone , -- EmergencyPhone - varchar(10)
          p.EmergencyPhoneExt , -- EmergencyPhoneExt - varchar(10)
          p.Ethnicity , -- Ethnicity - varchar(64)
          p.Race , -- Race - varchar(64)
          p.LicenseNumber , -- LicenseNumber - varchar(64)
          p.LicenseState , -- LicenseState - varchar(2)
          p.Language1 , -- Language1 - varchar(64)
          p.Language2  -- Language2 - varchar(64)
FROM dbo.[_import_2_9_Patient] p
LEFT JOIN dbo.Doctor pp ON
	p.primaryproviderid = pp.VendorID AND
	pp.PracticeID = @PracticeID
LEFT JOIN dbo.Doctor rd ON 
	p.referringphysicianid = rd.VendorID AND 
	rd.PracticeID = @PracticeID
LEFT JOIN dbo.Doctor pcp ON	
	p.primarycarephysicianid = pcp.VendorID  AND
	pcp.PracticeID = @PracticeID
LEFT JOIN dbo.PatientReferralSource prs ON 
	p.patientreferralsourceid = prs.PatientReferralSourceID AND
	prs.PracticeID = @PracticeID
LEFT JOIN dbo.#tempemp te ON
	p.EmployerID = te.id 
LEFT JOIN dbo.Employers e ON
	te.NAME = e.EmployerName
WHERE p.PracticeID = @SourcePracticeID
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
SELECT    
		  p.PatientID ,
          pc.Name ,
          pc.active  ,
          CASE WHEN ps.PayerScenarioID IS NULL THEN 5 ELSE ps.PayerScenarioID END ,
          rp.DoctorID  ,
          pc.employmentrelatedflag  ,
          pc.autoaccidentrelatedflag  ,
          pc.otheraccidentrelatedflag ,
          pc.abuserelatedflag  ,
          pc.AutoAccidentRelatedState ,
          pc.Notes ,
          pc.showexpiredinsurancepolicies ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          @PracticeID ,
          pc.CaseNumber ,
          --pc.WorkersCompContactInfoID ,
          pc.patientcaseid ,
          @VendorImportID ,
          pc.pregnancyrelatedflag  ,
          pc.statementactive  ,
          pc.epsdt ,
          pc.familyplanning ,
          pc.epsdtcodeid  ,
          pc.emergencyrelated ,
          pc.homeboundrelatedflag 
FROM dbo.[_import_2_9_PatientCase] pc
	INNER JOIN dbo.Patient p ON 
		pc.patientid = p.VendorID AND
		p.VendorImportID = @VendorImportID 
	LEFT JOIN dbo.Doctor rp ON 
		pc.referringphysicianid = rp.VendorID AND
		rp.PracticeID = @PracticeID
	LEFT JOIN dbo.PayerScenario ps ON
		pc.PayerScenarioID = ps.PayerScenarioID
WHERE pc.PracticeID = @SourcePracticeID
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
SELECT    
          p.PatientID , -- PatientID - int
          pa.AlertMessage , -- AlertMessage - text
          pa.showinpatientflag , -- ShowInPatientFlag - bit
          pa.showinappointmentflag  , -- ShowInAppointmentFlag - bit
          pa.showinencounterflag  , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
		  0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pa.showinclaimflag , -- ShowInClaimFlag - bit
          pa.showinpaymentflag , -- ShowInPaymentFlag - bit
          pa.showinpatientstatementflag  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_2_9_PatientAlert] pa
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
          pjn.hidden  ,
          pjn.NoteMessage ,
          pjn.AccountStatus ,
          pjn.NoteTypeCode ,
          pjn.lastnote 
FROM dbo.[_import_2_9_PatientJournalNote] pjn
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
SELECT    
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
FROM dbo.[_import_2_9_InsurancePolicy] ip
	INNER JOIN dbo.PatientCase pc ON 
		ip.patientcaseid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
    INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		ip.insurancecompanyplanid = icp.VendorID AND
		icp.VendorImportID = @VendorImportID
WHERE ip.PracticeID = @SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DROP TABLE #tempemp



--ROLLBACK
--COMMIT


