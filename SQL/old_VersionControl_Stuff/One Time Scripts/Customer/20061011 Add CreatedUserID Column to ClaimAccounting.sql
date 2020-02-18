IF NOT EXISTS(SELECT sc.* 
			  FROM sys.objects so INNER JOIN sys.columns sc ON so.object_id=sc.object_id
			  WHERE so.name='ClaimAccounting' AND so.type='U' AND sc.name='CreatedUserID')
	ALTER TABLE ClaimAccounting ADD CreatedUserID INT
GO
							