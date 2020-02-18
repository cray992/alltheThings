
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PracticeID' 
	AND Object_ID = Object_ID(N'VendorImport'))
BEGIN
	ALTER TABLE VendorImport ADD PracticeID int NULL;
  
    ALTER TABLE VendorImport ADD CONSTRAINT [fk_PracticeID] FOREIGN KEY (PracticeID) REFERENCES Practice(PracticeID);
END

--SELECT * FROM dbo.VendorImport AS vi

