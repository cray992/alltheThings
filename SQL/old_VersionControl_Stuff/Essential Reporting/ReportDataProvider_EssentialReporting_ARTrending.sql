USE superbill_22109_dev
GO


/****** Object:  StoredProcedure [dbo].[ReportDataProvider_ArAgingSummary_Insurance_V1]    Script Date: 8/18/2015 3:06:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
DECLARE 
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@BucketType VARCHAR(10)='ww', --dd-day, ww-Week, mm-Month, yy-year
	@PracticeID INT,
    @DateType VARCHAR(1)= 'F' ,--First Bill Date is Default =F, Last Bill Date=L, Encounter PostingDate=E
    @ProviderID INT = NULL ,
    @NofIns INT= 10,
	@IncludePastAR TINYINT=0,
	@BeginARDate DATETIME=NULL


	Select @EndDate='7/1/2015', 
			@BeginDate='6/1/2015',
			@PracticeID=3, 
			@DateType='F', 
			@NofIns = 8,
			@ProviderID=18,
			@IncludePastAR=0
	
IF @IncludePastAR=0
BEGIN
SELECT @BeginARDate=(SELECT activationDate FROM SHAREDSERVER.Superbill_Shared.dbo.ProductDomain_ProductSubscription WHERE ProductId=5 AND customerid=(
	SELECT value FROM dbo.CustomerProperties WHERE [KEY]='CustomerID'))

END

IF @BeginARDate IS NULL 
BEGIN
SELECT @BeginARDate='1/1/1900'
END


DECLARE @EndOfDayEndDate DATETIME,
		@CurrBucket INT,
		@NoOfBuckets INT
  
CREATE TABLE #FinalTotals(InsuranceCompany VARCHAR(500), TotalBalance MONEY, Rank INT, Period DATETIME)        
CREATE Table  #BucketTable ( BucketID INT IDENTITY, BucketCntId INT, EndPeriod DateTime)     

SELECT @NoOfBuckets=(SELECT CASE WHEN @BucketType='dd' THEN (SELECT DATEDIFF(dd,@BeginDate, @EndDate))
								 WHEN @BucketType='ww' THEN (SELECT DATEDIFF(ww,@BeginDate, @EndDate)+1)
								 WHEN @BucketType='MM' THEN (SELECT DATEDIFF(MM,@BeginDate, @EndDate)+1)
								 WHEN @BucketType='YY' THEN (SELECT DATEDIFF(YY,@BeginDate, @EndDate)+1)
						END)


						

SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))
--SET @CurrentDate = CAST(@BeginDate AS DATE)
DECLARE @BucketCount INT
SET @BucketCount=0

--Build the buckettable with buckets of either days, weeks, months or years. It will have the as of date
WHILE (@BucketCount <= @NoOfBuckets)
BEGIN
			
		INSERT INTO #BucketTable 
		        ( BucketCntId,EndPeriod)
		SELECT  @BucketCount, 
				CASE @BucketType WHEN 'dd' THEN --This returns the 11:59 of current day
											DATEADD(dd,-@bucketCount,@EndOfDayEndDate)            
								 WHEN 'ww' THEN -- This returns saturday night of the current week
											DATEADD(ww,-@bucketCount,@EndOfDayEndDate)
								 WHEN 'mm' THEN -- 
											DATEADD(mm,-@bucketCount,@EndOfDayEndDate)
								 WHEN 'yy' THEN --This will return the last day of the year
											DATEADD(YY,-@bucketCount,@EndOfDayEndDate)										
					END
				
		--Set The Bucket count to the next bucket
		SET @BucketCount=@BucketCount+1                         

END

DECLARE @MaxBucketCount INT
SET @MaxBucketCount=(SELECT MAX(BucketID) FROM #BucketTable)
SET @BucketCount=(SELECT MIN(BucketId) FROM #BucketTable)


WHILE @BucketCount<=@MaxBucketCount

BEGIN 



	SET @EndDate=(SELECT EndPeriod FROM #BucketTable WHERE BucketID=@BucketCount)


 

	
SET @EndDate = DATEADD(S,-1,DATEADD(D,1,dbo.fn_DateOnly( @EndDate )))	

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL	READ UNCOMMITTED


	
CREATE TABLE #BLLMax
    (
      PracticeID INT ,
      ClaimID INT ,
      ClaimTransactionID INT ,
      TypeGroup VARCHAR(20)
    )
	
CREATE TABLE #BLL
    (
      PracticeID INT ,
      ClaimID INT ,
      PostingDate DATETIME ,
      TypeGroup VARCHAR(20)
    )

CREATE TABLE #AR_ASN
    (
      PracticeID INT ,
      PatientID INT ,
      ClaimID INT ,
      InsAmount MONEY ,
      PatAmount MONEY ,
      UnasgnAmount MONEY ,
      ServiceDate DATETIME ,
      ServicePostingDate DATETIME ,
      TypeCode CHAR(1) ,
      InsurancePolicyID INT ,
      InsuranceCompanyPlanID INT ,
      InsuranceCompanyID INT
    )





	
CREATE TABLE #AR
    (
      PracticeID INT ,
      PaymentID INT ,
      RespID INT ,
      ClaimID INT ,
      ARAmount MONEY ,
      ServiceDate DATETIME ,
      ServicePostingDate DATETIME ,
      TypeGroup VARCHAR(20) ,
      TypeSort INT
    )
CREATE TABLE #ReportResults
    (
      PracticeID INT ,
      RespID INT ,
      TypeGroup VARCHAR(128) ,
      TypeSort INT ,
      TotalBalance MONEY
    )



	
CREATE TABLE #ASNMax
    (
      ClaimID INT ,
      ClaimTransactionID INT
    )


CREATE TABLE #ASN
    (
      ClaimID INT ,
      InsurancePolicyID INT ,
      InsuranceCompanyPlanID INT ,
      InsurancecompanyID INT
    )
INSERT  INTO #ASNMax
        ( ClaimID ,
          ClaimTransactionID
        )
        SELECT  CAA.ClaimID ,
                MAX(ClaimTransactionID) ClaimTransactionID
        FROM    ClaimAccounting_Assignments CAA
        WHERE   PracticeID = @PracticeID
                AND caa.PostingDate <= @EndDate AND caa.PostingDate>=@BeginARDate
        GROUP BY CAA.ClaimID
	
	

INSERT  INTO #ASN
        ( ClaimID ,
          InsurancePolicyID ,
          InsuranceCompanyPlanID ,
          InsuranceCompanyID
        )
        SELECT  CAA.ClaimID ,
                ip.InsurancePolicyID ,
                ip.InsuranceCompanyPlanID ,
                icp.InsuranceCompanyID
        FROM    ClaimAccounting_Assignments CAA
                INNER JOIN #ASNMax AM ON CAA.ClaimID = AM.ClaimID
                                         AND CAA.ClaimTransactionID = AM.ClaimTransactionID
                LEFT JOIN InsurancePolicy ip ON caa.PracticeID = ip.PracticeID
                                                AND CAA.InsurancePolicyID = IP.InsurancePolicyID
                LEFT JOIN InsuranceCompanyPlan icp ON CAA.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
        WHERE   CAA.PracticeID = @PracticeID
                AND CAA.PostingDate <= @EndDate AND caa.PostingDate>=@beginARDate
	-----------------------------------------------------------------------


 
			--Patient and Insurance
INSERT  INTO #AR_ASN
        ( PracticeID ,
          patientID ,
          ClaimID ,
          ServiceDate ,
          ServicePostingDate ,
          UnasgnAmount ,
          InsAmount ,
          PatAmount ,
          TypeCode ,
          InsurancePolicyID ,
          InsuranceCompanyPlanID ,
          InsuranceCompanyID
				
        )
        SELECT  CA.PracticeID ,
                EDP.patientID ,
                ca.ClaimID ,
                EDP.ProcedureDateOfService ,
                eDP.EncounterDate PostingDate ,
                UnasgnAmount = SUM(CASE WHEN asn.CLaimID IS NULL
                                        THEN CASE WHEN ClaimTransactionTypeCode = 'PAY'
                                                       AND ca.ca_PostingDate > @EndDate
                                                  THEN 0	-- we can not take future payments
                                                  WHEN ClaimTransactionTypeCode = 'CST'
                                                  THEN amount
                                                  ELSE -1 * Amount
                                             END
                                        ELSE 0
                                   END) ,
                InsAmount = SUM(CASE WHEN asn.CLaimID IS NULL THEN 0 -- 'Unassigned'
                                     WHEN ClaimTransactionTypeCode = 'PAY'
                                          AND PayerTypeCode = 'P' -- Exclude patient payment against total
                                          THEN 0
                                     WHEN InsurancePolicyID IS NOT NULL
                                     THEN CASE WHEN ClaimTransactionTypeCode = 'CST'
                                               THEN AMOUNT
                                               ELSE -1 * AMOUNT
                                          END
                                     ELSE 0
                                END) ,
                PatAmount = SUM(CASE WHEN asn.CLaimID IS NULL THEN 0 -- 'Unassigned'		
                                     WHEN ClaimTransactionTypeCode = 'PAY'
                                          AND PayerTypeCode = 'P' -- Include patient payment against total
                                          THEN Amount * -1
                                     WHEN InsurancePolicyID IS NULL -- Assinged to patient
                                          THEN CASE WHEN ClaimTransactionTypeCode = 'CST'
                                                    THEN Amount
                                                    ELSE Amount * -1
                                               END
                                     ELSE 0
                                END) ,
                CASE WHEN InsurancePolicyID IS NULL THEN 'P'
                     ELSE 'I'
                END ,
                asn.InsurancePolicyID ,
                asn.InsuranceCompanyPlanID ,
                asn.InsuranceCompanyID
        FROM    vReportDataProvider_Claim_ClaimAccounting CA WITH ( NOEXPAND )
                INNER JOIN vReportDataProvider_Encounter_Doctor_Patient AS EDP
                WITH ( NOEXPAND ) ON CA.PracticeID = EDP.PRacticeID
                                     AND edp.EncounterProcedureID = CA.EncounterPRocedureID
                INNER JOIN #ASN asn ON asn.ClaimID = ca.ClaimID
                LEFT JOIN Payment PMT ON PMT.PracticeID = ca.PracticeID
                                         AND PMT.PaymentID = ca.PaymentID
        WHERE   ca.PracticeID = @PracticeID
                AND ca.ca_PostingDate <= @Enddate
                AND ClaimTransactionTypeCode IN ( 'PAY', 'ADJ', 'CST' )
				AND edp.DoctorID=isnull(@ProviderId,edp.DoctorID)
        GROUP BY Ca.PracticeID ,
                ca.ClaimID ,
                edp.ProcedureDateOfService ,
                edp.EncounterDate ,
                edp.patientID ,
                CASE WHEN InsurancePolicyID IS NULL THEN 'P'
                     ELSE 'I'
                END ,
                asn.InsurancePolicyID ,
                asn.InsuranceCompanyPlanID ,
                asn.InsuranceCompanyID
	
	
	

	







			--------------- Figures out co-pay ----------------

		
UPDATE  asn
SET     insAmount = ISNULL(insAmount, 0) - ISNULL(ca.amount, 0) ,
        patAmount = ISNULL(PatAmount, 0) + ISNULL(ca.amount, 0)
FROM    #AR_ASN asn
        INNER JOIN ( SELECT PracticeID ,
                            ClaimID ,
                            SUM(Amount) Amount
                     FROM   ClaimAccounting ca
                     WHERE  ClaimTransactionTypeCode = 'PRC'
                            AND ca.PostingDate <= @Enddate
                     GROUP BY ClaimID ,
                            PracticeID
                   ) AS ca ON ca.ClaimID = asn.ClaimID
                              AND ca.PracticeID = asn.PracticeID
WHERE   TypeCode = 'I'
        AND ASN.PracticeID = @PracticeID


			-- Insurance's responsibility
INSERT  INTO #AR
        ( PracticeID ,
          RespID ,
          ClaimID ,
          ServiceDate ,
          ServicePostingDate ,
          ARAmount ,
          TypeGroup ,
          TypeSort
				
        )
        SELECT  c.PracticeID ,
                c.InsuranceCompanyPlanID AS RespID ,
                c.ClaimID ,
                c.ServiceDate ,
                c.ServicePostingDate ,
                c.insAmount ,
                TypeGroup = 'Insurance' ,
                TypeSort = 1
        FROM    #AR_ASN c
        WHERE   c.insAmount <> 0

	
			-- Patient's responsibility
INSERT  INTO #AR
        ( PracticeID ,
          RespID ,
          ClaimID ,
          ServiceDate ,
          ServicePostingDate ,
          ARAmount ,
          TypeGroup ,
          TypeSort
				
        )
        SELECT  c.PracticeID ,
                patientID AS RespID ,
                c.ClaimID ,
                c.ServiceDate ,
                c.ServicePostingDate ,
                c.patAmount ,
                TypeGroup = 'Patient' ,
                TypeSort = 2
        FROM    #AR_ASN c
        WHERE   patAmount <> 0

	

		
IF @DateType = 'F'
    BEGIN
			--Get First Billed Info
        INSERT  INTO #BLLMax
                ( PracticeID ,
                  ClaimID ,
                  ClaimTransactionID ,
                  TypeGroup
                )
                SELECT  CAB.PracticeID ,
                        CAB.ClaimID ,
                        MIN(ClaimTransactionID) ClaimTransactionID ,
                        CASE WHEN BatchType = 'S' THEN 'Patient'
                             ELSE 'Insurance'
                        END
                FROM    ClaimAccounting_Billings CAB
                        INNER JOIN #AR ar ON CAB.ClaimID = AR.ClaimID
                                             AND cab.PracticeID = AR.PracticeID
                WHERE   cab.PostingDate <= @EndDate 			
				--AND EXISTS(SELECT * FROM #AR ar WHERE CAB.ClaimID=AR.ClaimID AND CAB.PracticeID=AR.PracticeID)
                GROUP BY CAB.PracticeID ,
                        CAB.ClaimID ,
                        CASE WHEN BatchType = 'S' THEN 'Patient'
                             ELSE 'Insurance'
                        END
				
			
		
		
        INSERT  #BLL
                ( PracticeID ,
                  ClaimID ,
                  PostingDate ,
                  TypeGroup
                )
                SELECT  CAB.PracticeID ,
                        CAB.ClaimID ,
                        CAB.PostingDate ,
                        bm.TypeGroup
                FROM    #BLLMax BM
                        INNER JOIN ClaimAccounting_Billings CAB ON CAB.ClaimTransactionID = BM.ClaimTransactionID
                                                              AND CAB.ClaimId = BM.ClaimID
                                                              AND BM.PracticeID = CAB.PracticeID
    END
		

		

		


----------------------------------------			
INSERT  INTO #ReportResults
        ( PracticeID ,
          RespID ,
          TypeGroup ,
          TypeSort ,
          TotalBalance
		)
        SELECT  AR.PracticeID ,
                RespID ,
                ISNULL(ar.TypeGroup, 'Unassigned') ,
                ISNULL(TypeSort, 4) ,
                SUM(ARAmount) TotalBalance
        FROM    ( SELECT    PracticeID ,
                            RespID ,
                            ClaimID ,
                            TypeGroup ,
                            TypeSort ,
                            SUM(ARAmount) ARAmount
                  FROM      #AR
                  GROUP BY  PracticeID ,
                            RespID ,
                            ClaimID ,
                            TypeGroup ,
                            TypeSort
                ) AS AR
                LEFT JOIN #BLL BLL ON AR.ClaimID = BLL.ClaimID
                                      AND ( ( @DateType IN ( 'F', 'L' )
                                              AND bll.TypeGroup = ar.TypeGroup
                                            )
                                            OR ( @DateType NOT IN ( 'F', 'L' ) )
                                          )
        WHERE   ar.claimID IN ( SELECT  claimID
                                FROM    #AR aa
                                GROUP BY claimID
                                HAVING  SUM(ARAmount) <> 0 )
        GROUP BY AR.PracticeID ,
                RespID ,
                ar.TypeGroup ,
                TypeSort;


WITH    ARReport_CTE ( NAME, TotalBalance )
          AS ( SELECT   CASE WHEN ic.InsuranceCompanyName IS NULL
                                  AND typeSort = 2 THEN 'Patient'
                             WHEN ic.InsuranceCompanyName IS NULL
                                  AND typeSort <> 2 THEN 'All Others'
                             ELSE InsuranceCompanyName
                        END AS NAME ,
                        SUM(TotalBalance) AS TotalBalance
               FROM     #ReportResults r
                        LEFT JOIN InsuranceCompanyPlan AS icp ON r.respId = icp.InsuranceCompanyPlanId
                        LEFT JOIN dbo.InsuranceCompany IC ON IC.InsuranceCompanyID = icp.InsuranceCompanyID
               --WHERE    TotalBalance <> 0
               GROUP BY CASE WHEN ic.InsuranceCompanyName IS NULL
                                  AND typeSort = 2 THEN 'Patient'
                             WHEN ic.InsuranceCompanyName IS NULL
                                  AND typeSort <> 2 THEN 'All Others'
                             ELSE InsuranceCompanyName
                        END
             )


INSERT INTO #FinalTotals
    SELECT  Name ,
            TotalBalance ,
            RANK,
			@EndDate
    FROM    ( SELECT    Name ,
                        TotalBalance ,
                        ROW_NUMBER() OVER ( ORDER BY TotalBalance DESC ) AS [Rank]
              FROM      ARReport_CTE
              WHERE     name <> 'Patient'
            ) INS
    WHERE   Rank BETWEEN 1 AND @NofIns
    UNION ALL
    SELECT  'All Others' ,
            SUM(TotalBalance) AS TotalBalance ,
            11,
			@EndDate
    FROM    ( SELECT    Name ,
                        TotalBalance ,
                        ROW_NUMBER() OVER ( ORDER BY TotalBalance DESC ) AS [Rank]
              FROM      ARReport_CTE
              WHERE     name <> 'Patient'
            ) INS
    WHERE   Rank > @NofIns
    UNION ALL
    SELECT  Name ,
            TotalBalance ,
            12,
			@EndDate
    FROM    ARReport_CTE
    WHERE   name = 'Patient'


	
DROP TABLE #AR, #AR_ASN
DROP TABLE #ASNMAX, #ASN
DROP TABLE #BLL
DROP TABLE #ReportResults
DROP TABLE #BLLMax


SET @BucketCount=@BucketCount+1

END
 		
SELECT InsuranceCompany, TotalBalance, [Rank],Period	
FROM #FinalTotals

UNION All


SELECT 'MaxTotalBalance', MaxTotalBalance, 100, ft.Period
FROM (
Select        MAX(TotalBalance) AS MaxTotalBalance
FROM    ( SELECT    period ,
                    SUM(totalbalance) AS TotalBalance
          FROM      #FinalTotals
          GROUP BY  period
        ) sub
) sub2 
 JOIN #FinalTotals FT ON Sub2.MaxTotalBalance=FT.TotalBalance
 UNION ALL
 SELECT 'AvgTotalBalance', AvgTotalBalance, 101, Null
FROM (
Select       AVg(TotalBalance) AS AvgTotalBalance
FROM    ( SELECT    period ,
                    SUM(totalbalance) AS TotalBalance
          FROM      #FinalTotals
          GROUP BY  period
        ) sub)sub2




--DROP TABLE #AR, #AR_ASN
--DROP TABLE #ASNMAX, #ASN
--DROP TABLE #BLL
--DROP TABLE #ReportResults
--DROP TABLE #BLLMax
DROP TABLE #FinalTotals
DROP TABLE #BucketTable





GO


