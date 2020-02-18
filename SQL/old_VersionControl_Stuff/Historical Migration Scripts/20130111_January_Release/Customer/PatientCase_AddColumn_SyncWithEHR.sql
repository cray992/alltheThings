IF NOT EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'SyncWithEHR' and Object_ID = Object_ID(N'PatientCase'))    
BEGIN
	ALTER TABLE PatientCase
	ADD SyncWithEHR bit NOT NULL
	DEFAULT 0
END