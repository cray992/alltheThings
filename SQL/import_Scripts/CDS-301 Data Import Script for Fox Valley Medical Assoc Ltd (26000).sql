USE superbill_26000_dev
--superbill_26000_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT


SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))



--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
--DELETE FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Service Location records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alerts records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
--DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID AND [External] = 1
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Referring Provider records deleted'



PRINT ''
PRINT 'Updating Service Location VendorIDs...'
UPDATE dbo.ServiceLocation
SET VendorID = 17 
WHERE Name = 'FVMA - (Aurora)'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


UPDATE dbo.ServiceLocation 
SET VendorID = 16
WHERE Name = 'FVMA - (Batavia)'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


UPDATE dbo.ServiceLocation
SET VendorID = 76 
WHERE Name = 'FVMA - (YORKVILLE)'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


UPDATE dbo.ServiceLocation
SET VendorID = 74 
WHERE Name = 'FVMA - (Sandwich)'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Updating dbo.[_import_14_1_Appointment] APPT_TYPENAME '
UPDATE dbo.[_import_14_1_Appointment]
SET appttypename = '0098 Sick Call'
WHERE appttypename = '0098 Sick Visit'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '



PRINT ''
PRINT 'Inserting Into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  i.PATEMP , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_12_1_PATIENTS] i WHERE i.PATEMP <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Referring Provider...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
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
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          [External] ,
          NPI , 
		  Notes
        )
SELECT DISTINCT
		   @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          CASE WHEN i.REFPROVFIRSTNAME <> '' THEN i.REFPROVFIRSTNAME ELSE '' END , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          CASE WHEN i.REFPROVLASTNAME <> '' THEN i.REFPROVLASTNAME ELSE '' END , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.REFPROVADDRESS1 , -- AddressLine1 - varchar(256)
          i.REFPROVADDRESS2 , -- AddressLine2 - varchar(256)
          i.REFPROVCITY , -- City - varchar(128)
          i.REFPROVSTATE , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(i.REFPROVZIP,'-','') , -- ZipCode - varchar(9)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.REFPROVCODE , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- External - bit
          LEFT(I.REFPROVNPI,10) , -- NPI - varchar(10)
		  CASE WHEN i.REFPROVPRACTICENAME <> '' THEN 'Practice name from import: ' + i.REFPROVPRACTICENAME ELSE NULL END
FROM dbo.[_import_9_1_REFERRINGPROVS] i 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



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
          BillingName ,
          Phone ,
          VendorImportID ,
          VendorID ,
          TimeZoneID 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          i.FACNAME, -- Name - varchar(128)
          i.FACADDR1 , -- AddressLine1 - varchar(256)
          i.FACADDR2 , -- AddressLine2 - varchar(256)
          i.FACCITY , -- City - varchar(128)
          i.FACSTATE , -- State - varchar(2)
          '' , -- Country - varchar(32)
          dbo.fn_RemoveNonNumericCharacters(i.FACZIP) , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.FACNAME , -- BillingName - varchar(128)
          dbo.fn_RemoveNonNumericCharacters(i.FACPHONE) , -- Phone - varchar(10)
          @VendorImportID , -- VendorImportID - int
          i.FACCODE , -- VendorID - int
          11  -- TimeZoneID - int
FROM dbo.[_import_10_1_FACILITIES] i
WHERE NOT EXISTS (SELECT * FROM dbo.ServiceLocation sl WHERE i.FACADDR1 = sl.AddressLine1)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  i.INSNAME , -- InsuranceCompanyName - varchar(128)
          i.INSADDR1 , -- AddressLine1 - varchar(256)
          i.INSADDR2 , -- AddressLine2 - varchar(256)
          i.INSCITY , -- City - varchar(128)
          i.INSSTATE , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.INSZIP)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.INSZIP) 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(INSZIP)) IN (5.9) THEN dbo.fn_RemoveNonNumericCharacters(i.INSZIP) 
			   ELSE '' END, -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          i.INSCONTACT , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.INSPHONE)) >=10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.INSPHONE),10) ELSE '' END, -- Phone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.INSPHONE)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.INSPHONE),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.INSPHONE))),10) ELSE NULL END, -- PhoneExt - varchar(10)
          13 , -- BillingFormID - int
          'CI', -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          i.INSCODE , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_4_1_INSURANCELIST] i
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
		  InsuranceCompanyID,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          [State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          ContactFirstName , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          Phone , -- Phone - varchar(10)
          PhoneExt , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          VendorID ,
          VendorImportID ,
          Active ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone ,
		  PrimaryProviderID 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          CASE i.PATPROV 
						  WHEN 'HEID92' THEN 4
						  WHEN 'KED' THEN 10
						  WHEN '1' THEN 2
						  WHEN '3' THEN 8
						  WHEN '4' THEN 1
						  WHEN '315' THEN 3
						  WHEN '188' THEN 5 
						  WHEN '302' THEN 6
						  WHEN '45411' THEN 7 
						  ELSE d.doctorID END , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.PATFNAME , -- FirstName - varchar(64)
          CASE WHEN i.PATMI <> '' THEN i.PATMI ELSE '' END , -- MiddleName - varchar(64)
          i.PATLNAME , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.PATADDR1 , -- AddressLine1 - varchar(256)
          i.PATADDR2 , -- AddressLine2 - varchar(256)
          i.PATCITY , -- City - varchar(128)
          LEFT(i.PATSTATE, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.PATZIP)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.PATZIP) 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.PATZIP)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.PATZIP)
			   ELSE '' END ,-- ZipCode - varchar(9)
          CASE WHEN i.PATSEX <> '' THEN i.PATSEX ELSE 'U' END , -- Gender - varchar(1)
          i.PATMARITALSTATUS , -- MaritalStatus - varchar(1)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.PATHOMEPHONE)) >=10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.PATHOMEPHONE),10) ELSE '' END , -- HomePhone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.PATHOMEPHONE)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.PATHOMEPHONE),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.PATHOMEPHONE))),10) ELSE NULL END , -- HomePhoneExt - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.PATWORKPHONE)) >=10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.PATWORKPHONE),10) ELSE '' END , -- WorkPhone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.PATWORKPHONE)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.PATWORKPHONE),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.PATWORKPHONE))),10) ELSE NULL END , -- WorkPhoneExt - varchar(10)
          i.PATBDATE , -- DOB - datetime
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.PATSSN)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.PATSSN), 9) ELSE NULL END , -- SSN - char(9)
          i.PATEMAIL , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.PATEMP <> '' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
          CASE WHEN i.PATEMP <> '' THEN e.EmployerID END , -- EmployerID - int
          i.PATCHART , -- MedicalRecordNumber - varchar(128)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.PATCELLPHONE)) >=10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.PATCELLPHONE),10) ELSE '' END , -- MobilePhone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.PATCELLPHONE)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.PATCELLPHONE),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.PATCELLPHONE))),10) ELSE NULL END , -- MobilePhoneExt - varchar(10)
          i.patacct + i.patnum , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          0 , -- PhonecallRemindersEnabled - bit
          i.PATEMRGLASTNAME + ' ' + i.PATEMRGLASTNAME , -- EmergencyName - varchar(128)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.PATEMRGPHONE)) >=10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.PATEMRGPHONE),10) ELSE '' END  ,-- EmergencyPhone - varchar(10)
		  CASE i.PATPROV 
						  WHEN 'HEID92' THEN 4
						  WHEN 'KED' THEN 10
						  WHEN '1' THEN 2
						  WHEN '3' THEN 8
						  WHEN '4' THEN 1
						  WHEN '315' THEN 3
						  WHEN '188' THEN 5 
						  WHEN '302' THEN 6
						  WHEN '45411' THEN 7 
						  ELSE NULL END  -- PrimaryProviderID - int
FROM dbo.[_import_12_1_PATIENTS] i
LEFT JOIN dbo.Doctor d ON 
d.VendorID = i.PATPROV AND 
d.VendorImportID = @VendorImportID AND
d.[External] = 1
LEFT JOIN dbo.Employers e ON
e.EmployerName = i.PATEMP
WHERE i.PATACCT <> '' AND i.patnum <> '' AND NOT EXISTS 
(SELECT * FROM dbo.Patient p WHERE i.PATFNAME = p.FirstName AND i.PATLNAME = p.LastName AND CAST(CAST(i.PATBDATE AS DATE) AS DATETIME) = CAST(CAST(p.DOB AS DATE) AS DATETIME))
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Patient Alert...'
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
SELECT DISTINCT  
		  p.PatientID , -- PatientID - int
          i.PATNOTE , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_12_1_PATIENTS] i
INNER JOIN dbo.Patient p ON
p.VendorID = i.PATACCT + i.PATNUM AND
p.VendorImportID = @VendorImportID
WHERE i.PATNOTE <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
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
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient 
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



/*

PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
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
          DependentPolicyNumber ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          [pi].PATINSBILLORDNUM , -- Precedence - int
          i.GINSID , -- PolicyNumber - varchar(32)
          i.GINSGRP , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE([pi].PATINSEFFDATE) = 1 THEN [pi].PATINSEFFDATE ELSE NULL END  , -- PolicyStartDate - datetime
          CASE WHEN ISDATE([pi].PATINSTERMDATE) = 1 THEN [pi].PATINSTERMDATE ELSE NULL END  , -- PolicyEndDate - datetime
          CASE WHEN [pi].PATINSREL = 'SELF' THEN 'S'
			   WHEN [pi].PATINSREL = 'SPOUSE' THEN 'U'
			   WHEN [pi].PATINSREL = 'OTHER' THEN 'O'
			   WHEN [pi].PATINSREL = 'CHILD' THEN 'C' 
			   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN i.ginsfname  ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN i.ginsmi ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN i.ginslname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN CASE WHEN ISDATE(i.ginsbdate) = 1 THEN i.ginsbdate ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN 
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ginsssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.ginsssn),9) ELSE NULL END END , -- HolderSSN - char(11)
          CASE WHEN i.ginsemp <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
          CASE WHEN i.ginsemp <> '' THEN i.ginsemp ELSE '' END , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN CASE WHEN i.ginssex = '' THEN 'U' ELSE i.ginssex END ELSE NULL END, -- HolderGender - char(1)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN i.ginsaddr1 ELSE NULL END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN i.ginsaddr2 ELSE NULL  END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN i.ginscity ELSE NULL END , -- HolderCity - varchar(128)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN LEFT(i.ginsstate,2) ELSE NULL END , -- HolderState - varchar(2)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN '' ELSE NULL END , -- HolderCountry - varchar(32)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN 
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ginszip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.ginszip) 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ginszip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.ginszip) ELSE NULL END ELSE NULL END, -- HolderZipCode - varchar(9)
          CASE WHEN [pi].PATINSREL <> 'SELF' THEN i.ginsid ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.[_import_13_1_INSURANCEFLAT] i
INNER JOIN dbo.PatientCase pc ON
i.patacct + i.patnum = pc.VendorID AND
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
i.ginsins = icp.VendorID  AND
icp.VendorImportID = @VendorImportID
INNER JOIN  dbo.[_import_15_1_PatientInsDatesRel] [pi] ON
i.patacct + i.patnum = [pi].patinsacct + [pi].patinspatnum AND
i.patinsbillordnum = [pi].patinsbillordnum
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

*/


/*

PRINT ''
PRINT 'Inserting Into Appointments...'
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
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
		  CASE WHEN sl.ServiceLocationID IS NULL THEN 1 ELSE sl.ServiceLocationID END  , -- ServiceLocationID - int
          i.StartDateCST , -- StartDate - datetime
          i.EndDateCST , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.APPTCOMMENT , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S', -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.StartTMCST , -- StartTm - smallint
          i.EndTMCST  -- EndTm - smallint
FROM dbo.[_import_14_1_Appointment] i
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = i.patvendorid AND
	pat.PracticeID = @PracticeID 
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = pat.VendorID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = CAST(CAST(i.startdatecst AS DATE) AS DATETIME)   
LEFT JOIN dbo.ServiceLocation sl ON
	i.apptfac = sl.VendorID 
WHERE i.patvendorid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  app.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.apptprov 
				WHEN 4 THEN 1
				WHEN 7 THEN 2
				WHEN 8 THEN 8
				WHEN 9 THEN 5
				WHEN 37 THEN 6
				WHEN 41 THEN 3
				WHEN 47 THEN 4
				WHEN 48 THEN 11
				WHEN 49 THEN 10
				WHEN 50 THEN 7
				WHEN 52 THEN 9
				ELSE 1 END
				, -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_14_1_Appointment] i
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = i.patvendorid AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS app ON
	app.PatientID = pat.PatientID AND
	app.StartDate = i.startdatecst 
WHERE app.ModifiedDate > DATEADD(mi,-20,GETDATE()) AND app.StartDate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Appointment Reason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          i.appttypename , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          i.appttypename , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_14_1_Appointment] i
WHERE i.appttypename <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE i.appttypename = ar.Name)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting into Appointment to Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  app.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          0 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_14_1_Appointment] i
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = i.patvendorid AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS app ON
	app.PatientID = pat.PatientID AND
	app.StartDate = i.startdatecst AND
	app.StartTm = i.starttmcst  
INNER JOIN dbo.AppointmentReason AS ar ON
	ar.name = i.appttypename AND
	ar.PracticeID = @PracticeID
WHERE app.ModifiedDate > DATEADD(mi, -5, GETDATE()) AND app.StartDate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Patient Journal Note...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
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
		  i.notedate , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          'Kareo' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          i.notetext , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_11_1_NOTES] i
INNER JOIN dbo.Patient p ON
p.VendorID = i.patvendorid AND
p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Patient Cases to Self Pay Not Linked to Policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 ,
		  Name = 'Self Pay' 
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



*/





--ROLLBACK
--COMMIT
