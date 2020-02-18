UPDATE dbo.Report
SET ReportPath = '/Reporting/#/ArSummary/{CustomerID}/{PracticeID}'
WHERE ReportID = 81

UPDATE dbo.Report
SET ReportPath = '/Reporting/#/ArInsurance/{CustomerID}/{PracticeID}'
WHERE ReportID = 82

UPDATE dbo.Report
SET ReportPath = '/Reporting/#/ArPatient/{CustomerID}/{PracticeID}'
WHERE ReportID = 83

UPDATE dbo.Report
SET ReportPath = '/Reporting/#/ArPatientDetail/{CustomerID}/{PracticeID}/{EntityID}'
WHERE ReportID = 84

UPDATE dbo.Report
SET ReportPath = '/Reporting/#/ArInsuranceDetail/{CustomerID}/{PracticeID}/{EntityID}'
WHERE ReportID = 85