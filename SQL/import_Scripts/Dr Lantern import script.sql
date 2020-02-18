--BEGIN TRAN

--Insert Patients
INSERT INTO Patient(VendorImportID, VendorID, FirstName, LastName, MiddleName, AddressLine1, City, State, ZipCode, HomePhone, WorkPhone,
EmailAddress, Gender, DOB, PracticeID, Prefix, Suffix, MaritalStatus, ResponsibleDifferentThanPatient, Notes)
SELECT 3, [ID#] VendorID, ISNULL([First Name],'') FirstName, ISNULL([Last Name],'') LastName, ISNULL([MI],'') MiddleName, 
CASE WHEN LTRIM(RTRIM([Adress])) = '' THEN NULL ELSE LTRIM(RTRIM([Adress])) END AddressLine1, 
City, State, 
CASE WHEN LTRIM(RTRIM(REPLACE(LEFT(REPLACE([Zip],'-',''), 9),'0',''))) = '' THEN NULL ELSE CASE WHEN ISNUMERIC(LTRIM(RTRIM(LEFT(REPLACE([Zip],'-',''), 9))))=1
OR LEN(LTRIM(RTRIM(LEFT(REPLACE([Zip],'-',''), 9))))<5 
THEN LEFT(LTRIM(RTRIM(LEFT(REPLACE([Zip],'-',''), 9))),9) ELSE NULL END END ZipCode, 
CASE WHEN LEN(LTRIM(RTRIM(LEFT(REPLACE(Home,'-',''),10))))<7 THEN NULL
ELSE LTRIM(RTRIM(LEFT(REPLACE(Home,'-',''),10))) END HomePhone, 
CASE WHEN LEN(LTRIM(RTRIM(LEFT(REPLACE(Work,'-',''),10))))<7 THEN NULL
ELSE LTRIM(RTRIM(LEFT(REPLACE(Work,'-',''),10))) END WorkPhone, Email EmailAddress, '' Gender,
CASE WHEN [Date of Birth] IS NOT NULL THEN CAST([Date of Birth] AS DATETIME) ELSE NULL END DOB, 118 PracticeID,'' Prefix,'' Suffix,'U' MaritalStatus,0 ResponsibleDifferentThanPatient,
ISNULL('Fax: '+Fax+CHAR(13)+CHAR(10),'')+ISNULL('Alt Phone: '+[Alternate Phone]+CHAR(13)+CHAR(10),'')+
ISNULL('Start Date: '+[Start Date]+CHAR(13)+CHAR(10),'')+ISNULL('Diagnosis Code: '+[Diagnosis Code]+CHAR(13)+CHAR(10),'') Notes
FROM drlantern_patientlist
WHERE LEN([First Name])<>0 OR LEN([Last Name])<>0

--Insert Patient Cases
INSERT INTO PatientCase (PatientID,Name,PracticeID, PayerScenarioID, VendorImportID, VendorID)
SELECT PatientID, 'Case #1', 118, 5, 3, VendorID
FROM Patient
WHERE VendorImportID=3

--Insert Insurance Companies and Plans
CREATE TABLE #IC(Name VARCHAR(128), AddressLine1 VARCHAR(256), AddressLine2 VARCHAR(256), City VARCHAR(128), State VARCHAR(2),
ZipCode VARCHAR(9), Phone VARCHAR(10), VendorImportID INT, ReviewCode CHAR(1), CreatedPracticeID INT, Code INT IDENTITY(1,1))
INSERT INTO #IC(Name, AddressLine1, AddressLine2, City, State, ZipCode, Phone, VendorImportID, ReviewCode, CreatedPracticeID)
SELECT DISTINCT Name, AddressLine1, AddressLine2, City, State, 
CASE WHEN LTRIM(RTRIM(REPLACE(LEFT(REPLACE([Zip],'-',''), 9),'0',''))) = '' THEN NULL ELSE CASE WHEN ISNUMERIC(LTRIM(RTRIM(LEFT(REPLACE([Zip],'-',''), 9))))=1
OR LEN(LTRIM(RTRIM(LEFT(REPLACE([Zip],'-',''), 9))))<5 
THEN LEFT(LTRIM(RTRIM(LEFT(REPLACE([Zip],'-',''), 9))),9) ELSE NULL END END,
CASE WHEN LEN(LTRIM(RTRIM(LEFT(REPLACE(Phone,'-',''),10))))<7 THEN NULL
ELSE LTRIM(RTRIM(LEFT(REPLACE(Phone,'-',''),10))) END, 3, 'R', 118
FROM drlantern_payors

CREATE TABLE #PatIns(PatientCode VARCHAR(50), InsCode INT)
INSERT INTO #PatIns(PatientCode, InsCode)
SELECT p.[ID#] PatientCode, IC.Code
FROM drlantern_patientlist p INNER JOIN #IC IC
ON p.Insurance=IC.Name AND ISNULL(p.[address 1],'')=ISNULL(IC.AddressLine1,'') 
AND ISNULL(p.[address 2],'')=ISNULL(IC.AddressLine2,'')
AND ISNULL(p.City1,'')=ISNULL(IC.City,'') AND ISNULL(p.st,'')=ISNULL(IC.State,'')
AND ISNULL(CASE WHEN LTRIM(RTRIM(REPLACE(LEFT(REPLACE(zip1,'-',''), 9),'0',''))) = '' THEN NULL ELSE CASE WHEN ISNUMERIC(LTRIM(RTRIM(LEFT(REPLACE(zip1,'-',''), 9))))=1
OR LEN(LTRIM(RTRIM(LEFT(REPLACE(zip1,'-',''), 9))))<5 
THEN LEFT(LTRIM(RTRIM(LEFT(REPLACE(zip1,'-',''), 9))),9) ELSE NULL END END,'')=ISNULL(IC.ZipCode,'')

INSERT INTO InsuranceCompany 
(InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, VendorImportID, ReviewCode, CreatedPracticeID, VendorID)
SELECT Name, AddressLine1, AddressLine2, City, State, ZipCode, Phone, 
VendorImportID, ReviewCode, CreatedPracticeID, CAST(Code AS VARCHAR) VendorID
FROM #IC

INSERT INTO InsuranceCompanyPlan 
(PlanName, InsuranceCompanyID, AddressLine1, AddressLine2, City, State, ZipCode, Phone, VendorImportID, ReviewCode, CreatedPracticeID, VendorID)
SELECT InsuranceCompanyName, InsuranceCompanyID, AddressLine1, AddressLine2, City, State, ZipCode, Phone, 
VendorImportID, ReviewCode, CreatedPracticeID, VendorID
FROM InsuranceCompany
WHERE VendorImportID=3

--Create Insurance Policies
INSERT INTO InsurancePolicy(PracticeID, PatientCaseID, Precedence, InsuranceCompanyPlanID, PatientRelationshipToInsured, VendorImportID, VendorID)
SELECT PC.PracticeID, PC.PatientCaseID, 1, ICP.InsuranceCompanyPlanID, 'S', 3, PC.VendorID
FROM PatientCase PC INNER JOIN #PatIns P
ON PC.VendorID=P.PatientCode
INNER JOIN InsuranceCompanyPlan ICP
ON ICP.VendorImportID=3 AND P.InsCode=ICP.VendorID
WHERE PC.VendorImportID=3

DROP TABLE #IC
DROP TABLE #PatIns

--Update those cases with no insurance to Self Pay
UPDATE PC SET PayerScenarioID=11
FROM PatientCase PC LEFT JOIN InsurancePolicy IP
ON PC.PatientCaseID=IP.PatientCaseID
WHERE PC.PracticeID=118 AND PC.VendorImportID=3 AND IP.PatientCaseID IS NULL

--Insert Attorney Info
CREATE TABLE #Att(CompanyName VARCHAR(128), FirstName VARCHAR(64), LastName VARCHAR(64), AddressLine1 VARCHAR(256),
AddressLine2 VARCHAR(256), Notes TEXT, WorkPhone VARCHAR(10), FaxPhone VARCHAR(10), VendorImportID INT, VendorID INT IDENTITY(1,1))
INSERT INTO #Att(CompanyName, FirstName, LastName, AddressLine1, AddressLine2, Notes, WorkPhone, FaxPhone, VendorImportID)
SELECT DISTINCT ISNULL([Law Firm],ISNULL([Attorney First]+' '+[Attorney Last Name],'')), 
[Attorney First], [Attorney Last Name], [Attorney Address 1], Suite, 
ISNULL('Contact: '+Contact+CHAR(13)+CHAR(10),'')+ISNULL('Email: '+[Atty email]+CHAR(13)+CHAR(10),'') Notes, 
CASE WHEN LEN(LTRIM(RTRIM(LEFT(REPLACE([Atty Phone],'-',''),10))))<7 THEN NULL
ELSE LTRIM(RTRIM(LEFT(REPLACE([Atty Phone],'-',''),10))) END WorkPhone, 
CASE WHEN LEN(LTRIM(RTRIM(LEFT(REPLACE([Atty Fax],'-',''),10))))<7 THEN NULL
ELSE LTRIM(RTRIM(LEFT(REPLACE([Atty Fax],'-',''),10))) END FaxPhone, 
3 VendorImportID
FROM drlantern_patientlist
WHERE [Attorney First]<>'UNASSIGNED'

CREATE TABLE #PCxAtt(PatientCode VARCHAR(50), AttCode INT)
INSERT INTO #PCxAtt(PatientCode, AttCode)
SELECT p.[ID#] PatientCode, A.VendorID AttCode
FROM drlantern_patientlist p INNER JOIN #Att A
ON ISNULL(p.[Law Firm],ISNULL(p.[Attorney First]+' '+p.[Attorney Last Name],''))=A.CompanyName
AND ISNULL(p.[Attorney Address 1],'')=ISNULL(A.AddressLine1,'')
AND ISNULL(p.Suite,'')=ISNULL(A.AddressLine2,'')

INSERT INTO Attorney(CompanyName, FirstName, LastName, AddressLine1, AddressLine2, Notes, WorkPhone, FaxPhone, VendorImportID, VendorID, Prefix, Suffix, MiddleName)
SELECT CompanyName, FirstName, LastName, AddressLine1, AddressLine2, Notes, WorkPhone, FaxPhone, VendorImportID, CAST(VendorID AS VARCHAR) VendorID, '', '', ''
FROM #Att

INSERT INTO PatientCaseToAttorney(PatientCaseID, AttorneyID, Type)
SELECT PatientCaseID, AttorneyID, 'A'
FROM PatientCase PC INNER JOIN #PCxAtt pcta
ON PC.VendorImportID=3 AND PC.VendorID=pcta.PatientCode
INNER JOIN Attorney A
ON A.VendorImportID=3 AND CAST(pcta.AttCode AS VARCHAR)=A.VendorID
WHERE PC.PracticeID=118

DROP TABLE #Att
DROP TABLE #PCxAtt

--Insert Referring Physician Info
CREATE TABLE #Doc(FirstName VARCHAR(64), LastName VARCHAR(64), Degree VARCHAR(8), AddressLine1 VARCHAR(256),
City VARCHAR(128), State VARCHAR(2), ZipCode VARCHAR(9), WorkPhone VARCHAR(10), SSN VARCHAR(9), Notes TEXT,
UPIN VARCHAR(6), PracticeID INT, [External] BIT, VendorImportID INT, VendorID INT IDENTITY(1,1))
INSERT INTO #Doc(FirstName, LastName, Degree, AddressLine1, City, State, ZipCode, WorkPhone, SSN, Notes, 
UPIN, PracticeID, [External], VendorImportID)
SELECT FirstName, LastName, 
CASE WHEN LEN(LTRIM(RTRIM(REPLACE(Degree,'.',''))))=2 THEN LTRIM(RTRIM(REPLACE(Degree,'.',''))) ELSE NULL END Degree, 
AdressLine1, City, State, 
CASE WHEN LTRIM(RTRIM(REPLACE(LEFT(REPLACE([Zip],'-',''), 9),'0',''))) = '' THEN NULL ELSE CASE WHEN ISNUMERIC(LTRIM(RTRIM(LEFT(REPLACE([Zip],'-',''), 9))))=1
OR LEN(LTRIM(RTRIM(LEFT(REPLACE([Zip],'-',''), 9))))<5 
THEN LEFT(LTRIM(RTRIM(LEFT(REPLACE([Zip],'-',''), 9))),9) ELSE NULL END END ZipCode,
CASE WHEN LEN(LTRIM(RTRIM(LEFT(REPLACE(Phone,'-',''),10))))<7 THEN NULL
ELSE LTRIM(RTRIM(LEFT(REPLACE(Phone,'-',''),10))) END WorkPhone,
LEFT(REPLACE(SSN,'-',''),9) SSN,
ISNULL(Notes+CHAR(13)+CHAR(10)+CASE WHEN LEN(UPIN)>6 THEN UPIN ELSE NULL END,Notes) Notes,
CASE WHEN LEN(UPIN)=6 THEN UPIN ELSE NULL END UPIN, 118 PracticeID, 1 [External], 3 VendorImportID
FROM drlantern_referrals

INSERT INTO Doctor(FirstName, LastName, Degree, AddressLine1, City, State, ZipCode, WorkPhone, SSN, Notes, 
PracticeID, [External], VendorImportID, VendorID, Prefix, Suffix, MiddleName)
SELECT ISNULL(FirstName,'') FirstName, LastName, Degree, AddressLine1, City, State, ZipCode, WorkPhone, SSN, Notes, 
PracticeID, [External], VendorImportID, CAST(VendorID AS VARCHAR) VendorID, '','',''
FROM #Doc

INSERT INTO ProviderNumber(DoctorID, ProviderNumberTypeID, ProviderNumber, AttachConditionsTypeID)
SELECT DoctorID, 25, UPIN, 1
FROM Doctor D INNER JOIN #Doc doc
ON D.VendorImportID=doc.VendorImportID AND D.VendorID=CAST(doc.VendorID AS VARCHAR)
WHERE D.PracticeID=118 AND doc.UPIN IS NOT NULL

DROP TABLE #Doc

--COMMIT
--ROLLBACK

