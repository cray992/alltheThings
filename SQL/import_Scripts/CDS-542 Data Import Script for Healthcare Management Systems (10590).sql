USE superbill_10590_dev
--USE superbill_10590_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 30
SET @VendorImportID = 17

SET NOCOUNT ON 

/*
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
*/


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
		  CreatedPracticeID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID 
        )
SELECT DISTINCT
		  insurancename ,
          [address] ,
          '' ,
          city ,
          [State] ,
          '' ,
          dbo.fn_RemoveNonNumericCharacters(zip) ,
          dbo.fn_RemoveNonNumericCharacters(phone) ,
          1 ,
          13 ,
          'CI' ,
          'C' ,
          'D' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
		  @PracticeID , 
          13 ,
          insuranceid ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18
FROM dbo.[_import_17_30_ReportInsurances] i WHERE kareoinsuranceplanid = 'NaN'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted'


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
          Phone ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted'

PRINT ''
PRINT 'Inserting Into Doctor...'
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
          WorkPhone ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          FirstName ,
          MiddleName ,
          LastName ,
          '' ,
          [Address] ,
          Address2 ,
          City ,
          [State] ,
          '' ,
          dbo.fn_RemoveNonNumericCharacters(zip) ,
          dbo.fn_RemoveNonNumericCharacters(phone) ,
          CASE WHEN specialty = '' THEN '' ELSE 'Specialty: ' + specialty + CHAR(13) + CHAR(10) END +
		  CASE WHEN taxid = '' THEN '' ELSE 'Tax ID: ' + taxid + CHAR(13) + CHAR(10) END + 
		  CASE WHEN upin = '' THEN '' ELSE 'UPIN: ' + upin + CHAR(13) + CHAR(10) END ,
          1 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          Degree ,
          firstname+lastname ,
          @VendorImportID ,
          dbo.fn_RemoveNonNumericCharacters(fax) ,
          1 ,
          NPI 
FROM dbo.[_import_17_30_ReportReferringProviders]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted' 

PRINT ''
PRINT 'Inserting Into Employer...'
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
		  employername , -- EmployerName - varchar(128)
          employeraddress , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          employercity , -- City - varchar(128)
          employerstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          dbo.fn_RemoveNonNumericCharacters(employerzip) , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_17_30_ReportPatientListCSVExport] 
WHERE NOT EXISTS (SELECT * FROM dbo.Employers e WHERE e.EmployerName = employername AND e.AddressLine1 = employeraddress) AND employername <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          DOB ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName 
        )
SELECT DISTINCT
		  @PracticeID ,
          10219 ,
          '' ,
          firstname ,
          middlename ,
          lastname ,
          '' ,
          patientaddress ,
          '' ,
          patientcity ,
          patientstate ,
          '' ,
          REPLACE(patientzip,'-','') ,
          sex ,
          '' ,
          dbo.fn_RemoveNonNumericCharacters(patienthomephone) ,
          CASE WHEN ISDATE(dob) = 1 THEN dob ELSE NULL END ,
          email ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CASE WHEN i.employername <> '' THEN 'E' ELSE 'U' END ,
          10219 ,
          158 ,
          e.EmployerID ,
          patientid ,
          patientid ,
          @VendorImportID ,
          1 ,
          1 ,
          0 ,
          0 ,
          emergencycontact
FROM dbo.[_import_17_30_ReportPatientListCSVExport] i
LEFT JOIN dbo.Employers e ON
e.EmployerName = i.employername AND
e.AddressLine1 = i.employeraddress
WHERE patientid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Policy 1 of 4...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          1 ,
          i.primaryinsuredid ,
          1 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          1 ,
          @PracticeID ,
          pc.VendorID + i.primaryinsuredid ,
          @VendorImportID ,
          'Y'
FROM dbo.[_import_17_30_ReportPatientListCSVExport] i
INNER JOIN dbo.PatientCase pc ON 
i.patientid = pc.VendorID AND 
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
i.priinscode = icp.InsuranceCompanyPlanID 
WHERE i.priinscode <> '' AND i.primaryinsuredid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Policy 2 of 4...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          1 ,
          i.primaryinsuredid ,
          1 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          1 ,
          @PracticeID ,
          pc.VendorID + i.primaryinsuredid ,
          @VendorImportID ,
          'Y'
FROM dbo.[_import_17_30_ReportPatientListCSVExport] i
INNER JOIN dbo.PatientCase pc ON 
i.patientid = pc.VendorID AND 
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
i.priinscode2 = icp.VendorID AND
icp.VendorImportID = @VendorImportID 
WHERE i.priinscode2 <> '' AND i.primaryinsuredid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Policy 3 of 4...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          2 ,
          i.secinsuredid ,
          1 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          1 ,
          30 ,
          pc.VendorID + i.secinsuredid ,
          18 ,
          'Y'
FROM dbo.[_import_17_30_ReportPatientListCSVExport] i
INNER JOIN dbo.PatientCase pc ON 
i.patientid = pc.VendorID AND 
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
i.secinscode = icp.InsuranceCompanyPlanID 
WHERE i.secinscode <> '' AND i.secinsuredid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Policy 4 of 4...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          2 ,
          i.secinsuredid ,
          1 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          1 ,
          30 ,
          pc.VendorID + i.secinsuredid ,
          18 ,
          'Y'
FROM dbo.[_import_17_30_ReportPatientListCSVExport] i
INNER JOIN dbo.PatientCase pc ON 
i.patientid = pc.VendorID AND 
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
i.secinscode2 = icp.VendorID AND
icp.VendorImportID = @VendorImportID 
WHERE i.secinscode2 <> '' AND i.secinsuredid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11 
FROM dbo.PatientCase pc
	LEFT JOIN dbo.InsurancePolicy ip ON
		pc.PatientCaseID = ip.PatientCaseID  
WHERE pc.VendorImportID = @VendorImportID AND
      PayerScenarioID = 5 AND 
      ip.PatientCaseID IS NULL 

--ROLLBACK
--COMMIT

