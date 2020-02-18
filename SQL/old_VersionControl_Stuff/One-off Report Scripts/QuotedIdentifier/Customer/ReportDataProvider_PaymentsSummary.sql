SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_PaymentsSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[ReportDataProvider_PaymentsSummary]
GO


--===========================================================================
-- SRS Payments Summary
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_PaymentsSummary
	@PracticeID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@PaymentMethodCode varchar(1) = '',
	@BatchID varchar(50) = NULL, 
	@PaymentTypeID INT = -1
AS
/*
declare
	@PracticeID int,
	@BeginDate datetime,
	@EndDate datetime,
	@PaymentMethodCode varchar(1),
	@BatchID varchar(50)
select
	@PracticeID  = 13,
	@BeginDate  = '5/1/06',
	@EndDate  = '5/31/06',
	@PaymentMethodCode  = '',
	@BatchID  = NULL
*/
BEGIN
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))

	CREATE TABLE #Payments(PaymentMethodCode CHAR(1), PaymentID INT, PaymentAmount MONEY, UnappliedAmount MONEY, BatchID varchar(50), PaymentTypeID INT)
	INSERT INTO #Payments(PaymentMethodCode, PaymentID, PaymentAmount, BatchID, PaymentTypeID)
	SELECT PaymentMethodCode, PaymentID, PaymentAmount, BatchID, PaymentTypeID
	FROM Payment P
	WHERE P.PracticeID=@PracticeID AND PostingDate BETWEEN @BeginDate AND @EndDate
	AND ((BatchID=@BatchID) or (@BatchID is NULL))
	
	UPDATE P SET UnappliedAmount=Unapplied
	FROM #Payments P INNER JOIN (
	SELECT P.PaymentID, SUM(Amount) Unapplied
	FROM  #Payments P INNER JOIN PaymentClaimTransaction PCT
	ON P.PaymentID=PCT.PaymentID
	INNER JOIN ClaimAccounting CA
	ON PCT.ClaimTransactionID = CA.ClaimTransactionID						
	WHERE CA.PracticeID=@PracticeID AND CA.ClaimTransactionTypeCode='PAY'
	GROUP BY  P.PaymentID) T ON P.PaymentID=T.PaymentID

	CREATE TABLE #Refunds(PaymentID INT, RefundAmount MONEY)
	INSERT INTO #Refunds(PaymentID, RefundAmount)
	SELECT RTP.PaymentID, SUM(Amount) RefundAmount
	FROM RefundToPayments RTP INNER JOIN #Payments P ON RTP.PaymentID=P.PaymentID
	WHERE PostingDate BETWEEN @BeginDate AND @EndDate
	GROUP BY RTP.PaymentID

	UPDATE P SET UnappliedAmount=ISNULL(UnappliedAmount,0)+RefundAmount
	FROM #Payments P INNER JOIN #Refunds R ON P.PaymentID=R.PaymentID

-----------------
	CREATE TABLE #Capitated(PaymentID INT, CapitatedAccountID INT, CapitatedAmount MONEY)
	INSERT INTO #Capitated(PaymentID, CapitatedAccountID, CapitatedAmount)
	SELECT CAP.PaymentID, CAP.CapitatedAccountID, SUM(Amount) CapitatedAmount
	FROM  CapitatedAccountToPayment CAP 
	INNER JOIN #Payments P ON CAP.PaymentID=P.PaymentID
	WHERE PostingDate BETWEEN @BeginDate AND @EndDate
	GROUP BY CAP.CapitatedAccountID, CAP.PaymentID

	UPDATE P SET UnappliedAmount=ISNULL(UnappliedAmount,0)+ CapitatedAmount
	FROM #Payments P INNER JOIN #Capitated C ON P.PaymentID=C.PaymentID

-----------------

	UPDATE #Payments SET UnappliedAmount=PaymentAmount-ISNULL(UnappliedAmount,0)

	SELECT 
		ISNULL(SUM(PaymentAmount),0) PaymentAmount, 
		ISNULL(SUM(UnappliedAmount),0) UnappliedAmount,
		PT.Name as PayementType,
		PT.SortOrder,
		PTC.Description PayerTypeCode,
		P.PaymentTypeID
	FROM PaymentType PT 
		INNER JOIN #Payments P ON PT.PaymentTypeID = P.PaymentTypeID
		INNER JOIN PayerTypeCode PTC on PTC.PayerTypeCode = PT.PayerTypeCode
	WHERE ((@PaymentMethodCode='') OR (@PaymentMethodCode<>'' AND P.PaymentMethodCode=@PaymentMethodCode))
		AND ( @PaymentTypeID = -1 OR @PaymentTypeID = P.PaymentTypeID )
	GROUP BY 
		PT.Name,
		PT.SortOrder,
		PTC.Description,
		P.PaymentTypeID

	DROP TABLE #Payments

	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
