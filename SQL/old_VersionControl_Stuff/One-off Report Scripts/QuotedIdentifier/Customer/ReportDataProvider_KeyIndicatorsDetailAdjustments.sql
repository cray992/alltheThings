SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_KeyIndicatorsDetailAdjustments]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[ReportDataProvider_KeyIndicatorsDetailAdjustments]
GO


CREATE PROCEDURE dbo.ReportDataProvider_KeyIndicatorsDetailAdjustments
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@SummarizeAllProviders bit = 0,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
/*
DECLARE
	@PracticeID int,
	@ProviderID int,
	@SummarizeAllProviders bit,
	@BeginDate datetime,
	@EndDate datetime

SELECT 
	@PracticeID  = 65,
	@ProviderID  = 133,
	@SummarizeAllProviders  = 0,
	@BeginDate  = '6/1/06',
	@EndDate  = '6/21/06'
*/
BEGIN
	SET @BeginDate =  dbo.fn_DateOnly(@BeginDate)
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))


	IF @SummarizeAllProviders = 0
	BEGIN 	
		SELECT Claim_ProviderID ProviderID, dbo.fn_ZeroLengthStringToNull(CT.Code),
			ISNULL(AC.Description, 'Not Specified') AS AdjustmentDescription,
			SUM(ISNULL(CT.Amount,0)) AS AdjustmentTotal		
		FROM ClaimTransaction CT 
			LEFT JOIN VoidedClaims VC ON CT.ClaimID=VC.ClaimID
			LEFT JOIN Adjustment AC ON CT.Code=AC.AdjustmentCode
			LEFT OUTER JOIN PaymentClaimTransaction pct ON pct.PracticeID = @PracticeID AND pct.ClaimID = ct.ClaimID AND pct.ClaimTransactionID = ct.ClaimTransactionID
			LEFT OUTER JOIN Payment p on p.PracticeID=@PracticeID AND pct.PaymentID = p.PaymentID
		WHERE CT.PracticeID=@PracticeID
		AND ISNULL(p.PostingDate, CT.PostingDate) BETWEEN @BeginDate AND @EndDate
		AND CT.ClaimTransactionTypeCode = 'ADJ'
		AND VC.ClaimID IS NULL
		AND ((Claim_ProviderID = @ProviderID) OR (ISNULL(@ProviderID,0)=0))
		GROUP BY Claim_ProviderID, dbo.fn_ZeroLengthStringToNull(CT.Code), ISNULL(AC.Description, 'Not Specified') 
	END
	ELSE
	BEGIN

		SELECT 0 ProviderID, dbo.fn_ZeroLengthStringToNull(CT.Code),
			ISNULL(AC.Description, 'Not Specified') AS AdjustmentDescription,
			SUM(ISNULL(CT.Amount,0)) AS AdjustmentTotal		
		FROM ClaimTransaction CT 
			LEFT JOIN VoidedClaims VC ON CT.ClaimID=VC.ClaimID
			LEFT JOIN Adjustment AC ON CT.Code=AC.AdjustmentCode
			LEFT OUTER JOIN PaymentClaimTransaction pct ON pct.PracticeID = @PracticeID AND pct.ClaimID = ct.ClaimID AND pct.ClaimTransactionID = ct.ClaimTransactionID
			LEFT OUTER JOIN Payment p on p.PracticeID=@PracticeID AND pct.PaymentID = p.PaymentID
		WHERE CT.PracticeID=@PracticeID
		AND ISNULL(p.PostingDate, CT.PostingDate) BETWEEN @BeginDate AND @EndDate
		AND CT.ClaimTransactionTypeCode = 'ADJ'
		AND VC.ClaimID IS NULL
		AND ((Claim_ProviderID = @ProviderID) OR (ISNULL(@ProviderID,0)=0))
		GROUP BY dbo.fn_ZeroLengthStringToNull(CT.Code), ISNULL(AC.Description, 'Not Specified')
	END
			
END	
