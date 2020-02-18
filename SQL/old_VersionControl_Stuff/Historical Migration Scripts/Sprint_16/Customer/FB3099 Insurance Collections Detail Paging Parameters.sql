UPDATE dbo.Report
SET ReportParameters.modify('replace value of (/parameters/@extraHeaderLength)[1] with "1684"')
WHERE name = 'Insurance Collections Detail'

UPDATE dbo.Report
SET ReportParameters.modify('replace value of (/parameters/@pageColumnCount)[1] with "14"')
WHERE name = 'Insurance Collections Detail'