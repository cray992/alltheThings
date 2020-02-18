

declare @EndDate Datetime, @BeginDate Datetime
set @EndDate = '12/12/07'
SET @BeginDate = dateadd(Day, -60, @EndDate);
SET @EndDate = DATEADD(S,-1,DATEADD(D,1, dbo.fn_DateOnly( @EndDate )))

print @BeginDate
print @EndDate




        SELECT
        -- Practice Demographics:
                p.PracticeID,
                p.Name as practiceName,
                p.CreatedDate as practiceCreatedDate,
                p.City as practiceCity,
                p.State as practiceState,
                p.ZipCode as practiceZipCode,
             
                
        --Other Related to Practice:
                (select count(*) from Doctor d where d.PracticeID = p.PracticeID and d.ActiveDoctor = 1 and [external] = 0) as NumberOfActiveProviders,
                et.EditionTypeName as PracticeEditionTypeName,
                p.SupportTypeID, 
                cast( 0 As Money) as PatientAR,
                cast( 0 As Money) as InsuranceAR,
                cast( 0 As Money) as TotalAR,
                cast( 0 As Money) as ARover60Days,
                cast( 0 As INT) as PatientStatement
        -- Clearinghouse - If there is some way to determine the "primary" clearinghouse used by the practice, which I realize might be hard to determine, then please include this as it would help us see if customers are likely to get better DRO from one clearinghouse then another.
        INTO #Practice
        FROM Practice p
                left join editionType et on et.EditionTypeID = p.editionTypeID
        where p.Active = 1 
                        
                        
        -- Payment                
        select p.PracticeID,
                SUM(case when p.PayerTypeCode = 'P' THEN PaymentAmount ELSE 0 END) as PatientPayments,
                SUM(case when p.PayerTypeCode = 'I' THEN PaymentAmount ELSE 0 END) as InsurancePayments,
                sum( case when p.ClearinghouseResponseID is not null then PaymentAmount else 0 end ) as InsurancePaymentsLinkedToERA,
                sum( PaymentAmount) as  TotalPayments
        INTO #Payment      
        FROM Payment p
        WHERE postingDate between @BeginDate AND @EndDate
        group by p.PracticeID
        
        
        
        select 
                p.practiceID,
				ca.ProviderID,
                SUM(case when p.PayerTypeCode = 'P' THEN ca.Amount ELSE 0 END) as PatientPaymentApplications,
                SUM(case when p.PayerTypeCode = 'I' THEN ca.Amount ELSE 0 END) as InsurancePaymentsApplications,
                sum( case when p.ClearinghouseResponseID is not null then ca.Amount else 0 end ) as InsurancePaymentsLinkedToERAApplications,
                sum( Amount ) as  TotalPaymentsApplications
        INTO #PaymentApplication
        from ClaimAccounting ca
                inner join payment p on p.PracticeID = ca.PracticeID and ca.PaymentID = p.PaymentID
        WHERE  ClaimTransactionTypeCode = 'PAY'
                AND p.postingDate between @BeginDate AND @EndDate
        group by p.PracticeID,
			ca.ProviderID
        
        
        
        
        
        select doctorID,
                d.PracticeID,
                ISNULL(d.Prefix + ' ', '')  + ISNULL(d.FirstName, '') + ISNULL(' '+d.MiddleName, '') + ISNULL(' ' + d.LastName, '') + ISNULL(', ' + d.Degree, '') AS ProviderFullName, 
                d.createdDate as providerCreatedDate,
                ProviderTypeName as ProviderTypeID,
                TaxonomySpecialtyName as ProviderSpecialityName,
                TaxonomyCodeClassification as ProviderSpecialityClassification,
                ISNULL(TaxonomyCodeDesc,TaxonomySpecialtyDesc) as ProviderSpecialityDescription
        INTO #Doctor                
        from Doctor d
                LEFT join TaxonomyCode tc on d.TaxonomyCode = tc.TaxonomyCode
                LEfT JOIN TaxonomySpecialty ts on ts.TaxonomySpecialtyCode = tc.TaxonomySpecialtyCode                       
                LEFT JOIN providerType pt on pt.ProviderTypeID = d.ProviderTypeID
        where d.ActiveDoctor = 1 and [external] = 0
        
        
        
        
----------------------------- AR Stuff --------------------------

	--Get Last Assignments
	CREATE TABLE #ASNMax (PracticeID Int, ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #ASNMax(PracticeID, ClaimID, ClaimTransactionID)
	SELECT PracticeID, CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Assignments CAA 
	WHERE caa.PostingDate<=@EndDate
	GROUP BY PracticeID, CAA.ClaimID
	
	CREATE TABLE #ASN (PracticeID INT, ClaimID INT, PostingDate DATETIME, InsurancePolicyID INT, InsuranceCompanyPlanID INT, InsuranceCompanyID INT ) 
	INSERT INTO #ASN(PracticeID, ClaimID, InsurancePolicyID, InsuranceCompanyPlanID)
	SELECT am.PracticeID, 
        CAA.ClaimID, 
	caa.InsurancePolicyID,
	caa.InsuranceCompanyPlanID
	FROM ClaimAccounting_Assignments CAA 
		INNER JOIN #ASNMax AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
	WHERE CAA.PostingDate<=@EndDate



	CREATE TABLE #AR_ASN (PaymentID INT, RespID INT, ClaimID INT, AppliedAmount MONEY, InsAmount MONEY, PatAmount MONEY, UnasgnAmount MONEY, PostingDate Datetime, ServiceDate Datetime, ServicePostingDate Datetime, TypeCode char(1) )
	CREATE TABLE #AR (PaymentID INT, RespID INT, ClaimID INT, ARAmount MONEY, PostingDate Datetime, ServiceDate Datetime, ServicePostingDate Datetime, TypeGroup varchar(20), TypeSort INT)

			-- Insurance Repsonbility
			INSERT INTO #AR_ASN(PaymentID, RespID, AppliedAmount, ClaimID, PostingDate, UnasgnAmount, InsAmount, PatAmount, TypeCode)
			SELECT	
					PaymentID = CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN PMT.PaymentID ELSE NULL END,
					RespID = case when ClaimTransactionTypeCode = 'PAY' AND PayerTypeCode='P' THEN PayerID 
								ELSE Case when asn.ClaimID IS NULL THEN NULL ELSE ISNULL(asn.InsurancePolicyID, ca.PatientID) END
								END,
					AppliedAmount = SUM(CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN -1 * Amount ELSE 0 END),
					ca.ClaimID, 
					CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN PMT.PostingDate ELSE ca.PostingDate END,
					UnasgnAmount = SUM( case when asn.CLaimID IS NULL THEN
											case when ClaimTransactionTypeCode = 'CST' THEN amount else -1*Amount END 
											ELSE 0 
											END ),
					InsAmount = SUM(	CASE 
								WHEN asn.CLaimID IS NULL THEN 0 -- 'Unassigned'
								WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' -- Exclude patient payment against total
									THEN 0
								WHEN InsurancePolicyID IS NOT NULL 
									THEN CASE WHEN ClaimTransactionTypeCode='CST' THEN AMOUNT ELSE -1*AMOUNT END
								ELSE 0
							END
							),
					PatAmount = SUM(	CASE 
									WHEN asn.CLaimID IS NULL THEN 0 -- 'Unassigned'				
				
									-- Copay will always increase's a Patient's balance.
									WHEN ClaimTransactionTypeCode = 'PRC'
										THEN	-- This prevents from adding the PRC + CST. Copay increases the patient's balance, but when the claim is assinged to the patient, 
												-- then we ignore it because the CST will be used later. 
												-- Otherwise, if the claim is assigned to the insurance, we increase the patient's balance by the PRC amount
												case WHEN InsurancePolicyID IS NULL -- when claim is assigned to insurance, we add the PRC amount
													THEN 0
													ELSE Amount
												END
									WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P'  -- Include patient payment against total
										THEN Amount*-1
									WHEN InsurancePolicyID IS NULL -- Assinged to Copay
										THEN  CASE WHEN ClaimTransactionTypeCode = 'CST' THEN Amount ELSE Amount*-1 END 
									ELSE 0 
								END
								),
				case when ClaimTransactionTypeCode = 'PAY' AND PayerTypeCode='P' THEN PayerTypeCode -- payment
					ELSE case when InsurancePolicyID IS NULL then 'P' else 'I' end
					END
			FROM ClaimAccounting  ca (nolock)
				LEFT JOIN Payment PMT   (nolock) ON PMT.PaymentID = ca.PaymentID
				LEFT JOIN #ASN asn  (nolock) ON asn.ClaimID = ca.ClaimID
			WHERE  (
                                        ( ClaimTransactionTypeCode = 'PAY' AND PMT.PostingDate <= @EndDate) 
                                        OR (ClaimTransactionTypeCode <> 'PAY' AND ca.PostingDate <=@EndDate )
                                )
				AND ClaimTransactionTypeCode IN ('PAY', 'ADJ', 'CST')
			GROUP BY CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN PMT.PaymentID ELSE NULL END, 
					case when ClaimTransactionTypeCode = 'PAY' AND PayerTypeCode='P' THEN PayerID 
						ELSE Case when asn.ClaimID IS NULL THEN NULL ELSE ISNULL(asn.InsurancePolicyID, ca.PatientID) END
						END,
					ca.ClaimID, 
					(CASE WHEN ClaimTransactionTypeCode = 'PAY' THEN PMT.PostingDate ELSE ca.PostingDate END), 
					case when ClaimTransactionTypeCode = 'PAY' AND PayerTypeCode='P' THEN PayerTypeCode -- payment
						ELSE case when InsurancePolicyID IS NULL then 'P' else 'I' end
						END





	
			SELECT PatientID, ClaimID, max(PostingDate) PostingDate, sum(Amount) Amount 
			INTO #Copay
			FROM ClaimAccounting  (nolock)
			WHERE PostingDate <= @endDate 
                                AND ClaimTransactionTypeCode = 'PRC'
			GROUP BY PatientID, ClaimID

			-- Copay 
			INSERT #AR_ASN( RespID, ClaimID, PostingDate, InsAmount, PatAmount, TypeCode)
			select PatientID, asn.ClaimID, ca.PostingDate, 
				insAmount = -1 * ca.amount,
				patAmount = ca.amount,
				'P'
			from 
				#Copay ca
				INNER JOIN (Select distinct ClaimID FROM #AR_ASN WHERE TypeCode = 'I') as asn 
					ON ca.ClaimID = asn.ClaimID





			-- Insurance's responsibility
			INSERT INTO #AR(RespID, PaymentID, ClaimID, PostingDate, ServiceDate, ServicePostingDate, ARAmount, TypeGroup, TypeSort)
			SELECT	RespID,
				PaymentID, ClaimID, PostingDate, ServiceDate, ServicePostingDate,
				insAmount,
				TypeGroup = 'Insurance', 
				TypeSort = 1
			FROM #AR_ASN
			where insAmount <> 0



			-- Patient's responsibility
			INSERT INTO #AR(RespID, PaymentID, ClaimID, PostingDate, ServiceDate, ServicePostingDate, ARAmount, TypeGroup, TypeSort)
			SELECT	RespID,
					PaymentID, ClaimID, PostingDate, ServiceDate, ServicePostingDate,
					patAmount,
					TypeGroup = 'Patient', 
					TypeSort = 2
			FROM #AR_ASN
			where patAmount <> 0


			-- Unassigned
			INSERT INTO #AR(RespID, PaymentID, ClaimID, PostingDate, ServiceDate, ServicePostingDate, ARAmount, TypeGroup, TypeSort)
			SELECT	RespID,
					PaymentID, ClaimID, PostingDate, ServiceDate, ServicePostingDate,
					UnasgnAmount,
					TypeGroup = 'Unassigned', 
					TypeSort = 4
			FROM #AR_ASN
			where UnasgnAmount <> 0




	-- Get Date of AR based on DateType Selection
	CREATE TABLE #BLL(ClaimID INT, PostingDate DATETIME, TypeGroup varchar(20) )

	--Get Last Billed Info
	CREATE TABLE #BLLMax (ClaimID INT, ClaimTransactionID INT, TypeGroup varchar(20) )
	INSERT INTO #BLLMax(ClaimID, ClaimTransactionID, TypeGroup)
	SELECT CAB.ClaimID, MIN(ClaimTransactionID) ClaimTransactionID,
		case when BatchType = 'S' THEN 'Patient' ELSE 'Insurance' END
	FROM ClaimAccounting_Billings CAB INNER JOIN (Select distinct ClaimID FROM #AR) AR ON CAB.ClaimID=AR.ClaimID
	WHERE cab.PostingDate<=@EndDate 
	GROUP BY CAB.ClaimID, 
		case when BatchType = 'S' THEN 'Patient' ELSE 'Insurance' END
	

	INSERT #BLL(ClaimID, PostingDate, TypeGroup)
	SELECT CAB.ClaimID, CAB.PostingDate, bm.TypeGroup
	FROM ClaimAccounting_Billings CAB 
                INNER JOIN #BLLMax BM ON CAB.ClaimTransactionID=BM.ClaimTransactionID
	WHERE CAB.PostingDate<=@EndDate

	DROP TABLE #BLLMax
        
        
        -----------------  Calc Unapplied amounts -----------
	SELECT	ca.PaymentID, 
	        SUM(  -1 * Amount ) AppliedAmount
	INTO #AppliedReceipts
	FROM ClaimAccounting ca (nolock)
		INNER JOIN Payment p on p.PracticeID = ca.PracticeID AND ca.PaymentID = p.PaymentID
	WHERE ( 
                        p.PostingDate <= @endDate 
                        OR ca.PostingDate <= @endDate 
                )
		AND ClaimTransactionTypeCode = 'PAY'
	GROUP BY ca.PaymentID




	SELECT PracticeID, PayerID, PayerTypeCode, SUM(PaymentAmount) AS PaymentAmount
	INTO #SummarizedUnapplied
	FROM	(
                        SELECT  p.PracticeID, 
                                PayerTypeCode, 
                                PayerID,
                                PaymentAmount = SUM(  ISNULL(PaymentAmount, 0) + ISNULL(a.AppliedAmount, 0) )
                        FROM  Payment P
                                LEFT OUTER JOIN #AppliedReceipts AS a ON a.PaymentID = p.PaymentID
                        WHERE p.PostingDate <= @EndDate
                        GROUP BY   p.PracticeID, p.PayerTypeCode, p.PayerID

                        UNION ALL


                        select  p.PracticeID, PayerTypeCode, p.PayerID, sum(-1 * rtp.amount)
                        from refund r 
                                INNER jOIn refundToPayments rtp on r.RefundID = rtp.RefundID
                                INNER JOIN Payment p on  p.practiceID = r.practiceID AND p.PaymentID = rtp.PaymentID
                        WHERE rtp.PostingDate <= @EndDate 
                                AND r.RefundStatusCode = 'I'
                        group by  p.PracticeID, p.PayerID, payerTypeCode

                        UNION ALL

                        select  p.PracticeID, PayerTypeCode, PayerID, sum(-1 * rtp.amount)
                        from CapitatedAccountToPayment rtp
                                INNER JOIN Payment p on  p.PaymentID = rtp.PaymentID
                        WHERE rtp.PostingDate <= @EndDate 
                        group by  p.PracticeID, p.PayerID, payerTypeCode


				) AS V
	GROUP BY  PracticeID, PayerID, PayerTypeCode




	CREATE TABLE #ReportResults(PracticeID Int, RespID INT, TypeGroup VARCHAR(128), TypeSort INT, Unapplied MONEY,
	CurrentBalance MONEY, Age31_60 MONEY, Age61_90 MONEY, Age91_120 MONEY, AgeOver120 MONEY, TotalBalance MONEY)
	INSERT INTO #ReportResults(PracticeID, RespID, TypeGroup, TypeSort, Unapplied, CurrentBalance, Age31_60, Age61_90, Age91_120, 
	        AgeOver120, TotalBalance)
	SELECT PracticeID, RespID, ISNULL(ar.TypeGroup, 'Unassigned'), ISNULL(TypeSort, 4), 0 Unapplied,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 0 AND 30 OR BLL.PostingDate IS NULL THEN ARAmount ELSE 0 END) CurrentBalance,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 31 AND 60 THEN ARAmount ELSE 0 END) Age31_60,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 61 AND 90 THEN ARAmount ELSE 0 END) Age61_90,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 91 AND 120 THEN ARAmount ELSE 0 END) Age91_120,
		SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) >=121 THEN ARAmount ELSE 0 END) AgeOver120,
	SUM(ARAmount) TotalBalance
	FROM #AR AR 
		LEFT JOIN #ASN ASN ON AR.ClaimID=ASN.ClaimID
		LEFT JOIN #BLL BLL ON AR.ClaimID=BLL.ClaimID 
				AND bll.TypeGroup = ar.TypeGroup	
        WHERE ar.ClaimID NOT in (select ClaimID FROm #AR_ASN group by ClaimID having 0 = sum(UnasgnAmount) + sum(InsAmount) + sum(PatAmount) )
	GROUP BY PracticeID, RespID, ar.TypeGroup, TypeSort
        having sum(ARAmount) <> 0


--         ---------- Adds Unapplied Payment                                                                                                                                       
	INSERT INTO #ReportResults( practiceID, RespID, TypeGroup, Unapplied, TotalBalance)
	SELECT  su.PracticeID,
                PayerID,
		TypeGroup = (CASE SU.PayerTypeCode WHEN  'I' THEN 'Insurance' WHEN 'P' THEN 'Patient' ELSE 'Other' END),
		sum(SU.PaymentAmount), 
                sum(-1* PaymentAmount)
	FROM #SummarizedUnapplied SU
        group by su.PracticeID, PayerID, (CASE SU.PayerTypeCode WHEN  'I' THEN 'Insurance' WHEN 'P' THEN 'Patient' ELSE 'Other' END)
        having sum(SU.PaymentAmount) <> 0
--         ----------- End Adds Unapplied Payment

                
        update p
        set InsuranceAR = rr.TotalBalance
        from (	
                SELECT PracticeID, TypeGroup, SUM(TotalBalance) TotalBalance
                FROM #ReportResults
                GROUP BY PracticeID, TypeGroup
                ) as rr
        inner join #practice p on p.practiceID = rr.PracticeID
        WHERE TypeGroup = 'Insurance'
             
        
        update p
        set PatientAR = rr.TotalBalance
        from (	
                SELECT PracticeID, TypeGroup, SUM(TotalBalance) TotalBalance
                FROM #ReportResults
                GROUP BY PracticeID, TypeGroup
                ) as  rr
        inner join #practice p on p.practiceID = rr.PracticeID
        WHERE TypeGroup = 'Patient'
        
        
        update p
        set TotalAR = rr.TotalBalance
        from (	SELECT PracticeID, SUM(TotalBalance) TotalBalance
                FROM #ReportResults
                GROUP BY PracticeID) as  rr
        inner join #practice p on p.practiceID = rr.PracticeID
        
        
        
        update p
        set ARover60Days = Over60Days
        from #practice p 
                inner join (select practiceID, sum( Age61_90 + Age91_120 + AgeOver120 ) AS Over60Days 
                                from #ReportResults group by PracticeID
                                ) as rr 
                        on p.practiceID = rr.PracticeID
                       
        
        
        
	DROP TABLE #AR, #AR_ASN
	DROP TABLE #ASN
	DROP TABLE #ASNMax
	DROP TABLE #BLL
	DROP TABLE #ReportResults
	DROP TABLE #SummarizedUnapplied
	DROP TABLE #AppliedReceipts, #Copay
        
        
        
        

        
        
        

        
        update P
        SET patientStatement = f.patientStatement
        FROM #practice p
        inner join      
        (
                SELECT PracticeID, sum(PatientStatement) patientStatement
                From 
                (
                                        
                        SELECT BB.PracticeID, BB.BillBatchID, count(distinct BS.PatientID) as patientStatement
                        FROM BillBatch BB 
                        INNER JOIN Bill_Statement BS
                                ON BB.BillBatchID=BS.BillBatchID
                        INNER JOIN BillTransmission BT
                                ON BB.BillBatchID=BT.ReferenceID 
                                AND BT.BillTransmissionFileTypeCode='P'
                        WHERE BB.ConfirmedDate BETWEEN @BeginDate AND @EndDate 
                                AND BB.BillBatchTypeCode='S'
                                AND BS.Active=1 AND LEFT(BT.FileName,4)<>'test'
                        GROUP BY BB.PracticeID, BB.BillBatchID
                
                
                ) as v
                group by PracticeID
        ) as f on f.PracticeID = p.PracticeID
        
        

	SELECT PracticeID, 
                sum( case when createdUserID =  1526 THEN 1 ELSE 0 END ) as FaxedDocuments,
                sum( case when DocumentTypeID = 1 AND createdUserID <> 1526 THEN 1 ELSE 0 END ) as ScannedDocuments,
                sum( case when DocumentTypeID = 2 AND createdUserID <> 1526 THEN 1 ELSE 0 END ) as FileDocuments,
                count( * ) as TotalDocuments
        INTO #DMSUsage              
	FROM DMSDocument DD 
	WHERE   DD.CreatedDate BETWEEN @BeginDate AND @EndDate 
                AND DD.PracticeID IS NOT NULL
	GROUP BY PracticeID
  


	SELECT PracticeID, 
                CAST(ROUND(SUM(DF.SizeInBytes)/1048576.00,2) AS DECIMAL(9,2)) as DMSStorage_MB
        INTO #DMSStorageUsage                
	FROM DMSDocument DD 
        INNER JOIN DMSFileInfo DF
	        ON DD.DMSDocumentID=DF.DMSDocumentID
	WHERE   DD.CreatedDate BETWEEN @BeginDate AND @EndDate 
                AND SizeInBytes IS NOT NULL 
                AND ISNUMERIC(SizeInBytes)=1 
                AND DD.PracticeID IS NOT NULL
	GROUP BY PracticeID


	SELECT cr.PracticeID, SUM(CR.ItemCount) ERAQty
        INTO #ERA
	FROM ClearinghouseResponse CR
	WHERE CR.FileReceiveDate BETWEEN @BeginDate AND @EndDate 
                AND CR.ResponseType = 33 
                AND CR.ClearinghouseResponseReportTypeID = 2
	GROUP BY PracticeID
        
        
        
        
        select e.practiceID,
                count(distinct e.encounterID) as Encounters,
                count(*) as TotalClaimsCreated
        INTO #Encounter               
        FROM Encounter e
			inner join encounterProcedure ep 
				on ep.practiceID = e.practiceID 
				AND ep.encounterID = e.EncounterID
        where EncounterStatusID <> 1
              and e.createdDate between @BeginDate and @EndDate
        GROUP BY e.PracticeID
        
        
        
        
        
 
--------------------------- EClaim stuff ---------------        
       
        declare @CustomerID Int, @CustomerName varchar(max), 
			@CustomerCreatedDate datetime, @SupportTypeCaption varchar(80),
			@ClearinghouseConnectionID INT
			
 
 
        select @CustomerID = customerID, @CustomerName = CompanyName, @CustomerCreatedDate = createdDate, @SupportTypeCaption = SupportTypeCaption
        FROM sharedServer.Superbill_Shared.dbo.Customer c
			LEFT JOIN sharedServer.Superbill_Shared.dbo.SupportType st on st.SupportTypeID = c.SupportTypeID
        WHERE c.DatabaseName = db_name()
                and c.DatabaseServerName in (select Name from sys.servers where server_id = 0)
        
        
        
	--Eligibility Checks
	CREATE TABLE #Eligibility(CustomerID INT, PracticeID INT, PatientID INT, PatientCaseID INT, InsurancePolicyID INT, InsuranceCompanyID INT, InsuranceCompanyPlanID INT)
	INSERT INTO #Eligibility(CustomerID, PracticeID, PatientID, PatientCaseID, InsurancePolicyID, InsuranceCompanyID, InsuranceCompanyPlanID)
	SELECT CustomerID, PracticeID, PatientID, CaseID PatientCaseID, InsurancePolicyID, InsuranceCompanyID, InsuranceCompanyPlanID
	FROM sharedserver.Superbill_Shared.dbo.EligibilityTransactionLog EL
	WHERE EL.CustomerID=@CustomerID AND EL.TransactionDate BETWEEN @BeginDate AND @EndDate

	--Check for Association with PatientCase
	UPDATE E SET PracticeID=PC.PracticeID
	FROM #Eligibility E INNER JOIN PatientCase PC
	ON E.PatientCaseID=PC.PatientCaseID
	WHERE E.PracticeID IS NULL

	--Check for Association with Patient
	UPDATE E SET PracticeID=P.PracticeID
	FROM #Eligibility E INNER JOIN Patient P
	ON E.PatientID=P.PatientID
	WHERE E.PracticeID IS NULL

	--Check for Association with InsurancePolicy
	UPDATE E SET PracticeID=IP.PracticeID
	FROM #Eligibility E INNER JOIN InsurancePolicy IP
	ON E.InsurancePolicyID=IP.InsurancePolicyID
	WHERE E.PracticeID IS NULL


      
        
        
        CREATE TABLE #Submissions(BillBatchID INT, CustomerID INT, PracticeID INT, BillID INT, ReferenceID INT, PayerNumber VARCHAR(30), ZNumber BIT, ClearinghouseID INT)
        CREATE TABLE #PGR_ClaimData(PayerGatewayResponseID INT, CustomerID INT, PracticeID INT, ReferenceID INT, PayerNumber VARCHAR(30), ZNumber BIT, ClearingHouseID INT)
        
	INSERT INTO #Submissions(BillBatchID, CustomerID, PracticeID, BillID, ReferenceID, PayerNumber, ZNumber)
	EXECUTE BIZCLAIMSDBSERVER_REPORTING.Kareobizclaims..BC_CompanyMetrics_Billing_EClaimsSubmissions @BeginDate,@EndDate,@CustomerID


	INSERT INTO #PGR_ClaimData(PayerGatewayResponseID, CustomerID, PracticeID, ReferenceID, PayerNumber, ZNumber)
	EXECUTE BIZCLAIMSDBSERVER_REPORTING.Kareobizclaims..BC_CompanyMetrics_Billing_EClaimsRejections @BeginDate,@EndDate,@CustomerID


        update s
        SET ClearinghouseID = cpl.ClearinghouseID
        from #Submissions s
        inner join Bill_EDI b 
                on b.BillBatchID = s.BillBatchID 
                and b.BillID = s.BillID
        inner join InsurancePolicy ip 
                on ip.InsurancePolicyID = b.PayerInsurancePolicyID
        inner join InsuranceCompanyPlan icp 
                on icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
        inner join InsuranceCompany ic 
                on ic.InsuranceCompanyID = icp.InsuranceCompanyID
        inner join ClearinghousePayersList cpl 
                on cpl.ClearinghousePayerID = ic.ClearinghousePayerID

--         update r
--         SET ClearinghouseID = cpl.ClearinghouseID
--         from #PGR_ClaimData r
--                 inner join ClearinghousePayersList as cpl on cpl.PayerNumber = r.PayerNumber
--        
         
        --- ClaimAssignment
        Select  ZNumber, s.ReferenceID, count(*) as NumOfAssignment
        INTO #ASN_eClaim
        from ClaimAccounting_Assignments caa
                inner join #Submissions s 
                        on s.ReferenceID = caa.ClaimID
                        and s.PracticeID = caa.PracticeID
        WHERE S.ZNumber=0 
        GROUP BY  ZNumber, s.ReferenceID
        

        insert into #ASN_eClaim
        Select ZNumber, s.ReferenceID, count(*) as NumOfAssignment
        from    
                (select ep.PracticeID, ep.EncounterID, min(ClaimID) as ClaimID
                FROM encounterProcedure ep 
                inner join claim c
                        on c.practiceID = ep.practiceID 
                        AND c.EncounterProcedureID = ep.EncounterProcedureID 
                GROUP BY ep.PracticeID, ep.EncounterID
                ) as e 
                inner join #Submissions s 
                        on s.ReferenceID = e.EncounterID
                        and s.PracticeID = e.PracticeID
                INNER JOIN ClaimAccounting_Assignments caa
                        ON caa.PracticeID = e.PracticeID
                        AND caa.ClaimID = e.ClaimID
        WHERE S.ZNumber=1
        GROUP BY  ZNumber, s.ReferenceID
        
        

       
        
        
        --- ClaimAssignment
        Select ZNumber, s.ReferenceID, count(*) as NumOfAssignment
        INTO #ASN_PGR
        from ClaimAccounting_Assignments caa
                inner join #PGR_ClaimData s 
                        on s.ReferenceID = caa.ClaimID
                        and s.PracticeID = caa.PracticeID
        WHERE S.ZNumber=0 
        GROUP BY ZNumber, s.ReferenceID
        
        
        insert into #ASN_PGR
        Select ZNumber, s.ReferenceID, count(*) as NumOfAssignment
        from    
                (select ep.PracticeID, ep.EncounterID, min(ClaimID) as ClaimID
                FROM encounterProcedure ep 
                inner join claim c
                        on c.practiceID = ep.practiceID 
                        AND c.EncounterProcedureID = ep.EncounterProcedureID 
                GROUP BY ep.PracticeID, ep.EncounterID
                ) as e 
                inner join #PGR_ClaimData s 
                        on s.ReferenceID = e.EncounterID
                        and s.PracticeID = e.PracticeID
                INNER JOIN ClaimAccounting_Assignments caa
                        ON caa.PracticeID = e.PracticeID
                        AND caa.ClaimID = e.ClaimID
        WHERE S.ZNumber=1
        GROUP BY  ZNumber, s.ReferenceID
        
        
        
        
        
	CREATE TABLE #EClaimsMetrics_PartI(PracticeID INT, DoctorID INT, 
                CH_PROXYMED INT,
                CH_OFFICEALLY INT,
                CH_GATEWAYEDI INT,
                EClaims INT, PrimaryEClaim Int, SecondaryEClaim Int)
        
	INSERT INTO #EClaimsMetrics_PartI(PracticeID, DoctorID,                 
                CH_PROXYMED,
                CH_OFFICEALLY,
                CH_GATEWAYEDI,
                EClaims, PrimaryEClaim, SecondaryEClaim)
	SELECT S.PracticeID, e.DoctorID DoctorID, 
                sum( case when ClearinghouseID = 1 then 1 else 0 end),
                sum( case when ClearinghouseID = 2 then 1 else 0 end),
                sum( case when ClearinghouseID = 3 then 1 else 0 end),
                COUNT(S.ReferenceID) EClaims,
                sum(case when a.NumOfAssignment = 1 THEN 1 ELSE 0 END ) as PrimaryEClaim,
                sum(case when a.NumOfAssignment > 1 THEN 1 ELSE 0 END ) as SecondaryEClaim
	FROM #Submissions S 
        INNER JOIN Claim CA
	        ON S.PracticeID=CA.PracticeID 
                AND S.ReferenceID=CA.ClaimID 
        inner join EncounterProcedure ep
                on ep.PracticeID = CA.PracticeID
                and ep.EncounterProcedureID = CA.EncounterProcedureID
        inner join Encounter e
                on e.EncounterID = ep.EncounterID
                and e.PracticeID = ep.PracticeID
        INNER JOIN #ASN_eClaim a
                On s.ReferenceID = a.ReferenceID
                AND S.ZNumber = a.ZNumber
	WHERE S.ZNumber=0 
	GROUP BY S.PracticeID, e.DoctorID
        
        

	INSERT INTO #EClaimsMetrics_PartI(PracticeID, DoctorID,                 
                CH_PROXYMED,
                CH_OFFICEALLY,
                CH_GATEWAYEDI,
                EClaims, PrimaryEClaim, SecondaryEClaim)
	SELECT S.PracticeID, E.DoctorID, 
                sum( case when ClearinghouseID = 1 then 1 else 0 end),
                sum( case when ClearinghouseID = 2 then 1 else 0 end),
                sum( case when ClearinghouseID = 3 then 1 else 0 end),
                COUNT(S.ReferenceID) EClaims,
                sum(case when a.NumOfAssignment = 1 THEN 1 ELSE 0 END ) as PrimaryEClaim,
                sum(case when a.NumOfAssignment > 1 THEN 1 ELSE 0 END ) as SecondaryEClaim
	FROM #Submissions S 
        INNER JOIN Encounter E
	        ON S.PracticeID=E.PracticeID 
                AND S.ReferenceID=E.EncounterID
        INNER JOIN #ASN_eClaim a
                On s.ReferenceID = a.ReferenceID
                AND S.ZNumber = a.ZNumber
        inner join Bill_EDI b 
                on b.BillBatchID = s.BillBatchID 
                and b.BillID = s.BillID
	WHERE S.ZNumber=1
	GROUP BY S.PracticeID, E.DoctorID




	INSERT INTO #EClaimsMetrics_PartI(PracticeID, DoctorID, 
                CH_PROXYMED,
                CH_OFFICEALLY,
                CH_GATEWAYEDI,
                EClaims, PrimaryEClaim, SecondaryEClaim)
	SELECT R.PracticeID, e.DoctorID,
                sum( case when ClearinghouseID = 1 then -1 else 0 end),
                sum( case when ClearinghouseID = 2 then -1 else 0 end),
                sum( case when ClearinghouseID = 3 then -1 else 0 end),
                COUNT(R.PayerGatewayResponseID)*-1 EClaims,
                sum(case when a.NumOfAssignment = 1 THEN 1 ELSE 0 END )*-1 as PrimaryEClaim,
                sum(case when a.NumOfAssignment > 1 THEN 1 ELSE 0 END )*-1 as SecondaryEClaim
	FROM #PGR_ClaimData R 
        INNER JOIN Claim CA
	        ON R.PracticeID=CA.PracticeID 
                AND R.ReferenceID=CA.ClaimID 
        inner join EncounterProcedure ep
                on ep.PracticeID = CA.PracticeID
                and ep.EncounterProcedureID = CA.EncounterProcedureID
        inner join Encounter e
                on e.EncounterID = ep.EncounterID
                and e.PracticeID = ep.PracticeID
        INNER JOIN #ASN_eClaim a
                On r.ReferenceID = a.ReferenceID
                AND r.ZNumber = a.ZNumber
	WHERE R.ZNumber=0
	GROUP BY R.PracticeID, e.doctorID


	INSERT INTO #EClaimsMetrics_PartI(PracticeID, DoctorID,
                CH_PROXYMED,
                CH_OFFICEALLY,
                CH_GATEWAYEDI,
                EClaims, PrimaryEClaim, SecondaryEClaim)
	SELECT R.PracticeID, E.DoctorID, 
                sum( case when ClearinghouseID = 1 then -1 else 0 end),
                sum( case when ClearinghouseID = 2 then -1 else 0 end),
                sum( case when ClearinghouseID = 3 then -1 else 0 end),
                COUNT(R.PayerGatewayResponseID)*-1 EClaims,
                sum(case when a.NumOfAssignment = 1 THEN 1 ELSE 0 END )*-1 as PrimaryEClaim,
                sum(case when a.NumOfAssignment > 1 THEN 1 ELSE 0 END )*-1 as SecondaryEClaim
	FROM #PGR_ClaimData R 
                INNER JOIN Encounter E
	        ON R.PracticeID=E.PracticeID 
                AND R.ReferenceID=E.EncounterID
        INNER JOIN #ASN_eClaim a
                On r.ReferenceID = a.ReferenceID
                AND r.ZNumber = a.ZNumber
	WHERE R.ZNumber=1
	GROUP BY R.PracticeID, E.DoctorID, PayerNumber

	
	SELECT P.PracticeID, 
                DoctorID,
                SUM(CH_PROXYMED) CH_PROXYMED,
                SUM(CH_OFFICEALLY) CH_OFFICEALLY,
                SUM(CH_GATEWAYEDI) CH_GATEWAYEDI,
                SUM(E.EClaims) EClaimsTotal,
                SUM(E.PrimaryEClaim) PrimaryEClaim,
                SUM(E.SecondaryEClaim) SecondaryEClaim
        INTO #EClaims
	FROM #EClaimsMetrics_PartI E INNER JOIN Practice P
	ON E.PracticeID=P.PracticeID
	WHERE P.Metrics=1 AND P.Active=1
	GROUP BY P.PracticeID, DoctorID
        
                
        
-- 
-- 
--         select e.PracticeID, e.doctorID, count(Distinct ct.ClaimID) as RejectedClaim
--         INTO #RejectedClaim
--         from ClaimTransaction ct
--                 inner join claim c on c.practiceID = ct.practiceID AND c.claimID = ct.claimID
--                 inner join encounterProcedure ep On c.practiceID = ep.practiceID ANd c.encounterprocedureID = ep.encounterprocedureID
--                 inner join encounter e on e.practiceID = ep.practiceID AND e.encounterID = ep.EncounterID
--         where ClaimTransactionTypeCode = 'RJT'
--                 and ct.postingDate between @BeginDate and @EndDate
--         group by e.PracticeID, e.doctorID
--               
        
        
        select  case when  isnull( charindex( 'Z', ClaimK9Number), 0) >= 1 THEN left(ClaimK9Number, charindex( 'Z', ClaimK9Number) - 1 ) ELSE NULL END as EncounterID
        INTO #Rej
        FROM   BIZCLAIMSDBSERVER.KareoBizClaims.dbo.PayerGatewayResponse PGR WITH(NOLOCK)
        WHERE (PGR.PayerGatewayResponseTypeCode = 'ch-prc') AND (CAST(PGR.PayerProcessingStatus AS varchar) = 'REJ')
        AND PGR.CreatedDate BETWEEN @BeginDate and @EndDate
        and CustomerId = @BeginDate
        and 1=isnumeric( case when  isnull( charindex( 'Z', ClaimK9Number), 0) >= 1 THEN left(ClaimK9Number, charindex( 'Z', ClaimK9Number) - 1 ) ELSE NULL END )
              
        select e.PracticeID, e.doctorID, count(*) as RejectedClaim
        into #RejectedClaim
        from Encounter e
                inner join #Rej r on e.encounterID = r.encounterID
        group by e.PracticeID, e.doctorID

        
  
              
              
        select e.practiceID, e.doctorID, count(Distinct e.encounterID) as DeniedEncounters
        INTO #DeniedClaim
        from ClaimTransaction ct
                inner join claim c on c.practiceID = ct.practiceID AND c.claimID = ct.claimID
                inner join encounterProcedure ep On c.practiceID = ep.practiceID ANd c.encounterprocedureID = ep.encounterprocedureID
                inner join encounter e on e.practiceID = ep.practiceID AND e.encounterID = ep.EncounterID
        where ClaimTransactionTypeCode = 'DEN'
                and ct.postingDate between @BeginDate and @EndDate
        group by e.practiceID, e.doctorID
        

        select e.practiceID, e.doctorID, count(Distinct ct.ClaimID) as PaperClaim
        INTO #PaperClaim
        from ClaimAccounting_Billings ct
                inner join claim c on c.practiceID = ct.practiceID AND c.claimID = ct.claimID
                inner join encounterProcedure ep On c.practiceID = ep.practiceID ANd c.encounterprocedureID = ep.encounterprocedureID
                inner join encounter e on e.practiceID = ep.practiceID AND e.encounterID = ep.EncounterID
        where BatchType = 'P'
                and ct.postingDate between @BeginDate and @EndDate
        group by e.practiceID, e.doctorID
        
        
        
        drop Table #ASN_eClaim, 
                #ASN_PGR, 
                #PGR_ClaimData, 
                #EClaimsMetrics_PartI,
                #Submissions, #Rej
---------------------------END OF  EClaim stuff ---------------
                

        
-------------------------- Patient Balance Summary -----------------------
	---- =================================
	---- ReportDataProvider_PatientDemographicExport uses this as an output
	---- ====================================
	select @EndDate = dateadd(s, -1, dateadd(d, 1, convert(varchar, @EndDate, 1)))


	
	CREATE TABLE #AR_Bal (ClaimID INT, Amount MONEY)
	create table #PatientBalanceSummary(
                                PracticeID Int,
				PatientID int, 
				PatientName varchar(200),
				Charges money default 0,
				Adjustments money default 0,
				InsPay money default 0,
				PatPay money default 0,
				TotalBalance money default 0,
				PendingIns money default 0,
				PendingPat money default 0,
				AssignToIns	INT default 0
		)


	INSERT INTO #AR_Bal(ClaimID, Amount)
	SELECT ClaimID, SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE Amount*-1  END)
	FROM ClaimAccounting
	WHERE PostingDate<=@EndDate
		AND ClaimTransactionTypeCode IN ('CST', 'ADJ', 'PAY')
	GROUP BY ClaimID
        Having 0<> SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE Amount*-1  END)       


	
	--Get Last Assignments
	CREATE TABLE #ASNMax_Bal (ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #ASNMax_Bal(ClaimID, ClaimTransactionID)
	SELECT CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Assignments CAA
		INNER JOIN #AR_Bal ar ON ar.CLaimID = caa.CLaimID
	WHERE PostingDate<=@EndDate
	GROUP BY CAA.ClaimID
	
	CREATE TABLE #ASN_Bal (ClaimID INT, PatientID INT, TypeGroup INT)
	INSERT INTO #ASN_Bal(ClaimID, PatientID, TypeGroup)
	SELECT CAA.ClaimID, 
		CAA.PatientID,
			CASE WHEN caa.InsuranceCompanyPlanID IS NULL THEN 2 ELSE 1 END TypeGroup
	FROM ClaimAccounting_Assignments CAA 
		INNER JOIN #ASNMax_Bal AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
		LEFT JOIN InsuranceCompanyPlan icp on icp.InsuranceCompanyPlanID = caa.InsuranceCompanyPlanID
	WHERE CAA.PostingDate<=@EndDate
	


	SELECT a.ClaimID, a.PatientID, 
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
	INTO #AR_ASN_Bal
	FROM #ASN_Bal A 
		INNER JOIN ClaimAccounting CAA ON A.PatientID=CAA.PatientID AND A.ClaimID=CAA.ClaimID
		LEFT JOIN Payment P ON p.PracticeID = caa.PracticeID AND caa.PaymentID=P.PaymentID
	WHERE ( (CAA.ClaimTransactionTypeCode <> 'PAY' AND CAA.PostingDate<=@EndDate) 
                                OR (CAA.ClaimTransactionTypeCode = 'PAY' AND p.PostingDate<=@EndDate) 
                )
		AND ClaimTransactionTypeCode IN ('CST', 'ADJ', 'PAY')
	GROUP BY a.ClaimID, TypeGroup, a.PatientID



		update asn
		set
			PendingIns = PendingIns - ISNULL(ca.amount, 0),
			PendingPat =  PendingPat + ISNULL(ca.amount, 0) 
		from #AR_ASN_Bal asn 
			INNER JOIN (Select ClaimID, sum(amount) amount from ClaimAccounting  
						where ClaimTransactionTypeCode = 'PRC' AND PostingDate <= @endDate  GROUP BY ClaimID) as ca
				on ca.ClaimID = asn.ClaimID
		WHERE TypeGroup = '1' 


		INSERT #PatientBalanceSummary(
                                        PracticeID,
					PatientID , 
					Charges,
					Adjustments,
					InsPay,
					PatPay,
					TotalBalance,
					PendingIns,
					PendingPat,
					AssignToIns
				)
		SELECT 
                        pat.PracticeID,
			PAT.PatientID, 
			SUM(Charges) Charges,
			SUM(Adjustments) Adjustments,
			SUM(InsPay) InsPay,
			SUM(PatPay) PatPay,
			TotalBalance = SUM( TotalBalance ),
			PendingIns = SUM(PendingIns),
			PendingPat = SUM(PendingPat),
			SUM(DISTINCT a.TypeGroup)
		From Patient Pat
                        LEFT JOIN #AR_ASN_Bal A ON A.PatientID=Pat.PatientID
		GROUP BY  pat.PracticeID,PAT.PatientID




	-- Collects Unapplied payment
	SELECT PayerID as PatientID, PaymentID, PaymentAmount
	INTO #Unapplied
	FROM Payment p
		INNER JOIN #PatientBalanceSummary a ON a.PatientID = p.PayerID 
	where p.PostingDate<=@EndDate
		AND p.PayerTypeCode = 'P'

	Update u
	SET PaymentAmount = PaymentAmount - (select ISNULL(SUM(Amount), 0) as Amount 
											FROM ClaimAccounting ca 
											WHERE ClaimTransactionTypeCode = 'PAY' 
													AND ca.PaymentID = u.PaymentID)
	FROM #Unapplied u


	-- refund 
	Update u
	SET PaymentAmount = PaymentAmount - ISNULL(Amount, 0)
	FROM #Unapplied u
		INNER JOIN (select PaymentID, sum(Amount) Amount from Refund r INNER JOIN RefundToPayments rtp ON rtp.RefundID = r.RefundID WHERE  RefundStatusCode = 'I' AND r.PostingDate <= @EndDate GRoup by paymentID ) as r
		ON r.PaymentID = u.PaymentID


	--Get any capitated to found Unapplied payments
	Update u
	SET PaymentAmount = PaymentAmount - ISNULL(Amount, 0)
	FROM #Unapplied u
		INNER JOIN ( SELECT PaymentID, SUM(Amount) Amount FROM CapitatedAccountToPayment where PostingDate <= @EndDate GROUP BY PaymentID) as CAP ON CAP.PaymentID=u.PaymentID


	select RecipientID as PatientID,  SUM(RefundAmount) as RefundAmount
		INTO #Refund
	FROM Refund r
		INNER JOIN #PatientBalanceSummary rs ON rs.PatientID = r.RecipientID
	WHERE RecipientTypeCode = 'P'
		AND PostingDate <= @EndDate
		AND RefundStatusCode = 'I'
	Group BY RecipientID
	



	-- Subtract Unapplied Payments
	Update a
	SET TotalBalance = TotalBalance - ISNULL(PaymentAmount, 0),
		PendingPat = PendingPat - ISNULL(PaymentAmount, 0),
		PatPay = PatPay - ISNULL(PaymentAmount, 0)
	FROM #PatientBalanceSummary a
		INNER JOIN (SELECT PatientID, SUM(PaymentAmount) as PaymentAmount FROM  #Unapplied Group by PatientID) as U
			ON a.PatientID = u.PatientID



	DROP TABLE #AR_Bal, #AR_ASN_Bal
	DROP TABLE #ASN_Bal
	DROP TABLE #ASNMax_Bal, #Unapplied, #Refund


----------------- END Patient Balance Summary

                
-- NOT GOING TO BE NEEDING THIS. Can Calc from the eClaim section above
--                 select cab.practiceID, 
--                         SUM( case when caa.RelativePrecedence = 1 THEN 1 ELSE 0 END) as PrimaryElectronicClaims,
--                         SUM( case when caa.RelativePrecedence = 1 THEN 0 ELSE 1 END) as SecondaryElectronicClaims
--                 from ClaimAccounting_Billings cab
--                 inner join ClaimAccounting_Assignments caa on caa.PracticeID = cab.PracticeID 
--                         AND cab.ClaimID = caa.ClaimID
--                         AND cab.ClaimTransactionID > caa.ClaimTransactionID 
--                         AND (cab.ClaimTransactionID <= caa.EndClaimTransactionID OR caa.EndClaimTransactionID IS NULL )
--                 where BatchType = 'E'
--                         and caa.InsurancePolicyID is not null
--                         and cab.LastBilled = 1
--                         AND caa.LastAssignment = 1
--                         AND cab.PostingDate between @BeginDate and @EndDate
--                 group by cab.PracticeID
                
            
        --------------- DRO --------------------               
        create Table #Providers( providerID Int, DRO Decimal(9, 4), DaysInAR Decimal(9,4), DaysToBill Decimal(9,4),
                                CodeCheck INT, Appointment INT
                                )
                                
        INSERT INTO #Providers( providerID, DRO )                                
	select d.DoctorID, DaysRevenueOutstanding = CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END
	from DOCTOR D
        LEFT JOIN 
                (

			SELECT	prac.practiceID,
                                ca.providerID,
				Weighted = ca.Amount * datediff(d, ep.ProcedureDateOfService, p.PostingDate),
				AMOUNT = ca.Amount
			FROM practice prac
					INNER JOIN ClaimAccounting ca (nolock) ON ca.PracticeID = prac.PracticeID
					INNER JOIN EncounterProcedure ep on ep.PracticeID = prac.PracticeID AND ep.EncounterProcedureID = ca.EncounterProcedureID
					INNER JOIN Payment P on p.PaymentID = ca.PaymentID
			WHERE ClaimTransactionTypeCode = 'PAY' 
				AND CA.PostingDate  BETWEEN @BeginDate AND @EndDate

		) as v on v.ProviderID = d.DOctorID and v.PracticeID = d.PracticeID
        where D.ActiveDoctor = 1 and [external] = 0
        Group by d.DoctorID
                

        UPDATE p           
	SET DaysInAR = v.DaysInAR
	from #Providers p
        INNER JOIN 
        (       select providerID,  DaysInAR =CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END
                FROM 
                (

			SELECT	ca.providerID,
				Weighted = ca.Amount * datediff(d, bll.PostingDate, ca.PostingDate),
				AMOUNT = ca.Amount
			FROM ClaimAccounting ca (nolock) 
				INNER JOIN ClaimAccounting bll (nolock) 
                                ON ca.PracticeID = bll.PracticeID and ca.ClaimID = bll.ClaimID
			WHERE ca.ClaimTransactionTypeCode = 'PAY' 
                                AND bll.ClaimTransactionTypeCode = 'BLL'
				AND CA.PostingDate  BETWEEN @BeginDate AND @EndDate
                ) as AR
                group by ProviderID
       ) as v on v.ProviderID = p.ProviderID
       
       
       
        UPDATE p           
	SET DaysToBill = v.DaysToBill
	from #Providers p
        INNER JOIN 
        (       select providerID,  DaysToBill =CASE WHEN SUM(Amount)=0 THEN 0 ELSE SUM(Weighted)/SUM(Amount) END
                FROM 
                (

			SELECT	bll.providerID,
				Weighted = dbo.fn_RoundUpToPenny( ep.ServiceChargeAmount * ep.ServiceUnitCount)  * datediff(d, ep.ProcedureDateOfService, bll.PostingDate),
				AMOUNT = dbo.fn_RoundUpToPenny( ep.ServiceChargeAmount * ep.ServiceUnitCount)
			FROM ClaimAccounting bll (nolock) 
                                INNER JOIN EncounterProcedure ep 
                                        on ep.PracticeID = bll.PracticeID 
                                        AND ep.EncounterProcedureID = bll.EncounterProcedureID
			WHERE bll.ClaimTransactionTypeCode = 'BLL'
				AND bll.PostingDate  BETWEEN @BeginDate AND @EndDate
                ) as AR
                group by ProviderID
       ) as v on v.ProviderID = p.ProviderID
        
        
        
        UPDATE p           
	SET Appointment = v.NumOfAppt
	from #Providers p
        INNER JOIN 
                (
                        select ResourceID as ProviderID, count(*) as NumOfAppt
                        from Appointment a
                        inner join AppointmentToResource atr 
                                on atr.AppointmentID = a.AppointmentID
                                and atr.AppointmentResourceTypeID = 1
                        where a.StartDate between @BeginDate and @EndDate
                        GROUP BY ResourceID
                        
                ) as v on p.providerID = v.ProviderID
                
                
                
                

        select 
			@CustomerID as CustomerID, 
			@CustomerName as CustomerName, 
			convert(Varchar, @CustomerCreatedDate, 1) as CustomerCreatedDate, 
			@SupportTypeCaption as SupportTypeCaption,
			p.PracticeID,
			practiceName,
			convert( varchar, practiceCreatedDate, 1) as practiceCreatedDate,	
			practiceCity,	
			practiceState,	
			left(practiceZipCode,5) practiceZipCode,
			isnull(NumberOfActiveProviders, 0) NumberOfActiveProviders,
			PracticeEditionTypeName,
			SupportTypeID	,
			isnull(PatientAR,0) PatientAR,
			isnull(InsuranceAR,0) InsuranceAR,
			isnull(TotalAR,0) TotalAR,
			isnull(ARover60Days,0) ARover60Days,
			isnull(PatientStatement,0) as PatientStatement,
			isnull(PatientPayments,0) PatientPayments,
			isnull(InsurancePayments, 0) InsurancePayments,
			isnull(InsurancePaymentsLinkedToERA,0) InsurancePaymentsLinkedToERA,
--			isnull(TotalPayments, 0) TotalPayments,
                        isnull(PatientPayments,0) + isnull(InsurancePayments, 0) as TotalPayments,
			isnull(PatientPaymentApplications,0) PatientPaymentApplications,
			isnull(InsurancePaymentsApplications,0) InsurancePaymentsApplications,
			isnull(InsurancePaymentsLinkedToERAApplications,0) InsurancePaymentsLinkedToERAApplications,
--			isnull(TotalPaymentsApplications,0) TotalPaymentsApplications,
                        isnull(PatientPaymentApplications,0) + isnull(InsurancePaymentsApplications,0) + isnull(InsurancePaymentsLinkedToERAApplications,0) as TotalPaymentsApplications,
			isnull(DMSStorage_MB,0) DMSStorage_MB,
			isnull(FaxedDocuments,0) FaxedDocuments,
			isnull(ScannedDocuments,0) as ScannedDocuments,
			isnull(FileDocuments,0) as FileDocuments,
			isnull(TotalDocuments,0) TotalDocuments,
			isnull(ERAQty,0) ERAQty,
			isnull(Encounters, 0) Encounters,
			isnull(PatientWithOpenBalance,0) PatientWithOpenBalance,
			isnull(NumOfPatient,0) NumOfPatient,
			isnull(NumOfEligibilityCheck,0) NumOfEligibilityCheck,
			d.doctorID,
			ProviderFullName,
			convert(varchar, providerCreatedDate, 1) as providerCreatedDate,
			ProviderTypeID,
			ProviderSpecialityName,
                        ProviderSpecialityClassification,
			ProviderSpecialityDescription,
			isnull(DRO,0) as DRO,
			isnull(DaysInAR,0) DaysInAR,
			isnull(DaysToBill, 0) DaysToBill,
			isnull(CodeCheck,0) CodeCheck,
			isnull(Appointment,0) Appointment,
			isnull(RejectedClaim,0) RejectedClaim,
            isnull(CH_PROXYMED, 0) as CH_PROXYMED,
            isnull(CH_OFFICEALLY, 0) as CH_OFFICEALLY,
            isnull(CH_GATEWAYEDI, 0) as CH_GATEWAYEDI,
			isnull(EClaimsTotal,0) EClaimsTotal,
			isnull(PrimaryEClaim,0) PrimaryEClaim,
			isnull(SecondaryEClaim	,0) SecondaryEClaim,
			isnull(PaperClaim,0) PaperClaim	,
			isnull(DeniedEncounters, 0) DeniedEncounter,
			isnull(TotalClaimsCreated, 0) TotalClaimsCreated
        from #practice p
                LEFT join #payment pay on pay.PracticeID = p.PracticeID
                LEFT join #DMSUsage dmsU on dmsU.practiceID = p.practiceID
                LEFT join #DMSStorageUsage dmsS on dmsS.practiceID=p.practiceID
                LEFT join #ERA era on era.practiceID = p.practiceID
                LEFT JOIN (
                                select PracticeID, sum( case when PendingPat >0 THEN 1 ELSE 0 END) as PatientWithOpenBalance, count(distinct PatientID) as NumOfPatient
                                From #PatientBalanceSummary
                                GROUP BY PracticeID
                        ) as pat on p.practiceID = pat.PracticeID
                LEFT JOIN (
                                select PracticeID, count(*) as NumOfEligibilityCheck
                                From #Eligibility
                                GROUP BY PracticeID
                        ) as eli on p.practiceID = eli.PracticeID
				LEFT join #Encounter e on e.practiceID = p.practiceID
                LEFT join #doctor d on d.practiceID = p.practiceID
                LEFT join #Providers pro on pro.providerID = d.doctorID
                LEFT join #paymentApplication paa on paa.practiceID = p.practiceID AND paa.providerID = d.DoctorID
                LEFT join #RejectedClaim rc on rc.practiceID = p.practiceID and d.doctorID = rc.doctorID
                LEFT join #EClaims ec on ec.practiceID = p.practiceID and d.doctorID = ec.doctorID
                LEFT join #PaperClaim pc on pc.practiceID = p.practiceID and d.doctorID = pc.doctorID
                LEFT join #DeniedClaim dc on ec.practiceID = p.practiceID and d.doctorID = dc.doctorID
        
        
                
        
        
           



drop Table #practice, #payment, #paymentApplication, 
        #doctor, #DMSStorageUsage, #DMSUsage, #ERA, #Encounter,
        #Eligibility, #PaperClaim, #RejectedClaim, #EClaims, #DeniedClaim, #PatientBalanceSummary, #Providers
        
        

