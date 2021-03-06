--USE [superbill_0242_dev]
--GO
--/****** Object:  StoredProcedure [dbo].[WebServiceDataProvider_ChargesExport]    Script Date: 11/08/2009 21:24:34 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO



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



declare
	@PracticeName varchar(100),						 
	@FromCreatedDate datetime,						
	@ToCreatedDate datetime ,							
	@FromLastModifiedDate datetime ,					
	@ToLastModifiedDate datetime ,					
	@PatientName varchar(100) ,						
	@CasePayerScenario varchar(100) ,					
	@FromServiceDate datetime ,						
	@ToServiceDate datetime ,							
	@FromPostingDate datetime ,						
	@ToPostingDate datetime ,							
	@BatchNumber varchar(100) ,						
	@SchedulingProviderFullName varchar(256) ,		
	@RenderingProviderFullName varchar(256) ,			
	@ReferringProviderFullName varchar(256) ,			
	@ServiceLocationName varchar(256) ,				
	@ProcedureCode varchar(max) ,						
	@DiagnosisCode varchar(max) ,						
	@Status varchar(max) ,							
	@BilledTo varchar(max) ,	
	@IncludeUnapprovedCharges bit,	
	@EncounterStatus varchar(50)

-- select * from practice where active = 1			
select
	@PracticeName  = 'Physical Medicine Associates, LTD',			 
	@FromCreatedDate  = null,						
	@ToCreatedDate  = null,							
	@FromLastModifiedDate  = null,					
	@ToLastModifiedDate  = null,					
	@PatientName  = null,						
	@CasePayerScenario  = null,					
	@FromServiceDate  = null,						
	@ToServiceDate  = null,							
	@FromPostingDate  = null,						
	@ToPostingDate  = null,							
	@BatchNumber  = null,						
	@SchedulingProviderFullName = null,		
	@RenderingProviderFullName = null,			
	@ReferringProviderFullName = null,			
	@ServiceLocationName = null,				
	@ProcedureCode = NULL,						
	@DiagnosisCode = NULL,						
	@Status  = NULL,							
	@BilledTo = NULL,	
	@IncludeUnapprovedCharges = 0,	
	@EncounterStatus  = NULL


BEGIN

	SET NOCOUNT ON
	set transaction isolation level read uncommitted
	
	declare @now datetime
	select @now = getdate();

	-- patch up if they specified only one of modified date pair
	IF @FromLastModifiedDate is not null AND @ToLastModifiedDate is null BEGIN
		SET @ToLastModifiedDate = CAST(CONVERT(VARCHAR,DATEADD(dd,7,@FromLastModifiedDate),110) AS DATETIME)
	END ELSE IF @FromLastModifiedDate is null AND @ToLastModifiedDate is not null BEGIN
		SET @FromLastModifiedDate = CAST(CONVERT(VARCHAR,DATEADD(dd,-7,@ToLastModifiedDate),110) AS DATETIME)
	END

	-- patch up if they specified only one of modified date pair
	IF @FromCreatedDate is not null AND @ToCreatedDate is null BEGIN
		SET @ToCreatedDate = CAST(CONVERT(VARCHAR,DATEADD(dd,7,@FromCreatedDate),110) AS DATETIME)
	END ELSE IF @FromCreatedDate is null AND @ToCreatedDate is not null BEGIN
		SET @FromCreatedDate = CAST(CONVERT(VARCHAR,DATEADD(dd,-7,@ToCreatedDate),110) AS DATETIME)
	END

	-- patch up if they specified only one of service date pair
	IF @FromServiceDate is not null AND @ToServiceDate is null BEGIN
		SET @ToServiceDate = CAST(CONVERT(VARCHAR,DATEADD(dd,7,@FromServiceDate),110) AS DATETIME)
	END ELSE IF @FromServiceDate is null AND @ToServiceDate is not null BEGIN
		SET @FromServiceDate = CAST(CONVERT(VARCHAR,DATEADD(dd,-7,@ToServiceDate),110) AS DATETIME)
	END

	-- patch up if they specified only one of Posting date pair
	IF @FromPostingDate is not null AND @ToPostingDate is null BEGIN
		SET @ToPostingDate = CAST(CONVERT(VARCHAR,DATEADD(dd,7,@FromPostingDate),110) AS DATETIME)
	END ELSE IF @FromPostingDate is null AND @ToPostingDate is not null BEGIN
		SET @FromPostingDate = CAST(CONVERT(VARCHAR,DATEADD(dd,-7,@ToPostingDate),110) AS DATETIME)
	END

	-- if they haven't specified complete dates for posting, lastmodified, transaction or service dates, then we'll put in some range for posting date
	IF (@FromPostingDate IS NULL) AND (@ToPostingDate IS NULL) 
		AND (@FromLastModifiedDate IS NULL) AND (@ToLastModifiedDate IS NULL) 
		AND (@FromServiceDate IS NULL) AND (@ToServiceDate IS NULL) 
		AND (@FromCreatedDate IS NULL) AND (@ToCreatedDate IS NULL) 
	BEGIN
		SET @FromPostingDate = CAST(CONVERT(VARCHAR,DATEADD(dd,-7,GETDATE()),110) AS DATETIME)
		SET @ToPostingDate = CAST(CONVERT(VARCHAR,DATEADD(dd,7,@FromPostingDate),110) AS DATETIME)
	END

	-- for all the "to" dates, we need to do the following logic:
	--    if they specified a specific time, honor that specific time.
	--    if they specified just a date, then look for everything through the end of that date
	SET @ToCreatedDate = case when DBO.fn_DateOnly(@ToCreatedDate) = @ToCreatedDate then DATEADD( S, -1, DBO.fn_DateOnly( DATEADD(D, 1, @ToCreatedDate))) ELSE @ToCreatedDate END
	SET @ToLastModifiedDate = case when DBO.fn_DateOnly(@ToLastModifiedDate) = @ToLastModifiedDate then DATEADD( S, -1, DBO.fn_DateOnly( DATEADD(D, 1, @ToLastModifiedDate))) ELSE @ToLastModifiedDate END
	SET @ToServiceDate = case when DBO.fn_DateOnly(@ToServiceDate) = @ToServiceDate then DATEADD( S, -1, DBO.fn_DateOnly( DATEADD(D, 1, @ToServiceDate))) ELSE @ToServiceDate END
	SET @ToPostingDate = case when DBO.fn_DateOnly(@ToPostingDate) = @ToPostingDate then DATEADD( S, -1, DBO.fn_DateOnly( DATEADD(D, 1, @ToPostingDate))) ELSE @ToPostingDate END
        
	DECLARE @CheckForNoASN TABLE(ClaimID INT, NoASN BIT, CTPostingDate DATETIME)
	DECLARE @AssignmentInfo TABLE(ClaimID INT, InsurancePolicyID INT, InsuranceCompanyPlanID INT)
        
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
					PostingDate datetime
							)

			insert #Claims ( claimID, CreatedDate, ModifiedDate, ClaimServiceDateFrom, ClaimServiceDateTo, PracticeId, ClaimStatusCode, Status, encounterID, ContractID, encounterProcedureID, ProcedureCodeDictionaryID, PatientID, ProcedureModifier1, patientCaseID, DateOfService, PostingDate)
			select c.ClaimID, c.CreatedDate, c.ModifiedDate, ep.ProcedureDateOfService, ep.ServiceEndDate, c.PracticeId, c.ClaimStatusCode, 
				CASE
						WHEN cae.ClaimTransactionTypeCode IS NOT NULL  THEN 
							CASE cae.ClaimTransactionTypeCode 
								WHEN 'RJT' THEN 'Error - Rejection'
								WHEN 'DEN' THEN 'Error - Denial'
								WHEN 'BLL' THEN 'Error - No Response'
								ELSE 'Error'
							END
						WHEN C.ClaimStatusCode = 'C' THEN 'Completed'
						WHEN C.ClaimStatusCode = 'P' THEN 'Pending'
						WHEN C.ClaimStatusCode = 'R' THEN 'Ready'
						ELSE '*** Undefined'
					END AS Status,
				
				e.EncounterID, ep.ContractID, ep.encounterProcedureID, ep.ProcedureCodeDictionaryID, e.PatientID, ep.ProcedureModifier1, e.patientCaseID, e.DateOfService, ct.PostingDate
			from Encounter e
					inner join EncounterProcedure ep on e.PracticeID = ep.PracticeID and e.EncounterID = ep.EncounterID
					inner join Claim c on c.PracticeID = ep.PracticeID and c.EncounterProcedureID = ep.EncounterProcedureID
--					inner join PatientCase pc on pc.PatientCaseID = e.PatientCaseID
--					inner join Doctor d on D.DoctorID = e.DoctorID and e.PracticeID = d.PracticeID
					LEFT JOIN [dbo].[fn_ReportDataProvider_ParseProcedureCode] ( @ProcedureCode ) pcs ON pcs.ProcedureCodeDictionaryID = ep.ProcedureCodeDictionaryID
					LEFT JOIN dbo.ClaimAccounting_Errors cae ON cae.PracticeID = c.practiceId AND cae.ClaimID = c.ClaimID
					inner join Practice prac on prac.PracticeId = e.PracticeId
					INNER JOIN ClaimTransaction CT on CT.ClaimID = c.ClaimId AND CT.PracticeId = c.PracticeId AND CT.ClaimTransactionTypeCode = 'CST'
		WHERE (@PracticeName is NULL OR prac.Name like '%' + @PracticeName + '%' and prac.active=1 )




		INSERT @AssignmentInfo(ClaimID, InsurancePolicyID, InsuranceCompanyPlanID)
			SELECT CAA.ClaimID, CAA.InsurancePolicyID, CAA.InsuranceCompanyPlanID
			FROM #Claims C 
				INNER JOIN dbo.ClaimAccounting_Assignments CAA
					ON C.ClaimID=CAA.ClaimID AND CAA.LastAssignment=1


		INSERT @CheckForNoASN(ClaimID, NoASN, CTPostingDate)
			SELECT C.ClaimID, CASE WHEN COUNT(CASE WHEN CT.ClaimTransactionTypeCode='ASN' THEN 1 ELSE NULL END)=0 THEN 1 ELSE 0 END NoASN,
			MIN(CASE WHEN ClaimTransactionTypeCode='CST' THEN CT.PostingDate ELSE NULL END) CTPostingDate
			FROM #Claims C 
				INNER JOIN dbo.ClaimTransaction CT ON C.ClaimID=CT.ClaimID AND CT.ClaimTransactionTypeCode IN ('CST','ASN')
			GROUP BY C.ClaimID

		UPDATE #Claims 
			SET AssignedToDisplayName = XX.AssignedToDisplayName
			FROM #Claims JOIN 
				(SELECT #Claims.ClaimId, AssignedToDisplayName = ISNULL(CAST ((CASE 
								WHEN #Claims.ClaimStatusCode = 'C' OR CFN.NoASN=1 THEN 'Unassigned'
								WHEN CAA.InsurancePolicyID IS NULL THEN 'Patient'
								ELSE NULL 
								END) AS varchar(100)), ICP.PlanName) 
					FROM #Claims 
						LEFT JOIN @AssignmentInfo CAA ON #Claims.ClaimID=CAA.ClaimID
						LEFT JOIN dbo.InsuranceCompanyPlan ICP ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
						INNER JOIN @CheckForNoASN CFN ON #Claims.ClaimID=CFN.ClaimID) XX ON #Claims.ClaimId = XX.ClaimId
			


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
					INNER JOIN EncounterDiagnosis ed ON ed.EncounterID = ep.EncounterID AND ed.EncounterDiagnosisID IN (ep.EncounterDiagnosisID1, ep.EncounterDiagnosisID2, ep.EncounterDiagnosisID3, ep.EncounterDiagnosisID4, ep.EncounterDiagnosisID5, ep.EncounterDiagnosisID6, ep.EncounterDiagnosisID7, ep.EncounterDiagnosisID8)
					LEFT JOIN [dbo].[fn_ReportDataProvider_ParseDiagnosisCode] ( @DiagnosisCode ) ecd ON ecd.DiagnosisCodeDictionaryID = ed.DiagnosisCodeDictionaryID
				where ecd.DiagnosisCodeDictionaryID IS NOT NULL		
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




		create TABLE #ClaimInsurance ( claimID INT, 
				PrimaryInsuranceCompanyPlanID INT, PrimaryInsuranceFirstBillDate DATETIME, PrimaryInsuranceLastBillDate DATETIME, 
				SecondaryInsuranceCompanyPlanID INT, SecondaryInsuranceFirstBillDate DATETIME, SecondaryInsuranceLastBillDate DATETIME,
				TertiaryInsuranceCompanyPlanID INT, 
				PatientFirstBillDate DATETIME, PatientLastBillDate DATETIME
				)
                
		INSERT #ClaimInsurance ( claimID, PrimaryInsuranceCompanyPlanID, SecondaryInsuranceCompanyPlanID, TertiaryInsuranceCompanyPlanID )
		select c.claimID, 
				PrimaryInsuranceCompanyPlanID = case when ip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence( c.patientCaseID, DateOfService, 0 ) THEN ip.InsuranceCompanyPlanID ELSE NULL END,
				SecondaryInsuranceCompanyPlanID = case when Sip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence( c.patientCaseID, DateOfService, ip.Precedence ) THEN Sip.InsuranceCompanyPlanID ELSE NULL END,
				TertiaryInsuranceCompanyPlanID = case when Tip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence( c.patientCaseID, DateOfService, Sip.Precedence ) THEN Tip.InsuranceCompanyPlanID ELSE NULL END
		from #Claims c 
				inner join PatientCase pc on pc.PatientCaseID = c.patientCaseID
				inner join InsurancePolicy ip on ip.PatientCaseID = c.patientCaseID and ip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence( c.patientCaseID, DateOfService, 0 )
				LEFT join InsurancePolicy Sip on Sip.PatientCaseID = c.patientCaseID and Sip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence( c.patientCaseID, DateOfService, ip.Precedence )
				LEFT join InsurancePolicy Tip on Tip.PatientCaseID = c.patientCaseID and Tip.Precedence = dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence( c.patientCaseID, DateOfService, Sip.Precedence )



		------ Primary Insurance First bill
		update #ClaimInsurance
		SET PrimaryInsuranceFirstBillDate = cab.FirstBillDate, PrimaryInsuranceLastBillDate = cab.LastBillDate
		FROM (
				select ci.claimID, min( cab.PostingDate ) as FirstBillDate, max( cab.PostingDate ) as LastBillDate
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
        
        
        
        
		update c
		SET c.PrimaryInsPaymentID = priPay.paymentID
		FROM #Claims c
				inner join #ClaimInsurance ci on c.claimID = ci.ClaimID
				inner join PaymentClaim priPayC on priPayC.ClaimID = c.claimID
				inner JOIN Payment priPay on priPayC.PaymentID = priPay.PaymentID 
				inner join insuranceCompanyPlan icpPayer on icpPayer.InsuranceCompanyPlanID = priPay.PayerID and priPay.PayerTypeCode = 'I'
				inner join InsuranceCompanyPlan icpIns on icpIns.InsuranceCompanyID = icpPayer.InsuranceCompanyID 
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
				eboXML.row.value('@type','varchar(50)') Type,
				eboXML.row.value('@amount','Money') Amount,
				eboXML.row.value('@code','varchar(50)') Code,
				eboXML.row.value('@category','varchar(50)') Category,
				eboXML.row.value('@description','varchar(250)') Description
		INTO #ClaimPayment
		FROM paymentClaim pc cross apply eobXML.nodes('/eob/items/item') AS eboXML(row)
				inner join #Claims c on c.claimID = pc.ClaimID 
				AND pc.PaymentID in ( c.PrimaryInsPaymentID, c.SecondaryInsPaymentID, c.OtherInsPaymentID )
			--		where pc.practiceID = @practiceID
		-- order by pc.paymentID desc






		create TABLE #minContractAdjustment( claimID INT, paymentID INT, rowID INT )
		insert into #minContractAdjustment( claimID, paymentID, rowID )
		select claimID, paymentID, min(rowID)
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
        
        
		create TABLE #payments (paymentID INT, claimID INT, Amount MONEY)
        
		insert into #payments (paymentID, claimID, Amount)
		select paymentID, ca.ClaimID, sum(Amount)
		from claimAccounting ca
				inner join #Claims c on c.claimID = ca.ClaimID and ca.PaymentID in (c.PrimaryInsPaymentID, c.SecondaryInsPaymentID)
		where ca.ClaimTransactionTypeCode = 'PAY'
--			and ca.practiceID = @practiceID
		group by PaymentID, ca.ClaimID
                
                
                
		create TABLE #Adjustment (ClaimID INT, Amount MONEY)
		INSERT INTO #Adjustment(ClaimID, Amount)
		select ca.ClaimID, sum(Amount)
		from claimAccounting ca
				inner join #Claims c on c.claimID = ca.ClaimID
		where ca.ClaimTransactionTypeCode = 'ADJ'
--				and ca.practiceID = @practiceID
		group by ca.ClaimID
                
	                
		CREATE TABLE #AR (ClaimID INT, Amount MONEY)

		INSERT INTO #AR(ClaimID, Amount)
		SELECT CA.ClaimID, SUM(CASE WHEN CA.ClaimTransactionTypeCode='CST' THEN Amount ELSE Amount*-1  END)
		FROM ClaimAccounting CA
		INNER JOIN #Claims C on C.ClaimId = CA.ClaimId
		WHERE CA.ClaimTransactionTypeCode IN ('CST', 'ADJ', 'PAY')
		GROUP BY CA.ClaimID

		CREATE TABLE #ASNMax (ClaimID INT, ClaimTransactionID INT)
		INSERT INTO #ASNMax(ClaimID, ClaimTransactionID)
		SELECT CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
		FROM ClaimAccounting_Assignments CAA
			INNER JOIN #AR ar ON ar.CLaimID = caa.CLaimID
		GROUP BY CAA.ClaimID

		CREATE TABLE #ASN (ClaimID INT, PatientID INT, TypeGroup INT)
		INSERT INTO #ASN(ClaimID, PatientID, TypeGroup)
		SELECT CAA.ClaimID, 
			CAA.PatientID,
				CASE WHEN caa.InsuranceCompanyPlanID IS NULL THEN 2 ELSE 1 END TypeGroup
		FROM ClaimAccounting_Assignments CAA 
			INNER JOIN #ASNMax AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
			LEFT JOIN InsuranceCompanyPlan icp on icp.InsuranceCompanyPlanID = caa.InsuranceCompanyPlanID
		
		SELECT a.ClaimID, a.PatientID, ep.EncounterProcedureID,
			SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END) Charges,
			SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN Amount*-1 ELSE 0 END) Adjustments,
			SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='I' THEN Amount*-1 ELSE 0 END) InsPay,
			SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' THEN Amount*-1 ELSE 0 END) PatPay,

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



		update asn
		set
			PendingIns = PendingIns - ISNULL(ca.amount, 0),
			PendingPat =  PendingPat + ISNULL(ca.amount, 0) 
		from #AR_ASN asn 
			INNER JOIN (Select ClaimID, sum(amount) amount from ClaimAccounting  where ClaimTransactionTypeCode = 'PRC' GROUP BY ClaimID) as ca
				on ca.ClaimID = asn.ClaimID
		WHERE TypeGroup = '1' 


--	select '#AR_ASN' as [#AR_ASN], * from #AR_ASN

	-- todo: still need to handle refunds, unapplied amts, etc. - lots and lots of stuff from WebServiceDataProvider_PatientBalanceSummary

select
	null as CustomerID,
	prac.PracticeID,
	CollectionCategoryName,
	c.ClaimID, 
	e.EncounterID as [EncounterID], 
	e.PatientID as [PatientID],
	p.Prefix as Prefix,
	p.FirstName,
	p.MiddleName,
	p.LastName,
	p.Suffix,
	dbo.fn_FormatSSN(p.SSN) as SSN,
	convert(varchar, p.DOB, 101) as DOB,
	Age = floor( cast(datediff( month, p.DOB, @now) as decimal(9,2)) / 12.00 ) + case when month(p.DOB) = month(@now) and day(@now ) < day(p.DOB) then -1 else 0 end,
	p.Gender,
	p.MedicalRecordNumber,
	p.MaritalStatus,
		
	StatusName as [EmploymentStatus], 
	[EmployerName], 
	PatientReferralSourceCaption as ReferralSource,

	p.AddressLine1 as [AddressLine1], 
	p.AddressLine2 as [AddressLine2], 
	p.City as [City], 
	p.State as [State], 
	p.Country as [Country], 
	p.ZipCode as [ZipCode],

	dbo.fn_FormatPhone(p.HomePhone) as [HomePhone], 
	p.HomePhoneExt as [HomePhoneExt], 
	dbo.fn_FormatPhone(p.WorkPhone) as [WorkPhone],
	p.WorkPhoneExt as [WorkPhoneExt], 
	dbo.fn_FormatPhone(p.MobilePhone) as [MobilePhone], 
	p.MobilePhoneExt as [MobilePhoneExt], 
	p.EmailAddress as [EmailAddress], 
	
	dbo.fn_FormatFirstMiddleLast( p.FirstName, p.MiddleName, p.LastName) as PatientName,

	convert(varchar, p.DOB, 101) as PatientDateOfBirth,
	pc.Name as CaseName,
	
	
	paySc.Name as [CasePayerScenario],
	convert(varchar, c.ClaimServiceDateFrom, 101) as ServiceStartDate,
	convert(varchar, c.ClaimServiceDateTo, 101) as ServiceEndDate,
	convert(varchar, c.PostingDate, 101) as PostingDate,
	e.BatchId as [BatchNumber],
	replace(ISNULL(sp.Prefix + ' ', '')  + ISNULL(sp.FirstName, '') + ISNULL(' '+sp.MiddleName, '') + ISNULL(' ' + sp.LastName, '') + ISNULL(', ' + sp.Degree, ''), '  ',' ') as [SchedulingProviderName],
	replace(ISNULL(d.Prefix + ' ', '')  + ISNULL(d.FirstName, '') + ISNULL(' '+d.MiddleName, '') + ISNULL(' ' + d.LastName, '') + ISNULL(', ' + d.Degree, ''), '  ',' ') as [RenderingProviderName],
	replace(ISNULL(supD.Prefix + ' ', '')  + ISNULL(supD.FirstName, '') + ISNULL(' '+supD.MiddleName, '') + ISNULL(' ' + supD.LastName, '') + ISNULL(', ' + supD.Degree, ''), '  ',' ') as [SupervisingProviderName],
	replace(ISNULL(refD.Prefix + ' ', '')  + ISNULL(refD.FirstName, '') + ISNULL(' '+refD.MiddleName, '') + ISNULL(' ' + refD.LastName, '') + ISNULL(', ' + refD.Degree, ''), '  ',' ') as [ReferringProviderName],
	sl.Name as ServiceLocationName,
	pcd.ProcedureCode,
	isnull(pcd.LocalName, pcd.OfficialName) as ProcedureName,
	pcc.ProcedureCodeCategoryName as ProcedureCodeCategory,
	ep.ProcedureModifier1,
	ep.ProcedureModifier2,
	ep.ProcedureModifier3,
	ep.ProcedureModifier4,
	dcd1.DiagnosisCode as EncounterDiagnosisID1,
	dcd2.DiagnosisCode as EncounterDiagnosisID2,
	dcd3.DiagnosisCode as EncounterDiagnosisID3,
	dcd4.DiagnosisCode as EncounterDiagnosisID4,
	ep.ServiceUnitCount as [Units],
	ep.ServiceChargeAmount as [UnitCharge],
	cast( dbo.fn_RoundUpToPenny( isnull(ep.ServiceUnitCount, 0) * isnull(ep.ServiceChargeAmount, 0)) as MONEY) as [TotalCharges],
	(CA.Charges-isnull(adj.Amount, 0)) as AdjustedCharges,	
	isnull(CA.InsPay,0.0) + isnull(CA.PatPay,0.0) as Receipts,			
	CA.PendingPat as PatientBalance,	
	CA.PendingIns as InsuranceBalance,				
	CA.TotalBalance as TotalBalance,			
	ic1.InsuranceCompanyName as [PrimaryInsuranceCompanyName],
	icp1.PlanName as [PrimaryInsurancePlanName],
	ic2.InsuranceCompanyName as SecondaryInsuranceCompanyName,
	icp2.PlanName as SecondaryInsurancePlanName,
	c.AssignedToDisplayName as BilledTo,
	c.Status
    
from #Claims c
	inner join Encounter e on e.EncounterID = c.encounterID 
	inner join EncounterStatus es on es.EncounterStatusID = e.EncounterStatusID
	inner join Patient p on p.PatientID = c.PatientID and p.PracticeID = e.PracticeID
	
	left join employmentStatus enst on enst.EmploymentStatusCode = p.EmploymentStatus
	inner join PatientCase pc on pc.PatientCaseID = e.PatientCaseID and pc.PracticeID = e.PracticeID
	inner join PayerScenario paySc on paySc.PayerScenarioID = pc.PayerScenarioID
	inner join Doctor d on d.DoctorID = e.DoctorID and d.PracticeID = e.PracticeID
	INNER JOIN ProcedureCodeDictionary pcd on pcd.ProcedureCodeDictionaryID = c.ProcedureCodeDictionaryID
	LEFT join ProcedureCodeCategory pcc (Nolock) on pcc.ProcedureCodeCategoryID = pcd.ProcedureCodeCategoryID
	inner join EncounterProcedure ep on ep.PracticeID = e.PracticeID and ep.EncounterProcedureID = c.encounterProcedureID and ep.EncounterID = c.EncounterID
	LEFT join #ClaimInsurance ci on ci.claimID = c.claimID
	
	LEFT OUTER JOIN CollectionCategory (nolock) ON p.CollectionCategoryID = CollectionCategory.CollectionCategoryID 
	LEFT OUTER JOIN Employers (nolock) ON p.EmployerID = Employers.EmployerID 
	LEFT OUTER JOIN PatientReferralSource (nolock) ON p.PatientReferralSourceID = PatientReferralSource.PatientReferralSourceID 

	LEFT join Doctor sp on sp.DoctorID = e.SchedulingProviderID
	left join Doctor supD on supD.DoctorID = e.SupervisingProviderID
	left join Doctor refD on refD.DoctorID = e.ReferringPhysicianID
	LEFT join ServiceLocation sl on sl.ServiceLocationID = e.LocationID
	left join PlaceOfService pos on pos.PlaceOfServiceCode = e.PlaceOfServiceCode

	LEFT JOIN TypeOfService tos on tos.TypeOfServiceCode = ep.TypeOfServiceCode
    
	----- primary ins payment
	LEFT join Payment p1 on p1.PaymentID = c.PrimaryInsPaymentID
	LEFT JOIN #payments cp1 on cp1.claimID = c.claimID and cp1.paymentID = p1.PaymentID
	LEFT JOIN PaymentMethodCode pmc1 on pmc1.PaymentMethodCode = p1.PaymentMethodCode
	LEFT JOIN Category cat1 on cat1.CategoryID = p1.PaymentCategoryID
	LEFT JOIN InsuranceCompanyPlan icp1 on icp1.InsuranceCompanyPlanID = isnull(p1.PayerID,ci.PrimaryInsuranceCompanyPlanID)
	LEFT JOIN InsuranceCompany ic1 on icp1.InsuranceCompanyID = ic1.InsuranceCompanyID
	LEFT JOIN #ClaimEOB eob1 on eob1.ClaimID = c.claimID and eob1.PaymentID = p1.PaymentID
    
	----- secondary ins payment
	LEFT join Payment p2 on p2.PaymentID = c.SecondaryInsPaymentID
	LEFT JOIN #payments cp2 on cp2.claimID = c.claimID and cp2.paymentID = p2.PaymentID
	LEFT JOIN PaymentMethodCode pmc2 on pmc2.PaymentMethodCode = p2.PaymentMethodCode
	LEFT JOIN Category cat2 on cat2.CategoryID = p2.PaymentCategoryID
	LEFT JOIN InsuranceCompanyPlan icp2 on icp2.InsuranceCompanyPlanID = isnull(p2.PayerID,ci.SecondaryInsuranceCompanyPlanID)
	LEFT JOIN InsuranceCompany ic2 on icp2.InsuranceCompanyID = ic2.InsuranceCompanyID
	LEFT JOIN #ClaimEOB eob2 on eob2.ClaimID = c.claimID and eob2.PaymentID = p2.PaymentID

	
    
	left join EncounterDiagnosis ed1 on ed1.PracticeID = ep.PracticeID and ed1.EncounterID = ep.EncounterID AND ed1.EncounterDiagnosisID = ep.EncounterDiagnosisID1 
	left join DiagnosisCodeDictionary dcd1 on dcd1.DiagnosisCodeDictionaryID= ed1.DiagnosisCodeDictionaryID
    
	left join EncounterDiagnosis ed2 on ed2.PracticeID = ep.PracticeID and ed2.EncounterID = ep.EncounterID AND ed2.EncounterDiagnosisID = ep.EncounterDiagnosisID2
	left join DiagnosisCodeDictionary dcd2 on dcd2.DiagnosisCodeDictionaryID= ed2.DiagnosisCodeDictionaryID
    
	left join EncounterDiagnosis ed3 on ed3.PracticeID = ep.PracticeID and ed3.EncounterID = ep.EncounterID AND ed3.EncounterDiagnosisID = ep.EncounterDiagnosisID3 
	left join DiagnosisCodeDictionary dcd3 on dcd3.DiagnosisCodeDictionaryID= ed3.DiagnosisCodeDictionaryID
    
	left join EncounterDiagnosis ed4 on ed4.PracticeID = ep.PracticeID and ed4.EncounterID = ep.EncounterID AND ed4.EncounterDiagnosisID = ep.EncounterDiagnosisID4 
	left join DiagnosisCodeDictionary dcd4 on dcd4.DiagnosisCodeDictionaryID= ed4.DiagnosisCodeDictionaryID
	LEFT JOIN #Adjustment adj on adj.claimID = c.claimID    
	LEFT JOIN #AR_ASN CA ON c.ClaimID=CA.ClaimID
	INNER JOIN Practice prac on prac.PracticeId = c.PracticeId
WHERE
	CollectionCategoryName = 'Collections'
	and CA.PendingPat > 0
		

drop TABLE 
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
