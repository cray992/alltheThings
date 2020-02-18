USE superbill_28726_dev
GO


SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 4

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Inserting Into Insurance Policy 3...'
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
          HolderSSN ,
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
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          i.policynumber3 , -- PolicyNumber - varchar(32)
          i.groupnumber3 , -- GroupNumber - varchar(32)
          CASE i.patientrelationship3 WHEN 'Spouse' THEN 'U' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN i.holder3firstname ELSE NULL END, -- HolderFirstName - varchar(64)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN i.holder3middlename ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN i.holder3lastname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN 
		  CASE WHEN ISDATE(i.holder3dateofbirth) = 1 THEN i.holder3dateofbirth ELSE NULL END ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN i.holder3ssn ELSE NULL END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN i.holder3gender ELSE NULL END , -- HolderGender - char(1)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN i.holder3street1 ELSE NULL END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN i.holder3street2 ELSE NULL END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN i.holder3city ELSE NULL END , -- HolderCity - varchar(128)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN i.holder3state ELSE NULL END , -- HolderState - varchar(2)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN '' ELSE NULL END , -- HolderCountry - varchar(32)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN i.holder3zipcode ELSE NULL END , -- HolderZipCode - varchar(9)
          CASE WHEN i.patientrelationship3 = 'Spouse' THEN i.policynumber3 ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          i.policy3copay , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_5_1_TertiaryPolicy] i
INNER JOIN dbo.Patient p ON
	i.chartnumber = p.MedicalRecordNumber AND
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase pc ON
	pc.PatientID = p.PatientID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = i.insurancecode3 AND
	icp.VendorImportID = @VendorImportID	
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



--COMMIT
--ROLLBACK

