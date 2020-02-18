DECLARE @Loop INT
DECLARE @Count INT

CREATE TABLE #DBs(TID INT IDENTITY(1,1), CustomerID INT, DatabaseName VARCHAR(50), Customer VARCHAR(128))
INSERT INTO #DBs(CustomerID, DatabaseName, Customer)
SELECT CustomerID, DatabaseName, CompanyName
FROM Customer
WHERE DBActive=1 AND CustomerType='N' AND Metrics=1

SET @Loop=@@ROWCOUNT
SET @Count=0

DECLARE @DatabaseName VARCHAR(50)
DECLARE @CustomerID INT

CREATE TABLE #S_ProviderStatus(CustomerID INT, PracticeName VARCHAR(228), ProviderName VARCHAR(128), Degree VARCHAR(8), Status VARCHAR(2), Free BIT)

CREATE TABLE #S_EncounterMetrics(CustomerID INT, PracticeName VARCHAR(228), ProviderName VARCHAR(128), Degree VARCHAR(8), Status VARCHAR(2), Free BIT,
								 LastEncounter DATETIME, AvgP3MMax INT, LMoMax INT, MTDMax INT, PrcOfAvgP3M REAL, PrcOfLMo REAL) 

CREATE TABLE #S_AppointmentMetrics(CustomerID INT, PracticeName VARCHAR(228), ProviderName VARCHAR(128), Degree VARCHAR(8), Status VARCHAR(2), Free BIT,
								   AvgP3M INT, LMo INT, MTD INT, PrcOfAvgP3M REAL, PrcOfLMo REAL)

DECLARE @SQL VARCHAR(MAX)
DECLARE @ExecSQL VARCHAR(MAX)

SET @ExecSQL=''

SET @SQL='

DECLARE @CustomerID INT
SET @CustomerID={0}

CREATE TABLE #Practice(PracticeID INT, Active BIT, PracticeName VARCHAR(128))
INSERT INTO #Practice(PracticeID, Active, PracticeName)
SELECT PracticeID, Active, Name
FROM {1}Practice
WHERE Metrics=1

CREATE TABLE #Doctor(RID INT IDENTITY(1,1), PracticeID INT, Active BIT, ProviderID INT, ProviderName VARCHAR(228), Degree VARCHAR(8), CreatedDate DATETIME)
INSERT INTO #Doctor(PracticeID, Active, ProviderID, ProviderName, Degree, CreatedDate)
SELECT PracticeID, ActiveDoctor Active, DoctorID ProviderID,
RTRIM(ISNULL(D.FirstName + '' '','''') + ISNULL(D.MiddleName + '' '', '''')) + ISNULL('' '' + D.LastName,'''') ProviderName, 
Degree, CreatedDate
FROM {1}Doctor D
WHERE [External]=0 AND CreatedDate<=''7-2-07''

DECLARE @FreeProviderAllowance INT
SELECT @FreeProviderAllowance=CASE WHEN C.CreatedDate<''10/16/2006'' AND DATEDIFF(M,C.CreatedDate,GETDATE())>12 THEN 0
								   WHEN C.CreatedDate>''10/16/2006'' AND DATEDIFF(M,C.CreatedDate,GETDATE())>6 THEN 0
							  ELSE CASE WHEN EditionTypeID=4 THEN 0 WHEN EditionTypeID=2 THEN 2
								   WHEN EditionTypeID=1 THEN 4 ELSE 0 END
							  END
FROM Superbill_Shared..Customer C INNER JOIN Superbill_Shared..CustomerOrder CO
ON C.CustomerID=CO.CustomerID
INNER JOIN Superbill_Shared..CustomerOrderEdition COE
ON CO.CustomerOrderID=COE.CustomerOrderID
WHERE C.CustomerID=@CustomerID

DECLARE @CurrentMoID INT
DECLARE @Today DATETIME

SELECT @CurrentMoID=MoID, @Today=Dt
FROM {1}DateKey
WHERE Dt=CAST(CONVERT(CHAR(10),''7-2-07'',110) AS DATETIME)

CREATE TABLE #QryDates(MoID INT, Mo INT, StartDt DATETIME, EndDt DATETIME)
INSERT INTO #QryDates(MoID, Mo, StartDt, EndDt)
SELECT MoID, Mo, MIN(Dt) StartDt, DATEADD(S,-1,DATEADD(D,1,Max(CASE WHEN Dt>@Today THEN NULL ELSE Dt END))) EndDt
FROM {1}DateKey
WHERE MoID BETWEEN @CurrentMoID-3 AND @CurrentMoID
GROUP BY MoID, Mo
ORDER BY MoID, Mo

CREATE TABLE #ProviderLastEncounter(PracticeID INT, ProviderID INT, LastEncounter DATETIME)
INSERT INTO #ProviderLastEncounter(PracticeID, ProviderID, LastEncounter)
SELECT PracticeID, ProviderID, MAX(LastEncounter) LastEncounter
FROM (
SELECT PracticeID, DoctorID ProviderID, MAX(CreatedDate) LastEncounter
FROM {1}Encounter
GROUP BY PracticeID, DoctorID
UNION
SELECT PracticeID, SupervisingProviderID ProviderID, MAX(CreatedDate) LastEncounter
FROM {1}Encounter
WHERE SupervisingProviderID IS NOT NULL
GROUP BY PracticeID, SupervisingProviderID
UNION
SELECT PracticeID, SchedulingProviderID ProviderID, MAX(CreatedDate) LastEncounter
FROM {1}Encounter
WHERE SchedulingProviderID IS NOT NULL
GROUP BY PracticeID, SchedulingProviderID) LastEncounters
GROUP BY PracticeID, ProviderID

CREATE TABLE #EncounterStatsDetail(PracticeID INT, ProviderID INT, MoID INT, Mo TINYINT, PrimaryCount INT, SupervisingCount INT, SchedulingCount INT)
INSERT INTO #EncounterStatsDetail(PracticeID, ProviderID, MoID, Mo, PrimaryCount, SupervisingCount, SchedulingCount)
SELECT PLE.PracticeID, PLE.ProviderID, QDGrp.MoID, QDGrp.Mo, 
COUNT(CASE WHEN E.DoctorID=PLE.ProviderID THEN 1 ELSE NULL END) PrimaryCount,
COUNT(CASE WHEN E.SupervisingProviderID=PLE.ProviderID THEN 1 ELSE NULL END) SupervisingCount,
COUNT(CASE WHEN E.SchedulingProviderID=PLE.ProviderID THEN 1 ELSE NULL END) SchedulingCount
FROM #ProviderLastEncounter PLE INNER JOIN #QryDates QD
ON QD.MoID=@CurrentMoID-3 AND PLE.LastEncounter>=QD.StartDt
INNER JOIN {1}Encounter E
ON PLE.PracticeID=E.PracticeID AND E.CreatedDate>=QD.StartDt
INNER JOIN #QryDates QDGrp
ON E.CreatedDate BETWEEN QDGrp.StartDt AND QDGrp.EndDt
GROUP BY PLE.PracticeID, PLE.ProviderID, QDGrp.MoID, QDGrp.Mo

CREATE TABLE #EncounterStatsSummaries(PracticeID INT, ProviderID INT, AvgP3M_PrimaryCount INT, AvgP3M_SupervisingCount INT, AvgP3M_SchedulingCount INT,
LMo_PrimaryCount INT, LMo_SupervisingCount INT, LMo_SchedulingCount INT, MTD_PrimaryCount INT, MTD_SupervisingCount INT, MTD_SchedulingCount INT)
INSERT INTO #EncounterStatsSummaries(PracticeID, ProviderID, AvgP3M_PrimaryCount, AvgP3M_SupervisingCount, AvgP3M_SchedulingCount,
LMo_PrimaryCount, LMo_SupervisingCount, LMo_SchedulingCount, MTD_PrimaryCount, MTD_SupervisingCount, MTD_SchedulingCount)
SELECT PracticeID, ProviderID, 
CASE WHEN SUM(CASE WHEN MoID<>@CurrentMoID THEN PrimaryCount ELSE NULL END)<>0 
THEN SUM(CASE WHEN MoID<>@CurrentMoID THEN PrimaryCount ELSE NULL END)/COUNT(CASE WHEN MoID<>@CurrentMoID AND PrimaryCount<>0 THEN PrimaryCount ELSE NULL END)
ELSE 0 END AvgP3M_PrimaryCount,
CASE WHEN SUM(CASE WHEN MoID<>@CurrentMoID THEN SupervisingCount ELSE NULL END)<>0 
THEN SUM(CASE WHEN MoID<>@CurrentMoID THEN SupervisingCount ELSE NULL END)/COUNT(CASE WHEN MoID<>@CurrentMoID AND SupervisingCount<>0 THEN SupervisingCount ELSE NULL END)
ELSE 0 END AvgP3M_SupervisingCount,
CASE WHEN SUM(CASE WHEN MoID<>@CurrentMoID THEN SchedulingCount ELSE NULL END)<>0 
THEN SUM(CASE WHEN MoID<>@CurrentMoID THEN SchedulingCount ELSE NULL END)/COUNT(CASE WHEN MoID<>@CurrentMoID AND SchedulingCount<>0 THEN SchedulingCount ELSE NULL END)
ELSE 0 END AvgP3M_SchedulingCount,
SUM(CASE WHEN MoID=@CurrentMoID-1 THEN PrimaryCount ELSE 0 END) LMo_PrimaryCount,
SUM(CASE WHEN MoID=@CurrentMoID-1 THEN SupervisingCount ELSE 0 END) LMo_SupervisingCount,
SUM(CASE WHEN MoID=@CurrentMoID-1 THEN SchedulingCount ELSE 0 END) LMo_SchedulingCount,
SUM(CASE WHEN MoID=@CurrentMoID THEN PrimaryCount ELSE 0 END) MTD_PrimaryCount,
SUM(CASE WHEN MoID=@CurrentMoID THEN SupervisingCount ELSE 0 END) MTD_SupervisingCount,
SUM(CASE WHEN MoID=@CurrentMoID THEN SchedulingCount ELSE 0 END) MTD_SchedulingCount
FROM #EncounterStatsDetail
GROUP BY PracticeID, ProviderID

CREATE TABLE #EncounterStats(PracticeID INT, ProviderID INT, AvgP3MMax INT, LMoMax INT, MTDMax INT)
INSERT INTO #EncounterStats(PracticeID, ProviderID, AvgP3MMax, LMoMax, MTDMax)
SELECT PracticeID, ProviderID, 
CASE WHEN AvgP3M_PrimaryCount>=AvgP3M_SupervisingCount AND AvgP3M_PrimaryCount>=AvgP3M_SchedulingCount THEN AvgP3M_PrimaryCount
	 WHEN AvgP3M_SupervisingCount>=AvgP3M_PrimaryCount AND AvgP3M_SupervisingCount>=AvgP3M_SchedulingCount THEN AvgP3M_SupervisingCount
	 WHEN AvgP3M_SchedulingCount>=AvgP3M_PrimaryCount AND AvgP3M_SchedulingCount>=AvgP3M_SupervisingCount THEN AvgP3M_SchedulingCount END AvgP3MMax,
CASE WHEN LMo_PrimaryCount>=LMo_SupervisingCount AND LMo_PrimaryCount>=LMo_SchedulingCount THEN LMo_PrimaryCount
	 WHEN LMo_SupervisingCount>=LMo_PrimaryCount AND LMo_SupervisingCount>=LMo_SchedulingCount THEN LMo_SupervisingCount
	 WHEN LMo_SchedulingCount>=LMo_PrimaryCount AND LMo_SchedulingCount>=LMo_SupervisingCount THEN LMo_SchedulingCount END LMoMax,
CASE WHEN MTD_PrimaryCount>=MTD_SupervisingCount AND MTD_PrimaryCount>=MTD_SchedulingCount THEN MTD_PrimaryCount
	 WHEN MTD_SupervisingCount>=MTD_PrimaryCount AND MTD_SupervisingCount>=MTD_SchedulingCount THEN MTD_SupervisingCount
	 WHEN MTD_SchedulingCount>=MTD_PrimaryCount AND MTD_SchedulingCount>=MTD_SupervisingCount THEN MTD_SchedulingCount END MTDMax
FROM #EncounterStatsSummaries

CREATE TABLE #EncounterMetrics(PracticeID INT, ProviderID INT, LastEncounter DATETIME, AvgP3MMax INT, 
LMoMax INT, MTDMax INT, PrcOfAvgP3M REAL, PrcOfLMo REAL)
INSERT INTO #EncounterMetrics(PracticeID, ProviderID, LastEncounter, AvgP3MMax, LMoMax, MTDMax, PrcOfAvgP3M, PrcOfLMo)
SELECT D.PracticeID, D.ProviderID, LastEncounter, AvgP3MMax, LMoMax, MTDMax, 
ROUND(CASE WHEN MTDMax>0 AND AvgP3MMax<>0 THEN CAST(MTDMax AS REAL)/CAST(AvgP3MMax AS REAL) END,2) PrcOfAvgP3M,
ROUND(CASE WHEN MTDMax>0 AND LMoMax<>0 THEN CAST(MTDMax AS REAL)/CAST(LMoMax AS REAL) END,2) PrcOfLMo
FROM #Doctor D LEFT JOIN #ProviderLastEncounter PLE
ON D.PracticeID=PLE.PracticeID AND D.ProviderID=PLE.ProviderID
LEFT JOIN #EncounterStats ES
ON D.PracticeID=ES.PracticeID AND D.ProviderID=ES.ProviderID

CREATE TABLE #AppointmentStatsDetail(PracticeID INT, ProviderID INT, MoID INT, Mo INT, Appointments INT)
INSERT INTO #AppointmentStatsDetail(PracticeID, ProviderID, MoID, Mo, Appointments)
SELECT A.PracticeID, ATR.ResourceID ProviderID, QDGrp.MoID, QDGrp.Mo, COUNT(ATR.AppointmentID) Appointments
FROM {1}Appointment A INNER JOIN {1}AppointmentToResource ATR
ON A.AppointmentID=ATR.AppointmentID AND A.AppointmentResourceTypeID=ATR.AppointmentResourceTypeID
INNER JOIN #QryDates QDGrp
ON A.CreatedDate BETWEEN QDGrp.StartDt AND QDGrp.EndDt
WHERE A.AppointmentResourceTypeID=1
GROUP BY A.PracticeID, ATR.ResourceID, QDGrp.MoID, QDGrp.Mo

CREATE TABLE #AppointmentStats(PracticeID INT, ProviderID INT, AvgP3M INT, LMo INT, MTD INT)
INSERT INTO #AppointmentStats(PracticeID, ProviderID, AvgP3M, LMo, MTD)
SELECT PracticeID, ProviderID, 
CASE WHEN SUM(CASE WHEN MoID<>@CurrentMoID THEN Appointments ELSE NULL END)<>0 
THEN SUM(CASE WHEN MoID<>@CurrentMoID THEN Appointments ELSE NULL END)/COUNT(CASE WHEN MoID<>@CurrentMoID AND Appointments<>0 THEN Appointments ELSE NULL END)
ELSE 0 END AvgP3M,
SUM(CASE WHEN MoID=@CurrentMoID-1 THEN Appointments ELSE 0 END) LMo,
SUM(CASE WHEN MoID=@CurrentMoID THEN Appointments ELSE 0 END) MTD
FROM #AppointmentStatsDetail
GROUP BY PracticeID, ProviderID

CREATE TABLE #AppointmentMetrics(PracticeID INT, ProviderID INT, AvgP3M INT, 
LMo INT, MTD INT, PrcOfAvgP3M REAL, PrcOfLMo REAL)
INSERT INTO #AppointmentMetrics(PracticeID, ProviderID, AvgP3M, LMo, MTD, PrcOfAvgP3M, PrcOfLMo)
SELECT D.PracticeID, D.ProviderID, AvgP3M, LMo, MTD, 
ROUND(CASE WHEN MTD>0 AND AvgP3M<>0 THEN CAST(MTD AS REAL)/CAST(AvgP3M AS REAL) END,2) PrcOfAvgP3M,
ROUND(CASE WHEN MTD>0 AND LMo<>0 THEN CAST(MTD AS REAL)/CAST(LMo AS REAL) END,2) PrcOfLMo
FROM #Doctor D LEFT JOIN #AppointmentStats AptS
ON D.PracticeID=AptS.PracticeID AND D.ProviderID=AptS.ProviderID

CREATE TABLE #ProviderStatus(PracticeID INT, ProviderID INT, Status VARCHAR(2), Free BIT, Seq INT)
INSERT INTO #ProviderStatus(PracticeID, ProviderID, Status, Free)
SELECT D.PracticeID, D.ProviderID, ''I'', 0
FROM #Doctor D INNER JOIN #Practice P
ON D.PracticeID=P.PracticeID
WHERE P.Active=0 OR D.Active=0

INSERT INTO #ProviderStatus(PracticeID, ProviderID, Status, Free)
SELECT D.PracticeID, D.ProviderID, ''AR'', 0
FROM #Doctor D LEFT JOIN #ProviderStatus PS
ON D.PracticeID=PS.PracticeID AND D.ProviderID=PS.ProviderID
INNER JOIN #EncounterMetrics EM
ON D.PracticeID=EM.PracticeID AND D.ProviderID=EM.ProviderID
INNER JOIN #AppointmentMetrics AM
ON D.PracticeID=AM.PracticeID AND D.ProviderID=AM.ProviderID
WHERE PS.ProviderID IS NULL AND 
((ISNULL(EM.LMoMax,0)=0 AND ISNULL(EM.MTDMax,0)=0 AND LastEncounter IS NOT NULL) 
  OR 
 ((ISNULL(EM.LMoMax,0)=0 AND ISNULL(EM.MTDMax,0)=0 AND LastEncounter IS NOT NULL) AND (ISNULL(AM.LMo,0)=0 OR ISNULL(AM.MTD,0)=0)))

INSERT INTO #ProviderStatus(PracticeID, ProviderID, Status, Free)
SELECT D.PracticeID, D.ProviderID, ''A'', 0
FROM #Doctor D LEFT JOIN #ProviderStatus PS
ON D.PracticeID=PS.PracticeID AND D.ProviderID=PS.ProviderID
WHERE PS.ProviderID IS NULL

IF @FreeProviderAllowance<>0
BEGIN
	CREATE TABLE #SeqActive(ProviderID INT, Seq INT IDENTITY(1,1))
	INSERT INTO #SeqActive(ProviderID)
	SELECT ProviderID
	FROM #ProviderStatus
	WHERE Status IN (''AR'',''A'')

	UPDATE PS SET Seq=SA.Seq
	FROM #ProviderStatus PS INNER JOIN #SeqActive SA
	ON PS.ProviderID=SA.ProviderID

	UPDATE #ProviderStatus SET Free=CASE WHEN Seq<=@FreeProviderAllowance THEN 1 ELSE 0 END

	DROP TABLE #SeqActive
END

--Recent Changes
CREATE TABLE #PS_I(CustomerID INT, ProviderID INT, ProviderName VARCHAR(256), Status VARCHAR(3), Free BIT)
INSERT INTO #PS_I(CustomerID, ProviderID, ProviderName, Status, Free)
SELECT @CustomerID, D.ProviderID, ProviderName, Status, Free
FROM #ProviderStatus PS INNER JOIN #Practice P
ON PS.PracticeID=P.PracticeID
INNER JOIN #Doctor D
ON PS.PracticeID=D.PracticeID AND PS.ProviderID=D.ProviderID

CREATE TABLE #PS_II(CustomerID INT, KareoProviderID INT, DoctorID INT)
INSERT INTO #PS_II(CustomerID, KareoProviderID, DoctorID)
SELECT KP.CustomerID, KPD.KareoProviderID, MIN(KPD.DoctorID) DoctorID
FROM #PS_I PS INNER JOIN KareoProvider KP
ON PS.CustomerID=KP.CustomerID
INNER JOIN KareoProviderToDoctor KPD
ON KP.KareoProviderID=KPD.KareoProviderID AND PS.ProviderID=KPD.DoctorID
GROUP BY KP.CustomerID, KPD.KareoProviderID

INSERT INTO #S_ProviderStatus(CustomerID, PracticeName, ProviderName, Degree, Status, Free)
SELECT PSI.CustomerID, NULL, PSI.ProviderName, NULL, PSI.Status, PSI.Free
FROM #PS_I PSI INNER JOIN #PS_II PSII
ON PSI.CustomerID=PSII.CustomerID AND PSI.ProviderID=PSII.DoctorID

--End of Recent Changes

INSERT INTO #S_EncounterMetrics(CustomerID, PracticeName, ProviderName, Degree, Status, Free, LastEncounter, AvgP3MMax, LMoMax, MTDMax, PrcOfAvgP3M, PrcOfLMo)
SELECT @CustomerID, PracticeName, ProviderName, Degree, Status, Free, LastEncounter, AvgP3MMax, LMoMax, MTDMax, PrcOfAvgP3M, PrcOfLMo
FROM #ProviderStatus PS INNER JOIN #Practice P
ON PS.PracticeID=P.PracticeID
INNER JOIN #Doctor D
ON PS.PracticeID=D.PracticeID AND PS.ProviderID=D.ProviderID
INNER JOIN #EncounterMetrics EM
ON PS.PracticeID=EM.PracticeID AND PS.ProviderID=EM.ProviderID

INSERT INTO #S_AppointmentMetrics(CustomerID, PracticeName, ProviderName, Degree, Status, Free, AvgP3M, LMo, MTD, PrcOfAvgP3M, PrcOfLMo)
SELECT @CustomerID, PracticeName, ProviderName, Degree, Status, Free, AvgP3M, LMo, MTD, PrcOfAvgP3M, PrcOfLMo
FROM #ProviderStatus PS INNER JOIN #Practice P
ON PS.PracticeID=P.PracticeID
INNER JOIN #Doctor D
ON PS.PracticeID=D.PracticeID AND PS.ProviderID=D.ProviderID
INNER JOIN #AppointmentMetrics AM
ON PS.PracticeID=AM.PracticeID AND PS.ProviderID=AM.ProviderID

DROP TABLE #Practice
DROP TABLE #Doctor
DROP TABLE #ProviderLastEncounter
DROP TABLE #QryDates
DROP TABLE #EncounterStatsDetail
DROP TABLE #EncounterStatsSummaries
DROP TABLE #EncounterStats
DROP TABLE #EncounterMetrics
DROP TABLE #AppointmentStatsDetail
DROP TABLE #AppointmentStats
DROP TABLE #AppointmentMetrics
DROP TABLE #ProviderStatus

--Recent Changes
DROP TABLE #PS_I
DROP TABLE #PS_II
'

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	SELECT @DatabaseName=DatabaseName, @CustomerID=CustomerID
	FROM #DBs
	WHERE TID=@Count

	SET @ExecSQL=REPLACE(@SQL,'{0}',CAST(@CustomerID AS VARCHAR))
	SET @ExecSQL=REPLACE(@ExecSQL,'{1}',dbo.Shared_ReportDataProvider_GetServerAndDatabase(@CustomerID)+'.dbo.')

	PRINT @DatabaseName
	EXEC(@ExecSQL)
END

--Provider Status
SELECT PS.CustomerID, Customer, PracticeName, ProviderName, Degree, Status, Free 
FROM #S_ProviderStatus PS INNER JOIN #DBs D
ON PS.CustomerID=D.CustomerID

--Encounters
SELECT EM.CustomerID, Customer, PracticeName, ProviderName, Degree, Status, Free, LastEncounter, AvgP3MMax, LMoMax, MTDMax, PrcOfAvgP3M, PrcOfLMo 
FROM #S_EncounterMetrics EM INNER JOIN #DBs D
ON EM.CustomerID=D.CustomerID

--Appointments
SELECT AM.CustomerID, Customer, PracticeName, ProviderName, Degree, Status, Free, AvgP3M, LMo, MTD, PrcOfAvgP3M, PrcOfLMo
FROM #S_AppointmentMetrics AM INNER JOIN #DBs D
ON AM.CustomerID=D.CustomerID

DROP TABLE #DBs
DROP TABLE #S_ProviderStatus
DROP TABLE #S_EncounterMetrics
DROP TABLE #S_AppointmentMetrics