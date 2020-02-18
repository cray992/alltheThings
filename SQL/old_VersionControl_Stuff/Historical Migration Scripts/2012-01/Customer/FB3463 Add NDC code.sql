IF NOT EXISTS (SELECT * FROM dbo.EDINoteReferenceCode AS ENRC WHERE Code = 'NDC')
BEGIN
	INSERT INTO dbo.EDINoteReferenceCode
			( Code ,
			  Definition ,
			  ClaimOnly ,
			  DisplayCMS1500 ,
			  DisplayUB04
			)
	VALUES  ( 'NDC' , -- Code - char(3)
			  'National Drug Code' , -- Definition - varchar(64)
			  0 , -- ClaimOnly - bit
			  1 , -- DisplayCMS1500 - bit
			  0  -- DisplayUB04 - bit
			)
END			