USE superbill_60757_prod
GO

BEGIN TRAN
SET XACT_ABORT ON 
SET NOCOUNT ON 

UPDATE d
SET NPI = LEFT(i.npi,10) , 
	AddressLine1 = i.address1 ,
	AddressLine2 = i.address2 ,
	City = i.city ,
	[State] = i.[state] ,
	ZipCode = i.zip , 
	MobilePhone = 	CASE
						WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone2)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone2),10)
					ELSE '' END ,
	MobilePhoneExt =CASE
					WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone2)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.phone2),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.phone2))),10)
					ELSE NULL END  ,
	WorkPhone =		CASE
					WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.contact)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.contact),10)
					ELSE '' END  , 
	WorkPhoneExt=	CASE
					WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.contact)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.contact),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.contact))),10)
					ELSE NULL END ,
	HomePhone =		CASE
					WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone),10)
					ELSE '' END  , 
	HomePhoneExt=	CASE
					WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.phone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.phone))),10)
					ELSE NULL END ,
	VendorID = i.referral ,
	ModifiedDate = GETDATE()
FROM dbo.Doctor d 
INNER JOIN dbo._import_2_1_Sheet i ON 
	d.DoctorID = (SELECT MAX(d2.DoctorID) FROM dbo.Doctor d2 
				  WHERE d2.FirstName = i.firstname AND
						d2.LastName = i.lastname AND
						d2.[External] = 1 AND
						d2.PracticeID = 1)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

UPDATE d
SET NPI = LEFT(i.npi,10) , 
	AddressLine1 = i.address1 ,
	AddressLine2 = i.address2 ,
	City = i.city ,
	[State] = i.[state] ,
	ZipCode = i.zip , 
	MobilePhone = 	CASE
						WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone2)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone2),10)
					ELSE '' END ,
	MobilePhoneExt =CASE
					WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone2)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.phone2),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.phone2))),10)
					ELSE NULL END  ,
	WorkPhone =		CASE
					WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.contact)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.contact),10)
					ELSE '' END  , 
	WorkPhoneExt=	CASE
					WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.contact)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.contact),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.contact))),10)
					ELSE NULL END ,
	HomePhone =		CASE
					WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone),10)
					ELSE '' END  , 
	d.HomePhoneExt=	CASE
					WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.phone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.phone))),10)
					ELSE NULL END ,
	d.VendorID = i.referral ,
	ModifiedDate = GETDATE()
FROM dbo.Doctor d 
INNER JOIN dbo._import_2_1_Sheet i ON 
						d.FirstName = i.firstname AND
						d.LastName = i.lastname AND
						d.[External] = 1 AND
						d.PracticeID = 1 
WHERE d.VendorID <> i.referral
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT