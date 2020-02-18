
CREATE TABLE #CT_Deletion(
	CustomerID INT,
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
	NewBalance money,
	success BIT
) 





DECLARE @Loop INT
DECLARE @Count INT
DECLARE @CurrentDate datetime

	CREATE TABLE #DBS(DBID INT IDENTITY(1,1), DatabaseServerName varchar(50), DatabaseName VARCHAR(50), Exsts BIT, CustomerID INT, CompanyName varchar(500) )
	INSERT INTO #DBS(DatabaseServerName, DatabaseName, Exsts, CustomerID, CompanyName)
	SELECT DatabaseServerName, DatabaseName, 0, CustomerID, CompanyName
	FROM Customer
	WHERE DBActive=1
AND CustomerID in( 122, 203 )



SET @Loop=@@ROWCOUNT
SET @Count=0
SET @CurrentDate = getdate()

DECLARE @SQL VARCHAR(8000)
DECLARE @ESQL VARCHAR(8000)

SET @SQL='
		DECLARE @ct TABLE(
			CustomerID INT,
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


		INSERT INTO @ct (
			CustomerID,
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
		select distinct {1}, 
			prac.Name,
			ct.PaymentID, d.*, 
			CurrentBal = (select sum(case when claimTransactionTypeCode = ''CST'' THEN AMOUNT else -1*Amount END ) FROM {0}.dbo.ClaimAccounting ca where ca.ClaimID = d.ClaimID AND ClaimTransactionTypeCode IN (''CST'', ''PAY'', ''ADJ'') ),
			NewBal = (-1 * d.Amount) + (select sum(case when claimTransactionTypeCode = ''CST'' THEN AMOUNT else -1*Amount END ) FROM {0}.dbo.ClaimAccounting ca where ca.ClaimID = d.ClaimID  AND ClaimTransactionTypeCode IN (''CST'', ''PAY'', ''ADJ'') )
		from {0}.dbo.CT_Deletions d
			INNER JOIN {0}.dbo.Practice prac ON prac.PracticeID = d.PracticeID 
			INNER JOIN {0}.dbo.Claim c ON c.ClaimID = d.ClaimID
			INNER JOIN {0}.dbo.ClaimTransaction ct ON ct.PracticeID = d.PracticeID
						AND ct.CreatedDate = d.CreatedDate AND ct.CreatedUserID = d.CreatedUserID AND ct.PatientID = d.PatientID
						AND ct.PaymentID IS NOT NULL
			INNER JOIN {0}.dbo.ClaimTransaction delTrigger ON delTrigger.PaymentID = ct.PaymentID AND datediff(s, delTrigger.createdDate, d.DeletionDate ) Between -1 and 1
			LEFT JOIN {0}.dbo.ClaimTransaction fixPay ON fixPay.ClaimID = d.ClaimID AND fixPay.PracticeID = d.PracticeID AND fixPay.PaymentID = ct.PaymentID 
						AND fixPay.Amount = d.Amount AND fixPay.ClaimTransactionID > d.ClaimTransactionID AND fixPay.ClaimTransactionTypeCode = ''PAY''
		where DeletionDate >= ''5/5/07 9:00 pm''
			AND d.ClaimTransactionTypeCode = ''PAY''
			AND fixPay.ClaimTransactionID IS NULL
		order by ct.PaymentID, d.patientID, d.ClaimID


		Declare @success bit


		begin trans
		BEGIN TRY
			SET IDENTITY_INSERT {0}.dbo.[ClaimTransaction] ON

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
			SELECT ClaimTransactionID
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
						,''Transaction was restored from backup on ' + cast( @CurrentDate as varchar ) + '''
						, 1
			FROM @ct

			SET IDENTITY_INSERT {0}.dbo.[ClaimTransaction] ON

			UPDATE ct
			SET overrideClosingDate = 0
			FROM {0}.dbo.[ClaimTransaction] ct
				INNER JOIN @ct d ON d.ClaimTransactionID = ct.ClaimTransactionID

			DELETE d
			FROM {0}.dbo.CT_Deletions d INNER JOIN @ct ct ON ct.ClaimTransactionID = d.ClaimTransactionID
		

			SET @success = 1
			commit trans

		END TRY
		BEGIN CATCH

			print ''Failed on {1}''
			SET @success = 0
			ROLL BACK TRANS			

		END CATCH

		INSERT INTO #CT_Deletion
		SELECT *, @success FROM @ct

		'

DECLARE @DB VARCHAR(50), @CustomerID INT
SET @DB=''

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	SELECT @DB='['+DatabaseServerName+'].'+DatabaseName,
			@CustomerID = CustomerID
	FROM #DBS
	WHERE DBID=@Count

	SET @ESQL=REPLACE(@SQL,'{0}',@DB)
	SET @ESQL=REPLACE(@ESQL,'{1}',@CustomerID)


print @ESQL
--	EXEC(@ESQL)
END



select d.CustomerID, CompanyName, PracticeName, PaymentID, PatientID, ClaimID, Amount, PostingDate, CurrentBalance, NewBalance, D.DeletionDate
from #CT_Deletion d 
INNER JOIN #DBS c ON c.CustomerID = d.CustomerID
WHERE CurrentBalance <> 0
order by d.CustomerID, CompanyName, PracticeName, PaymentID, PatientID, ClaimID


-- drop table  #CT_Deletion, #DBS
-- select getdate()
--


--
--
--
--
--select DISTINCT
--			d.ClaimTransactionID
--			,d.[ClaimTransactionTypeCode]
--           ,d.[ClaimID]
--           ,d.[Amount]
--           ,d.[Quantity]
--           ,d.[Code]
--           ,d.[ReferenceID]
--           ,d.[ReferenceData]
--
--           ,d.[CreatedDate]
--           ,d.[ModifiedDate]
--           ,d.[PatientID]
--           ,d.[PracticeID]
--           ,d.[BatchKey]
--           ,d.[Original_ClaimTransactionID]
--           ,d.[Claim_ProviderID]
--
--           ,d.[PostingDate]
--           ,d.[CreatedUserID]
--           ,d.[ModifiedUserID]
--			,ct.PaymentID
--FROM 
--	CT_Deletions d
--	INNER JOIN Claim c ON c.ClaimID = d.ClaimID
--	INNER JOIN ClaimTransaction ct ON ct.PracticeID = d.PracticeID AND ct.ClaimID = d.ClaimID
--			AND ct.ClaimTransactionID > d.ClaimTransactionID
--			AND ct.PaymentID IS NOT NULL
----			AND datediff( s, ct.createdDate, DeletionDate ) < 2
--where DeletionDate >= '5/5/07 9:00 pm'
--	AND d.ClaimTransactionTypeCode = 'PAY'
--	AND d.ClaimTransactionID in (298228,
--298225,
--298222,
--298219)
--
--delete CT_Deletions
--WHERE 	ClaimTransactionID in (298228,
--298225,
--298222,
--298219)
--	AND DeletionDate >= '5/14/07'
