/*
	SET ALL CUSTOMERS TO NOT ENFORCE PASSWORD EXPIRATION BY DEFAULT
*/
UPDATE dbo.SecuritySetting
SET PasswordExpiration = 0