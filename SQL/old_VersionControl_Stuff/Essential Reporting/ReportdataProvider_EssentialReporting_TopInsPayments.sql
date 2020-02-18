USE superbill_22109_dev
go


--CREATE PROCEDURE [dbo].[ReportdataProvider_Beta_EssentialBilling_TopInsPayment]
--	@BeginDate DATETIME,
--	@EndDate DATETIME,
--	@PracticeID INT,
--	@NumberOfIns INT

--AS
----DEBUG---
 DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PracticeID INT,
	@NumberOfIns int

SELECT  @BeginDate = '1/1/2015' ,
        @EndDate = '4/20/2015' ,
		@PracticeID = 3 ,
		@NumberOfIns = 10
	
DECLARE @EndOfDayEndDate DATETIME,
		@Payments Money 
		
  

CREATE TABLE #Payments
	(Payments MONEY,  InsCoID INT, InsName VARCHAR(MAX),  [Date] DATETIME)
CREATE TABLE #FinalData
	(InsCoID INT, InsName VARCHAR(MAX), Result MONEY, [Rank] INT, [Group] VARCHAR(1))
CREATE TABLE  #TempFinal
	(InsCoId INT , InsName VARCHAR(MAX),  Result MONEY , [Rank] INT , [Group] VARCHAR(1) )
				
SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))

--Payments  --Grabs all payments and associated Insurance Company
INSERT INTO #Payments
        ( Payments,  InsCoID, InsName, Date )
SELECT SUM(P.PaymentAmount) , 
		IC.InsuranceCompanyID, IC.InsuranceCompanyName, P.PostingDate
FROM dbo.Payment AS P
INNER JOIN dbo.InsuranceCompanyPlan AS ICP ON ICP.InsuranceCompanyPlanID = P.PayerID
INNER JOIN dbo.InsuranceCompany AS IC ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
WHERE   P.PostingDate BETWEEN @beginDate AND @EndOfDayEndDate
	AND P.PracticeID = @PracticeID
	GROUP BY P.PostingDate, IC.InsuranceCompanyID, IC.InsuranceCompanyName


INSERT INTO #FinalData
( InsCoID, InsName, Result   )
SELECT P.InsCoId, P.InsName, SUM(P.Payments) 
FROM #Payments P
GROUP BY InsCoID, InsName


--Move over all data and add ranking
INSERT INTO #TempFinal
(InsCoId, InsName, Result, [Rank], [Group])
SELECT InsCoID, InsName,  Result, RANK() OVER ( ORDER BY Result DESC, InsCoID ),
CASE WHEN (RANK() OVER ( ORDER BY Result DESC)) < (@NumberOfIns + 1) THEN 'I'  ELSE 'G' END
FROM #FinalData 

--Delete everything from FinalData so we can put the data back in ordered and sum up Other
DELETE FROM #FinalData

--This is inserting individual records that are in the top @NumberOfIns
INSERT INTO #FinalData (InsCoId, InsName, Result, [Rank], [Group])
SELECT InsCoId, InsName, Result, [Rank], [Group]
FROM #TempFinal AS F
WHERE [Group] = 'I' 

--This is inserting group of records that are not in the top @NumberOfIns
INSERT INTO #FinalData ( InsName,  Result, [Rank], [Group])
SELECT DISTINCT 'Other', ISNULL(SUM(Result), 0), (@NumberOfIns + 1) , 'G'
FROM #TempFinal AS F
WHERE [Group] = 'G' 


--Only return when there are payments made
SELECT InsCoID, InsName, Result, [Rank] 
FROM #FinalData 
ORDER BY  [Rank]

 

DROP TABLE  #FinalData, #Payments, #TempFinal
