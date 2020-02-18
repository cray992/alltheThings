-- Clean Dr_Pat_Ins_Data
-- CHANGE DATABASE AND SET VARIABLES

USE ImportSpec -- %%%%%%%%%%%%%%%%%   CHANGE DATABASE   %%%%%%%%%%%%%%%%%

SET NOCOUNT ON

IF OBJECT_ID('tempdb..#Vars') IS NOT NULL
	DROP TABLE [#Vars]

CREATE TABLE #Vars(VarName varchar(50), VarValue varchar(200))

-- %%%%%%%%%%%  SET VARIABLES    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INSERT INTO #Vars (VarName, VarValue) VALUES ('x_Doctor',			'dbo.z_DoctorBlank_txt')

INSERT INTO #Vars (VarName, VarValue) VALUES ('x_Patient',			'dbo.xC_patient_txt')

INSERT INTO #Vars (VarName, VarValue) VALUES ('x_InsuranceCompany', 'dbo.xC_insurance_txt')
-- ==================================================================
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_Doctor')
		DROP SYNONYM [dbo].[x_Doctor]
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_Patient')
		DROP SYNONYM [dbo].[x_Patient]
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_InsuranceCompany')
		DROP SYNONYM [dbo].[x_InsuranceCompany]
    GO
-- ==================================================================
	DECLARE @x_Doctor varchar(50)
	DECLARE @x_Patient varchar(50)
	DECLARE @x_InsuranceCompany varchar(50)

	SELECT @x_Doctor = VarValue FROM #Vars WHERE VarName = 'x_Doctor'
	SELECT @x_Patient = VarValue FROM #Vars WHERE VarName = 'x_Patient'
	SELECT @x_InsuranceCompany = VarValue FROM #Vars WHERE VarName = 'x_InsuranceCompany'

    EXEC ('Create Synonym x_Doctor For ' + @x_Doctor)
    EXEC ('Create Synonym x_Patient For ' + @x_Patient)
    EXEC ('Create Synonym x_InsuranceCompany For ' + @x_InsuranceCompany)

	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_InsuranceCompany) and name='InsuranceProgramCode')
		EXEC ('ALTER TABLE ' + @x_InsuranceCompany + ' ADD InsuranceProgramCode varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_InsuranceCompany) and name='Fax')
		EXEC ('ALTER TABLE ' + @x_InsuranceCompany + ' ADD Fax varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_InsuranceCompany) and name='ContactFirstName')
		EXEC ('ALTER TABLE ' + @x_InsuranceCompany + ' ADD ContactFirstName varchar(50)')

	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Doctor) and name='SSN')
		EXEC ('ALTER TABLE ' + @x_Doctor + ' ADD SSN varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Doctor) and name='TaxID')
		EXEC ('ALTER TABLE ' + @x_Doctor + ' ADD TaxID varchar(50)')

	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='PatVendorID')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD PatVendorID varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='ProviderPhysician_VendorID')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD ProviderPhysician_VendorID varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='ReferringPhysician_VendorID')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD ReferringPhysician_VendorID varchar(50)')

	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='MaritalStatus')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD MaritalStatus varchar(50)')

	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='MobilePhone')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD MobilePhone varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='MobilePhoneExt')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD MobilePhoneExt varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='EmailAddress')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD EmailAddress varchar(50)')

	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1FirstName')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1FirstName varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1MiddleName')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1MiddleName varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1LastName')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1LastName varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1PatientRelationshipToInsured')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1PatientRelationshipToInsured varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1AddressLine1')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1AddressLine1 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1AddressLine2')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1AddressLine2 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1City')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1City varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1State')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1State varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1ZipCode')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1ZipCode varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1Phone')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1Phone varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1DOB')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1DOB varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1EmployerName')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1EmployerName varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder1Gender')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder1Gender varchar(50)')


	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='InsVendorID1')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD InsVendorID1 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='PolicyNumber1')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD PolicyNumber1 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='GroupNumber1')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD GroupNumber1 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='CoPay1')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD CoPay1 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='AdjusterLastName1')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD AdjusterLastName1 varchar(50)')

	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2FirstName')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2FirstName varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2MiddleName')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2MiddleName varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2LastName')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2LastName varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2PatientRelationshipToInsured')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2PatientRelationshipToInsured varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2AddressLine1')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2AddressLine1 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2AddressLine2')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2AddressLine2 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2City')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2City varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2State')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2State varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2ZipCode')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2ZipCode varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2Phone')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2Phone varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2DOB')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2DOB varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2EmployerName')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2EmployerName varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder2Gender')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder2Gender varchar(50)')

	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='InsVendorID2')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD InsVendorID2 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='PolicyNumber2')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD PolicyNumber2 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='GroupNumber2')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD GroupNumber2 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='CoPay2')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD CoPay2 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='AdjusterLastName2')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD AdjusterLastName2 varchar(50)')

	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3FirstName')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3FirstName varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3LastName')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3LastName varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3PatientRelationshipToInsured')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3PatientRelationshipToInsured varchar(50)')

	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3MiddleName')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3MiddleName varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3AddressLine1')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3AddressLine1 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3AddressLine2')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3AddressLine2 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3City')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3City varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3State')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3State varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3ZipCode')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3ZipCode varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3Phone')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3Phone varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3DOB')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3DOB varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3EmployerName')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3EmployerName varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='Holder3Gender')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD Holder3Gender varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='AdjusterLastName3')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD AdjusterLastName3 varchar(50)')

	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='InsVendorID3')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD InsVendorID3 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='PolicyNumber3')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD PolicyNumber3 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='GroupNumber3')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD GroupNumber3 varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Patient) and name='CoPay3')
		EXEC ('ALTER TABLE ' + @x_Patient + ' ADD CoPay3 varchar(50)')

GO
-- ==================================================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetNumberImport]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fn_GetNumberImport]
BEGIN
	execute dbo.sp_executesql @statement = N'
	CREATE FUNCTION [dbo].[fn_GetNumberImport]( @string Varchar(255) )
	RETURNS Varchar(20)
	AS
	BEGIN
		DECLARE @number Varchar(20)
		DECLARE @OldString VARCHAR(255)

		SET @OldString = @string + ''a''
		WHILE LEN(@OldString) > LEN(@String)
			BEGIN
				SET @OldString = @string
				SET	@string = REPLACE(@string, SUBSTRING(@string, PATINDEX(''%[^0-9]%'', @string), 1), '''')
			END

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
		SET @string = Replace( @string , ''CHAR(39)'' , '''' )

		If LTrim( RTrim( @string ) ) = ''''
			Select @string = Null

		SET @number = LEFT( @string , 20 )

		RETURN @number
	END
	' 
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetStateImport]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fn_GetStateImport]
BEGIN
	execute dbo.sp_executesql @statement = N'
	CREATE FUNCTION [dbo].[fn_GetStateImport]( @string Varchar(255) )
	RETURNS Varchar(20)
	AS
	BEGIN
		DECLARE @Return VarChar(20)
		
		SET @Return = 
		CASE @string
			WHEN ''ALABAMA'' THEN ''AL''
			WHEN ''ALASKA'' THEN ''AK''
			WHEN ''AMERICAN SAMOA'' THEN ''AS''
			WHEN ''ARIZONA'' THEN ''AZ''
			WHEN ''ARKANSAS'' THEN ''AR''
			WHEN ''CALIFORNIA'' THEN ''CA''
			WHEN ''COLORADO'' THEN ''CO''
			WHEN ''CONNECTICUT'' THEN ''CT''
			WHEN ''DELAWARE'' THEN ''DE''
			WHEN ''DISTRICT OF COLUMBIA'' THEN ''DC''
			WHEN ''FEDERATED STATES OF MICRONESIA'' THEN ''FM''
			WHEN ''FLORIDA'' THEN ''FL''
			WHEN ''GEORGIA'' THEN ''GA''
			WHEN ''GUAM'' THEN ''GU''
			WHEN ''HAWAII'' THEN ''HI''
			WHEN ''IDAHO'' THEN ''ID''
			WHEN ''ILLINOIS'' THEN ''IL''
			WHEN ''INDIANA'' THEN ''IN''
			WHEN ''IOWA'' THEN ''IA''
			WHEN ''KANSAS'' THEN ''KS''
			WHEN ''KENTUCKY'' THEN ''KY''
			WHEN ''LOUISIANA'' THEN ''LA''
			WHEN ''MAINE'' THEN ''ME''
			WHEN ''MARSHALL ISLANDS'' THEN ''MH''
			WHEN ''MARYLAND'' THEN ''MD''
			WHEN ''MASSACHUSETTS'' THEN ''MA''
			WHEN ''MICHIGAN'' THEN ''MI''
			WHEN ''MINNESOTA'' THEN ''MN''
			WHEN ''MISSISSIPPI'' THEN ''MS''
			WHEN ''MISSOURI'' THEN ''MO''
			WHEN ''MONTANA'' THEN ''MT''
			WHEN ''NEBRASKA'' THEN ''NE''
			WHEN ''NEVADA'' THEN ''NV''
			WHEN ''NEW HAMPSHIRE'' THEN ''NH''
			WHEN ''NEW JERSEY'' THEN ''NJ''
			WHEN ''NEW MEXICO'' THEN ''NM''
			WHEN ''NEW YORK'' THEN ''NY''
			WHEN ''NORTH CAROLINA'' THEN ''NC''
			WHEN ''NORTH DAKOTA'' THEN ''ND''
			WHEN ''NORTHERN MARIANA ISLANDS'' THEN ''MP''
			WHEN ''OHIO'' THEN ''OH''
			WHEN ''OKLAHOMA'' THEN ''OK''
			WHEN ''OREGON'' THEN ''OR''
			WHEN ''PALAU'' THEN ''PW''
			WHEN ''PENNSYLVANIA'' THEN ''PA''
			WHEN ''PUERTO RICO'' THEN ''PR''
			WHEN ''RHODE ISLAND'' THEN ''RI''
			WHEN ''SOUTH CAROLINA'' THEN ''SC''
			WHEN ''SOUTH DAKOTA'' THEN ''SD''
			WHEN ''TENNESSEE'' THEN ''TN''
			WHEN ''TEXAS'' THEN ''TX''
			WHEN ''UTAH'' THEN ''UT''
			WHEN ''VERMONT'' THEN ''VT''
			WHEN ''VIRGIN ISLANDS'' THEN ''VI''
			WHEN ''VIRGINIA '' THEN ''VA''
			WHEN ''WASHINGTON'' THEN ''WA''
			WHEN ''WEST VIRGINIA'' THEN ''WV''
			WHEN ''WISCONSIN'' THEN ''WI''
			WHEN ''WYOMING'' THEN ''WY''
			ELSE @string
		END

		RETURN @string
	END
	' 
END

GO
-- ==================================================================

UPDATE x_InsuranceCompany SET InsVendorID = NULL WHERE InsVendorID = ''
UPDATE x_InsuranceCompany SET InsuranceCompanyName = NULL WHERE InsuranceCompanyName = ''
UPDATE x_InsuranceCompany SET AddressLine1 = NULL WHERE AddressLine1 = ''
UPDATE x_InsuranceCompany SET AddressLine2 = NULL WHERE AddressLine2 = ''
UPDATE x_InsuranceCompany SET City = NULL WHERE City = ''
UPDATE x_InsuranceCompany SET State = NULL WHERE State = ''
UPDATE x_InsuranceCompany SET State = dbo.fn_GetStateImport(State)
SELECT State FROM x_InsuranceCompany WHERE LEN(State) > 2

UPDATE x_InsuranceCompany SET ZipCode = dbo.fn_GetNumberImport(ZipCode)
UPDATE x_InsuranceCompany SET ZipCode = NULL WHERE ZipCode = ''
UPDATE x_InsuranceCompany SET ZipCode = '0' + ZipCode WHERE LEN(ZipCode) = 4
SELECT InsuranceCompanyName, ZipCode FROM x_InsuranceCompany WHERE LEN(ZipCode) > 9
IF @@RowCount > 0 PRINT 'SELECT InsuranceCompanyName, ZipCode FROM x_InsuranceCompany WHERE LEN(ZipCode) < 5'
SELECT InsuranceCompanyName, ZipCode FROM x_InsuranceCompany WHERE LEN(ZipCode) > 9
IF @@RowCount > 0 PRINT 'SELECT InsuranceCompanyName, ZipCode FROM x_InsuranceCompany WHERE LEN(ZipCode) < 5'

-- UPDATE x_InsuranceCompany SET ZipCode = NULL WHERE LEN(ZipCode) > 9
SELECT ZipCode FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT ZipCode FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0'

UPDATE x_InsuranceCompany SET Phone = dbo.fn_GetNumberImport(Phone)
UPDATE x_InsuranceCompany SET Phone = NULL WHERE Phone = ''
SELECT InsuranceCompanyName, Phone FROM x_InsuranceCompany WHERE LEN(Phone) > 10
IF @@RowCount > 0 PRINT 'SELECT InsuranceCompanyName, Phone FROM x_InsuranceCompany WHERE LEN(Phone) > 10'
-- UPDATE x_InsuranceCompany SET Phone = NULL WHERE  LEN(Phone) > 10
SELECT Phone FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(Phone, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT Phone FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(Phone, 0)) = 0'

--UPDATE x_InsuranceCompany SET CarrierType = NULL WHERE CarrierType = ''
--SELECT CarrierType FROM x_InsuranceCompany WHERE CarrierType NOT IN('01', '02','04','05','MG') AND CarrierType IS NOT NULL

UPDATE x_InsuranceCompany SET InsuranceProgramCode = NULL WHERE InsuranceProgramCode = ''
UPDATE x_InsuranceCompany SET InsuranceProgramCode = 'CI' WHERE InsuranceProgramCode IS NULL
SELECT InsuranceProgramCode FROM x_InsuranceCompany WHERE InsuranceProgramCode NOT IN('09', '10','11','12','13','14','15','16','AM','BL','CH','CI','DS','HM','LI','LM','MB','MC','OF','TV','VA','WC','ZZ') AND InsuranceProgramCode IS NOT NULL
IF @@RowCount > 0 PRINT 'SELECT InsuranceProgramCode FROM x_InsuranceCompany WHERE InsuranceProgramCode NOT IN AND InsuranceProgramCode IS NOT NULL'

UPDATE x_InsuranceCompany SET Fax = dbo.fn_GetNumberImport(Fax)
UPDATE x_InsuranceCompany SET Fax = NULL WHERE Fax = ''
SELECT InsuranceCompanyName, Fax FROM x_InsuranceCompany WHERE LEN(Fax) > 10
IF @@RowCount > 0 PRINT 'SELECT InsuranceCompanyName, Fax FROM x_InsuranceCompany WHERE LEN(Fax) > 10'
SELECT Fax FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(Fax, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT Fax FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(Fax, 0)) = 0'

--UPDATE x_InsuranceCompany SET Phone = NULL WHERE ISNUMERIC(ISNULL(Phone, 0)) = 0
--UPDATE x_InsuranceCompany SET Phone = SUBSTRING(Phone, 2, LEN(Phone)-2) WHERE LEFT(phone, 1) = '1'
--SELECT Phone = SUBSTRING(Phone, 2, LEN(Phone)-2), PhoneOrig = Phone FROM x_InsuranceCompany WHERE LEFT(Phone, 1) = '1'

--UPDATE x_InsuranceCompany SET BillingFormID = NULL

--SELECT DISTINCT InsuranceProgramCode, ProgramName FROM dbo.InsuranceProgram

--UPDATE x_InsuranceCompany SET InsuranceProgramCode = 'CI' WHERE [Carrier Type] = '01'
--UPDATE x_InsuranceCompany SET InsuranceProgramCode = 'MC' WHERE [Carrier Type] = '02'
--UPDATE x_InsuranceCompany SET InsuranceProgramCode = 'MB' WHERE [Carrier Type] = '04'
--UPDATE x_InsuranceCompany SET InsuranceProgramCode = 'BL' WHERE [Carrier Type] = '05'
--UPDATE x_InsuranceCompany SET InsuranceProgramCode = 'ZZ' WHERE [Carrier Type] = 'MG'


UPDATE x_Doctor SET VendorID = NULL WHERE VendorID = ''
UPDATE x_Doctor SET LastName = NULL WHERE LastName = ''
UPDATE x_Doctor SET FirstName = NULL WHERE FirstName = ''
UPDATE x_Doctor SET AddressLine1 = NULL WHERE AddressLine1 = ''
UPDATE x_Doctor SET AddressLine2 = NULL WHERE AddressLine2 = ''
UPDATE x_Doctor SET City = NULL WHERE City = ''
UPDATE x_Doctor SET State = NULL WHERE State = ''
UPDATE x_Doctor SET State = dbo.fn_GetStateImport(State)
SELECT State FROM x_Doctor WHERE LEN(State) > 2

UPDATE x_Doctor SET ZipCode = dbo.fn_GetNumberImport(ZipCode)
UPDATE x_Doctor SET ZipCode = NULL WHERE ZipCode = ''
UPDATE x_Doctor SET ZipCode = '0' + ZipCode WHERE LEN(ZipCode) = 4
SELECT ZipCode FROM x_Doctor WHERE LEN(ZipCode) > 9
IF @@RowCount > 0 PRINT 'SELECT ZipCode FROM x_Doctor WHERE LEN(ZipCode) > 9'
SELECT ZipCode FROM x_Doctor WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT FaxNumber FROM x_InsuranceCompany WHERE ISNUMERIC(ISNULL(FaxNumber, 0)) = 0'
UPDATE x_Doctor SET SSN = dbo.fn_GetNumberImport(SSN)
UPDATE x_Doctor SET SSN = NULL WHERE SSN = ''
SELECT SSN FROM x_Doctor WHERE LEN(SSN) > 9
IF @@RowCount > 0 PRINT 'SELECT SSN FROM x_Doctor WHERE LEN(SSN) > 9'
SELECT SSN FROM x_Doctor WHERE ISNUMERIC(ISNULL(SSN, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT SSN FROM x_Doctor WHERE ISNUMERIC(ISNULL(SSN, 0)) = 0'
UPDATE x_Doctor SET HomePhone = dbo.fn_GetNumberImport(HomePhone)
UPDATE x_Doctor SET HomePhone = NULL WHERE HomePhone = ''
SELECT HomePhone FROM x_Doctor WHERE LEN(HomePhone) > 10
IF @@RowCount > 0 PRINT 'SELECT HomePhone FROM x_Doctor WHERE LEN(HomePhone) > 10'
SELECT HomePhone FROM x_Doctor WHERE ISNUMERIC(ISNULL(HomePhone, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT HomePhone FROM x_Doctor WHERE ISNUMERIC(ISNULL(HomePhone, 0)) = 0'
UPDATE x_Doctor SET TaxID = NULL WHERE TaxID = ''
--UPDATE x_Doctor SET [External] = NULL WHERE [External] = ''
UPDATE x_Doctor SET [External] = 1 WHERE [External] IS NULL
SELECT LastName, [External] FROM x_Doctor WHERE [External] IS NULL
IF @@RowCount > 0 PRINT 'SELECT LastName, [External] FROM x_Doctor WHERE [External] IS NULL'
UPDATE x_Doctor SET WorkPhone = dbo.fn_GetNumberImport(WorkPhone)
UPDATE x_Doctor SET WorkPhone = RIGHT(WorkPhone, 10) WHERE WorkPhone = 11
UPDATE x_Doctor SET WorkPhone = NULL WHERE WorkPhone = ''
SELECT WorkPhone FROM x_Doctor WHERE LEN(WorkPhone) > 10
IF @@RowCount > 0 PRINT 'SELECT WorkPhone FROM x_Doctor WHERE LEN(WorkPhone) > 10'
SELECT WorkPhone FROM x_Doctor WHERE ISNUMERIC(ISNULL(WorkPhone, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT WorkPhone FROM x_Doctor WHERE ISNUMERIC(ISNULL(WorkPhone, 0)) = 0'
UPDATE x_Doctor SET FaxNumber = dbo.fn_GetNumberImport(FaxNumber)
UPDATE x_Doctor SET FaxNumber = NULL WHERE FaxNumber = ''
UPDATE x_Doctor SET Degree = NULL WHERE Degree = ''
SELECT FaxNumber FROM x_Doctor WHERE LEN(FaxNumber) > 10
IF @@RowCount > 0 PRINT 'SELECT FaxNumber FROM x_Doctor WHERE LEN(FaxNumber) > 10'
SELECT FaxNumber FROM x_Doctor WHERE ISNUMERIC(ISNULL(FaxNumber, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT FaxNumber FROM x_Doctor WHERE ISNUMERIC(ISNULL(FaxNumber, 0)) = 0'

--UPDATE x_Doctor SET LastName = LastName + ' ' + Degree
--UPDATE x_Doctor SET Degree = NULL
--UPDATE x_Doctor SET LastName = RTRIM(LastName)

--UPDATE x_Doctor SET  LastName = SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)), 
--Degree = SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName) - CHARINDEX(' ', LastName))
--FROM x_Doctor WHERE CHARINDEX(' ', LastName) > 0

--UPDATE x_Doctor SET [External] = 1 WHERE [External] = 'REF' 
--UPDATE x_Doctor SET [External] = 0 WHERE [External] = 'SVC' 
--UPDATE x_Doctor SET [External] = REPLACE(REPLACE(REPLACE(REPLACE([External], '(', ''), ')', ''), '-', ''), ' ', '')
--UPDATE x_Doctor SET [External] = NULL WHERE [External] = ''

--DELETE FROM x_Doctor WHERE LastName Is Null

--==================================================================
UPDATE x_Patient SET PatVendorID = ISNULL(FirstName, '') + ISNULL(LastName, '') + ISNULL(SSN, '') WHERE PatVendorID IS NULL

--UPDATE x_Patient SET PatVendorID = NULL WHERE PatVendorID = ''
UPDATE x_Patient SET FirstName = NULL WHERE FirstName = ''
UPDATE x_Patient SET MiddleName = NULL WHERE MiddleName = ''
UPDATE x_Patient SET LastName = NULL WHERE LastName = ''
UPDATE x_Patient SET AddressLine1 = NULL WHERE AddressLine1 = ''
UPDATE x_Patient SET AddressLine2 = NULL WHERE AddressLine2 = ''
UPDATE x_Patient SET City = NULL WHERE City = ''
UPDATE x_Patient SET State = NULL WHERE State = ''
UPDATE x_Patient SET State = dbo.fn_GetStateImport(State)
SELECT State FROM x_Patient WHERE LEN(State) > 2
IF @@RowCount > 0 PRINT '90'
--UPDATE x_Patient SET State = NULL WHERE LEN(State) > 2
UPDATE x_Patient SET ZipCode = dbo.fn_GetNumberImport(ZipCode)
UPDATE x_Patient SET ZipCode = NULL WHERE ZipCode = ''
UPDATE x_Patient SET ZipCode = '0' + ZipCode WHERE LEN(ZipCode) = 4
SELECT ZipCode FROM x_Patient WHERE LEN(ZipCode) > 9
IF @@RowCount > 0 PRINT '100'
SELECT ZipCode FROM x_Patient WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT ZipCode FROM x_Patient WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0'

UPDATE x_Patient SET HomePhone = dbo.fn_GetNumberImport(HomePhone)

UPDATE x_Patient SET HomePhone = NULL WHERE HomePhone = ''
SELECT HomePhone FROM x_Patient WHERE LEN(HomePhone) > 10
--UPDATE x_Patient SET HomePhone = NULL WHERE LEN(HomePhone) > 10
--UPDATE x_Patient SET HomePhone = SUBSTRING(HomePhone, 2, LEN(Phone)-2) WHERE LEFT(HomePhone, 1) = '1'
IF @@RowCount > 0 PRINT '101'
SELECT HomePhone FROM x_Patient WHERE ISNUMERIC(ISNULL(HomePhone, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT HomePhone FROM x_Patient WHERE ISNUMERIC(ISNULL(HomePhone, 0)) = 0'
UPDATE x_Patient SET WorkPhone = dbo.fn_GetNumberImport(WorkPhone)
UPDATE x_Patient SET WorkPhone = NULL WHERE WorkPhone = ''
UPDATE x_Doctor SET WorkPhone = RIGHT(WorkPhone, 10) WHERE WorkPhone = 11
--SELECT WorkPhone FROM x_Patient WHERE LEFT(WorkPhone, 1) = '1'
--UPDATE x_Patient SET WorkPhone = SUBSTRING(WorkPhone, 2, LEN(WorkPhone)-2) WHERE LEFT(WorkPhone, 1) = '1'

SELECT WorkPhone = Left(WorkPhone, 10), RIGHT(WorkPhone, LEN(WorkPhone) - 10) AS EXT FROM x_Patient WHERE LEN(WorkPhone) > 10
--UPDATE x_Patient SET WorkPhoneExt = RIGHT(WorkPhone, LEN(WorkPhone) - 10), WorkPhone = Left(WorkPhone, 10) FROM x_Patient WHERE LEN(WorkPhone) > 10
SELECT WorkPhone FROM x_Patient WHERE LEN(WorkPhone) > 10
IF @@RowCount > 0 PRINT '102'
SELECT WorkPhone FROM x_Patient WHERE ISNUMERIC(ISNULL(WorkPhone, 0)) = 0

IF @@RowCount > 0 PRINT 'SELECT WorkPhone FROM x_Patient WHERE ISNUMERIC(ISNULL(WorkPhone, 0)) = 0'
--UPDATE x_Patient SET Workphone = NULL WHERE ISNUMERIC(ISNULL(WorkPhone, 0)) = 0 

UPDATE x_Patient SET WorkPhoneExt = dbo.fn_GetNumberImport(WorkPhoneExt)
UPDATE x_Patient SET WorkPhoneExt = NULL WHERE WorkPhoneExt = ''
SELECT WorkPhoneExt FROM x_Patient WHERE LEN(WorkPhoneExt) > 9
IF @@RowCount > 0 PRINT '103'
SELECT WorkPhoneExt FROM x_Patient WHERE ISNUMERIC(ISNULL(WorkPhoneExt, 0)) = 0
IF @@RowCount > 0 PRINT '103.1'

UPDATE x_Patient SET MobilePhone = dbo.fn_GetNumberImport(MobilePhone)

SELECT MobilePhone FROM x_Patient WHERE LEFT(MobilePhone, 1) = '1'
--UPDATE x_Patient SET MobilePhone = SUBSTRING(MobilePhone, 2, LEN(MobilePhone)-2) WHERE LEFT(MobilePhone, 1) = '1'
SELECT MobilePhone = Left(MobilePhone, 10), RIGHT(MobilePhone, LEN(MobilePhone) - 10) AS EXT FROM x_Patient WHERE LEN(MobilePhone) > 10
--UPDATE x_Patient SET MobilePhoneExt = RIGHT(MobilePhone, LEN(MobilePhone) - 10), MobilePhone = Left(MobilePhone, 10) FROM x_Patient WHERE LEN(MobilePhone) > 10

SELECT MobilePhone FROM x_Patient WHERE LEN(MobilePhone) > 10
IF @@RowCount > 0 PRINT '103.5'
SELECT MobilePhone FROM x_Patient WHERE ISNUMERIC(ISNULL(MobilePhone, 0)) = 0
IF @@RowCount > 0 PRINT '103.6'

UPDATE x_Patient SET MobilePhoneExt = dbo.fn_GetNumberImport(MobilePhoneExt)
UPDATE x_Patient SET MobilePhoneExt = NULL WHERE MobilePhoneExt = ''
SELECT MobilePhoneExt FROM x_Patient WHERE LEN(MobilePhoneExt) > 9
IF @@RowCount > 0 PRINT '103.7'
SELECT MobilePhoneExt FROM x_Patient WHERE ISNUMERIC(ISNULL(MobilePhoneExt, 0)) = 0
IF @@RowCount > 0 PRINT '103.8'

UPDATE x_Patient SET SSN = dbo.fn_GetNumberImport(SSN)
UPDATE x_Patient SET SSN = NULL WHERE SSN = ''
UPDATE x_Patient SET SSN = NULL WHERE SSN = 0
--$$$$$$$$$$$$$$$
UPDATE x_Patient SET SSN = '0' + SSN WHERE LEN(SSN) = 8
--UPDATE x_Patient SET SSN = LEFT(SSN, 9) WHERE LEN(SSN) > 9
--UPDATE x_Patient SET SSN = NULL WHERE LEN(SSN) > 9
--$$$$$$$$$$$$$$$
UPDATE x_Patient SET SSN = NULL WHERE LEN(SSN) < 9
SELECT SSN FROM x_Patient WHERE ISNUMERIC(ISNULL(SSN, 0)) = 0
IF @@RowCount > 0 PRINT '104'
SELECT SSN FROM x_Patient WHERE LEN(SSN) > 9
IF @@RowCount > 0 PRINT '105'
SELECT SSN FROM x_Patient WHERE LEN(SSN) < 9
IF @@RowCount > 0 PRINT 'SELECT SSN FROM x_Patient WHERE LEN(SSN) < 9'

UPDATE x_Patient SET EmploymentStatus = NULL WHERE EmploymentStatus = ''
UPDATE x_Patient SET MedicalRecordNumber = NULL WHERE MedicalRecordNumber = ''
--UPDATE x_Patient SET MedicalRecordNumber = PatVendorID
UPDATE x_Patient SET Gender = NULL WHERE Gender = ''
SELECT Gender FROM x_Patient WHERE Gender NOT IN('M', 'F', 'U')
--UPDATE x_Patient SET Gender = 'U' WHERE Gender IS NULL
--UPDATE x_Patient SET Gender = 'U' WHERE Gender NOT IN('M', 'F', 'U')
UPDATE x_Patient SET DOB = NULL WHERE DOB = ''
SELECT DOB FROM x_Patient WHERE ISDATE(DOB) = 0 AND DOB IS NOT NULL
IF @@RowCount > 0 PRINT 'SELECT DOB FROM x_Patient WHERE ISDATE(DOB) = 0 AND DOB IS NOT NULL'
--UPDATE x_Patient SET DOB = NULL WHERE ISDATE(DOB) = 0 AND DOB IS NOT NULL
--SELECT CONVERT(DateTime, DOB, 112) AS DOB FROM x_Patient
--UPDATE x_Patient SET DOB = NULL WHERE LEN(DOB) < 4
--UPDATE x_Patient SET DOB = CONVERT(DateTime, DOB, 112)
--SELECT CONVERT(DateTime, DOB, 112) FROM x_Patient
--SELECT DOB FROM x_Patient WHERE ISDATE(DOB) = 0 AND DOB IS NOT NULL

UPDATE x_Patient SET MaritalStatus = NULL WHERE MaritalStatus = ''

UPDATE x_Patient SET MaritalStatus = 'U' WHERE MaritalStatus IS NULL OR MaritalStatus = ''
--$$$$$$$$$$$
UPDATE x_Patient SET MaritalStatus = 'S' WHERE MaritalStatus IN('D', 'W')
--$$$$$$$$$
UPDATE x_Patient SET MaritalStatus = 'U' WHERE MaritalStatus NOT IN('M', 'S', 'U')
--SELECT DISTINCT MaritalStatus FROM x_Patient 
SELECT MaritalStatus FROM x_Patient WHERE MaritalStatus NOT IN('M', 'S', 'U')
IF @@RowCount > 0 PRINT '105'
--UPDATE x_Patient SET MaritalStatus = 'S' WHERE MaritalStatus = 'D'
--UPDATE x_Patient SET MaritalStatus = 'S' WHERE MaritalStatus = 'W'

UPDATE x_Patient SET ProviderPhysician_VendorID = NULL WHERE ProviderPhysician_VendorID = ''
UPDATE x_Patient SET ReferringPhysician_VendorID = NULL WHERE ReferringPhysician_VendorID = ''

UPDATE x_Patient SET Holder1FirstName = NULL WHERE Holder1FirstName = ''
UPDATE x_Patient SET Holder1LastName = NULL WHERE Holder1LastName = ''

UPDATE x_Patient SET Holder1MiddleName = NULL WHERE Holder1MiddleName = ''
UPDATE x_Patient SET Holder1AddressLine1 = NULL WHERE Holder1AddressLine1 = ''
UPDATE x_Patient SET Holder1AddressLine2 = NULL WHERE Holder1AddressLine2 = ''
UPDATE x_Patient SET Holder1City = NULL WHERE Holder1City = ''
UPDATE x_Patient SET Holder1State = NULL WHERE Holder1State = ''
UPDATE x_Patient SET Holder1State = dbo.fn_GetStateImport(Holder1State)
SELECT Holder1State FROM x_Patient WHERE LEN(Holder1State) > 2
UPDATE x_Patient SET Holder1ZipCode = dbo.fn_GetNumberImport(Holder1ZipCode)
UPDATE x_Patient SET Holder1ZipCode = NULL WHERE Holder1ZipCode = ''
SELECT Holder1ZipCode FROM x_Patient WHERE LEN(Holder1ZipCode) > 9
IF @@RowCount > 0 PRINT '106'
SELECT Holder1ZipCode FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder1ZipCode, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT Holder1ZipCode FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder1ZipCode, 0)) = 0'

UPDATE x_Patient SET Holder1Phone = dbo.fn_GetNumberImport(Holder1Phone)
UPDATE x_Patient SET Holder1Phone = NULL WHERE Holder1Phone = ''
SELECT Holder1Phone FROM x_Patient WHERE LEN(Holder1Phone) > 10
IF @@RowCount > 0 PRINT '107'
SELECT Holder1Phone FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder1Phone, 0)) = 0
IF @@RowCount > 0 PRINT '108'
UPDATE x_Patient SET Holder1DOB = NULL WHERE Holder1DOB = ''
--UPDATE x_Patient SET Holder1DOB = NULL WHERE ISDATE(Holder1DOB) = 0 AND Holder1DOB IS NOT NULL
--UPDATE x_Patient SET Holder1DOB = CONVERT(DateTime, Holder1DOB, 112)
SELECT Holder1DOB FROM x_Patient WHERE ISDATE(Holder1DOB) = 0 AND Holder1DOB IS NOT NULL
IF @@RowCount > 0 PRINT '109'
UPDATE x_Patient SET Holder1SSN = dbo.fn_GetNumberImport(Holder1SSN)
UPDATE x_Patient SET Holder1EmployerName = NULL WHERE Holder1EmployerName = ''
UPDATE x_Patient SET Holder1Gender = NULL WHERE Holder1Gender = ''
SELECT Holder1Gender FROM x_Patient WHERE Holder1Gender NOT IN('M', 'F', 'U')
IF @@RowCount > 0 PRINT 'SELECT Holder1Gender FROM x_Patient WHERE Holder1Gender NOT IN'

UPDATE x_Patient SET Holder1PatientRelationshipToInsured = NULL WHERE Holder1PatientRelationshipToInsured = ''
SELECT DISTINCT Holder1PatientRelationshipToInsured FROM x_Patient WHERE (NOT Holder1PatientRelationshipToInsured IN('S', 'U', 'C', 'O')) 
IF @@RowCount > 0 PRINT '109'
--UPDATE x_Patient SET Holder1PatientRelationshipToInsured = NULL WHERE (NOT Holder1PatientRelationshipToInsured IN('S', 'U', 'C', 'O')) 
--UPDATE x_Patient SET Holder1PatientRelationshipToInsured = 'U' WHERE Holder1PatientRelationshipToInsured = '02'
--UPDATE x_Patient SET Holder1PatientRelationshipToInsured = 'S' WHERE Holder1PatientRelationshipToInsured = '01'
--UPDATE x_Patient SET Holder1PatientRelationshipToInsured = 'C' WHERE Holder1PatientRelationshipToInsured = '0#'
--SELECT Holder1PatientRelationshipToInsured, FirstName, DOB, HOLDER1LastName, Holder1DOB FROM x_Patient
UPDATE x_Patient SET InsVendorID1 = NULL WHERE InsVendorID1 = ''
UPDATE x_Patient SET PolicyNumber1 = NULL WHERE PolicyNumber1 = ''
UPDATE x_Patient SET GroupNumber1 = NULL WHERE GroupNumber1 = ''
UPDATE x_Patient SET Copay1 = NULL WHERE Copay1 = ''
UPDATE x_Patient SET AdjusterLastName1 = NULL WHERE AdjusterLastName1 = ''
SELECT Copay1 FROM x_Patient WHERE ISNUMERIC(ISNULL(Copay1, 0)) = 0
IF @@RowCount > 0 PRINT '110'

UPDATE x_Patient SET Holder2FirstName = NULL WHERE Holder2FirstName = ''
UPDATE x_Patient SET Holder2LastName = NULL WHERE Holder2LastName = ''

UPDATE x_Patient SET Holder2MiddleName = NULL WHERE Holder2MiddleName = ''
UPDATE x_Patient SET Holder2AddressLine1 = NULL WHERE Holder2AddressLine1 = ''
UPDATE x_Patient SET Holder2AddressLine2 = NULL WHERE Holder2AddressLine2 = ''
UPDATE x_Patient SET Holder2City = NULL WHERE Holder2City = ''
UPDATE x_Patient SET Holder2State = NULL WHERE Holder2State = ''
UPDATE x_Patient SET Holder2State = dbo.fn_GetStateImport(Holder2State)
SELECT Holder2State FROM x_Patient WHERE LEN(Holder2State) > 2
UPDATE x_Patient SET Holder2ZipCode = dbo.fn_GetNumberImport(Holder2ZipCode)
UPDATE x_Patient SET Holder2ZipCode = NULL WHERE Holder2ZipCode = ''
SELECT Holder2ZipCode FROM x_Patient WHERE LEN(Holder2ZipCode) > 9
IF @@RowCount > 0 PRINT '111'
SELECT Holder2ZipCode FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder2ZipCode, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT Holder2ZipCode FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder2ZipCode, 0)) = 0'

UPDATE x_Patient SET Holder2Phone = dbo.fn_GetNumberImport(Holder2Phone)
UPDATE x_Patient SET Holder2Phone = NULL WHERE Holder2Phone = ''
SELECT Holder2Phone FROM x_Patient WHERE LEN(Holder2Phone) > 10
IF @@RowCount > 0 PRINT '111'
SELECT Holder2Phone FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder2Phone, 0)) = 0
--UPDATE x_Patient SET Holder2DOB = NULL WHERE ISDATE(Holder2DOB) = 0 AND Holder2DOB IS NOT NULL
--UPDATE x_Patient SET Holder2DOB = CONVERT(DateTime, Holder2DOB, 112)
UPDATE x_Patient SET Holder2DOB = NULL WHERE Holder2DOB = ''
UPDATE x_Patient SET Holder2SSN = dbo.fn_GetNumberImport(Holder2SSN)
SELECT Holder2DOB FROM x_Patient WHERE ISDATE(Holder2DOB) = 0 AND Holder2DOB IS NOT NULL
IF @@RowCount > 0 PRINT '112'
UPDATE x_Patient SET Holder2EmployerName = NULL WHERE Holder2EmployerName = ''
UPDATE x_Patient SET Holder2Gender = NULL WHERE Holder2Gender = ''
SELECT Holder2Gender FROM x_Patient WHERE Holder2Gender NOT IN('M', 'F', 'U')
IF @@RowCount > 0 PRINT '113'

UPDATE x_Patient SET Holder2PatientRelationshipToInsured = NULL WHERE Holder2PatientRelationshipToInsured = ''
SELECT DISTINCT Holder2PatientRelationshipToInsured FROM x_Patient WHERE (NOT Holder2PatientRelationshipToInsured IN('S', 'U', 'C', 'O')) 
IF @@RowCount > 0 PRINT '114'
--UPDATE x_Patient SET Holder2PatientRelationshipToInsured = NULL WHERE (NOT Holder2PatientRelationshipToInsured IN('S', 'U', 'C', 'O')) 
--UPDATE x_Patient SET Holder2PatientRelationshipToInsured = 'U' WHERE Holder2PatientRelationshipToInsured = '02'
--UPDATE x_Patient SET Holder2PatientRelationshipToInsured = 'S' WHERE Holder2PatientRelationshipToInsured = '01'
--UPDATE x_Patient SET Holder2PatientRelationshipToInsured = 'C' WHERE Holder2PatientRelationshipToInsured = '03'
--SELECT Holder2PatientRelationshipToInsured, FirstName, DOB, Holder2LastName, Holder2DOB FROM x_Patient

UPDATE x_Patient SET InsVendorID2 = NULL WHERE InsVendorID2 = ''
UPDATE x_Patient SET PolicyNumber2 = NULL WHERE PolicyNumber2 = ''
UPDATE x_Patient SET GroupNumber2 = NULL WHERE GroupNumber2 = ''
UPDATE x_Patient SET Copay2 = NULL WHERE Copay2 = ''
UPDATE x_Patient SET AdjusterLastName2 = NULL WHERE AdjusterLastName2 = ''
SELECT Copay2 FROM x_Patient WHERE ISNUMERIC(ISNULL(Copay2, 0)) = 0
IF @@RowCount > 0 PRINT 'SELECT Copay2 FROM x_Patient WHERE ISNUMERIC(ISNULL(Copay2, 0)) = 0'

UPDATE x_Patient SET Holder3FirstName = NULL WHERE Holder3FirstName = ''
UPDATE x_Patient SET Holder3LastName = NULL WHERE Holder3LastName = ''

UPDATE x_Patient SET Holder3MiddleName = NULL WHERE Holder3MiddleName = ''
UPDATE x_Patient SET Holder3AddressLine1 = NULL WHERE Holder3AddressLine1 = ''
UPDATE x_Patient SET Holder3AddressLine2 = NULL WHERE Holder3AddressLine2 = ''
UPDATE x_Patient SET Holder3City = NULL WHERE Holder3City = ''
UPDATE x_Patient SET Holder3State = NULL WHERE Holder3State = ''
UPDATE x_Patient SET Holder3State = dbo.fn_GetStateImport(Holder3State)
SELECT Holder3State FROM x_Patient WHERE LEN(Holder3State) > 2
UPDATE x_Patient SET Holder3ZipCode = dbo.fn_GetNumberImport(Holder3ZipCode)
UPDATE x_Patient SET Holder3ZipCode = NULL WHERE Holder3ZipCode = ''
SELECT Holder3ZipCode FROM x_Patient WHERE LEN(Holder3ZipCode) > 9
IF @@RowCount > 0 PRINT '115'
SELECT Holder3ZipCode FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder3ZipCode, 0)) = 0
IF @@RowCount > 0 PRINT '116'
UPDATE x_Patient SET Holder3Phone = dbo.fn_GetNumberImport(Holder3Phone)
UPDATE x_Patient SET Holder3Phone = NULL WHERE Holder3Phone = ''
SELECT Holder3Phone FROM x_Patient WHERE LEN(Holder3Phone) > 10
IF @@RowCount > 0 PRINT '117'
SELECT Holder3Phone FROM x_Patient WHERE ISNUMERIC(ISNULL(Holder3Phone, 0)) = 0
UPDATE x_Patient SET Holder3DOB = NULL WHERE Holder3DOB = ''
--UPDATE x_Patient SET Holder3DOB = NULL WHERE ISDATE(Holder3DOB) = 0 AND Holder3DOB IS NOT NULL
--UPDATE x_Patient SET Holder3DOB = CONVERT(DateTime, Holder3DOB, 112)
SELECT Holder3DOB FROM x_Patient WHERE ISDATE(Holder3DOB) = 0 AND Holder3DOB IS NOT NULL
IF @@RowCount > 0 PRINT '118'
UPDATE x_Patient SET Holder3SSN = dbo.fn_GetNumberImport(Holder3SSN)
UPDATE x_Patient SET Holder3EmployerName = NULL WHERE Holder3EmployerName = ''
UPDATE x_Patient SET Holder3Gender = NULL WHERE Holder3Gender = ''
SELECT Holder3Gender FROM x_Patient WHERE Holder3Gender NOT IN('M', 'F', 'U')
IF @@RowCount > 0 PRINT 'SELECT Holder3Gender FROM x_Patient WHERE Holder3Gender NOT IN'

UPDATE x_Patient SET Holder3PatientRelationshipToInsured = NULL WHERE Holder3PatientRelationshipToInsured = ''
SELECT DISTINCT Holder3PatientRelationshipToInsured FROM x_Patient WHERE (NOT Holder3PatientRelationshipToInsured IN('S', 'U', 'C', 'O')) 
IF @@RowCount > 0 PRINT '119'
--UPDATE x_Patient SET Holder3PatientRelationshipToInsured = NULL WHERE (NOT Holder3PatientRelationshipToInsured IN('S', 'U', 'C', 'O')) 
--UPDATE x_Patient SET Holder3PatientRelationshipToInsured = 'U' WHERE Holder3PatientRelationshipToInsured = '02'
--UPDATE x_Patient SET Holder3PatientRelationshipToInsured = 'S' WHERE Holder3PatientRelationshipToInsured = '01'
--UPDATE x_Patient SET Holder3PatientRelationshipToInsured = 'C' WHERE Holder3PatientRelationshipToInsured = '03'

UPDATE x_Patient SET InsVendorID3 = NULL WHERE InsVendorID3 = ''
UPDATE x_Patient SET PolicyNumber3 = NULL WHERE PolicyNumber3 = ''
UPDATE x_Patient SET GroupNumber3 = NULL WHERE GroupNumber3 = ''
UPDATE x_Patient SET AdjusterLastName3 = NULL WHERE AdjusterLastName3 = ''
UPDATE x_Patient SET Copay3 = NULL WHERE CoPay3 = ''
SELECT Copay3 FROM x_Patient WHERE ISNUMERIC(ISNULL(Copay3, 0)) = 0
IF @@RowCount > 0 PRINT '120'

--Ins1PolicyType
--Ins2PolicyType
--ProviderPhysician_VendorID
--ReferringPhysician_VendorID
--MaritalStatus
--MedicalRecordNumber

--UPDATE x_Patient SET [FIRST_NAME_MI] = RTRIM(LTRIM([FIRST_NAME_MI]))

--UPDATE x_Patient SET  FirstName = SUBSTRING([FIRST_NAME_MI], 0, CHARINDEX(' ', [FIRST_NAME_MI])), 
--MiddleName = SUBSTRING([FIRST_NAME_MI], CHARINDEX(' ', [FIRST_NAME_MI]) + 1, LEN([FIRST_NAME_MI]) - CHARINDEX(' ', [FIRST_NAME_MI]))
--FROM x_Patient WHERE CHARINDEX(' ', [FIRST_NAME_MI]) > 0

--UPDATE x_Patient SET
----SELECT  
--FirstName = [FIRST_NAME_MI]
----, [FIRST_NAME_MI]
--FROM x_Patient WHERE CHARINDEX(' ', [FIRST_NAME_MI]) = 0

--SELECT FirstName, MiddleName, LastName, [FIRST_NAME_MI] FROM x_Patient



--UPDATE x_Patient SET Phone = NULL WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
--SELECT ZipCode FROM x_Patient WHERE ISNUMERIC(ISNULL(ZipCode, 0)) = 0
--UPDATE x_Patient SET ZipCode = NULL WHERE LEN(ZipCode) > 9


--UPDATE x_Patient SET HomePhone = LEFT(HomePhone, 10) WHERE LEN(HomePhone) > 10


--UPDATE x_Patient SET WorkPhone = LEFT(WorkPhone, 10) WHERE LEN(WorkPhone) > 10

--UPDATE x_Patient SET WorkPhone = SUBSTRING(WorkPhone, 0, CHARINDEX('X', WorkPhone)), 
--WorkPhoneExt = SUBSTRING(WorkPhone, CHARINDEX('X', WorkPhone) + 1, LEN(WorkPhone) - CHARINDEX('X', WorkPhone))
--FROM x_Patient
--WHERE (CHARINDEX('X', WorkPhone) > 0)


--UPDATE x_Patient SET DOB = NULL WHERE ISDATE(DOB) = 0 AND DOB IS NOT NULL

--UPDATE x_Patient SET EmploymentStatus = 'E' WHERE EmploymentStatus = 'F'
--UPDATE x_Patient SET EmploymentStatus = 'U' WHERE EmploymentStatus IS NULL

--UPDATE x_Patient SET MedicareID = NULL WHERE MedicareID = ''
--UPDATE x_Patient SET MedicalID = NULL WHERE MedicalID = ''


--UPDATE x_Patient SET Holder1PatientRelationshipToInsured = 'U' WHERE Holder1PatientRelationshipToInsured = 'S'
--UPDATE x_Patient SET Holder1PatientRelationshipToInsured = 'S' WHERE Holder1PatientRelationshipToInsured = 'I'

--UPDATE x_Patient SET Holder1PatientRelationshipToInsured = 'S' WHERE Holder1PatientRelationshipToInsured = '18'
--UPDATE x_Patient SET Holder1PatientRelationshipToInsured = 'U' WHERE Holder1PatientRelationshipToInsured = '01'
--UPDATE x_Patient SET Holder1PatientRelationshipToInsured = 'C' WHERE Holder1PatientRelationshipToInsured = '19'
--UPDATE x_Patient SET Holder1PatientRelationshipToInsured = 'O' WHERE (NOT Holder1PatientRelationshipToInsured IN('18', '01', '19', 'S', 'U', 'C')) 
--AND (NOT Holder1PatientRelationshipToInsured IS NULL)

--UPDATE xPatientTotal
--SET Holder2LastName = NULL, Holder2FirstName = NULL, Holder2MiddleName = NULL, 
-- Holder2AddressLine1 = NULL, Holder2AddressLine2 = NULL, Holder2City = NULL, 
--Holder2State = NULL, Holder2ZipCode = NULL, 
-- Holder2Phone = NULL, Holder2DOB = NULL, Holder2Gender = NULL
--WHERE (Holder2PatientRelationshipToInsured = N'S')




--UPDATE x_Patient
--SET 
--InsVendorID1 = 'Medicare Of So. Cal.', 
--GroupNumber1 = NULL, 
--PolicyNumber1 = MedicareID, 
--Holder1FirstName = NULL, 
--Holder1LastName = NULL, 
--Holder1PatientRelationshipToInsured = NULL, 
--InsVendorID2 = 'Calif. Medi-Cal', 
--GroupNumber2 = NULL, 
--PolicyNumber2 = MedicalID,  
--Holder2FirstName = NULL, 
--Holder2LastName = NULL, 
--Holder2PatientRelationshipToInsured = NULL, 
--CoPay2 = NULL
--WHERE (MedicareID IS NOT NULL) AND (MedicalID IS NOT NULL)
--
--UPDATE    x_Patient
--SET 
--InsVendorID1 = 'Medicare Of So. Cal.', 
--GroupNumber1 = NULL, 
--PolicyNumber1 = MedicareID, 
--Holder1FirstName = NULL, 
--Holder1LastName = NULL, 
--Holder1PatientRelationshipToInsured = NULL, 
--InsVendorID2 = InsVendorID1, 
--GroupNumber2 = GroupNumber1, 
--PolicyNumber2 = PolicyNumber1,  
--Holder2FirstName = Holder1FirstName, 
--Holder2LastName = Holder1LastName, 
--Holder2PatientRelationshipToInsured = Holder1PatientRelationshipToInsured, 
--CoPay2 = CoPay1
--WHERE (MedicareID IS NOT NULL) AND (MedicalID IS NULL)
--
--UPDATE x_Patient
--SET 
--InsVendorID1 = 'Calif. Medi-Cal', 
--GroupNumber1 = NULL, 
--PolicyNumber1 = MedicalID, 
--Holder1FirstName = NULL, 
--Holder1LastName = NULL, 
--Holder1PatientRelationshipToInsured = NULL, 
--InsVendorID2 = InsVendorID1, 
--GroupNumber2 = GroupNumber1, 
--PolicyNumber2 = PolicyNumber1,  
--Holder2FirstName = Holder1FirstName, 
--Holder2LastName = Holder1LastName, 
--Holder2PatientRelationshipToInsured = Holder1PatientRelationshipToInsured, 
--CoPay2 = CoPay1
--WHERE (MedicareID IS NULL) AND (MedicalID IS NOT NULL)

--16446	Medicare Of So. Cal.	Medicare Of So. Cal.
--8230	+62413M878	CNA INSURANCE COMPANIES
--16447	Calif. Medi-Cal	Calif. Medi-Cal

-- AZTEC
--UPDATE x_Patient SET InsVendorID1 = '16446' WHERE InsVendorID1 = 'Medicare Of So. Cal.'
--UPDATE x_Patient SET InsVendorID2 = '16446' WHERE InsVendorID2 = 'Medicare Of So. Cal.'
--UPDATE x_Patient SET InsVendorID1 = '16447' WHERE InsVendorID1 = 'Calif. Medi-Cal'
--UPDATE x_Patient SET InsVendorID2 = '16447' WHERE InsVendorID2 = 'Calif. Medi-Cal'


--SELECT     MedicareID, MedicalID
--FROM         x_Patient
--WHERE     (MedicareID IS NOT NULL) AND (MedicalID IS NOT NULL)
--
--SELECT     MedicareID, MedicalID
--FROM         x_Patient
--WHERE (MedicalID IS NOT NULL) AND (MedicareID IS NULL) 









