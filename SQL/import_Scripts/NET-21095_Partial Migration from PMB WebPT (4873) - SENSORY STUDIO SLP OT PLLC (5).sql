USE superbill_63317_dev
GO
--rollback
--commit
SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 2
SET @SourcePracticeID = 5
SET @VendorImportID = 17

SET NOCOUNT ON 


--ALTER TABLE dbo.ContractsAndFees_StandardFee ADD vendorimportid VARCHAR(10)
--ALTER TABLE dbo.ContractsAndFees_StandardFeeSchedule ADD vendorimportid VARCHAR(10)
--ALTER TABLE dbo.ContractsAndFees_StandardFeeScheduleLink ADD vendorimportid VARCHAR(10)
--ALTER TABLE dbo.Appointment ADD lastname VARCHAR(30),firstname VARCHAR(30),dob datetime


--------UPDATE dp 
--------SET dp.DOB = rp.DOB
--------FROM superbill_4873_restore.dbo.patient rp 
--------INNER JOIN superbill_4873_dev.dbo.Patient dp
--------	ON rp.PatientID = dp.PatientID

--------USE superbill_63317_dev
--------GO
--------UPDATE dp 
--------SET dp.DOB = rp.DOB
--------FROM superbill_63317_restore.dbo.patient rp 
--------INNER JOIN superbill_63317_dev.dbo.Patient dp
--------	ON rp.PatientID = dp.PatientID

--UPDATE a SET 
--a.planname='Blue Cross Blue Shield-2'
--FROM dbo.InsuranceCompanyPlan a 
--WHERE a.InsuranceCompanyPlanID=58

--UPDATE a SET 
--a.planname='GHI-2'
--FROM dbo.InsuranceCompanyPlan a 
--WHERE a.InsuranceCompanyPlanID=28

--UPDATE a SET 
--a.planname='GHI-3'
--FROM dbo.InsuranceCompanyPlan a 
--WHERE a.InsuranceCompanyPlanID=29

--UPDATE a SET 
--a.planname='UNITED HEALTH CARE-2'
--FROM dbo.InsuranceCompanyPlan a 
--WHERE a.InsuranceCompanyPlanID=21


--UPDATE a SET 
----SELECT * 
--a.lastname=p.LastName,
--a.firstname=p.FirstName,
--a.dob=p.DOB
--FROM dbo.Patient p 
--INNER JOIN dbo.Appointment a ON 
--	a.PatientID=p.PatientID
--WHERE p.PracticeID=5 

--SELECT * FROM dbo.Appointment WHERE PracticeID=5

--SELECT * FROM dbo.Patient


PRINT 'Source PracticeID = ' + CAST(@SourcePracticeID AS VARCHAR) 
PRINT 'Target PracticeID = ' + CAST(@TargetPracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR) 
--rollback


PRINT ''
PRINT 'Updating Insurance Company Review Code...'
UPDATE dbo.InsuranceCompany 
	SET ReviewCode = 'R'
FROM superbill_4873_dev.dbo.InsuranceCompany ic 
INNER JOIN superbill_4873_dev.dbo.InsuranceCompanyPlan icp ON 
	ic.InsuranceCompanyID = icp.InsuranceCompanyID 
INNER JOIN superbill_4873_dev.dbo.InsurancePolicy ip ON 
	ip.PracticeID = @SourcePracticeID AND 
	icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
WHERE ic.ReviewCode = '' OR ic.ReviewCode IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Company Plan Review Code...'
UPDATE dbo.InsuranceCompanyPlan  
	SET ReviewCode = 'R'
FROM superbill_4873_dev.dbo.InsuranceCompanyPlan icp 
INNER JOIN superbill_4873_dev.dbo.InsurancePolicy ip ON 
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
FROM superbill_4873_dev.dbo.Doctor d 
WHERE d.PracticeID = @SourcePracticeID 

PRINT ''
PRINT 'Updating Existing Rendering Doctor Records with VendorID...'
UPDATE dbo.Doctor 
	SET VendorID = i.DoctorID
FROM superbill_4873_dev.dbo.Doctor d
INNER JOIN #tempdoc i ON
	i.FirstName = d.FirstName AND
    i.LastName = d.LastName AND
    i.NPI = d.NPI 
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Existing Referring Doctor Records with VendorID...'
UPDATE dbo.Doctor 
	SET VendorID = i.DoctorID
FROM superbill_4873_dev.dbo.Doctor d
INNER JOIN #tempdoc i ON
	i.FirstName = d.FirstName AND
    i.LastName = d.LastName AND
    i.NPI = d.NPI 
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 1
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
FROM superbill_4873_dev.dbo.[Doctor] i WHERE i.PracticeID = @SourcePracticeID AND i.[External] = 1 AND
NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE d.VendorID = i.DoctorID AND d.PracticeID = @TargetPracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


CREATE TABLE #tempemp
( id INT , NAME VARCHAR(128))

INSERT INTO #tempemp
        ( id, NAME )
SELECT DISTINCT
		  e.EmployerID, -- id - int
          oe.EmployerName  -- NAME - varchar(128)
FROM superbill_4873_dev.dbo.[Employers] e 
INNER JOIN superbill_4873_dev.dbo.Employers oe ON
	oe.EmployerName = e.EmployerName

CREATE TABLE #tempsl
( id INT , NAME VARCHAR(128))

INSERT INTO #tempsl
        ( id, NAME )
SELECT DISTINCT
		  sl.ServiceLocationID, -- id - int
          osl.Name  -- NAME - varchar(128)
FROM superbill_4873_dev.dbo.ServiceLocation sl 
INNER JOIN superbill_4873_dev.dbo.ServiceLocation osl ON
	osl.Name = sl.Name and
	OSl.PracticeID = @SourcePracticeID
WHERE sl.PracticeID = @TargetPracticeID

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
          --DefaultServiceLocationID ,
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
          --CASE WHEN sl.ServiceLocationID IS NULL THEN (SELECT MIN(ServiceLocationID) FROM superbill_4873_dev.dbo.ServiceLocation s WHERE s.PracticeID = @TargetPracticeID) ELSE sl.ServiceLocationID END , -- DefaultServiceLocationID - int
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
FROM superbill_4873_dev.dbo.[Patient] p
LEFT JOIN superbill_4873_dev.dbo.Doctor pp ON
	p.primaryproviderid = pp.VendorID AND
	pp.PracticeID = @TargetPracticeID
LEFT JOIN superbill_4873_dev.dbo.Doctor rd ON 
	p.referringphysicianid = rd.VendorID AND 
	rd.PracticeID = @TargetPracticeID
LEFT JOIN superbill_4873_dev.dbo.Doctor pcp ON	
	p.primarycarephysicianid = pcp.VendorID  AND
	pcp.PracticeID = @TargetPracticeID
LEFT JOIN dbo.#tempemp te ON
	p.EmployerID = te.id 
LEFT JOIN superbill_4873_dev.dbo.Employers emp ON
	emp.EmployerID = (SELECT TOP 1 emp2.EmployerID FROM superbill_4873_dev.dbo.Employers emp2 WHERE te.NAME = emp2.EmployerName)
LEFT JOIN dbo.#tempsl tsl ON
	p.DefaultServiceLocationID = tsl.id 
LEFT JOIN superbill_4873_dev.dbo.ServiceLocation sl ON
	tsl.NAME = sl.Name AND
    sl.PracticeID = @TargetPracticeID
WHERE p.PracticeID = @SourcePracticeID 
AND NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--USE superbill_63317_dev
--SELECT * FROM dbo.Patient

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
FROM superbill_4873_dev.dbo.[PatientJournalNote] pjn
	INNER JOIN superbill_63317_dev.dbo.Patient p ON
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
		--select * 
FROM superbill_4873_dev.dbo.[PatientCase] pc
	INNER JOIN superbill_63317_dev.dbo.Patient p ON 
		pc.patientid = p.PatientID AND
		p.VendorImportID = @VendorImportID
	LEFT JOIN superbill_63317_dev.dbo.Doctor d ON 
		pc.ReferringPhysicianID = d.VendorID AND 
	    d.PracticeID = @TargetPracticeID
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

		--SELECT * FROM dbo.InsuranceCompanyPlan ORDER BY PlanName
		  --SELECT * 
FROM superbill_4873_dev.dbo.[InsurancePolicy] ip
	INNER JOIN superbill_63317_dev.dbo.PatientCase pc ON 
		ip.patientcaseid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID

FROM dbo._import_1_2_patientDemographics ip 
INNER JOIN dbo._import_1_2_Insurancecompanyplanlist icpl ON ip.insurancecode1=icpl.insuranceid
INNER JOIN dbo.PatientCase pc ON ip.chartnumber = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON icpl.planname = icp.PlanName AND CreatedPracticeID=@TargetPracticeID
LEFT JOIN dbo.InsurancePolicy ipo ON ipo.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID AND ipo.PracticeID=@TargetPracticeID 
AND ipo.PatientCaseID=pc.PatientCaseID AND policynumber1=ipo.PolicyNumber
WHERE ipo.InsurancePolicyID IS NULL

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT''
PRINT'Insert Into ContractsAndFees_StandardFeeSchedule...'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
(
    PracticeID,
    Name,
    Notes,
    EffectiveStartDate,
    SourceType,
    SourceFileName,
    EClaimsNoResponseTrigger,
    PaperClaimsNoResponseTrigger,
    MedicareFeeScheduleGPCICarrier,
    MedicareFeeScheduleGPCILocality,
    MedicareFeeScheduleGPCIBatchID,
    MedicareFeeScheduleRVUBatchID,
    AddPercent,
    AnesthesiaTimeIncrement,
	vendorimportid
)
SELECT DISTINCT 
    @TargetPracticeID,         -- PracticeID - int
    fs.Name,        -- Name - varchar(128)
    fs.Notes,        -- Notes - varchar(1024)
    GETDATE(), -- EffectiveStartDate - datetime
    fs.SourceType,        -- SourceType - char(1)
    fs.SourceFileName,        -- SourceFileName - varchar(256)
    fs.EClaimsNoResponseTrigger,         -- EClaimsNoResponseTrigger - int
    fs.PaperClaimsNoResponseTrigger,         -- PaperClaimsNoResponseTrigger - int
    fs.MedicareFeeScheduleGPCICarrier,         -- MedicareFeeScheduleGPCICarrier - int
    fs.MedicareFeeScheduleGPCILocality,         -- MedicareFeeScheduleGPCILocality - int
    fs.MedicareFeeScheduleGPCIBatchID,         -- MedicareFeeScheduleGPCIBatchID - int
    fs.MedicareFeeScheduleRVUBatchID,         -- MedicareFeeScheduleRVUBatchID - int
    fs.AddPercent,      -- AddPercent - decimal(18, 0)
    fs.AnesthesiaTimeIncrement,          -- AnesthesiaTimeIncrement - int
    @vendorimportid
   --select *  
FROM superbill_4873_dev.dbo.ContractsAndFees_StandardFeeSchedule fs
WHERE fs.PracticeID=@SourcePracticeID AND fs.Name = 'Standard Fees'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'
SELECT * FROM dbo.ContractsAndFees_StandardFeeSchedule
--rollback
--commit

PRINT''
PRINT'Insert Into ContractsAndFees_StandardFee...'
INSERT INTO dbo.ContractsAndFees_StandardFee
(
    StandardFeeScheduleID,
    ProcedureCodeID,
    ModifierID,
    SetFee,
    AnesthesiaBaseUnits,
	vendorimportid
)
SELECT 
    1,--(SELECT a.StandardFeeScheduleID FROM superbill_4873_dev.dbo.ContractsAndFees_StandardFeeSchedule a WHERE a.PracticeID=2 AND a.Name='Standard Fees'),    -- StandardFeeScheduleID - int
    sf.ProcedureCodeID,    -- ProcedureCodeID - int
    sf.ModifierID,    -- ModifierID - int
    sf.SetFee, -- SetFee - money
    sf.AnesthesiaBaseUnits,     -- AnesthesiaBaseUnits - int
    @VendorImportID

--select * 
FROM superbill_4873_dev.dbo.ContractsAndFees_StandardFee sf 
	INNER JOIN superbill_4873_dev.dbo.ContractsAndFees_StandardFeeSchedule sfs ON sfs.StandardFeeScheduleID=sf.StandardFeeScheduleID
WHERE sf.StandardFeeScheduleID=sfs.StandardFeeScheduleID AND sfs.PracticeID=5

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT''
PRINT'Insert Into ContractsAndFees_StandardFeeScheduleLink...'

INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
(
    ProviderID,
    LocationID,
    StandardFeeScheduleID,
	vendorimportid
)
SELECT DISTINCT 
    doc.doctorid, -- ProviderID - int
    sl.ServiceLocationID, -- LocationID - int
    sfs.StandardFeeScheduleID,  -- StandardFeeScheduleID - int
    2


FROM superbill_4873_dev.dbo.Doctor doc 
	INNER JOIN superbill_4873_dev.dbo.ServiceLocation sl ON sl.practiceid=doc.PracticeID
	INNER JOIN superbill_4873_dev.dbo.ContractsAndFees_StandardFeeSchedule sfs ON sfs.StandardFeeScheduleID = 1
WHERE doc.[External]<>1 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink  WHERE standardfeeschedulelinkid = 8
--SELECT * FROM dbo.ContractsAndFees_StandardFeeSchedule
--SELECT * FROM dbo.ContractsAndFees_ContractRateSchedule

DROP TABLE #tempdoc
DROP TABLE #tempemp
DROP TABLE #tempsl


--COMMIT
--ROLLBACK

USE superbill_4873_dev
--SELECT * FROM dbo.ContractsAndFees_StandardFeeScheduleLink
--SELECT * FROM superbill_4873_dev.dbo.Appointment WHERE PracticeID=5

--SELECT * FROM dbo.Patient

--select * 
--FROM superbill_4873_dev.dbo.[PatientCase] pc
--	INNER JOIN superbill_4873_dev.dbo.Patient p ON 
--		pc.patientid = p.PatientID AND
--		p.VendorImportID = 2 
--	LEFT JOIN superbill_4873_dev.dbo.Doctor d ON 
--		pc.ReferringPhysicianID = d.VendorID AND 
--	    d.PracticeID = 2

		--SELECT * FROM superbill_4873_dev.dbo.[PatientCase] pc