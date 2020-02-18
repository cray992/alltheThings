USE superbill_22109_dev
Go


--CREATE  PROCEDURE [dbo].[ReportdataProvider_Beta_EssentialBilling_TopProcCharges]
--	@BeginDate DATETIME,
--	@EndDate DATETIME,
--	@BucketType VARCHAR(10)= 'dd', --dd-day, ww-Week, mm-Month, yy-year
--	@PracticeID INT,
--	@PreviousBeginDate DATETIME ,
--	@PreviousEndDate DATETIME 

--AS
----DEBUG----
 DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PracticeID INT,
	@NumberOfProcCharges INT,
	@ProviderID INT

SELECT  @BeginDate = '6/1/2014' ,
        @EndDate = '7/15/2014' ,
		@PracticeID =3 ,
		@NumberOfProcCharges = 10,
		@ProviderId=null

	
DECLARE @EndOfDayEndDate DATETIME,
		@Charges Money 
		
  
        
CREATE TABLE #Charges
	( Charges MONEY, ProcedureCodeDictionaryID VARCHAR(MAX), ProcedureCode VARCHAR(10), OfficialName VARCHAR(MAX))
CREATE TABLE #FinalData
	( ProcedureCode VARCHAR(10), ProcedureName VARCHAR(MAX), Result MONEY, [Rank] INT, [Group]VARCHAR(1))
CREATE TABLE  #TempFinal
	( ProcedureCode VARCHAR(10), ProcedureName VARCHAR(MAX), Result MONEY, [Rank] INT , [Group] VARCHAR(1) )
		

SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))

--Charges
INSERT INTO #Charges
        ( Charges, ProcedureCodeDictionaryID, ProcedureCode, OfficialName )
SELECT  SUM(CA.Amount ) ,
		EP.ProcedureCodeDictionaryID, 
		pcd.ProcedureCode,
		pcd.OfficialName 
FROM    dbo.ClaimAccounting AS CA
INNER JOIN dbo.EncounterProcedure AS EP ON CA.EncounterProcedureID = EP.EncounterProcedureID
INNER JOIN dbo.ProcedureCodeDictionary AS PCD ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
WHERE   ca.ClaimTransactionTypeCode ='CST'
	AND ca.PostingDate BETWEEN @beginDate AND @EndOfDayEndDate
	AND ca.PracticeID = @PracticeID
	AND ca.ProviderID=isnull(@providerId, ca.providerid)
GROUP BY EP.ProcedureCodeDictionaryID, pcd.ProcedureCode, pcd.OfficialName

INSERT INTO #FinalData
        ( ProcedureCode, ProcedureName, Result)
SELECT  ProcedureCode, OfficialName, SUM(Charges)
FROM #Charges AS C
GROUP BY ProcedureCode, OfficialName


INSERT INTO #TempFinal
        (  ProcedureCode, ProcedureName, Result, [Rank] , [Group])
SELECT ProcedureCode, ProcedureName, Result, ROW_NUMBER() OVER (ORDER BY Result DESC, ProcedureCode) AS [Rank],
	CASE WHEN (ROW_NUMBER() OVER (ORDER BY Result DESC)) < (@NumberOfProcCharges +1) THEN 'I' ELSE 'G' END AS [Group]
FROM #FinalData AS FD

DELETE FROM #FinalData

INSERT INTO #FinalData
        ( ProcedureCode, ProcedureName, Result,[Rank] ,[Group])
SELECT ProcedureCode, ProcedureName, Result, [Rank], [Group]
FROM #TempFinal AS TF 
WHERE [Group] = 'I'

INSERT INTO #FinalData
        (  ProcedureName, Result, [Rank], [Group])
SELECT 'All Others', ISNULL(SUM(Result),0), (@NumberOfProcCharges +1)  , 'G'
FROM #TempFinal AS TF 
WHERE [Group] = 'G'

SELECT ProcedureCode, ProcedureName, Result, [Rank]
FROM #FinalData
ORDER BY [Rank]

DROP TABLE  #FinalData, #Charges, #TempFinal
