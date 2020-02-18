/*
select top 10 reportparameters from report 

UPDATE	Report
SET		ReportParameters.modify(
		'delete /parameters/@csv')
WHERE	ReportID = 7
*/

-- Modify the ReportParameters to the XML data type
ALTER TABLE Report
ALTER COLUMN ReportParameters XML

GO

-- Add attribute to disable the csv button
UPDATE	Report
SET		ReportParameters.modify(
		'insert attribute csv {"false"} into (/parameters)[1]')
