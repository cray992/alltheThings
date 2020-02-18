UPDATE dbo.Report
SET ReportParameters.modify('replace value of (/parameters/@headerExtractCharacterCount)[1] with "110000"')
WHERE name = 'Insurance Collections Detail'