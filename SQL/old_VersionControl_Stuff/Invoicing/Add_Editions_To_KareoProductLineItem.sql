IF NOT EXISTS (SELECT * FROM dbo.KareoProductLineItem AS KPLI WHERE KareoProductLineItemName = 'Suite')
BEGIN
	INSERT INTO dbo.KareoProductLineItem
			( KareoProductLineItemName ,
			  Price ,
			  Active ,
			  KareoProductLineItemDesc ,
			  InvoicingInputItemID ,
			  CreatedDate ,
			  CreatedUserID ,
			  ModifiedDate ,
			  ModifiedUserID ,
			  DefaultDateTypeID ,
			  Internal
			)
	VALUES  ( 'Suite' , -- KareoProductLineItemName - varchar(128)
			  299, -- Price - money
			  1, -- Active - bit
			  'Suite Edition' , -- KareoProductLineItemDesc - varchar(500)
			  NULL , -- InvoicingInputItemID - int
			  GETDATE() , -- CreatedDate - datetime
			  26143 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  26143 , -- ModifiedUserID - int
			  2 , -- DefaultDateTypeID - int
			  0  -- Internal - bit
			)
END

IF NOT EXISTS (SELECT * FROM dbo.KareoProductLineItem AS KPLI WHERE KareoProductLineItemName = 'Open PM')
BEGIN
	INSERT INTO dbo.KareoProductLineItem
			( KareoProductLineItemName ,
			  Price ,
			  Active ,
			  KareoProductLineItemDesc ,
			  InvoicingInputItemID ,
			  CreatedDate ,
			  CreatedUserID ,
			  ModifiedDate ,
			  ModifiedUserID ,
			  DefaultDateTypeID ,
			  Internal
			)
	VALUES  ( 'Open PM' , -- KareoProductLineItemName - varchar(128)
			  199, -- Price - money
			  1, -- Active - bit
			  'Open PM Edition' , -- KareoProductLineItemDesc - varchar(500)
			  NULL , -- InvoicingInputItemID - int
			  GETDATE() , -- CreatedDate - datetime
			  26143 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  26143 , -- ModifiedUserID - int
			  2 , -- DefaultDateTypeID - int
			  0  -- Internal - bit
			)
END
		