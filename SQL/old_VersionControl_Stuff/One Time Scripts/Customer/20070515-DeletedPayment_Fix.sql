

		declare @CurrentDate datetime
		Declare @success bit

		SET @CurrentDate = getdate()

		Create TABLE #ct(
			PracticeName varchar(250),
			PaymentID INT,
			[ClaimTransactionID] [int] ,
			[ClaimTransactionTypeCode] [char](3) ,
			[ClaimID] [int] ,
			[Amount] [money] ,
			[Quantity] [int] ,
			[Code] [varchar](50) ,
			[ReferenceID] [int] ,
			[ReferenceData] [varchar](250) ,
			[CreatedDate] [datetime],
			[ModifiedDate] [datetime],
			[PatientID] [int] ,
			[PracticeID] [int] ,
			[BatchKey] [uniqueidentifier] ,
			[Original_ClaimTransactionID] [int] ,
			[Claim_ProviderID] [int] ,
			[PostingDate] [datetime],
			[CreatedUserID] [int] ,
			[ModifiedUserID] [int] ,
			[DeletionDate] [datetime],
			CurrentBalance money,
			NewBalance money
		) 


		INSERT INTO #ct (
			PracticeName,
			PaymentID,
			[ClaimTransactionID],
			[ClaimTransactionTypeCode],
			[ClaimID],
			[Amount],
			[Quantity],
			[Code],
			[ReferenceID],
			[ReferenceData],
			[CreatedDate],
			[ModifiedDate],
			[PatientID],
			[PracticeID],
			[BatchKey],
			[Original_ClaimTransactionID],
			[Claim_ProviderID],
			[PostingDate],
			[CreatedUserID],
			[ModifiedUserID],
			[DeletionDate],
			CurrentBalance,
			NewBalance
			)

		select distinct 
			prac.Name,
			ct.PaymentID, d.*, 
			CurrentBal = (select sum(case when claimTransactionTypeCode = 'CST' THEN AMOUNT else -1*Amount END ) FROM ClaimAccounting ca where ca.ClaimID = d.ClaimID AND ClaimTransactionTypeCode IN ('CST', 'PAY', 'ADJ') ),
			NewBal = (-1 * d.Amount) + (select sum(case when claimTransactionTypeCode = 'CST' THEN AMOUNT else -1*Amount END ) FROM ClaimAccounting ca where ca.ClaimID = d.ClaimID  AND ClaimTransactionTypeCode IN ('CST', 'PAY', 'ADJ') )
		from CT_Deletions d
			INNER JOIN Practice prac ON prac.PracticeID = d.PracticeID 
			INNER JOIN Claim c ON c.ClaimID = d.ClaimID
			INNER JOIN ClaimTransaction ct ON ct.PracticeID = d.PracticeID
						AND ct.CreatedDate = d.CreatedDate AND ct.CreatedUserID = d.CreatedUserID AND ct.PatientID = d.PatientID
						AND ct.PaymentID IS NOT NULL
			INNER JOIN ClaimTransaction delTrigger ON delTrigger.PaymentID = ct.PaymentID 
						AND 
						( 
							datediff(s, delTrigger.createdDate, d.DeletionDate ) Between -1 and 1
						OR 
d.ClaimTransactionID IN (
0
 )
							)
			LEFT JOIN ClaimTransaction fixPay ON fixPay.ClaimID = d.ClaimID AND fixPay.PracticeID = d.PracticeID AND fixPay.PaymentID = ct.PaymentID 
						AND fixPay.Amount = d.Amount AND fixPay.ClaimTransactionID > d.ClaimTransactionID AND fixPay.ClaimTransactionTypeCode = 'PAY'
		where DeletionDate >= '5/5/07 9:00 pm'
			AND d.ClaimTransactionTypeCode = 'PAY'
			AND fixPay.ClaimTransactionID IS NULL




		begin tran


		BEGIN TRY

print 'here'
						

			SET IDENTITY_INSERT [ClaimTransaction] ON

			INSERT INTO [ClaimTransaction]
					   (ClaimTransactionID
						,[ClaimTransactionTypeCode]
					   ,[ClaimID]
					   ,[Amount]
					   ,[Quantity]
					   ,[Code]
					   ,[ReferenceID]
					   ,[ReferenceData]

					   ,[CreatedDate]
					   ,[ModifiedDate]
					   ,[PatientID]
					   ,[PracticeID]
					   ,[BatchKey]
					   ,[Original_ClaimTransactionID]
					   ,[Claim_ProviderID]

					   ,[PostingDate]
					   ,[CreatedUserID]
					   ,[ModifiedUserID]
						,PaymentID
						,NOTES
						,overrideClosingDate
					)
			SELECT d.ClaimTransactionID
						,d.[ClaimTransactionTypeCode]
					   ,d.[ClaimID]
					   ,d.[Amount]
					   ,d.[Quantity]
					   ,d.[Code]
					   ,d.[ReferenceID]
					   ,d.[ReferenceData]

					   ,d.[CreatedDate]
					   ,d.[ModifiedDate]
					   ,d.[PatientID]
					   ,d.[PracticeID]
					   ,d.[BatchKey]
					   ,d.[Original_ClaimTransactionID]
					   ,d.[Claim_ProviderID]

					   ,d.[PostingDate]
					   ,d.[CreatedUserID]
					   ,d.[ModifiedUserID]
						,d.PaymentID
						,'Transaction was restored from backup on ' + cast(@CurrentDate as varchar)
						, 1
			FROM #ct d
				LEFT JOIN [ClaimTransaction] ct ON d.ClaimTransactionID = ct.ClaimTransactionID
			WHERE ct.PracticeID IS NULL

			SET IDENTITY_INSERT [ClaimTransaction] OFF
		

			UPDATE ct
			SET overrideClosingDate = 0
			FROM dbo.[ClaimTransaction] ct
				INNER JOIN #ct d ON d.ClaimTransactionID = ct.ClaimTransactionID



			DELETE d
			FROM CT_Deletions d INNER JOIN #ct ct ON ct.ClaimTransactionID = d.ClaimTransactionID
		
			SET @success = 1

			commit tran
			print 'success'
		END TRY
		BEGIN CATCH

			SET @success = 0
			ROLLBACK TRAN		
			print 'Failed'

		END CATCH


select * from #ct order by practiceName, paymentID, ClaimID


return

drop table #ct




