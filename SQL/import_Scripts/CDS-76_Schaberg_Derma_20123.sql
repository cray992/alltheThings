--USE superbill_20123_dev
USE superbill_20123_prod
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

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT patientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'

UPDATE dbo._import_3_1_InsuranceCompanyPlanList 
	SET [plan] = 'UNITED HEALTHCARE INSURANCE COMPANY-1'
	WHERE AutoTempID = 170

PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany
	(    InsuranceCompanyName,
		CreatedPracticeID,
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID,
		VendorID,
		VendorImportID,
		BillSecondaryInsurance ,
		EClaimsAccepts ,
		BillingFormID ,
		InsuranceProgramCode ,
		HCFADiagnosisReferenceFormatCode ,
		HCFASameAsInsuredFormatCode ,
		DefaultAdjustmentCode ,
		ReferringProviderNumberTypeID ,
		NDCFormat ,
		UseFacilityID ,
		AnesthesiaType ,
		InstitutionalBillingFormID,
		SecondaryPrecedenceBillingFormID 
	)
SELECT  DISTINCT
		ic.[company]
		,@PracticeID
		,GETDATE()
		,0
		,GETDATE()
		,0
		,ic.id  -- Hope it's unique!
		,@VendorImportID
		,0  -- BillSecondaryInsurance - bit
		,0 -- EClaimsAccepts - bit
		,13  -- BillingFormID - int
		,'CI'  -- InsuranceProgramCode - char(2)
		,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
		,'D'  -- HCFASameAsInsuredFormatCode - char(1)
		,NULL -- DefaultAdjustmentCode - varchar(10)
		,NULL  -- ReferringProviderNumberTypeID - int
		,1  -- NDCFormat - int
		,1 -- UseFacilityID - bit
		,'U'  -- AnesthesiaType - varchar(1)
		,18  -- InstitutionalBillingFormID - int,
		,13
FROM [dbo].[_import_3_1_InsuranceCompanyPlanList] ic
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--InsuranceCompanyPlan
PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
		  AddressLine1 ,
		  AddressLine2 ,
		  city ,
		  State ,
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
		  icp.[plan] , -- PlanName - varchar(128)
		  icp.address1 ,
		  icp.address2 ,
		  icp.city ,
		  icp.[State] ,
		  icp.zip ,
		  icp.phone ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo._import_3_1_InsuranceCompanyPlanList icp
INNER JOIN dbo.InsuranceCompany ic ON 
	icp.id = ic.VendorID AND
	ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--Patient
PRINT ''
PRINT 'Inserting into Patient ...'
INSERT INTO dbo.Patient
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Gender , 
          MaritalStatus , 
          HomePhone ,
          WorkPhone ,
          MobilePhone ,
          DOB ,
          SSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT DISTINCT 
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.[firstname] , -- FirstName - varchar(64)
          pat.[middlename] , -- MiddleName - varchar(64)
          pat.[lastname] , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.[address1] , -- AddressLine1 - varchar(256)
          pat.[city] , -- City - varchar(128)
          pat.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          pat.[zip] , -- ZipCode - varchar(9)
          pat.[gender] ,
          pat.[maritalstatus], -- MaritalStatus
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[home], '(', ''), ')', ''), '-', ''), ' ', ''), 10) , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[work], '(', ''), ')', ''), '-', ''), ' ', ''), 10) , -- WorkPhone - varchar(10)
		  LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[mobile], '(', ''), ')', ''), '-', ''), ' ', ''), 10) , -- MobilePhone - varchar(10)
          CASE WHEN ISDATE(pat.[dob]) = 1 THEN pat.[dob] ELSE NULL END , -- DOB - datetime
          LEFT(REPLACE(pat.ssn, '-', ''), 9) , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.patientid , -- MedicalRecordNumber
          pat.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo._import_3_1_PatientDemo pat
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--PatientCase
PRINT ''
PRINT 'Inserting into PatientCase ...'
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
SELECT    pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import, please review.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pat
WHERE pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--InsurancePolicy #1
PRINT ''
PRINT 'Inserting into InsurancePolicy 1 ...'
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
          HolderFirstName ,
          HolderLastName ,
          HolderMiddleName ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT     
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pol.primarypolicy , -- PolicyNumber - varchar(32)
          pol.primarygroup , -- GroupNumber - varchar(32)
          CASE pol.primarysubrelation WHEN 'Self' THEN 'S'
									  WHEN 'Child' THEN  'C'
									  WHEN 'Spouse' THEN 'U'
									  WHEN 'Other' THEN 'O'
										ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pol.primarysubrelation = 'Self' THEN '' 
				 ELSE pol.primarysubfirstname END , -- HolderFirstName - varchar(64)
		  CASE WHEN pol.primarysubrelation =  'Self' THEN ''
				ELSE pol.primarysublastname END , -- HolderLastName - varchar(64)				
          CASE WHEN pol.primarysubrelation = 'Self' THEN ''
				ELSE pol.primarysubmiddlename END , -- HolderMiddleName - varchar(64)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.AutoTempID , -- VendorID - varchar(50)
          @VendorImportId  -- VendorImportID - int
FROM dbo.[_import_3_1_InsurancePolicy] pol 
INNER JOIN dbo.PatientCase pc ON
	pol.patientid = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	pol.primaryinsurance = icp.PlanName AND
	icp.VendorImportID = @VendorImportID
WHERE pol.patientid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--InsurancePolicy #2
PRINT ''
PRINT 'Inserting into InsurancePolicy 2 ...'
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
          HolderFirstName ,
          HolderLastName ,
          HolderMiddleName ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT     
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          pol.secondarypolicy , -- PolicyNumber - varchar(32)
          pol.secondarygroup , -- GroupNumber - varchar(32)
          CASE pol.secondaryrelation WHEN 'Self' THEN 'S'
									  WHEN 'Child' THEN  'C'
									  WHEN 'Spouse' THEN 'U'
									  WHEN 'Other' THEN 'O'
										ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pol.secondaryrelation = 'Self' THEN '' 
				 ELSE pol.secondarysubfirstname END , -- HolderFirstName - varchar(64)
		  CASE WHEN pol.secondaryrelation =  'Self' THEN ''
				ELSE pol.secondarysublastname END , -- HolderLastName - varchar(64)				
          CASE WHEN pol.secondaryrelation = 'Self' THEN ''
				ELSE pol.secondarysubmiddlename END , -- HolderMiddleName - varchar(64)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.AutoTempID , -- VendorID - varchar(50)
          @VendorImportId  -- VendorImportID - int
FROM dbo.[_import_3_1_InsurancePolicy] pol 
INNER JOIN dbo.PatientCase pc ON
	pol.patientid = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	pol.secondaryinsurance = icp.PlanName AND
	icp.VendorImportID = @VendorImportID
WHERE pol.patientid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment ....'
INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
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
          1 ,
          1  ,
          DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , app.[appointmenttime], 0) > 0 then  
					   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
							THEN  replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '')
							ELSE (replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
							END
						ELSE
							CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
								THEN REPLACE(replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 				ELSE replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', '')
							END 
						END ), 2) AS SMALLINT), 
				  DATEADD(hh, CAST(
						(CASE WHEN (LEFT((CASE WHEN charindex( 'PM' , app.[appointmenttime], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 2)) > 24 
						THEN  left((CASE WHEN charindex( 'PM' , app.[appointmenttime], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 1)
						ELSE  left((CASE WHEN charindex( 'PM' , app.[appointmenttime], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
				END ), 2) END) AS SMALLINT),app.[appointmentdate])) , --Starttime 
			DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , app.[appointmenttime], 0) > 0 then  
					   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
							THEN  replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
							ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
							END
						ELSE
							CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
								THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 				ELSE replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
							END 
						END ), 2) AS SMALLINT), 
				DATEADD(hh, CAST(
					(CASE WHEN (LEFT((CASE WHEN charindex( 'PM' , app.[appointmenttime], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 2)) > 24 
					THEN  left((CASE WHEN charindex( 'PM' , app.[appointmenttime], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 1)
					ELSE  left((CASE WHEN charindex( 'PM' , app.[appointmenttime], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 2) END) AS SMALLINT),app.[appointmentdate])) , -- Endtime
          'P' ,
          '' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          0 ,
          'S' ,
          pc.PatientCaseID ,
          dk.DKPracticeID ,
          dk.DKPracticeID ,
          CASE WHEN charindex( 'PM' , app.[appointmenttime] , 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '') 
						ELSE (replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200) 
					  END
					  ELSE
						replace(replace(ltrim(right(CAST(app.[appointmenttime] AS DATETIME), 7)), 'AM', ''), ':', '')
		  END  ,
          CASE WHEN charindex( 'PM' , app.[appointmenttime], 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '') 
						  ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200) 
					  END
					  ELSE
						CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
							 THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '') 
			 			ELSE replace(replace(ltrim(right(DATEADD(mi, cast(15 AS smallint), CAST(app.[appointmenttime] AS DATETIME)), 7)), 'AM', ''), ':', '') 
						END 
		  END
FROM dbo._import_3_1_Appointment app
INNER JOIN dbo.Patient pat ON 
    app.patientid = pat.VendorID AND
    pat.PracticeID = 1
INNER JOIN dbo.PatientCase pc ON
	pc.PatientID = pat.PatientID AND
	pc.PracticeID = 1
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = 1 AND
	dk.Dt = (SELECT Dt FROM dbo.DateKeyToPractice WHERE Dt = CAST(app.appointmentdate AS DATETIME))
PRINT CAST(@@rowcount AS VARCHAR) + ' records inserted'

COMMIT