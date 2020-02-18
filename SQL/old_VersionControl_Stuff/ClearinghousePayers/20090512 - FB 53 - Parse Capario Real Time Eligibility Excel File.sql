-- FB 53 - Parse Excel file to get Real Time Payer Eligibility information for Capario
USE ClearinghousePayers

-- Create new field for ExcelHyperlinkBaseUrl since getting it via the BuiltinDocumentProperties in code is seemingly not reliable
ALTER TABLE PayerSource
ADD ExcelHyperlinkBaseUrl varchar(200) NULL

UPDATE	PayerSource
SET		ExcelUrl = 'http://www.capario.com/services/resource_center/payer/list/Capario%20Provider%20Portal%20and%20B2B%20Payer%20List.xls',
		ExcelHyperlinkBaseUrl = 'http://www.capario.com/services/resource_center/payer/list/'
WHERE	PayerSourceName = 'MedAvant'