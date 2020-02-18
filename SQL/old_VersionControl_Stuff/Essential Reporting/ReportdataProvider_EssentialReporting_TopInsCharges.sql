

----DEBUG----
 DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PracticeID INT,
	@NumberOfIns INT,
	@ProviderID INT=NULL

SELECT  @BeginDate = '6/1/2014' ,
        @EndDate = '7/15/2014' ,
		@PracticeID =3 ,
		@NumberOfIns = 10,
		@ProviderID=18


	
DECLARE @EndOfDayEndDate DATETIME,
		@Charges Money 
		
  
        
CREATE TABLE #Charges
	(Charges MONEY, InsCoID INT, InsName VARCHAR(MAX),  [Date] DATETIME)
CREATE TABLE #FinalData
	(BeginPeriod DATETIME, EndPeriod DATETIME, InsCoId INT, InsName VARCHAR(MAX), Result MONEY, [Rank] INT, [Group]VARCHAR(1))
CREATE TABLE  #TempFinal
	(InsCoId INT , InsName VARCHAR(MAX), BeginPeriod DATETIME , EndPeriod DATETIME, Result INT , 
		[Rank] INT , [Group] VARCHAR(1) )
		

SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))

--Charges
INSERT INTO #Charges
        ( Charges, InsCoID, InsName, Date )
SELECT SUM(ca.Amount ) ,
		IC.InsuranceCompanyID, 
		IC.InsuranceCompanyName, 
		Ca.PostingDate
FROM    dbo.ClaimAccounting AS CA
INNER JOIN dbo.ClaimAccounting_Assignments AS CAA ON CA.ClaimID = CAA.ClaimID
INNER JOIN dbo.ClaimAccounting_Billings AS CAB ON CAA.ClaimID = CAB.ClaimID
INNER JOIN dbo.InsuranceCompanyPlan AS ICP ON CAA.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
INNER JOIN dbo.InsuranceCompany AS IC ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
WHERE   ca.ClaimTransactionTypeCode ='CST'
	AND ca.PostingDate BETWEEN @beginDate AND @EndOfDayEndDate
	AND ca.PracticeID = @PracticeID
	AND ca.ProviderID=isnull(@ProviderId, ca.ProviderId)
	GROUP BY CA.PostingDate, IC.InsuranceCompanyID, IC.InsuranceCompanyName


INSERT INTO #FinalData
        ( InsCoId , InsName , Result )
SELECT InsCoID, InsName, SUM(Charges)
FROM #Charges AS C
GROUP BY InsCoId, InsName


INSERT INTO #TempFinal
        ( InsCoId ,InsName ,Result ,[Rank] ,[Group])
SELECT InsCoId, InsName, Result, ROW_NUMBER() OVER (ORDER BY Result DESC, InsCoID) AS [Rank],
	CASE WHEN (ROW_NUMBER() OVER (ORDER BY Result DESC)) < (@NumberOfIns +1) THEN 'I' ELSE 'G' END AS [Group]
FROM #FinalData AS FD

DELETE FROM #FinalData

INSERT INTO #FinalData
        ( InsCoId ,InsName ,Result ,[Rank] ,[Group])
SELECT InsCoID, InsName, Result, [Rank], [Group]
FROM #TempFinal AS TF 
WHERE [Group] = 'I'

INSERT INTO #FinalData
        ( InsName ,Result ,[Rank] ,[Group])
SELECT 'All Others', ISNULL(SUM(Result),0), (@NumberOfIns +1)  , 'G'
FROM #TempFinal AS TF 
WHERE [Group] = 'G'

SELECT  InsCoId, InsName, Result, [Rank] 
FROM #FinalData
ORDER BY [Rank]





DROP TABLE  #FinalData, #Charges, #TempFinal

