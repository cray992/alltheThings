USE superbill_58037_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @VendorImportID INT
SET @VendorImportID = 5

PRINT 'Inserting Records Into PracticeID: 2 -'
PRINT ''

UPDATE dbo.InsuranceCompanyPlan
SET	VendorID = i.insurancecompanyvendorid
FROM dbo._import_5_2_PolicyImport i 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.InsuranceCompanyPlanID = (SELECT MIN(InsuranceCompanyPlanID) FROM dbo.InsuranceCompanyPlan icp2 WHERE
								  i.insurancecompanyname = icp2.PlanName AND icp2.CreatedPracticeID = 2) 
WHERE i.practicename = 'PR: PREMIER MEDICAL CARE LLC' AND icp.CreatedPracticeID = 2 AND
NOT EXISTS (SELECT * FROM dbo.InsuranceCompanyPlan icp3 WHERE icp3.VendorID = i.insurancecompanyvendorid AND icp3.CreatedPracticeID = 2)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Existing Insurance Company Plan Records Updated...'

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
		  i.insurancecompanyname ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          2 ,
          IC.InsuranceCompanyID ,
          i.insurancecompanyvendorid ,
          @VendorImportID 
FROM dbo._import_5_2_PolicyImport i
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE LTRIM(RTRIM(i.insurancecompanyname)) = LTRIM(RTRIM(InsuranceCompanyName)) AND
										  (ReviewCode = 'R' OR CreatedPracticeID = 2))
LEFT JOIN dbo.InsuranceCompanyPlan ICP ON 
	i.insurancecompanyvendorid = icp.VendorID AND 
	icp.CreatedPracticeID = 2
WHERE i.practicename = 'PR: PREMIER MEDICAL CARE LLC' AND icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Company Plan [Existing Company] Records Inserted...'


INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
          InstitutionalBillingFormID 
        )
SELECT DISTINCT
		  insurancecompanyname ,
          1 ,
          19 ,
          'CI' ,
          'C' ,
          'D' ,
          2 ,
          GETDATE() ,
          0 ,	
          GETDATE() ,
          0 ,
          i.insurancecompanyname ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM dbo._import_5_2_PolicyImport i
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	i.insurancecompanyvendorid = icp.VendorID AND
	icp.CreatedPracticeID = 2
WHERE practicename = 'PR: PREMIER MEDICAL CARE LLC' AND icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Company Records Inserted...'

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
		  i.insurancecompanyname ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          2 ,
          IC.InsuranceCompanyID ,
          i.insurancecompanyvendorid ,
          @VendorImportID 
FROM dbo._import_5_2_PolicyImport i
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(LTRIM(RTRIM(i.insurancecompanyname)), 50) AND
	LTRIM(RTRIM(i.insurancecompanyname)) = LTRIM(RTRIM(IC.InsuranceCompanyName)) AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	i.insurancecompanyvendorid = OICP.VendorID AND
	OICP.CreatedPracticeID = 2
WHERE IC.CreatedPracticeID = 2 AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL AND    
      i.practicename = 'PR: PREMIER MEDICAL CARE LLC' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Plan Records Inserted...'

INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          i.precedence ,
          i.policynumber ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          2 ,
          pc.VendorID ,
          @VendorImportID ,
          'Y'
FROM dbo._import_5_2_PolicyImport i 
INNER JOIN dbo.Patient p ON 
	i.patientfirstname = p.FirstName AND 
	i.patientlastname = p.LastName AND 
	DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) = p.DOB AND 
	p.PracticeID = 2 AND 
	p.VendorImportID = 1
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND 
	pc.VendorImportID = 1
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.insurancecompanyvendorid = icp.VendorID AND 
	icp.CreatedPracticeID = 2
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID AND 
	ip.PracticeID = 2
WHERE icp.ModifiedUserID = 0 AND i.practicename = 'PR: PREMIER MEDICAL CARE LLC' AND ip.InsurancePolicyID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Policy Records Inserted...'
PRINT ''

PRINT 'Inserting Records Into PracticeID: 3 -'
PRINT ''

UPDATE dbo.InsuranceCompanyPlan
SET	VendorID = i.insurancecompanyvendorid
FROM dbo._import_5_2_PolicyImport i 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.InsuranceCompanyPlanID = (SELECT MIN(InsuranceCompanyPlanID) FROM dbo.InsuranceCompanyPlan icp2 WHERE
								  i.insurancecompanyname = icp2.PlanName AND icp2.CreatedPracticeID = 3) 
WHERE i.practicename = 'PR: PRINCETON PC CLINIC' AND icp.CreatedPracticeID = 3 AND
NOT EXISTS (SELECT * FROM dbo.InsuranceCompanyPlan icp3 WHERE icp3.VendorID = i.insurancecompanyvendorid AND icp3.CreatedPracticeID = 3)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Existing Insurance Company Plan Records Updated...'

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
		  i.insurancecompanyname ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          3 ,
          IC.InsuranceCompanyID ,
          i.insurancecompanyvendorid ,
          @VendorImportID 
FROM dbo._import_5_2_PolicyImport i
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE LTRIM(RTRIM(i.insurancecompanyname)) = LTRIM(RTRIM(InsuranceCompanyName)) AND
										  (ReviewCode = 'R' OR CreatedPracticeID = 3))
LEFT JOIN dbo.InsuranceCompanyPlan ICP ON 
	i.insurancecompanyvendorid = icp.VendorID AND 
	icp.CreatedPracticeID = 3
WHERE i.practicename = 'PR: PRINCETON PC CLINIC' AND icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Company Plan [Existing Company] Records Inserted...'


INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
          InstitutionalBillingFormID 
        )
SELECT DISTINCT
		  insurancecompanyname ,
          1 ,
          19 ,
          'CI' ,
          'C' ,
          'D' ,
          3 ,
          GETDATE() ,
          0 ,	
          GETDATE() ,
          0 ,
          i.insurancecompanyname ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM dbo._import_5_2_PolicyImport i
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	i.insurancecompanyvendorid = icp.VendorID AND
	icp.CreatedPracticeID = 3
WHERE practicename = 'PR: PRINCETON PC CLINIC' AND icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Company Records Inserted...'

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
		  i.insurancecompanyname ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          3 ,
          IC.InsuranceCompanyID ,
          i.insurancecompanyvendorid ,
          @VendorImportID 
FROM dbo._import_5_2_PolicyImport i
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(LTRIM(RTRIM(i.insurancecompanyname)), 50) AND
	LTRIM(RTRIM(i.insurancecompanyname)) = LTRIM(RTRIM(IC.InsuranceCompanyName)) AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	i.insurancecompanyvendorid = OICP.VendorID AND
	OICP.CreatedPracticeID = 3
WHERE IC.CreatedPracticeID = 3 AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL AND    
      i.practicename = 'PR: PRINCETON PC CLINIC' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Plan Records Inserted...'

INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          i.precedence ,
          i.policynumber ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          3 ,
          pc.VendorID ,
          @VendorImportID ,
          'Y'
FROM dbo._import_5_2_PolicyImport i 
INNER JOIN dbo.Patient p ON 
	i.patientfirstname = p.FirstName AND 
	i.patientlastname = p.LastName AND 
	DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) = p.DOB AND 
	p.PracticeID = 3 AND 
	p.VendorImportID = 2
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND 
	pc.VendorImportID = 2
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.insurancecompanyvendorid = icp.VendorID AND 
	icp.CreatedPracticeID = 3
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID AND 
	ip.PracticeID = 3
WHERE icp.ModifiedUserID = 0 AND i.practicename = 'PR: PRINCETON PC CLINIC' AND ip.InsurancePolicyID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Policy Records Inserted...'
PRINT ''

PRINT 'Inserting Records Into PracticeID: 4 -'
PRINT ''


UPDATE dbo.InsuranceCompanyPlan
SET	VendorID = i.insurancecompanyvendorid
FROM dbo._import_5_2_PolicyImport i 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.InsuranceCompanyPlanID = (SELECT MIN(InsuranceCompanyPlanID) FROM dbo.InsuranceCompanyPlan icp2 WHERE
								  i.insurancecompanyname = icp2.PlanName AND icp2.CreatedPracticeID = 4) 
WHERE i.practicename = 'PR: AMIT AGARWAL MD' AND icp.CreatedPracticeID = 4 AND
NOT EXISTS (SELECT * FROM dbo.InsuranceCompanyPlan icp3 WHERE icp3.VendorID = i.insurancecompanyvendorid AND icp3.CreatedPracticeID = 4)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Existing Insurance Company Plan Records Updated...'

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
		  i.insurancecompanyname ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          4 ,
          IC.InsuranceCompanyID ,
          i.insurancecompanyvendorid ,
          @VendorImportID 
FROM dbo._import_5_2_PolicyImport i
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE LTRIM(RTRIM(i.insurancecompanyname)) = LTRIM(RTRIM(InsuranceCompanyName)) AND
										  (ReviewCode = 'R' OR CreatedPracticeID = 4))
LEFT JOIN dbo.InsuranceCompanyPlan ICP ON 
	i.insurancecompanyvendorid = icp.VendorID AND 
	icp.CreatedPracticeID = 4
WHERE i.practicename = 'PR: AMIT AGARWAL MD' AND icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Company Plan [Existing Company] Records Inserted...'


INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
          InstitutionalBillingFormID 
        )
SELECT DISTINCT
		  insurancecompanyname ,
          1 ,
          19 ,
          'CI' ,
          'C' ,
          'D' ,
          4 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          i.insurancecompanyname ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM dbo._import_5_2_PolicyImport i
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	i.insurancecompanyvendorid = icp.VendorID AND
	icp.CreatedPracticeID = 4
WHERE practicename = 'PR: AMIT AGARWAL MD' AND icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Company Records Inserted...'

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
		  i.insurancecompanyname ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          4 ,
          IC.InsuranceCompanyID ,
          i.insurancecompanyvendorid ,
          @VendorImportID 
FROM dbo._import_5_2_PolicyImport i
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(LTRIM(RTRIM(i.insurancecompanyname)), 50) AND
	LTRIM(RTRIM(i.insurancecompanyname)) = LTRIM(RTRIM(IC.InsuranceCompanyName)) AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	i.insurancecompanyvendorid = OICP.VendorID AND
	OICP.CreatedPracticeID = 4
WHERE IC.CreatedPracticeID = 4 AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL AND    
      i.practicename = 'PR: AMIT AGARWAL MD' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Plan Records Inserted...'

INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          i.precedence ,
          i.policynumber ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          4 ,
          pc.VendorID ,
          @VendorImportID ,
          'Y'
FROM dbo._import_5_2_PolicyImport i 
INNER JOIN dbo.Patient p ON 
	i.patientfirstname = p.FirstName AND 
	i.patientlastname = p.LastName AND 
	DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) = p.DOB AND 
	p.PracticeID = 4 AND 
	p.VendorImportID = 3
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND 
	pc.VendorImportID = 3
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.insurancecompanyvendorid = icp.VendorID AND 
	icp.CreatedPracticeID = 4
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID AND 
	ip.PracticeID = 4
WHERE icp.ModifiedUserID = 0 AND i.practicename = 'PR: AMIT AGARWAL MD' AND ip.InsurancePolicyID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Policy Records Inserted...'
PRINT ''

PRINT 'Inserting Records Into PracticeID: 5 -'
PRINT ''


UPDATE dbo.InsuranceCompanyPlan
SET	VendorID = i.insurancecompanyvendorid
FROM dbo._import_5_2_PolicyImport i 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.InsuranceCompanyPlanID = (SELECT MIN(InsuranceCompanyPlanID) FROM dbo.InsuranceCompanyPlan icp2 WHERE
								  i.insurancecompanyname = icp2.PlanName AND icp2.CreatedPracticeID = 5) 
WHERE i.practicename = 'PR: SHARAD SAHU MD' AND icp.CreatedPracticeID = 5 AND
NOT EXISTS (SELECT * FROM dbo.InsuranceCompanyPlan icp3 WHERE icp3.VendorID = i.insurancecompanyvendorid AND icp3.CreatedPracticeID = 5)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Existing Insurance Company Plan Records Updated...'

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
		  i.insurancecompanyname ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          5 ,
          IC.InsuranceCompanyID ,
          i.insurancecompanyvendorid ,
          @VendorImportID 
FROM dbo._import_5_2_PolicyImport i
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE LTRIM(RTRIM(i.insurancecompanyname)) = LTRIM(RTRIM(InsuranceCompanyName)) AND
										  (ReviewCode = 'R' OR CreatedPracticeID = 5))
LEFT JOIN dbo.InsuranceCompanyPlan ICP ON 
	i.insurancecompanyvendorid = icp.VendorID AND 
	icp.CreatedPracticeID = 5
WHERE i.practicename = 'PR: SHARAD SAHU MD' AND icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Company Plan [Existing Company] Records Inserted...'


INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
          InstitutionalBillingFormID 
        )
SELECT DISTINCT
		  insurancecompanyname ,
          1 ,
          19 ,
          'CI' ,
          'C' ,
          'D' ,
          5 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          i.insurancecompanyname ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM dbo._import_5_2_PolicyImport i
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	i.insurancecompanyvendorid = icp.VendorID AND
	icp.CreatedPracticeID = 5
WHERE practicename = 'PR: SHARAD SAHU MD' AND icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Company Records Inserted...'

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
		  i.insurancecompanyname ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          5 ,
          IC.InsuranceCompanyID ,
          i.insurancecompanyvendorid ,
          @VendorImportID 
FROM dbo._import_5_2_PolicyImport i
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(LTRIM(RTRIM(i.insurancecompanyname)), 50) AND
	LTRIM(RTRIM(i.insurancecompanyname)) = LTRIM(RTRIM(IC.InsuranceCompanyName)) AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	i.insurancecompanyvendorid = OICP.VendorID AND
	OICP.CreatedPracticeID = 5
WHERE IC.CreatedPracticeID = 5 AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL AND    
      i.practicename = 'PR: SHARAD SAHU MD' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Plan Records Inserted...'

INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          i.precedence ,
          i.policynumber ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          5 ,
          pc.VendorID ,
          @VendorImportID ,
          'Y'
FROM dbo._import_5_2_PolicyImport i 
INNER JOIN dbo.Patient p ON 
	i.patientfirstname = p.FirstName AND 
	i.patientlastname = p.LastName AND 
	DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) = p.DOB AND 
	p.PracticeID = 5 AND 
	p.VendorImportID = 4
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND 
	pc.VendorImportID = 4
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.insurancecompanyvendorid = icp.VendorID AND 
	icp.CreatedPracticeID = 5
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID AND 
	ip.PracticeID = 5
WHERE icp.ModifiedUserID = 0 AND i.practicename = 'PR: SHARAD SAHU MD' AND ip.InsurancePolicyID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Policy Records Inserted...'
PRINT ''

--ROLLBACK
--COMMIT


