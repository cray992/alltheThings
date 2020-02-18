ALTER TABLE Patient ADD VendorID VARCHAR(50) NULL
GO

ALTER TABLE InsuranceCompany ADD VendorID VARCHAR(50) NULL
GO

ALTER TABLE InsuranceCompanyPlan ADD VendorID VARCHAR(50) NULL
GO

-- 00=Lambrecht (PracticeID = 1)

INSERT INTO Patient(VendorID, FirstName, LastName, MiddleName, AddressLine1, City, State, ZipCode, HomePhone, WorkPhone,
SSN, Gender, DOB, PracticeID, Prefix, Suffix, MaritalStatus, ResponsibleDifferentThanPatient)
SELECT [VendorID], [FirstName], [LastName], [MiddleName], CASE WHEN LTRIM(RTRIM([Address])) = '' THEN NULL ELSE LTRIM(RTRIM([Address])) END, 
City, State, CASE WHEN LTRIM(RTRIM(REPLACE(LEFT(REPLACE([Zip],'-',''), 9),'0',''))) = '' THEN NULL ELSE LTRIM(RTRIM(LEFT(REPLACE([Zip],'-',''), 9))) END, [HomePhone], BusinessPhone,
REPLACE([SocialSecurityNo],'-',''), Gender, CASE WHEN BirthDate IS NOT NULL THEN CAST(BirthDate AS DATETIME) ELSE NULL END,1,'','','U',0
FROM [patient-list-lambrecht]
WHERE LEN([FirstName])<>0 AND LEN([LastName])<>0


-- 01=Martin (PracticeID = 2)

INSERT INTO Patient(VendorID, FirstName, LastName, MiddleName, AddressLine1, City, State, ZipCode, HomePhone, WorkPhone,
SSN, Gender, DOB, PracticeID, Prefix, Suffix, MaritalStatus, ResponsibleDifferentThanPatient)
SELECT [VendorID], [FirstName], [LastName], [MiddleName], CASE WHEN LTRIM(RTRIM([Address])) = '' THEN NULL ELSE LTRIM(RTRIM([Address])) END, 
City, State, CASE WHEN LTRIM(RTRIM(REPLACE(LEFT(REPLACE([Zip],'-',''), 9),'0',''))) = '' THEN NULL ELSE LTRIM(RTRIM(LEFT(REPLACE([Zip],'-',''), 9))) END, [HomePhone], BusinessPhone,
REPLACE([SocialSecurityNo],'-',''), Gender, CASE WHEN BirthDate IS NOT NULL THEN CAST(BirthDate AS DATETIME) ELSE NULL END,2,'','','U',0
FROM [patient-list-martin]
WHERE LEN([FirstName])<>0 AND LEN([LastName])<>0




INSERT INTO dbo.InsuranceCompany 
(InsuranceCompanyName, AddressLine1, City, State, ZipCode, Phone, Fax, VendorID, ReviewCode)	-- added ReviewCode = 'R'
SELECT [PlanName], [Address], [City], [State], CASE WHEN LTRIM(RTRIM(REPLACE(LEFT(REPLACE([Zip],'-',''), 9),'0',''))) = '' THEN NULL ELSE LTRIM(RTRIM(LEFT(REPLACE([Zip],'-',''), 9))) END, 
[Phone], [Fax], [VendorID], 'R' 
FROM [insurance-carrier-list]

INSERT INTO dbo.InsuranceCompanyPlan
(PlanName, InsuranceCompanyID,  AddressLine1, City, State, ZipCode, 
Phone, Fax, VendorID, ReviewCode)
SELECT InsuranceCompanyName, InsuranceCompanyID,  AddressLine1, 
City, State, ZipCode, Phone, Fax, VendorID, 'R'
FROM InsuranceCompany
WHERE VendorID IS NOT NULL

DECLARE @Loop INT 
DECLARE @Count INT
DECLARE @PatientID INT
DECLARE @PatientVendorID VARCHAR(50)
DECLARE @NewPatientCaseID INT

DECLARE @InsVendorID1 VARCHAR(50)
DECLARE @Ins1Policy VARCHAR(32)
DECLARE @Ins1CompanyPlanID INT

DECLARE @InsVendorID2 VARCHAR(50)
DECLARE @Ins2Policy VARCHAR(32)
DECLARE @Ins2CompanyPlanID INT


-- *************************************
-- Lambrecht: PracticeID = 1
-- mm: added PracticeID to distinguish patients for each of two practices
CREATE TABLE #P(PID INT IDENTITY(1,1), PatientID INT, VendorID VARCHAR(50), PracticeID INT)   

INSERT INTO #P(PatientID, VendorID, PracticeID)		-- insert patients for PracticeID = 1
SELECT PatientID, VendorID, PracticeID
FROM Patient
WHERE VendorID IS NOT NULL
AND PracticeID = 1

-- select * from #P

SET @Loop=@@ROWCOUNT
SET @Count=0

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	SELECT @PatientID=PatientID, @PatientVendorID=VendorID
	FROM #P
	WHERE PID=@Count

	INSERT INTO PatientCase (PatientID,Name,PracticeID, PayerScenarioID)
	VALUES(@PatientID, 'Case #1',1,5)						-- PracticeID = 1		---- changed Case_121 to Case #1 

	SET @NewPatientCaseID=@@IDENTITY

	SELECT @InsVendorID1=LTRIM(RTRIM([InsuranceCode])), 
	       @Ins1Policy=[InsuranceID],
	       @InsVendorID2=LTRIM(RTRIM([SecondaryInsuranceCode])), 
	       @Ins2Policy=[SecondaryID]
	FROM [patient-list-lambrecht]
	WHERE [VendorID]=@PatientVendorID

	IF @InsVendorID1<>''
	BEGIN
		SELECT @Ins1CompanyPlanID=InsuranceCompanyPlanID
		FROM InsuranceCompanyPlan
		WHERE VendorID=@InsVendorID1

		INSERT INTO InsurancePolicy(PatientCaseID, InsuranceCompanyPlanID, 
		PolicyNumber, PracticeID, PatientRelationshipToInsured, Precedence)
		VALUES(@NewPatientCaseID, @Ins1CompanyPlanID, @Ins1Policy, 1, 'S', 1)
	END

	IF @InsVendorID2<>''
	BEGIN
		SELECT @Ins2CompanyPlanID=InsuranceCompanyPlanID
		FROM InsuranceCompanyPlan
		WHERE VendorID=@InsVendorID2

		INSERT INTO InsurancePolicy(PatientCaseID, InsuranceCompanyPlanID, 
		PolicyNumber, PracticeID, PatientRelationshipToInsured, Precedence)
		VALUES(@NewPatientCaseID, @Ins2CompanyPlanID, @Ins2Policy, 1, 'S', 2)
	END

	IF @InsVendorID1 = '' And @InsVendorID2 = ''
	BEGIN
		UPDATE PatientCase SET PayerScenarioID = 11 WHERE PatientCaseID = @NewPatientCaseID
	END

END

DROP TABLE #P
GO

DECLARE @Loop INT 
DECLARE @Count INT
DECLARE @PatientID INT
DECLARE @PatientVendorID VARCHAR(50)
DECLARE @NewPatientCaseID INT

DECLARE @InsVendorID1 VARCHAR(50)
DECLARE @Ins1Policy VARCHAR(32)
DECLARE @Ins1CompanyPlanID INT

DECLARE @InsVendorID2 VARCHAR(50)
DECLARE @Ins2Policy VARCHAR(32)
DECLARE @Ins2CompanyPlanID INT

-- ********************************
-- Martin: PracticeID = 2

CREATE TABLE #P(PID INT IDENTITY(1,1), PatientID INT, VendorID VARCHAR(50), PracticeID INT)   

INSERT INTO #P(PatientID, VendorID, PracticeID)		-- insert patients for PracticeID = 2
SELECT PatientID, VendorID, PracticeID
FROM Patient
WHERE VendorID IS NOT NULL
AND PracticeID = 2

-- select * from #P

SET @Loop=@@ROWCOUNT
SET @Count=0

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	SELECT @PatientID=PatientID, @PatientVendorID=VendorID
	FROM #P
	WHERE PID=@Count

	INSERT INTO PatientCase (PatientID,Name,PracticeID, PayerScenarioID)
	VALUES(@PatientID, 'Case #1',2,5)						-- PracticeID = 2	-- changed Case_121 to Case #1 
	SET @NewPatientCaseID=@@IDENTITY

	SELECT @InsVendorID1=LTRIM(RTRIM([InsuranceCode])), 
	       @Ins1Policy=[InsuranceID],
	       @InsVendorID2=LTRIM(RTRIM([SecondaryInsuranceCode])), 
	       @Ins2Policy=[SecondaryID]
	FROM [patient-list-martin]
	WHERE [VendorID]=@PatientVendorID

	IF @InsVendorID1<>''
	BEGIN
		SELECT @Ins1CompanyPlanID=InsuranceCompanyPlanID
		FROM InsuranceCompanyPlan
		WHERE VendorID=@InsVendorID1

		INSERT INTO InsurancePolicy(PatientCaseID, InsuranceCompanyPlanID, 
		PolicyNumber, PracticeID, PatientRelationshipToInsured)
		VALUES(@NewPatientCaseID, @Ins1CompanyPlanID, @Ins1Policy, 2, 'S')
	END

	IF @InsVendorID2<>''
	BEGIN
		SELECT @Ins2CompanyPlanID=InsuranceCompanyPlanID
		FROM InsuranceCompanyPlan
		WHERE VendorID=@InsVendorID2

		INSERT INTO InsurancePolicy(PatientCaseID, InsuranceCompanyPlanID, 
		PolicyNumber, PracticeID, PatientRelationshipToInsured)
		VALUES(@NewPatientCaseID, @Ins2CompanyPlanID, @Ins2Policy, 2, 'S')
	END

	IF @InsVendorID1 = '' And @InsVendorID2 = ''
	BEGIN
		UPDATE PatientCase SET PayerScenarioID = 11 WHERE PatientCaseID = @NewPatientCaseID
	END

END

DROP TABLE #P

-- Delete 'DO NOT USE'
DELETE DiagnosisCodeDictionary where DiagnosisName like 'DO NOT USE%'


--DELETE ProcedureCodeDictionary where ProcedureName like 'DO NOT USE%'