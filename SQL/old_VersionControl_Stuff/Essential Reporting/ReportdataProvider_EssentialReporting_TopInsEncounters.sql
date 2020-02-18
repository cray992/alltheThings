SET TRANSACTION ISOLATION LEVEL READ COMMITTED


--CREATE PROCEDURE [dbo].[ReportdataProvider_Beta_EssentialBilling_TopInsEncounters] 
--	@BeginDate DATETIME,
--	@EndDate DATETIME,
--	@BucketType VARCHAR(10)= 'dd', --dd-day, ww-Week, mm-Month, yy-year
--	@PracticeID INT,
--	@NumberOfIns INT

--AS
----DEBUG----
 DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PracticeID INT,
	@NumberOfIns INT,
	@ProviderID INT=NULL

SELECT  @BeginDate = '1/1/2015' ,
        @EndDate = '7/20/2015' ,
		@PracticeID = 3,
		@NumberOfIns = 6,
		@ProviderID=18

	
DECLARE @EndOfDayEndDate DATETIME,
		@CurrentDate DATETIME ,
        @Encounters INT ,
		@NumOfColumns INT 
  
        

CREATE TABLE #Encounters 
	( Encounters INT, InsuranceName VARCHAR(MAX), InsCoID INT, [Date] DATETIME)
CREATE TABLE #FinalData
	( InsCoID INT, InsName VARCHAR(MAX), Result INT, [Rank] INT, [GROUP] Varchar(3)) 
CREATE TABLE  #TempFinal
	(InsCoId INT, InsName VARCHAR(MAX), Result INT, [Rank] INT, [Group] VARCHAR(1) )
			
SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))
SET @CurrentDate = CAST(@BeginDate AS DATE)


--Gets only the Encounters that belong to the time periods
INSERT INTO #Encounters
        ( Encounters, InsuranceName, InsCoID,  Date )
SELECT COUNT(E.EncounterID), IC.InsuranceCompanyName , IC.InsuranceCompanyID, E.PostingDate 
		FROM dbo.Encounter AS E
		INNER JOIN dbo.InsurancePolicy AS IP ON E.PatientCaseID = IP.PatientCaseID 
		INNER JOIN dbo.InsuranceCompanyPlan AS ICP ON IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
		INNER JOIN dbo.InsuranceCompany AS IC ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID 
		WHERE E.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
			AND E.EncounterStatusID = 3 AND E.PracticeID = @PracticeID AND IP.Precedence = 1
			AND e.DoctorID=Isnull(@ProviderID, e.doctorId)
		GROUP BY E.PostingDate, IC.InsuranceCompanyName, IC.InsuranceCompanyID
		HAVING COUNT(E.EncounterID) > 0
	
--populate finaldata with all insurancecompanies
INSERT INTO #FinalData
	(InsCoID , InsName, Result )
SELECT DISTINCT InsCoID, InsuranceName, SUM(Encounters)
FROM #Encounters 
GROUP BY InsCoId, InsuranceName


INSERT INTO #TempFinal
        ( InsCoId , InsName ,Result ,[Rank] ,[Group])
SELECT InsCoId, InsName, Result, ROW_NUMBER() OVER (ORDER BY Result DESC, InsName) AS [Rank],
		CASE WHEN (ROW_NUMBER() OVER (ORDER BY Result DESC)) < (@NumberOfIns+1) THEN 'I' ELSE 'G' END AS [GROUP]
FROM #FinalData AS FD

DELETE FROM #FinalData

INSERT INTO #FinalData (InsCoID, InsName, Result, [Rank], [Group])
SELECT InsCoID, InsName, Result, [Rank], [Group]
FROM #TempFinal
WHERE [Group] = 'I'

INSERT INTO #FinalData (InsCoID, InsName, Result, [Rank], [Group])
SELECT '', 'All Others', ISNULL(SUM(Result), 0 ), (@NumberOfIns +1), 'G'
FROM #TempFinal
WHERE [Group] = 'G'

SELECT InsCoID, InsName,  Result, [Rank]
FROM #FinalData 
ORDER BY [Rank]
 

DROP TABLE  #FinalData,  #Encounters,#TempFinal

