USE superbill_52264_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

UPDATE dbo.PatientCase
SET	CreatedDate = GETDATE() , 
	ModifiedDate = GETDATE()
WHERE VendorImportID IN (4,3,2,1) AND ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Case Records Updated'

UPDATE dbo.InsurancePolicy 
SET PatientRelationshipToInsured = 'S' ,
	HolderFirstName = NULL ,
	HolderMiddleName = NULL ,
	HolderLastName = NULL ,
	HolderDOB = NULL ,
	HolderThroughEmployer = 0 ,
	HolderEmployerName = NULL ,  
	HolderAddressLine1 = NULL , 
	HolderAddressLine2 = NULL , 
	HolderCity = NULL , 
	HolderState = NULL , 
	HolderCountry = NULL , 
	HolderZipCode = NULL , 
	DependentPolicyNumber = NULL , 
	CreatedDate = GETDATE() , 
	ModifiedDate = GETDATE()
WHERE VendorImportID IN (4,3,2,1) AND ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Policy Records Updated'

--ROLLBACK
--COMMIT


