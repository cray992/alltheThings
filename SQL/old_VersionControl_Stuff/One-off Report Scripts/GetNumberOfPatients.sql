
SELECT SUM(PatientCnt) AS PatientCnt
FROM (
SELECT e.PracticeId, COUNT(DISTINCT patient.PatientId)PatientCnt
FROM Patient
INNER JOIN Encounter AS e ON Patient.PatientID = e.PatientID
WHERE e.CreatedDate BETWEEN DATEADD(yy,-1,GETDATE()) AND GETDATE()
GROUP BY e.PracticeId) sub