USE superbill_31891_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
/*
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from InsurancePolicy' 
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Insurance Company Plan'
DELETE FROM dbo.PracticeToInsuranceCompany WHERE PracticeID =@practiceID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from PracticeToInsuranceCompany'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from Insurance'
DELETE FROM dbo.PatientCaseDate
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCase'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientAlert'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientJournalNotes'
DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Doctor'
DELETE FROM dbo.servicelocation WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from servicelocation'
*/
PRINT ''
PRINT 'Inserting records into Insurance Company'
--SET IDENTITY_INSERT dbo.InsuranceCompany OFF
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
          ProviderNumberTypeID ,
          GroupNumberTypeID ,
          LocalUseProviderNumberTypeID ,
          CompanyTextID ,
          ClearinghousePayerID ,   
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      /*  KareoInsuranceCompanyID ,
          KareoLastModifiedDate ,
          RecordTimeStamp ,  */  
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
          ic.InsuranceCompanyName , -- InsuranceCompanyName - varchar(128)
          ic.Notes , -- Notes - text
          ic.addressline1 , -- AddressLine1 - varchar(256)
          ic.addressline2 , -- AddressLine2 - varchar(256)
          ic.city , -- City - varchar(128)
          ic.state , -- State - varchar(2) */ 
          '' , -- Country - varchar(32)
          CASE WHEN LEN(ic.zipcode) = 4 THEN '0' + ic.zipcode ELSE LEFT(ic.zipcode, 9) END ,  -- ZipCode - varchar(9)  
          ic.ContactPrefix , -- ContactPrefix - varchar(16)
          ic.ContactFirstName , -- ContactFirstName - varchar(64)
          ic.ContactMiddleName , -- ContactMiddleName - varchar(64)
          ic.ContactLastName , -- ContactLastName - varchar(64) 
          ic.ContactSuffix , -- ContactSuffix - varchar(16)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ic.phone,' ','')),10)  , -- Phone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ic.phoneext,' ','')),10) , -- PhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ic.fax,' ','')),10) , -- Fax - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ic.faxext,' ','')),10) , -- FaxExt - varchar(10)  
          ic.BillSecondaryInsurance , -- BillSecondaryInsurance - bit
          ic.EClaimsAccepts , -- EClaimsAccepts - bit
          ic.BillingFormID , -- BillingFormID - int
          ic.InsuranceProgramCode , -- InsuranceProgramCode - char(2)
          ic.HCFADiagnosisReferenceFormatCode , -- HCFADiagnosisReferenceFormatCode - char(1)
          ic.HCFASameAsInsuredFormatCode , -- HCFASameAsInsuredFormatCode - char(1)
          ic.LocalUseFieldTypeCode , -- LocalUseFieldTypeCode - char(5)
          ic.ReviewCode , -- ReviewCode - char(1)
          CASE WHEN ic.ProviderNumberTypeID = '' THEN NULL ELSE ic.ProviderNumberTypeID END , -- ProviderNumberTypeID - int
          CASE WHEN ic.GroupNumberTypeID = '' THEN NULL ELSE ic.GroupNumberTypeID END , -- GroupNumberTypeID - int
          CASE WHEN ic.LocalUseProviderNumberTypeID = '' THEN NULL ELSE ic.LocalUseProviderNumberTypeID END , -- LocalUseProviderNumberTypeID - int
          ic.CompanyTextID , -- CompanyTextID - varchar(10)
          ic.ClearinghousePayerID , -- ClearinghousePayerID - int 
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  0 , -- KareoInsuranceCompanyID - int
      --  GETDATE() , -- KareoLastModifiedDate - datetime
      --  NULL , -- RecordTimeStamp - timestamp
          ic.SecondaryPrecedenceBillingFormID , -- SecondaryPrecedenceBillingFormID - int
          ic.insurancecompanyID,-- VendorID - varchar(50)  
          @VendorImportID , -- VendorImportID - int
          CASE WHEN ic.DefaultAdjustmentCode = '' THEN NULL ELSE ic.DefaultAdjustmentCode END, -- DefaultAdjustmentCode - varchar(10)
          ic.ReferringProviderNumberTypeID , -- ReferringProviderNumberTypeID - int
          ic.NDCFormat , -- NDCFormat - int
          ic.UseFacilityID , -- UseFacilityID - bit
          ic.AnesthesiaType , -- AnesthesiaType - varchar(1)
          ic.InstitutionalBillingFormID  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceCompany] as ic
WHERE ic.insurancecompanyname<>''  
--SET IDENTITY_INSERT dbo.InsuranceCompany OFF
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company'

PRINT ''
PRINT 'Inserting records into PracticetoInsuranceCompany'
INSERT INTO dbo.PracticeToInsuranceCompany
        ( PracticeID ,
          InsuranceCompanyID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimestamp ,
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
          @practiceID , -- PracticeID - int
          inscom.insurancecompanyID , -- InsuranceCompanyID --  int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimestamp - timestamp
          pic.EClaimsProviderID , -- EClaimsProviderID - varchar(32)
          pic.EClaimsEnrollmentStatusID , -- EClaimsEnrollmentStatusID - int
          pic.EClaimsDisable , -- EClaimsDisable - int
          pic.AcceptAssignment , -- AcceptAssignment - bit
          pic.UseSecondaryElectronicBilling , -- UseSecondaryElectronicBilling - bit
          pic.UseCoordinationOfBenefits , -- UseCoordinationOfBenefits - bit
          pic.ExcludePatientPayment , -- ExcludePatientPayment - bit
          pic.BalanceTransfer  -- BalanceTransfer - bit
FROM dbo.[_import_1_1_PracticeToInsuranceCompany] as pic
INNER JOIN dbo.InsuranceCompany AS inscom ON
    inscom.VendorID = pic.insurancecompanyid AND
    inscom.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into PracticeToInsuranceCompany'

PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
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
          MM_CompanyID ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReviewCode ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          InsuranceCompanyID ,
          ADS_CompanyID ,
          Copay ,
          Deductible ,  
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
          icp.planname , -- PlanName - varchar(128)
          icp.AddressLine1 , -- AddressLine1 - varchar(256)
          icp.AddressLine2 , -- AddressLine2 - varchar(256)
          icp.city , -- City - varchar(128)
          icp.state , -- State - varchar(2)  
          '' , -- Country - varchar(32)
          CASE WHEN LEN(icp.zipcode) = 4 THEN '0' + icp.zipcode ELSE LEFT(icp.zipcode, 9) END , -- ZipCode - varchar(9)
          icp.ContactPrefix , -- ContactPrefix - varchar(16)
          icp.ContactFirstName , -- ContactFirstName - varchar(64)
          icp.ContactMiddleName , -- ContactMiddleName - varchar(64)
          icp.ContactLastName , -- ContactLastName - varchar(64)  
          icp.ContactSuffix , -- ContactSuffix - varchar(16)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(icp.phone,' ','')),10) , -- Phone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(icp.phoneext,' ','')),10) , -- PhoneExt - varchar(10)
          icp.Notes , -- Notes - text
          icp.MMCompanyID , -- MM_CompanyID - varchar(10)  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          icp.ReviewCode , -- ReviewCode - char(1)
          @practiceID , -- CreatedPracticeID - int
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(icp.fax,' ','')),10) , -- Fax - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(icp.faxext,' ','')),10) , -- FaxExt - varchar(10)
          inscom.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.ADSCompanyID , -- ADS_CompanyID - varchar(10)
          icp.Copay , -- Copay - money
          icp.Deductible , -- Deductible - money   
          icp.insurancecompanyplanID, -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo._import_1_1_InsuranceCompanyPlan as icp
INNER JOIN dbo.InsuranceCompany AS inscom ON
  inscom.VendorID = icp.insurancecompanyid 
  AND inscom.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company plan'

PRINT ''
PRINT 'Inserting records into ServiceLocation'
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
      --  RecordTimeStamp ,
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
      --  ServiceLocationGuid 
        )
SELECT  DISTINCT
          @PracticeID , -- PracticeID - int
          sl.name , -- Name - varchar(128)
          sl.Addressline1 , -- AddressLine1 - varchar(256)
          sl.Addressline2 , -- AddressLine2 - varchar(256)
          sl.City , -- City - varchar(128)
          sl.State , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(sl.zipcode) = 4 THEN '0' + sl.zipcode ELSE LEFT(sl.zipcode, 9) END  , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          sl.PlaceOfServiceCode , -- PlaceOfServiceCode - char(2)
          sl.BillingName , -- BillingName - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(sl.phone,' ','')),10) , -- Phone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(sl.phoneext,' ','')),10) , -- PhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(sl.faxphone,' ','')),10) , -- FaxPhone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(sl.faxphoneext,' ','')),10) , -- FaxPhoneExt - varchar(10)
          sl.HCFABox32FacilityID , -- HCFABox32FacilityID - varchar(50)
          sl.CLIANumber , -- CLIANumber - varchar(30)
          sl.RevenueCode , -- RevenueCode - varchar(4)
          @VendorImportID , -- VendorImportID - int
          sl.servicelocationid , -- VendorID - int
          sl.NPI , -- NPI - varchar(10)
          sl.FacilityIDType , -- FacilityIDType - int
          sl.TimeZoneID , -- TimeZoneID - int
          sl.PayToName , -- PayToName - varchar(25)
          sl.PayToAddressLine1 , -- PayToAddressLine1 - varchar(256)
          sl.PayToAddressLine2 , -- PayToAddressLine2 - varchar(256)
          sl.PayToCity , -- PayToCity - varchar(128)
          sl.PayToState , -- PayToState - varchar(2)
          sl.PayToCountry , -- PayToCountry - varchar(32)
          sl.PayToZipCode , -- PayToZipCode - varchar(9)
          sl.PayToPhone , -- PayToPhone - varchar(10)
          sl.PayToPhoneExt , -- PayToPhoneExt - varchar(10)
          sl.PayToFax , -- PayToFax - varchar(10)
          sl.PayToFaxExt , -- PayToFaxExt - varchar(10)
          sl.EIN , -- EIN - varchar(9)
          CASE WHEN sl.BillTypeID ='' THEN NULL ELSE sl.billtypeid END  -- BillTypeID - int
      --  NULL  -- ServiceLocationGuid - uniqueidentifier  
FROM [dbo].[_import_1_1_ServiceLocation] as sl
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into Service Location Successfully'

SET IDENTITY_INSERT dbo.Patient ON
PRINT ''
PRINT 'Inserting records into patient'
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
       -- RecordTimeStamp ,
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
          EmergencyPhoneExt 
      --  PatientGuid ,
      --  Ethnicity ,
      --  Race ,
      --  LicenseNumber 
      --  LicenseState ,
      --  Language1 ,
      --  Language2
        )
SELECT  DISTINCT
          ip.patientID , -- patientID - int
          @PracticeID , -- PracticeID - int
          CASE ip.referringphysicianid WHEN 1 THEN 1 ELSE NULL END, -- ReferringPhysicianID - int
          ip.prefix , -- Prefix - varchar(16)
          ip.firstname , -- FirstName - varchar(64)
          ip.middlename , -- MiddleName - varchar(64)
          ip.lastname , -- LastName - varchar(64)
          ip.suffix ,  -- Suffix - varchar(16)
          ip.addressline1 , -- AddressLine1 - varchar(256)
          ip.addressline2 , -- AddressLine2 - varchar(256)
          ip.city , -- City - varchar(128)
          ip.state , -- State - varchar(2)
          '' , -- Country - varchar(32)   
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
          CASE WHEN ip.InsuranceProgramCode='' THEN NULL ELSE ip.insuranceprogramcode END , -- InsuranceProgramCode - char(2)
          CASE WHEN ip.PatientReferralSourceID ='' THEN NULL ELSE ip.patientreferralsourceid END, -- PatientReferralSourceID - int
          CASE WHEN ip.primaryproviderid = 1 THEN 1 ELSE NULL END  , -- PrimaryProviderID - int     **********   Here we have '' and 1 values in import sheet   **********
          CASE WHEN ip.defaultservicelocationid = 1 THEN 1 ELSE sl.ServiceLocationID END , -- DefaultServiceLocationID - int
         -- ip.EmployerID  , -- EmployerID - int
          ip.MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.mobilephone,' ','')),10) ,  -- MobilePhone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.mobilephoneext,' ','')),10) , -- MobilePhoneExt - varchar(10)
          CASE WHEN ip.primarycarephysicianid = 1 THEN 1 ELSE NULL END ,   -- PrimaryCarePhysicianID - int   **********   Here we have '' and 1 values in import sheet   **********
          ip.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          ip.CollectionCategoryID , -- CollectionCategoryID - int
          ip.Active , -- Active - bit
          ip.SendEmailCorrespondence , -- SendEmailCorrespondence - bit
          ip.PhonecallRemindersEnabled , -- PhonecallRemindersEnabled - bit
          ip.EmergencyName , -- EmergencyName - varchar(128)
          ip.EmergencyPhone ,    -- EmergencyPhone - varchar(10)
          ip.EmergencyPhoneExt  -- EmergencyPhoneExt - varchar(10)
      --  NULL , -- PatientGuid - uniqueidentifier
      --  '' , -- Ethnicity - varchar(64)
      --  '' , -- Race - varchar(64)
      --  '' ,  -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  ''  -- Language2 - varchar(64)
FROM dbo.[_import_1_1_Patient] as ip
LEFT JOIN dbo.ServiceLocation AS sl ON
     sl.VendorID = ip.defaultservicelocationid AND 
	 sl.PracticeID = @PracticeID
/*INNER JOIN dbo.Doctor AS doc ON
    doc.DoctorID = ip.primaryproviderid AND
	doc.PracticeID = @practiceid   */
WHERE ip.patientid<>'' AND NOT EXISTS (SELECT * FROM dbo.Patient p WHERE p.PatientID = ip.patientid)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'
SET IDENTITY_INSERT dbo.Patient OFF


PRINT ''
PRINT 'Inserting into PatientJournalNote'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
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
SELECT 
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
     --   '' , -- timestamp - timestamp
          pjn.patientid , -- PatientID - int
          pjn.username , -- UserName - varchar(128)
          pjn.softwareapplicationid , -- SoftwareApplicationID - char(1)
          pjn.hidden , -- Hidden - bit
          pjn.notemessage , -- NoteMessage - varchar(max)
          pjn.accountstatus , -- AccountStatus - bit
          pjn.notetypecode , -- NoteTypeCode - int
          pjn.lastnote  -- LastNote - bit
FROM dbo.[_import_1_1_PatientJournalNote] AS pjn 
/*INNER JOIN dbo.Patient AS p ON
    p.PatientID = pjn.patientid AND 
	p.PracticeID=@practiceid       
WHERE pjn.notemessage <> '' */
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into PatientJournalNote Successfully'

PRINT ''
PRINT 'Inserting into PatientAlert'
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
      --  RecordTimeStamp ,
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT  DISTINCT
          pa.patientid , -- PatientID - int
          pa.AlertMessage , -- AlertMessage - text
          pa.ShowInPatientFlag , -- ShowInPatientFlag - bit
          pa.ShowInAppointmentFlag , -- ShowInAppointmentFlag - bit
          pa.showinencounterflag , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          pa.showinclaimflag , -- ShowInClaimFlag - bit
          pa.showinpaymentflag , -- ShowInPaymentFlag - bit
          pa.showinpatientstatementflag  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_1_1_PatientAlert] as pa
/*INNER JOIN dbo.Patient as pat on
         pat.PatientID = pa.patientid
     AND pat.PracticeID = @PracticeID  */
WHERE pa.alertmessage <> '' AND pa.patientid <>''    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patientAlert Successfully'

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
          pat.PatientID , -- PatientID - int
          patcase.name , -- Name - varchar(128)
          patcase.Active , -- Active - bit
          patcase.payerscenarioid , -- PayerScenarioID - int
          CASE patcase.referringphysicianid WHEN '1' THEN 1 ELSE NULL END , -- ReferringPhysicianID - int  *********  we have  FK issue with this column  ********************
          patcase.employmentrelatedflag , -- EmploymentRelatedFlag - bit
          patcase.autoaccidentrelatedflag , -- AutoAccidentRelatedFlag - bit
          patcase.otheraccidentrelatedflag , -- OtherAccidentRelatedFlag - bit
          patcase.abuserelatedflag , -- AbuseRelatedFlag - bit
          patcase.autoaccidentrelatedstate , -- AutoAccidentRelatedState - char(2)
          patcase.notes , -- Notes - text
          patcase.showexpiredinsurancepolicies , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          patcase.casenumber , -- CaseNumber - varchar(128)
          CASE WHEN patcase.workerscompcontactinfoid = '' THEN NULL ELSE patcase.workerscompcontactinfoid END , -- WorkersCompContactInfoID - int
          patcase.patientcaseID , -- VendorID - varchar(50)
          @VendorImportID ,  -- VendorImportID - int
          patcase.pregnancyrelatedflag , -- PregnancyRelatedFlag - bit
          patcase.statementactive , -- StatementActive - bit
          patcase.epsdt , -- EPSDT - bit
          patcase.familyplanning , -- FamilyPlanning - bit
          CASE WHEN patcase.epsdtcodeid ='' THEN NULL ELSE patcase.epsdtcodeid END , -- EPSDTCodeID - int
          patcase.emergencyrelated , -- EmergencyRelated - bit
          patcase.homeboundrelatedflag  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_1_1_PatientCase] as patcase
INNER JOIN dbo.Patient AS pat ON
    pat.PatientID = patcase.patientid AND
    pat.VendorImportID = @VendorImportID   
WHERE patcase.patientcaseid <> ''  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase'


PRINT ''
PRINT 'Inserting into PatientCaseDate'
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
          pcd.practiceid , -- PracticeID - int
          patcase.patientcaseid , -- PatientCaseID - int
          pcd.patientcasedatetypeid , -- PatientCaseDateTypeID - int
          pcd.startdate , -- StartDate - datetime
          GETDATE() , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_1_PatientCaseDate] AS pcd
INNER JOIN dbo.patientcase as patcase ON
        patcase.vendorID = pcd.patientcaseid AND
		patcase.VendorImportID = @VendorImportID	
--WHERE patcase.practiceID = @practiceID and vendorimportid= @vendorimportid 
WHERE pcd.patientcasedateid <> '' AND pcd.patientcasedatetypeid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into patientcaseDate'

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
          InsuranceProgramTypeID ,
          GroupName ,
          ReleaseOfInformation 
     /*   SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          pc.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          iip.Precedence , -- Precedence - int
          iip.PolicyNumber , -- PolicyNumber - varchar(32)
          iip.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(iip.policystartdate) = 1 THEN iip.policystartdate ELSE NULL END  , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(iip.PolicyEndDate) = 1 THEN iip.PolicyEndDate ELSE NULL END , -- PolicyEndDate - datetime
          iip.cardonfile , -- CardOnFile - bit
          iip.patientrelationshiptoinsured , -- PatientRelationshipToInsured - varchar(1)
          iip.holderprefix , -- HolderPrefix - varchar(16)
          iip.holderfirstname , -- HolderFirstName - varchar(64)
          iip.holdermiddlename , -- HolderMiddleName - varchar(64)
          iip.holderlastname , -- HolderLastName - varchar(64)
          iip.holdersuffix , -- HolderSuffix - varchar(16)
          iip.holderdob , -- HolderDOB - datetime
          iip.holderssn , -- HolderSSN - char(11)
          iip.holderthroughemployer , -- HolderThroughEmployer - bit
          iip.holderemployername , -- HolderEmployerName - varchar(128)
          iip.patientinsurancestatusid , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          iip.holdergender , -- HolderGender - char(1)
          iip.holderaddressline1 , -- HolderAddressLine1 - varchar(256)
          iip.holderaddressline2 , -- HolderAddressLine2 - varchar(256)
          iip.holdercity , -- HolderCity - varchar(128)
          iip.holderstate , -- HolderState - varchar(2)  
          iip.holdercountry , -- HolderCountry - varchar(32)
          iip.holderzipcode , -- HolderZipCode - varchar(9)
          iip.holderphone , -- HolderPhone - varchar(10)
          iip.holderphoneext , -- HolderPhoneExt - varchar(10)
          iip.dependentpolicynumber , -- DependentPolicyNumber - varchar(32)
          iip.notes , -- Notes - text
          iip.phone , -- Phone - varchar(10)
          iip.phoneext , -- PhoneExt - varchar(10)
          iip.fax , -- Fax - varchar(10)
          iip.faxext , -- FaxExt - varchar(10)
          iip.copay , -- Copay - money
          iip.deductible , -- Deductible - money
          iip.patientinsurancenumber , -- PatientInsuranceNumber - varchar(32)
          iip.active , -- Active - bit
          @PracticeID , -- PracticeID - int
          iip.adjusterprefix , -- AdjusterPrefix - varchar(16)
          iip.adjusterfirstname , -- AdjusterFirstName - varchar(64)
          iip.adjustermiddlename , -- AdjusterMiddleName - varchar(64)
          iip.adjusterlastname , -- AdjusterLastName - varchar(64)
          iip.adjustersuffix , -- AdjusterSuffix - varchar(16)  
          iip.insurancepolicyid , -- VendorID - varchar(50)
          @VendorImportID ,  -- VendorImportID - int
          CASE WHEN iip.insuranceprogramtypeid = '' THEN NULL ELSE iip.insuranceprogramtypeid end , -- InsuranceProgramTypeID - int
          iip.groupname , -- GroupName - varchar(14)
          iip.releaseofinformation  -- ReleaseOfInformation - varchar(1)
       /* NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_1_1_InsurancePolicy] AS iip
INNER JOIN dbo.PatientCase AS pc ON
    pc.vendorID = iip.patientcaseID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS inscoplan ON
    inscoplan.vendorID = iip.insurancecompanyplanid AND
	inscoplan.VendorImportID = @VendorImportID 
--WHERE iip.insurancepolicyid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy '

PRINT '' 
PRINT 'updating patient case with PayerScenarioID'
Update dbo.patientcase set PayerScenarioID=11, name='Self Pay' from dbo.patientcase as patcase 
LEFT JOIN dbo.insurancepolicy as ip ON
ip.patientcaseID = patcase.patientcaseID 
where patcase.VendorImportID = @vendorImportID AND
ip.patientcaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated into patient case '



--ROLLBACK
--COMMIT
--PRINT 'COMMIT SUCCESSFUllY'

