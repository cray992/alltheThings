UPDATE diagnosiscodedictionary SET DiagnosisCode=
CASE WHEN LEN(DiagnosisCode)=5 THEN LEFT(DiagnosisCode,3)+SUBSTRING(DiagnosisCode,5,1)
ELSE LEFT(DiagnosisCode,3)+SUBSTRING(DiagnosisCode,5,1)+'.'+RIGHT(DiagnosisCode,LEN(DiagnosisCode)-5) END
where left(diagnosiscode,1)='E' 
AND SUBSTRING(diagnosiscode,2,1) IN ('0','1','2','3','4','5','6','7','8','9')
AND CHARINDEX('.',DiagnosisCode)=4

UPDATE diagnosiscodedictionary SET DiagnosisCode=
LEFT(CASE WHEN CHARINDEX('.',DiagnosisCode)=0 THEN DiagnosisCode
ELSE REPLACE(DiagnosisCode,'.','') END,3)+'.'+RIGHT(CASE WHEN CHARINDEX('.',DiagnosisCode)=0 THEN DiagnosisCode
ELSE REPLACE(DiagnosisCode,'.','') END,LEN(CASE WHEN CHARINDEX('.',DiagnosisCode)=0 THEN DiagnosisCode
ELSE REPLACE(DiagnosisCode,'.','') END)-3)
where left(diagnosiscode,1)='V' 
AND SUBSTRING(diagnosiscode,2,1) IN ('0','1','2','3','4','5','6','7','8','9')
AND CHARINDEX('.',DiagnosisCode)=5 OR 
left(diagnosiscode,1)='V' AND SUBSTRING(diagnosiscode,2,1) IN ('0','1','2','3','4','5','6','7','8','9')
AND LEN(DiagnosisCode)=4 AND CHARINDEX('.',DiagnosisCode)=0