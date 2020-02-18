USE superbill_23553_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @OldVendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 6
SET @OldVendorImportID = 5

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
PRINT ''

-- Table List of Patients where the User has not modified the record
CREATE TABLE #UpdatePat (PatID INT)
INSERT INTO #UpdatePat  (PatID )
SELECT patientid 
FROM dbo.Patient 
WHERE ModifiedUserID = 0 AND CreatedUserID = 0 AND VendorImportID = @OldVendorImportID

-- Create Insurance Company and Plans from import file

CREATE TABLE #InsList (InsUID VARCHAR(10) , InsName VARCHAR(256))
INSERT INTO #InsList  (InsUID, InsName)
SELECT DISTINCT  primpolicycarrierabbr , primpolicycarriername 
FROM dbo._import_6_1_Sheet1
WHERE primpolicycarriername <> 'OLD ADDRESSNeighborhood Health' AND primpolicycarrierabbr <> ''

INSERT INTO #InsList  (InsUID, InsName)
SELECT DISTINCT  secmpolicycarrierabbr , secpolicycarriername 
FROM dbo._import_6_1_Sheet1
WHERE NOT EXISTS (SELECT * FROM #InsList WHERE InsUID = secmpolicycarrierabbr)
AND secpolicycarriername <> 'OLD ADDRESSNeighborhood Health' AND secmpolicycarrierabbr <> ''

INSERT INTO #InsList  (InsUID, InsName)
SELECT DISTINCT  tertmpolicycarrierabbr , tertmpolicycarriername 
FROM dbo._import_6_1_Sheet1
WHERE NOT EXISTS (SELECT * FROM #InsList WHERE InsUID = tertmpolicycarrierabbr)
AND tertmpolicycarriername <> 'OLD ADDRESSNeighborhood Health' AND tertmpolicycarrierabbr <> ''

-- Insert plan and companies where they do not already exist

--     Plan to existing company

INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , CreatedPracticeID , 
	InsuranceCompanyID , VendorID , VendorImportID 
)
SELECT DISTINCT
	ICP.InsName  , -- PlanName - varchar(128)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	icp.InsUID,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM #InsList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE ICP.InsName = InsuranceCompanyName AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
LEFT JOIN dbo.InsuranceCompanyPlan ricp ON ICP.InsUID = ricp.VendorID
WHERE ricp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' InsuranceCompanyPlan [Existing Company] records inserted'	

--     New Company 

INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	IICL.InsName  , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	19 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	13 , -- SecondaryPrecedenceBillingFormID - int
	IICL.InsName , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM #InsList AS IICL
WHERE 
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.InsName AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' InsuranceCompany records inserted'		

--      Plans for New Company

INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , CreatedPracticeID , 
	InsuranceCompanyID , VendorID , VendorImportID 
)
SELECT DISTINCT
	ICP.InsName  , -- PlanName - varchar(128)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	icp.InsUID,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM #InsList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.InsName, 50) AND
	ICP.InsName = IC.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.InsUID = OICP.VendorID AND
	OICP.VendorImportID IN (@OldVendorImportID, @VendorImportID)
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' InsuranceCompanyPlan records inserted'	

-- Update Patient Demographics

UPDATE p
	SET p.AddressLine1 = i.patientstreet1 , 
		p.AddressLine2 = i.patientstreet2 , 
		p.City = i.patientcity , 
		p.[State] = i.patientstate ,
		p.ZipCode = i.patientzipcode ,
		p.SSN = i.patientssn , 
		p.Gender = i.patientsex , 
		p.DOB = i.patientdob ,
		p.MedicalRecordNumber = i.patientnumber 
FROM dbo.Patient p 
INNER JOIN #UpdatePat up ON p.PatientID = up.PatID
INNER JOIN dbo._import_6_1_Sheet1 i ON p.VendorID = i.patientid 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient records updated'

-- Update Primary Policies

UPDATE ip
	SET InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID , 
		PolicyNumber = i.primpolicycertificateno
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON pc.PatientCaseID = ip.PatientCaseID AND pc.VendorImportID = @OldVendorImportID
INNER JOIN #UpdatePat up ON pc.PatientID = up.PatID 
INNER JOIN dbo._import_6_1_Sheet1 i ON pc.VendorID = i.patientid
INNER JOIN dbo.InsuranceCompanyPlan icp ON i.primpolicycarrierabbr = icp.VendorID 
WHERE ip.ModifiedUserID = 0 AND icp.CreatedUserID = 0 AND ip.Precedence = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Primary InsurancePolicy records Updated'

-- Update Secondary Policies

UPDATE ip
	SET InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID , 
		PolicyNumber = i.secpolicycertificateno
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON pc.PatientCaseID = ip.PatientCaseID AND pc.VendorImportID = @OldVendorImportID
INNER JOIN #UpdatePat up ON pc.PatientID = up.PatID 
INNER JOIN dbo._import_6_1_Sheet1 i ON pc.VendorID = i.patientid
INNER JOIN dbo.InsuranceCompanyPlan icp ON i.secpolicycarrierabbr = icp.VendorID 
WHERE ip.ModifiedUserID = 0 AND icp.CreatedUserID = 0 AND ip.Precedence = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Secondary InsurancePolicy records Updated'

-- Update Tertiary Policies

UPDATE ip
	SET InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID , 
		PolicyNumber = i.tertmpolicycertificateno
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON pc.PatientCaseID = ip.PatientCaseID AND pc.VendorImportID = @OldVendorImportID
INNER JOIN #UpdatePat up ON pc.PatientID = up.PatID 
INNER JOIN dbo._import_6_1_Sheet1 i ON pc.VendorID = i.patientid
INNER JOIN dbo.InsuranceCompanyPlan icp ON i.tertmpolicycarrierabbr = icp.VendorID 
WHERE ip.ModifiedUserID = 0 AND icp.CreatedUserID = 0 AND ip.Precedence = 3
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Tertiary InsurancePolicy records Updated'

-- Inserting New Patients with Cases and Insurance Policies

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
          DOB ,
          SSN ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          i.patientfirstname ,
          '' ,
          i.patientlastname ,
          '' ,
          i.patientstreet1 ,
          i.patientstreet2 ,
          i.patientcity ,
          i.patientstate ,
          '' ,
          i.patientzipcode ,
          i.patientsex ,
          '' ,
          i.patientdob ,
          i.patientssn ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          'U' ,
          i.accountnumber ,
          i.patientid ,
          @VendorImportID ,
          1 ,
          1 ,
          0 ,
          0 
FROM dbo._import_6_1_Sheet1 i
LEFT JOIN dbo.Patient p ON i.patientfirstname = p.FirstName AND i.patientlastname = p.LastName AND DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) = p.DOB AND p.PracticeID = @PracticeID
WHERE p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient records inserted'

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
		  PatientID ,
          'Default case' ,
          1 ,
          5 ,
          0 ,
          0 ,
          0 ,
          0 ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          @PracticeID ,
          VendorID ,
          @VendorImportID ,
          0 ,
          1 ,
          0 ,
          0 ,
          1 ,
          0 ,
          0
FROM dbo.Patient 
WHERE VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' PatientCase records inserted'

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
          i.primpolicycertificateno ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          @PracticeID ,
          pc.VendorID ,
          @VendorImportID ,
          'Y'
FROM dbo._import_6_1_Sheet1 i
	INNER JOIN dbo.PatientCase pc ON i.patientid = pc.VendorID AND pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON i.primpolicycarrierabbr = icp.VendorID 
WHERE i.primpolicycertificateno <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' InsurancePolicy records inserted - Primary'

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
          2 ,
          i.secpolicycertificateno ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          @PracticeID ,
          pc.VendorID ,
          @VendorImportID ,
          'Y'
FROM dbo._import_6_1_Sheet1 i
	INNER JOIN dbo.PatientCase pc ON i.patientid = pc.VendorID AND pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON i.secpolicycarrierabbr = icp.VendorID 
WHERE i.secpolicycertificateno <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' InsurancePolicy records inserted - Secondary'

DROP TABLE #InsList , #UpdatePat

--ROLLBACK
--COMMIT
