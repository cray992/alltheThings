
--Payer Managed Physcial Network for professional and UB needs to be linked to Payer ACN01
DECLARE @NewPayerACN01 INT 

SELECT @NewPayerACN01 = clearinghousepayerID FROM dbo.ClearinghousePayersList AS CPL
WHERE CPL.PayerNumber = 'ACN01' AND CPL.ClearinghouseID = 1 AND CPL.Name = 'American Chiropractic Network Group'

IF @NewPayerACN01 > 0
BEGIN
	UPDATE dbo.InsuranceCompany
	SET ClearinghousePayerID = @NewPayerACN01
	WHERE ClearinghousePayerID IN 
	(
		SELECT ClearinghousePayerID 
		FROM ClearinghousePayersList AS CPL
		WHERE CPL.PayerNumber in ('41159', '93900') AND CPL.ClearinghouseID = 1
	)
END
