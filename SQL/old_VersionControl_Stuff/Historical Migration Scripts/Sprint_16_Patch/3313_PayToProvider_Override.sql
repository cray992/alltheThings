IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OverridePayToAddressFlag' and Object_ID = Object_ID(N'ClaimSettings'))
BEGIN

	ALTER TABLE dbo.ClaimSettings
		ADD 
			OverridePayToAddressFlag bit NOT NULL DEFAULT 0,
			OverridePayToName VARCHAR(128) NULL,
			OverridePayToAddressLine1 varchar(256) NULL,
			OverridePayToAddressLine2 varchar(256) NULL,
			OverridePayToCity varchar(128) NULL,
			OverridePayToState varchar(2) NULL,
			OverridePayToZipCode varchar(9) NULL,
			OverridePayToCountry VARCHAR(32) NULL
END



