USE superbill_56217_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT , @VendorImportID INT
SET @PracticeID = 20
SET @VendorImportID = 7


/*
==========================================================================================================================================
CREATE INSURANCE PLANS FROM [Existing IC]
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , CreatedPracticeID , InsuranceCompanyID , 
	VendorID , VendorImportID 
)
SELECT DISTINCT
	ICP.payername  , -- PlanName - varchar(128)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	LTRIM(RTRIM(payername)) ,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM dbo._import_7_20_PatientDemgraphics ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE LTRIM(RTRIM(ICP.payername)) = LTRIM(RTRIM(InsuranceCompanyName)) AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
WHERE icp.payername <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
/*
==========================================================================================================================================
CREATE INSURANCE COMPANIES FROM [_import_1_1_InsuranceCOMPANYPLANList]
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , ReviewCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	IICL.payername  , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	19 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	'' , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	19 , -- SecondaryPrecedenceBillingFormID - int
	LTRIM(RTRIM(IICL.payername)) , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo._import_7_20_PatientDemgraphics AS IICL
WHERE IICL.payername <> '' AND
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE LTRIM(RTRIM(InsuranceCompanyName)) = LTRIM(RTRIM(IICL.payername)) AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'															 

/*
==========================================================================================================================================
CREATE INSURANCE PLANS FROM [InsuranceCOMPANYPLANList]
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , CreatedPracticeID , InsuranceCompanyID , 
	VendorID , VendorImportID 
)
SELECT DISTINCT
	ICP.payername  , -- PlanName - varchar(128)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	payername ,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM dbo._import_7_20_PatientDemgraphics ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(LTRIM(RTRIM(ICP.payername)), 50) AND
	LTRIM(RTRIM(ICP.payername)) = LTRIM(RTRIM(IC.InsuranceCompanyName)) AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	LTRIM(RTRIM(ICP.payername)) = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
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
          CASE i.primsectert
			WHEN 'Primary' THEN 1
			WHEN 'Secondary' THEN 2
			WHEN 'Tertiary' THEN 3
		  END ,
          i.memberid ,
          LEFT(i.groupnbr,32) ,
          CASE WHEN i.effdate <> '' THEN CAST(i.effdate AS DATETIME) END ,
          CASE WHEN i.termdate <> '' THEN CAST(i.termdate AS DATETIME) END ,
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
FROM dbo._import_7_20_PatientDemgraphics i 
	INNER JOIN dbo.Patient p ON 
		i.ac = p.VendorID AND 
		p.VendorImportID = 6
	INNER JOIN dbo.PatientCase pc ON 
		p.PatientID = pc.PatientID AND
		pc.VendorImportID = 6
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.payername = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND 
		ip.PracticeID = @PracticeID
WHERE i.primsectert IN ('Primary','Secondary','Tertiary') AND ip.InsurancePolicyID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET Name = 'Default Case' , 
		PayerScenarioID = 5 , 
		CreatedDate = GETDATE() , 
		ModifiedDate = GETDATE()
FROM dbo.PatientCase pc 
	INNER JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND
        ip.VendorImportID = @VendorImportID
WHERE pc.Name = 'Self Pay'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

UPDATE dbo.Patient 
	SET ModifiedDate = GETDATE() , 
		CreatedDate = GETDATE()
WHERE PatientID IN (SELECT PatientID FROM dbo.PatientCase WHERE ModifiedDate > DATEADD(s,-1,GETDATE()))

--ROLLBACK
--COMMIT
