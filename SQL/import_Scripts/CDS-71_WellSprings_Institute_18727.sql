--USE superbill_18727_dev
USE superbill_18727_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION 

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 10 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT )
INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID)
(
	SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule 
	WHERE Notes = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) 
)
DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
	PRINT '    ' + CAST(@@ROWCOUNT AS varchar) + ' Employers records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeId AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'

--DELETE FROM dbo.[_import_10_1_InsuranceList] WHERE AutoTempID IN (43,155,175,176,178,181,452,495,555,574,576,578,651,716)


PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Phone ,
          PhoneExt ,
          Fax ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CreatedPracticeID , 
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID ,
          SecondaryPrecedenceBillingFormID
        )
Select DISTINCT
          insurancecompanyname, -- InsuranceCompanyName - varchar(128)
          insurancecompanyaddress1, -- AddressLine1 - varchar(256)
          insurancecompanyaddress2 , -- AddressLine2 - varchar(256)
          insurancecompanycity , -- City - varchar(128)
          insurancecompanystate , -- State - varchar(2)
          insurancecompanyzipcode , -- ZipCode - varchar(9)
          insurancecompanyphone, -- Phone - varchar(10)
          insurancecompanyphoneextension, -- PhoneExt - varchar(10)
          insurancecompanyfax, -- Fax - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedDate
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID
          insurancecompanyuniqueidentifier , -- VendorID - varchar(50)
          @VendorImportID, -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18 , -- InstitutionalBillingFormID - int
          13
FROM dbo.[_import_10_1_InsuranceList]
PRINT CAST(@@Rowcount AS VARCHAR) + ' records inserted'



PRINT''
PRINT'Inserting into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Phone ,
          PhoneExt ,
          Fax ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
Select DISTINCT 
		  icp.insurancecompanyname , -- PlanName - varchar(128)
          insurancecompanyaddress1, -- AddressLine1 - varchar(256)
          insurancecompanyaddress2 , -- AddressLine2 - varchar(256)
          insurancecompanycity , -- City - varchar(128)
          insurancecompanystate , -- State - varchar(2)
          insurancecompanyzipcode , -- ZipCode - varchar(9)
          insurancecompanyphone, -- Phone - varchar(10)
          insurancecompanyphoneextension, -- PhoneExt - varchar(10)
          insurancecompanyfax, -- Fax - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID
          ic.insurancecompanyid , -- InsuranceCompanyID - int
          insurancecompanyuniqueidentifier , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_10_1_InsuranceList] icp
INNER JOIN dbo.insurancecompany ic ON
	ic.vendorid = icp.insurancecompanyuniqueidentifier AND
	ic.vendorimportid = @VendorImportID
PRINT CAST(@@Rowcount AS VARCHAR) + ' records inserted'


PRINT''
PRINT'Inserting into Doctor...'
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
          Degree ,
          VendorID ,
          VendorImportID ,
          [External] 
         
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          referringphysicianfirstname , -- FirstName - varchar(64)
          referringphysicianmiddleinitial , -- MiddleName - varchar(64)
          referringphysicianlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          referringphysicianaddress1 , -- AddressLine1 - varchar(256)
          referringphysicianaddress2 , -- AddressLine2 - varchar(256)
          referringphysiciancity , -- City - varchar(128)
          LEFT(referringphysicianstate, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(referringphysicianzipcode, '-', ''), 9) , -- ZipCode - varchar(9)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          LEFT(referringphysiciandegree, 8) , -- Degree - varchar(8)
          '' , -- VendorID - varchar(50)
          @VendorImportID  , -- VendorImportID - int
          1  -- External - bit
FROM dbo.[_import_5_1_ReferringPhysicians] 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT'Inserting into Employers... '
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
SELECT    employersname , -- EmployerName - varchar(128)
          employeraddress , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          employercity , -- City - varchar(128)
          LEFT(employerstate, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(employerzip, '-', ''), 9) , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_5_1_Employers] 
PRINT CAST(@@ROWCOUNT AS VARCHAR)  + ' records inserted'


PRINT''
PRINT'Inserting into Patient....'
INSERT INTO dbo.Patient
        ( PracticeID ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          Prefix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Gender ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          EmergencyName ,
          EmergencyPhone 
		)
SELECT DISTINCT   
	      @PracticeID , -- PracticeID - int
          imppat1.patientfirstname , -- FirstName - varchar(64)
          imppat1.patientmiddleinitial , -- MiddleName - varchar(64)
          imppat1.patientlastname , -- LastName - varchar(64)
          imppat1.patientsuffix, -- Suffix - varchar(16)
          '' , -- Prefix
          imppat1.patientaddress1 , -- AddressLine1 - varchar(256)
          imppat1.patientaddress2 , -- AddressLine2 - varchar(256)
          imppat1.patientcity , -- City - varchar(128)
          imppat1.patientstate , -- State - varchar(2)
          '' , -- Country            
          LEFT (REPLACE(imppat1.patientzipcode, '-', ''), 9) ,-- ZipCode - varchar(9)
          imppat1.patientsex , -- Gender - varchar(1)
          imppat2.patienthomephone, -- HomePhone - varchar(10)
          imppat2.patientworkphone, -- WorkPhone - varchar(10)
          imppat1.patientbirthdate , -- DOB - datetime
          imppat1.patientssn , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          imppat1.patientacct , -- MedicalRecordNumber - varchar(128)
          imppat2.patientcellphone , -- MobilePhone - varchar(10)
          imppat1.patientacct , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          imppat2.patientemergencycontact , -- EmergencyName - varchar(128)
          imppat2.patientemergencycontactphone  -- EmergencyPhone - varchar(10)
FROM dbo.[_import_11_1_PatientDemographics1] imppat1
inner JOIN dbo.[_import_10_1_PatientDemographics2] imppat2 ON
	imppat1.patientacct = imppat2.patientacct  AND
	imppat2.patientacct <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT''
PRINT'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT   PatientID, -- PatientID - int
          'Default Case', -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID, -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pat
WHERE pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
          pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          LEFT(imppi.primarypolicynumber, 32), -- PolicyNumber - varchar(32)
          LEFT(imppi.primarygroupnumber, 32) , -- GroupNumber - varchar(32)
          CASE imppi.primaryinsuredrelationship WHEN 'Self' THEN 'S'
												WHEN 'Spouse' THEN 'U'
												WHEN 'Child' THEN 'C' 
												WHEN 'Other' THEN 'O'
												ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          imppi.primaryinsuredfirstname , -- HolderFirstName - varchar(64)
          imppi.primaryinsuredmiddlename , -- HolderMiddleName - varchar(64)
          imppi.primaryinsuredlastname , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          imppi.primaryinsureddateofbirth , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          imppi.primaryinsuredaddress , -- HolderAddressLine1 - varchar(256)
          imppi.primaryinsuredcity , -- HolderCity - varchar(128)
          LEFT(imppi.primaryinsuredstate, 2) , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          LEFT(REPLACE(imppi.primaryinsuredzipcode, '-', ''), 9) , -- HolderZipCode - varchar(9)
          imppi.primarypolicynumber , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imppi.patientacct   , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_10_1_PolicyInformation] imppi
INNER JOIN patientcase pc ON 
	imppi.patientacct = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	imppi.primaryinsurancecode =  icp.VendorID AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT''
PRINT'Inserting into Insurance Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
          pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          LEFT(imppi.secondarypolicynumber, 32), -- PolicyNumber - varchar(32)
          LEFT(imppi.secondarygroupnumber, 32) , -- GroupNumber - varchar(32)
          CASE imppi.secondaryinsuredrelationship WHEN 'Self' THEN 'S'
												WHEN 'Spouse' THEN 'U'
												WHEN 'Child' THEN 'C' 
												WHEN 'Other' THEN 'O'
												ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          imppi.secondaryinsuredfirstname , -- HolderFirstName - varchar(64)
          imppi.secondaryinsuredmiddlename , -- HolderMiddleName - varchar(64)
          imppi.secondaryinsuredlastname , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          imppi.secondaryinsureddateofbirth , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          imppi.secondaryinsuredaddress , -- HolderAddressLine1 - varchar(256)
          imppi.secondaryinsuredcity , -- HolderCity - varchar(128)
          LEFT(imppi.secondaryinsuredstate, 2) , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          LEFT(REPLACE(imppi.secondaryinsuredzipcode, '-', ''), 9) , -- HolderZipCode - varchar(9)
          imppi.secondarypolicynumber , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imppi.patientacct   , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_10_1_PolicyInformation] imppi
INNER JOIN patientcase pc ON 
	imppi.patientacct = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	imppi.secondaryinsurancecode =  icp.VendorID AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting in a new StandardFeeSchedule ...'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
        ( PracticeID ,
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
VALUES  ( 
		  @PracticeID , -- PracticeID - int
          'Default contract' , -- Name - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          GETDATE() , -- EffectiveStartDate - datetime
          'f' , -- SourceType - char(1)
          'Import file' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting in Standard Fees ...'
INSERT INTO dbo.ContractsAndFees_StandardFee
    ( StandardFeeScheduleID ,
      ProcedureCodeID ,
      ModifierID ,
      SetFee ,
      AnesthesiaBaseUnits
    )
SELECT
      c.StandardFeeScheduleID , -- StandardFeeScheduleID - int
      pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
      0 , -- ModifierID - int
      impSFS.fee , -- SetFee - money
      0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_10_1_FeeSchedule] impSFS
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule c ON
	CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
	c.practiceID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	impSFS.cptcode = pcd.ProcedureCode
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting in Standard Fee Schedule Link ...'
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
WHERE doc.PracticeID = @PracticeID AND
	doc.[External] = 0 AND 
	sl.PracticeID = @PracticeID AND
	CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	sfs.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Appointment ...'
INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          AppointmentConfirmationStatusCode ,
          Subject ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT    pat.PatientID , -- PatientID
          @PracticeID , -- PracticeID
          1  , -- ServiceLocationID 
          DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , app.[hmmss], 0) > 0 then  
					   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
							THEN  replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')
							ELSE (replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
							END
						ELSE
							CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
								THEN REPLACE(replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 				ELSE replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
							END 
						END ), 2) AS SMALLINT), 
				  DATEADD(hh, CAST(
						(CASE WHEN (LEFT((CASE WHEN charindex( 'PM' , app.[hmmss], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 2)) > 24 
						THEN  left((CASE WHEN charindex( 'PM' , app.[hmmss], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 1)
						ELSE  left((CASE WHEN charindex( 'PM' , app.[hmmss], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
				END ), 2) END) AS SMALLINT),app.[startdate])) , --Starttime 
			DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , app.[hmmss], 0) > 0 then  
					   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
							THEN  replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '')
							ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
							END
						ELSE
							CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
								THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 				ELSE replace(replace(ltrim(right(DATEADD(mi, CAST(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', '')
							END 
						END ), 2) AS SMALLINT), 
				DATEADD(hh, CAST(
					(CASE WHEN (LEFT((CASE WHEN charindex( 'PM' , app.[hmmss], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 2)) > 24 
					THEN  left((CASE WHEN charindex( 'PM' , app.[hmmss], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 1)
					ELSE  left((CASE WHEN charindex( 'PM' , app.[hmmss], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 2) END) AS SMALLINT),app.[startdate])) , -- Endtime
          'P' , -- AppointmentType
          'S' , -- AppointmentConfirmationStatusCode
          '' , -- Subject 
          app.appointmentreason , -- Notes
          GETDATE() , -- CreatedDate
          0 , -- CreatedUserID
          GETDATE() , --ModifiedDate
          0 , -- ModifiedUserID
          pc.PatientCaseID , -- PatientCaseID
          dk.DKPracticeID , -- DKStartPracticeID
          dk.DKPracticeID , -- DKEndPracticeID
          CASE WHEN charindex( 'PM' , app.[hmmss] , 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') 
						ELSE (replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200) 
					  END
					  ELSE
						replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
		  END  , -- Starttm
          CASE WHEN charindex( 'PM' , app.[hmmss], 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '') 
						  ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200) 
					  END
					  ELSE
						CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
							 THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '') 
			 			ELSE replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', '') 
						END 
		  END -- Endtm
FROM dbo.[_import_10_1_Appointment] app
INNER JOIN dbo.Patient pat ON 
    app.patientacct = pat.VendorID AND
    pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON
	pc.PatientID = pat.PatientID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = (SELECT Dt FROM dbo.DateKeyToPractice WHERE Dt = CAST(app.startdate AS DATETIME))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into AppointmentToAppointmentReason'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          ModifiedDate ,
          PracticeID
        )
SELECT    appt.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_10_1_Appointment impAppt
INNER JOIN dbo.Patient pat ON 
	impAppt.patientacct = pat.VendorID AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment appt ON 
	pat.PatientID = appt.PatientID AND
	appt.StartDate = 	(DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , impAppt.[hmmss], 0) > 0 then  
					   CASE WHEN len(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
							THEN  replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')
							ELSE (replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
							END
						ELSE
							CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
								THEN REPLACE(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 				ELSE replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
							END 
						END ), 2) AS SMALLINT), 
				  DATEADD(hh, CAST(
						(CASE WHEN (LEFT((CASE WHEN charindex( 'PM' , impAppt.[hmmss], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 2)) > 24 
						THEN  left((CASE WHEN charindex( 'PM' , impAppt.[hmmss], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 1)
						ELSE  left((CASE WHEN charindex( 'PM' , impAppt.[hmmss], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
				END ), 2) END) AS SMALLINT),impAppt.[startdate])) )
INNER JOIN dbo.AppointmentReason ar ON
	impAppt.appointmentreason = ar.Name
PRINT CAST(@@ROWCOUNT AS VARCHAR) +  ' records inserted'


PRINT ''
PRINT 'Inserting into AppointmentToResource'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT    appt.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          doc.DoctorID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_10_1_Appointment impAppt
INNER JOIN dbo.Patient pat ON 
	impAppt.patientacct = pat.VendorID AND
	pat.PracticeID = 1--@PracticeID
INNER JOIN dbo.Appointment appt ON 
	pat.PatientID = appt.PatientID AND
	appt.StartDate = 	(DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , impAppt.[hmmss], 0) > 0 then  
					   CASE WHEN len(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
							THEN  replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')
							ELSE (replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
							END
						ELSE
							CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
								THEN REPLACE(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 				ELSE replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
							END 
						END ), 2) AS SMALLINT), 
				  DATEADD(hh, CAST(
						(CASE WHEN (LEFT((CASE WHEN charindex( 'PM' , impAppt.[hmmss], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 2)) > 24 
						THEN  left((CASE WHEN charindex( 'PM' , impAppt.[hmmss], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 1)
						ELSE  left((CASE WHEN charindex( 'PM' , impAppt.[hmmss], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(impAppt.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
				END ), 2) END) AS SMALLINT),impAppt.[startdate])))
INNER JOIN dbo.Doctor doc ON	
	impAppt.renderingphysician = doc.FirstName + ' ' + doc.LastName AND
	doc.[External] = 0
PRINT CAST(@@rowcount AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Updating into PatientCase ...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11
	WHERE PayerScenarioID = 5 AND
		VendorImportID = @VendorImportID AND
		PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


COMMIT
