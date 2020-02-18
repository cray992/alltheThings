-- ***************************************************************
-- *** NEED PracticeID Below
-- *** NEED Synonyms assigned below
-- Vendor Import Data
-- ***************************************************************
-- TODO Include name of files in print out

-- Generic procedure for importing Doctor, Patient and Insurance data
-- We have three flat tables
-- x_Doctor, x_Patient, and x_InsCo
SET NOCOUNT ON

USE superbill_0850_prod -- %%%%%%%%%%%%%%%%%   CHANGE DATABASE   %%%%%%%%%%%%%%%%%

----ROLLBACK TRANSACTION
----COMMIT TRANSACTION

--**************************** PRACTICE ID ***************************
--INSERT INTO Practice ([Name], VendorImportID) VALUES ('Vancouver Clinical', 1)
--SET @PracticeID = SCOPE_IDENTITY()
-- SELECT * FROM Practice

--SELECT @PracticeID = PracticeID 
--FROM Practice
--WHERE [Name] = 'Chucks practice'
--********************************************************************

IF OBJECT_ID('tempdb..#Vars') IS NOT NULL
	DROP TABLE [#Vars]

CREATE TABLE #Vars(VarName varchar(50), VarValue varchar(200))

-- %%%%%%%%%%%  SET VARIABLES    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INSERT INTO #Vars (VarName, VarValue) VALUES ('TestDataType',		0)
INSERT INTO #Vars (VarName, VarValue) VALUES ('VendorName',			'Stevens')
INSERT INTO #Vars (VarName, VarValue) VALUES ('PracticeName',		'Refer to Practice ID')

INSERT INTO #Vars (VarName, VarValue) VALUES ('PracticeID',			'3')
INSERT INTO #Vars (VarName, VarValue) VALUES ('iDoctor',			'dbo.z_DoctorBlank_txt')
INSERT INTO #Vars (VarName, VarValue) VALUES ('iPatient',			'dbo.xC_patient_txt')
INSERT INTO #Vars (VarName, VarValue) VALUES ('iInsuranceCompany',	'dbo.xC_insurance_txt')

-- ==================================================================
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_Doctor')
		DROP SYNONYM [dbo].[x_Doctor]
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_Patient')
		DROP SYNONYM [dbo].[x_Patient]
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_InsuranceCompany')
		DROP SYNONYM [dbo].[x_InsuranceCompany]
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

DECLARE @iDoctor varchar(50)
DECLARE @iPatient varchar(50)
DECLARE @iInsCompany varchar(50)
DECLARE @Rows INT

SELECT @iPatient = VarValue FROM #Vars WHERE VarName = 'iPatient'
SELECT @iDoctor = VarValue FROM #Vars WHERE VarName = 'iDoctor'
SELECT @iInsCompany = VarValue FROM #Vars WHERE VarName = 'iInsuranceCompany'

EXEC ('Create Synonym x_Patient For ' + @iPatient)
EXEC ('Create Synonym x_Doctor For ' + @iDoctor)
EXEC ('Create Synonym x_InsuranceCompany For ' + @iInsCompany)
GO
-- ====================================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fn_GetNumber]
BEGIN
	EXECUTE dbo.sp_executesql @statement = N'
	CREATE FUNCTION [dbo].[fn_GetNumber]( @string Varchar(255) )
	RETURNS Varchar(20)
	AS
	BEGIN
		DECLARE @number Varchar(20)
		SET @string = Replace( @string , ''('' , '''' )
		SET @string = Replace( @string , '')'' , '''' )
		SET @string = Replace( @string , ''-'' , '''' )
		SET @string = Replace( @string , '' '' , '''' )
		SET @string = Replace( @string , '','' , '''' )
		SET @string = Replace( @string , ''.'' , '''' )
		SET @string = Replace( @string , ''$'' , '''' )
		SET @string = Replace( @string , ''%'' , '''' )
		SET @string = Replace( @string , ''_'' , '''' )
		SET @string = Replace( @string , ''*'' , '''' )

		If LTrim( RTrim( @string ) ) = ''''
			Select @string = Null

		SET @number = LEFT( @string , 20 )

		RETURN @number
	END
	' 
END
GO
-- ==========================================================

-- ////////////////////////////////////////////////////////////////////////////////////////////
-- Data check of data to import
-- 1 Test if data will be truncated
-- 2 Check for proper data type
DECLARE @Rows INT
DECLARE @testDataType INT
SELECT @testDataType = VarValue FROM #Vars WHERE VarName = 'TestDataType'

SELECT * FROM x_Doctor WHERE LEN(FirstName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor FirstName will be truncated. Process aborted'
	RETURN
END
----------------
SELECT * FROM x_Doctor WHERE LEN(MiddleName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor MiddleName will be truncated. Process aborted'
	RETURN
END
---------------
SELECT * FROM x_Doctor WHERE LEN(LastName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor LastName will be truncated. Process aborted'
	RETURN
END
---------------
SELECT * FROM x_Doctor WHERE LEN(AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor AddressLine1 will be truncated. Process aborted'
	RETURN
END
----------------
SELECT * FROM x_Doctor WHERE LEN(AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor AddressLine2 will be truncated. Process aborted'
	RETURN
END
----------------
SELECT * FROM x_Doctor WHERE LEN(City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor City will be truncated. Process aborted'
	RETURN
END
-----------------
SELECT * FROM x_Doctor WHERE LEN(State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor State will be truncated. Process aborted'
	RETURN
END
-----------------
SELECT * FROM x_Doctor WHERE LEN(ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor ZipCode will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Doctor ZipCode column must be numeric. Process is aborted'
	RETURN
END
-----------------
SELECT * FROM x_Doctor WHERE LEN(SSN) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Doctor SSN will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(SSN, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Doctor SSN column must be numeric. Process is aborted'
	RETURN
END
------------------
SELECT * FROM x_Doctor WHERE LEN(HomePhone) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Doctor HomePhone will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(HomePhone, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Doctor HomePhone column must be numeric. Process is aborted'
	RETURN
END
------------------
SELECT * FROM x_Doctor WHERE LEN(WorkPhone) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor WorkPhone will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(WorkPhone, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Doctor WorkPhone column must be numeric. Process is aborted'
	RETURN
END
------------------
SELECT * FROM x_Doctor WHERE LEN(Degree) > 8
--UPDATE x_Doctor SET Degree = NULL WHERE LEN(Degree) > 8
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor Degree will be truncated. Process aborted'
	RETURN
END
------------------
SELECT * FROM x_Doctor WHERE LEN(VendorID) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor VendorID will be truncated. Process aborted'
	RETURN
END
------------------
SELECT * FROM x_Doctor WHERE LEN(FaxNumber) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor FaxNumber will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL(FaxNumber, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Doctor FaxNumber column must be numeric. Process is aborted'
	RETURN
END
------------------
SELECT * FROM x_Doctor WHERE LEN([External]) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in Doctor [External] will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Doctor WHERE ISNUMERIC(ISNULL([External], 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Doctor [External] column must be numeric. Process is aborted'
	RETURN
END
-- ****************
-- ************************************
SELECT * FROM x_InsuranceCompany WHERE LEN(InsVendorID) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany InsVendorID will be truncated. Process aborted'
	RETURN
END
-------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(InsuranceCompanyName) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany InsuranceCompanyName will be truncated. Process aborted'
	RETURN
END
-------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany AddressLine1 will be truncated. Process aborted'
	RETURN
END
-------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany AddressLine2 will be truncated. Process aborted'
	RETURN
END
-------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany City will be truncated. Process aborted'
	RETURN
END
--------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany State will be truncated. Process aborted'
	RETURN
END
--------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany ZipCode will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany ZipCode column must be numeric. Process is aborted'
	RETURN
END
---------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(ContactFirstName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany ContactFirstName will be truncated. Process aborted'
	RETURN
END
--------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(Phone) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany Phone will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(Phone, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany Phone column must be numeric. Process is aborted'
	RETURN
END
---------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(Fax) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany Fax will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(Fax, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany Fax column must be numeric. Process is aborted'
	RETURN
END
---------------------
SELECT * FROM x_InsuranceCompany WHERE LEN(InsuranceProgramCode) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_InsuranceCompany InsuranceProgramCode will be truncated. Process aborted'
	RETURN
END
-- ****************
-- ************************************
SELECT * FROM x_Patient WHERE LEN(PatVendorID) > 50
IF @@RowCount > 0
BEGIN
	PRINT 'Values in x_Patient PatVendorID will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1
	SELECT CONVERT(Varchar(50), PatVendorID) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(FirstName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient FirstName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), FirstName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(MiddleName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient MiddleName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), MiddleName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(LastName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient LastName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), LastName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient AddressLine1 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(256), AddressLine1) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient AddressLine2 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(256), AddressLine2) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient City will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(128), City) FROM x_Patient
--------------------
--UPDATE x_Patient SET State = NULL WHERE LEN(State) > 2
SELECT State FROM x_Patient WHERE LEN(State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient State will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(2), State) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient ZipCode will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient ZipCode column must be numeric. Process is aborted'

	RETURN
END
--------------------
--UPDATE x_patient SET Gender = NULL WHERE LEN(Gender) > 1
SELECT Gender FROM x_Patient WHERE LEN(Gender) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Gender will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(1), Gender) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(MaritalStatus) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient MaritalStatus will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(1), MaritalStatus) FROM x_Patient
---------------------
--UPDATE x_Patient SET HomePhone = NULL WHERE LEN(HomePhone) > 10
SELECT HomePhone FROM x_Patient WHERE LEN(HomePhone) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient HomePhone will be truncated. Process aborted'
	RETURN
END
SELECT HomePhone FROM x_Patient WHERE ISNUMERIC(ISNULL(HomePhone, 0)) = 0
IF @@RowCount > 0
BEGIN
	PRINT 'Values in x_Patient HomePhone column must be numeric. Process is aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(10), HomePhone) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(WorkPhone) > 10
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient WorkPhone will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(WorkPhone, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	PRINT 'Values in x_Patient WorkPhone column must be numeric. Process is aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(10), WorkPhone) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(SSN) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient SSN will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(SSN, 0)) = 0
--UPDATE x_Patient SET SSN = NULL WHERE SSN = ''
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	PRINT 'Values in x_Patient SSN column must be numeric. Process is aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(9), SSN) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE ISDATE(DOB) = 0 AND DOB IS NOT NULL
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient DOB column must be Date Type. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(InsVendorID1) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient InsVendorID1 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(50), InsVendorID1) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(PolicyNumber1) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient PolicyNumber1 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(32), PolicyNumber1) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(GroupNumber1) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient GroupNumber1 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(32), GroupNumber1) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Copay1, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Copay1 column must be numeric. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1PatientRelationshipToInsured) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1PatientRelationshipToInsured will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(1), Holder1PatientRelationshipToInsured) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1FirstName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1FirstName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), Holder1FirstName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1MiddleName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1MiddleName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), Holder1MiddleName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1LastName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1LastName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), Holder1LastName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE ISDATE(Holder1DOB) = 0 AND (NOT Holder1DOB IS NULL)
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1DOB column must be Date Type. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1EmployerName) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1EmployerName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(128), Holder1EmployerName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1Gender) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1Gender will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(1), Holder1Gender) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1AddressLine1 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(256), Holder1AddressLine1) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1AddressLine2 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(256), Holder1AddressLine2) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1City will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(128), Holder1City) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1State will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(2), Holder1State) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1ZipCode will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder1ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1ZipCode column must be numeric. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder1Phone) > 10
--UPDATE x_Patient SET Holder1Phone = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Holder1Phone, '(', ''), ')', ''), '-', ''), ' ', ''), '_', '')
--UPDATE x_Patient SET Holder1Phone = NULL WHERE Holder1Phone = ''
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1Phone will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder1Phone, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder1Phone column must be numeric. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(AdjusterLastName1) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient AdjusterLastName1 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), AdjusterLastName1) FROM x_Patient
--------------------
--------------------
SELECT * FROM x_Patient WHERE LEN(InsVendorID2) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient InsVendorID2 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(50), InsVendorID2) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(PolicyNumber2) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient PolicyNumber2 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(32), PolicyNumber2) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(GroupNumber2) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient GroupNumber2 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(32), GroupNumber2) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Copay2, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Copay2 column must be numeric. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2PatientRelationshipToInsured) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2PatientRelationshipToInsured will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(1), Holder2PatientRelationshipToInsured) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2FirstName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2FirstName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), Holder2FirstName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2MiddleName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2MiddleName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), Holder2MiddleName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2LastName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2LastName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), Holder2LastName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE ISDATE(Holder2DOB) = 0 AND Holder2DOB IS NOT NULL
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2DOB column must be Date Type. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2EmployerName) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2EmployerName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), Holder2EmployerName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2Gender) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2Gender will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(1), Holder2Gender) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2AddressLine1 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(256), Holder2AddressLine1) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2AddressLine2 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(256), Holder2AddressLine2) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2City will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(128), Holder2City) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2State will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(2), Holder2State) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2ZipCode will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder2ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2ZipCode column must be numeric. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder2Phone) > 10
--UPDATE x_Patient SET Holder2Phone = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Holder2Phone, '(', ''), ')', ''), '-', ''), ' ', ''), '_', '')
--UPDATE x_Patient SET Holder2Phone = NULL WHERE Holder2Phone = ''
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2Phone will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder2Phone, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder2Phone column must be numeric. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(AdjusterLastName2) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient AdjusterLastName2 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), AdjusterLastName2) FROM x_Patient
---------------------
SELECT * FROM x_Patient WHERE LEN(InsVendorID3) > 50
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient InsVendorID3 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(50), InsVendorID3) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(PolicyNumber3) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient PolicyNumber3 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(32), PolicyNumber3) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(GroupNumber3) > 32
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient GroupNumber3 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(32), GroupNumber3) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Copay3, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Copay3 column must be numeric. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3PatientRelationshipToInsured) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3PatientRelationshipToInsured will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(1), Holder3PatientRelationshipToInsured) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3FirstName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3FirstName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), Holder3FirstName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3MiddleName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3MiddleName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), Holder3MiddleName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3LastName) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3LastName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), Holder3LastName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE ISDATE(Holder3DOB) = 0 AND Holder3DOB IS NOT NULL
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3DOB column must be Date Type. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3EmployerName) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3EmployerName will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(128), Holder3EmployerName) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3Gender) > 1
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3Gender will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(1), Holder3Gender) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3AddressLine1) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3AddressLine1 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(256), Holder3AddressLine1) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3AddressLine2) > 256
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3AddressLine2 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(256), Holder3AddressLine2) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3City) > 128
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3City will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(128), Holder3City) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3State) > 2
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3State will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(2), Holder3State) FROM x_Patient
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3ZipCode) > 9
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3ZipCode will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder3ZipCode, 0)) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3ZipCode column must be numeric. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(Holder3Phone) > 10
--UPDATE x_Patient SET Holder3Phone = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Holder3Phone, '(', ''), ')', ''), '-', ''), ' ', ''), '_', '')
--UPDATE x_Patient SET Holder3Phone = NULL WHERE Holder3Phone = ''
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3Phone will be truncated. Process aborted'
	RETURN
END
SELECT * FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder3Phone, 0)) = 0

Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient Holder3Phone column must be numeric. Process is aborted'
	RETURN
END
--------------------
SELECT * FROM x_Patient WHERE LEN(AdjusterLastName3) > 64
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	PRINT 'Values in x_Patient AdjusterLastName3 will be truncated. Process aborted'
	RETURN
END
IF @testDataType = 1 
	SELECT CONVERT(Varchar(64), AdjusterLastName3) FROM x_Patient
--------------------
--Check PatientRelationshipToInsured
SELECT     
PatVendorID, 
FirstName, 
LastName, 
Holder1PatientRelationshipToInsured, 
Holder1FirstName, 
Holder1LastName, 
Holder2PatientRelationshipToInsured, 
Holder2FirstName, 
Holder2LastName, 
Holder3PatientRelationshipToInsured, 
Holder3FirstName, 
Holder3LastName
FROM  x_Patient
WHERE ((Holder3LastName IS NOT NULL) 
AND (Holder3FirstName IS NOT NULL) 
AND ((Holder3PatientRelationshipToInsured NOT IN('U', 'C', 'O', 'S') AND Holder3PatientRelationshipToInsured IS NOT NULL) OR Holder3PatientRelationshipToInsured IS NULL))
OR (((Holder2PatientRelationshipToInsured NOT IN('U', 'C', 'O', 'S') AND Holder2PatientRelationshipToInsured IS NOT NULL) OR Holder2PatientRelationshipToInsured IS NULL) 
AND (Holder2FirstName IS NOT NULL) 
AND (Holder2LastName IS NOT NULL)) 
OR ((Holder1LastName IS NOT NULL) 
AND (Holder1FirstName IS NOT NULL) 
AND ((Holder1PatientRelationshipToInsured NOT IN('U', 'C', 'O', 'S') AND Holder1PatientRelationshipToInsured IS NOT NULL) OR Holder1PatientRelationshipToInsured IS NULL))

----UPDATE x_Patient SET Holder1PatientRelationshipToInsured = NULL WHERE Holder1LastName IS NULL AND Holder1FirstName IS NULL
----UPDATE x_Patient SET Holder2PatientRelationshipToInsured = NULL WHERE Holder2LastName IS NULL AND Holder2FirstName IS NULL
----UPDATE x_Patient SET Holder3PatientRelationshipToInsured = NULL WHERE Holder3LastName IS NULL AND Holder3FirstName IS NULL
--UPDATE x_Patient SET Holder1PatientRelationshipToInsured = 'O' WHERE Holder1LastName IS NOT NULL AND Holder1FirstName IS NOT NULL AND (Holder1PatientRelationshipToInsured NOT IN('S', 'C', 'U', 'O') OR Holder1PatientRelationshipToInsured IS NULL)
--UPDATE x_Patient SET Holder2PatientRelationshipToInsured = 'O' WHERE Holder2LastName IS NOT NULL AND Holder2FirstName IS NOT NULL AND (Holder2PatientRelationshipToInsured NOT IN('S', 'C', 'U', 'O') OR Holder2PatientRelationshipToInsured IS NULL)
--UPDATE x_Patient SET Holder3PatientRelationshipToInsured = 'O' WHERE Holder3LastName IS NOT NULL AND Holder3FirstName IS NOT NULL AND (Holder3PatientRelationshipToInsured NOT IN('S', 'C', 'U', 'O') OR Holder3PatientRelationshipToInsured IS NULL)
----
--------------------
GO
--=====================================================
SET NOCOUNT ON

DECLARE @Rows               Int
        , @Message          Varchar(75)
        , @PracticeID       Int
        , @VendorImportID   Int
        , @VendorName       Varchar(100)

DECLARE @DefaultPayerScenarioID int
SET @DefaultPayerScenarioID = 5 --Commercial

SELECT @PracticeID = VarValue FROM #Vars WHERE VarName = 'PracticeID'
SELECT @VendorName = VarValue FROM #Vars WHERE VarName = 'VendorName'

BEGIN TRANSACTION

INSERT INTO VendorImport (VendorName, VendorFormat, DateCreated, Notes)
VALUES ('Chuck Bagby', 'csv', GETDATE(), 'None')
SET @VendorImportID = SCOPE_IDENTITY()


Print 'Import: ' + Convert( Varchar(20) , @VendorName )
Print 'Data Import Date & Time : ' + Convert( Varchar(20) , GetDate() )
Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )
Print 'DataBase : ' + DB_Name()
Print 'Practice ID : ' + Convert( Char(3) , @PracticeID )

INSERT INTO InsuranceCompany 
	(InsuranceCompanyName, 
	AddressLine1, 
	AddressLine2, 
	City, 
	State, 
	ZipCode, 
	ContactFirstName,
	Phone, 
	Fax,
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
	x_InsuranceCompany.ContactFirstName,
	x_InsuranceCompany.Phone, 
	x_InsuranceCompany.Fax,
	ISNULL(x_InsuranceCompany.InsuranceProgramCode, 'CI') AS InsuranceProgramCode,
	'R', 
	@PracticeID, 
	x_InsuranceCompany.InsVendorID
	, @VendorImportID
FROM x_InsuranceCompany 
	LEFT OUTER JOIN InsuranceCompany 
	ON x_InsuranceCompany.InsuranceCompanyName = InsuranceCompany.InsuranceCompanyName
	AND x_InsuranceCompany.AddressLine1 = InsuranceCompany.AddressLine1
--	AND x_InsuranceCompany.State = InsuranceCompany.State 
--	AND x_InsuranceCompany.City = InsuranceCompany.City 
--	AND x_InsuranceCompany.ZipCode = InsuranceCompany.ZipCode
WHERE LEN(x_InsuranceCompany.InsuranceCompanyName) > 0 
	AND (InsuranceCompany.InsuranceCompanyName IS NULL)
	AND x_InsuranceCompany.InsuranceCompanyName IS NOT NULL
	AND x_InsuranceCompany.AddressLine1 IS NOT NULL

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
--	AND InsuranceCompany_Uniquee.City = dbo.x_InsuranceCompany.City 
--	AND InsuranceCompany_Uniquee.State = dbo.x_InsuranceCompany.State 
--	AND InsuranceCompany_Uniquee.ZipCode = dbo.x_InsuranceCompany.ZipCode 
	LEFT OUTER JOIN dbo.InsuranceCompanyPlan 
	ON dbo.InsuranceCompany.InsuranceCompanyName = dbo.InsuranceCompanyPlan.PlanName 
--	AND dbo.InsuranceCompany.State = dbo.InsuranceCompanyPlan.State 
	AND dbo.InsuranceCompany.AddressLine1 = dbo.InsuranceCompanyPlan.AddressLine1 
--	AND dbo.InsuranceCompany.City = dbo.InsuranceCompanyPlan.City 
--	AND dbo.InsuranceCompany.ZipCode = dbo.InsuranceCompanyPlan.ZipCode
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
	WorkPhone,
	Notes,
	Degree,
	VendorID, 
	VendorImportID,
	FaxNumber,
	[External])
SELECT DISTINCT 
	@PracticeID,
	'' AS Prefix,
	ISNULL(x_Doctor.FirstName, '') AS FirstName,
	ISNULL(x_Doctor.MiddleName, '') AS MiddleName,
	ISNULL(x_Doctor.LastName, '') AS LastName,
	'' AS Suffix,
	x_Doctor.AddressLine1, 
	x_Doctor.AddressLine2, 
	x_Doctor.City, 
	x_Doctor.State, 
	x_Doctor.ZipCode, 
	x_Doctor.SSN, 
	x_Doctor.HomePhone, 
	x_Doctor.WorkPhone,
	x_Doctor.Notes,
	x_Doctor.Degree,
	x_Doctor.VendorID,
	@VendorImportID,
	x_Doctor.FaxNumber,
	x_Doctor.[External]
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

-- Above ensures no duplication from existing doctors

Select @Rows = @@RowCount
Select @Message = 'Rows Added in Doctor Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [x_Doctor]
Select @Message = 'Rows in original x_Doctor Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

 -- Import Medical License Number 7.
INSERT INTO ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
	  , VendorImportID
    )
	SELECT dbo.Doctor.DoctorID, 
	7 AS ProviderNumberTypeID, 
	x_Doctor.License,
	@VendorImportID
	FROM dbo.Doctor 
	INNER JOIN x_Doctor 
	ON dbo.Doctor.VendorID = x_Doctor.VendorID
	WHERE (dbo.Doctor.VendorImportID = @VendorImportID) 
	AND (ISNULL(x_Doctor.License, '') <> '')

Select @Rows = @@RowCount
Select @Message = 'Rows Added in ProviderNumber Table for Medical License Number (Providers) '
Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

 -- Import UPIN Number 25.
INSERT INTO ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
	  , VendorImportID
    )
	SELECT dbo.Doctor.DoctorID, 
	25 AS ProviderNumberTypeID, 
	x_Doctor.Upin,
	@VendorImportID
	FROM dbo.Doctor 
	INNER JOIN x_Doctor 
	ON dbo.Doctor.VendorID = x_Doctor.VendorID
	WHERE (dbo.Doctor.VendorImportID = @VendorImportID) 
	AND (ISNULL(x_Doctor.Upin, '') <> '')

Select @Rows = @@RowCount
Select @Message = 'Rows Added in ProviderNumber Table for Medical License Number (Providers) '
Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--PATIENT

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
	MobilePhone,
	MobilePhoneExt,
	DOB, 
	SSN, 
	EmailAddress,
	PrimaryProviderID, 
	EmploymentStatus,
	MedicalRecordNumber, 
	PrimaryCarePhysicianID, 
	VendorID, 
	VendorImportID)
SELECT DISTINCT
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
	x_Patient.MaritalStatus, 
	x_Patient.HomePhone, 
	x_Patient.WorkPhone, 
	x_Patient.WorkPhoneExt, 
	x_Patient.MobilePhone,
	x_Patient.MobilePhoneExt,
	x_Patient.DOB, 
	x_Patient.SSN, 
	x_Patient.EmailAddress,
	DoctorPhy.DoctorID, 
	x_Patient.EmploymentStatus,
	x_Patient.MedicalRecordNumber, 
	DoctorPhy.DoctorID, 
	x_Patient.PatVendorID
	, @VendorImportID
FROM dbo.Patient 
	RIGHT OUTER JOIN dbo.x_Patient 
	ON dbo.Patient.LastName = dbo.x_Patient.LastName 
	AND dbo.Patient.FirstName = dbo.x_Patient.FirstName 
	AND dbo.Patient.SSN = dbo.x_Patient.SSN LEFT OUTER JOIN
	dbo.x_Doctor AS x_Doctor_1 INNER JOIN
	  (SELECT FirstName, LastName, MIN(DoctorID) AS DoctorID
		FROM dbo.Doctor
		GROUP BY FirstName, LastName) AS Doctor_Ref 
	ON x_Doctor_1.FirstName = Doctor_Ref.FirstName 
	AND x_Doctor_1.LastName = Doctor_Ref.LastName 
	ON dbo.x_Patient.ReferringPhysician_VendorID = x_Doctor_1.VendorID LEFT OUTER JOIN
	  (SELECT FirstName, LastName, MIN(DoctorID) AS DoctorID
		FROM dbo.Doctor AS Doctor_1
		GROUP BY FirstName, LastName) AS DoctorPhy INNER JOIN
	dbo.x_Doctor ON DoctorPhy.LastName = dbo.x_Doctor.LastName 
	AND DoctorPhy.FirstName = dbo.x_Doctor.FirstName 
	ON dbo.x_Patient.ProviderPhysician_VendorID = dbo.x_Doctor.VendorID
	WHERE (dbo.Patient.SSN IS NULL)

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
	HolderSSN,
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

--DECLARE @VendorImportID VarChar(20)
--SET @VendorImportID = 21
--
--DECLARE @PracticeID VarChar(20)
--SET @PracticeID = 14

SELECT DISTINCT
	@PracticeID,
	PatientCase.PatientCaseID,
	InsuranceCompanyPlan_Unique.InsuranceCompanyPlanID,
	1 AS Precedence,
	x_Patient.PolicyNumber1,
	x_Patient.GroupNumber1,

	ISNULL(x_Patient.Holder1PatientRelationshipToInsured, 'S') AS PatientRelationshipToInsured,
	x_Patient.Holder1FirstName,
	x_Patient.Holder1MiddleName,
	x_Patient.Holder1LastName,
	x_Patient.Holder1DOB,
	x_Patient.Holder1SSN,
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
--	AND dbo.x_InsuranceCompany.City = InsuranceCompanyPlan_Unique.City 
--	AND dbo.x_InsuranceCompany.State = InsuranceCompanyPlan_Unique.State 
--	AND dbo.x_InsuranceCompany.ZipCode = InsuranceCompanyPlan_Unique.ZipCode
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
	HolderSSN,
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

	ISNULL(x_Patient.Holder2PatientRelationshipToInsured, 'S') AS PatientRelationshipToInsured,
	x_Patient.Holder2FirstName,
	x_Patient.Holder2MiddleName,
	x_Patient.Holder2LastName,
	x_Patient.Holder2DOB,
	x_Patient.Holder2SSN,
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
--	AND dbo.x_InsuranceCompany.City = InsuranceCompanyPlan_Unique.City 
--	AND dbo.x_InsuranceCompany.State = InsuranceCompanyPlan_Unique.State 
--	AND dbo.x_InsuranceCompany.ZipCode = InsuranceCompanyPlan_Unique.ZipCode
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
	HolderFirstName,
	HolderMiddleName,
	HolderLastName,
	HolderDOB,
	HolderSSN,
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
	3 AS Precedence,
	x_Patient.PolicyNumber3,
	x_Patient.GroupNumber3,

	ISNULL(x_Patient.Holder3PatientRelationshipToInsured, 'S') AS PatientRelationshipToInsured,
	x_Patient.Holder3FirstName,
	x_Patient.Holder3MiddleName,
	x_Patient.Holder3LastName,
	x_Patient.Holder3DOB,
	x_Patient.Holder3SSN,
	x_Patient.Holder3EmployerName,
	x_Patient.Holder3Gender,
	x_Patient.Holder3AddressLine1,
	x_Patient.Holder3AddressLine2,
	x_Patient.Holder3City,
	x_Patient.Holder3State,
	x_Patient.Holder3ZipCode,
	x_Patient.Holder3Phone,
	x_Patient.AdjusterLastName1,

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
--	AND dbo.x_InsuranceCompany.City = InsuranceCompanyPlan_Unique.City 
--	AND dbo.x_InsuranceCompany.State = InsuranceCompanyPlan_Unique.State 
--	AND dbo.x_InsuranceCompany.ZipCode = InsuranceCompanyPlan_Unique.ZipCode
	WHERE dbo.Patient.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy Table 3rd '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SET NOCOUNT OFF

-- ROLLBACK TRANSACTION
-- COMMIT TRANSACTION

--BEGIN TRANSACTION
--
--	DECLARE @VendorImportID INT
--	SET @VendorImportID = 8
------	DELETE FROM Practice WHERE VendorImportID = @VendorImportID
--	DELETE FROM PatientCaseDate FROM PatientCaseDate PCD INNER JOIN PatientCase PC ON PCD.PatientCaseID = PC.PatientCaseID WHERE PC.VendorImportID = @VendorImportID
--	DELETE FROM InsurancePolicy FROM PatientCase INNER JOIN InsurancePolicy ON PatientCase.PatientCaseID = InsurancePolicy.PatientCaseID WHERE (PatientCase.VendorImportID = @VendorImportID)
--	DELETE FROM PatientCase WHERE VendorImportID = @VendorImportID
--	DELETE Patient FROM Patient LEFT OUTER JOIN PaymentPatient ON Patient.PatientID = PaymentPatient.PatientID WHERE VendorImportID = @VendorImportID AND PaymentPatient.PatientID IS NULL
--	DELETE FROM ProviderNumber FROM ProviderNumber PN INNER JOIN Doctor D ON D.DoctorID = PN.DoctorID WHERE D.VendorImportID = @VendorImportID
--	DELETE FROM Doctor WHERE VendorImportID = @VendorImportID
--	DELETE FROM InsuranceCompanyPlan FROM InsuranceCompanyPlan INNER JOIN InsuranceCompany ON InsuranceCompanyPlan.InsuranceCompanyID = InsuranceCompany.InsuranceCompanyID WHERE InsuranceCompany.VendorImportID = @VendorImportID
--	DELETE FROM InsuranceCompany WHERE VendorImportID = @VendorImportID
----	DELETE FROM VendorImport WHERE VendorImportID = @VendorImportID
--	DELETE FROM ServiceLocation WHERE VendorImportID = @VendorImportID

----ROLLBACK TRANSACTION
----COMMIT TRANSACTION

