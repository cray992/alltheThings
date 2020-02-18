USE superbill_14328_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 4
SET @VendorImportID = 3 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

/*
DELETE FROM dbo.InsurancePolicyAuthorization WHERE InsurancePolicyID IN (SELECT InsurancePolicyID FROM dbo.InsurancePolicy where PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy Auth records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource WHERE PracticeID = 3
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE PracticeID = 3
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @practiceid AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.AppointmentReason WHERE PracticeID = 3
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Reason deleted'
DELETE FROM dbo.PracticeResource WHERE PracticeID = 3
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Reason deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
*/



--PRINT ''
--PRINT 'Updating Insurance Company Records to Global Scope...'
--UPDATE dbo.InsuranceCompany 
--SET ReviewCode = 'R'
--FROM dbo.[_import_2_3_InsurancePolicy] i
--	INNER JOIN dbo.InsuranceCompanyPlan icp ON
--		i.insurancecompanyplanid = icp.InsuranceCompanyPlanID 
--	INNER JOIN dbo.InsuranceCompany ic ON
--		icp.InsuranceCompanyID = ic.InsuranceCompanyID
--WHERE icp.InsuranceCompanyID = ic.InsuranceCompanyID 
--PRINT CAST(@@Rowcount AS VARCHAR) + ' records updated'	


--PRINT ''
--PRINT 'Updating Insurance Company Plan Records to Global Scope...'
--UPDATE dbo.InsuranceCompanyPlan
--SET ReviewCode = 'R'
--FROM dbo.[_import_2_3_InsurancePolicy] i
--	INNER JOIN dbo.InsuranceCompanyPlan icp ON	
--		i.insurancecompanyplanid = icp.InsuranceCompanyPlanID
--PRINT CAST(@@Rowcount AS VARCHAR) + ' records updated'	



--SET IDENTITY_INSERT dbo.Patient ON
PRINT ''
PRINT 'Inserting records into patient'
INSERT INTO dbo.Patient
        ( --PatientID ,
		  PracticeID ,
       -- ReferringPhysicianID ,
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
      --  RecordTimeStamp ,
          EmploymentStatus ,
          InsuranceProgramCode ,
          PatientReferralSourceID ,   
      /*  PrimaryProviderID ,  
          DefaultServiceLocationID ,
          EmployerID ,   */
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
      --  PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt 
      /*  PatientGuid ,
          Ethnicity ,
          Race ,
          LicenseNumber 
          LicenseState ,
          Language1 ,
          Language2   */
        )
SELECT  DISTINCT 
          --ip.patientidvendorid , --patientID int
          @PracticeID , -- PracticeID - int
       -- ip.ReferringPhysicianID , -- ReferringPhysicianID - int
          ip.Prefix , -- Prefix - varchar(16)
          ip.firstname , -- FirstName - varchar(64)
          ip.middlename , -- MiddleName - varchar(64)
          ip.lastname , -- LastName - varchar(64)
          ip.suffix ,  -- Suffix - varchar(16)
          ip.addressline1 , -- AddressLine1 - varchar(256)
          ip.addressline2 , -- AddressLine2 - varchar(256)
          ip.city , -- City - varchar(128)
          ip.state , -- State - varchar(2)
          ip.Country , -- Country - varchar(32)   
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.zipcode,'-','')),9) , -- ZipCode - varchar(9)
          ip.gender  , -- Gender - varchar(1)
          ip.maritalstatus , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.homephone,' ','')),10) , -- HomePhone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.homephoneext,' ','')),10) , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.workphone,' ','')),10) , -- WorkPhone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.workphoneext,' ','')),10) , -- WorkPhoneExt - varchar(10)
          ip.dob  , -- DOB - datetime
		  CASE WHEN LEN(ip.ssn) >= 6 THEN RIGHT ('000' + ip.ssn , 9) ELSE '' END , -- SSN - char(9)
          ip.EmailAddress , -- EmailAddress - varchar(256) 
          ip.ResponsibleDifferentThanPatient , --  ResponsibleDifferentThanPatient - BIT ,
          ip.ResponsiblePrefix , -- ResponsiblePrefix - varchar(16)
          ip.ResponsibleFirstName , -- ResponsibleFirstName - varchar(64)
          ip.ResponsibleMiddleName , -- ResponsibleMiddleName - varchar(64)
          ip.ResponsibleLastName , -- ResponsibleLastName - varchar(64)  
          ip.ResponsibleSuffix , -- ResponsibleSuffix - varchar(16)
          ip.ResponsibleRelationshipToPatient , -- ResponsibleRelationshipToPatient - varchar(1)
          ip.ResponsibleAddressLine1 , -- ResponsibleAddressLine1 - varchar(256)
          ip.ResponsibleAddressLine2 , -- ResponsibleAddressLine2 - varchar(256)
          ip.ResponsibleCity , -- ResponsibleCity - varchar(128)
          ip.ResponsibleState , -- ResponsibleState - varchar(2)  
          ip.ResponsibleCountry , -- ResponsibleCountry - varchar(32)
          ip.ResponsibleZipCode , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          ip.EmploymentStatus , -- EmploymentStatus - char(1)
          CASE WHEN ip.InsuranceProgramCode='' THEN NULL ELSE ip.InsuranceProgramCode END , -- InsuranceProgramCode - char(2)
          CASE WHEN ip.PatientReferralSourceID ='' THEN NULL ELSE ip.PatientReferralSourceID END, -- PatientReferralSourceID - int
      /*  CASE WHEN ip.PrimaryProviderID = '' THEN NULL ELSE ip.PrimaryProviderID END , -- PrimaryProviderID - int
          sl.ServiceLocationID  , -- DefaultServiceLocationID - int
          ip.EmployerID  , -- EmployerID - int   */
          ip.MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.MobilePhone,' ','')),10) ,  -- MobilePhone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.MobilePhoneExt,' ','')),10) , -- MobilePhoneExt - varchar(10)
     --   CASE WHEN ip.PrimaryCarePhysicianID = '' THEN NULL ELSE ip.PrimaryCarePhysicianID END , -- PrimaryCarePhysicianID - int
          ip.patientidvendorid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          ip.CollectionCategoryID , -- CollectionCategoryID - int
          ip.Active , -- Active - bit
          ip.SendEmailCorrespondence , -- SendEmailCorrespondence - bit
          ip.PhonecallRemindersEnabled , -- PhonecallRemindersEnabled - bit
          ip.EmergencyName , -- EmergencyName - varchar(128)
          ip.EmergencyPhone ,    -- EmergencyPhone - varchar(10)
          ip.EmergencyPhoneExt  -- EmergencyPhoneExt - varchar(10)
      /*  NULL , -- PatientGuid - uniqueidentifier
          '' , -- Ethnicity - varchar(64)
          '' , -- Race - varchar(64)
          '' ,  -- LicenseNumber - varchar(64)
          '' , -- LicenseState - varchar(2)
          '' , -- Language1 - varchar(64)
          ''  -- Language2 - varchar(64)    */
FROM dbo.[_import_2_3_Patient] as ip
/*INNER JOIN dbo.ServiceLocation AS sl ON
     sl.ServiceLocationID = ip.defaultservicelocationid AND 
	 sl.PracticeID = @PracticeID   */
WHERE ip.patientidvendorid<>'' --AND NOT EXISTS (select * FROM dbo.Patient AS p WHERE p.PatientID = ip.patientidvendorid)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'

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
          pjn.Hidden , -- Hidden - bit
          pjn.NoteMessage , -- NoteMessage - varchar(max)
          pjn.AccountStatus , -- AccountStatus - bit
          pjn.NoteTypeCode , -- NoteTypeCode - int
          pjn.LastNote  -- LastNote - bit
FROM dbo.[_import_2_3_PatientJournalNote] AS pjn 
INNER JOIN dbo.Patient AS p ON
    p.VendorID = pjn.PatientID AND
	p.VendorImportID = @VendorImportID     
WHERE pjn.PatientID <> '' AND pjn.SoftwareApplicationID <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into PatientJournalNote Successfully'

PRINT ''
PRINT 'Inserting into PatientCase'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
      --  ReferringPhysicianID ,
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
          patcase.Active , -- Active - bit
          patcase.PayerScenarioID , -- PayerScenarioID - int
      --  '' , -- ReferringPhysicianID - int
          patcase.EmploymentRelatedFlag , -- EmploymentRelatedFlag - bit
          patcase.AutoAccidentRelatedFlag , -- AutoAccidentRelatedFlag - bit
          patcase.OtherAccidentRelatedFlag , -- OtherAccidentRelatedFlag - bit
          patcase.AbuseRelatedFlag , -- AbuseRelatedFlag - bit
          patcase.AutoAccidentRelatedState , -- AutoAccidentRelatedState - char(2)
          patcase.Notes , -- Notes - text
          patcase.ShowExpiredInsurancePolicies , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          patcase.CaseNumber , -- CaseNumber - varchar(128)
          CASE WHEN patcase.WorkersCompContactInfoID = '' THEN NULL ELSE patcase.WorkersCompContactInfoID END , -- WorkersCompContactInfoID - int
          patcase.PatientCaseIDVendorID , -- VendorID - varchar(50)
          @VendorImportID ,  -- VendorImportID - int
          patcase.PregnancyRelatedFlag , -- PregnancyRelatedFlag - bit
          patcase.StatementActive , -- StatementActive - bit
          patcase.EPSDT , -- EPSDT - bit
          patcase.FamilyPlanning , -- FamilyPlanning - bit
          CASE WHEN patcase.EPSDTCodeID ='' THEN NULL ELSE patcase.EPSDTCodeID END , -- EPSDTCodeID - int
          patcase.EmergencyRelated , -- EmergencyRelated - bit
          patcase.HomeboundRelatedFlag  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_2_3_PatientCase] as patcase
INNER JOIN dbo.Patient AS pat ON
    pat.VendorID = patcase.patientid AND
    pat.PracticeID = @practiceID and
	pat.vendorimportid = @vendorimportid
WHERE patcase.PatientCaseIDVendorID <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase'


PRINT ''
PRINT 'Inserting Into InsurancePolicy ' 
--IF NOT Exists (select * from dbo.InsurancePolicy where policynumber='AJI888680296431' AND PracticeID=@practiceID)
--BEGIN

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
          iip.HolderThroughEmployer , -- HolderThroughEmployer - bit
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
          iip.Active , -- Active - bit
          @PracticeID , -- PracticeID - int
          iip.AdjusterPrefix , -- AdjusterPrefix - varchar(16)
          iip.AdjusterFirstName , -- AdjusterFirstName - varchar(64)
          iip.AdjusterMiddleName , -- AdjusterMiddleName - varchar(64)
          iip.AdjusterLastName , -- AdjusterLastName - varchar(64)
          iip.AdjusterSuffix , -- AdjusterSuffix - varchar(16)  
          iip.insurancepolicyidvendorid , -- VendorID - varchar(50)
          @VendorImportID ,  -- VendorImportID - int
        --iip.InsuranceProgramTypeID , -- InsuranceProgramTypeID - int
          iip.GroupName , -- GroupName - varchar(14)
          iip.ReleaseOfInformation  -- ReleaseOfInformation - varchar(1)
       /* NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_2_3_InsurancePolicy] AS iip
INNER JOIN dbo.PatientCase AS patcase ON
      patcase.VendorID=iip.patientcaseid AND 
	  patcase.VendorImportID = @VendorImportID
WHERE iip.insurancepolicyidvendorid <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy '

PRINT''
PRINT 'Inserting Into InsurancePolicyAuthorization ' 
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
       --   RecordTimeStamp ,
          AuthorizedNumberOfVisitsUsed ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
          ip.InsurancePolicyID , -- InsurancePolicyID - int
          iaz.AuthorizationNumber , -- AuthorizationNumber - varchar(65)
          iaz.AuthorizedNumberOfVisits , -- AuthorizedNumberOfVisits - int
          iaz.StartDate , -- StartDate - datetime
          iaz.EndDate , -- EndDate - datetime
          iaz.ContactFullname , -- ContactFullname - varchar(65)
          iaz.ContactPhone , -- ContactPhone - varchar(10)
          iaz.ContactPhoneExt , -- ContactPhoneExt - varchar(10)
          iaz.AuthorizationStatusID , -- AuthorizationStatusID - int
          iaz.Notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
     --   iaz.recordtimestamp , -- RecordTimeStamp - timestamp
          iaz.AuthorizedNumberOfVisitsUsed , -- AuthorizedNumberOfVisitsUsed - int
          iaz.InsurancePolicyAuthorizationID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_3_InsurancePolicyAuthorization] AS iaz 
INNER JOIN dbo.InsurancePolicy ip ON
	ip.VendorID = iaz.insurancepolicyid AND
	ip.VendorImportID = @VendorImportID
WHERE iaz.InsurancePolicyID <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into InsurancePolicyAuthorization '

PRINT''
PRINT 'Inserting Into PracticeResource' 
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
SELECT DISTINCT
          ipr.PracticeResourceTypeID , -- PracticeResourceTypeID - int
          @PracticeID, -- PracticeID - int 
          ipr.ResourceName , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
FROM dbo.[_import_2_3_PracticeResource] as ipr
WHERE ipr.PracticeResourceTypeID <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Practice Resource '

PRINT ''
PRINT 'Inserting into AppointmentReason'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
      --  TIMESTAMP ,
      --  AppointmentReasonGuid
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          ar.name , -- Name - varchar(128)
          ar.defaultdurationminutes , -- DefaultDurationMinutes - int
          ar.DefaultColorCode , -- DefaultColorCode - int
          ar.Description , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
     --   NULL , -- TIMESTAMP - timestamp
     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
FROM [dbo].[_import_2_3_AppointmentReason] as ar
WHERE ar.name <> '' 
--AND NOT EXISTS (select * from dbo.AppointmentReason ar where ar.name = ims.appointmenttype)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into AppointmentReason'

PRINT ''
PRINT'Inserting records into Appointment'
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
      --  RecordTimeStamp ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
          AllDay ,
          InsurancePolicyAuthorizationID ,
      --  PatientCaseID ,
          Recurrence ,
          RecurrenceStartDate ,
          RangeEndDate ,
          RangeType ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
      --  AppointmentGuid
        )
SELECT  DISTINCT  
          pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          7 , -- ServiceLocationID - int /*<-------This was in the instructions to select the first integer for the PracticeID ---------*/
          ia.startdate , -- StartDate - datetime
          ia.enddate , -- EndDate - datetime
          ia.AppointmentType , -- AppointmentType - varchar(1)
          ia.appointmentsubject , -- Subject - varchar(64)
          ia.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          ia.AppointmentResourceTypeID , -- AppointmentResourceTypeID - int
          ia.AppointmentConfirmationStatusCode , -- AppointmentConfirmationStatusCode - char(1)
          ia.AllDay , -- AllDay - bit
          ia.InsurancePolicyAuthorizationID , -- InsurancePolicyAuthorizationID - int
      --  ia.PatientCaseID , -- PatientCaseID - int
          0 , -- Recurrence - bit
          ia.RecurrenceStartDate , -- RecurrenceStartDate - datetime
          ia.RangeEndDate , -- RangeEndDate - datetime
          ia.RangeType , -- RangeType - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID  , -- EndDKPracticeID - int
          ia.StartTm , -- StartTm - smallint
          ia.EndTm -- EndTm - smallint
      --  NULL  -- AppointmentGuid - uniqueidentifier
FROM [dbo].[_import_2_3_Appointment] as ia
INNER JOIN dbo.patient AS pat ON
  pat.VendorID = ia.patientid AND
  pat.VendorImportID = @VendorImportID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.VendorID = ia.patientcaseid AND
  patcase.VendorImportID = @VendorImportID  
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(ia.startdate AS date) AS DATETIME) 
WHERE ia.appointmentsubject<>'' --and NOT EXISTS (select * from dbo.appointment as dboa where dboa.subject = ims.appointmentid)  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted into Appointment Successfully'


PRINT ''
PRINT 'Inserting into Appointment To Appointment Reason'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
	  --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT
          dboa.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
	  --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM [dbo].[_import_2_3_Appointment] as ia
INNER JOIN dbo.Appointment AS dboa ON
    dboa.Subject = ia.appointmentsubject AND
    dboa.PracticeID = @PracticeID AND
    dboa.startdate = CAST(ia.startdate AS DATETIME) AND 
    dboa.enddate = CAST(ia.enddate AS DATETIME) 
INNER JOIN dbo.AppointmentReason AS ar ON 
    ar.Name = ia.appointmentreason AND 
    ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted AppointmentToAppointmentReason'

PRINT ''
PRINT 'Inserting records into AppointmenttoResource Type 2 '
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
      --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT 
          dboa.AppointmentID , -- AppointmentID - int
          iar.AppointmentResourceTypeID , -- AppointmentResourceTypeID - int
          iar.ResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM [dbo].[_import_2_3_AppointmentToResource] as iar 
INNER JOIN dbo.Appointment AS dboa ON
    dboa.Subject = iar.appointmentsubject AND
    dboa.PracticeID = @PracticeID 
    /*dboa.startdate = CAST(ia.startdate AS DATETIME) AND 
    dboa.enddate = CAST(ia.enddate AS DATETIME) */
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'


PRINT ''
PRINT 'Inserting records into AppointmenttoResource Type 1 '
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
      --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT 
          dboa.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          25 , -- ResourceID - int  **************************************************** UPDATE TO ACTIVE DOCTORID FOR PRACTICEID 4
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_3_Appointment] ia
INNER JOIN dbo.Appointment AS dboa ON
    dboa.Subject = ia.appointmentsubject AND
    dboa.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'


 
--ROLLBACK
--COMMIT TRANSACTION
--        PRINT 'COMMITTED SUCCESSFULLY'





