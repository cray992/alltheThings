-- ***************************************************************
-- *** NEED PracticeID Below
-- *** NEED Synonyms assigned below
-- Vendor Import Data
-- ***************************************************************

-- Generic procedure for importing Doctor, Patient and Insurance data
-- We have three flat tables
-- x_Doctor, x_Patient, and x_InsCo
SET NOCOUNT ON
-- ==================================================================
--	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_Doctor')
--	DROP SYNONYM [dbo].[x_Doctor]
--    GO
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_Patient')
	DROP SYNONYM [dbo].[x_Patient]
    GO
--	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_InsuranceCompany')
--	DROP SYNONYM [dbo].[x_InsuranceCompany]
--    GO
--    Create Synonym x_Doctor For dbo.xDoctorTotal
--    Go
    Create Synonym x_Patient For dbo.x_PATS_txt_2
    Go
--    Create Synonym x_InsuranceCompany For dbo.xInsuranceCarrier
--    Go
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

--SELECT * FROM x_Doctor WHERE LEN(FirstName) > 64
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor FirstName will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
------------------
--SELECT * FROM x_Doctor WHERE LEN(MiddleName) > 64
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor MiddleName will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
-----------------
--SELECT * FROM x_Doctor WHERE LEN(LastName) > 64
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor LastName will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
-----------------
--SELECT * FROM x_Doctor WHERE LEN(AddressLine1) > 256
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor AddressLine1 will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
------------------
--SELECT * FROM x_Doctor WHERE LEN(AddressLine2) > 256
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor AddressLine2 will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
------------------
--SELECT * FROM x_Doctor WHERE LEN(City) > 128
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor City will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
-------------------
--SELECT * FROM x_Doctor WHERE LEN(State) > 2
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor State will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
-------------------
--SELECT * FROM x_Doctor WHERE LEN(ZipCode) > 9
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor ZipCode will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
--SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_Doctor ZipCode column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
-------------------
--SELECT * FROM x_Doctor WHERE LEN(SSN) > 9
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_Doctor SSN will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
--SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(SSN, 0)) = 0
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_Doctor SSN column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
--------------------
--SELECT * FROM x_Doctor WHERE LEN(HomePhone) > 10
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_Doctor HomePhone will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
--SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(HomePhone, 0)) = 0
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_Doctor HomePhone column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
--------------------
--SELECT * FROM x_Doctor WHERE LEN(WorkPhone) > 10
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor WorkPhone will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
--SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(WorkPhone, 0)) = 0
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_Doctor WorkPhone column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
--------------------
--SELECT * FROM x_Doctor WHERE LEN(Degree) > 8
----UPDATE x_Doctor SET Degree = NULL WHERE LEN(Degree) > 8
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor Degree will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
--------------------
--SELECT * FROM x_Doctor WHERE LEN(VendorID) > 10
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor VendorID will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
--------------------
--SELECT * FROM x_Doctor WHERE LEN(FaxNumber) > 10
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor FaxNumber will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
--SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(FaxNumber, 0)) = 0
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_Doctor FaxNumber column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
--------------------
--SELECT * FROM x_Doctor WHERE LEN([External]) > 1
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in Doctor [External] will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
--SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL([External], 0)) = 0
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_Doctor [External] column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
---- ****************
---- ************************************
--SELECT * FROM x_InsuranceCompany WHERE LEN(InsVendorID) > 50
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany InsVendorID will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
---------------------
--SELECT * FROM x_InsuranceCompany WHERE LEN(InsuranceCompanyName) > 128
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany InsuranceCompanyName will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
---------------------
--SELECT * FROM x_InsuranceCompany WHERE LEN(AddressLine1) > 256
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany AddressLine1 will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
---------------------
--SELECT * FROM x_InsuranceCompany WHERE LEN(AddressLine2) > 256
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany AddressLine2 will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
---------------------
--SELECT * FROM x_InsuranceCompany WHERE LEN(City) > 128
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany City will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
----------------------
--SELECT * FROM x_InsuranceCompany WHERE LEN(State) > 2
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany State will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
----------------------
--SELECT * FROM x_InsuranceCompany WHERE LEN(ZipCode) > 9
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany ZipCode will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
--SELECT * FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany ZipCode column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
-----------------------
--SELECT * FROM x_InsuranceCompany WHERE LEN(ContactFirstName) > 64
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany ContactFirstName will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
----------------------
--SELECT * FROM x_InsuranceCompany WHERE LEN(Phone) > 10
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany Phone will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
--SELECT * FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(Phone, 0)) = 0
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany Phone column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
-----------------------
--SELECT * FROM x_InsuranceCompany WHERE LEN(Fax) > 10
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany Fax will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
--SELECT * FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(Fax, 0)) = 0
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany Fax column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
-----------------------
--SELECT * FROM x_InsuranceCompany WHERE LEN(InsuranceProgramCode) > 2
--Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	SET @Message = 'Values in x_InsuranceCompany InsuranceProgramCode will be truncated. Process aborted'
--	Print @Message
--	RETURN
--END
-- ****************
-- ************************************
SELECT * FROM x_Patient WHERE LEN(PatVendorID) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient PatVendorID will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(FirstName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient FirstName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(MiddleName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient MiddleName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(LastName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient LastName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient AddressLine1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient AddressLine2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient City will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient State will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient ZipCode will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient ZipCode column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(HomePhone) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
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
	SET @Message = 'Values in x_Patient WorkPhone will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(WorkPhone, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient WorkPhone column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(WorkPhoneExt) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient WorkPhoneExt will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(WorkPhoneExt, 0)) = 0
Select @Rows = @@RowCount
--IF @Rows > 0
--BEGIN
--	-- No Source Table
--	SET @Message = 'Values in x_Patient WorkPhoneExt column must be numeric. Process is aborted'
--	Print @Message
--	RETURN
--END
--------------------
SELECT * FROM x_Patient WHERE LEN(SSN) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient SSN will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(SSN, 0)) = 0
--UPDATE x_Patient SET SSN = NULL WHERE SSN = ''
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in x_Patient SSN column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Gender) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Gender will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE ISDATE(DOB) = 0 AND DOB IS NOT NULL
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient DOB column must be Date Type. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(InsVendorID1) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient InsVendorID1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(PolicyNumber1) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient PolicyNumber1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(GroupNumber1) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient GroupNumber1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Copay1, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Copay1 column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------


--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1PatientRelationshipToInsured) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1PatientRelationshipToInsured will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1FirstName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1FirstName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1MiddleName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1MiddleName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1LastName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1LastName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE ISDATE(Holder1DOB) = 0 AND (NOT Holder1DOB IS NULL)
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1DOB column must be Date Type. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1EmployerName) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1EmployerName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1Gender) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1Gender will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1AddressLine1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1AddressLine2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1City will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1State will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1ZipCode will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder1ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1ZipCode column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1Phone) > 10
--UPDATE x_Patient SET Holder1Phone = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Holder1Phone, '(', ''), ')', ''), '-', ''), ' ', ''), '_', '')
--UPDATE x_Patient SET Holder1Phone = NULL WHERE Holder1Phone = ''
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1Phone will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder1Phone, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder1Phone column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(AdjusterLastName1) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient AdjusterLastName1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
--------------------
SELECT * FROM x_Patient WHERE LEN(InsVendorID2) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient InsVendorID2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(PolicyNumber2) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient PolicyNumber2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(GroupNumber2) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient GroupNumber2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Copay2, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Copay2 column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2PatientRelationshipToInsured) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2PatientRelationshipToInsured will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2FirstName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2FirstName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2MiddleName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2MiddleName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2LastName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2LastName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE ISDATE(Holder2DOB) = 0 AND Holder2DOB IS NOT NULL
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2DOB column must be Date Type. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2EmployerName) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2EmployerName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2Gender) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2Gender will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2AddressLine1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2AddressLine2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2City will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2State will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2ZipCode will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder2ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2ZipCode column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2Phone) > 10
--UPDATE x_Patient SET Holder2Phone = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Holder2Phone, '(', ''), ')', ''), '-', ''), ' ', ''), '_', '')
--UPDATE x_Patient SET Holder2Phone = NULL WHERE Holder2Phone = ''
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2Phone will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder2Phone, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder2Phone column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(AdjusterLastName2) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient AdjusterLastName2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
---------------------
---------------------

SELECT * FROM x_Patient WHERE LEN(InsVendorID3) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient InsVendorID3 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(PolicyNumber3) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
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
SELECT * FROM x_Patient WHERE LEN(Holder3PatientRelationshipToInsured) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3PatientRelationshipToInsured will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3FirstName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3FirstName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3MiddleName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3MiddleName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3LastName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3LastName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE ISDATE(Holder3DOB) = 0 AND Holder3DOB IS NOT NULL
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3DOB column must be Date Type. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3EmployerName) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3EmployerName will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3Gender) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3Gender will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3AddressLine1 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3AddressLine2 will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3City will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3State will be truncated. Process aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3ZipCode will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder3ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3ZipCode column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3Phone) > 10
--UPDATE x_Patient SET Holder3Phone = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Holder3Phone, '(', ''), ')', ''), '-', ''), ' ', ''), '_', '')
--UPDATE x_Patient SET Holder3Phone = NULL WHERE Holder3Phone = ''
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3Phone will be truncated. Process aborted'
	Print @Message
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder3Phone, 0)) = 0

Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient Holder3Phone column must be numeric. Process is aborted'
	Print @Message
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(AdjusterLastName3) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	SET @Message = 'Values in x_Patient AdjusterLastName3 will be truncated. Process aborted'
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
--INSERT INTO Practice ([Name], VendorImportID) VALUES ('FlatIrons Import 12/29/06', 1)
--SET @PracticeID = SCOPE_IDENTITY()

SET @PracticeID = 19

--SELECT @PracticeID = PracticeID 
--FROM Practice
--WHERE [Name] = 'Chucks practice'
--********************************************************************
----
----INSERT INTO InsuranceCompany 
----	(InsuranceCompanyName, 
----	AddressLine1, 
----	AddressLine2, 
----	City, 
----	State, 
----	ZipCode, 
----	ContactFirstName,
----	Phone, 
----	Fax,
------	InsuranceProgramCode,
----	ReviewCode, 
----	CreatedPracticeID, 
----	VendorID, 
----	VendorImportID)
----SELECT DISTINCT
----	x_InsuranceCompany.InsuranceCompanyName, 
----	x_InsuranceCompany.AddressLine1, 
----	x_InsuranceCompany.AddressLine2, 
----	x_InsuranceCompany.City, 
----	x_InsuranceCompany.State, 
----	x_InsuranceCompany.ZipCode, 
----	x_InsuranceCompany.ContactFirstName,
----	x_InsuranceCompany.Phone, 
----	x_InsuranceCompany.Fax,
------	'' AS InsuranceProgramCode, --ISNULL(x_InsuranceCompany.InsuranceProgramCode, 'ZZ') AS InsuranceProgramCode,
----	'R', 
----	@PracticeID, 
----	x_InsuranceCompany.InsVendorID, 
----	@VendorImportID
----FROM x_InsuranceCompany 
----	LEFT OUTER JOIN InsuranceCompany 
----	ON x_InsuranceCompany.State = InsuranceCompany.State 
----	AND x_InsuranceCompany.InsuranceCompanyName = InsuranceCompany.InsuranceCompanyName
----	AND x_InsuranceCompany.City = InsuranceCompany.City 
----	AND x_InsuranceCompany.AddressLine1 = InsuranceCompany.AddressLine1 
----	AND x_InsuranceCompany.ZipCode = InsuranceCompany.ZipCode
----WHERE LEN(x_InsuranceCompany.InsuranceCompanyName) > 0 
----	AND (InsuranceCompany.InsuranceCompanyName IS NULL)
----
----Select @Rows = @@RowCount
----Select @Message = 'Rows Added in InsuranceCompany Table '
----Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
----
----SELECT @Rows = COUNT(*) FROM [x_InsuranceCompany]
----Select @Message = 'Rows in original x_InsuranceCompany Table '
----Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
----
------ Create Default InsuranceCompanyPlan from Insurance Company
----INSERT INTO
----	InsuranceCompanyPlan
----	(InsuranceCompanyID, 
----	PlanName, 
----	AddressLine1, 
----	AddressLine2, 
----	City, 
----	State, 
----	ZipCode, 
----	Phone, 
----	ReviewCode, 
----	CreatedPracticeID, 
----	VendorID, 
----	VendorImportID)
----SELECT
----	InsuranceCompany.InsuranceCompanyID, 
----	InsuranceCompany.InsuranceCompanyName, 
----	InsuranceCompany.AddressLine1, 
----	InsuranceCompany.AddressLine2, 
----	InsuranceCompany.City, 
----	InsuranceCompany.State, 
----	InsuranceCompany.ZipCode, 
----	InsuranceCompany.Phone, 
----	'R', 
----	@PracticeID, 
----	InsuranceCompany.VendorID, 
----	@VendorImportID
----FROM dbo.InsuranceCompany 
----	INNER JOIN
----  (SELECT MIN(InsuranceCompanyID) AS InsuranceCompanyID, InsuranceCompanyName, AddressLine1, City, State, ZipCode
----    FROM dbo.InsuranceCompany AS InsuranceCompany_1
----    GROUP BY InsuranceCompanyName, AddressLine1, City, State, ZipCode) AS InsuranceCompany_Uniquee 
----	ON dbo.InsuranceCompany.InsuranceCompanyID = InsuranceCompany_Uniquee.InsuranceCompanyID 
----	INNER JOIN dbo.x_InsuranceCompany 
----	ON InsuranceCompany_Uniquee.InsuranceCompanyName = dbo.x_InsuranceCompany.InsuranceCompanyName 
----	AND InsuranceCompany_Uniquee.AddressLine1 = dbo.x_InsuranceCompany.AddressLine1 
----	AND InsuranceCompany_Uniquee.City = dbo.x_InsuranceCompany.City 
----	AND InsuranceCompany_Uniquee.State = dbo.x_InsuranceCompany.State 
----	AND InsuranceCompany_Uniquee.ZipCode = dbo.x_InsuranceCompany.ZipCode 
----	LEFT OUTER JOIN dbo.InsuranceCompanyPlan 
----	ON dbo.InsuranceCompany.InsuranceCompanyName = dbo.InsuranceCompanyPlan.PlanName 
----	AND dbo.InsuranceCompany.State = dbo.InsuranceCompanyPlan.State 
----	AND dbo.InsuranceCompany.AddressLine1 = dbo.InsuranceCompanyPlan.AddressLine1 
----	AND dbo.InsuranceCompany.City = dbo.InsuranceCompanyPlan.City 
----	AND dbo.InsuranceCompany.ZipCode = dbo.InsuranceCompanyPlan.ZipCode
----WHERE (LEN(dbo.InsuranceCompany.InsuranceCompanyName) > 0) 
----	AND (dbo.InsuranceCompanyPlan.PlanName IS NULL)
----
------ Above Joins x_InsuranceCompany to InsuranceCompany_Unique to InsuranceCompany
------ to ensure we are not creating duplicate InsuranceCompanyPlan records
----
----Select @Rows = @@RowCount
----Select @Message = 'Rows Added in InsuranceCompanyPlan Table '
----Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
----
----SELECT @Rows = COUNT(*) FROM InsuranceCompany
----Select @Message = 'Rows in original InsuranceCompany Table '
----Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
----
------
------process patients
------
----
------employer creation
----
----/* SKIPPING: current lytec data has no employers set */
----
------provider creation
----
----INSERT INTO Doctor
----	(PracticeID, 
----	Prefix,
----	FirstName, 
----	MiddleName, 
----	LastName, 
----	Suffix,
----	AddressLine1,
----	AddressLine2,
----	City,
----	State,
----	ZipCode,
----	SSN,
----	HomePhone,
----	WorkPhone,
----	Notes,
----	Degree,
----	VendorID, 
----	VendorImportID,
----	FaxNumber,
----	[External])
----SELECT DISTINCT 
----	@PracticeID,
----	'' AS Prefix,
----	ISNULL(x_Doctor.FirstName, '') AS FirstName,
----	ISNULL(x_Doctor.MiddleName, '') AS MiddleName,
----	ISNULL(x_Doctor.LastName, '') AS LastName,
----	'' AS Suffix,
----	x_Doctor.AddressLine1, 
----	x_Doctor.AddressLine2, 
----	x_Doctor.City, 
----	x_Doctor.State, 
----	x_Doctor.ZipCode, 
----	x_Doctor.SSN, 
----	x_Doctor.HomePhone, 
----	x_Doctor.WorkPhone,
----	x_Doctor.Notes,
----	x_Doctor.Degree,
----	x_Doctor.VendorID,
----	@VendorImportID,
----	x_Doctor.FaxNumber,
----	x_Doctor.[External]
----FROM x_Doctor 
----	LEFT OUTER JOIN 
----	(SELECT MIN(DoctorID) AS DoctorID, FirstName, LastName
----	FROM dbo.Doctor
----	WHERE (PracticeID = @PracticeID)
----	GROUP BY FirstName, LastName) AS DoctorMinID
----	ON x_Doctor.LastName = DoctorMinID.LastName 
----	AND x_Doctor.FirstName = DoctorMinID.FirstName
----	WHERE (DoctorMinID.LastName IS NULL)
----		AND ((x_Doctor.LastName IS NOT NULL) OR (x_Doctor.FirstName IS NOT NULL))
----
------ Above ensures no duplication from existing doctors
----
----Select @Rows = @@RowCount
----Select @Message = 'Rows Added in Doctor Table '
----Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
----
----SELECT @Rows = COUNT(*) FROM [x_Doctor]
----Select @Message = 'Rows in original x_Doctor Table '
----Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
----
---- -- Import Medical License Number 7.
----INSERT INTO ProviderNumber
----	 ( DoctorID
----      , ProviderNumberTypeID
----      , ProviderNumber
----	  , VendorImportID
----    )
----	SELECT dbo.Doctor.DoctorID, 
----	7 AS ProviderNumberTypeID, 
----	x_Doctor.License,
----	@VendorImportID
----	FROM dbo.Doctor 
----	INNER JOIN x_Doctor 
----	ON dbo.Doctor.VendorID = x_Doctor.VendorID
----	WHERE (dbo.Doctor.VendorImportID = @VendorImportID) 
----	AND (ISNULL(x_Doctor.License, '') <> '')
----
----Select @Rows = @@RowCount
----Select @Message = 'Rows Added in ProviderNumber Table for Medical License Number (Providers) '
----Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
----
---- -- Import UPIN Number 25.
----INSERT INTO ProviderNumber
----	 ( DoctorID
----      , ProviderNumberTypeID
----      , ProviderNumber
----	  , VendorImportID
----    )
----	SELECT dbo.Doctor.DoctorID, 
----	25 AS ProviderNumberTypeID, 
----	x_Doctor.Upin,
----	@VendorImportID
----	FROM dbo.Doctor 
----	INNER JOIN x_Doctor 
----	ON dbo.Doctor.VendorID = x_Doctor.VendorID
----	WHERE (dbo.Doctor.VendorImportID = @VendorImportID) 
----	AND (ISNULL(x_Doctor.Upin, '') <> '')
----
----Select @Rows = @@RowCount
----Select @Message = 'Rows Added in ProviderNumber Table for Medical License Number (Providers) '
----Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


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
	MaritalStatus, 
	HomePhone, 
	WorkPhone, 
	WorkPhoneExt, 
	DOB, 
	SSN, 
	PrimaryProviderID, 
	EmploymentStatus,
	MedicalRecordNumber, 
	PrimaryCarePhysicianID, 
	VendorID, 
	VendorImportID)
SELECT DISTINCT
	@PracticeID, 
	NULL, --Doctor_Ref.DoctorID, 
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
	x_Patient.MaritalStatus, 
	x_Patient.HomePhone, 
	x_Patient.WorkPhone, 
	x_Patient.WorkPhoneExt, 
	x_Patient.DOB, 
	x_Patient.SSN, 
	NULL, --DoctorPhy.DoctorID, 
	x_Patient.EmploymentStatus,
	x_Patient.MedicalRecordNumber, 
	NULL, --DoctorPhy.DoctorID, 
	x_Patient.PatVendorID, 
	@VendorImportID
FROM x_Patient

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
	HolderFirstName,
	HolderMiddleName,
	HolderLastName,
	HolderDOB,
	HolderEmployerName,
	HolderGender,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderZipCode,
	HolderPhone,
	AdjusterLastName,
	Copay,
	VendorID)
SELECT DISTINCT
	@PracticeID,
	PatientCase.PatientCaseID,
	InsuranceCompanyPlan_Unique.InsuranceCompanyPlanID,
	1 AS Precedence,
	x_Patient.PolicyNumber1,
	x_Patient.GroupNumber1,
	ISNULL(x_Patient.Holder1PatientRelationshipToInsured, 'U') AS PatientRelationshipToInsured,
	x_Patient.Holder1FirstName,
	x_Patient.Holder1MiddleName,
	x_Patient.Holder1LastName,
	x_Patient.Holder1DOB,
	x_Patient.Holder1EmployerName,
	x_Patient.Holder1Gender,
	x_Patient.Holder1AddressLine1,
	x_Patient.Holder1AddressLine2,
	x_Patient.Holder1City,
	x_Patient.Holder1State,
	x_Patient.Holder1ZipCode,
	x_Patient.Holder1Phone,
	x_Patient.AdjusterLastName1,
	ISNULL(x_Patient.Copay1, 0) AS Copay,
	x_Patient.InsVendorID1 AS VendorID
FROM dbo.InsuranceCompanyPlan INNER JOIN
      (SELECT MIN(InsuranceCompanyPlanID) AS InsuranceCompanyPlanID, PlanName, AddressLine1, City, State, ZipCode
        FROM  dbo.InsuranceCompanyPlan AS InsuranceCompanyPlan_1
        GROUP BY PlanName, AddressLine1, City, State, ZipCode) AS InsuranceCompanyPlan_Unique ON 
	  dbo.InsuranceCompanyPlan.InsuranceCompanyPlanID = InsuranceCompanyPlan_Unique.InsuranceCompanyPlanID 
	INNER JOIN
	  dbo.x_Patient INNER JOIN
	  dbo.PatientCase INNER JOIN
	  dbo.Patient ON dbo.PatientCase.PatientID = dbo.Patient.PatientID ON dbo.x_Patient.PatVendorID = dbo.Patient.VendorID ON 
	  dbo.InsuranceCompanyPlan.VendorID = dbo.x_Patient.InsVendorID1
	WHERE dbo.Patient.VendorImportID = @VendorImportID


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
	HolderFirstName,
	HolderMiddleName,
	HolderLastName,
	HolderDOB,
	HolderEmployerName,
	HolderGender,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderZipCode,
	HolderPhone,
	AdjusterLastName,

	Copay,
	VendorID)
SELECT DISTINCT
	@PracticeID,
	PatientCase.PatientCaseID,
	InsuranceCompanyPlan_Unique.InsuranceCompanyPlanID,
	2 AS Precedence,
	x_Patient.PolicyNumber2,
	x_Patient.GroupNumber2,

	ISNULL(x_Patient.Holder2PatientRelationshipToInsured, 'U') AS PatientRelationshipToInsured,
	x_Patient.Holder2FirstName,
	x_Patient.Holder2MiddleName,
	x_Patient.Holder2LastName,
	x_Patient.Holder2DOB,
	x_Patient.Holder2EmployerName,
	x_Patient.Holder2Gender,
	x_Patient.Holder2AddressLine1,
	x_Patient.Holder2AddressLine2,
	x_Patient.Holder2City,
	x_Patient.Holder2State,
	x_Patient.Holder2ZipCode,
	x_Patient.Holder2Phone,
	x_Patient.AdjusterLastName2,

	ISNULL(x_Patient.Copay2, 0) AS Copay,
	x_Patient.InsVendorID2 AS VendorID
FROM dbo.InsuranceCompanyPlan INNER JOIN
      (SELECT MIN(InsuranceCompanyPlanID) AS InsuranceCompanyPlanID, PlanName, AddressLine1, City, State, ZipCode
        FROM  dbo.InsuranceCompanyPlan AS InsuranceCompanyPlan_1
        GROUP BY PlanName, AddressLine1, City, State, ZipCode) AS InsuranceCompanyPlan_Unique ON 
	  dbo.InsuranceCompanyPlan.InsuranceCompanyPlanID = InsuranceCompanyPlan_Unique.InsuranceCompanyPlanID 
	INNER JOIN
	  dbo.x_Patient INNER JOIN
	  dbo.PatientCase INNER JOIN
	  dbo.Patient ON dbo.PatientCase.PatientID = dbo.Patient.PatientID ON dbo.x_Patient.PatVendorID = dbo.Patient.VendorID ON 
	  dbo.InsuranceCompanyPlan.VendorID = dbo.x_Patient.InsVendorID2
	WHERE dbo.Patient.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy Table 2nd '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


SET NOCOUNT OFF

-- ROLLBACK TRANSACTION
-- COMMIT TRANSACTION

--	DECLARE @VendorImportID INT
--	SET @VendorImportID = 7
------	DELETE FROM Practice WHERE VendorImportID = @VendorImportID
----	DELETE FROM PatientCaseDate FROM PatientCaseDate PCD INNER JOIN PatientCase PC ON PCD.PatientCaseID = PC.PatientCaseID WHERE PC.VendorImportID = @VendorImportID
--	DELETE FROM InsurancePolicy FROM PatientCase INNER JOIN InsurancePolicy ON PatientCase.PatientCaseID = InsurancePolicy.PatientCaseID WHERE (PatientCase.VendorImportID = @VendorImportID)
--	DELETE FROM PatientCase WHERE VendorImportID = @VendorImportID
--	DELETE FROM Patient WHERE VendorImportID = @VendorImportID
--	DELETE FROM ProviderNumber FROM ProviderNumber PN INNER JOIN Doctor D ON D.DoctorID = PN.DoctorID WHERE D.VendorImportID = @VendorImportID
--	DELETE FROM Doctor WHERE VendorImportID = @VendorImportID
--	DELETE FROM InsuranceCompanyPlan FROM InsuranceCompanyPlan INNER JOIN InsuranceCompany ON InsuranceCompanyPlan.InsuranceCompanyID = InsuranceCompany.InsuranceCompanyID WHERE InsuranceCompany.VendorImportID = @VendorImportID
--	DELETE FROM InsuranceCompany WHERE VendorImportID = @VendorImportID
--	DELETE FROM VendorImport WHERE VendorImportID = @VendorImportID
--	DELETE FROM ServiceLocation WHERE VendorImportID = @VendorImportID

