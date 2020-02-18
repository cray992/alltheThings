USE superbill_29285_dev
--USE superbill_29285_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @VendorImportID2 INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 6
SET @VendorImportID2 = 7
SET @PracticeID = 1

--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID2
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID2
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'

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
          i.familyno + i.personno , -- VendorID - varchar(50)
          @VendorImportID2 , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_6_1_Patient] i 
	INNER JOIN dbo.Patient p ON 
		p.MedicalRecordNumber = i.familyno + '-0' + i.personno AND
		p.PracticeID = @PracticeID
WHERE p.CreatedUserID = -1 AND p.ModifiedUserID = -1
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--7648

PRINT ''
PRINT 'Inserting Into Policy...'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          DependentPolicyNumber ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation 
        )
SELECT DISTINCT	 
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          policyrank, -- Precedence - int
          policyno , -- PolicyNumber - varchar(32)
          insgroupid , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(effdate) = 1 THEN CONVERT(VARCHAR, effdate, 101) ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(enddatedonotimporttermed) = 1 THEN enddatedonotimporttermed ELSE NULL END , -- PolicyEndDate - datetime
          CASE relation WHEN '' THEN 'S' ELSE relation END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN relation <> 'S' AND relation <> '' THEN '' ELSE NULL END  , -- HolderPrefix - varchar(16)
          CASE WHEN relation <> 'S' AND relation <> '' THEN insuredfirst ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN relation <> 'S' AND relation <> '' THEN insuredmiddle ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN relation <> 'S' AND relation <> '' THEN insuredlast ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN relation <> 'S' AND relation <> '' THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN relation <> 'S' AND relation <> '' THEN policyno ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          genericcopay , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID2 , -- VendorImportID - int
          LEFT(i.insgroupnm, 14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_6_1_Policy] i
	INNER JOIN dbo.PatientCase pc ON 
		i.familyno + i.personno = pc.VendorID AND
		pc.VendorImportID = @VendorImportID2
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		i.insureno = icp.VendorID AND
		icp.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--5776

PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 , 
		  Name = 'Self Pay'
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID2 AND
              PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'
--2372

PRINT ''
PRINT 'Updating MRN to match imported patients through 3rd party integration...'
UPDATE dbo.Patient 
	SET MedicalRecordNumber = i.familyno + '-0' + i.personno
FROM dbo.[_import_6_1_Patient] i
	INNER JOIN dbo.Patient p ON
		i.familyno + i.personno = p.VendorID AND
		p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'
--770 matches patient insert on NET-3126


--COMMIT
--ROLLBACK


