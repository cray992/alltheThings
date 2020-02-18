--===========================================================================
-- 
-- BILL DATA PROVIDER
--
--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BillDataProvider_GetStatementBatchXML'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.BillDataProvider_GetStatementBatchXML
GO

--===========================================================================
-- GET STATEMENT BATCH XML
--===========================================================================

CREATE PROCEDURE dbo.BillDataProvider_GetStatementBatchXML
	@batch_id INT
AS
BEGIN


	DECLARE @current_date DATETIME
	SET @current_date = GETDATE()

	DECLARE @format_id INT
	SET @format_id = ISNULL((SELECT TOP 1 BB.FormatId FROM BillBatch BB WHERE BB.BillBatchID = @batch_id), -1)

	-- make a list of claims that go into the current batch
	SELECT C.ClaimID, C.PatientID
	INTO #tt
	FROM	Bill_Statement B
		INNER JOIN BillClaim BC
		ON BC.BillID = B.BillID
		AND BC.BillBatchTypeCode = 'S'
		INNER JOIN Claim C
		ON C.ClaimID = BC.ClaimID
	WHERE	B.BillBatchID = @batch_id AND B.Active = 1


	SELECT	1 AS Tag, NULL AS Parent,
		@batch_id AS [batch!1!batch-id],
		@format_id AS [batch!1!format-id],
		(	SELECT	COUNT(*)
			FROM	Bill_Statement B
			WHERE	BillBatchID = @batch_id AND B.Active = 1
		) AS [batch!1!statement-count],
		NULL AS [statement!2!statement-id],
		NULL AS [statement!2!statement-number],
		CAST(NULL AS DATETIME) AS [statement!2!statement-date],
		NULL AS [statement!2!page-count],
		NULL AS [statement!2!page-number],
		NULL AS [statement!2!practice-name],
		NULL AS [statement!2!practice-street-1],
		NULL AS [statement!2!practice-street-2],
		NULL AS [statement!2!practice-city],
		NULL AS [statement!2!practice-state],
		NULL AS [statement!2!practice-zip],
		NULL AS [statement!2!practice-phone],
		NULL AS [statement!2!patient-id],
		NULL AS [statement!2!patient-prefix],
		NULL AS [statement!2!patient-first-name],
		NULL AS [statement!2!patient-middle-name],
		NULL AS [statement!2!patient-last-name],
		NULL AS [statement!2!patient-suffix],
		NULL AS [statement!2!patient-street-1],
		NULL AS [statement!2!patient-street-2],
		NULL AS [statement!2!patient-city],
		NULL AS [statement!2!patient-state],
		NULL AS [statement!2!patient-zip],
		CAST(NULL AS DATETIME) AS [statement!2!last-payment-date],
		CAST(NULL AS MONEY) AS [statement!2!last-payment-amount],
		CAST(NULL AS MONEY) AS [statement!2!current-balance],
		CAST(NULL AS MONEY) AS [statement!2!thirty-day-balance],
		CAST(NULL AS MONEY) AS [statement!2!sixty-day-balance],
		CAST(NULL AS MONEY) AS [statement!2!ninety-day-balance],
		CAST(NULL AS MONEY) AS [statement!2!onehundredtwenty-day-balance],
		CAST(NULL AS MONEY) AS [statement!2!total-balance],
		CAST(NULL AS MONEY) AS [statement!2!insurance-pending-amount],
		CAST(NULL AS MONEY) AS [statement!2!balance-due-amount],
		NULL AS [line-item!3!service-id],
		CAST(NULL AS DATETIME) AS [line-item!3!service-date],
		CAST(NULL AS DATETIME) AS [line-item!3!first-bill-date],
		NULL AS [line-item!3!description],
		CAST(NULL AS MONEY) AS [line-item!3!service-charge-amount],
		CAST(NULL AS MONEY) AS [line-item!3!medicare-receipt-amount],
		CAST(NULL AS MONEY) AS [line-item!3!insurance-receipt-amount],
		CAST(NULL AS MONEY) AS [line-item!3!patient-receipt-amount],
		CAST(NULL AS MONEY) AS [line-item!3!adjustment-amount],
		CAST(NULL AS MONEY) AS [line-item!3!balance-amount],
		NULL AS [line-item!3!insurance-pending-flag],
		NULL AS [line-item!3!part-of-batch]
	INTO #t

	UNION ALL

	SELECT	2 AS Tag, 1 AS Parent,
		B.BillBatchID AS [batch!1!batch-id],
		@format_id AS [batch!1!format-id],
		NULL AS [batch!1!statement-count],
		B.BillID AS [statement!2!statement-id],
		B.PatientID AS [statement!2!statement-number],
		@current_date AS [statement!2!statement-date],
		(	SELECT	COUNT(*)
			FROM	Bill_Statement B2
			WHERE	B2.PatientID = B.PatientID
			AND	B2.BillBatchID = B.BillBatchID AND B2.Active = 1)
			AS [statement!2!page-count],
		(	SELECT	COUNT(*) + 1
			FROM	Bill_Statement B2
			WHERE	B2.PatientID = B.PatientID
			AND	B2.BillBatchID = B.BillBatchID AND B2.Active = 1
			AND	BillID < B.BillID)
			AS [statement!2!page-number],
		PR.NAME AS [statement!2!practice-name],
		PR.ADDRESSLINE1 AS [statement!2!practice-street-1],
		PR.ADDRESSLINE2 AS [statement!2!practice-street-2],
		PR.CITY AS [statement!2!practice-city],
		PR.STATE AS [statement!2!practice-state],
		PR.ZIPCODE AS [statement!2!practice-zip],
		PR.PHONE AS [statement!2!practice-phone],

		-- change here to use guarantor if it entered
		P.PATIENTID AS [statement!2!patient-id],

		CASE WHEN P.ResponsibleDifferentThanPatient=1 AND ResponsibleRelationshipToPatient<>'S' THEN UPPER(P.ResponsiblePrefix) 
		ELSE P.PREFIX END AS [statement!2!patient-prefix],
		CASE WHEN P.ResponsibleDifferentThanPatient=1 AND ResponsibleRelationshipToPatient<>'S' THEN UPPER(P.ResponsibleFirstName) 
		ELSE P.FIRSTNAME END AS [statement!2!patient-first-name],
		CASE WHEN P.ResponsibleDifferentThanPatient=1 AND ResponsibleRelationshipToPatient<>'S' THEN UPPER(P.ResponsibleMiddleName)
		ELSE P.MIDDLENAME END AS [statement!2!patient-middle-name],
		CASE WHEN P.ResponsibleDifferentThanPatient=1 AND ResponsibleRelationshipToPatient<>'S' THEN UPPER(P.ResponsibleLastName) 
		ELSE P.LASTNAME END AS [statement!2!patient-last-name],
		CASE WHEN P.ResponsibleDifferentThanPatient=1 AND ResponsibleRelationshipToPatient<>'S' THEN UPPER(P.ResponsibleSuffix)
		ELSE P.SUFFIX END AS [statement!2!patient-suffix],

		CASE WHEN P.ResponsibleDifferentThanPatient=1 AND ResponsibleRelationshipToPatient<>'S' THEN UPPER(P.ResponsibleAddressLine1)
		ELSE P.ADDRESSLINE1 END AS [statement!2!patient-street-1],
		CASE WHEN P.ResponsibleDifferentThanPatient=1 AND ResponsibleRelationshipToPatient<>'S' THEN UPPER(P.ResponsibleAddressLine2)
		ELSE P.ADDRESSLINE2 END AS [statement!2!patient-street-2],
		CASE WHEN P.ResponsibleDifferentThanPatient=1 AND ResponsibleRelationshipToPatient<>'S' THEN UPPER(P.ResponsibleCity)
		ELSE P.CITY END AS [statement!2!patient-city],
		CASE WHEN P.ResponsibleDifferentThanPatient=1 AND ResponsibleRelationshipToPatient<>'S' THEN UPPER(P.ResponsibleState)
		ELSE P.STATE END AS [statement!2!patient-state],
		CASE WHEN P.ResponsibleDifferentThanPatient=1 AND ResponsibleRelationshipToPatient<>'S' THEN ISNULL(UPPER(P.ResponsibleZIPCode), '') + ' REF:'+dbo.fn_FormatFirstMiddleLast(P.FIRSTNAME, P.MIDDLENAME, P.LASTNAME)
		ELSE P.ZIPCODE END AS [statement!2!patient-zip],

		NULL AS [statement!2!last-payment-date],
		0 AS [statement!2!last-payment-amount],
		0 AS [statement!2!current-balance],
		0 AS [statement!2!thirty-day-balance],
		0 AS [statement!2!sixty-day-balance],
		0 AS [statement!2!ninety-day-balance],
		0 AS [statement!2!onehundredtwenty-day-balance],
		0 AS [statement!2!total-balance],
		0.00 AS [statement!2!insurance-pending-amount],
		0 AS [statement!2!balance-due-amount],
		NULL AS [line-item!3!service-id],
		NULL AS [line-item!3!service-date],
		NULL AS [line-item!3!first-bill-date],
		NULL AS [line-item!3!description],
		NULL AS [line-item!3!service-charge-amount],
		NULL AS [line-item!3!medicare-receipt-amount],
		NULL AS [line-item!3!insurance-receipt-amount],
		NULL AS [line-item!3!patient-receipt-amount],
		NULL AS [line-item!3!adjustment-amount],
		NULL AS [line-item!3!balance-amount],
		NULL AS [line-item!3!insurance-pending-flag],
		NULL AS [line-item!3!part-of-batch]
	FROM 	Bill_Statement B
		INNER JOIN Patient P
		ON P.PatientID = B.PatientID
		INNER JOIN Practice PR
		ON PR.PracticeID = P.PracticeID
	WHERE	B.BillBatchID = @batch_id AND B.Active = 1

	
	UNION ALL
	
	SELECT	3 AS Tag, 2 AS Parent,
		B.BILLBATCHID AS [batch!1!batch-id],
		@format_id AS [batch!1!format-id],
		NULL AS [batch!1!statement-count],
		B.BILLID AS [statement!2!statement-id],
		NULL AS [statement!2!statement-number],
		NULL AS [statement!2!statement-date],
		NULL AS [statement!2!page-count],
		NULL AS [statement!2!page-number],
		NULL AS [statement!2!practice-name],
		NULL AS [statement!2!practice-street-1],
		NULL AS [statement!2!practice-street-2],
		NULL AS [statement!2!practice-city],
		NULL AS [statement!2!practice-state],
		NULL AS [statement!2!practice-zip],
		NULL AS [statement!2!practice-phone],
		E.PatientID AS [statement!2!patient-id],
		NULL AS [statement!2!patient-prefix],
		NULL AS [statement!2!patient-first-name],
		NULL AS [statement!2!patient-middle-name],
		NULL AS [statement!2!patient-last-name],
		NULL AS [statement!2!patient-suffix],
		NULL AS [statement!2!patient-street-1],
		NULL AS [statement!2!patient-street-2],
		NULL AS [statement!2!patient-city],
		NULL AS [statement!2!patient-state],
		NULL AS [statement!2!patient-zip],
		NULL AS [statement!2!last-payment-date],
		NULL AS [statement!2!last-payment-amount],
		NULL AS [statement!2!current-charges],
		NULL AS [statement!2!thirty-day-charges],
		NULL AS [statement!2!sixty-day-charges],
		NULL AS [statement!2!ninety-day-charges],
		NULL AS [statement!2!onehundredtwenty-day-charges],
		NULL AS [statement!2!total-charges],
		NULL AS [statement!2!insurance-amount-pending],
		NULL AS [statement!2!amount-due],
		C.ClaimID AS [line-item!3!service-id],
		DATEADD(hour, 3,EP.ProcedureDateOfService) AS [line-item!3!service-date],
		NULL AS [line-item!3!first-bill-date],
		PCD.OfficialName AS [line-item!3!description],
		0 AS [line-item!3!service-charge-amount],
		0 AS [line-item!3!medicare-receipt-amount],
		0 AS [line-item!3!insurance-receipt-amount],
		0 AS [line-item!3!patient-receipt-amount],
		0 AS [line-item!3!adjustment-amount],
		0 AS [line-item!3!balance-amount],
		CAST ((CASE WHEN CAA.InsurancePolicyID IS NOT NULL THEN 1 ELSE 0 END) AS INT) AS [line-item!3!insurance-pending-flag],
		1 AS [line-item!3!part-of-batch]
	FROM	Bill_Statement B
		INNER JOIN BillClaim BC
		ON BC.BillID = B.BillID
		AND BC.BillBatchTypeCode = 'S'
		INNER JOIN Claim C
		ON C.ClaimID = BC.ClaimID
		INNER JOIN EncounterProcedure EP 
		ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN ProcedureCodeDictionary PCD
		ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
		INNER JOIN Encounter E
		ON EP.EncounterID=E.EncounterID
		INNER JOIN ClaimAccounting_Assignments CAA
		ON C.ClaimID=CAA.ClaimID AND 1=LastAssignment
	WHERE	B.BillBatchID = @batch_id AND B.Active = 1



	UPDATE
		T
	SET
		[line-item!3!first-bill-date] = CA.PostingDate
-- 			SELECT TOP 1 
-- 				BB.ConfirmedDate
-- 			FROM
-- 				BillBatch BB 
-- 			WHERE
-- 				BB.ConfirmedDate IS NOT NULL
-- 				AND EXISTS(
-- 					SELECT
-- 						B.BillID
-- 					FROM
-- 						Bill_HCFA B
-- 						INNER JOIN BillClaim BC ON BC.BillID = B.BillID AND BC.BillBatchTypeCode = 'P'
-- 					WHERE
-- 						B.BillBatchID = BB.BillBatchID
-- 						AND BC.ClaimID = T.[line-item!3!service-id]
-- 			
-- 					UNION ALL
-- 			
-- 					SELECT
-- 						B.BillID
-- 					FROM
-- 						Bill_EDI B
-- 						INNER JOIN BillClaim BC ON BC.BillID = B.BillID AND BC.BillBatchTypeCode = 'E'
-- 					WHERE
-- 						B.BillBatchID = BB.BillBatchID
-- 						AND BC.ClaimID = T.[line-item!3!service-id]
-- 
-- 					UNION ALL
-- 
-- 					SELECT
-- 						B.BillID
-- 					FROM
-- 						Bill_Statement B
-- 						INNER JOIN BillClaim BC ON BC.BillID = B.BillID AND BC.BillBatchTypeCode = 'S'
-- 					WHERE
-- 						B.BillBatchID = BB.BillBatchID
-- 						AND B.Active = 1
-- 						AND BC.ClaimID = T.[line-item!3!service-id]
-- 				)
-- 			ORDER BY 
-- 				BB.ConfirmedDate ASC
-- 		)
	FROM
		#t T INNER JOIN ClaimAccounting CA
		ON T.[line-item!3!service-id]=CA.ClaimID
	WHERE
		CA.ClaimTransactionTypeCode='BLL' AND T.[line-item!3!service-id] IS NOT NULL

	--if first-billed is set to null, set to be current date
	UPDATE
		T
	SET
		[line-item!3!first-bill-date] = COALESCE([line-item!3!first-bill-date],@current_date)
	FROM
		#t T
	WHERE
		T.[line-item!3!service-id] IS NOT NULL


	UPDATE
		T
	SET
		[statement!2!last-payment-date] =
			DATEADD(hour, 3,
			(
				SELECT	MAX(PostingDate)
				FROM	PAYMENT
				WHERE	PayerTypeCode = 'P'
				AND	PAYERID = T.[statement!2!patient-id]
			)),
		[statement!2!last-payment-amount] = CASE WHEN T.[statement!2!last-payment-date] IS NULL THEN 0 ELSE
			(
				SELECT	TOP 1 PaymentAmount
				FROM	PAYMENT
				WHERE	PayerTypeCode = 'P'
				AND	PAYERID = T.[statement!2!patient-id]
				AND	PostingDate = DATEADD(hour,-3,T.[statement!2!last-payment-date])
				ORDER BY CreatedDate DESC
			) END

	FROM
		#t T
	WHERE
		T.[statement!2!patient-id] IS NOT NULL	
		

	UPDATE
		T
	SET
		[line-item!3!service-charge-amount] = 
			(
				COALESCE(EP.ServiceUnitCount,1) * 
				COALESCE(EP.ServiceChargeAmount,0)
			)
	FROM
		#t T
		INNER JOIN Claim C ON C.ClaimID = T.[line-item!3!service-id]
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
	WHERE
		T.[line-item!3!service-id] IS NOT NULL
			

	UPDATE
		T
	SET
		[line-item!3!medicare-receipt-amount] = 
				(
					SELECT	COALESCE(SUM(COALESCE(CA.Amount,0)),0)
					FROM	CLAIM C
						INNER JOIN ClaimAccounting CA
						ON CA.ClaimID = C.ClaimID
						AND CA.ClaimTransactionTypeCode = 'PAY'
						INNER JOIN PaymentClaimTransaction PCT
						ON CA.ClaimTransactionID=PCT.ClaimTransactionID
						INNER JOIN PAYMENT P
						ON PCT.PaymentID = P.PaymentID
						AND P.PayerTypeCode = 'I'
						INNER JOIN INSURANCECOMPANYPLAN ICP
						ON ICP.InsuranceCompanyPlanID = P.PayerID
						INNER JOIN InsuranceCompany IC
						ON ICP.InsuranceCompanyID=IC.InsuranceCompanyID
					WHERE	C.CLAIMID = T.[line-item!3!service-id]
					AND	IC.InsuranceProgramCode = 'MB'
				)
	FROM
		#t T

	WHERE
		T.[line-item!3!service-id] IS NOT NULL
		
	UPDATE
		T
	SET
		[line-item!3!insurance-receipt-amount] = 
				(
					SELECT	COALESCE(SUM(COALESCE(CA.Amount,0)),0)
					FROM	CLAIM C
						INNER JOIN ClaimAccounting CA
						ON CA.ClaimID = C.ClaimID
						AND CA.ClaimTransactionTypeCode = 'PAY'
						INNER JOIN PaymentClaimTransaction PCT
						ON CA.ClaimTransactionID=PCT.ClaimTransactionID
						INNER JOIN PAYMENT P
						ON PCT.PaymentID = P.PaymentID
						AND P.PayerTypeCode = 'I'
						INNER JOIN INSURANCECOMPANYPLAN ICP
						ON ICP.InsuranceCompanyPlanID = P.PayerID
						INNER JOIN InsuranceCompany IC
						ON ICP.InsuranceCompanyID=IC.InsuranceCompanyID
					WHERE	C.CLAIMID = T.[line-item!3!service-id]
					AND	IC.InsuranceProgramCode <> 'MB'
				)
	FROM
		#t T
	WHERE
		T.[line-item!3!service-id] IS NOT NULL
		

	UPDATE
		T
	SET
		[line-item!3!patient-receipt-amount] = 
				(
					SELECT	COALESCE(SUM(COALESCE(CA.Amount,0)),0)
					FROM	CLAIM C
						INNER JOIN ClaimAccounting CA
						ON CA.ClaimID = C.ClaimID
						AND CA.ClaimTransactionTypeCode = 'PAY'
						INNER JOIN PaymentClaimTransaction PCT
						ON CA.ClaimTransactionID=PCT.ClaimTransactionID
						INNER JOIN PAYMENT P
						ON PCT.PaymentID = P.PaymentID
						AND P.PayerTypeCode = 'P'
					WHERE	C.CLAIMID = T.[line-item!3!service-id]
				)

	FROM
		#t T
	WHERE
		T.[line-item!3!service-id] IS NOT NULL
		

	UPDATE
		T
	SET
		[line-item!3!adjustment-amount] = 
				(
					SELECT	COALESCE(SUM(COALESCE(CA.Amount,0)),0)
					FROM	CLAIM C
						LEFT JOIN ClaimAccounting CA
						ON CA.ClaimID = C.ClaimID
						AND CA.ClaimTransactionTypeCode IN ('ADJ','END')
					WHERE	C.CLAIMID = T.[line-item!3!service-id]
				)
	FROM
		#t T
	WHERE
		T.[line-item!3!service-id] IS NOT NULL
		

	UPDATE
		T
	SET
		[line-item!3!balance-amount] = 
				[line-item!3!service-charge-amount]
				-
				[line-item!3!adjustment-amount]
				-
				(
					SELECT	COALESCE(SUM(COALESCE(CA.Amount,0)),0)
					FROM	CLAIM C
						INNER JOIN ClaimAccounting CA
						ON CA.ClaimID = C.ClaimID
						AND CA.ClaimTransactionTypeCode = 'PAY'
					WHERE	C.CLAIMID = T.[line-item!3!service-id]
				)
	FROM
		#t T
	WHERE
		T.[line-item!3!service-id] IS NOT NULL




	UPDATE
		T
	SET
		[statement!2!insurance-pending-amount] = 
			(
				SELECT 
					COALESCE(SUM(A.[line-item!3!balance-amount]),0)
				FROM 
					#t A
					INNER JOIN #tt TT ON TT.ClaimID = A.[line-item!3!service-id]
				WHERE
					A.[line-item!3!insurance-pending-flag] = 1
					AND TT.PatientID = T.[statement!2!patient-id]
			)
	FROM
		#t T
	WHERE
		T.[statement!2!patient-id] IS NOT NULL



	UPDATE
		T
	SET
		[statement!2!current-balance] = 
			(
				SELECT 	
					COALESCE(SUM(A.[line-item!3!balance-amount]),0)
				FROM 	
					#t A
				WHERE	
					A.[statement!2!patient-id] = T.[statement!2!patient-id]
					AND DATEDIFF(day, A.[line-item!3!first-bill-date], @current_date) <= 30
			),
		[statement!2!thirty-day-balance] = 
			(
				SELECT 	
					COALESCE(SUM(A.[line-item!3!balance-amount]),0)
				FROM 	
					#t A
				WHERE	
					A.[statement!2!patient-id] = T.[statement!2!patient-id]
					AND DATEDIFF(day, A.[line-item!3!first-bill-date], @current_date) <= 60
					AND DATEDIFF(day, A.[line-item!3!first-bill-date], @current_date) > 30
			),
		[statement!2!sixty-day-balance] = 
			(
				SELECT 	
					COALESCE(SUM(A.[line-item!3!balance-amount]),0)
				FROM 	
					#t A
				WHERE	
					A.[statement!2!patient-id] = T.[statement!2!patient-id]
					AND DATEDIFF(day, A.[line-item!3!first-bill-date], @current_date) <= 90
					AND DATEDIFF(day, A.[line-item!3!first-bill-date], @current_date) > 60
			),
		[statement!2!ninety-day-balance] = 
			(
				SELECT 	
					COALESCE(SUM(A.[line-item!3!balance-amount]),0)
				FROM 	
					#t A
				WHERE	
					A.[statement!2!patient-id] = T.[statement!2!patient-id]
					AND DATEDIFF(day, A.[line-item!3!first-bill-date], @current_date) <= 120
					AND DATEDIFF(day, A.[line-item!3!first-bill-date], @current_date) > 90
			),
		[statement!2!onehundredtwenty-day-balance] = 
			(
				SELECT 	
					COALESCE(SUM(A.[line-item!3!balance-amount]),0)
				FROM 	
					#t A
				WHERE	
					A.[statement!2!patient-id] = T.[statement!2!patient-id]
					AND DATEDIFF(day, A.[line-item!3!first-bill-date], @current_date) > 120
			),
		[statement!2!total-balance] = 
			(
				SELECT 	
					COALESCE(SUM(A.[line-item!3!balance-amount]),0)
				FROM 	
					#t A
				WHERE	
					A.[statement!2!patient-id] = T.[statement!2!patient-id]
			)
	FROM
		#t T
	WHERE
		T.[statement!2!patient-id] IS NOT NULL


	UPDATE
		T
	SET
		[statement!2!balance-due-amount] = [statement!2!total-balance] - [statement!2!insurance-pending-amount]
	FROM
		#t T
	WHERE
		T.[statement!2!patient-id] IS NOT NULL


	
	SELECT DISTINCT * FROM #t
	ORDER BY [batch!1!batch-id],
		[statement!2!statement-id],
		[line-item!3!service-id]
	
	FOR XML EXPLICIT

	DROP TABLE #t
	DROP TABLE #tt

END

GO

