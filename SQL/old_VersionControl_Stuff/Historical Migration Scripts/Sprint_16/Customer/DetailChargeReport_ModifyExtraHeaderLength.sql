UPDATE dbo.Report
SET ReportParameters.modify('replace value of (/parameters/@extraHeaderLength)[1] with "1313"')
WHERE name = 'charges detail'