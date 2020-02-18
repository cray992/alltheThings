USE superbill_41156_dev
--superbill_41156_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

PRINT ''
PRINT 'Updating Insurance Policy - 1...'
UPDATE dbo.InsurancePolicy 
	SET HolderGender = CASE WHEN i.priinsuredrelation <> 'SELF' THEN CASE i.priinsuredsex WHEN 'MALE' THEN 'M' WHEN 'FEMALE' THEN 'F' ELSE 'U' END END ,
		HolderSSN = CASE WHEN i.priinsuredrelation <> 'SELF' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.socialsecurity)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.socialsecurity), 9) ELSE '' END END ,
		PatientRelationshipToInsured = CASE i.priinsuredrelation WHEN 'CHILD' THEN 'C' WHEN 'SPOUSE' THEN 'U' ELSE 'S' END ,
		HolderFirstName = CASE WHEN i.priinsuredrelation <> 'SELF' THEN i.prifirstname END ,
		HolderLastName = CASE WHEN i.priinsuredrelation <> 'SELF' THEN i.prilastname END ,
		HolderMiddleName = CASE WHEN i.priinsuredrelation <> 'SELF' THEN i.primiddlename END ,
		HolderAddressLine1 = CASE WHEN i.priinsuredrelation <> 'SELF' THEN i.priinsuredaddress END  ,
		HolderAddressLine2 = CASE WHEN i.priinsuredrelation <> 'SELF' THEN '' END ,
		HolderCity = CASE WHEN i.priinsuredrelation <> 'SELF' THEN i.priinsuredcity END ,
		HolderState = CASE WHEN i.priinsuredrelation <> 'SELF' THEN i.priinsuredstate END , 
		HolderZipCode = CASE WHEN i.priinsuredrelation <> 'SELF' THEN i.priinsuredzip END ,
		HolderCountry = CASE WHEN i.priinsuredrelation <> 'SELF' THEN '' END  ,
		HolderDOB = CASE WHEN i.priinsuredrelation <> 'SELF' THEN CASE WHEN ISDATE(i.priinsuredbirthdate) = 1 THEN i.priinsuredbirthdate ELSE NULL END END ,
		DependentPolicyNumber = CASE WHEN i.priinsuredrelation <> 'SELF' THEN ip.PolicyNumber END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.[_import_3_1_PatientDemographics] ipd ON 
	ip.VendorID = ipd.chartnumber AND 
	ip.VendorImportID = @VendorImportID
INNER JOIN dbo.[_import_3_1_priins] i ON
	ipd.fullname = i.fullname 
WHERE ip.Precedence = 1 AND i.priinsuredrelation <> 'SELF' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - 2...'
UPDATE dbo.InsurancePolicy 
	SET HolderGender = CASE WHEN i.secinsuredrelation <> 'SELF' THEN CASE i.secinsuredsex WHEN 'MALE' THEN 'M' WHEN 'FEMALE' THEN 'F' ELSE 'U' END END ,
		HolderSSN = CASE WHEN i.secinsuredrelation <> 'SELF' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.socialsecurity)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.socialsecurity), 9) ELSE '' END END ,
		PatientRelationshipToInsured = CASE i.secinsuredrelation WHEN 'CHILD' THEN 'C' WHEN 'SPOUSE' THEN 'U' ELSE 'S' END ,
		HolderFirstName = CASE WHEN i.secinsuredrelation <> 'SELF' THEN i.secfirstname END ,
		HolderLastName = CASE WHEN i.secinsuredrelation <> 'SELF' THEN i.seclastname END ,
		HolderMiddleName = CASE WHEN i.secinsuredrelation <> 'SELF' THEN i.secmiddlename END ,
		HolderAddressLine1 = CASE WHEN i.secinsuredrelation <> 'SELF' THEN i.secinsuredaddress END  ,
		HolderAddressLine2 = CASE WHEN i.secinsuredrelation <> 'SELF' THEN '' END ,
		HolderCity = CASE WHEN i.secinsuredrelation <> 'SELF' THEN i.secinsuredcity END ,
		HolderState = CASE WHEN i.secinsuredrelation <> 'SELF' THEN i.secinsuredstate END , 
		HolderZipCode = CASE WHEN i.secinsuredrelation <> 'SELF' THEN i.secinsuredzip END ,
		HolderCountry = CASE WHEN i.secinsuredrelation <> 'SELF' THEN '' END  ,
		HolderDOB = CASE WHEN i.secinsuredrelation <> 'SELF' THEN CASE WHEN ISDATE(i.secinsuredbirthdate) = 1 THEN i.secinsuredbirthdate ELSE NULL END END ,
		DependentPolicyNumber = CASE WHEN i.secinsuredrelation <> 'SELF' THEN ip.PolicyNumber END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.[_import_3_1_PatientDemographics] ipd ON 
	ip.VendorID = ipd.chartnumber AND 
	ip.VendorImportID = @VendorImportID
INNER JOIN dbo.[_import_3_1_secins] i ON
	ipd.fullname = i.fullname 
WHERE ip.Precedence = 2 AND i.secinsuredrelation <> 'SELF'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

