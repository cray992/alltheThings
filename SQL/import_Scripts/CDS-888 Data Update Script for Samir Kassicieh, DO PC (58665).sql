USE superbill_58665_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT , @VendorImportID INT 
SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Update Patient Demographics...'
UPDATE dbo.Patient
	SET MedicalRecordNumber = i.chartnumber , 
		MaritalStatus = CASE i.maritalstatus
							WHEN 2 THEN 'M'
							WHEN 3 THEN 'D'
							WHEN 4 THEN 'L'
							WHEN 5 THEN 'W'
							WHEN 1 THEN 'S'
					    ELSE '' END , 
		AddressLine1 = i.address2 , 
		AddressLine2 = i.address1 , 
		City = i.city , 
		ZipCode = CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (4,8) THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.zipcode),9)
					   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zipcode)
				  ELSE '' END ,
		HomePhone = LEFT(i.homephone,10) , 
		MobilePhone = LEFT(i.cell,10) ,
		WorkPhone = LEFT(i.officephone,10) , 
		WorkPhoneExt = LEFT(i.officeextension,10) ,
		ResponsibleDifferentThanPatient = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname THEN 1 ELSE 0 END ,
		ResponsibleRelationshipToPatient = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN CASE i.relationship 
												WHEN 1 THEN 'S' 
												WHEN 2 THEN 'U' 
												WHEN 3 THEN 'C'
												WHEN 4 THEN 'O'
											ELSE 'O' END ELSE 'O' END ,
		 ResponsiblePrefix = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN '' END ,
         ResponsibleFirstName = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.firstname END ,
         ResponsibleMiddleName = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.middlename END ,
         ResponsibleLastName = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.lastname END ,
         ResponsibleSuffix = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN '' END ,
         ResponsibleAddressLine1 = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.address2 END ,
         ResponsibleAddressLine2 = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.address1 END ,
         ResponsibleCity = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.city END ,
         ResponsibleState = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.[state] END ,
         ResponsibleCountry = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN '' END ,
         ResponsibleZipCode = CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN LEFT(REPLACE(rp.zipcode,'-',''),9) END 
FROM dbo.Patient p 
	INNER JOIN dbo._import_4_1_PatientInfo i ON 
		p.VendorID = i.patientuid AND 
		p.VendorImportID = @VendorImportID
	LEFT JOIN dbo.[_import_4_1_ResponsibleParties] rp ON
		i.responsiblepartyfid = rp.responsiblepartyuid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT