--SELECT * FROM Cadeceus_Pediatrics WHERE ACCT=66
--SELECT * FROM Cadeceus_PediatricsIns WHERE ACCT=66

--BEGIN TRANSACTION

--Start
DECLARE @VendorImportID INT

--INSERT INTO VendorImport(VendorName, DateCreated, Notes, VendorFormat)
--VALUES('Cadeceus Pediatrics', GETDATE(), '', 'Unknown')
--
--SET @VendorImportID=@@IDENTITY

DECLARE @PracticeID INT
SET @PracticeID=114

DECLARE @Today DATETIME
SET @Today=GETDATE()

--Get Primary Care Physician 
CREATE TABLE #PCP(Loc INT, Acct INT, PT INT, DocFirstName VARCHAR(64), DocLastName VARCHAR(64), Degree VARCHAR(64))

INSERT INTO #PCP(Loc, Acct, PT, DocFirstName, DocLastName, Degree)
SELECT CAST(Loc AS INT) Loc, CAST(Acct AS INT) Acct, CAST(PT AS INT) PT, REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PCP)))<>0 THEN LEFT(LTRIM(RTRIM(PCP)), CHARINDEX(' ', LTRIM(RTRIM(PCP)))-1) ELSE '' END, ',','') DocFirstName,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PCP)))<>0 AND LEN(LTRIM(RTRIM(PCP)))>CHARINDEX(' ',LTRIM(RTRIM(PCP)))
THEN RIGHT(LTRIM(RTRIM(PCP)),LEN(LTRIM(RTRIM(PCP)))-CHARINDEX(' ',LTRIM(RTRIM(PCP)))) ELSE '' END DocLastName, '' Degree
FROM Cadeceus_Pediatrics

UPDATE PC SET DocLastName=REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(DocLastName)))<>0 THEN LEFT(LTRIM(RTRIM(DocLastName)), CHARINDEX(' ', LTRIM(RTRIM(DocLastName)))-1) ELSE '' END, ',',''),
Degree=CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(DocLastName)))<>0 AND LEN(LTRIM(RTRIM(DocLastName)))>CHARINDEX(' ',LTRIM(RTRIM(DocLastName)))
THEN RIGHT(LTRIM(RTRIM(DocLastName)),LEN(LTRIM(RTRIM(DocLastName)))-CHARINDEX(' ',LTRIM(RTRIM(DocLastName)))) ELSE '' END
FROM #PCP PC

DELETE #PCP WHERE DocLastName='' AND DocFirstName='' AND Degree=''

DECLARE @Doc TABLE(DocFirstName VARCHAR(64), DocLastName VARCHAR(64), Degree VARCHAR(64), DoctorID INT)
INSERT @Doc(DocFirstName, DocLastName, Degree)
SELECT DISTINCT DocFirstName, DocLastName, Degree FROM #PCP

IF @PracticeID=114
BEGIN
	UPDATE @Doc SET DoctorID=13710
	WHERE DocFirstName='GILBERT' AND DocLastName='GONZALES' AND Degree='MD'

	UPDATE @Doc SET DoctorID=271
	WHERE DocFirstName='GREGG' AND DocLastName='DENICOLA' AND Degree='MD'

	UPDATE @Doc SET DoctorID=270
	WHERE DocFirstName='AZZA' AND DocLastName='AYAD' AND Degree='MD'

	UPDATE @Doc SET DoctorID=13709
	WHERE DocFirstName='SHEILA' AND DocLastName='PONZIO' AND Degree='MD'
END

IF @PracticeID=113
BEGIN
	UPDATE @Doc SET DoctorID=268
	WHERE DocFirstName='GILBERT' AND DocLastName='GONZALES' AND Degree='MD'

	UPDATE @Doc SET DoctorID=258
	WHERE DocFirstName='GREGG' AND DocLastName='DENICOLA' AND Degree='MD'

	UPDATE @Doc SET DoctorID=269
	WHERE DocFirstName='AZZA' AND DocLastName='AYAD' AND Degree='MD'

	UPDATE @Doc SET DoctorID=267
	WHERE DocFirstName='SHEILA' AND DocLastName='PONZIO' AND Degree='MD'
END

--Parse Out Guarantor Name Info
CREATE TABLE #Guarantor(Acct INT, GuarantorName VARCHAR(196), GrLastName VARCHAR(64), GrFirstName VARCHAR(64), GrMiddleName VARCHAR(64))
INSERT INTO #Guarantor(Acct, GuarantorName, GrLastName, GrFirstName, GrMiddleName)
SELECT DISTINCT CAST(Acct AS INT) Acct, LTRIM(RTRIM(GuarantorName)),
REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(GUARANTORNAME)))<>0 THEN LEFT(LTRIM(RTRIM(GUARANTORNAME)), CHARINDEX(' ', LTRIM(RTRIM(GUARANTORNAME)))-1) ELSE '' END, ',','') GrLastName,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(GUARANTORNAME)))<>0 AND LEN(LTRIM(RTRIM(GUARANTORNAME)))>CHARINDEX(' ',LTRIM(RTRIM(GUARANTORNAME)))
THEN RIGHT(LTRIM(RTRIM(GUARANTORNAME)),LEN(LTRIM(RTRIM(GUARANTORNAME)))-CHARINDEX(' ',LTRIM(RTRIM(GUARANTORNAME)))) ELSE '' END GrFirstName, '' GrMiddleName
FROM Cadeceus_Pediatrics

UPDATE G SET GrFirstName=REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(GrFirstName)))<>0 THEN LEFT(LTRIM(RTRIM(GrFirstName)), CHARINDEX(' ', LTRIM(RTRIM(GrFirstName)))-1) ELSE '' END, ',',''),
GrMiddleName=CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(GrFirstName)))<>0 AND LEN(LTRIM(RTRIM(GrFirstName)))>CHARINDEX(' ',LTRIM(RTRIM(GrFirstName)))
THEN RIGHT(LTRIM(RTRIM(GrFirstName)),LEN(LTRIM(RTRIM(GrFirstName)))-CHARINDEX(' ',LTRIM(RTRIM(GrFirstName)))) ELSE '' END
FROM #Guarantor G
WHERE CHARINDEX(' ',GrFirstName)<>0

--Begin Demographics Clean up
CREATE TABLE #CleanedDemo(Loc INT, Acct INT, PT INT, PatLastName VARCHAR(64), PatFirstName VARCHAR(64), PatMiddleName VARCHAR(64), SSN CHAR(9), DOB DATETIME, Gender VARCHAR(1),
PCP INT, AddressLine1 VARCHAR(256), AddressLine2 VARCHAR(256), City VARCHAR(128), State VARCHAR(2), ZipCode VARCHAR(9), HomePhone VARCHAR(10), WorkPhone VARCHAR(10),
Notes TEXT)

INSERT INTO #CleanedDemo(Loc, Acct, PT, PatLastName, PatFirstName, PatMiddleName, SSN, DOB, Gender, AddressLine1, AddressLine2, City, State, ZipCode, HomePhone, 
WorkPhone, Notes)
SELECT CAST(Loc AS INT) Loc, CAST(Acct AS INT) Acct, CAST(PT AS INT) PT, 
REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PatientName)))<>0 THEN LEFT(LTRIM(RTRIM(PatientName)), CHARINDEX(' ', LTRIM(RTRIM(PatientName)))-1) ELSE '' END, ',','') PatLastName,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PatientName)))<>0 AND LEN(LTRIM(RTRIM(PatientName)))>CHARINDEX(' ',LTRIM(RTRIM(PatientName)))
THEN RIGHT(LTRIM(RTRIM(PatientName)),LEN(LTRIM(RTRIM(PatientName)))-CHARINDEX(' ',LTRIM(RTRIM(PatientName)))) ELSE '' END PatFirstName, '' PatMiddleName, 
LTRIM(RTRIM(SSN)) SSN, DOB, GEN Gender, Addr1 AddressLine1, Addr2 AddressLine2, City, ST, Zip,
CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(HomePhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''))>10
THEN RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(HomePhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''),10)
ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(HomePhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.','') END HomePhone,
CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(WorkPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''))>10
THEN RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(WorkPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''),10)
ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(WorkPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.','') END WorkPhone,
ISNULL('Misc Acct Info: '+CASE WHEN LTRIM(RTRIM(MiscAcctInfo))='' THEN NULL ELSE LTRIM(RTRIM(MiscAcctInfo)) END+CHAR(13)+CHAR(10),'') +
ISNULL('Misc Patient Info: '+CASE WHEN LTRIM(RTRIM(MiscPatientInfo))='' THEN NULL ELSE LTRIM(RTRIM(MiscPatientInfo)) END+CHAR(13)+CHAR(10),'') +
ISNULL('Last Visit: '+CONVERT(CHAR(10),LastVisit,101)+CHAR(13)+CHAR(10),'') +
ISNULL('Cr Status: '+CASE WHEN LTRIM(RTRIM(CrStatus))='' THEN NULL ELSE LTRIM(RTRIM(CrStatus)) END+CHAR(13)+CHAR(10),'') Notes
FROM Cadeceus_Pediatrics

UPDATE CD SET PatFirstName=REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PatFirstName)))<>0 THEN LEFT(LTRIM(RTRIM(PatFirstName)), CHARINDEX(' ', LTRIM(RTRIM(PatFirstName)))-1) ELSE '' END, ',',''),
PatMiddleName=CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PatFirstName)))<>0 AND LEN(LTRIM(RTRIM(PatFirstName)))>CHARINDEX(' ',LTRIM(RTRIM(PatFirstName)))
THEN RIGHT(LTRIM(RTRIM(PatFirstName)),LEN(LTRIM(RTRIM(PatFirstName)))-CHARINDEX(' ',LTRIM(RTRIM(PatFirstName)))) ELSE '' END
FROM #CleanedDemo CD
WHERE CHARINDEX(' ',PatFirstName)<>0 AND PatFirstName NOT IN ('BABY GIRL', 'BABY BOY')

--Associate Primary Care Physician
UPDATE #CleanedDemo SET PCP=D.DoctorID
FROM #CleanedDemo CD LEFT JOIN #PCP PC
ON CD.Loc=PC.Loc AND CD.Acct=PC.Acct AND CD.PT=PC.PT
LEFT JOIN @Doc D
ON PC.DocFirstName=D.DocFirstName AND PC.DocLastName=D.DocLastName AND PC.Degree=D.Degree

--Check for Invalid WorkPhone and HomePhone Entries, if found add this info to patient notes
UPDATE CD SET Notes=ISNULL(CAST(Notes AS VARCHAR(1000)),'')+ 
CASE WHEN HomePhone<>'' THEN ISNULL('HomePhone: '+HomePhone+CHAR(13)+CHAR(10),'') ELSE '' END,
HomePhone=NULL
FROM #CleanedDemo CD
WHERE ISNUMERIC(HomePhone)<>1

UPDATE CD SET Notes=ISNULL(CAST(Notes AS VARCHAR(1000)),'')+ 
CASE WHEN WorkPhone<>'' THEN ISNULL('WorkPhone: '+WorkPhone+CHAR(13)+CHAR(10),'') ELSE '' END,
WorkPhone=NULL
FROM #CleanedDemo CD
WHERE ISNUMERIC(WorkPhone)<>1

DELETE #CleanedDemo
WHERE PatFirstName='' AND PatLastName='' AND PatMiddleName=''

--Get Insurance Info
CREATE TABLE #Ins(PayorType INT, InsCode VARCHAR(6), InsName VARCHAR(128), Addr1 VARCHAR(128), Addr2 VARCHAR(128), CityStateZip VARCHAR(128), InsPhone VARCHAR(50))
INSERT INTO #Ins(PayorType, InsCode, InsName, Addr1, Addr2, CityStateZip, InsPhone)
SELECT DISTINCT CAST(PayorType AS INT) PayorType, LTRIM(RTRIM(InsCode)) InsCode, LTRIM(RTRIM(InsName)), LTRIM(RTRIM(Addr1)), LTRIM(RTRIM(Addr2)), LTRIM(RTRIM(CityStateZip)), 
CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(InsPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''))>10
THEN RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(InsPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''),10)
ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(InsPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.','') END InsPhone
FROM Cadeceus_PediatricsIns
WHERE InsName IS NOT NULL AND LTRIM(RTRIM(InsName))<>''

UPDATE I SET Addr2=CityStateZip, CityStateZip=Addr2
FROM #Ins I
WHERE CityStateZip LIKE '%BOX%' OR CHARINDEX(',',Addr2)<>0

CREATE TABLE #InsCleaned(PayorType INT, InsCode VARCHAR(6), InsName VARCHAR(128), Addr1 VARCHAR(128), Addr2 VARCHAR(128), City VARCHAR(128), State VARCHAR(2), Zip VARCHAR(9), 
CityStateZip VARCHAR(128), InsPhone VARCHAR(10))
INSERT INTO #InsCleaned(PayorType, InsCode, InsName, Addr1, Addr2, City, CityStateZip, InsPhone)
SELECT PayorType, InsCode, InsName, Addr1, Addr2, 
CASE WHEN LEN(LTRIM(RTRIM(CityStateZip)))<>0 AND CHARINDEX(',',CityStateZip)<>0 THEN LEFT(CityStateZip,CHARINDEX(',',CityStateZip)-1) ELSE NULL END City, 
CASE WHEN LEN(LTRIM(RTRIM(CityStateZip)))<>0 AND CHARINDEX(',',CityStateZip)<>0 
THEN REPLACE(REPLACE(LTRIM(RTRIM(RIGHT(CityStateZip,LEN(CityStateZip)-CHARINDEX(',',CityStateZip)))),',',''),'.','') ELSE NULL END CityStateZip, InsPhone
FROM #Ins

UPDATE IC SET Zip=CASE WHEN LEN(REPLACE(RIGHT(CityStateZip,5),'-',''))=5 THEN RIGHT(CityStateZip,5) ELSE REPLACE(RIGHT(CityStateZip,10),'-','') END, CityStateZip=NULL
FROM #InsCleaned IC
WHERE CASE WHEN LEN(LTRIM(RTRIM(CityStateZip)))<>0 AND CHARINDEX(' ',CityStateZip)<>0 
THEN LEN(LTRIM(RTRIM(LEFT(CityStateZip,CHARINDEX(' ',CityStateZip)-1)))) ELSE 0 END>2

UPDATE IC SET State=LEFT(LTRIM(RTRIM(LEFT(CityStateZip,3))),2), Zip=LEFT(LTRIM(RTRIM(REPLACE(RIGHT(CityStateZip,LEN(CityStateZip)-3),'-',''))),9)
FROM #InsCleaned IC
WHERE CityStateZip IS NOT NULL

SELECT *
FROM #InsCleaned

--Build Unique Patient Insurance List
--1. Get policy with most recent effective policy date
--2. If still multiple primary, get last entry as new primary

CREATE TABLE #PatIns(InsID INT IDENTITY(1,1), Acct INT, PT INT, PayorType INT, InsCode VARCHAR(6), PRIM CHAR(1), 
GroupNo VARCHAR(50), PolicyNo VARCHAR(50), Copay MONEY, EffectiveDate DATETIME, GuarantorName VARCHAR(196))
INSERT INTO #PatIns(Acct, PT, PayorType, InsCode, PRIM, GroupNo, PolicyNo, Copay, EffectiveDate)
SELECT Acct, PT, PayorType, InsCode, CASE WHEN PRIM='' OR PRIM IS NULL THEN 'P' ELSE PRIM END PRIM, GroupNo, PolicyNo, Copay, EffDateFrom
FROM Cadeceus_PediatricsIns

CREATE TABLE #RecentPatIns(Acct INT, PT INT, PRIM CHAR(1), MaxEffDate DATETIME)
INSERT INTO #RecentPatIns(Acct, PT, PRIM, MaxEffDate)
SELECT Acct, PT, PRIM, MAX(ISNULL(EffectiveDate,@Today)) MaxEffDate
FROM #PatIns
GROUP BY Acct, PT, PRIM

CREATE TABLE #FinalPatIns(Acct INT, PT INT, PRIM CHAR(1), MaxInsID INT)
INSERT INTO #FinalPatIns(Acct, PT, PRIM, MaxInsID)
SELECT PI.Acct, PI.PT, PI.PRIM, MAX(InsID) MaxInsID
FROM #PatIns PI INNER JOIN #RecentPatIns RPI
ON PI.Acct=RPI.Acct AND PI.PT=RPI.PT AND ISNULL(PI.EffectiveDate,@Today)=RPI.MaxEffDate
GROUP BY PI.Acct, PI.PT, PI.PRIM

DELETE PI
FROM #PatIns PI LEFT JOIN #FinalPatIns FPI
ON PI.InsID=FPI.MaxInsID
WHERE FPI.MaxInsID IS NULL

UPDATE PI SET GuarantorName=LTRIM(RTRIM(CI.Subscriber))
FROM #PatIns PI INNER JOIN Cadeceus_PediatricsIns CI
ON PI.Acct=CI.Acct AND PI.PT=CI.PT AND PI.PayorType=CI.PayorType AND PI.InsCode=CI.InsCode AND PI.PRIM=ISNULL(CI.PRIM,'P')

SELECT PI.*
FROM #PatIns PI LEFT JOIN #Guarantor G
ON PI.GuarantorName=G.GuarantorName
WHERE G.GuarantorName IS NULL

--INSERT INTO InsuranceCompany (InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, VendorImportID, ReviewCode, CreatedPracticeID, VendorID)
--SELECT InsName, Addr1, Addr2, City, State, Zip, InsPhone, 
--@VendorImportID, 'R', @PracticeID, CAST(PayorType AS VARCHAR)+'.'+InsCode VendorID
--FROM #InsCleaned IC
--
--INSERT INTO InsuranceCompanyPlan (PlanName, InsuranceCompanyID, AddressLine1, AddressLine2, City, State, ZipCode, Phone, VendorImportID, ReviewCode, CreatedPracticeID, VendorID)
--SELECT InsuranceCompanyName, InsuranceCompanyID, AddressLine1, AddressLine2, City, State, ZipCode, CASE WHEN ISNUMERIC(Phone)=1 THEN Phone ELSE NULL END Phone, 
--VendorImportID, ReviewCode, CreatedPracticeID, VendorID
--FROM InsuranceCompany
--WHERE VendorImportID=@VendorImportID

--Insert Patients
--INSERT INTO Patient(VendorImportID, VendorID, FirstName, LastName, MiddleName, AddressLine1, AddressLine2, City, State, ZipCode, HomePhone, WorkPhone,
--Gender, DOB, SSN, PracticeID, Prefix, Suffix, ResponsibleDifferentThanPatient, Notes, PrimaryCarePhysicianID,
--ResponsiblePrefix, ResponsibleFirstName, ResponsibleLastName, ResponsibleMiddleName, ResponsibleSuffix)
SELECT @VendorImportID, CAST(CD.Acct AS VARCHAR)+'.'+CAST(RIGHT(PT,1) AS VARCHAR) VendorID, PatFirstName, PatLastName, PatMiddleName, AddressLine1,
AddressLine2, City, State, ZipCode, HomePhone, WorkPhone, Gender, DOB, SSN, @PracticeID, '' Prefix, '' Suffix, 1, Notes, PCP,
'' ResponsiblePrefix, GrFirstName ResponsibleFirstName, GrLastName ResponsibleLastName, GrMiddleName ResponsibleMiddleName, '' ResponsibleSuffix
FROM #CleanedDemo CD LEFT JOIN #Guarantor G
ON CD.Acct=G.Acct

----Insert Patient Cases
--INSERT INTO PatientCase (PatientID,Name,PracticeID, PayerScenarioID, VendorImportID, VendorID)
--SELECT PatientID, 'Case #1', @PracticeID, 5, VendorImportID, VendorID
--FROM Patient
--WHERE VendorImportID=@VendorImportID

----Create Insurance Policies
--INSERT INTO InsurancePolicy(PracticeID, PatientCaseID, Precedence, InsuranceCompanyPlanID, 
--PatientRelationshipToInsured, VendorImportID, VendorID, HolderPrefix, HolderFirstName, 
--HolderLastName, HolderMiddleName, HolderSuffix, Copay, PolicyStartDate, GroupNumber, PolicyNumber)
--SELECT PC.PracticeID, PC.PatientCaseID, CASE WHEN PRIM='P' THEN 1 WHEN PRIM='S' THEN 2 ELSE 1 END Precedence,
--ICP.InsuranceCompanyPlanID, 'C', PC.VendorImportID, PC.VendorID, '' HolderPrefix, 
--G.GrFirstName HolderFirstName, G.GrLastName HolderLastName, G.GrMiddleName HolderMiddleName, '' HolderSuffix,
--ISNULL(PI.Copay,0) Copay, EffectiveDate PolicyStartDate, GroupNo GroupNumber, PolicyNo PolicyNumber
--FROM PatientCase PC INNER JOIN #PatIns PI
--ON PC.VendorID=CAST(PI.Acct AS VARCHAR)+'.'+CAST(PI.PT AS VARCHAR)
--INNER JOIN #Guarantor G
--ON PI.Acct=G.Acct
--INNER JOIN InsuranceCompanyPlan ICP
--ON ICP.VendorImportID=@VendorImportID AND CAST(PI.PayorType AS VARCHAR)+'.'+PI.InsCode=ICP.VendorID
--WHERE PC.VendorImportID=@VendorImportID

----Update those cases with no insurance to Self Pay
--UPDATE PC SET PayerScenarioID=11
--FROM PatientCase PC LEFT JOIN InsurancePolicy IP
--ON PC.PatientCaseID=IP.PatientCaseID
--WHERE PC.PracticeID=@PracticeID AND PC.VendorImportID=@VendorImportID AND IP.PatientCaseID IS NULL

----Perform State, City Clean up when ZipCode is available by Cross Referencing Shared USZipCodes
--UPDATE IC SET City=UZC.City, State=UZC.State
--FROM InsuranceCompany IC INNER JOIN Superbill_Shared..USZipCodes UZC
--ON LEFT(IC.ZipCode,5)=UZC.ZipCode
--WHERE IC.VendorImportID=@VendorImportID
--
--UPDATE ICP SET City=UZC.City, State=UZC.State
--FROM InsuranceCompanyPlan ICP INNER JOIN Superbill_Shared..USZipCodes UZC
--ON LEFT(ICP.ZipCode,5)=UZC.ZipCode
--WHERE ICP.VendorImportID=@VendorImportID
--
--UPDATE P SET City=UZC.City, State=UZC.State
--FROM Patient P INNER JOIN Superbill_Shared..USZipCodes UZC
--ON LEFT(P.ZipCode,5)=UZC.ZipCode
--WHERE P.VendorImportID=@VendorImportID

DROP TABLE #CleanedDemo
DROP TABLE #PCP
DROP TABLE #Guarantor
DROP TABLE #Ins
DROP TABLE #InsCleaned
DROP TABLE #PatIns
DROP TABLE #RecentPatIns
DROP TABLE #FinalPatIns

--PRINT 'Vendor Import ID# '+CAST(@VendorImportID AS VARCHAR)

--delete insurancepolicy
--where vendorimportid=@VendorImportID
--
--delete patientcase
--where vendorimportid=@VendorImportID
--
--delete insurancecompanyplan
--where vendorimportid=@VendorImportID
--
--delete insurancecompany
--where vendorimportid=@VendorImportID
--
--delete patient
--where vendorimportid=@VendorImportID

--delete vendorimport
--where vendorimportid=@VendorImportID

--COMMIT TRANSACTION