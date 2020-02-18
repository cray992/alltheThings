
DECLARE @VendorImportID int

INSERT INTO VendorImport (VendorName, VendorFormat, DateCreated, Notes)
VALUES ('Chuck Bagby', 'parsed', GETDATE(), 'None')

SET @VendorImportID = SCOPE_IDENTITY()

INSERT INTO DOCTOR (
	PracticeID, 
	Prefix, 
	FirstName, 
	MiddleName, 
	LastName, 
	Suffix, 
	SSN, 
	AddressLine1, 
	AddressLine2, 
	City, 
	State, 
	Country, 
	ZipCode, 
	HomePhone, 
	HomePhoneExt, 
	WorkPhone, 
	WorkPhoneExt, 
	PagerPhone, 
	PagerPhoneExt, 
	MobilePhone, 
	MobilePhoneExt, 
	DOB, 
	EmailAddress, 
	Notes, 
	ActiveDoctor, 
	CreatedDate, 
	CreatedUserID, 
	ModifiedDate, 
	ModifiedUserID, 
	RecordTimeStamp, 
	UserID, 
	Degree, 
	DefaultEncounterTemplateID, 
	TaxonomyCode, 
	DepartmentID, 
	VendorID, 
	VendorImportID, 
	FaxNumber, 
	FaxNumberExt, 
	OrigReferringPhysicianID, 
	[External]
)
SELECT 
	1,	--PracticeID, 
	'',	--Prefix, 
	LTRIM(RTRIM(ISNULL(FirstName, ''))),		--FirstName, 
	'',	--MiddleName, 
	LTRIM(RTRIM(ISNULL(LastName, ''))),		--LastName, 
	'',	--Suffix, 
	NULL,	--SSN, 
	AddressLine1,		--AddressLine1, 
	AddressLine2,		--AddressLine2, 
	City,		--City, 
	State,		--State, 
	NULL,	--Country, 
	LEFT(REPLACE(REPLACE(REPLACE(ZipCode, '(', ''), ')', ''), '-', ''), 9),	--ZipCode, 
	LEFT(REPLACE(REPLACE(REPLACE(Phone, '(', ''), ')', ''), '-', ''), 10),		--HomePhone, 
	NULL,	--HomePhoneExt, 
	NULL,	--WorkPhone, 
	NULL,	--WorkPhoneExt, 
	NULL,	--PagerPhone, 
	NULL,	--PagerPhoneExt, 
	NULL,	--MobilePhone, 
	NULL,	--MobilePhoneExt, 
	NULL,	--DOB, 
	NULL,	--EmailAddress, 
	NULL,	--Notes, 
	1,	--ActiveDoctor, (Default -1)
	GETDATE(),	--CreatedDate,	(getdate())
	0,	--CreatedUserID,	(0)
	GETDATE(),	--ModifiedDate, 	(getdate())
	0,	--ModifiedUserID,	(0)
	NULL,	--RecordTimeStamp,	(Default)
	NULL,	--UserID, 
	NULL,	--Degree, 
	NULL,	--DefaultEncounterTemplateID, 
	NULL,	--TaxonomyCode, 
	NULL,	--DepartmentID, 
	NULL,	--VendorID, 
	@VendorImportID,	--VendorImportID, 
	LEFT(REPLACE(REPLACE(REPLACE(Fax, '(', ''), ')', ''), '-', ''), 10),		--FaxNumber, 
	NULL,	--FaxNumberExt, 
	NULL,	--OrigReferringPhysicianID, 
	1	--[External]

FROM         dbo.Imp_741_Referral_15272_2
