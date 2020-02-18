--BEGIN TRAN

DECLARE @PedsPracticeID INT
DECLARE @FamPracticeID INT
DECLARE @SpecPracticeID INT
DECLARE @YLPracticeID INT
SET @PedsPracticeID=113
SET @FamPracticeID=113
SET @SpecPracticeID=113
SET @YLPracticeID=115

DECLARE @VendorImportID INT

INSERT INTO VendorImport(VendorName, DateCreated, Notes, VendorFormat)
VALUES('Caduceus',GETDATE(),'new dev import','Unknown')

SET @VendorImportID=@@IDENTITY

--Get Primary Care Physician Peds
CREATE TABLE #PCP(Loc INT, Acct INT, PT INT, DocFirstName VARCHAR(64), DocLastName VARCHAR(64), Degree VARCHAR(64))

INSERT INTO #PCP(Loc, Acct, PT, DocFirstName, DocLastName, Degree)
SELECT CAST(Loc AS INT) Loc, CAST(Acct AS INT) Acct, CAST(PT AS INT) PT, REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PCP)))<>0 THEN LEFT(LTRIM(RTRIM(PCP)), CHARINDEX(' ', LTRIM(RTRIM(PCP)))-1) ELSE '' END, ',','') DocFirstName,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PCP)))<>0 AND LEN(LTRIM(RTRIM(PCP)))>CHARINDEX(' ',LTRIM(RTRIM(PCP)))
THEN RIGHT(LTRIM(RTRIM(PCP)),LEN(LTRIM(RTRIM(PCP)))-CHARINDEX(' ',LTRIM(RTRIM(PCP)))) ELSE '' END DocLastName, '' Degree
FROM Caduceus_CombinedCleanDemo

UPDATE PC SET DocLastName=REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(DocLastName)))<>0 THEN LEFT(LTRIM(RTRIM(DocLastName)), CHARINDEX(' ', LTRIM(RTRIM(DocLastName)))-1) ELSE '' END, ',',''),
Degree=CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(DocLastName)))<>0 AND LEN(LTRIM(RTRIM(DocLastName)))>CHARINDEX(' ',LTRIM(RTRIM(DocLastName)))
THEN RIGHT(LTRIM(RTRIM(DocLastName)),LEN(LTRIM(RTRIM(DocLastName)))-CHARINDEX(' ',LTRIM(RTRIM(DocLastName)))) ELSE '' END
FROM #PCP PC

DELETE #PCP WHERE DocLastName='' AND DocFirstName='' AND Degree=''

CREATE TABLE #Doc(DocFirstName VARCHAR(64), DocLastName VARCHAR(64), Degree VARCHAR(64), DoctorID INT)
INSERT INTO #Doc(DocFirstName, DocLastName, Degree)
SELECT DISTINCT DocFirstName, DocLastName, Degree FROM #PCP

UPDATE #Doc SET DoctorID=268
WHERE DocFirstName='GILBERT' AND DocLastName='GONZALES' AND Degree='MD'

UPDATE #Doc SET DoctorID=265
WHERE DocFirstName='GREGG' AND DocLastName='DENICOLA' AND Degree='MD'

UPDATE #Doc SET DoctorID=269
WHERE DocFirstName='AZZA' AND DocLastName='AYAD' AND Degree='MD'

UPDATE #Doc SET DoctorID=267
WHERE DocFirstName='SHEILA' AND DocLastName='PONZIO' AND Degree='MD'

UPDATE #Doc SET DoctorID=265
WHERE DocFirstName='GREGG' AND DocLastName='DENICOLA' AND Degree='MD'

UPDATE #Doc SET DoctorID=259
WHERE DocFirstName='AMBICA' AND DocLastName='BALI' AND Degree='MD'

UPDATE #Doc SET DoctorID=259
WHERE DocFirstName='AMBIKA' AND DocLastName='BALI' AND Degree='MD'

UPDATE #Doc SET DoctorID=261
WHERE DocFirstName='BRIAN' AND DocLastName='CONSTANTINE' AND Degree='DPM'

UPDATE #Doc SET DoctorID=14027
WHERE DocFirstName='BRIAN' AND DocLastName='NAROUZI' AND Degree='MD'

UPDATE #Doc SET DoctorID=14027
WHERE DocFirstName='BRIAN' AND DocLastName='NOROUZI' AND Degree='MD'

UPDATE #Doc SET DoctorID=262
WHERE DocFirstName='CECIL' AND DocLastName='FOLMAR' AND Degree='MD'

UPDATE #Doc SET DoctorID=263
WHERE DocFirstName='CHOI' AND DocLastName='JUNGHWAN' AND Degree='MD'

UPDATE #Doc SET DoctorID=14020
WHERE DocFirstName='ED' AND DocLastName='' AND Degree=''

UPDATE #Doc SET DoctorID=14019
WHERE DocFirstName='ELLEN' AND DocLastName='T.' AND Degree='TROJNAR, MFCC'

UPDATE #Doc SET DoctorID=14022
WHERE DocFirstName='KATHY' AND DocLastName='DIESTO' AND Degree='R.D.'

UPDATE #Doc SET DoctorID=264
WHERE DocFirstName='MIKEL' AND DocLastName='WHITING' AND Degree='MD'

UPDATE #Doc SET DoctorID=260
WHERE DocFirstName='PARVINDAR' AND DocLastName='WADHWA' AND Degree='MD'

UPDATE #Doc SET DoctorID=266
WHERE DocFirstName='ROBERT' AND DocLastName='BORROWDALE' AND Degree='MD'

--Get Primary Care Physician Specialists
CREATE TABLE #YLPCP(Loc INT, Acct INT, PT INT, DocFirstName VARCHAR(64), DocLastName VARCHAR(64), Degree VARCHAR(64))

INSERT INTO #YLPCP(Loc, Acct, PT, DocFirstName, DocLastName, Degree)
SELECT CAST(Loc AS INT) Loc, CAST(Acct AS INT) Acct, CAST(PT AS INT) PT, REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PCP)))<>0 THEN LEFT(LTRIM(RTRIM(PCP)), CHARINDEX(' ', LTRIM(RTRIM(PCP)))-1) ELSE '' END, ',','') DocFirstName,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PCP)))<>0 AND LEN(LTRIM(RTRIM(PCP)))>CHARINDEX(' ',LTRIM(RTRIM(PCP)))
THEN RIGHT(LTRIM(RTRIM(PCP)),LEN(LTRIM(RTRIM(PCP)))-CHARINDEX(' ',LTRIM(RTRIM(PCP)))) ELSE '' END DocLastName, '' Degree
FROM YLFCombinedCleanDemo

UPDATE PC SET DocLastName=REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(DocLastName)))<>0 THEN LEFT(LTRIM(RTRIM(DocLastName)), CHARINDEX(' ', LTRIM(RTRIM(DocLastName)))-1) ELSE '' END, ',',''),
Degree=CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(DocLastName)))<>0 AND LEN(LTRIM(RTRIM(DocLastName)))>CHARINDEX(' ',LTRIM(RTRIM(DocLastName)))
THEN RIGHT(LTRIM(RTRIM(DocLastName)),LEN(LTRIM(RTRIM(DocLastName)))-CHARINDEX(' ',LTRIM(RTRIM(DocLastName)))) ELSE '' END
FROM #YLPCP PC

DELETE #YLPCP WHERE DocLastName='' AND DocFirstName='' AND Degree=''

CREATE TABLE #YLDoc(DocFirstName VARCHAR(64), DocLastName VARCHAR(64), Degree VARCHAR(64), DoctorID INT)
INSERT INTO #YLDoc(DocFirstName, DocLastName, Degree)
SELECT DISTINCT DocFirstName, DocLastName, Degree FROM #YLPCP

IF @YLPracticeID=115
BEGIN
	UPDATE #YLDoc SET DoctorID=255
	WHERE DocFirstName='PAUL' AND DocLastName='JORDAN' AND Degree='M.D.'

	UPDATE #YLDoc SET DoctorID=254
	WHERE DocFirstName='DANIEL' AND DocLastName='MAY' AND Degree='M.D.'

	UPDATE #YLDoc SET DoctorID=253
	WHERE DocFirstName='THOMAS' AND DocLastName='BARKER' AND Degree='MD'

	UPDATE #YLDoc SET DoctorID=257
	WHERE DocFirstName='DENNIS' AND DocLastName='PONZIO' AND Degree='M.D.'

	UPDATE #YLDoc SET DoctorID=253
	WHERE DocFirstName='THOMAS' AND DocLastName='BARKER' AND Degree='M.D.'

	UPDATE #YLDoc SET DoctorID=256
	WHERE DocFirstName='MICHAEL' AND DocLastName='HALL' AND Degree='M.D.'
END

--Guarantor Info
CREATE TABLE #Guarantor(Loc INT, Acct INT, PT INT, GuarantorName VARCHAR(196), GrLastName VARCHAR(64), GrFirstName VARCHAR(64), GrMiddleName VARCHAR(64))
INSERT INTO #Guarantor(Loc, Acct, PT, GuarantorName, GrLastName, GrFirstName, GrMiddleName)
SELECT DISTINCT Loc, CAST(Acct AS INT) Acct, PT, LTRIM(RTRIM(GuarantorName)),
REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(GUARANTORNAME)))<>0 THEN LEFT(LTRIM(RTRIM(GUARANTORNAME)), CHARINDEX(' ', LTRIM(RTRIM(GUARANTORNAME)))-1) ELSE '' END, ',','') GrLastName,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(GUARANTORNAME)))<>0 AND LEN(LTRIM(RTRIM(GUARANTORNAME)))>CHARINDEX(' ',LTRIM(RTRIM(GUARANTORNAME)))
THEN RIGHT(LTRIM(RTRIM(GUARANTORNAME)),LEN(LTRIM(RTRIM(GUARANTORNAME)))-CHARINDEX(' ',LTRIM(RTRIM(GUARANTORNAME)))) ELSE '' END GrFirstName, '' GrMiddleName
FROM Caduceus_CombinedCleanDemo
WHERE LTRIM(RTRIM(GUARANTORNAME))<>''
UNION
SELECT DISTINCT Loc, CAST(Acct AS INT) Acct, PT, LTRIM(RTRIM(GuarantorName)),
REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(GUARANTORNAME)))<>0 THEN LEFT(LTRIM(RTRIM(GUARANTORNAME)), CHARINDEX(' ', LTRIM(RTRIM(GUARANTORNAME)))-1) ELSE '' END, ',','') GrLastName,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(GUARANTORNAME)))<>0 AND LEN(LTRIM(RTRIM(GUARANTORNAME)))>CHARINDEX(' ',LTRIM(RTRIM(GUARANTORNAME)))
THEN RIGHT(LTRIM(RTRIM(GUARANTORNAME)),LEN(LTRIM(RTRIM(GUARANTORNAME)))-CHARINDEX(' ',LTRIM(RTRIM(GUARANTORNAME)))) ELSE '' END GrFirstName, '' GrMiddleName
FROM YLFCombinedCleanDemo
WHERE LTRIM(RTRIM(GUARANTORNAME))<>''

UPDATE G SET GrFirstName=REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(GrFirstName)))<>0 THEN LEFT(LTRIM(RTRIM(GrFirstName)), CHARINDEX(' ', LTRIM(RTRIM(GrFirstName)))-1) ELSE '' END, ',',''),
GrMiddleName=CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(GrFirstName)))<>0 AND LEN(LTRIM(RTRIM(GrFirstName)))>CHARINDEX(' ',LTRIM(RTRIM(GrFirstName)))
THEN RIGHT(LTRIM(RTRIM(GrFirstName)),LEN(LTRIM(RTRIM(GrFirstName)))-CHARINDEX(' ',LTRIM(RTRIM(GrFirstName)))) ELSE '' END
FROM #Guarantor G
WHERE CHARINDEX(' ',GrFirstName)<>0

--Parse Out Subscriber Name Info
CREATE TABLE #Subscriber(Loc INT, Acct INT, PT INT, SubscriberName VARCHAR(196), SLastName VARCHAR(64), SFirstName VARCHAR(64), SMiddleName VARCHAR(64), SDOB DATETIME, Gender CHAR(1), RelToSub CHAR(1))
INSERT INTO #Subscriber(Loc, Acct, PT, SubscriberName, SLastName, SFirstName, SMiddleName, SDOB, Gender, RelToSub)
SELECT DISTINCT Loc, CAST(Acct AS INT) Acct, PT, LTRIM(RTRIM(SUBSCRIBER)),
REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(SUBSCRIBER)))<>0 THEN LEFT(LTRIM(RTRIM(SUBSCRIBER)), CHARINDEX(' ', LTRIM(RTRIM(SUBSCRIBER)))-1) ELSE '' END, ',','') GrLastName,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(SUBSCRIBER)))<>0 AND LEN(LTRIM(RTRIM(SUBSCRIBER)))>CHARINDEX(' ',LTRIM(RTRIM(SUBSCRIBER)))
THEN RIGHT(LTRIM(RTRIM(SUBSCRIBER)),LEN(LTRIM(RTRIM(SUBSCRIBER)))-CHARINDEX(' ',LTRIM(RTRIM(SUBSCRIBER)))) ELSE '' END GrFirstName, '' GrMiddleName,
SDOB, SEX, RELTOSUB
FROM Caduceus_CombinedCleanIns
WHERE LTRIM(RTRIM(Subscriber))<>''
UNION
SELECT DISTINCT Loc, CAST(Acct AS INT) Acct, PT, LTRIM(RTRIM(SUBSCRIBER)),
REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(SUBSCRIBER)))<>0 THEN LEFT(LTRIM(RTRIM(SUBSCRIBER)), CHARINDEX(' ', LTRIM(RTRIM(SUBSCRIBER)))-1) ELSE '' END, ',','') GrLastName,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(SUBSCRIBER)))<>0 AND LEN(LTRIM(RTRIM(SUBSCRIBER)))>CHARINDEX(' ',LTRIM(RTRIM(SUBSCRIBER)))
THEN RIGHT(LTRIM(RTRIM(SUBSCRIBER)),LEN(LTRIM(RTRIM(SUBSCRIBER)))-CHARINDEX(' ',LTRIM(RTRIM(SUBSCRIBER)))) ELSE '' END GrFirstName, '' GrMiddleName,
SDOB, SEX, RELTOSUB
FROM YLFCombinedCleanIns
WHERE LTRIM(RTRIM(Subscriber))<>''

UPDATE S SET SFirstName=REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(SFirstName)))<>0 THEN LEFT(LTRIM(RTRIM(SFirstName)), CHARINDEX(' ', LTRIM(RTRIM(SFirstName)))-1) ELSE '' END, ',',''),
SMiddleName=CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(SFirstName)))<>0 AND LEN(LTRIM(RTRIM(SFirstName)))>CHARINDEX(' ',LTRIM(RTRIM(SFirstName)))
THEN RIGHT(LTRIM(RTRIM(SFirstName)),LEN(LTRIM(RTRIM(SFirstName)))-CHARINDEX(' ',LTRIM(RTRIM(SFirstName)))) ELSE '' END
FROM #Subscriber S
WHERE CHARINDEX(' ',SFirstName)<>0

--Begin Demographics Clean up
CREATE TABLE #Demo(Loc INT, Acct INT, PT INT, GuarantorName VARCHAR(196), PatLastName VARCHAR(64), PatFirstName VARCHAR(64), PatMiddleName VARCHAR(64), SSN CHAR(9), DOB DATETIME, Gender VARCHAR(1),
PCP INT, AddressLine1 VARCHAR(256), AddressLine2 VARCHAR(256), City VARCHAR(128), State VARCHAR(2), ZipCode VARCHAR(9), HomePhone VARCHAR(10), WorkPhone VARCHAR(10),
Notes TEXT, DefaultLoc INT, AccountStatusNote VARCHAR(500))

INSERT INTO #Demo(Loc, Acct, PT, GuarantorName, PatLastName, PatFirstName, PatMiddleName, SSN, DOB, Gender, AddressLine1, AddressLine2, City, State, ZipCode, HomePhone, 
WorkPhone, Notes, AccountStatusNote)
SELECT CAST(Loc AS INT) Loc, CAST(Acct AS INT) Acct, CAST(PT AS INT) PT, GuarantorName, 
REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PatientName)))<>0 THEN LEFT(LTRIM(RTRIM(PatientName)), CHARINDEX(' ', LTRIM(RTRIM(PatientName)))-1) ELSE '' END, ',','') PatLastName,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PatientName)))<>0 AND LEN(LTRIM(RTRIM(PatientName)))>CHARINDEX(' ',LTRIM(RTRIM(PatientName)))
THEN RIGHT(LTRIM(RTRIM(PatientName)),LEN(LTRIM(RTRIM(PatientName)))-CHARINDEX(' ',LTRIM(RTRIM(PatientName)))) ELSE '' END PatFirstName, '' PatMiddleName, 
LTRIM(RTRIM(SSN)) SSN, DOB, GEN Gender, Addr1 AddressLine1, Addr2 AddressLine2, City, ST, LEFT(RTRIM(LTRIM(REPLACE(Zip,'-',''))),9),
CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(HomePhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''))>10
THEN RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(HomePhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''),10)
ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(HomePhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.','') END HomePhone,
CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(WorkPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''))>10
THEN RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(WorkPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''),10)
ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(WorkPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.','') END WorkPhone,
ISNULL('Misc Acct Info: '+CASE WHEN LTRIM(RTRIM(MiscAcctInfo))='' THEN NULL ELSE LTRIM(RTRIM(MiscAcctInfo)) END+CHAR(13)+CHAR(10),'') +
ISNULL('Misc Patient Info: '+CASE WHEN LTRIM(RTRIM(MiscPatientInfo))='' THEN NULL ELSE LTRIM(RTRIM(MiscPatientInfo)) END+CHAR(13)+CHAR(10),'') +
ISNULL('Last Visit: '+CONVERT(CHAR(10),LastVisit,110)+CHAR(13)+CHAR(10),'') +
ISNULL('Cr Status: '+CASE WHEN LTRIM(RTRIM(CrStatus))='' THEN NULL ELSE LTRIM(RTRIM(CrStatus)) END+CHAR(13)+CHAR(10),'') Notes,
CASE WHEN LTRIM(RTRIM(MiscAcctInfo))='' THEN NULL ELSE LTRIM(RTRIM(MiscAcctInfo)) END AccountStatusNote
FROM Caduceus_CombinedCleanDemo
WHERE RLoc=0 AND RAcct=0 AND RPt=0

CREATE TABLE #YLDemo(Cs INT, Loc INT, Acct INT, PT INT, GuarantorName VARCHAR(196), PatLastName VARCHAR(64), PatFirstName VARCHAR(64), PatMiddleName VARCHAR(64), SSN CHAR(9), DOB DATETIME, Gender VARCHAR(1),
PCP INT, AddressLine1 VARCHAR(256), AddressLine2 VARCHAR(256), City VARCHAR(128), State VARCHAR(2), ZipCode VARCHAR(9), HomePhone VARCHAR(10), WorkPhone VARCHAR(10),
Notes TEXT, DefaultLoc INT, AccountStatusNote VARCHAR(500))

INSERT INTO #YLDemo(Cs, Loc, Acct, PT, GuarantorName, PatLastName, PatFirstName, PatMiddleName, SSN, DOB, Gender, AddressLine1, AddressLine2, City, State, ZipCode, HomePhone, 
WorkPhone, Notes, AccountStatusNote)
SELECT CAST(Cs AS INT) Cs, CAST(Loc AS INT) Loc, CAST(Acct AS INT) Acct, CAST(PT AS INT) PT, GuarantorName, 
REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PatientName)))<>0 THEN LEFT(LTRIM(RTRIM(PatientName)), CHARINDEX(' ', LTRIM(RTRIM(PatientName)))-1) ELSE '' END, ',','') PatLastName,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PatientName)))<>0 AND LEN(LTRIM(RTRIM(PatientName)))>CHARINDEX(' ',LTRIM(RTRIM(PatientName)))
THEN RIGHT(LTRIM(RTRIM(PatientName)),LEN(LTRIM(RTRIM(PatientName)))-CHARINDEX(' ',LTRIM(RTRIM(PatientName)))) ELSE '' END PatFirstName, '' PatMiddleName, 
LEFT(LTRIM(RTRIM(SSN)),9) SSN, DOB, LEFT(GEN,1) Gender, Addr1 AddressLine1, Addr2 AddressLine2, City, LEFT(RTRIM(LTRIM(ST)),2), LEFT(RTRIM(LTRIM(REPLACE(Zip,'-',''))),9),
CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(HomePhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''))>10
THEN RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(HomePhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''),10)
ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(HomePhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.','') END HomePhone,
CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(WorkPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''))>10
THEN RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(WorkPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''),10)
ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(WorkPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.','') END WorkPhone,
ISNULL('Misc Acct Info: '+CASE WHEN LTRIM(RTRIM(MiscAcctInfo))='' THEN NULL ELSE LTRIM(RTRIM(MiscAcctInfo)) END+CHAR(13)+CHAR(10),'') +
ISNULL('Misc Patient Info: '+CASE WHEN LTRIM(RTRIM(MiscPatientInfo))='' THEN NULL ELSE LTRIM(RTRIM(MiscPatientInfo)) END+CHAR(13)+CHAR(10),'') +
ISNULL('Last Visit: '+CONVERT(CHAR(10),LastVisit,110)+CHAR(13)+CHAR(10),'') +
ISNULL('Cr Status: '+CASE WHEN LTRIM(RTRIM(CrStatus))='' THEN NULL ELSE LTRIM(RTRIM(CrStatus)) END+CHAR(13)+CHAR(10),'') Notes,
CASE WHEN LTRIM(RTRIM(MiscAcctInfo))='' THEN NULL ELSE LTRIM(RTRIM(MiscAcctInfo)) END AccountStatusNote
FROM YLFCombinedCleanDemo

DELETE #Demo WHERE PatFirstName IN ('Baby Girl','Baby Boy') OR PatFirstName LIKE '%Baby%'

UPDATE CD SET PatFirstName=REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PatFirstName)))<>0 THEN LEFT(LTRIM(RTRIM(PatFirstName)), CHARINDEX(' ', LTRIM(RTRIM(PatFirstName)))-1) ELSE '' END, ',',''),
PatMiddleName=CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PatFirstName)))<>0 AND LEN(LTRIM(RTRIM(PatFirstName)))>CHARINDEX(' ',LTRIM(RTRIM(PatFirstName)))
THEN RIGHT(LTRIM(RTRIM(PatFirstName)),LEN(LTRIM(RTRIM(PatFirstName)))-CHARINDEX(' ',LTRIM(RTRIM(PatFirstName)))) ELSE '' END
FROM #Demo CD
WHERE CHARINDEX(' ',PatFirstName)<>0 AND PatFirstName NOT IN ('BABY GIRL', 'BABY BOY')

UPDATE CD SET PatFirstName=REPLACE(CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PatFirstName)))<>0 THEN LEFT(LTRIM(RTRIM(PatFirstName)), CHARINDEX(' ', LTRIM(RTRIM(PatFirstName)))-1) ELSE '' END, ',',''),
PatMiddleName=CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(PatFirstName)))<>0 AND LEN(LTRIM(RTRIM(PatFirstName)))>CHARINDEX(' ',LTRIM(RTRIM(PatFirstName)))
THEN RIGHT(LTRIM(RTRIM(PatFirstName)),LEN(LTRIM(RTRIM(PatFirstName)))-CHARINDEX(' ',LTRIM(RTRIM(PatFirstName)))) ELSE '' END
FROM #YLDemo CD
WHERE CHARINDEX(' ',PatFirstName)<>0 AND PatFirstName NOT IN ('BABY GIRL', 'BABY BOY')

--Associate Primary Care Physician
UPDATE CD SET PCP=D.DoctorID
FROM #Demo CD LEFT JOIN #PCP PC
ON CD.Loc=PC.Loc AND CD.Acct=PC.Acct AND CD.PT=PC.PT
LEFT JOIN #Doc D
ON PC.DocFirstName=D.DocFirstName AND PC.DocLastName=D.DocLastName AND PC.Degree=D.Degree

UPDATE CD SET PCP=D.DoctorID
FROM #YLDemo CD LEFT JOIN #YLPCP PC
ON CD.Loc=PC.Loc AND CD.Acct=PC.Acct AND CD.PT=PC.PT
LEFT JOIN #YLDoc D
ON PC.DocFirstName=D.DocFirstName AND PC.DocLastName=D.DocLastName AND PC.Degree=D.Degree

--Check for Invalid WorkPhone and HomePhone Entries, if found add this info to patient notes
UPDATE CD SET Notes=ISNULL(CAST(Notes AS VARCHAR(1000)),'')+ 
CASE WHEN HomePhone<>'' THEN ISNULL('HomePhone: '+HomePhone+CHAR(13)+CHAR(10),'') ELSE '' END,
HomePhone=NULL
FROM #Demo CD
WHERE ISNUMERIC(HomePhone)<>1

UPDATE CD SET Notes=ISNULL(CAST(Notes AS VARCHAR(1000)),'')+ 
CASE WHEN HomePhone<>'' THEN ISNULL('HomePhone: '+HomePhone+CHAR(13)+CHAR(10),'') ELSE '' END,
HomePhone=NULL
FROM #YLDemo CD
WHERE ISNUMERIC(HomePhone)<>1

UPDATE CD SET Notes=ISNULL(CAST(Notes AS VARCHAR(1000)),'')+ 
CASE WHEN WorkPhone<>'' THEN ISNULL('WorkPhone: '+WorkPhone+CHAR(13)+CHAR(10),'') ELSE '' END,
WorkPhone=NULL
FROM #Demo CD
WHERE ISNUMERIC(WorkPhone)<>1

UPDATE CD SET Notes=ISNULL(CAST(Notes AS VARCHAR(1000)),'')+ 
CASE WHEN WorkPhone<>'' THEN ISNULL('WorkPhone: '+WorkPhone+CHAR(13)+CHAR(10),'') ELSE '' END,
WorkPhone=NULL
FROM #YLDemo CD
WHERE ISNUMERIC(WorkPhone)<>1

DELETE #Demo
WHERE PatFirstName='' AND PatLastName='' AND PatMiddleName=''

DELETE #YLDemo
WHERE PatFirstName='' AND PatLastName='' AND PatMiddleName=''

--Set DefaultServiceLocationID

UPDATE #Demo SET DefaultLoc=421
WHERE LOC=6

UPDATE #Demo SET DefaultLoc=478
WHERE LOC=20

UPDATE #Demo SET DefaultLoc=419
WHERE LOC=19

UPDATE #Demo SET DefaultLoc=418
WHERE LOC=1

UPDATE #Demo SET DefaultLoc=420
WHERE LOC=10

IF @YLPracticeID=115
	UPDATE #YLDemo SET DefaultLoc=417

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Patient Insurance Information
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DECLARE @Today DATETIME
SET @Today=GETDATE()

CREATE TABLE #PatIns (InsID INT IDENTITY(1,1), Cs INT, Loc INT, Acct INT, PT INT, PayorType INT, InsCode VARCHAR(6), PRIM CHAR(1), 
GroupNo VARCHAR(50), PolicyNo VARCHAR(50), Copay MONEY, EffectiveDate DATETIME, Subscriber VARCHAR(196), RP VARCHAR(10))
INSERT INTO #PatIns(Cs, Loc, Acct, PT, PayorType, InsCode, PRIM, GroupNo, PolicyNo, Copay, EffectiveDate, Subscriber, RP)
SELECT Cs, CASE WHEN RLoc<>0 THEN RLoc ELSE Loc END Loc, CASE WHEN RAcct<>0 THEN RAcct ELSE Acct END Acct, CASE WHEN RPt<>0 THEN RPt ELSE Pt END PT, 
PayorType, InsCode, CASE WHEN PRIM='' OR PRIM IS NULL THEN 'P' ELSE PRIM END PRIM, GroupNo, PolicyNo, Copay, EffDateFrom,
Subscriber, CASE WHEN LEN(RP)>10 THEN NULL ELSE RP END
FROM Caduceus_CombinedCleanIns

CREATE TABLE #RecentPatIns (Loc INT, Acct INT, PT INT, PRIM CHAR(1), MaxEffDate DATETIME)
INSERT INTO #RecentPatIns(Loc, Acct, PT, PRIM, MaxEffDate)
SELECT Loc, Acct, PT, PRIM, MAX(ISNULL(EffectiveDate,@Today)) MaxEffDate
FROM #PatIns
WHERE Cs=0
GROUP BY Loc, Acct, PT, PRIM

CREATE TABLE #FinalPatIns(Loc INT, Acct INT, PT INT, PRIM CHAR(1), MaxInsID INT)
INSERT INTO #FinalPatIns(Loc, Acct, PT, PRIM, MaxInsID)
SELECT PI.Loc, PI.Acct, PI.PT, PI.PRIM, MAX(InsID) MaxInsID
FROM #PatIns PI INNER JOIN #RecentPatIns RPI
ON PI.Acct=RPI.Acct AND PI.PT=RPI.PT AND ISNULL(PI.EffectiveDate,@Today)=RPI.MaxEffDate
WHERE Cs=0
GROUP BY PI.Loc, PI.Acct, PI.PT, PI.PRIM

DELETE PI
FROM #PatIns PI LEFT JOIN #FinalPatIns FPI
ON PI.InsID=FPI.MaxInsID
WHERE PI.Cs=0 AND FPI.MaxInsID IS NULL

CREATE TABLE #PatPC(Cs INT, Loc INT, Acct INT, PT INT, PayerScenarioID INT, PCName VARCHAR(128))
INSERT INTO #PatPC(Cs, Loc, Acct, Pt, PayerScenarioID, PCName)
SELECT DISTINCT Cs, Loc, Acct, Pt, CASE WHEN Cs=4 THEN 2 WHEN Cs=2 THEN 13 ELSE 5 END,
CASE WHEN Cs=1 THEN '6-Psych' WHEN Cs=2 THEN '8-WC' WHEN Cs=3 THEN '4-OB' WHEN Cs=4 THEN '9-Auto'  WHEN Cs=5 THEN '5-OB' ELSE '1-General' END
FROM #PatIns

CREATE TABLE #YLPatIns (InsID INT IDENTITY(1,1), Cs INT, Loc INT, Acct INT, PT INT, PayorType INT, InsCode VARCHAR(6), PRIM CHAR(1), 
GroupNo VARCHAR(50), PolicyNo VARCHAR(50), Copay MONEY, EffectiveDate DATETIME, Subscriber VARCHAR(196), RP VARCHAR(10))
INSERT INTO #YLPatIns(Cs, Loc, Acct, PT, PayorType, InsCode, PRIM, GroupNo, PolicyNo, Copay, EffectiveDate, Subscriber, RP)
SELECT Cs, Loc, Acct, PT, PayorType, InsCode, CASE WHEN PRIM='' OR PRIM IS NULL THEN 'P' ELSE PRIM END PRIM, GroupNo, PolicyNo, Copay, EffDateFrom,
Subscriber, CASE WHEN LEN(RP)>10 THEN NULL ELSE RP END
FROM YLFCombinedCleanIns

CREATE TABLE #YLRecentPatIns (Loc INT, Acct INT, PT INT, PRIM CHAR(1), MaxEffDate DATETIME)
INSERT INTO #YLRecentPatIns(Loc, Acct, PT, PRIM, MaxEffDate)
SELECT Loc, Acct, PT, PRIM, MAX(ISNULL(EffectiveDate,@Today)) MaxEffDate
FROM #YLPatIns
WHERE Cs=0
GROUP BY Loc, Acct, PT, PRIM

CREATE TABLE #YLFinalPatIns(Loc INT, Acct INT, PT INT, PRIM CHAR(1), MaxInsID INT)
INSERT INTO #YLFinalPatIns(Loc, Acct, PT, PRIM, MaxInsID)
SELECT PI.Loc, PI.Acct, PI.PT, PI.PRIM, MAX(InsID) MaxInsID
FROM #YLPatIns PI INNER JOIN #YLRecentPatIns RPI
ON PI.Acct=RPI.Acct AND PI.PT=RPI.PT AND ISNULL(PI.EffectiveDate,@Today)=RPI.MaxEffDate
WHERE Cs=0
GROUP BY PI.Loc, PI.Acct, PI.PT, PI.PRIM

DELETE PI
FROM #YLPatIns PI LEFT JOIN #YLFinalPatIns FPI
ON PI.InsID=FPI.MaxInsID
WHERE PI.Cs=0 AND FPI.MaxInsID IS NULL

CREATE TABLE #YLPC(Cs INT, Loc INT, Acct INT, PT INT, PayerScenarioID INT, PCName VARCHAR(128))
INSERT INTO #YLPC(Cs, Loc, Acct, Pt, PayerScenarioID, PCName)
SELECT DISTINCT Cs, Loc, Acct, Pt, CASE WHEN Cs=4 THEN 2 WHEN Cs=2 THEN 13 ELSE 5 END,
CASE WHEN Cs=1 THEN '6-Psych' WHEN Cs=2 THEN '8-WC' WHEN Cs=3 THEN '4-OB' WHEN Cs=4 THEN '9-Auto'  WHEN Cs=5 THEN '5-OB' ELSE '1-General' END
FROM #YLPatIns

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Insurance Information Consolidation
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--Get Insurance Info
CREATE TABLE #Ins(Loc INT, PayorType INT, InsCode VARCHAR(6), InsName VARCHAR(128), Addr1 VARCHAR(128), Addr2 VARCHAR(128), CityStateZip VARCHAR(128), InsPhone VARCHAR(50))
INSERT INTO #Ins(Loc, PayorType, InsCode, InsName, Addr1, Addr2, CityStateZip, InsPhone)
SELECT DISTINCT CI.Loc, CAST(PayorType AS INT) PayorType, LTRIM(RTRIM(InsCode)) InsCode, LTRIM(RTRIM(InsName)), LTRIM(RTRIM(CI.Addr1)), LTRIM(RTRIM(CI.Addr2)), LTRIM(RTRIM(CityStateZip)), 
CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(InsPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''))>10
THEN RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(InsPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''),10)
ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(InsPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.','') END InsPhone
FROM Caduceus_CombinedCleanIns CI INNER JOIN Caduceus_CombinedCleanDemo C
ON C.LOC=CI.LOC AND C.ACCT=CI.ACCT AND C.PT=CI.PT
WHERE C.RLoc=0 AND C.RAcct=0 AND C.RPt=0 AND InsName IS NOT NULL AND LTRIM(RTRIM(InsName))<>''

UPDATE I SET Addr2=CityStateZip, CityStateZip=Addr2
FROM #Ins I
WHERE CityStateZip LIKE '%BOX%' OR CHARINDEX(',',Addr2)<>0

CREATE TABLE #InsCleaned(Loc INT, PayorType INT, InsCode VARCHAR(6), InsName VARCHAR(128), Addr1 VARCHAR(128), Addr2 VARCHAR(128), City VARCHAR(128), State VARCHAR(2), Zip VARCHAR(9), 
CityStateZip VARCHAR(128), InsPhone VARCHAR(10))
INSERT INTO #InsCleaned(Loc, PayorType, InsCode, InsName, Addr1, Addr2, City, CityStateZip, InsPhone)
SELECT Loc, PayorType, InsCode, InsName, Addr1, Addr2, 
CASE WHEN LEN(LTRIM(RTRIM(CityStateZip)))<>0 AND CHARINDEX(',',CityStateZip)<>0 THEN LEFT(CityStateZip,CHARINDEX(',',CityStateZip)-1) ELSE NULL END City, 
CASE WHEN LEN(LTRIM(RTRIM(CityStateZip)))<>0 AND CHARINDEX(',',CityStateZip)<>0 
THEN REPLACE(REPLACE(LTRIM(RTRIM(RIGHT(CityStateZip,LEN(CityStateZip)-CHARINDEX(',',CityStateZip)))),',',''),'.','') ELSE NULL END CityStateZip, InsPhone
FROM #Ins

UPDATE IC SET Zip=CASE WHEN LEN(REPLACE(RIGHT(CityStateZip,5),'-',''))=5 THEN RIGHT(CityStateZip,5) ELSE REPLACE(RIGHT(CityStateZip,10),'-','') END, CityStateZip=NULL
FROM #InsCleaned IC
WHERE CASE WHEN LEN(LTRIM(RTRIM(CityStateZip)))<>0 AND CHARINDEX(' ',CityStateZip)<>0 
THEN LEN(LTRIM(RTRIM(LEFT(CityStateZip,CHARINDEX(' ',CityStateZip)-1)))) ELSE 0 END>2

UPDATE IC SET State=LEFT(LTRIM(RTRIM(LEFT(CityStateZip,3))),2), Zip=CASE WHEN LEN(CityStateZip)>3 THEN LEFT(LTRIM(RTRIM(REPLACE(RIGHT(CityStateZip,LEN(CityStateZip)-3),'-',''))),9) ELSE NULL END
FROM #InsCleaned IC
WHERE CityStateZip IS NOT NULL

CREATE TABLE #YLIns(Loc INT, PayorType INT, InsCode VARCHAR(6), InsName VARCHAR(128), Addr1 VARCHAR(128), Addr2 VARCHAR(128), CityStateZip VARCHAR(128), InsPhone VARCHAR(50))
INSERT INTO #YLIns(Loc, PayorType, InsCode, InsName, Addr1, Addr2, CityStateZip, InsPhone)
SELECT DISTINCT CI.Loc, CAST(PayorType AS INT) PayorType, LTRIM(RTRIM(InsCode)) InsCode, LTRIM(RTRIM(InsName)), LTRIM(RTRIM(CI.Addr1)), LTRIM(RTRIM(CI.Addr2)), LTRIM(RTRIM(CityStateZip)), 
CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(InsPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''))>10
THEN RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(InsPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.',''),10)
ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(InsPhone,''),'-',''),'?',''),' ',''),'/',''),'DISCONNECTED',''),'.','') END InsPhone
FROM YLFCombinedCleanIns CI INNER JOIN YLFCombinedCleanDemo C
ON CI.LOC=C.LOC AND CI.ACCT=C.ACCT AND CI.PT=C.PT
WHERE InsName IS NOT NULL AND LTRIM(RTRIM(InsName))<>''

UPDATE I SET Addr2=CityStateZip, CityStateZip=Addr2
FROM #YLIns I
WHERE CityStateZip LIKE '%BOX%' OR CHARINDEX(',',Addr2)<>0

CREATE TABLE #YLInsCleaned(Loc INT, PayorType INT, InsCode VARCHAR(6), InsName VARCHAR(128), Addr1 VARCHAR(128), Addr2 VARCHAR(128), City VARCHAR(128), State VARCHAR(2), Zip VARCHAR(9), 
CityStateZip VARCHAR(128), InsPhone VARCHAR(10))
INSERT INTO #YLInsCleaned(Loc, PayorType, InsCode, InsName, Addr1, Addr2, City, CityStateZip, InsPhone)
SELECT Loc, PayorType, InsCode, InsName, Addr1, Addr2, 
CASE WHEN LEN(LTRIM(RTRIM(CityStateZip)))<>0 AND CHARINDEX(',',CityStateZip)<>0 THEN LEFT(CityStateZip,CHARINDEX(',',CityStateZip)-1) ELSE NULL END City, 
CASE WHEN LEN(LTRIM(RTRIM(CityStateZip)))<>0 AND CHARINDEX(',',CityStateZip)<>0 
THEN REPLACE(REPLACE(LTRIM(RTRIM(RIGHT(CityStateZip,LEN(CityStateZip)-CHARINDEX(',',CityStateZip)))),',',''),'.','') ELSE NULL END CityStateZip, InsPhone
FROM #YLIns

UPDATE IC SET Zip=CASE WHEN LEN(REPLACE(RIGHT(CityStateZip,5),'-',''))=5 THEN RIGHT(CityStateZip,5) ELSE REPLACE(RIGHT(CityStateZip,10),'-','') END, CityStateZip=NULL
FROM #YLInsCleaned IC
WHERE CASE WHEN LEN(LTRIM(RTRIM(CityStateZip)))<>0 AND CHARINDEX(' ',CityStateZip)<>0 
THEN LEN(LTRIM(RTRIM(LEFT(CityStateZip,CHARINDEX(' ',CityStateZip)-1)))) ELSE 0 END>2

UPDATE IC SET State=LEFT(LTRIM(RTRIM(LEFT(CityStateZip,3))),2), Zip=CASE WHEN LEN(CityStateZip)>=5 THEN LEFT(LTRIM(RTRIM(REPLACE(RIGHT(CityStateZip,LEN(CityStateZip)-3),'-',''))),9) ELSE NULL END
FROM #YLInsCleaned IC
WHERE CityStateZip IS NOT NULL

DELETE #InsCleaned
WHERE InsName LIKE 'NEED INSURANCE%'

DELETE #YLInsCleaned
WHERE InsName LIKE 'NEED INSURANCE%' OR InsName LIKE 'NEEDS INS INFORMATION 88'

CREATE TABLE #InsMaster(IMID INT IDENTITY(1,1), Source VARCHAR(6), Loc INT, PayorType INT, InsCode VARCHAR(6), InsName VARCHAR(128),
Addr1 VARCHAR(128), Addr2 VARCHAR(128), City VARCHAR(50), State VARCHAR(4), Zip VARCHAR(10), InsPhone VARCHAR(15), ICPID INT)

INSERT INTO #InsMaster(Source, Loc, PayorType, InsCode, InsName, Addr1, Addr2, City, State, Zip, InsPhone)
SELECT 'Cad' Source, Loc, PayorType, InsCode, InsName, Addr1, Addr2, City, State, Zip, InsPhone
FROM #InsCleaned
UNION
SELECT 'YL' Source, Loc, PayorType, InsCode, InsName, Addr1, Addr2, City, State, Zip, InsPhone
FROM #YLInsCleaned
ORDER BY InsName, Addr1, Addr2, City, State, Zip, PayorType

CREATE TABLE #UniqueInsMaster(UIMID INT IDENTITY(1,1), InsName VARCHAR(128), Addr1 VARCHAR(128), 
Addr2 VARCHAR(128), City VARCHAR(50), State VARCHAR(4), Zip VARCHAR(10), InsPhone VARCHAR(15))
INSERT INTO #UniqueInsMaster(InsName, Addr1, Addr2, City, State, Zip, InsPhone)
SELECT DISTINCT InsName, Addr1, Addr2, City, State, Zip, InsPhone
FROM #InsMaster

DECLARE @ID INT

CREATE TABLE #NewCompany(NCID INT IDENTITY(1,1), CompanyName VARCHAR(128))
CREATE TABLE #NewCompanyToPlan(NCID INT, UIMID INT)

INSERT #NewCompany(CompanyName)
VALUES('AETNA')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'AETNA%' OR InsName LIKE 'AENA%'

INSERT #NewCompany(CompanyName)
VALUES('BEECH STREET')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'BEECH STREET%'

INSERT #NewCompany(CompanyName)
VALUES('BENESIGHT')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'BENESIGHT%'

INSERT #NewCompany(CompanyName)
VALUES('BLUE CROSS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName='BLUE CROSS' OR InsName LIKE 'BLUE CROSS %' OR InsName='BLUE CROSS/SCREEN ACTORS GUILD'

INSERT #NewCompany(CompanyName)
VALUES('AUTO CLUB OF CA')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'AUTO CLUB%'

INSERT #NewCompany(CompanyName)
VALUES('BEN-E-LECT')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'BEN-E-LECT%'

INSERT #NewCompany(CompanyName)
VALUES('BENEFIT PLANNERS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'BENEFIT PLANNERS%'

INSERT #NewCompany(CompanyName)
VALUES('BENEFIT CONCEPTS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'BENEFIT CONCEPTS%'

INSERT #NewCompany(CompanyName)
VALUES('BLUE CROSS/ BLUE SHIELD')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'BLUE CROSS/ BLUE SHIELD%' OR InsName LIKE 'BLUE CROSS/BLUE SHIELD%'
OR InsName LIKE 'BLUE CROSS/SHIELD%'

INSERT #NewCompany(CompanyName)
VALUES('BLUE SHIELD')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'BLUE SHIELD%'

INSERT #NewCompany(CompanyName)
VALUES('CIGNA')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'Cigna%'

INSERT #NewCompany(CompanyName)
VALUES('CORESOURCE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'CORESOURCE%'

INSERT #NewCompany(CompanyName)
VALUES('DELTA HEALTH SYSTEMS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'DELTA%'

INSERT #NewCompany(CompanyName)
VALUES('E.B.A. & M CORPORATION')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'E.B.A.%'

INSERT #NewCompany(CompanyName)
VALUES('EMPLOYEE BENEFIT MGMT SERV')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'EMPLOYEE BENEFIT MGMT SERV%'

INSERT #NewCompany(CompanyName)
VALUES('CAL OPTIMA')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'CAL OPTIMA%' OR InsName LIKE 'CAL-OPTIMA%' OR InsName LIKE 'CALOPTIMA%'

INSERT #NewCompany(CompanyName)
VALUES('FARMER''S INSURANCE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'FARMER''S INSURANCE%'

INSERT #NewCompany(CompanyName)
VALUES('FIRST HEALTH')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'FIRST HEALTH%'

INSERT #NewCompany(CompanyName)
VALUES('FORTIS INSURANCE CO')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'FORTIS%'

INSERT #NewCompany(CompanyName)
VALUES('GALLAGHER BASSETT SERVICES')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'GALLAGHER%'

INSERT #NewCompany(CompanyName)
VALUES('GREAT WEST INSURANCE CO')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'GREAT WEST%'

INSERT #NewCompany(CompanyName)
VALUES('GUARDIAN')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'GUARDIAN%'

INSERT #NewCompany(CompanyName)
VALUES('HEALTHNET')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'HEALTHNET%' OR InsName LIKE 'HEALTH NET%'

INSERT #NewCompany(CompanyName)
VALUES('HUMANA')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'HUMANA%'

INSERT #NewCompany(CompanyName)
VALUES('INSURANCE CENTER')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'INSURANCE CENTER%' OR InsName LIKE 'INSURANCE SERVICE CENTER'

INSERT #NewCompany(CompanyName)
VALUES('KAISER PERMANENTE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'KAISER%'

INSERT #NewCompany(CompanyName)
VALUES('KEENAN & ASSOCIATES')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'KEENAN%'

INSERT #NewCompany(CompanyName)
VALUES('MONARCH')

SET @ID=@@IDENTITY

DECLARE @MonarchID INT
SET @MonarchID=@ID

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'MONARCH%'

INSERT #NewCompany(CompanyName)
VALUES('MUTUAL OF OMAHA')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'MUTUAL OF OMAHA%'

INSERT #NewCompany(CompanyName)
VALUES('MYERS STEVENS & CO')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'MYERS%'

INSERT #NewCompany(CompanyName)
VALUES('NATIONWIDE HEALTH PLANS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'NATIONWIDE%'

INSERT #NewCompany(CompanyName)
VALUES('LABORERS HEALTH & WELFARE TRUST')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'LABORER%'

INSERT #NewCompany(CompanyName)
VALUES('MEGA LIFE AND HEALTH INS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'MEGA%'

INSERT #NewCompany(CompanyName)
VALUES('PACIFICARE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'PACIFICARE%'

INSERT #NewCompany(CompanyName)
VALUES('PRINCIPAL MUTUAL LIFE INS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'PRINCIPAL%'

INSERT #NewCompany(CompanyName)
VALUES('QUAD/MED CLAIMS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'QUAD%'

INSERT #NewCompany(CompanyName)
VALUES('REGAL')

SET @ID=@@IDENTITY

DECLARE @RegalID INT
SET @RegalID=@ID

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'REGAL%'

INSERT #NewCompany(CompanyName)
VALUES('TRICARE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'TRICARE%'

INSERT #NewCompany(CompanyName)
VALUES('UFCW')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'UFCW%' OR InsName LIKE 'U.F.C.W.'

INSERT #NewCompany(CompanyName)
VALUES('UNICARE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'UNICARE%' OR InsName LIKE 'UNICAARE%'

INSERT #NewCompany(CompanyName)
VALUES('UNITED HEALTHCARE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName='UNITED HEALTH' OR InsName LIKE 'UNITED HEALTHCARE%' OR InsName='UNITED HEALTH - 30555'

INSERT #NewCompany(CompanyName)
VALUES('COLEN & LEE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'COLEN & LEE%'

INSERT #NewCompany(CompanyName)
VALUES('CAMBRIDGE INTEGRATED SERVICES')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'CAMBRIDGE%'

INSERT #NewCompany(CompanyName)
VALUES('ALLSTATE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'ALLSTATE%'

INSERT #NewCompany(CompanyName)
VALUES('CARPENTERS HEALTH AND WELFARE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'CARPENTERS%'

INSERT #NewCompany(CompanyName)
VALUES('CORESTAR')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'CORESTAR%'

INSERT #NewCompany(CompanyName)
VALUES('DEFINITY HEALTH CLAIMS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'DEFINITY%'

INSERT #NewCompany(CompanyName)
VALUES('HARRINGTON BENEFITS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'HARRINGTON%'

INSERT #NewCompany(CompanyName)
VALUES('LUMENOS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'LUMENOS%'

INSERT #NewCompany(CompanyName)
VALUES('MOTION PICTURE INDUSTRY')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'MOTION PICTURE%'

INSERT #NewCompany(CompanyName)
VALUES('NGS AMERICAN INC.')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'NGS%'

INSERT #NewCompany(CompanyName)
VALUES('NIPPON LIFE INS. CO OF AMERICA')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'NIPPON%'

INSERT #NewCompany(CompanyName)
VALUES('ONE HEALTH PLAN')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'ONE HEALTH%'

INSERT #NewCompany(CompanyName)
VALUES('OPERATING ENGINEERS HLTH')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'OPERATING ENGINEERS%'

INSERT #NewCompany(CompanyName)
VALUES('PACIFIC LIFE & ANNUITY CO.')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'PACIFIC LIFE & ANNUITY CO.%'

INSERT #NewCompany(CompanyName)
VALUES('PROSPECT MEDICAL GROUP')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'PROSPECT MEDICAL GROUP%'

INSERT #NewCompany(CompanyName)
VALUES('RIVERSIDE COUNTY FOUNDATION')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'RIVERSIDE%'

INSERT #NewCompany(CompanyName)
VALUES('SELF CREATED INSURANCE SERVICE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'SELF CREATED%'

INSERT #NewCompany(CompanyName)
VALUES('SHEET METAL WORKERS HLTH PLAN')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'SHEET METAL%'

INSERT #NewCompany(CompanyName)
VALUES('SOUTHWEST ADMINISTRATORS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'SOUTHWEST ADMIN%'

INSERT #NewCompany(CompanyName)
VALUES('ST. JOSEPH IPA')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'ST. JOSEPH%' OR InsName Like 'ST JOSEPH%'

INSERT #NewCompany(CompanyName)
VALUES('STATE FARM')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'STATE FARM%'

INSERT #NewCompany(CompanyName)
VALUES('TBN GROUP HEALTH PLAN')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'TBN GROUP HEALTH PLAN%'

INSERT #NewCompany(CompanyName)
VALUES('THE PLAN HANDLERS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'THE PLAN HANDLERS%'

INSERT #NewCompany(CompanyName)
VALUES('UNITED MEDICAL RESOURCES')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'UNITED MEDICAL RESOURCES%'

INSERT #NewCompany(CompanyName)
VALUES('WAUSAU BNEFITS, INC.')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'WAUSAU%'

INSERT #NewCompany(CompanyName)
VALUES('OXFORD HEALTH PLANS')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'OXFORD%'

INSERT #NewCompany(CompanyName)
VALUES('MIDWEST NATIONAL LIFE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'MID%'

INSERT #NewCompany(CompanyName)
VALUES('MERCURY INSURANCE')

SET @ID=@@IDENTITY

INSERT #NewCompanyToPLan(NCID, UIMID)
SELECT @ID, UIMID
FROM #UniqueInsMaster
WHERE InsName LIKE 'MERCURY%'

CREATE TABLE #InsCompany(ICID INT IDENTITY(1,1), CompanyName VARCHAR(128), Addr1 VARCHAR(256), Addr2 VARCHAR(256),
City VARCHAR(128), State VARCHAR(2), Zip VARCHAR(9), Phone VARCHAR(10))

INSERT INTO #InsCompany(CompanyName)
SELECT CompanyName
FROM #NewCompany

INSERT INTO #InsCompany(CompanyName, Addr1, Addr2, City, State, Zip, Phone)
SELECT InsName, Addr1, Addr2, City, State, Zip, InsPhone
FROM #UniqueInsMaster  UM LEFT JOIN #NewCompanyToPlan NCP
ON UM.UIMID=NCP.UIMID
WHERE NCP.UIMID IS NULL
ORDER BY InsName, Addr1, Addr2, City, State, Zip

CREATE TABLE #InsCompanyPlans(ICPID INT IDENTITY(1,1), ICID INT, InsName VARCHAR(128), 
Addr1 VARCHAR(256), Addr2 VARCHAR(256), City VARCHAR(128), State VARCHAR(2), Zip VARCHAR(9),
Phone VARCHAR(10))
INSERT INTO #InsCompanyPlans(ICID, InsName, Addr1, Addr2, City, State, Zip, Phone)
SELECT NCTP.NCID ICID, UM.InsName, UM.Addr1, UM.Addr2, UM.City, UM.State, UM.Zip, UM.InsPhone 
FROM #UniqueInsMaster UM INNER JOIN #NewCompanyToPlan NCTP
ON UM.UIMID=NCTP.UIMID

INSERT INTO #InsCompanyPlans(ICID, InsName, Addr1, Addr2, City, State, Zip, Phone)
SELECT ICID, CompanyName, Addr1, Addr2, City, State, Zip, Phone 
FROM #InsCompany
WHERE Addr1 IS NOT NULL OR Addr2 IS NOT NULL OR City IS NOT NULL OR State IS NOT NULL 
OR Zip IS NOT NULL OR Phone IS NOT NULL

UPDATE IM SET ICPID=ICP.ICPID
FROM #InsMaster IM INNER JOIN #InsCompanyPlans ICP
ON IM.InsName=ICP.InsName AND ISNULL(IM.Addr1,'')=ISNULL(ICP.Addr1,'')
AND ISNULL(IM.Addr2,'')=ISNULL(ICP.Addr2,'')
AND ISNULL(IM.City,'')=ISNULL(ICP.City,'')
AND ISNULL(IM.State,'')=ISNULL(ICP.State,'')
AND ISNULL(IM.InsPhone,'')=ISNULL(ICP.Phone,'')

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Import Records
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--BEGIN TRAN

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Reffering Physicians
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

----Correct Info
--UPDATE RF SET LastName=MiddleName, Degree=LastName, MiddleName=''
--FROM YL_RefPhys RF
--WHERE LTRIM(RTRIM(Degree))='' AND LTRIM(RTRIM(LastName))='MD'
--
--UPDATE RF SET LastName=MiddleName, Degree=LastName, MiddleName=''
--FROM CadYL_RefPhys RF
--WHERE LTRIM(RTRIM(Degree))='' AND LTRIM(RTRIM(LastName))='MD'
--
--UPDATE RF SET LastName=MiddleName, Degree=LastName, MiddleName=''
--FROM CadSpec_RefPhys RF
--WHERE LTRIM(RTRIM(Degree))='' AND LTRIM(RTRIM(LastName))='MD'
--
--UPDATE RF SET LastName=MiddleName, Degree=LastName, MiddleName=''
--FROM CadPeds_RefPhys RF
--WHERE LTRIM(RTRIM(Degree))='' AND LTRIM(RTRIM(LastName))='MD'
--
----get rid of bad Degree Data
--UPDATE RF SET Degree=''
--FROM YL_RefPhys RF
--WHERE LEN(Degree)>2
--
--UPDATE RF SET Degree=''
--FROM CadYL_RefPhys RF
--WHERE LEN(Degree)>2
--
--UPDATE RF SET Degree=''
--FROM CadSpec_RefPhys RF
--WHERE LEN(Degree)>2
--
--UPDATE RF SET Degree=''
--FROM CadPeds_RefPhys RF
--WHERE LEN(Degree)>2
--
----Clean Up Zip and Phone
--UPDATE RF SET Zip=CASE WHEN LEN(LTRIM(RTRIM(Zip)))<5 THEN NULL WHEN ISNUMERIC(LTRIM(RTRIM(Zip)))=0 THEN NULL ELSE LTRIM(RTRIM(Zip)) END,
--Phone=CASE WHEN LEN(LTRIM(RTRIM(Phone)))>10 THEN LEFT(Phone,10) WHEN ISNUMERIC(LTRIM(RTRIM(Phone)))=0 THEN NULL
--ELSE LTRIM(RTRIM(Phone)) END
--FROM YL_RefPhys RF
--
--UPDATE RF SET Zip=CASE WHEN LEN(LTRIM(RTRIM(Zip)))<5 THEN NULL WHEN ISNUMERIC(LTRIM(RTRIM(Zip)))=0 THEN NULL ELSE LTRIM(RTRIM(Zip)) END,
--Phone=CASE WHEN LEN(LTRIM(RTRIM(Phone)))>10 THEN LEFT(Phone,10) WHEN ISNUMERIC(LTRIM(RTRIM(Phone)))=0 THEN NULL
--ELSE LTRIM(RTRIM(Phone)) END
--FROM CadYL_RefPhys RF
--
--UPDATE RF SET Zip=CASE WHEN LEN(LTRIM(RTRIM(Zip)))<5 THEN NULL WHEN ISNUMERIC(LTRIM(RTRIM(Zip)))=0 THEN NULL ELSE LTRIM(RTRIM(Zip)) END,
--Phone=CASE WHEN LEN(LTRIM(RTRIM(Phone)))>10 THEN LEFT(Phone,10) WHEN ISNUMERIC(LTRIM(RTRIM(Phone)))=0 THEN NULL
--ELSE LTRIM(RTRIM(Phone)) END
--FROM CadSpec_RefPhys RF
--
--UPDATE RF SET Zip=CASE WHEN LEN(LTRIM(RTRIM(Zip)))<5 THEN NULL WHEN ISNUMERIC(LTRIM(RTRIM(Zip)))=0 THEN NULL ELSE LTRIM(RTRIM(Zip)) END,
--Phone=CASE WHEN LEN(LTRIM(RTRIM(Phone)))>10 THEN LEFT(Phone,10) WHEN ISNUMERIC(LTRIM(RTRIM(Phone)))=0 THEN NULL
--ELSE LTRIM(RTRIM(Phone)) END
--FROM CadPeds_RefPhys RF
--
--INSERT INTO Doctor(PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, Degree, AddressLine1, 
--				   AddressLine2, City, State, ZipCode, WorkPhone, VendorID, VendorImportID, [External])
--SELECT 113, '', FirstName, MiddleName, LastName, '', Degree, AddressLine1, AddressLine2, City, LEFT(State,2),
--Zip, Phone, OfficeCode+'.'+RefCode, @VendorImportID, 1
--FROM CadYL_RefPhys
--
--INSERT INTO Doctor(PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, Degree, AddressLine1, 
--				   AddressLine2, City, State, ZipCode, WorkPhone, VendorID, VendorImportID, [External])
--SELECT 113, '', FirstName, MiddleName, LastName, '', Degree, AddressLine1, AddressLine2, City, LEFT(State,2),
--Zip, Phone, OfficeCode+'.'+RefCode, @VendorImportID,1
--FROM CadSpec_RefPhys
--
--INSERT INTO Doctor(PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, Degree, AddressLine1, 
--				   AddressLine2, City, State, ZipCode, WorkPhone, VendorID, VendorImportID, [External])
--SELECT 113, '', FirstName, MiddleName, LastName, '', Degree, AddressLine1, AddressLine2, City, LEFT(State,2),
--Zip, Phone, OfficeCode+'.'+RefCode, @VendorImportID, 1
--FROM CadPeds_RefPhys
--
--INSERT INTO Doctor(PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, Degree, AddressLine1, 
--				   AddressLine2, City, State, ZipCode, WorkPhone, VendorID, VendorImportID, [External])
--SELECT 115, '', FirstName, MiddleName, LastName, '', Degree, AddressLine1, AddressLine2, City, LEFT(State,2),
--Zip, Phone, OfficeCode+'.'+RefCode, @VendorImportID, 1
--FROM YL_RefPhys
--
--INSERT INTO ProviderNumber(DoctorID, ProviderNumberTypeID, ProviderNumber, AttachConditionsTypeID)
--SELECT D.DoctorID, 25, RP.UPIN, 1
--FROM Doctor D INNER JOIN CadYL_RefPhys RP
--ON D.VendorImportID=@VendorImportID AND D.VendorID=RP.OfficeCode+'.'+RefCode
--WHERE LTRIM(RTRIM(RP.UPIN))<>''
--
--INSERT INTO ProviderNumber(DoctorID, ProviderNumberTypeID, ProviderNumber, AttachConditionsTypeID)
--SELECT D.DoctorID, 25, RP.UPIN, 1
--FROM Doctor D INNER JOIN CadSpec_RefPhys RP
--ON D.VendorImportID=@VendorImportID AND D.VendorID=RP.OfficeCode+'.'+RefCode
--WHERE LTRIM(RTRIM(RP.UPIN))<>''
--
--INSERT INTO ProviderNumber(DoctorID, ProviderNumberTypeID, ProviderNumber, AttachConditionsTypeID)
--SELECT D.DoctorID, 25, RP.UPIN, 1
--FROM Doctor D INNER JOIN CadPeds_RefPhys RP
--ON D.VendorImportID=@VendorImportID AND D.VendorID=RP.OfficeCode+'.'+RefCode
--WHERE LTRIM(RTRIM(RP.UPIN))<>''
--
--INSERT INTO ProviderNumber(DoctorID, ProviderNumberTypeID, ProviderNumber, AttachConditionsTypeID)
--SELECT D.DoctorID, 25, RP.UPIN, 1
--FROM Doctor D INNER JOIN YL_RefPhys RP
--ON D.VendorImportID=@VendorImportID AND D.VendorID=RP.OfficeCode+'.'+RefCode
--WHERE LTRIM(RTRIM(RP.UPIN))<>''

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Reffering Physicians
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

INSERT INTO InsuranceCompany (InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, VendorImportID, ReviewCode, VendorID)
SELECT CompanyName, Addr1, Addr2, City, State, Zip, Phone, @VendorImportID, 'R', ICID
FROM #InsCompany

INSERT INTO InsuranceCompanyPlan (PlanName, InsuranceCompanyID, AddressLine1, AddressLine2, City, State, ZipCode, Phone, VendorImportID, ReviewCode, VendorID)
SELECT InsName, IC.InsuranceCompanyID, Addr1, Addr2, ICP.City, ICP.State, Zip, ICP.Phone, @VendorImportID, 'R', ICPID
FROM #InsCompanyPlans ICP INNER JOIN InsuranceCompany IC
ON ICP.ICID=IC.VendorID AND IC.VendorImportID=@VendorImportID

INSERT INTO Patient(VendorImportID, VendorID, FirstName, LastName, MiddleName, AddressLine1, AddressLine2, City, State, ZipCode, HomePhone, WorkPhone,
Gender, DOB, SSN, PracticeID, Prefix, Suffix, ResponsibleDifferentThanPatient, PrimaryCarePhysicianID,
ResponsiblePrefix, ResponsibleFirstName, ResponsibleLastName, ResponsibleMiddleName, ResponsibleSuffix, DefaultServiceLocationID, MedicalRecordNumber)
SELECT @VendorImportID, CAST(D.Loc AS VARCHAR)+'-'+CAST(D.Acct AS VARCHAR)+'.'+CAST(D.PT AS VARCHAR) VendorID, PatFirstName, PatLastName, PatMiddleName, LTRIM(RTRIM(AddressLine1)),
LTRIM(RTRIM(AddressLine2)), LTRIM(RTRIM(City)), State, ZipCode, HomePhone, WorkPhone, Gender, DOB, SSN, @PedsPracticeID, '' Prefix, '' Suffix, 
CASE WHEN D.GuarantorName IS NOT NULL AND D.GuarantorName<>G.GuarantorName THEN 1 ELSE 0 END, PCP,
'' ResponsiblePrefix, 
CASE WHEN D.GuarantorName IS NOT NULL AND D.GuarantorName<>G.GuarantorName THEN GrFirstName ELSE '' END ResponsibleFirstName, 
CASE WHEN D.GuarantorName IS NOT NULL AND D.GuarantorName<>G.GuarantorName THEN GrLastName ELSE '' END ResponsibleLastName, 
CASE WHEN D.GuarantorName IS NOT NULL AND D.GuarantorName<>G.GuarantorName THEN GrMiddleName ELSE '' END ResponsibleMiddleName, 
'' ResponsibleSuffix, DefaultLoc,
CAST(D.Loc AS VARCHAR)+'-'+CAST(D.Acct AS VARCHAR)+'.'+CAST(D.PT AS VARCHAR)
FROM #Demo D LEFT JOIN #Guarantor G
ON D.Loc=G.Loc AND D.Acct=G.Acct AND D.PT=G.PT
ORDER BY PatLastName, PatFirstName

INSERT INTO PatientJournalNote(PatientID, UserName, SoftwareApplicationID, Hidden, NoteMessage)
SELECT P.PatientID, 'System Conversion', 'B', 0, PD.Notes
FROM #Demo PD INNER JOIN Patient P
ON CAST(PD.Loc AS VARCHAR)+'-'+CAST(PD.Acct AS VARCHAR)+'.'+CAST(PD.PT AS VARCHAR)=P.VendorID
WHERE P.VendorImportID=@VendorImportID

--Account Status Note
INSERT INTO PatientJournalNote(PatientID, UserName, SoftwareApplicationID, Hidden, NoteMessage, AccountStatus)
SELECT P.PatientID, 'System Conversion', 'B', 1, 'Status: '+PD.AccountStatusNote, 1
FROM #Demo PD INNER JOIN Patient P
ON CAST(PD.Loc AS VARCHAR)+'-'+CAST(PD.Acct AS VARCHAR)+'.'+CAST(PD.PT AS VARCHAR)=P.VendorID
WHERE P.VendorImportID=@VendorImportID AND PD.AccountStatusNote IS NOT NULL

INSERT INTO PatientCase (PatientID, Name, PracticeID, PayerScenarioID, ReferringPhysicianID, VendorImportID, VendorID)
SELECT P.PatientID, PCName, @PedsPracticeID PracticeID, PayerScenarioID, P.ReferringPhysicianID, @VendorImportID VendorImportID, 
CAST(PC.Loc AS VARCHAR)+'-'+CAST(PC.Acct AS VARCHAR)+'.'+CAST(PC.PT AS VARCHAR)+CAST(PC.Cs AS VARCHAR) VendorID
FROM #PatPC PC INNER JOIN Patient P
ON CAST(PC.Loc AS VARCHAR)+'-'+CAST(PC.Acct AS VARCHAR)+'.'+CAST(PC.PT AS VARCHAR)=P.VendorID
WHERE P.VendorImportID=@VendorImportID

INSERT INTO InsurancePolicy(PracticeID, PatientCaseID, Precedence, InsuranceCompanyPlanID, 
PatientRelationshipToInsured, VendorImportID, VendorID, HolderPrefix, HolderFirstName, 
HolderLastName, HolderMiddleName, HolderSuffix, HolderGender, HolderDOB, Copay, PolicyStartDate, GroupNumber, PolicyNumber)
SELECT DISTINCT @PedsPracticeID PracticeID, PC.PatientCaseID, CASE WHEN PRIM='P' THEN 1 ELSE 2 END Precedence,
ICP.InsuranceCompanyPlanID, 
CASE WHEN LTRIM(RTRIM(S.RelToSub))='' AND SFirstName IS NOT NULL THEN 'O' WHEN S.RelToSub IS NULL THEN 'S' 
WHEN LTRIM(RTRIM(S.RelToSub))='S' THEN 'U' ELSE LTRIM(RTRIM(RelToSub)) END PatientRelationshipToInsured,
@VendorImportID, PC.VendorID, '' HolderPrefix, SFirstName HolderFirstName, SLastName HolderLastName, 
SMiddleName HolderMiddleName, '' HolderSuffix, Gender HolderGender, SDOB HolderDOB, ISNULL(PPI.CoPay,0) Copay,
EffectiveDate PolicyStartDate, GroupNo GroupNumber, PolicyNo PolicyNumber
FROM PatientCase PC INNER JOIN #PatIns PPI
ON PC.VendorImportID=@VendorImportID 
AND PC.VendorID=CAST(PPI.Loc AS VARCHAR)+'-'+CAST(PPI.Acct AS VARCHAR)+'.'+CAST(PPI.PT AS VARCHAR)+CAST(PPI.Cs AS VARCHAR)
LEFT JOIN #Subscriber S
ON PPI.Loc=S.Loc AND PPI.Acct=S.Acct AND PPI.PT=S.PT AND PPI.Subscriber=S.SubscriberName
INNER JOIN #InsMaster IM
ON IM.Source='Cad' AND IM.Loc=PPI.Loc AND IM.PayorType=PPI.PayorType AND IM.InsCode=PPI.InsCode
INNER JOIN InsuranceCompanyPlan ICP
ON ICP.VendorImportID=@VendorImportID AND IM.ICPID=ICP.VendorID
WHERE PPI.PRIM='P'

INSERT INTO InsurancePolicy(PracticeID, PatientCaseID, Precedence, InsuranceCompanyPlanID, 
PatientRelationshipToInsured, VendorImportID, VendorID, HolderPrefix, HolderFirstName, 
HolderLastName, HolderMiddleName, HolderSuffix, HolderGender, HolderDOB, Copay, PolicyStartDate, GroupNumber, PolicyNumber)
SELECT DISTINCT @PedsPracticeID PracticeID, PC.PatientCaseID, CASE WHEN PRIM='P' THEN 1 ELSE 2 END Precedence,
ICP.InsuranceCompanyPlanID, 
CASE WHEN LTRIM(RTRIM(S.RelToSub))='' AND SFirstName IS NOT NULL THEN 'O' WHEN S.RelToSub IS NULL THEN 'S' 
WHEN LTRIM(RTRIM(S.RelToSub))='S' THEN 'U' ELSE LTRIM(RTRIM(RelToSub)) END PatientRelationshipToInsured,
@VendorImportID, PC.VendorID, '' HolderPrefix, SFirstName HolderFirstName, SLastName HolderLastName, 
SMiddleName HolderMiddleName, '' HolderSuffix, Gender HolderGender, SDOB HolderDOB, ISNULL(PPI.CoPay,0) Copay,
EffectiveDate PolicyStartDate, GroupNo GroupNumber, PolicyNo PolicyNumber
FROM PatientCase PC INNER JOIN #PatIns PPI
ON PC.VendorImportID=@VendorImportID 
AND PC.VendorID=CAST(PPI.Loc AS VARCHAR)+'-'+CAST(PPI.Acct AS VARCHAR)+'.'+CAST(PPI.PT AS VARCHAR)+CAST(PPI.Cs AS VARCHAR)
LEFT JOIN #Subscriber S
ON PPI.Loc=S.Loc AND PPI.Acct=S.Acct AND PPI.PT=S.PT AND PPI.Subscriber=S.SubscriberName
INNER JOIN #InsMaster IM
ON IM.Source='Cad' AND IM.Loc=PPI.Loc AND IM.PayorType=PPI.PayorType AND IM.InsCode=PPI.InsCode
INNER JOIN InsuranceCompanyPlan ICP
ON ICP.VendorImportID=@VendorImportID AND IM.ICPID=ICP.VendorID
WHERE PPI.PRIM='S'

CREATE TABLE #DistinctRP_CadFam(RID INT IDENTITY(1,1), LOC INT, ACCT INT, PT INT, RP VARCHAR(10))
INSERT INTO #DistinctRP_CadFam(LOC, ACCT, PT, RP)
SELECT DISTINCT LOC, ACCT, PT, RP
FROM Caduceus_CombinedCleanIns
WHERE LOC IN ('19','20') AND RP IS NOT NULL AND LEN(RP)<=10

CREATE TABLE #UniqueRP_CadFam(LOC INT, ACCT INT, PT INT, RP VARCHAR(10))
INSERT INTO #UniqueRP_CadFam(LOC, ACCT, PT, RP)
SELECT DRP.LOC, DRP.ACCT, DRP.PT, DRP.RP
FROM #DistinctRP_CadFam DRP INNER JOIN 
(SELECT LOC, ACCT, PT, MIN(RID) MinRID FROM #DistinctRP_CadFam GROUP BY LOC, ACCT, PT) MinDRP
ON DRP.LOC=MinDRP.LOC AND DRP.ACCT=MinDRP.ACCT AND DRP.PT=MinDRP.PT AND DRP.RID=MinDRP.MinRID

UPDATE P SET ReferringPhysicianID=D.DoctorID
FROM #UniqueRP_CadFam URP INNER JOIN Patient P
ON CAST(URP.Loc AS VARCHAR)+'-'+CAST(URP.Acct AS VARCHAR)+'.'+CAST(URP.PT AS VARCHAR)=P.VendorID
INNER JOIN Doctor D
ON D.PracticeID=113 AND D.VendorImportID=@VendorImportID 
AND D.VendorID='CADYL.'+URP.RP AND D.[External]=1
WHERE P.PracticeID=113 AND P.VendorImportID=@VendorImportID

DROP TABLE #DistinctRP_CadFam
DROP TABLE #UniqueRP_CadFam

CREATE TABLE #DistinctRP_CadSpec(RID INT IDENTITY(1,1), LOC INT, ACCT INT, PT INT, RP VARCHAR(10))
INSERT INTO #DistinctRP_CadSpec(LOC, ACCT, PT, RP)
SELECT DISTINCT LOC, ACCT, PT, RP
FROM Caduceus_CombinedCleanIns
WHERE LOC NOT IN ('6','19','20') AND RP IS NOT NULL AND LEN(RP)<=10

CREATE TABLE #UniqueRP_CadSpec(LOC INT, ACCT INT, PT INT, RP VARCHAR(10))
INSERT INTO #UniqueRP_CadSpec(LOC, ACCT, PT, RP)
SELECT DRP.LOC, DRP.ACCT, DRP.PT, DRP.RP
FROM #DistinctRP_CadSpec DRP INNER JOIN 
(SELECT LOC, ACCT, PT, MIN(RID) MinRID FROM #DistinctRP_CadSpec GROUP BY LOC, ACCT, PT) MinDRP
ON DRP.LOC=MinDRP.LOC AND DRP.ACCT=MinDRP.ACCT AND DRP.PT=MinDRP.PT AND DRP.RID=MinDRP.MinRID

UPDATE P SET ReferringPhysicianID=D.DoctorID
FROM #UniqueRP_CadSpec URP INNER JOIN Patient P
ON CAST(URP.Loc AS VARCHAR)+'-'+CAST(URP.Acct AS VARCHAR)+'.'+CAST(URP.PT AS VARCHAR)=P.VendorID
INNER JOIN Doctor D
ON D.PracticeID=113 AND D.VendorImportID=@VendorImportID 
AND D.VendorID='CADSPEC.'+URP.RP AND D.[External]=1
WHERE P.PracticeID=113 AND P.VendorImportID=@VendorImportID

DROP TABLE #DistinctRP_CadSpec
DROP TABLE #UniqueRP_CadSpec

INSERT INTO Patient(VendorImportID, VendorID, FirstName, LastName, MiddleName, AddressLine1, AddressLine2, City, State, ZipCode, HomePhone, WorkPhone,
Gender, DOB, SSN, PracticeID, Prefix, Suffix, ResponsibleDifferentThanPatient, PrimaryCarePhysicianID,
ResponsiblePrefix, ResponsibleFirstName, ResponsibleLastName, ResponsibleMiddleName, ResponsibleSuffix, DefaultServiceLocationID, MedicalRecordNumber)
SELECT @VendorImportID, CAST(D.Loc AS VARCHAR)+'-'+CAST(D.Acct AS VARCHAR)+'.'+CAST(D.PT AS VARCHAR) VendorID, PatFirstName, PatLastName, PatMiddleName, LTRIM(RTRIM(AddressLine1)),
LTRIM(RTRIM(AddressLine2)), LTRIM(RTRIM(City)), State, ZipCode, HomePhone, WorkPhone, Gender, DOB, SSN, @YLPracticeID, '' Prefix, '' Suffix, 
CASE WHEN D.GuarantorName IS NOT NULL AND D.GuarantorName<>G.GuarantorName THEN 1 ELSE 0 END, PCP,
'' ResponsiblePrefix, 
CASE WHEN D.GuarantorName IS NOT NULL AND D.GuarantorName<>G.GuarantorName THEN GrFirstName ELSE '' END ResponsibleFirstName, 
CASE WHEN D.GuarantorName IS NOT NULL AND D.GuarantorName<>G.GuarantorName THEN GrLastName ELSE '' END ResponsibleLastName, 
CASE WHEN D.GuarantorName IS NOT NULL AND D.GuarantorName<>G.GuarantorName THEN GrMiddleName ELSE '' END ResponsibleMiddleName, 
'' ResponsibleSuffix, DefaultLoc,
CAST(D.Loc AS VARCHAR)+'-'+CAST(D.Acct AS VARCHAR)+'.'+CAST(D.PT AS VARCHAR)
FROM #YLDemo D LEFT JOIN #Guarantor G
ON D.Loc=G.Loc AND D.Acct=G.Acct AND D.PT=G.PT
WHERE D.Cs=0
ORDER BY PatLastName, PatFirstName

INSERT INTO PatientJournalNote(PatientID, UserName, SoftwareApplicationID, Hidden, NoteMessage)
SELECT P.PatientID, 'System Conversion', 'B', 0, PD.Notes
FROM #YLDemo PD INNER JOIN Patient P
ON CAST(PD.Loc AS VARCHAR)+'-'+CAST(PD.Acct AS VARCHAR)+'.'+CAST(PD.PT AS VARCHAR)=P.VendorID
WHERE P.VendorImportID=@VendorImportID

--Account Status Note
INSERT INTO PatientJournalNote(PatientID, UserName, SoftwareApplicationID, Hidden, NoteMessage, AccountStatus)
SELECT P.PatientID, 'System Conversion', 'B', 1, 'Status: '+PD.AccountStatusNote, 1
FROM #YLDemo PD INNER JOIN Patient P
ON CAST(PD.Loc AS VARCHAR)+'-'+CAST(PD.Acct AS VARCHAR)+'.'+CAST(PD.PT AS VARCHAR)=P.VendorID
WHERE P.VendorImportID=@VendorImportID AND PD.AccountStatusNote IS NOT NULL

INSERT INTO PatientCase (PatientID, Name, PracticeID, PayerScenarioID, ReferringPhysicianID, VendorImportID, VendorID)
SELECT P.PatientID, PCName, @YLPracticeID PracticeID, PayerScenarioID, P.ReferringPhysicianID, @VendorImportID VendorImportID, 
CAST(PC.Loc AS VARCHAR)+'-'+CAST(PC.Acct AS VARCHAR)+'.'+CAST(PC.PT AS VARCHAR) VendorID
FROM #YLPC PC INNER JOIN Patient P
ON CAST(PC.Loc AS VARCHAR)+'-'+CAST(PC.Acct AS VARCHAR)+'.'+CAST(CASE WHEN PC.Cs<>0 THEN RIGHT(PC.PT,1) ELSE PC.PT END AS VARCHAR)=P.VendorID
WHERE P.VendorImportID=@VendorImportID

INSERT INTO InsurancePolicy(PracticeID, PatientCaseID, Precedence, InsuranceCompanyPlanID, 
PatientRelationshipToInsured, VendorImportID, VendorID, HolderPrefix, HolderFirstName, 
HolderLastName, HolderMiddleName, HolderSuffix, HolderGender, HolderDOB, Copay, PolicyStartDate, GroupNumber, PolicyNumber)
SELECT DISTINCT @YLPracticeID PracticeID, PC.PatientCaseID, CASE WHEN PRIM='P' THEN 1 ELSE 2 END Precedence,
ICP.InsuranceCompanyPlanID, 
CASE WHEN LTRIM(RTRIM(S.RelToSub))='' AND SFirstName IS NOT NULL THEN 'O' WHEN S.RelToSub IS NULL THEN 'S' 
WHEN LTRIM(RTRIM(S.RelToSub))='S' THEN 'U' ELSE LTRIM(RTRIM(RelToSub)) END PatientRelationshipToInsured,
@VendorImportID, PC.VendorID, '' HolderPrefix, SFirstName HolderFirstName, SLastName HolderLastName, 
SMiddleName HolderMiddleName, '' HolderSuffix, Gender HolderGender, SDOB HolderDOB, ISNULL(PPI.CoPay,0) Copay,
EffectiveDate PolicyStartDate, GroupNo GroupNumber, PolicyNo PolicyNumber
FROM PatientCase PC INNER JOIN #YLPatIns PPI
ON PC.VendorImportID=@VendorImportID 
AND PC.VendorID=CAST(PPI.Loc AS VARCHAR)+'-'+CAST(PPI.Acct AS VARCHAR)+'.'+CAST(PPI.PT AS VARCHAR)
LEFT JOIN #Subscriber S
ON PPI.Loc=S.Loc AND PPI.Acct=S.Acct AND PPI.PT=S.PT AND PPI.Subscriber=S.SubscriberName
INNER JOIN #InsMaster IM
ON IM.Source='YL' AND IM.Loc=PPI.Loc AND IM.PayorType=PPI.PayorType AND IM.InsCode=PPI.InsCode
INNER JOIN InsuranceCompanyPlan ICP
ON ICP.VendorImportID=@VendorImportID AND IM.ICPID=ICP.VendorID
WHERE PPI.PRIM='P'

INSERT INTO InsurancePolicy(PracticeID, PatientCaseID, Precedence, InsuranceCompanyPlanID, 
PatientRelationshipToInsured, VendorImportID, VendorID, HolderPrefix, HolderFirstName, 
HolderLastName, HolderMiddleName, HolderSuffix, HolderGender, HolderDOB, Copay, PolicyStartDate, GroupNumber, PolicyNumber)
SELECT DISTINCT @YLPracticeID PracticeID, PC.PatientCaseID, CASE WHEN PRIM='P' THEN 1 ELSE 2 END Precedence,
ICP.InsuranceCompanyPlanID, 
CASE WHEN LTRIM(RTRIM(S.RelToSub))='' AND SFirstName IS NOT NULL THEN 'O' WHEN S.RelToSub IS NULL THEN 'S' 
WHEN LTRIM(RTRIM(S.RelToSub))='S' THEN 'U' ELSE LTRIM(RTRIM(RelToSub)) END PatientRelationshipToInsured,
@VendorImportID, PC.VendorID, '' HolderPrefix, SFirstName HolderFirstName, SLastName HolderLastName, 
SMiddleName HolderMiddleName, '' HolderSuffix, Gender HolderGender, SDOB HolderDOB, ISNULL(PPI.CoPay,0) Copay,
EffectiveDate PolicyStartDate, GroupNo GroupNumber, PolicyNo PolicyNumber
FROM PatientCase PC INNER JOIN #YLPatIns PPI
ON PC.VendorImportID=@VendorImportID 
AND PC.VendorID=CAST(PPI.Loc AS VARCHAR)+'-'+CAST(PPI.Acct AS VARCHAR)+'.'+CAST(PPI.PT AS VARCHAR)
LEFT JOIN #Subscriber S
ON PPI.Loc=S.Loc AND PPI.Acct=S.Acct AND PPI.PT=S.PT AND PPI.Subscriber=S.SubscriberName
INNER JOIN #InsMaster IM
ON IM.Source='YL' AND IM.Loc=PPI.Loc AND IM.PayorType=PPI.PayorType AND IM.InsCode=PPI.InsCode
INNER JOIN InsuranceCompanyPlan ICP
ON ICP.VendorImportID=@VendorImportID AND IM.ICPID=ICP.VendorID
WHERE PPI.PRIM='S'

CREATE TABLE #DistinctRP_YL(RID INT IDENTITY(1,1), LOC INT, ACCT INT, PT INT, RP VARCHAR(10))
INSERT INTO #DistinctRP_YL(LOC, ACCT, PT, RP)
SELECT DISTINCT LOC, ACCT, PT, RP
FROM YLFCombinedCleanIns
WHERE RP IS NOT NULL AND LEN(RP)<=10

CREATE TABLE #UniqueRP_YL(LOC INT, ACCT INT, PT INT, RP VARCHAR(10))
INSERT INTO #UniqueRP_YL(LOC, ACCT, PT, RP)
SELECT DRP.LOC, DRP.ACCT, DRP.PT, DRP.RP
FROM #DistinctRP_YL DRP INNER JOIN 
(SELECT LOC, ACCT, PT, MIN(RID) MinRID FROM #DistinctRP_YL GROUP BY LOC, ACCT, PT) MinDRP
ON DRP.LOC=MinDRP.LOC AND DRP.ACCT=MinDRP.ACCT AND DRP.PT=MinDRP.PT AND DRP.RID=MinDRP.MinRID

UPDATE P SET ReferringPhysicianID=D.DoctorID
FROM #UniqueRP_YL URP INNER JOIN Patient P
ON CAST(URP.Loc AS VARCHAR)+'-'+CAST(URP.Acct AS VARCHAR)+'.'+CAST(URP.PT AS VARCHAR)=P.VendorID
INNER JOIN Doctor D
ON D.PracticeID=115 AND D.VendorImportID=@VendorImportID 
AND D.VendorID='YL.'+URP.RP AND D.[External]=1
WHERE P.PracticeID=115 AND P.VendorImportID=@VendorImportID

DROP TABLE #DistinctRP_YL
DROP TABLE #UniqueRP_YL

CREATE TABLE #CasesToPopulate(PatientID INT, PracticeID INT, VendorImportID INT, VendorID VARCHAR(50))
INSERT INTO #CasesToPopulate(PatientID, PracticeID, VendorImportID, VendorID)
SELECT P.PatientID, P.PracticeID, P.VendorImportID, P.VendorID
FROM Patient P LEFT JOIN PatientCase PC
ON P.PatientID=PC.PatientID
WHERE P.VendorImportID=@VendorImportID AND PC.PatientID IS NULL

INSERT INTO PatientCase (PatientID, Name, PracticeID, PayerScenarioID, VendorImportID, VendorID)
SELECT PatientID, '1-General', PracticeID, 5, VendorImportID, VendorID
FROM #CasesToPopulate

DROP TABLE #CasesToPopulate

CREATE TABLE #CasesToSetToSelfPay(PatientCaseID INT)
INSERT INTO #CasesToSetToSelfPay(PatientCaseID)
SELECT PC.PatientCaseID
FROM PatientCase PC LEFT JOIN InsurancePolicy IP
ON PC.PatientCaseID=IP.PatientCaseID
WHERE PC.PracticeID IN (113,114,115,116)
GROUP BY PC.PatientCaseID
HAVING COUNT(IP.InsurancePolicyID)=0

UPDATE PC SET PayerScenarioID=11, Name='3-Self-Pay'
FROM PatientCase PC INNER JOIN #CasesToSetToSelfPay CTS
ON PC.PatientCaseID=CTS.PatientCaseID
WHERE PC.PracticeID IN (113,114,115,116)

UPDATE PC SET PayerScenarioID=6
FROM PatientCase PC INNER JOIN InsurancePolicy IP
ON PC.PatientCaseID=IP.PatientCaseID
INNER JOIN InsuranceCompanyPlan ICP
ON IP.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
INNER JOIN InsuranceCompany IC
ON ICP.InsuranceCompanyID=IC.InsuranceCompanyID
WHERE PC.PracticeID IN (113,114,115,116) AND IP.Precedence=1 
AND IC.VendorImportID=@VendorImportID AND IC.VendorID IN (@MonarchID,@RegalID)

DROP TABLE #CasesToSetToSelfPay

create table #cpctoupdate(PatientCaseID INT, PayerScenarioID INT)
INSERT INTO #cpctoupdate(PatientCaseID, PayerScenarioID)
select distinct pc.patientcaseid, cp.payerscenarioid
from patientcase pc inner join insurancepolicy ip
on pc.patientcaseid=ip.patientcaseid and ip.precedence=1
inner join insurancecompanyplan icp
on ip.insurancecompanyplanid=icp.insurancecompanyplanid
inner join insurancecompany ic
on icp.insurancecompanyid=ic.insurancecompanyid
inner join caduceus_payerscenarios cp
on icp.planname=cp.planname and ic.insurancecompanyname=cp.companyname and cp.casename=pc.name
where pc.practiceid=113
order by pc.patientcaseid

UPDATE PC SET PayerScenarioID=cp.PayerScenarioID
FROM PatientCase PC INNER JOIN #cpctoupdate cp
on PC.PatientCaseID=cp.PatientCaseID

delete #cpctoupdate

INSERT INTO #cpctoupdate(PatientCaseID, PayerScenarioID)
select distinct pc.patientcaseid, cp.payerscenarioid
from patientcase pc inner join insurancepolicy ip
on pc.practiceid=ip.practiceid and pc.patientcaseid=ip.patientcaseid and ip.precedence=1
inner join insurancecompanyplan icp
on ip.insurancecompanyplanid=icp.insurancecompanyplanid
inner join insurancecompany ic
on icp.insurancecompanyid=ic.insurancecompanyid
inner join YLFP_payerscenarios cp
on icp.planname=cp.planname and ic.insurancecompanyname=cp.companyname and cp.casename=pc.name
where pc.practiceid=115

UPDATE PC SET PayerScenarioID=cp.PayerScenarioID
FROM PatientCase PC INNER JOIN #cpctoupdate cp
on PC.PatientCaseID=cp.PatientCaseID

DROP TABLE #cpctoupdate

CREATE TABLE #DupPolicies(PatientCaseID INT, Precedence INT, MaxIP INT)
INSERT INTO #DupPolicies(PatientCaseID, Precedence, MaxIP)
select patientcaseid, precedence, MAX(insurancepolicyid)
from insurancepolicy
where practiceid IN (113,115)
group by patientcaseid, precedence
having count(insurancepolicyid)>1

DELETE IP
FROM InsurancePolicy IP INNER JOIN #DupPolicies DP
ON IP.PatientCaseID=DP.PatientCaseID AND IP.Precedence=DP.Precedence AND IP.InsurancePolicyID=DP.MaxIP

DELETE #DupPolicies

INSERT INTO #DupPolicies(PatientCaseID, Precedence, MaxIP)
select patientcaseid, precedence, MAX(insurancepolicyid)
from insurancepolicy
where practiceid IN (113,115)
group by patientcaseid, precedence
having count(insurancepolicyid)>1

DELETE IP
FROM InsurancePolicy IP INNER JOIN #DupPolicies DP
ON IP.PatientCaseID=DP.PatientCaseID AND IP.Precedence=DP.Precedence AND IP.InsurancePolicyID=DP.MaxIP

DELETE #DupPolicies

INSERT INTO #DupPolicies(PatientCaseID, Precedence, MaxIP)
select patientcaseid, precedence, MAX(insurancepolicyid)
from insurancepolicy
where practiceid IN (113,115)
group by patientcaseid, precedence
having count(insurancepolicyid)>1

DELETE IP
FROM InsurancePolicy IP INNER JOIN #DupPolicies DP
ON IP.PatientCaseID=DP.PatientCaseID AND IP.Precedence=DP.Precedence AND IP.InsurancePolicyID=DP.MaxIP

DELETE #DupPolicies

INSERT INTO #DupPolicies(PatientCaseID, Precedence, MaxIP)
select patientcaseid, precedence, MAX(insurancepolicyid)
from insurancepolicy
where practiceid IN (113,115)
group by patientcaseid, precedence
having count(insurancepolicyid)>1

DELETE IP
FROM InsurancePolicy IP INNER JOIN #DupPolicies DP
ON IP.PatientCaseID=DP.PatientCaseID AND IP.Precedence=DP.Precedence AND IP.InsurancePolicyID=DP.MaxIP

DROP TABLE #DupPolicies

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Contracts
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DECLARE @Fees TABLE(TID INT IDENTITY(1,1), FID INT, ProcedureCode VARCHAR(16), Mod VARCHAR(16), Standard MONEY)
INSERT @Fees(FID, ProcedureCode, Mod, Standard)
SELECT DISTINCT FID, CF.ProcedureCode, CASE WHEN Mod='' THEN NULL ELSE Mod END Mode, ISNULL(StandardAmount,UnitRate) Standard
FROM Cadeceus_Fees CF INNER JOIN ProcedureCodeDictionary PCD
ON CF.ProcedureCode=PCD.ProcedureCode
WHERE ISNULL(StandardAmount,UnitRate)<>''

DELETE F
FROM @Fees F LEFT JOIN ProcedureModifier PM
ON F.Mod=PM.ProcedureModifierCode
WHERE F.Mod IS NOT NULL AND PM.ProcedureModifierCode IS NULL

DECLARE @FeesToImport TABLE(FID INT, ProcedureCode VARCHAR(16), Mod VARCHAR(16), MaxID INT)
INSERT @FeesToImport(FID, ProcedureCode, Mod, MaxID)
SELECT FID, ProcedureCode, ISNULL(Mod,'') Mod, MAX(TID) MaxID
FROM @Fees
GROUP BY FID, ProcedureCode, ISNULL(Mod,'')

DECLARE @ContractID INT

INSERT INTO Contract(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, 
					 NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated)
VALUES(@PedsPracticeID,'Standard (Peds)', 'S', GETDATE(), DATEADD(Y,1,GETDATE()), 45, 45, 0)

SET @ContractID=@@IDENTITY

INSERT INTO ContractFeeSchedule(ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU,
								ProcedureCodeDictionaryID)
SELECT @ContractID, CASE WHEN FTI.Mod='' THEN NULL ELSE FTI.Mod END Mod, 'B', F.Standard, 0, 0, 0, PCD.ProcedureCodeDictionaryID
FROM @FeesToImport FTI INNER JOIN @Fees F
ON FTI.MaxID=F.TID
INNER JOIN ProcedureCodeDictionary PCD
ON F.ProcedureCode=PCD.ProcedureCode
WHERE F.FID=1

IF @PedsPracticeID=113
	INSERT INTO ContractToServiceLocation(ContractID, ServiceLocationID)
	VALUES(@ContractID,421)


INSERT INTO Contract(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, 
					 NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated)
VALUES(@FamPracticeID,'Standard (Family)', 'S', GETDATE(), DATEADD(Y,1,GETDATE()), 45, 45, 0)

SET @ContractID=@@IDENTITY

INSERT INTO ContractFeeSchedule(ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU,
								ProcedureCodeDictionaryID)
SELECT @ContractID, CASE WHEN FTI.Mod='' THEN NULL ELSE FTI.Mod END Mod, 'B', F.Standard, 0, 0, 0, PCD.ProcedureCodeDictionaryID
FROM @FeesToImport FTI INNER JOIN @Fees F
ON FTI.MaxID=F.TID
INNER JOIN ProcedureCodeDictionary PCD
ON F.ProcedureCode=PCD.ProcedureCode
WHERE F.FID=3

IF @FamPracticeID=113
BEGIN
	INSERT INTO ContractToServiceLocation(ContractID, ServiceLocationID)
	VALUES(@ContractID,478)

	INSERT INTO ContractToServiceLocation(ContractID, ServiceLocationID)
	VALUES(@ContractID,419)
END


INSERT INTO Contract(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, 
					 NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated)
VALUES(@SpecPracticeID,'Standard (Spec)', 'S', GETDATE(), DATEADD(Y,1,GETDATE()), 45, 45, 0)

SET @ContractID=@@IDENTITY

INSERT INTO ContractFeeSchedule(ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU,
								ProcedureCodeDictionaryID)
SELECT @ContractID, CASE WHEN FTI.Mod='' THEN NULL ELSE FTI.Mod END Mod, 'B', F.Standard, 0, 0, 0, PCD.ProcedureCodeDictionaryID
FROM @FeesToImport FTI INNER JOIN @Fees F
ON FTI.MaxID=F.TID
INNER JOIN ProcedureCodeDictionary PCD
ON F.ProcedureCode=PCD.ProcedureCode
WHERE F.FID=2

IF @SpecPracticeID=113
BEGIN
	INSERT INTO ContractToServiceLocation(ContractID, ServiceLocationID)
	VALUES(@ContractID,418)

	INSERT INTO ContractToServiceLocation(ContractID, ServiceLocationID)
	VALUES(@ContractID,420)
END


INSERT INTO Contract(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, 
					 NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated)
VALUES(@YLPracticeID,'Standard', 'S', GETDATE(), DATEADD(Y,1,GETDATE()), 45, 45, 0)

SET @ContractID=@@IDENTITY

INSERT INTO ContractFeeSchedule(ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU,
								ProcedureCodeDictionaryID)
SELECT @ContractID, CASE WHEN FTI.Mod='' THEN NULL ELSE FTI.Mod END Mod, 'B', F.Standard, 0, 0, 0, PCD.ProcedureCodeDictionaryID
FROM @FeesToImport FTI INNER JOIN @Fees F
ON FTI.MaxID=F.TID
INNER JOIN ProcedureCodeDictionary PCD
ON F.ProcedureCode=PCD.ProcedureCode
WHERE F.FID=4

IF @YLPracticeID=115
	INSERT INTO ContractToServiceLocation(ContractID, ServiceLocationID)
	VALUES(@ContractID,417)

--WorkersComp Fee Schedule Import

--Caduceus
INSERT INTO Contract(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, 
					 NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated)
VALUES(113,'WorkersComp', 'S', GETDATE(), DATEADD(Y,1,GETDATE()), 45, 45, 0)

SET @ContractID=@@IDENTITY

INSERT INTO ContractFeeSchedule(ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU,
								ProcedureCodeDictionaryID)
SELECT @ContractID, Mod, 'B', Rate, 0, 0, RVU, PCD.ProcedureCodeDictionaryID
FROM WCFees WC INNER JOIN ProcedureCodeDictionary PCD
ON WC.CPT=PCD.ProcedureCode


--YL
INSERT INTO Contract(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, 
					 NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated)
VALUES(115,'WorkersComp', 'S', GETDATE(), DATEADD(Y,1,GETDATE()), 45, 45, 0)

SET @ContractID=@@IDENTITY

INSERT INTO ContractFeeSchedule(ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU,
								ProcedureCodeDictionaryID)
SELECT @ContractID, Mod, 'B', Rate, 0, 0, RVU, PCD.ProcedureCodeDictionaryID
FROM WCFees WC INNER JOIN ProcedureCodeDictionary PCD
ON WC.CPT=PCD.ProcedureCode

--Medi Cal Fee Schedule Import

--Caduceus
INSERT INTO Contract(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, 
					 NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated)
VALUES(113,'Medi Cal', 'S', GETDATE(), DATEADD(Y,1,GETDATE()), 45, 45, 0)

SET @ContractID=@@IDENTITY

INSERT INTO ContractFeeSchedule(ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU,
								ProcedureCodeDictionaryID)
SELECT @ContractID, NULL, 'B', Rate, 0, 0, 0, PCD.ProcedureCodeDictionaryID
FROM MedicalFees M INNER JOIN ProcedureCodeDictionary PCD
ON M.CPT=PCD.ProcedureCode


--YL
INSERT INTO Contract(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, 
					 NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated)
VALUES(115,'Medi Cal', 'S', GETDATE(), DATEADD(Y,1,GETDATE()), 45, 45, 0)

SET @ContractID=@@IDENTITY

INSERT INTO ContractFeeSchedule(ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU,
								ProcedureCodeDictionaryID)
SELECT @ContractID, NULL, 'B', Rate, 0, 0, 0, PCD.ProcedureCodeDictionaryID
FROM MedicalFees M INNER JOIN ProcedureCodeDictionary PCD
ON M.CPT=PCD.ProcedureCode

--Medi Care Fee Schedule Import

--Caduceus
INSERT INTO Contract(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, 
					 NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated)
VALUES(113,'Medi Care', 'S', GETDATE(), DATEADD(Y,1,GETDATE()), 45, 45, 0)

SET @ContractID=@@IDENTITY

INSERT INTO ContractFeeSchedule(ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU,
								ProcedureCodeDictionaryID)
SELECT @ContractID, Mod, 'B', Rate, 0, 0, 0, PCD.ProcedureCodeDictionaryID
FROM MedicareFees M INNER JOIN ProcedureCodeDictionary PCD
ON M.CPT=PCD.ProcedureCode


--YL
INSERT INTO Contract(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, 
					 NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated)
VALUES(115,'Medi Care', 'S', GETDATE(), DATEADD(Y,1,GETDATE()), 45, 45, 0)

SET @ContractID=@@IDENTITY

INSERT INTO ContractFeeSchedule(ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU,
								ProcedureCodeDictionaryID)
SELECT @ContractID, Mod, 'B', Rate, 0, 0, 0, PCD.ProcedureCodeDictionaryID
FROM MedicareFees M INNER JOIN ProcedureCodeDictionary PCD
ON M.CPT=PCD.ProcedureCode

--COMMIT TRAN
--ROLLBACK TRAN
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Temp Table Clean up
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--======================================================================================
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DROP TABLE #Demo
DROP TABLE #YLDemo
DROP TABLE #PCP
DROP TABLE #YLPCP
DROP TABLE #Doc
DROP TABLE #YLDoc
DROP TABLE #Subscriber
DROP TABLE #Guarantor

--Patient Insurances
DROP TABLE #PatIns
DROP TABLE #RecentPatIns
DROP TABLE #FinalPatIns

DROP TABLE #YLPatIns
DROP TABLE #YLRecentPatIns
DROP TABLE #YLFinalPatIns

--Patient Cases
DROP TABLE #PatPC

DROP TABLE #YLPC

--Practice Insurance
DROP TABLE #InsMaster
DROP TABLE #InsCompanyPlans
DROP TABLE #InsCompany
DROP TABLE #NewCompany
DROP TABLE #NewCompanyToPlan
DROP TABLE #UniqueInsMaster
DROP TABLE #InsCleaned
DROP TABLE #YLInsCleaned
DROP TABLE #Ins
DROP TABLE #YLIns

--COMMIT TRAN
--ROLLBACK TRAN