		
DECLARE		
		@BeginDate DATETIME ,
		@EndDate DATETIME ,
		@PreviousBeginDate DATETIME ,
		@PreviousEndDate DATETIME ,
		@PracticeID INT,
		@Providerid INT = NULL
		




SELECT	
		@BeginDate ='4/1/2014' ,
		@EndDate = '5/15/2014' ,
		@PreviousBeginDate ='4/1/2014' ,
		@PreviousEndDate = '5/15/2014' ,
		@PracticeID =3,
		@Providerid=null

DECLARE @EndOfDayEndDate DATETIME ,
		@EndOfDayPreviousEndDate DATETIME ,
		@PreviousEncounters INT ,
		@EncounterAverage INT,
		@EncounterTotal INT,
		@EncounterHighDate DATETIME,
		@MaxEncounters INT
        
CREATE TABLE #Encounters 
	( Encounters INT, [Date] DATETIME)

SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))
SET @EndOfDayPreviousEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@PreviousEndDate)))

INSERT INTO #Encounters
        ( Encounters,   Date )
SELECT COUNT(E.EncounterID), E.PostingDate 
		FROM dbo.Encounter AS E
		WHERE E.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
			AND E.EncounterStatusID = 3 AND E.PracticeID = @PracticeID
			AND e.DoctorID=ISNULL(@Providerid, e.doctorid)
		GROUP BY E.PostingDate

SET @EncounterAverage = (SELECT SUM(Encounters)/COUNT(Encounters) FROM #Encounters )
SET @EncounterTotal = (SELECT SUM(Encounters) FROM #Encounters)
SET @PreviousEncounters = (SELECT COUNT(E.EncounterID) FROM dbo.Encounter E WHERE E.PracticeID = @PracticeID AND
							E.PostingDate BETWEEN @PreviousBeginDate AND @EndOfDayPreviousEndDate AND
							E.EncounterStatusID = 3
							AND e.DoctorID=ISNULL(@Providerid, e.doctorid))                          
SET @EncounterHighDate = (SELECT Date FROM #Encounters WHERE Encounters = (SELECT MAX(ENCOUNTERS) FROM #Encounters))
SET @MaxEncounters = (SELECT MAX(ENCOUNTERS) FROM #Encounters)




SELECT  @EncounterTotal AS 'Total', @EncounterAverage AS 'Average',  @PreviousEncounters AS 'Previous Results',
		@MaxEncounters AS 'High', @EncounterHighDate AS 'High Date'

DROP TABLE #Encounters