USE superbill_42703_dev
GO


CREATE TABLE #DupedPats (PracticeName VARCHAR(256) , PatientID INT , FirstName VARCHAR(256) , LastName VARCHAR(256) , 
						 DOB DATE , SSN VARCHAR(9) , EncounterID1 INT , EncounterID1_DOS DATE , EncounterID2 INT , 
						 EncounterID2_DOS DATE , EncounterID3 INT , EncounterID3_DOS DATE , EncounterID4 INT , 
						 EncounterID4_DOS DATE , EncounterID5 INT , EncounterID5_DOS DATE , EncounterID6 INT , EncounterID6_DOS DATE ,
						 EncounterID7 INT , EncounterID7_DOS DATE , EncounterID8 INT , EncounterID8_DOS DATE )
INSERT INTO #DupedPats
        ( PracticeName ,
          PatientID ,
          FirstName ,
          LastName ,
          DOB ,
          SSN
        )
SELECT 
pr.Name , 
p.PatientID , 
p.firstname , 
p.lastname , 
p.dob ,
p.SSN
FROM dbo.Patient p
INNER JOIN dbo.Practice pr ON p.PracticeID = pr.PracticeID
WHERE (SELECT COUNT(*) FROM dbo.Patient p2 WHERE p.FirstName = p2.FirstName AND
												 p.LastName = p2.LastName AND
												 p.DOB = p2.DOB) > 1

UPDATE #DupedPats
SET 
EncounterID1 =Enc1.EncounterID , 
EncounterID1_DOS = CONVERT(VARCHAR,Enc1.DateOfService,101) ,
EncounterID2 = Enc2.EncounterID , 
EncounterID2_DOS = CONVERT(VARCHAR,Enc2.DateOfService,101) ,
EncounterID3 = Enc3.EncounterID , 
EncounterID3_DOS = CONVERT(VARCHAR,Enc3.DateOfService,101) ,
EncounterID4 = Enc4.EncounterID , 
EncounterID4_DOS = CONVERT(VARCHAR,Enc4.DateOfService,101) , 
EncounterID5 = Enc5.EncounterID , 
EncounterID5_DOS = CONVERT(VARCHAR,Enc5.DateOfService,101) , 
EncounterID6 = Enc6.EncounterID , 
EncounterID6_DOS = CONVERT(VARCHAR,Enc6.DateOfService,101) , 
EncounterID7 = Enc7.EncounterID , 
EncounterID7_DOS = CONVERT(VARCHAR,Enc7.DateOfService,101) ,
EncounterID8 = Enc8.EncounterID , 
EncounterID8_DOS = CONVERT(VARCHAR,Enc8.DateOfService,101) 
FROM #DupedPats p
LEFT JOIN  (
SELECT EncounterID , DateOfService , PatientID , ROW_NUMBER() OVER(PARTITION BY PatientID ORDER BY EncounterID DESC) AS EncNum FROM dbo.Encounter 
		   ) AS Enc1  ON p.PatientID = Enc1.PatientID AND Enc1.EncNum = 1
LEFT JOIN  (
SELECT EncounterID , DateOfService , PatientID , ROW_NUMBER() OVER(PARTITION BY PatientID ORDER BY EncounterID DESC) AS EncNum FROM dbo.Encounter 
		   ) AS Enc2  ON p.PatientID = Enc2.PatientID AND Enc2.EncNum = 2
LEFT JOIN  (
SELECT EncounterID , DateOfService , PatientID , ROW_NUMBER() OVER(PARTITION BY PatientID ORDER BY EncounterID DESC) AS EncNum FROM dbo.Encounter 
		   ) AS Enc3  ON p.PatientID = Enc3.PatientID AND Enc3.EncNum = 3
LEFT JOIN  (
SELECT EncounterID , DateOfService , PatientID , ROW_NUMBER() OVER(PARTITION BY PatientID ORDER BY EncounterID DESC) AS EncNum FROM dbo.Encounter 
		   ) AS Enc4  ON p.PatientID = Enc4.PatientID AND Enc4.EncNum = 4
LEFT JOIN  (
SELECT EncounterID , DateOfService , PatientID , ROW_NUMBER() OVER(PARTITION BY PatientID ORDER BY EncounterID DESC) AS EncNum FROM dbo.Encounter 
		   ) AS Enc5  ON p.PatientID = Enc5.PatientID AND Enc5.EncNum = 5
LEFT JOIN  (
SELECT EncounterID , DateOfService , PatientID , ROW_NUMBER() OVER(PARTITION BY PatientID ORDER BY EncounterID DESC) AS EncNum FROM dbo.Encounter 
		   ) AS Enc6  ON p.PatientID = Enc6.PatientID AND Enc6.EncNum = 6
LEFT JOIN  (
SELECT EncounterID , DateOfService , PatientID , ROW_NUMBER() OVER(PARTITION BY PatientID ORDER BY EncounterID DESC) AS EncNum FROM dbo.Encounter 
		   ) AS Enc7  ON p.PatientID = Enc7.PatientID AND Enc7.EncNum = 7
LEFT JOIN  (
SELECT EncounterID , DateOfService , PatientID , ROW_NUMBER() OVER(PARTITION BY PatientID ORDER BY EncounterID DESC) AS EncNum FROM dbo.Encounter 
		   ) AS Enc8  ON p.PatientID = Enc8.PatientID AND Enc8.EncNum = 8

		   SELECT * FROM #DupedPats
DROP TABLE #DupedPats

/*==========================================================================*/
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--
--CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
--INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo._import_5_2_PatientDemographics2 i ON p.PatientID = i.id

--INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo._import_5_2_PatientDemographics3 i ON p.PatientID = i.id

--UNION 

--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo._import_5_2_PatientDemographics4 i ON p.PatientID = i.id

--UNION

--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo._import_5_2_PatientDemographics5 i ON p.PatientID = i.id

--UNION

--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo._import_5_2_PatientDemographics7 i ON p.PatientID = i.id

--UNION

--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo._import_5_2_PatientDemographics8 i ON p.PatientID = i.id

--PRINT ''
--PRINT 'Updating Existing Patients Demographics...'
--UPDATE dbo.Patient 
--	SET DOB = i.DateofBirth  ,
--		SSN = i.ssn
--FROM #updatepat i 
--INNER JOIN dbo.Patient p ON
--	p.PatientID = i.patientid
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--DROP TABLE #updatepat

/*==========================================================================*/

--ROLLBACK
--COMMIT
