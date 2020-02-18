IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='PremiumTrainingDate' AND COLUMNS.TABLE_NAME='Salesforce_Case')
BEGIN
	ALTER TABLE dbo.Salesforce_Case
	ADD PremiumTrainingDate DATETIME NULL
END 
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='ProServicesDate' AND COLUMNS.TABLE_NAME='Salesforce_Case')
BEGIN
	ALTER TABLE dbo.Salesforce_Case
	ADD ProServicesDate DATETIME NULL
END 
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='PatientMgntDate' AND COLUMNS.TABLE_NAME='Salesforce_Case')
BEGIN
	ALTER TABLE dbo.Salesforce_Case
	ADD PatientMgntDate DATETIME NULL
END        