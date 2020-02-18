
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ClaimSettingsHistory')
BEGIN
	DROP TABLE ClaimSettingsHistory
END

CREATE TABLE dbo.ClaimSettingsHistory(
	ClaimSettingsHistoryID int not null identity(1, 1),

	CustomerID int not null,
	ClaimSettingEdition int null,
	ModifiedUserID int null,
	ModifiedDate datetime null,
	
	CONSTRAINT PK_ClaimSettingsHistory PRIMARY KEY CLUSTERED 
	(
		ClaimSettingsHistoryID ASC
	)
)