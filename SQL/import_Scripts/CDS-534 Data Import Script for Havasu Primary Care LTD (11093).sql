USE superbill_11093_dev
--USE superbill_11093_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Insurance Company Records to Global Scope...'
UPDATE dbo.InsuranceCompany 
SET ReviewCode = 'R'
FROM dbo.[_import_2_2_InsurancePolicy] i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		i.insurancecompanyplanid = icp.InsuranceCompanyPlanID 
	INNER JOIN dbo.InsuranceCompany ic ON
		icp.InsuranceCompanyID = ic.InsuranceCompanyID
WHERE icp.InsuranceCompanyID = ic.InsuranceCompanyID AND icp.ReviewCode <> 'R'
PRINT CAST(@@Rowcount AS VARCHAR) + ' records updated'	

PRINT ''
PRINT 'Updating Insurance Company Plan Records to Global Scope...'
UPDATE dbo.InsuranceCompanyPlan
SET ReviewCode = 'R'
FROM dbo.[_import_2_2_InsurancePolicy] i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON	
		i.insurancecompanyplanid = icp.InsuranceCompanyPlanID
WHERE icp.ReviewCode <> 'R'
PRINT CAST(@@Rowcount AS VARCHAR) + ' records updated'	

UPDATE dbo.Doctor 
SET VendorID = 2 
WHERE DoctorID = 4

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
FROM dbo.[_import_2_2_Patient] p
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
FROM dbo.[_import_2_2_PatientCase] pc
	INNER JOIN dbo.Patient p ON 
		pc.patientid = p.VendorID AND
		p.VendorImportID = @VendorImportID 
	LEFT JOIN dbo.Doctor rp ON 
		pc.referringphysicianid = rp.VendorID AND
		rp.PracticeID = @PracticeID
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
          CASE WHEN pjn.Hidden = '-1' THEN 1 ELSE pjn.hidden END ,
          pjn.NoteMessage ,
          pjn.AccountStatus ,
          pjn.NoteTypeCode ,
          CASE WHEN pjn.LastNote = '-1' THEN 1 ELSE pjn.lastnote END
FROM dbo.[_import_2_2_PatientJournalNote] pjn
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
          ip.insurancecompanyplanid ,
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
FROM dbo.[_import_2_2_InsurancePolicy] ip
	INNER JOIN dbo.PatientCase pc ON 
		ip.patientcaseid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
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
FROM dbo.[_import_2_2_InsurancePolicyAuthorization] i
INNER JOIN dbo.InsurancePolicy ip ON
	i.insurancepolicyid = ip.VendorID AND
	ip.VendorImportID = @VendorImportID
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
          @PracticeID , -- PracticeID - int
          i.resourcename , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
FROM dbo.[_import_2_2_PracticeResource] i
WHERE NOT EXISTS (SELECT * FROM dbo.PracticeResource pr WHERE pr.ResourceName = i.resourcename AND pr.PracticeID = @PracticeID) AND i.resourcename <> ''
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
		  @PracticeID , -- PracticeID - int
          i.Name , -- Name - varchar(128)
          i.DefaultDurationMinutes , -- DefaultDurationMinutes - int
          i.DefaultColorCode , -- DefaultColorCode - int
          i.[Description] , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_2_2_AppointmentReason] i
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE i.Name = ar.Name AND ar.PracticeID = @PracticeID) AND i.name <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          InsurancePolicyAuthorizationID ,
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          CASE WHEN sl.ServiceLocationID IS NULL THEN sl2.ServiceLocationID ELSE sl.ServiceLocationID END  , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.appointmenttype , -- AppointmentType - varchar(1)
          i.appointmentid + i.subject , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.appointmentresourcetypeid , -- AppointmentResourceTypeID - int
          i.appointmentconfirmationstatuscode , -- AppointmentConfirmationStatusCode - char(1)
          ipa.InsurancePolicyAuthorizationID , -- InsurancePolicyAuthorizationID - int
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_2_2_Appointment] i
	INNER JOIN dbo.Patient p ON
		p.VendorID = i.patientid AND
		p.VendorImportID = @VendorImportID
	LEFT JOIN dbo.PatientCase pc ON
		pc.VendorID = i.patientcaseid AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.DateKeyToPractice dk ON
        dk.[PracticeID] = @PracticeID AND
        dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
	LEFT JOIN dbo.InsurancePolicyAuthorization ipa ON
		ipa.VendorID = i.insurancepolicyauthorizationid AND
		ipa.VendorImportID = @VendorImportID
	LEFT JOIN dbo.ServiceLocation sl ON 
		i.servicelocationid = sl.VendorID AND 
		sl.PracticeID = @PracticeID
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment - Other...'
INSERT INTO dbo.Appointment
        ( --PatientID ,
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
          InsurancePolicyAuthorizationID ,
          --PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  --p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          CASE WHEN sl.ServiceLocationID IS NULL THEN sl2.ServiceLocationID ELSE sl.ServiceLocationID END , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.appointmenttype , -- AppointmentType - varchar(1)
          i.appointmentid + ' ' + i.[subject] , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.appointmentresourcetypeid , -- AppointmentResourceTypeID - int
          i.appointmentconfirmationstatuscode , -- AppointmentConfirmationStatusCode - char(1)
          ipa.InsurancePolicyAuthorizationID , -- InsurancePolicyAuthorizationID - int
          --pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_2_2_Appointment] i
	INNER JOIN dbo.DateKeyToPractice dk ON
        dk.[PracticeID] = @PracticeID AND
        dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
	LEFT JOIN dbo.InsurancePolicyAuthorization ipa ON
		ipa.VendorID = i.insurancepolicyauthorizationid AND
		ipa.VendorImportID = @VendorImportID
	LEFT JOIN dbo.ServiceLocation sl ON 
		i.servicelocationid = sl.VendorID AND 
		sl.PracticeID = @PracticeID
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
	
WHERE i.patientid = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_2_Appointment] i
	INNER JOIN dbo.Appointment a ON
		a.[Subject] = i.appointmentid + ' ' + i.subject AND
		a.PracticeID = @PracticeID
	INNER JOIN dbo.AppointmentReason ar ON
		ar.Name = i.appointmentreason AND
		ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_2_Appointment] i
	INNER JOIN dbo.Appointment a ON
		a.[Subject] = i.appointmentid + ' ' + i.subject AND
		a.PracticeID = @PracticeID
	INNER JOIN dbo.PracticeResource pr ON	
		pr.ResourceName = i.practiceresource AND
		pr.PracticeID = @PracticeID
WHERE i.practiceresource <> ''
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
          i.providerresource , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_2_Appointment] i
	INNER JOIN dbo.Appointment a ON
		a.[Subject] = i.appointmentid + ' ' + i.subject AND
		a.PracticeID = @PracticeID
WHERE i.providerresource <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--ROLLBACK
--COMMIT


