IF NOT Exists( select * from [ClaimTransactionType] where [ClaimTransactionTypeCode] = 'RJT' )
BEGIN
	INSERT INTO [ClaimTransactionType]
			   ([ClaimTransactionTypeCode]
			   ,[TypeName])
		 VALUES (
			   'RJT'
			   ,'Rejected')
END
