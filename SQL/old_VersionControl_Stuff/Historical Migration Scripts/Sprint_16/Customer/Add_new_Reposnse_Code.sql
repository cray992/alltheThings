IF NOT EXISTS (SELECT * FROM dbo.PaymentResponseCode WHERE Code = '0CV')
	INSERT INTO dbo.PaymentResponseCode
        ( Code, Description )
VALUES  ( '0CV', -- Code - varchar(10)
          'Failure CV'  -- Description - varchar(128)
          )
