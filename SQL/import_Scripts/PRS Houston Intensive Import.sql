BEGIN TRAN

DECLARE @VendorImportID int
DECLARE @PracticeID int

SET @VendorImportID = 4
SET @PracticeID = 7

--=============
--  insurance
--=============

print 'start insurance block'

DECLARE @ins TABLE (VendorID varchar(50), CompanyName varchar(50), AddressLine1 varchar(50), AddressLine2 varchar(50), City varchar(50), State char(2), ZipCode varchar(9),ICID int DEFAULT NULL, ICPID int DEFAULT NULL)

INSERT INTO @ins (VendorID, CompanyName, AddressLine1, AddressLine2, City, State, ZipCode)
SELECT DISTINCT
	InsName+InsAddressLine1 AS VendorID,
	InsName AS CompanyName,
	InsAddressLine1 AS AddressLine1,
	InsAddressLine2 AS AddressLine2,
	InsCity AS City,
	InsState AS State,
	InsZipCode AS Zip
FROM
	importSF1074
WHERE
	LEN(InsName) > 0
	
--SELECT * FROM @ins

print 'import ins companies'

INSERT INTO InsuranceCompany
	(InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, VendorID, VendorImportID,
	 CreatedDate,ModifiedDate, CreatedUserId, ModifiedUserId)
	SELECT
		CompanyName, AddressLine1, AddressLine2, City, State, ZipCode, VendorID, @VendorImportID,
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
	(PlanName, AddressLine1, AddressLine2, City, State, ZipCode, InsuranceCompanyID, VendorID, VendorImportID,
	 CreatedDate,ModifiedDate, CreatedUserId, ModifiedUserId)
	SELECT
		CompanyName, AddressLine1, AddressLine2, City, State, ZipCode, ICID, VendorID, @VendorImportID, 
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

DECLARE @PatientNameExpression varchar(max)
SET @PatientNameExpression = '(?<first>[^\s]+)(?:\s+(?<middle>[^\s]+))?\s+(?<last>[^\s]+)(?:\s+(?<suffix>(?:SR|JR|III).?))|(?<first>[^\s]+)(?:\s+(?<middle>[^\s]+))?\s+(?<last>.+)'

DECLARE @pmap table (MinID int, MaxID int, Name varchar(max))

INSERT INTO @pmap
SELECT min(cast(patientid as int)), max(cast(patientid as int)),patientfullname from importSF1074 group by patientfullname --patientfullname, zipcode


DECLARE @pat TABLE (VendorID varchar(50), FirstName varchar(50), MiddleName varchar(50), LastName varchar(50), Suffix varchar(50),
					AddressLine1 varchar(50), AddressLine2, City varchar(50), State varchar(2), ZipCode varchar(9), 
					HomePhone varchar(10), WorkPhone varchar(10),
					PID int DEFAULT NULL, PCID int DEFAULT NULL)

INSERT INTO @pat (VendorID, FirstName, MiddleName, LastName, Suffix, AddressLine1, AddressLine2, City, State, ZipCode, HomePhone, WorkPhone)
SELECT 
	PatientID,
	dbo.RegexReplace(PatientFullName,@PatientNameExpression,'${first}') AS First,
	dbo.RegexReplace(PatientFullName,@PatientNameExpression,'${middle}') AS Middle,
	dbo.RegexReplace(PatientFullName,@PatientNameExpression,'${last}') AS Last,
	dbo.RegexReplace(PatientFullName,@PatientNameExpression,'${suffix}') AS Suffix,
	AddressLine1,
	AddressLine2,
	City,
	State,
	ZipCode, 
	dbo.RegexReplace(HomePhone,'[()A-Z\s-]','') AS HomePhone,
	CASE WHEN LEN(WorkPhone) > 0 THEN
		dbo.RegexReplace(HomePhone,'([0-9][0-9][0-9]).*','$1') + dbo.RegexReplace(WorkPhone,'[()A-Z\s-]','')
	ELSE
		''
	END AS WorkPhone
FROM importSF1074
where 1 = dbo.RegexMatch(PatientFullName,'.*\s.*') and cast(patientid as int) in (select maxid from @pmap) 
union
select
	PatientID,
	'','',PatientFullName,'',
	AddressLine1,
	AddressLine2,
	City,
	State,
	ZipCode, 
	dbo.RegexReplace(HomePhone,'[()A-Z\s-]','') AS HomePhone,
	CASE WHEN LEN(WorkPhone) > 0 THEN
		dbo.RegexReplace(HomePhone,'([0-9][0-9][0-9]).*','$1') + dbo.RegexReplace(WorkPhone,'[()A-Z\s-]','')
	ELSE
		''
	END AS WorkPhone
FROM
	importSF1074
WHERE 0 = dbo.RegexMatch(PatientFullName,'.*\s.*') and cast(patientid as int) in (select maxid from @pmap) 




print 'import patients'

INSERT INTO
	Patient
	(PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, AddressLine1, AddressLine2, City, State, ZipCode, Gender, MaritalStatus, HomePhone, WorkPhone,
	VendorID, VendorImportID,
	CreatedDate,ModifiedDate, CreatedUserId, ModifiedUserId)
	SELECT 
		@PracticeID, '', FirstName, MiddleName, LastName, Suffix, AddressLine1, AddressLine2, City, State, ZipCode, 'U','U', HomePhone, WorkPhone, VendorID, @VendorImportID,
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
	(PracticeID, PatientID, Name, Active, PayerScenarioID, VendorID, VendorImportID,
	 CreatedDate,ModifiedDate, CreatedUserId, ModifiedUserId)
	SELECT
		@PracticeID, PID, 'Default Case', 1, @DefaultPayerScenarioID, VendorID, @VendorImportID,
		getdate(),getdate(),0,0
	FROM
		@pat

UPDATE @pat
SET PCID = PC.PatientCaseID
FROM
	@pat P
	INNER JOIN PatientCase PC ON PC.VendorImportID = @VendorImportID AND PC.VendorID = P.VendorID

DECLARE @pi TABLE (PatientCaseID int, Precedence int, InsuranceCompanyPlanID int, PolicyNumber varchar(50), GroupNumber varchar(50))

INSERT INTO @pi
SELECT
	p.PCID, 1, 
	i.ICPID, 
	d.InsPolNum AS PolicyNumber,
	d.InsGroupNum AS GroupNumber
FROM
	importSF1074 d
	INNER JOIN @pat p ON d.patnum = p.VendorID
	INNER JOIN @ins i ON d.InsName+d.InsAddressLine1 = i.VendorID

print 'import policies'
INSERT INTO InsurancePolicy
	(PatientCaseID, Precedence, PolicyNumber, GroupNumber, InsuranceCompanyPlanID,PracticeID, VendorImportID,
	 CreatedDate,ModifiedDate, CreatedUserId, ModifiedUserId)
SELECT 
	PatientCaseID, Precedence, PolicyNumber, GroupNumber, InsuranceCompanyPlanID, @PracticeID, @VendorImportID,
	getdate(),getdate(),0,0
FROM
	@pi

--SELECT * FROM @pi

--SELECT * FROM Doctor

print 'misc updates'
UPDATE InsuranceCompany SET ReviewCode = 'R' WHERE VendorImportID = @VendorImportID
UPDATE InsuranceCompanyPlan SET ReviewCode = 'R' WHERE VendorImportID = @VendorImportID

print 'finished'
--COMMIT
--ROLLBACK
