USE superbill_24302_dev
--USE superbill_24302_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 67
SET @VendorImportID = 37
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting Into Patient Journal Note...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          Hidden ,
          NoteMessage ,
          AccountStatus ,
          NoteTypeCode ,
          LastNote
        )
SELECT DISTINCT
		  GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          PatientID , -- PatientID - int
          'Kareo' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          'Medial Record Number: ' + MedicalRecordNumber , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID IN (35,36) AND MedicalRecordNumber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted'

PRINT ''
PRINT 'Updating Patient MRN...'
UPDATE dbo.Patient 
SET MedicalRecordNumber = i.chartnumber
FROM dbo.[_import_37_67_PatientDemographics] i
INNER JOIN dbo.Patient p ON p.FirstName = i.firstname AND p.LastName = i.lastname AND p.DOB = DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) AND p.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company...'
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
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID 
        )
SELECT DISTINCT
		  i.insurancecompanyname ,
          1 ,
          13 ,
          'CI' ,
          'C' ,
          'D' ,
          @PracticeID ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          13 ,
          LEFT(i.insurancecompanyname, 50) ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18
FROM dbo.[_import_37_67_InsuranceCOMPANYPLANList] i
INNER JOIN dbo.[_import_37_67_PatientDemographics] ipd ON i.insuranceid = ipd.insurancecode2 OR i.insuranceid = ipd.insurancecode1
LEFT JOIN dbo.InsuranceCompanyPlan icp ON i.insuranceid = icp.VendorID AND icp.VendorImportID IN (35,36)
WHERE icp.InsuranceCompanyPlanID IS NULL AND 
NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE LEFT(i.insurancecompanyname,50) = ic.VendorID AND ic.VendorImportID IN (35,36))	 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
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
	        i.planname ,
          ic.CreatedDate ,
          ic.CreatedUserID ,
          ic.ModifiedDate ,
          ic.ModifiedUserID ,
          ic.CreatedPracticeID ,
          ic.InsuranceCompanyID ,
          i.insuranceid ,
          @VendorImportID 
FROM dbo.InsuranceCompany ic 
INNER JOIN dbo.[_import_37_67_InsuranceCOMPANYPLANList] i ON LEFT(i.insurancecompanyname , 50) = ic.VendorID AND ic.VendorImportID = @VendorImportID
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompanyPlan icp WHERE icp.VendorID = i.insuranceid AND icp.VendorImportID IN (35,36))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 1 of 2...'
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
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.policynumber1 , -- PolicyNumber - varchar(32)
          i.groupnumber1 , -- GroupNumber - varchar(32)
          1 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          p.VendorID + i.policynumber1 , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_37_67_PatientDemographics] i
INNER JOIN dbo.Patient p ON p.FirstName = i.firstname AND p.LastName = i.lastname AND p.DOB = DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) AND p.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON p.PatientID = pc.PatientID AND pc.PracticeID = @PracticeID AND pc.VendorID IS NOT NULL
INNER JOIN dbo.InsuranceCompanyPlan icp ON i.insurancecode1 = icp.VendorID  AND icp.VendorImportID IN (35,36,37)
LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID
WHERE ip.PatientCaseID IS NULL AND i.policynumber1 <> '' AND i.insurancecode1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 2 of 2...'
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
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.policynumber2 , -- PolicyNumber - varchar(32)
          i.groupnumber2 , -- GroupNumber - varchar(32)
          1 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          p.VendorID + i.policynumber2 , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_37_67_PatientDemographics] i
INNER JOIN dbo.Patient p ON p.FirstName = i.firstname AND p.LastName = i.lastname AND p.DOB = DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) AND p.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON p.PatientID = pc.PatientID AND pc.PracticeID = @PracticeID AND pc.VendorID IS NOT NULL
INNER JOIN dbo.InsuranceCompanyPlan icp ON i.insurancecode2 = icp.VendorID AND icp.VendorImportID IN (35,36,37)
LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 2
WHERE ip.PatientCaseID IS NULL AND i.policynumber2 <> '' AND i.insurancecode2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase
SET Name = 'Default Case' ,
	PayerScenarioID = 5
WHERE CreatedUserID = 0 AND ModifiedUserID = 0 AND VendorImportID IN (35,36) AND PracticeID = @PracticeID AND Name = 'Self Pay' AND PatientCaseID IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = 67)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'
	
--ROLLBACK
--COMMIT





