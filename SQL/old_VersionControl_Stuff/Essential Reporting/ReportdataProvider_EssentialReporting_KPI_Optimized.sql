
/****** Object:  StoredProcedure [dbo].[ReportdataProvider_Beta_KeyIndicatorSummary]    Script Date: 7/8/2015 9:28:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




 DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME ,
	@PreviousBeginDate DATETIME  ,
	@PreviousEndDate DATETIME ,
	@PracticeID INT,
	@ProviderID INT=NULL



---------DEBUG---------
SET @BeginDate='6/1/2015'
SET @EndDate='7/1/2015'
SET @PreviousBeginDate='5/1/2015'
SET @PreviousEndDate='6/1/2015'
SET @PracticeID=3
SET @ProviderID=null






DECLARE @EndOfDayEndDate DATETIME,
		@EndOfDayPreviousEndDate DATETIME

SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))
SET @EndOfDayPreviousEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@PreviousEndDate)))

---Create Tables Needed----
CREATE TABLE #FinalData
    (
      Period VARCHAR(128) ,
      Encounters INT ,
      Charges MONEY ,
      Adjustments MONEY ,
	  Payments MONEY ,
      OutstandingAR MONEY
    )

CREATE TABLE #ARAGINGCurrent
	(GroupBy VARCHAR(128),
	  GroupBy1 INT,
	  PracticeID INT, 
	  NAME VARCHAR(128),
	  TotalBalance MONEY, 
	  Credit MONEY)
 
CREATE TABLE #ARAGINGPrevious
	(GroupBy VARCHAR(128),
	 GroupBy1 INT,
	 PracticeID INT, 
	 NAME VARCHAR(128),
	 TotalBalance MONEY, 
	 Credit MONEY)


INSERT INTO #FinalData ( Period )
SELECT   ( 'Current' )
	UNION
SELECT ( 'Previous' )

----Encounters
UPDATE #FinalData
SET Encounters=Encounters.Encounters
FROM  #finalData		--This is grabbing data based on the two periods given 
JOIN (SELECT COUNT(EncounterID) AS Encounters, 'Current' AS Period
		FROM dbo.Encounter AS E 
		WHERE E.PracticeID = @PracticeID 
			AND E.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
			AND E.EncounterStatusID = 3
			AND e.DoctorID=ISNULL(@ProviderID, e.doctorId)
	UNION	  
	SELECT COUNT(EncounterID) AS Encounters, 'Previous' AS Period
		FROM dbo.Encounter AS E WHERE E.PracticeID = @PracticeID 
		AND E.PostingDate BETWEEN @PreviousBeginDate AND @EndOfDayPreviousEndDate
		AND E.EncounterStatusID = 3
		AND e.DoctorID=ISNULL(@ProviderID, e.doctorId)) Encounters
ON #FinalData.Period = Encounters.Period

--Charges and Adjustments
UPDATE #FinalData
SET Charges=Charges.Charges, Adjustments=Charges.Adjustments
FROM #finalData		--This is grabbing data based on the two periods given 
JOIN (	SELECT SUM(CASE WHEN ClaimTransactionTypecode='CST' THEN ca.Amount END) AS Charges,
			 SUM(CASE WHEN ClaimTransactionTypecode='ADJ' THEN ca.Amount END) AS Adjustments,
			 'Current' AS Period
		FROM    dbo.ClaimAccounting AS CA
		WHERE   ca.ClaimTransactionTypeCode IN ( 'CST', 'ADJ' )
			AND ca.PostingDate BETWEEN @beginDate AND @EndOfDayEndDate
			AND ca.PracticeID = @PracticeID
			AND ca.ProviderID=ISNULL(@ProviderID, ca.ProviderID)
		UNION
		SELECT SUM(CASE WHEN ClaimTransactionTypecode='CST' THEN ca.Amount END) AS Charges,
			 SUM(CASE WHEN ClaimTransactionTypecode='ADJ' THEN ca.Amount END) AS Adjustments,
			 'Previous' AS Period
		FROM    dbo.ClaimAccounting AS CA
		WHERE   ca.ClaimTransactionTypeCode IN ( 'CST', 'ADJ' )
			AND ca.PostingDate BETWEEN @PreviousBeginDate AND @EndOfDayPreviousEndDate
			AND ca.PracticeID = @PracticeID
				AND ca.ProviderID=ISNULL(@ProviderID, ca.ProviderID)      
       )Charges ON #finalData.Period = Charges.Period


--Payment

UPDATE #FinalData
SET Payments = Payment.Payment
FROM #finalData		--Gets all payments made within the two periods
JOIN (SELECT SUM(P.PaymentAmount) AS Payment , 'Current' AS Period
	FROM dbo.Payment AS P 
	WHERE P.PracticeID = @PracticeID
		AND P.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
	UNION ALL
	SELECT SUM(P.PaymentAmount) AS Payment , 'Previous' AS Period
	FROM dbo.Payment AS P 
	WHERE P.PracticeID = @PracticeID
		AND P.PostingDate BETWEEN @PreviousBeginDate AND @EndOfDayPreviousEndDate)Payment
	ON #FinalData.Period = Payment.Period

------AR------Need two calls to get the two different AR periods-------------
IF EXISTS(SELECT 1 FROM dbo.ARAGingGraph_Data
WHERE PracticeID=@PracticeID AND DateCreated=@EndDate AND @ProviderID IS NULL)

BEGIN 
INSERT INTO #ARAGINGCurrent
        ( PracticeID ,
          TotalBalance 
        )

SELECT PracticeID,SUM(TotalBalance)
FROM dbo.ARAGingGraph_Data
WHERE PracticeID=@PracticeID AND DateCreated=@EndDate
GROUP BY PracticeID
END

ELSE

BEGIN 
INSERT INTO #ARAGINGCurrent
EXEC ReportDataProvider_ArAgingSummary_For_KeyIndicators 
	@PracticeID=@PracticeID, 
	@EndDate=@EndOfDayEndDate,
	@ProviderID=@ProviderID
     



END

IF EXISTS(SELECT 1 FROM dbo.ARAGingGraph_Data
WHERE PracticeID=@PracticeID AND DateCreated=@PreviousEndDate)


BEGIN 
INSERT INTO #ARAGINGPrevious
         ( PracticeID ,
          TotalBalance 
        )

SELECT PracticeID,SUM(TotalBalance)
FROM dbo.ARAGingGraph_Data
WHERE PracticeID=@PracticeID AND DateCreated=@PreviousEndDate
GROUP BY PracticeID
END

ELSE
BEGIN
	
INSERT INTO #ARAGINGPrevious
EXEC ReportDataProvider_ArAgingSummary_For_KeyIndicators 
	@PracticeID=@PracticeID, 
	@EndDate=@EndofDayPreviousEndDate,
	@ProviderID=@ProviderId
END	
	
UPDATE #FinalData
SET OutstandingAR=TotalBalance
FROM #FinalData
JOIN (SELECT SUM(AC.TotalBalance) AS TotalBalance, 'Current' AS Period
		FROM #ARAGINGCurrent AS AC
	 UNION
	  SELECT SUM(AP.TotalBalance) AS TotalBalance, 'Previous' AS Period
		FROM #ARAGINGPrevious AS AP) AR
ON  #finalData.Period = AR.Period


SELECT Period, Encounters, Charges, Adjustments, Payments, OutstandingAR FROM #FinalData


DROP TABLE  #FinalData

DROP TABLE #ARAGINGCurrent, #ARAGINGPrevious








            