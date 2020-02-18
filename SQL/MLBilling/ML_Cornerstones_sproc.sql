----ML_Cornerstones

----USE superbill_69264_dev
----SET TRAN ISOLATION LEVEL READ UNCOMMITTED
----/*Find Practice Names*/
--SELECT * FROM dbo.Practice 
--WHERE PracticeID IN (1,2)
----/*Execute ChargesExport for each practice*/
--EXEC dbo.WebServiceDataProvider_ChargesExport_MLBilling_4 @PracticeName = 'Cornerstones Autism Services LLC', 
--                                                 @FromCreatedDate = '2018-01-01',  @ToCreatedDate = '2020-01-22' 
--EXEC dbo.WebServiceDataProvider_ChargesExport_MLBilling_4 @PracticeName = 'Cornerstones Therapeutic Svc PC', 
--                                                 @FromCreatedDate = '2018-01-01',  @ToCreatedDate = '2020-01-22'


---------


USE [superbill_69264_dev]
GO

/****** Object:  StoredProcedure [dbo].[WebServiceDataProvider_ChargesExport_v2]    Script Date: 12/6/2019 4:33:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--declare
--DROP PROCEDURE [dbo].[WebServiceDataProvider_ChargesExport_MLBilling_4]
CREATE PROCEDURE [dbo].[WebServiceDataProvider_ChargesExport_MLBilling_4]
    @PracticeName VARCHAR(100) = NULL,						 
	@FromCreatedDate DATETIME = NULL,						
	@ToCreatedDate DATETIME = NULL,							
	@FromLastModifiedDate DATETIME = NULL,					
	@ToLastModifiedDate DATETIME = NULL,					
	@PatientName VARCHAR(100) = NULL,						
	@CasePayerScenario VARCHAR(100) = NULL,					
	@FromServiceDate DATETIME = NULL,						
	@ToServiceDate DATETIME = NULL,							
	@FromPostingDate DATETIME = NULL,						
	@ToPostingDate DATETIME = NULL,							
	@BatchNumber VARCHAR(100) = NULL,						
	@SchedulingProviderFullName VARCHAR(256) = NULL,		
	@RenderingProviderFullName VARCHAR(256) = NULL,			
	@ReferringProviderFullName VARCHAR(256) = NULL,			
	@ServiceLocationName VARCHAR(256) = NULL,				
	@ProcedureCode VARCHAR(MAX) = NULL,						
	@DiagnosisCode VARCHAR(MAX) = NULL,						
	@Status VARCHAR(MAX) = NULL,							
	@BilledTo VARCHAR(MAX) = NULL,	
	@IncludeUnapprovedCharges BIT = 0,	
	@EncounterStatus VARCHAR(50) = NULL

WITH RECOMPILE	

AS

SET NOCOUNT ON;
SET XACT_ABORT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN

-- patch up if they specified only one of modified date pair
	IF @FromLastModifiedDate is not null AND @ToLastModifiedDate is null BEGIN
		SET @ToLastModifiedDate = CAST(CONVERT(VARCHAR,DATEADD(dd,7,@FromLastModifiedDate),110) AS DATETIME)
	END ELSE IF @FromLastModifiedDate IS NULL AND @ToLastModifiedDate IS NOT NULL BEGIN
		SET @FromLastModifiedDate = CAST(CONVERT(VARCHAR,DATEADD(dd,-7,@ToLastModifiedDate),110) AS DATETIME)
	END

	-- patch up if they specified only one of modified date pair
	IF @FromCreatedDate is not null AND @ToCreatedDate is null BEGIN
		SET @ToCreatedDate = CAST(CONVERT(VARCHAR,DATEADD(dd,7,@FromCreatedDate),110) AS DATETIME)
	END ELSE IF @FromCreatedDate IS NULL AND @ToCreatedDate IS NOT NULL BEGIN
		SET @FromCreatedDate = CAST(CONVERT(VARCHAR,DATEADD(dd,-7,@ToCreatedDate),110) AS DATETIME)
	END

	-- patch up if they specified only one of service date pair
	IF @FromServiceDate is not null AND @ToServiceDate is null BEGIN
		SET @ToServiceDate = CAST(CONVERT(VARCHAR,DATEADD(dd,7,@FromServiceDate),110) AS DATETIME)
	END ELSE IF @FromServiceDate IS NULL AND @ToServiceDate IS NOT NULL BEGIN
		SET @FromServiceDate = CAST(CONVERT(VARCHAR,DATEADD(dd,-7,@ToServiceDate),110) AS DATETIME)
	END

	-- patch up if they specified only one of Posting date pair
	IF @FromPostingDate is not null AND @ToPostingDate is null BEGIN
		SET @ToPostingDate = CAST(CONVERT(VARCHAR,DATEADD(dd,7,@FromPostingDate),110) AS DATETIME)
	END ELSE IF @FromPostingDate IS NULL AND @ToPostingDate IS NOT NULL BEGIN
		SET @FromPostingDate = CAST(CONVERT(VARCHAR,DATEADD(dd,-7,@ToPostingDate),110) AS DATETIME)
	END

	-- if they haven't specified complete dates for posting, lastmodified, transaction or service dates, then we'll put in some range for posting date
	IF (@FromPostingDate IS NULL) AND (@ToPostingDate IS NULL) 
		AND (@FromLastModifiedDate IS NULL) AND (@ToLastModifiedDate IS NULL) 
		AND (@FromServiceDate IS NULL) AND (@ToServiceDate IS NULL) 
		AND (@FromCreatedDate IS NULL) AND (@ToCreatedDate IS NULL) 
	BEGIN
		SET @FromPostingDate = CAST(CONVERT(VARCHAR,DATEADD(dd,-7,CURRENT_TIMESTAMP),110) AS DATETIME)
		SET @ToPostingDate = CAST(CONVERT(VARCHAR,DATEADD(dd,7,@FromPostingDate),110) AS DATETIME)
	END

	-- for all the to dates, we need to do the following logic:
	--    if they specified a specific time, honor that specific time.
	--    if they specified just a date, then look for everything through the end of that date
	SET @ToCreatedDate = case when DBO.fn_DateOnly(@ToCreatedDate) = @ToCreatedDate then DATEADD( S, -1, DBO.fn_DateOnly( DATEADD(D, 1, @ToCreatedDate))) ELSE @ToCreatedDate END
	SET @ToLastModifiedDate = case when DBO.fn_DateOnly(@ToLastModifiedDate) = @ToLastModifiedDate then DATEADD( S, -1, DBO.fn_DateOnly( DATEADD(D, 1, @ToLastModifiedDate))) ELSE @ToLastModifiedDate END
	SET @ToServiceDate = case when DBO.fn_DateOnly(@ToServiceDate) = @ToServiceDate then DATEADD( S, -1, DBO.fn_DateOnly( DATEADD(D, 1, @ToServiceDate))) ELSE @ToServiceDate END
	SET @ToPostingDate = case when DBO.fn_DateOnly(@ToPostingDate) = @ToPostingDate then DATEADD( S, -1, DBO.fn_DateOnly( DATEADD(D, 1, @ToPostingDate))) ELSE @ToPostingDate END
        
	--CREATE TABLE #CheckForNoASN (ClaimID INT, NoASN BIT, CTPostingDate DATETIME)
	--CREATE TABLE #AssignmentInfo (ClaimID INT, InsurancePolicyID INT, InsuranceCompanyPlanID INT)
	PRINT('Update @ToCreatedDate'+CAST(@ToCreatedDate as VARCHAR(MAX)))
	PRINT('Update @FromLastModifiedDate'+CAST(@FromLastModifiedDate as VARCHAR(MAX)))
	PRINT('Update @ToServiceDate'+CAST(@ToServiceDate as VARCHAR(MAX)))
	PRINT('Update @ToPostingDate'+CAST(@ToPostingDate as VARCHAR(MAX)))
	

    PRINT('BUILDING CLAIMS...');
	create TABLE #Claims( claimID int, 
					CreatedDate datetime,
					ModifiedDate datetime,
					ClaimServiceDateFrom datetime,
					ClaimServiceDateTo datetime,
					PracticeId int,
					ClaimStatusCode char(1),
					Status varchar(128),
					AssignedToDisplayName varchar(256),
					encounterID INT, 
					encounterProcedureID INT, 
					ContractID INT, 
					ProcedureCodeDictionaryID INT, 
					PatientID INT, 
					AllowedAmount MONEY, 
					ExpectedAmount MONEY, 
					ProcedureModifier1 VARCHAR(16),
					patientCaseID INT,
					DateOfService DATETIME,
					PrimaryInsPaymentID INT,
					SecondaryInsPaymentID INT,
					OtherInsPaymentID INT,
					OtherInsPaymentAmount MONEY,
					PatientPaymentID INT,
					PatientPaymentAmount MONEY,
					PostingDate datetime,
					OtherPaymentID INT,
					OtherPaymentAmount MONEY,
 

			)  

		DECLARE @SqlClaims NVARCHAR(max);

		SELECT ProcedureCodeDictionaryID 
		INTO #ParseProcedureCode 
		FROM [dbo].[fn_ReportDataProvider_ParseProcedureCode] (@ProcedureCode)


		SET @SqlClaims =
			N'
			SELECT 
			claimID, v.CreatedDate, v.ModifiedDate, v.ProcedureDateOfService, v.ServiceEndDate, v.PracticeId, v.ClaimStatusCode, v.[Status], v.encounterID, v.ContractID
			, v.encounterProcedureID, v.ProcedureCodeDictionaryID, v.PatientID, v.ProcedureModifier1, v.patientCaseID, v.DateOfService, v.PostingDate				
			from Claims_API_Query v 
		'

		IF (@ProcedureCode IS NOT NULL)
			SET @SqlClaims += ' LEFT JOIN #ParseProcedureCode pcs ON pcs.ProcedureCodeDictionaryID = v.ProcedureCodeDictionaryID'

		DECLARE @PracticeName1 VARCHAR(100)= '%'+@PracticeName+'%';

		SET @SqlClaims += ' WHERE v.PostingDate IS NOT NULL '

		IF (@FromServiceDate IS NOT NULL) SET @SqlClaims += ' AND v.ProcedureDateOfService >= @FromServiceDate'
		IF (@ToServiceDate IS NOT NULL) SET @SqlClaims += ' AND v.ProcedureDateOfService <= @ToServiceDate'
		IF (@ProcedureCode IS NOT NULL) SET @SqlClaims += ' AND v.ProcedureCodeDictionaryID = v.ProcedureCodeDictionaryID'
		IF (@BatchNumber IS NOT NULL) SET @SqlClaims += ' AND  @BatchNumber = v.BatchID '
		IF (@PracticeName IS NOT NULL) SET @SqlClaims += ' AND v.Name like @PracticeName  and v.active=1' --TODO: Add %%  to the practice name
		IF (@FromPostingDate IS NOT NULL) SET @SqlClaims += ' AND v.PostingDate>=@FromPostingDate'
		IF (@ToPostingDate IS NOT NULL) SET @SqlClaims += ' AND v.PostingDate<=@ToPostingDate'
		IF (@FromCreatedDate IS NOT NULL) SET @SqlClaims += ' AND v.CreatedDate >= @FromCreatedDate'
		IF (@ToCreatedDate IS NOT NULL) SET @SqlClaims += ' AND v.CreatedDate <= @ToCreatedDate'
		IF (@ToLastModifiedDate IS NOT NULL) SET @SqlClaims += ' AND v.ModifiedDate <= @ToLastModifiedDate'
		IF (@FromLastModifiedDate IS NOT NULL) SET @SqlClaims += ' AND v.ModifiedDate >= @FromLastModifiedDate'

		 
		PRINT(@SqlClaims)
	
		----------------------------------------------------------------------------------------------------------
 
			DECLARE @paramDefinition NVARCHAR(MAX) = '	
			@ProcedureCodeDynamic varchar(max),				
			@FromServiceDate datetime,						
			@ToServiceDate datetime,							
			@BatchNumber varchar(100),
			@PracticeName varchar(100),						 
			@FromPostingDate datetime,						
			@ToPostingDate datetime,							
			@FromCreatedDate datetime,						
			@ToCreatedDate datetime	'

		INSERT #Claims ( claimID, CreatedDate, ModifiedDate, ClaimServiceDateFrom, ClaimServiceDateTo, PracticeId, ClaimStatusCode, [Status], encounterID, ContractID
			, encounterProcedureID, ProcedureCodeDictionaryID, PatientID, ProcedureModifier1, patientCaseID, DateOfService, PostingDate)
		EXEC sp_executesql @SqlClaims, @paramDefinition,
				--Parameters
				@FromServiceDate,
				@ToServiceDate ,
				@ProcedureCode ,
				@BatchNumber  ,
				@PracticeName1,
				@FromPostingDate,
				@ToPostingDate ,
				@FromCreatedDate,
				@ToCreatedDate 
 
			----------------------------------------------------------------------------------------------------------
					CREATE CLUSTERED INDEX tClaims_ClaimID ON #Claims (claimID)	with ( statistics_norecompute = on )	

					CREATE INDEX tClaims_PostingDate ON #Claims (PostingDate)	with ( statistics_norecompute = on )	

					CREATE INDEX tClaims_encounterID_PatientID ON #Claims (encounterID,PatientID)	with ( statistics_norecompute = on )	

					CREATE INDEX t_Claims_modifiedDate ON #Claims (claimID, ModifiedDate)
				
			----------------------------------------------------------------------------------------------------------

		--DELETE FROM #Claims WHERE PostingDate IS null

	
		--INSERT #AssignmentInfo(ClaimID, InsurancePolicyID, InsuranceCompanyPlanID)
			SELECT CAA.ClaimID, CAA.InsurancePolicyID, CAA.InsuranceCompanyPlanID
			INTO #AssignmentInfo
			FROM #Claims C 
				INNER JOIN dbo.ClaimAccounting_Assignments CAA
					ON C.ClaimID=CAA.ClaimID AND CAA.LastAssignment=1
 

			SELECT C.ClaimID, CASE WHEN COUNT(CASE WHEN CT.ClaimTransactionTypeCode='ASN' THEN 1 ELSE NULL END)=0 THEN 1 ELSE 0 END NoASN,
			MIN(CASE WHEN ClaimTransactionTypeCode='CST' THEN CT.PostingDate ELSE NULL END) CTPostingDate
			INTO #CheckForNoASN
			FROM #Claims C 
				INNER JOIN dbo.ClaimTransaction CT ON C.ClaimID=CT.ClaimID AND CT.ClaimTransactionTypeCode IN ('CST','ASN')
			GROUP BY C.ClaimID

					----------------------------------------------------------------------------------------------------------
					CREATE CLUSTERED INDEX tAssignmentInfo_ClaimID ON #AssignmentInfo (ClaimID)	with ( statistics_norecompute = on )	

					CREATE CLUSTERED INDEX tCheckForNoASN_ClaimID ON #CheckForNoASN (ClaimID)	with ( statistics_norecompute = on )	
			----------------------------------------------------------------------------------------------------------
 
		UPDATE #Claims 
			SET AssignedToDisplayName = XX.AssignedToDisplayName
			FROM #Claims JOIN 
				(SELECT #Claims.ClaimId, AssignedToDisplayName = ISNULL(CAST ((CASE 
								WHEN #Claims.ClaimStatusCode = 'C' OR CFN.NoASN=1 THEN 'Unassigned'
								WHEN CAA.InsurancePolicyID IS NULL THEN 'Patient'
								ELSE NULL 
								END) AS varchar(100)), ICP.PlanName) 
					FROM #Claims 
						LEFT JOIN #AssignmentInfo CAA ON #Claims.ClaimID=CAA.ClaimID
						LEFT JOIN dbo.InsuranceCompanyPlan ICP ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
						INNER JOIN #CheckForNoASN CFN ON #Claims.ClaimID=CFN.ClaimID) XX ON #Claims.ClaimId = XX.ClaimId
	
		if @DiagnosisCode IS NOT NULL
		BEGIN

			-- Phil: fixed a bug here, first reported in SF 76494, FB 25590
			--    We used to delete anything that had NULL when matching fn_ReportDataProvider_ParseDiagnosisCode
			--    Unfortunately, this would delete any claim that had multiple Dx in even if one of the dx happened to be one we were looking for
			DELETE a
			FROM #Claims a
			WHERE a.ClaimId NOT IN (
				SELECT a.ClaimId
				FROM #Claims a
					inner join EncounterProcedure ep on ep.EncounterProcedureID = a.EncounterProcedureID 
					INNER JOIN EncounterDiagnosis ed ON ed.EncounterID = ep.EncounterID AND ed.EncounterDiagnosisID 
					IN (ep.EncounterDiagnosisID1, ep.EncounterDiagnosisID2, ep.EncounterDiagnosisID3, ep.EncounterDiagnosisID4, ep.EncounterDiagnosisID5
						, ep.EncounterDiagnosisID6, ep.EncounterDiagnosisID7, ep.EncounterDiagnosisID8)
					LEFT JOIN [dbo].[fn_ReportDataProvider_ParseDiagnosisCode] ( @DiagnosisCode ) ecd ON ecd.DiagnosisCodeDictionaryID = ed.DiagnosisCodeDictionaryID
                    LEFT JOIN [dbo].[fn_ReportDataProvider_ParseICD10DiagnosisCode] ( @DiagnosisCode ) ecd1 ON ecd1.ICD10DiagnosisCodeDictionaryID = ed.DiagnosisCodeDictionaryID
				where ecd.DiagnosisCodeDictionaryID IS NOT NULL	OR ecd1.ICD10DiagnosisCodeDictionaryID IS NOT NULL
			)			
				

		END


	        
		Update c
		SET     AllowedAmount = cfs.Allowable, ExpectedAmount = cfs.ExpectedReimbursement
		FROM 
			#Claims c
			INNER JOIN ContractFeeSchedule cfs ON cfs.ProcedureCodeDictionaryID = c.ProcedureCodeDictionaryID and cfs.ContractID = c.contractID
			INNER JOIN Patient pat ON pat.PatientID = c.PatientID
			WHERE  ((Pat.Gender=CFS.Gender) OR CFS.Gender='B')
			AND ((ISNULL(c.ProcedureModifier1,'')=ISNULL(CFS.Modifier,'')) OR CFS.Modifier IS NULL)


		--CREATE TABLE #ClaimInsurance ( claimID INT, 
		--		PrimaryInsuranceCompanyPlanID INT, PrimaryInsuranceFirstBillDate DATETIME, PrimaryInsuranceLastBillDate DATETIME, 
		--		SecondaryInsuranceCompanyPlanID INT, SecondaryInsuranceFirstBillDate DATETIME, SecondaryInsuranceLastBillDate DATETIME,
		--		TertiaryInsuranceCompanyPlanID INT, 
		--		PatientFirstBillDate DATETIME, PatientLastBillDate DATETIME
		--		)
				
                
		select c.claimID, 
				PrimaryInsuranceCompanyPlanID = case when ip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence( c.patientCaseID, DateOfService, 0 ) THEN ip.InsuranceCompanyPlanID ELSE NULL END,
				getdate() PrimaryInsuranceFirstBillDate,
				GETDATE() PrimaryInsuranceLastBillDate,
				SecondaryInsuranceCompanyPlanID = case when Sip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence( c.patientCaseID, DateOfService, ip.Precedence ) THEN Sip.InsuranceCompanyPlanID ELSE NULL END,
				GETDATE() SecondaryInsuranceFirstBillDate,
				GETDATE() SecondaryInsuranceLastBillDate,
				TertiaryInsuranceCompanyPlanID = case when Tip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence( c.patientCaseID, DateOfService, Sip.Precedence ) THEN Tip.InsuranceCompanyPlanID ELSE NULL END,
				GETDATE() PatientFirstBillDate,
				GETDATE() PatientLastBillDate
		INTO #ClaimInsurance
		from #Claims c 
				inner join PatientCase pc on pc.PatientCaseID = c.patientCaseID
				inner join InsurancePolicy ip on ip.PatientCaseID = c.patientCaseID and ip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence( c.patientCaseID, DateOfService, 0 )
				LEFT join InsurancePolicy Sip on Sip.PatientCaseID = c.patientCaseID and Sip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence( c.patientCaseID, DateOfService, ip.Precedence )
				LEFT join InsurancePolicy Tip on Tip.PatientCaseID = c.patientCaseID and Tip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence( c.patientCaseID, DateOfService, Sip.Precedence )

			CREATE CLUSTERED INDEX tClaimInsurance_ClaimID ON #ClaimInsurance(claimID)	with ( statistics_norecompute = on )	


		------ Primary Insurance First bill
		update #ClaimInsurance
		SET #ClaimInsurance.PrimaryInsuranceFirstBillDate = cab.FirstBillDate, #ClaimInsurance.PrimaryInsuranceLastBillDate = cab.LastBillDate
		FROM (
				select ci.claimID, CONVERT(datetime, min( cab.PostingDate )) as FirstBillDate, CONVERT(datetime, max( cab.PostingDate )) as LastBillDate
				from    #ClaimInsurance ci
						inner join ClaimAccounting_Billings cab on ci.claimID = cab.ClaimID
						inner join ClaimAccounting_Assignments caa on ci.claimID = caa.ClaimID
								and ( 
												( cab.ClaimTransactionID between caa.ClaimTransactionID and caa.EndClaimTransactionID )
												OR (cab.ClaimTransactionID >= caa.ClaimTransactionID and caa.EndClaimTransactionID IS NULL)
										)
								and caa.InsuranceCompanyPlanID = ci.PrimaryInsuranceCompanyPlanID
--				where cab.practiceID = @practiceID
--					AND caa.practiceID = @practiceID
				group by ci.claimID
				) as cab
		WHERE  cab.claimID = #ClaimInsurance.claimID

		------ Secondary Insurance Billing Date
		update #ClaimInsurance
		SET SecondaryInsuranceFirstBillDate = cab.FirstBillDate,  SecondaryInsuranceLastBillDate = cab.LastBillDate
		FROM (
				select ci.claimID, min( cab.PostingDate ) as FirstBillDate, max( cab.PostingDate ) as LastBillDate
				from    #ClaimInsurance ci
						inner join ClaimAccounting_Billings cab on ci.claimID = cab.ClaimID
						inner join ClaimAccounting_Assignments caa on ci.claimID = caa.ClaimID
								and ( 
												( cab.ClaimTransactionID between caa.ClaimTransactionID and caa.EndClaimTransactionID )
												OR (cab.ClaimTransactionID >= caa.ClaimTransactionID and caa.EndClaimTransactionID IS NULL)
										)
								and caa.InsuranceCompanyPlanID = ci.SecondaryInsuranceCompanyPlanID
--				where cab.practiceID = @practiceID
--					AND caa.practiceID = @practiceID
				group by ci.claimID
				) as cab
		WHERE  cab.claimID = #ClaimInsurance.claimID

        
		------ Patient Billing Date
		update #ClaimInsurance
		SET PatientFirstBillDate = cab.FirstBillDate, PatientLastBillDate = cab.LastBillDate
		FROM (
				select ci.claimID, min( cab.PostingDate ) as FirstBillDate, max( cab.PostingDate ) as LastBillDate
				from    #ClaimInsurance ci
						inner join ClaimAccounting_Billings cab on ci.claimID = cab.ClaimID
						inner join ClaimAccounting_Assignments caa on ci.claimID = caa.ClaimID
								and ( 
												( cab.ClaimTransactionID between caa.ClaimTransactionID and caa.EndClaimTransactionID )
												OR (cab.ClaimTransactionID >= caa.ClaimTransactionID and caa.EndClaimTransactionID IS NULL)
										)
				WHERE caa.InsuranceCompanyPlanID IS NULL                                
--					AND cab.practiceID = @practiceID
--					AND caa.practiceID = @practiceID
				group by ci.claimID
				) as cab
		WHERE  cab.claimID = #ClaimInsurance.claimID
        

        
        -- Originally we did the following block commented join, which resulted in issues described in SF 151803 (missing primary insurance info).
		-- However, removing this join introduced the issue described in SF 244092 (secondary insurance info appearing in the primary insurance columns).
		-- The thought is that for SF 151803, the customer had changed the case assinged to the encounter, leading to a NULL match.
		-- However, without the filter SQL Server finds multiple payment matches and is free to return/set the PaymentID to any of the rows.
		-- A thought was that could rank the payments by their PaymentID, but in some cases a secondary payment may appear before the primary, such
		-- as when the claim has been crossed over or, more generically, the secondary payment is posted before the primary.
		-- All that said, we've decided to add the filter back in, since we're locking down cases after they've been approved.
		/* inner join InsuranceCompanyPlan icpIns on icpIns.InsuranceCompanyID = icpPayer.InsuranceCompanyID
		    AND icpINs.InsuranceCompanyPlanID = ci.PrimaryInsuranceCompanyPlanID
		 */
		 
		update c
		SET c.PrimaryInsPaymentID = priPay.paymentID
		FROM #Claims c
				inner join #ClaimInsurance ci on c.claimID = ci.ClaimID
				inner join PaymentClaim priPayC on priPayC.ClaimID = c.claimID
				inner JOIN Payment priPay on priPayC.PaymentID = priPay.PaymentID 
				inner join insuranceCompanyPlan icpPayer on icpPayer.InsuranceCompanyPlanID = priPay.PayerID and priPay.PayerTypeCode = 'I'
		WHERE icpPayer.InsuranceCompanyPlanID = ci.PrimaryInsuranceCompanyPlanID


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
                
                       
                
		update c
		SET c.SecondaryInsPaymentID = priPay.paymentID
		FROM #Claims c
				inner join #ClaimInsurance ci on c.claimID = ci.ClaimID
				inner join PaymentClaim priPayC on priPayC.ClaimID = c.claimID
				inner JOIN Payment priPay on priPayC.PaymentID = priPay.PaymentID 
				inner join insuranceCompanyPlan icpPayer on icpPayer.InsuranceCompanyPlanID = priPay.PayerID and priPay.PayerTypeCode = 'I'
				inner join InsuranceCompanyPlan icpIns on icpIns.InsuranceCompanyID = icpPayer.InsuranceCompanyID  
		WHERE
--			priPay.practiceID = @practiceID
--			and priPayC.practiceID = @practiceID AND
			icpINs.InsuranceCompanyPlanID = ci.SecondaryInsuranceCompanyPlanID


		---- the SUM Of various Patient Payments
		update c
		SET c.PatientPaymentID = p.paymentID, c.PatientPaymentAmount=p.Amount
		FROM #Claims c
				inner join (
						select claimID, paymentID = max(p.paymentID), Amount = sum(Amount)
						from ClaimAccounting ca
								inner join Payment p on p.PaymentID = ca.PaymentID and ca.PracticeID = p.PracticeID
						where 
--								ca.PracticeID = @practiceID and 
								ca.ClaimTransactionTypeCode = 'PAY'
								and p.PayerTypeCode = 'P'
						GROUP BY ca.ClaimID
								) as p on p.claimID = c.claimID 


		---- the SUM Of various Other Payments
		update c
		SET c.OtherPaymentID = p.paymentID, c.OtherPaymentAmount=p.Amount
		FROM #Claims c
				inner join (
						select claimID, paymentID = max(p.paymentID), Amount = sum(Amount)
						from ClaimAccounting ca
								inner join Payment p on p.PaymentID = ca.PaymentID and ca.PracticeID = p.PracticeID
						where
								ca.ClaimTransactionTypeCode = 'PAY'
								and p.PayerTypeCode = 'O'
						GROUP BY ca.ClaimID
								) as p on p.claimID = c.claimID


		---- the SUM Of various Insurance Payments that isn't either the primary or secondary
		update c
		SET c.OtherInsPaymentID = p.paymentID, c.OtherInsPaymentAmount=p.Amount
		FROM #Claims c
				inner join (
						select ca.claimID, paymentID = max(p.paymentID), Amount = sum(Amount)
						from ClaimAccounting ca
								inner join Payment p on p.PaymentID = ca.PaymentID --and ca.PracticeID = p.PracticeID
								inner join #Claims c on c.claimID = ca.ClaimID 
										and (p.PaymentID <> c.PrimaryInsPaymentID OR c.PrimaryInsPaymentID IS NULL) 
										AND (p.PaymentID <> c.SecondaryInsPaymentID OR c.SecondaryInsPaymentID IS NULL)
						where 
--								ca.PracticeID = @practiceID and 
								ca.ClaimTransactionTypeCode = 'PAY'
								and p.PayerTypeCode = 'I'
						GROUP BY ca.ClaimID
								) as p on p.claimID = c.claimID 
         


		--Parse XML eob for denial = true. Extract out type=Reason

		SELECT  rowID = identity(int, 1,1),
				pc.ClaimID,
				pc.PaymentID,
				eboXML.Type,
				eboXML.Amount,
				eboXML.Code,
				eboXML.Category,
				eboXML.Description
		INTO #ClaimPayment
		FROM paymentClaim pc 
				INNER JOIN EOBXml_API_Query eboXML on pc.PaymentClaimID = eboXML.PaymentClaimID
		--cross apply eobXML.nodes('/eob/items/item') AS eboXML(row)
				inner join #Claims c on c.claimID = pc.ClaimID 
				AND pc.PaymentID in ( c.PrimaryInsPaymentID, c.SecondaryInsPaymentID, c.OtherInsPaymentID )



		--SELECT  rowID = identity(int, 1,1),
		--		pc.ClaimID,
		--		pc.PaymentID,
		--		eboXML.row.value('@type','varchar(50)') Type,
		--		eboXML.row.value('@amount','Money') Amount,
		--		eboXML.row.value('@code','varchar(50)') Code,
		--		eboXML.row.value('@category','varchar(50)') Category,
		--		eboXML.row.value('@description','varchar(250)') Description
		--INTO #ClaimPayment
		--FROM paymentClaim pc cross apply eobXML.nodes('/eob/items/item') AS eboXML(row)
		--		inner join #Claims c on c.claimID = pc.ClaimID 
		--		AND pc.PaymentID in ( c.PrimaryInsPaymentID, c.SecondaryInsPaymentID, c.OtherInsPaymentID )
			--		where pc.practiceID = @practiceID
		-- order by pc.paymentID desc
 

		--CREATE TABLE #minContractAdjustment( claimID INT, paymentID INT, rowID INT );
		select claimID, paymentID, min(rowID) rowID
		into #minContractAdjustment
		from #ClaimPayment
		where TYPE = 'Reason' and Category = 'CO'
		group by claimID, paymentID
 

        --------- EOB Info
		select cp.claimID, cp.paymentID,
		InsuranceAllowed = max( case when Type = 'Allowed' THEN Amount ELSE '0' END ),
		InsuranceContractAdjustment = max( case when Type = 'Reason' and Category = 'CO' and minAdj.rowID = cp.rowID THEN Amount ELSE '0' END),
		InsuranceContractAdjustmentReason = max( case when Type = 'Reason' and Category = 'CO'  and minAdj.rowID = cp.rowID THEN isnull(a.Description, adR.Description) ELSE '' END),
        
		InsuranceSecondarytAdjustment = max( case when Type = 'Reason' and Category = 'CO' and minAdj.rowID < cp.rowID THEN Amount ELSE '0' END),
		InsuranceSecondaryAdjustmentReason = max( case when Type = 'Reason' and Category = 'CO'  and minAdj.rowID < cp.rowID THEN isnull(a.Description, adR.Description) ELSE '' END),
        
		InsurancePayment = max( case when Type = 'Paid' THEN Amount ELSE '0' END),
		InsuranceDeductible = max( case when Type = 'Reason' and cp.Description = '1'THEN Amount ELSE '0' END),
		InsuranceCoinsurance= max( case when Type = 'Reason' and cp.Description = '2' THEN Amount ELSE '0' END),
		InsuranceCopay= max( case when Type = 'Reason' and cp.Description = '3' THEN Amount ELSE '0' END)
		INTO #ClaimEOB
		from #ClaimPayment cp
				LEFT JOIN adjustmentReason adR on adR.adjustmentReasonCode = cp.Description
				left join Adjustment a on a.AdjustmentCode = cp.CODE
				LEFT JOIN #minContractAdjustment minAdj on minAdj.claimID = cp.ClaimID and minAdj.paymentID = cp.PaymentID
		group by cp.claimID, cp.paymentID
        
        CREATE CLUSTERED INDEX tClaimEOB_ClaimID ON #ClaimEOB (claimID)	with ( statistics_norecompute = on )	
        
		--CREATE TABLE #payments (paymentID INT, claimID INT, Amount MONEY)
  
		select paymentID, ca.ClaimID, sum(Amount) Amount
		into #payments
		from claimAccounting ca
				inner join #Claims c on c.claimID = ca.ClaimID and ca.PaymentID in (c.PrimaryInsPaymentID, c.SecondaryInsPaymentID)
		where ca.ClaimTransactionTypeCode = 'PAY'
--			and ca.practiceID = @practiceID
		group by PaymentID, ca.ClaimID
            
			   CREATE CLUSTERED INDEX tPayments_ClaimID ON #payments (claimID)	with ( statistics_norecompute = on )	
 
 

                
		--CREATE TABLE #Adjustment (ClaimID INT, Amount MONEY)	
		
		--INSERT  #Adjustment(ClaimID, Amount)
		select ca.ClaimID, sum(Amount) Amount
		INTO #Adjustment
		from claimAccounting ca
				inner join #Claims c on c.claimID = ca.ClaimID
		where ca.ClaimTransactionTypeCode = 'ADJ'
--				and ca.practiceID = @practiceID
		group by ca.ClaimID
           
		   CREATE CLUSTERED INDEX tAdjustment_ClaimID ON #Adjustment(ClaimID)
		
		--CREATE TABLE #AR (ClaimID INT, Amount MONEY)

		--INSERT INTO #AR(ClaimID, Amount)
		SELECT CA.ClaimID, SUM(CASE WHEN CA.ClaimTransactionTypeCode='CST' THEN Amount ELSE Amount*-1  END) Amount
		INTO #AR
		FROM ClaimAccounting CA
		INNER JOIN #Claims C on C.ClaimId = CA.ClaimId
		WHERE CA.ClaimTransactionTypeCode IN ('CST', 'ADJ', 'PAY')
		GROUP BY CA.ClaimID


		--CREATE TABLE #ASNMax (ClaimID INT, ClaimTransactionID INT)
		--INSERT INTO #ASNMax(ClaimID, ClaimTransactionID)
		SELECT CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
		INTO #ASNMax
		FROM ClaimAccounting_Assignments CAA
			INNER JOIN #AR ar ON ar.CLaimID = caa.CLaimID
		GROUP BY CAA.ClaimID


		--CREATE TABLE #ASN (ClaimID INT, PatientID INT, TypeGroup INT)
		--INSERT INTO #ASN(ClaimID, PatientID, TypeGroup)
		SELECT CAA.ClaimID, 
			CAA.PatientID,
				CASE WHEN caa.InsuranceCompanyPlanID IS NULL THEN 2 ELSE 1 END TypeGroup
		INTO #ASN
		FROM ClaimAccounting_Assignments CAA 
			INNER JOIN #ASNMax AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
			LEFT JOIN InsuranceCompanyPlan icp on icp.InsuranceCompanyPlanID = caa.InsuranceCompanyPlanID



		SELECT a.ClaimID, a.PatientID, ep.EncounterProcedureID,
			SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END) Charges,
			SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN Amount*-1 ELSE 0 END) Adjustments,
			SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='I' THEN Amount*-1 ELSE 0 END) InsPay,
			SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' THEN Amount*-1 ELSE 0 END) PatPay,
			SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='O' THEN Amount*-1 ELSE 0 END) OtherPaymentAmount,
			TotalBalance = SUM( CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE Amount*-1  END ),

			PendingIns = SUM(CASE 
								WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' -- Exclude patient payment against total
									THEN 0
								WHEN TypeGroup=1  -- Assinged to patient
									THEN CASE WHEN ClaimTransactionTypeCode='CST' THEN AMOUNT ELSE -1*AMOUNT END
								ELSE 0
							END),

			PendingPat = SUM(CASE 
								WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P'  -- Include patient payment against total
									THEN Amount*-1
								WHEN TypeGroup=2 -- Assinged to patient
									THEN  CASE WHEN ClaimTransactionTypeCode = 'CST' THEN Amount ELSE Amount*-1 END 
								ELSE 0 
							END),
			TotalAR = cast(0 as money),
			TypeGroup
		INTO #AR_ASN
		FROM #ASN A 
			INNER JOIN ClaimAccounting CAA ON A.PatientID=CAA.PatientID AND A.ClaimID=CAA.ClaimID
			INNER JOIN Claim c on c.PracticeID = caa.PracticeID AND caa.ClaimID = c.CLaimID
			INNER JOIN Encounterprocedure ep on ep.PracticeID = c.PracticeID AND c.EncounterProcedureID = ep.EncounterProcedureID
			INNER JOIN Encounter e On e.PracticeID = ep.PracticeID and e.EncounterID = ep.EncounterID
			INNER JOIN Doctor d on d.PracticeID = e.PracticeID AND d.doctorID = e.DoctorID
			INNER JOIN PatientCase pc on pc.PatientCaseID = e.PatientCaseID
			LEFT JOIN Payment P ON p.PracticeID = caa.PracticeID AND caa.PaymentID=P.PaymentID
		WHERE ClaimTransactionTypeCode IN ('CST', 'ADJ', 'PAY')
		GROUP BY a.ClaimID, TypeGroup, a.PatientID, ep.EncounterProcedureID
		

		CREATE CLUSTERED INDEX tAR_ASN_ClaimID ON #AR_ASN (ClaimID)	with ( statistics_norecompute = on )	

		update asn
		set
			PendingIns = PendingIns - ISNULL(ca.amount, 0),
			PendingPat =  PendingPat + ISNULL(ca.amount, 0) 
		from #AR_ASN asn 
			INNER JOIN (Select ClaimID, sum(amount) amount from ClaimAccounting  where ClaimTransactionTypeCode = 'PRC' GROUP BY ClaimID) as ca
				on ca.ClaimID = asn.ClaimID
		WHERE TypeGroup = '1' 

--	select '#AR_ASN' as [#AR_ASN], * from #AR_ASN


	select ca.claimID, STRING_AGG(p.paymentID, ', ')AS PatientPaymentIDsAll, STRING_AGG(ca.Amount, ', ')AS PatientPaymentAmountsAll, STRING_AGG(ca.PostingDate, ', ')AS PatientPaymentPostingDatesAll, 
						STRING_AGG(p.AdjudicationDate, ', ')AS AdjudicationDatesAll, STRING_AGG(p.PaymentNumber, ', ')AS InsPaymentRef
	into #PatientPaymentsAll
	from ClaimAccounting ca
			inner join Payment p on p.PaymentID = ca.PaymentID and ca.PracticeID = p.PracticeID
	where 
			ca.ClaimTransactionTypeCode = 'PAY'
			and p.PayerTypeCode = 'P'
	GROUP BY ca.ClaimID	



	select ca.claimID, STRING_AGG(p.paymentID, ', ')AS PatientPaymentIDsAll, STRING_AGG(ca.Amount, ', ')AS OtherPatientPaymentsAll, STRING_AGG(ca.PostingDate, ', ')AS OtherPatientPaymentPostingDatesAll
    into #OtherPatientPaymentsAll
	from ClaimAccounting ca
			inner join Payment p on p.PaymentID = ca.PaymentID --and ca.PracticeID = p.PracticeID
			inner join #Claims c on c.claimID = ca.ClaimID 
					and (p.PaymentID <> c.PrimaryInsPaymentID OR c.PrimaryInsPaymentID IS NULL) 
					and (p.PaymentID <> c.SecondaryInsPaymentID OR c.SecondaryInsPaymentID IS NULL)
	where 
			ca.ClaimTransactionTypeCode = 'PAY'
			and p.PayerTypeCode = 'I'
	GROUP BY ca.ClaimID


	select ca.claimID, STRING_AGG(p.paymentID, ', ')AS PatientPaymentIDsAll, STRING_AGG(ca.Amount, ', ')AS OtherPaymentsAll, STRING_AGG(ca.PostingDate, ', ')AS OtherPaymentPostingDatesAll
	into #OtherPaymentsAll
	FROM ClaimAccounting ca
			inner join Payment p on p.PaymentID = ca.PaymentID and ca.PracticeID = p.PracticeID
	where
			ca.ClaimTransactionTypeCode = 'PAY'
			and p.PayerTypeCode = 'O'
	GROUP BY ca.ClaimID

	select ci.claimID, STRING_AGG(cab.PostingDate, ', ')AS PostingDate
	INTO #PrimaryInsDates
	FROM    #ClaimInsurance ci
			inner join ClaimAccounting_Billings cab on ci.claimID = cab.ClaimID
			inner join ClaimAccounting_Assignments caa on ci.claimID = caa.ClaimID
					and ( 
									( cab.ClaimTransactionID between caa.ClaimTransactionID and caa.EndClaimTransactionID )
									OR (cab.ClaimTransactionID >= caa.ClaimTransactionID and caa.EndClaimTransactionID IS NULL)
							)
					and caa.InsuranceCompanyPlanID = ci.PrimaryInsuranceCompanyPlanID
	group by ci.claimID


	select ci.claimID, STRING_AGG(cab.PostingDate, ', ')AS PostingDate
	INTO #SecondaryInsDates
	from    #ClaimInsurance ci
			inner join ClaimAccounting_Billings cab on ci.claimID = cab.ClaimID
			inner join ClaimAccounting_Assignments caa on ci.claimID = caa.ClaimID
					and ( 
									( cab.ClaimTransactionID between caa.ClaimTransactionID and caa.EndClaimTransactionID )
									OR (cab.ClaimTransactionID >= caa.ClaimTransactionID and caa.EndClaimTransactionID IS NULL)
							)
					and caa.InsuranceCompanyPlanID = ci.SecondaryInsuranceCompanyPlanID
--				where cab.practiceID = @practiceID
--					AND caa.practiceID = @practiceID
	group by ci.claimID



	select ca.ClaimID, STRING_AGG(ca.PaymentID, ', ')AS PrimaryPaymentIDsAll, STRING_AGG(ca.Amount, ', ')AS PrimaryAmountsAll
	into #PrimarypaymentsAll
	from claimAccounting ca
			inner join #Claims c on c.claimID = ca.ClaimID and ca.PaymentID = c.PrimaryInsPaymentID
	where ca.ClaimTransactionTypeCode = 'PAY'
	group by ca.ClaimID


	select ca.ClaimID, STRING_AGG(ca.PaymentID, ', ')AS SecondaryPaymentIDsAll, STRING_AGG(ca.Amount, ', ')AS SecondaryAmountsAll
	into #SecondarypaymentsAll
	from claimAccounting ca
			inner join #Claims c on c.claimID = ca.ClaimID and ca.PaymentID = c.SecondaryInsPaymentID
	where ca.ClaimTransactionTypeCode = 'PAY'
	group by ca.ClaimID

	-- todo: still need to handle refunds, unapplied amts, etc. - lots and lots of stuff from WebServiceDataProvider_PatientBalanceSummary

	SELECT 
					c.claimID AS [ID], 
					CONVERT(VARCHAR, c.CreatedDate, 101) AS [CreatedDate],
					--convert(Varchar, c.ModifiedDate, 101) as [LastModifiedDate],
					
					CONVERT(VARCHAR, 
						(SELECT MAX(moddate.ModifiedDate) FROM (SELECT TOP 1 ModifiedDate FROM Claim c1 WHERE c1.ClaimID = c.ClaimID
						 UNION
						 SELECT TOP 1 ModifiedDate FROM dbo.EncounterProcedure ep1 WHERE ep1.EncounterProcedureID = ep.EncounterProcedureID
						 UNION
						 SELECT TOP 1 ModifiedDate FROM dbo.Encounter e1 WHERE e1.EncounterID = e.EncounterID) AS moddate),
						101) AS [LastModifiedDate],
						
					prac.Name AS [PracticeName],
					e.EncounterID AS [EncounterID], 
					ep.EncounterProcedureID AS [EncounterProcedureID],
					e.PatientID AS [PatientID],
					dbo.fn_FormatFirstMiddleLast( p.FirstName, p.MiddleName, p.LastName) AS PatientName,
                    p.FirstName AS PatientFirstName,
					p.MiddleName AS PatientMiddleName,
					p.LastName AS PatientLastName,
					CONVERT(VARCHAR, p.DOB, 101) AS [PatientDateOfBirth],
					pc.Name AS [CaseName], 
					paySc.Name AS [CasePayerScenario],
					CONVERT(VARCHAR, c.ClaimServiceDateFrom, 101) AS ServiceStartDate,
					CONVERT(VARCHAR, c.ClaimServiceDateTo, 101) AS ServiceEndDate,
					CONVERT(VARCHAR, c.PostingDate, 101) AS PostingDate,
					e.BatchId AS [BatchNumber],
					REPLACE(ISNULL(sp.Prefix + ' ', '')  + ISNULL(sp.FirstName, '') + ISNULL(' '+sp.MiddleName, '') + ISNULL(' ' + sp.LastName, '') + ISNULL(', ' + sp.Degree, ''), '  ',' ') AS [SchedulingProviderName],
					REPLACE(ISNULL(d.Prefix + ' ', '')  + ISNULL(d.FirstName, '') + ISNULL(' '+d.MiddleName, '') + ISNULL(' ' + d.LastName, '') + ISNULL(', ' + d.Degree, ''), '  ',' ') AS [RenderingProviderName],
					REPLACE(ISNULL(supD.Prefix + ' ', '')  + ISNULL(supD.FirstName, '') + ISNULL(' '+supD.MiddleName, '') + ISNULL(' ' + supD.LastName, '') + ISNULL(', ' + supD.Degree, ''), '  ',' ') AS [SupervisingProviderName],
					REPLACE(ISNULL(refD.Prefix + ' ', '')  + ISNULL(refD.FirstName, '') + ISNULL(' '+refD.MiddleName, '') + ISNULL(' ' + refD.LastName, '') + ISNULL(', ' + refD.Degree, ''), '  ',' ') AS [ReferringProviderName],
					sl.Name AS ServiceLocationName,
					pcd.ProcedureCode,
					ISNULL(pcd.LocalName, pcd.OfficialName) AS ProcedureName,
					pcc.ProcedureCodeCategoryName AS ProcedureCodeCategory,
					ep.ProcedureModifier1,
					ep.ProcedureModifier2,
					ep.ProcedureModifier3,
					ep.ProcedureModifier4,
					CASE WHEN dcd5.DiagnosisCode IS NULL THEN dcd1.DiagnosisCode ELSE dcd5.DiagnosisCode END AS EncounterDiagnosisID1,
					CASE WHEN dcd6.DiagnosisCode IS NULL THEN dcd2.DiagnosisCode ELSE dcd6.DiagnosisCode END AS EncounterDiagnosisID2,
					CASE WHEN dcd7.DiagnosisCode IS NULL THEN dcd3.DiagnosisCode ELSE dcd7.DiagnosisCode END AS EncounterDiagnosisID3,
					CASE WHEN dcd8.DiagnosisCode IS NULL THEN dcd4.DiagnosisCode ELSE dcd8.DiagnosisCode END AS EncounterDiagnosisID4,
					ep.ServiceUnitCount AS [Units],
					ep.ServiceChargeAmount AS [UnitCharge],
					CAST( dbo.fn_RoundUpToPenny( ISNULL(ep.ServiceUnitCount, 0) * ISNULL(ep.ServiceChargeAmount, 0)) AS MONEY) AS [TotalCharges],
					(CA.Charges-ISNULL(adj.Amount, 0)) AS AdjustedCharges,	
					ISNULL(CA.InsPay,0.0) + ISNULL(CA.PatPay,0.0) + ISNULL(CA.OtherPaymentAmount,0.0) AS Receipts,			
					CA.PendingPat AS PatientBalance,	
					CA.PendingIns AS InsuranceBalance,				
					CA.TotalBalance AS TotalBalance,			
					ic1.InsuranceCompanyName AS [PrimaryInsuranceCompanyName],
					icp1.PlanName AS [PrimaryInsurancePlanName],
					ic2.InsuranceCompanyName AS SecondaryInsuranceCompanyName,
					icp2.PlanName AS SecondaryInsurancePlanName,
					c.AssignedToDisplayName AS BilledTo,
                    			es.EncounterStatusDescription AS EncounterStatus,
					c.Status,
					c.practiceID AS [PracticeID], 
					CASE
						WHEN (A.AppointmentID IS NOT NULL) AND (AR.AppointmentID IS NOT NULL) 
							THEN dbo.AppointmentDataProvider_GetTicketNumber(A.AppointmentID, E.AppointmentStartDate, 1)
						WHEN (A.AppointmentID IS NOT NULL) AND (AR.AppointmentID IS NULL) 
							THEN dbo.AppointmentDataProvider_GetTicketNumber(A.AppointmentID, E.AppointmentStartDate, 0)
						ELSE CAST('' AS VARCHAR(100))
					END AS [AppointmentID],
					sp.DoctorId AS [SchedulingProviderID],
					d.DoctorId AS [RenderingProviderID],
					supD.DoctorId AS [SupervisingProviderID],
					refD.DoctorId AS [ReferringProviderID],
					e.AmountPaid AS CopayAmount,
					epmc.Description AS CopayMethod,
					EpayC.Name AS CopayCategory,
					e.Reference AS CopayReference,
					ep.AnesthesiaTime AS [Minutes],
					ep.EDIServiceNote AS [LineNote],
					epedinrc.Definition AS [RefCode],
					tos.Description AS [TypeOfService],
					CONVERT(VARCHAR, e.HospitalizationStartDT, 101) AS [HospitalizationStartDate],
					CONVERT(VARCHAR, e.HospitalizationEndDT, 101) AS [HospitalizationEndDate],
					e.Box10d AS [LocalUseBox10d],
					e.Box19 AS [LocalUseBox19],
					e.DoNotSendElectronic AS [DoNotSendClaimElectronically],
					e.DoNotSendElectronicSecondary AS [DoNotSendElectronicallyToSecondary],
					edinrc.Definition AS [EClaimNoteType],
					CASE
						WHEN (e.ClaimTypeID IS NOT NULL AND e.ClaimTypeID IN (0, 2)) 
							THEN e.EDIClaimNoteCMS1500
						WHEN (e.ClaimTypeID IS NOT NULL AND e.ClaimTypeID = 1) 
							THEN e.EDIClaimNoteUB04
						ELSE NULL
					END AS [EClaimNote],
					sl.ServiceLocationID AS ServiceLocationId,
					sl.BillingName AS ServiceLocationBillingName,
					sl.PlaceOfServiceCode AS ServiceLocationPlaceOfServiceCode,
					pos.Description AS ServiceLocationPlaceOfServiceName,
					sl.AddressLine1 AS ServiceLocationNameAddressLine1, 
					sl.AddressLine2 AS ServiceLocationNameAddressLine2, 
					sl.City AS ServiceLocationNameCity, 
					sl.State AS ServiceLocationNameState, 
					sl.Country AS ServiceLocationNameCountry, 
					sl.ZipCode AS ServiceLocationNameZipCode, 
					dbo.fn_FormatPhone(sl.Phone) AS ServiceLocationPhone, 
					sl.PhoneExt AS ServiceLocationPhoneExt, 
					dbo.fn_FormatPhone(sl.FaxPhone) AS ServiceLocationFax, 
					sl.FaxPhoneExt AS ServiceLocationFaxExt, 
					sl.NPI AS ServiceLocationNPI, 
					sl.HCFABox32FacilityID AS ServiceLocationFacilityID,
					RTRIM(LTRIM(gnt.ANSIReferenceIdentificationQualifier + ' ' + gnt.TypeName)) AS ServiceLocationFacilityIdType,
					sl.CLIANumber AS ServiceLocationCLIANumber, 
					c.AllowedAmount,
					c.ExpectedAmount,


					----- primary ins payment
					icp1.[AddressLine1] AS PrimaryInsuranceAddressLine1,
					icp1.[AddressLine2] AS PrimaryInsuranceAddressLine2,
					icp1.[City] AS PrimaryInsuranceCity,
					icp1.[State] AS PrimaryInsuranceState,
					icp1.[Country] AS PrimaryInsuranceCountry,
					icp1.[ZipCode] AS PrimaryInsuranceZipCode,
					p1.BatchID AS [PrimaryInsuranceBatchID],
					CONVERT(VARCHAR, ci.PrimaryInsuranceFirstBillDate, 101) AS PrimaryInsuranceFirstBillDate,
					CONVERT(VARCHAR, ci.PrimaryInsuranceLastBillDate, 101) AS PrimaryInsuranceLastBillDate,
					#PrimaryInsDates.PostingDate AS PrimaryPostingDates,
					p1.PaymentID AS PrimaryInsurancePaymentID,
					#PrimarypaymentsAll.PrimaryPaymentIDsAll AS PrimaryPaymentIDsAll,
					CONVERT(VARCHAR, p1.PostingDate, 101) AS PrimaryInsurancePaymentPostingDate,
					CONVERT(VARCHAR, p1.AdjudicationDate, 101) AS PrimaryInsuranceAdjudicationDate,
					--#PrimarypaymentsAll.AdjudicationDatesAll AS AdjudicationDatesAll,
					p1.PaymentNumber AS PrimaryInsurancePaymentRef,
					#PrimarypaymentsAll.PrimaryAmountsAll AS PrimaryAmountsAll,
					pmc1.Description AS PrimaryInsurancePaymentMethodDesc,
					cat1.Name AS PrimaryInsurancePaymentCategoryDesc,
					eob1.InsuranceAllowed AS PrimaryInsuranceInsuranceAllowed,
					eob1.InsuranceContractAdjustment AS PrimaryInsuranceInsuranceContractAdjustment,
					eob1.InsuranceContractAdjustmentReason AS PrimaryInsuranceInsuranceContractAdjustmentReason,
					eob1.InsuranceSecondarytAdjustment AS PrimaryInsuranceInsuranceSecondaryAdjustment,
					eob1.InsuranceSecondaryAdjustmentReason AS PrimaryInsuranceInsuranceSecondaryAdjustmentReason,
					cp1.Amount  AS PrimaryInsuranceInsurancePayment,
					eob1.InsuranceDeductible AS PrimaryInsuranceInsuranceDeductible,
					eob1.InsuranceCoinsurance AS PrimaryInsuranceInsuranceCoinsurance, 
					eob1.InsuranceCopay AS PrimaryInsuranceInsuranceCopay,
	        
	                
					----- secondary ins payment
					icp2.[AddressLine1] AS SecondaryInsuranceAddressLine1,
					icp2.[AddressLine2] AS SecondaryInsuranceAddressLine2,
					icp2.[City] AS SecondaryInsuranceCity,
					icp2.[State] AS SecondaryInsuranceState,
					icp2.[Country] AS SecondaryInsuranceCountry,
					icp2.[ZipCode] AS SecondaryInsuranceZipCode,
					p2.BatchID AS SecondaryInsuranceBatchID,
					CONVERT(VARCHAR, ci.SecondaryInsuranceFirstBillDate, 101) AS SecondaryInsuranceFirstBillDate,
					CONVERT(VARCHAR, ci.SecondaryInsuranceLastBillDate, 101) AS SecondaryInsuranceLastBillDate,
					#SecondaryInsDates.PostingDate AS SecondaryPostingDates,
					p2.PaymentID AS SecondaryInsurancePaymentID,
					#SecondarypaymentsAll.SecondaryPaymentIDsAll AS PrimaryPaymentIDsAll,
					CONVERT(VARCHAR, p2.PostingDate, 101) AS SecondaryInsurancePaymentPostingDate,
					CONVERT(VARCHAR, p2.AdjudicationDate, 101) AS SecondaryInsuranceAdjudicationDate,
					--#SecondarypaymentsAll.AdjudicationDatesAll AS SecondaryAdjudicationDatesAll,
					p2.PaymentNumber AS SecondaryInsurancePaymentRef,
					#SecondarypaymentsAll.SecondaryAmountsAll AS SecondaryAmountsAll,
					pmc2.Description AS SecondaryInsurancePaymentMethodDesc,
					cat2.Name AS SecondaryInsurancePaymentCategoryDesc,
					eob2.InsuranceAllowed AS SecondaryInsuranceInsuranceAllowed,
					eob2.InsuranceContractAdjustment AS SecondaryInsuranceInsuranceContractAdjustment,
					eob2.InsuranceContractAdjustmentReason AS SecondaryInsuranceInsuranceContractAdjustmentReason,
					eob2.InsuranceSecondarytAdjustment AS SecondaryInsuranceInsuranceSecondaryAdjustment,
					eob2.InsuranceSecondaryAdjustmentReason AS SecondaryInsuranceInsuranceSecondaryAdjustmentReason,
					cp2.Amount  AS SecondaryInsuranceInsurancePayment,
					--#SecondarypaymentsAll.SecondaryAmountsAll AS SecondaryAmountsAll,
					eob2.InsuranceDeductible AS SecondaryInsuranceInsuranceDeductible,
					eob2.InsuranceCoinsurance AS SecondaryInsuranceInsuranceCoinsurance, 
					eob2.InsuranceCopay AS SecondaryInsuranceInsuranceCopay,
	                
					----- OTHER ins payment
					ic4.InsuranceCompanyName AS TertiaryInsuranceCompanyName,
					icp4.PlanName AS TertiaryInsuranceCompanyPlanName,
					icp4.[AddressLine1] AS TertiaryInsuranceAddressLine1,
					icp4.[AddressLine2] AS TertiaryInsuranceAddressLine2,
					icp4.[City] AS TertiaryInsuranceCity,
					icp4.[State] AS TertiaryInsuranceState,
					icp4.[Country] AS TertiaryInsuranceCountry,
					icp4.[ZipCode] AS TertiaryInsuranceZipCode,
					p4.BatchID AS TertiaryInsuranceBatchID,
					p4.PaymentID AS TertiaryInsurancePaymentID,
					CONVERT(VARCHAR, p4.PostingDate, 101) AS TertiaryInsurancePaymentPostingDate,
					CONVERT(VARCHAR, p4.AdjudicationDate, 101) AS TertiaryInsuranceAdjudicationDate,
					p4.PaymentNumber AS TertiaryInsurancePaymentRef,
					pmc4.Description AS TertiaryInsurancePaymentMethodDesc,
					cat4.Name AS TertiaryInsurancePaymentCategoryDesc,
					eob4.InsuranceAllowed AS TertiaryInsuranceInsuranceAllowed,
					eob4.InsuranceContractAdjustment AS TertiaryInsuranceInsuranceContractAdjustment,
					eob4.InsuranceContractAdjustmentReason AS TertiaryInsuranceInsuranceContractAdjustmentReason,
					eob4.InsuranceSecondarytAdjustment AS TertiaryInsuranceInsuranceSecondaryAdjustment,
					eob4.InsuranceSecondaryAdjustmentReason AS TertiaryInsuranceInsuranceSecondaryAdjustmentReason,
					c.OtherInsPaymentAmount  AS TertiaryInsuranceInsurancePayment,
					eob4.InsuranceDeductible AS TertiaryInsuranceInsuranceDeductible,
					eob4.InsuranceCoinsurance AS TertiaryInsuranceInsuranceCoinsurance, 
					eob4.InsuranceCopay AS TertiaryInsuranceInsuranceCopay,
	                                
	                
					------ PatientPayment
					p3.BatchID AS PatientBatchID,
					CONVERT(VARCHAR, ci.PatientFirstBillDate, 101) PatientFirstBillDate,
					CONVERT(VARCHAR, ci.PatientLastBillDate, 101) AS PatientLastBillDate,
					p3.PaymentNumber AS PatientPaymentRef,
					p3.PaymentID AS PatientPaymentID,
					#PatientPaymentsAll.PatientPaymentIDsAll AS PatientPaymentIDsAll,
					CONVERT(VARCHAR, p3.PostingDate, 101) AS PatientPaymentPostingDate,
					#PatientPaymentsAll.PatientPaymentPostingDatesAll AS PatientPaymentPostingDatesAll,
					pmc3.Description AS PatientPaymentMethodDesc,
					cat3.Name AS PatientPaymentCategoryDesc,
					c.PatientPaymentAmount AS PatientPaymentAmount,
					#PatientPaymentsAll.PatientPaymentAmountsAll AS PatientPaymentAmountsAll,
					#OtherPatientPaymentsAll.OtherPatientPaymentsAll AS OtherPatientPaymentsAll,
					ISNULL(adj.Amount, 0) -  ISNULL(eob1.InsuranceContractAdjustment, 0) - ISNULL(eob1.InsuranceSecondarytAdjustment, 0) 
					- ISNULL(eob2.InsuranceContractAdjustment, 0) - ISNULL(eob2.InsuranceSecondarytAdjustment, 0) - ISNULL(eob4.InsuranceContractAdjustment, 0) 
					- ISNULL(eob4.InsuranceSecondarytAdjustment, 0) AS OtherAdjustment,
                             
					------ Other payments
					otherpay.PaymentID AS OtherPaymentID,
					#OtherPaymentsAll.PatientPaymentIDsAll AS OtherPaymentsIDsAll,
					otherpay.PaymentNumber AS OtherPaymentRef,                             
					c.OtherPaymentAmount AS OtherPaymentAmount,
					#OtherPaymentsAll.OtherPaymentsAll AS OtherPaymentsAll,
					CONVERT(VARCHAR, otherpay.PostingDate, 101) AS OtherPaymentPostingDate,
					#OtherPaymentsAll.OtherPaymentPostingDatesAll AS OtherPaymentPostingDatesAll,
					pmc5.Description AS OtherPaymentMethodDesc,
					cat5.Name AS OtherPaymentCategoryDesc
			FROM #Claims c
					INNER JOIN Encounter e ON e.EncounterID = c.EncounterID 
					INNER JOIN EncounterStatus es ON es.EncounterStatusID = e.EncounterStatusID
					INNER JOIN Patient p ON p.PatientID = c.PatientID AND p.PracticeID = e.PracticeID
					INNER JOIN PatientCase pc ON pc.PatientCaseID = e.PatientCaseID AND pc.PracticeID = e.PracticeID
					INNER JOIN PayerScenario paySc ON paySc.PayerScenarioID = pc.PayerScenarioID
					INNER JOIN Doctor d ON d.DoctorID = e.DoctorID AND d.PracticeID = e.PracticeID
					INNER JOIN ProcedureCodeDictionary pcd ON pcd.ProcedureCodeDictionaryID = c.ProcedureCodeDictionaryID
					LEFT JOIN ProcedureCodeCategory pcc (NOLOCK) ON pcc.ProcedureCodeCategoryID = pcd.ProcedureCodeCategoryID
					INNER JOIN EncounterProcedure ep ON ep.PracticeID = e.PracticeID AND ep.EncounterProcedureID = c.encounterProcedureID AND ep.EncounterID = c.EncounterID
					LEFT JOIN #ClaimInsurance ci ON ci.claimID = c.claimID
					LEFT JOIN Doctor sp ON sp.DoctorID = e.SchedulingProviderID
					LEFT JOIN Doctor supD ON supD.DoctorID = e.SupervisingProviderID
					LEFT JOIN Doctor refD ON refD.DoctorID = e.ReferringPhysicianID
					LEFT JOIN ServiceLocation sl ON sl.ServiceLocationID = e.LocationID
					LEFT JOIN PlaceOfService pos ON pos.PlaceOfServiceCode = e.PlaceOfServiceCode
					LEFT JOIN GroupNumberType gnt ON gnt.GroupNumberTypeID = sl.FacilityIDType
					LEFT JOIN PaymentMethodCode Epmc ON Epmc.PaymentMethodCode = e.PaymentMethod
					LEFT JOIN Category EpayC ON EpayC.CategoryID = e.PaymentCategoryID
					LEFT JOIN EDINoteReferenceCode edinrc ON  edinrc.Code = CASE WHEN (e.ClaimTypeID IS NOT NULL AND e.ClaimTypeID IN (0, 2)) 
							THEN e.EDIClaimNoteReferenceCodeCMS1500
						    WHEN (e.ClaimTypeID IS NOT NULL AND e.ClaimTypeID = 1) 
							THEN e.EDIClaimNoteReferenceCodeUB04
						    ELSE e.EDIClaimNoteReferenceCode 
						END
					LEFT JOIN EDINoteReferenceCode epedinrc ON  epedinrc.Code = ep.EDIServiceNoteReferenceCode
					LEFT JOIN TypeOfService tos ON tos.TypeOfServiceCode = ep.TypeOfServiceCode
					LEFT JOIN Appointment A ON A.AppointmentID = E.AppointmentID	
					LEFT JOIN AppointmentRecurrence AR ON AR.AppointmentID = E.AppointmentID
	                
					----- primary ins payment
					LEFT JOIN Payment p1 ON p1.PaymentID = c.PrimaryInsPaymentID
					LEFT JOIN #payments cp1 ON cp1.claimID = c.claimID AND cp1.paymentID = p1.PaymentID
					LEFT JOIN PaymentMethodCode pmc1 ON pmc1.PaymentMethodCode = p1.PaymentMethodCode
					LEFT JOIN Category cat1 ON cat1.CategoryID = p1.PaymentCategoryID
					LEFT JOIN InsuranceCompanyPlan icp1 ON icp1.InsuranceCompanyPlanID = ISNULL(p1.PayerID,ci.PrimaryInsuranceCompanyPlanID)
					LEFT JOIN InsuranceCompany ic1 ON icp1.InsuranceCompanyID = ic1.InsuranceCompanyID
					LEFT JOIN #ClaimEOB eob1 ON eob1.ClaimID = c.claimID AND eob1.PaymentID = p1.PaymentID
					LEFT JOIN #PrimaryInsDates ON #PrimaryInsDates.claimID = c.claimID
					LEFT JOIN #PrimarypaymentsAll ON #PrimarypaymentsAll.ClaimID = c.claimID
					LEFT JOIN #SecondarypaymentsAll ON #SecondarypaymentsAll.ClaimID = c.claimID
	                
					----- secondary ins payment
					LEFT JOIN Payment p2 ON p2.PaymentID = c.SecondaryInsPaymentID
					LEFT JOIN #payments cp2 ON cp2.claimID = c.claimID AND cp2.paymentID = p2.PaymentID
					LEFT JOIN PaymentMethodCode pmc2 ON pmc2.PaymentMethodCode = p2.PaymentMethodCode
					LEFT JOIN Category cat2 ON cat2.CategoryID = p2.PaymentCategoryID
					LEFT JOIN InsuranceCompanyPlan icp2 ON icp2.InsuranceCompanyPlanID = ISNULL(p2.PayerID,ci.SecondaryInsuranceCompanyPlanID)
					LEFT JOIN InsuranceCompany ic2 ON icp2.InsuranceCompanyID = ic2.InsuranceCompanyID
					LEFT JOIN #ClaimEOB eob2 ON eob2.ClaimID = c.claimID AND eob2.PaymentID = p2.PaymentID
					LEFT JOIN #SecondaryInsDates ON #SecondaryInsDates.claimID = c.claimID
	        
					----- Patient Payment        
					LEFT JOIN Payment p3 ON p3.PaymentID = c.PatientPaymentID
					LEFT JOIN #payments cp3 ON cp3.claimID = c.claimID AND cp3.paymentID = p3.PaymentID
					LEFT JOIN PaymentMethodCode pmc3 ON pmc3.PaymentMethodCode = p3.PaymentMethodCode
					LEFT JOIN Category cat3 ON cat3.CategoryID = p3.PaymentCategoryID
					LEFT JOIN #PatientPaymentsAll ON #PatientPaymentsAll.ClaimID = c.claimID
					
					----- OTHER ins payment
					LEFT JOIN Payment p4 ON p4.PaymentID = c.OtherInsPaymentID
					LEFT JOIN PaymentMethodCode pmc4 ON pmc4.PaymentMethodCode = p4.PaymentMethodCode
					LEFT JOIN Category cat4 ON cat4.CategoryID = p4.PaymentCategoryID
					LEFT JOIN InsuranceCompanyPlan icp4 ON icp4.InsuranceCompanyPlanID = ISNULL(p4.PayerID,ci.TertiaryInsuranceCompanyPlanID)
					LEFT JOIN InsuranceCompany ic4 ON icp4.InsuranceCompanyID = ic4.InsuranceCompanyID
					LEFT JOIN #ClaimEOB eob4 ON eob4.ClaimID = c.claimID AND eob4.PaymentID = p4.PaymentID
					LEFT JOIN #OtherPatientPaymentsAll ON #OtherPatientPaymentsAll.claimid = c.claimID
					LEFT JOIN #OtherPaymentsAll ON #OtherPaymentsAll.claimid = c.claimID
					
					----- OTHER payments
					LEFT JOIN Payment otherpay ON otherpay.PaymentID = c.OtherPaymentID
					LEFT JOIN Category cat5 ON cat5.CategoryID = otherpay.PaymentCategoryID
					LEFT JOIN PaymentMethodCode pmc5 ON otherpay.PaymentMethodCode = pmc5.PaymentMethodCode   	                
	                
					LEFT JOIN EncounterDiagnosis ed1 ON ed1.PracticeID = ep.PracticeID AND ed1.EncounterID = ep.EncounterID AND ed1.EncounterDiagnosisID = ep.EncounterDiagnosisID1 
					LEFT JOIN DiagnosisCodeDictionary dcd1 ON dcd1.DiagnosisCodeDictionaryID= ed1.DiagnosisCodeDictionaryID
	                
					LEFT JOIN EncounterDiagnosis ed2 ON ed2.PracticeID = ep.PracticeID AND ed2.EncounterID = ep.EncounterID AND ed2.EncounterDiagnosisID = ep.EncounterDiagnosisID2
					LEFT JOIN DiagnosisCodeDictionary dcd2 ON dcd2.DiagnosisCodeDictionaryID= ed2.DiagnosisCodeDictionaryID
	                
					LEFT JOIN EncounterDiagnosis ed3 ON ed3.PracticeID = ep.PracticeID AND ed3.EncounterID = ep.EncounterID AND ed3.EncounterDiagnosisID = ep.EncounterDiagnosisID3 
					LEFT JOIN DiagnosisCodeDictionary dcd3 ON dcd3.DiagnosisCodeDictionaryID= ed3.DiagnosisCodeDictionaryID
	                
					LEFT JOIN EncounterDiagnosis ed4 ON ed4.PracticeID = ep.PracticeID AND ed4.EncounterID = ep.EncounterID AND ed4.EncounterDiagnosisID = ep.EncounterDiagnosisID4 
					LEFT JOIN DiagnosisCodeDictionary dcd4 ON dcd4.DiagnosisCodeDictionaryID= ed4.DiagnosisCodeDictionaryID

                    LEFT JOIN EncounterDiagnosis ed5 ON ed5.PracticeID = ep.PracticeID AND ed5.EncounterID = ep.EncounterID AND ed5.EncounterDiagnosisID = ep.EncounterDiagnosisID5
					LEFT JOIN ICD10DiagnosisCodeDictionary dcd5 ON dcd5.ICD10DiagnosisCodeDictionaryId = ed5.DiagnosisCodeDictionaryID

					LEFT JOIN EncounterDiagnosis ed6 ON ed6.PracticeID = ep.PracticeID AND ed6.EncounterID = ep.EncounterID AND ed6.EncounterDiagnosisID = ep.EncounterDiagnosisID6
					LEFT JOIN ICD10DiagnosisCodeDictionary dcd6 ON dcd6.ICD10DiagnosisCodeDictionaryId = ed6.DiagnosisCodeDictionaryID

					LEFT JOIN EncounterDiagnosis ed7 ON ed7.PracticeID = ep.PracticeID AND ed7.EncounterID = ep.EncounterID AND ed7.EncounterDiagnosisID = ep.EncounterDiagnosisID7
					LEFT JOIN ICD10DiagnosisCodeDictionary dcd7 ON dcd7.ICD10DiagnosisCodeDictionaryId = ed7.DiagnosisCodeDictionaryID

					LEFT JOIN EncounterDiagnosis ed8 ON ed8.PracticeID = ep.PracticeID AND ed8.EncounterID = ep.EncounterID AND ed8.EncounterDiagnosisID = ep.EncounterDiagnosisID8
					LEFT JOIN ICD10DiagnosisCodeDictionary dcd8 ON dcd8.ICD10DiagnosisCodeDictionaryId = ed8.DiagnosisCodeDictionaryID

					LEFT JOIN #Adjustment adj ON adj.claimID = c.claimID    
        			LEFT JOIN #AR_ASN CA ON c.ClaimID=CA.ClaimID
					INNER JOIN Practice prac ON prac.PracticeId = c.PracticeId
    
			WHERE 
--				e.PracticeID = @PracticeID AND
				(@FromCreatedDate IS NULL OR e.CreatedDate >= @FromCreatedDate)
				AND (@ToCreatedDate IS NULL OR e.CreatedDate <= @ToCreatedDate)
				AND (@FromLastModifiedDate IS NULL OR (SELECT MAX(moddate.ModifiedDate) FROM (SELECT TOP 1 ModifiedDate FROM Claim c1 WHERE c1.ClaimID = c.ClaimID
						 UNION
						 SELECT TOP 1 ModifiedDate FROM dbo.EncounterProcedure ep1 WHERE ep1.EncounterProcedureID = ep.EncounterProcedureID
						 UNION
						 SELECT TOP 1 ModifiedDate FROM dbo.Encounter e1 WHERE e1.EncounterID = e.EncounterID) AS moddate) >= @FromLastModifiedDate)
				AND (@ToLastModifiedDate IS NULL OR (SELECT MAX(moddate.ModifiedDate) FROM (SELECT TOP 1 ModifiedDate FROM Claim c1 WHERE c1.ClaimID = c.ClaimID
						 UNION
						 SELECT TOP 1 ModifiedDate FROM dbo.EncounterProcedure ep1 WHERE ep1.EncounterProcedureID = ep.EncounterProcedureID
						 UNION
						 SELECT TOP 1 ModifiedDate FROM dbo.Encounter e1 WHERE e1.EncounterID = e.EncounterID) AS moddate) <= @ToLastModifiedDate)
				AND (@FromPostingDate IS NULL OR C.PostingDate >= @FromPostingDate)
				AND (@ToPostingDate IS NULL OR C.PostingDate <= @ToPostingDate)
				AND (@SchedulingProviderFullName IS NULL OR REPLACE(ISNULL(sp.Prefix + ' ', '')  + ISNULL(sp.FirstName, '') + ISNULL(' '+sp.MiddleName, '') + ISNULL(' ' + sp.LastName, '') 
				+ ISNULL(', ' + sp.Degree, ''), '  ',' ') LIKE '%' + @SchedulingProviderFullName + '%')
				AND (@RenderingProviderFullName IS NULL OR REPLACE(ISNULL(d.Prefix + ' ', '')  + ISNULL(d.FirstName, '') + ISNULL(' '+d.MiddleName, '') + ISNULL(' ' + d.LastName, '') 
				+ ISNULL(', ' + d.Degree, ''), '  ',' ') LIKE '%' + @RenderingProviderFullName + '%')
				AND (@ReferringProviderFullName IS NULL OR REPLACE(ISNULL(refD.Prefix + ' ', '')  + ISNULL(refD.FirstName, '') + ISNULL(' '+refD.MiddleName, '') 
				+ ISNULL(' ' + refD.LastName, '') + ISNULL(', ' + refD.Degree, ''), '  ',' ') LIKE '%' + @ReferringProviderFullName + '%')
				AND (@ServiceLocationName IS NULL OR sl.Name LIKE '%' + @ServiceLocationName + '%')
				AND (@PatientName IS NULL OR dbo.fn_FormatFirstMiddleLast( p.FirstName, p.MiddleName, p.LastName) LIKE '%' + @PatientName + '%')
				AND (@CasePayerScenario IS NULL OR paySc.Name LIKE '%' + @CasePayerScenario + '%')
				AND (@Status IS NULL OR c.Status LIKE '%' + @Status + '%')
				AND (@BilledTo IS NULL OR c.AssignedToDisplayName LIKE '%' + @BilledTo + '%')
				AND (@PracticeName IS NULL OR prac.Name LIKE '%' + @PracticeName + '%' AND prac.active=1 )
				AND (@EncounterStatus IS NULL OR es.EncounterStatusDescription LIKE '%' + @EncounterStatus + '%')
 
			/* Return unapproved charges as well */
			UNION

			SELECT 
					NULL AS [ID], 
					ep.CreatedDate AS [CreatedDate],
					CONVERT(VARCHAR, 
						(SELECT MAX(moddate.ModifiedDate) FROM (SELECT TOP 1 ModifiedDate FROM Claim c1 WHERE c1.ClaimID = c.ClaimID
						 UNION
						 SELECT TOP 1 ModifiedDate FROM dbo.EncounterProcedure ep1 WHERE ep1.EncounterProcedureID = ep.EncounterProcedureID
						 UNION
						 SELECT TOP 1 ModifiedDate FROM dbo.Encounter e1 WHERE e1.EncounterID = e.EncounterID) AS moddate),
						101) AS [LastModifiedDate],					
					prac.Name AS [PracticeName],
					e.EncounterID AS [EncounterID], 
					ep.EncounterProcedureID AS [EncounterProcedureID],
					e.PatientID AS [PatientID],
					dbo.fn_FormatFirstMiddleLast( p.FirstName, p.MiddleName, p.LastName) AS PatientName,
					p.FirstName AS PatientFirstName,
					p.MiddleName AS PatientMiddleName,
					p.LastName AS PatientLastName,
					CONVERT(VARCHAR, p.DOB, 101) AS [PatientDateOfBirth],
					pc.Name AS [CaseName], 
					paySc.Name AS [CasePayerScenario],
					CONVERT(VARCHAR, COALESCE(ep.ProcedureDateOfService, e.DateOfService), 101) AS ServiceStartDate,
					CONVERT(VARCHAR, COALESCE(ep.ServiceEndDate, e.DateOfServiceTo), 101) AS ServiceEndDate,
					CONVERT(VARCHAR, e.PostingDate, 101) AS PostingDate,
					e.BatchId AS [BatchNumber],
					REPLACE(ISNULL(sp.Prefix + ' ', '')  + ISNULL(sp.FirstName, '') + ISNULL(' '+sp.MiddleName, '') + ISNULL(' ' + sp.LastName, '') + ISNULL(', ' + sp.Degree, ''), '  ',' ') AS [SchedulingProviderName],
					REPLACE(ISNULL(d.Prefix + ' ', '')  + ISNULL(d.FirstName, '') + ISNULL(' '+d.MiddleName, '') + ISNULL(' ' + d.LastName, '') + ISNULL(', ' + d.Degree, ''), '  ',' ') AS [RenderingProviderName],
					REPLACE(ISNULL(supD.Prefix + ' ', '')  + ISNULL(supD.FirstName, '') + ISNULL(' '+supD.MiddleName, '') + ISNULL(' ' + supD.LastName, '') + ISNULL(', ' + supD.Degree, ''), '  ',' ') AS [SupervisingProviderName],
					REPLACE(ISNULL(refD.Prefix + ' ', '')  + ISNULL(refD.FirstName, '') + ISNULL(' '+refD.MiddleName, '') + ISNULL(' ' + refD.LastName, '') + ISNULL(', ' + refD.Degree, ''), '  ',' ') AS [ReferringProviderName],
					sl.Name AS ServiceLocationName,
					pcd.ProcedureCode,
					ISNULL(pcd.LocalName, pcd.OfficialName) AS ProcedureName,
					pcc.ProcedureCodeCategoryName AS ProcedureCodeCategory,
					ep.ProcedureModifier1,
					ep.ProcedureModifier2,
					ep.ProcedureModifier3,
					ep.ProcedureModifier4,
					CASE WHEN dcd5.DiagnosisCode IS NULL THEN dcd1.DiagnosisCode ELSE dcd5.DiagnosisCode END AS EncounterDiagnosisID1,
					CASE WHEN dcd6.DiagnosisCode IS NULL THEN dcd2.DiagnosisCode ELSE dcd6.DiagnosisCode END AS EncounterDiagnosisID2,
					CASE WHEN dcd7.DiagnosisCode IS NULL THEN dcd3.DiagnosisCode ELSE dcd7.DiagnosisCode END AS EncounterDiagnosisID3,
					CASE WHEN dcd8.DiagnosisCode IS NULL THEN dcd4.DiagnosisCode ELSE dcd8.DiagnosisCode END AS EncounterDiagnosisID4,
					ep.ServiceUnitCount AS [Units],
					ep.ServiceChargeAmount AS [UnitCharge],
					CAST( dbo.fn_RoundUpToPenny( ISNULL(ep.ServiceUnitCount, 0) * ISNULL(ep.ServiceChargeAmount, 0)) AS MONEY) AS [TotalCharges],
					NULL AS AdjustedCharges,	
					0.0 AS Receipts,			
					0.0 AS PatientBalance,	
					0.0 AS InsuranceBalance,				
					0.0 AS TotalBalance,			
					ic1.InsuranceCompanyName AS [PrimaryInsuranceCompanyName],
					icp1.PlanName AS [PrimaryInsurancePlanName],
					ic2.InsuranceCompanyName AS SecondaryInsuranceCompanyName,
					icp2.PlanName AS SecondaryInsurancePlanName,
					NULL AS BilledTo,
                    es.EncounterStatusDescription AS EncounterStatus,
					NULL AS 'Status',
					e.practiceID AS [PracticeID], 
					CASE
						WHEN (A.AppointmentID IS NOT NULL) AND (AR.AppointmentID IS NOT NULL) 
							THEN dbo.AppointmentDataProvider_GetTicketNumber(A.AppointmentID, E.AppointmentStartDate, 1)
						WHEN (A.AppointmentID IS NOT NULL) AND (AR.AppointmentID IS NULL) 
							THEN dbo.AppointmentDataProvider_GetTicketNumber(A.AppointmentID, E.AppointmentStartDate, 0)
						ELSE CAST('' AS VARCHAR(100))
					END AS [AppointmentID],
					sp.DoctorId AS [SchedulingProviderID],
					d.DoctorId AS [RenderingProviderID],
					supD.DoctorId AS [SupervisingProviderID],
					refD.DoctorId AS [ReferringProviderID],
					e.AmountPaid AS CopayAmount,
					epmc.Description AS CopayMethod,
					EpayC.Name AS CopayCategory,
					e.Reference AS CopayReference,
					ep.AnesthesiaTime AS [Minutes],
					ep.EDIServiceNote AS [LineNote],
					epedinrc.Definition AS [RefCode],
					tos.Description AS [TypeOfService],
					CONVERT(VARCHAR, e.HospitalizationStartDT, 101) AS [HospitalizationStartDate],
					CONVERT(VARCHAR, e.HospitalizationEndDT, 101) AS [HospitalizationEndDate],
					e.Box10d AS [LocalUseBox10d],
					e.Box19 AS [LocalUseBox19],
					e.DoNotSendElectronic AS [DoNotSendClaimElectronically],
					e.DoNotSendElectronicSecondary AS [DoNotSendElectronicallyToSecondary],
					edinrc.Definition AS [EClaimNoteType],
					CASE
						WHEN (e.ClaimTypeID IS NOT NULL AND e.ClaimTypeID IN (0, 2)) 
							THEN e.EDIClaimNoteCMS1500
						WHEN (e.ClaimTypeID IS NOT NULL AND e.ClaimTypeID = 1) 
							THEN e.EDIClaimNoteUB04
						ELSE NULL
					END AS [EClaimNote],
					sl.ServiceLocationID AS ServiceLocationId,
					sl.BillingName AS ServiceLocationBillingName,
					sl.PlaceOfServiceCode AS ServiceLocationPlaceOfServiceCode,
					pos.Description AS ServiceLocationPlaceOfServiceName,
					sl.AddressLine1 AS ServiceLocationNameAddressLine1, 
					sl.AddressLine2 AS ServiceLocationNameAddressLine2, 
					sl.City AS ServiceLocationNameCity, 
					sl.State AS ServiceLocationNameState, 
					sl.Country AS ServiceLocationNameCountry, 
					sl.ZipCode AS ServiceLocationNameZipCode, 
					dbo.fn_FormatPhone(sl.Phone) AS ServiceLocationPhone, 
					sl.PhoneExt AS ServiceLocationPhoneExt, 
					dbo.fn_FormatPhone(sl.FaxPhone) AS ServiceLocationFax, 
					sl.FaxPhoneExt AS ServiceLocationFaxExt, 
					sl.NPI AS ServiceLocationNPI, 
					sl.HCFABox32FacilityID AS ServiceLocationFacilityID,
					RTRIM(LTRIM(gnt.ANSIReferenceIdentificationQualifier + ' ' + gnt.TypeName)) AS ServiceLocationFacilityIdType,
					sl.CLIANumber AS ServiceLocationCLIANumber, 
					0.0 AS AllowedAmount,
					0.0 AS ExpectedAmount,

					----- primary ins payment
					icp1.[AddressLine1] AS PrimaryInsuranceAddressLine1,
					icp1.[AddressLine2] AS PrimaryInsuranceAddressLine2,
					icp1.[City] AS PrimaryInsuranceCity,
					icp1.[State] AS PrimaryInsuranceState,
					icp1.[Country] AS PrimaryInsuranceCountry,
					icp1.[ZipCode] AS PrimaryInsuranceZipCode,
					NULL AS [PrimaryInsuranceBatchID],
					NULL AS PrimaryInsuranceFirstBillDate,
					NULL AS PrimaryInsuranceLastBillDate,
					NULL AS PrimaryPostingDates,
					NULL AS PrimaryInsurancePaymentID,
					NULL AS PrimaryPaymentIDsAll,
					NULL AS PrimaryInsurancePaymentPostingDate,
					--NULL AS PrimaryInsuranceAdjudicationDate,
					NULL AS PrimaryAdjudicationDatesAll,
					NULL AS PrimaryInsurancePaymentRef,
					NULL AS PrimaryInsurancePaymentMethodDesc,
					NULL AS PrimaryInsurancePaymentCategoryDesc,
					NULL AS PrimaryInsuranceInsuranceAllowed,
					NULL AS PrimaryInsuranceInsuranceContractAdjustment,
					NULL AS PrimaryInsuranceInsuranceContractAdjustmentReason,
					NULL AS PrimaryInsuranceInsuranceSecondaryAdjustment,
					NULL AS PrimaryInsuranceInsuranceSecondaryAdjustmentReason,
					NULL AS PrimaryInsuranceInsurancePayment,
					NULL AS PrimaryPaymentPaymentsAll,
					NULL AS PrimaryInsuranceInsuranceDeductible,
					NULL AS PrimaryInsuranceInsuranceCoinsurance, 
					NULL AS PrimaryInsuranceInsuranceCopay,
	  
	                
					----- secondary ins payment
					icp2.[AddressLine1] AS SecondaryInsuranceAddressLine1,
					icp2.[AddressLine2] AS SecondaryInsuranceAddressLine2,
					icp2.[City] AS SecondaryInsuranceCity,
					icp2.[State] AS SecondaryInsuranceState,
					icp2.[Country] AS SecondaryInsuranceCountry,
					icp2.[ZipCode] AS SecondaryInsuranceZipCode,
					NULL AS SecondaryInsuranceBatchID,
					NULL AS SecondaryInsuranceFirstBillDate,
					NULL AS SecondaryInsuranceLastBillDate,
					NULL AS SecondaryPostingDates,
					NULL AS SecondaryInsurancePaymentID,
					NULL AS SecondaryInsurancePaymentIDsAll,
					NULL AS SecondaryInsurancePaymentPostingDate,
					NULL AS SecondaryInsuranceAdjudicationDate,
					--NULL AS SecondaryAdjudicationDatesAll,
					NULL AS SecondaryInsurancePaymentRef,
					NULL AS SecondaryInsurancePaymentMethodDesc,
					NULL AS SecondaryInsurancePaymentCategoryDesc,
					NULL AS SecondaryInsuranceInsuranceAllowed,
					NULL AS SecondaryInsuranceInsuranceContractAdjustment,
					NULL AS SecondaryInsuranceInsuranceContractAdjustmentReason,
					NULL AS SecondaryInsuranceInsuranceSecondaryAdjustment,
					NULL AS SecondaryInsuranceInsuranceSecondaryAdjustmentReason,
					NULL AS SecondaryInsuranceInsurancePayment,
					NULL AS SecondaryPaymentPaymentsAll,
					NULL AS SecondaryInsuranceInsuranceDeductible,
					NULL AS SecondaryInsuranceInsuranceCoinsurance, 
					NULL AS SecondaryInsuranceInsuranceCopay,
	                
					----- OTHER ins payment
					ic3.InsuranceCompanyName AS TertiaryInsuranceCompanyName,
					icp3.PlanName AS TertiaryInsuranceCompanyPlanName,
					icp3.[AddressLine1] AS TertiaryInsuranceAddressLine1,
					icp3.[AddressLine2] AS TertiaryInsuranceAddressLine2,
					icp3.[City] AS TertiaryInsuranceCity,
					icp3.[State] AS TertiaryInsuranceState,
					icp3.[Country] AS TertiaryInsuranceCountry,
					icp3.[ZipCode] AS TertiaryInsuranceZipCode,
					NULL AS TertiaryInsuranceBatchID,
					NULL AS TertiaryInsurancePaymentID,
					NULL AS TertiaryInsurancePaymentPostingDate,
					NULL AS TertiaryInsuranceAdjudicationDate,
					NULL AS TertiaryInsurancePaymentRef,
					NULL AS TertiaryInsurancePaymentMethodDesc,
					NULL AS TertiaryInsurancePaymentCategoryDesc,
					NULL AS TertiaryInsuranceInsuranceAllowed,
					NULL AS TertiaryInsuranceInsuranceContractAdjustment,
					NULL AS TertiaryInsuranceInsuranceContractAdjustmentReason,
					NULL AS TertiaryInsuranceInsuranceSecondaryAdjustment,
					NULL AS TertiaryInsuranceInsuranceSecondaryAdjustmentReason,
					NULL  AS TertiaryInsuranceInsurancePayment,
					NULL AS TertiaryInsuranceInsuranceDeductible,
					NULL AS TertiaryInsuranceInsuranceCoinsurance, 
					NULL AS TertiaryInsuranceInsuranceCopay,
	                
					------ PatientPayment
					NULL AS PatientBatchID,
					NULL AS PatientFirstBillDate,
					NULL AS PatientLastBillDate,
					NULL AS PatientPaymentRef,
					NULL AS PatientPaymentID,
					NULL AS PatientPaymentIDsAll,
					NULL AS PatientPaymentPostingDate,
					NULL AS PatientPaymentPostingDatesAll,
					NULL AS PatientPaymentMethodDesc,
					NULL AS PatientPaymentCategoryDesc,
					NULL AS PatientPaymentAmount,
					NULL AS PatientPaymentAmountsAll,
					NULL AS OtherPatientPaymentsAll,
					NULL AS OtherAdjustment,

					------ Other Payments
					NULL AS OtherPaymentID,
					NULL AS OtherPaymentIDsAll,
					NULL AS OtherPaymentRef,                             
					NULL AS OtherPaymentAmount, 
					NULL AS OtherPaymentsAll,
					NULL AS OtherPaymentPostingDate,
					NULL AS OtherPaymentPostingDatesAll,
					NULL AS OtherPaymentMethodDesc,
					NULL AS OtherPaymentCategoryDesc   
			FROM	Encounter e 
					INNER JOIN Practice prac ON prac.PracticeId = e.PracticeId
                    INNER JOIN EncounterStatus es ON es.EncounterStatusID = e.EncounterStatusID
					INNER JOIN EncounterProcedure ep ON ep.PracticeID = e.PracticeID AND ep.EncounterID = e.EncounterID
					INNER JOIN Patient p ON p.PatientID = e.PatientID AND p.PracticeID = e.PracticeID
					INNER JOIN PatientCase pc ON pc.PatientCaseID = e.PatientCaseID AND pc.PracticeID = e.PracticeID
					INNER JOIN PayerScenario paySc ON paySc.PayerScenarioID = pc.PayerScenarioID
					INNER JOIN Doctor d ON d.DoctorID = e.DoctorID AND d.PracticeID = e.PracticeID
					INNER JOIN ProcedureCodeDictionary pcd ON pcd.ProcedureCodeDictionaryID = ep.ProcedureCodeDictionaryID
					LEFT JOIN Claim c ON c.PracticeID = ep.PracticeID AND c.EncounterProcedureID = ep.EncounterProcedureID
                    LEFT JOIN ProcedureCodeCategory pcc (NOLOCK) ON pcc.ProcedureCodeCategoryID = pcd.ProcedureCodeCategoryID
					LEFT JOIN Doctor sp ON sp.DoctorID = e.SchedulingProviderID
					LEFT JOIN Doctor supD ON supD.DoctorID = e.SupervisingProviderID
					LEFT JOIN Doctor refD ON refD.DoctorID = e.ReferringPhysicianID
					LEFT JOIN ServiceLocation sl ON sl.ServiceLocationID = e.LocationID
					LEFT JOIN PlaceOfService pos ON pos.PlaceOfServiceCode = e.PlaceOfServiceCode
					LEFT JOIN GroupNumberType gnt ON gnt.GroupNumberTypeID = sl.FacilityIDType
					LEFT JOIN PaymentMethodCode Epmc ON Epmc.PaymentMethodCode = e.PaymentMethod
					LEFT JOIN Category EpayC ON EpayC.CategoryID = e.PaymentCategoryID
					LEFT JOIN EDINoteReferenceCode edinrc ON  edinrc.Code = CASE WHEN (e.ClaimTypeID IS NOT NULL AND e.ClaimTypeID IN (0, 2)) 
							THEN e.EDIClaimNoteReferenceCodeCMS1500
						    WHEN (e.ClaimTypeID IS NOT NULL AND e.ClaimTypeID = 1) 
							THEN e.EDIClaimNoteReferenceCodeUB04
						    ELSE e.EDIClaimNoteReferenceCode 
						END
					LEFT JOIN EDINoteReferenceCode epedinrc ON  epedinrc.Code = ep.EDIServiceNoteReferenceCode
					LEFT JOIN TypeOfService tos ON tos.TypeOfServiceCode = ep.TypeOfServiceCode
					LEFT JOIN Appointment A ON A.AppointmentID = E.AppointmentID	
					LEFT JOIN AppointmentRecurrence AR ON AR.AppointmentID = E.AppointmentID
	                LEFT JOIN InsurancePolicy ip1 ON ip1.PatientCaseID = e.PatientCaseID AND ip1.PracticeID = e.PracticeID AND ip1.Precedence = 1
                    LEFT JOIN InsurancePolicy ip2 ON ip2.PatientCaseID = e.PatientCaseID AND ip2.PracticeID = e.PracticeID AND ip2.Precedence = 2
                    LEFT JOIN InsurancePolicy ip3 ON ip3.PatientCaseID = e.PatientCaseID AND ip3.PracticeID = e.PracticeID AND ip3.Precedence = 3
					LEFT JOIN InsuranceCompanyPlan icp1 ON icp1.InsuranceCompanyPlanID = ip1.InsuranceCompanyPlanID
					LEFT JOIN InsuranceCompany ic1 ON icp1.InsuranceCompanyID = ic1.InsuranceCompanyID
					LEFT JOIN InsuranceCompanyPlan icp2 ON icp2.InsuranceCompanyPlanID = ip2.InsuranceCompanyPlanID
					LEFT JOIN InsuranceCompany ic2 ON icp2.InsuranceCompanyID = ic2.InsuranceCompanyID
					----- Patient Payment 
					LEFT JOIN PaymentMethodCode pmc ON pmc.PaymentMethodCode = e.PaymentMethod
					LEFT JOIN Category cat ON cat.CategoryID = e.PaymentCategoryID
					----- OTHER ins payment
					LEFT JOIN InsuranceCompanyPlan icp3 ON icp3.InsuranceCompanyPlanID = ip3.InsuranceCompanyPlanID
					LEFT JOIN InsuranceCompany ic3 ON icp3.InsuranceCompanyID = ic3.InsuranceCompanyID
	                
					LEFT JOIN EncounterDiagnosis ed1 ON ed1.PracticeID = ep.PracticeID AND ed1.EncounterID = ep.EncounterID AND ed1.EncounterDiagnosisID = ep.EncounterDiagnosisID1 
					LEFT JOIN DiagnosisCodeDictionary dcd1 ON dcd1.DiagnosisCodeDictionaryID= ed1.DiagnosisCodeDictionaryID
	                
					LEFT JOIN EncounterDiagnosis ed2 ON ed2.PracticeID = ep.PracticeID AND ed2.EncounterID = ep.EncounterID AND ed2.EncounterDiagnosisID = ep.EncounterDiagnosisID2
					LEFT JOIN DiagnosisCodeDictionary dcd2 ON dcd2.DiagnosisCodeDictionaryID= ed2.DiagnosisCodeDictionaryID
	                
					LEFT JOIN EncounterDiagnosis ed3 ON ed3.PracticeID = ep.PracticeID AND ed3.EncounterID = ep.EncounterID AND ed3.EncounterDiagnosisID = ep.EncounterDiagnosisID3 
					LEFT JOIN DiagnosisCodeDictionary dcd3 ON dcd3.DiagnosisCodeDictionaryID= ed3.DiagnosisCodeDictionaryID
	                
					LEFT JOIN EncounterDiagnosis ed4 ON ed4.PracticeID = ep.PracticeID AND ed4.EncounterID = ep.EncounterID AND ed4.EncounterDiagnosisID = ep.EncounterDiagnosisID4 
					LEFT JOIN DiagnosisCodeDictionary dcd4 ON dcd4.DiagnosisCodeDictionaryID= ed4.DiagnosisCodeDictionaryID			

                    LEFT JOIN EncounterDiagnosis ed5 ON ed5.PracticeID = ep.PracticeID AND ed5.EncounterID = ep.EncounterID AND ed5.EncounterDiagnosisID = ep.EncounterDiagnosisID5
					LEFT JOIN ICD10DiagnosisCodeDictionary dcd5 ON dcd5.ICD10DiagnosisCodeDictionaryId = ed5.DiagnosisCodeDictionaryID

					LEFT JOIN EncounterDiagnosis ed6 ON ed6.PracticeID = ep.PracticeID AND ed6.EncounterID = ep.EncounterID AND ed6.EncounterDiagnosisID = ep.EncounterDiagnosisID6
					LEFT JOIN ICD10DiagnosisCodeDictionary dcd6 ON dcd6.ICD10DiagnosisCodeDictionaryId = ed6.DiagnosisCodeDictionaryID

					LEFT JOIN EncounterDiagnosis ed7 ON ed7.PracticeID = ep.PracticeID AND ed7.EncounterID = ep.EncounterID AND ed7.EncounterDiagnosisID = ep.EncounterDiagnosisID7
					LEFT JOIN ICD10DiagnosisCodeDictionary dcd7 ON dcd7.ICD10DiagnosisCodeDictionaryId = ed7.DiagnosisCodeDictionaryID

					LEFT JOIN EncounterDiagnosis ed8 ON ed8.PracticeID = ep.PracticeID AND ed8.EncounterID = ep.EncounterID AND ed8.EncounterDiagnosisID = ep.EncounterDiagnosisID8
					LEFT JOIN ICD10DiagnosisCodeDictionary dcd8 ON dcd8.ICD10DiagnosisCodeDictionaryId = ed8.DiagnosisCodeDictionaryID		
    
			WHERE (c.ClaimID IS NULL)
                AND (@FromCreatedDate IS NULL OR ep.CreatedDate >= @FromCreatedDate)
				AND (@ToCreatedDate IS NULL OR ep.CreatedDate <= @ToCreatedDate)
				AND (@FromLastModifiedDate IS NULL OR (SELECT MAX(moddate.ModifiedDate) FROM (SELECT TOP 1 ModifiedDate FROM Claim c1 WHERE c1.ClaimID = c.ClaimID
						 UNION
						 SELECT TOP 1 ModifiedDate FROM dbo.EncounterProcedure ep1 WHERE ep1.EncounterProcedureID = ep.EncounterProcedureID ORDER BY ep1.ModifiedDate DESC
						 UNION
						 SELECT TOP 1 ModifiedDate FROM dbo.Encounter e1 WHERE e1.EncounterID = e.EncounterID) AS moddate) >= @FromLastModifiedDate)
				AND (@ToLastModifiedDate IS NULL OR (SELECT MAX(moddate.ModifiedDate) FROM (SELECT TOP 1 ModifiedDate FROM Claim c1 WHERE c1.ClaimID = c.ClaimID
						 UNION
						 SELECT TOP 1 ModifiedDate FROM dbo.EncounterProcedure ep1 WHERE ep1.EncounterProcedureID = ep.EncounterProcedureID ORDER BY ep1.ModifiedDate DESC
						 UNION
						 SELECT TOP 1 ModifiedDate FROM dbo.Encounter e1 WHERE e1.EncounterID = e.EncounterID  ORDER BY e1.ModifiedDate) AS moddate) <= @ToLastModifiedDate)
				AND (@FromPostingDate IS NULL OR e.PostingDate >= @FromPostingDate)
				AND (@ToPostingDate IS NULL OR e.PostingDate <= @ToPostingDate)
				AND (@FromServiceDate IS NULL OR ep.ProcedureDateOfService >= @FromServiceDate)
				AND (@ToServiceDate IS NULL OR ep.ProcedureDateOfService <= @ToServiceDate)
				AND (@SchedulingProviderFullName IS NULL OR REPLACE(ISNULL(sp.Prefix + ' ', '')  + ISNULL(sp.FirstName, '') + ISNULL(' '+sp.MiddleName, '') + ISNULL(' ' + sp.LastName, '') + ISNULL(', ' + sp.Degree, ''), '  ',' ') LIKE '%' 
				+ @SchedulingProviderFullName + '%')
				AND (@RenderingProviderFullName IS NULL OR REPLACE(ISNULL(d.Prefix + ' ', '')  + ISNULL(d.FirstName, '') + ISNULL(' '+d.MiddleName, '') + ISNULL(' ' + d.LastName, '') + ISNULL(', ' + d.Degree, ''), '  ',' ') LIKE '%' + @RenderingProviderFullName + '%
'
)
				AND (@ReferringProviderFullName IS NULL OR REPLACE(ISNULL(refD.Prefix + ' ', '')  + ISNULL(refD.FirstName, '') + ISNULL(' '+refD.MiddleName, '') + ISNULL(' ' + refD.LastName, '') + ISNULL(', ' + refD.Degree, ''), '  ',' ') LIKE '%' 
				+ @ReferringProviderFullName + '%')
				AND (@ServiceLocationName IS NULL OR sl.Name LIKE '%' + @ServiceLocationName + '%')
				AND (@PatientName IS NULL OR dbo.fn_FormatFirstMiddleLast( p.FirstName, p.MiddleName, p.LastName) LIKE '%' + @PatientName + '%')
				AND (@CasePayerScenario IS NULL OR paySc.Name LIKE '%' + @CasePayerScenario + '%')
				AND (@Status IS NULL)
				AND (@BilledTo IS NULL)
				AND (@PracticeName IS NULL OR prac.Name LIKE '%' + @PracticeName + '%' AND prac.active=1 )
				AND (@IncludeUnapprovedCharges = 1)  
				AND (@EncounterStatus IS NULL OR es.EncounterStatusDescription LIKE '%' + @EncounterStatus + '%')

		
					

	DROP TABLE #Claims, #ClaimInsurance, #minContractAdjustment, #ClaimPayment, #ClaimEOB, #payments, #Adjustment, #AR, #ASNMax, #CheckForNoASN, #AssignmentInfo, #ASN, #AR_ASN, #ParseProcedureCode, #PatientPaymentsAll, 
				#OtherPatientPaymentsAll, #OtherPaymentsAll, #PrimaryInsDates, #SecondaryInsDates, #PrimarypaymentsAll, #SecondarypaymentsAll

	

END

GO


