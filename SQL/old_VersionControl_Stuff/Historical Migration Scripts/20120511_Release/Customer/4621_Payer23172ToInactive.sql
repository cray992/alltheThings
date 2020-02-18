UPDATE dbo.ClearinghousePayersList
SET Active = 0
WHERE PayerNumber = '23172' 
AND ClearinghouseID IN (1,3)