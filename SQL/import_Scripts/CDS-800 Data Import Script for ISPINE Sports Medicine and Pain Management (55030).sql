--USE superbill_55030_dev
USE superbill_55030_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 3
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


/*==========================================================================
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--
CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
SELECT DISTINCT
		     p.PatientID , -- PatientID - int
			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
			 i.ssn  -- SSN - varchar(9)
FROM dbo.Patient p 
INNER JOIN dbo.[_import_4_3_PatientDemographics] i ON p.PatientID = i.id

PRINT ''
PRINT 'Updating Existing Patients Demographics...'
UPDATE dbo.Patient 
	SET DOB = i.DateofBirth  ,
		SSN = i.ssn
FROM #updatepat i 
INNER JOIN dbo.Patient p ON
	p.PatientID = i.patientid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #updatepat

==========================================================================*/

PRINT ''
PRINT 'Update Patient - DOB...'
UPDATE dbo.Patient 
	SET DOB = p.DOB + 1462 ,
		MedicalRecordNumber = i.patientid 
FROM dbo.Patient p 
INNER JOIN dbo._import_3_3_ISPINECompleteDemogrpahics i ON 
	p.VendorID = i.rowcountid 
WHERE p.VendorImportID = @VendorImportID AND p.PracticeID = @PracticeID AND p.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

UPDATE dbo._import_3_3_ISPINECompleteDemogrpahics SET priinsurancename = 'UNITED HEALTH CARE' WHERE priinsurancename = 'UNITED HEALTHCARE'
	
PRINT ''
PRINT 'Inserting Into Insurance Policy...'
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
          1 ,
          i.pripolicynumber ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          @PracticeID ,
          pc.PatientCaseID ,
          @VendorImportID ,
          'Y'
FROM dbo._import_3_3_ISPINECompleteDemogrpahics i
INNER JOIN dbo.PatientCase pc ON
	i.rowcountid = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.priinsurancename = icp.PlanName AND 
	icp.CreatedPracticeID = @PracticeID AND 
	icp.VendorImportID = @VendorImportID
WHERE i.pripolicynumber <> '' AND pc.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET Name = 'Default Case' , PayerScenarioID = 5
FROM dbo.PatientCase pc 
INNER JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.VendorImportID = @VendorImportID 
WHERE pc.PracticeID = @PracticeID AND pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

	

--ROLLBACK
--COMMIT

