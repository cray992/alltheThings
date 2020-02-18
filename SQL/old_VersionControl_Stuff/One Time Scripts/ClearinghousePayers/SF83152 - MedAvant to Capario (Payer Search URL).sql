-- Update link for ClearinghousePayerListScraper application
UPDATE	PayerSource
SET		ParserUrl = 'http://www.capario.com/services/resource_center/payer/list/default_db.asp'
WHERE	PayerSourceID = 1
AND		PayerSourceName = 'MedAvant'

UPDATE	PayerSource
SET		ParserUrl = 'https://services.gatewayedi.com/PayerList/PayerList.asmx'
WHERE	PayerSourceID = 3
AND		PayerSourceName = 'GatewayEDI'

