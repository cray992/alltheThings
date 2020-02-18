BEGIN TRAN

DECLARE @VendorImportID int
DECLARE @PracticeID int

SET @VendorImportID = 7
SET @PracticeID = 11

DECLARE @ref TABLE (FullName varchar(50), LastName varchar(50), FirstName varchar(50), MiddleName varchar(50), UPIN varchar(50), DID int)

INSERT INTO @ref (FullName, UPIN, LastName, FirstName, MiddleName)
SELECT DISTINCT RefDoc, RefUPIN,
	CASE WHEN dbo.RegexMatch(RefDoc,'.*,.*') = 1 
		THEN dbo.RegexReplace(RefDoc,'^([^,]*),\s([^\s]+)(?:\s(.+))?$','$1') 
		ELSE dbo.RegexReplace(RefDoc,'(.*)\s(.*)','$1')
	END AS Last,
	CASE WHEN dbo.RegexMatch(RefDoc,'.*,.*') = 1 
		THEN dbo.RegexReplace(RefDoc,'^([^,]*),\s([^\s]+)(?:\s(.+))?$','$2') 
		ELSE dbo.RegexReplace(RefDoc,'(.*)\s(.*)','$2')
	END AS First,
	CASE WHEN dbo.RegexMatch(RefDoc,'.*,.*') = 1 AND dbo.RegexMatch(RefDoc,'.*\sMD$|.*\sJR\.?$') = 0
		THEN dbo.RegexReplace(RefDoc,'^([^,]*),\s([^\s]+)(?:\s(.+))?$','$3') 
		ELSE ''
	END AS Middle
FROM importSF1364
WHERE LEN(RefDoc) > 0

--SELECT * FROM Doctor

print 'import ref phys'

INSERT INTO Doctor
	(PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, [External], VendorImportID, VendorID, 
	 CreatedDate,ModifiedDate, CreatedUserId, ModifiedUserId)
SELECT
	@PracticeID, '', FirstName, MiddleName, LastName, '', 1, @VendorImportID, FullName,
	getdate(),getdate(),0,0
FROM 
	@ref

UPDATE @ref
SET	DID=D.DoctorID
FROM @ref r INNER JOIN Doctor D ON D.VendorID = r.FullName 

DECLARE @UPINPNType int
SET @UPINPNType = 25

print 'import upins'

INSERT INTO ProviderNumber
	(DoctorID, ProviderNumberTypeID, ProviderNumber, AttachConditionsTypeID)
SELECT
	DID, @UPINPNType, UPIN, 1
FROM
	@ref
WHERE
	UPIN IS NOT NULL AND LEN(UPIN) > 0

--=============
--  insurance
--=============

print 'start insurance block'

DECLARE @ins TABLE (VendorID varchar(50), CompanyName varchar(50), AddressLine1 varchar(50), City varchar(50), State char(2), ZipCode varchar(9),ICID int DEFAULT NULL, ICPID int DEFAULT NULL)

INSERT INTO @ins (VendorID, CompanyName, AddressLine1, City, State, ZipCode)
SELECT DISTINCT
	ins01_num AS VendorID,
	ins01_name AS CompanyName,
	ins01_address AS AddressLine1,
	dbo.RegexReplace(ins01_csz,'^(.*)\s(..)\s([0-9-]+)$','$1') AS City,
	dbo.RegexReplace(ins01_csz,'^(.*)\s(..)\s([0-9-]+)$','$2') AS State,
	dbo.RegexReplace(dbo.RegexReplace(ins01_csz,'^(.*)\s(..)\s([0-9-]+)$','$3'),'-','') AS Zip
FROM
	importSF1364
WHERE
	ins01_num not in (0,6950,6975,8345,8229,8204,8212)
UNION
SELECT DISTINCT
	ins02_num AS VendorID,
	ins02_name AS CompanyName,
	ins02_address AS AddressLine1,
	dbo.RegexReplace(ins02_csz,'^(.*)\s(..)\s([0-9-]+)$','$1') AS City,
	dbo.RegexReplace(ins02_csz,'^(.*)\s(..)\s([0-9-]+)$','$2') AS State,
	dbo.RegexReplace(dbo.RegexReplace(ins02_csz,'^(.*)\s(..)\s([0-9-]+)$','$3'),'-','') AS Zip
FROM
	importSF1364
WHERE
	ins02_num not in (0,6950,6975,8345,8229,8204,8212)
UNION
SELECT DISTINCT
	ins03_num AS VendorID,
	ins03_name AS CompanyName,
	ins03_address AS AddressLine1,
	dbo.RegexReplace(ins03_csz,'^(.*)\s(..)\s([0-9-]+)$','$1') AS City,
	dbo.RegexReplace(ins03_csz,'^(.*)\s(..)\s([0-9-]+)$','$2') AS State,
	dbo.RegexReplace(dbo.RegexReplace(ins03_csz,'^(.*)\s(..)\s([0-9-]+)$','$3'),'-','') AS Zip
FROM
	importSF1364
WHERE
	ins03_num not in (0,6950,6975,8345,8229,8204,8212)

--SELECT * FROM @ins

print 'import ins companies'

INSERT INTO InsuranceCompany
	(InsuranceCompanyName, AddressLine1, City, State, ZipCode, VendorID, VendorImportID,
	 CreatedDate,ModifiedDate, CreatedUserId, ModifiedUserId)
	SELECT
		CompanyName, AddressLine1, City, State, ZipCode, VendorID, @VendorImportID,
		Getdate(),getdate(),0,0
	FROM
		@ins

UPDATE 
	@ins
SET
	ICID = IC.InsuranceCompanyID
FROM
	@ins i
	INNER JOIN InsuranceCompany IC ON IC.VendorImportID = @VendorImportID AND IC.VendorID = i.VendorID

print 'import plans'
INSERT INTO
	InsuranceCompanyPlan
	(PlanName, AddressLine1, City, State, ZipCode, InsuranceCompanyID, VendorID, VendorImportID,
	 CreatedDate,ModifiedDate, CreatedUserId, ModifiedUserId)
	SELECT
		CompanyName, AddressLine1, City, State, ZipCode, ICID, VendorID, @VendorImportID, 
		Getdate(),getdate(),0,0
	FROM
		@ins

UPDATE 
	@ins
SET
	ICPID = ICP.InsuranceCompanyPlanID
FROM
	@ins i
	INNER JOIN InsuranceCompanyPlan ICP ON ICP.VendorImportID = @VendorImportID AND ICP.VendorID = i.VendorID

--SELECT * FROM @ins

--=============
--  patients
--=============

PRINT 'prepare patients'

DECLARE @pat TABLE (VendorID varchar(50), FirstName varchar(50), MiddleName varchar(50), LastName varchar(50), 
					AddressLine1 varchar(50), City varchar(50), State varchar(2), ZipCode varchar(9), HomePhone varchar(10),
					DOB datetime, SSN varchar(9), PID int DEFAULT NULL, PCID int DEFAULT NULL, RPID int default null)

INSERT INTO @pat (VendorID, FirstName, MiddleName, LastName, AddressLine1, City, State, ZipCode, HomePhone, DOB, SSN)
SELECT
	patnum as VendorID,
	dbo.RegexReplace(pat_fname,'^(.*),\s([^\s]+)(?:\s(.+))?$','$2') AS FirstName,
	dbo.RegexReplace(pat_fname,'^(.*),\s([^\s]+)(?:\s(.+))?$','$3') AS MiddleName,
	dbo.RegexReplace(pat_fname,'^(.*),\s([^\s]+)(?:\s(.+))?$','$1') AS LastName,
	address AS AddressLine1,
	dbo.RegexReplace(pat_csz,'^(.*)\s(..)\s([0-9-]+)$','$1') AS City,
	dbo.RegexReplace(pat_csz,'^(.*)\s(..)\s([0-9-]+)$','$2') AS State,
	dbo.RegexReplace(dbo.RegexReplace(pat_csz,'^(.*)\s(..)\s([0-9-]+)$','$3'),'-','') AS ZipCode,
	dbo.RegexReplace(phone,'[()A-Z\s-]','') AS HomePhone,  
	CASE WHEN DOB = '-  -' THEN NULL ELSE CAST(dob AS datetime) + 0.5 END as DOB,
	dbo.RegexReplace(ssn,'-','') AS SSN
FROM
	importSF1364
where len(dbo.RegexReplace(pat_csz,'^(.*)\s(..)\s([0-9-]+)$','$2')) < 3

DELETE FROM @pat WHERE LEN(FirstName) < 1 AND LEN(LastName) < 1


UPDATE @pat
SET RPID = r.DID
FROM
	@pat p
	INNER JOIN importSF1364 d ON d.patnum = p.VendorID
	INNER JOIN @ref r ON r.FullName = d.RefDoc


print 'import patients'

INSERT INTO
	Patient
	(PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, AddressLine1, City, State, ZipCode, Gender, MaritalStatus, HomePhone,
	DOB, SSN, ReferringPhysicianID, VendorID, VendorImportID,
	 CreatedDate,ModifiedDate, CreatedUserId, ModifiedUserId)
	SELECT 
		@PracticeID, '', FirstName, MiddleName, LastName, '', AddressLine1, City, State, ZipCode, 'U','U', HomePhone, DOB, SSN, RPID, VendorID, @VendorImportID,
		getdate(), getdate(), 0,0
	FROM
		@pat

UPDATE
	@pat
SET
	PID = Pat.PatientID
FROM
	@pat P
	INNER JOIN Patient Pat ON Pat.VendorImportID = @VendorImportID AND Pat.VendorID = P.VendorID

DECLARE @DefaultPayerScenarioID int
SET @DefaultPayerScenarioID = 5

print 'create cases'

INSERT INTO
	PatientCase
	(PracticeID, PatientID, Name, Active, PayerScenarioID, ReferringPhysicianID, VendorID, VendorImportID,
	 CreatedDate,ModifiedDate, CreatedUserId, ModifiedUserId)
	SELECT
		@PracticeID, PID, 'Default Case', 1, @DefaultPayerScenarioID, RPID, VendorID, @VendorImportID,
		getdate(),getdate(),0,0
	FROM
		@pat

UPDATE @pat
SET PCID = PC.PatientCaseID
FROM
	@pat P
	INNER JOIN PatientCase PC ON PC.VendorImportID = @VendorImportID AND PC.VendorID = P.VendorID

DECLARE @pi TABLE (PatientCaseID int, Precedence int, InsuranceCompanyPlanID int, PolicyNumber varchar(50),
					HolderLast varchar(50), HolderFirst varchar(50), HolderMiddle varchar(50))

INSERT INTO @pi
SELECT
	p.PCID, 1, 
	i.ICPID, 
	d.ins01_polnum AS PolicyNumber,
	dbo.RegexReplace(d.ins01_holder,'^(.*),\s([^\s]+)(?:\s(.+))?$','$1') AS HolderLast,
	dbo.RegexReplace(d.ins01_holder,'^(.*),\s([^\s]+)(?:\s(.+))?$','$2') AS HolderFirst,
	dbo.RegexReplace(d.ins01_holder,'^(.*),\s([^\s]+)(?:\s(.+))?$','$3') AS HolderMiddle
FROM
	importSF1364 d
	INNER JOIN @pat p ON d.patnum = p.VendorID
	INNER JOIN @ins i ON d.ins01_num = i.VendorID
UNION
SELECT
	p.PCID, 2, 
	i.ICPID, 
	d.ins02_polnum AS PolicyNumber,
	dbo.RegexReplace(d.ins02_holder,'^(.*),\s([^\s]+)(?:\s(.+))?$','$1') AS HolderLast,
	dbo.RegexReplace(d.ins02_holder,'^(.*),\s([^\s]+)(?:\s(.+))?$','$2') AS HolderFirst,
	dbo.RegexReplace(d.ins02_holder,'^(.*),\s([^\s]+)(?:\s(.+))?$','$3') AS HolderMiddle
FROM
	importSF1364 d
	INNER JOIN @pat p ON d.patnum = p.VendorID
	INNER JOIN @ins i ON d.ins02_num = i.VendorID
UNION
SELECT
	p.PCID, 3, 
	i.ICPID, 
	d.ins03_polnum AS PolicyNumber,
	dbo.RegexReplace(d.ins03_holder,'^(.*),\s([^\s]+)(?:\s(.+))?$','$1') AS HolderLast,
	dbo.RegexReplace(d.ins03_holder,'^(.*),\s([^\s]+)(?:\s(.+))?$','$2') AS HolderFirst,
	dbo.RegexReplace(d.ins03_holder,'^(.*),\s([^\s]+)(?:\s(.+))?$','$3') AS HolderMiddle
FROM
	importSF1364 d
	INNER JOIN @pat p ON d.patnum = p.VendorID
	INNER JOIN @ins i ON d.ins03_num = i.VendorID

print 'import policies'
INSERT INTO InsurancePolicy
	(PatientCaseID, Precedence, PolicyNumber, InsuranceCompanyPlanID,PracticeID,
	PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName, HolderSuffix, VendorImportID,
	 CreatedDate,ModifiedDate, CreatedUserId, ModifiedUserId)
SELECT 
	PatientCaseID, Precedence, PolicyNumber, InsuranceCompanyPlanID, @PracticeID,
	'O', '', HolderFirst, HolderMiddle, HolderLast, '', @VendorImportID,
	getdate(),getdate(),0,0
FROM
	@pi


print 'misc updates'
UPDATE Patient SET SSN = NULL WHERE SSN = '         ' AND VendorImportID = @VendorImportID
UPDATE InsuranceCompany SET ReviewCode = 'R' WHERE VendorImportID = @VendorImportID
UPDATE InsuranceCompanyPlan SET ReviewCode = 'R' WHERE VendorImportID = @VendorImportID
UPDATE InsurancePolicy SET PatientRelationshipToInsured = 'S' WHERE VendorImportID=@VendorImportID AND LEN(HolderLastname) = 0

print 'finished'
--COMMIT
--ROLLBACK
