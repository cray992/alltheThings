--USE superbill_59746_dev
USE superbill_59746_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 1
SET @SourcePracticeID = 20
SET @VendorImportID = 1

SET NOCOUNT ON 


/*==========================================================================*/
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--
--CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
--INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo.[_import_2_1_PatientDemographics] i ON p.PatientID = i.id

--PRINT ''
--PRINT 'Updating Existing Patients Demographics...'
--UPDATE dbo.Patient 
--	SET DOB = i.DateofBirth  ,
--		SSN = i.ssn
--FROM #updatepat i 
--INNER JOIN dbo.Patient p ON
--	p.PatientID = i.patientid
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--DROP TABLE #updatepat

/*==========================================================================*/

/*
PRINT ''
PRINT 'Updating Patients Demographics Source Table...'
UPDATE dbo._import_1_1_Patient 
	SET DOB = DATEADD(hh,12,CAST(p.DateofBirth AS DATETIME))  ,
		SSN = p.ssn , 
		HomePhone = p.HomePhone , 
		HomePhoneExt = p.HomePhoneExt , 
		MobilePhone = p.MobilePhone , 
		MobilePhoneExt = p.MobilePhoneExt , 
		WorkPhone = p.WorkPhone , 
		WorkPhoneExt = p.WorkPhoneExt 
FROM _import_1_1_Patient i 
INNER JOIN dbo._import_1_1_PatientDemographics p ON
	p.id = i.patientid
WHERE i.PracticeID = @SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'
*/


CREATE TABLE #tempdoc (doctorid INT, firstname VARCHAR(65), lastname VARCHAR(65), NPI INT , [External] INT)
INSERT INTO #tempdoc (doctorid, firstname, lastname, NPI , [External] )
SELECT DISTINCT
		  d.doctorid ,
		  d.firstname ,-- firstname - varchar(65)
          d.lastname, -- lastname - varchar(65)
          d.npi ,  -- NPI - int
		  d.[External]
FROM dbo._import_1_1_Doctor d 
WHERE d.PracticeID = @SourcePracticeID 

PRINT ''
PRINT 'Updating Existing Rendering Doctor Records with VendorID...'
UPDATE dbo.Doctor 
	SET VendorID = i.DoctorID
FROM dbo.Doctor d
INNER JOIN #tempdoc i ON
	i.FirstName = d.FirstName AND
    i.LastName = d.LastName AND
    i.NPI = d.NPI 
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 0 AND i.[External] = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

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
          @TargetPracticeID , -- CreatedPracticeID - int
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
FROM dbo.[_import_1_1_InsuranceCompany] i
	INNER JOIN dbo.[_import_1_1_InsuranceCompanyPlan] icp ON
		i.InsuranceCompanyID = icp.InsuranceCompanyID
	INNER JOIN dbo.[_import_1_1_InsurancePolicy] ip ON
		icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND
		ip.PracticeID = @SourcePracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Updating Insurance Company Notes...'
UPDATE dbo.InsuranceCompany
	SET Notes = i.Notes
FROM dbo.InsuranceCompany ic 
	INNER JOIN dbo.[_import_1_1_InsuranceCompany] i ON
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
          @TargetPracticeID , -- PracticeID - int
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
FROM dbo.[_import_1_1_PracticeToInsuranceCompany] ptic
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
          @TargetPracticeID,
          i.Fax ,
          i.FaxExt ,
          i.KareoInsuranceCompanyPlanID ,
          CASE WHEN ISDATE(i.KareoLastModifiedDate) = 1 THEN i.kareolastmodifieddate ELSE NULL END ,
          ic.InsuranceCompanyID ,
          i.Copay ,
          i.Deductible ,
          i.InsuranceCompanyPlanID ,
          @VendorImportID 
FROM dbo.[_import_1_1_InsuranceCompanyPlan] i
	INNER JOIN dbo.InsuranceCompany ic ON 
		i.insurancecompanyid = ic.VendorID AND
		ic.VendorImportID = @VendorImportID
WHERE i.InsuranceCompanyPlanID IN (SELECT InsuranceCompanyPlanID FROM dbo._import_1_1_InsurancePolicy WHERE PracticeID = @SourcePracticeID)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Updating Existing Patients with VendorID...'
UPDATE dbo.Patient 
	SET VendorID = i.PatientID , 
		VendorImportID = @VendorImportID
FROM dbo.Patient p 
	INNER JOIN dbo._import_1_1_Patient i ON 
		p.FirstName = i.FirstName AND 
		p.LastName = i.LastName AND 
		p.DOB = i.DOB AND
		i.PracticeID = @SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

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
          --PatientReferralSourceID ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          --EmployerID ,
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
		  @TargetPracticeID , -- PracticeID - int
          rd.doctorID , -- ReferringPhysicianID - int
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
          p.responsibledifferentthanpatient , -- ResponsibleDifferentThanPatient - bit
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
          p.insuranceprogramcode  , -- InsuranceProgramCode - char(2)
          --prs.PatientReferralSourceID , -- PatientReferralSourceID - int
          pp.DoctorID , -- PrimaryProviderID - int
          sl.ServiceLocationID , -- DefaultServiceLocationID - int
          --emp.EmployerID , -- EmployerID - int
          p.MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
          p.MobilePhone , -- MobilePhone - varchar(10)
          p.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
          pcp.DoctorID , -- PrimaryCarePhysicianID - int
          p.PatientID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          p.CollectionCategoryID , -- CollectionCategoryID - int
          p.active , -- Active - bit
          p.sendemailcorrespondence , -- SendEmailCorrespondence - bit
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
FROM dbo.[_import_1_1_Patient] p
LEFT JOIN dbo.Doctor pp ON
	p.primaryproviderid = pp.VendorID AND
	pp.PracticeID = @TargetPracticeID
LEFT JOIN dbo.Doctor rd ON 
	p.referringphysicianid = rd.VendorID AND 
	rd.PracticeID = @TargetPracticeID
LEFT JOIN dbo.Doctor pcp ON	
	p.primarycarephysicianid = pcp.VendorID  AND
	pcp.PracticeID = @TargetPracticeID
LEFT JOIN dbo.ServiceLocation sl ON
	sl.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation WHERE PracticeID = @TargetPracticeID)
WHERE p.PracticeID = @SourcePracticeID 
AND NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Insert Into Patient Alert...'
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
SELECT 
		  p.PatientID , -- PatientID - int
          pa.AlertMessage , -- AlertMessage - text
          pa.ShowInPatientFlag , -- ShowInPatientFlag - bit
          pa.ShowInAppointmentFlag , -- ShowInAppointmentFlag - bit
          pa.ShowInEncounterFlag , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pa.ShowInClaimFlag , -- ShowInClaimFlag - bit
          pa.ShowInPaymentFlag , -- ShowInPaymentFlag - bit
          pa.ShowInPatientStatementFlag  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_1_1_PatientAlert] pa
INNER JOIN dbo.Patient p ON 
	p.VendorImportID = @VendorImportID AND
	p.VendorID = pa.PatientID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
FROM dbo.[_import_1_1_PatientJournalNote] pjn
	INNER JOIN dbo.Patient p ON
		pjn.patientid = p.VendorID AND 
		p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Existing Patient Cases with VendorID...'
UPDATE dbo.PatientCase
	SET VendorID = ipc.PatientCaseID , 
		VendorImportID = @VendorImportID
FROM dbo.PatientCase pc		
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
    p.PracticeID = @TargetPracticeID
INNER JOIN dbo._import_1_1_PatientCase ipc ON 
	p.VendorID = ipc.PatientID AND 
	ipc.PracticeID = @SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting into PatientCase ...'
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
          pc.PayerScenarioID ,
          d.DoctorID ,
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
          @TargetPracticeID ,
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
FROM dbo.[_import_1_1_PatientCase] pc
	INNER JOIN dbo.Patient p ON 
		pc.patientid = p.VendorID AND
		p.VendorImportID = @VendorImportID 
	LEFT JOIN dbo.Doctor d ON 
		pc.ReferringPhysicianID = d.VendorID AND 
	    d.PracticeID = @TargetPracticeID
	LEFT JOIN dbo.PatientCase tpc ON 
		tpc.PatientID = p.PatientID AND
        tpc.PracticeID = @TargetPracticeID AND
        tpc.VendorImportID = @VendorImportID
WHERE tpc.PatientCaseID IS NULL 
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
		  @TargetPracticeID , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          i.PatientCaseDateTypeID , -- PatientCaseDateTypeID - int
          i.StartDate , -- StartDate - datetime
          i.EndDate , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_1_PatientCaseDate] i
	INNER JOIN dbo.PatientCase pc ON
		i.PatientCaseID = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
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
          ip.holderthroughemployer  ,
          ip.HolderEmployerName ,
          ip.PatientInsuranceStatusID ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
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
          ip.active  ,
          @TargetPracticeID ,
          ip.AdjusterPrefix ,
          ip.AdjusterFirstName ,
          ip.AdjusterMiddleName ,
          ip.AdjusterLastName ,
          ip.AdjusterSuffix ,
          ip.InsurancePolicyID ,
          @VendorImportID ,
          ip.insuranceprogramtypeid ,
          ip.GroupName ,
          ip.ReleaseOfInformation 
FROM dbo.[_import_1_1_InsurancePolicy] ip
	INNER JOIN dbo.PatientCase pc ON 
		ip.patientcaseid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		ip.InsuranceCompanyPlanID = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

SET IDENTITY_INSERT dbo.[ContractsAndFees_StandardFeeSchedule] ON
PRINT ''
PRINT 'Inserting Into Standard Fee Schedule...'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
        ( StandardFeeScheduleID ,
		  PracticeID ,
          Name ,
          Notes ,
          EffectiveStartDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          MedicareFeeScheduleGPCICarrier ,
          MedicareFeeScheduleGPCILocality ,
          MedicareFeeScheduleGPCIBatchID ,
          MedicareFeeScheduleRVUBatchID ,
          AddPercent ,
          AnesthesiaTimeIncrement
        )
SELECT 
		  7 , 
		  @TargetPracticeID , -- PracticeID - int
          i.Name , -- Name - varchar(128)
          i.Notes , -- Notes - varchar(1024)
          i.EffectiveStartDate , -- EffectiveStartDate - datetime
          i.SourceType , -- SourceType - char(1)
          i.SourceFileName , -- SourceFileName - varchar(256)
          i.EClaimsNoResponseTrigger , -- EClaimsNoResponseTrigger - int
          i.PaperClaimsNoResponseTrigger , -- PaperClaimsNoResponseTrigger - int
          i.MedicareFeeScheduleGPCICarrier , -- MedicareFeeScheduleGPCICarrier - int
          i.MedicareFeeScheduleGPCILocality , -- MedicareFeeScheduleGPCILocality - int
          i.MedicareFeeScheduleGPCIBatchID , -- MedicareFeeScheduleGPCIBatchID - int
          i.MedicareFeeScheduleRVUBatchID , -- MedicareFeeScheduleRVUBatchID - int
          i.AddPercent , -- AddPercent - decimal
          i.AnesthesiaTimeIncrement  -- AnesthesiaTimeIncrement - int
FROM dbo.[_import_1_1_ContractsAndFees_StandardFeeSchedule] i
WHERE i.PracticeID = @SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	
SET IDENTITY_INSERT dbo.[ContractsAndFees_StandardFeeSchedule] OFF

PRINT ''
PRINT 'Inserting Into Standard Fee...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT DISTINCT
	      sf.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          pm.ProcedureModifierID , -- ModifierID - int
          i.SetFee , -- SetFee - money
          i.AnesthesiaBaseUnits  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_1_1_ContractsAndFees_StandardFee] i
	INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sf ON
		sf.StandardFeeScheduleID = 7
	LEFT JOIN dbo.[_import_1_1_ProcedureCodeDictionary] ipcd ON
		i.ProcedureCodeID = ipcd.ProcedureCodeDictionaryID
	LEFT JOIN dbo.ProcedureCodeDictionary pcd ON
		ipcd.procedurecode = pcd.ProcedureCode
	LEFT JOIN  dbo.[_import_1_1_ProcedureModifier] ipm ON
		i.ModifierID = ipm.ProcedureModifierID
	LEFT JOIN dbo.ProcedureModifier pm ON
		ipm.proceduremodifiercode = pm.ProcedureModifierCode
WHERE pcd.ProcedureCodeDictionaryID IS NOT NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Standard Fee Schedule Link...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT   
		  doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs
WHERE doc.PracticeID = @TargetPracticeID AND
	  doc.[External] = 0 AND
      sl.PracticeID = @TargetPracticeID AND
	  sfs.StandardFeeScheduleID = 7 AND
      sfs.PracticeID = @TargetPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	



DROP TABLE #tempdoc


--COMMIT 
--ROLLBACK
