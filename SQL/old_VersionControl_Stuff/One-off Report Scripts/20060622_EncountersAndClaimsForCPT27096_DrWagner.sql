-- Report for diagnosis 720.1, Dr. Robert H. Wagner, Physical Medicine Associates, LTD
SELECT CASE WHEN E.DoctorID = 136 THEN 'Robert H. Wagner' ELSE '' END 'Rendering Provider', 
E.EncounterID, C.ClaimID, EP.ProcedureDateOfService, 
ISNULL(EP.ServiceChargeAmount,0)*ISNULL(EP.ServiceUnitCount,1) Amount, 
CASE WHEN EP.ProcedureCodeDictionaryID = 47 THEN '27096' 
	ELSE '' END 'CPT Code',
ISNULL(DCD1.DiagnosisCode, '') Diagnosis1,
ISNULL(DCD2.DiagnosisCode, '') Diagnosis2,
ISNULL(DCD3.DiagnosisCode, '') Diagnosis3,
ISNULL(DCD4.DiagnosisCode, '') Diagnosis4
FROM Encounter E INNER JOIN EncounterProcedure EP
ON E.EncounterID=EP.EncounterID AND ProcedureCodeDictionaryID = 47
LEFT JOIN EncounterDiagnosis ED1
ON EP.EncounterDiagnosisID1=ED1.EncounterDiagnosisID AND ED1.DiagnosisCodeDictionaryID=4447
LEFT JOIN EncounterDiagnosis ED2
ON EP.EncounterDiagnosisID2=ED2.EncounterDiagnosisID AND ED2.DiagnosisCodeDictionaryID=4447
LEFT JOIN EncounterDiagnosis ED3
ON EP.EncounterDiagnosisID3=ED3.EncounterDiagnosisID AND ED3.DiagnosisCodeDictionaryID=4447
LEFT JOIN EncounterDiagnosis ED4
ON EP.EncounterDiagnosisID4=ED4.EncounterDiagnosisID AND ED4.DiagnosisCodeDictionaryID=4447
LEFT JOIN Claim C
ON EP.EncounterProcedureID=C.EncounterProcedureID
LEFT JOIN DiagnosisCodeDictionary DCD1 ON DCD1.DiagnosisCodeDictionaryid = ED1.DiagnosisCodeDictionaryID
LEFT JOIN DiagnosisCodeDictionary DCD2 ON DCD2.DiagnosisCodeDictionaryid = ED2.DiagnosisCodeDictionaryID
LEFT JOIN DiagnosisCodeDictionary DCD3 ON DCD3.DiagnosisCodeDictionaryid = ED3.DiagnosisCodeDictionaryID
LEFT JOIN DiagnosisCodeDictionary DCD4 ON DCD4.DiagnosisCodeDictionaryid = ED4.DiagnosisCodeDictionaryID
WHERE E.PracticeID=65 AND DoctorID=136
AND (DCD1.DiagnosisCode = '720.1' 
	OR DCD2.DiagnosisCode = '720.1'  
	OR DCD3.DiagnosisCode = '720.1'
	OR DCD4.DiagnosisCode = '720.1')

/*AND (DCD1.DiagnosisCode IS NOT NULL 
	OR DCD2.DiagnosisCode IS NOT NULL  
	OR DCD3.DiagnosisCode IS NOT NULL 
	OR DCD4.DiagnosisCode IS NOT NULL) */
ORDER BY EncounterID, ClaimID 

-- All diagnoses:

SELECT CASE WHEN E.DoctorID = 136 THEN 'Robert H. Wagner' ELSE '' END 'Rendering Provider', 
E.EncounterID, C.ClaimID, EP.ProcedureDateOfService, 
ISNULL(EP.ServiceChargeAmount,0)*ISNULL(EP.ServiceUnitCount,1) Amount, 
CASE WHEN EP.ProcedureCodeDictionaryID = 47 THEN '27096' 
	ELSE '' END 'CPT Code',
ISNULL(DCD1.DiagnosisCode, '') Diagnosis1,
ISNULL(DCD2.DiagnosisCode, '') Diagnosis2,
ISNULL(DCD3.DiagnosisCode, '') Diagnosis3,
ISNULL(DCD4.DiagnosisCode, '') Diagnosis4
FROM Encounter E INNER JOIN EncounterProcedure EP
ON E.EncounterID=EP.EncounterID AND ProcedureCodeDictionaryID = 47
LEFT JOIN EncounterDiagnosis ED1
ON EP.EncounterDiagnosisID1=ED1.EncounterDiagnosisID 
LEFT JOIN EncounterDiagnosis ED2
ON EP.EncounterDiagnosisID2=ED2.EncounterDiagnosisID 
LEFT JOIN EncounterDiagnosis ED3
ON EP.EncounterDiagnosisID3=ED3.EncounterDiagnosisID 
LEFT JOIN EncounterDiagnosis ED4
ON EP.EncounterDiagnosisID4=ED4.EncounterDiagnosisID 
LEFT JOIN Claim C
ON EP.EncounterProcedureID=C.EncounterProcedureID
LEFT JOIN DiagnosisCodeDictionary DCD1 ON DCD1.DiagnosisCodeDictionaryid = ED1.DiagnosisCodeDictionaryID
LEFT JOIN DiagnosisCodeDictionary DCD2 ON DCD2.DiagnosisCodeDictionaryid = ED2.DiagnosisCodeDictionaryID
LEFT JOIN DiagnosisCodeDictionary DCD3 ON DCD3.DiagnosisCodeDictionaryid = ED3.DiagnosisCodeDictionaryID
LEFT JOIN DiagnosisCodeDictionary DCD4 ON DCD4.DiagnosisCodeDictionaryid = ED4.DiagnosisCodeDictionaryID
WHERE E.PracticeID=65 AND DoctorID=136
AND (DCD1.DiagnosisCode IS NOT NULL 
	OR DCD2.DiagnosisCode IS NOT NULL  
	OR DCD3.DiagnosisCode IS NOT NULL 
	OR DCD4.DiagnosisCode IS NOT NULL) 
ORDER BY EncounterID, ClaimID 


