--BEGIN TRAN

CREATE TABLE #DupPatientsToDelete(PatientID INT)
INSERT INTO #DupPatientsToDelete(PatientID)
SELECT P.PatientID
FROM Patient P INNER JOIN Cad_YL_Dups CY
ON P.MedicalRecordNumber=CY.[Medical#]
WHERE PracticeID IN (113,114,115,116) AND CY.[Delete]='x'

DELETE IP
FROM #DupPatientsToDelete DP
INNER JOIN PatientCase PC 
ON DP.PatientID=PC.PatientID
INNER JOIN InsurancePolicy IP
ON PC.PatientCaseID=IP.PatientCaseID
WHERE PC.PracticeID IN (113,114,115,116)

DELETE PCD
FROM #DupPatientsToDelete DP
INNER JOIN PatientCase PC 
ON DP.PatientID=PC.PatientID
INNER JOIN PatientCaseDate PCD
ON PC.PatientCaseID=PCD.PatientCaseID
WHERE PC.PracticeID IN (113,114,115,116)

DELETE PC
FROM #DupPatientsToDelete DP
INNER JOIN PatientCase PC 
ON DP.PatientID=PC.PatientID
WHERE PracticeID IN (113,114,115,116)

DELETE PJN
FROM #DupPatientsToDelete DP 
INNER JOIN PatientJournalNote PJN
ON DP.PatientID=PJN.PatientID

DELETE PA
FROM #DupPatientsToDelete DP 
INNER JOIN PatientAlert PA
ON DP.PatientID=PA.PatientID

DELETE P
FROM #DupPatientsToDelete DP 
INNER JOIN Patient P
ON DP.PatientID=P.PatientID
WHERE PracticeID IN (113,114,115,116)

DROP TABLE #DupPatientsToDelete

UPDATE PC SET Name=CASE WHEN DP.Cs='1' THEN '12-Personal Injury' ELSE '9-Auto' END,
PayerScenarioID=CASE WHEN DP.PS='' THEN 5 ELSE DP.PS END
FROM Patient P INNER JOIN Cad_YL_Dups DP
ON P.MedicalRecordNumber=DP.[Medical#]
INNER JOIN PatientCase PC
ON P.PatientID=PC.PatientID
WHERE Cs<>'' OR PS<>''

CREATE TABLE #AddlCases(CaseMedicalNo VARCHAR(50), PrimaryMedicalNo VARCHAR(50), PatientIDToRef INT)
INSERT INTO #AddlCases(CaseMedicalNo, PrimaryMedicalNo)
SELECT [Medical#], 
SUBSTRING([Medical#],1,CHARINDEX('.',[Medical#]))+RIGHT([Medical#],1)
FROM Cad_YL_Dups
WHERE LEN([Medical#])-CHARINDEX('.',[Medical#])=2

CREATE TABLE #PrimaryCase(MedicalNo VARCHAR(50))
INSERT INTO #PrimaryCase(MedicalNo)
SELECT DISTINCT CD.[Medical#]
FROM Cad_YL_Dups CD INNER JOIN #AddlCases AC
ON CD.[Medical#]=AC.PrimaryMedicalNo
WHERE LEN(CD.[Medical#])-CHARINDEX('.',CD.[Medical#])=1

UPDATE AC SET PatientIDToRef=PatientID
FROM Patient P INNER JOIN #AddlCases AC
ON P.MedicalRecordNumber=AC.PrimaryMedicalNo
WHERE P.PracticeID IN (113,114,115,116)

DELETE AC
FROM #AddlCases AC LEFT JOIN #PrimaryCase PC
ON AC.PrimaryMedicalNo=PC.MedicalNo
WHERE PC.MedicalNo IS NULL

UPDATE PC SET PatientID = AC.PatientIDToRef, VendorID=PrimaryMedicalNo
FROM #AddlCases AC INNER JOIN Patient P
ON AC.CaseMedicalNo=P.MedicalRecordNumber
INNER JOIN PatientCase PC
ON P.PatientID=PC.PatientID
WHERE P.PracticeID IN(113,114,115,116)

CREATE TABLE #DupsToDelete(PatientID INT)
INSERT INTO #DupsToDelete(PatientID)
SELECT DISTINCT P.PatientID
FROM #AddlCases AC INNER JOIN Patient P
ON AC.CaseMedicalNo=P.MedicalRecordNumber
WHERE P.PracticeID IN (113,114,115,116)

DELETE IP
FROM #DupsToDelete DP
INNER JOIN PatientCase PC 
ON DP.PatientID=PC.PatientID
INNER JOIN InsurancePolicy IP
ON PC.PatientCaseID=IP.PatientCaseID
WHERE PC.PracticeID IN (113,114,115,116)

DELETE PCD
FROM #DupsToDelete DP
INNER JOIN PatientCase PC 
ON DP.PatientID=PC.PatientID
INNER JOIN PatientCaseDate PCD
ON PC.PatientCaseID=PCD.PatientCaseID
WHERE PC.PracticeID IN (113,114,115,116)

DELETE PC
FROM #DupsToDelete DP
INNER JOIN PatientCase PC 
ON DP.PatientID=PC.PatientID
WHERE PracticeID IN (113,114,115,116)

DELETE PJN
FROM #DupsToDelete DP 
INNER JOIN PatientJournalNote PJN
ON DP.PatientID=PJN.PatientID

DELETE PA
FROM #DupsToDelete DP 
INNER JOIN PatientAlert PA
ON DP.PatientID=PA.PatientID

DELETE P
FROM #DupsToDelete DP 
INNER JOIN Patient P
ON DP.PatientID=P.PatientID
WHERE PracticeID IN (113,114,115,116)

DROP TABLE #PrimaryCase
DROP TABLE #AddlCases
DROP TABLE #DupsToDelete

--ROLLBACK TRAN
--COMMIT TRAN