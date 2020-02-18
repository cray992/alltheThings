SELECT CASE WHEN E.DoctorID = 133 THEN 'Abraham A. Cherrick' ELSE '' END 'Rendering Provider', 
E.EncounterID, C.ClaimID, EP.ProcedureDateOfService, 
ISNULL(EP.ServiceChargeAmount,0)*ISNULL(EP.ServiceUnitCount,1) Amount, 
CASE WHEN EP.ProcedureCodeDictionaryID =595 THEN '20550' 
	WHEN EP.ProcedureCodeDictionaryID =596 THEN '20551'
	WHEN EP.ProcedureCodeDictionaryID =597 THEN '20552'
	WHEN EP.ProcedureCodeDictionaryID =598 THEN '20553'
	ELSE '' END 'CPT Code',
ISNULL(DCD1.DiagnosisCode, '') Diagnosis1,
ISNULL(DCD2.DiagnosisCode, '') Diagnosis2,
ISNULL(DCD3.DiagnosisCode, '') Diagnosis3,
ISNULL(DCD4.DiagnosisCode, '') Diagnosis4
FROM Encounter E INNER JOIN EncounterProcedure EP
ON E.EncounterID=EP.EncounterID AND ProcedureCodeDictionaryID IN (595,596,597,598)
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
WHERE E.PracticeID=65 AND DoctorID=133
AND (DCD1.DiagnosisCode IS NOT NULL 
	OR DCD2.DiagnosisCode IS NOT NULL  
	OR DCD3.DiagnosisCode IS NOT NULL 
	OR DCD4.DiagnosisCode IS NOT NULL)
ORDER BY EncounterID, ClaimID 


/*
06/20/2006

Maria,
 
Can you run a report manually to show this information for Department B (PM&R Resources)?  I think this is a report off the claims table where you'd need to show Encounter ID, Claim ID, Service Date, Rendering Provider, Procedure Code, Diag 1, Diag 2, Diag 3, Diag 4 that meet the procedure code and diagnosis criteria below.  Please reply to all with this information in Excel, if you can.
 
Thanks,
 
Dan Rodrigues
Founder/CEO
Kareo - On Demand Revenue Cycle Automation.
Office: 888.77.KAREO
Mobile: 310.666.2941
Email: danr@kareo.com
Visit: http://www.kareo.com/

--------------------------------------------------------------------------------
From: Hege Arvesu [mailto:hege@departmentb.com] 
Sent: Tuesday, June 20, 2006 11:46 AM
To: Dan Rodrigues
Subject: Dr Cherrick
Importance: High

Dan, 

I was wondering if there is any way please please to have a report created for a special project. This is what I am looking for: Charges for Dr Cherrick with Physical Medicine Associates, LTD. I am looking for encounters/claims containing the following CPT codes, 20550, 20551, 20552, 20553 billed with diagnosis 720.1.

I am at a loss as to where to start looking on my own here… 

Thank you, 

Hege C Arvesu
*/

