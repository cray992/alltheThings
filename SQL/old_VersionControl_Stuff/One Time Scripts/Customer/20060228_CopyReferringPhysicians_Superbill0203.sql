-- Case 9099
-- Copy ReferringPhysicians from practice 1 to practice 2 for cust. 0203
-- BEGIN TRANSACTION

CREATE TABLE #RP(
	Prefix varchar(16),
	FirstName varchar(64) ,
	MiddleName varchar(64),
	LastName varchar(64),
	Suffix varchar(16),
	UPIN varchar(32),
	WorkPhone varchar(10),
	WorkPhoneExt varchar(10),
	CreatedDate datetime,
	CreatedUserID int,
	ModifiedDate datetime,
	ModifiedUserID int,
	Degree varchar(8),
	AddressLine1 varchar(256) ,
	AddressLine2 varchar(256),
	City varchar(128),
	State varchar(2),
	Country varchar(32),
	ZipCode varchar(9),
	FaxPhone varchar(10),
	FaxPhoneExt varchar(10),
	MM_ref_dr_no int,
	OtherID varchar(32)
	)

INSERT INTO #RP(
	Prefix,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	UPIN,
	WorkPhone,
	WorkPhoneExt,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	AddressLine1,
	AddressLine2,
	City,
	State,
	Country,
	ZipCode,
	FaxPhone,
	FaxPhoneExt,
	MM_ref_dr_no,
	OtherID
	)
SELECT 	Prefix,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	UPIN,
	WorkPhone,
	WorkPhoneExt,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	AddressLine1,
	AddressLine2,
	City,
	State,
	Country,
	ZipCode,
	FaxPhone,
	FaxPhoneExt,
	MM_ref_dr_no,
	OtherID
FROM ReferringPhysician
WHERE PracticeID = 1			-- Dr Raymond P. Allard 
AND ReferringPhysicianID NOT IN (3, 45)  -- these physicians exists for practice 2 as id 47 and 43
ORDER BY ReferringPhysicianID

-- SELECT * FROM #RP

INSERT INTO ReferringPhysician(
	PracticeID,
	Prefix,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	UPIN,
	WorkPhone,
	WorkPhoneExt,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	AddressLine1,
	AddressLine2,
	City,
	State,
	Country,
	ZipCode,
	FaxPhone,
	FaxPhoneExt,
	MM_ref_dr_no,
	OtherID
	)
SELECT 2,			-- PracticeID = 2 for Carson City Hospital
	Prefix,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	UPIN,
	WorkPhone,
	WorkPhoneExt,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	AddressLine1,
	AddressLine2,
	City,
	State,
	Country,
	ZipCode,
	FaxPhone,
	FaxPhoneExt,
	MM_ref_dr_no,
	OtherID
FROM #RP

DROP TABLE #RP

-- SELECT * FROM ReferringPhysician ORDER BY ReferringPhysicianID

-- ROLLBACK
-- COMMIT
		