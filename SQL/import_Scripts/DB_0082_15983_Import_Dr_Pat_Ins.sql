-- ***************************************************************
-- *** NEED PracticeID Below
-- *** NEED Synonyms assigned below
-- Vendor Import Data
-- ***************************************************************

-- Generic procedure for importing Doctor, Patient and Insurance data
-- We have three flat tables
-- x_Doctor, x_Patient, and x_InsCo

-- ==================================================================
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_Doctor')
	DROP SYNONYM [dbo].[x_Doctor]
    GO
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_Patient')
	DROP SYNONYM [dbo].[x_Patient]
    GO
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_InsuranceCompany')
	DROP SYNONYM [dbo].[x_InsuranceCompany]
    GO
    Create Synonym x_Doctor For dbo.x_Docdatame_txt
    Go
    Create Synonym x_Patient For dbo.x_Patdatame_txt
    Go
    Create Synonym x_InsuranceCompany For dbo.x_Cardatame_txt
    Go
-- ==================================================================

-- ******************************************************************
-- Make sure the destination tables have VendorID columns
------------------------ Practice
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Practice') and name='VendorImportID')
BEGIN
	ALTER TABLE Practice ADD VendorImportID int
	PRINT 'Added column ' + 'VendorImportID' + ' to table ' + 'Practice'
END
------------------------ Doctor
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Doctor') and name='VendorID')
BEGIN
	ALTER TABLE Doctor ADD VendorID varchar(50)
	PRINT 'Added column ' + 'VendorID' + ' to table ' + 'Doctor'
END
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Doctor') and name='VendorImportID')
BEGIN
	ALTER TABLE Doctor ADD VendorImportID int
	PRINT 'Added column ' + 'VendorImportID' + ' to table ' + 'Doctor'
END
--------------------- ProviderNumber
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('ProviderNumber') and name='VendorID')
BEGIN
	ALTER TABLE ProviderNumber ADD VendorID varchar(50)
	PRINT 'Added column ' + 'VendorID' + ' to table ' + 'ProviderNumber'
END
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('ProviderNumber') and name='VendorImportID')
BEGIN
	ALTER TABLE ProviderNumber ADD VendorImportID int
	PRINT 'Added column ' + 'VendorImportID' + ' to table ' + 'ProviderNumber'
END
----------------------
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('InsuranceCompany') and name='VendorID')
BEGIN
	ALTER TABLE InsuranceCompany ADD VendorID varchar(50)
	PRINT 'Added column ' + 'VendorID' + ' to table ' + 'InsuranceCompany'
END
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('InsuranceCompany') and name='VendorImportID')
BEGIN
	ALTER TABLE InsuranceCompany ADD VendorImportID int
	PRINT 'Added column ' + 'VendorImportID' + ' to table ' + 'InsuranceCompany'
END
---------------------
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('InsuranceCompanyPlan') and name='VendorID')
BEGIN
	ALTER TABLE InsuranceCompanyPlan ADD VendorID varchar(50)
	PRINT 'Added column ' + 'VendorID' + ' to table ' + 'InsuranceCompanyPlan'
END
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('InsuranceCompanyPlan') and name='VendorImportID')
BEGIN
	ALTER TABLE InsuranceCompanyPlan ADD VendorImportID int
	PRINT 'Added column ' + 'VendorImportID' + ' to table ' + 'InsuranceCompanyPlan'
END
----------------------
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('InsurancePolicy') and name='VendorID')
BEGIN
	ALTER TABLE InsurancePolicy ADD VendorID varchar(50)
	PRINT 'Added column ' + 'VendorID' + ' to table ' + 'InsurancePolicy'
END
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('InsurancePolicy') and name='VendorImportID')
BEGIN
	ALTER TABLE InsurancePolicy ADD VendorImportID int
	PRINT 'Added column ' + 'VendorImportID' + ' to table ' + 'InsurancePolicy'
END
----------------------
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Patient') and name='VendorID')
BEGIN
	ALTER TABLE Patient ADD VendorID varchar(50)
	PRINT 'Added column ' + 'VendorID' + ' to table ' + 'Patient'
END
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Patient') and name='VendorImportID')
BEGIN
	ALTER TABLE Patient ADD VendorImportID int
	PRINT 'Added column ' + 'VendorImportID' + ' to table ' + 'Patient'
END
GO
-----------------------
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('PatientCase') and name='VendorID')
BEGIN
	ALTER TABLE PatientCase ADD VendorID varchar(50)
	PRINT 'Added column ' + 'VendorID' + ' to table ' + 'PatientCase'
END
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('PatientCase') and name='VendorImportID')
BEGIN
	ALTER TABLE PatientCase ADD VendorImportID int
	PRINT 'Added column ' + 'VendorImportID' + ' to table ' + 'PatientCase'
END
GO
-- ******************************************************************

DECLARE @VendorImportID int
DECLARE @PracticeID int
DECLARE @Rows Int
DECLARE @Message Varchar(75)
DECLARE @DefaultPayerScenarioID int
SET @DefaultPayerScenarioID = 5 --Commercial

-- ////////////////////////////////////////////////////////////////////////////////////////////
-- Data check of data to import
-- 1 Test if data will be truncated
-- 2 Check for proper data type
SELECT * FROM x_Doctor WHERE LEN(FirstName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in Doctor FirstName will be truncated. Process aborted'
	Print @Message
	RETURN
END
----------------
SELECT * FROM x_Doctor WHERE LEN(LastName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in Doctor LastName will be truncated. Process aborted'
	Print @Message
	RETURN
END
---------------
SELECT * FROM x_Doctor WHERE LEN(AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in Doctor AddressLine1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
----------------
SELECT * FROM x_Doctor WHERE LEN(AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in Doctor AddressLine2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
----------------
SELECT * FROM x_Doctor WHERE LEN(City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in Doctor City will be truncated. Process aborted'
	Print @Message
	RETURN
END
-----------------
SELECT * FROM x_Doctor WHERE LEN(State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in Doctor State will be truncated. Process aborted'
	Print @Message
	RETURN
END
-----------------
SELECT * FROM x_Doctor WHERE LEN(ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in Doctor ZipCode will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Doctor ZipCode column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
-----------------
SELECT * FROM x_Doctor WHERE LEN(SSN) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Doctor SSN will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(SSN, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Doctor SSN column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
------------------
SELECT * FROM x_Doctor WHERE LEN(HomePhone) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in Doctor HomePhone will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(HomePhone, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Doctor HomePhone column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
------------------
SELECT * FROM x_Doctor WHERE LEN([External]) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in Doctor [External] will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL([External], 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Doctor [External] column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
-- ****************
-- ************************************
SELECT * FROM x_InsuranceCompany WHERE LEN(InsVendorID) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_InsuranceCompany InsVendorID will be truncated. Process aborted'
	Print @Message
	RETURN
END
-------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(InsuranceCompanyName) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_InsuranceCompany InsuranceCompanyName will be truncated. Process aborted'
	Print @Message
	RETURN
END
-------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_InsuranceCompany AddressLine1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
-------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_InsuranceCompany AddressLine2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
-------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_InsuranceCompany City will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_InsuranceCompany State will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_InsuranceCompany ZipCode will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_InsuranceCompany ZipCode column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
---------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(Phone) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_InsuranceCompany Phone will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(Phone, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_InsuranceCompany Phone column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
---------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(InsuranceProgramCode) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_InsuranceCompany InsuranceProgramCode will be truncated. Process aborted'
	Print @Message
	RETURN
END
-- ****************
-- ************************************
SELECT * FROM x_Patient WHERE LEN(PatVendorID) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient PatVendorID will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(FirstName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient FirstName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(MiddleName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient MiddleName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(LastName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient LastName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient AddressLine1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient AddressLine2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient City will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient State will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient ZipCode will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient ZipCode column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(HomePhone) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient HomePhone will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(HomePhone, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
--BEGIN
--	-- No Source Table
--	SET @Message = 'Values in x_Patient HomePhone column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
--------------------
SELECT * FROM x_Patient WHERE LEN(WorkPhone) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient WorkPhone will be truncated. Process aborted'
	Print @Message
	RETURN
END
--SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(WorkPhone, 0)) = 0
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	-- No Source Table
--	SET @Message = 'Values in x_Patient WorkPhone column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
--------------------
SELECT * FROM x_Patient WHERE LEN(SSN) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient SSN will be truncated. Process aborted'
	Print @Message
	RETURN
END
--SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(SSN, 0)) = 0
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	-- No Source Table
--	SET @Message = 'Values in x_Patient SSN column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
-------
--------------------
SELECT * FROM x_Patient WHERE LEN(Gender) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient Gender will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE ISDATE(DOB) = 0 AND DOB IS NOT NULL
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient DOB column must be Date Type. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(InsVendorID1) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient InsVendorID1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(PolicyNumber1) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient PolicyNumber1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(GroupNumber1) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient GroupNumber1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Copay1, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient Copay1 column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(InsVendorID2) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient InsVendorID2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(PolicyNumber2) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient PolicyNumber2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(GroupNumber2) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient GroupNumber2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Copay2, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient Copay2 column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(InsVendorID3) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient InsVendorID3 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(PolicyNumber3) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient PolicyNumber3 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(GroupNumber3) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient GroupNumber3 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Copay3, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Copay3 column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
-- ///////////////////////////////////////////////////////////////////////////////////////


-- ?????????????????????????????????????????????????????????????????
-- Check data type to import

-- ?????????????????????????????????????????????????????????????????

BEGIN TRANSACTION


INSERT INTO VendorImport (VendorName, VendorFormat, DateCreated, Notes)
VALUES ('Chuck Bagby', 'csv', GETDATE(), 'None')
SET @VendorImportID = SCOPE_IDENTITY()

Select @Message = 'VendorID '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @VendorImportID )


--**************************** PRACTICE ID ***************************
--INSERT INTO Practice ([Name], VendorImportID) VALUES ('Medford OB/GYN Associates', @VendorImportID)
--SET @PracticeID = SCOPE_IDENTITY()

SET @PracticeID = 3

--SELECT @PracticeID = PracticeID 
--FROM Practice
--WHERE [Name] = 'Chucks practice'
--********************************************************************

INSERT INTO InsuranceCompany 
	(InsuranceCompanyName, 
	AddressLine1, 
	AddressLine2, 
	City, 
	State, 
	ZipCode, 
	Phone, 
	InsuranceProgramCode,
	ReviewCode, 
	CreatedPracticeID, 
	VendorID, 
	VendorImportID)
SELECT DISTINCT
	x_InsuranceCompany.InsuranceCompanyName, 
	x_InsuranceCompany.AddressLine1, 
	x_InsuranceCompany.AddressLine2, 
	x_InsuranceCompany.City, 
	x_InsuranceCompany.State, 
	x_InsuranceCompany.ZipCode, 
	x_InsuranceCompany.Phone, 
	ISNULL(x_InsuranceCompany.InsuranceProgramCode, 'ZZ') AS InsuranceProgramCode,
	'R', 
	@PracticeID, 
	x_InsuranceCompany.InsVendorID, 
	@VendorImportID
FROM x_InsuranceCompany 
	LEFT OUTER JOIN InsuranceCompany 
	ON x_InsuranceCompany.State = InsuranceCompany.State 
	AND x_InsuranceCompany.InsuranceCompanyName = InsuranceCompany.InsuranceCompanyName
	AND x_InsuranceCompany.City = InsuranceCompany.City 
	AND x_InsuranceCompany.AddressLine1 = InsuranceCompany.AddressLine1 
	AND x_InsuranceCompany.ZipCode = InsuranceCompany.ZipCode
WHERE LEN(x_InsuranceCompany.InsuranceCompanyName) > 0 
	AND (InsuranceCompany.InsuranceCompanyName IS NULL)

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsuranceCompany Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [x_InsuranceCompany]
Select @Message = 'Rows in original x_InsuranceCompany Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- Create Default InsuranceCompanyPlan from Insurance Company
INSERT INTO
	InsuranceCompanyPlan
	(InsuranceCompanyID, 
	PlanName, 
	AddressLine1, 
	AddressLine2, 
	City, 
	State, 
	ZipCode, 
	Phone, 
	ReviewCode, 
	CreatedPracticeID, 
	VendorID, 
	VendorImportID)
SELECT
	InsuranceCompany.InsuranceCompanyID, 
	InsuranceCompany.InsuranceCompanyName, 
	InsuranceCompany.AddressLine1, 
	InsuranceCompany.AddressLine2, 
	InsuranceCompany.City, 
	InsuranceCompany.State, 
	InsuranceCompany.ZipCode, 
	InsuranceCompany.Phone, 
	'R', 
	@PracticeID, 
	InsuranceCompany.VendorID, 
	@VendorImportID
FROM dbo.InsuranceCompany 
	INNER JOIN
  (SELECT MIN(InsuranceCompanyID) AS InsuranceCompanyID, InsuranceCompanyName, AddressLine1, City, State, ZipCode
    FROM dbo.InsuranceCompany AS InsuranceCompany_1
    GROUP BY InsuranceCompanyName, AddressLine1, City, State, ZipCode) AS InsuranceCompany_Uniquee 
	ON dbo.InsuranceCompany.InsuranceCompanyID = InsuranceCompany_Uniquee.InsuranceCompanyID 
	INNER JOIN dbo.x_InsuranceCompany 
	ON InsuranceCompany_Uniquee.InsuranceCompanyName = dbo.x_InsuranceCompany.InsuranceCompanyName 
	AND InsuranceCompany_Uniquee.AddressLine1 = dbo.x_InsuranceCompany.AddressLine1 
	AND InsuranceCompany_Uniquee.City = dbo.x_InsuranceCompany.City 
	AND InsuranceCompany_Uniquee.State = dbo.x_InsuranceCompany.State 
	AND InsuranceCompany_Uniquee.ZipCode = dbo.x_InsuranceCompany.ZipCode 
	LEFT OUTER JOIN dbo.InsuranceCompanyPlan 
	ON dbo.InsuranceCompany.InsuranceCompanyName = dbo.InsuranceCompanyPlan.PlanName 
	AND dbo.InsuranceCompany.State = dbo.InsuranceCompanyPlan.State 
	AND dbo.InsuranceCompany.AddressLine1 = dbo.InsuranceCompanyPlan.AddressLine1 
	AND dbo.InsuranceCompany.City = dbo.InsuranceCompanyPlan.City 
	AND dbo.InsuranceCompany.ZipCode = dbo.InsuranceCompanyPlan.ZipCode
WHERE (LEN(dbo.InsuranceCompany.InsuranceCompanyName) > 0) 
	AND (dbo.InsuranceCompanyPlan.PlanName IS NULL)

-- Above Joins x_InsuranceCompany to InsuranceCompany_Unique to InsuranceCompany
-- to ensure we are not creating duplicate InsuranceCompanyPlan records

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsuranceCompanyPlan Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM InsuranceCompany
Select @Message = 'Rows in original InsuranceCompany Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--
--process patients
--

--employer creation

/* SKIPPING: current lytec data has no employers set */

--provider creation

INSERT INTO Doctor
	(PracticeID, 
	Prefix,
	FirstName, 
	MiddleName, 
	LastName, 
	Suffix,
	AddressLine1,
	AddressLine2,
	City,
	State,
	ZipCode,
	SSN,
	HomePhone,
	[External], 
	VendorID, 
	VendorImportID)
SELECT DISTINCT 
	@PracticeID,
	'' AS Prefix,
	ISNULL(x_Doctor.FirstName, '') AS FirstName,
	'' AS MiddleName,	--	x_Doctor.MiddleName,
	ISNULL(x_Doctor.LastName, '') AS LastName,
	'' AS Suffix,
	x_Doctor.AddressLine1, 
	x_Doctor.AddressLine2, 
	x_Doctor.City, 
	x_Doctor.State, 
	x_Doctor.ZipCode, 
	x_Doctor.SSN, 
	x_Doctor.HomePhone, 
	x_Doctor.[External],
	x_Doctor.VendorID,
	@VendorImportID 
FROM x_Doctor 
	LEFT OUTER JOIN 
	(SELECT MIN(DoctorID) AS DoctorID, FirstName, LastName
	FROM dbo.Doctor
	WHERE (PracticeID = @PracticeID)
	GROUP BY FirstName, LastName) AS DoctorMinID
	ON x_Doctor.LastName = DoctorMinID.LastName 
	AND x_Doctor.FirstName = DoctorMinID.FirstName
	WHERE (DoctorMinID.LastName IS NULL)
		AND ((x_Doctor.LastName IS NOT NULL) OR (x_Doctor.FirstName IS NOT NULL))

-- Above ensures nor duplication from existing doctors

Select @Rows = @@RowCount
Select @Message = 'Rows Added in Doctor Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [x_Doctor]
Select @Message = 'Rows in original x_Doctor Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--patient

INSERT INTO Patient
	(PracticeID, 
	ReferringPhysicianID, 
	Prefix, 
	FirstName, 
	MiddleName, 
	LastName, 
	Suffix, 
	AddressLine1, 
	AddressLine2, 
	City, 
	State, 
	ZipCode, 
	Gender, 
--	MaritalStatus, 
	HomePhone, 
	WorkPhone, 
--	WorkPhoneExt, 
	DOB, 
	SSN, 
	PrimaryProviderID, 
--	MedicalRecordNumber, 
	PrimaryCarePhysicianID, 
	VendorID, 
	VendorImportID)
SELECT
	@PracticeID, 
	Doctor_Ref.DoctorID, 
	'' AS Prefix, --	x_Patient.Prefix, 
	ISNULL(x_Patient.FirstName, '') AS FirstName, 
	ISNULL(x_Patient.MiddleName, '') AS MiddleName,
	ISNULL(x_Patient.LastName, '') AS LastName,
	'' AS Suffix, --	x_Patient.Suffix, 
	x_Patient.AddressLine1, 
	x_Patient.AddressLine2, 
	x_Patient.City, 
	x_Patient.State, 
	x_Patient.ZipCode, 
	x_Patient.Gender, 
--	x_Patient.MaritalStatus, 
	x_Patient.HomePhone, 
	x_Patient.WorkPhone, 
--	x_Patient.WorkPhoneExt, 
	x_Patient.DOB, 
	x_Patient.SSN, 
	DoctorPhy.DoctorID,  
--	x_Patient.MedicalRecordNumber, 
	DoctorPhy.DoctorID, 
	x_Patient.PatVendorID, 
	@VendorImportID
FROM x_Doctor AS x_Doctor_1 
INNER JOIN
  (SELECT FirstName, LastName, MIN(DoctorID) AS DoctorID
    FROM Doctor
    GROUP BY FirstName, LastName) AS Doctor_Ref 
ON x_Doctor_1.FirstName = Doctor_Ref.FirstName 
AND x_Doctor_1.LastName = Doctor_Ref.LastName 
RIGHT OUTER JOIN dbo.x_Patient 
ON x_Doctor_1.VendorID = dbo.x_Patient.[REFERRING DOCTOR CODE] 
LEFT OUTER JOIN
      (SELECT FirstName, LastName, MIN(DoctorID) AS DoctorID
        FROM dbo.Doctor AS Doctor_1
        GROUP BY FirstName, LastName) AS DoctorPhy 
INNER JOIN dbo.x_Doctor 
ON DoctorPhy.LastName = dbo.x_Doctor.LastName 
AND DoctorPhy.FirstName = dbo.x_Doctor.FirstName 
ON dbo.x_Patient.[ASSIGNED DOCTOR CODE] = dbo.x_Doctor.VendorID

-- Subqueries above to ensure that we are getting individual doctors
-- and not creating duplicate Patient records

Select @Rows = @@RowCount
Select @Message = 'Rows Added in Patient Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM x_Patient
Select @Message = 'Rows in original x_Patient Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--patient case creation

INSERT INTO PatientCase(
	PatientID, 
	[Name], 
	PayerScenarioID, 
	ReferringPhysicianID, 
	PracticeID, 
	VendorID, 
	VendorImportID)
SELECT
	Patient.PatientID, 
	'Default Case', 
	@DefaultPayerScenarioID, 
	Patient.ReferringPhysicianID, 
	@PracticeID, 
	Patient.VendorID, 
	@VendorImportID
FROM
	Patient
WHERE
	Patient.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in PatientCase Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--add dates: total disability (5)


--
--insurance policy creation
--

--Primary Policy, First patients with their own insurance

INSERT INTO InsurancePolicy
	(PracticeID, 
	PatientCaseID, 
	InsuranceCompanyPlanID, 
	Precedence, 
	PolicyNumber, 
	GroupNumber, 
	PatientRelationshipToInsured,
	Copay,
	VendorID)
SELECT DISTINCT
	@PracticeID,
	PatientCase.PatientCaseID,
	InsuranceCompanyPlan_Unique.InsuranceCompanyPlanID,
	1 AS Precedence,
	x_Patient.PolicyNumber1,
	x_Patient.GroupNumber1,
	'U' AS PatientRelationshipToInsured,
	ISNULL(x_Patient.Copay1, 0) AS Copay,
	x_Patient.InsVendorID1 AS VendorID
FROM  dbo.x_Patient 
	INNER JOIN dbo.PatientCase 
	INNER JOIN dbo.Patient 
	ON dbo.PatientCase.PatientID = dbo.Patient.PatientID 
	ON dbo.x_Patient.PatVendorID = dbo.Patient.VendorID 
	INNER JOIN dbo.x_InsuranceCompany 
	ON dbo.x_Patient.InsVendorID1 = dbo.x_InsuranceCompany.InsVendorID 
	INNER JOIN
	  (SELECT MIN(InsuranceCompanyPlanID) AS InsuranceCompanyPlanID, PlanName, AddressLine1, City, State, ZipCode
		FROM dbo.InsuranceCompanyPlan
		GROUP BY PlanName, AddressLine1, City, State, ZipCode) AS InsuranceCompanyPlan_Unique 
	ON dbo.x_InsuranceCompany.InsuranceCompanyName = InsuranceCompanyPlan_Unique.PlanName 
	AND dbo.x_InsuranceCompany.AddressLine1 = InsuranceCompanyPlan_Unique.AddressLine1 
	AND dbo.x_InsuranceCompany.City = InsuranceCompanyPlan_Unique.City 
	AND dbo.x_InsuranceCompany.State = InsuranceCompanyPlan_Unique.State 
	AND dbo.x_InsuranceCompany.ZipCode = InsuranceCompanyPlan_Unique.ZipCode
	WHERE dbo.Patient.VendorImportID = @VendorImportID

--FROM  dbo.InsuranceCompanyPlan 
--	INNER JOIN dbo.x_Patient
--	INNER JOIN dbo.PatientCase 
--	INNER JOIN dbo.Patient
--	ON dbo.PatientCase.PatientID = dbo.Patient.PatientID 
--	ON dbo.x_Patient.PatVendorID = dbo.Patient.VendorID 
--	INNER JOIN dbo.InsuranceCompany 
--	INNER JOIN dbo.x_InsuranceCompany 
--	ON dbo.InsuranceCompany.State = dbo.x_InsuranceCompany.State 
--	AND dbo.InsuranceCompany.InsuranceCompanyName = x_InsuranceCompany.InsuranceCompanyName 
--	AND dbo.InsuranceCompany.City = dbo.x_InsuranceCompany.City 
--	AND dbo.InsuranceCompany.AddressLine1 = dbo.x_InsuranceCompany.AddressLine1 
--	AND dbo.InsuranceCompany.ZipCode = dbo.x_InsuranceCompany.ZipCode 
--	ON dbo.x_Patient.InsVendorID1 = dbo.x_InsuranceCompany.InsVendorID 
--	ON dbo.InsuranceCompanyPlan.InsuranceCompanyID = dbo.InsuranceCompany.InsuranceCompanyID

-- ********* Rewrite to ensure no duplicate InsuranceCompany and no duplicate InsuranceCompanyPlan

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy Table primary '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- Secondary Insurance Policy
INSERT INTO InsurancePolicy
	(PracticeID, 
	PatientCaseID, 
	InsuranceCompanyPlanID, 
	Precedence, 
	PolicyNumber, 
	GroupNumber, 
	PatientRelationshipToInsured,
	Copay,
	VendorID)
SELECT DISTINCT
	@PracticeID,
	PatientCase.PatientCaseID,
	InsuranceCompanyPlan_Unique.InsuranceCompanyPlanID,
	2 AS Precedence,
	x_Patient.PolicyNumber2,
	x_Patient.GroupNumber2,
	'U' AS PatientRelationshipToInsured,
	ISNULL(x_Patient.Copay2, 0) AS Copay,
	x_Patient.InsVendorID2 AS VendorID
FROM  dbo.x_Patient 
	INNER JOIN dbo.PatientCase 
	INNER JOIN dbo.Patient 
	ON dbo.PatientCase.PatientID = dbo.Patient.PatientID 
	ON dbo.x_Patient.PatVendorID = dbo.Patient.VendorID 
	INNER JOIN dbo.x_InsuranceCompany 
	ON dbo.x_Patient.InsVendorID2 = dbo.x_InsuranceCompany.InsVendorID 
	INNER JOIN
	  (SELECT MIN(InsuranceCompanyPlanID) AS InsuranceCompanyPlanID, PlanName, AddressLine1, City, State, ZipCode
		FROM dbo.InsuranceCompanyPlan
		GROUP BY PlanName, AddressLine1, City, State, ZipCode) AS InsuranceCompanyPlan_Unique 
	ON dbo.x_InsuranceCompany.InsuranceCompanyName = InsuranceCompanyPlan_Unique.PlanName 
	AND dbo.x_InsuranceCompany.AddressLine1 = InsuranceCompanyPlan_Unique.AddressLine1 
	AND dbo.x_InsuranceCompany.City = InsuranceCompanyPlan_Unique.City 
	AND dbo.x_InsuranceCompany.State = InsuranceCompanyPlan_Unique.State 
	AND dbo.x_InsuranceCompany.ZipCode = InsuranceCompanyPlan_Unique.ZipCode
	WHERE dbo.Patient.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy Table 2nd '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- 3rd Insurance Policy
INSERT INTO InsurancePolicy
	(PracticeID, 
	PatientCaseID, 
	InsuranceCompanyPlanID, 
	Precedence, 
	PolicyNumber, 
	GroupNumber, 
	PatientRelationshipToInsured,
	Copay,
	VendorID)
SELECT DISTINCT
	@PracticeID,
	PatientCase.PatientCaseID,
	InsuranceCompanyPlan_Unique.InsuranceCompanyPlanID,
	3 AS Precedence,
	x_Patient.PolicyNumber3,
	x_Patient.GroupNumber3,
	'U' AS PatientRelationshipToInsured,
	ISNULL(x_Patient.Copay3, 0) AS Copay,
	x_Patient.InsVendorID3 AS VendorID
FROM  dbo.x_Patient 
	INNER JOIN dbo.PatientCase 
	INNER JOIN dbo.Patient 
	ON dbo.PatientCase.PatientID = dbo.Patient.PatientID 
	ON dbo.x_Patient.PatVendorID = dbo.Patient.VendorID 
	INNER JOIN dbo.x_InsuranceCompany 
	ON dbo.x_Patient.InsVendorID3 = dbo.x_InsuranceCompany.InsVendorID 
	INNER JOIN
	  (SELECT MIN(InsuranceCompanyPlanID) AS InsuranceCompanyPlanID, PlanName, AddressLine1, City, State, ZipCode
		FROM dbo.InsuranceCompanyPlan
		GROUP BY PlanName, AddressLine1, City, State, ZipCode) AS InsuranceCompanyPlan_Unique 
	ON dbo.x_InsuranceCompany.InsuranceCompanyName = InsuranceCompanyPlan_Unique.PlanName 
	AND dbo.x_InsuranceCompany.AddressLine1 = InsuranceCompanyPlan_Unique.AddressLine1 
	AND dbo.x_InsuranceCompany.City = InsuranceCompanyPlan_Unique.City 
	AND dbo.x_InsuranceCompany.State = InsuranceCompanyPlan_Unique.State 
	AND dbo.x_InsuranceCompany.ZipCode = InsuranceCompanyPlan_Unique.ZipCode
	WHERE dbo.Patient.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy Table 3rd '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- ROLLBACK TRANSACTION
-- COMMIT TRANSACTION

--	DECLARE @VendorImportID INT
--	SET @VendorImportID = 14
------	DELETE FROM Practice WHERE VendorImportID = @VendorImportID
--	DELETE FROM PatientCaseDate FROM PatientCaseDate PCD INNER JOIN PatientCase PC ON PCD.PatientCaseID = PC.PatientCaseID WHERE PC.VendorImportID = @VendorImportID
--	DELETE FROM InsurancePolicy FROM PatientCase INNER JOIN InsurancePolicy ON PatientCase.PatientCaseID = InsurancePolicy.PatientCaseID WHERE (PatientCase.VendorImportID = @VendorImportID)
--	DELETE FROM PatientCase WHERE VendorImportID = @VendorImportID
--	DELETE FROM Patient WHERE VendorImportID = @VendorImportID
--	DELETE FROM ProviderNumber FROM ProviderNumber PN INNER JOIN Doctor D ON D.DoctorID = PN.DoctorID WHERE D.VendorImportID = @VendorImportID
--	DELETE FROM Doctor WHERE VendorImportID = @VendorImportID
--	DELETE FROM InsuranceCompanyPlan FROM InsuranceCompanyPlan INNER JOIN InsuranceCompany ON InsuranceCompanyPlan.InsuranceCompanyID = InsuranceCompany.InsuranceCompanyID WHERE InsuranceCompany.VendorImportID = @VendorImportID
--	DELETE FROM InsuranceCompany WHERE VendorImportID = @VendorImportID
----	DELETE FROM VendorImport WHERE VendorImportID = @VendorImportID
--	DELETE FROM ServiceLocation WHERE VendorImportID = @VendorImportID

