UPDATE DCD SET DiagnosisName=IC.DiagnosisName
FROM DiagnosisCodeDictionary DCD INNER JOIN ICD9Cleaned IC
ON DCD.DiagnosisCode=IC.DiagnosisCode

CREATE TABLE #CodesToImport(ICDID INT, DiagnosisCode VARCHAR(12), DiagnosisName VARCHAR(100))
INSERT INTO #CodesToImport(ICDID, DiagnosisCode, DiagnosisName)
SELECT ICDID, IC.DiagnosisCode, IC.DiagnosisName
FROM ICD9Cleaned IC LEFT JOIN DiagnosisCodeDictionary DCD
ON IC.DiagnosisCode=DCD.DiagnosisCode
WHERE DCD.DiagnosisCode IS NULL

CREATE TABLE #Dups(DiagnosisCode VARCHAR(12))
INSERT INTO #Dups(DiagnosisCode)
SELECT DiagnosisCode
FROM #CodesToImport
GROUP BY DiagnosisCode
HAVING COUNT(DISTINCT DiagnosisName)>1

CREATE TABLE #DupsWMax(DiagnosisCode VARCHAR(12), MaxID INT)
INSERT INTO #DupsWMax(DiagnosisCode, MaxID)
SELECT D.DiagnosisCode, MAX(ICDID) MaxID
FROM #Dups D INNER JOIN #CodesToImport CTI
ON D.DiagnosisCode=CTI.DiagnosisCode
GROUP BY D.DiagnosisCode

DELETE CTI
FROM #CodesToImport CTI INNER JOIN #DupsWMax D
ON CTI.DiagnosisCode=D.DiagnosisCode AND CTI.ICDID<>D.MaxID

INSERT INTO DiagnosisCodeDictionary(DiagnosisCode, DiagnosisName)
SELECT DISTINCT DiagnosisCode, DiagnosisName
FROM #CodesToImport

DROP TABLE #CodesToImport
DROP TABLE #Dups
DROP TABLE #DupsWMax