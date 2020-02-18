-- ** CHANGE SYNONYM *********
-- ** CHANGE PRACTICEID *******
-- ** CHANGE DATABASE ********
-- SET PRACTICEID
-- SET SYNONYMS

-- Important.
-- ==========
-- Make sure to run another import script before running this script to add employers to the employers table
-- and attorneys to the attorneys table.

-- Tables Populated.
-- =================
-- 1. Doctor
-- 2. Patient
-- 3. PatientCase
-- 4. PatientCaseDate
-- 4. InsuranceCompany
-- 5. InsuranceCompanyPlan
-- 6. InsurancePolicy
-- 7. InsuracePolicyAuthorization

USE superbill_0980_prod -- %%%%%%%%%%%%%%%%%   CHANGE DATABASE   %%%%%%%%%%%%%%%%%

SET NOCOUNT ON
    -- =============================
-- Select * From Practice
-- INSERT INTO Practice ([Name], VendorImportID) VALUES ('Practice 3', 0)
    -- =============================

IF OBJECT_ID('tempdb..#Vars') IS NOT NULL
	DROP TABLE [#Vars]

CREATE TABLE #Vars(VarName varchar(50), VarValue varchar(200))

-- %%%%%%%%%%%  SET VARIABLES    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INSERT INTO #Vars (VarName, VarValue) VALUES ('PracticeID', '1')
INSERT INTO #Vars (VarName, VarValue) VALUES ('VendorName', 'Arkady Goldstein, MD')
INSERT INTO #Vars (VarName, VarValue) VALUES ('PracticeName', 'Initial Import')
INSERT INTO #Vars (VarName, VarValue) VALUES ('iPatient',		'dbo.impMWPAT4049')
INSERT INTO #Vars (VarName, VarValue) VALUES ('iPatientCase',	'dbo.impMWCAS4049')
INSERT INTO #Vars (VarName, VarValue) VALUES ('iDoctor',		'dbo.impMWPHY4049')
INSERT INTO #Vars (VarName, VarValue) VALUES ('iRefPhy',		'dbo.impMWRPH4049')
INSERT INTO #Vars (VarName, VarValue) VALUES ('iInsCompany',	'dbo.impMWINS4049')
INSERT INTO #Vars (VarName, VarValue) VALUES ('iAddress',		'dbo.impMWADD4049')

------------------------ PatientCaseDate
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('PatientCaseDate') and name='VendorImportID')
	ALTER TABLE PatientCaseDate ADD VendorImportID int
------------------------ InsurancePolicyAuthorization
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('InsurancePolicyAuthorization') and name='VendorImportID')
	ALTER TABLE InsurancePolicyAuthorization ADD VendorImportID int
------------------------ Practice
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Practice') and name='VendorImportID')
	ALTER TABLE Practice ADD VendorImportID int
--=========================================================
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'iPatient')
		DROP SYNONYM [iPatient]
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'iPatientCase')
		DROP SYNONYM [iPatientCase]
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'iDoctor')
		DROP SYNONYM [iDoctor]
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'iRefPhy')
		DROP SYNONYM [iRefPhy]
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'iInsCompany')
		DROP SYNONYM [iInsCompany]
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'iAddress')
		DROP SYNONYM [iAddress]
GO
SET NOCOUNT ON
    -- ================================================
	DECLARE @iPatient varchar(50)
	DECLARE @iPatientCase varchar(50)
	DECLARE @iDoctor varchar(50)
	DECLARE @iRefPhy varchar(50)
	DECLARE @iInsCompany varchar(50)
	DECLARE @iAddress varchar(50)

	SELECT @iPatient = VarValue FROM #Vars WHERE VarName = 'iPatient'
	SELECT @iPatientCase = VarValue FROM #Vars WHERE VarName = 'iPatientCase'
	SELECT @iDoctor = VarValue FROM #Vars WHERE VarName = 'iDoctor'
	SELECT @iRefPhy = VarValue FROM #Vars WHERE VarName = 'iRefPhy'
	SELECT @iInsCompany = VarValue FROM #Vars WHERE VarName = 'iInsCompany'
	SELECT @iAddress = VarValue FROM #Vars WHERE VarName = 'iAddress'
	--================================================
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@iDoctor) and name='Office')
		EXEC ('ALTER TABLE ' + @iDoctor + ' ADD Office varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@iDoctor) and name='Cell')
		EXEC ('ALTER TABLE ' + @iDoctor + ' ADD Cell varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@iRefPhy) and name='Office')
		EXEC ('ALTER TABLE ' + @iRefPhy + ' ADD Office varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@iRefPhy) and name='Cell')
		EXEC ('ALTER TABLE ' + @iRefPhy + ' ADD Cell varchar(50)')
	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@iPatient) and name='Email')
		EXEC ('ALTER TABLE ' + @iPatient + ' ADD Email varchar(50)')

    EXEC ('Create Synonym iPatient For ' + @iPatient)
    EXEC ('Create Synonym iPatientCase For ' + @iPatientCase)
    EXEC ('Create Synonym iDoctor For ' + @iDoctor)
    EXEC ('Create Synonym iRefPhy For ' + @iRefPhy)
    EXEC ('Create Synonym iInsCompany For ' + @iInsCompany)
    EXEC ('Create Synonym iAddress For ' + @iAddress)
GO
-- ====================================================
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
GO
-- ==========================================================


SET NOCOUNT ON
    UPDATE iDoctor
        SET ZipCode = dbo.fn_GetNumberImport( ZipCode )
    UPDATE iDoctor
        SET Phone = dbo.fn_GetNumberImport( Phone )
            , Office = dbo.fn_GetNumberImport( Office )
            , Cell = dbo.fn_GetNumberImport( Cell )
            , Fax = dbo.fn_GetNumberImport( Fax )
            , SSNOrFedTaxID = dbo.fn_GetNumberImport( SSNOrFedTaxID )
    UPDATE iRefPhy
        SET SSNOrFedTaxID = dbo.fn_GetNumberImport( SSNOrFedTaxID )
    			, Phone = dbo.fn_GetNumberImport( Phone )
				, Office = dbo.fn_GetNumberImport( Office )
				, Cell = dbo.fn_GetNumberImport( Cell )
        		, Fax = dbo.fn_GetNumberImport( Fax )
        		, ZipCode = dbo.fn_GetNumberImport( ZipCode )
    UPDATE iPatient
        SET Phone1 = dbo.fn_GetNumberImport( Phone1 )
            , Phone2 = dbo.fn_GetNumberImport( Phone2 )
            , WorkPhone = dbo.fn_GetNumberImport( WorkPhone )
            , ZipCode = dbo.fn_GetNumberImport( ZipCode )
            , SocialSecurityNumber = dbo.fn_GetNumberImport( SocialSecurityNumber )
    UPDATE iInsCompany
        SET ZipCode = dbo.fn_GetNumberImport( ZipCode )
            , Phone = dbo.fn_GetNumberImport( Phone )
            , Fax = dbo.fn_GetNumberImport( Fax )
GO
--=====================================================
SET NOCOUNT ON

Declare @Rows               Int
        , @Message          Varchar(75)
        , @PracticeID       Int
        , @VendorImportID   Int
        , @VendorName       Varchar(100)

	SELECT @PracticeID = VarValue FROM #Vars WHERE VarName = 'PracticeID'
	SELECT @VendorName = VarValue FROM #Vars WHERE VarName = 'VendorName'





BEGIN TRANSACTION
BEGIN

    INSERT INTO VendorImport( VendorName, VendorFormat, Notes)
		VALUES(@VendorName, 'MediSoft', 'Import Patients, Doctors, Ref. Physicians, InsCompanies & Policies.')

    Set @VendorImportID = SCOPE_IDENTITY()

    -- =====================
    Print 'Import: ' + Convert( Varchar(20) , @VendorName )
    Print 'Data Import Date & Time : ' + Convert( Varchar(20) , GetDate() )
    Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )
    Print 'DataBase : ' + DB_Name()
    Print 'Practice ID : ' + Convert( Char(1) , @PracticeID )

    -- Import Tables Order.
    -- ====================
    -- Physicians
    -- Referring Physicians
    -- Patients
    -- Insurance Companies
    -- Insurance Company Plans
    --

    -- Import Physicians.
    Insert Into Doctor
    ( PracticeID
      , Prefix
      , FirstName
      , MiddleName
      , LastName
      , Suffix
      , Degree
      , SSN
      -- TaxonomyCode
      , WorkPhone
      , MobilePhone
      , FaxNumber
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , VendorID
      , VendorImportID
      , [External]
      )
    SELECT
      @PracticeID
      , ''
      , IsNull(FirstName, '' ) As FirstName
    	, IsNull( MiddleInitial , '' ) As MiddleName
    	, LastName
    	, ''
    	, Credentials
    	-- , Case When UPIN Is Not Null Then LTrim(RTrim(UPIN)) Else '' End
    	, SSNOrFedTaxID
    	-- , Case When TaxonomyCode Is Not Null Then LTrim(RTrim(TaxonomyCode)) Else NULL End
    	, IsNull( Office , '' ) As WorkPhone
      , IsNull( Cell , '' ) As MobilePhone
    	, Fax
    	, Street1
    	, Street2
    	, City
    	, State
    	, ZipCode
    	, Code
    	, @VendorImportID
    	, 0 As [External]
    FROM iDoctor

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Physicians '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Medical License Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	 Select A.DoctorID
           , 7
           , B.LicenseNumber
		From Doctor A
				Inner Join iDoctor B On A.VendorID = B.Code
		Where IsNull( B.LicenseNumber , '' ) <> ''
				And A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Providers (License Number) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import UPIN Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	 Select A.DoctorID
           , 25
           , B.UPIN
		From Doctor A
				Inner Join iDoctor B On A.VendorID = B.Code
		Where IsNull( B.UPIN , '' ) <> '' And IsNull( UPIN , '' ) Not Like '%NO%'
				And A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Providers (UPIN) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import NPI Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	 Select A.DoctorID
           , 8
           , B.NPI
		From Doctor A
				Inner Join iDoctor B On A.VendorID = B.Code
		Where IsNull( B.NPI , '' ) <> ''
				And A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Providers (NPI) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Select Distinct A.ReferringProvider Into #RefPhy
        From iPatientCase A
                Inner Join iPatient B On B.ChartNumber = A.ChartNumber
        Where B.PatientType <> 'Guarantor'
                And IsNull( A.ReferringProvider , '' ) <> ''

    -- Import Referring Physicians.
    Insert Into Doctor
    ( PracticeID
      , Prefix
      , FirstName
      , MiddleName
      , LastName
      , Suffix
      , Degree
      , SSN
	   , WorkPhone
      , MobilePhone
	   , FaxNumber
	   , AddressLine1
	   , AddressLine2
	   , City
	   , State
	   , ZipCode
	   , VendorID
	   , VendorImportID
	   , [External]
    )
    Select
      @PracticeID
      , '' As Prefix
      ,  IsNull(FirstName, '' ) As FirstName
    	, IsNull( MiddleInitial , '' ) As MiddleName
    	, LastName
    	, '' As Suffix
    	, Credentials
    	, SSNOrFedTaxID
    	, IsNull( Office , '' ) As WorkPhone
      , IsNull( Cell , '' ) As MobilePhone
    	, Fax
    	, Street1
    	, Street2
    	, City
    	, State
    	, ZipCode
    	, Code
    	, @VendorImportID
    	, 1 As [External]
    From iRefPhy A
            Inner Join #RefPhy B On B.ReferringProvider = A.Code
    Where Not Exists ( Select * 
                            From Doctor B
                            Where B.PracticeID = @PracticeID
                                    And B.FirstName = A.FirstName
                                    And B.LastName = A.LastName 
                                    And B.VendorImportID Is Null 
                                    And B.[External] = 1 )

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Referring Physicians '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Medical License Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	 Select A.DoctorID
           , 7
           , B.LicenseNumber
		From Doctor A
				Inner Join iRefPhy B On A.VendorID = B.Code
		Where IsNull( B.LicenseNumber , '' ) <> ''
				And A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Ref. Physicians (License Number) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import UPIN Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select A.DoctorID
           , 25
           , B.UPIN
		From Doctor A
				Inner Join iRefPhy B On A.VendorID = B.Code
		Where IsNull( B.UPIN , '' ) <> '' And IsNull( UPIN , '' ) Not Like '%NO%'
				And A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Ref. Physicians (UPIN) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import NPI Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select A.DoctorID
           , 8
           , B.NPI
		From Doctor A
				Inner Join iRefPhy B On A.VendorID = B.Code
		Where IsNull( B.NPI , '' ) <> ''
				And A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Ref. Physicians (NPI) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


    -- Patient (note: the same ssn can correspond to more than 1 PatientID, if patient used more than one practice)
    -- Insert patients excluding Guarantor (Where Patient Type <> 'Guarantor'
    -- Create table with Patients and their Guarantors
    Create Table #PG
    ( PatientChartNumber                Varchar(50)
      , GuarantorChartNumber            Varchar(50)
      , ResponsibleDifferentThanPatient Bit
      , ResponsibleFirstName            Varchar(50)
      , ResponsibleMiddleName           Varchar(50)
      , ResponsibleLastName             Varchar(50)
      , ResponsibleAddressLine1         Varchar(50)
      , ResponsibleAddressLine2         Varchar(50)
      , ResponsibleCity                 Varchar(50)
      , ResponsibleState                Varchar(50)
      , ResponsibleZipCode              Varchar(50)
      , ResponsibleRelationshipToPatient Varchar(50)
      , CaseNumber                      Varchar(50)
    )

    -- Process Responsible Persons.
    Insert Into #PG
    ( PatientChartNumber
      , GuarantorChartNumber
      , ResponsibleDifferentThanPatient
      , ResponsibleFirstName
      , ResponsibleMiddleName
      , ResponsibleLastName
      , ResponsibleAddressLine1
      , ResponsibleAddressLine2
      , ResponsibleCity
      , ResponsibleState
      , ResponsibleZipCode
      , ResponsibleRelationshipToPatient
      , CaseNumber
    )
    Select Distinct
      CAS.ChartNumber
      , CAS.Guarantor
      , 1
      , PAT.FirstName
      , PAT.MiddleInitial
    	, PAT.LastName
    	, PAT.Street1
    	, PAT.Street2
    	, PAT.City
    	, PAT.State
    	, PAT.ZipCode
      , Case
		  When CAS.Guarantor = CAS.Insured1 Then
				Case
					When Upper( CAS.InsuredRelationship1 ) = 'OTHER' Then 'O'
					When Upper( CAS.InsuredRelationship1 ) = 'CHILD' Then 'O'
					When Upper( CAS.InsuredRelationship1 ) = 'SPOUSE' Then 'U'
					When Upper( CAS.InsuredRelationship1 ) = 'SELF' Then 'S'
					Else 'O'
				End
			Else 'O'
		  End As ResponsibleRelationshipToPatient
    	, CAS.CaseNumber
    From iPatient PAT
        Inner Join iPatientCase CAS On CAS.Guarantor = PAT.ChartNumber
    Where CAS.ChartNumber <> CAS.Guarantor

    -- Delete duplicate patients with guarantors; use guarantor listed for the most recent Case
    Delete From #PG
    Where Exists
    	( Select * From #PG As Z
        	Where Z.PatientChartNumber = #PG.PatientChartNumber
        	        And Convert( Int , Z.CaseNumber ) > Convert( Int , #PG.CaseNumber ) )

    -- Select * From #PG Order By PatientChartNumber

    -- Import Patients.
    INSERT INTO Patient
    ( VendorImportID
      , VendorID
      , PracticeID
      , Prefix
      , FirstName
      , MiddleName
      , LastName
      , Suffix
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , Gender
      , MaritalStatus
      , EmploymentStatus
      , HomePhone
      , WorkPhone
      , WorkPhoneExt
      , EmailAddress
      , DOB
      , SSN
	  , MedicalRecordNumber
      , ResponsibleDifferentThanPatient
      , ResponsibleFirstName
      , ResponsibleMiddleName
      , ResponsibleLastName
      , ResponsibleAddressLine1
      , ResponsibleAddressLine2
      , ResponsibleCity
      , ResponsibleState
      , ResponsibleZipCode
	   , ResponsibleRelationshipToPatient
      , PrimaryProviderID
      , MobilePhone
    )
    SELECT
      @VendorImportID
      , PAT.ChartNumber
      , @PracticeID
    	, ''
    	,  IsNull(PAT.FirstName, '' ) As FirstName
    	, IsNull( PAT.MiddleInitial , '' ) As MiddleName
    	, PAT.LastName
    	, ''
    	, PAT.Street1
    	, PAT.Street2
    	, PAT.City
    	, PAT.State
    	, PAT.ZipCode
    	, Case
			When LTrim( RTrim( PAT.Sex ) ) = 'Male' Then 'M'
         	When LTrim( RTrim( PAT.Sex ) ) = 'Female' Then 'F'
         	Else 'U'
		  End As Gender
    	, 'U' As MaritalStatus
      , Case
            When PAT.EmploymentStatus = 'Full time' Then 'E'
            When PAT.EmploymentStatus = 'Part time' Then 'E'
            When PAT.EmploymentStatus = 'Retired' Then 'R'
            Else 'U'
        End As EmploymentStatus
    	, PAT.Phone1
    	, PAT.WorkPhone
    	, PAT.WorkExtension
      , PAT.Email
    	, PAT.DateOfBirth
    	, Case
            When Len( PAT.SocialSecurityNumber ) = 9 Then PAT.SocialSecurityNumber
            Else Null
        End
      , PAT.ChartNumber
    	, Case When PG.PatientChartNumber Is Not Null Then 1 Else 0 End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleFirstName Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleMiddleName Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleLastName Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleAddressLine1 Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleAddressLine2 Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleCity Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleState Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then Left( PG.ResponsibleZipCode , 9 ) Else NULL End
		, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleRelationShipToPatient End
		, Null
    	, PAT.Phone2
    From iPatient PAT
        Left Join #PG PG On PAT.ChartNumber = PG.PatientChartNumber
    Where Upper( LTrim( RTrim( PAT.PatientType ) ) ) <> 'GUARANTOR'
            And Not Exists 
                ( Select * From Patient A 
                    Where A.PracticeID = @PracticeID 
                            And PAT.FirstName = A.FirstName 
                            And PAT.LastName = A.LastName )
    Order By PAT.LastName , PAT.FirstName

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Patient Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Update P
        Set PrimaryProviderID = C.DoctorID
        From Patient P
                Inner Join iPatient B On P.VendorID = B.ChartNumber
                Inner Join Doctor C On C.VendorID = B.AssignedProvider
        Where P.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Rendering Provider ID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Update Patient's Marital Status.
    Update A
        Set MaritalStatus =
                Case
                    When B.MaritalStatus = 'Single' Then 'S'
                    When B.MaritalStatus = 'Married' Then 'M'
                    When B.MaritalStatus = 'Divorced' Then 'D'
                    When B.MaritalStatus = 'Unknown' Then 'U'
                    Else 'U'
                End
        From Patient A
                Inner Join ( Select Distinct ChartNumber , MaritalStatus 
                                From iPatientCase 
                                Where IsNull( MaritalStatus , '' ) <> '' ) B On B.ChartNumber = A.VendorID
        Where A.VendorImportID = @VendorImportID
                And A.PracticeID = @PracticeID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Marital Status '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    /*
    Declare @RefToPatient Table
    ( ChartNumber           Varchar(50)
      , ReferringProvider   Varchar(50)
    )

    Insert @RefToPatient
    ( ChartNumber
      , ReferringProvider
    )
    Select Distinct
        ChartNumber
        , ReferringProvider
    From iPatientCase
    Where IsNull( ReferringProvider , '' ) <> ''

    Update P
        Set ReferringPhysicianID = D.DoctorID
        From Patient P
            Inner Join @RefToPatient RTP On P.VendorImportID = @VendorImportID And P.VendorID = RTP.ChartNumber
            -- Inner Join Doctor D On D.VendorImportID = @VendorImportID AND RTP.ReferringProvider = D.VendorID
            Inner Join Doctor D On RTP.ReferringProvider = D.VendorID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Referring Physicians '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
    */

    -- InsuranceCompany
    -- MWINS - Assume that insurance company is the same as insuranceplan
    -- Create temporary table to hold insurance companies that already exist in InsuranceCompany table
    Create Table #EIC
    ( InsuranceCompanyID            Int
      , InsuranceCompanyName        varchar(255)
      , AddressLine1                varchar(255)
      , AddressLine2                varchar(255)
      , City                        varchar(255)
      , State                       varchar(255)
      , ZipCode                     varchar(255)
      , Phone                       varchar(255)
      , PhoneExt                    varchar(255)
      , ReviewCode                  varchar(255)
      , Code                        varchar(255)
    )

    Insert Into #EIC
    ( InsuranceCompanyID
      , InsuranceCompanyName
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , Phone
      , PhoneExt
      , ReviewCode
      , Code
    )
    Select
        Max( ICO.InsuranceCompanyID ) As InsuranceCompanyID
        , IC.Name
        , IC.Street1
        , IC.Street2
        , IC.City
        , IC.State
        , IC.ZipCode
        , IC.Phone
        , IC.Extension
        , ICO.ReviewCode
        , IC.Code
    From iInsCompany IC
        Inner Join InsuranceCompany ICO On LTrim( RTrim( ICO.InsuranceCompanyName ) ) = LTrim( RTrim( IC.Name ) )
    Where LTrim(RTrim( ICO.City ) ) = LTrim(RTrim( IC.City ) )
            AND Left( ICO.ZipCode , 5 ) = Left( IC.ZipCode , 5 )
        	AND LTrim( RTrim( ICO.State ) ) = LTrim(RTrim( IC.State ) )
        	AND LTrim( RTrim( ICO.InsuranceCompanyName ) ) = LTrim( RTrim( IC.Name ) )
        	AND Replace( Replace( ICO.AddressLine1, ' ' , '' ) , '.' , '' ) = Replace( Replace( IC.Street1 , ' ', '' ) , '.' , '' )
    Group By IC.Name , IC.Street1 , IC.Street2 , IC.City , IC.State , IC.ZipCode , IC.Phone , IC.Extension , ICO.ReviewCode , IC.Code

    -- Debug.
    -- Select * From #EIC

    -- Store insurance companies that do not exist in InsuranceCompany table in another temporary table #NIC
    Create Table #NIC
    ( Code                      VarChar(255)
      , InsuranceCompanyName    VarChar(255)
      , AddressLine1            VarChar(255)
      , AddressLine2            VarChar(255)
      , City                    VarChar(255)
      , State                   VarChar(255)
      , ZipCode                 VarChar(255)
      , Phone                   VarChar(255)
      , PhoneExt                VarChar(255)
      , ReviewCode              VarChar(255)
    )

    Insert Into #NIC
    ( Code
      , InsuranceCompanyName
      , AddressLine1
      , AddressLine2
      , City, State
      , ZipCode
      , Phone
      , PhoneExt
      , ReviewCode
      )
    Select
      IsNull( IC.Code , '' )
      , IC.Name
      , IC.Street1
      , IC.Street2
      , IC.City
      , IC.State
      , IC.ZipCode
      , IC.Phone
      , IC.Extension
      , 'R'
    From iInsCompany IC
    Where IC.Code Not In ( Select Code From #EIC )

    -- Insert Into InsuranceCompany those insurance companies that do not already exist.
    Insert Into InsuranceCompany
    ( VendorID
      , VendorImportID
      , InsuranceCompanyName
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , Phone
      , PhoneExt
      , ReviewCode
    )
    Select
      IsNull( Code , '' )
      , @VendorImportID
      , InsuranceCompanyName
    	, AddressLine1
    	, AddressLine2
    	, City
    	, State
    	, ZipCode
    	, Phone
    	, PhoneExt
    	, 'R'
    From #NIC

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsuranceCompany Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- InsuranceCompanyPlan
    -- Insert plans that do not already exist  in InsuranceCompanyPlan
    -- 1) find which ones exist;  Code - same as InsuranceCarrier #1, #2 and 3# in MWCAS)
    -- Existing InsuranceCompanyPlans
    Create Table #EIP
    ( InsuranceCompanyPlanID    int
      , Code                    varchar(255)
      , PlanName                varchar(255)
      , AddressLine1            varchar(255)
      , AddressLine2            varchar(255)
      , City                    varchar(255)
      , State                   varchar(255)
      , ZipCode                 varchar(255)
      , Phone                   varchar(255)
      , PhoneExt                varchar(255)
    )

    -- Insert plans that already exist in InsuranceCompanyPlan table
    Insert Into #EIP
    ( InsuranceCompanyPlanID
      , Code
      , PlanName
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , Phone
      , PhoneExt
      )
    Select Max( ICP.InsuranceCompanyPlanID ) As InsuranceCompanyPlanID
    	, IsNull( IP.Code , '' )
    	, IP.Name
    	, IP.Street1
    	, IP.Street2
    	, IP.City
    	, IP.State
    	, IP.ZipCode
    	, IP.Phone
    	, IP.Extension
    From iInsCompany IP
        Join InsuranceCompanyPlan ICP On LTrim( RTrim( ICP.PlanName ) ) = LTrim( RTrim( IP.Name ) )
    	Where LTrim( RTrim( ICP.City ) ) = LTrim( RTrim( IP.City ) )
    	        And LTrim( RTrim( ICP.State ) ) = LTrim( RTrim( IP.State ) )
              And Left( ICP.ZipCode , 5 ) = Left( IP.ZipCode , 5 )
              And LTrim( RTrim( ICP.PlanName ) ) = LTrim( RTrim( IP.Name ) )
              And Replace( Replace( ICP.AddressLine1 , ' ' , '' ) , '.' , '' ) = Replace( Replace( IP.Street1 , ' ' , '' ) , '.' , '' )
    Group By IP.Code
		       , IP.Name
		       , IP.Street1
	          , IP.Street2
	          , IP.City
	          , IP.State
	          , IP.ZipCode
	          , IP.Phone
	          , IP.Extension

    -- Create temporary table with plans that do not exist in InsuranceCompanyPlan table
    Create Table #NIP
    ( Code                  varchar(255)
      , PlanName            varchar(255)
      , InsuranceCompanyID  int
      , AddressLine1        varchar(255)
      , AddressLine2        varchar(255)
      , City                varchar(255)
      , State               varchar(255)
      , ZipCode             varchar(255)
      , Phone               varchar(255)
      , PhoneExt            varchar(255)
    )

    -- Insert plans that do not already exist in InsuranceCompanyPlan table
    Insert Into #NIP
    ( Code
      , PlanName
      , InsuranceCompanyID
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , Phone
      , PhoneExt
    )
    Select
      IsNull( IP.Code , '' )
    	, IP.Name
    	, IsNull( EIC.InsuranceCompanyID , IC.InsuranceCompanyID )
    	, IP.Street1
    	, IP.Street2
    	, IP.City
    	, IP.State
    	, IP.ZipCode
    	, IP.Phone
    	, IP.Extension
    From iInsCompany IP
        Left Join InsuranceCompany IC On IC.VendorImportID = @VendorImportID And IP.Code = IC.VendorID
        Left Join #EIC EIC On IP.code = EIC.Code
    Where IP.Code Not In ( Select Code From #EIP )
    Order By IP.Name

    -- Insert plans that do not already exist Into InsuranceCompanyPlan table
    Insert Into InsuranceCompanyPlan
    ( VendorImportID
      , VendorID
      , PlanName
      , InsuranceCompanyID
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , Phone
      , Copay
      , PhoneExt
      , ReviewCode
    )
    Select
    	@VendorImportID,
    	NIP.Code,
    	NIP.PlanName,
    	NIP.InsuranceCompanyID,
    	NIP.AddressLine1,
    	NIP.AddressLine2,
    	NIP.City,
    	Case When Len( NIP.State ) <= 2 Then NIP.State Else NULL End,
    	Case When Len( NIP.ZipCode ) <= 9 Then NIP.ZipCode Else NULL End,
    	NIP.Phone,
    	0 As Copay,
    	NIP.PhoneExt,
    	'R'
    From #NIP NIP

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsuranceCompanyPlan Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Insurance plans that did not exist will have VendorImportID for this import and and VendorID = MWINS.Code
    -- for those that did exist, match InsuranceCompanyPlanID From #EIP
    -- Select InsuranceCompanyPlanID From #EIP

    Select ChartNumber
    	      , Convert( Varchar(50) , Max( CaseNumber ) ) As CaseNumber Into #RecentCases
    	From iPatientCase
    	Group By ChartNumber
    	Order By ChartNumber

    Insert Into PatientCase
    ( PatientID
      , Name
      , PracticeID
      , PayerScenarioID
      , VendorID
      , VendorImportID
      -- , ReferringPhysicianID
      , EmploymentRelatedFlag
      , AutoAccidentRelatedFlag
      , AutoAccidentRelatedState
      , Notes
    )
    Select
        P.PatientID
        , Case 
            When IsNull( DC.Description , '' ) = '' Then 'Default Case'
            Else DC.Description
          End
        , P.PracticeID
        , 5
        , DC.CaseNumber As VendorID
        , @VendorImportID
        -- , P.ReferringPhysicianID
        , DC.RelatedToEmployment
        , Case When IsNull( DC.RelatedToAccident , '' ) = 'AUTO' Then 1 Else 0 End
        , DC.AccidentState
        , DC.Notes
    From Patient P
    	Inner Join iPatientCase DC ON P.VendorID = DC.ChartNumber
    	-- Inner Join #RecentCases RC On DC.ChartNumber = RC.ChartNumber And DC.CaseNumber = RC.CaseNumber
    Where P.VendorID Is Not Null
    	      And VendorImportID = @VendorImportID
    	      And P.PracticeID = @PracticeID
    Order By P.LastName , P.FirstName , DC.CaseNumber

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in PatientCase Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Create Default Patient Cases for patients with no chartnumber in mwcas table
    Insert Into PatientCase
    ( PatientID
      , [Name]
      , PayerScenarioID
      , ReferringPhysicianID
      , PracticeID
      , VendorID
      , VendorImportID
    )
    Select
    	P.PatientID
    	, 'Default Case'
    	, 5
    	, P.ReferringPhysicianID
    	, @PracticeID
    	, P.VendorID
    	, @VendorImportID
    From Patient P
    Where P.VendorImportID = @VendorImportID
    		And P.VendorID Not In ( Select Distinct ChartNumber From iPatientCase )

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in PatientCase Table for Default Case '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Update ReferringPhysicianID on PatientCase Table.
    Update A
        Set ReferringPhysicianID = D.DoctorID
        From PatientCase A
                Inner Join Patient B On B.PatientID = A.PatientID
                Inner Join iPatientCase C On C.ChartNumber = B.VendorID And Convert( Varchar(20) , C.CaseNumber ) = A.VendorID
                Inner Join Doctor D On D.VendorID = C.ReferringProvider
        Where A.VendorImportID = @VendorImportID
                And D.[External] = 1
                And IsNull( C.ReferringProvider , '' ) <> ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in PatientCase Table for Referring Physician ID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Update ReferringPhysicianID on Patient Table.
    Update A
        Set ReferringPhysicianID = B.ReferringPhysicianID
        From Patient A
                Inner Join PatientCase B On B.PatientID = A.PatientID
                Inner Join #RecentCases C On C.ChartNumber = A.VendorID And C.CaseNumber = B.VendorID
        Where A.VendorImportID = @VendorImportID
                And IsNull( B.ReferringPhysicianID , 0 ) <> 0

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Referring Physician ID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Date of Injury Records.
    Insert Into PatientCaseDate
    ( PracticeID
      , PatientCaseID
      , PatientCaseDateTypeID
      , StartDate
      , VendorImportID
    )
    Select 
        B.PracticeID
        , A.PatientCaseID
        , 2 As PatientCaseDateTypeID
        , Convert( DateTime , IsNull( C.DateOfInjury , '' ) ) As StartDate
        , @VendorImportID
    From PatientCase A
            Inner Join Patient B On B.PatientID = A.PatientID
            Inner Join iPatientCase C On C.CaseNumber = A.VendorID And C.ChartNumber = B.VendorID
    Where B.VendorImportID = @VendorImportID
            And A.PracticeID = @PracticeID
            And A.[Name] <> 'Default Case'
            And IsNull( C.DateOfInjury , '' ) <> ''
            And IsDate( C.DateOfInjury ) = 1
        
    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in PatientCaseDate Table for Date of Injury '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Primary Insurance Policy.
    Insert Into InsurancePolicy
      ( PatientCaseID
         , PracticeID
         , InsuranceCompanyPlanID
         , PolicyNumber
         , GroupNumber
         , Precedence
         , PolicyStartDate
         , PolicyEndDate
         , PatientRelationshipToInsured
         , HolderLastName
         , HolderFirstName
         , HolderMiddleName
         , HolderAddressLine1
         , HolderAddressLine2
         , HolderCity
         , HolderState
         , HolderZipCode
         , HolderGEnder
         , HolderPhone
         , HolderDOB
         , HolderSSN
         , VendorID
         , VendorImportID
       )
    Select
        PC.PatientCaseID
        , PC.PracticeID
        , IsNull( EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID ) As InsuranceCompanyPlanID
        , Left( LTrim( RTrim( DC.PolicyNumber1 ) ) , 32 ) As PolicyNumber
        , Left( LTrim( RTrim( DC.GroupNumber1 ) ) , 32 ) As GroupNumber
        , 1
        , DC.Policy1StartDate As PolicyStartDate
        , DC.Policy1EndDate As PolicyEndDate
        , Case
		    When IsNull( DC.Insured1 , '' ) <> '' And IsNull( DC.Insured1 , '' ) = DC.ChartNumber Then 'S'
		    When IsNull( DC.Insured1 , '' ) <> '' And IsNull( DC.Insured1 , '' ) <> DC.ChartNumber Then
				Case
					When Upper( DC.InsuredRelationship1 ) = 'OTHER' Then 'O'	-- Other
					When Upper( DC.InsuredRelationship1 ) = 'CHILD' Then 'C' 	-- Child
					When Upper( DC.InsuredRelationship1 ) = 'SPOUSE' Then 'U'	-- Spouse
					Else 'U'
				End
		    Else 'O'
		    End As PatientRelationshipToInsured
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.LastName Else NULL End HolderLastName
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.FirstName Else NULL End HolderFirstName
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.MiddleInitial Else NULL End HolderMiddleName
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.Street1 Else NULL End HolderAddressLine1
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.Street2 Else NULL End HolderAddressLine2
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.City Else NULL End HolderCity
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then Left( DP.State , 2 ) Else NULL End HolderState
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then Left( DP.ZipCode , 9 ) Else NULL End HolderZipCode
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then 
                Case When DP.Sex = 'Female' Then 'F' Else 'M' End Else NULL End HolderGEnder
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then Left( DP.Phone1 , 10 ) Else NULL End HolderPhone
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.DateOfBirth Else NULL End HolderDOB
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then Left( DP.SocialSecurityNumber , 9 ) Else NULL End HolderSSN
        , DC.InsuranceCarrier1
        , @VendorImportID
    From iPatientCase DC
        Inner Join PatientCase PC On PC.VendorImportID = @VendorImportID And Convert( Varchar(50) , DC.CaseNumber ) = PC.VendorID
        Left Join InsuranceCompanyPlan ICP On ICP.VendorImportID = @VendorImportID And DC.InsuranceCarrier1 = ICP.VendorID
        Left Join #EIP EIP On DC.InsuranceCarrier1 = EIP.Code
        Left Join iPatient DP On DC.Insured1 = DP.ChartNumber
    Where LTrim( RTrim( IsNull( DC.InsuranceCarrier1 , '' ) ) ) <> ''
            And IsNull( EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID ) Is Not Null

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Primary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Insurance Secondary Insurance Policy.
    Insert Into InsurancePolicy
    ( PatientCaseID
     , PracticeID
     , InsuranceCompanyPlanID
     , PolicyNumber
     , GroupNumber
     , Precedence
     , PolicyStartDate
     , PolicyEndDate
     , PatientRelationshipToInsured
     , HolderLastName
	  , HolderFirstName
     , HolderMiddleName
	  , HolderAddressLine1
	  , HolderAddressLine2
	  , HolderCity
	  , HolderState
	  , HolderZipCode
	  , HolderGEnder
	  , HolderPhone
	  , HolderDOB
	  , HolderSSN
	  , VendorID
	  , VendorImportID
	 )
    Select
        PC.PatientCaseID
        , PC.PracticeID
        , IsNull(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) InsuranceCompanPlanID
        , Left(LTrim(RTrim(PolicyNumber2)),32) PolicyNumber
        , Left(LTrim(RTrim(GroupNumber2)),32) GroupNumber
        , 2
        , Policy2StartDate PolicyStartDate
        , Policy2EndDate PolicyEndDate
        , Case
		    When IsNull( DC.Insured2 , '' ) <> '' And IsNull( DC.Insured2 , '' ) = DC.ChartNumber Then 'S'
		    When IsNull( DC.Insured2 , '' ) <> '' And IsNull( DC.Insured2 , '' ) <> DC.ChartNumber Then
				Case
					When Upper( DC.InsuredRelationship2 ) = 'OTHER' Then 'O'	-- Other
					When Upper( DC.InsuredRelationship2 ) = 'CHILD' Then 'C' 	-- Child
					When Upper( DC.InsuredRelationship2 ) = 'SPOUSE' Then 'U'	-- Spouse
					Else 'U'
				End
		   Else 'O'
		   End As PatientRelationshipToInsured
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.LastName Else Null End HolderLastName
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.FirstName Else Null End HolderFirstName
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.MiddleInitial Else Null End HolderMiddleName
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.Street1 Else Null End HolderAddressLine1
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.Street2 Else Null End HolderAddressLine2
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.City Else Null End HolderCity
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then Left( DP.State , 2 ) Else Null End HolderState
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then Left( DP.ZipCode , 9 ) Else Null End HolderZipCode
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then 
                Case When DP.Sex = 'Female' Then 'F' Else 'M' End Else Null End HolderGender
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then Left( DP.Phone1 , 10 ) Else Null End HolderPhone
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.DateOfBirth Else Null End HolderDOB
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then Left( DP.SocialSecurityNumber , 9 ) Else Null End HolderSSN
        , DC.InsuranceCarrier2
        , @VendorImportID
    From iPatientCase DC
        Inner Join PatientCase PC ON PC.VendorImportID = @VendorImportID And Convert( Varchar(50) , DC.CaseNumber ) = PC.VendorID
        Left Join InsuranceCompanyPlan ICP ON ICP.VendorImportID = @VendorImportID AND DC.InsuranceCarrier2 = ICP.VendorID
        Left Join #EIP EIP ON DC.InsuranceCarrier2 = EIP.Code
        Left Join iPatient DP ON DC.Insured2 = DP.ChartNumber
    Where IsNull( DC.InsuranceCarrier2 , '' ) <> '' 
            And IsNull( EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID ) Is Not Null

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Secondary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Tertiary Insurance Policy.
    Insert Into InsurancePolicy
       ( PatientCaseID
       , PracticeID
       , InsuranceCompanyPlanID
       , PolicyNumber
       , GroupNumber
       , Precedence
       , PolicyStartDate
       , PolicyEndDate
       , PatientRelationshipToInsured
       , HolderLastName
       , HolderFirstName
       , HolderMiddleName
       , HolderAddressLine1
       , HolderAddressLine2
       , HolderCity
       , HolderState
       , HolderZipCode
       , HolderGEnder
       , HolderPhone
       , HolderDOB
       , HolderSSN
       , VendorID
       , VendorImportID
       )
    Select
        PC.PatientCaseID
        , PC.PracticeID
        , IsNull( EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID ) InsuranceCompanPlanID
        , PolicyNumber3 PolicyNumber
        , GroupNumber3 GroupNumber
        , 3
        , Policy3StartDate PolicyStartDate
        , Policy3EndDate PolicyEndDate
        , Case
		  When IsNull( DC.Insured3 , '' ) <> '' And IsNull( DC.Insured3 , '' ) = DC.ChartNumber Then 'S'
		  When IsNull( DC.Insured3 , '' ) <> '' And IsNull( DC.Insured3 , '' ) <> DC.ChartNumber Then
				Case
					When Upper( DC.InsuredRelationship3 ) = 'OTHER' Then 'O'	-- Other
					When Upper( DC.InsuredRelationship3 ) = 'CHILD' Then 'C' 	-- Child
					When Upper( DC.InsuredRelationship3 ) = 'SPOUSE' Then 'U'	-- Spouse
					Else 'U'
				End
		  Else 'O'
		  End As PatientRelationshipToInsured
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.LastName Else Null End HolderLastName
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.FirstName Else Null End HolderFirstName
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.MiddleInitial Else Null End HolderMiddleName
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.Street1 Else Null End HolderAddressLine1
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.Street2 Else Null End HolderAddressLine2
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.City Else Null End HolderCity
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then Left( DP.State , 2 ) Else Null End HolderState
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then Left( DP.ZipCode , 9 ) Else Null End HolderZipCode
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then 
            Case When DP.Sex = 'Female' Then 'F' Else 'M' End Else Null End HolderGender
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then Left( DP.Phone1 , 10 ) Else Null End HolderPhone
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.DateOfBirth Else Null End HolderDOB
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then Left( DP.SocialSecurityNumber , 9 ) Else Null End HolderSSN
        , DC.InsuranceCarrier3
        , @VendorImportID
    From iPatientCase DC
        Inner Join PatientCase PC On PC.VendorImportID = @VendorImportID And Convert( Varchar(50) , DC.CaseNumber ) = PC.VendorID
        Left Join InsuranceCompanyPlan ICP On ICP.VendorImportID = @VendorImportID And DC.InsuranceCarrier3 = ICP.VendorID
        Left Join #EIP EIP On DC.InsuranceCarrier3 = EIP.Code
        Left Join iPatient DP On DC.Insured3 = DP.ChartNumber
    Where IsNull( DC.InsuranceCarrier3 , '' ) <> ''
            And IsNull( EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID ) Is Not Null

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Tertiary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Insurance Policy Authorization.
    Insert Into InsurancePolicyAuthorization
    ( InsurancePolicyID
      , AuthorizationNumber
      , AuthorizedNumberOfVisits
      , StartDate
      , EndDate
      , VendorImportID
    )
    Select
        A.InsurancePolicyID
        , IsNull( D.VisitAuthorizationNo , '' ) As AuthorizationNumber
        , IsNull( D.AuthorizedNoOfVisits , 0 ) As AuthorizedNumberOfVisits
        , '01/01/2000' As StartDate
        , D.TreatmentAuthThrough As EndDate
        , @VendorImportID
    From InsurancePolicy A
            Inner Join PatientCase B On B.PatientCaseID = A.PatientCaseID
            Inner Join Patient C On C.PatientID = B.PatientID
            Inner Join iPatientCase D On Convert( Varchar(20) , D.CaseNumber ) = B.VendorID And D.ChartNumber = C.VendorID
    Where A.VendorImportID = @VendorImportID
            And A.Precedence = 1
            And ( ( IsNull( D.AuthorizedNoOfVisits , 0 ) <> 100 And IsNull( D.AuthorizedNoOfVisits , 0 ) <> 0 )
                    Or IsNull( D.VisitAuthorizationNo , '' ) <> ''
                    Or IsNull( D.TreatmentAuthThrough , '' ) <> '' )


    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicyAuthorization Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Create Table #PCToUpdate
    ( PatientCaseID Int )

    Insert Into #PCToUpdate
    ( PatientCaseID )
    Select
        PC.PatientCaseID
    From PatientCase PC
        Left Join InsurancePolicy IP On PC.PatientCaseID = IP.PatientCaseID
    Where PC.PracticeID = @PracticeID
    Group By PC.PatientCaseID Having Count(*) = 0

    Update PC
        Set PayerScenarioID = 11
        From PatientCase PC
            Inner Join #PCToUpdate PCU On PC.PatientCaseID = PCU.PatientCaseID

    -- Edit GroupNumber, PolicyStartDate and PolicyEndDate
    Update InsurancePolicy
        Set GroupNumber = ''
        Where VendorImportID = @VendorImportID
                And Upper( IsNull( GroupNumber , '' ) ) = 'NONE'

    Update InsurancePolicy
        Set PolicyStartDate = Null
        Where Convert( Char(10) , IsNull( PolicyStartDate , '' ) , 101 ) = '01/01/1900'
                And VendorImportID = @VendorImportID

    Update InsurancePolicy
        Set PolicyEndDate = Null
        Where Convert( Char(10) , IsNull( PolicyEndDate , '' ) , 101 ) = '01/01/1900'
                And VendorImportID = @VendorImportID

    Update InsurancePolicy
        Set HolderDOB = Null
        Where Convert( Char(10) , IsNull( HolderDOB , '' ) , 101 ) = '01/01/1900'
                And VendorImportID = @VendorImportID

    -- Update EmployerID.
    Update A
        Set EmployerID = C.EmployerID
        From Patient A
            Inner Join iPatient B On B.ChartNumber = A.VendorID
            Inner Join Employers C On C.VendorID = B.Employer
        Where A.PracticeID = @PracticeID
                And B.PatientType <> 'Guarantor'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Distinct Employer ID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- If duplicate employer, update employer id based on employername and address.
    Update A
        Set EmployerID = D.EmployerID
        From Patient A
            Inner Join iPatient B On B.ChartNumber = A.VendorID
            Inner Join iAddress C On C.Code = B.Employer
            Inner Join Employers D On 
                D.EmployerName = C.Name 
                And IsNull( D.AddressLine1 , '' ) = IsNull( C.Street1 , '' )
                And IsNull( D.AddressLine2 , '' ) = IsNull( C.Street2 , '' )
                And IsNull( D.City , '' ) = IsNull( C.City , '' )
                And IsNull( D.State , '' ) = IsNull( C.State , '' )
                And IsNull( D.ZipCode , '' ) = IsNull( C.ZipCode , '' )
        Where A.PracticeID = @PracticeID
            And B.PatientType <> 'Guarantor'
            And IsNull( D.VendorID , '' ) = ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Duplicate Employer ID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Drop Table #PCToUpdate
    Drop Table #PG
    Drop Table #EIC
    Drop Table #NIC
    Drop Table #EIP
    Drop Table #NIP
    Drop Table #RecentCases
    Drop Table #RefPhy

End
-- ROLLBACK
-- COMMIT TRANSACTION

SET NOCOUNT OFF


/*
-- INSURANCE COMPANY
  Select
      MAX(LEN(IC.Code)) AS Code
      , MAX(LEN(IC.Name)) AS Name
      , MAX(LEN(IC.Street1)) AS Street1
      , MAX(LEN(IC.Street2)) AS Street2
      , MAX(LEN(IC.City)) AS City
      , MAX(LEN(IC.State)) AS State
      , MAX(LEN(IC.ZipCode)) AS ZipCode
      , MAX(LEN(IC.Phone)) AS Phone
      , MAX(LEN(IC.Extension)) AS Extension
      , 'R'
    From iInsCompany IC
SELECT ZipCode FROM iInsCompany WHERE LEN(ZipCode) > 9
UPDATE iInsCompany SET ZipCode = NULL WHERE LEN(ZipCode) > 9

-- DOCTOR
    Select
		MAX(LEN(FirstName)) As FirstName
    	, MAX(LEN(MiddleInitial)) As MiddleName
    	, MAX(LEN(LastName)) As LastName
    	, MAX(LEN(Credentials)) As Credentials
    	, MAX(LEN(SSNOrFedTaxID)) As SSN
    	, MAX(LEN(Office)) As WorkPhone
		, MAX(LEN(Cell)) As MobilePhone
    	, MAX(LEN(Fax)) As Fax
    	, MAX(LEN(Street1)) As Street1
    	, MAX(LEN(Street2)) As Street2
    	, MAX(LEN(City)) As City
    	, MAX(LEN(State)) As State
    	, MAX(LEN(ZipCode)) As ZipCode
    	, MAX(LEN(Code)) As Code
    From iDoctor

SELECT Fax FROM iDoctor WHERE LEN(Fax) > 10
SELECT Credentials FROM iDoctor WHERE LEN(Credentials) > 8
-- UPDATE iDoctor SET Credentials = LEFT(Credentials, 8) WHERE LEN(Credentials) > 8

-- PATIENT
	SELECT
      MAX(LEN(PAT.ChartNumber)) AS ChartNumber
    	, MAX(LEN(PAT.FirstName)) As FirstName
    	, MAX(LEN(PAT.MiddleInitial)) As MiddleName
    	, MAX(LEN(PAT.LastName)) AS LastName
    	, MAX(LEN(PAT.Street1)) AS Street1
    	, MAX(LEN(PAT.Street2)) AS Street2
    	, MAX(LEN(PAT.City)) AS City
    	, MAX(LEN(PAT.State)) AS State
    	, MAX(LEN(PAT.ZipCode)) AS ZipCode
--    	, Case
--			When LTrim( RTrim( PAT.Sex ) ) = 'Male' Then 'M'
--         	When LTrim( RTrim( PAT.Sex ) ) = 'Female' Then 'F'
--         	Else 'U'
--		  End As Gender
--      , Case
--            When PAT.EmploymentStatus = 'Full time' Then 'E'
--            When PAT.EmploymentStatus = 'Part time' Then 'E'
--            When PAT.EmploymentStatus = 'Retired' Then 'R'
--            Else 'U'
--        End As EmploymentStatus
    	, MAX(LEN(PAT.Phone1)) AS Phone1
    	, MAX(LEN(PAT.WorkPhone)) AS WorkPhone
    	, MAX(LEN(PAT.WorkExtension)) AS WorkExtension
        , MAX(LEN(PAT.Email)) AS Email
--    	, PAT.DateOfBirth 
--    	, Case
--            When Len( PAT.SocialSecurityNumber ) = 9 Then PAT.SocialSecurityNumber
--            Else Null
--        End
        , MAX(LEN(PAT.ChartNumber)) AS ChartNumber
    	, MAX(LEN(PAT.Phone2)) AS Phone2
    FROM iPatient PAT
SELECT ZipCode FROM iPatient WHERE LEN(ZipCode) > 9

*/