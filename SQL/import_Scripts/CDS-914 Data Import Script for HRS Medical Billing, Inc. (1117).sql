USE superbill_1117_prod
GO

BEGIN TRAN 
SET XACT_ABORT ON 
SET NOCOUNT ON

DECLARE @PracticeID INT 
DECLARE @VendorImportID INT 

SET @PracticeID = 16
SET @VendorImportID = 4

UPDATE dbo._import_4_16_Table 
	SET Precedence = PatDupe.DupeCount
FROM dbo._import_4_16_Table i 
LEFT JOIN (SELECT autotempid , ROW_NUMBER() OVER(PARTITION BY FirstName + LastName ORDER BY AutoTempID) AS DupeCount 
		   FROM dbo._import_4_16_Table
		  ) AS PatDupe ON i.AutoTempID = PatDupe.AutoTempID

INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
	      pc.PatientCaseID ,  -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.Precedence , -- Precedence - int
          i.insuranceid , -- PolicyNumber - varchar(32)
          i.policynumber , -- GroupNumber - varchar(32)
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_4_16_Table i 
INNER JOIN dbo.Patient p ON 
	i.firstname = p.FirstName AND 
	i.lastname = p.LastName AND
	p.PracticeID = @PracticeID AND
	p.VendorImportID = 3
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.InsuranceCompanyPlanID = (SELECT MAX(icp2.InsuranceCompanyPlanID) 
								  FROM dbo.InsuranceCompanyPlan icp2
								  WHERE icp2.VendorImportID = 3 AND 
										icp2.CreatedPracticeID = @PracticeID AND
										icp2.PlanName = i.insurancename)
WHERE i.insuranceid <> '' AND 
	  p.PatientID NOT IN (
							SELECT p.patientid
							FROM dbo.Patient p
							INNER JOIN (
								SELECT firstname , lastname , COUNT(*) AS DupeCount
								FROM dbo.Patient
								WHERE PracticeID = @PracticeID
								GROUP BY FirstName , LastName
								HAVING COUNT(*) > 1
										) dp ON dp.FirstName = p.FirstName AND 
												dp.LastName = p.LastName
						 )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into InsurancePolicy'

UPDATE dbo.PatientCase
	SET Name = 'Default Case' , PayerScenarioID = 5
WHERE PatientCaseID IN (SELECT PatientCaseID 
						FROM dbo.InsurancePolicy
						WHERE VendorImportID = @VendorImportID AND 
							  PracticeID = @PracticeID
					   )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Case records updated'
 


--ROLLBACK
--COMMIT




