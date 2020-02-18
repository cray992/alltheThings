IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'GlobalPayToAddressFlag' and Object_ID = Object_ID(N'Doctor'))
BEGIN

	ALTER TABLE dbo.Doctor
		ADD 
			GlobalPayToAddressFlag bit NULL DEFAULT 0,
			GlobalPayToName VARCHAR(128) NULL,
			GlobalPayToAddressLine1 varchar(256) NULL,
			GlobalPayToAddressLine2 varchar(256) NULL,
			GlobalPayToCity varchar(128) NULL,
			GlobalPayToState varchar(2) NULL,
			GlobalPayToZipCode varchar(9) NULL,
			GlobalPayToCountry VARCHAR(32) NULL
END


SELECT * FROM dbo.Doctor AS D