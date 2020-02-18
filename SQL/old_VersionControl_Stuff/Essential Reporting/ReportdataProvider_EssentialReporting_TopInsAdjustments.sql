
 DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PracticeID INT,
	@NumberOfIns INT,
	@ProviderID INT

SELECT  @BeginDate = '7/1/2014' ,
        @EndDate = '7/30/2014' ,
		@PracticeID =3 ,
		@NumberOfIns = 10,
		@ProviderID=18

	
DECLARE @EndOfDayEndDate DATETIME
		        
CREATE TABLE #Adjustments
	(Adjustments MONEY,  InsCoID INT, InsName VARCHAR(MAX),  [Date] DATETIME)
CREATE TABLE #FinalData
	( InsCoID INT, InsName VARCHAR(Max), Result MONEY, [Rank] INT, [Group] VARCHAR(1))
CREATE TABLE  #TempFinal
	(InsCoId INT , InsName VARCHAR(MAX), Result INT , [Rank] INT , [Group] VARCHAR(1) )	
SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))



--Adjustments
INSERT INTO #Adjustments
        ( Adjustments, InsCoID, InsName, Date )
SELECT SUM(CASE WHEN ClaimTransactionTypecode='ADJ' THEN ca.Amount END) AS Adjustments, 
		IC.InsuranceCompanyID, 
		IC.InsuranceCompanyName, 
		Ca.PostingDate
FROM    dbo.ClaimAccounting AS CA
INNER JOIN dbo.ClaimAccounting_Assignments AS CAA ON CA.ClaimID = CAA.ClaimID
INNER JOIN dbo.ClaimAccounting_Billings AS CAB ON CAA.ClaimID = CAB.ClaimID
INNER JOIN dbo.InsuranceCompanyPlan AS ICP ON CAA.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
INNER JOIN dbo.InsuranceCompany AS IC ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
WHERE   ca.ClaimTransactionTypeCode =  'ADJ'
	AND ca.PostingDate BETWEEN @beginDate AND @EndOfDayEndDate
	AND ca.PracticeID = @PracticeID
	AND ca.ProviderID=ISNULL(@ProviderID, ca.providerid)
	GROUP BY CA.PostingDate, IC.InsuranceCompanyID, IC.InsuranceCompanyName


INSERT INTO #FinalData
        ( InsCoID ,InsName ,Result)
SELECT InsCoID, InsName, SUM(Adjustments)
FROM #Adjustments AS A
GROUP BY InsCoID, InsName

INSERT INTO #TempFinal
        ( InsCoId ,InsName ,Result ,[Rank] ,[Group])
SELECT InsCoID, InsName, Result, ROW_NUMBER() OVER (ORDER BY Result DESC, InsCoID) AS [Rank],
		CASE WHEN (ROW_NUMBER() OVER (ORDER BY Result DESC)) < (@NumberOfIns + 1) THEN 'I' ELSE 'G' END AS [Group]
FROM #FinalData AS FD

DELETE FROM #FinalData

INSERT INTO #FinalData
        ( InsCoID ,InsName ,Result, [Rank], [Group])
SELECT InsCoID, InsName, Result, [Rank], [Group]
FROM #TempFinal
WHERE [Group] = 'I'

INSERT INTO #FinalData
        ( InsName ,Result, [Rank], [Group])
SELECT 'All Others', ISNULL(SUM(Result),0), (@NumberOfIns + 1), 'G'
FROM #TempFinal
WHERE [Group] = 'G'


SELECT InsCoId, InsName, Result, RANK
FROM #FinalData


 

DROP TABLE #FinalData,  #Adjustments, #TempFinal






