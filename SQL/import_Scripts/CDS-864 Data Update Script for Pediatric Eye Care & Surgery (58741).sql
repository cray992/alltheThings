USE superbill_58741_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

UPDATE dbo.Patient
SET AddressLine1 = i.address1 , 
	City = i.city ,
	[State] = i.[STATE] ,
	ZipCode = CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zipcode)
				   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) = 3 THEN '00' + dbo.fn_RemoveNonNumericCharacters(i.zipcode)
			       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zipcode)
			  ELSE '00000' END , 
	CreatedDate = GETDATE() , 
	ModifiedDate = GETDATE()
FROM dbo.Patient p 
INNER JOIN dbo._import_2_1_PATIENTIMPORTKAREO i ON 
	p.FirstName = i.firstname AND 
	p.LastName = i.lastname AND 
	p.DOB = DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) 
WHERE p.ModifiedUserID = 0 AND p.VendorImportID = 1 AND i.address1 <> p.AddressLine1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient records updated'

--COMMIT
--ROLLBACK
