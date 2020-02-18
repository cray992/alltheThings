USE superbill_59263_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

UPDATE dbo.Patient 
	SET ZipCode = CASE 
					WHEN LEN(i.zipcode) = 1 THEN '0000' + i.zipcode
					WHEN LEN(i.zipcode) = 3 THEN '00' + i.zipcode
				  END			   
FROM dbo.Patient p 
INNER JOIN dbo._import_1_3_PatientDemographics i ON 
	p.VendorID = i.chartnumber AND 
    p.VendorImportID = 1 AND 
	p.PracticeID = 3
WHERE p.ModifiedUserID = 0 AND LEN(i.zipcode) IN (1,3)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Zip Codes Updated...'

--ROLLBACK
--COMMIT
