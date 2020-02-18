USE superbill_37658_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 2
SET @SourcePracticeID = 1
SET @VendorImportID = 5

SET NOCOUNT ON 

--PRINT ''
--PRINT 'Updating Patients Demographics Source Table...'
--UPDATE i 
--	SET DOB = DATEADD(hh,12,CAST(p.DateofBirth AS DATETIME))  ,
--		SSN = p.ssn , 
--		MedicalRecordNumber = p.medicalrecordnumber , 
--		HomePhone = p.HomePhone , 
--		HomePhoneExt = p.HomePhoneExt , 
--		MobilePhone = p.MobilePhone , 
--		MobilePhoneExt = p.MobilePhoneExt , 
--		WorkPhone = p.WorkPhone , 
--		WorkPhoneExt = p.WorkPhoneExt , 
--		EmailAddress = p.emailaddress ,
--		EmergencyName = p.emergencyname ,
--		EmergencyPhone = p.emergencyphone , 
--		EmergencyPhoneExt = p.emergencyphoneext
		
--FROM Patient i 
--INNER JOIN dbo._import_5_1_PatientDemographics p ON
--	p.id = i.patientid
--WHERE i.PracticeID = @SourcePracticeID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Company Review Code...'
UPDATE dbo.InsuranceCompany 
	SET ReviewCode = 'R'
FROM dbo.InsuranceCompany ic 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	ic.InsuranceCompanyID = icp.InsuranceCompanyID 
INNER JOIN dbo.InsurancePolicy ip ON 
	ip.PracticeID = @SourcePracticeID AND 
	icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
WHERE ic.ReviewCode = '' OR ic.ReviewCode IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Company Plan Review Code...'
UPDATE dbo.InsuranceCompanyPlan  
	SET ReviewCode = 'R'
FROM dbo.InsuranceCompanyPlan icp 
INNER JOIN dbo.InsurancePolicy ip ON 
	ip.PracticeID = @SourcePracticeID AND 
	icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
WHERE icp.ReviewCode = '' OR icp.ReviewCode IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

CREATE TABLE #tempdoc (doctorid INT, firstname VARCHAR(65), lastname VARCHAR(65), NPI INT , [External] INT)
INSERT INTO #tempdoc (doctorid, firstname, lastname, NPI , [External] )
SELECT DISTINCT
		  d.doctorid ,
		  d.firstname ,-- firstname - varchar(65)
          d.lastname, -- lastname - varchar(65)
          d.npi ,  -- NPI - int
		  d.[External]
FROM dbo.Doctor d 
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
PRINT 'Inserting Into Doctor...'
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
          Degree ,
          TaxonomyCode ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          FaxNumberExt ,
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
          KareoSpecialtyId
        )
SELECT 
		  @TargetPracticeID , -- PracticeID - int
          i.prefix , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          i.MiddleName , -- MiddleName - varchar(64)
          i.LastName , -- LastName - varchar(64)
          i.Suffix , -- Suffix - varchar(16)
          i.SSN , -- SSN - varchar(9)
          i.AddressLine1 , -- AddressLine1 - varchar(256)
          i.AddressLine2 , -- AddressLine2 - varchar(256)
          i.City , -- City - varchar(128)
          i.State , -- State - varchar(2)
          i.Country , -- Country - varchar(32)
          i.ZipCode , -- ZipCode - varchar(9)
          i.HomePhone , -- HomePhone - varchar(10)
          i.HomePhoneExt , -- HomePhoneExt - varchar(10)
          i.WorkPhone , -- WorkPhone - varchar(10)
          i.WorkPhoneExt , -- WorkPhoneExt - varchar(10)
          i.PagerPhone , -- PagerPhone - varchar(10)
          i.PagerPhoneExt , -- PagerPhoneExt - varchar(10)
          i.MobilePhone , -- MobilePhone - varchar(10)
          i.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
          i.DOB , -- DOB - datetime
          i.EmailAddress , -- EmailAddress - varchar(256)
          i.Notes , -- Notes - text
          i.ActiveDoctor , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.Degree , -- Degree - varchar(8)
          i.TaxonomyCode , -- TaxonomyCode - char(10)
          i.DoctorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          i.FaxNumber , -- FaxNumber - varchar(10)
          i.FaxNumberExt , -- FaxNumberExt - varchar(10)
          i.[External] , -- External - bit
          i.NPI , -- NPI - varchar(10)
          i.ProviderTypeID , -- ProviderTypeID - int
          i.ProviderPerformanceReportActive , -- ProviderPerformanceReportActive - bit
          i.ProviderPerformanceScope , -- ProviderPerformanceScope - int
          i.ProviderPerformanceFrequency , -- ProviderPerformanceFrequency - char(1)
          i.ProviderPerformanceDelay , -- ProviderPerformanceDelay - int
          i.ProviderPerformanceCarbonCopyEmailRecipients , -- ProviderPerformanceCarbonCopyEmailRecipients - varchar(max)
          i.ExternalBillingID , -- ExternalBillingID - varchar(50)
          i.GlobalPayToAddressFlag , -- GlobalPayToAddressFlag - bit
          i.GlobalPayToName , -- GlobalPayToName - varchar(128)
          i.GlobalPayToAddressLine1 , -- GlobalPayToAddressLine1 - varchar(256)
          i.GlobalPayToAddressLine2 , -- GlobalPayToAddressLine2 - varchar(256)
          i.GlobalPayToCity , -- GlobalPayToCity - varchar(128)
          i.GlobalPayToState , -- GlobalPayToState - varchar(2)
          i.GlobalPayToZipCode , -- GlobalPayToZipCode - varchar(9)
          i.GlobalPayToCountry , -- GlobalPayToCountry - varchar(32)
          i.KareoSpecialtyId  -- KareoSpecialtyId - int
FROM dbo.[Doctor] i WHERE i.PracticeID = @SourcePracticeID AND i.[External] = 1 AND
NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE d.VendorID = i.DoctorID AND d.PracticeID = @TargetPracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Service Location...'
INSERT INTO dbo.ServiceLocation
        ( PracticeID ,
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
SELECT DISTINCT
		  @TargetPracticeID , -- PracticeID - int
          i.Name , -- Name - varchar(128)
          i.AddressLine1 , -- AddressLine1 - varchar(256)
          i.AddressLine2 , -- AddressLine2 - varchar(256)
          i.City , -- City - varchar(128)
          i.[State] , -- State - varchar(2)
          i.Country , -- Country - varchar(32)
          i.ZipCode , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.PlaceOfServiceCode , -- PlaceOfServiceCode - char(2)
          i.BillingName , -- BillingName - varchar(128)
          i.Phone , -- Phone - varchar(10)
          i.PhoneExt , -- PhoneExt - varchar(10)
          i.FaxPhone , -- FaxPhone - varchar(10)
          i.FaxPhoneExt , -- FaxPhoneExt - varchar(10)
          i.HCFABox32FacilityID , -- HCFABox32FacilityID - varchar(50)
          i.CLIANumber , -- CLIANumber - varchar(30)
          i.RevenueCode , -- RevenueCode - varchar(4)
          @VendorImportID , -- VendorImportID - int
          i.ServiceLocationID , -- VendorID - int
          i.NPI , -- NPI - varchar(10)
          i.FacilityIDType , -- FacilityIDType - int
          i.TimeZoneID , -- TimeZoneID - int
          i.PayToName , -- PayToName - varchar(60)
          i.PayToAddressLine1 , -- PayToAddressLine1 - varchar(256)
          i.PayToAddressLine2 , -- PayToAddressLine2 - varchar(256)
          i.PayToCity , -- PayToCity - varchar(128)
          i.PayToState , -- PayToState - varchar(2)
          i.PayToCountry , -- PayToCountry - varchar(32)
          i.PayToZipCode , -- PayToZipCode - varchar(9)
          i.PayToPhone , -- PayToPhone - varchar(10)
          i.PayToPhoneExt , -- PayToPhoneExt - varchar(10)
          i.PayToFax , -- PayToFax - varchar(10)
          i.PayToFaxExt , -- PayToFaxExt - varchar(10)
          i.EIN , -- EIN - varchar(9)
          i.BillTypeID  -- BillTypeID - int
FROM dbo.ServiceLocation i
LEFT JOIN dbo.ServiceLocation sl ON 
	i.Name = sl.Name AND
    i.AddressLine1 = i.AddressLine1 AND
    sl.PracticeID = @TargetPracticeID
WHERE sl.ServiceLocationID IS NULL AND i.PracticeID = @SourcePracticeID
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
          --PatientReferralSourceID ,
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
          CASE WHEN sl.ServiceLocationID IS NULL THEN (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @TargetPracticeID) ELSE sl.ServiceLocationID END , -- DefaultServiceLocationID - int
          p.EmployerID , -- EmployerID - int
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
FROM dbo.[Patient] p
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
	p.DefaultServiceLocationID = sl.VendorID AND 
	sl.VendorImportID = @VendorImportID
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
FROM dbo.[PatientAlert] pa
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
FROM dbo.[PatientJournalNote] pjn
	INNER JOIN dbo.Patient p ON
		pjn.patientid = p.VendorID AND 
		p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
FROM dbo.[PatientCase] pc
	INNER JOIN dbo.Patient p ON 
		pc.patientid = p.VendorID AND
		p.VendorImportID = @VendorImportID 
	LEFT JOIN dbo.Doctor d ON 
		pc.ReferringPhysicianID = d.VendorID AND 
	    d.PracticeID = @TargetPracticeID
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
FROM dbo.[PatientCaseDate] i
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
          ip.InsuranceCompanyPlanID ,
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
FROM dbo.[InsurancePolicy] ip
	INNER JOIN dbo.PatientCase pc ON 
		ip.patientcaseid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy Authorization...'
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
SELECT 		
          ip.InsurancePolicyID , -- InsurancePolicyID - int
          i.AuthorizationNumber , -- AuthorizationNumber - varchar(65)
          i.AuthorizedNumberOfVisits , -- AuthorizedNumberOfVisits - int
          i.StartDate , -- StartDate - datetime
          i.EndDate , -- EndDate - datetime
          i.ContactFullname , -- ContactFullname - varchar(65)
          i.ContactPhone , -- ContactPhone - varchar(10)
          i.ContactPhoneExt , -- ContactPhoneExt - varchar(10)
          i.AuthorizationStatusID , -- AuthorizationStatusID - int
          i.Notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.AuthorizedNumberOfVisits , -- AuthorizedNumberOfVisitsUsed - int
          i.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[InsurancePolicyAuthorization] i
INNER JOIN dbo.InsurancePolicy ip ON
	i.InsurancePolicyID = ip.VendorID AND
	ip.VendorImportID = @VendorImportID	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- DoctorID 4 not in target account
CREATE TABLE #badappts (ApptID INT)
INSERT INTO #badappts 
SELECT AppointmentID
FROM dbo.AppointmentToResource 
WHERE ResourceID = 4 AND AppointmentResourceTypeID = 1

PRINT ''
PRINT 'Inserting Into Appointment...'
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
          PatientCaseID ,
          Recurrence ,
          RecurrenceStartDate ,
          RangeEndDate ,
          RangeType ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm , 
		  InsurancePolicyAuthorizationID
        )
SELECT 
		  p.PatientID , -- PatientID - int
          @TargetPracticeID , -- PracticeID - int
          CASE WHEN SL.ServiceLocationID IS NULL THEN SL2.ServiceLocationID ELSE SL.ServiceLocationID END , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.appointmenttype , -- AppointmentType - varchar(1)
          i.appointmentid , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          i.ModifiedDate , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.appointmentresourcetypeid , -- AppointmentResourceTypeID - int
          i.appointmentconfirmationstatuscode , -- AppointmentConfirmationStatusCode - char(1)
		  i.AllDay ,
          pc.PatientCaseID ,
          i.recurrence ,
          i.RecurrenceStartDate ,
          NULL ,
          i.RangeType ,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm , -- EndTm - smallint
		  CASE WHEN ipa.InsurancePolicyAuthorizationID IS NOT NULL THEN ipa.InsurancePolicyAuthorizationID ELSE NULL END
FROM dbo.[Appointment] i
	INNER JOIN dbo.Patient p ON
		p.VendorID = i.patientid AND
		p.VendorImportID = @VendorImportID
	LEFT JOIN dbo.PatientCase pc ON
		pc.VendorID = i.patientcaseid AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.DateKeyToPractice dk ON
        dk.[PracticeID] = @TargetPracticeID AND
        dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
	LEFT JOIN dbo.InsurancePolicyAuthorization ipa ON
		ipa.VendorID = i.insurancepolicyauthorizationid AND
		ipa.VendorImportID = @VendorImportID
	LEFT JOIN dbo.ServiceLocation sl ON
		sl.VendorID = i.ServiceLocationID AND
		sl.VendorImportID = @VendorImportID
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @TargetPracticeID)
	LEFT JOIN #badappts bappts ON 
		i.AppointmentID = bappts.ApptID
WHERE i.PracticeID = @SourcePracticeID AND bappts.ApptID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into PracticeResource...'
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
SELECT DISTINCT
		  i.practiceresourcetypeid , -- PracticeResourceTypeID - int
          @TargetPracticeID , -- PracticeID - int
          i.resourcename , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
FROM dbo.[PracticeResource] i
WHERE i.resourcename <> '' AND NOT EXISTS (SELECT * FROM dbo.PracticeResource pr WHERE pr.ResourceName = i.resourcename AND pr.PracticeID = @TargetPracticeID) and i.practiceid = @SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmentReason...'
INSERT  INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
		  @TargetPracticeID , -- PracticeID - int
          i.Name , -- Name - varchar(128)
          i.DefaultDurationMinutes , -- DefaultDurationMinutes - int
          i.DefaultColorCode , -- DefaultColorCode - int
          i.[Description] , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[AppointmentReason] i
WHERE i.name <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE i.Name = ar.Name AND ar.PracticeID = @TargetPracticeID) and i.practiceid = @SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #apptreason
(
	appointmentid INT , 
	reasonname VARCHAR(50)
)

INSERT INTO #apptreason
	(appointmentid, reasonname)
SELECT DISTINCT
	atar.AppointmentID ,
	ar.Name
FROM dbo.[AppointmentReason] ar
INNER JOIN dbo.[AppointmentToAppointmentReason] atar ON
	ar.AppointmentReasonID = atar.AppointmentReasonID AND
	ar.PracticeID = @SourcePracticeID
INNER JOIN dbo.[Appointment] a ON 
	a.PracticeID = @SourcePracticeID AND
	a.AppointmentID = atar.AppointmentID
WHERE ar.PracticeID = @SourcePracticeID 

PRINT ''
PRINT 'Inserting Into Appointment to Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          sar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @TargetPracticeID  -- PracticeID - int
	FROM #apptreason ar
		INNER JOIN dbo.AppointmentReason sar ON
			sar.AppointmentReasonID = (SELECT MAX(AppointmentReasonID) FROM dbo.AppointmentReason sar2 
									  WHERE sar2.Name = ar.reasonname AND sar2.PracticeID = @TargetPracticeID) 
	INNER JOIN dbo.Appointment a ON 
		a.PracticeID = @TargetPracticeID AND
		ar.appointmentid = a.[Subject]
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #appttopracres
(
	appointmentid INT , 
	pracresourcename VARCHAR(50)
)

INSERT INTO #appttopracres
	(appointmentid, pracresourcename)
SELECT DISTINCT
	atr.AppointmentID ,
	pr.ResourceName
FROM dbo.[AppointmentToResource] atr
INNER JOIN dbo.[PracticeResource] pr ON
	atr.ResourceID = pr.PracticeResourceID  AND
	atr.PracticeID = @SourcePracticeID
INNER JOIN dbo.[Appointment] a ON 
	a.AppointmentID = atr.AppointmentID AND
	a.PracticeID = @SourcePracticeID
WHERE atr.AppointmentResourceTypeID = 2

PRINT ''
PRINT 'Inserting Into Appointment to Resource - Practice Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          2 , -- AppointmentResourceTypeID - int
          pr.PracticeResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @TargetPracticeID  -- PracticeID - int
FROM #appttopracres atpr
	INNER JOIN dbo.PracticeResource pr ON	
		pr.ResourceName = atpr.pracresourcename AND
		pr.PracticeID = @TargetPracticeID
	INNER JOIN dbo.Appointment a ON
		a.[Subject] = atpr.appointmentid AND
		a.PracticeID = @TargetPracticeID
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Resource - Doctor Resource'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
	      a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE WHEN d.DoctorID IS NULL THEN (SELECT MIN(DoctorID) FROM dbo.Doctor WHERE [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @TargetPracticeID)
		  ELSE d.DoctorID END, -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @TargetPracticeID  -- PracticeID - int
FROM dbo.[AppointmentToResource] i
	INNER JOIN dbo.Appointment a ON
		a.[Subject] = i.appointmentid AND
		a.PracticeID = @TargetPracticeID
	LEFT JOIN dbo.Doctor d ON
		i.resourceid = d.VendorID AND
		d.PracticeID = @TargetPracticeID
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE()) AND i.AppointmentResourceTypeID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #apptrecurappt (AppointmentID INT, RangeEndDate DATETIME)

INSERT INTO #apptrecurappt
        ( AppointmentID, RangeEndDate )
SELECT DISTINCT
		  i.AppointmentID, -- AppointmentID - int
          i.RangeEndDate  -- RangeEndDate - datetime
FROM dbo.Appointment i
INNER JOIN dbo.Appointment a ON 
	i.AppointmentID = a.[Subject] AND
    a.PracticeID = @TargetPracticeID  
WHERE i.PracticeID = @SourcePracticeID AND a.CreatedDate > DATEADD(mi,-5,GETDATE()) AND a.RangeEndDate IS NOT NULL

PRINT ''
PRINT 'Updating Appointment RangeEndDate...'
UPDATE dbo.Appointment
	SET RangeEndDate = i.RangeEndDate
FROM dbo.Appointment a 
INNER JOIN #apptrecurappt i ON
	i.AppointmentID = a.[Subject] AND
    a.PracticeID = @TargetPracticeID
WHERE a.PracticeID = @TargetPracticeID AND a.CreatedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated...'

USE superbill_37658_prod
GO 
DISABLE TRIGGER ALL ON dbo.AppointmentRecurrence
GO


DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 2
SET @SourcePracticeID = 1
SET @VendorImportID = 5

SET XACT_ABORT ON

PRINT ''
PRINT 'Inserting Into Appointment Recurrence...'
INSERT INTO dbo.AppointmentRecurrence
        ( AppointmentID ,
          Type ,
          WeeklyNumWeeks ,
          WeeklyOnSunday ,
          WeeklyOnMonday ,
          WeeklyOnTuesday ,
          WeeklyOnWednesday ,
          WeeklyOnThursday ,
          WeeklyOnFriday ,
          WeeklyOnSaturday ,
          DailyType ,
          DailyNumDays ,
          MonthlyType ,
          MonthlyNumMonths ,
          MonthlyDayOfMonth ,
          MonthlyWeekTypeOfMonth ,
          MonthlyTypeOfDay ,
          YearlyType ,
          YearlyDayTypeOfMonth ,
          YearlyTypeOfDay ,
          YearlyDayOfMonth ,
          YearlyMonth ,
          RangeType ,
          RangeEndOccurrences ,
          RangeEndDate ,
          ModifiedDate ,
          ModifiedUserID ,
          StartDate 
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          i.[Type] , -- Type - char(1)
          i.WeeklyNumWeeks , -- WeeklyNumWeeks - int
          i.WeeklyOnSunday , -- WeeklyOnSunday - bit
          i.WeeklyOnMonday , -- WeeklyOnMonday - bit
          i.WeeklyOnTuesday , -- WeeklyOnTuesday - bit
          i.WeeklyOnWednesday , -- WeeklyOnWednesday - bit
          i.weeklyonthursday , -- WeeklyOnThursday - bit
          i.WeeklyOnFriday , -- WeeklyOnFriday - bit
          i.WeeklyOnSaturday , -- WeeklyOnSaturday - bit
          i.DailyType , -- DailyType - char(1)
          i.DailyNumDays , -- DailyNumDays - int
          i.MonthlyType , -- MonthlyType - char(1)
          i.MonthlyNumMonths , --  - int
          i.MonthlyDayOfMonth , -- MonthlyDayOfMonth - int
          i.MonthlyWeekTypeOfMonth , -- MonthlyWeekTypeOfMonth - char(1)
          i.MonthlyTypeOfDay , -- MonthlyTypeOfDay - char(1)
          i.YearlyType , -- YearlyType - char(1)
          i.YearlyDayTypeOfMonth , -- YearlyDayTypeOfMonth - char(1)
          i.YearlyTypeOfDay , -- YearlyTypeOfDay - char(1)
          i.YearlyDayOfMonth , -- YearlyDayOfMonth - int
          i.YearlyMonth , -- YearlyMonth - int
          i.RangeType , -- RangeType - char(1)
          i.RangeEndOccurrences , -- RangeEndOccurrences - int
          a.RangeEndDate , -- RangeEndDate - datetime
          i.ModifiedDate , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.StartDate  -- StartDate - datetime
FROM dbo.[AppointmentRecurrence] i 
INNER JOIN dbo.Appointment a ON
	i.AppointmentID = a.[Subject] AND
	a.PracticeID = @TargetPracticeID 
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE()) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

USE superbill_37658_prod
GO
 ENABLE TRIGGER ALL ON dbo.AppointmentRecurrence
GO


USE superbill_37658_prod
GO
 DISABLE TRIGGER ALL ON dbo.AppointmentRecurrenceException
GO
SET XACT_ABORT ON

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 2
SET @SourcePracticeID = 1
SET @VendorImportID = 5

PRINT ''
PRINT 'Inserting Into Appointment Recurrence Exception...'
INSERT INTO dbo.AppointmentRecurrenceException
        ( AppointmentID ,
          ExceptionDate ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
	      a.AppointmentID , -- AppointmentID - int
          i.exceptiondate , -- ExceptionDate - datetime
          i.ModifiedDate , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[AppointmentRecurrenceException] i
INNER JOIN dbo.Appointment a ON 
	i.AppointmentID = a.[subject] AND
	a.PracticeID = @TargetPracticeID 
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

USE superbill_37658_prod
GO
ENABLE TRIGGER ALL ON dbo.AppointmentRecurrenceException
GO


DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 2
SET @SourcePracticeID = 1
SET @VendorImportID = 5
SET XACT_ABORT ON

PRINT ''
PRINT 'Inserting Into Appointment - Other...'
INSERT INTO dbo.Appointment
        ( 
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
          Recurrence ,
          RecurrenceStartDate ,
          RangeEndDate ,
          RangeType ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT 
          @TargetPracticeID , -- PracticeID - int
          CASE WHEN SL.ServiceLocationID IS NULL THEN SL2.ServiceLocationID ELSE SL.ServiceLocationID END , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.appointmenttype , -- AppointmentType - varchar(1)
          i.AppointmentID , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          i.ModifiedDate , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.appointmentresourcetypeid , -- AppointmentResourceTypeID - int
          i.appointmentconfirmationstatuscode , -- AppointmentConfirmationStatusCode - char(1)
		  i.AllDay ,
          i.recurrence ,
          i.RecurrenceStartDate ,
          NULL ,
          i.RangeType ,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[Appointment] i
	INNER JOIN dbo.DateKeyToPractice dk ON
        dk.[PracticeID] = @TargetPracticeID AND
        dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation sl ON
		sl.VendorID = i.ServiceLocationID AND
		sl.VendorImportID = @VendorImportID
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @TargetPracticeID)
	LEFT JOIN #badappts bappts ON 
		i.AppointmentID = bappts.ApptID
WHERE i.PracticeID = @SourcePracticeID AND bappts.ApptID IS NULL AND i.AppointmentType = 'O'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Resource - Doctor Resource - Other'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
	      a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE WHEN d.DoctorID IS NULL THEN (SELECT MIN(DoctorID) FROM dbo.Doctor WHERE [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @TargetPracticeID)
		  ELSE d.DoctorID END, -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @TargetPracticeID  -- PracticeID - int
FROM dbo.[AppointmentToResource] i
	INNER JOIN dbo.Appointment a ON
		a.[Subject] = i.appointmentid AND
		a.PracticeID = @TargetPracticeID
	LEFT JOIN dbo.Doctor d ON
		i.resourceid = d.VendorID AND
		d.PracticeID = @TargetPracticeID
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE()) AND i.AppointmentResourceTypeID = 1 AND a.AppointmentType = 'O'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Other Appointment...'
UPDATE a
	SET [Subject] = i.[Subject] , 
		RangeEndDate = i.RangeEndDate
FROM dbo.Appointment a 
	INNER JOIN dbo.Appointment i ON 
		a.[Subject] = i.AppointmentID AND 
		i.AppointmentType = 'O'
WHERE a.AppointmentType = 'O' AND a.PracticeID = @TargetPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DROP TABLE #tempdoc, #apptreason ,#appttopracres , #apptrecurappt , #badappts

--COMMIT 
--ROLLBACK

