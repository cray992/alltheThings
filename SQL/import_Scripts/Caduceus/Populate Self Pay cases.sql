CREATE TABLE #PatientsToCreateSelfPayCaseIN(PracticeID INT, PatientID INT, VendorImportID INT, VendorID VARCHAR(50))
INSERT INTO #PatientsToCreateSelfPayCaseIN(PracticeID, PatientID, VendorImportID, VendorID)
SELECT P.PracticeID, P.PatientID, P.VendorImportID, P.VendorID
FROM Patient P LEFT JOIN PatientCase PC
ON P.PatientID=PC.PatientID
WHERE P.PracticeID IN (113,114,115,116)
GROUP BY P.PracticeID, P.PatientID, P.VendorImportID, P.VendorID
HAVING COUNT(CASE WHEN PC.PayerScenarioID=11 THEN 1 ELSE NULL END)=0

INSERT INTO PatientCase (PatientID, Name, PracticeID, PayerScenarioID, VendorImportID, VendorID)
SELECT PatientID, '3-Self-Pay', PracticeID, 11, VendorImportID, VendorID
FROM #PatientsToCreateSelfPayCaseIN

DROP TABLE #PatientsToCreateSelfPayCaseIN