
--Payer 86049 needs to be linked to Payer 25175
DECLARE @NewPayer INT 

SELECT @NewPayer = clearinghousepayerID FROM dbo.ClearinghousePayersList AS CPL
WHERE CPL.PayerNumber = '25175' AND CPL.ClearinghouseID = 1

IF @NewPayer > 0
BEGIN
	UPDATE dbo.InsuranceCompany
	SET ClearinghousePayerID = @NewPayer
	WHERE ClearinghousePayerID IN 
	(
		SELECT ClearinghousePayerID 
		FROM ClearinghousePayersList AS CPL
		WHERE CPL.PayerNumber in ('86049') AND CPL.ClearinghouseID = 1
	)
END


