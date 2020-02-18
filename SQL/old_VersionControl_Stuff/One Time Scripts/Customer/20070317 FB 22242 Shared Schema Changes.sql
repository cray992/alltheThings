CREATE TABLE CompanyMetrics_ProviderComparisonRptKeys(ReportKeyID INT IDENTITY(1,1), CreatedDate DATETIME)

CREATE TABLE CompanyMetrics_ProviderComparisonRptDetails(ReportKeyID INT, CustomerID INT, PracticeID INT, PracticeName VARCHAR(128), DoctorID INT, ProviderName VARCHAR(228), 
Degree VARCHAR(50), ProviderType VARCHAR(50), CreatedDate DATETIME, Active BIT, DoctorSettingsChanged BIT, PracticeSettingsChanged BIT, New BIT)