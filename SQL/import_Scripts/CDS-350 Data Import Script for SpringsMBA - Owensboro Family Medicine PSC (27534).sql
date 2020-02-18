USE superbill_27534_dev
--USE superbill_27534_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @OldVendorImportID INT


SET @PracticeID = 1
SET @VendorImportID = 2
SET @OldVendorImportID = 1



PRINT ''
PRINT 'Deleting Duplicate Patient Record from _import_2_1_PatientDemographics '
DELETE FROM dbo.[_import_2_1_PatientDemographics] WHERE chartnumber = '906'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '


PRINT ''
PRINT 'Updating ResponsibleDifferentThanPatient to 0...'
UPDATE dbo.Patient 
	SET ResponsibleDifferentThanPatient = 0
FROM dbo.Patient p
INNER JOIN dbo.[_import_2_1_PatientDemographics] i ON
	i.responsiblepartyrelationship = 'S' AND
	p.MedicalRecordNumber = i.chartnumber AND
	p.VendorImportID = @OldVendorImportID 
WHERE p.ModifiedUserID = 0
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Updating Insurance Company Records with VendorID from Imported Insurance Company Plans...'
--Imported Insurance Companies were merged into User Created Records
UPDATE dbo.InsuranceCompany 
	SET VendorImportID = @OldVendorImportID ,
	    VendorID = icp.VendorID
FROM dbo.InsuranceCompany ic
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	ic.InsuranceCompanyID = icp.InsuranceCompanyID AND
	icp.VendorImportID = @OldVendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Inserting Into Insurance Company from i.InsuranceCode1...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
		  i.insuranceplanname1 , -- InsuranceCompanyName - varchar(128)
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          insurancecode1 , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_PatientDemographics] i
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE i.insurancecode1 = ic.VendorID)
AND i.insuranceplanname1 <>  ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
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
		  InsuranceCompanyName , -- PlanName - varchar(128)
          CreatedDate , -- CreatedDate - datetime
          CreatedUserID , -- CreatedUserID - int
          ModifiedDate , -- ModifiedDate - datetime
          ModifiedUserID , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany where VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '




PRINT ''
PRINT 'Updating Patient Cases that were incorrectly imported and not modified by user to Inactive...'
UPDATE dbo.PatientCase
	SET Active = 0
WHERE ModifiedUserID = 0 AND CreatedUserID = 0 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '

PRINT ''
PRINT 'Inserting Into Patient Case where the patient record has not been modified by user...'
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
		  p.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          CASE WHEN defaultcase <> '' THEN ps.PayerScenarioID ELSE 5 END , -- PayerScenarioID - int
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
          i.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient p
INNER JOIN dbo.[_import_2_1_PatientDemographics] i ON
	p.MedicalRecordNumber = i.chartnumber AND
	p.VendorImportID = @OldVendorImportID
LEFT JOIN dbo.PayerScenario ps ON
	i.defaultcase = ps.Name
WHERE p.ModifiedUserID = 0 AND CreatedUserID = 0
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Insurance Policy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
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
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.policynumber1 , -- PolicyNumber - varchar(32)
          i.groupnumber1 , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.policy1startdate) = 1 THEN i.policy1startdate ELSE NULL END  , -- PolicyStartDate - datetime
          CASE i.patientrelationship1 WHEN '' THEN 'S' ELSE i.patientrelationship1 END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.patientrelationship1 <> 'S' THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1firstname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1middlename ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1lastname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientrelationship1 <> 'S' THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.patientrelationship1 <> 'S' THEN (CASE i.holder1gender WHEN '' THEN 'U' ELSE i.holder1gender END) ELSE NULL END , -- HolderGender - char(1)
          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1street1 ELSE NULL END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.patientrelationship1 <> 'S' THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.patientrelationship1 <> 'S' THEN '' END , -- HolderCity - varchar(128)
          CASE WHEN i.patientrelationship1 <> 'S' THEN '' END , -- HolderState - varchar(2)
          CASE WHEN i.patientrelationship1 <> 'S' THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.patientrelationship1 <> 'S' THEN '' END , -- HolderZipCode - varchar(9)
          CASE WHEN i.patientrelationship1 <> 'S' THEN i.policynumber1 ELSE NULL END, -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_2_1_PatientDemographics] i
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = i.chartnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = i.insurancecode1 AND
	icp.VendorImportID IN (@OldVendorImportID, @VendorImportID)
WHERE i.insurancecode1 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
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
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.policynumber2 , -- PolicyNumber - varchar(32)
          i.groupnumber2 , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.policy2startdate) = 2 THEN i.policy2startdate ELSE NULL END  , -- PolicyStartDate - datetime
          CASE i.patientrelationship2 WHEN '' THEN 'S' ELSE i.patientrelationship2 END , -- PatientRelationshipToInsured - varchar(2)
          CASE WHEN i.patientrelationship2 <> 'S' THEN '' ELSE NULL END , -- HolderPrefix - varchar(26)
          CASE WHEN i.patientrelationship2 <> 'S' THEN i.holder2firstname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.patientrelationship2 <> 'S' THEN i.holder2middlename ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientrelationship2 <> 'S' THEN i.holder2lastname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientrelationship2 <> 'S' THEN '' ELSE NULL END , -- HolderSuffix - varchar(26)
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.patientrelationship2 <> 'S' THEN (CASE i.holder2gender WHEN '' THEN 'U' ELSE i.holder2gender END) ELSE NULL END , -- HolderGender - char(2)
          CASE WHEN i.patientrelationship2 <> 'S' THEN i.holder2street2 ELSE NULL END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.patientrelationship2 <> 'S' THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.patientrelationship2 <> 'S' THEN i.holder2city ELSE NULL END , -- HolderCity - varchar(228)
          CASE WHEN i.patientrelationship2 <> 'S' THEN i.holder2state ELSE NULL END , -- HolderState - varchar(2)
          CASE WHEN i.patientrelationship2 <> 'S' THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.patientrelationship2 <> 'S' THEN i.holder2zipcode ELSE NULL END , -- HolderZipCode - varchar(9)
          CASE WHEN i.patientrelationship2 <> 'S' THEN i.policynumber2 ELSE NULL END, -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_2_1_PatientDemographics] i
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = i.chartnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = i.insurancecode2 AND
	icp.VendorImportID IN (@OldVendorImportID, @VendorImportID)
WHERE i.insurancecode2 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          CASE WHEN pc.PatientCaseID IS NULL THEN (SELECT TOP 1 PatientCaseID FROM dbo.PatientCase
												   WHERE PatientID = p.PatientID AND Active = 1 AND VendorID = p.VendorID AND VendorImportID = @OldVendorImportID)
												   ELSE pc.PatientCaseID END , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_2_1_Appointment] i
INNER JOIN dbo.Patient p ON
	i.pat = p.MedicalRecordNumber AND
	p.VendorImportID = @OldVendorImportID
LEFT JOIN dbo.PatientCase pc ON
	i.pat = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice dk ON
    dk.[PracticeID] = @PracticeID AND
    dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)   
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Appointment to Resource for Type 1...'
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
          CASE i.resources WHEN 'Bickel, Lauren' THEN 9
						   WHEN 'Bryant, Bill' THEN 5
						   WHEN 'Wahl, Gary' THEN 8
						   WHEN 'Vaught, Lisa' THEN 7 
						   WHEN 'Keeley, Benjamin' THEN 2
						   WHEN 'Phelps, Leslie' THEN 6 END, -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_Appointment] i
INNER JOIN dbo.Patient p ON
	i.pat = p.MedicalRecordNumber AND
	p.VendorImportID = @OldVendorImportID
INNER JOIN dbo.Appointment a ON
	p.PatientID = a.PatientID AND
	CAST(i.startdate AS DATETIME) = a.StartDate AND
	CAST(i.enddate AS DATETIME) = a.EndDate
WHERE i.resources <> 'LAB'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Appointment to Resource for Type 2...'
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
FROM dbo.[_import_2_1_Appointment] i
INNER JOIN dbo.Patient p ON
	i.pat = p.MedicalRecordNumber AND
	p.VendorImportID = @OldVendorImportID
INNER JOIN dbo.Appointment a ON
	p.PatientID = a.PatientID AND
	CAST(i.startdate AS DATETIME) = a.StartDate AND
	CAST(i.enddate AS DATETIME) = a.EndDate
INNER JOIN dbo.PracticeResource pr ON
	i.resources = pr.ResourceName AND
	pr.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
FROM dbo.[_import_2_1_Appointment] i
INNER JOIN dbo.Patient p ON
	i.pat = p.MedicalRecordNumber AND
	p.VendorImportID = @OldVendorImportID
INNER JOIN dbo.Appointment a ON
	p.PatientID = a.PatientID AND
	CAST(i.startdate AS DATETIME) = a.StartDate AND
	CAST(i.enddate AS DATETIME) = a.EndDate
INNER JOIN dbo.AppointmentReason ar ON
	i.apptreason = ar.Name AND
	ar.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
	
	

PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
	
--COMMIT
--ROLLBACK


