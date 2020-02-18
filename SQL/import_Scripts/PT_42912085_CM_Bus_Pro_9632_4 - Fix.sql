USE superbill_9632_dev
--USE superbill_9632_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

	UPDATE 
		InsuranceCompany
	SET 
		ZipCode = LEFT(ZipCode, 5) + '00' + RIGHT(ZipCode, 2)
	WHERE 
		LEN(ZipCode) =  7 AND
		CreatedPracticeID = 4

	UPDATE 
		InsuranceCompanyPlan 
	SET 
		ZipCode = LEFT(ZipCode, 5) + '00' + RIGHT(ZipCode, 2)
	WHERE 
		LEN(ZipCode) =  7 AND
		CreatedPracticeID = 4
		
	UPDATE 
		InsuranceCompany 
	SET 
		ZipCode = LEFT(ZipCode, 5) + '0' + RIGHT(ZipCode, 3)
	WHERE 
		LEN(ZipCode) =  8 AND
		CreatedPracticeID = 4
		
	UPDATE 
		InsuranceCompanyPlan 
	SET 
		ZipCode = LEFT(ZipCode, 5) + '0' + RIGHT(ZipCode, 3)
	WHERE 
		LEN(ZipCode) =  8 AND
		CreatedPracticeID = 4


COMMIT