USE superbill_9632_dev
--USE superbill_9632_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

	UPDATE 
		[_import_1_4_ReferringPhysicians] 
	SET 
		zipplus4 = '0' + zipplus4
	WHERE 
		LEN(zipplus4) =  3

	-- Doctor (Referring) (External = True)
	PRINT ''
	PRINT 'Inserting records into Doctor  ...'
	INSERT INTO dbo.Doctor( 
		PracticeID ,
		Prefix ,
		FirstName ,
		MiddleName ,
		LastName ,
		Suffix ,
		AddressLine1 ,
		AddressLine2 ,
		City ,
		State ,
		ZipCode ,
		HomePhone ,
		WorkPhone,
		EmailAddress ,
		ActiveDoctor ,
		CreatedDate ,
		CreatedUserID ,
		ModifiedDate ,
		ModifiedUserID ,
		VendorID ,
		VendorImportID ,
		FaxNumber ,
		[External] ,
		ProviderTypeID
	)
	SELECT DISTINCT
		4 , -- PracticeID - int
		'' , -- Prefix - varchar(16)
		firstname , -- FirstName - varchar(64)
		middlename , -- MiddleName - varchar(64)
		lastname , -- LastName - varchar(64)
		'' , -- Suffix - varchar(16)
		address1 , -- AddressLine1 - varchar(256)
		address2 , -- AddressLine2 - varchar(256)
		city , -- City - varchar(128)
		LEFT([state], 2) , -- State - varchar(2)
		zipcode + zipplus4 , -- ZipCode - varchar(9)
		mainphone , -- HomePhone - varchar(10)
		phone , -- WorkPhone - varchar(10)
		homeemail , -- EmailAddress - varchar(256)
		1 , -- ActiveDoctor - bit
		GETDATE() , -- CreatedDate - datetime
		0 , -- CreatedUserID - int
		GETDATE() , -- ModifiedDate - datetime
		0 , -- ModifiedUserID - int
		code , -- VendorID - varchar(50)
		1 , -- VendorImportID - int
		fax , -- FaxNumber - varchar(10)
		1 , -- External - bit
		1  -- ProviderTypeID - int
	FROM dbo.[_import_1_4_ReferringPhysicians]
	WHERE
		NOT EXISTS(SELECT * FROM dbo.Doctor WHERE
			VendorImportID = 1 AND
			[External] = 1 AND
			FirstName = firstname AND
			LastName = lastname AND
			dbo.Doctor.AddressLine1 = address1)
			
	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT