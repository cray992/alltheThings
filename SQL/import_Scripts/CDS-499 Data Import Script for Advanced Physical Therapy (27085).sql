USE superbill_27085_dev
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 2
SET @VendorImportID = 1 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

/*
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
*/


PRINT ''
PRINT 'Updating Insurance Company Records to Global Scope...'
UPDATE dbo.InsuranceCompany 
SET ReviewCode = 'R'
FROM dbo.[_import_1_2_InsurancePolicy] i
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
FROM dbo.[_import_1_2_InsurancePolicy] i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON	
		i.insurancecompanyplanid = icp.InsuranceCompanyPlanID
WHERE icp.ReviewCode <> 'R'
PRINT CAST(@@Rowcount AS VARCHAR) + ' records updated'	


PRINT ''
PRINT 'Updating Existing Provider Records with VendorID...'
UPDATE dbo.Doctor 
	SET VendorID = i.providerid
FROM dbo.Doctor d
INNER JOIN dbo.[_import_1_2_Providers] i ON
	d.FirstName = i.firstname AND
	d.LastName = i.lastname AND
	d.NPI = i.npi
WHERE d.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Inserting Into Referring Doctor...'
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
          WorkPhone ,
          MobilePhone ,
          DOB ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          [External] ,
          NPI 
        )
SELECT DISTINCT  
		  @PracticeID , -- PracticeID - int
          i.prefix , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          i.middlename , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          i.suffix , -- Suffix - varchar(16)
          i.ssn , -- SSN - varchar(9)
          i.addressline1 , -- AddressLine1 - varchar(256)
          i.addressline2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.zipcode , -- ZipCode - varchar(9)
          i.homephone , -- HomePhone - varchar(10)
          i.workphone , -- WorkPhone - varchar(10)
          i.mobilephone , -- MobilePhone - varchar(10)
          i.dob , -- DOB - datetime
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          i.providerid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- External - bit
          i.npi  -- NPI - varchar(10)
FROM dbo.[_import_1_2_Providers] i WHERE providertype = 'Referring' 
								 AND NOT EXISTS
									(SELECT * FROM dbo.Doctor d 
									 WHERE i.providerid = d.VendorID AND d.PracticeID = @PracticeID)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          --EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          rp.DoctorID , -- ReferringPhysicianID - int
          i.prefix , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          i.middlename , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          i.suffix , -- Suffix - varchar(16)
          i.addressline1 , -- AddressLine1 - varchar(256)
          i.addressline2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          LEFT(i.[state] ,2) , -- State - varchar(2)
          i.country , -- Country - varchar(32)
          i.zipcode , -- ZipCode - varchar(9)
          i.gender , -- Gender - varchar(1)
          i.maritalstatus  , -- MaritalStatus - varchar(1)
          i.homephone , -- HomePhone - varchar(10)
          i.homephoneext , -- HomePhoneExt - varchar(10)
          i.workphone , -- WorkPhone - varchar(10)
          i.workphoneext , -- WorkPhoneExt - varchar(10)
          i.dob , -- DOB - datetime
          i.ssn , -- SSN - char(9)
          i.emailaddress , -- EmailAddress - varchar(256)
          CASE WHEN i.responsibledifferentthanpatient = '-1' THEN 1 ELSE i.responsibledifferentthanpatient END , -- ResponsibleDifferentThanPatient - bit
          i.responsibleprefix , -- ResponsiblePrefix - varchar(16)
          i.responsiblefirstname , -- ResponsibleFirstName - varchar(64)
          i.responsiblemiddlename , -- ResponsibleMiddleName - varchar(64)
          i.responsiblelastname , -- ResponsibleLastName - varchar(64)
          i.responsiblesuffix, -- ResponsibleSuffix - varchar(16)
          i.responsiblerelationshiptopatient , -- ResponsibleRelationshipToPatient - varchar(1)
          i.responsibleaddressline1 , -- ResponsibleAddressLine1 - varchar(256)
          i.responsibleaddressline2 , -- ResponsibleAddressLine2 - varchar(256)
          i.responsiblecity , -- ResponsibleCity - varchar(128)
          i.responsiblestate , -- ResponsibleState - varchar(2)
          i.responsiblecountry, -- ResponsibleCountry - varchar(32)
          i.responsiblezipcode , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          i.employmentstatus , -- EmploymentStatus - char(1)
          CASE WHEN i.primaryproviderid <> '' THEN drp.DoctorID END , -- PrimaryProviderID - int
          CASE WHEN i.defaultservicelocationid = '2' THEN 3 ELSE NULL END , -- DefaultServiceLocationID - int
          --CASE WHEN i.employerid <> '' THEN i.employerid END , -- EmployerID - int
          i.medicalrecordnumber , -- MedicalRecordNumber - varchar(128)
          i.mobilephone , -- MobilePhone - varchar(10)
          i.mobilephoneext , -- MobilePhoneExt - varchar(10)
          i.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE i.active WHEN '-1' THEN 1 ELSE i.active END , -- Active - bit
          CASE i.sendemailcorrespondence WHEN '-1' THEN 1 ELSE i.sendemailcorrespondence END , -- SendEmailCorrespondence - bit
          i.emergencyname , -- EmergencyName - varchar(128)
          i.emergencyphone , -- EmergencyPhone - varchar(10)
          i.emergencyphoneext  -- EmergencyPhoneExt - varchar(10)
FROM dbo.[_import_1_2_Patient] i
LEFT JOIN dbo.Doctor rp ON
	rp.VendorID = i.referringphysicianid AND 
	rp.PracticeID = @PracticeID AND
	rp.VendorID <> ''
LEFT JOIN dbo.Doctor pcp ON
	pcp.VendorID = i.primarycarephysicianid AND
	pcp.PracticeID = @PracticeID AND
	pcp.VendorID <> ''
LEFT JOIN dbo.Doctor drp ON
	drp.VendorID = i.primaryproviderid AND
	drp.PracticeID = @PracticeID AND
	drp.[External] = 0 AND
	drp.VendorID <> ''
WHERE NOT EXISTS (SELECT FirstName, LastName, DOB FROM dbo.Patient p 
					WHERE i.firstname = p.FirstName AND 
						  i.lastname = p.LastName AND
						  DATEADD(hh,12,CAST(DOB AS DATETIME)) = p.DOB AND
						  p.PracticeID = @PracticeID)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--PRINT ''
--PRINT 'Inserting Into Patient Alert...'
--INSERT INTO dbo.PatientAlert
--        ( PatientID ,
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
--SELECT DISTINCT		
--		  p.PatientID ,
--          i.AlertMessage ,
--          CASE WHEN i.ShowInPatientFlag = '-1' THEN 1 ELSE i.ShowInPatientFlag END ,
--          CASE WHEN i.ShowInAppointmentFlag = '-1' THEN 1 ELSE i.ShowInAppointmentFlag END,
--          CASE WHEN i.ShowInEncounterFlag = '-1'THEN 1 ELSE i.ShowInEncounterFlag END,
--          GETDATE() ,
--          -50 ,
--          GETDATE() ,
--          -50 ,
--          CASE WHEN i.ShowInClaimFlag = '-1' THEN 1 ELSE i.ShowInClaimFlag END ,
--          CASE WHEN i.ShowInPaymentFlag = '-1' THEN 1 ELSE i.ShowInPaymentFlag END,
--          CASE WHEN i.ShowInPatientStatementFlag = '-1' THEN 1 ELSE i.ShowInPatientStatementFlag END
--FROM dbo.[_import_1_2_PatientAlert] i
--INNER JOIN dbo.Patient p ON
--	i.patientid = p.vendorid AND
--	p.VendorImportID = @VendorImportID
--WHERE i.alertmessage <> ''
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting into PatientJournalNote'
INSERT INTO dbo.PatientJournalNote
        ( 
		  CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  timestamp ,
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
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
     --   '' , -- timestamp - timestamp
          p.patientid , -- PatientID - int
          pjn.UserName , -- UserName - varchar(128)
          pjn.SoftwareApplicationID , -- SoftwareApplicationID - char(1)
          CASE pjn.Hidden WHEN '-1' THEN 1 ELSE pjn.hidden END , -- Hidden - bit
          pjn.NoteMessage , -- NoteMessage - varchar(max)
          CASE pjn.AccountStatus WHEN '-1' THEN 1 ELSE pjn.AccountStatus END , -- bit
          pjn.NoteTypeCode , -- NoteTypeCode - int
          CASE pjn.LastNote WHEN '-1' THEN 1 ELSE pjn.lastnote END -- LastNote - bit
FROM dbo.[_import_1_2_PatientJournalNote] AS pjn 
INNER JOIN dbo.Patient AS p ON
    p.VendorID = pjn.PatientID AND
	p.VendorImportID = @VendorImportID     
WHERE pjn.PatientID <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into PatientJournalNote Successfully'


PRINT ''
PRINT 'Inserting into PatientCase'
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
SELECT DISTINCT
          pat.patientid , -- PatientID - int
          patcase.Name , -- Name - varchar(128)
          CASE WHEN patcase.ACTIVE = '-1' THEN 1 ELSE patcase.ACTIVE END , -- Active - bit
          patcase.PayerScenarioID , -- PayerScenarioID - int
          d.DoctorID , -- ReferringPhysicianID - int
          CASE patcase.EmploymentRelatedFlag WHEN '-1' THEN 1 ELSE patcase.employmentrelatedflag END , -- EmploymentRelatedFlag - bit
          CASE patcase.AutoAccidentRelatedFlag WHEN '-1' THEN 1 ELSE patcase.autoaccidentrelatedflag END , -- AutoAccidentRelatedFlag - bit
          CASE patcase.OtherAccidentRelatedFlag WHEN '-1' THEN 1 ELSE patcase.otheraccidentrelatedflag END, -- OtherAccidentRelatedFlag - bit
          CASE patcase.AbuseRelatedFlag WHEN '-1' THEN 1 ELSE patcase.abuserelatedflag END , -- AbuseRelatedFlag - bit
          patcase.autoaccidentrelatedstate , -- AutoAccidentRelatedState - char(2)
          patcase.Notes , -- Notes - text
          CASE patcase.ShowExpiredInsurancePolicies WHEN '-1' THEN 1 ELSE patcase.showexpiredinsurancepolicies END , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          patcase.CaseNumber , -- CaseNumber - varchar(128)
          CASE WHEN patcase.WorkersCompContactInfoID = '' THEN NULL ELSE patcase.WorkersCompContactInfoID END , -- WorkersCompContactInfoID - int
          patcase.PatientCaseID , -- VendorID - varchar(50)
          @VendorImportID ,  -- VendorImportID - int
          CASE patcase.PregnancyRelatedFlag WHEN '-1' THEN 1 ELSE patcase.pregnancyrelatedflag END , -- PregnancyRelatedFlag - bit
          CASE patcase.StatementActive WHEN '-1' THEN 1 ELSE patcase.StatementActive END , -- StatementActive - bit
          CASE patcase.EPSDT WHEN '-1' THEN 1 ELSE patcase.epsdt END , -- EPSDT - bit
          CASE patcase.FamilyPlanning WHEN '-1' THEN 1 ELSE patcase.familyplanning END , -- FamilyPlanning - bit
          CASE WHEN patcase.EPSDTCodeID = '' THEN NULL ELSE patcase.EPSDTCodeID END , -- EPSDTCodeID - int
          CASE patcase.EmergencyRelated WHEN '-1' THEN 1 ELSE patcase.emergencyrelated END , -- EmergencyRelated - bit
          CASE patcase.HomeboundRelatedFlag WHEN '-1' THEN 1 ELSE patcase.homeboundrelatedflag END -- HomeboundRelatedFlag - bit
FROM dbo.[_import_1_2_PatientCase] as patcase
INNER JOIN dbo.Patient AS pat ON
    pat.VendorID = patcase.patientid AND
    pat.PracticeID = @practiceID and
	pat.vendorimportid = @vendorimportid
LEFT JOIN dbo.Doctor d ON
	d.VendorID = patcase.referringphysicianid AND
	d.PracticeID = @PracticeID
WHERE patcase.PatientCaseID <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase'


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
		  @PracticeID , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          i.patientcasedatetypeid , -- PatientCaseDateTypeID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_2_PatientCaseDate] i
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = i.patientcaseid AND
	pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into InsurancePolicy ' 
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
      --  RecordTimeStamp ,
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
       -- InsuranceProgramTypeID ,
          GroupName ,
          ReleaseOfInformation 
     /*   SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patcase.PatientCaseID , -- PatientCaseID - int
          iip.insurancecompanyplanid , -- InsuranceCompanyPlanID - int
          iip.Precedence , -- Precedence - int
          iip.PolicyNumber , -- PolicyNumber - varchar(32)
          iip.GroupNumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(iip.PolicyStartDate) = 1 THEN iip.policystartdate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(iip.PolicyEndDate) = 1 THEN iip.policyenddate ELSE NULL END , -- PolicyEndDate - datetime
          iip.CardOnFile , -- CardOnFile - bit
          iip.PatientRelationshipToInsured , -- PatientRelationshipToInsured - varchar(1)
          iip.HolderPrefix , -- HolderPrefix - varchar(16)
          iip.HolderFirstName , -- HolderFirstName - varchar(64)
          iip.HolderMiddleName , -- HolderMiddleName - varchar(64)
          iip.HolderLastName , -- HolderLastName - varchar(64)
          iip.HolderSuffix , -- HolderSuffix - varchar(16)
          iip.HolderDOB , -- HolderDOB - datetime
          iip.HolderSSN , -- HolderSSN - char(11)
          CASE WHEN iip.HolderThroughEmployer = '-1' THEN 1 ELSE iip.holderthroughemployer END , -- HolderThroughEmployer - bit
          iip.HolderEmployerName , -- HolderEmployerName - varchar(128)
          iip.PatientInsuranceStatusID , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          iip.HolderGender , -- HolderGender - char(1)
          iip.HolderAddressLine1 , -- HolderAddressLine1 - varchar(256)
          iip.HolderAddressLine2 , -- HolderAddressLine2 - varchar(256)
          iip.HolderCity , -- HolderCity - varchar(128)
          iip.HolderState , -- HolderState - varchar(2)  
          iip.HolderCountry , -- HolderCountry - varchar(32)
          iip.HolderZipCode , -- HolderZipCode - varchar(9)
          iip.HolderPhone , -- HolderPhone - varchar(10)
          iip.HolderPhoneExt , -- HolderPhoneExt - varchar(10)
          iip.DependentPolicyNumber , -- DependentPolicyNumber - varchar(32)
          iip.Notes , -- Notes - text
          iip.Phone , -- Phone - varchar(10)
          iip.PhoneExt , -- PhoneExt - varchar(10)
          iip.Fax , -- Fax - varchar(10)
          iip.FaxExt , -- FaxExt - varchar(10)
          iip.Copay , -- Copay - money
          iip.Deductible , -- Deductible - money
          iip.PatientInsuranceNumber , -- PatientInsuranceNumber - varchar(32)
          CASE WHEN iip.ACTIVE = '-1' THEN 1 ELSE iip.ACTIVE END , -- Active - bit
          @PracticeID , -- PracticeID - int
          iip.AdjusterPrefix , -- AdjusterPrefix - varchar(16)
          iip.AdjusterFirstName , -- AdjusterFirstName - varchar(64)
          iip.AdjusterMiddleName , -- AdjusterMiddleName - varchar(64)
          iip.AdjusterLastName , -- AdjusterLastName - varchar(64)
          iip.AdjusterSuffix , -- AdjusterSuffix - varchar(16)  
          iip.insurancepolicyid , -- VendorID - varchar(50)
          @VendorImportID ,  -- VendorImportID - int
        --iip.InsuranceProgramTypeID , -- InsuranceProgramTypeID - int
          iip.GroupName , -- GroupName - varchar(14)
          iip.ReleaseOfInformation  -- ReleaseOfInformation - varchar(1)
       /* NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_1_2_InsurancePolicy] AS iip
INNER JOIN dbo.PatientCase AS patcase ON
      patcase.VendorID=iip.patientcaseid AND 
	  patcase.VendorImportID = @VendorImportID
WHERE iip.insurancepolicyid <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy '


PRINT ''
PRINT 'Inserting Into Insuance Policy Authorization...'
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
          CASE WHEN ISDATE(i.startdate) = 1 THEN i.startdate ELSE NULL END , -- StartDate - datetime
          CASE WHEN ISDATE(i.enddate) = 1 THEN i.startdate ELSE NULL END , -- EndDate - datetime
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
FROM dbo.[_import_1_2_InsurancePolicyAuthorization] i
INNER JOIN dbo.InsurancePolicy ip ON
	ip.VendorID = i.insurancepolicyid AND
	ip.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




--ROLLBACK
--COMMIT

