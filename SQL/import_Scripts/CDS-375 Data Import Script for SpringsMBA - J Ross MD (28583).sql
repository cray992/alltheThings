USE superbill_28583_dev
--USE superbill_28583_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 4
SET @PracticeID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
--DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = -50 AND ModifiedUserID = -50
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'

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
		  InsuranceCompanyName , -- InsuranceCompanyName - varchar(128)
          InsuranceStreet1 , -- AddressLine1 - varchar(256)
          InsuranceStreet2 , -- AddressLine2 - varchar(256)
          InsuranceCity , -- City - varchar(128)
          InsuranceState , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(InsuranceZip, '-','') , -- ZipCode - varchar(9)
          InsurancePhone , -- Phone - varchar(10)
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
          InsuranceID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_4_1_InsuranceCompanyPlanList]
WHERE insuranceid <> ''
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
	      InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          [State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
		  employername , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.[_import_4_1_PatientDemographics]
WHERE employername <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Patient...'
SET IDENTITY_INSERT dbo.Patient ON
INSERT INTO dbo.Patient
        ( PatientID ,
		  PracticeID ,
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
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  i.chartnumber , -- PatientID
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          LEFT(i.FirstName, 64) , -- FirstName - varchar(64)
          LEFT(i.MiddleInitial, 64) , -- MiddleName - varchar(64)
          LEFT(i.LastName, 64) , -- LastName - varchar(64)
          i.Suffix , -- Suffix - varchar(16)
          i.Street1 , -- AddressLine1 - varchar(256)
          i.Street2 , -- AddressLine2 - varchar(256)
          i.City , -- City - varchar(128)
          i.[State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(i.ZipCode, '-', '') , -- ZipCode - varchar(9)
          CASE WHEN i.gender = '' THEN 'U' ELSE i.gender END , -- Gender - varchar(1)
          i.maritalstatus , -- MaritalStatus - varchar(1)
          i.homephone , -- HomePhone - varchar(10)
          i.workphone , -- WorkPhone - varchar(10)
          i.workextension , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(i.dateofbirth) = 1 THEN i.dateofbirth ELSE NULL END , -- DOB - datetime
          i.socialsecuritynumber , -- SSN - char(9)
          i.email , -- EmailAddress - varchar(256)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN i.responsiblepartyrelationship <> '' THEN '' ELSE NULL END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartyfirstname ELSE NULL END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartymiddlename ELSE NULL END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartylastname ELSE NULL END , -- ResponsibleLastName - varchar(64)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartysuffix ELSE NULL END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartyrelationship ELSE NULL END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartyaddress1 ELSE NULL END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartyaddress2 ELSE NULL END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartycity ELSE NULL END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartystate ELSE NULL END , -- ResponsibleState - varchar(2)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN '' ELSE NULL END , -- ResponsibleCountry - varchar(32)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN REPLACE(i.responsiblepartyzipcode, '-','') ELSE NULL END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.employername <> '' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
          2 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          e.EmployerID , -- EmployerID - int
          2 , -- PrimaryCarePhysicianID - int
          i.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_4_1_PatientDemographics] i
	LEFT JOIN dbo.Employers e ON
		i.employername = e.EmployerName AND
		e.CreatedUserID = -50
WHERE i.chartnumber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.Patient OFF
 

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
		  p.PatientID , -- PatientID - int
          i.defaultcase , -- Name - varchar(128)
          1 , -- Active - bit
          CASE i.defaultcase WHEN '1 -Commercial' THEN 5
							 WHEN '3 -Medicare' THEN 7
							 WHEN '3 -Anthem BCBS' THEN 3
							 WHEN '4-Medicaid' THEN 8 
							 WHEN '2 -BCBS' THEN 3
							 WHEN '3 -Medicaid' THEN 8 ELSE 5 END, -- PayerScenarioID - int
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
          p.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient p
	INNER JOIN dbo.[_import_4_1_PatientDemographics] i ON
		i.chartnumber = p.VendorID AND
		p.VendorImportID = @VendorImportID
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient Alert...'
INSERT INTO dbo.PatientAlert
        ( PatientID ,
          AlertMessage ,
          ShowInPatientFlag ,
          ShowInAppointmentFlag ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Converted Patient' , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          1 , -- ShowInAppointmentFlag - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.Patient WHERE VendorImportID = @VendorImportID
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
          CASE WHEN ISDATE(i.policy1startdate) = 1 THEN i.policy1startdate ELSE NULL END , -- PolicyStartDate - datetime
          CASE i.patientrelationship1 WHEN 'CHILD' THEN 'C'
									  WHEN 'U' THEN 'U'
									  WHEN 'OTHER' THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.patientrelationship1 <> '' THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN i.patientrelationship1 <> '' THEN holder1firstname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.patientrelationship1 <> '' THEN holder1middlename ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientrelationship1 <> '' THEN holder1lastname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientrelationship1 <> '' THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.patientrelationship1 <> '' THEN CASE i.holder1gender WHEN '' THEN 'U' ELSE i.holder1gender END ELSE NULL END , -- HolderGender - char(1)
          CASE WHEN i.patientrelationship1 <> '' THEN i.policynumber1 ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_4_1_PatientDemographics] i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON	
		icp.VendorID = i.insurancecode1 AND
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON
		i.chartnumber = pc.VendorID AND
		pc.VendorImportID = @VendorImportID
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
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation ,
		  HolderAddressLine1 ,
		  HolderAddressLine2 ,
		  HolderCity ,
		  HolderState ,
		  HolderZipCode
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.policynumber2 , -- PolicyNumber - varchar(32)
          i.groupnumber2 , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.policy2startdate) = 1 THEN i.policy2startdate ELSE NULL END , -- PolicyStartDate - datetime
          CASE i.patientrelationship2 WHEN 'CHILD' THEN 'C'
									  WHEN 'U' THEN 'U'
									  WHEN 'OTHER' THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(2)
          CASE WHEN i.patientrelationship2 <> '' THEN '' ELSE NULL END , -- HolderPrefix - varchar(26)
          CASE WHEN i.patientrelationship2 <> '' THEN holder2firstname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.patientrelationship2 <> '' THEN holder2middlename ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientrelationship2 <> '' THEN holder2lastname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientrelationship2 <> '' THEN '' ELSE NULL END , -- HolderSuffix - varchar(26)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.patientrelationship2 <> '' THEN CASE i.holder2gender WHEN '' THEN 'U' ELSE i.holder2gender END ELSE NULL END , -- HolderGender - char(2)
          CASE WHEN i.patientrelationship2 <> '' THEN i.policynumber2 ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          2 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y' , -- ReleaseOfInformation - varchar(1)
		  i.holder2street1 ,
		  i.holder2street2 , 
		  i.holder2city ,
		  i.holder2state ,
		  i.holder2zipcode 
FROM dbo.[_import_4_1_PatientDemographics] i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON	
		icp.VendorID = i.insurancecode2 AND
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON
		i.chartnumber = pc.VendorID AND
		pc.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 ,
		  Name = 'Self Pay'
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = 1 AND
              ip.PatientCaseID IS NULL AND
			  pc.PayerScenarioID = 5
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
          p.FirstName + ' ' + p.LastName + ' - ' + p.VendorID , -- Subject - varchar(64)
          CASE WHEN i.dr = 5 THEN 'Hospital' + CHAR(13) + CHAR(10) + [description] ELSE [description]  END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID  , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_4_1_Appointment] i
	INNER JOIN dbo.Patient p ON
		i.pat = p.VendorID AND
		p.VendorImportID = p.VendorImportID
	INNER JOIN dbo.PatientCase pc ON
		i.pat = pc.VendorID AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.DateKeyToPractice dk ON
		dk.PracticeID = @PracticeID AND
		dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
	      AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment a
	INNER JOIN dbo.Patient p ON
	 p.PatientID = a.PatientID AND
	 p.VendorImportID = VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--ROLLBACK
--COMMIT


