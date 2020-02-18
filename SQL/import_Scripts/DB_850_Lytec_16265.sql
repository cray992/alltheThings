-- *****************************************************************
-- *** NEED PraciticeID ********************************************
-- *****************************************************************

DECLARE @VendorImportID int
DECLARE @PracticeID int
DECLARE @Rows Int
DECLARE @Message Varchar(75)

EXEC DataInterface_SetupLytecTables

INSERT INTO VendorImport (VendorName, VendorFormat, DateCreated, Notes)
VALUES ('Chuck Bagby', 'csv', GETDATE(), 'None')

SET @VendorImportID = SCOPE_IDENTITY()

--INSERT INTO Practice ([Name], VendorImportID) VALUES ('Name', @VendorImportID)
--SET @PracticeID = SCOPE_IDENTITY()
SET @PracticeID = 1
--SELECT @PracticeID = PracticeID 
--FROM Practice
--WHERE [Name] = 'Chucks practice'

DECLARE @DefaultPayerScenarioID int
SET @DefaultPayerScenarioID = 5 --Commercial

DECLARE @ZipCleanupPattern varchar(10)
DECLARE @AddressCleanupCheckPattern varchar(10)
DECLARE @SSNCleanupPattern varchar(10)

SET @AddressCleanupCheckPattern = '[\.,]'
SET @ZipCleanupPattern = '[ -]'
SET @SSNCleanupPattern = '[-]'

--UPDATE Lutec Tables VendorImportID
UPDATE dbo.lytec_insurance
SET VendorImportID = @VendorImportID

UPDATE dbo.lytec_address
SET VendorImportID = @VendorImportID

UPDATE dbo.lytec_patients
SET VendorImportID = @VendorImportID

UPDATE lytec_insurance SET InsuranceCompanyID = NULL

UPDATE lytec_insurance SET InsuranceCompanyPlanID = NULL

-- Begin Import
UPDATE 
	lytec_insurance
SET
	InsuranceCompanyID = IC.InsuranceCompanyID
FROM
	lytec_insurance i
	INNER JOIN InsuranceCompany IC ON (
		UPPER(i.City) = UPPER(IC.City)
		AND UPPER(i.State) = UPPER(IC.State)
		AND LEFT(dbo.RegexReplace(i.[Zip Code],@ZipCleanupPattern,''),9) = IC.ZipCode
		AND i.Phone = IC.Phone
	)
WHERE
	LEN(i.City) > 0 AND LEN(i.State) > 0 AND LEN(i.[Zip Code]) > 0 AND LEN(i.[Address 1]) > 0
	AND i.VendorImportID = @VendorImportID


Select @Rows = @@RowCount
Select @Message = 'Rows Updated in lytec_insurance Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--SELECT @Rows = COUNT(*) FROM [x_TAPPT(1)_csv]
--Select @Message = 'Rows in original x_TAPPT(1)_csv Table '
--Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


INSERT INTO
	InsuranceCompany 
	(InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, ReviewCode, CreatedPracticeID, VendorID, VendorImportID)
SELECT
	Name, [Address 1], [Address 2], City, State, LEFT(dbo.RegexReplace([Zip Code], @ZipCleanupPattern,''),9), Phone, 'R', @PracticeID, Code, @VendorImportID
FROM
	lytec_insurance
WHERE
	InsuranceCompanyID IS NULL
	AND VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsuranceCompany Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [lytec_insurance]
Select @Message = 'Rows in original lytec_insurance Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

UPDATE
	lytec_insurance
SET
	InsuranceCompanyID = IC.InsuranceCompanyID
FROM
	InsuranceCompany IC
	INNER JOIN lytec_insurance i ON i.Code = IC.VendorID AND IC.VendorImportID = @VendorImportID
WHERE
	i.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Updated in lytec_insurance Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


--insurance company plans

UPDATE 
	lytec_insurance
SET
	InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
FROM
	lytec_insurance i
	INNER JOIN InsuranceCompany IC ON i.InsuranceCompanyID = IC.InsuranceCompanyID
	INNER JOIN InsuranceCompanyPlan ICP ON (
		ICP.InsuranceCompanyID = IC.InsuranceCompanyID
		AND UPPER(i.City) = UPPER(ICP.City)
		AND UPPER(i.State) = UPPER(ICP.State)
		AND LEFT(dbo.RegexReplace(i.[Zip Code],@ZipCleanupPattern,''),9) = ICP.ZipCode
		AND i.Phone = ICP.Phone
	)
WHERE
	LEN(i.City) > 0 AND LEN(i.State) > 0 AND LEN(i.[Zip Code]) > 0 AND LEN(i.[Address 1]) > 0
	AND i.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Updated in lytec_insurance Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

INSERT INTO
	InsuranceCompanyPlan
	(InsuranceCompanyID, PlanName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, ReviewCode, CreatedPracticeID, VendorID, VendorImportID)
SELECT
	InsuranceCompanyID, Name, [Address 1], [Address 2], City, State, LEFT(dbo.RegexReplace([Zip Code], @ZipCleanupPattern,''),9), Phone, 'R', @PracticeID, Code, @VendorImportID
FROM
	lytec_insurance
WHERE
	InsuranceCompanyPlanID IS NULL
	AND VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsuranceCompanyPlan Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [lytec_insurance]
Select @Message = 'Rows in original lytec_insurance Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

UPDATE
	lytec_insurance
SET
	InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
FROM
	InsuranceCompanyPlan ICP
	INNER JOIN lytec_insurance i ON i.Code = ICP.VendorID AND ICP.VendorImportID = @VendorImportID
WHERE
	i.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Updated in lytec_insurance Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
--
--process patients
--

--employer creation

/* SKIPPING: current lytec data has no employers set */

--provider creation

INSERT INTO Doctor
	(PracticeID, 
	Prefix, 
	FirstName, 
	MiddleName, 
	LastName, 
	Suffix, 
	TaxonomyCode, 
	[External], 
	VendorID, 
	VendorImportID)
SELECT DISTINCT
	@PracticeID,
	'',
	'',
	'',
	Provider,
	'',
	'0000000001',
	0,
	Provider, 
	@VendorImportID
FROM
	lytec_patients
WHERE
	VendorImportID = @VendorImportID
	AND Provider IS NOT NULL AND LEN(Provider) > 0

Select @Rows = @@RowCount
Select @Message = 'Rows Added in Doctor Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [lytec_patients]
Select @Message = 'Rows in original lytec_patients Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--patient

INSERT INTO Patient
	(PracticeID, 
	Prefix, 
	FirstName, 
	MiddleName, 
	LastName, 
	Suffix, 
	AddressLine1, 
	AddressLine2, 
	City, 
	State, 
	ZipCode,
	Gender, 
	MaritalStatus,
	HomePhone, 
	WorkPhone, 
	WorkPhoneExt, 
	DOB, 
	SSN,
	EmailAddress,
	PrimaryProviderID,
	MedicalRecordNumber,
	VendorID,
	VendorImportID)
SELECT
	@PracticeID, 
	'', 
	i.[First Name], 
	i.[Middle Initial], 
	i.[Last Name], 
	'',
	i.[Address 1],
	i.[Address 2], 
	i.City, 
	i.State, 
	LEFT(dbo.RegexReplace(i.[Zip Code],@ZipCleanupPattern,''),9),
	i.Sex, 
	i.[Marital Status],
	i.[Home Phone], 
	i.[Work Phone], 
	CASE WHEN LEN(i.[Work Extension]) > 0 THEN i.[Work Extension] ELSE NULL END, 
	dbo.DateFromYYYYMMDD(i.[Date Of Birth]),
	CASE WHEN LEN(dbo.RegexReplace(i.[Social Security Number],@SSNCleanupPattern,'')) > 0 THEN dbo.RegexReplace(i.[Social Security Number],@SSNCleanupPattern,'') ELSE NULL END,
	CASE WHEN LEN(i.[Home Email]) > 0 THEN i.[Home Email] ELSE CASE WHEN LEN(i.[Work Email]) > 0 THEN i.[Work Email] ELSE NULL END END,
	D.DoctorID,
	i.[Chart Number],
	i.[Chart Number],
	@VendorImportID
FROM
	lytec_patients i
	LEFT OUTER JOIN Doctor D 
	ON D.VendorImportID = @VendorImportID 
	AND D.VendorID = i.Provider
WHERE
	i.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in Patient Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [lytec_patients]
Select @Message = 'Rows in original lytec_patients Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--patient case creation

INSERT INTO
	PatientCase
	(PatientID, Name, PayerScenarioID, ReferringPhysicianID, PracticeID, VendorID, VendorImportID)
SELECT
	P.PatientID, 'Default Case', @DefaultPayerScenarioID, P.ReferringPhysicianID, @PracticeID, P.VendorID, @VendorImportID
FROM
	Patient P
WHERE
	P.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in PatientCase Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--add dates: total disability (5)
INSERT INTO PatientCaseDate
	(PracticeID, PatientCaseID, 
	PatientCaseDateTypeID, 
	StartDate, EndDate)
SELECT
	@PracticeID, PC.PatientCaseID, 
	5, 
	dbo.DateFromYYYYMMDD(i.[Total Disability 1]), dbo.DateFromYYYYMMDD(i.[Total Disability 2])
FROM
	lytec_patients i
	INNER JOIN Patient P ON P.VendorImportID = @VendorImportID AND P.VendorID = i.[Chart Number]
	INNER JOIN PatientCase PC ON PC.PatientID = P.PatientID
WHERE
	i.VendorImportID = @VendorImportID
	AND dbo.DateFromYYYYMMDD(i.[Total Disability 1]) IS NOT NULL 

Select @Rows = @@RowCount
Select @Message = 'Rows Added in PatientCaseDate Table Disability '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--add dates: hospitalization (6)
INSERT INTO PatientCaseDate
	(PracticeID, PatientCaseID, 
	PatientCaseDateTypeID, 
	StartDate, EndDate)
SELECT
	@PracticeID, PC.PatientCaseID, 
	6, 
	dbo.DateFromYYYYMMDD(i.[Hospitalization 1]), dbo.DateFromYYYYMMDD(i.[Hospitalization 2])
FROM
	lytec_patients i
	INNER JOIN Patient P ON P.VendorImportID = @VendorImportID AND P.VendorID = i.[Chart Number]
	INNER JOIN PatientCase PC ON PC.PatientID = P.PatientID
WHERE
	i.VendorImportID = @VendorImportID
	AND dbo.DateFromYYYYMMDD(i.[Hospitalization 1]) IS NOT NULL 

Select @Rows = @@RowCount
Select @Message = 'Rows Added in PatientCaseDate Table hospitalization '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--add dates: dateofinjury (2)
INSERT INTO PatientCaseDate
	(PracticeID, PatientCaseID, 
	PatientCaseDateTypeID, 
	StartDate)
SELECT
	@PracticeID, PC.PatientCaseID, 
	2, 
	dbo.DateFromYYYYMMDD(i.[Symptom Date])
FROM
	lytec_patients i
	INNER JOIN Patient P ON P.VendorImportID = @VendorImportID AND P.VendorID = i.[Chart Number]
	INNER JOIN PatientCase PC ON PC.PatientID = P.PatientID
WHERE
	i.VendorImportID = @VendorImportID
	AND dbo.DateFromYYYYMMDD(i.[Symptom Date]) IS NOT NULL 

Select @Rows = @@RowCount
Select @Message = 'Rows Added in PatientCaseDate Table dateofinjury '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--add dates: similarillness (3)
INSERT INTO PatientCaseDate
	(PracticeID, PatientCaseID, 
	PatientCaseDateTypeID, 
	StartDate)
SELECT
	@PracticeID, PC.PatientCaseID, 
	3, 
	dbo.DateFromYYYYMMDD(i.[Similar Date])
FROM
	lytec_patients i
	INNER JOIN Patient P ON P.VendorImportID = @VendorImportID AND P.VendorID = i.[Chart Number]
	INNER JOIN PatientCase PC ON PC.PatientID = P.PatientID
WHERE
	i.VendorImportID = @VendorImportID
	AND dbo.DateFromYYYYMMDD(i.[Similar Date]) IS NOT NULL 

Select @Rows = @@RowCount
Select @Message = 'Rows Added in PatientCaseDate Table similarillness '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--
--insurance policy creation
--

--Primary Policy, First patients with their own insurance

INSERT INTO InsurancePolicy
	(PracticeID, 
	PatientCaseID, 
	InsuranceCompanyPlanID, 
	Precedence, 
	PolicyNumber, 
	GroupNumber, 
	PatientRelationshipToInsured,
	HolderPrefix, 
	HolderFirstName, 
	HolderMiddleName, 
	HolderLastName, 
	HolderSuffix, 
	HolderDOB, 
	HolderSSN,
	HolderGender, 
	HolderAddressLine1, 
	HolderAddressLine2, 
	HolderCity, 
	HolderState, 
	HolderCountry, 
	HolderZipCode, 
	HolderPhone, 
	HolderPhoneExt,
	VendorImportID)
SELECT
	@PracticeID, 
	PC.PatientCaseID, 
	LyIns.InsuranceCompanyPlanID, 
	1, 
	LyPat.[Insurance Insured ID 1], 
	LyPat.[Insurance Group Number 1],
	'S',
	Pat.Prefix AS Prefix, 
	Pat.FirstName AS FirstName, 
	Pat.MiddleName AS MiddleName, 
	Pat.LastName AS LastName, 
	Pat.Suffix AS Suffix, 
	Pat.DOB AS DOB, 
	Pat.SSN AS SSN,
	Pat.Gender AS Gender, 
	Pat.AddressLine1 AS AddressLine1, 
	Pat.AddressLine2 AS AddressLine2, 
	Pat.City AS City, 
	Pat.State AS State, 
	Pat.Country AS Country, 
	Pat.ZipCode AS ZipCode, 
	Pat.HomePhone AS HomePhone, 
	Pat.HomePhoneExt AS HomePhoneExt,
	@VendorImportID
FROM
	lytec_patients LyPat 
	INNER JOIN lytec_insurance LyIns  
	ON LyPat.[Insurance Code 1] = LyIns.Code 
	AND LyIns.VendorImportID = @VendorImportID
	INNER JOIN Patient Pat 
	ON Pat.VendorImportID = @VendorImportID 
	AND Pat.VendorID = LyPat.[Chart Number]
	INNER JOIN PatientCase PC 
	ON PC.PatientID = Pat.PatientID
WHERE
	LyPat.VendorImportID = @VendorImportID
	AND LyPat.[Insurance Insured Is 1] = '1'

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy Table primary '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


-- Primary policy, Now Patients who have Guantors
INSERT INTO InsurancePolicy
	(
	PracticeID, 
	PatientCaseID, 
	InsuranceCompanyPlanID, 
	Precedence, 
	PolicyNumber, 
	GroupNumber, 
	PatientRelationshipToInsured,
	HolderPrefix, 
	HolderFirstName, 
	HolderMiddleName, 
	HolderLastName, 
	HolderSuffix, 
	HolderDOB, 
	HolderSSN,
	HolderGender, 
	HolderAddressLine1, 
	HolderAddressLine2, 
	HolderCity, 
	HolderState, 
	HolderCountry, 
	HolderZipCode, 
	HolderPhone, 
	HolderPhoneExt,
	VendorImportID)
SELECT
	@PracticeID, 
	PC.PatientCaseID, 
	LyIns.InsuranceCompanyPlanID, 
	1, 
	LyPat.[Insurance Insured ID 1], 
	LyPat.[Insurance Group Number 1],
	'O',
	'' AS HolderPrefix, 
	ISNULL(lytec_guarantor.[First Name], '') AS HolderFirstName, 
	ISNULL(lytec_guarantor.[Middle Initial], '') AS HolderMiddleName, 
	ISNULL(lytec_guarantor.[Last Name], '') AS HolderLastName, 
	'' AS HolderSuffix, 
	dbo.DateFromYYYYMMDD(lytec_guarantor.[Date Of Birth]) AS HolderDOB, 
	CASE WHEN LEN(dbo.RegexReplace(lytec_guarantor.[Social Security Number] ,@SSNCleanupPattern,'')) > 0 THEN dbo.RegexReplace(lytec_guarantor.[Social Security Number] ,@SSNCleanupPattern,'') ELSE NULL END AS HolderSSN,
	lytec_guarantor.Sex AS HolderGender, 
	lytec_guarantor.[Address 1] AS HolderAddressLine1, 
	lytec_guarantor.[Address 2] AS HolderAddressLine2, 
	lytec_guarantor.City AS HolderCity, 
	lytec_guarantor.State AS HolderState, 
	'' AS HolderCountry, 
	LEFT(dbo.RegexReplace(lytec_guarantor.[Zip Code], @ZipCleanupPattern,''),9) AS HolderZipCode, 
	lytec_guarantor.[Home Phone] AS HolderHomePhone, 
	NULL AS HolderPhoneExt,
	@VendorImportID
FROM
	lytec_patients LyPat 
	INNER JOIN lytec_insurance LyIns  
	ON LyPat.[Insurance Code 1] = LyIns.Code 
	AND LyIns.VendorImportID = @VendorImportID
	INNER JOIN Patient Pat 
	ON Pat.VendorImportID = @VendorImportID 
	AND Pat.VendorID = LyPat.[Chart Number]
	INNER JOIN PatientCase PC 
	ON PC.PatientID = Pat.PatientID
	LEFT OUTER JOIN lytec_guarantor 
	ON LyPat.[Insurance Insured 1] = lytec_guarantor.Code
WHERE
	LyPat.VendorImportID = @VendorImportID
	AND LyPat.[Insurance Insured Is 1] <> '1'

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy Table primary with guarantor'
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


--secondary policy own insurance (no guarantor)
INSERT INTO InsurancePolicy
	(PracticeID, 
	PatientCaseID, 
	InsuranceCompanyPlanID, 
	Precedence, 
	PolicyNumber, 
	GroupNumber, 
	PatientRelationshipToInsured,
	HolderPrefix, 
	HolderFirstName, 
	HolderMiddleName, 
	HolderLastName, 
	HolderSuffix, 
	HolderDOB, 
	HolderSSN,
	HolderGender, 
	HolderAddressLine1, 
	HolderAddressLine2, 
	HolderCity, 
	HolderState, 
	HolderCountry, 
	HolderZipCode, 
	HolderPhone, 
	HolderPhoneExt,
	VendorImportID)
SELECT
	@PracticeID, 
	PC.PatientCaseID, 
	LyIns.InsuranceCompanyPlanID, 
	1, 
	LyPat.[Insurance Insured ID 2], 
	LyPat.[Insurance Group Number 2],
	'S',
	Pat.Prefix AS Prefix, 
	Pat.FirstName AS FirstName, 
	Pat.MiddleName AS MiddleName, 
	Pat.LastName AS LastName, 
	Pat.Suffix AS Suffix, 
	Pat.DOB AS DOB, 
	Pat.SSN AS SSN,
	Pat.Gender AS Gender, 
	Pat.AddressLine1 AS AddressLine1, 
	Pat.AddressLine2 AS AddressLine2, 
	Pat.City AS City, 
	Pat.State AS State, 
	Pat.Country AS Country, 
	Pat.ZipCode AS ZipCode, 
	Pat.HomePhone AS HomePhone, 
	Pat.HomePhoneExt AS HomePhoneExt,
	@VendorImportID
FROM
	lytec_patients LyPat 
	INNER JOIN lytec_insurance LyIns  
	ON LyPat.[Insurance Code 2] = LyIns.Code 
	AND LyIns.VendorImportID = @VendorImportID
	INNER JOIN Patient Pat 
	ON Pat.VendorImportID = @VendorImportID 
	AND Pat.VendorID = LyPat.[Chart Number]
	INNER JOIN PatientCase PC 
	ON PC.PatientID = Pat.PatientID
WHERE
	LyPat.VendorImportID = @VendorImportID
	AND LyPat.[Insurance Insured Is 2] = '1'


Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy secondary '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


-- Secondary Insurance for Patients who have Guantors
INSERT INTO InsurancePolicy
	(PracticeID, 
	PatientCaseID, 
	InsuranceCompanyPlanID, 
	Precedence, 
	PolicyNumber, 
	GroupNumber, 
	PatientRelationshipToInsured,
	HolderPrefix, 
	HolderFirstName, 
	HolderMiddleName, 
	HolderLastName, 
	HolderSuffix, 
	HolderDOB, 
	HolderSSN,
	HolderGender, 
	HolderAddressLine1, 
	HolderAddressLine2, 
	HolderCity, 
	HolderState, 
	HolderCountry, 
	HolderZipCode, 
	HolderPhone, 
	HolderPhoneExt,
	VendorImportID)
SELECT
	@PracticeID, 
	PC.PatientCaseID, 
	LyIns.InsuranceCompanyPlanID, 
	2, 
	LyPat.[Insurance Insured ID 2], 
	LyPat.[Insurance Group Number 2],
	'O',
	'' AS HolderPrefix, 
	ISNULL(lytec_guarantor.[First Name], '') AS HolderFirstName, 
	ISNULL(lytec_guarantor.[Middle Initial], '') AS HolderMiddleName, 
	ISNULL(lytec_guarantor.[Last Name], '') AS HolderLastName, 
	'' AS HolderSuffix, 
	dbo.DateFromYYYYMMDD(lytec_guarantor.[Date Of Birth]) AS DOB, 
	CASE WHEN LEN(dbo.RegexReplace(lytec_guarantor.[Social Security Number] ,@SSNCleanupPattern,'')) > 0 THEN dbo.RegexReplace(lytec_guarantor.[Social Security Number] ,@SSNCleanupPattern,'') ELSE NULL END AS SSN,
	lytec_guarantor.Sex AS Gender, 
	lytec_guarantor.[Address 1] AS AddressLine1, 
	lytec_guarantor.[Address 2] AS AddressLine2, 
	lytec_guarantor.City AS City, 
	lytec_guarantor.State AS State, 
	'' AS Country, 
	LEFT(dbo.RegexReplace(lytec_guarantor.[Zip Code], @ZipCleanupPattern,''),9) AS ZipCode, 
	lytec_guarantor.[Home Phone] AS HomePhone, 
	NULL AS HolderPhoneExt,
	@VendorImportID
FROM
	lytec_patients LyPat 
	INNER JOIN lytec_insurance LyIns  
	ON LyPat.[Insurance Code 2] = LyIns.Code 
	AND LyIns.VendorImportID = @VendorImportID
	INNER JOIN Patient Pat 
	ON Pat.VendorImportID = @VendorImportID 
	AND Pat.VendorID = LyPat.[Chart Number]
	INNER JOIN PatientCase PC 
	ON PC.PatientID = Pat.PatientID
	LEFT OUTER JOIN lytec_guarantor 
	ON LyPat.[Insurance Insured 2] = lytec_guarantor.Code
WHERE
	LyPat.VendorImportID = @VendorImportID
	AND LyPat.[Insurance Insured Is 2] <> '1'

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy secondary with guarantors'
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


--tertiary policy
INSERT INTO InsurancePolicy
	(PracticeID, 
	PatientCaseID, 
	InsuranceCompanyPlanID, 
	Precedence, 
	PolicyNumber, 
	GroupNumber, 
	PatientRelationshipToInsured,
	HolderPrefix, 
	HolderFirstName, 
	HolderMiddleName, 
	HolderLastName, 
	HolderSuffix, 
	HolderDOB, 
	HolderSSN,
	HolderGender, 
	HolderAddressLine1, 
	HolderAddressLine2, 
	HolderCity, 
	HolderState, 
	HolderCountry, 
	HolderZipCode, 
	HolderPhone, 
	HolderPhoneExt,
	VendorImportID)
SELECT
	@PracticeID, 
	PC.PatientCaseID, 
	LyIns.InsuranceCompanyPlanID, 
	1, 
	LyPat.[Insurance Insured ID 3], 
	LyPat.[Insurance Group Number 3],
	'S',
	Pat.Prefix AS Prefix, 
	Pat.FirstName AS FirstName, 
	Pat.MiddleName AS MiddleName, 
	Pat.LastName AS LastName, 
	Pat.Suffix AS Suffix, 
	Pat.DOB AS DOB, 
	Pat.SSN AS SSN,
	Pat.Gender AS Gender, 
	Pat.AddressLine1 AS AddressLine1, 
	Pat.AddressLine2 AS AddressLine2, 
	Pat.City AS City, 
	Pat.State AS State, 
	Pat.Country AS Country, 
	Pat.ZipCode AS ZipCode, 
	Pat.HomePhone AS HomePhone, 
	Pat.HomePhoneExt AS HomePhoneExt,
	@VendorImportID
FROM
	lytec_patients LyPat 
	INNER JOIN lytec_insurance LyIns  
	ON LyPat.[Insurance Code 3] = LyIns.Code 
	AND LyIns.VendorImportID = @VendorImportID
	INNER JOIN Patient Pat 
	ON Pat.VendorImportID = @VendorImportID 
	AND Pat.VendorID = LyPat.[Chart Number]
	INNER JOIN PatientCase PC 
	ON PC.PatientID = Pat.PatientID
WHERE
	LyPat.VendorImportID = @VendorImportID
	AND LyPat.[Insurance Insured Is 3] = '1'

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy tertiary '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


-- Secondary Insurance for Patients who have Guantors
INSERT INTO InsurancePolicy
	(PracticeID, 
	PatientCaseID, 
	InsuranceCompanyPlanID, 
	Precedence, 
	PolicyNumber, 
	GroupNumber, 
	PatientRelationshipToInsured,
	HolderPrefix, 
	HolderFirstName, 
	HolderMiddleName, 
	HolderLastName, 
	HolderSuffix, 
	HolderDOB, 
	HolderSSN,
	HolderGender, 
	HolderAddressLine1, 
	HolderAddressLine2, 
	HolderCity, 
	HolderState, 
	HolderCountry, 
	HolderZipCode, 
	HolderPhone, 
	HolderPhoneExt,
	VendorImportID)
SELECT
	@PracticeID, 
	PC.PatientCaseID, 
	LyIns.InsuranceCompanyPlanID, 
	2, 
	LyPat.[Insurance Insured ID 3], 
	LyPat.[Insurance Group Number 3],
	'O',
	'' AS HolderPrefix, 
	ISNULL(lytec_guarantor.[First Name], '') AS HolderFirstName, 
	ISNULL(lytec_guarantor.[Middle Initial], '') AS HolderMiddleName, 
	ISNULL(lytec_guarantor.[Last Name], '') AS HolderLastName, 
	'' AS HolderSuffix, 
	dbo.DateFromYYYYMMDD(lytec_guarantor.[Date Of Birth]) AS DOB, 
	CASE WHEN LEN(dbo.RegexReplace(lytec_guarantor.[Social Security Number] ,@SSNCleanupPattern,'')) > 0 THEN dbo.RegexReplace(lytec_guarantor.[Social Security Number] ,@SSNCleanupPattern,'') ELSE NULL END AS SSN,
	lytec_guarantor.Sex AS Gender, 
	lytec_guarantor.[Address 1] AS AddressLine1, 
	lytec_guarantor.[Address 2] AS AddressLine2, 
	lytec_guarantor.City AS City, 
	lytec_guarantor.State AS State, 
	'' AS Country, 
	LEFT(dbo.RegexReplace(lytec_guarantor.[Zip Code], @ZipCleanupPattern,''),9) AS ZipCode, 
	lytec_guarantor.[Home Phone] AS HomePhone,
	NULL AS HolderPhoneExt,
	@VendorImportID
FROM
	lytec_patients LyPat 
	INNER JOIN lytec_insurance LyIns  
	ON LyPat.[Insurance Code 3] = LyIns.Code 
	AND LyIns.VendorImportID = @VendorImportID
	INNER JOIN Patient Pat 
	ON Pat.VendorImportID = @VendorImportID 
	AND Pat.VendorID = LyPat.[Chart Number]
	INNER JOIN PatientCase PC 
	ON PC.PatientID = Pat.PatientID
	LEFT OUTER JOIN lytec_guarantor 
	ON LyPat.[Insurance Insured 3] = lytec_guarantor.Code
WHERE
	LyPat.VendorImportID = @VendorImportID
	AND LyPat.[Insurance Insured Is 3] <> '1'

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy secondary with guarantors'
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


--ref providers and service locations

CREATE TABLE #PatientFacility(PatientID INT, FacilityCode VARCHAR(50), UniqueCode VARCHAR(50))
INSERT INTO #PatientFacility(PatientID, FacilityCode)
SELECT P.PatientID, LP.Facility
FROM Patient P INNER JOIN lytec_patients LP
ON P.VendorImportID=LP.VendorImportID AND P.VendorID=LP.[Chart Number]
WHERE P.VendorImportID=@VendorImportID

CREATE TABLE #PatientReferringProvider(PatientID INT, ReferringProviderCode VARCHAR(50))
INSERT INTO #PatientReferringProvider(PatientID, ReferringProviderCode)
SELECT P.PatientID, LP.[Referring Physician]
FROM Patient P INNER JOIN lytec_patients LP
ON P.VendorImportID=LP.VendorImportID AND P.VendorID=LP.[Chart Number]
WHERE P.VendorImportID=@VendorImportID

CREATE TABLE #Facilities(FacilityCode VARCHAR(50))
CREATE TABLE #ReferringProvider(ReferringProviderCode VARCHAR(50))


UPDATE #PatientFacility SET UniqueCode=FacilityCode
WHERE UniqueCode IS NULL

INSERT INTO #Facilities(FacilityCode)
SELECT DISTINCT FacilityCode
FROM #PatientFacility

INSERT INTO #ReferringProvider(ReferringProviderCode)
SELECT DISTINCT ReferringProviderCode
FROM #PatientReferringProvider


INSERT ServiceLocation(
PracticeID, 
[Name], 
AddressLine1, 
AddressLine2, 
City, 
State, 
ZipCode, 
BillingName,
Phone, 
PhoneExt, 
FaxPhone, 
VendorImportID, 
VendorID)
SELECT 
@PracticeID, 
LTRIM(RTRIM(Name)), 
CASE WHEN LTRIM(RTRIM([Address 1]))='' THEN NULL ELSE LTRIM(RTRIM([Address 1])) END, 
CASE WHEN LTRIM(RTRIM([Address 2]))='' THEN NULL ELSE LTRIM(RTRIM([Address 2])) END, 
CASE WHEN LTRIM(RTRIM(City))='' THEN NULL ELSE LTRIM(RTRIM(City)) END, 
CASE WHEN LTRIM(RTRIM(State))='' THEN NULL ELSE LTRIM(RTRIM(State)) END, 
CASE WHEN LTRIM(RTRIM(REPLACE([Zip Code],'-','')))='' THEN NULL ELSE LTRIM(RTRIM(REPLACE([Zip Code],'-',''))) END,
LTRIM(RTRIM(Name)),
CASE WHEN LTRIM(RTRIM(Phone))='' THEN NULL ELSE LTRIM(RTRIM(Phone)) END, 
CASE WHEN LTRIM(RTRIM(Extension))='' THEN NULL ELSE LTRIM(RTRIM(Extension)) END, 
CASE WHEN LTRIM(RTRIM(Fax))='' THEN NULL ELSE LTRIM(RTRIM(Fax)) END, @VendorImportID, Code
FROM lytec_address a INNER JOIN #Facilities F
ON a.Code=F.FacilityCode
WHERE a.VendorImportID = @VendorImportID
	
Select @Rows = @@RowCount
Select @Message = 'Rows Added in ServiceLocation '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

UPDATE P SET DefaultServiceLocationID=ServiceLocationID
FROM Patient P INNER JOIN #PatientFacility PF
ON P.PatientID=PF.PatientID
INNER JOIN ServiceLocation SL
ON SL.VendorImportID=@VendorImportID AND PF.UniqueCode=SL.VendorID

Select @Rows = @@RowCount
Select @Message = 'Rows Updated in Patient '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

INSERT Doctor(
	PracticeID, 
	FirstName, 
	MiddleName, 
	LastName, 
	Prefix, 
	Suffix, 
	AddressLine1, 
	AddressLine2, 
	City, 
	State, 
	ZipCode, 
	HomePhone, 
	HomePhoneExt, 
	FaxNumber, 
	VendorImportID, 
	VendorID, 
	[External])
SELECT
@PracticeID,
-- Lytec table has single field for entire name and separate fileds for First, Last etc.
-- if first or last is used we will not use entire name
	CASE WHEN (RefDoctor.FirstName1 IS NOT NULL OR RefDoctor.LastName1 IS NOT NULL) THEN RefDoctor.FirstName1 ELSE RefDoctor.FirstName2 END AS FistName,
	CASE WHEN (RefDoctor.FirstName1 IS NOT NULL OR RefDoctor.LastName1 IS NOT NULL) THEN RefDoctor.MiddleName1 ELSE RefDoctor.MiddleName2 END AS MiddleName,
	CASE WHEN (RefDoctor.FirstName1 IS NOT NULL OR RefDoctor.LastName1 IS NOT NULL) THEN RefDoctor.LastName1 ELSE RefDoctor.LastName2 END AS LastName,
	CASE WHEN (RefDoctor.FirstName1 IS NOT NULL OR RefDoctor.LastName1 IS NOT NULL) THEN RefDoctor.Prefix1 ELSE RefDoctor.Prefix2 END AS Prefix,
	CASE WHEN (RefDoctor.FirstName1 IS NOT NULL OR RefDoctor.LastName1 IS NOT NULL) THEN RefDoctor.Suffix1 ELSE RefDoctor.Suffix2 END AS Suffix,
	RefDoctor.AddressLine1,
	RefDoctor.AddressLine2,
	RefDoctor.City,
	RefDoctor.State,
	RefDoctor.ZipCode,
	RefDoctor.HomePhone,
	RefDoctor.HomePhoneExt,
	RefDoctor.FaxNumber,
	@VendorImportID, 
	RefDoctor.VendorID,
	RefDoctor.[External]
FROM
(
SELECT 
	ISNULL([First Name], '') AS FirstName1, 
	ISNULL([Middle Initial], '') AS MiddleName1, 
	ISNULL([Last Name], '') AS LastName1, 
	'' AS Prefix1, 
	'' AS Suffix1, 
	CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(Name)))<>0 THEN LEFT(LTRIM(RTRIM(Name)),CHARINDEX(' ',LTRIM(RTRIM(Name)))-1) ELSE LTRIM(RTRIM(Name)) END AS FirstName2,
	CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(Name)))<>0 AND CHARINDEX(' ',LTRIM(RTRIM(Name)),CHARINDEX(' ',LTRIM(RTRIM(Name)))+1)<>0 THEN
	SUBSTRING(LTRIM(RTRIM(Name)),CHARINDEX(' ',LTRIM(RTRIM(Name)))+1,CHARINDEX(' ',LTRIM(RTRIM(Name)),CHARINDEX(' ',LTRIM(RTRIM(Name)))+1)-CHARINDEX(' ',LTRIM(RTRIM(Name)))) ELSE '' END AS MiddleName2,
	CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(Name)))<>0 AND CHARINDEX(' ',LTRIM(RTRIM(Name)),CHARINDEX(' ',LTRIM(RTRIM(Name)))+1)<>0 THEN
	RIGHT(LTRIM(RTRIM(Name)),LEN(LTRIM(RTRIM(Name)))-CHARINDEX(' ',LTRIM(RTRIM(Name)),CHARINDEX(' ',LTRIM(RTRIM(Name)))+1)) ELSE 
	RIGHT(LTRIM(RTRIM(Name)),LEN(LTRIM(RTRIM(Name)))-CHARINDEX(' ',LTRIM(RTRIM(Name)))+1) END AS LastName2,
	'' AS Prefix2,
	'' AS Suffix2,
	CASE WHEN LTRIM(RTRIM([Address 1]))='' THEN NULL ELSE LTRIM(RTRIM([Address 1])) END AS AddressLine1, 
	CASE WHEN LTRIM(RTRIM([Address 2]))='' THEN NULL ELSE LTRIM(RTRIM([Address 2])) END AS AddressLine2, 
	CASE WHEN LTRIM(RTRIM(City))='' THEN NULL ELSE LTRIM(RTRIM(City)) END AS City, 
	CASE WHEN LTRIM(RTRIM(State))='' THEN NULL ELSE LTRIM(RTRIM(State)) END AS State, 
	CASE WHEN LTRIM(RTRIM(REPLACE([Zip Code],'-','')))='' THEN NULL ELSE LTRIM(RTRIM(REPLACE([Zip Code],'-',''))) END As ZipCode,
	CASE WHEN LTRIM(RTRIM(Phone))='' THEN NULL ELSE LTRIM(RTRIM(Phone)) END AS HomePhone, 
	CASE WHEN LTRIM(RTRIM(Extension))='' THEN NULL ELSE LTRIM(RTRIM(Extension)) END AS HomePhoneExt, 
	CASE WHEN LTRIM(RTRIM(Fax))='' THEN NULL ELSE LTRIM(RTRIM(Fax)) END AS FaxNumber, 
-- VendorImportId is Above
	Code AS VendorID, 
	1 AS [External]
FROM lytec_address a INNER JOIN #ReferringProvider R
ON a.Code=R.ReferringProviderCode
WHERE
	a.VendorImportID = @VendorImportID
	AND Name IS NOT NULL AND LEN(Name) > 0
) AS RefDoctor



Select @Rows = @@RowCount
Select @Message = 'Rows Added in Doctor - Referring Doctor'
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

INSERT INTO ProviderNumber(DoctorID, ProviderNumberTypeID, ProviderNumber, AttachConditionsTypeID)
SELECT DoctorID, 25, LTRIM(RTRIM([Insurance Codes 1])), 1
FROM Doctor D INNER JOIN lytec_address a
ON D.VendorImportID=@VendorImportID AND D.VendorID=a.Code AND a.VendorImportID = @VendorImportID
WHERE LTRIM(RTRIM([Insurance Codes 1]))<>''

Select @Rows = @@RowCount
Select @Message = 'Rows Added in ProviderNumber '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

UPDATE P SET ReferringPhysicianID=DoctorID
FROM Patient P INNER JOIN #PatientReferringProvider PRP
ON P.PatientID=PRP.PatientID
INNER JOIN Doctor D
ON D.VendorImportID=@VendorImportID AND D.VendorID=PRP.ReferringProviderCode

Select @Rows = @@RowCount
Select @Message = 'Rows Updated in Patient '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

DROP TABLE #PatientFacility
DROP TABLE #PatientReferringProvider
DROP TABLE #Facilities
DROP TABLE #ReferringProvider