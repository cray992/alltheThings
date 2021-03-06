set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--===========================================================================
-- GET CLAIMS
--===========================================================================
ALTER PROCEDURE [dbo].[ClaimDataProvider_GetClaims]
	@practice_id INT,
	@status VARCHAR(100),
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(64) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT

--WITH RECOMPILE
AS

BEGIN

	DECLARE @ISINT BIT
	SET @ISINT=0

	IF ISNUMERIC(@query)=1
	BEGIN
		DECLARE @BIGNumber BIGINT
		DECLARE @MAXINT BIGINT
		DECLARE @MAXBIG FLOAT

		IF CHARINDEX('-',@query)=0 AND CHARINDEX('.',@query)=0 AND CHARINDEX('\',@query)=0 AND CHARINDEX('/',@query)=0
		AND CHARINDEX('+',@query)=0
		BEGIN
			SET @query=REPLACE(REPLACE(@query,',',''),'$','')
			SET @MAXINT=2147483647
			SET @MAXBIG=9223372036854775807

			IF (@MAXBIG-CAST(@query AS FLOAT))>0
			BEGIN
				SET @BIGNumber=CAST(@query AS BIGINT)	
				SET @BIGNumber=@BIGNumber-@MAXINT

				IF @BIGNumber<0 AND @BIGNumber<>0
				BEGIN
					SET @ISINT=1
				END
			END
		END
	END

	CREATE TABLE #t_tempbase(
		ClaimID int,
		PatientID int,
		PracticeID int,
		ClaimStatusCode char(1),
		CreatedDate datetime,
		Charges money default(0),
		Receipts money default(0),
		Balance money default(0),
		ClearinghouseTrackingNumber varchar(64),
		PayerTrackingNumber varchar(64),
		ClearinghouseProcessingStatus varchar(1),
		CurrentPayerProcessingStatusTypeCode CHAR(3),
		PayerProcessingStatus varchar (500),
		ClearinghousePayer varchar(128),
		Editable bit,
		Status varchar(64),
		EncounterProcedureID int,
		PayerProcessingStatusTypeCode char(3),
		InsurancePolicyID INT,
		InsuranceCompanyPlanID INT,
		FirstBillDate DATETIME,
		LocationID INT,
		DateOfService DATETIME,
		ProcedureCodeDictionaryID INT,
		ProcedureModifier1 varchar(16),
		LastBillDate DATETIME,
		BatchType CHAR(1),
		NoResponse BIT,
		EncounterID INT)

	CREATE TABLE #t_base(
		ClaimID int,
		PatientID int,
		PracticeID int,
		ClaimStatusCode char(1),
		CreatedDate datetime,
		Charges money default(0),
		Receipts money default(0),
		Balance money default(0),
		ClearinghouseTrackingNumber varchar(64),
		PayerTrackingNumber varchar(64),
		ClearinghouseProcessingStatus varchar(1),
		CurrentPayerProcessingStatusTypeCode CHAR(3),
		PayerProcessingStatus varchar (500),
		ClearinghousePayer varchar(128),
		Editable bit,
		Status varchar(64),
		EncounterProcedureID int,
		PayerProcessingStatusTypeCode char(3),
		InsurancePolicyID INT,
		InsuranceCompanyPlanID INT,
		FirstBillDate DATETIME,
		DateOfService DATETIME,
		ProcedureCodeDictionaryID INT,
		ProcedureModifier1 varchar(16),
		EncounterID INT,
		TID INT IDENTITY(0,1))

	CREATE TABLE #t_claim(
		ClaimID int,
		PatientID int,
		PracticeID int,
		ClaimStatusCode char(1),
		CreatedDate datetime,
		Charges money default(0),
		Receipts money default(0),
		Balance money default(0),
		ClearinghouseTrackingNumber varchar(64),
		PayerTrackingNumber varchar(64),
		ClearinghouseProcessingStatus varchar(1),
		CurrentPayerProcessingStatusTypeCode CHAR(3),
		PayerProcessingStatus varchar (500),
		ClearinghousePayer varchar(128),
		Editable bit,
		Status varchar(64),
		EncounterProcedureID int,
		PayerProcessingStatusTypeCode char(3),
		InsurancePolicyID INT,
		InsuranceCompanyPlanID INT,
		FirstBillDate DATETIME,
		DateOfService DATETIME,
		ProcedureCodeDictionaryID INT,
		ProcedureModifier1 varchar(16),
		EncounterID INT,
		TID INT)

	DECLARE @ID INT
	DECLARE @Rows INT

	IF @status='All'
	BEGIN

		INSERT #t_base (ClaimID, PatientID, PracticeID, ClaimStatusCode, CreatedDate, Charges, Receipts,
						Balance, ClearinghouseTrackingNumber, PayerTrackingNumber, ClearinghouseProcessingStatus,
						CurrentPayerProcessingStatusTypeCode, PayerProcessingStatus, ClearinghousePayer,
						Editable, Status, EncounterProcedureID, PayerProcessingStatusTypeCode, InsurancePolicyID,
						InsuranceCompanyPlanID, FirstBillDate, DateOfService, ProcedureCodeDictionaryID,
						ProcedureModifier1, EncounterID)
		SELECT C.ClaimID,
			C.PatientID,
			C.PracticeID,
			C.ClaimStatusCode,
			C.CreatedDate,
			0 Charges,
			0 Receipts,
			0 Balance,
			C.ClearinghouseTrackingNumber,
			C.PayerTrackingNumber,
			C.ClearinghouseProcessingStatus,
			CASE WHEN C.CurrentPayerProcessingStatusTypeCode IN ('R00', 'DP0') THEN 1 WHEN C.CurrentPayerProcessingStatusTypeCode NOT IN ('R00', 'DP0') THEN 2 END  CurrentPayerProcessingStatusTypeCode,
			COALESCE(C.PayerProcessingStatusTypeCode, '') + COALESCE(' - ' + C.PayerProcessingStatus, '') AS PayerProcessingStatus,
			COALESCE(C.ClearinghousePayer, '') + COALESCE(' - ' + C.ClearinghousePayerReported, '') AS ClearinghousePayer,
			CASE WHEN C.ClaimStatusCode <> 'C' THEN 1 ELSE 0 END Editable,
			CASE (C.ClaimStatusCode)
				WHEN 'C' THEN 'Completed'
				WHEN 'P' THEN 'Pending'
				WHEN 'R' THEN 'Ready'
				ELSE '*** Undefined'
			END AS Status,
			C.EncounterProcedureID,
			C.PayerProcessingStatusTypeCode,
			CA.InsurancePolicyID,
			CA.InsuranceCompanyPlanID,
			C.CreatedDate FirstBillDate,
			EP.ProcedureDateOfService DateOfService,
			EP.ProcedureCodeDictionaryID,
			EP.ProcedureModifier1,
			EP.EncounterID
		FROM	Claim C
				INNER JOIN EncounterProcedure EP 
				ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
				INNER JOIN Patient P
				ON C.PracticeID=P.PracticeID AND C.PatientID=P.PatientID
				LEFT JOIN ClaimAccounting_Assignments CA
				ON C.PracticeID=CA.PracticeID AND CA.LastAssignment=1 AND C.PatientID=CA.PatientID AND C.ClaimID=CA.ClaimID
		WHERE	C.PracticeID=@practice_id
				AND (	(@query_domain IS NULL OR @query IS NULL)
				OR	((@query_domain = 'ClaimID' OR @query_domain = 'All')
					AND (C.ClaimID=CASE WHEN @ISINT=1 THEN CAST(@query AS INT) END) OR @query='')
				OR  ((@query_domain = 'PatientID' OR @query_domain= 'All')
					AND C.PatientID=CASE WHEN @ISINT=1 THEN CAST(@query AS INT) END OR @query='')
				OR	((@query_domain = 'ClearinghousePayer' OR @query_domain = 'All')
					AND (C.ClearinghousePayer LIKE '%' + @query + '%' OR C.ClearinghousePayerReported LIKE '%' + @query + '%'))
				OR	((@query_domain = 'ClearinghouseProcessingStatus' OR @query_domain = 'All')
					AND C.ClearinghouseProcessingStatus = @query)
				OR	((@query_domain = 'ClearinghouseTrackingNumber' OR @query_domain = 'All')
					AND C.ClearinghouseTrackingNumber LIKE '%' + @query + '%')
				OR	((@query_domain = 'PayerProcessingStatus' OR @query_domain = 'All')
					AND C.PayerProcessingStatus LIKE '%' + @query + '%')
				OR	((@query_domain = 'PayerTrackingNumber' OR @query_domain = 'All')
					AND C.PayerTrackingNumber LIKE '%' + @query + '%')
				OR	((@query_domain = 'PatientName' OR @query_domain = 'All')
					AND (P.FirstName LIKE '%' + @query + '%' OR P.LastName LIKE '%' + @query + '%')
				OR	((@query_domain = 'PatientName' OR @query_domain = 'All')
					AND 	( P.FirstName LIKE '%' + @query + '%' 
						OR P.LastName LIKE '%' + @query + '%'
						OR (P.FirstName + P.LastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
						OR (P.LastName + P.FirstName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%' )
					)
				)
				)
				ORDER BY EP.ProcedureDateOfService DESC

		SET @totalRecords=@@ROWCOUNT	
	END
	ELSE IF @status <> 'ReadyElectronicClaimsToSubmit'
	BEGIN

			IF (@status = 'Errors' OR @status = 'ErrorsNoResponse')
			BEGIN

				INSERT #t_tempbase
				SELECT	C.ClaimID,
					C.PatientID,
					C.PracticeID,
					C.ClaimStatusCode,
					C.CreatedDate,
					0 Charges,
					0 Receipts,
					0 Balance,
					C.ClearinghouseTrackingNumber,
					C.PayerTrackingNumber,
					C.ClearinghouseProcessingStatus,
					C.CurrentPayerProcessingStatusTypeCode,
					COALESCE(C.PayerProcessingStatusTypeCode, '') + COALESCE(' - ' + C.PayerProcessingStatus, '') AS PayerProcessingStatus,
					COALESCE(C.ClearinghousePayer, '') + COALESCE(' - ' + C.ClearinghousePayerReported, '') AS ClearinghousePayer,
					CASE WHEN C.ClaimStatusCode <> 'C' THEN 1 ELSE 0 END Editable,
					CASE (C.ClaimStatusCode)
						WHEN 'C' THEN 'Completed'
						WHEN 'P' THEN 'Pending'
						WHEN 'R' THEN 'Ready'
						ELSE '*** Undefined'
					END AS Status,
					C.EncounterProcedureID,
					C.PayerProcessingStatusTypeCode,
					CA.InsurancePolicyID,
					CA.InsuranceCompanyPlanID,
					C.CreatedDate FirstBillDate,
					E.LocationID,
					EP.ProcedureDateOfService DateOfService,
					EP.ProcedureCodeDictionaryID,
					EP.ProcedureModifier1,
					CAB.PostingDate LastBillDate,
					CAB.BatchType,
					NULL NoResponse,
					E.EncounterID
				FROM	Claim C INNER JOIN Patient P
				ON C.PracticeID=P.PracticeID AND C.PatientID=P.PatientID
				INNER JOIN EncounterProcedure EP 
				ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
				INNER JOIN Encounter E
				ON EP.PracticeID=E.PracticeID AND EP.EncounterID=E.EncounterID
				LEFT JOIN ClaimAccounting_Assignments CA
				ON C.PracticeID=CA.PracticeID AND CA.LastAssignment=1 AND C.PatientID=CA.PatientID AND C.ClaimID=CA.ClaimID
				LEFT JOIN ClaimAccounting_Billings CAB
				ON CA.PracticeID=CAB.PracticeID AND CAB.Status=0 AND CAB.LastBilled=1 AND CA.ClaimID=CAB.ClaimID 
				WHERE	C.PracticeID = @practice_id 
					AND C.ClaimStatusCode = CASE 
												WHEN @status = 'Completed' THEN 'C'
												WHEN @status IN ('Ready', 'ReadyPaperClaimsToPrint', 'ReadyPatientStatementsToSend') THEN 'R'
											ELSE 'P'
											END	
					AND	((@status IN ('Ready','Pending','ReadyPaperClaimsToPrint','PendingInsurance')
						AND CA.InsurancePolicyID IS NOT NULL)
					OR	(@status IN ('Ready','Pending','ReadyPatientStatementsToSend','PendingPatient')
						AND CA.ClaimID IS NOT NULL 
						AND CA.InsurancePolicyID IS NULL)
					OR  (@status='Completed')
					OR 	(@status = 'Errors' 
						AND C.ClearinghouseProcessingStatus IS NOT NULL
						AND CA.InsurancePolicyID IS NOT NULL)
					OR 	(@status = 'ErrorsNoResponse'
						AND C.CurrentPayerProcessingStatusTypeCode IS NULL
						AND C.ClearinghouseProcessingStatus = 'P'
						AND CA.InsurancePolicyID IS NOT NULL)
					OR 	(@status = 'ErrorsRejections'
						AND (C.CurrentPayerProcessingStatusTypeCode = 'R00' 
							OR C.ClearinghouseProcessingStatus = 'R' AND C.CurrentPayerProcessingStatusTypeCode IS NOT NULL)
						AND CA.InsurancePolicyID IS NOT NULL)
					OR 	(@status = 'ErrorsDenials'
						AND C.ClearinghouseProcessingStatus IS NOT NULL
						AND C.CurrentPayerProcessingStatusTypeCode = 'DP0'
						AND CA.InsurancePolicyID IS NOT NULL)
	  				)
					AND ((@query_domain IS NULL OR @query IS NULL)
					OR	((@query_domain = 'ClaimID' OR @query_domain = 'All')
						AND (C.ClaimID=CASE WHEN @ISINT=1 THEN CAST(@query AS INT) END) OR @query='')
					OR  ((@query_domain = 'PatientID' OR @query_domain= 'All')
						AND C.PatientID=CASE WHEN @ISINT=1 THEN CAST(@query AS INT) END OR @query='')
					OR	((@query_domain = 'ClearinghousePayer' OR @query_domain = 'All')
						AND (C.ClearinghousePayer LIKE '%' + @query + '%' OR C.ClearinghousePayerReported LIKE '%' + @query + '%'))
					OR	((@query_domain = 'ClearinghouseProcessingStatus' OR @query_domain = 'All')
						AND C.ClearinghouseProcessingStatus = @query)
					OR	((@query_domain = 'ClearinghouseTrackingNumber' OR @query_domain = 'All')
						AND C.ClearinghouseTrackingNumber LIKE '%' + @query + '%')
					OR	((@query_domain = 'PayerProcessingStatus' OR @query_domain = 'All')
						AND C.PayerProcessingStatus LIKE '%' + @query + '%')
					OR	((@query_domain = 'PayerTrackingNumber' OR @query_domain = 'All')
						AND C.PayerTrackingNumber LIKE '%' + @query + '%')
					OR	((@query_domain = 'PatientName' OR @query_domain = 'All')
						AND (P.FirstName LIKE '%' + @query + '%' OR P.LastName LIKE '%' + @query + '%')
					OR	((@query_domain = 'PatientName' OR @query_domain = 'All')
						AND 	( P.FirstName LIKE '%' + @query + '%' 
							OR P.LastName LIKE '%' + @query + '%'
							OR (P.FirstName + P.LastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
							OR (P.LastName + P.FirstName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%' )
						)
					)
					)

				DECLARE @CurrentDate DATETIME
				SET @CurrentDate=GETDATE()

				UPDATE t SET NoResponse=
				CASE WHEN ((t.BatchType = 'P' AND (@CurrentDate-t.LastBillDate)>C.NoResponseTriggerPaper)
					OR (t.BatchType = 'E' AND (@CurrentDate-t.LastBillDate)>C.NoResponseTriggerElectronic))
					AND t.CurrentPayerProcessingStatusTypeCode IS NULL
					 THEN 1 ELSE 0 END
				FROM #t_tempbase t INNER JOIN ContractToServiceLocation CTSL
				ON CTSL.ServiceLocationID = t.LocationID
				INNER JOIN Contract C
				ON t.PracticeID=C.PracticeID 
				AND CTSL.ContractID=C.ContractID
				AND C.ContractType='S'
				AND t.DateOfService BETWEEN C.EffectiveStartDate AND C.EffectiveEndDate

				UPDATE t SET NoResponse=
				CASE WHEN ((t.BatchType = 'P' AND (@CurrentDate-t.LastBillDate)>C.NoResponseTriggerPaper)
					OR (t.BatchType = 'E' AND (@CurrentDate-t.LastBillDate)>C.NoResponseTriggerElectronic))
					AND t.CurrentPayerProcessingStatusTypeCode IS NULL
					 THEN 1 ELSE 0 END
				FROM #t_tempbase t INNER JOIN ContractToServiceLocation CTSL
				ON CTSL.ServiceLocationID = t.LocationID
				INNER JOIN Contract C
				ON t.PracticeID=C.PracticeID 
				AND CTSL.ContractID=C.ContractID
				AND C.ContractType='P'
				AND t.DateOfService BETWEEN C.EffectiveStartDate AND C.EffectiveEndDate
				INNER JOIN ContractToInsurancePlan CTIP
				ON C.ContractID=CTIP.ContractID
				AND t.InsuranceCompanyPlanID=CTIP.PlanID

				IF (@status = 'Errors') 
				BEGIN
					DELETE 	#t_tempbase
					WHERE 	( (CurrentPayerProcessingStatusTypeCode NOT IN ('R00', 'DP0') 
							OR CurrentPayerProcessingStatusTypeCode IS NULL )
							AND ( NoResponse <> 1 OR NoResponse IS NULL)
							AND ClearinghouseProcessingStatus <> 'R'
						  OR CurrentPayerProcessingStatusTypeCode IS NULL 
						  AND ( NoResponse <> 1 OR NoResponse IS NULL)
						  AND ClearinghouseProcessingStatus = 'R')
				END
				ELSE BEGIN
					DELETE 	#t_tempbase
					WHERE 	(NoResponse <> 1 OR NoResponse IS NULL)
				END

				INSERT #t_base
				SELECT ClaimID,
					PatientID,
					PracticeID,
					ClaimStatusCode,
					CreatedDate,
					Charges,
					Receipts,
					Balance,
					ClearinghouseTrackingNumber,
					PayerTrackingNumber,
					ClearinghouseProcessingStatus,
					CurrentPayerProcessingStatusTypeCode,
					PayerProcessingStatus,
					ClearinghousePayer,
					Editable,
					Status = 
					CASE
						WHEN Status = 'Pending' 
							AND (
								(CurrentPayerProcessingStatusTypeCode IN ('R00', 'DP0')) 
								OR (NoResponse = 1)
								OR (ClearinghouseProcessingStatus = 'R')
							) THEN 'Error'
						ELSE Status
					END,
					EncounterProcedureID,
					PayerProcessingStatusTypeCode,
					InsurancePolicyID,
					InsuranceCompanyPlanID,
					FirstBillDate,
					DateOfService,
					ProcedureCodeDictionaryID,
					ProcedureModifier1,
					EncounterID
				FROM #t_tempbase t
				ORDER BY t.DateOfService DESC

				SET @totalRecords=@@ROWCOUNT	
			END
			ELSE
			BEGIN
				INSERT #t_base
				SELECT	C.ClaimID,
					C.PatientID,
					C.PracticeID,
					C.ClaimStatusCode,
					C.CreatedDate,
					0 Charges,
					0 Receipts,
					0 Balance,
					C.ClearinghouseTrackingNumber,
					C.PayerTrackingNumber,
					C.ClearinghouseProcessingStatus,
					CASE WHEN C.CurrentPayerProcessingStatusTypeCode IN ('R00', 'DP0') THEN 1 WHEN C.CurrentPayerProcessingStatusTypeCode NOT IN ('R00', 'DP0') THEN 2 END  CurrentPayerProcessingStatusTypeCode,
					COALESCE(C.PayerProcessingStatusTypeCode, '') + COALESCE(' - ' + C.PayerProcessingStatus, '') AS PayerProcessingStatus,
					COALESCE(C.ClearinghousePayer, '') + COALESCE(' - ' + C.ClearinghousePayerReported, '') AS ClearinghousePayer,
					CASE WHEN C.ClaimStatusCode <> 'C' THEN 1 ELSE 0 END Editable,
					CASE (C.ClaimStatusCode)
						WHEN 'C' THEN 'Completed'
						WHEN 'P' THEN 'Pending'
						WHEN 'R' THEN 'Ready'
						ELSE '*** Undefined'
					END AS Status,
					C.EncounterProcedureID,
					C.PayerProcessingStatusTypeCode,
					CA.InsurancePolicyID,
					CA.InsuranceCompanyPlanID,
					C.CreatedDate FirstBillDate,
					EP.ProcedureDateOfService DateOfService,
					EP.ProcedureCodeDictionaryID,
					EP.ProcedureModifier1,
					EP.EncounterID
				FROM	Claim C INNER JOIN Patient P
				ON C.PracticeID=P.PracticeID AND C.PatientID=P.PatientID
				INNER JOIN EncounterProcedure EP 
				ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
				LEFT JOIN ClaimAccounting_Assignments CA
				ON C.PracticeID=CA.PracticeID AND CA.LastAssignment=1 AND C.PatientID=CA.PatientID AND C.ClaimID=CA.ClaimID
				WHERE	C.PracticeID = @practice_id 
					AND C.ClaimStatusCode = CASE 
												WHEN @status = 'Completed' THEN 'C'
												WHEN @status IN ('Ready', 'ReadyPaperClaimsToPrint', 'ReadyPatientStatementsToSend') THEN 'R'
											ELSE 'P'
											END	
					AND	((@status IN ('Ready','Pending','ReadyPaperClaimsToPrint','PendingInsurance')
						AND CA.InsurancePolicyID IS NOT NULL)
					OR	(@status IN ('Ready','Pending','ReadyPatientStatementsToSend','PendingPatient')
						AND CA.ClaimID IS NOT NULL 
						AND CA.InsurancePolicyID IS NULL)
					OR  (@status='Completed')
					OR 	(@status = 'ErrorsRejections'
						AND (C.CurrentPayerProcessingStatusTypeCode = 'R00' 
							OR C.ClearinghouseProcessingStatus = 'R' AND C.CurrentPayerProcessingStatusTypeCode IS NOT NULL)
						AND CA.InsurancePolicyID IS NOT NULL)
					OR 	(@status = 'ErrorsDenials'
						AND C.ClearinghouseProcessingStatus IS NOT NULL
						AND C.CurrentPayerProcessingStatusTypeCode = 'DP0'
						AND CA.InsurancePolicyID IS NOT NULL)
	  				)
					AND ((@query_domain IS NULL OR @query IS NULL)
					OR	((@query_domain = 'ClaimID' OR @query_domain = 'All')
						AND (C.ClaimID=CASE WHEN @ISINT=1 THEN CAST(@query AS INT) END) OR @query='')
					OR  ((@query_domain = 'PatientID' OR @query_domain= 'All')
						AND C.PatientID=CASE WHEN @ISINT=1 THEN CAST(@query AS INT) END OR @query='')
					OR	((@query_domain = 'ClearinghousePayer' OR @query_domain = 'All')
						AND (C.ClearinghousePayer LIKE '%' + @query + '%' OR C.ClearinghousePayerReported LIKE '%' + @query + '%'))
					OR	((@query_domain = 'ClearinghouseProcessingStatus' OR @query_domain = 'All')
						AND C.ClearinghouseProcessingStatus = @query)
					OR	((@query_domain = 'ClearinghouseTrackingNumber' OR @query_domain = 'All')
						AND C.ClearinghouseTrackingNumber LIKE '%' + @query + '%')
					OR	((@query_domain = 'PayerProcessingStatus' OR @query_domain = 'All')
						AND C.PayerProcessingStatus LIKE '%' + @query + '%')
					OR	((@query_domain = 'PayerTrackingNumber' OR @query_domain = 'All')
						AND C.PayerTrackingNumber LIKE '%' + @query + '%')
					OR	((@query_domain = 'PatientName' OR @query_domain = 'All')
						AND (P.FirstName LIKE '%' + @query + '%' OR P.LastName LIKE '%' + @query + '%')
					OR	((@query_domain = 'PatientName' OR @query_domain = 'All')
						AND 	( P.FirstName LIKE '%' + @query + '%' 
							OR P.LastName LIKE '%' + @query + '%'
							OR (P.FirstName + P.LastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
							OR (P.LastName + P.FirstName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%' )
						)
					)
					)
				ORDER BY EP.ProcedureDateOfService DESC

				SET @totalRecords=@@ROWCOUNT	
			END
	END
	ELSE IF @status = 'ReadyElectronicClaimsToSubmit'
	BEGIN

		INSERT #t_tempbase
		SELECT	C.ClaimID,
			C.PatientID,
			C.PracticeID,
			C.ClaimStatusCode,
			C.CreatedDate,
			0 Charges,
			0 Receipts,
			0 Balance,
			C.ClearinghouseTrackingNumber,
			C.PayerTrackingNumber,
			C.ClearinghouseProcessingStatus,
			C.CurrentPayerProcessingStatusTypeCode,
			COALESCE(C.PayerProcessingStatusTypeCode, '') + COALESCE(' - ' + C.PayerProcessingStatus, '') AS PayerProcessingStatus,
			COALESCE(C.ClearinghousePayer, '') + COALESCE(' - ' + C.ClearinghousePayerReported, '') AS ClearinghousePayer,
			CASE WHEN C.ClaimStatusCode <> 'C' THEN 1 ELSE 0 END Editable,
			CASE (C.ClaimStatusCode)
				WHEN 'C' THEN 'Completed'
				WHEN 'P' THEN 'Pending'
				WHEN 'R' THEN 'Ready'
				ELSE '*** Undefined'
			END AS Status,
			C.EncounterProcedureID,
			C.PayerProcessingStatusTypeCode,
			CAA.InsurancePolicyID,
			CAA.InsuranceCompanyPlanID,
			C.CreatedDate FirstBillDate,
			E.LocationID,
			EP.ProcedureDateOfService DateOfService,
			EP.ProcedureCodeDictionaryID,
			EP.ProcedureModifier1,
			NULL LastBillDate,
			NULL BatchType,
			NULL NoResponse,
			E.EncounterID
		FROM	Claim C INNER JOIN ClaimAccounting_Assignments CAA
		ON C.PracticeID=CAA.PracticeID AND CAA.Status=0 AND CAA.LastAssignment=1 AND C.ClaimID=CAA.ClaimID AND CAA.InsurancePolicyID IS NOT NULL
		INNER JOIN Patient P
		ON C.PracticeID=P.PracticeID AND C.PatientID=P.PatientID
		INNER JOIN EncounterProcedure EP
		ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN Encounter E
		ON EP.PracticeID=E.PracticeID AND EP.EncounterID=E.EncounterID
		INNER JOIN PatientCase PC
		ON E.PracticeID=PC.PracticeID AND E.PatientCaseID=PC.PatientCaseID
		INNER JOIN Practice Pr
		ON PC.PracticeID=Pr.PracticeID	
		INNER JOIN InsuranceCompanyPlan ICP
		ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
		INNER JOIN InsuranceCompany IC
		ON ICP.InsuranceCompanyID=IC.InsuranceCompanyID
		LEFT JOIN ClearingHousePayersList CPL
		ON IC.ClearingHousePayerID = CPL.ClearingHousePayerID
		LEFT JOIN PracticeToInsuranceCompany PTIC
		ON PTIC.PracticeID = PR.PracticeID AND PTIC.InsuranceCompanyID = IC.InsuranceCompanyID
		LEFT JOIN PatientCaseDate PCD
		ON PC.PracticeID=PCD.PracticeID AND PC.PatientCaseID=PCD.PatientCaseID AND PCD.PatientCaseDateTypeID=6	
		WHERE	C.PracticeID = @practice_id
			AND C.ClaimStatusCode = 'R'
			AND ((@query_domain IS NULL OR @query IS NULL)
			OR	((@query_domain = 'ClaimID' OR @query_domain = 'All')
				AND (C.ClaimID=CASE WHEN @ISINT=1 THEN CAST(@query AS INT) END) OR @query='')
			OR  ((@query_domain = 'PatientID' OR @query_domain= 'All')
				AND C.PatientID=CASE WHEN @ISINT=1 THEN CAST(@query AS INT) END OR @query='')
			OR	((@query_domain = 'ClearinghousePayer' OR @query_domain = 'All')
				AND (C.ClearinghousePayer LIKE '%' + @query + '%' OR C.ClearinghousePayerReported LIKE '%' + @query + '%'))
			OR	((@query_domain = 'ClearinghouseProcessingStatus' OR @query_domain = 'All')
				AND C.ClearinghouseProcessingStatus = @query)
			OR	((@query_domain = 'ClearinghouseTrackingNumber' OR @query_domain = 'All')
				AND C.ClearinghouseTrackingNumber LIKE '%' + @query + '%')
			OR	((@query_domain = 'PayerProcessingStatus' OR @query_domain = 'All')
				AND C.PayerProcessingStatus LIKE '%' + @query + '%')
			OR	((@query_domain = 'PayerTrackingNumber' OR @query_domain = 'All')
				AND C.PayerTrackingNumber LIKE '%' + @query + '%')
			OR	((@query_domain = 'PatientName' OR @query_domain = 'All')
				AND (P.FirstName LIKE '%' + @query + '%' OR P.LastName LIKE '%' + @query + '%')
			OR	((@query_domain = 'PatientName' OR @query_domain = 'All')
				AND 	( P.FirstName LIKE '%' + @query + '%' 
					OR P.LastName LIKE '%' + @query + '%'
					OR (P.FirstName + P.LastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
					OR (P.LastName + P.FirstName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%' )
				)
			)
			)
			AND NOT (C.NonElectronicOverrideFlag = 1 OR E.DoNotSendElectronic = 1)
			AND PC.AutoAccidentRelatedFlag = 0
			AND PC.EmploymentRelatedFlag = 0
			AND NOT (PCD.StartDate IS NULL 
						AND E.HospitalizationStartDT IS NULL
						AND E.PlaceOfServiceCode IN (21,51))
			AND PR.EClaimsEnrollmentStatusID > 1
			AND IC.EClaimsAccepts = 1 AND (PTIC.EClaimsDisable IS NULL OR PTIC.EClaimsDisable = 0)
			AND CPL.PayerNumber IS NOT NULL
			AND (CPL.IsEnrollmentRequired = 0 OR PTIC.EClaimsEnrollmentStatusID > 1) 

		CREATE TABLE #ClaimsWAdj(ClaimID INT)
		INSERT INTO #ClaimsWAdj(ClaimID)
		SELECT DISTINCT t.ClaimID
		FROM #t_tempbase t INNER JOIN ClaimAccounting CA
		ON t.ClaimID=CA.ClaimID	
		WHERE CA.PracticeID=@practice_id AND CA.status=0 AND ClaimTransactionTypeCode='ADJ'

		DELETE t
		FROM #t_tempbase t INNER JOIN #ClaimsWAdj C
		ON t.ClaimID=C.ClaimID

		INSERT #t_base
		SELECT ClaimID,
			PatientID,
			PracticeID,
			ClaimStatusCode,
			CreatedDate,
			Charges,
			Receipts,
			Balance,
			ClearinghouseTrackingNumber,
			PayerTrackingNumber,
			ClearinghouseProcessingStatus,
			CurrentPayerProcessingStatusTypeCode,
			PayerProcessingStatus,
			ClearinghousePayer,
			Editable,
			Status,
			EncounterProcedureID,
			PayerProcessingStatusTypeCode,
			InsurancePolicyID,
			InsuranceCompanyPlanID,
			FirstBillDate,
			DateOfService,
			ProcedureCodeDictionaryID,
			ProcedureModifier1,
			EncounterID
		FROM #t_tempbase t
		ORDER BY t.DateOfService DESC

		SET @totalRecords=@@ROWCOUNT	

		DROP TABLE #ClaimsWAdj
	END

	IF @maxRecords = 0
		SET @maxRecords = @totalRecords

	INSERT INTO #t_claim
	SELECT *
	FROM #t_base
	WHERE TID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)

	CREATE TABLE #ClaimAmounts( 
		ClaimID INT, 
		Charges MONEY, 
		Receipts MONEY, 
		Balance MONEY )

	INSERT INTO #ClaimAmounts (
		ClaimID, 
		Charges, 
		Receipts, 
		Balance )
	SELECT 	CA.ClaimID,
		SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)-SUM(CASE WHEN ClaimTransactionTypeCode IN ('ADJ','END') THEN Amount ELSE 0 END) Charges,
		SUM(CASE WHEN ClaimTransactionTypeCode='PAY' THEN Amount ELSE 0 END) Receipts,
		SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END) Balance
	FROM ClaimAccounting CA INNER JOIN #t_claim C
	ON CA.PracticeID=C.PracticeID AND CA.ClaimID=C.ClaimID
	WHERE CA.PracticeID=@practice_id
	GROUP BY CA.ClaimID

	--Update FirstBillDate
	IF @status='ReadyPaperClaimsToPrint'
	BEGIN
		-- This code is also in BusinessRule_PaymentPostingDateIsValid
		DECLARE @FirstInsAssigned TABLE(ClaimID INT, FirstInsAssignedDate DATETIME)
		INSERT @FirstInsAssigned(ClaimID, FirstInsAssignedDate)
		SELECT CAA.ClaimID, MIN(PostingDate) FirstInsAssignedDate
		FROM #t_claim t INNER JOIN ClaimAccounting_Assignments CAA
		ON t.PracticeID=CAA.PracticeID AND t.ClaimID=CAA.ClaimID
		WHERE TID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
		GROUP BY CAA.ClaimID

		DECLARE @FirstBillDates TABLE(TID INT, FirstBillDate DATETIME)
		INSERT @FirstBillDates(TID, FirstBillDate)
		SELECT TID, MIN(PostingDate) FirstBillDate
		FROM #t_claim t INNER JOIN @FirstInsAssigned FIA
		ON t.ClaimID=FIA.ClaimID
		INNER JOIN ClaimAccounting_Billings CAB
		ON t.PracticeID=CAB.PracticeID AND t.ClaimID=CAB.ClaimID
		AND CAB.PostingDate>=FIA.FirstInsAssignedDate
		WHERE TID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
		GROUP BY TID
		
		UPDATE t SET FirstBillDate=FBD.FirstBillDate
		FROM #t_claim t INNER JOIN @FirstBillDates FBD
		ON t.TID=FBD.TID

	END

	DECLARE @EncountersToCount TABLE(EncounterID INT)
	INSERT @EncountersToCount(EncounterID)
	SELECT DISTINCT EncounterID
	FROM #t_claim
	
	CREATE TABLE #ClaimCount(EncounterID INT, ClaimCount INT)
	INSERT INTO #ClaimCount(EncounterID, ClaimCount)
	SELECT ETC.EncounterID, COUNT(EP.EncounterProcedureID)
	FROM Encounter E INNER JOIN @EncountersToCount ETC 
	ON E.PracticeID=@practice_id AND E.EncounterID=ETC.EncounterID
	INNER JOIN EncounterProcedure EP
	ON E.PracticeID=EP.PracticeID AND E.EncounterID=EP.EncounterID
	GROUP BY ETC.EncounterID

	CREATE TABLE #t_results(
	ClaimID int,
	CreatedDate datetime,
	DateOfService DATETIME,
	ProcedureCode VARCHAR(16),
	ProcedureModifier1 VARCHAR(16),
	PatientDisplayName VARCHAR(200),
	InsurancePolicyID INT,
	AssignedToDisplayName VARCHAR(200),
	Charges money default(0),
	Receipts money default(0),
	Balance money default(0),
	ClearinghouseTrackingNumber varchar(64),
	PayerTrackingNumber varchar(64),
	ClearinghouseProcessingStatus varchar(1),
	PayerProcessingStatus varchar (500),
	ClearinghousePayer varchar(128),
	Editable bit,
	Status varchar(64),
	FirstBillDate DATETIME,
	EncounterID INT,
	ClaimCount INT,
	RID INT)

	INSERT INTO #t_results
	SELECT t.ClaimID, t.CreatedDate, DateOfService, PCD.ProcedureCode, t.ProcedureModifier1,
	COALESCE(P.LastName + ',', '') + COALESCE(' ' + P.FirstName, '') + COALESCE(' ' + P.MiddleName, '') AS PatientDisplayName,
	t.InsurancePolicyID, 
	ISNULL(CAST ((CASE 
	WHEN t.ClaimStatusCode = 'C' THEN 'Unassigned'
	WHEN t.InsurancePolicyID IS NULL THEN 'Patient'
	ELSE NULL 
	END) AS varchar(100)), ICP.PlanName) AssignedToDisplayName,
	CA.Charges, CA.Receipts, CA.Balance,
	ClearinghouseTrackingNumber, 
	PayerTrackingNumber,
	ClearinghouseProcessingStatus, 
	PayerProcessingStatus, 
	ClearinghousePayer, 
	Editable, 
	Status,
	FirstBillDate,
	t.EncounterID,
	CC.ClaimCount,
	t.TID RID
	FROM #t_claim t INNER JOIN ProcedureCodeDictionary PCD
	ON t.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
	INNER JOIN Patient P
	ON t.PracticeID=P.PracticeID AND t.PatientID=P.PatientID
	LEFT JOIN InsuranceCompanyPlan ICP 
	ON t.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	LEFT JOIN #ClaimAmounts CA
	ON t.ClaimID=CA.ClaimID
	LEFT JOIN #ClaimCount CC
	ON t.EncounterID=CC.EncounterID
	WHERE P.PracticeID=@practice_id

	SELECT *
	FROM #t_results
	ORDER BY DateOfService DESC, PatientDisplayName, ClaimID DESC

	DROP TABLE #t_tempbase
	DROP TABLE #t_base
	DROP TABLE #t_claim
	DROP TABLE #ClaimAmounts
	DROP TABLE #ClaimCount

	RETURN

END


