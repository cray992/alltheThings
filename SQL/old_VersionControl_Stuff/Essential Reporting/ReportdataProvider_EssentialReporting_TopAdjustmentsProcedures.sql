USE superbill_22109_dev
Go


--CREATE PROCEDURE [dbo].[ReportdataProvider_Beta_EssentialBilling_TopAdjustmentsProcedures]
--	@BeginDate DATETIME ,
--    @EndDate DATETIME, 
--    @PracticeID INT, 
--	@NumberOfAdjProc INT,

--AS
 DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PracticeID INT,
	@NumberOfAdjProc INT,
	@ProviderId INT=NULL

SELECT  @BeginDate = '7/1/2014' ,
        @EndDate = '7/30/2014' ,
		@PracticeID =3 ,
		@NumberOfAdjProc = 10,
		@ProviderId=18

	
DECLARE @EndOfDayEndDate DATETIME
		        
CREATE TABLE #Adjustments
	(Adjustments MONEY,  ProcedureCode  VARCHAR(10), OfficialName VARCHAR(MAX))
CREATE TABLE #FinalData
	( ProcedureCode  VARCHAR(10), ProcedureName VARCHAR(MAX), Result MONEY, [Rank] INT, [Group] VARCHAR(1))
CREATE TABLE  #TempFinal
	( ProcedureCode  VARCHAR(10), ProcedureName VARCHAR(MAX), Result MONEY, [Rank] INT, [Group] VARCHAR(1))	
SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))



--Adjustments
INSERT INTO #Adjustments
        ( Adjustments, ProcedureCode, OfficialName )
SELECT  SUM(CA.Amount ) ,
		pcd.ProcedureCode,
		pcd.OfficialName 
FROM    dbo.ClaimAccounting AS CA
INNER JOIN dbo.EncounterProcedure AS EP ON CA.EncounterProcedureID = EP.EncounterProcedureID
INNER JOIN dbo.ProcedureCodeDictionary AS PCD ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
WHERE   ca.ClaimTransactionTypeCode ='ADJ'
	AND ca.PostingDate BETWEEN @beginDate AND @EndOfDayEndDate
	AND ca.PracticeID = @PracticeID
	AND ca.ProviderID=isnull(@providerid,ca.ProviderID)
GROUP BY EP.ProcedureCodeDictionaryID, pcd.ProcedureCode, pcd.OfficialName


INSERT INTO #FinalData
        ( ProcedureCode, ProcedureName, Result)
SELECT ProcedureCode, OfficialName, SUM(Adjustments)
FROM #Adjustments AS A
GROUP BY ProcedureCode, OfficialName

INSERT INTO #TempFinal
        ( ProcedureCode ,ProcedureName ,Result ,[Rank] ,[Group])
SELECT ProcedureCode, ProcedureName, Result, ROW_NUMBER() OVER (ORDER BY Result DESC, ProcedureCode) AS [Rank],
		CASE WHEN (ROW_NUMBER() OVER (ORDER BY Result DESC)) < (@NumberOfAdjProc + 1) THEN 'I' ELSE 'G' END AS [Group]
FROM #FinalData AS FD

DELETE FROM #FinalData

INSERT INTO #FinalData
        ( ProcedureCode ,ProcedureName ,Result, [Rank], [Group])
SELECT ProcedureCode, ProcedureName, Result, [Rank], [Group]
FROM #TempFinal
WHERE [Group] = 'I'

INSERT INTO #FinalData
        ( ProcedureName ,Result, [Rank], [Group])
SELECT 'All Others', ISNULL(SUM(Result),0), (@NumberOfAdjProc + 1), 'G'
FROM #TempFinal
WHERE [Group] = 'G'


SELECT ProcedureCode, ProcedureName, Result, RANK
FROM #FinalData


 

DROP TABLE #FinalData,  #Adjustments, #TempFinal






