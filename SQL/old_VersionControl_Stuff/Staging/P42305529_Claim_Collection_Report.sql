BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

/*
-- kprod-db31
USE superbill_0242_dev;
GO
USE superbill_0242_prod;
GO
*/

----------- test: WebServiceDataProvider_ChargesExport 'cardio', @PatientName = 'debbie arrington'
--ALTER proc [dbo].[WebServiceDataProvider_ChargesExport]
--	@PracticeName varchar(100) = null,						 
--	@FromCreatedDate datetime = null,						
--	@ToCreatedDate datetime = null,							
--	@FromLastModifiedDate datetime = null,					
--	@ToLastModifiedDate datetime = null,					
--	@PatientName varchar(100) = null,						
--	@CasePayerScenario varchar(100) = null,					
--	@FromServiceDate datetime = null,						
--	@ToServiceDate datetime = null,							
--	@FromPostingDate datetime = null,						
--	@ToPostingDate datetime = null,							
--	@BatchNumber varchar(100) = null,						
--	@SchedulingProviderFullName varchar(256) = null,		
--	@RenderingProviderFullName varchar(256) = null,			
--	@ReferringProviderFullName varchar(256) = null,			
--	@ServiceLocationName varchar(256) = null,				
--	@ProcedureCode varchar(max) = NULL,						
--	@DiagnosisCode varchar(max) = NULL,						
--	@Status varchar(max) = NULL,							
--	@BilledTo varchar(max) = NULL,	
--	@IncludeUnapprovedCharges bit = 0,	
--	@EncounterStatus varchar(50) = NULL
--AS


IF OBJECT_ID('tempdb..#asn') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#asn;
    END
GO
IF OBJECT_ID('tempdb..#ar_asn') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#ar_asn;
    END
GO
IF OBJECT_ID('tempdb..#claims') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#claims;
    END
GO
IF OBJECT_ID('tempdb..#ClaimInsurance') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#ClaimInsurance;
    END
GO
IF OBJECT_ID('tempdb..#minContractAdjustment') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#minContractAdjustment;
    END
GO
IF OBJECT_ID('tempdb..#ClaimPayment') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#ClaimPayment;
    END
GO
IF OBJECT_ID('tempdb..#ClaimEOB') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#ClaimEOB;
    END
GO
IF OBJECT_ID('tempdb..#payments') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#payments;
    END
GO
IF OBJECT_ID('tempdb..#Adjustment') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#Adjustment;
    END
GO
IF OBJECT_ID('tempdb..#AR') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#AR;
    END
GO
IF OBJECT_ID('tempdb..#ASNMax') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#ASNMax;
    END
GO




DECLARE @PracticeName VARCHAR(100) ,
    @FromCreatedDate DATETIME ,
    @ToCreatedDate DATETIME ,
    @FromLastModifiedDate DATETIME ,
    @ToLastModifiedDate DATETIME ,
    @PatientName VARCHAR(100) ,
    @CasePayerScenario VARCHAR(100) ,
    @FromServiceDate DATETIME ,
    @ToServiceDate DATETIME ,
    @FromPostingDate DATETIME ,
    @ToPostingDate DATETIME ,
    @BatchNumber VARCHAR(100) ,
    @SchedulingProviderFullName VARCHAR(256) ,
    @RenderingProviderFullName VARCHAR(256) ,
    @ReferringProviderFullName VARCHAR(256) ,
    @ServiceLocationName VARCHAR(256) ,
    @ProcedureCode VARCHAR(MAX) ,
    @DiagnosisCode VARCHAR(MAX) ,
    @Status VARCHAR(MAX) ,
    @BilledTo VARCHAR(MAX) ,
    @IncludeUnapprovedCharges BIT ,
    @EncounterStatus VARCHAR(50)

-- select * from practice where active = 1			
SELECT  @PracticeName = 'VALLEY INTERNAL MED AND PEDIATRIC' ,
        @FromCreatedDate = NULL ,
        @ToCreatedDate = NULL ,
        @FromLastModifiedDate = NULL ,
        @ToLastModifiedDate = NULL ,
        @PatientName = NULL ,
        @CasePayerScenario = NULL ,
        @FromServiceDate = NULL ,
        @ToServiceDate = NULL ,
        @FromPostingDate = NULL ,
        @ToPostingDate = NULL ,
        @BatchNumber = NULL ,
        @SchedulingProviderFullName = NULL ,
        @RenderingProviderFullName = NULL ,
        @ReferringProviderFullName = NULL ,
        @ServiceLocationName = NULL ,
        @ProcedureCode = NULL ,
        @DiagnosisCode = NULL ,
        @Status = NULL ,
        @BilledTo = NULL ,
        @IncludeUnapprovedCharges = 0 ,
        @EncounterStatus = NULL


BEGIN

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
    DECLARE @now DATETIME
    SELECT  @now = GETDATE();

	-- patch up if they specified only one of modified date pair
    IF @FromLastModifiedDate IS NOT NULL
        AND @ToLastModifiedDate IS NULL 
        BEGIN
            SET @ToLastModifiedDate = CAST(CONVERT(VARCHAR, DATEADD(dd, 7,
                                                              @FromLastModifiedDate), 110) AS DATETIME)
        END
    ELSE 
        IF @FromLastModifiedDate IS NULL
            AND @ToLastModifiedDate IS NOT NULL 
            BEGIN
                SET @FromLastModifiedDate = CAST(CONVERT(VARCHAR, DATEADD(dd,
                                                              -7,
                                                              @ToLastModifiedDate), 110) AS DATETIME)
            END

	-- patch up if they specified only one of modified date pair
    IF @FromCreatedDate IS NOT NULL
        AND @ToCreatedDate IS NULL 
        BEGIN
            SET @ToCreatedDate = CAST(CONVERT(VARCHAR, DATEADD(dd, 7,
                                                              @FromCreatedDate), 110) AS DATETIME)
        END
    ELSE 
        IF @FromCreatedDate IS NULL
            AND @ToCreatedDate IS NOT NULL 
            BEGIN
                SET @FromCreatedDate = CAST(CONVERT(VARCHAR, DATEADD(dd, -7,
                                                              @ToCreatedDate), 110) AS DATETIME)
            END

	-- patch up if they specified only one of service date pair
    IF @FromServiceDate IS NOT NULL
        AND @ToServiceDate IS NULL 
        BEGIN
            SET @ToServiceDate = CAST(CONVERT(VARCHAR, DATEADD(dd, 7,
                                                              @FromServiceDate), 110) AS DATETIME)
        END
    ELSE 
        IF @FromServiceDate IS NULL
            AND @ToServiceDate IS NOT NULL 
            BEGIN
                SET @FromServiceDate = CAST(CONVERT(VARCHAR, DATEADD(dd, -7,
                                                              @ToServiceDate), 110) AS DATETIME)
            END

	-- patch up if they specified only one of Posting date pair
    IF @FromPostingDate IS NOT NULL
        AND @ToPostingDate IS NULL 
        BEGIN
            SET @ToPostingDate = CAST(CONVERT(VARCHAR, DATEADD(dd, 7,
                                                              @FromPostingDate), 110) AS DATETIME)
        END
    ELSE 
        IF @FromPostingDate IS NULL
            AND @ToPostingDate IS NOT NULL 
            BEGIN
                SET @FromPostingDate = CAST(CONVERT(VARCHAR, DATEADD(dd, -7,
                                                              @ToPostingDate), 110) AS DATETIME)
            END

	-- if they haven't specified complete dates for posting, lastmodified, transaction or service dates, then we'll put in some range for posting date
    IF ( @FromPostingDate IS NULL )
        AND ( @ToPostingDate IS NULL )
        AND ( @FromLastModifiedDate IS NULL )
        AND ( @ToLastModifiedDate IS NULL )
        AND ( @FromServiceDate IS NULL )
        AND ( @ToServiceDate IS NULL )
        AND ( @FromCreatedDate IS NULL )
        AND ( @ToCreatedDate IS NULL ) 
        BEGIN
            SET @FromPostingDate = CAST(CONVERT(VARCHAR, DATEADD(dd, -7,
                                                              GETDATE()), 110) AS DATETIME)
            SET @ToPostingDate = CAST(CONVERT(VARCHAR, DATEADD(dd, 7,
                                                              @FromPostingDate), 110) AS DATETIME)
        END

	-- for all the "to" dates, we need to do the following logic:
	--    if they specified a specific time, honor that specific time.
	--    if they specified just a date, then look for everything through the end of that date
    SET @ToCreatedDate = CASE WHEN DBO.fn_DateOnly(@ToCreatedDate) = @ToCreatedDate
                              THEN DATEADD(S, -1,
                                           DBO.fn_DateOnly(DATEADD(D, 1,
                                                              @ToCreatedDate)))
                              ELSE @ToCreatedDate
                         END
    SET @ToLastModifiedDate = CASE WHEN DBO.fn_DateOnly(@ToLastModifiedDate) = @ToLastModifiedDate
                                   THEN DATEADD(S, -1,
                                                DBO.fn_DateOnly(DATEADD(D, 1,
                                                              @ToLastModifiedDate)))
                                   ELSE @ToLastModifiedDate
                              END
    SET @ToServiceDate = CASE WHEN DBO.fn_DateOnly(@ToServiceDate) = @ToServiceDate
                              THEN DATEADD(S, -1,
                                           DBO.fn_DateOnly(DATEADD(D, 1,
                                                              @ToServiceDate)))
                              ELSE @ToServiceDate
                         END
    SET @ToPostingDate = CASE WHEN DBO.fn_DateOnly(@ToPostingDate) = @ToPostingDate
                              THEN DATEADD(S, -1,
                                           DBO.fn_DateOnly(DATEADD(D, 1,
                                                              @ToPostingDate)))
                              ELSE @ToPostingDate
                         END
        
    DECLARE @CheckForNoASN TABLE
        (
          ClaimID INT ,
          NoASN BIT ,
          CTPostingDate DATETIME
        )
    DECLARE @AssignmentInfo TABLE
        (
          ClaimID INT ,
          InsurancePolicyID INT ,
          InsuranceCompanyPlanID INT
        )
        
    CREATE TABLE #Claims
        (
          claimID INT ,
          CreatedDate DATETIME ,
          ModifiedDate DATETIME ,
          ClaimServiceDateFrom DATETIME ,
          ClaimServiceDateTo DATETIME ,
          PracticeId INT ,
          ClaimStatusCode CHAR(1) ,
          Status VARCHAR(128) ,
          AssignedToDisplayName VARCHAR(256) ,
          encounterID INT ,
          encounterProcedureID INT ,
          ContractID INT ,
          ProcedureCodeDictionaryID INT ,
          PatientID INT ,
          AllowedAmount MONEY ,
          ExpectedAmount MONEY ,
          ProcedureModifier1 VARCHAR(16) ,
          patientCaseID INT ,
          DateOfService DATETIME ,
          PrimaryInsPaymentID INT ,
          SecondaryInsPaymentID INT ,
          OtherInsPaymentID INT ,
          OtherInsPaymentAmount MONEY ,
          PatientPaymentID INT ,
          PatientPaymentAmount MONEY ,
          PostingDate DATETIME
        )

    INSERT  #Claims
            ( claimID ,
              CreatedDate ,
              ModifiedDate ,
              ClaimServiceDateFrom ,
              ClaimServiceDateTo ,
              PracticeId ,
              ClaimStatusCode ,
              Status ,
              encounterID ,
              ContractID ,
              encounterProcedureID ,
              ProcedureCodeDictionaryID ,
              PatientID ,
              ProcedureModifier1 ,
              patientCaseID ,
              DateOfService ,
              PostingDate
            )
            SELECT  c.ClaimID ,
                    c.CreatedDate ,
                    c.ModifiedDate ,
                    ep.ProcedureDateOfService ,
                    ep.ServiceEndDate ,
                    c.PracticeId ,
                    c.ClaimStatusCode ,
                    CASE WHEN cae.ClaimTransactionTypeCode IS NOT NULL
                         THEN CASE cae.ClaimTransactionTypeCode
                                WHEN 'RJT' THEN 'Error - Rejection'
                                WHEN 'DEN' THEN 'Error - Denial'
                                WHEN 'BLL' THEN 'Error - No Response'
                                ELSE 'Error'
                              END
                         WHEN C.ClaimStatusCode = 'C' THEN 'Completed'
                         WHEN C.ClaimStatusCode = 'P' THEN 'Pending'
                         WHEN C.ClaimStatusCode = 'R' THEN 'Ready'
                         ELSE '*** Undefined'
                    END AS Status ,
                    e.EncounterID ,
                    ep.ContractID ,
                    ep.encounterProcedureID ,
                    ep.ProcedureCodeDictionaryID ,
                    e.PatientID ,
                    ep.ProcedureModifier1 ,
                    e.patientCaseID ,
                    e.DateOfService ,
                    ct.PostingDate
            FROM    Encounter e
                    INNER JOIN EncounterProcedure ep ON e.PracticeID = ep.PracticeID
                                                        AND e.EncounterID = ep.EncounterID
                    INNER JOIN Claim c ON c.PracticeID = ep.PracticeID
                                          AND c.EncounterProcedureID = ep.EncounterProcedureID
--					inner join PatientCase pc on pc.PatientCaseID = e.PatientCaseID
--					inner join Doctor d on D.DoctorID = e.DoctorID and e.PracticeID = d.PracticeID
                    LEFT JOIN [dbo].[fn_ReportDataProvider_ParseProcedureCode](@ProcedureCode) pcs ON pcs.ProcedureCodeDictionaryID = ep.ProcedureCodeDictionaryID
                    LEFT JOIN dbo.ClaimAccounting_Errors cae ON cae.PracticeID = c.practiceId
                                                              AND cae.ClaimID = c.ClaimID
                    INNER JOIN Practice prac ON prac.PracticeId = e.PracticeId
                    INNER JOIN ClaimTransaction CT ON CT.ClaimID = c.ClaimId
                                                      AND CT.PracticeId = c.PracticeId
                                                      AND CT.ClaimTransactionTypeCode = 'CST'
            WHERE   ( @PracticeName IS NULL
                      OR prac.Name LIKE '%' + @PracticeName + '%'
                      AND prac.active = 1
                    )




    INSERT  @AssignmentInfo
            ( ClaimID ,
              InsurancePolicyID ,
              InsuranceCompanyPlanID
            )
            SELECT  CAA.ClaimID ,
                    CAA.InsurancePolicyID ,
                    CAA.InsuranceCompanyPlanID
            FROM    #Claims C
                    INNER JOIN dbo.ClaimAccounting_Assignments CAA ON C.ClaimID = CAA.ClaimID
                                                              AND CAA.LastAssignment = 1


    INSERT  @CheckForNoASN
            ( ClaimID ,
              NoASN ,
              CTPostingDate
            )
            SELECT  C.ClaimID ,
                    CASE WHEN COUNT(CASE WHEN CT.ClaimTransactionTypeCode = 'ASN'
                                         THEN 1
                                         ELSE NULL
                                    END) = 0 THEN 1
                         ELSE 0
                    END NoASN ,
                    MIN(CASE WHEN ClaimTransactionTypeCode = 'CST'
                             THEN CT.PostingDate
                             ELSE NULL
                        END) CTPostingDate
            FROM    #Claims C
                    INNER JOIN dbo.ClaimTransaction CT ON C.ClaimID = CT.ClaimID
                                                          AND CT.ClaimTransactionTypeCode IN (
                                                          'CST', 'ASN' )
            GROUP BY C.ClaimID

    UPDATE  #Claims
    SET     AssignedToDisplayName = XX.AssignedToDisplayName
    FROM    #Claims
            JOIN ( SELECT   #Claims.ClaimId ,
                            AssignedToDisplayName = ISNULL(CAST (( CASE
                                                              WHEN #Claims.ClaimStatusCode = 'C'
                                                              OR CFN.NoASN = 1
                                                              THEN 'Unassigned'
                                                              WHEN CAA.InsurancePolicyID IS NULL
                                                              THEN 'Patient'
                                                              ELSE NULL
                                                              END ) AS VARCHAR(100)),
                                                           ICP.PlanName)
                   FROM     #Claims
                            LEFT JOIN @AssignmentInfo CAA ON #Claims.ClaimID = CAA.ClaimID
                            LEFT JOIN dbo.InsuranceCompanyPlan ICP ON CAA.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
                            INNER JOIN @CheckForNoASN CFN ON #Claims.ClaimID = CFN.ClaimID
                 ) XX ON #Claims.ClaimId = XX.ClaimId
			


    IF @DiagnosisCode IS NOT NULL 
        BEGIN

			-- Phil: fixed a bug here, first reported in SF 76494, FB 25590
			--    We used to delete anything that had NULL when matching fn_ReportDataProvider_ParseDiagnosisCode
			--    Unfortunately, this would delete any claim that had multiple Dx in even if one of the dx happened to be one we were looking for
            DELETE  a
            FROM    #Claims a
            WHERE   a.ClaimId NOT IN (
                    SELECT  a.ClaimId
                    FROM    #Claims a
                            INNER JOIN EncounterProcedure ep ON ep.EncounterProcedureID = a.EncounterProcedureID
                            INNER JOIN EncounterDiagnosis ed ON ed.EncounterID = ep.EncounterID
                                                              AND ed.EncounterDiagnosisID IN (
                                                              ep.EncounterDiagnosisID1,
                                                              ep.EncounterDiagnosisID2,
                                                              ep.EncounterDiagnosisID3,
                                                              ep.EncounterDiagnosisID4 )
                            LEFT JOIN [dbo].[fn_ReportDataProvider_ParseDiagnosisCode](@DiagnosisCode) ecd ON ecd.DiagnosisCodeDictionaryID = ed.DiagnosisCodeDictionaryID
                    WHERE   ecd.DiagnosisCodeDictionaryID IS NOT NULL )			
				

        END

	        
    UPDATE  c
    SET     AllowedAmount = cfs.Allowable ,
            ExpectedAmount = cfs.ExpectedReimbursement
    FROM    #Claims c
            INNER JOIN ContractFeeSchedule cfs ON cfs.ProcedureCodeDictionaryID = c.ProcedureCodeDictionaryID
                                                  AND cfs.ContractID = c.contractID
            INNER JOIN Patient pat ON pat.PatientID = c.PatientID
    WHERE   ( ( Pat.Gender = CFS.Gender )
              OR CFS.Gender = 'B'
            )
            AND ( ( ISNULL(c.ProcedureModifier1, '') = ISNULL(CFS.Modifier, '') )
                  OR CFS.Modifier IS NULL
                )




    CREATE TABLE #ClaimInsurance
        (
          claimID INT ,
          PrimaryInsuranceCompanyPlanID INT ,
          PrimaryInsuranceFirstBillDate DATETIME ,
          PrimaryInsuranceLastBillDate DATETIME ,
          SecondaryInsuranceCompanyPlanID INT ,
          SecondaryInsuranceFirstBillDate DATETIME ,
          SecondaryInsuranceLastBillDate DATETIME ,
          TertiaryInsuranceCompanyPlanID INT ,
          PatientFirstBillDate DATETIME ,
          PatientLastBillDate DATETIME
        )
                
    INSERT  #ClaimInsurance
            ( claimID ,
              PrimaryInsuranceCompanyPlanID ,
              SecondaryInsuranceCompanyPlanID ,
              TertiaryInsuranceCompanyPlanID 
            )
            SELECT  c.claimID ,
                    PrimaryInsuranceCompanyPlanID = CASE WHEN ip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(c.patientCaseID,
                                                              DateOfService, 0)
                                                         THEN ip.InsuranceCompanyPlanID
                                                         ELSE NULL
                                                    END ,
                    SecondaryInsuranceCompanyPlanID = CASE WHEN Sip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(c.patientCaseID,
                                                              DateOfService,
                                                              ip.Precedence)
                                                           THEN Sip.InsuranceCompanyPlanID
                                                           ELSE NULL
                                                      END ,
                    TertiaryInsuranceCompanyPlanID = CASE WHEN Tip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(c.patientCaseID,
                                                              DateOfService,
                                                              Sip.Precedence)
                                                          THEN Tip.InsuranceCompanyPlanID
                                                          ELSE NULL
                                                     END
            FROM    #Claims c
                    INNER JOIN PatientCase pc ON pc.PatientCaseID = c.patientCaseID
                    INNER JOIN InsurancePolicy ip ON ip.PatientCaseID = c.patientCaseID
                                                     AND ip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(c.patientCaseID,
                                                              DateOfService, 0)
                    LEFT JOIN InsurancePolicy Sip ON Sip.PatientCaseID = c.patientCaseID
                                                     AND Sip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(c.patientCaseID,
                                                              DateOfService,
                                                              ip.Precedence)
                    LEFT JOIN InsurancePolicy Tip ON Tip.PatientCaseID = c.patientCaseID
                                                     AND Tip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(c.patientCaseID,
                                                              DateOfService,
                                                              Sip.Precedence)



		------ Primary Insurance First bill
    UPDATE  #ClaimInsurance
    SET     PrimaryInsuranceFirstBillDate = cab.FirstBillDate ,
            PrimaryInsuranceLastBillDate = cab.LastBillDate
    FROM    ( SELECT    ci.claimID ,
                        MIN(cab.PostingDate) AS FirstBillDate ,
                        MAX(cab.PostingDate) AS LastBillDate
              FROM      #ClaimInsurance ci
                        INNER JOIN ClaimAccounting_Billings cab ON ci.claimID = cab.ClaimID
                        INNER JOIN ClaimAccounting_Assignments caa ON ci.claimID = caa.ClaimID
                                                              AND ( ( cab.ClaimTransactionID BETWEEN caa.ClaimTransactionID
                                                              AND
                                                              caa.EndClaimTransactionID )
                                                              OR ( cab.ClaimTransactionID >= caa.ClaimTransactionID
                                                              AND caa.EndClaimTransactionID IS NULL
                                                              )
                                                              )
                                                              AND caa.InsuranceCompanyPlanID = ci.PrimaryInsuranceCompanyPlanID
--				where cab.practiceID = @practiceID
--					AND caa.practiceID = @practiceID
              GROUP BY  ci.claimID
            ) AS cab
    WHERE   cab.claimID = #ClaimInsurance.claimID
        
        
		------ Secondary Insurance Billing Date
    UPDATE  #ClaimInsurance
    SET     SecondaryInsuranceFirstBillDate = cab.FirstBillDate ,
            SecondaryInsuranceLastBillDate = cab.LastBillDate
    FROM    ( SELECT    ci.claimID ,
                        MIN(cab.PostingDate) AS FirstBillDate ,
                        MAX(cab.PostingDate) AS LastBillDate
              FROM      #ClaimInsurance ci
                        INNER JOIN ClaimAccounting_Billings cab ON ci.claimID = cab.ClaimID
                        INNER JOIN ClaimAccounting_Assignments caa ON ci.claimID = caa.ClaimID
                                                              AND ( ( cab.ClaimTransactionID BETWEEN caa.ClaimTransactionID
                                                              AND
                                                              caa.EndClaimTransactionID )
                                                              OR ( cab.ClaimTransactionID >= caa.ClaimTransactionID
                                                              AND caa.EndClaimTransactionID IS NULL
                                                              )
                                                              )
                                                              AND caa.InsuranceCompanyPlanID = ci.SecondaryInsuranceCompanyPlanID
--				where cab.practiceID = @practiceID
--					AND caa.practiceID = @practiceID
              GROUP BY  ci.claimID
            ) AS cab
    WHERE   cab.claimID = #ClaimInsurance.claimID
        
        
        
		------ Patient Billing Date
    UPDATE  #ClaimInsurance
    SET     PatientFirstBillDate = cab.FirstBillDate ,
            PatientLastBillDate = cab.LastBillDate
    FROM    ( SELECT    ci.claimID ,
                        MIN(cab.PostingDate) AS FirstBillDate ,
                        MAX(cab.PostingDate) AS LastBillDate
              FROM      #ClaimInsurance ci
                        INNER JOIN ClaimAccounting_Billings cab ON ci.claimID = cab.ClaimID
                        INNER JOIN ClaimAccounting_Assignments caa ON ci.claimID = caa.ClaimID
                                                              AND ( ( cab.ClaimTransactionID BETWEEN caa.ClaimTransactionID
                                                              AND
                                                              caa.EndClaimTransactionID )
                                                              OR ( cab.ClaimTransactionID >= caa.ClaimTransactionID
                                                              AND caa.EndClaimTransactionID IS NULL
                                                              )
                                                              )
              WHERE     caa.InsuranceCompanyPlanID IS NULL                                
--					AND cab.practiceID = @practiceID
--					AND caa.practiceID = @practiceID
              GROUP BY  ci.claimID
            ) AS cab
    WHERE   cab.claimID = #ClaimInsurance.claimID
        
        
        
        
    UPDATE  c
    SET     c.PrimaryInsPaymentID = priPay.paymentID
    FROM    #Claims c
            INNER JOIN #ClaimInsurance ci ON c.claimID = ci.ClaimID
            INNER JOIN PaymentClaim priPayC ON priPayC.ClaimID = c.claimID
            INNER JOIN Payment priPay ON priPayC.PaymentID = priPay.PaymentID
            INNER JOIN insuranceCompanyPlan icpPayer ON icpPayer.InsuranceCompanyPlanID = priPay.PayerID
                                                        AND priPay.PayerTypeCode = 'I'
            INNER JOIN InsuranceCompanyPlan icpIns ON icpIns.InsuranceCompanyID = icpPayer.InsuranceCompanyID 
--		WHERE priPay.practiceID = @practiceID
--		and priPayC.practiceID = @practiceID
                                                      AND icpINs.InsuranceCompanyPlanID = ci.PrimaryInsuranceCompanyPlanID 
                
                
--         
--         
--         update c
--         SET c.PrimaryInsPaymentID = priPay.paymentID
--         FROM #Claims c
--                 inner join #ClaimInsurance ci on c.claimID = ci.ClaimID
--                 inner join PaymentClaim priPayC on priPayC.ClaimID = c.claimID
--                 inner JOIN Payment priPay on priPayC.PaymentID = priPay.PaymentID             
--         WHERE priPay.practiceID = @practiceID
-- 		and priPayC.practiceID = @practiceID
--                 AND priPay.PayerID = ci.PrimaryInsuranceCompanyPlanID 
--                 and priPay.PayerTypeCode = 'I'
                
                       
                
    UPDATE  c
    SET     c.SecondaryInsPaymentID = priPay.paymentID
    FROM    #Claims c
            INNER JOIN #ClaimInsurance ci ON c.claimID = ci.ClaimID
            INNER JOIN PaymentClaim priPayC ON priPayC.ClaimID = c.claimID
            INNER JOIN Payment priPay ON priPayC.PaymentID = priPay.PaymentID
            INNER JOIN insuranceCompanyPlan icpPayer ON icpPayer.InsuranceCompanyPlanID = priPay.PayerID
                                                        AND priPay.PayerTypeCode = 'I'
            INNER JOIN InsuranceCompanyPlan icpIns ON icpIns.InsuranceCompanyID = icpPayer.InsuranceCompanyID
    WHERE   --			priPay.practiceID = @practiceID
--			and priPayC.practiceID = @practiceID AND
            icpINs.InsuranceCompanyPlanID = ci.SecondaryInsuranceCompanyPlanID
   



		---- the SUM Of various Patient Payments
    UPDATE  c
    SET     c.PatientPaymentID = p.paymentID ,
            c.PatientPaymentAmount = p.Amount
    FROM    #Claims c
            INNER JOIN ( SELECT claimID ,
                                paymentID = MAX(p.paymentID) ,
                                Amount = SUM(Amount)
                         FROM   ClaimAccounting ca
                                INNER JOIN Payment p ON p.PaymentID = ca.PaymentID
                                                        AND ca.PracticeID = p.PracticeID
                         WHERE  --								ca.PracticeID = @practiceID and 
                                ca.ClaimTransactionTypeCode = 'PAY'
                                AND p.PayerTypeCode = 'P'
                         GROUP BY ca.ClaimID
                       ) AS p ON p.claimID = c.claimID 



		---- the SUM Of various Insurance Payments that isn't either the primary or secondary
    UPDATE  c
    SET     c.OtherInsPaymentID = p.paymentID ,
            c.OtherInsPaymentAmount = p.Amount
    FROM    #Claims c
            INNER JOIN ( SELECT ca.claimID ,
                                paymentID = MAX(p.paymentID) ,
                                Amount = SUM(Amount)
                         FROM   ClaimAccounting ca
                                INNER JOIN Payment p ON p.PaymentID = ca.PaymentID --and ca.PracticeID = p.PracticeID
                                INNER JOIN #Claims c ON c.claimID = ca.ClaimID
                                                        AND ( p.PaymentID <> c.PrimaryInsPaymentID
                                                              OR c.PrimaryInsPaymentID IS NULL
                                                            )
                                                        AND ( p.PaymentID <> c.SecondaryInsPaymentID
                                                              OR c.SecondaryInsPaymentID IS NULL
                                                            )
                         WHERE  --								ca.PracticeID = @practiceID and 
                                ca.ClaimTransactionTypeCode = 'PAY'
                                AND p.PayerTypeCode = 'I'
                         GROUP BY ca.ClaimID
                       ) AS p ON p.claimID = c.claimID 
         
         
		--Parse XML eob for denial = true. Extract out type=Reason
    SELECT  rowID = IDENTITY( INT, 1,1 ),
            pc.ClaimID ,
            pc.PaymentID ,
            eboXML.row.value('@type', 'varchar(50)') Type ,
            eboXML.row.value('@amount', 'Money') Amount ,
            eboXML.row.value('@code', 'varchar(50)') Code ,
            eboXML.row.value('@category', 'varchar(50)') Category ,
            eboXML.row.value('@description', 'varchar(250)') Description
    INTO    #ClaimPayment
    FROM    paymentClaim pc
            CROSS APPLY eobXML.nodes('/eob/items/item') AS eboXML ( row )
            INNER JOIN #Claims c ON c.claimID = pc.ClaimID
                                    AND pc.PaymentID IN (
                                    c.PrimaryInsPaymentID,
                                    c.SecondaryInsPaymentID,
                                    c.OtherInsPaymentID )
			--		where pc.practiceID = @practiceID
		-- order by pc.paymentID desc






    CREATE TABLE #minContractAdjustment
        (
          claimID INT ,
          paymentID INT ,
          rowID INT
        )
    INSERT  INTO #minContractAdjustment
            ( claimID ,
              paymentID ,
              rowID 
            )
            SELECT  claimID ,
                    paymentID ,
                    MIN(rowID)
            FROM    #ClaimPayment
            WHERE   TYPE = 'Reason'
                    AND Category = 'CO'
            GROUP BY claimID ,
                    paymentID
        
                
        
		--------- EOB Info
    SELECT  cp.claimID ,
            cp.paymentID ,
            InsuranceAllowed = MAX(CASE WHEN Type = 'Allowed' THEN Amount
                                        ELSE '0'
                                   END) ,
            InsuranceContractAdjustment = MAX(CASE WHEN Type = 'Reason'
                                                        AND Category = 'CO'
                                                        AND minAdj.rowID = cp.rowID
                                                   THEN Amount
                                                   ELSE '0'
                                              END) ,
            InsuranceContractAdjustmentReason = MAX(CASE WHEN Type = 'Reason'
                                                              AND Category = 'CO'
                                                              AND minAdj.rowID = cp.rowID
                                                         THEN ISNULL(a.Description,
                                                              adR.Description)
                                                         ELSE ''
                                                    END) ,
            InsuranceSecondarytAdjustment = MAX(CASE WHEN Type = 'Reason'
                                                          AND Category = 'CO'
                                                          AND minAdj.rowID < cp.rowID
                                                     THEN Amount
                                                     ELSE '0'
                                                END) ,
            InsuranceSecondaryAdjustmentReason = MAX(CASE WHEN Type = 'Reason'
                                                              AND Category = 'CO'
                                                              AND minAdj.rowID < cp.rowID
                                                          THEN ISNULL(a.Description,
                                                              adR.Description)
                                                          ELSE ''
                                                     END) ,
            InsurancePayment = MAX(CASE WHEN Type = 'Paid' THEN Amount
                                        ELSE '0'
                                   END) ,
            InsuranceDeductible = MAX(CASE WHEN Type = 'Reason'
                                                AND cp.Description = '1'
                                           THEN Amount
                                           ELSE '0'
                                      END) ,
            InsuranceCoinsurance = MAX(CASE WHEN Type = 'Reason'
                                                 AND cp.Description = '2'
                                            THEN Amount
                                            ELSE '0'
                                       END) ,
            InsuranceCopay = MAX(CASE WHEN Type = 'Reason'
                                           AND cp.Description = '3'
                                      THEN Amount
                                      ELSE '0'
                                 END)
    INTO    #ClaimEOB
    FROM    #ClaimPayment cp
            LEFT JOIN adjustmentReason adR ON adR.adjustmentReasonCode = cp.Description
            LEFT JOIN Adjustment a ON a.AdjustmentCode = cp.CODE
            LEFT JOIN #minContractAdjustment minAdj ON minAdj.claimID = cp.ClaimID
                                                       AND minAdj.paymentID = cp.PaymentID
    GROUP BY cp.claimID ,
            cp.paymentID
        
        
    CREATE TABLE #payments
        (
          paymentID INT ,
          claimID INT ,
          Amount MONEY
        )
        
    INSERT  INTO #payments
            ( paymentID ,
              claimID ,
              Amount
            )
            SELECT  paymentID ,
                    ca.ClaimID ,
                    SUM(Amount)
            FROM    claimAccounting ca
                    INNER JOIN #Claims c ON c.claimID = ca.ClaimID
                                            AND ca.PaymentID IN (
                                            c.PrimaryInsPaymentID,
                                            c.SecondaryInsPaymentID )
            WHERE   ca.ClaimTransactionTypeCode = 'PAY'
--			and ca.practiceID = @practiceID
            GROUP BY PaymentID ,
                    ca.ClaimID
                
                
                
    CREATE TABLE #Adjustment
        (
          ClaimID INT ,
          Amount MONEY
        )
    INSERT  INTO #Adjustment
            ( ClaimID ,
              Amount
            )
            SELECT  ca.ClaimID ,
                    SUM(Amount)
            FROM    claimAccounting ca
                    INNER JOIN #Claims c ON c.claimID = ca.ClaimID
            WHERE   ca.ClaimTransactionTypeCode = 'ADJ'
--				and ca.practiceID = @practiceID
            GROUP BY ca.ClaimID
                
	                
    CREATE TABLE #AR
        (
          ClaimID INT ,
          Amount MONEY
        )

    INSERT  INTO #AR
            ( ClaimID ,
              Amount
            )
            SELECT  CA.ClaimID ,
                    SUM(CASE WHEN CA.ClaimTransactionTypeCode = 'CST'
                             THEN Amount
                             ELSE Amount * -1
                        END)
            FROM    ClaimAccounting CA
                    INNER JOIN #Claims C ON C.ClaimId = CA.ClaimId
            WHERE   CA.ClaimTransactionTypeCode IN ( 'CST', 'ADJ', 'PAY' )
            GROUP BY CA.ClaimID

    CREATE TABLE #ASNMax
        (
          ClaimID INT ,
          ClaimTransactionID INT
        )
    INSERT  INTO #ASNMax
            ( ClaimID ,
              ClaimTransactionID
            )
            SELECT  CAA.ClaimID ,
                    MAX(ClaimTransactionID) ClaimTransactionID
            FROM    ClaimAccounting_Assignments CAA
                    INNER JOIN #AR ar ON ar.CLaimID = caa.CLaimID
            GROUP BY CAA.ClaimID

    CREATE TABLE #ASN
        (
          ClaimID INT ,
          PatientID INT ,
          TypeGroup INT
        )
    INSERT  INTO #ASN
            ( ClaimID ,
              PatientID ,
              TypeGroup
            )
            SELECT  CAA.ClaimID ,
                    CAA.PatientID ,
                    CASE WHEN caa.InsuranceCompanyPlanID IS NULL THEN 2
                         ELSE 1
                    END TypeGroup
            FROM    ClaimAccounting_Assignments CAA
                    INNER JOIN #ASNMax AM ON CAA.ClaimID = AM.ClaimID
                                             AND CAA.ClaimTransactionID = AM.ClaimTransactionID
                    LEFT JOIN InsuranceCompanyPlan icp ON icp.InsuranceCompanyPlanID = caa.InsuranceCompanyPlanID
		
    SELECT  a.ClaimID ,
            a.PatientID ,
            ep.EncounterProcedureID ,
            SUM(CASE WHEN ClaimTransactionTypeCode = 'CST' THEN Amount
                     ELSE 0
                END) Charges ,
            SUM(CASE WHEN ClaimTransactionTypeCode = 'ADJ' THEN Amount * -1
                     ELSE 0
                END) Adjustments ,
            SUM(CASE WHEN ClaimTransactionTypeCode = 'PAY'
                          AND PayerTypeCode = 'I' THEN Amount * -1
                     ELSE 0
                END) InsPay ,
            SUM(CASE WHEN ClaimTransactionTypeCode = 'PAY'
                          AND PayerTypeCode = 'P' THEN Amount * -1
                     ELSE 0
                END) PatPay ,
            TotalBalance = SUM(CASE WHEN ClaimTransactionTypeCode = 'CST'
                                    THEN Amount
                                    ELSE Amount * -1
                               END) ,
            PendingIns = SUM(CASE WHEN ClaimTransactionTypeCode = 'PAY'
                                       AND PayerTypeCode = 'P' -- Exclude patient payment against total
                                       THEN 0
                                  WHEN TypeGroup = 1  -- Assinged to patient
                                       THEN CASE WHEN ClaimTransactionTypeCode = 'CST'
                                                 THEN AMOUNT
                                                 ELSE -1 * AMOUNT
                                            END
                                  ELSE 0
                             END) ,
            PendingPat = SUM(CASE WHEN ClaimTransactionTypeCode = 'PAY'
                                       AND PayerTypeCode = 'P'  -- Include patient payment against total
                                       THEN Amount * -1
                                  WHEN TypeGroup = 2 -- Assinged to patient
                                       THEN CASE WHEN ClaimTransactionTypeCode = 'CST'
                                                 THEN Amount
                                                 ELSE Amount * -1
                                            END
                                  ELSE 0
                             END) ,
            TotalAR = CAST(0 AS MONEY) ,
            TypeGroup
    INTO    #AR_ASN
    FROM    #ASN A
            INNER JOIN ClaimAccounting CAA ON A.PatientID = CAA.PatientID
                                              AND A.ClaimID = CAA.ClaimID
            INNER JOIN Claim c ON c.PracticeID = caa.PracticeID
                                  AND caa.ClaimID = c.CLaimID
            INNER JOIN Encounterprocedure ep ON ep.PracticeID = c.PracticeID
                                                AND c.EncounterProcedureID = ep.EncounterProcedureID
            INNER JOIN Encounter e ON e.PracticeID = ep.PracticeID
                                      AND e.EncounterID = ep.EncounterID
            INNER JOIN Doctor d ON d.PracticeID = e.PracticeID
                                   AND d.doctorID = e.DoctorID
            INNER JOIN PatientCase pc ON pc.PatientCaseID = e.PatientCaseID
            LEFT JOIN Payment P ON p.PracticeID = caa.PracticeID
                                   AND caa.PaymentID = P.PaymentID
    WHERE   ClaimTransactionTypeCode IN ( 'CST', 'ADJ', 'PAY' )
    GROUP BY a.ClaimID ,
            TypeGroup ,
            a.PatientID ,
            ep.EncounterProcedureID



    UPDATE  asn
    SET     PendingIns = PendingIns - ISNULL(ca.amount, 0) ,
            PendingPat = PendingPat + ISNULL(ca.amount, 0)
    FROM    #AR_ASN asn
            INNER JOIN ( SELECT ClaimID ,
                                SUM(amount) amount
                         FROM   ClaimAccounting
                         WHERE  ClaimTransactionTypeCode = 'PRC'
                         GROUP BY ClaimID
                       ) AS ca ON ca.ClaimID = asn.ClaimID
    WHERE   TypeGroup = '1' 


--	select '#AR_ASN' as [#AR_ASN], * from #AR_ASN

	-- todo: still need to handle refunds, unapplied amts, etc. - lots and lots of stuff from WebServiceDataProvider_PatientBalanceSummary

    SELECT  NULL AS CustomerID ,
            prac.PracticeID ,
            LTRIM(RTRIM(CC.CollectionCategoryName)) AS CollectionCategoryName,
            c.ClaimID ,
            e.EncounterID AS [EncounterID] ,
            e.PatientID AS [PatientID] ,
            p.Prefix AS Prefix ,
            p.FirstName ,
            p.MiddleName ,
            p.LastName ,
            p.Suffix ,
            dbo.fn_FormatSSN(p.SSN) AS SSN ,
            CONVERT(VARCHAR, p.DOB, 101) AS DOB ,
            Age = FLOOR(CAST(DATEDIFF(month, p.DOB, @now) AS DECIMAL(9, 2))
                        / 12.00)
            + CASE WHEN MONTH(p.DOB) = MONTH(@now)
                        AND DAY(@now) < DAY(p.DOB) THEN -1
                   ELSE 0
              END ,
            p.Gender ,
            p.MedicalRecordNumber ,
            p.MaritalStatus ,
            StatusName AS [EmploymentStatus] ,
            [EmployerName] ,
            PatientReferralSourceCaption AS ReferralSource ,
            p.AddressLine1 AS [AddressLine1] ,
            p.AddressLine2 AS [AddressLine2] ,
            p.City AS [City] ,
            p.State AS [State] ,
            p.Country AS [Country] ,
            p.ZipCode AS [ZipCode] ,
            dbo.fn_FormatPhone(p.HomePhone) AS [HomePhone] ,
            p.HomePhoneExt AS [HomePhoneExt] ,
            dbo.fn_FormatPhone(p.WorkPhone) AS [WorkPhone] ,
            p.WorkPhoneExt AS [WorkPhoneExt] ,
            dbo.fn_FormatPhone(p.MobilePhone) AS [MobilePhone] ,
            p.MobilePhoneExt AS [MobilePhoneExt] ,
            p.EmailAddress AS [EmailAddress] ,
            dbo.fn_FormatFirstMiddleLast(p.FirstName, p.MiddleName, p.LastName) AS PatientName ,
            CONVERT(VARCHAR, p.DOB, 101) AS PatientDateOfBirth ,
            pc.Name AS CaseName ,
            paySc.Name AS [CasePayerScenario] ,
            CONVERT(VARCHAR, c.ClaimServiceDateFrom, 101) AS ServiceStartDate ,
            CONVERT(VARCHAR, c.ClaimServiceDateTo, 101) AS ServiceEndDate ,
            CONVERT(VARCHAR, c.PostingDate, 101) AS PostingDate ,
            e.BatchId AS [BatchNumber] ,
            REPLACE(ISNULL(sp.Prefix + ' ', '') + ISNULL(sp.FirstName, '')
                    + ISNULL(' ' + sp.MiddleName, '') + ISNULL(' '
                                                              + sp.LastName,
                                                              '')
                    + ISNULL(', ' + sp.Degree, ''), '  ', ' ') AS [SchedulingProviderName] ,
            REPLACE(ISNULL(d.Prefix + ' ', '') + ISNULL(d.FirstName, '')
                    + ISNULL(' ' + d.MiddleName, '') + ISNULL(' ' + d.LastName,
                                                              '')
                    + ISNULL(', ' + d.Degree, ''), '  ', ' ') AS [RenderingProviderName] ,
            REPLACE(ISNULL(supD.Prefix + ' ', '') + ISNULL(supD.FirstName, '')
                    + ISNULL(' ' + supD.MiddleName, '') + ISNULL(' '
                                                              + supD.LastName,
                                                              '')
                    + ISNULL(', ' + supD.Degree, ''), '  ', ' ') AS [SupervisingProviderName] ,
            REPLACE(ISNULL(refD.Prefix + ' ', '') + ISNULL(refD.FirstName, '')
                    + ISNULL(' ' + refD.MiddleName, '') + ISNULL(' '
                                                              + refD.LastName,
                                                              '')
                    + ISNULL(', ' + refD.Degree, ''), '  ', ' ') AS [ReferringProviderName] ,
            sl.Name AS ServiceLocationName ,
            pcd.ProcedureCode ,
            ISNULL(pcd.LocalName, pcd.OfficialName) AS ProcedureName ,
            pcc.ProcedureCodeCategoryName AS ProcedureCodeCategory ,
            ep.ProcedureModifier1 ,
            ep.ProcedureModifier2 ,
            ep.ProcedureModifier3 ,
            ep.ProcedureModifier4 ,
            dcd1.DiagnosisCode AS EncounterDiagnosisID1 ,
            dcd2.DiagnosisCode AS EncounterDiagnosisID2 ,
            dcd3.DiagnosisCode AS EncounterDiagnosisID3 ,
            dcd4.DiagnosisCode AS EncounterDiagnosisID4 ,
            ep.ServiceUnitCount AS [Units] ,
            ep.ServiceChargeAmount AS [UnitCharge] ,
            CAST(dbo.fn_RoundUpToPenny(ISNULL(ep.ServiceUnitCount, 0)
                                       * ISNULL(ep.ServiceChargeAmount, 0)) AS MONEY) AS [TotalCharges] ,
            ( CA.Charges - ISNULL(adj.Amount, 0) ) AS AdjustedCharges ,
            ISNULL(CA.InsPay, 0.0) + ISNULL(CA.PatPay, 0.0) AS Receipts ,
            CA.PendingPat AS PatientBalance ,
            CA.PendingIns AS InsuranceBalance ,
            CA.TotalBalance AS TotalBalance ,
            ic1.InsuranceCompanyName AS [PrimaryInsuranceCompanyName] ,
            icp1.PlanName AS [PrimaryInsurancePlanName] ,
            ic2.InsuranceCompanyName AS SecondaryInsuranceCompanyName ,
            icp2.PlanName AS SecondaryInsurancePlanName ,
            c.AssignedToDisplayName AS BilledTo ,
            c.Status
    FROM    #Claims c
            INNER JOIN Encounter e ON e.EncounterID = c.encounterID
            INNER JOIN EncounterStatus es ON es.EncounterStatusID = e.EncounterStatusID
            INNER JOIN Patient p ON p.PatientID = c.PatientID
                                    AND p.PracticeID = e.PracticeID
            LEFT JOIN employmentStatus enst ON enst.EmploymentStatusCode = p.EmploymentStatus
            INNER JOIN PatientCase pc ON pc.PatientCaseID = e.PatientCaseID
                                         AND pc.PracticeID = e.PracticeID
            INNER JOIN PayerScenario paySc ON paySc.PayerScenarioID = pc.PayerScenarioID
            INNER JOIN Doctor d ON d.DoctorID = e.DoctorID
                                   AND d.PracticeID = e.PracticeID
            INNER JOIN ProcedureCodeDictionary pcd ON pcd.ProcedureCodeDictionaryID = c.ProcedureCodeDictionaryID
            LEFT JOIN ProcedureCodeCategory pcc ( NOLOCK ) ON pcc.ProcedureCodeCategoryID = pcd.ProcedureCodeCategoryID
            INNER JOIN EncounterProcedure ep ON ep.PracticeID = e.PracticeID
                                                AND ep.EncounterProcedureID = c.encounterProcedureID
                                                AND ep.EncounterID = c.EncounterID
            LEFT JOIN #ClaimInsurance ci ON ci.claimID = c.claimID
            LEFT OUTER JOIN CollectionCategory AS CC ( NOLOCK ) ON p.CollectionCategoryID = CC.CollectionCategoryID
            LEFT OUTER JOIN Employers (NOLOCK) ON p.EmployerID = Employers.EmployerID
            LEFT OUTER JOIN PatientReferralSource (NOLOCK) ON p.PatientReferralSourceID = PatientReferralSource.PatientReferralSourceID
            LEFT JOIN Doctor sp ON sp.DoctorID = e.SchedulingProviderID
            LEFT JOIN Doctor supD ON supD.DoctorID = e.SupervisingProviderID
            LEFT JOIN Doctor refD ON refD.DoctorID = e.ReferringPhysicianID
            LEFT JOIN ServiceLocation sl ON sl.ServiceLocationID = e.LocationID
            LEFT JOIN PlaceOfService pos ON pos.PlaceOfServiceCode = e.PlaceOfServiceCode
            LEFT JOIN TypeOfService tos ON tos.TypeOfServiceCode = ep.TypeOfServiceCode
    
	----- primary ins payment
            LEFT JOIN Payment p1 ON p1.PaymentID = c.PrimaryInsPaymentID
            LEFT JOIN #payments cp1 ON cp1.claimID = c.claimID
                                       AND cp1.paymentID = p1.PaymentID
            LEFT JOIN PaymentMethodCode pmc1 ON pmc1.PaymentMethodCode = p1.PaymentMethodCode
            LEFT JOIN Category cat1 ON cat1.CategoryID = p1.PaymentCategoryID
            LEFT JOIN InsuranceCompanyPlan icp1 ON icp1.InsuranceCompanyPlanID = ISNULL(p1.PayerID,
                                                              ci.PrimaryInsuranceCompanyPlanID)
            LEFT JOIN InsuranceCompany ic1 ON icp1.InsuranceCompanyID = ic1.InsuranceCompanyID
            LEFT JOIN #ClaimEOB eob1 ON eob1.ClaimID = c.claimID
                                        AND eob1.PaymentID = p1.PaymentID
    
	----- secondary ins payment
            LEFT JOIN Payment p2 ON p2.PaymentID = c.SecondaryInsPaymentID
            LEFT JOIN #payments cp2 ON cp2.claimID = c.claimID
                                       AND cp2.paymentID = p2.PaymentID
            LEFT JOIN PaymentMethodCode pmc2 ON pmc2.PaymentMethodCode = p2.PaymentMethodCode
            LEFT JOIN Category cat2 ON cat2.CategoryID = p2.PaymentCategoryID
            LEFT JOIN InsuranceCompanyPlan icp2 ON icp2.InsuranceCompanyPlanID = ISNULL(p2.PayerID,
                                                              ci.SecondaryInsuranceCompanyPlanID)
            LEFT JOIN InsuranceCompany ic2 ON icp2.InsuranceCompanyID = ic2.InsuranceCompanyID
            LEFT JOIN #ClaimEOB eob2 ON eob2.ClaimID = c.claimID
                                        AND eob2.PaymentID = p2.PaymentID
            LEFT JOIN EncounterDiagnosis ed1 ON ed1.PracticeID = ep.PracticeID
                                                AND ed1.EncounterID = ep.EncounterID
                                                AND ed1.EncounterDiagnosisID = ep.EncounterDiagnosisID1
            LEFT JOIN DiagnosisCodeDictionary dcd1 ON dcd1.DiagnosisCodeDictionaryID = ed1.DiagnosisCodeDictionaryID
            LEFT JOIN EncounterDiagnosis ed2 ON ed2.PracticeID = ep.PracticeID
                                                AND ed2.EncounterID = ep.EncounterID
                                                AND ed2.EncounterDiagnosisID = ep.EncounterDiagnosisID2
            LEFT JOIN DiagnosisCodeDictionary dcd2 ON dcd2.DiagnosisCodeDictionaryID = ed2.DiagnosisCodeDictionaryID
            LEFT JOIN EncounterDiagnosis ed3 ON ed3.PracticeID = ep.PracticeID
                                                AND ed3.EncounterID = ep.EncounterID
                                                AND ed3.EncounterDiagnosisID = ep.EncounterDiagnosisID3
            LEFT JOIN DiagnosisCodeDictionary dcd3 ON dcd3.DiagnosisCodeDictionaryID = ed3.DiagnosisCodeDictionaryID
            LEFT JOIN EncounterDiagnosis ed4 ON ed4.PracticeID = ep.PracticeID
                                                AND ed4.EncounterID = ep.EncounterID
                                                AND ed4.EncounterDiagnosisID = ep.EncounterDiagnosisID4
            LEFT JOIN DiagnosisCodeDictionary dcd4 ON dcd4.DiagnosisCodeDictionaryID = ed4.DiagnosisCodeDictionaryID
            LEFT JOIN #Adjustment adj ON adj.claimID = c.claimID
            LEFT JOIN #AR_ASN CA ON c.ClaimID = CA.ClaimID
            INNER JOIN Practice prac ON prac.PracticeId = c.PracticeId
    WHERE   CC.CollectionCategoryName = '5 COLLECTIONS/BAD DEBT'
            AND CA.PendingPat > 0
		

    DROP TABLE 
	#asn, 
	#ar_asn, 
	#claims, 
	#ClaimInsurance, 
	#minContractAdjustment, 
	#ClaimPayment, 
	#ClaimEOB, 
	#payments, 
	#Adjustment, 
	#AR, 
	#ASNMax

END	

IF OBJECT_ID('tempdb..#asn') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#asn;
    END
GO
IF OBJECT_ID('tempdb..#ar_asn') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#ar_asn;
    END
GO
IF OBJECT_ID('tempdb..#claims') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#claims;
    END
GO
IF OBJECT_ID('tempdb..#ClaimInsurance') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#ClaimInsurance;
    END
GO
IF OBJECT_ID('tempdb..#minContractAdjustment') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#minContractAdjustment;
    END
GO
IF OBJECT_ID('tempdb..#ClaimPayment') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#ClaimPayment;
    END
GO
IF OBJECT_ID('tempdb..#ClaimEOB') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#ClaimEOB;
    END
GO
IF OBJECT_ID('tempdb..#payments') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#payments;
    END
GO
IF OBJECT_ID('tempdb..#Adjustment') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#Adjustment;
    END
GO
IF OBJECT_ID('tempdb..#AR') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#AR;
    END
GO
IF OBJECT_ID('tempdb..#ASNMax') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#ASNMax;
    END
GO
