DECLARE @436ID INT
SELECT @436ID=DiagnosisCodeDictionaryID
FROM DiagnosisCodeDictionary
WHERE DiagnosisCode='436'

DECLARE @BadCodes TABLE(DiagnosisCodeDictionaryID INT)
INSERT @BadCodes(DiagnosisCodeDictionaryID)
SELECT DiagnosisCodeDictionaryID
FROM DiagnosisCodeDictionary
WHERE DiagnosisCode IN ('436.0','436.01')

UPDATE ED SET DiagnosisCodeDictionaryID=@436ID
FROM EncounterDiagnosis ED INNER JOIN @BadCodes BC
ON ED.DiagnosisCodeDictionaryID=BC.DiagnosisCodeDictionaryID

UPDATE DTE SET DiagnosisCodeDictionaryID=@436ID
FROM DiagnosisCodeDictionaryToCodingTemplate DTE INNER JOIN @BadCodes BC
ON DTE.DiagnosisCodeDictionaryID=BC.DiagnosisCodeDictionaryID

DELETE DiagnosisCodeDictionary
WHERE DiagnosisCode IN ('436.0','436.01')