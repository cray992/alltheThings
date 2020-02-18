USE superbill_22109_dev
Go

----DEBUG----
 DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PracticeID INT,
	@NumberofProcedures INT ,
	@ProviderID INT=NULL

SELECT  @BeginDate = '6/1/2015' ,
        @EndDate = '7/15/2015' ,
		@PracticeID =3 ,
		@NumberofProcedures = 10,
		@Providerid = 18

	
DECLARE @EndOfDayEndDate DATETIME,
		@EndOfDayPreviousEndDate DATETIME,
		@CurrentDate DATETIME 
  
  
        
   
CREATE TABLE #Procedures
	(ProcedureCount INT, ProcedureCodeDictionaryID INT , ProcedureCode VARCHAR(40), ProcedureName VARCHAR(MAX),  [Date] DATETIME)
CREATE TABLE #FinalData
	(Result INT, ProcedureCode VARCHAR(40), ProcedureName Varchar(MAX), [Rank] INT , [Group] VARCHAR(1))
CREATE TABLE #TempFinal
	(Result INT , ProcedureCode VARCHAR(40) , ProcedureName VARCHAR (MAX), [Rank] INT, [Group] VARCHAR(1))

SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))
SET @CurrentDate = CAST(@BeginDate AS DATE)


INSERT INTO #Procedures
        ( ProcedureCount ,
          ProcedureCodeDictionaryID ,
          ProcedureCode ,
          ProcedureName ,
          Date
        )
SELECT Count(ep.encounterprocedureid), ep.ProcedureCodeDictionaryID, pcd.ProcedureCode, pcd.OfficialName, ep.ProcedureDateOfService
FROM dbo.EncounterProcedure AS EP
INNER JOIN dbo.Encounter AS E ON EP.EncounterID = E.EncounterID
INNER JOIN dbo.ProcedureCodeDictionary AS PCD ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
WHERE ep.PracticeID = @PracticeID
	AND E.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
	AND e.DoctorID=isnull(@ProviderId, e.doctorid)
GROUP BY EP.ProcedureCodeDictionaryID, pcd.ProcedureCode, pcd.OfficialName, ep.ProcedureDateOfService


INSERT INTO #FinalData
        ( Result , ProcedureCode , ProcedureName)
SELECT  SUM(PR.ProcedureCount) AS ProcCount, PR.ProcedureCode, PR.ProcedureName
FROM #Procedures as PR
GROUP BY  pR.ProcedureCode, PR.ProcedureName


INSERT INTO #TempFinal
	 ( Result , ProcedureCode , ProcedureName, [Rank], [Group])
SELECT Result, ProcedureCode, ProcedureName, ROW_NUMBER() OVER (ORDER BY Result DESC, ProcedureCode ) AS [Rank],
	CASE WHEN (ROW_NUMBER() OVER (ORDER BY Result DESC)) < (@NumberOfProcedures+1) THEN 'I' ELSE 'G' END AS [Group]
  FROM #FinalData

DELETE FROM #FinalData

INSERT INTO #FinalData (ProcedureCode, ProcedureName, Result, [Rank], [Group])
SELECT ProcedureCode, ProcedureName, Result, [Rank], [Group]
FROM #TempFinal
WHERE [Group] = 'I'

INSERT INTO #FinalData (ProcedureName, ProcedureCode,  Result, [Rank], [Group])
SELECT 'All Others', '', ISNULL(SUM(Result),0), (@NumberOfProcedures + 1), 'G'
FROM #TempFinal
WHERE [Group] = 'G'


SELECT ProcedureName, ProcedureCode, Result, [Rank], [Group] FROM #FinalData
ORDER BY [Rank]


DROP TABLE  #Procedures,  #FinalData,#TempFinal





