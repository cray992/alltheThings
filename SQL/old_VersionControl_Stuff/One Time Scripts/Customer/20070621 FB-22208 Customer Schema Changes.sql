CREATE TABLE DoctorSettingsLog(DoctorSettingsLogID INT IDENTITY(1,1) CONSTRAINT PK_DoctorSettingHistory PRIMARY KEY, 
								   DoctorID INT, ActiveDoctor BIT, ProviderTypeID INT, ModifiedDate DATETIME, ModifiedUserID INT)

GO

CREATE INDEX IX_DoctorSettingsLog_DoctorID_ModifiedDate
ON DoctorSettingsLog (DoctorID, ModifiedDate)

GO

CREATE TABLE PracticeSettingsLog(PracticeSettingsLog INT IDENTITY(1,1) CONSTRAINT PK_PracticeSettingsLog PRIMARY KEY,
								 PracticeID INT, Active BIT, EditionTypeID INT, SupportTypeID INT, Metrics BIT, 
								 ModifiedDate DATETIME, ModifiedUserID INT)

GO

CREATE INDEX IX_PracticeSettingsLog_PracticeID_ModifiedDate
ON PracticeSettingsLog (PracticeID, ModifiedDate)

GO