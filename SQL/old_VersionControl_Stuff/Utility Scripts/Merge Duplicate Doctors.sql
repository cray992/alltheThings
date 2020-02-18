-- Script for merging duplicate doctors
-- C. Bagby 11/6/06

-- create Temp Tmp of Duplicate Doctors to be Deleted
SELECT PracticeID, DoctorID, FirstName, LastName
INTO #TmpDeleteDr
FROM dbo.Doctor AS Doc_Out
WHERE (PracticeID IN (113, 115)) AND EXISTS
  (SELECT NULL AS Expr1
    FROM dbo.Doctor AS Doc_In
    WHERE (PracticeID = Doc_Out.PracticeID) AND (Doc_Out.FirstName = FirstName) AND (Doc_Out.LastName = LastName)
    GROUP BY PracticeID, FirstName, LastName
    HAVING (Doc_Out.DoctorID > MIN(DoctorID)) AND (COUNT(LastName) > 1))
ORDER BY PracticeID, LastName


-- Temp table of good doctors (keep records)
-- Table of doctors with min DoctorID happens to also be Internal Doctors and Doctors with lower case names

SELECT PracticeID, DoctorID, FirstName, LastName
INTO #TmpKeepDr
FROM dbo.Doctor AS Doc_Out
WHERE (PracticeID IN (113, 115)) AND EXISTS
  (SELECT NULL AS Expr1
    FROM dbo.Doctor AS Doc_In
    WHERE (PracticeID = Doc_Out.PracticeID) AND (Doc_Out.FirstName = FirstName) AND (Doc_Out.LastName = LastName)
    GROUP BY PracticeID, FirstName, LastName
    HAVING (Doc_Out.DoctorID = MIN(DoctorID)) AND (COUNT(LastName) > 1))
ORDER BY PracticeID, LastName

-- Create new ProviderNumber records for KeepDotorID
-- where DoctorID will be deleted
INSERT INTO ProviderNumber(DoctorID, ProviderNumberTypeID, InsuranceCompanyPlanID, 
LocationID, ProviderNumber, AttachConditionsTypeID)
SELECT TmpKeeplDr_1.DoctorID, DeleteDr_ProviderNum.ProviderNumberTypeID, DeleteDr_ProviderNum.InsuranceCompanyPlanID, 
DeleteDr_ProviderNum.LocationID, DeleteDr_ProviderNum.ProviderNumber, DeleteDr_ProviderNum.AttachConditionsTypeID
FROM #TmpKeepDr AS TmpKeeplDr_1 INNER JOIN
     (
	SELECT DISTINCT TmpDeleteDr_1.FirstName, TmpDeleteDr_1.LastName, 
	ProviderNumber.ProviderNumberTypeID, ProviderNumber.InsuranceCompanyPlanID, 
    ProviderNumber.LocationID, ProviderNumber.ProviderNumber, ProviderNumber.AttachConditionsTypeID
	FROM #TmpDeleteDr AS TmpDeleteDr_1
	INNER JOIN dbo.ProviderNumber 
	ON TmpDeleteDr_1.DoctorID = ProviderNumber.DoctorID
	) AS DeleteDr_ProviderNum 
		ON TmpKeeplDr_1.FirstName = DeleteDr_ProviderNum.FirstName 
		AND TmpKeeplDr_1.LastName = DeleteDr_ProviderNum.LastName 
		LEFT OUTER JOIN
        (
		SELECT TmpKeepDr_2.DoctorID, TmpKeepDr_2.FirstName, TmpKeepDr_2.LastName, dbo.ProviderNumber.ProviderNumberTypeID, 
                      dbo.ProviderNumber.InsuranceCompanyPlanID, dbo.ProviderNumber.LocationID, dbo.ProviderNumber.ProviderNumber, 
                      dbo.ProviderNumber.AttachConditionsTypeID
                FROM #TmpKeepDr AS TmpKeepDr_2
					INNER JOIN dbo.ProviderNumber 
				ON TmpKeepDr_2.DoctorID = dbo.ProviderNumber.DoctorID
		) AS KeepDr_ProviderNum 
			ON 
          DeleteDr_ProviderNum.FirstName = KeepDr_ProviderNum.FirstName AND 
		  DeleteDr_ProviderNum.LastName = KeepDr_ProviderNum.LastName AND 
          DeleteDr_ProviderNum.ProviderNumberTypeID = KeepDr_ProviderNum.ProviderNumberTypeID AND 
          DeleteDr_ProviderNum.ProviderNumber = KeepDr_ProviderNum.ProviderNumber AND 
          DeleteDr_ProviderNum.AttachConditionsTypeID = KeepDr_ProviderNum.AttachConditionsTypeID
WHERE     (KeepDr_ProviderNum.LastName IS NULL)
ORDER BY TmpKeeplDr_1.DoctorID


--Update Patient table
-- Primary Doctor
UPDATE Patient
SET PrimaryCarePhysicianID = TmpKeepDr_1.DoctorID
FROM #TmpDeleteDr AS TmpDeleteDr_1 
INNER JOIN #TmpKeepDr AS TmpKeepDr_1 
ON TmpDeleteDr_1.FirstName = TmpKeepDr_1.FirstName 
AND TmpDeleteDr_1.LastName = TmpKeepDr_1.LastName 
INNER JOIN dbo.Patient 
ON TmpDeleteDr_1.DoctorID = dbo.Patient.PrimaryCarePhysicianID

-- Update Patient 
-- Referring Doctor
UPDATE Patient
SET ReferringPhysicianID = TmpKeepDr_1.DoctorID
FROM #TmpDeleteDr AS TmpDeleteDr_1 INNER JOIN
#TmpKeepDr AS TmpKeepDr_1 ON TmpDeleteDr_1.FirstName = TmpKeepDr_1.FirstName AND 
TmpDeleteDr_1.LastName = TmpKeepDr_1.LastName INNER JOIN
dbo.Patient ON TmpDeleteDr_1.DoctorID = dbo.Patient.ReferringPhysicianID

-- Update PatientCase Table
UPDATE PatientCase
SET ReferringPhysicianID = TmpKeepDr_1.DoctorID
FROM  #TmpDeleteDr AS TmpDeleteDr_1 INNER JOIN
dbo.PatientCase ON TmpDeleteDr_1.DoctorID = dbo.PatientCase.ReferringPhysicianID INNER JOIN
#TmpKeepDr AS TmpKeepDr_1 ON TmpDeleteDr_1.FirstName = TmpKeepDr_1.FirstName 
AND TmpDeleteDr_1.LastName = TmpKeepDr_1.LastName

-- Encounter
-- ReferrinngID
UPDATE Encounter
SET ReferringPhysicianID = TmpKeepDr_1.DoctorID
FROM dbo.Encounter INNER JOIN 
#TmpDeleteDr AS TmpDeleteDr_1 INNER JOIN
#TmpKeepDr AS TmpKeepDr_1 
ON TmpDeleteDr_1.FirstName = TmpKeepDr_1.FirstName 
AND TmpDeleteDr_1.LastName = TmpKeepDr_1.LastName 
ON dbo.Encounter.ReferringPhysicianID = TmpDeleteDr_1.DoctorID

-- Encounter
-- DoctorID
UPDATE Encounter
SET DoctorID = TmpKeepDr_1.DoctorID
FROM dbo.Encounter INNER JOIN 
#TmpDeleteDr AS TmpDeleteDr_1 INNER JOIN
#TmpKeepDr AS TmpKeepDr_1 
ON TmpDeleteDr_1.FirstName = TmpKeepDr_1.FirstName 
AND TmpDeleteDr_1.LastName = TmpKeepDr_1.LastName 
ON dbo.Encounter.DoctorID = TmpDeleteDr_1.DoctorID

-- DELETE ProviderNumber
DELETE FROM dbo.ProviderNumber
FROM #TmpDeleteDr AS TmpDeleteDr_1 
INNER JOIN dbo.ProviderNumber 
ON TmpDeleteDr_1.DoctorID = dbo.ProviderNumber.DoctorID

--DELETE Doctor
DELETE FROM dbo.Doctor
FROM #TmpDeleteDr AS TmpDeleteDr_1 
INNER JOIN dbo.Doctor 
ON TmpDeleteDr_1.DoctorID = dbo.Doctor.DoctorID

