--USE superbill_18744_dev
USE superbill_18744_prod
go

--UPDATE dbo.[_import_1_1_PatientDemographics] SET primaryinsurance = 'ZURICH NORTHAMERICAN INS CO' where primaryinsurance = 'ZURICH INSURANCE'

--UPDATE dbo.[_import_1_1_PatientDemographics] SET primaryinsurance = 'CHICKERING CLAIMS ADM. INC' WHERE primaryinsurance = 'CHICKERING CLAIMS ADM. INC'
--UPDATE dbo.[_import_1_1_PatientDemographics] SET primaryinsurance = 'PRINCIPAL MUTUAL LIFE INSURANCE' WHERE primaryinsurance = 'PRINCIPLE MUTUAL LIFE INSURANCE'


BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))


DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT)
INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID) 
(
	SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE ProviderID IN 
	(
		SELECT DoctorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND DoctorID NOT IN 
		(
			SELECT ISNULL(PrimaryCarePhysicianID,0) FROM dbo.Patient
		)
	)
)
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' ContractsAndFees_StandardFeeScheduleLink deleted'
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' ContractsAndFees_StandardFee deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' ContractsAndFees_StandardFeeSchedule deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT  AppointmentID FROM dbo.Appointment WHERE PatientID IN 
		(SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' AppointmentToAppointmentReasons deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN  
		(SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCount AS VARCHAR) + ' AppointmentToResources deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' Appointments deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' + CAST(@@Rowcount AS VARCHAR) + ' Insurance Policies deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' +  CAST(@@rowcount AS VARCHAR) + ' Patient Cases deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' Patients deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' Doctors deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' InsuranceCompanyPlans deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' InsuranceCompanys deleted'

PRINT ''
PRINT 'Insert into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
          PhoneExt ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
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
SELECT    ic.insurancename , -- InsuranceCompanyName - varchar(128)
          '' , -- Notes - text
          ic.address1 , -- AddressLine1 - varchar(256)
          ic.address2 , -- AddressLine2 - varchar(256)
          ic.city , -- City - varchar(128)
          ic.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ic.zip , -- ZipCode - varchar(9)
          ic.phonenumber , -- Phone - varchar(10)
          ic.phoneext , -- PhoneExt - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          ic.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_Insurance] ic
PRINT CAST(@@rowcount AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
          PhoneExt ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReviewCode ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT    icp.InsuranceCompanyName , -- PlanName - varchar(128)
          icp.AddressLine1 , -- AddressLine1 - varchar(256)
          icp.AddressLine2 , -- AddressLine2 - varchar(256)
          icp.City , -- City - varchar(128)
          icp.State , -- State - varchar(2)
          '' , -- Country - varchar(32)
          icp.ZipCode , -- ZipCode - varchar(9)
          icp.Phone , -- Phone - varchar(10)
          icp.PhoneExt , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          icp.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany icp 
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Doctor ...'
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
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          ref.referringfirstname , -- FirstName - varchar(64)
          ref.referringmiddleinitial , -- MiddleName - varchar(64)
          ref.referringlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          ref.address1 , -- AddressLine1 - varchar(256)
          ref.address2 , -- AddressLine2 - varchar(256)
          ref.city , -- City - varchar(128)
          ref.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ref.zip , -- ZipCode - varchar(9)
          ref.phonenumber , -- WorkPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ref.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID, -- VendorImportID - int
          ref.faxnumber , -- FaxNumber - varchar(10)
          1 , -- External - bit
          ref.npi  -- NPI - varchar(10)
FROM dbo.[_import_1_1_ReferringPhysicians] ref
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT''
PRINT'Inserting into Patient ...'
INSERT INTO dbo.Patient 
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
          Gender ,
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
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
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
          PhonecallRemindersEnabled 
        )
SELECT    @PracticeID ,
          '' ,
          p.FirstName ,
          p.Middleinitial ,
          p.LastName ,
          '' ,
          p.Address1 ,
          p.Address2 ,
          p.City ,
          p.State ,
          '' ,
          LEFT(REPLACE(p.Zip,'-',''),9) ,
          p.Gender ,
          p.HomePhone ,
          p.WorkPhone ,
          p.WorkPhoneextension ,
          DATEADD(hh, 5, p.dateofbirth) ,
          p.SSN ,
          CASE WHEN guar.guarantorfirstname IS NOT NULL THEN 1  ELSE 0 END ,
          '' ,
          guar.guarantorfirstname ,
          guar.guarantormiddleinitial ,
          guar.guarantorlastname ,
          '' ,
          CASE WHEN guar.guarantorfirstname IS NOT NULL THEN 'O' ELSE '' END  ,
          guar.guarantoraddress1 ,
          guar.guarantoraddress2 ,
          guar.guarantorcity ,
          guar.guarantorstate ,
          '' ,
          guar.guarantorzip + guar.guarantorzipplus4 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0,
          CASE p.employmentstatus WHEN 'Full time' THEN 'E'
								  WHEN 'Part time' THEN 'T'
								  WHEN 'Not employed' THEN 'U'
								  WHEN 'Retired' THEN 'R'
								  ELSE 'U' END,
          1  ,
          p.chartnumber ,
          p.cellphone ,
          p.chartnumber ,
          @VendorImportID ,
          CASE WHEN p.Activeinactive = 'Active' THEN 1 
			   WHEN p.Activeinactive = 'Inactive' THEN 0 END ,
          CASE WHEN p.homephone <> '' THEN 1 ELSE 0 END  
FROM dbo.[_import_1_1_PatientDemographics] p
LEFT JOIN dbo.[_import_1_1_Guarantor] guar ON 
	p.chartnumber = guar.patientchartnumber 	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

SELECT * FROM dbo.[_import_1_1_PatientDemographics]
PRINT''
PRINT'Inserting into PatientCase ...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pat.PatientID ,
          'Default Case' ,
          1 ,
          5,
          'Created via Data Import, please review.' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          @PracticeID ,
          pat.VendorID ,
          @VendorImportID 
FROM dbo.Patient pat
WHERE pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          1 ,
          ip.policynumber ,
          ip.GroupNumber ,
          'S',
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          '' , -- Notes -text
          '' , -- PatientInsuranceNumber - varchar(32)
          1 ,
          1 ,
          ip.policynumber ,
          1  
FROM dbo.[_import_1_1_PatientDemographics] ip
left JOIN dbo.PatientCase pc ON
	ip.chartnumber = pc.VendorID AND
	pc.VendorImportID = 1
LEFT  JOIN dbo.InsuranceCompanyPlan icp ON
	ip.primaryinsurance = icp.PlanName
WHERE ip.primaryinsurance <> ''	AND icp.InsuranceCompanyPlanID IS NOT NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into StandardFeeSchedule ...'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
        ( PracticeID ,
          Name ,
          Notes ,
          EffectiveStartDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          AddPercent ,
          AnesthesiaTimeIncrement
        )
VALUES   (  @PracticeID , -- PracticeID - int
          'Default Fee Schedule' , -- Name - varchar(128)
          'Created via Data Import, please review.' , -- Notes - varchar(1024)
          GETDATE(), -- EffectiveStartDate - datetime
          'F' , -- SourceType - char(1)
          'Import file' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
		)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into StandardFee ...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT    sfs.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          0 , -- ModifierID - int
          fees.fee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_1_1_FeeSchedule] fees
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON
	sfs.PracticeID = 1
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	fees.cptcode = pcd.ProcedureCode
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into ContractRateScheduleLink ...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT    doc.DoctorID , -- ProviderID - int
          (SELECT ServicelocationID FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID) , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.ContractsAndFees_StandardFeeSchedule sfs, dbo.Doctor doc
WHERE sfs.PracticeID = @PracticeID AND
	  doc.PracticeID = @PracticeID
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
SELECT    pat.PatientID ,
          @PracticeID ,
          1 ,
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
				END ), 2) END) AS SMALLINT),app.[date])) , --Starttime 
			DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , app.[hmmss], 0) > 0 then  
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
								END ), 2) END) AS SMALLINT),app.[date])) , -- Endtime
          'P' ,
          '' ,
          app.notes ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          0 ,
          'S' ,
          pc.PatientCaseID ,
          dk.DKPracticeID ,
          dk.DKPracticeID ,
          CASE WHEN charindex( 'PM' , app.[hmmss] , 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') 
						ELSE (replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200) 
					  END
					  ELSE
						replace(replace(ltrim(right(CAST(app.[hmmss] AS DATETIME), 7)), 'AM', ''), ':', '')
		  END  ,
          CASE WHEN charindex( 'PM' , app.[hmmss], 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, CAST(15 AS SMALLINT), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(DATEADD(mi, CAST(15 AS SMALLINT), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '') 
						  ELSE (replace(replace(ltrim(right(DATEADD(mi, CAST(15 AS SMALLINT), CAST(app.[hmmss] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200) 
					  END
					  ELSE
						CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, CAST(15 AS SMALLINT), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
							 THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, CAST(15 AS SMALLINT), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '') 
			 			ELSE replace(replace(ltrim(right(DATEADD(mi, CAST(15 AS SMALLINT), CAST(app.[hmmss] AS DATETIME)), 7)), 'AM', ''), ':', '') 
						END 
		  END
FROM dbo.[_import_1_1_Appointments] app
INNER JOIN dbo.Patient pat ON 
    app.patientchartnumber = pat.VendorID AND
    pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON
	pc.PatientID = pat.PatientID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = (SELECT Dt FROM dbo.DateKeyToPractice WHERE Dt = CAST(app.date AS DATETIME))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into AppointmentToResource ...'
INSERT INTO dbo.AppointmentToResource 
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT    app.AppointmentID , -- AppointmentID - int
          doc.DoctorID , -- AppointmentResourceTypeID - int
          0 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment app
INNER JOIN dbo.Doctor doc ON 
	doc.PracticeID = @PracticeID AND
	doc.DoctorID = 1
WHERE app.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



COMMIT

