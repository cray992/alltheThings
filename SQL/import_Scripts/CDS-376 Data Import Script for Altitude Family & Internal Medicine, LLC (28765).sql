USE superbill_28765_dev
--USE superbill_28765_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 5

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
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
		  name , -- InsuranceCompanyName - varchar(128)
          '' , -- Notes - text
          [address] , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(zip) IN (4,8) THEN '0' + zip
			   WHEN LEN(zip) IN (5,9) THEN zip ELSE '' END , -- ZipCode - varchar(9)
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          LEFT(name , 50) , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_5_1_InsuranceCompanyList]
WHERE name <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



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
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          [State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Patient...'
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
          MaritalStatus ,
          HomePhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
		  PrimaryProviderID
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          middlename , -- MiddleName - varchar(64)
          patientlastname , -- LastName - varchar(64)
          suffix , -- Suffix - varchar(16)
          [address] , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(zipcode) IN (4,8) THEN '0' + zipcode
			   WHEN LEN(zipcode) IN (5,9) THEN zipcode ELSE '' END , -- ZipCode - varchar(9)
          'U' , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          hmphone , -- HomePhone - varchar(10)
          dob , -- DOB - datetime
          CASE WHEN LEN(ssn) >= 6 THEN RIGHT('000' + ssn , 9) ELSE '' END , -- SSN - char(9)
          ie.email , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          acct , -- MedicalRecordNumber - varchar(128)
          cellphone , -- MobilePhone - varchar(10)
          acct , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
		  CASE i.primaryprovider WHEN 'Pou, Danielle Kay' THEN 5
								 WHEN 'Braun, David' THEN 4
								 WHEN 'Hansen, Shara L' THEN 6
								 WHEN 'Hansen, Douglas B. C.' THEN 2
								 WHEN 'Sartor, Ashleigh' THEN 3 ELSE NULL END
FROM dbo.[_import_5_1_PatientDemographics] i
LEFT JOIN dbo.[_import_5_1_PatientEmail] ie ON
	i.acct = ie.account 
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
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



PRINT ''
PRINT 'Inserting Into Insurance Policy 1...'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
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
          i.pripolicy , -- PolicyNumber - varchar(32)
          i.prigroup , -- GroupNumber - varchar(32)
          CASE WHEN i.prirelation <> '' THEN i.prirelation ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.prirelation <> 'S' THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN i.prirelation <> 'S' THEN pripolicyhfirstname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.prirelation <> 'S' THEN pripolicyhmiddlename ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.prirelation <> 'S' THEN pripolicyhlastname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.prirelation <> 'S' THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.prirelation <> 'S' THEN i.pripolicy ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_5_1_PatientDemographics] i
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = i.acct AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.InsuranceCompanyPlanID = (SELECT TOP 1 icp2.InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan icp2
											   WHERE icp2.VendorID = LEFT(i.priinsco , 50)) AND
		icp.VendorImportID = @VendorImportID
WHERE i.priinsco <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Policy 2...'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
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
          i.secpolicy , -- PolicyNumber - varchar(32)
          i.secgroup , -- GroupNumber - varchar(32)
          CASE WHEN i.secrelation <> '' THEN i.secrelation ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.secrelation <> 'S' THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN i.secrelation <> 'S' THEN secpolicyhfirstname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.secrelation <> 'S' THEN secpolicyhmiddlename ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.secrelation <> 'S' THEN secpolicyhlastname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.secrelation <> 'S' THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.secrelation <> 'S' THEN i.secpolicy ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_5_1_PatientDemographics] i
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = i.acct AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.InsuranceCompanyPlanID = (SELECT TOP 1 icp2.InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan icp2
											   WHERE icp2.VendorID = LEFT(i.secinsco , 50)) AND
		icp.VendorImportID = @VendorImportID
WHERE i.secinsco <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Updating Patient Cases with no Policies as Self Pay...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11 ,
		Name = 'Self Pay'
FROM dbo.PatientCase pc
LEFT JOIN dbo.InsurancePolicy ip ON
		pc.PatientCaseID = ip.PatientCaseID  
WHERE pc.VendorImportID = @VendorImportID AND
      ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'



PRINT ''
PRINT 'Inserting into Standard Fee Schedule...'
      --Standard Fee Schedule
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
      VALUES  
                  ( 
                    @PracticeID , -- PracticeID - int
                    'Default Contract' , -- Name - varchar(128)
                    'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
                    GETDATE() , -- EffectiveStartDate - datetime
                    'F' , -- SourceType - char(1)
                    'Import File' , -- SourceFileName - varchar(256)
                    30 , -- EClaimsNoResponseTrigger - int
                    30 , -- PaperClaimsNoResponseTrigger - int
                    NULL , -- MedicareFeeScheduleGPCICarrier - int
                    NULL , -- MedicareFeeScheduleGPCILocality - int
                    NULL , -- MedicareFeeScheduleGPCIBatchID - int
                    NULL , -- MedicareFeeScheduleRVUBatchID - int
                    0 , -- AddPercent - decimal
                    15  -- AnesthesiaTimeIncrement - int
                  )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Standard Fee...'
      --StandardFee
      INSERT INTO dbo.ContractsAndFees_StandardFee
                  ( StandardFeeScheduleID ,
                    ProcedureCodeID ,
                    SetFee ,
                    AnesthesiaBaseUnits
                  )
      SELECT DISTINCT
                    sfs.[StandardFeeScheduleID], -- StandardFeeScheduleID - int
                    pcd.[ProcedureCodeDictionaryID] , -- ProcedureCodeID - int
                    Impsfs.fee , -- SetFee - money
                    0  -- AnesthesiaBaseUnits - int
      FROM dbo.[_import_5_1_FeeSchedule] AS Impsfs
      INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule AS sfs ON
            CAST(sfs.[Notes] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID  
      INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
            pcd.[ProcedureCode] = Impsfs.code
      WHERE fee > '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Standard Fee Schedule Link...'
      --Standard Fee Schedule Link
      INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
                  ( ProviderID ,
                    LocationID ,
                    StandardFeeScheduleID
                  )
      SELECT DISTINCT
                    doc.[DoctorID] , -- ProviderID - int
                    sl.[ServiceLocationID] , -- LocationID - int
                    sfs.[StandardFeeScheduleID]  -- StandardFeeScheduleID - int
      FROM dbo.Doctor AS doc, dbo.ServiceLocation AS sl, dbo.ContractsAndFees_StandardFeeSchedule AS sfs
      WHERE doc.[External] = 0 AND
            doc.[PracticeID] = @PracticeID AND
            sl.PracticeID = @PracticeID AND
            sfs.[Notes] = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID    
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
          EndTm ,
		  Notes
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          CASE i.location WHEN 'Littleton' THEN 1
						  WHEN 'Lakewood' THEN 2 ELSE 1 END , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          p.FirstName + ' ' + p.LastName + ' - ' + i.[resource] , -- Subject - varchar(64)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          i.resourcetypeid , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          starttm , -- StartTm - smallint
          endtm , -- EndTm - smallint
		  CASE WHEN i.typereasondetail = '' THEN '' ELSE 'Detail : ' + i.typereasondetail + CHAR(13) + CHAR(10) END + 
		 (CASE WHEN i.note = '' THEN '' ELSE 'Note: ' + i.note END)
FROM dbo.[_import_5_1_Appointment] i
INNER JOIN dbo.Patient p ON 
	i.account = p.VendorID AND
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase pc ON 
	i.account = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
	      a.AppointmentID , -- AppointmentID - int
          i.resourcetypeid , -- AppointmentResourceTypeID - int
          i.reourceid , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_5_1_Appointment] i
INNER JOIN dbo.Patient p ON
	i.account = p.VendorID AND 
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON
	p.PatientID = a.PatientID AND
	a.StartDate = CAST(i.startdate AS DATETIME) AND
	a.EndDate = CAST(i.enddate AS DATETIME) AND
	a.[Subject] = p.FirstName + ' ' + p.LastName + ' - ' + i.[resource] 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



--COMMIT
--ROLLBACK