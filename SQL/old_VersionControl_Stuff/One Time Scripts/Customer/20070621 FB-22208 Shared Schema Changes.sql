CREATE TABLE CustomerSettingsLog(CustomerSettingsLogID INT IDENTITY(1,1) CONSTRAINT PK_CustomerSettingsLog PRIMARY KEY,
								 CustomerID INT, AccountLocked INT, DBActive BIT, Metrics BIT, ModifiedDate DATETIME, ModifiedUserID INT)

GO

CREATE INDEX IX_CustomerSettingsLog_CustomerID_ModifiedDate 
ON CustomerSettingsLog (CustomerID, ModifiedDate)