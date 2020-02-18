USE superbill_15593_dev
--USE superbill_15593_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
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

DELETE FROM dbo.InsurancePolicy WHERE (PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@rowcount AS varchar(10)) + ' Insurance Policy records deleted '

DELETE FROM dbo.PatientCase WHERE PatientID IN (SELECT patientid FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@rowcount AS varchar(10)) + ' Patient Case records deleted '

DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@rowcount AS varchar(10)) + ' Patient records deleted '

DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@rowcount AS varchar(10)) + ' Insurance Company Plans records deleted '

DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@rowcount AS varchar(10)) + ' Insurance Companies records deleted '

DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE PracticeID = @PracticeID)
PRINT CAST(@@rowcount AS varchar(10)) + ' Standard Fee Schedule Link records deleted '

DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE PracticeID = @PracticeID)
PRINT CAST(@@rowcount AS varchar(10)) + ' Standard Fee records deleted '

DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE PracticeID = @PracticeID
PRINT CAST(@@rowcount AS varchar(10)) + ' Standard Fee Schedule records deleted '

DELETE FROM dbo.ContractsAndFees_ContractRateScheduleLink WHERE ContractRateScheduleID IN (SELECT ContractRateScheduleID FROM dbo.ContractsAndFees_ContractRateSchedule WHERE PracticeID = @PracticeID)
PRINT CAST(@@rowcount AS varchar(10)) + ' Contract Rate Schedule Link records deleted '

DELETE FROM dbo.ContractsAndFees_ContractRate WHERE ContractRateScheduleID IN (SELECT ContractRateScheduleID FROM dbo.ContractsAndFees_ContractRateSchedule WHERE PracticeID = @PracticeID)
PRINT CAST(@@rowcount AS varchar(10)) + ' Contract Rate records deleted '

DELETE FROM dbo.ContractsAndFees_ContractRateSchedule WHERE PracticeID = @PracticeID AND InsuranceCompanyID = 2
PRINT CAST(@@rowcount AS varchar(10)) + ' Contract Rate Schedule records deleted '

DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@rowcount AS varchar(10)) + ' Doctor records deleted '



PRINT ''
PRINT 'Inserting into Doctor ....'
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
          ZipCode ,
          HomePhone ,
          WorkPhone ,
          PagerPhone ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          TaxonomyCode ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix
          firstname , -- FirstName - varchar(64)
		  '' , -- MiddleName
          lastname , -- LastName - varchar(64)
		  '' , -- Suffix
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          LEFT(REPLACE(REPLACE(zipcode, '-', ''), ' ', ''), 9) , -- ZipCode - varchar(9)
          LEFT(REPLACE(home, '-', ''), 10) , -- HomePhone - varchar(10)
          LEFT(REPLACE(office, '-', ''), 10) , -- WorkPhone - varchar(10)
          LEFT(REPLACE(beeper, '-', ''), 10) , -- PagerPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN taxonomy IN (SELECT [TaxonomyCode] FROM dbo.TaxonomyCode) THEN taxonomy
		  ELSE NULL
		  END , -- TaxonomyCode - char(10)
          code , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(REPLACE(fax, '-', ''), 10) , -- FaxNumber - varchar(10)
          1 , -- External - bit
          npi -- NPI - varchar(10)
FROM [dbo].[_import_1_1_RefDr]

PRINT''
PRINT'Inserting into Insurance Company ....'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Phone ,
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
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT    name , -- InsuranceCompanyName - varchar(128)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          REPLACE(zipcode, '-', '') , -- ZipCode - varchar(9)
          CASE LEFT(phone1, 1) WHEN '1' THEN  REPLACE(RIGHT(phone1, LEN(phone1) - 1), '-', '') -- Phone - varchar(10)
							   ELSE REPLACE(phone1, '-', '')
		  END ,
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE()  , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          code , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_1_1_Insurance]
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Insurance Company Plan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
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
SELECT    InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.InsuranceCompany
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


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
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,
		  ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled,
		  ReferringPhysicianID
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pt.fname , -- FirstName - varchar(64)
          pt.mi , -- MiddleName - varchar(64)
          pt.lname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pt.address1 , -- AddressLine1 - varchar(256)
          pt.address2 , -- AddressLine2 - varchar(256)
          pt.city , -- City - varchar(128)
          pt.state , -- State - varchar(2)
          LEFT(REPLACE(pt.zipcode, '-', ''), 9) , -- ZipCode - varchar(9)
          pt.sex , -- Gender - varchar(1)
          'U' , -- MaritalStatus - varchar(1)
          LEFT(REPLACE(pt.home, '-', ''), 10) , -- HomePhone - varchar(10)
          LEFT(REPLACE(pt.wphone, '-', ''), 10) , -- WorkPhone - varchar(10)
          pt.wkext , -- WorkPhoneExt - varchar(10)
          pt.dateofbirth , -- DOB - datetime
          REPLACE(pt.ssn, '-', '') , -- SSN - char(9)
          pt.email , -- EmailAddress - varchar(256)
          CASE pt.guarantor WHEN 'Y' THEN 1
		                             ELSE 0
		  END , -- ResponsibleDifferentThanPatient - bit
          CASE pt.guarantor WHEN 'Y' THEN guarfirstname
		                             ELSE ''
		  END , -- ResponsibleFirstName - varchar(64)
          CASE pt.guarantor WHEN 'Y' THEN guarmiddlename
		                             ELSE ''
		  END , -- ResponsibleMiddleName - varchar(64)
          CASE pt.guarantor WHEN 'Y' THEN guarlastname
		                             ELSE ''
		  END , -- ResponsibleLastName - varchar(64)
          CASE pt.guarantor WHEN 'Y' THEN 'O'
		                             ELSE ''
		  END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE pt.guarantor WHEN 'Y' THEN gaddress1
		                             ELSE ''
		  END , -- ResponsibleAddressLine1 - varchar(256)
          CASE pt.guarantor WHEN 'Y' THEN gaddress2
		                             ELSE ''
		  END , -- ResponsibleAddressLine2 - varchar(256)
          CASE pt.guarantor WHEN 'Y' THEN gcity
		                             ELSE ''
		  END , -- ResponsibleCity - varchar(128)
          CASE pt.guarantor WHEN 'Y' THEN gstate
		                             ELSE ''
		  END , -- ResponsibleState - varchar(2)
          CASE pt.guarantor WHEN 'Y' THEN REPLACE(gzipcode, '-', '')
		                             ELSE ''
		  END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE pt.employed WHEN 'Y' THEN 'E'
		                            ELSE 'U'
		  END , -- EmploymentStatus - char(1)
          LEFT(REPLACE(cellphone, '-', ''), 10) , -- MobilePhone - varchar(10)
          pt.idnum , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          CASE pt.email WHEN '' THEN 0
		                ELSE 1
		  END , -- SendEmailCorrespondence - bit
          1 , -- PhonecallRemindersEnabled - bit
		  DoctorID -- ReferringPhysicianID
FROM [dbo].[_import_1_1_PATIENT] AS pt
JOIN dbo.Doctor AS doc
ON pt.refdr = doc.VendorID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Patient Case ...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import.  Please Review.' , -- Notes - text
          1 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Insurance Policy ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          Notes ,
          Copay ,
          Deductible ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          CASE ptin.inslevel WHEN 'P' THEN 1
		                     WHEN 'S' THEN 2
						     WHEN 'T' THEN 3
		  END , -- Precedence - int
          ptin.policy , -- PolicyNumber - varchar(32)
          ptin.groupno , -- GroupNumber - varchar(32)
          CASE ptin.relationship WHEN 'C' THEN 'C'
		                         WHEN 'P' THEN 'U'
							     WHEN 'S' THEN 'S'
							     ELSE 'O'
		  END , -- PatientRelationshipToInsured - varchar(1)
          CASE ptin.relationship WHEN 'S' THEN ''
		                         ELSE ptin.fname
		  END , -- HolderFirstName - varchar(64)
          CASE ptin.relationship WHEN 'S' THEN ''
		                         ELSE ptin.mi 
		  END , -- HolderMiddleName - varchar(64)
          CASE ptin.relationship WHEN 'S' THEN ''
		                         ELSE ptin.lname
		  END , -- HolderLastName - varchar(64)
          CASE ptin.relationship WHEN 'S' THEN ''
		                         ELSE ptin.dob
		  END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE ptin.relationship WHEN 'S' THEN ''
		                         ELSE ptin.sex 
		  END , -- HolderGender - char(1)
          'Created via Data Import.  Please Review' , -- Notes - text
          ptin.copay , -- Copay - money
          ptin.deductible , -- Deductible - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ptin.patid , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM [dbo].[_import_1_1_PatIns] AS ptin
JOIN dbo.PatientCase AS pc
ON pc.VendorID=ptin.patid AND pc.VendorImportID=@VendorImportID
JOIN dbo.InsuranceCompanyPlan AS icp
ON icp.VendorID=ptin.inscode
WHERE ptin.idnum NOT IN (23202,24040,24041,26395,26637,28639,28871,30704,30755,20584,20711,21031,21179,21195,22114,25820,30570,26279)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Contracts and Fees, Contract Rate Schedule'
INSERT INTO dbo.ContractsAndFees_ContractRateSchedule
        ( PracticeID ,
          InsuranceCompanyID ,
          EffectiveStartDate ,
          EffectiveEndDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          AddPercent ,
          AnesthesiaTimeIncrement ,
          Capitated
        )
VALUES  ( @PracticeID , -- PracticeID - int
          2 , -- InsuranceCompanyID - int
          GETDATE() , -- EffectiveStartDate - datetime
          DATEADD(dd, -1, DATEADD(yy, 1, GETDATE())) , -- EffectiveEndDate - datetime
          'F' , -- SourceType - char(1)
          'Import File' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          0 , -- AddPercent - decimal
          15 , -- AnesthesiaTimeIncrement - int
          0  -- Capitated - bit
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Contracts and Fees, Contract Rate Schedule'
INSERT INTO dbo.ContractsAndFees_ContractRate
        ( ContractRateScheduleID ,
          ProcedureCodeID ,
          SetFee ,
		  AnesthesiaBaseUnits
        )
SELECT    crs.ContractRateScheduleID , -- ContractRateScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          cpt.medicarepriceinsurancespecificfeeschedule , -- SetFee - money
		  0 -- AnesthesiaBaseUnits
FROM dbo.[_import_1_1_Cpt] AS cpt
JOIN dbo.ContractsAndFees_ContractRateSchedule AS crs
ON PracticeID = @PracticeID
JOIN dbo.ProcedureCodeDictionary AS pcd
ON cpt.code=pcd.procedurecode
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Contracts and Fees, Contract Rate Schedule Link'
INSERT INTO dbo.ContractsAndFees_ContractRateScheduleLink
        ( ProviderID ,
          LocationID ,
          ContractRateScheduleID
        )
SELECT    doc.doctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          crs.ContractRateScheduleID  -- StandardFeeScheduleID - int
FROM [dbo].Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_ContractRateSchedule crs
WHERE doc.[External] <> 1 AND 
doc.PracticeID = @PracticeID AND
sl.PracticeID = @PracticeID AND
crs.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Contracts and Fees, Standard Fee Schedule'
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
VALUES  ( @PracticeID , -- PracticeID - int
          'Default Contract' , -- Name - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          GETDATE() , -- EffectiveStartDate - datetime
          'F' , -- SourceType - char(1)
          'Import File' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
		)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Contracts and Fees, Standard Fee'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          SetFee 
        )
SELECT    sfs.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          cpt.standard  -- SetFee - money
FROM [dbo].[_import_1_1_Cpt] AS cpt
JOIN dbo.ContractsAndFees_StandardFeeSchedule AS sfs
ON PracticeID = 1--@PracticeID
JOIN dbo.ProcedureCodeDictionary AS pcd
ON cpt.code=pcd.ProcedureCode
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Contracts and Fees, Standard Fee Schedule Link'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT    doc.doctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM [dbo].Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs
WHERE doc.[External] <> 1 AND 
doc.PracticeID = @PracticeID AND
sl.PracticeID = @PracticeID AND
sfs.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT TRAN 


