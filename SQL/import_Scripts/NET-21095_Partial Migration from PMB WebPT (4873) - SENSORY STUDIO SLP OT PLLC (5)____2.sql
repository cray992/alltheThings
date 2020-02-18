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
SET @VendorImportID = 8

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
--PhonecallRemindersEnabled ,
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
NULL,--rd.doctorID , – ReferringPhysicianID - int
'' , -- Prefix - varchar(16)
p.FirstName , -- FirstName - varchar(64)
'',--p.MiddleName , – MiddleName - varchar(64)
p.LastName , -- LastName - varchar(64)
'',--p.Suffix , – Suffix - varchar(16)
p.addressline1 , -- AddressLine1 - varchar(256)
p.addressline2 , -- AddressLine2 - varchar(256)
p.city , -- City - varchar(128)
p.State , -- State - varchar(2)
NULL,--p.Country , – Country - varchar(32)
CASE 
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(p.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(p.zipcode)
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(p.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(p.zipcode)
ELSE '' END , -- ZipCode - varchar(9)
p.Gender , -- Gender - varchar(1)
NULL,-- p.MaritalStatus , – MaritalStatus - varchar(1)
CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.homephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(P.homephone),10)
ELSE '' END, -- HomePhone - varchar(10)
NULL,--p.HomePhoneExt , – HomePhoneExt - varchar(10)
CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(P.workphone),10)
ELSE '' END, -- WorkPhone - varchar(10)
NULL,--p.WorkExtension , – WorkPhoneExt - varchar(10)
p.Dateofbirth , -- DOB - datetime
CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.ssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(P.SSN), 9)
ELSE NULL END , -- SSN - char(9)
p.emailaddress , -- EmailAddress - varchar(256)
CASE 
WHEN p.guarantorlastname='' THEN 0
ELSE 1
end , -- ResponsibleDifferentThanPatient - bit
nuLL, --p.ResponsiblePrefix , -- ResponsiblePrefix - varchar(16)
p.ResponsiblepartyFirstName , -- ResponsibleFirstName - varchar(64)
p.guarantormiddlename , -- ResponsibleMiddleName - varchar(64)
p.guarantorlastname , -- ResponsibleLastName - varchar(64)
p.guarantorsuffix , -- ResponsibleSuffix - varchar(16)
p.guarantorrelationshiptopatient , -- ResponsibleRelationshipToPatient - varchar(1)
p.guarantoraddressline1 , -- ResponsibleAddressLine1 - varchar(256)
p.guarantoraddressline2,  -- ResponsibleAddressLine2 - varchar(256)
p.guarantorcity , -- ResponsibleCity - varchar(128)
p.guarantorstate , -- ResponsibleState - varchar(2)
NULL, --p.ResponsiblepartyCountry , -- ResponsibleCountry - varchar(32)
p.guarantorzip , -- ResponsibleZipCode - varchar(9)
GETDATE() , -- CreatedDate - datetime
0 , -- CreatedUserID - int
GETDATE() , -- ModifiedDate - datetime
0 , -- ModifiedUserID - int
NULL, --p.EmploymentStatus , – EmploymentStatus - char(1)
NULL,--p.insuranceprogramcode , – InsuranceProgramCode - char(2)
NULL, --prs.PatientReferralSourceID , – PatientReferralSourceID - int
NULL,--pp.DoctorID , – PrimaryProviderID - int
NULL,--CASE WHEN sl.ServiceLocationID IS NULL THEN (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @TargetPracticeID) ELSE sl.ServiceLocationID END , – DefaultServiceLocationID - int
NULL, --emp.EmployerID , – EmployerID - int
P.id , -- MedicalRecordNumber - varchar(128)
CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.mobilephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(P.mobilephone),10)
ELSE '' END, -- MobilePhone - varchar(10)
NULL, --p.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
NULL,--pcp.DoctorID , – PrimaryCarePhysicianID - int
P.id , -- VendorID - varchar(50)
@VendorImportID , -- VendorImportID - int
Null , -- CollectionCategoryID - int
1 , -- Active - bit
NULL , -- SendEmailCorrespondence - bit
-- PhonecallRemindersEnabled - bit
EmergencyName, -- varchar(128)
EmergencyPhone, -- varchar(10)
EmergencyPhoneExt, -- varchar(10)
NULL, --Ethnicity - varchar(64)
NULL, --Race - varchar(64)
NULL , -- LicenseNumber - varchar(64)
NULL , -- LicenseState - varchar(2)
Null , -- Language1 - varchar(64)
NULL -- Language2 - varchar(64)
		  --select*
FROM dbo._import_1_2_patientDemographics P
WHERE --p.PracticeID = @SourcePracticeID 
NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dateofbirth AND pp.PracticeID = @TargetPracticeID) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--USE superbill_63317_dev
--SELECT * FROM dbo.Patient

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
pa.patientalertmessage , -- AlertMessage - text
1 , -- ShowInPatientFlag - bit
1 , -- ShowInAppointmentFlag - bit
1 , -- ShowInEncounterFlag - bit
GETDATE() , -- CreatedDate - datetime
0 , -- CreatedUserID - int
GETDATE() , -- ModifiedDate - datetime
0 , -- ModifiedUserID - int
1, -- ShowInClaimFlag - bit
1 , -- ShowInPaymentFlag - bit
1 -- ShowInPatientStatementFlag - bit
FROM dbo._import_106_56_patientdemographics pa
INNER JOIN dbo.Patient p ON
p.VendorImportID = @VendorImportID AND
p.VendorID = pa.chartnumber
WHERE pa.patientalertmessage <>''
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
          pc.patientfullname ,
          pc.active  ,
          CASE 
			pc.financialclass
			WHEN 'Medicaid' THEN 8
			WHEN 'Medical' THEN 8
			WHEN 'Cash' THEN 11
			WHEN 'Cash Patient' THEN 11
			WHEN 'HMO' THEN 18
			WHEN 'PI Lien' THEN 1
			WHEN 'P.I. Lien' THEN 1
			WHEN '' THEN 11
			ELSE ps.PayerScenarioID
			END
			,
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
FROM _imp pc
INNER JOIN dbo.Patient p ON
pc.id = p.VendorID AND
p.VendorImportID = @VendorImportID

INNER JOIN dbo.PayerScenario ps ON 
ps.
SELECT * FROM dbo.PayerScenario

left JOIN dbo.PayerScenario ps ON pc.financialclass=ps.Name

WHERE p.CreatedDate > DATEADD(mi,-1,GETDATE())
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
		  --rollback
		--SELECT * FROM dbo.InsuranceCompanyPlan ORDER BY PlanName
		  --SELECT * 
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