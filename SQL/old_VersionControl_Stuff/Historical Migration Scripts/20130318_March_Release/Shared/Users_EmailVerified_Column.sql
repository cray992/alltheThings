IF NOT EXISTS(SELECT * FROM sys.columns 
	WHERE Name = N'EmailVerified' and Object_ID = Object_ID(N'Users'))    
BEGIN
	ALTER TABLE Users
	ADD EmailVerified INT NOT NULL -- 0 not validated, 1 legacy, 2 validated
	DEFAULT 1
END