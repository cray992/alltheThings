IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'PaymentDataProvider_GetPayments'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.PaymentDataProvider_GetPayments
GO


--===========================================================================
-- GET PAYMENTS
--===========================================================================
CREATE  PROCEDURE dbo.PaymentDataProvider_GetPayments
	@practice_id INT,
	@applied_status VARCHAR(25),
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT

AS

BEGIN
SET NOCOUNT ON

	DECLARE @CheckReferenceID BIT
	SET @CheckReferenceID=0

	--Unapplied Payments for Practice
	DECLARE @PracticePayments TABLE(PracticeID INT, PaymentID INT, PaymentAmount MONEY,
					PaymentDate DATETIME, PaymentNumber VARCHAR(30),
					Description VARCHAR(250), PAYERTYPE VARCHAR(50), PayerID INT,
					PayerName VARCHAR(250), FullyApplied BIT, FirstName VARCHAR(64), LastName VARCHAR(64))
	INSERT @PracticePayments(PracticeID, PaymentID, PaymentAmount, PaymentDate, PaymentNumber,
				 Description, PAYERTYPE, PayerID)
	SELECT U.PracticeID, U.PaymentID, PaymentAmount, 
	       CAST(CONVERT(CHAR(10),PaymentDate,110) AS DATETIME) PaymentDate,
	       PaymentNumber, P.Description,
	       PT.Description PAYERTYPE, PayerID
	FROM UnappliedPayments U INNER JOIN Payment P 
	ON U.PracticeID=P.PracticeID AND U.PaymentID=P.PaymentID
	INNER JOIN PayerTypeCode PT ON P.PayerTypeCode=PT.PayerTypeCode
	WHERE P.Practiceid=@practice_id
	
	--Applied Amounts
	DECLARE @Applied TABLE(PracticeID INT, PaymentID INT, AppliedAmount MONEY)
	INSERT @Applied(PracticeID, PaymentID, AppliedAmount)
	SELECT PP.PracticeID, PP.PaymentID, SUM(Amount) AppliedAmount
	FROM @PracticePayments PP INNER JOIN PaymentClaimTransaction PCT 
	ON PP.PracticeID=PCT.PracticeID AND PP.PaymentID=PCT.PaymentID
	INNER JOIN ClaimTransaction CT ON PCT.ClaimTransactionID=CT.ClaimTransactionID
	WHERE CT.PracticeID=@practice_id AND CT.ClaimTransactionTypeCode='PAY'
	GROUP BY PP.PracticeID, PP.PaymentID
	
	--Fully Applied Payments
	INSERT @PracticePayments(PracticeID, PaymentID, PaymentAmount, PaymentDate, PaymentNumber,
				 Description, PAYERTYPE, PayerID, FullyApplied)
	SELECT P.PracticeID, P.PaymentID, P.PaymentAmount, 
	       CAST(CONVERT(CHAR(10),P.PaymentDate,110) AS DATETIME) PaymentDate,
	       P.PaymentNumber, P.Description,
	       PT.Description PAYERTYPE, P.PayerID, 1 FullyApplied
	FROM Payment P 
	LEFT JOIN @PracticePayments PP ON P.PracticeID=PP.PracticeID AND P.PaymentID=PP.PaymentID
	INNER JOIN PayerTypeCode PT ON P.PayerTypeCode=PT.PayerTypeCode
	WHERE P.Practiceid=@practice_id AND PP.PaymentID IS NULL
	
	UPDATE PP SET PayerName=OtherName
	FROM @PracticePayments PP INNER JOIN Other O ON PP.PayerID=O.OtherID
	
	UPDATE PP SET PayerName=COALESCE(P.FirstName + ' ','') 
				+ COALESCE(P.MiddleName + ' ','') 
				+ COALESCE(P.LastName,'') 
				+ ' (' + CAST(P.PatientID AS VARCHAR) + ')',
				FirstName=P.FirstName,
				LastName=P.LastName
	FROM @PracticePayments PP INNER JOIN Patient P 
	ON PP.PracticeID=P.PracticeID AND PP.PayerID=P.PatientID
	WHERE P.PracticeID=@practice_id
	
	UPDATE PP SET PayerName=COALESCE(ICP.PlanName,'') 
				+ ' (' + CAST(ICP.InsuranceCompanyPlanID AS VARCHAR)+ ')' 
	FROM @PracticePayments PP INNER JOIN InsuranceCompanyPlan ICP 
	ON PP.PayerID=ICP.InsuranceCompanyPlanID
	
	--Refunds
	DECLARE @AppliedToRefund TABLE(PracticeID INT, PaymentID INT, RefundAmt MONEY)
	INSERT @AppliedToRefund(PracticeID, PaymentID, RefundAmt)
	SELECT PP.PracticeID, PP.PaymentID, SUM(Amount) RefundAmt
	FROM @PracticePayments PP INNER JOIN RefundToPayments RTP 
	ON PP.PaymentID=RTP.PaymentID
	GROUP BY PP.PracticeID, PP.PaymentID
	
	DECLARE @TOQUERY TABLE(PaymentID INT, PaymentAmount MONEY,
		       PaymentDate DATETIME, PayerName VARCHAR(250),
	               PAYERTYPE VARCHAR(50), PaymentNumber VARCHAR(30),
		       Description VARCHAR(250),  UNAPPLIEDAMOUNT MONEY,
	               RefundsTotal MONEY, Deletable BIT, PayerID INT, FirstName VARCHAR(64), LastName VARCHAR(64))
	INSERT @TOQUERY(PaymentID, PaymentDate, PaymentAmount, PayerName, PAYERTYPE,
		      PaymentNumber, Description, UNAPPLIEDAMOUNT, RefundsTotal, Deletable, PayerID, FirstName, LastName)				
	SELECT PP.PaymentID, PaymentDate, PaymentAmount, ISNULL(PayerName,'') PayerName,
	       PAYERTYPE, PaymentNumber, Description, 
	       CASE WHEN FullyApplied=1 THEN 0 ELSE PaymentAmount-(ISNULL(RefundAmt,0)+ISNULL(AppliedAmount,0)) END UNAPPLIEDAMOUNT, 
	       ISNULL(RefundAmt,0) RefundsTotal, 
	       CASE WHEN FullyApplied=1 OR ISNULL(AP.AppliedAmount,0)<>0 OR ISNULL(RP.RefundAmt,0)<>0 THEN 0 ELSE 1 END Deletable, PayerID,
	       FirstName, LastName
	FROM @PracticePayments PP LEFT JOIN @Applied AP ON PP.PaymentID=AP.PaymentID
	LEFT JOIN @AppliedToRefund RP ON PP.PaymentID=RP.PaymentID
	Order By PaymentDate DESC
	
	DECLARE @FINAL TABLE(PaymentID INT, PaymentAmount MONEY,
		       PaymentDate DATETIME, PayerName VARCHAR(250),
	               PAYERTYPE VARCHAR(50), PaymentNumber VARCHAR(30),
		       Description VARCHAR(250),  UNAPPLIEDAMOUNT MONEY,
	               RefundsTotal MONEY, Deletable BIT,RID INT IDENTITY(0,1))
	
	IF ISNUMERIC(@query)=1 AND (@query_domain='ClaimPayerID' OR @query_domain='PaymentID' 
				    OR @query_domain='PayerID' OR @query_domain='ALL')
	BEGIN
		DECLARE @BIGNumber BIGINT
		DECLARE @MAXINT BIGINT
	
		SET @BIGNumber=CAST(@query AS BIGINT)
		SET @MAXINT=2147483647

		SET @BIGNumber=@BIGNumber-@MAXINT
	
		IF @BIGNumber<0
		BEGIN
	
			DECLARE @ID INT
			SET @ID=CAST(@query AS INT)
		
			DECLARE @Payers TABLE(PayerID INT)
		
			IF @query_domain='ClaimPayerID'
			BEGIN
				INSERT @Payers(PayerID)
				SELECT	E.PatientID PayerID
				FROM	CLAIM C
					INNER JOIN ENCOUNTERPROCEDURE EP
					ON EP.EncounterProcedureID = C.EncounterProcedureID 
					AND EP.PracticeID=C.PracticeID
					INNER JOIN ENCOUNTER E
					ON E.EncounterID = EP.EncounterID AND E.PracticeID=EP.PracticeID
				WHERE	C.PracticeID=@practice_id AND C.ClaimID = @ID
				UNION ALL
				SELECT	IP.InsuranceCompanyPlanID PayerID
				FROM	CLAIM C
					INNER JOIN
						ClaimAccounting_Assignments CA
					ON	   CA.PracticeID = @practice_id
					AND	   CA.ClaimID = C.ClaimID
					AND	   CA.LastAssignment = 1
					INNER JOIN ENCOUNTERPROCEDURE EP
					ON EP.EncounterProcedureID = C.EncounterProcedureID
					AND EP.PracticeID=C.PracticeID
					INNER JOIN InsurancePolicy IP
					ON IP.InsurancePolicyID = CA.InsurancePolicyID
				WHERE	C.PracticeID=@practice_id AND C.ClaimID = @ID

				INSERT @FINAL(PaymentID, PaymentDate, PaymentAmount, PayerName, PAYERTYPE,
					      PaymentNumber, Description, UNAPPLIEDAMOUNT, RefundsTotal, Deletable)				
	
				SELECT PaymentID, PaymentDate, PaymentAmount, PayerName, PAYERTYPE,
					      PaymentNumber, Description, UNAPPLIEDAMOUNT, RefundsTotal, Deletable 
				FROM @TOQUERY TQ INNER JOIN @Payers P ON TQ.PayerID=P.PayerID
				WHERE (@applied_status = 'Unapplied'
						AND UNAPPLIEDAMOUNT<>0)
					OR	(@applied_status = 'Applied'
						AND UNAPPLIEDAMOUNT=0)
					OR	(@applied_status = 'All')
			END
			ELSE
			BEGIN
				INSERT @FINAL(PaymentID, PaymentDate, PaymentAmount, PayerName, PAYERTYPE,
					      PaymentNumber, Description, UNAPPLIEDAMOUNT, RefundsTotal, Deletable)				
	
				SELECT PaymentID, PaymentDate, PaymentAmount, PayerName, PAYERTYPE,
					      PaymentNumber, Description, UNAPPLIEDAMOUNT, RefundsTotal, Deletable 
				FROM @TOQUERY 
				WHERE ((@applied_status = 'Unapplied'
						AND UNAPPLIEDAMOUNT<>0)
					OR	(@applied_status = 'Applied'
						AND UNAPPLIEDAMOUNT=0)
					OR	(@applied_status = 'All'))
				AND (	((@query_domain = 'PaymentID'
							OR @query_domain = 'All')
						AND	PaymentID=@ID)
					OR	((@query_domain = 'PayerID'
							OR @query_domain = 'All')
						AND	PayerID=@ID)
					OR	((@query_domain = 'PaymentNumber'
							OR @query_domain = 'All')
						AND	PaymentNumber=CAST(@ID AS VARCHAR(30))))
			END
		
			SET @totalRecords = @@ROWCOUNT
		END
		ELSE
		BEGIN
			SET @CheckReferenceID=1
		END
	END
	
	IF ISDATE(@query)=1 AND (@query_domain='PaymentDate' OR @query_domain='ALL')
	BEGIN
		DECLARE @DT DATETIME
		SET @DT=CAST(@query AS DATETIME)
	
		INSERT @FINAL(PaymentID, PaymentDate, PaymentAmount, PayerName, PAYERTYPE,
			      PaymentNumber, Description, UNAPPLIEDAMOUNT, RefundsTotal, Deletable)				

		SELECT PaymentID, PaymentDate, PaymentAmount, PayerName, PAYERTYPE,
			      PaymentNumber, Description, UNAPPLIEDAMOUNT, RefundsTotal, Deletable 
		FROM @TOQUERY 
		WHERE ((@applied_status = 'Unapplied'
				AND UNAPPLIEDAMOUNT<>0)
			OR	(@applied_status = 'Applied'
				AND UNAPPLIEDAMOUNT=0)
			OR	(@applied_status = 'All'))
			AND ((@query_domain = 'PaymentDate'
	 			OR @query_domain = 'All')
	 		AND	PaymentDate=@DT)
	
		SET @totalRecords = @@ROWCOUNT
	END
	
	
	IF @query_domain IS NULL OR @query IS NULL
	BEGIN
		INSERT @FINAL(PaymentID, PaymentDate, PaymentAmount, PayerName, PAYERTYPE,
			      PaymentNumber, Description, UNAPPLIEDAMOUNT, RefundsTotal, Deletable)				

		SELECT PaymentID, PaymentDate, PaymentAmount, PayerName, PAYERTYPE,
			      PaymentNumber, Description, UNAPPLIEDAMOUNT, RefundsTotal, Deletable 
		FROM @TOQUERY 
		WHERE ((@applied_status = 'Unapplied'
				AND UNAPPLIEDAMOUNT<>0)
			OR	(@applied_status = 'Applied'
				AND UNAPPLIEDAMOUNT=0)
			OR	(@applied_status = 'All'))
			AND (@query_domain IS NULL OR @query IS NULL)
	
		SET @totalRecords = @@ROWCOUNT
	END
	
	IF ISDATE(@query)=0 AND ISNUMERIC(@query)=0 AND (@query_domain='PayerName' OR @query_domain='ALL')
	   OR @CheckReferenceID=1
	BEGIN
		INSERT @FINAL(PaymentID, PaymentDate, PaymentAmount, PayerName, PAYERTYPE,
			      PaymentNumber, Description, UNAPPLIEDAMOUNT, RefundsTotal, Deletable)				

		SELECT PaymentID, PaymentDate, PaymentAmount, PayerName, PAYERTYPE,
			      PaymentNumber, Description, UNAPPLIEDAMOUNT, RefundsTotal, Deletable 
		FROM @TOQUERY 
		WHERE ((@applied_status = 'Unapplied'
				AND UNAPPLIEDAMOUNT<>0)
			OR	(@applied_status = 'Applied'
				AND UNAPPLIEDAMOUNT=0)
			OR	(@applied_status = 'All'))
			AND (((@query_domain = 'PayerName' 
					OR @query_domain = 'All')
				AND	(
					PayerName LIKE @query + '%'
					OR FirstName LIKE @query + '%'
					OR LastName LIKE @query + '%'))
			OR	((@query_domain = Null
						OR @query_domain = 'All' OR @CheckReferenceID=1)
					AND	PaymentNumber=@query))
	
		SET @totalRecords = @@ROWCOUNT
	END
	
	IF NOT EXISTS(SELECT * FROM @FINAL)
	BEGIN
		SET @totalRecords=0
		SELECT * FROM @FINAL
	END
	ELSE
	BEGIN
		SELECT * 
		FROM @Final
		WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)	
	END

END


GO


