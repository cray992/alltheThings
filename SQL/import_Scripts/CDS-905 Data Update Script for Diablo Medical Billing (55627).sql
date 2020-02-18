USE superbill_55627_prod
GO

SET XACT_ABORT ON
 
BEGIN TRANSACTION
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 11
SET @VendorImportID = 7

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

/*============================================================================================

 Initial import incorrectly assigned the InsuranceCompanyPlan VendorID to the primary policy

 Source File: _import_9_11_PatientDemographics 
 
 Columns-
	Shouldbe = corrected InsuranceCompanyPlan VendorID
	datacheck = True-1 | False-0 bit   

============================================================================================== */

-- Update primary insurance policy to the correct InsuranceCompanyPlanID

PRINT ''
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID , 
		CreatedDate = GETDATE() , 
		ModifiedDate = GETDATE()
FROM dbo.InsurancePolicy ip 
	INNER JOIN dbo._import_9_11_PatientDemographics i ON 
		i.chartnumber = ip.VendorID AND 
		ip.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.shouldbe = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
WHERE i.datacheck = 0 AND ip.Precedence = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' InsurancePolicy records updated'


-- Three patient records did not recieve an intial Primary Policy import

UPDATE dbo.PatientCase 
	SET Name = 'Default Case' , 
		PayerScenarioID = 5 , 
		CreatedDate = GETDATE() , 
		ModifiedDate = GETDATE()
FROM dbo.PatientCase pc 
	INNER JOIN dbo._import_9_11_PatientDemographics i ON 
		pc.VendorID = i.chartnumber AND 
		pc.PracticeID = @PracticeID
WHERE pc.VendorImportID = @VendorImportID AND i.insurancecode1 = '' AND i.datacheck = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' PatientCase records updated'

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
	      pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          1 ,
          i.policynumber1 ,
          i.groupnumber1 ,
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
FROM dbo._import_9_11_PatientDemographics i 
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.shouldbe = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON 
		pc.VendorID = i.chartnumber AND 
		pc.VendorImportID = @VendorImportID
WHERE i.insurancecode1 = '' AND i.datacheck = 0 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' InsurancePolicy records inserted'



--ROLLBACK
--COMMIT
